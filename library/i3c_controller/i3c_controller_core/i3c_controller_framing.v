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
  output wire        cmdp_cancelled, // by the peripheral

  // Byte stream

  output wire sdo_ready,
  input  wire sdo_valid,
  input  wire [7:0] sdo,

  input  wire sdi_ready,
  output wire sdi_valid,
  output wire [7:0] sdi,

  // Word command

  output wire cmdw_valid,
  input  wire cmdw_ready,
  output wire [`CMDW_HEADER_WIDTH+8:0] cmdw,
  input  wire cmdw_nack,

  output wire cmdw_rx_ready,
  input  wire cmdw_rx_valid,
  input  wire [7:0] cmdw_rx,

  // Raw SDO input & bus condition

  input wire rx,
  input wire idle_bus,

  // IBI interface

  input  wire ibi_requested,
  output reg  ibi_requested_auto,

  // uP accessible info

  input wire [1:0] rmap_ibi_config
);
  wire ibi_enable;
  wire ibi_auto;

  reg        cmdp_ccc_reg;
  reg        cmdp_ccc_bcast_reg;
  reg [6:0]  cmdp_ccc_id_reg;
  reg        cmdp_bcast_header_reg;
  reg [1:0]  cmdp_xmit_reg;
  reg        cmdp_sr_reg;
  reg [11:0] cmdp_buffer_len_reg;
  reg [6:0]  cmdp_da_reg;
  reg        cmdp_rnw_reg;

  reg ibi_requested_lock;

  reg [`CMDW_HEADER_WIDTH:0] sm;
  reg [7:0] cmdw_body;
  reg sr;

  reg [1:0] smt;
  localparam [1:0]
    setup      = 0,
    transfer   = 1,
    setup_sdo  = 2,
    cleanup    = 3;
  reg cmdp_valid_reg;

  always @(posedge clk) begin
    if (!reset_n) begin
      sm  <= `CMDW_NOP;
      smt <= setup;
    end else if (cmdw_nack) begin
      sm  <= `CMDW_NOP;
      smt <= cleanup;
    end else begin
      // SDI Ready is are not checked, data will be lost
      // if it do not accept/provide data when needed.
      case (smt)
        setup: begin
          sr <= cmdw_ready ? 1'b0 : sr;
          if (idle_bus & ibi_auto & ibi_enable & ~rx) begin
            sm <= `CMDW_BCAST_7E_W0;
            smt <= transfer;
            ibi_requested_auto <= 1'b1;
          end else if (cmdp_valid) begin
            sm <= cmdw_ready | ~sr ? `CMDW_START : `CMDW_MSG_SR;
            smt <= transfer;
          end else begin
            sm <= cmdw_ready ? `CMDW_NOP : sm;
          end
          cmdp_valid_reg <= cmdp_valid;
          cmdp_ccc_reg          <= cmdp_ccc;
          cmdp_ccc_bcast_reg    <= cmdp_ccc_bcast;
          cmdp_ccc_id_reg       <= cmdp_ccc_id;
          cmdp_bcast_header_reg <= cmdp_bcast_header;
          cmdp_xmit_reg         <= cmdp_xmit;
          cmdp_sr_reg           <= cmdp_sr;
          cmdp_buffer_len_reg   <= cmdp_buffer_len;
          cmdp_da_reg           <= cmdp_da;
          cmdp_rnw_reg          <= cmdp_rnw;
          ibi_requested_lock <= 1'b0;
        end
        transfer: begin
          sr <= cmdp_sr_reg;
          if (ibi_requested & ~ibi_requested_lock) begin
            sm <= ibi_enable ? `CMDW_IBI_MDB : `CMDW_SR;
            ibi_requested_lock <= 1'b1;
          end
          if (cmdw_ready) begin
            ibi_requested_auto <= 1'b0;
            case(sm)
              `CMDW_NOP: begin
                smt <= setup;
              end
              `CMDW_SR,
              `CMDW_START: begin
                cmdw_body <= {cmdp_da, cmdp_rnw}; // Attention to RnW here
                sm <= ~cmdp_bcast_header_reg & ~cmdp_ccc_reg ? `CMDW_TARGET_ADDR_OD : `CMDW_BCAST_7E_W0;
              end
              `CMDW_BCAST_7E_W0: begin
                sm <= cmdp_ccc_reg ? `CMDW_CCC_PP : `CMDW_MSG_SR;
                cmdw_body   <= {cmdp_ccc_bcast_reg, cmdp_ccc_id_reg}; // Attention to BCAST here
              end
              `CMDW_CCC_PP: begin
                if (cmdp_ccc_bcast_reg) begin
                  sm <= `CMDW_MSG_SR;
                end else if (cmdp_buffer_len_reg == 0) begin
                  sm  <= `CMDW_STOP;
                  smt <= sr ? setup : transfer;
                end else begin
                  smt <= setup_sdo;
                  sm  <= `CMDW_STOP;
                  sm  <= `CMDW_NOP;
                end
              end
              `CMDW_MSG_SR: begin
                cmdw_body   <= {cmdp_da, cmdp_rnw}; // Attention to RnW here
                sm <= `CMDW_TARGET_ADDR_PP;
              end
              `CMDW_TARGET_ADDR_OD,
              `CMDW_TARGET_ADDR_PP: begin
                if (cmdp_rnw_reg) begin
                  sm <= `CMDW_MSG_RX;
                end else begin
                  smt <= setup_sdo;
                  sm  <= `CMDW_NOP;
                end
              end
              `CMDW_MSG_RX: begin
                cmdp_buffer_len_reg <= cmdp_buffer_len_reg - 1;
                if (~|cmdp_buffer_len_reg[11:1]) begin
                  sm  <= `CMDW_STOP;
                  smt <= sr ? setup : transfer;
                end
              end
              `CMDW_MSG_TX: begin
                cmdp_buffer_len_reg <= cmdp_buffer_len_reg - 1;
                if (~|cmdp_buffer_len_reg[11:1]) begin
                  smt <= sr ? setup : transfer;
                  sm  <= `CMDW_STOP;
                end else begin
                  smt <= setup_sdo;
                  sm  <= `CMDW_NOP;
                end
              end
              `CMDW_STOP: begin
                sm <= `CMDW_NOP;
                cmdp_sr_reg <= 1'b0;
              end
              `CMDW_IBI_MDB: begin
                sm <= cmdp_valid_reg ? `CMDW_SR : `CMDW_STOP;
              end
              default: begin
                sm <= `CMDW_NOP;
              end
            endcase
          end
        end
        setup_sdo: begin
          if (sdo_valid) begin
            sm  <= `CMDW_MSG_TX;
            smt <= transfer;
          end
          cmdw_body <= sdo;
        end
        cleanup: begin
          // The peripheral did not ACK the transfer, so it is cancelled.
          // the SDO data is discarted
          if (sdo_valid) begin
            cmdp_buffer_len_reg <= cmdp_buffer_len_reg - 1;
          end
          smt <= cmdp_buffer_len_reg == 0 ? setup : smt;
        end
        default: begin
          smt <= setup;
        end
      endcase
    end
  end

  assign cmdp_ready = smt == setup & cmdw_ready & !cmdw_nack & reset_n;
  assign sdo_ready = (smt == setup_sdo | smt == cleanup) & reset_n;
  assign cmdw = {sm, cmdw_body};
  assign cmdp_cancelled = cmdw_nack;
  assign cmdw_valid = smt == transfer;

  assign cmdw_rx_ready = sdi_ready;
  assign sdi_valid = cmdw_rx_valid;
  assign sdi = cmdw_rx;

  assign ibi_enable = rmap_ibi_config[0];
  assign ibi_auto   = rmap_ibi_config[1];
endmodule
