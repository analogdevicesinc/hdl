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

module i3c_controller_word #(
) (
  input  wire clk,
  input  wire reset_n,

  // Word command

  input wire cmdw_mux,
  output reg cmdw_nack,
  // NACK is HIGH when an ACK is not satisfied in the I3C bus, acts as reset.
  output wire cmdw_framing_valid,
  output wire cmdw_daa_valid,
  output wire cmdw_ready,
  input  wire [`CMDW_HEADER_WIDTH+8:0] cmdw_framing, // From Framing
  input  wire [`CMDW_HEADER_WIDTH+8:0] cmdw_daa, // From DAA


  input  wire cmdw_rx_ready,
  output reg  cmdw_rx_valid,
  output wire [7:0] cmdw_rx,

  // Bit Modulation Command

  output reg [`MOD_BIT_CMD_WIDTH:0] cmd,
  output wire cmd_valid,
  input  wire cmd_ready,

  // RX and ACK

  input wire rx,
  input wire rx_valid,
  input wire rx_stop,
  input wire rx_nack,

  // Modulation clock selection

  output wire clk_sel,

  // IBI interface

  output reg  ibi_requested,
  output reg  ibi_tick,
  output wire [6:0] ibi_da,
  output wire [7:0] ibi_mdb,

  // uP accessible info

  input wire [1:0] rmap_ibi_config
);
  wire ibi_enable;
  wire ibi_auto;

  wire [`CMDW_HEADER_WIDTH:0] cmdw_header;
  wire [`CMDW_HEADER_WIDTH+8:0] cmdw;
  wire cmdw_valid;
  reg cmd_ready_reg;

  reg [7:0] cmdw_body;
  reg [`CMDW_HEADER_WIDTH:0] sm;
  reg [`CMDW_HEADER_WIDTH:0] sm_reg;
  reg [`CMDW_HEADER_WIDTH:0] sm_reg_2;
  reg [8:0] cmdw_rx_reg;
  reg cmdw_rx_valid_reg;

  reg ibi_tick_reg;
  reg  [8:0] ibi_da_reg;
  reg  [8:0] ibi_mdb_reg;

  localparam [6:0]
    I3C_RESERVED = 7'h7e;

  reg [1:0] do_ack; // Peripheral did NACK?
  reg [1:0] do_rx_t; // Peripheral end Message at T in Read Data?
  reg rx_sampled;
  reg clk_sel_lut;
  reg [1:0] clk_sel_reg;

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
      `CMDW_CCC             : i_ =  8; // Direct/Bcast+CCC+T
      `CMDW_TARGET_ADDR_OD  : i_ =  8; // DA+RNW+ACK
      `CMDW_TARGET_ADDR_PP  : i_ =  8; // DA+RNW+ACK
      `CMDW_MSG_SR          : i_ =  0;
      `CMDW_MSG_RX          : i_ =  8; // SDI+T
      `CMDW_MSG_TX          : i_ =  8; // SDO+T
      `CMDW_STOP            : i_ =  0;
      `CMDW_BCAST_7E_W1     : i_ =  8; // 7'h7e+RnW=1+ACK
      `CMDW_PROV_ID_BCR_DCR : i_ =  8; // 48-bitUniqueID+BCR+DCR
      `CMDW_DYN_ADDR        : i_ =  8; // DA+T+ACK
      `CMDW_IBI_MDB         : i_ =  8; // MDB+T
      `CMDW_SR              : i_ =  0;
      default               : i_ =  0;
    endcase

    case (sm)
      `CMDW_NOP             : clk_sel_lut = 0;
      `CMDW_START           : clk_sel_lut = 0;
      `CMDW_BCAST_7E_W0     : clk_sel_lut = 0;
      `CMDW_CCC             : clk_sel_lut = 1;
      `CMDW_TARGET_ADDR_OD  : clk_sel_lut = 0;
      `CMDW_TARGET_ADDR_PP  : clk_sel_lut = 1;
      `CMDW_MSG_SR          : clk_sel_lut = 1;
      `CMDW_MSG_RX          : clk_sel_lut = 1;
      `CMDW_MSG_TX          : clk_sel_lut = 1;
      `CMDW_STOP            : clk_sel_lut = 1;
      `CMDW_BCAST_7E_W1     : clk_sel_lut = 0;
      `CMDW_PROV_ID_BCR_DCR : clk_sel_lut = 0;
      `CMDW_DYN_ADDR        : clk_sel_lut = 0;
      `CMDW_IBI_MDB         : clk_sel_lut = 1;
      `CMDW_SR              : clk_sel_lut = 1;
      default               : clk_sel_lut = 0;
    endcase
  end

  reg [0:0] smt;
  localparam [0:0]
    setup      = 0,
    transfer   = 1;

  always @(posedge clk) begin
    cmdw_nack <= 1'b0;
    cmdw_rx_valid <= 1'b0;
    ibi_tick <= 1'b0;
    if (!reset_n) begin
      cmd <= `MOD_BIT_CMD_NOP;
      smt <= setup;
      sm <= `CMDW_NOP;
      sm_reg <= `CMDW_NOP;
      sm_reg_2 <= `CMDW_NOP;
      i <= 0;
      i_reg <= 0;
      i_reg_2 <= 0;
      clk_sel_reg <= 2'b00;
      ibi_requested <= 1'b0;
    end if ((do_ack[1] & rx_nack) | (do_rx_t[1] & rx_stop)) begin
      sm <= `CMDW_NOP;
      cmd <= {`MOD_BIT_CMD_STOP_, 1'b0,1'b0};
      clk_sel_reg <= 2'b00;
      cmdw_nack <= 1'b1;
    end else begin
      case (smt)
        setup: begin
          if (cmdw_valid) begin
            smt <= transfer;
          end
         sm <= cmdw_header;
         cmdw_body <= cmdw[7:0];
         i <= 0;
        end
        transfer: begin
          if (cmd_ready) begin
            clk_sel_reg <= {clk_sel_reg[0], clk_sel_lut};
            do_ack  <= {do_ack[0], 1'b0};
            do_rx_t <= {do_rx_t[0], 1'b0};
            i <= i + 1;
            i_reg <= i;
            i_reg_2 <= i_reg;
            sm_reg <= sm;
            sm_reg_2 <= sm_reg;
            if (i == i_) begin
              smt <= setup;
            end
            ibi_requested <= 1'b0;

            // RX pipelines, delayed twice to match bit_mod
            case (sm_reg_2)
              `CMDW_BCAST_7E_W0: begin
                ibi_da_reg[8-i_reg_2] <= rx_sampled;
                ibi_requested <= i_reg_2 < 6 & rx_sampled === 1'b0 ? 1'b1 : ibi_requested;
              end
              `CMDW_MSG_RX: begin
                if (i_reg_2 == 8) begin
                  cmdw_rx_valid <= 1'b1;
                end
                cmdw_rx_reg[8-i_reg_2] <= rx_sampled;
              end
              `CMDW_IBI_MDB: begin
                if (i_reg_2 == 8) begin
                  ibi_tick <= 1'b1;
                end
                ibi_mdb_reg[8-i_reg_2] <= rx_sampled;
              end
              default: begin
              end
            endcase

            case (sm)
              `CMDW_NOP: begin
                cmd <= `MOD_BIT_CMD_NOP;
              end
              `CMDW_START: begin
                cmd <= `MOD_BIT_CMD_START_OD;
              end
              `CMDW_BCAST_7E_W0: begin
                // During the header broadcast, the peripheral shall issue an IBI, due
                // to this the SDO is monitored and if the controller loses arbitration,
                // shall ACK if IBI is enabled and receive the MDB, of NACK and Sr.
                // In both cases, the cmd's transfer will continue after the IBI is
                // resolved;
                if (i[2:1] == 2'b11) begin
                  // 1'b0+RnW=0
                  cmd <= ibi_requested ? `MOD_BIT_CMD_READ : {`MOD_BIT_CMD_WRITE_,1'b0,1'b0};
                end else if (i == 8) begin
                  if (ibi_requested) begin
                    cmd <= ibi_enable ? `MOD_BIT_CMD_ACK_IBI : `MOD_BIT_CMD_READ;
                  end else begin
                    // ACK
                    cmd <= `MOD_BIT_CMD_ACK_SDR;
                    do_ack[0] <= 1'b1;
                  end
                end else begin
                  // 6'b111111
                  cmd <= `MOD_BIT_CMD_READ;
                end
              end
              `CMDW_BCAST_7E_W1: begin
                if (i == 7) begin
                  // RnW=1
                  cmd <= {`MOD_BIT_CMD_WRITE_,1'b1,1'b1};
                end else if (i == 8) begin
                  // ACK
                  cmd <= `MOD_BIT_CMD_ACK_SDR;
                  do_ack[0] <= 1'b1;
                end else begin
                  // 7'h7e
                  cmd <= {`MOD_BIT_CMD_WRITE_,1'b1,I3C_RESERVED[6 - i[2:0]]};
                end
              end
              `CMDW_DYN_ADDR,
              `CMDW_TARGET_ADDR_OD,
              `CMDW_TARGET_ADDR_PP: begin
                if (i == 8) begin
                  // ACK
                  cmd <= `MOD_BIT_CMD_ACK_SDR;
                  do_ack[0] <= 1'b1;
                end else begin
                  // DA+RnW/DA+T
                  cmd <= {`MOD_BIT_CMD_WRITE_,clk_sel_lut,cmdw_body[7 - i[2:0]]};
                end
              end
              `CMDW_SR,
              `CMDW_MSG_SR: begin
                  cmd <= `MOD_BIT_CMD_START_PP;
              end
              `CMDW_MSG_RX: begin
                if (i == 8) begin
                  // T
                  if (cmdw_rx_ready) begin
                    do_rx_t[0] <= 1'b1;
                    cmd <= `MOD_BIT_CMD_T_READ_CONT; // continue, if peripheral wishes to do so
                  end else begin
                    cmd <= `MOD_BIT_CMD_T_READ_STOP; // stop
                  end
                end else begin
                  // SDI
                  cmd <= `MOD_BIT_CMD_READ;
                end
              end
              `CMDW_CCC,
              `CMDW_MSG_TX: begin
                if (i == 8) begin
                  // T
                  cmd <= {`MOD_BIT_CMD_WRITE_,1'b1,~^cmdw_body};
                end else begin
                  // SDO/BCAST+CCC
                  cmd <= {`MOD_BIT_CMD_WRITE_,1'b1,cmdw_body[7 - i[2:0]]};
                end
              end
              `CMDW_STOP: begin
                cmd <= `MOD_BIT_CMD_STOP_OD;
              end
              `CMDW_PROV_ID_BCR_DCR: begin
                cmd <= `MOD_BIT_CMD_READ;
                // TODO: Figure out what to do with PID,BCR,DCR
              end
              `CMDW_IBI_MDB: begin
                if (i == 8) begin
                  // T
                  cmd <= `MOD_BIT_CMD_READ;
                end else begin
                  // MDB
                  cmd <= `MOD_BIT_CMD_READ;
                end
              end
              default: begin
                sm <= `CMDW_NOP;
              end
            endcase
          end
        end
      endcase
    end
    rx_sampled <= rx_valid ? rx : rx_sampled;
    cmd_ready_reg <= cmd_ready;
  end

  assign cmdw_ready = smt == setup; // i == 0 & cmd_ready_reg & reset_n;
  assign cmdw = cmdw_mux ? cmdw_framing : cmdw_daa;
  assign cmdw_valid = cmdw_mux ? cmdw_framing_valid : cmdw_daa_valid;
  assign cmdw_header = cmdw[`CMDW_HEADER_WIDTH+8 -: `CMDW_HEADER_WIDTH+1];
  assign cmdw_rx = cmdw_rx_reg[8:1];
  assign clk_sel = clk_sel_reg[1];

  assign ibi_da  = ibi_da_reg [8:2];
  assign ibi_mdb = ibi_mdb_reg[8:1];
  assign ibi_enable = rmap_ibi_config[0];
  assign ibi_auto   = rmap_ibi_config[1];
  assign cmd_valid = smt == transfer;
endmodule
