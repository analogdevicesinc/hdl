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
 * Each command has 8 states and shall jump to a new command
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
 * The clk_1 is scaled depending on the requirements, e.g. in open-drain, is
 * slower and must be in synced with clk.
 *
 * Note: clk_1 must be at least 3x slower than clk_0.
 */

`timescale 1ns/100ps
`default_nettype none
`include "i3c_controller_bit_mod_cmd.v"

module i3c_controller_bit_mod (
  input wire reset_n,
  input wire clk_0, // 100MHz
  input wire clk_1, // 12.5MHz
  input wire clk_sel,

  // Bit Modulation Command

  input wire [`MOD_BIT_CMD_WIDTH:0] cmd,
  input wire cmd_valid,
  output wire cmd_ready,

  // RX and ACK

  output wire rx,
  output wire rx_valid,
  output wire rx_stop,
  output wire rx_nack,

  // Status

  output wire idle_bus,

  // Bus drive signals

  output reg  scl,
  output reg  sdi,
  input  wire sdo,
  output wire t
);

  reg reset_n_ctrl;
  reg reset_n_clr;

  reg pp;
  reg [2:0] i;
  reg [7:0] scl_;
  reg [7:0] sdi_;

  reg [1:0] rx_valid_reg;
  reg [1:0] rx_stop_reg;
  reg [1:0] rx_nack_reg;

  reg  [1:0] st;
  reg  [`MOD_BIT_CMD_WIDTH:2] sm;

  reg sdo_reg;
  reg scl_reg;

  localparam [2:0] i_ = 7;

  always @(sm) begin
    case (sm)
      `MOD_BIT_CMD_STOP_     : scl_ = 8'b00011111;
      default                : scl_ = 8'b00011100;
    endcase

    case (sm)
      `MOD_BIT_CMD_START_    : sdi_ = 8'b11111000;
      `MOD_BIT_CMD_STOP_     : sdi_ = 8'b00000111;
      `MOD_BIT_CMD_ACK_IBI_  : sdi_ = 8'b00001111;
      default                : sdi_ = 8'b00000000;
    endcase
  end

  always @(posedge clk_0) begin
    if (!reset_n) begin
      reset_n_ctrl <= 1'b0;
      sm  <= `MOD_BIT_CMD_NOP_;
      cmd_ready_reg_ctrl <= 1'b0;
    end else if (reset_n_clr) begin
      reset_n_ctrl <= 1'b1;
	  end else begin
      if ((cmd_ready_reg & !cmd_ready_reg_ctrl) | sm == `MOD_BIT_CMD_NOP_) begin
        if (cmd_valid) begin
          sm <= cmd[`MOD_BIT_CMD_WIDTH:2];
          st <= cmd[1:0];
        end else begin
          sm <= `MOD_BIT_CMD_NOP_;
        end
      end else begin
        sm <= sm;
        st <= st;
      end
      if (cmd_ready_reg) begin
        cmd_ready_reg_ctrl <= 1'b1;
      end else begin
        cmd_ready_reg_ctrl <= 1'b0;
      end
	end
    rx_valid_reg [1] <= rx_valid_reg [0];
    rx_stop_reg  [1] <= rx_stop_reg  [0];
    rx_nack_reg  [1] <= rx_nack_reg  [0];
  end

  reg cmd_ready_reg;
  reg cmd_ready_reg_ctrl;
  always @(posedge clk_1) begin
    rx_nack_reg[0]  <= 1'b0;
    rx_valid_reg[0] <= 1'b0;
    rx_stop_reg[0]  <= 1'b0;
    if (!reset_n_ctrl) begin
      reset_n_clr <= 1'b1;
      scl <= 1'b1;
      sdi <= 1'b1;
      pp  <= 1'b0;
      i   <= 0;
      cmd_ready_reg <= 1'b0;
    end else begin
      reset_n_clr <= 1'b0;

      i <= sm == `MOD_BIT_CMD_NOP_ ? 0 : i + 1;
      cmd_ready_reg <= (i == i_ - 1 & clk_sel) | (i == i_ & ~clk_sel);

      scl <= scl_[7-i];
      sdi <= sdi_[7-i];
      pp  <= st[1];
      case (sm)
        `MOD_BIT_CMD_NOP_: begin
          sdi <= sdi;
          pp  <= 1'b0;
          scl <= scl;
        end
        `MOD_BIT_CMD_WRITE_: begin
          sdi <= st[0];
        end
        `MOD_BIT_CMD_READ_: begin
          sdi <= 1'b1;
          pp  <= 1'b0;
          if (i == 5) begin
            rx_valid_reg[0] <= 1'b1;
          end
        end
        `MOD_BIT_CMD_START_: begin
          // For Sr
          if (i <= 2) begin
            scl <= scl_reg;
          end
        end
        `MOD_BIT_CMD_STOP_: begin
        end
        `MOD_BIT_CMD_ACK_SDR_: begin
          if (i == 0 || i == 1) begin
            sdi <= 1'b1;
            pp  <= 1'b0;
          end else if (i == 2) begin
            sdi <= sdo_reg;
            rx_nack_reg[0] <= sdo_reg;
          end else begin
            sdi <= sdi;
          end
        end
        `MOD_BIT_CMD_T_READ_: begin
          if (i == 0 || i == 1) begin
            sdi <= 1'b1;
            pp  <= 1'b0;
          end else if (i == 2) begin
            sdi <= st[0] ? 1'b0 : sdo_reg;
            rx_stop_reg[0] <= ~sdo_reg;
          end else begin
            sdi <= sdi;
          end
        end
        `MOD_BIT_CMD_ACK_IBI_: begin
          pp  <= 1'b0;
        end
        default: begin
        end
      endcase
    end
    sdo_reg <= sdo === 1'b0 ? 1'b0 : 1'b1;
    scl_reg <= scl;
  end

  assign rx_valid = rx_valid_reg[0] & ~rx_valid_reg[1];
  assign rx_stop  = rx_stop_reg [0] & ~rx_stop_reg [1];
  assign rx_nack  = rx_nack_reg [0] & ~rx_nack_reg [1];
  assign rx = sdo_reg;

  assign cmd_ready = (cmd_ready_reg | sm == `MOD_BIT_CMD_NOP_) & !cmd_ready_reg_ctrl & reset_n;
  assign t = ~pp & sdi ? 1'b1 : 1'b0;
  assign idle_bus = sm == `MOD_BIT_CMD_NOP_;
endmodule
