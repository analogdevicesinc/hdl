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

module spi_translator_execution (
  input                       clk,
  input                       resetn,

  input                       flush,
  input       [7:0]           clk_div,
  input       [3:0]           spi_config,

  // frame slots, filled by the decoder

  input                       payload_we,
  input       [7:0]           payload_addr,
  input       [7:0]           payload_data,

  input                       commit,
  input                       commit_rw,
  input       [1:0]           commit_target,
  input                       commit_long,
  input       [7:0]           commit_len,
  input       [7:0]           commit_wlen,

  output                      busy,
  output      [7:0]           txn_count,

  // response FIFO read side

  output                      resp_valid,
  output      [7:0]           resp_data,
  input                       resp_ready,
  output                      resp_rdy,
  input                       resp_done,

  // SPI Engine control interface

  input                       cmd_ready,
  output                      cmd_valid,
  output  reg [15:0]          cmd,

  input                       sdo_data_ready,
  output                      sdo_data_valid,
  output      [7:0]           sdo_data,

  output                      sdi_data_ready,
  input                       sdi_data_valid,
  input       [7:0]           sdi_data,

  output                      sync_ready,
  input                       sync_valid,
  input       [7:0]           sync_data
);

  localparam [3:0] S_IDLE    = 4'd0;
  localparam [3:0] S_TAG     = 4'd1;
  localparam [3:0] S_DIV     = 4'd2;
  localparam [3:0] S_CFG     = 4'd3;
  localparam [3:0] S_CS_ON   = 4'd4;
  localparam [3:0] S_XFER    = 4'd5;
  localparam [3:0] S_XFER_RD = 4'd6;
  localparam [3:0] S_CS_OFF  = 4'd7;
  localparam [3:0] S_SYNC    = 4'd8;
  localparam [3:0] S_WAIT    = 4'd9;
  localparam [3:0] S_DONE    = 4'd10;

  wire        start;
  wire        done;
  wire        transfer;
  wire        cfg_new;
  wire        has_cmd;
  wire        step;
  wire  [7:0] rlen;
  wire  [7:0] pay_count;

  wire  [7:0] sdo_mem_data;
  wire        sdo_rd;
  wire        sdo_ready_int;

  reg         abort = 1'b0;
  reg         cfg_valid = 1'b0;
  reg   [7:0] last_div = 8'h00;
  reg   [3:0] last_cfg = 4'h0;
  reg   [7:0] txn_count_reg = 8'h00;
  reg   [7:0] sdo_ptr = 8'h00;
  reg   [7:0] sdi_ptr = 8'h00;
  reg         sdo_valid = 1'b0;

  reg         cur_rw = 1'b0;
  reg         cur_long = 1'b0;
  reg   [1:0] cur_target = 2'd0;
  reg   [7:0] cur_len = 8'h00;
  reg   [7:0] cur_wlen = 8'h00;
  reg   [7:0] cur_tag = 8'h00;
  reg   [7:0] cur_div = 8'h00;
  reg   [3:0] cur_cfg = 4'h0;

  reg   [3:0] state = S_IDLE;
  reg   [3:0] state_next;

  assign start    = commit;
  assign done     = (state == S_DONE);
  assign busy     = (state != S_IDLE);
  assign transfer = (state >= S_DIV) && (state <= S_WAIT);

  assign cfg_new   = ~cfg_valid || (cur_div != last_div) || (cur_cfg != last_cfg);
  assign pay_count = (cur_rw & cur_long) ? cur_wlen : cur_len;
  assign txn_count = txn_count_reg;
  assign resp_rdy = 1'b1;
  assign sync_ready = 1'b1;
  assign rlen = 8'h00;

  // command generation
  always @(*) begin
    case (state)
      S_DIV:     cmd = {8'h20, cur_div};
      S_CFG:     cmd = {8'h21, 4'h0, cur_cfg};
      S_CS_ON:   cmd = {8'h10, ~(8'h01 << cur_target)};
      S_XFER:    cmd = (cur_rw & ~cur_long) ? {8'h03, cur_len - 8'h01} :
                       (cur_rw & cur_long)  ? {8'h01, cur_wlen - 8'h01} :
                                              {8'h01, cur_len - 8'h01};
      S_XFER_RD: cmd = {8'h02, rlen - 8'h01};
      S_CS_OFF:  cmd = 16'h10ff;
      S_SYNC:    cmd = {8'h30, cur_tag};
      default:   cmd = 16'h0000;
    endcase
  end

  assign has_cmd = (state == S_DIV) || (state == S_CFG) || (state == S_CS_ON) ||
                   (state == S_SYNC) || (state == S_CS_OFF) ||
                   ((state == S_XFER) && ~(cur_rw & cur_long & (cur_wlen == 8'h00))) ||
                   ((state == S_XFER_RD) && (rlen != 8'h00));

  assign cmd_valid = has_cmd & ~abort;
  assign step = has_cmd ? cmd_ready : 1'b1;

  always @(*) begin
    state_next = state;
    case (state)
      S_IDLE:    if (commit) state_next = S_TAG;
      S_TAG:     if (!cur_rw | resp_rdy) state_next = cfg_new ? S_DIV : S_CS_ON;
      S_DIV:     if (step) state_next = S_CFG;
      S_CFG:     if (step) state_next = S_CS_ON;
      S_CS_ON:   if (step) state_next = S_XFER;
      S_XFER:    if (step) state_next = (cur_rw & cur_long) ? S_XFER_RD : S_CS_OFF;
      S_XFER_RD: if (step) state_next = S_CS_OFF;
      S_CS_OFF:  if (step) state_next = S_SYNC;
      S_SYNC:    if (step) state_next = S_WAIT;
      S_WAIT:    state_next = sync_valid ? S_DONE : S_WAIT;
      S_DONE:    state_next = S_IDLE;
      default:   state_next = S_IDLE;
    endcase
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      abort <= 1'b0;
    end else begin
      abort <= flush;
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0 || abort == 1'b1) begin
      state <= S_IDLE;
    end else begin
      state <= state_next;
    end
  end

  always @(posedge clk) begin
    if (commit) begin
      cur_rw <= commit_rw;
      cur_long <= commit_long;
      cur_target <= commit_target;
      cur_len <= commit_len;
      cur_wlen <= commit_wlen;
      cur_tag <= txn_count_reg;
      cur_div <= clk_div;
      cur_cfg <= spi_config;
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0 || abort == 1'b1) begin
      cfg_valid <= 1'b0;
      last_div <= 8'h00;
      last_cfg <= 4'h0;
    end else if (state == S_CFG && step) begin
      cfg_valid <= 1'b1;
      last_div <= cur_div;
      last_cfg <= cur_cfg;
    end
  end

  assign sdo_data_valid = sdo_valid & transfer;
  assign sdo_data       = sdo_mem_data;
  assign sdo_ready_int  = sdo_data_ready & transfer;
  assign sdo_rd         = (sdo_ptr != sdi_ptr) & (~sdo_valid | sdo_ready_int);

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      sdi_ptr <= 8'h00;
    end else if (state == S_TAG) begin
      sdi_ptr <= 8'h00;
    end else if (transfer && payload_we) begin
      sdi_ptr <= sdi_ptr + + 1'b1;
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      sdo_ptr <= 8'h00;
      sdo_valid <= 1'b0;
    end else if (state == S_TAG) begin
      sdo_ptr <= 8'h00;
      sdo_valid <= 1'b0;
    end else if (sdo_rd) begin
      sdo_ptr <= sdo_ptr + 1'b1;
      sdo_valid <= 1'b1;
    end else if (sdo_ready_int) begin
      sdo_valid <= 1'b0;
    end
  end

  ad_mem #(
    .DATA_WIDTH (8),
    .ADDRESS_WIDTH (8)
  ) i_slot_mem (
    .clka (clk),
    .wea (payload_we),
    .addra (payload_addr),
    .dina (payload_data),
    .clkb (clk),
    .reb (sdo_rd),
    .addrb (sdo_ptr),
    .doutb (sdo_mem_data));

endmodule
