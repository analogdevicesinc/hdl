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
// FILE NAME :  speed_detector.v
// MODULE NAME : speed_detector
// AUTHOR : ACostina
// AUTHOR'S EMAIL : adrian.costina@analog.com
// -----------------------------------------------------------------------------
// KEYWORDS : Analog Devices, Motor Control, Speed detector
// -----------------------------------------------------------------------------
// PURPOSE : Detects the speed of rotation of a motor
// -----------------------------------------------------------------------------
// REUSE ISSUES
// Reset Strategy      :
// Clock Domains       :
// Critical Timing     :
// Test Features       :
// Asynchronous I/F    :
// Instantiations      :
// Synthesizable (y/n) :
// Target Device       :
// Other               :
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

module speed_detector
//----------- Paramters Declarations -------------------------------------------
#(
    parameter   AVERAGE_WINDOW   = 32,      // Averages data on the latest samples
    parameter   LOG_2_AW         = 5,       // Average window is 2 ^ LOG_2_AW
    parameter   SAMPLE_CLK_DECIM = 10000
)
//----------- Ports Declarations -----------------------------------------------
(
    input               clk_i,
    input               rst_i,
    input       [ 2:0]  position_i,         // position as determined by the sensors
    output reg          new_speed_o,        // signals a new speed has been computed
    output reg  [31:0]  current_speed_o,    // data bus with the current speed
    output reg  [31:0]  speed_o             // data bus with the mediated speed
);

//------------------------------------------------------------------------------
//----------- Local Parameters -------------------------------------------------
//------------------------------------------------------------------------------
localparam AW             = LOG_2_AW - 1;
localparam MAX_SPEED_CNT  = 32'h10000;

//State machine
localparam RESET            = 8'b00000001;
localparam INIT             = 8'b00000010;
localparam CHANGE_POSITION  = 8'b00000100;
localparam ADD_COUNTER      = 8'b00001000;
localparam SUBSTRACT_MEM    = 8'b00010000;
localparam UPDATE_MEM       = 8'b00100000;
localparam IDLE             = 8'b10000000;

//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------
reg [ 2:0]  position_old;
reg [63:0]  avg_register;
reg [63:0]  avg_register_stable;
reg [31:0]  cnt_period;
reg [31:0]  decimation;                   // register used to divide by ten the speed
reg [31:0]  cnt_period_old;
reg [31:0]  fifo [0:((2**LOG_2_AW)-1)];   // 32 bit wide RAM
reg [AW:0]  write_addr;
reg [AW:0]  read_addr;

reg [31:0]  sample_clk_div;

reg [ 7:0]  state;
reg [ 7:0]  next_state;

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------
// Count ticks per position
always @(posedge clk_i)
begin
    if(rst_i == 1'b1)
    begin
        cnt_period <= 32'b0;
        decimation <= 32'b0;
    end
    else
    begin
        if(state != CHANGE_POSITION)
        begin
            if(decimation == 9)
            begin
                cnt_period <= cnt_period + 1;
                decimation <= 32'b0;
            end
            else
            begin
                decimation  <= decimation + 1;
            end
        end
        else
        begin
            decimation      <= 32'b0;
            cnt_period      <= 32'b0;
            cnt_period_old  <= cnt_period;
        end
    end
end

always @(posedge clk_i)
begin
    if(rst_i == 1'b1)
    begin
        state <= RESET;
    end
    else
    begin
        state <= next_state;
    end
end

always @*
begin
    next_state = state;
    case(state)
        RESET:
        begin
            next_state = INIT;
        end
        INIT:
        begin
            if(position_i != position_old)
            begin
                next_state = CHANGE_POSITION;
            end
        end
        CHANGE_POSITION:
        begin
            next_state = ADD_COUNTER;
        end
        ADD_COUNTER:
        begin
            next_state = SUBSTRACT_MEM;
        end
        SUBSTRACT_MEM:
        begin
            next_state = UPDATE_MEM;
        end
        UPDATE_MEM:
        begin
            next_state          = IDLE;
        end
        IDLE:
        begin
            if(position_i != position_old)
            begin
                next_state = CHANGE_POSITION;
            end
        end
    endcase
end

always @(posedge clk_i)
begin
    case(state)
        RESET:
        begin
            avg_register        <= MAX_SPEED_CNT;
            fifo[write_addr]    <= MAX_SPEED_CNT;
        end
        INIT:
        begin
        end
        CHANGE_POSITION:
        begin
            position_old <= position_i;
        end
        ADD_COUNTER:
        begin
            avg_register <= avg_register + cnt_period_old ;
        end
        SUBSTRACT_MEM:
        begin
            avg_register <= avg_register - fifo[write_addr];
        end
        UPDATE_MEM:
        begin
            fifo[write_addr]    <= cnt_period_old;
            write_addr          <= write_addr + 1;
            avg_register_stable <= avg_register;
        end
        IDLE:
        begin
        end
    endcase
end

// Stable sampling frequency of the motor speed
always @(posedge clk_i)
begin
    if(rst_i == 1'b1)
    begin
        sample_clk_div  <= 0;
        speed_o         <= 0;
        new_speed_o     <= 0;
    end
    else
    begin
        if(sample_clk_div == SAMPLE_CLK_DECIM)
        begin
            sample_clk_div  <= 0;
            speed_o         <=(avg_register_stable >> LOG_2_AW);
            new_speed_o     <= 1;
            current_speed_o <= cnt_period_old;
        end
        else
        begin
            new_speed_o     <= 0;
            sample_clk_div  <= sample_clk_div + 1;
        end
    end
end

endmodule
