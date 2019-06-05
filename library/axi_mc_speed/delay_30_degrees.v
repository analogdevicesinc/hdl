// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

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

