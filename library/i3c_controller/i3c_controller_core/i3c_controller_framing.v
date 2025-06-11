// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
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
 * Frames commands to the word module.
 * That means, joins cmdp and sdio bus into single interface cmdw.
 * It is the main state-machine for the Command Descriptors received.
 *
 * The Dynamic Address Assigment (DAA) procedure is:
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
 * finishing the DAA. At B, goto on st state before A, Sr.
 * The first and last ACK are mandatory in the flowchart, if a NACK is received,
 * it is considered an error and the module resets.
 * The whole DAA occurs in OD, hence the Start as Sr in the SM below.
 */

`timescale 1ns/100ps

`include "i3c_controller_word.vh"

module i3c_controller_framing #(
  parameter MAX_DEVS = 16
) (
  input         clk,
  input         reset_n,

  // Command parsed

  output        cmdp_ready,
  input         cmdp_valid,
  input  [30:0] cmdp,
  output [2:0]  cmdp_error,
  output reg    cmdp_daa_trigger,

  // Byte stream

  output        sdo_ready,
  input         sdo_valid,
  input  [7:0]  sdo,

  // Word command

  output [`CMDW_HEADER_WIDTH+8:0] cmdw,
  output        cmdw_valid,
  input         cmdw_ready,
  input         cmdw_nack_bcast,
  input         cmdw_nack_resp,

  // Raw SDO input

  input         rx,

  input         nop,
  output reg    i2c_mode,

  // IBI interface

  input         arbitration_valid,
  output        ibi_dev_is_attached,
  output        ibi_bcr_2,
  input         ibi_requested,
  output reg    ibi_requested_auto,
  input [6:0]   ibi_da,

  // uP accessible info

  input  [1:0]  rmap_ibi_config,
  output [6:0]  rmap_dev_char_addr,
  input  [3:0]  rmap_dev_char_data
);

  // Defines the bus available condition width (> 1us for target)
  // Setting around 0.64us for the controller.
  localparam BUS_AVAIL = 5;

  localparam [2:0] SM_SETUP       = 0;
  localparam [2:0] SM_VALIDATE    = 1;
  localparam [2:0] SM_TRANSFER    = 2;
  localparam [2:0] SM_SETUP_SDO   = 3;
  localparam [2:0] SM_CLEANUP     = 4;
  localparam [2:0] SM_ARBITRATION = 5;

  localparam [6:0] CCC_ENTDAA = 'h07;

  reg [`CMDW_HEADER_WIDTH:0] st;
  reg [BUS_AVAIL:0] bus_avail_reg;
  reg        cmdp_ccc_reg;
  reg        cmdp_ccc_bcast_reg;
  reg [6:0]  cmdp_ccc_id_reg;
  reg        cmdp_bcast_header_reg;
  reg        cmdp_sr_reg;
  reg [11:0] cmdp_buffer_len_reg;
  reg [6:0]  cmdp_da_reg;
  reg        cmdp_rnw_reg;
  reg        cmdp_valid_reg;
  reg [7:0]  cmdw_body;
  reg        ctrl_daa;
  reg        ctrl_validate;
  reg [3:0]  j;
  reg [2:0]  dev_char_len;
  reg        daa_trigger;
  reg        error_nack_bcast;
  reg        error_unknown_da;
  reg        error_nack_resp ;
  reg [2:0]  sm;

  wire        bus_avail;
  wire        ibi_enable;
  wire        ibi_listen;
  wire        cmdp_rnw;
  wire [6:0]  cmdp_da;
  wire [11:0] cmdp_buffer_len;
  wire        cmdp_sr;
  wire        cmdp_bcast_header;
  wire        cmdp_ccc;
  wire [6:0]  cmdp_ccc_id;
  wire        cmdp_ccc_bcast;
  wire        dev_is_attached;
  wire        dev_is_i2c;

  always @(posedge clk) begin
    error_unknown_da <= 1'b0;
    if (!reset_n) begin
      j <= 0;
      st  <= `CMDW_NOP;
      sm <= SM_SETUP;
      ctrl_daa <= 1'b0;
      ibi_requested_auto <= 1'b0;
      cmdp_sr_reg <= 0;
      daa_trigger <= 1'b0;
      i2c_mode <= 1'b0;
    end else if (cmdw_nack_bcast | cmdw_nack_resp) begin
      j <= 0;
      st  <= `CMDW_NOP;
      sm <= cmdp_ccc_id_reg == CCC_ENTDAA ? SM_SETUP :
             cmdp_rnw_reg ? SM_SETUP : SM_CLEANUP;
      ctrl_daa <= 1'b0;
    end else begin

      // Delay DAA trigger one word to match last SDI byte.
      cmdp_daa_trigger <= 1'b0;
      if (cmdw_ready) begin
        cmdp_daa_trigger <= daa_trigger;
      end

      // SDI Ready is are not checked, data will be lost
      // if it do not accept/provide data when needed.
      case (sm)
        SM_SETUP: begin
          j <= 0;
          i2c_mode <= 1'b0;
          // Condition where a peripheral requested a IBI during quiet times.
          if (cmdp_valid) begin
            cmdp_sr_reg <= cmdp_sr;
            // Look last SM_TRANSFER SR flag.
            st <= cmdp_sr_reg ? `CMDW_MSG_SR : `CMDW_START;
            // CCC Broadcast casts to all devices, validation not required.
            // Direct is CCC_BCAST 1'b1
            sm <= cmdp_ccc & ~cmdp_ccc_bcast ? SM_TRANSFER : SM_VALIDATE;
            ctrl_validate <= 1'b0;
          end else if (ibi_listen & rx === 1'b0 & bus_avail) begin
            st <= `CMDW_BCAST_7E_W0;
            sm <= SM_TRANSFER;
            ibi_requested_auto <= 1'b1;
          end
          cmdp_valid_reg        <= cmdp_valid;
          cmdp_ccc_reg          <= cmdp_ccc;
          cmdp_ccc_bcast_reg    <= cmdp_ccc_bcast;
          cmdp_ccc_id_reg       <= cmdp_ccc_id;
          cmdp_bcast_header_reg <= cmdp_bcast_header;
          cmdp_buffer_len_reg   <= cmdp_buffer_len;
          cmdp_da_reg           <= cmdp_da;
          cmdp_rnw_reg          <= cmdp_rnw;
        end
        SM_VALIDATE: begin
          // Provide one clock cycle to read the BRAM and improve timing.
          ctrl_validate <= 1'b1;
          if (ctrl_validate) begin
            if (dev_is_i2c) begin
              i2c_mode <= 1'b1;
            end else begin
              i2c_mode <= 1'b0;
            end
            if (dev_is_attached) begin
              sm <= SM_TRANSFER;
            end else begin
              error_unknown_da <= 1'b1;
              sm <= cmdp_rnw_reg ? SM_SETUP : SM_CLEANUP;
            end
          end
        end
        SM_TRANSFER: begin
          if (cmdw_ready) begin
            ibi_requested_auto <= 1'b0;
            case(st)
              `CMDW_NOP: begin
                sm <= SM_SETUP;
                ctrl_daa <= 1'b0;
              end
              `CMDW_SR,
              `CMDW_START: begin
                cmdw_body <= {cmdp_da, cmdp_rnw}; // Attention to RnW here
                st <= ctrl_daa ? `CMDW_BCAST_7E_W1 :
                      (~cmdp_bcast_header_reg & ~cmdp_ccc_reg) | dev_is_i2c ? `CMDW_TARGET_ADDR_OD :
                      `CMDW_BCAST_7E_W0;
              end
              `CMDW_BCAST_7E_W0: begin
                sm <= SM_ARBITRATION;
                cmdw_body <= {cmdp_ccc_bcast_reg, cmdp_ccc_id_reg}; // Attention to BCAST here
              end
              `CMDW_CCC_OD: begin
                // Occurs only during the DAA
                st <= `CMDW_START;
                ctrl_daa <= 1'b1;
              end
              `CMDW_CCC_PP: begin
                if (cmdp_ccc_bcast_reg) begin
                  st <= `CMDW_MSG_SR;
                end else if (~|cmdp_buffer_len_reg) begin
                  st  <= `CMDW_STOP_PP;
                  if (cmdp_sr_reg) begin
                    sm <= SM_SETUP;
                  end
                end else begin
                  st <= `CMDW_MSG_TX;
                  sm <= SM_SETUP_SDO;
                  cmdp_buffer_len_reg <= cmdp_buffer_len_reg - 1;
                end
              end
              `CMDW_BCAST_7E_W1: begin
                // Occurs only during the DAA
                dev_char_len <= 7;
                st <= `CMDW_DAA_DEV_CHAR;
              end
              `CMDW_DAA_DEV_CHAR: begin
                dev_char_len <= dev_char_len - 1;
                if (~|dev_char_len) begin
                  st <= `CMDW_DYN_ADDR;
                  sm <= SM_SETUP_SDO;
                  daa_trigger <= 1'b1;
                end
              end
              `CMDW_DYN_ADDR: begin
                st <= j == MAX_DEVS - 1 ? `CMDW_STOP_OD : `CMDW_START;
                daa_trigger <= 1'b0;
              end
              `CMDW_MSG_SR: begin
                cmdw_body <= {cmdp_da, cmdp_rnw}; // Be aware of RnW here
                st <= dev_is_i2c ? `CMDW_TARGET_ADDR_OD : `CMDW_TARGET_ADDR_PP;
              end
              `CMDW_TARGET_ADDR_OD,
              `CMDW_TARGET_ADDR_PP: begin
                if (cmdp_rnw_reg) begin
                  st <= dev_is_i2c ? `CMDW_I2C_RX : `CMDW_MSG_RX;
                end else begin
                  st <= dev_is_i2c ? `CMDW_I2C_TX : `CMDW_MSG_TX;
                  sm <= SM_SETUP_SDO;
                end
                cmdp_buffer_len_reg <= cmdp_buffer_len_reg - 1;
              end
              `CMDW_I2C_RX,
              `CMDW_MSG_RX: begin
                // I²C read transfers cannot be stopped by the peripheral.
                cmdp_buffer_len_reg <= cmdp_buffer_len_reg - 1;
                if (~|cmdp_buffer_len_reg) begin
                  st  <= dev_is_i2c ? `CMDW_STOP_OD :`CMDW_STOP_PP;
                  if (cmdp_sr_reg) begin
                    sm <= SM_SETUP;
                  end
                end
              end
              `CMDW_I2C_TX,
              `CMDW_MSG_TX: begin
                cmdp_buffer_len_reg <= cmdp_buffer_len_reg - 1;
                if (~|cmdp_buffer_len_reg) begin
                  st  <= dev_is_i2c ? `CMDW_STOP_OD :`CMDW_STOP_PP;
                  if (cmdp_sr_reg) begin
                    sm <= SM_SETUP;
                  end
                end else begin
                  sm <= SM_SETUP_SDO;
                end
              end
              `CMDW_STOP_OD,
              `CMDW_STOP_PP: begin
                sm <= SM_SETUP;
                st <= `CMDW_NOP;
                cmdp_sr_reg <= 1'b0;
              end
              `CMDW_IBI_MDB: begin
                st <= cmdp_valid_reg ? `CMDW_SR : `CMDW_STOP_PP;
              end
              default: begin
                st <= `CMDW_NOP;
              end
            endcase
          end
        end
        SM_SETUP_SDO: begin
          if (sdo_valid) begin
            sm <= SM_TRANSFER;
          end
          cmdw_body <= sdo;
        end
        SM_CLEANUP: begin
          // The peripheral did not ACK the SM_TRANSFER, so it is cancelled.
          // the SDO data is discarded
          if (sdo_valid) begin
            cmdp_buffer_len_reg <= cmdp_buffer_len_reg - 1;
          end
          if (cmdp_buffer_len_reg == 0) begin
            sm <= SM_SETUP;
          end
        end
        SM_ARBITRATION: begin
          if (arbitration_valid) begin
            sm <= SM_TRANSFER;
            // IBI requested during CMDW_BCAST_7E_W0.
            // At the word module, was ACKed if IBI is enabled and DA is known, if not, NACKed.
            if (ibi_requested) begin
              // Receive MSB if IBI is enabled, dev is known and BCR[2] is 1'b1.
              if (ibi_enable & dev_is_attached & ibi_bcr_2) begin
                st <= `CMDW_IBI_MDB;
              end else begin
                st <= cmdp_valid_reg ? `CMDW_START : `CMDW_STOP_OD;
              end
            // No IBI requested during CMDW_BCAST_7E_W0.
            end else if (cmdp_valid_reg) begin
              st <= cmdp_ccc_reg ?
                    (cmdp_ccc_id_reg == CCC_ENTDAA ? `CMDW_CCC_OD : `CMDW_CCC_PP) : `CMDW_MSG_SR;
            end else begin
              st <= `CMDW_STOP_OD;
            end
          end
        end
        default: begin
          sm <= SM_SETUP;
        end
      endcase
    end
    // Improve timing
    error_nack_resp <= cmdw_nack_resp;
    error_nack_bcast <= cmdw_nack_bcast;
  end

  // Bus available condition
  always @(posedge clk) begin
    if (!reset_n || !nop) begin
      bus_avail_reg <= 0;
    end else if (!bus_avail) begin
      bus_avail_reg <= bus_avail_reg + 1;
    end
  end
  assign bus_avail = &bus_avail_reg;

  // Device characteristics look-up.

  assign dev_is_i2c      = rmap_dev_char_data[0] === 1'b1;
  assign dev_is_attached = rmap_dev_char_data[1] === 1'b1;
  assign ibi_bcr_2       = rmap_dev_char_data[3] === 1'b1;

  assign ibi_dev_is_attached = dev_is_attached;
  assign rmap_dev_char_addr  = ibi_requested ? ibi_da : cmdp_da_reg;

  assign cmdp_ready = sm == SM_SETUP & !cmdw_nack_bcast & !cmdw_nack_resp & reset_n;
  assign sdo_ready = (sm == SM_SETUP_SDO | sm == SM_CLEANUP) & !cmdw_nack_bcast & !cmdw_nack_resp & reset_n;
  assign cmdw = {st, cmdw_body};
  assign cmdw_valid = sm == SM_TRANSFER;

  assign ibi_enable = rmap_ibi_config[0];
  assign ibi_listen = rmap_ibi_config[1];

  assign cmdp_rnw          = cmdp[0];
  assign cmdp_da           = cmdp[7:1];
  assign cmdp_buffer_len   = cmdp[19:8];
  assign cmdp_sr           = cmdp[20];
  assign cmdp_bcast_header = cmdp[21];
  assign cmdp_ccc          = cmdp[22];
  assign cmdp_ccc_id       = cmdp[29:23];
  assign cmdp_ccc_bcast    = cmdp[30];

  assign cmdp_error = {error_nack_resp, error_unknown_da, error_nack_bcast};

endmodule
