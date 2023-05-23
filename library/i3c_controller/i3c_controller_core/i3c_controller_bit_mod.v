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
 * start   SCL ====--------\____
 *         SDA -~-~-~-~\________
 *          x  | A | B | C | D | *
 *
 * stop    SCL   ___/-----------
 *         SDA   ==____/~~~~~~~~
 *          x  | A | B | C | D | *
 *
 * write  SCL ____/-------\____
 *        SDA X===============X
 *         x  | A | B | C | D | *
 *
 * read    SCL ____/-------\____
 *         SDA ~~~~~~~~~~~~~~~~~
 *          x  | A | B | C | D | *
 *
 * T(read) SCL ____/-------\____
 *         SDA ~~~~S============
 *          x  | A | B | C | D | *
 *
 * S: sample lane and drive it to the value.
 * =: keep last value.
 * X: set lane to value
 * ~: open-drain high
 * ~: push-pull high
 * _: low
 * ~-: either pp or od
 * The clk_bus is scaled depending on the requirements, e.g. in open-drain, is
 * slower and must be in synced with clk.
 */

`timescale 1ns/100ps
`default_nettype none
`include "i3c_controller_bit_mod_cmd.v"

module i3c_controller_bit_mod (
  input wire reset_n,
  input wire clk, // 200MHz
  input wire clk_bus, // 50Mhz, 25MHz

  // Bit Modulation Command
  // "cmd_valid" is embed in known enum values
  input wire [`MOD_BIT_CMD_WIDTH:0] cmd,
  output wire cmd_ready, // indicate sample window

  output reg  scl,
  output reg  sdi,
  input  wire sdo,
  output wire t
);

  wire clk_scl;
  wire [2:0] key;

  reg sdo_reg;
  reg clk_scl_reg;
  reg clk_scl_posedge;
  reg reset_n_reg;
  reg reset_n_clr;
  reg pp_en;
  reg [1:0] clk_counter;

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
    t_rd_b   = 13,
    t_rd_c   = 14,
    t_rd_d   = 15;

  always @(posedge clk) begin
    if (!reset_n) begin
      reset_n_reg <= 1'b0;
      clk_scl_posedge <= 1'b1;
    end else begin
      if (reset_n_clr) begin
        reset_n_reg <= 1'b1;
      end
      clk_scl_posedge <= clk_scl;
    end
  end

  always @(posedge clk_bus) begin
    if (!reset_n_reg) begin
      reset_n_clr <= 1'b1;
      scl <= 1'b1;
      sdi <= 1'b1;
      sm <= idle;
      clk_counter <= 2'b00;
    end else begin
      reset_n_clr <= 1'b0;
      clk_counter <= clk_counter + 1;
      case (sm)
        idle:
        begin
          if (~clk_scl_reg && clk_scl) begin
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
              `MOD_BIT_CMD_T_READ_:
              begin
                sm <= t_rd_b;
                pp_en <= 1'b0;
                scl <= 1'b0;
                sdi <= 1'b1;
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
        t_rd_b, t_rd_c:
        begin
          sm <= sm + 1;
        end
        start_d, stop_d,
        rd_d, wr_d,
        t_rd_d:
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
        t_rd_b: begin
          scl <= 1'b1;
          sdi <= sdo_reg;
        end
        t_rd_c: begin
          scl <= 1'b1;
          sdi <= sdi;
        end
        t_rd_d: begin
          scl <= 1'b0;
          sdi <= sdi;
        end
        default:
          sm <= idle;
      endcase
    end
    clk_scl_reg <= clk_scl;
    sdo_reg <= sdo;
  end

  assign key = cmd[`MOD_BIT_CMD_WIDTH:2];
  assign t = ~pp_en & sdi ? 1'b1 : 1'b0;
  assign clk_scl = clk_counter[1];
  assign cmd_ready = clk_scl & !clk_scl_posedge;
endmodule
