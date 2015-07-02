// -----------------------------------------------------------------------------
//
// Copyright 2013(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//  - Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//  - Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in
//    the documentation and/or other materials provided with the
//    distribution.
//  - Neither the name of Analog Devices, Inc. nor the names of its
//    contributors may be used to endorse or promote products derived
//    from this software without specific prior written permission.
//  - The use of this software may or may not infringe the patent rights
//    of one or more patent holders.  This license does not release you
//    from the requirement that you obtain separate licenses from these
//    patent holders to use this software.
//  - Use of the software either in source or binary form, must be run
//    on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED
// WARRANTIES, INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY
// AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// INTELLECTUAL PROPERTY RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// -----------------------------------------------------------------------------
// FILE NAME : AD7401.v
// MODULE NAME : AD7401
// AUTHOR :  Adrian Costina
// AUTHOR'S EMAIL : adrian.costina@analog.com
// -----------------------------------------------------------------------------
// KEYWORDS : Analog Devices, Motor Control, AD7401
// -----------------------------------------------------------------------------
// PURPOSE : Driver for 
// -----------------------------------------------------------------------------
// REUSE ISSUES
// Reset Strategy      : Active high reset signal
// Clock Domains       : fpga_clk_i, 100 MHz
//                       adc_clk_i, up to 20 MHz
// Critical Timing     : N/A
// Test Features       : N/A
// Asynchronous I/F    : N/A
// Instantiations      : N/A
// Synthesizable (y/n) : Y
// Target Device       :
// Other               :
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

`timescale 1 ns / 100 ps //Use a timescale that is best for simulation.

//------------------------------------------------------------------------------
//----------- Module Declaration -----------------------------------------------
//------------------------------------------------------------------------------

module ad7401
//----------- Ports Declarations -----------------------------------------------
(
    //clock and reset signals
    input               fpga_clk_i,     // system clock
    input               adc_clk_i,      // up to 20 MHZ clock
    input               reset_i,        // active high reset signal

    //IP control and data interface
    output reg  [15:0]  data_o,          // data read from the ADC
    output reg          data_rd_ready_o, // when set to high the data read from the ADC is available on the data_o bus
    output reg          adc_status_o,

    //AD7401 control and data interface
    input               adc_mdata_i    // AD7401 MDAT pin
);

//------------------------------------------------------------------------------
//----------- Wire Declarations ------------------------------------------------
//------------------------------------------------------------------------------

wire        data_rdy_s;
wire [15:0] data_s ;

//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------
//State machine
reg [3:0]   present_state;
reg [3:0]   next_state;

reg         data_rdy_s_d1;
reg         data_rdy_s_d2;

//------------------------------------------------------------------------------
//----------- Local Parameters -------------------------------------------------
//------------------------------------------------------------------------------

//States
localparam WAIT_DATA_RDY_HIGH_STATE = 4'b0001;
localparam ACQUIRE_DATA_STATE       = 4'b0010;
localparam TRANSFER_DATA_STATE      = 4'b0100;
localparam WAIT_DATA_RDY_LOW_STATE  = 4'b1000;

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------

// synchronize data on fpga_clki
always @(posedge fpga_clk_i)
begin
    data_rdy_s_d1 <= data_rdy_s;
    data_rdy_s_d2 <= data_rdy_s_d1;
end

always @(posedge fpga_clk_i)
begin
    if(reset_i == 1'b1)
    begin
        present_state      <= WAIT_DATA_RDY_HIGH_STATE;
        adc_status_o       <= 1'b0;
    end
    else
    begin
        present_state <= next_state;
        case (present_state)
            WAIT_DATA_RDY_HIGH_STATE:
            begin
                data_rd_ready_o  <= 1'b0;
            end
            ACQUIRE_DATA_STATE:             // Acquire data from the filter
            begin
                data_o          <= data_s;
                data_rd_ready_o <= 1'b0;
                adc_status_o    <= 1'b1;
            end
            TRANSFER_DATA_STATE:            // Transfer data to the upper module to write in memory
            begin
                data_rd_ready_o <= 1'b1;
            end
            WAIT_DATA_RDY_LOW_STATE:
            begin
                data_rd_ready_o <= 1'b0;
            end
        endcase
    end
end

always @(present_state, data_rdy_s_d2)
begin
    next_state <= present_state;
    case (present_state)
        WAIT_DATA_RDY_HIGH_STATE:
        begin
            if(data_rdy_s_d2 == 1'b1)
            begin
                next_state  <= ACQUIRE_DATA_STATE;
            end
        end
        ACQUIRE_DATA_STATE:
        begin
            next_state      <= TRANSFER_DATA_STATE;
        end
        TRANSFER_DATA_STATE:
        begin
            next_state      <= WAIT_DATA_RDY_LOW_STATE;
        end
        WAIT_DATA_RDY_LOW_STATE:
        begin
            if(data_rdy_s_d2 == 1'b0)
            begin
                next_state  <= WAIT_DATA_RDY_HIGH_STATE;
            end
        end
        default:
        begin
            next_state      <= WAIT_DATA_RDY_HIGH_STATE;
        end
    endcase
end

dec256sinc24b filter(
    .mclkout_i(adc_clk_i),
    .reset_i(reset_i),
    .mdata_i(adc_mdata_i),
    .data_rdy_o(data_rdy_s),
    .data_o(data_s));

endmodule
