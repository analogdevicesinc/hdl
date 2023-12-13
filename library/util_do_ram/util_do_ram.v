// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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

// Constraints:

`timescale 1ns/100ps

module util_do_ram #(
  parameter SRC_DATA_WIDTH = 512,
  parameter DST_DATA_WIDTH = 128,

  parameter LENGTH_WIDTH = 16
) (
  input                                    wr_request_enable,
  input                                    wr_request_valid,
  output  reg                              wr_request_ready = 1'b0,
  input   [LENGTH_WIDTH-1:0]               wr_request_length,
  output  reg [LENGTH_WIDTH-1:0]           wr_response_measured_length = 'h0,
  output  reg                              wr_response_eot = 1'b0,

  input                                    rd_request_enable,
  input                                    rd_request_valid,
  output                                   rd_request_ready,
  input   [LENGTH_WIDTH-1:0]               rd_request_length,
  output                                   rd_response_eot,

  // Slave streaming AXI interface
  input                                    s_axis_aclk,
  input                                    s_axis_aresetn,
  output reg                               s_axis_ready = 1'b0,
  input                                    s_axis_valid,
  input  [SRC_DATA_WIDTH-1:0]              s_axis_data,
  input  [SRC_DATA_WIDTH/8-1:0]            s_axis_strb,
  input  [SRC_DATA_WIDTH/8-1:0]            s_axis_keep,
  input  [0:0]                             s_axis_user,
  input                                    s_axis_last,

  // Master streaming AXI interface
  input                                    m_axis_aclk,
  input                                    m_axis_aresetn,
  input                                    m_axis_ready,
  output                                   m_axis_valid,
  output [DST_DATA_WIDTH-1:0]              m_axis_data,
  output [DST_DATA_WIDTH/8-1:0]            m_axis_strb,
  output [DST_DATA_WIDTH/8-1:0]            m_axis_keep,
  output [0:0]                             m_axis_user,
  output                                   m_axis_last
);

  //   src = s_axis_* = wr
  //   dst = m_axis_* = rd
  //

  localparam RAM_LATENCY = 2;

  localparam SRC_ADDR_ALIGN = $clog2(SRC_DATA_WIDTH/8);
  localparam DST_ADDR_ALIGN = $clog2(DST_DATA_WIDTH/8);

  localparam SRC_ADDRESS_WIDTH = LENGTH_WIDTH - SRC_ADDR_ALIGN;
  localparam DST_ADDRESS_WIDTH = LENGTH_WIDTH - DST_ADDR_ALIGN;

  wire  wr_enable;
  wire  [DST_DATA_WIDTH-1:0] rd_data;
  wire  [1:0] rd_fifo_room;
  wire        rd_enable;
  wire        rd_last_beat;
  wire        rd_fifo_s_ready;
  wire        rd_fifo_s_valid;

  reg [SRC_ADDRESS_WIDTH-1:0] wr_length = 'h0;
  reg [SRC_ADDRESS_WIDTH-1:0] wr_addr = 'h0;
  reg [DST_DATA_WIDTH-1:0]    rd_data_l2 = 'h0;
  reg [DST_ADDRESS_WIDTH-1:0] rd_length = 'h0;
  reg [DST_ADDRESS_WIDTH-1:0] rd_addr = 'h0;
  reg rd_pending = 1'b0;

  always @(posedge s_axis_aclk) begin
    if (~s_axis_aresetn)
      wr_request_ready <= 1'b1;
    else if (wr_request_valid)
      wr_request_ready <= 1'b0;
    else if (wr_response_eot)
      wr_request_ready <= 1'b1;
  end

  always @(posedge s_axis_aclk) begin
    if (wr_request_valid & wr_request_ready)
      wr_length <= wr_request_length[LENGTH_WIDTH-1:SRC_ADDR_ALIGN];
    end

  wire wr_last_beat;
  assign wr_last_beat = s_axis_valid & s_axis_ready & ((wr_addr == wr_length) | s_axis_last);

  always @(posedge s_axis_aclk) begin
    if (~wr_request_enable)
      s_axis_ready <= 1'b0;
    else if (wr_request_valid & wr_request_ready)
      s_axis_ready <= 1'b1;
    else if (wr_last_beat) begin
      s_axis_ready <= 1'b0;
    end
  end

  always @(posedge s_axis_aclk) begin
    if (s_axis_valid & s_axis_ready)
      wr_response_eot <= s_axis_last | (wr_addr == wr_length);
    else
      wr_response_eot <= 1'b0;
  end

  always @(posedge s_axis_aclk) begin
    if (wr_last_beat)
      wr_response_measured_length <= {wr_addr, {SRC_ADDR_ALIGN{1'b1}}};
  end

  reg wr_full = 1'b0;
  // Protect against larger transfers than storage
  always @(posedge s_axis_aclk) begin
    if (wr_request_valid & wr_request_ready)
      wr_full <= 1'b0;
    else if (&wr_addr & (s_axis_valid & s_axis_ready))
      wr_full <= 1'b1;
  end

  // Do not roll over write address
  always @(posedge s_axis_aclk) begin
    if (~wr_request_enable | wr_last_beat)
      wr_addr <= 'h0;
    else if (s_axis_valid & s_axis_ready & (~(&wr_addr)))
      wr_addr <= wr_addr + 1;
  end
  assign wr_enable = s_axis_valid & s_axis_ready & ~wr_full;

  ad_mem_asym #(
    .A_ADDRESS_WIDTH (SRC_ADDRESS_WIDTH),
    .A_DATA_WIDTH (SRC_DATA_WIDTH),
    .B_ADDRESS_WIDTH (DST_ADDRESS_WIDTH),
    .B_DATA_WIDTH (DST_DATA_WIDTH)
  ) i_mem (
    .clka (s_axis_aclk),
    .wea (wr_enable),
    .addra (wr_addr),
    .dina (s_axis_data),

    .clkb (m_axis_aclk),
    .reb (1'b1),
    .addrb (rd_addr),
    .doutb (rd_data));

  reg rd_active = 1'b0;
  reg [1:0] rd_req_cnt = 2'b0;
  always @(posedge m_axis_aclk) begin
    if (~rd_request_enable)
      rd_req_cnt <= 2'b0;
    else if (rd_request_valid & rd_request_ready)
      rd_req_cnt <= rd_req_cnt + 2'b1;
    else if (rd_response_eot)
      rd_req_cnt <= rd_req_cnt - 2'b1;
  end

  assign rd_request_ready = ~rd_req_cnt[1];

  always @(posedge m_axis_aclk) begin
    if (rd_request_valid & rd_request_ready)
      rd_length <= rd_request_length[LENGTH_WIDTH-1:DST_ADDR_ALIGN];
  end

  wire rd_early_finish;

  assign rd_early_finish = rd_active & ~rd_request_enable;
  assign rd_last_beat = (rd_addr == rd_length) & rd_enable;
  assign rd_response_eot = (m_axis_last & m_axis_valid & m_axis_ready) || rd_early_finish;

  // Read logic
  always @(posedge m_axis_aclk) begin
    if (~rd_request_enable)
      rd_active <= 1'b0;
    else if (rd_request_valid & rd_request_ready)
      rd_active <= 1'b1;
    else if (rd_last_beat)
      rd_active <= rd_req_cnt == 2;
  end

  assign rd_enable = rd_fifo_s_ready & rd_active &
      (rd_fifo_room >= (m_axis_valid&m_axis_ready ? 1 : RAM_LATENCY));

  always @(posedge m_axis_aclk) begin
    if (~rd_request_enable | rd_last_beat)
      rd_addr <= 'h0;
    else if (rd_enable)
      rd_addr <= rd_addr + 1;
  end

  // Delay read enable with latency cycles
  // <TODO> make this depend on parameter
  reg rd_valid_l1 = 1'b0;
  reg rd_valid_l2 = 1'b0;
  reg rd_last_l1 = 1'b0;
  reg rd_last_l2 = 1'b0;
  always @(posedge m_axis_aclk) begin
    rd_valid_l1 <= rd_enable;
    rd_last_l1 <= rd_last_beat;
  end

  // Extra pipeline to be sucked in by the BRAM/URAM output stage
  always @(posedge m_axis_aclk) begin
    if (rd_valid_l1)
      rd_data_l2 <= rd_data;
   end

   always @(posedge m_axis_aclk) begin
    if (rd_valid_l1)
      rd_valid_l2 <= 1'b1;
    else if (rd_fifo_s_ready)
      rd_valid_l2 <= 1'b0;

    if (rd_valid_l1)
      rd_last_l2 <= rd_last_l1;
  end

  assign rd_fifo_s_valid = rd_valid_l2;

  // Read datapath to AXIS logic
  util_axis_fifo #(
    .DATA_WIDTH(DST_DATA_WIDTH+1),
    .ADDRESS_WIDTH(2),
    .ASYNC_CLK(0),
    .M_AXIS_REGISTERED(0)
  ) i_rd_fifo (
    .s_axis_aclk(m_axis_aclk),
    .s_axis_aresetn(m_axis_aresetn & rd_request_enable),
    .s_axis_valid(rd_fifo_s_valid),
    .s_axis_ready(rd_fifo_s_ready),
    .s_axis_full(),
    .s_axis_data({rd_last_l2,rd_data_l2}),
    .s_axis_room(rd_fifo_room),
    .s_axis_tkeep(),
    .s_axis_tlast(),
    .s_axis_almost_full(),

    .m_axis_aclk(m_axis_aclk),
    .m_axis_aresetn(m_axis_aresetn & rd_request_enable),
    .m_axis_valid(m_axis_valid),
    .m_axis_ready(m_axis_ready),
    .m_axis_data({m_axis_last,m_axis_data}),
    .m_axis_level(),
    .m_axis_empty(),
    .m_axis_tkeep(),
    .m_axis_tlast(),
    .m_axis_almost_empty());

endmodule
