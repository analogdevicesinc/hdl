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
 * That means, joins cmdp and sdio bus into single interface cmdw.
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
  input  wire        cmdp_ccc_broadcast,
  input  wire [6:0]  cmdp_ccc_id,
  input  wire        cmdp_broadcast_header,
  input  wire [1:0]  cmdp_xmit,
  input  wire        cmdp_sr,
  input  wire [11:0] cmdp_buffer_len,
  input  wire [6:0]  cmdp_da,
  input  wire        cmdp_rnw,

  // Byte stream

  output reg  sdo_u8_ready,
  input  wire sdo_u8_valid,
  input  wire [7:0] sdo_u8,

  input  wire sdi_u8_ready,
  output wire sdi_u8_valid,
  output wire [7:0] sdi_u8,

  // Word command

  input  wire cmdw_ready,
  output wire cmdw_valid,
  output wire [`WORD_CMD_HEADER_LEN+7:0] cmdw,
  // NACK is 'HIGH when an ACK is not satisfied in the I3C bus, acts as reset.
  input  wire cmdw_nack,

  output wire cmdw_rx_ready,
  input  wire cmdw_rx_valid,
  output wire [7:0] cmdw_rx,

);
  reg        cmdp_ccc_reg;
  reg        cmdp_ccc_broadcast_reg;
  reg [6:0]  cmdp_ccc_id_reg;
  reg        cmdp_broadcast_header_reg;
  reg [1:0]  cmdp_xmit_reg;
  reg        cmdp_sr_reg;
  reg [11:0] cmdp_buffer_len_reg;
  reg [6:0]  cmdp_da_reg;
  reg        cmdp_rnw_reg;

  reg [`WORD_CMD_HEADER_LEN-1:0] cmdw_header;
  reg [7:0] cmdw_body;

  localparam [6:0] CCC_ENTDAA = 7'd7;

  reg [3:0] sm;
  localparam [3:0]
    receive    = 0,
    bcast_7e_w = 1,
    target_addr= 2,
    pvt_msg_sr = 3,
    pvt_msg_tx = 4,
    pvt_msg_rx = 5,
    bcast_ccc  = 6,
    exit       = 7;

  always @(posedge clk) begin
    if (!reset_n | cmdw_nack) begin
      sm <= receive;
    end else begin
      case (sm)
        receive: begin
          cmdp_ccc_reg              <= cmdp_ccc;
          cmdp_ccc_broadcast_reg    <= cmdp_ccc_broadcast_reg;
          cmdp_ccc_id_reg           <= cmdp_ccc_id_reg;
          cmdp_xmit_reg             <= cmdp_xmit;
          cmdp_sr_reg               <= cmdp_sr;
          cmdp_buffer_len_reg       <= cmdp_buffer_len;
          cmdp_da_reg               <= cmdp_da;
          cmdp_rnw_reg              <= cmdp_rnw;

          if (cmdp_valid) begin
            cmdw_header <= cmdp_sr ? `WORD_CMD_BCAST_7E_W : (cmdp_ccc ? `WORD_CMD_BCAST_CCC : `WORD_CMD_PVT_MSG_SR);
          end else begin
            sm <= cmdp_sr ? bcast_7e_w : (cmdp_ccc ? bcast_ccc : pvt_msg_sr);
            sm <= receive;
          end
        end
        bcast_7e_w: begin
          if (cmdw_ready) begin
            cmdw_header <= cmdp_ccc_reg ? `WORD_CMD_BCAST_CCC : `WORD_CMD_PVT_MSG_SR;
            sm <= cmdp_ccc_reg ? bcast_ccc : pvt_msg_sr;
          end
        end
        bcast_ccc: begin
        end
        target_addr: begin
          cmdw_body   <= sdo_u8;
          if (cmdw_ready) begin
            if (cmdp_rnw_reg) begin
              cmdw_header <= `WORD_CMD_PVT_MSG_RX;
            end else begin
              cmdw_header <= `WORD_CMD_PVT_MSG_TX;
              sdo_u8_ready <= 1'b1;
            end
            sm <= cmdp_rnw_reg ? pvt_msg_rx : (sdo_u8_valid ? pvt_msg_tx : sm);
          end
        end
        pvt_msg_sr: begin
          if (cmdw_ready) begin
            cmdw_header <= `WORD_CMD_TARGET_ADDR;
            sm <= target_addr;
          end
        end
        pvt_msg_rx: begin
        end
        pvt_msg_tx: begin
          cmdw_body   <= sdo_u8;
          cmdw_header <= `WORD_CMD_PVT_MSG_TX;
          sdo_u8_ready <= cmdw_ready;
          sm <= !sdo_u8_valid ? exit : sm;

        end
        exit: begin
        end
        default: begin
          sm <= receive;
        end
      endcase
    end
  end

  assign cmdp_ready = (sm == receive) & reset_n & !cmdw_nack;
  assign cmdw_valid = (sm == bcast_7e_w) |
                      (sm == bcast_ccc) |
                      (sm == target_addr & (sdo_u8_valid | cmdp_rnw_reg)) |
                      (sm == pvt_msg_tx) |
                      (sm == pvt_msg_rx) |
                      (sm == pvt_msg_sr);
  assign cmdw = {cmdw_header, cmdw_body};
endmodule
