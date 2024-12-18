// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
/**
 * Executes Word Commands received by the framing module.
 * Each state has linear sub-states counted in Bit Modulation Commands.
 */

`timescale 1ns/100ps

`include "i3c_controller_word.vh"
`include "i3c_controller_bit_mod.vh"

module i3c_controller_word (
  input      clk,
  input      reset_n,

  // Word command

  output reg cmdw_nack_bcast,
  output reg cmdw_nack_resp,
  output     cmdw_ready,
  input      cmdw_valid,
  input  [`CMDW_HEADER_WIDTH+8:0] cmdw,

  // Byte stream

  input      sdi_ready,
  output reg sdi_valid,
  output     sdi_last,
  output reg [7:0] sdi,

  // Bit Modulation Command

  output [`MOD_BIT_CMD_WIDTH:0] cmdb,
  output       cmdb_valid,
  input        cmdb_ready,

  // RX and ACK

  input        rx,
  input        rx_valid,

  // IBI interface

  output reg   arbitration_valid,
  input        ibi_dev_is_attached,
  input        ibi_bcr_2,
  output reg   ibi_requested,
  input        ibi_requested_auto,
  output reg   ibi_tick,
  output [6:0] ibi_da,
  output [7:0] ibi_mdb,

  // uP accessible info

  input [1:0]  rmap_ibi_config
);

  localparam [6:0] I3C_RESERVED = 7'h7e;

  localparam [1:0] SM_GET      = 0;
  localparam [1:0] SM_SETUP    = 1;
  localparam [1:0] SM_TRANSFER = 2;
  localparam [1:0] SM_RESOLVE  = 3;

  reg [`CMDW_HEADER_WIDTH:0] st;
  reg [`MOD_BIT_CMD_WIDTH:2] cmd_r;
  reg [1:0] sm;
  reg       sg;
  reg [7:0] cmdw_body;
  reg       cmdw_nacked;
  reg [7:0] ibi_da_reg;
  reg [7:0] ibi_mdb_reg;
  reg       do_ack;  // Peripheral did NACK?
  reg       do_rx_t; // Peripheral end Message at T in Read Data?
  reg       cmd_wr;
  reg       sdi_last_reg;
  reg [5:0] i;
  reg [5:0] i_;

  wire ibi_enable;
  wire cmdw_nack;
  wire [`CMDW_HEADER_WIDTH:0] cmdw_header;

  // # of Bit Modulation Commands - 1 per word
  always @(st) begin
    case (st)
      `CMDW_NOP             : i_ =  0;
      `CMDW_START           : i_ =  0;
      `CMDW_BCAST_7E_W0     : i_ =  8; // 7'h7e+RnW=0+ACK / DA+RnW=1+ACK_IBI
      `CMDW_CCC_OD          : i_ =  8; // Direct/Bcast+CCC+T
      `CMDW_CCC_PP          : i_ =  8; // Direct/Bcast+CCC+T
      `CMDW_TARGET_ADDR_OD  : i_ =  8; // DA+RNW+ACK
      `CMDW_TARGET_ADDR_PP  : i_ =  8; // DA+RNW+ACK
      `CMDW_MSG_SR          : i_ =  0;
      `CMDW_MSG_RX          : i_ =  8; // SDI+T
      `CMDW_MSG_TX          : i_ =  8; // SDO+T
      `CMDW_STOP_OD         : i_ =  0;
      `CMDW_STOP_PP         : i_ =  0;
      `CMDW_BCAST_7E_W1     : i_ =  8; // 7'h7e+RnW=1+ACK
      `CMDW_DAA_DEV_CHAR    : i_ =  7; // 8-bit section of the PID+BCR+DCR
      `CMDW_DYN_ADDR        : i_ =  8; // DA+T+ACK
      `CMDW_IBI_MDB         : i_ =  8; // MDB+T
      `CMDW_SR              : i_ =  0;
      `CMDW_I2C_TX          : i_ =  8; // SDO+ACK
      `CMDW_I2C_RX          : i_ =  8; // SDI+ACK
      default               : i_ =  0;
    endcase

    // Set speed grade (open drain or push-pull) for each word.
    case (st)
      `CMDW_NOP             : sg = 0;
      `CMDW_START           : sg = 0;
      `CMDW_BCAST_7E_W0     : sg = 0;
      `CMDW_CCC_OD          : sg = 0;
      `CMDW_CCC_PP          : sg = 1;
      `CMDW_TARGET_ADDR_OD  : sg = 0;
      `CMDW_TARGET_ADDR_PP  : sg = 1;
      `CMDW_MSG_SR          : sg = 0;
      `CMDW_MSG_RX          : sg = 1;
      `CMDW_MSG_TX          : sg = 1;
      `CMDW_STOP_OD         : sg = 0;
      `CMDW_STOP_PP         : sg = 1;
      `CMDW_BCAST_7E_W1     : sg = 0;
      `CMDW_DAA_DEV_CHAR    : sg = 0;
      `CMDW_DYN_ADDR        : sg = 0;
      `CMDW_IBI_MDB         : sg = 1;
      `CMDW_SR              : sg = 0;
      `CMDW_I2C_TX          : sg = 0;
      `CMDW_I2C_RX          : sg = 0;
      default               : sg = 0;
    endcase
  end

  always @(posedge clk) begin
    ibi_tick <= 1'b0;
    sdi_valid <= 1'b0;
    sdi_last_reg <= 1'b0;
    arbitration_valid <= 1'b0;
    if (!reset_n) begin
      i <= 0;
      sm <= SM_GET;
      cmd_wr <= 1'b0;
      st <= `CMDW_NOP;
      ibi_requested <= 1'b0;
      cmd_r <= `MOD_BIT_CMD_NOP_;
    end else begin
      case (sm)
        SM_GET: begin
          if (cmdw_valid) begin
            sm <= SM_SETUP;
          end
          st <= cmdw_header;
          cmdw_body <= cmdw[7:0];
          ibi_requested <= ibi_requested_auto;
          i <= 0;
          cmdw_nacked <= 1'b0;
        end
        SM_SETUP: begin
          sm <= SM_TRANSFER;
          do_ack  <= 1'b0;
          do_rx_t <= 1'b0;

          case (st)
            `CMDW_NOP: begin
              cmd_r <= `MOD_BIT_CMD_NOP_;
            end
            `CMDW_START: begin
              cmd_r <= `MOD_BIT_CMD_START_;
            end
            `CMDW_BCAST_7E_W0: begin
              // During the header broadcast, the peripheral shall issue an IBI, due
              // to this the SDO is monitored and if the controller loses arbitration,
              // shall ACK if IBI is enabled and the DA is attached.
              // If the peripheral's BCR[2] == 1'b1, also receive the MDB.
              // If the device is unknown, NACK the ibi request.
              // resolved;
              if (i[2:1] == 2'b11 & ~ibi_requested) begin
                // 1'b0+RnW=0
                cmd_r <= `MOD_BIT_CMD_WRITE_;
                cmd_wr <= 1'b0;
              end else if (i == 8) begin
                if (ibi_requested) begin // also ibi_len ...
                  // ACK if IBI is enabled and device is known if not, NACK.
                  cmd_r <= ibi_enable & ibi_dev_is_attached ? `MOD_BIT_CMD_ACK_IBI_ : `MOD_BIT_CMD_READ_;
                end else begin
                  // ACK
                  cmd_r <= `MOD_BIT_CMD_ACK_SDR_;
                  do_ack <= 1'b1;
                end
              end else begin
                // 6'b111111
                cmd_r <= `MOD_BIT_CMD_READ_;
              end
            end
            `CMDW_BCAST_7E_W1: begin
              if (i == 7) begin
                // RnW=1
                cmd_r  <= `MOD_BIT_CMD_WRITE_;
                cmd_wr <= 1'b1;
              end else if (i == 8) begin
                // ACK
                cmd_r <= `MOD_BIT_CMD_ACK_SDR_;
                do_ack <= 1'b1;
              end else begin
                // 7'h7e
                cmd_r  <= `MOD_BIT_CMD_WRITE_;
                cmd_wr <= I3C_RESERVED[6 - i[2:0]];
              end
            end
            `CMDW_DYN_ADDR,
            `CMDW_TARGET_ADDR_OD,
            `CMDW_TARGET_ADDR_PP: begin
              if (i == 8) begin
                // ACK
                cmd_r  <= `MOD_BIT_CMD_ACK_SDR_;
                do_ack <= 1'b1;
              end else begin
                // DA+RnW/DA+T
                cmd_r  <= `MOD_BIT_CMD_WRITE_;
                cmd_wr <= cmdw_body[7 - i[2:0]];
              end
            end
            `CMDW_SR,
            `CMDW_MSG_SR: begin
              cmd_r <= `MOD_BIT_CMD_START_;
            end
            `CMDW_I2C_RX: begin
              if (i == 8) begin
                // In I2C, the peripheral cannot stop the SM_TRANSFER.
                cmd_r <= `MOD_BIT_CMD_WRITE_;
                if (sdi_ready) begin
                  if (cmdw_header == `CMDW_STOP_OD) begin
                    // Peek next command to see if the controller wishes to
                    // end the SM_TRANSFER.
                    cmd_wr <= 1'b1; // NACK
                  end else begin
                    cmd_wr <= 1'b0; // ACK
                  end
                end
              end else begin
                // SDI
                cmd_r <= `MOD_BIT_CMD_READ_;
              end
            end
            `CMDW_MSG_RX: begin
              if (i == 8) begin
                // T
                if (sdi_ready) begin
                  if (cmdw_header == `CMDW_STOP_PP) begin
                    // Peek next command to see if the controller wishes to
                    // end the SM_TRANSFER.
                    cmd_r <= `MOD_BIT_CMD_START_;
                  end else begin
                    // continue, if peripheral wishes to do so
                    cmd_r <= `MOD_BIT_CMD_ACK_SDR_;
                    do_rx_t <= 1'b1;
                  end
                end else begin
                  cmd_r <= `MOD_BIT_CMD_START_; // stop
                end
              end else begin
                // SDI
                cmd_r <= `MOD_BIT_CMD_READ_;
              end
            end
            `CMDW_I2C_TX: begin
              if (i == 8) begin
                // ACK
                do_ack <= 1'b1;
                cmd_r <= `MOD_BIT_CMD_READ_;
              end else begin
                // SDO
                cmd_r  <= `MOD_BIT_CMD_WRITE_;
                cmd_wr <= cmdw_body[7 - i[2:0]];
              end
            end
            `CMDW_CCC_OD,
            `CMDW_CCC_PP,
            `CMDW_MSG_TX: begin
              if (i == 8) begin
                // T
                cmd_r  <= `MOD_BIT_CMD_WRITE_;
                cmd_wr <= ~^cmdw_body;
              end else begin
                // SDO/BCAST+CCC
                cmd_r  <= `MOD_BIT_CMD_WRITE_;
                cmd_wr <= cmdw_body[7 - i[2:0]];
              end
            end
            `CMDW_STOP_OD,
            `CMDW_STOP_PP: begin
              cmd_r <= `MOD_BIT_CMD_STOP_;
            end
            `CMDW_DAA_DEV_CHAR: begin
              cmd_r <= `MOD_BIT_CMD_READ_;
            end
            `CMDW_IBI_MDB: begin
              if (i == 8) begin
                // T
                cmd_r <= `MOD_BIT_CMD_READ_;
              end else begin
                // MDB
                cmd_r <= `MOD_BIT_CMD_READ_;
              end
            end
            default: begin
              st <= `CMDW_NOP;
            end
          endcase
        end
        SM_TRANSFER: begin
          if (cmdb_ready) begin
            sm <= SM_RESOLVE;
          end
        end
        SM_RESOLVE: begin
          if (rx_valid) begin
            i <= i + 1;
            if (i == i_ | cmdw_nacked) begin
              sm <= SM_GET;
            end else begin
              sm <= SM_SETUP;
            end

            // Condition to end rx stream:
            // * Check if cmdw changed by peeking next cmd earlier
            // * Peripheral NACKed
            if ((i == i_ & st != cmdw_header) | cmdw_nack) begin
              sdi_last_reg <= 1'b1;
            end

            if (cmdw_nack) begin
              st <= sg ? `CMDW_STOP_PP : `CMDW_STOP_OD;
              sm <= SM_SETUP;
              cmdw_nacked <= 1'b1;
            end

            ibi_requested <= 1'b0;
            case (st)
              `CMDW_NOP,
              `CMDW_START : begin
                ibi_requested <= ibi_requested;
               end
              `CMDW_BCAST_7E_W0: begin
                ibi_da_reg[7-i] <= rx;
                // Arbitration for IBI request.
                ibi_requested <= i < 6 & rx === 1'b0 ? 1'b1 : ibi_requested;
                if (i[2:0] == 7) begin
                  arbitration_valid <= 1'b1;
                  if (ibi_enable & ibi_requested & ibi_dev_is_attached & ~ibi_bcr_2) begin
                    ibi_tick <= 1'b1;
                  end
                end
              end
              `CMDW_DAA_DEV_CHAR,
              `CMDW_I2C_RX,
              `CMDW_MSG_RX: begin
                if (i == i_) begin
                  sdi_valid <= 1'b1;
                end
                /* T-bit is discarded */
                sdi[7-i] <= rx;
              end
              `CMDW_IBI_MDB: begin
                if (i[2:0] == 7) begin
                  ibi_tick <= 1'b1;
                end
                ibi_mdb_reg[7-i] <= rx;
              end
              default: begin
              end
            endcase
          end
        end
      endcase
    end
    cmdw_nack_bcast <= cmdw_nack && st == `CMDW_BCAST_7E_W0;
    cmdw_nack_resp  <= cmdw_nack && st != `CMDW_BCAST_7E_W0;
  end

  assign cmdw_nack = sm == SM_RESOLVE & rx_valid ?
                     (st == `CMDW_DYN_ADDR ||
                      st == `CMDW_TARGET_ADDR_OD ||
                      st == `CMDW_TARGET_ADDR_PP ||
                      st == `CMDW_BCAST_7E_W1 ||
                      st == `CMDW_BCAST_7E_W0 ||
                      st == `CMDW_I2C_RX) ? (do_ack  & rx !== 1'b0) :
                     (st == `CMDW_MSG_RX) ? (do_rx_t & rx === 1'b0) : 1'b0 : 1'b0;

  assign cmdw_ready = sm == SM_GET;
  assign cmdw_header = cmdw[`CMDW_HEADER_WIDTH+8 -: `CMDW_HEADER_WIDTH+1];

  assign ibi_da  = ibi_da_reg [7:1];
  assign ibi_mdb = ibi_mdb_reg;
  assign ibi_enable = rmap_ibi_config[0];
  assign cmdb_valid = sm == SM_TRANSFER;
  assign cmdb = {cmd_r, sg, cmd_wr};

  assign sdi_last = sdi_valid & sdi_last_reg;

endmodule
