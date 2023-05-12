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
 * Executes Word Commands received by the framing module.
 * Each state has linear substates counted in Bit Modulation Commands.
 */

`timescale 1ns/100ps
`default_nettype none
`include "i3c_controller_word_cmd.v"
`include "i3c_controller_bit_mod_cmd.v"

`define DO_ACK do_ack <= 1'b0; // TODO: Change to 1

module i3c_controller_word #(
) (
  input  wire clk,
  input  wire reset_n,

  // Word command

  output wire cmdw_ready,
  input  wire [`CMDW_HEADER_WIDTH+8:0] cmdw,
  // NACK is HIGH when an ACK is not satisfied in the I3C bus, acts as reset.
  output reg cmdw_nack,

  input  wire cmdw_rx_ready,
  output wire cmdw_rx_valid,
  output wire [7:0] cmdw_rx,

  // Bit Modulation Command

  output reg [`MOD_BIT_CMD_WIDTH:0] cmd,
  input  wire cmd_ready,

  // I3C Bus SDA, used for ACK and T (read) check

  input wire sdo
);

  wire [`CMDW_HEADER_WIDTH:0] cmdw_header;

  reg [7:0] cmdw_body;
  reg [`CMDW_HEADER_WIDTH:0] sm;
  reg [8:0] cmdw_rx_reg;
  reg cmdw_rx_valid_reg;

  localparam [6:0]
    I3C_RESERVED = 7'h7e;

  reg do_ack; // Peripheral did NACK?
  reg do_rx_t; // Peripheral end Message at T in Read Data?

  reg [5:0] i;
  reg [5:0] i_;
  // # of Bit Modulation Commands - 1 per word
  always @(sm) begin
    case (sm)
      `CMDW_NOP         : i_ = 0;
      `CMDW_START       : i_ = 0;
      `CMDW_BCAST_7E_W0 : i_ = 8; // 7'h7e+RnW=0+ACK
      `CMDW_BCAST_CCC   : i_ = 0;
      `CMDW_TARGET_ADDR : i_ = 8; // DA+RNW+ACK
      `CMDW_PVT_MSG_SR  : i_ = 0;
      `CMDW_PVT_MSG_RX  : i_ = 8; // SDI+T
      `CMDW_PVT_MSG_TX  : i_ = 8; // SDO+T
      `CMDW_STOP        : i_ = 0;
      `CMDW_BCAST_7E_W1 : i_ = 8; // 7'h7e+RnW=1+ACK
      default           : i_ = 0;
    endcase
  end

  always @(posedge clk) begin
    if (!reset_n) begin
      do_ack <= 1'b0;
      do_rx_t <= 1'b0;
      cmd <= `MOD_BIT_CMD_NOP;
      cmdw_nack <= 1'b0;
      cmdw_rx_valid_reg <= 1'b0;
    end else if (cmd_ready) begin
      sm <= i == i_ ? cmdw_header : sm;
      cmdw_body <= i == i_ ? cmdw[7:0] : cmdw_body;
      i <= sm == `CMDW_NOP ? 0 : (i == i_ ? 0 : i + 1);
      do_ack <= 1'b0;
      do_rx_t <= 1'b0;
      cmdw_rx_valid_reg <= 1'b0;
      if ((do_ack & !(sdo === 1'b0)) | (do_rx_t & (sdo === 1'b0))) begin
        cmd <= `MOD_BIT_CMD_STOP;
        sm <= `CMDW_NOP;
        cmdw_nack <= 1'b1;
      end else begin
        cmdw_nack <= 1'b0;
        case (sm)
          `CMDW_NOP: begin
            cmd <= `MOD_BIT_CMD_NOP;
          end
          `CMDW_START: begin
            cmd <= `MOD_BIT_CMD_START_OD;
          end
          `CMDW_BCAST_7E_W0: begin
            if (i == 7) begin
              // RnW=0
              cmd <= {`MOD_BIT_CMD_WRITE_,1'b0,1'b0};
            end else if (i == 8) begin
              // ACK
              cmd <= {`MOD_BIT_CMD_READ};
              `DO_ACK
            end else begin
              // 7'h7e
              cmd <= {`MOD_BIT_CMD_WRITE_,1'b0,I3C_RESERVED[7 - i[2:0]]};
            end
          end
          `CMDW_BCAST_7E_W1: begin
            if (i == 7) begin
              // RnW=1
              cmd <= {`MOD_BIT_CMD_WRITE_,1'b0,1'b1};
            end else if (i == 8) begin
              // ACK
              cmd <= {`MOD_BIT_CMD_READ};
              `DO_ACK
            end else begin
              // 7'h7e
              cmd <= {`MOD_BIT_CMD_WRITE_,1'b0,I3C_RESERVED[7 - i[2:0]]};
            end
          end
          `CMDW_TARGET_ADDR: begin
            if (i == 8) begin
              // ACK
              cmd <= {`MOD_BIT_CMD_READ};
              `DO_ACK
            end else begin
              // DA+RnW
              cmd <= {`MOD_BIT_CMD_WRITE_,1'b0,cmdw_body[7 - i[2:0]]};
            end
          end
          `CMDW_PVT_MSG_SR: begin
              cmd <= `MOD_BIT_CMD_START_OD;
          end
          `CMDW_PVT_MSG_RX: begin
            if (i == 8) begin
              cmdw_rx_valid_reg <= 1'b1;
              // T
              if (cmdw_rx_ready) begin
                cmd <= `MOD_BIT_CMD_T_READ; // continue, if peripheral wishes to do so
                do_rx_t <= 1'b1;
              end else begin
                cmd <= `MOD_BIT_CMD_START_OD; // stop
              end
            end else begin
              // SDI
              cmd <= `MOD_BIT_CMD_READ;
            end
            cmdw_rx_reg[8-i] <= sdo;
          end
          `CMDW_PVT_MSG_TX: begin
            if (i == 8) begin
              // T
              cmd <= {`MOD_BIT_CMD_WRITE_,1'b0,~^cmdw_body};
              cmdw_rx_valid_reg <= 1'b1;
            end else begin
              // SDO
              cmd <= {`MOD_BIT_CMD_WRITE_,1'b0,cmdw_body[7 - i[2:0]]};
            end
          end
          `CMDW_BCAST_CCC: begin
          end
          `CMDW_STOP: begin
            cmd <= `MOD_BIT_CMD_STOP;
          end
          default: begin
            sm <= `CMDW_NOP;
          end
        endcase
      end
    end
  end

  assign cmdw_ready = (i == i_ & cmd_ready) & reset_n;
  assign cmdw_header = cmdw[`CMDW_HEADER_WIDTH+8 -: `CMDW_HEADER_WIDTH+1];
  assign cmdw_rx = cmdw_rx_reg[7:0];
  assign cmdw_rx_valid = cmdw_rx_valid_reg & cmd_ready;
endmodule
