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

// Join FIFO.
//
// NUM_CHANNELS converter channels deliver words on their own clocks, all at
// the same rate: the clocks must come from one source, only on separate
// distribution paths, as clocks from independent sources drift apart and a
// FIFO then overflows now and then. Each channel writes into a small FIFO, and the output, on
// out_clk, takes one word of every channel only when each has one, so the n-th
// words of all channels always leave together. Synchronized channels are at
// most one word apart; the FIFO depth covers that and the clock domain
// crossing with margin. When a channel stops, the output stops and the FIFOs
// of the others drop their new words once full.
//
// async_resetn low empties all FIFOs. It is asynchronous, as it works while
// the clocks are stopped, e.g. with the sync_n of converters that also stops
// the divided clocks; the counting then restarts from the first word after
// the converters restart, and the FIFOs stay in reset for a few cycles after
// the clocks restart. A reset of any channel also empties all FIFOs.
//
// Channel i uses bit i of clk, reset and valid, and word i of data and
// out_data. out_data is only valid in the cycles out_valid is set.
//
// The channel enables and the overflow of the sink cross along: bit i of
// enable, on clk[i], is bit i of out_enable on out_clk, and an out_overflow
// pulse on out_clk is a pulse of every bit of overflow on its channel clock.
// A word that channel i drops because its own FIFO is full pulses bit i too;
// with OVERFLOW_XFER_REQ set only while xfer_req is high. With
// CHANNEL_ENABLE_XFER_HOLD set, out_enable keeps its value while xfer_req is
// high, so a transfer never sees a channel come or go.
//
// xfer_req is the transfer request of the sink, on out_clk, used with
// XFER_REQ_ENABLE set; otherwise it reads as 1. While it is low the
// words are dropped instead of sent, and out_reset holds the packer, so a
// capture starts from the words that arrive after the request. Dropping
// follows the same rule as sending, one word of every channel at a time, as
// emptying the FIFOs at a given moment would drop a different number of
// words on channels that are not exactly in step.
//
// Any number of channels; util_sample_join_fifo wraps it with separate ports
// for up to 64 channels.

`timescale 1ns/100ps

module ad_sample_join_fifo #(
  parameter NUM_CHANNELS = 2,
  parameter DATA_WIDTH = 32,
  parameter ADDRESS_WIDTH = 4,
  parameter XFER_REQ_ENABLE = 0,
  parameter OVERFLOW_XFER_REQ = 0,
  parameter CHANNEL_ENABLE_XFER_HOLD = 0
) (
  input                                  async_resetn,
  input                                  xfer_req,

  input      [NUM_CHANNELS-1:0]            clk,
  input      [NUM_CHANNELS-1:0]            reset,
  input      [NUM_CHANNELS-1:0]            valid,
  input      [NUM_CHANNELS*DATA_WIDTH-1:0] data,
  input      [NUM_CHANNELS-1:0]            enable,
  output     [NUM_CHANNELS-1:0]            overflow,

  input                                  out_clk,
  output                                 out_reset,
  output reg                             out_valid = 1'b0,
  output reg [NUM_CHANNELS*DATA_WIDTH-1:0] out_data = 'd0,
  output     [NUM_CHANNELS-1:0]            out_enable,
  input                                  out_overflow
);

  localparam N  = NUM_CHANNELS;
  localparam DW = DATA_WIDTH;
  localparam AW = ADDRESS_WIDTH;

  (* ASYNC_REG = "TRUE" *) reg [3:0] out_rst = 4'hf;

  wire            out_resetn = ~out_rst[3];
  wire [N-1:0]    resetn;
  // ok: the FIFO of a channel has a word for the next pop, registered so pop is a single AND
  wire [N-1:0]    ok;
  wire [DW*N-1:0] r_data;
  wire [N-1:0]    reset_s;

  reg             reset_any = 1'b1;
  reg             xfer_req_d = 1'b0;

  wire            pop = &ok;

  assign out_reset = ~out_resetn | ~xfer_req_d;

  // a reset of any channel empties all FIFOs, so the words stay aligned; the
  // resets meet on out_clk and go back to every channel from there

  sync_bits #(
    .NUM_OF_BITS(N),
    .ASYNC_CLK(1)
  ) i_reset_sync (
    .in_bits(reset),
    .out_resetn(1'b1),
    .out_clk(out_clk),
    .out_bits(reset_s));

  always @(posedge out_clk) begin
    reset_any  <= |reset_s;
    xfer_req_d <= (XFER_REQ_ENABLE == 0) || xfer_req;
  end

  wire [N-1:0]    enable_s;
  reg  [N-1:0]    enable_h = 'd0;

  sync_bits #(
    .NUM_OF_BITS(N),
    .ASYNC_CLK(1)
  ) i_enable_sync (
    .in_bits(enable),
    .out_resetn(1'b1),
    .out_clk(out_clk),
    .out_bits(enable_s));

  always @(posedge out_clk) begin
    if (~xfer_req_d) enable_h <= enable_s;
  end

  assign out_enable = (CHANNEL_ENABLE_XFER_HOLD != 0 && XFER_REQ_ENABLE != 0) ? enable_h : enable_s;

  always @(posedge out_clk or negedge async_resetn) begin
    if (~async_resetn) begin
      out_rst <= 4'hf;
    end else begin
      out_rst <= {out_rst[2:0], reset_any};
    end
  end

  // FIFOs, written on the channel clock and read on out_clk. The memory has
  // only the write clock and an asynchronous read, so no cell is clocked by
  // two regional clocks, and the clock regions of the channels stay
  // independent. Gray pointers cross the clock domains.

  genvar i;
  generate
  for (i = 0; i < N; i = i + 1) begin : g_ch

    (* ASYNC_REG = "TRUE" *) reg [3:0] rst = 4'hf;
    wire                  rst_in;

    reg  [DW-1:0]         mem [0:2**AW-1];
    reg  [AW:0]           w_bin  = 'd0;
    reg  [AW:0]           w_gray = 'd0;
    reg  [AW:0]           r_bin  = 'd0;
    reg  [AW:0]           r_gray = 'd0;
    wire [AW:0]           w_gray_s;
    wire [AW:0]           r_gray_s;
    wire [AW:0]           w_bin_nx = w_bin + 1'b1;
    wire [AW:0]           r_bin_nx = r_bin + 1'b1;
    wire                  full = (w_gray == {~r_gray_s[AW:AW-1], r_gray_s[AW-2:0]});
    wire                  wr   = valid[i] & ~full;

    sync_bits #(
      .NUM_OF_BITS(1),
      .ASYNC_CLK(1)
    ) i_reset_sync (
      .in_bits(reset_any),
      .out_resetn(1'b1),
      .out_clk(clk[i]),
      .out_bits(rst_in));

    wire                  sink_ovf;
    reg                   ovf_r = 1'b0;

    sync_event #(
      .NUM_OF_EVENTS(1),
      .ASYNC_CLK(1)
    ) i_overflow_sync (
      .in_clk(out_clk),
      .in_event(out_overflow),
      .out_clk(clk[i]),
      .out_event(sink_ovf));

    // xfer_req on the channel clock, for the local overflow
    wire                  xfer_req_s;

    if (OVERFLOW_XFER_REQ != 0) begin : g_ovf_req
      sync_bits #(
        .NUM_OF_BITS(1),
        .ASYNC_CLK(1)
      ) i_xfer_sync (
        .in_bits(xfer_req_d),
        .out_resetn(1'b1),
        .out_clk(clk[i]),
        .out_bits(xfer_req_s));
    end else begin : g_ovf_all
      assign xfer_req_s = 1'b1;
    end

    always @(posedge clk[i]) begin
      ovf_r <= sink_ovf | (valid[i] & full & resetn[i] & xfer_req_s);
    end

    assign overflow[i] = ovf_r;

    always @(posedge clk[i] or negedge async_resetn) begin
      if (~async_resetn) begin
        rst <= 4'hf;
      end else begin
        rst <= {rst[2:0], rst_in};
      end
    end

    assign resetn[i] = ~rst[3];

    always @(posedge clk[i]) begin
      if (wr) begin
        mem[w_bin[AW-1:0]] <= data[DW*i +: DW];
      end
    end

    always @(posedge clk[i]) begin
      if (~resetn[i]) begin
        w_bin  <= 'd0;
        w_gray <= 'd0;
      end else if (wr) begin
        w_bin  <= w_bin_nx;
        w_gray <= w_bin_nx ^ (w_bin_nx >> 1);
      end
    end

    sync_bits #(
      .NUM_OF_BITS(AW+1),
      .ASYNC_CLK(1)
    ) i_w_gray_sync (
      .in_bits(w_gray),
      .out_resetn(out_resetn),
      .out_clk(out_clk),
      .out_bits(w_gray_s));

    sync_bits #(
      .NUM_OF_BITS(AW+1),
      .ASYNC_CLK(1)
    ) i_r_gray_sync (
      .in_bits(r_gray),
      .out_resetn(resetn[i]),
      .out_clk(clk[i]),
      .out_bits(r_gray_s));

    always @(posedge out_clk) begin
      if (~out_resetn) begin
        r_bin  <= 'd0;
        r_gray <= 'd0;
      end else if (pop) begin
        r_bin  <= r_bin_nx;
        r_gray <= r_bin_nx ^ (r_bin_nx >> 1);
      end
    end

    // w_bin_s: the synchronized write pointer in binary, one cycle behind, which only delays ok.
    reg  [AW:0] w_bin_s = 'd0;
    reg         ok_r = 1'b0;
    reg  [AW:0] w_bin_c;
    integer     b;

    always @(*) begin
      w_bin_c[AW] = w_gray_s[AW];
      for (b = AW-1; b >= 0; b = b - 1)
        w_bin_c[b] = w_bin_c[b+1] ^ w_gray_s[b];
    end

    // fill: words in the FIFO before this cycle's pop
    wire [AW:0] fill = w_bin_s - r_bin;

    always @(posedge out_clk) begin
      if (~out_resetn) begin
        w_bin_s <= 'd0;
        ok_r    <= 1'b0;
      end else begin
        w_bin_s <= w_bin_c;
        ok_r    <= pop ? (fill >= 2) : (fill >= 1);
      end
    end

    assign ok[i]              = ok_r;
    assign r_data[DW*i +: DW] = mem[r_bin[AW-1:0]];

  end
  endgenerate

  // dropped right away by async_resetn, as the stopped clock would hold it
  // without xfer_req the words are taken and dropped, so the FIFOs stay
  // nearly empty and the channels stay aligned
  always @(posedge out_clk or posedge out_reset) begin
    if (out_reset) begin
      out_valid <= 1'b0;
    end else begin
      out_valid <= pop & xfer_req_d;
    end
  end

  // loaded every cycle, valid with out_valid only; a clock enable would load pop with every data bit
  always @(posedge out_clk) begin
    out_data <= r_data;
  end

endmodule
