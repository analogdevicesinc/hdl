// ***************************************************************************
// ***************************************************************************
// Copyright 2023 (c) Analog Devices, Inc. All rights reserved.
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
/**
 * Translate simple commands into SCL/SDA transitions
 * Each command has 4 states and shall jump to a new command
 * without returning to idle, A/B/C/D/*, where * is a next command
 * first state A or idle.
 *
 * start:  SCL  ~~~~~~~~~~\____
 *      SDA  ~~~~~~~~\______
 *       x | A | B | C | D | *
 *
 * repstart  SCL  ____/~~~~\___
 *      SDA  __/~~~\______
 *       x | A | B | C | D | *
 *
 * stop    SCL  ____/~~~~~~~~
 *      SDA  ==\____/~~~~~
 *       x | A | B | C | D | *
 *
 * write  SCL  ____/~~~~\____
 *      SDA  ==X=========X=
 *       x | A | B | C | D | *
 *
 * read    SCL  ____/~~~~\____
 *      SDA  XXXX=====XXXX
 *       x | A | B | C | D | *
 */

`timescale 1ns / 1ps
`default_nettype none
`include "i3c_controller_bit_mod_cmd.v"

module i3c_controller_bit_mod (
  input wire reset_n,
  input wire clk,
  input wire clk_quarter,
  // Command from byte controller
  // "cmd_valid" is embed in known enum values
  input wire [`MOD_BIT_CMD_WIDTH:0] cmd,
  output reg cmd_tick, // indicate sample window

  output reg  scl,
  output reg  sdi,
  output wire t
);

  wire [2:0] key;
  reg clk_quarter_reg;
  reg pp_en;

  reg [4:0] sm;
  localparam [4:0]
    idle     = 0,
    start_b  = 1,
    start_c  = 2,
    start_d  = 3,
    stop_b   = 4,
    stop_c   = 5,
    stop_d   = 6,
    rd_b     = 7,
    rd_c     = 8,
    rd_d     = 9,
    wr_b     = 10,
    wr_c     = 11,
    wr_d     = 12,
    thigh_b  = 13,
    thigh_c  = 14;

  always @(posedge clk) begin
    if (!reset_n)
    begin
      cmd_tick <= 1'b0;
      scl <= 1'b1;
      sdi <= 1'b1;
      sm <= idle;
    end
    else
    begin
      cmd_tick <= 1'b0;
      cmd_tick <= ~clk_quarter_reg && clk_quarter ? 1'b1 : 1'b0;
      case (sm)
        idle:
        begin
          if (~clk_quarter_reg && clk_quarter) begin
            case (key)
              `MOD_BIT_CMD_START_:
              begin
                sm <= start_b;
                pp_en <= cmd[1];
                scl <= scl;
                sdi <= 1'b1;
              end
              `MOD_BIT_CMD_STOP_:
              begin
                sm <= stop_b;
                pp_en <= 1'b0;
                scl <= 1'b0;
                sdi <= 1'b0;
              end
              `MOD_BIT_CMD_READ_:
              begin
                sm <= rd_b;
                pp_en <= 1'b0;
                scl <= 1'b0;
                sdi <= 1'b1;
              end
              `MOD_BIT_CMD_WRITE_:
              begin
                sm <= wr_b;
                pp_en <= cmd[1];
                scl <= 1'b0;
                sdi <= cmd[0];
              end
              default: begin
                sm <= idle;
                pp_en <= 1'b0;
                sdi <= sdi;
                scl <= scl;
              end
            endcase
          end
        end
        start_b, start_c,
        stop_b, stop_c,
        rd_b, rd_c,
        wr_b, wr_c,
        thigh_b:
        begin
          sm <= sm + 1;
        end
        start_d, stop_d,
        rd_d, wr_d,
        thigh_c:
        begin
          sm <= idle;
        end
        default:
        begin
          sm <= idle;
        end
      endcase

      case (sm)
        idle: begin
        end
        start_b: begin
          scl <= 1'b1;
          sdi <= 1'b1;
        end
        start_c: begin
          scl <= 1'b1;
          sdi <= 1'b0;
        end
        start_d: begin
          scl <= 1'b0;
          sdi <= 1'b0;
        end
        stop_b: begin
          scl <= 1'b1;
          sdi <= 1'b0;
        end
        stop_c: begin
          scl <= 1'b1;
          sdi <= 1'b0;
        end
        stop_d: begin
          scl <= 1'b1;
          sdi <= 1'b1;
        end
        rd_b: begin
          scl <= 1'b1;
          sdi <= 1'b1;
        end
        rd_c: begin
          scl <= 1'b1;
          sdi <= 1'b1;
        end
        rd_d: begin
          scl <= 1'b0;
          sdi <= 1'b1;
        end
        wr_b: begin
          scl <= 1'b1;
          sdi <= sdi;
        end
        wr_c: begin
          scl <= 1'b1;
          sdi <= sdi;
        end
        wr_d: begin
          scl <= 1'b0;
          sdi <= sdi;
        end
        thigh_b: begin
          scl <= 1'b1;
          sdi <= 1'b1;
        end
        thigh_c: begin
          scl <= 1'b1;
          sdi <= 1'b1;
        end
        default:
          sm <= idle;
      endcase
    end
    clk_quarter_reg <= clk_quarter;
  end

  assign key = cmd[`MOD_BIT_CMD_WIDTH:2];
  assign t = ~pp_en & sdi ? 1'b1 : 1'b0;
endmodule
