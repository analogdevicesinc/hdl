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
 * Frames commands to the word module.
 * That means, cojoins cmdp and sdio bus into single interface cmdw.
 * It is the main state-machine for the Command Descriptors received.
 */

`timescale 1ns/100ps
`default_nettype none
`include "i3c_controller_word_cmd.v"

module i3c_controller_framing #(
) (
  input  wire clk,
  input  wire reset_n,

  // Command parsed

  input  wire        cmdp_valid,
  output wire        cmdp_ready,
  input  wire        cmdp_ccc,
  input  wire        cmdp_ccc_bcast,
  input  wire [6:0]  cmdp_ccc_id,
  input  wire        cmdp_bcast_header,
  input  wire [1:0]  cmdp_xmit,
  input  wire        cmdp_sr,
  input  wire [11:0] cmdp_buffer_len,
  input  wire [6:0]  cmdp_da,
  input  wire        cmdp_rnw,

  // Byte stream

  output wire sdo_ready,
  input  wire sdo_valid,
  input  wire [7:0] sdo,

  input  wire sdi_ready,
  output wire sdi_valid,
  output wire [7:0] sdi,
  // TODO: What happens when got NACK?
  // should it empty SDO until LEN 0?
  // And SDI?

  // Word command

  input  wire cmdw_ready,
  output wire [`CMDW_HEADER_WIDTH+8:0] cmdw,
  input  wire cmdw_nack,

  output wire cmdw_rx_ready,
  input  wire cmdw_rx_valid,
  input  wire [7:0] cmdw_rx
);
  reg        cmdp_ccc_reg;
  reg        cmdp_ccc_bcast_reg;
  reg [6:0]  cmdp_ccc_id_reg;
  reg        cmdp_bcast_header_reg;
  reg [1:0]  cmdp_xmit_reg;
  reg        cmdp_sr_reg;
  reg [11:0] cmdp_buffer_len_reg;
  reg [6:0]  cmdp_da_reg;
  reg        cmdp_rnw_reg;

  reg [`CMDW_HEADER_WIDTH:0] sm;
  reg [7:0] cmdw_body;

  always @(posedge clk) begin
    if (!reset_n | cmdw_nack) begin
      sm <= `CMDW_NOP;
      cmdw_body <= 8'h00;
    end else if (cmdw_ready) begin
      if (sm == `CMDW_NOP | ((sm == `CMDW_PVT_MSG_TX | sm == `CMDW_PVT_MSG_RX) & cmdp_buffer_len_reg == 0)) begin
        cmdp_ccc_reg        <= cmdp_ccc;
        cmdp_ccc_bcast_reg  <= cmdp_ccc_bcast_reg;
        cmdp_ccc_id_reg     <= cmdp_ccc_id_reg;
        cmdp_xmit_reg       <= cmdp_xmit;
        cmdp_sr_reg         <= cmdp_sr;
        cmdp_buffer_len_reg <= cmdp_buffer_len;
        cmdp_da_reg         <= cmdp_da;
        cmdp_rnw_reg        <= cmdp_rnw;
      end

      // Sr from cmdp_sr is ignored if no cmdp to be sampled at the
      // correct time.
      // However, software must ensure the next cmdp is from the same branch,
      // e.g, Sr'ing from a priv transfer to a BCAST CCC is a forbidden
      // path.
      // SDIO Ready/Valid are not monitored, data will be lost and gibberish
      // will be sent if they do not accept/provide data when needed.
      case (sm)
        `CMDW_NOP: begin
          if (cmdp_valid) begin
            sm <= `CMDW_START;
          end
        end
        `CMDW_START: begin
            sm <= `CMDW_BCAST_7E_W0;
        end
        `CMDW_BCAST_7E_W0: begin
          sm <= cmdp_ccc_reg ? `CMDW_BCAST_CCC : `CMDW_PVT_MSG_SR;
        end
        `CMDW_BCAST_CCC: begin
        end
        `CMDW_PVT_MSG_SR: begin
          cmdw_body   <= {cmdp_da, cmdp_rnw}; // Attention to RnW here
          sm <= `CMDW_TARGET_ADDR;
        end
        `CMDW_TARGET_ADDR: begin
          cmdp_buffer_len_reg <= cmdp_buffer_len_reg - 1;
          cmdw_body <= sdo; // Don't matter for RX
          sm <= cmdp_rnw_reg ? `CMDW_PVT_MSG_RX : `CMDW_PVT_MSG_TX;
        end
        `CMDW_PVT_MSG_RX: begin
          cmdp_buffer_len_reg <= cmdp_buffer_len_reg - 1;
          sm <= cmdp_buffer_len_reg == 0 ? (cmdp_sr_reg & cmdp_valid ? `CMDW_PVT_MSG_SR : `CMDW_STOP) : `CMDW_PVT_MSG_RX;
        end
        `CMDW_PVT_MSG_TX: begin
          cmdp_buffer_len_reg <= cmdp_buffer_len_reg - 1;
          sm <= cmdp_buffer_len_reg == 0 ? (cmdp_sr_reg & cmdp_valid ? `CMDW_PVT_MSG_SR : `CMDW_STOP) : `CMDW_PVT_MSG_TX;
          cmdw_body   <= sdo;
        end
        `CMDW_STOP: begin
          sm <= `CMDW_NOP;
        end
        default: begin
          sm <= `CMDW_NOP;
        end
      endcase
    end else begin
      sm <= sm;
    end
  end

  // TODO: consider replacing cmdw_ready with a synced copy (is acting as a PWM to narrow ready/valid signals)
  assign cmdp_ready = (sm == `CMDW_NOP |
                       ((sm == `CMDW_PVT_MSG_TX | sm == `CMDW_PVT_MSG_RX) & cmdp_buffer_len_reg == 0)
                      ) & reset_n & !cmdw_nack & cmdw_ready;
  assign sdo_ready = ((sm == `CMDW_TARGET_ADDR & !cmdp_rnw_reg) |
                      (sm == `CMDW_PVT_MSG_TX & cmdp_buffer_len_reg != 0)) &
                     cmdw_ready & reset_n;
  assign cmdw = {sm, cmdw_body};

  assign sdi_valid = cmdw_rx_valid;
  assign sdi = cmdw_rx[7:0];
  assign cmdw_rx_ready = sdi_ready;
endmodule
