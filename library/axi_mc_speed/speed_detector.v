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
