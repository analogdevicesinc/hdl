// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
//
// SPDX short identifier: ADIBSD
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

// The apollo_som_vu11p TX chain, from the upack read port to the DAC transport
// layer: upack (power of two wide, because its s_axis comes from the data
// offload) -> lookahead FIFO -> per channel gearbox -> transport layer.
//
// Two things need proving, and neither is obvious from the gearbox alone:
//
//   1. The DAC side never sees a bubble.  The transport layer cannot be
//      backpressured, so a cycle where dac_valid is high and the gearbox has
//      nothing is a corrupted sample.  512 -> 384 gives m_axis_valid every
//      cycle only if the gearbox is fed every cycle it asks, and upack answers
//      a request one cycle late without holding it, so the FIFO has to cover
//      that latency.  Wiring upack's fifo_rd_en straight to the gearbox
//      s_axis_ready instead does produce bubbles - see the NO_LOOKAHEAD
//      negative control below.
//
//   2. The two channels stay sample aligned.  They share one FIFO precisely so
//      that they see the same valid and the same ready; this checks that they
//      really do advance together and that each output beat is the next 24
//      samples of that channel, in order.

module tx_chain_tb;

  parameter VCD_FILE = {"tx_chain_tb.vcd"};

  // L=12 M=2 S=3 NP=16: upack emits 32 samples per channel, the transport
  // layer takes 24.
  localparam SW = 16;
  localparam CHANNELS = 2;
  localparam PACK_SAMPLES = 32;
  localparam TPL_SAMPLES = 24;
  localparam PACK_DW = SW * PACK_SAMPLES;
  localparam TPL_DW = SW * TPL_SAMPLES;
  localparam BUS_DW = PACK_DW * CHANNELS;

  `include "../../common/tb/tb_base.v"

  // Sample n of channel c, so a misrouted beat cannot look correct.
  function [SW-1:0] sample;
    input integer c;
    input integer n;
    sample = {c[0], n[SW-2:0]};
  endfunction

  // ---------------------------------------------------------------- upack
  //
  // util_upack2_impl.v:126-145 verbatim in behaviour: fifo_rd_data and
  // fifo_rd_valid are registers that only update when fifo_rd_en was high on
  // the previous edge, and fifo_rd_valid falls to zero when it was not.  There
  // is no hold, so whoever asked has to be able to take the answer.
  wire              rd_en;
  reg               rd_valid = 1'b0;
  reg  [BUS_DW-1:0] rd_data = {BUS_DW{1'b0}};
  reg  [31:0]       rd_word = 32'd0;

  reg  [BUS_DW-1:0] next_data;
  integer c, j;
  always @(*) begin
    for (c = 0; c < CHANNELS; c = c + 1)
      for (j = 0; j < PACK_SAMPLES; j = j + 1)
        next_data[c*PACK_DW + j*SW +: SW] = sample(c, rd_word*PACK_SAMPLES + j);
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      rd_valid <= 1'b0;
      rd_word <= 32'd0;
    end else if (rd_en == 1'b1) begin
      rd_valid <= 1'b1;
      rd_data <= next_data;
      rd_word <= rd_word + 1;
    end else begin
      rd_valid <= 1'b0;
    end
  end

  // ------------------------------------------------------- lookahead FIFO
  wire              fifo_s_ready;
  wire              fifo_s_almost_full;
  wire              fifo_m_valid;
  wire              fifo_m_ready;
  wire [BUS_DW-1:0] fifo_m_data;

  // Negative control: skip the FIFO and let the gearbox pull upack directly,
  // which is the wiring the FIFO exists to avoid.
  wire              gb_in_valid;
  wire [BUS_DW-1:0] gb_in_data;
`ifdef NO_LOOKAHEAD
  assign rd_en = gb_s_ready[0];
  assign gb_in_valid = rd_valid;
  assign gb_in_data = rd_data;
`else
  assign rd_en = ~fifo_s_almost_full;
  assign gb_in_valid = fifo_m_valid;
  assign gb_in_data = fifo_m_data;
`endif

  util_axis_fifo #(
    .DATA_WIDTH (BUS_DW),
    .ADDRESS_WIDTH (3),
    .ASYNC_CLK (0),
    .ALMOST_FULL_THRESHOLD (2)
  ) i_fifo (
    .s_axis_aclk (clk),
    .s_axis_aresetn (~reset),
    .s_axis_valid (rd_valid),
    .s_axis_ready (fifo_s_ready),
    .s_axis_data (rd_data),
    .s_axis_tkeep ({BUS_DW/8{1'b1}}),
    .s_axis_tlast (1'b0),
    .s_axis_room (),
    .s_axis_full (),
    .s_axis_almost_full (fifo_s_almost_full),

    .m_axis_aclk (clk),
    .m_axis_aresetn (~reset),
    .m_axis_ready (fifo_m_ready),
    .m_axis_valid (fifo_m_valid),
    .m_axis_data (fifo_m_data),
    .m_axis_tkeep (),
    .m_axis_tlast (),
    .m_axis_level (),
    .m_axis_empty (),
    .m_axis_almost_empty ());

  // ----------------------------------------------------------- gearboxes
  reg  dac_valid = 1'b1;

  wire [CHANNELS-1:0]       gb_s_ready;
  wire [CHANNELS-1:0]       gb_m_valid;
  wire [CHANNELS*TPL_DW-1:0] gb_m_data;

  genvar i;
  generate
  for (i = 0; i < CHANNELS; i = i + 1) begin : g_ch
    util_axis_gearbox #(
      .S_DATA_WIDTH (PACK_DW),
      .M_DATA_WIDTH (TPL_DW)
    ) i_gearbox (
      .clk (clk),
      .resetn (~reset),
      .s_axis_valid (gb_in_valid),
      .s_axis_ready (gb_s_ready[i]),
      .s_axis_data (gb_in_data[i*PACK_DW +: PACK_DW]),
      .m_axis_valid (gb_m_valid[i]),
      .m_axis_ready (dac_valid),
      .m_axis_data (gb_m_data[i*TPL_DW +: TPL_DW]));
  end
  endgenerate

  // Channel 0 speaks for all of them; they are identical and see the same
  // handshake, which is the whole point of the shared FIFO.
  assign fifo_m_ready = gb_s_ready[0];

  // ------------------------------------------------------------- checking
  reg [31:0] out_count [CHANNELS-1:0];
  reg [31:0] beats = 32'd0;
  reg [31:0] bubbles = 32'd0;
  reg [31:0] ready_skew = 32'd0;
  reg [31:0] valid_skew = 32'd0;
  reg        started = 1'b0;

  reg [TPL_DW-1:0] expected;
  integer k, ch;

  initial begin
    for (k = 0; k < CHANNELS; k = k + 1)
      out_count[k] = 32'd0;
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      for (k = 0; k < CHANNELS; k = k + 1)
        out_count[k] <= 32'd0;
      started <= 1'b0;
    end else begin
      // The gearboxes must agree, cycle by cycle - a single disagreement means
      // the channels can slip and I/Q come from different times.
      if (gb_s_ready[0] !== gb_s_ready[1]) ready_skew <= ready_skew + 1;
      if (gb_m_valid[0] !== gb_m_valid[1]) valid_skew <= valid_skew + 1;

      if (dac_valid == 1'b1 && gb_m_valid[0] == 1'b1) begin
        started <= 1'b1;
        beats <= beats + 1;
        for (ch = 0; ch < CHANNELS; ch = ch + 1) begin
          for (j = 0; j < TPL_SAMPLES; j = j + 1)
            expected[j*SW +: SW] = sample(ch, out_count[ch] + j);
          if (gb_m_data[ch*TPL_DW +: TPL_DW] !== expected) begin
            if (failed == 1'b0)
              $display("ERROR ch%0d beat %0d sample %0d: got %h expected %h",
                       ch, beats, out_count[ch],
                       gb_m_data[ch*TPL_DW +: TPL_DW], expected);
            failed <= 1'b1;
          end
          out_count[ch] <= out_count[ch] + TPL_SAMPLES;
        end
      end else if (dac_valid == 1'b1 && started == 1'b1) begin
        // The transport layer asked and got nothing.
        bubbles <= bubbles + 1;
      end
    end
  end

  // -------------------------------------------------------------- stimulus
  initial begin
    do_trigger_reset;
    // Free run: dac_valid high throughout, which is how the transport layer
    // behaves once the link is up.
    repeat (2000) @(posedge clk);

    $display("beats=%0d bubbles=%0d ready_skew=%0d valid_skew=%0d ch0=%0d ch1=%0d",
             beats, bubbles, ready_skew, valid_skew, out_count[0], out_count[1]);

    if (bubbles != 32'd0) begin
      $display("ERROR %0d bubble(s) on the DAC side", bubbles);
      failed <= 1'b1;
    end
    if (ready_skew != 32'd0 || valid_skew != 32'd0) begin
      $display("ERROR channels out of lockstep");
      failed <= 1'b1;
    end
    if (out_count[0] != out_count[1]) begin
      $display("ERROR channel sample counts differ");
      failed <= 1'b1;
    end
    if (beats < 32'd1000) begin
      $display("ERROR only %0d beats in 2000 cycles - the chain is not keeping up", beats);
      failed <= 1'b1;
    end

    if (failed == 1'b0)
      $display("SUCCESS");
    else
      $display("FAILED");
    $finish;
  end

endmodule
