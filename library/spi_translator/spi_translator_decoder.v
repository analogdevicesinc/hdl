// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

module spi_translator_decoder (
  input                       clk,
  input                       resetn,

  input                       flush,
  input                       crc_en,

  // SPI slave

  input       [7:0]           rx_data,
  input                       rx_valid,
  input                       frame_start,
  input                       frame_end,
  input                       frame_active,

  output                      tx_valid,
  output      [7:0]           tx_data,
  input                       tx_ready,

  // register file

  output                      reg_wr_en,
  output      [7:0]           reg_wr_addr,
  output      [7:0]           reg_wr_data,
  input       [7:0]           reg_rd_data,

  // frame slots

  output                      payload_we,
  output      [7:0]           payload_addr,
  output      [7:0]           payload_data,

  output  reg                 commit,
  output                      commit_rw,
  output      [1:0]           commit_target,
  output                      commit_long,
  output      [7:0]           commit_len,
  output      [7:0]           commit_wlen,

  // responses

  input                       resp_rdy,
  input                       resp_valid,
  input       [7:0]           resp_data,
  output                      resp_ready,
  output  reg                 resp_done,

  output  reg                 flush_req
);

  localparam [2:0] OP_NOP     = 3'd0;
  localparam [2:0] OP_XFER_W  = 3'd1;
  localparam [2:0] OP_XFER_RW = 3'd2;
  localparam [2:0] OP_FETCH   = 3'd3;
  localparam [2:0] OP_CTRL_W  = 3'd4;
  localparam [2:0] OP_CTRL_R  = 3'd5;
  localparam [2:0] OP_FLUSH   = 3'd6;

  wire  [2:0] op;
  wire        is_long;
  wire        hdr_last;
  wire        payload_byte;

  reg   [8:0] idx = 9'h000;
  reg   [7:0] hdr0 = 8'h00;
  reg   [7:0] hdr1 = 8'h00;
  reg   [7:0] hdr2 = 8'h00;
  reg         hdr_end = 1'b0;
  reg         hdr_ok = 1'b0;
  reg   [7:0] pay_cnt = 8'h00;
  reg   [7:0] pay_exp = 8'h00;
  reg         bad = 1'b0;
  reg         resp_rdy_start = 1'b0;

  assign op      = hdr0[7:5];
  assign is_long = hdr0[2];
  assign is_xfer = (op == OP_XFER_W) || (op == OP_XFER_RW);
  assign is_rw   = (op == OP_XFER_RW);

  // index of the last header byte
  assign hdr_last = 9'd1 + is_long;

  assign payload_byte = rx_valid & hdr_ok & ~bad;

  assign commit_rw      = is_rw;
  assign commit_target  = hdr0[4:3];
  assign commit_long    = is_long;
  assign commit_keep_cs = hdr0[1];
  assign commit_len     = hdr1;
  assign commit_wlen    = hdr2;

  assign payload_we   = payload_byte && is_xfer && (pay_cnt < pay_exp);
  assign payload_addr = pay_cnt[7:0];
  assign payload_data = rx_data;

  // header capture
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      idx <= 9'h000;
      hdr_end <= 1'b0;
      resp_rdy_start <= 1'b0;
    end else begin
      hdr_end <= 1'b0;
      if (frame_start) begin
        idx <= 9'h000;
        resp_rdy_start <= resp_rdy;
      end else if (rx_valid) begin
        idx <= (idx == 9'h1ff) ? idx : idx + 1'b1;
        if (idx == 9'h000) begin
          hdr0 <= rx_data;
        end else if (idx == 9'h001) begin
          hdr1 <= rx_data;
        end else if (idx == 9'h002 && is_long) begin
          hdr2 <= rx_data;
        end
        if (idx != 9'h000 && idx == hdr_last) begin
          hdr_end <= 1'b1;
        end
      end
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      hdr_ok <= 1'b0;
      bad <= 1'b0;
      commit <= 1'b0;
      pay_cnt <= 8'h00;
      pay_exp <= 8'h00;
      flush_req <= 1'b0;
    end else begin
      commit <= 1'b0;
      if (frame_start) begin
        hdr_ok <= 1'b0;
        bad <= 1'b0;
        pay_cnt <= 8'h00;
        pay_exp <= 8'h00;
        flush_req <= 1'b0;
      end else if (flush) begin
        // slots are being dropped under this frame; never commit it
        bad <= 1'b1;
      end else if (hdr_end && ~bad) begin
        hdr_ok <= 1'b1;
        commit <= 1'b1;
        pay_exp <= (is_rw && is_long) ? {1'b0, hdr2} : {1'b0, hdr1};
      end else if (payload_byte) begin
        if (is_xfer) begin
          if (pay_cnt < pay_exp) begin
            pay_cnt <= pay_cnt + 1'b1;
          end else begin
            bad <= 1'b1;
          end
        end
      end

      if (frame_end && idx != 9'h000) begin
        if (hdr_ok && ~bad) begin
          if (op == OP_FLUSH) begin
            flush_req <= 1'b1;
          end
        end
      end
    end
  end

endmodule