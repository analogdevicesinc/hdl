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
// FILE NAME : delay_30_degrees.v
// MODULE NAME : delay_30_degrees
// AUTHOR : ACostina
// AUTHOR'S EMAIL : adrian.costina@analog.com
// -----------------------------------------------------------------------------
// KEYWORDS : BEMF, Analog Devices, Motor Control
// -----------------------------------------------------------------------------
// PURPOSE : Module used for delaying the BEMF based position signal with 30
// degrees. 
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

module delay_30_degrees
//----------- Paramters Declarations -------------------------------------------
//----------- Ports Declarations -----------------------------------------------
(
    input               clk_i,
    input               rst_i,
    input       [31:0]  offset_i,   // offset register
    input       [2:0]   position_i, // input position
    output reg  [2:0]   position_o  // delayed with 30 degrees position
);

//------------------------------------------------------------------------------
//----------- Local Parameters -------------------------------------------------
//------------------------------------------------------------------------------
localparam MAX_SPEED_COUNT  = 32'h1000000;
//State machine
localparam RESET            = 6'b000001;
localparam INIT             = 6'b000010;
localparam CHANGE_POSITION  = 6'b000100;
localparam DELAY_30_DEGREES = 6'b001000;
localparam APPLY_CHANGE     = 6'b010000;
localparam IDLE             = 6'b100000;
//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------
reg [5:0]   state         = RESET;  // current state
reg [5:0]   next_state    = RESET;  // next state
reg [2:0]   position_old  = 3'h0;   // saves the latest position
reg [31:0]  speed_count   = 32'h0;  // counts the current speed of rotation
reg [31:0]  speed_divider = 32'h0;  // divides the speed of rotation by 2, correspoding to 30 degrees
reg [31:0]  delay_count   = 32'h0;  // Applied the delay to the input signal

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------

// State transitions
always @*
begin
    next_state = state;

    case (state)
        RESET:
        begin
            next_state = INIT;
        end
        INIT:
        begin
            if (position_i != position_old)
            begin
                next_state = CHANGE_POSITION;
            end
        end
        CHANGE_POSITION:
        begin
            next_state = DELAY_30_DEGREES;
        end
        DELAY_30_DEGREES:
        begin
            if( delay_count >  speed_divider)
            begin
                next_state          = APPLY_CHANGE;
            end
        end
        APPLY_CHANGE:
        begin
            next_state          = IDLE;
        end
        IDLE:
        begin
            if (position_i != position_old)
            begin
                next_state = CHANGE_POSITION;
            end
        end
        default:
        begin
            next_state = RESET;
        end
    endcase
end

always @(posedge clk_i)
begin
    case(state)
        RESET:
        begin
            speed_count     <= 0;
            speed_divider   <= 0;
            position_o      <= 3'b1;
        end
        INIT:
        begin
            if (speed_count < MAX_SPEED_COUNT)
            begin
                speed_count <= speed_count + 1;
            end
        end
        CHANGE_POSITION:
        begin
            speed_divider   <= speed_count >> 1 ;
            speed_count     <= 0;
            delay_count     <= 0;
        end
        DELAY_30_DEGREES:
        begin
            if (speed_count < MAX_SPEED_COUNT)
            begin
                speed_count <= speed_count + 1;
            end
            delay_count <= delay_count + 1;
        end
        APPLY_CHANGE:
        begin
            if (position_i == 3'b101)
            begin
                position_o <= 100;
            end 
            if (position_i == 3'b100)
            begin
                position_o <= 110;
            end 
            if (position_i == 3'b110)
            begin
                position_o <= 010;
            end 
            if (position_i == 3'b010)
            begin
                position_o <= 011;
            end 
            if (position_i == 3'b011)
            begin
                position_o <= 001;
            end 
            if (position_i == 3'b001)
            begin
                position_o <= 101;
            end 
            position_old    <= position_i;
            if (speed_count < MAX_SPEED_COUNT)
            begin
                speed_count <= speed_count + 1;
            end
        end
        IDLE:
        begin
            if (speed_count < MAX_SPEED_COUNT)
            begin
                speed_count <= speed_count + 1;
            end
        end
    endcase
end

always @ (posedge clk_i)
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

endmodule

