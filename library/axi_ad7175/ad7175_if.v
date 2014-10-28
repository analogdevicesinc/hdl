// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

//------------------------------------------------------------------------------   
//----------- Module Declaration -----------------------------------------------
//------------------------------------------------------------------------------ 
module ad7175_if
    (
        // Clock and Reset signals
        input fpga_clk_i,
        input adc_clk_i,
        input reset_n_i,
        
        // Conversion control signals
        input start_conversion_i,
        output [31:0] dma_data_o,
        output dma_data_rdy_o,
        
        // Transmit data on request signals
        input start_transmission_i,
        input [31:0] tx_data_i,
        output tx_data_rdy_o,
        
        // Read data on request signals
        input start_read_i,       
        output [31:0] rx_data_o,
        output rx_data_rdy_o,
        
        // AD7175 IC control signals
        input adc_sdo_i,
        output adc_sdi_o,
        output adc_cs_o,
        output adc_sclk_o,
		
		// ADC status
		output reg adc_status_o
    );

//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------
// State Machine Registers
reg [10:0] present_state;                                           // Present FSM State
reg [10:0] next_state;                                              // Next FSM State
reg [10:0] present_state_m1;                                        // Used to synchronise FSM States between different clock domains

// SCLK Registers
reg [7:0] sclk_cnt;                                                 // Used to count SCLK Ticks
reg [7:0] sclk_demand;                                              // Used to set number of SCLK Ticks

// Transmit Data Registers
reg [47:0] tx_data_reg;                                             // Used to shift data out
reg [47:0] tx_data_reg_switch;                                      // Used to select data that is being sent
reg tx_data_rdy_int;                                                // Used to signal the end of a transmit cycle

// Receive Data Registers
reg [47:0] rx_data_reg;                                             // Used to shift data in
reg [31:0] rx_read_data_reg;                                        // Used to store read data
reg rx_data_rdy_int;                                                // Used to signal the end of a read cycle

// Conversion Data Registers
reg [31:0] dma_rx_data_reg;                                         // Used to store conversion result (STATUS_REG[31:24] + DATA_REG[23:0])
reg dma_rdy_int;                                                    // Used to signal the end of a conversion read

// Internal registers used for external ports
reg adc_sdi_o_int;                                                  // Used for adc_sdi_o                                   
reg cs_int;                                                         // Used for adc_cs_o    

//------------------------------------------------------------------------------ 
//----------- Wires Declarations -----------------------------------------------
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//----------- Local Parameters -------------------------------------------------
//------------------------------------------------------------------------------
// ADC Controller State Machine States  
parameter ADC_IDLE_STATE                    = 11'b00000000001;      // Waits for Start Conversion / Start Transmission / Start Read
parameter ADC_WAIT_FOR_DATA_STATE           = 11'b00000000010;      // Waits for adc_sdo_i to go low (signals new data is available)
parameter ADC_PREP_READ_RESULT_STATE        = 11'b00000000100;      // Prepares data to perform Status + Data Register Read
parameter ADC_READ_RESULT_STATE             = 11'b00000001000;      // Reads Status + Data Register
parameter ADC_READ_RESULT_DONE_STATE        = 11'b00000010000;      // Signals completion of Status + Data Register Read
parameter ADC_PREP_SEND_DATA_STATE          = 11'b00000100000;      // Prepares data to perform Data Transmit
parameter ADC_SEND_DATA_STATE               = 11'b00001000000;      // Transmit Data
parameter ADC_SEND_DATA_DONE_STATE          = 11'b00010000000;      // Signals completion of Data Transmission
parameter ADC_PREP_READ_DATA_STATE          = 11'b00100000000;      // Prepares data to perform Data Read 
parameter ADC_READ_DATA_STATE               = 11'b01000000000;      // Reads Data
parameter ADC_READ_DATA_DONE_STATE          = 11'b10000000000;      // Signals completion of Data Read

// Number of SCLK Periods required for Status + Data Read
parameter ADC_SCLK_PERIODS = 8'd48;

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------
assign adc_sdi_o = adc_sdi_o_int;
assign adc_sclk_o = (((present_state_m1 == ADC_READ_RESULT_STATE)||(present_state_m1 == ADC_SEND_DATA_STATE)||(present_state_m1 == ADC_READ_DATA_STATE))&&(sclk_cnt != 8'd0)) ? adc_clk_i : 1'b1;
assign dma_data_o = dma_rx_data_reg;
assign dma_data_rdy_o = dma_rdy_int;
assign adc_cs_o = cs_int;
assign tx_data_rdy_o = tx_data_rdy_int;
assign rx_data_o = rx_read_data_reg;
assign rx_data_rdy_o = rx_data_rdy_int;

// Register States
always @(posedge fpga_clk_i)
begin
    if(reset_n_i == 1'b0)
    begin
        present_state <= ADC_IDLE_STATE; 
		adc_status_o <= 1'b0;
    end
    else
    begin
        present_state <= next_state;
		adc_status_o <= 1'b1;
    end
end

// State switch logic
always @(posedge fpga_clk_i)
begin
    next_state <= present_state;
    case(present_state)
        ADC_IDLE_STATE:
            begin
                // If transmit data is required
                if(start_transmission_i == 1'b1)
                begin
                    next_state <= ADC_PREP_SEND_DATA_STATE;
                end
                // If read data is required
                else if(start_read_i == 1'b1) 
                begin
                    next_state <= ADC_PREP_READ_DATA_STATE; 
                end
				// If start conversion has been requested
                else if(start_conversion_i == 1'b1)
                begin
                    next_state <= ADC_WAIT_FOR_DATA_STATE;
                end
            end
        ADC_WAIT_FOR_DATA_STATE:
            begin
                // If new data is available
                if(adc_sdo_i == 1'b0)
                begin
                    next_state <= ADC_PREP_READ_RESULT_STATE;
                end
				// If transmit data is required
                else if(start_transmission_i == 1'b1)
                begin
                    next_state <= ADC_PREP_SEND_DATA_STATE;
                end
                // If read data is required
                else if(start_read_i == 1'b1) 
                begin
                    next_state <= ADC_PREP_READ_DATA_STATE; 
                end
				// If transmit data is not required anymore
                else if(start_conversion_i == 1'b0)
                begin
                    next_state <= ADC_IDLE_STATE;
                end
            end
        ADC_PREP_READ_RESULT_STATE:
            begin
                if(present_state_m1 == ADC_PREP_READ_RESULT_STATE)
                begin
                    next_state <= ADC_READ_RESULT_STATE;
                end
            end
        ADC_READ_RESULT_STATE:
            begin
                // If data has been sent
                if(sclk_cnt == 8'd0)
                begin
                    next_state <= ADC_READ_RESULT_DONE_STATE;
                end
            end
        ADC_READ_RESULT_DONE_STATE:
            begin 
                next_state <= ADC_IDLE_STATE;
            end
        ADC_PREP_SEND_DATA_STATE:
            begin
                if(present_state_m1 == ADC_PREP_SEND_DATA_STATE)
                begin
                    next_state <= ADC_SEND_DATA_STATE;
                end
            end
        ADC_SEND_DATA_STATE:
            begin
                // If data has been sent
                if(sclk_cnt == 8'd0)
                begin
                    next_state <= ADC_SEND_DATA_DONE_STATE;
                end
            end
        ADC_SEND_DATA_DONE_STATE:
            begin
                next_state <= ADC_IDLE_STATE;
            end
        ADC_PREP_READ_DATA_STATE:
            begin
                if(present_state_m1 == ADC_PREP_READ_DATA_STATE)
                begin
                    next_state <= ADC_READ_DATA_STATE;
                end            
            end
        ADC_READ_DATA_STATE:
            begin
                // If data has been sent
                if(sclk_cnt == 8'd0)
                begin
                    next_state <= ADC_READ_DATA_DONE_STATE;
                end                
            end
        ADC_READ_DATA_DONE_STATE:
            begin
                next_state <= ADC_IDLE_STATE;
            end
        default:
            begin
                next_state <= ADC_IDLE_STATE;
            end
    endcase
end

// State output logic
always @(posedge fpga_clk_i)
begin
    if(reset_n_i == 1'b0)
    begin
        dma_rdy_int <= 1'b0;
        cs_int <= 1'b1;
        tx_data_rdy_int <= 1'b0;
        rx_data_rdy_int <= 1'b0;
    end
    else
    begin
        case(present_state)
            ADC_IDLE_STATE:
                begin
                    dma_rdy_int <= 1'b0;
                    tx_data_rdy_int <= 1'b0;
                    rx_data_rdy_int <= 1'b0;
                    cs_int <= 1'b1;
                end
            ADC_WAIT_FOR_DATA_STATE:
                begin
                    cs_int <= 1'b0;
                end                
            ADC_PREP_READ_RESULT_STATE:
                begin
                    dma_rdy_int <= 1'b0;
                    tx_data_reg_switch <= 48'h400044000000;
                    cs_int <= 1'b0;
                end
            ADC_READ_RESULT_STATE:
                begin
                    dma_rdy_int <= 1'b0;
                    cs_int <= 1'b0;
                end
            ADC_READ_RESULT_DONE_STATE:
                begin
                    // Final data = Status Reg + Data Reg
                    dma_rx_data_reg <= {rx_data_reg[39:32], rx_data_reg[23:0]};
                    dma_rdy_int <= 1'b1;
                    cs_int <= 1'b1;
                end
            ADC_PREP_SEND_DATA_STATE:
                begin
                    // Maximum 32 bits transmission (that is why I add 16'd0 to the LSB)
                    tx_data_rdy_int <= 1'b1;
                    cs_int <= 1'b1;
                    tx_data_reg_switch <= {tx_data_i, 16'd0};
                end
            ADC_SEND_DATA_STATE:
                begin
                    tx_data_rdy_int <= 1'b0;
                    cs_int <= 1'b0;
                end
            ADC_SEND_DATA_DONE_STATE:
                begin
                    tx_data_rdy_int <= 1'b1;
                    cs_int <= 1'b1;
                end   
            ADC_PREP_READ_DATA_STATE:
                begin
                    // Maximum 32 bits transmission (that is why I add 16'd0 to the LSB)
                    cs_int <= 1'b1;
                    rx_data_rdy_int <= 1'b1;
                    tx_data_reg_switch <= {2'b01, tx_data_i[29:0], 16'd0};
                end
            ADC_READ_DATA_STATE:
                begin
                    cs_int <= 1'b0;
                    rx_data_rdy_int <= 1'b0;
                end
            ADC_READ_DATA_DONE_STATE:
                begin
                    rx_read_data_reg <= rx_data_reg[31:0];
                    cs_int <= 1'b1;
                    rx_data_rdy_int <= 1'b1;
                end                
            default:
                begin
                    tx_data_rdy_int <= 1'b0;
                    rx_data_rdy_int <= 1'b0;
                    dma_rdy_int <= 1'b0;
                    cs_int <= 1'b1;
                end
        endcase
    end
end

// Synchronise States between different clock domains
always @(posedge adc_clk_i)
begin
    present_state_m1 <= present_state;
end

// Select size of transfered data according to desired registers (see AD7176_2 Datasheet for details)
always @(posedge fpga_clk_i)
begin
    case(tx_data_i[29:24])
        6'h00:
            begin
                sclk_demand <= 8'd16;
            end
        6'h01, 6'h02, 6'h06, 6'h07, 6'h10, 6'h11, 6'h12, 6'h13, 6'h20, 6'h21, 6'h22, 6'h23, 6'h28, 6'h29, 6'h2a, 6'h2b:
            begin
                sclk_demand <= 8'd24;
            end
        6'h03, 6'h04, 6'h30, 6'h31, 6'h32, 6'h33, 6'h38, 6'h39, 6'h3a, 6'h3b:
            begin
                sclk_demand <= 8'd32;
            end
        default:
            begin
                sclk_demand <= 8'd16;
            end
    endcase
end

// Serial Data In
always @(posedge adc_clk_i)
begin
    if((present_state_m1 == ADC_READ_RESULT_STATE)||(present_state_m1 == ADC_SEND_DATA_STATE)||(present_state_m1 == ADC_READ_DATA_STATE))
    begin
        sclk_cnt <= sclk_cnt - 8'd1;
        rx_data_reg <= {rx_data_reg[46:0], adc_sdo_i};  
    end
    else
    begin
        if((present_state_m1 == ADC_PREP_SEND_DATA_STATE)||(present_state_m1 == ADC_PREP_READ_DATA_STATE))
        begin 
            sclk_cnt <= sclk_demand;
        end
        else
        begin
            sclk_cnt <= ADC_SCLK_PERIODS;
        end
        if(present_state_m1 == ADC_IDLE_STATE)
        begin
            rx_data_reg <= 48'd0;
        end
    end
end

// Serial Data Out
always @(negedge adc_clk_i)
begin
    if((present_state_m1 == ADC_READ_RESULT_STATE)||(present_state_m1 == ADC_SEND_DATA_STATE)||(present_state_m1 == ADC_READ_DATA_STATE))
    begin
        adc_sdi_o_int <= tx_data_reg[47];
        tx_data_reg <= {tx_data_reg[46:0], 1'b0};
    end 
    else
    begin
        tx_data_reg <= tx_data_reg_switch;
    end
end

endmodule
