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

module i3c_controller_word (
  input  wire clk,
  input  wire reset_n,

  // Word command

  output reg cmdw_nack,
  // NACK is HIGH when an ACK is not satisfied in the I3C bus, acts as reset.
  output wire cmdw_ready,
  input  wire cmdw_valid,
  input  wire [`CMDW_HEADER_WIDTH+8:0] cmdw,

  input  wire cmdw_rx_ready,
  output reg  cmdw_rx_valid,
  output wire [7:0] cmdw_rx,

  // Bit Modulation Command

  output wire [`MOD_BIT_CMD_WIDTH:0] cmd,
  output wire cmd_valid,
  input  wire cmd_ready,

  // RX and ACK

  input wire rx,
  input wire rx_valid,

  // IBI interface

  output reg  arbitration_valid,
  input  wire ibi_bcr_2,
  output reg  ibi_requested,
  input  wire ibi_requested_auto,
  output reg  ibi_tick,
  output wire [6:0] ibi_da,
  input  wire ibi_da_attached,
  output wire [7:0] ibi_mdb,

  // DAA interface

  output reg pid_bcr_dcr_tick,
  output reg [31:0] pid_bcr_dcr,

  // uP accessible info

  input wire [1:0] rmap_ibi_config
);
  wire ibi_enable;
  wire ibi_auto;

  wire [`CMDW_HEADER_WIDTH:0] cmdw_header;

  reg [7:0] cmdw_body;
  reg [`CMDW_HEADER_WIDTH:0] sm;
  reg [8:0] cmdw_rx_reg;
  reg cmdw_nacked;

  reg  [8:0] ibi_da_reg;
  reg  [8:0] ibi_mdb_reg;

  localparam [6:0]
    I3C_RESERVED = 7'h7e;

  reg do_ack; // Peripheral did NACK?
  reg do_rx_t; // Peripheral end Message at T in Read Data?
  reg rx_sampled;
  reg sg;
  reg [`MOD_BIT_CMD_WIDTH:2] cmd_r;
  reg cmd_wr;

  reg [5:0] i;
  reg [5:0] i_reg;
  reg [5:0] i_reg_2;
  reg [5:0] i_;
  // # of Bit Modulation Commands - 1 per word
  always @(sm) begin
    case (sm)
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
      `CMDW_DAA_DEV_CHAR_1  : i_ = 31; // 32-bitMSB_PID
      `CMDW_DAA_DEV_CHAR_2  : i_ = 31; // 16-bitLSB_PID+BCR+DCR
      `CMDW_DYN_ADDR        : i_ =  8; // DA+T+ACK
      `CMDW_IBI_MDB         : i_ =  8; // MDB+T
      `CMDW_SR              : i_ =  0;
      default               : i_ =  0;
    endcase

    case (sm)
      `CMDW_NOP             : sg = 0;
      `CMDW_START           : sg = 0;
      `CMDW_BCAST_7E_W0     : sg = 0;
      `CMDW_CCC_OD          : sg = 0;
      `CMDW_CCC_PP          : sg = 1;
      `CMDW_TARGET_ADDR_OD  : sg = 0;
      `CMDW_TARGET_ADDR_PP  : sg = 1;
      `CMDW_MSG_SR          : sg = 1;
      `CMDW_MSG_RX          : sg = 1;
      `CMDW_MSG_TX          : sg = 1;
      `CMDW_STOP_OD         : sg = 0;
      `CMDW_STOP_PP         : sg = 1;
      `CMDW_BCAST_7E_W1     : sg = 0;
      `CMDW_DAA_DEV_CHAR_1  : sg = 0;
      `CMDW_DAA_DEV_CHAR_2  : sg = 0;
      `CMDW_DYN_ADDR        : sg = 0;
      `CMDW_IBI_MDB         : sg = 1;
      `CMDW_SR              : sg = 1;
      default               : sg = 0;
    endcase
  end

  reg [1:0] smt;
  localparam [1:0]
    get        = 0,
    setup      = 1,
    transfer   = 2,
    resolve    = 3;

  always @(posedge clk) begin
    cmdw_nack <= 1'b0;
    cmdw_rx_valid <= 1'b0;
    arbitration_valid <= 1'b0;
    ibi_tick <= 1'b0;
    pid_bcr_dcr_tick <= 1'b0;
    if (!reset_n) begin
      smt <= get;
      sm <= `CMDW_NOP;
      i <= 0;
      ibi_requested <= 1'b0;
      cmd_r <= `MOD_BIT_CMD_NOP_;
      cmd_wr <= 1'b0;
    end else begin
      case (smt)
        get: begin
          if (cmdw_valid) begin
            smt <= setup;
          end
         sm <= cmdw_header;
         cmdw_body <= cmdw[7:0];
         ibi_requested <= ibi_requested_auto;
         i <= 0;
         cmdw_nacked <= 1'b0;
        end
        setup: begin
            smt <= transfer;
            do_ack  <= 1'b0;
            do_rx_t <= 1'b0;

            case (sm)
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
                // If the peripheral's DCR[2] == 1'b1, also receive the MDB.
                // or NACK and Sr.
                // In both cases, the cmd's transfer will continue after the IBI is
                // resolved;
                // TODO multiple ibi bytes.
                if (i[2:1] == 2'b11 & ~ibi_requested) begin
                  // 1'b0+RnW=0
                  cmd_r <= `MOD_BIT_CMD_WRITE_;
                  cmd_wr <= 1'b0;
                end else if (i == 8) begin
                  if (ibi_requested) begin // also ibi_len ...
                    // ACK if IBI is enabled and DA is known, if not, NACK.
                    cmd_r <= ibi_enable & ibi_da_attached ? `MOD_BIT_CMD_ACK_IBI_ : `MOD_BIT_CMD_READ_;
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
              `CMDW_MSG_RX: begin
                if (i == 8) begin
                  // T
                  if (cmdw_rx_ready) begin
                    do_rx_t <= 1'b1;
                    cmd_r <= `MOD_BIT_CMD_ACK_SDR_; // continue, if peripheral wishes to do so
                  end else begin
                    cmd_r <= `MOD_BIT_CMD_START_; // stop
                  end
                end else begin
                  // SDI
                  cmd_r <= `MOD_BIT_CMD_READ_;
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
              `CMDW_DAA_DEV_CHAR_1,
              `CMDW_DAA_DEV_CHAR_2: begin
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
                sm <= `CMDW_NOP;
              end
            endcase
        end
        transfer: begin
          if (cmd_ready) begin
            smt <= resolve;
          end
        end
        resolve: begin
          if (rx_valid) begin
            i <= i + 1;
            smt <= i == i_ | cmdw_nacked ? get : setup;

            case (sm)
              `CMDW_DYN_ADDR,
              `CMDW_TARGET_ADDR_OD,
              `CMDW_TARGET_ADDR_PP,
              `CMDW_BCAST_7E_W1,
              `CMDW_BCAST_7E_W0: begin
                if (do_ack & rx !== 1'b0) begin
                  sm <= `CMDW_STOP_OD;
                  smt <= setup;
                  cmdw_nack <= 1'b1; // Tick
                  // Due to NACK'ED STOP inheriting NACK'ED word i value,
                  // this flag makes sm goto get after STOP cmd.
                  cmdw_nacked <= 1'b1;
                end
              end
              `CMDW_MSG_RX: begin
                if (do_rx_t & rx === 1'b0) begin
                  sm <= `CMDW_STOP_OD;
                  smt <= setup;
                  cmdw_nack <= 1'b1;
                  cmdw_nacked <= 1'b1;
                end
              end
              default: begin
              end
            endcase

            case (sm)
              `CMDW_NOP,
              `CMDW_STOP_OD,
              `CMDW_STOP_PP: begin
                ibi_requested <= ibi_requested;
               end
              `CMDW_BCAST_7E_W0: begin
                ibi_da_reg[8-i] <= rx;
                // Arbitration for IBI request.
                ibi_requested <= i < 6 & rx === 1'b0 ? 1'b1 : ibi_requested;
                if (i == 7) begin
                  arbitration_valid <= 1'b1;
                end
                if (i == 8 & ibi_requested) begin
                  ibi_requested <= 1'b0;
                  // IBI from known peripheral without MDB (BCR[2] is Low).
                  if (ibi_da_attached & ~ibi_bcr_2) begin
                    ibi_tick <= 1'b1;
                  end
                end
              end
              `CMDW_MSG_RX: begin
                if (i == 8) begin
                  cmdw_rx_valid <= 1'b1;
                end
                cmdw_rx_reg[8-i] <= rx;
              end
              `CMDW_IBI_MDB: begin
                if (i == 8) begin
                  ibi_tick <= 1'b1;
                end
                ibi_mdb_reg[8-i] <= rx;
              end
              `CMDW_DAA_DEV_CHAR_1,
              `CMDW_DAA_DEV_CHAR_2: begin
                if (i == 31) begin
                  pid_bcr_dcr_tick <= 1'b1;
                end
                pid_bcr_dcr[31 - i] <= rx;
              end
              default: begin
              end
            endcase
          end
        end
        default: begin
          smt <= get;
        end
      endcase
    end
  end

  assign cmdw_ready = smt == get;
  assign cmdw_header = cmdw[`CMDW_HEADER_WIDTH+8 -: `CMDW_HEADER_WIDTH+1];
  assign cmdw_rx = cmdw_rx_reg[8:1];

  assign ibi_da  = ibi_da_reg [8:2];
  assign ibi_mdb = ibi_mdb_reg[8:1];
  assign ibi_enable = rmap_ibi_config[0];
  assign ibi_auto   = rmap_ibi_config[1];
  assign cmd_valid = smt == transfer;
  assign cmd = {cmd_r, sg, cmd_wr};
endmodule
