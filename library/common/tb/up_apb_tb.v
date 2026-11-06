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

// up_apb: every APB transfer gives exactly one up_wreq or up_rreq pulse with
// the right address and data, as up_axi does, for a pcore that acks one or
// more cycles after the request, directly and behind util_apb_pipe_stage,
// with back-to-back transfers and idle gaps.

module up_apb_tb;
  parameter VCD_FILE = "up_apb_tb.vcd";

  `include "tb_base.v"

  wire [3:0] chain_fail;
  wire [3:0] chain_done;

  up_apb_tb_chain #(.USE_PIPE (0), .ACK_LATENCY (1), .SEED (1)) i_direct_ack1 (
    .clk (clk), .reset (reset), .fail (chain_fail[0]), .done (chain_done[0]));
  up_apb_tb_chain #(.USE_PIPE (0), .ACK_LATENCY (3), .SEED (2)) i_direct_ack3 (
    .clk (clk), .reset (reset), .fail (chain_fail[1]), .done (chain_done[1]));
  up_apb_tb_chain #(.USE_PIPE (1), .ACK_LATENCY (1), .SEED (3)) i_pipe_ack1 (
    .clk (clk), .reset (reset), .fail (chain_fail[2]), .done (chain_done[2]));
  up_apb_tb_chain #(.USE_PIPE (1), .ACK_LATENCY (3), .SEED (4)) i_pipe_ack3 (
    .clk (clk), .reset (reset), .fail (chain_fail[3]), .done (chain_done[3]));

  always @(posedge clk) begin
    failed <= failed | (|chain_fail);
  end

  initial begin
    wait (&chain_done);
    if (failed == 1'b0)
      $display("up_apb_tb: all transfers gave one request each");
  end

endmodule

// APB master, optional util_apb_pipe_stage, up_apb and a pcore model with a
// registered ack (ACK_LATENCY cycles after the request, read data with it).

module up_apb_tb_chain #(
  parameter USE_PIPE = 0,
  parameter ACK_LATENCY = 1,
  parameter SEED = 1,
  parameter NUM_TRANSFERS = 64
) (
  input       clk,
  input       reset,
  output  reg fail = 1'b0,
  output  reg done = 1'b0
);

  localparam AW = 16;

  // master side
  reg   [AW-1:0]  m_paddr = 'd0;
  reg             m_psel = 1'b0;
  reg             m_penable = 1'b0;
  reg             m_pwrite = 1'b0;
  reg   [31:0]    m_pwdata = 'd0;
  wire  [31:0]    m_prdata;
  wire            m_pready;
  wire            m_pslverr;

  // up_apb side
  wire  [AW-1:0]  s_paddr;
  wire            s_psel;
  wire            s_penable;
  wire            s_pwrite;
  wire  [31:0]    s_pwdata;
  wire  [31:0]    s_prdata;
  wire            s_pready;
  wire            s_pslverr;

  // pcore interface
  wire            up_wreq;
  wire  [AW-3:0]  up_waddr;
  wire  [31:0]    up_wdata;
  wire            up_wack;
  wire            up_rreq;
  wire  [AW-3:0]  up_raddr;
  wire  [31:0]    up_rdata;
  wire            up_rack;

  generate
  if (USE_PIPE != 0) begin: g_pipe
    util_apb_pipe_stage #(
      .ADDRESS_WIDTH (AW),
      .DATA_WIDTH (32)
    ) i_pipe (
      .clk (clk),
      .resetn (~reset),
      .s_apb_paddr (m_paddr),
      .s_apb_psel (m_psel),
      .s_apb_penable (m_penable),
      .s_apb_pwrite (m_pwrite),
      .s_apb_pwdata (m_pwdata),
      .s_apb_prdata (m_prdata),
      .s_apb_pready (m_pready),
      .s_apb_pslverr (m_pslverr),
      .m_apb_paddr (s_paddr),
      .m_apb_psel (s_psel),
      .m_apb_penable (s_penable),
      .m_apb_pwrite (s_pwrite),
      .m_apb_pwdata (s_pwdata),
      .m_apb_prdata (s_prdata),
      .m_apb_pready (s_pready),
      .m_apb_pslverr (s_pslverr));
  end else begin: g_direct
    assign s_paddr = m_paddr;
    assign s_psel = m_psel;
    assign s_penable = m_penable;
    assign s_pwrite = m_pwrite;
    assign s_pwdata = m_pwdata;
    assign m_prdata = s_prdata;
    assign m_pready = s_pready;
    assign m_pslverr = s_pslverr;
  end
  endgenerate

  up_apb #(
    .APB_ADDRESS_WIDTH (AW)
  ) i_up_apb (
    .up_apb_presetn (~reset),
    .up_apb_clk (clk),
    .up_apb_paddr (s_paddr),
    .up_apb_penable (s_penable),
    .up_apb_prdata (s_prdata),
    .up_apb_pready (s_pready),
    .up_apb_pselx (s_psel),
    .up_apb_pslverr (s_pslverr),
    .up_apb_pwdata (s_pwdata),
    .up_apb_pwrite (s_pwrite),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

  // pcore model: counts the requests, keeps the last write, acks
  // ACK_LATENCY cycles after the request; the read data is valid with the
  // ack only (zero otherwise), as the ADI register maps do

  function [31:0] rdata_of;
    input [AW-3:0] addr;
    rdata_of = {16'hca5e, 2'b00, addr};
  endfunction

  integer         wreq_count = 0;
  integer         rreq_count = 0;
  reg   [AW-3:0]  last_waddr = 'd0;
  reg   [31:0]    last_wdata = 'd0;

  reg   [ACK_LATENCY-1:0] wack_d = 'd0;
  reg   [ACK_LATENCY-1:0] rack_d = 'd0;
  reg   [31:0]            rdata_d [0:ACK_LATENCY-1];

  integer         n;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      wack_d <= 'd0;
      rack_d <= 'd0;
    end else begin
      wack_d <= {wack_d, up_wreq};
      rack_d <= {rack_d, up_rreq};
    end
    rdata_d[0] <= (up_rreq == 1'b1) ? rdata_of(up_raddr) : 32'd0;
    for (n = 1; n < ACK_LATENCY; n = n + 1) begin
      rdata_d[n] <= rdata_d[n-1];
    end
    if (up_wreq == 1'b1) begin
      wreq_count <= wreq_count + 1;
      last_waddr <= up_waddr;
      last_wdata <= up_wdata;
    end
    if (up_rreq == 1'b1) begin
      rreq_count <= rreq_count + 1;
    end
  end

  assign up_wack = wack_d[ACK_LATENCY-1];
  assign up_rack = rack_d[ACK_LATENCY-1];
  assign up_rdata = rdata_d[ACK_LATENCY-1];

  // master

  task apb_transfer;
    input             write;
    input   [AW-1:0]  addr;
    input   [31:0]    wdata;
    output  [31:0]    rdata;
  begin
    // setup phase
    m_psel <= 1'b1;
    m_penable <= 1'b0;
    m_pwrite <= write;
    m_paddr <= addr;
    m_pwdata <= wdata;
    @(posedge clk);
    // access phase until pready
    m_penable <= 1'b1;
    @(posedge clk);
    while (m_pready !== 1'b1) @(posedge clk);
    rdata = m_prdata;
    m_psel <= 1'b0;
    m_penable <= 1'b0;
  end
  endtask

  task check;
    input         ok;
    input [255:0] what;
  begin
    if (ok !== 1'b1) begin
      $display("up_apb_tb: pipe %0d ack %0d: %0s failed at %0t", USE_PIPE, ACK_LATENCY, what, $time);
      fail <= 1'b1;
    end
  end
  endtask

  integer         i;
  integer         gap;
  integer         seed;
  integer         wreq_expected;
  integer         rreq_expected;
  reg   [AW-1:0]  addr;
  reg   [31:0]    wdata;
  reg   [31:0]    rdata;

  initial begin
    seed = SEED;
    wreq_expected = 0;
    rreq_expected = 0;
    @(negedge reset);
    repeat (4) @(posedge clk);
    for (i = 0; i < NUM_TRANSFERS; i = i + 1) begin
      addr = {$random(seed)} & 16'hfffc;
      wdata = $random(seed);

      apb_transfer(1'b1, addr, wdata, rdata);
      wreq_expected = wreq_expected + 1;
      @(negedge clk);
      check(wreq_count == wreq_expected, "one up_wreq per write");
      check(rreq_count == rreq_expected, "no up_rreq on a write");
      check(last_waddr == addr[AW-1:2], "write address");
      check(last_wdata == wdata, "write data");

      // gap 0: back-to-back (the setup phase is driven right after the
      // completion, so it is the first thing the slave samples); else idle
      gap = {$random(seed)} % 3;
      repeat (gap) @(posedge clk);

      apb_transfer(1'b0, addr, 32'd0, rdata);
      rreq_expected = rreq_expected + 1;
      check(rdata == rdata_of(addr[AW-1:2]), "read data");
      @(negedge clk);
      check(rreq_count == rreq_expected, "one up_rreq per read");
      check(wreq_count == wreq_expected, "no up_wreq on a read");

      gap = {$random(seed)} % 3;
      repeat (gap) @(posedge clk);
    end
    // no late requests after the last transfer
    repeat (8) @(posedge clk);
    check(wreq_count == wreq_expected, "no late up_wreq");
    check(rreq_count == rreq_expected, "no late up_rreq");
    $display("up_apb_tb: pipe %0d ack %0d: %0d writes, %0d reads, %0d up_wreq, %0d up_rreq",
      USE_PIPE, ACK_LATENCY, wreq_expected, rreq_expected, wreq_count, rreq_count);
    done <= 1'b1;
  end

endmodule
