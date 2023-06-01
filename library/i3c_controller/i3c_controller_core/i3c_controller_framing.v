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
  input  wire        cmdp_do_daa_ready,

  // Byte stream

  output wire sdo_ready,
  input  wire sdo_valid,
  input  wire [7:0] sdo,

  input  wire sdi_ready,
  output reg sdi_valid,
  output reg [7:0] sdi,
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
  wire cmdp_valid_w;

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
  reg cmdw_ready_reg;
  reg sr;

  localparam [0:0]
    setup    = 0,
    transfer = 1;
  reg [0:0] smt;

  always @(posedge clk) begin
    cmdw_ready_reg <= cmdw_ready;
    if (!reset_n | cmdw_nack) begin
      smt <= setup;
      sm  <= `CMDW_NOP;
      cmdw_body <= 8'h00;
    end else begin
      // SDIO Ready/Valid are not monitored, data will be lost and gibberish
      // will be sent if they do not accept/provide data when needed.
      case (smt)
        setup: begin
          sr <= cmdw_ready ? 1'b0 : sr;
          sm <= cmdp_valid_w ? (cmdw_ready | ~sr ? `CMDW_START : `CMDW_MSG_SR) : (cmdw_ready ? `CMDW_NOP : sm);
          smt <= cmdp_valid_w ? transfer : setup;
          cmdp_ccc_reg          <= cmdp_ccc;
          cmdp_ccc_bcast_reg    <= cmdp_ccc_bcast;
          cmdp_ccc_id_reg       <= cmdp_ccc_id;
          cmdp_bcast_header_reg <= cmdp_bcast_header;
          cmdp_xmit_reg         <= cmdp_xmit;
          cmdp_sr_reg           <= cmdp_sr;
          cmdp_buffer_len_reg   <= cmdp_buffer_len;
          cmdp_da_reg           <= cmdp_da;
          cmdp_rnw_reg          <= cmdp_rnw;
        end
        transfer: begin
          sr <= cmdp_sr_reg;
          if (cmdw_ready) begin
            case(sm)
              `CMDW_NOP: begin
                smt <= setup;
              end
              `CMDW_START: begin
                cmdw_body <= {cmdp_da, cmdp_rnw}; // Attention to RnW here
                sm <= ~cmdp_bcast_header_reg & ~cmdp_ccc_reg ? `CMDW_TARGET_ADDR_OD : `CMDW_BCAST_7E_W0;
              end
              `CMDW_BCAST_7E_W0: begin
                sm <= cmdp_ccc_reg ? `CMDW_CCC : `CMDW_MSG_SR;
                cmdw_body   <= {cmdp_ccc_bcast_reg, cmdp_ccc_id_reg}; // Attention to BCAST here
              end
              `CMDW_CCC: begin
                if (cmdp_ccc_bcast_reg) begin
                  sm <= `CMDW_MSG_SR;
                end else if (cmdp_buffer_len_reg == 0) begin
                  sm  <= `CMDW_STOP;
                  smt <= sr ? setup : transfer;
                end else begin
                  sm <= `CMDW_MSG_TX;
                end
              end
              `CMDW_MSG_SR: begin
                cmdw_body   <= {cmdp_da, cmdp_rnw}; // Attention to RnW here
                sm <= `CMDW_TARGET_ADDR_PP;
              end
              `CMDW_TARGET_ADDR_OD,
              `CMDW_TARGET_ADDR_PP: begin
                cmdp_buffer_len_reg <= cmdp_buffer_len_reg - 1;
                cmdw_body <= sdo; // Don't matter for RX
                sm <= cmdp_rnw_reg ? `CMDW_MSG_RX : `CMDW_MSG_TX;
              end
              `CMDW_MSG_RX: begin
                cmdp_buffer_len_reg <= cmdp_buffer_len_reg - 1;
                if (cmdp_buffer_len_reg == 0) begin
                  sm  <= `CMDW_STOP;
                  smt <= sr ? setup : transfer;
                end
              end
              `CMDW_MSG_TX: begin
                cmdp_buffer_len_reg <= cmdp_buffer_len_reg - 1;
                cmdw_body   <= sdo;
                if (cmdp_buffer_len_reg == 0) begin
                  sm  <= `CMDW_STOP;
                  smt <= sr ? setup : transfer;
                end
              end
              `CMDW_STOP: begin
                sm <= `CMDW_NOP;
              end
              default: begin
                sm <= `CMDW_NOP;
              end
            endcase
          end
        end
      endcase
    end
  end

  assign cmdp_ready = smt == setup & reset_n & !cmdw_nack;
  assign sdo_ready = ((
                        (sm == `CMDW_TARGET_ADDR_OD | sm == `CMDW_TARGET_ADDR_PP)
                        & !cmdp_rnw_reg
                      ) | (sm == `CMDW_MSG_TX & cmdp_buffer_len_reg != 0))
                      & cmdw_ready_reg & reset_n;
  assign cmdw = {sm, cmdw_body};
  assign cmdw_rx_ready = sdi_ready;
  assign cmdp_valid_w = cmdp_valid & cmdp_do_daa_ready;
endmodule
