// ***************************************************************************
// ***************************************************************************
// Copyright 2023 - 2023 (c) Analog Devices, Inc. All rights reserved.
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
  output reg    cmdp_unknown_da,

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

  input rx_raw,
  input cmd_nop,

  // IBI interface

  input       arbitration_valid,
  output      ibi_bcr_2,
  input       ibi_requested,
  output reg  ibi_requested_auto,
  input [6:0] ibi_da,

  // DAA interface

  input pid_bcr_dcr_tick,
  input [31:0] pid_bcr_dcr,

  // uP accessible info

  input      [15:0] devs_ctrl,
  input      [15:0] devs_ctrl_is_i2c,
  input      [15:0] devs_ctrl_candidate,
  output reg [15:0] devs_ctrl_commit,

  input      [1:0]  rmap_ibi_config,
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

  reg [`CMDW_HEADER_WIDTH:0] sm;
  reg [7:0] cmdw_body;
  reg sr;
  reg ctrl_daa;
  reg [3:0] j;

  reg [2:0] smt;
  localparam [2:0]
    setup      = 0,
    validate   = 1,
    transfer   = 2,
    setup_sdo  = 3,
    cleanup    = 4,
    seek       = 5,
    commit     = 6,
    arbitration= 7;

  reg [0:0] smr;
  localparam [0:0]
    request    = 0,
    read       = 1;
  reg cmdp_valid_reg;

  localparam [6:0]
    CCC_ENTDAA = 'h07;

  always @(posedge clk) begin
    cmdp_unknown_da <= 1'b0;
    if (!reset_n) begin
      sm  <= `CMDW_NOP;
      smt <= setup;
      smr <= request;
      ctrl_daa <= 1'b0;
      j <= 0;
      ibi_requested_auto <= 1'b0;
    end else if (cmdw_nack) begin
      sm  <= `CMDW_NOP;
      smt <= cmdp_rnw_reg ? setup : cleanup;
      smr <= request;
      ctrl_daa <= 1'b0;
    end else begin
      devs_ctrl_commit <= 'b0;
      // SDI Ready is are not checked, data will be lost
      // if it do not accept/provide data when needed.
      case (smt)
        setup: begin
          j <= 'd0;
          sr <= cmdw_ready ? 1'b0 : sr;
          // Condition where a peripheral requested a IBI during quiet times.
          if (cmd_nop & ibi_auto & ibi_enable & rx_raw === 1'b0) begin
            sm <= `CMDW_BCAST_7E_W0;
            smt <= transfer;
            ibi_requested_auto <= 1'b1;
          // Got new parsed command from host interface.
          end else if (cmdp_valid) begin
            sm <= cmdw_ready | ~sr ? `CMDW_START : `CMDW_MSG_SR;
            // CCC Broadcast casts to all devices, validation not required.
            // Direct is CCC_BCAST 1'b1
            smt <= cmdp_ccc & ~cmdp_ccc_bcast ? transfer : validate;
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
        end
        validate: begin
          if (dev_is_i2c) begin
            // TODO CONTINUE HERE
            // Implement I2C transfer flow (OD only).
          end
          if (dev_is_known) begin
            smt <= transfer;
          end else begin
            cmdp_unknown_da <= 1'b1;
            smt <= cleanup;
          end
        end
        transfer: begin
          sr <= cmdp_sr_reg;
          if (cmdw_ready) begin
            ibi_requested_auto <= 1'b0;
            case(sm)
              `CMDW_NOP: begin
                smt <= setup;
              end
              `CMDW_SR,
              `CMDW_START: begin
                cmdw_body <= {cmdp_da, cmdp_rnw}; // Attention to RnW here
                sm <= ctrl_daa ? `CMDW_BCAST_7E_W1 :
                     ~cmdp_bcast_header_reg & ~cmdp_ccc_reg ? `CMDW_TARGET_ADDR_OD : `CMDW_BCAST_7E_W0;
                ctrl_daa <= 1'b0;
              end
              `CMDW_BCAST_7E_W0: begin
                smt <= arbitration;
                cmdw_body <= {cmdp_ccc_bcast_reg, cmdp_ccc_id_reg}; // Attention to BCAST here
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
                  sm  <= `CMDW_STOP_PP;
                  smt <= sr ? setup : transfer;
                end else begin
                  smt <= setup_sdo;
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
                cmdw_body <= rmap_dev_char_rdata[7:0];
              end
              `CMDW_DYN_ADDR: begin
                sm <= j == MAX_DEVS ? `CMDW_STOP_OD : `CMDW_START;
                smt <= commit;
              end
              `CMDW_MSG_SR: begin
                cmdw_body <= {cmdp_da, cmdp_rnw}; // Attention to RnW here
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
                  sm  <= `CMDW_STOP_PP;
                  smt <= sr ? setup : transfer;
                end
              end
              `CMDW_MSG_TX: begin
                cmdp_buffer_len_reg <= cmdp_buffer_len_reg - 1;
                if (~|cmdp_buffer_len_reg[11:1]) begin
                  smt <= sr ? setup : transfer;
                  sm  <= `CMDW_STOP_PP;
                end else begin
                  smt <= setup_sdo;
                  sm  <= `CMDW_NOP;
                end
              end
              `CMDW_STOP_OD,
              `CMDW_STOP_PP: begin
                sm <= `CMDW_NOP;
                cmdp_sr_reg <= 1'b0;
              end
              `CMDW_IBI_MDB: begin
                sm <= cmdp_valid_reg ? `CMDW_SR : `CMDW_STOP_PP;
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
          if (cmdp_buffer_len_reg == 0) begin
           smt <= setup;
          end
        end
        seek: begin
          if (devs_ctrl_candidate[j] == 1'b1) begin
            smt <= transfer;
          end else begin
            j <= j + 1;
          end
        end
        commit: begin
          devs_ctrl_commit[j] <= 1'b1;
          if (cmdw_ready) begin
            smt <= transfer;
            j <= j + 1;
          end
        end
        arbitration: begin
          if (arbitration_valid) begin
            smt <= transfer;
            // IBI requested during CMDW_BCAST_7E_W0.
            // At the word module, was ACKed if IBI is enabled and DA is known, if not, NACKed.
            if (ibi_requested) begin
              // Receive MSB if IBI is enabled and BCR[2] is 1'b1.
              // If the DA is unknown, BCR[2] is 1'b0.
              // The controller will ACK even if the DA is unknown.
              if (ibi_enable & ibi_bcr_2) begin
                sm <= `CMDW_IBI_MDB;
              // NACKed if BCR[2] is High or
              // ACKed/NACKed if BCR[2] is Low.
              end else begin
                sm <= cmdp_valid_reg ? `CMDW_START : `CMDW_STOP_OD;
              end
            // No IBI requested during CMDW_BCAST_7E_W0.
            end else if (cmdp_valid_reg) begin
              sm <= cmdp_ccc_reg ?
                    (cmdp_ccc_id_reg == CCC_ENTDAA ? `CMDW_CCC_OD : `CMDW_CCC_PP) : `CMDW_MSG_SR;
            end else begin
              sm <= `CMDW_STOP_OD;
            end
          end
        end
        default: begin
          smt <= setup;
        end
      endcase
    end
  end

  // 7-bit addr RAM for 1 cc data request.

  // Interface to check if device exists and if is I2C

  wire dev_is_known;
  wire dev_is_i2c;

  // Obtain addr index in dev_ctrl, 0 means unknown device,
  // since index 0 is reserved for this controller.

  wire [3:0] pos;
  wire       wen;
  wire [6:0] rwaddr;
  wire [6:0] raddr;
  wire [3:0] rout;
  assign pos = j;
  assign wen = smt == commit;
  assign rwaddr = cmdw_body[7:1];
  assign raddr  = cmdp_da_reg;

  assign dev_is_known = rout != 0;
  assign dev_is_i2c = devs_ctrl_is_i2c[rout];

  // Obtain index from device, unknown devs return 0 (TODO cleared when detatched).

  genvar i;
  generate
    for (i=0; i < 4; i=i+1) begin
      // TODO Replace with inferred
      RAM128X1D #(
        .INIT(128'd0)
      ) i_mem_pos (
        .A(rwaddr),    // Read/write port 7-bit address input
        .DPRA(raddr),  // Read 7-bit address input
        .SPO(),        // Read/write port 1-bit output
        .DPO(rout[i]), // Read port 1-bit output
        .D(pos[i]),    // Write data input
        .WE(wen),      // Write enable input
        .WCLK(clk));   // Write clock input
    end
  endgenerate

  // Obtain BCR[2] from device, unknown devs is 0.

  wire [6:0] raddr_bcr2;
  assign raddr_bcr2 = ibi_da;
   RAM128X1D #(
     .INIT(128'd0)
   ) i_mem_bcr_2 (
     .A(rwaddr),
     .DPRA(raddr_bcr2),
     .SPO(),
     .DPO(ibi_bcr_2),
     .D(pid_bcr_dcr[10]),
     .WE(wen),
     .WCLK(clk));

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
