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
 *
 * When doing the dynamic address assigment (DAA), the process is:
 * Controller       | Peripheral  | Flow
 * -----------------|-------------|---------
 * S,0x7e,RnW=0     |             |    │
 *                  | ACK         |    │
 * ENTDAA,T         |             |    │
 * Sr               |             | ┌─►│
 * 0x7e,RnW=1       |             | │  ▼
 *                  | ACK         | │  A──┐
 *                  | PID+BCR+DCR | │  │  │
 * DA, Par          |             | │  ▼  │
 *                  | ACK         | └──B  │
 * P                |             |    C◄─┘
 *
 * Notes
 * From A with ACK, continue flow to B, or with NACK, goto C Stop,
 * finishing the DAA. At B, goto on sm state before A, Sr.
 * The first and last ACK are mandatory in the flowchart, if a NACK is received,
 * it is considered an error and the module resets.
 * The whole DAA occurs in OD, hence the Start as Sr in the SM below.
 */

`timescale 1ns/100ps
`default_nettype wire
`include "i3c_controller_word_cmd.v"

module i3c_controller_framing #(
  parameter MAX_DEVS = 15
) (
  input clk,
  input reset_n,

  // Command parsed

  input         cmdp_valid,
  output        cmdp_ready,
  input         cmdp_ccc,
  input         cmdp_ccc_bcast,
  input  [6:0]  cmdp_ccc_id,
  input         cmdp_bcast_header,
  input  [1:0]  cmdp_xmit,
  input         cmdp_sr,
  input  [11:0] cmdp_buffer_len,
  input  [6:0]  cmdp_da,
  input         cmdp_rnw,
  output        cmdp_cancelled, // by the peripheral

  // Byte stream

  output sdo_ready,
  input  sdo_valid,
  input  [7:0] sdo,

  input  sdi_ready,
  output sdi_valid,
  output [7:0] sdi,

  // Word command

  output cmdw_valid,
  input  cmdw_ready,
  output [`CMDW_HEADER_WIDTH+8:0] cmdw,
  input  cmdw_nack,

  output cmdw_rx_ready,
  input  cmdw_rx_valid,
  input  [7:0] cmdw_rx,

  // Raw SDO input & bus condition

  input rx,
  input idle_bus,

  // IBI interface

  input      ibi_requested,
  output reg ibi_requested_auto,

  // DAA interface

  input pid_bcr_dcr_tick,
  input [31:0] pid_bcr_dcr,

  // uP accessible info

  input      [1:0]  rmap_ibi_config,
  input      [29:0] rmap_devs_ctrl_mr,
  output reg [14:0] rmap_devs_ctrl,
  output            rmap_dev_char_e,
  output            rmap_dev_char_we,
  output     [5:0]  rmap_dev_char_addr,
  output     [31:0] rmap_dev_char_wdata,
  input      [8:0]  rmap_dev_char_rdata

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
  reg ctrl_daa;
  reg [3:0] j;

  reg [2:0] smt;
  localparam [2:0]
    setup      = 0,
    transfer   = 1,
    setup_sdo  = 2,
    cleanup    = 3,
    seek       = 4,
    commit     = 5;
  reg [0:0] smr;
  localparam [0:0]
    request    = 0,
    read       = 1;
  reg cmdp_valid_reg;

  localparam [6:0]
    CCC_ENTDAA = 'h07;

  always @(posedge clk) begin
    if (!reset_n) begin
      sm  <= `CMDW_NOP;
      smt <= setup;
      smr <= request;
      ctrl_daa <= 1'b0;
      rmap_devs_ctrl <= 'd0;
      j <= 0;
    end else if (cmdw_nack) begin
      sm  <= `CMDW_NOP;
      smt <= cleanup;
      smr <= request;
      ctrl_daa <= 1'b0;
    end else begin
		  rmap_devs_ctrl <= (rmap_devs_ctrl | rmap_devs_ctrl_mr[14:0])
                      & ~rmap_devs_ctrl_mr[29:15];
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
          cmdp_valid_reg        <= cmdp_valid;
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
                j <= 0;
              end
              `CMDW_SR,
              `CMDW_START: begin
                cmdw_body <= {cmdp_da, cmdp_rnw}; // Attention to RnW here
                sm <= ctrl_daa ? `CMDW_BCAST_7E_W1 :
                     ~cmdp_bcast_header_reg & ~cmdp_ccc_reg ? `CMDW_TARGET_ADDR_OD : `CMDW_BCAST_7E_W0;
                ctrl_daa <= 1'b0;
              end
              `CMDW_BCAST_7E_W0: begin
                sm <= cmdp_ccc_reg ?
                     (cmdp_ccc_id_reg == CCC_ENTDAA ? `CMDW_CCC_OD : `CMDW_CCC_PP) :
                      `CMDW_MSG_SR;
                cmdw_body   <= {cmdp_ccc_bcast_reg, cmdp_ccc_id_reg}; // Attention to BCAST here
              end
              `CMDW_CCC_OD: begin
                // Occurs only during the DAA
                sm <= `CMDW_START;
                ctrl_daa <= 1'b1;
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
              `CMDW_BCAST_7E_W1: begin
                // Occurs only during the DAA
                sm <= `CMDW_DAA_DEV_CHAR_1;
              end
              `CMDW_DAA_DEV_CHAR_1: begin
                sm <= `CMDW_DAA_DEV_CHAR_2;
                smt <= seek;
              end
              `CMDW_DAA_DEV_CHAR_2: begin
                sm <= `CMDW_DYN_ADDR;
                cmdw_body <= rmap_dev_char_rdata;
              end
              `CMDW_DYN_ADDR: begin
                sm <= j == MAX_DEVS ? `CMDW_STOP : `CMDW_START;
                smt <= commit;
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
        seek: begin
          case (smr)
            request: begin
            end
            read: begin
              if (rmap_devs_ctrl[j] == 1'b0 & rmap_dev_char_rdata[8] == 1'b1) begin
                smt <= transfer;
              end
              if (rmap_dev_char_rdata[8] == 1'b0) begin
                // If I2C, just set it as attached
                rmap_devs_ctrl[j] <= 1'b1;
              end
              j <= j + 1;
            end
          endcase
          smr <= ~smr;
        end
        commit: begin
          if (cmdw_ready) begin
            rmap_devs_ctrl[j-1] <= 1'b1;
            smt <= transfer;
          end
        end
        default: begin
          smt <= setup;
        end
      endcase
    end
  end

  reg  [1:0] k;
  wire [1:0] l;
  always @(posedge clk) begin
    k <= ~reset_n ? 2'b01 :
         pid_bcr_dcr_tick ? {k[0],k[1]} : k;
  end
  assign l = smt == seek ? 2'b00 : k;
  assign rmap_dev_char_addr = {l,j};
  assign rmap_dev_char_wdata = pid_bcr_dcr;
  assign rmap_dev_char_we = pid_bcr_dcr_tick;
  assign rmap_dev_char_e = smt == seek | pid_bcr_dcr_tick;

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
