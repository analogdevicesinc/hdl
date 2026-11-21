// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2021-2026 Analog Devices, Inc. All rights reserved.
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
`timescale 1ns/1ps

module util_axis_fifo_asym #(
  parameter ASYNC_CLK = 1,
  parameter S_DATA_WIDTH = 64,
  parameter ADDRESS_WIDTH = 5,
  parameter M_DATA_WIDTH = 128,
  parameter M_AXIS_REGISTERED = 1,
  parameter ALMOST_EMPTY_THRESHOLD = 4,
  parameter ALMOST_FULL_THRESHOLD = 4,
  parameter TLAST_EN = 0,
  parameter TKEEP_EN = 0,
  parameter REDUCED_FIFO = 1,
  parameter SRC_REG_SLICE_EN = 0
) (
  input m_axis_aclk,
  input m_axis_aresetn,
  input m_axis_ready,
  output m_axis_valid,
  output [M_DATA_WIDTH-1:0] m_axis_data,
  output [M_DATA_WIDTH/8-1:0] m_axis_tkeep,
  output m_axis_tlast,
  output m_axis_empty,
  output m_axis_almost_empty,
  output [ADDRESS_WIDTH-1:0] m_axis_level,

  input s_axis_aclk,
  input s_axis_aresetn,
  output s_axis_ready,
  input s_axis_valid,
  input [S_DATA_WIDTH-1:0] s_axis_data,
  input [S_DATA_WIDTH/8-1:0] s_axis_tkeep,
  input s_axis_tlast,
  output s_axis_full,
  output s_axis_almost_full,
  output [ADDRESS_WIDTH-1:0] s_axis_room
);

  // define which interface has a wider bus
  localparam RATIO_TYPE = (S_DATA_WIDTH >= M_DATA_WIDTH) ? 1 : 0;

  // bus width ratio
  localparam RATIO = (RATIO_TYPE) ? S_DATA_WIDTH/M_DATA_WIDTH : M_DATA_WIDTH/S_DATA_WIDTH;

  // atomic parameters
  localparam A_WIDTH = (RATIO_TYPE) ? M_DATA_WIDTH : S_DATA_WIDTH;
  localparam A_ADDRESS = (REDUCED_FIFO) ? (ADDRESS_WIDTH-$clog2(RATIO)) : ADDRESS_WIDTH;
  localparam A_ALMOST_FULL_THRESHOLD = (REDUCED_FIFO) ? ((ALMOST_FULL_THRESHOLD+RATIO-1)/RATIO) : ALMOST_FULL_THRESHOLD;
  localparam A_ALMOST_EMPTY_THRESHOLD = (REDUCED_FIFO) ? ((ALMOST_EMPTY_THRESHOLD+RATIO-1)/RATIO) : ALMOST_EMPTY_THRESHOLD;

  // Occupancy tracking parameters (used only when TKEEP_EN, see
  // gen_accurate_level / gen_accurate_room).
  //   FIFO_CAP: usable depth in narrow-interface words. Each of the RATIO
  //     atomic FIFOs reports full at (2**A_ADDRESS - 1) entries.
  //   OUT_MAX: largest value the ADDRESS_WIDTH-bit room/level ports can carry.
  //     Equal to FIFO_CAP when REDUCED_FIFO=1. When REDUCED_FIFO=0 the
  //     narrow-side capacity does not fit the ports, and the outputs saturate
  //     at OUT_MAX.
  //   CNT_WIDTH: width of the occupancy counters. Before saturation, the
  //     counter difference can exceed FIFO_CAP (each atomic output register
  //     holds one entry its read pointer has already released) and can dip
  //     below 0 (the far count is stale). It must never wrap, or the clamp
  //     would turn into an over-report:
  //     - room (sync_gray, same depth as the atomics' own pointer sync):
  //       stays within [-2*RATIO, FIFO_CAP]
  //     - level (sync_data): dips by the reads made during one sync_data
  //       round trip, which depends on the clock ratio, not on parameters
  //     Three bits above FIFO_CAP give a signed range of at least
  //     +/-4*(FIFO_CAP+1), covering both with margin.
  localparam integer FIFO_CAP = RATIO * ((2**A_ADDRESS) - 1);
  localparam integer OUT_MAX = (FIFO_CAP < (2**ADDRESS_WIDTH) - 1) ? FIFO_CAP : (2**ADDRESS_WIDTH) - 1;
  localparam CNT_WIDTH = $clog2(FIFO_CAP + 1) + 3;

  localparam MEM_WORD = (TKEEP_EN & TLAST_EN) ? (A_WIDTH+A_WIDTH/8+1) :
                        (TKEEP_EN)            ? (A_WIDTH+A_WIDTH/8)   :
                        (TLAST_EN)            ? (A_WIDTH+1)           :
                                                (A_WIDTH);

  wire [MEM_WORD-1:0] slice_s_data [RATIO-1:0];
  wire [MEM_WORD-1:0] slice_m_data [RATIO-1:0];

  // slave and master sequencers
  reg [$clog2(RATIO)-1:0] s_axis_counter;
  reg [$clog2(RATIO)-1:0] m_axis_counter;

  // narrow-side room/level registers (driven only when TKEEP_EN)
  reg [ADDRESS_WIDTH-1:0] m_axis_level_reg;
  reg [ADDRESS_WIDTH-1:0] s_axis_room_reg;

  wire [RATIO-1:0] m_axis_ready_int_s;
  wire [RATIO-1:0] m_axis_valid_int_s;
  wire [RATIO*A_WIDTH-1:0] m_axis_data_int_s;
  wire [RATIO*A_WIDTH/8-1:0] m_axis_tkeep_int_s;
  wire [RATIO-1:0] m_axis_tlast_int_s;
  wire [RATIO-1:0] m_axis_empty_int_s;
  wire [RATIO-1:0] m_axis_almost_empty_int_s;
  wire [RATIO*A_ADDRESS-1:0] m_axis_level_int_s;

  wire [RATIO-1:0] s_axis_ready_int_s;
  wire [RATIO-1:0] s_axis_valid_int_s;
  wire [RATIO-1:0] slice_m_valid;
  wire [RATIO*A_WIDTH-1:0] s_axis_data_int_s;
  wire [RATIO*A_WIDTH/8-1:0] s_axis_tkeep_int_s;
  wire [RATIO-1:0] s_axis_tlast_int_s;
  wire [RATIO-1:0] s_axis_full_int_s;
  wire [RATIO-1:0] s_axis_almost_full_int_s;
  wire [RATIO*A_ADDRESS-1:0] s_axis_room_int_s;

  wire m_axis_valid_int;

  wire [RATIO-1:0] fifo_s_ready;
  wire [RATIO-1:0] fifo_s_valid;
  wire [RATIO*A_WIDTH-1:0] fifo_s_data;
  wire [RATIO*A_WIDTH/8-1:0] fifo_s_tkeep;
  wire [RATIO-1:0] fifo_s_tlast;

  // instantiate the FIFOs
  genvar i;
  generate
    for (i=0; i<RATIO; i=i+1) begin: gen_fifo_instances
      util_axis_fifo #(
        .DATA_WIDTH (A_WIDTH),
        .ADDRESS_WIDTH (A_ADDRESS),
        .ASYNC_CLK (ASYNC_CLK),
        .M_AXIS_REGISTERED (M_AXIS_REGISTERED),
        .ALMOST_EMPTY_THRESHOLD (A_ALMOST_EMPTY_THRESHOLD),
        .ALMOST_FULL_THRESHOLD (A_ALMOST_FULL_THRESHOLD),
        .TKEEP_EN (TKEEP_EN),
        .TLAST_EN (TLAST_EN),
        .REMOVE_NULL_BEAT_EN(0)
      ) i_fifo (
        .m_axis_aclk    (m_axis_aclk),
        .m_axis_aresetn (m_axis_aresetn),
        .m_axis_ready   (m_axis_ready_int_s[i]),
        .m_axis_valid   (m_axis_valid_int_s[i]),
        .m_axis_data    (m_axis_data_int_s[A_WIDTH*i+:A_WIDTH]),
        .m_axis_tlast   (m_axis_tlast_int_s[i]),
        .m_axis_tkeep   (m_axis_tkeep_int_s[A_WIDTH/8*i+:A_WIDTH/8]),
        .m_axis_level   (m_axis_level_int_s[A_ADDRESS*i+:A_ADDRESS]),
        .m_axis_empty   (m_axis_empty_int_s[i]),
        .m_axis_almost_empty (m_axis_almost_empty_int_s[i]),
        .s_axis_aclk    (s_axis_aclk),
        .s_axis_aresetn (s_axis_aresetn),
        .s_axis_ready   (fifo_s_ready[i]),
        .s_axis_valid   (fifo_s_valid[i]),
        .s_axis_data    (fifo_s_data[A_WIDTH*i+:A_WIDTH]),
        .s_axis_tkeep   (fifo_s_tkeep[A_WIDTH/8*i+:A_WIDTH/8]),
        .s_axis_tlast   (fifo_s_tlast[i]),
        .s_axis_room    (s_axis_room_int_s[A_ADDRESS*i+:A_ADDRESS]),
        .s_axis_full    (s_axis_full_int_s[i]),
        .s_axis_almost_full (s_axis_almost_full_int_s[i]));

      // SRC_REG_SLICE_EN: Adds an AXI register slice on the slave (source) side
      // of the FIFO to break timing critical paths. This is required for high-
      // frequency clock domains such as the SPI Engine's spi_clk (150-160 MHz),
      // where the combinatorial path from s_axis_* signals through the FIFO
      // creates timing violations. Disabled by default (0) since modules like
      // data_offload do not require this additional latency.
      if (SRC_REG_SLICE_EN) begin : gen_with_slice
        axi_register_slice #(
          .DATA_WIDTH(MEM_WORD),
          .FORWARD_REGISTERED(1),
          .BACKWARD_REGISTERED(1)
        ) i_src_dst_slice (
          .clk(s_axis_aclk),
          .resetn(s_axis_aresetn),
          .s_axi_data(slice_s_data[i]),
          .s_axi_valid(s_axis_valid_int_s[i]),
          .s_axi_ready(s_axis_ready_int_s[i]),
          .m_axi_data(slice_m_data[i]),
          .m_axi_valid(slice_m_valid[i]),
          .m_axi_ready(fifo_s_ready[i]));

        // Connect slice master to FIFO slave
        assign fifo_s_valid[i] = slice_m_valid[i];

        // TLAST and TKEEP packing/unpacking
        if (TLAST_EN & TKEEP_EN) begin
          assign slice_s_data[i]                      = {s_axis_data_int_s[A_WIDTH*i+:A_WIDTH], s_axis_tkeep_int_s[A_WIDTH/8*i+:A_WIDTH/8], s_axis_tlast_int_s[i]};
          assign fifo_s_data[A_WIDTH*i+:A_WIDTH]      = slice_m_data[i][(MEM_WORD-1)-:A_WIDTH];
          assign fifo_s_tkeep[A_WIDTH/8*i+:A_WIDTH/8] = slice_m_data[i][(MEM_WORD-A_WIDTH-1)-:A_WIDTH/8];
          assign fifo_s_tlast[i]                      = slice_m_data[i][(MEM_WORD-A_WIDTH-(A_WIDTH/8)-1)];
        end else if (TKEEP_EN) begin
          assign slice_s_data[i]                      = {s_axis_data_int_s[A_WIDTH*i+:A_WIDTH], s_axis_tkeep_int_s[A_WIDTH/8*i+:A_WIDTH/8]};
          assign fifo_s_data[A_WIDTH*i+:A_WIDTH]      = slice_m_data[i][(MEM_WORD-1)-:A_WIDTH];
          assign fifo_s_tkeep[A_WIDTH/8*i+:A_WIDTH/8] = slice_m_data[i][(MEM_WORD-A_WIDTH-1)-:A_WIDTH/8];
        end else if (TLAST_EN) begin
          assign slice_s_data[i]                      = {s_axis_data_int_s[A_WIDTH*i+:A_WIDTH], s_axis_tlast_int_s[i]};
          assign fifo_s_data[A_WIDTH*i+:A_WIDTH]      = slice_m_data[i][(MEM_WORD-1)-:A_WIDTH];
          assign fifo_s_tlast[i]                      = slice_m_data[i][(MEM_WORD-A_WIDTH-1)];
        end else begin
          assign slice_s_data[i]                      = {s_axis_data_int_s[A_WIDTH*i+:A_WIDTH]};
          assign fifo_s_data[A_WIDTH*i+:A_WIDTH]      = slice_m_data[i][(MEM_WORD-1)-:A_WIDTH];
        end

      end else begin : gen_without_slice
        // Direct connection - bypass register slice
        assign s_axis_ready_int_s[i]                = fifo_s_ready[i];
        assign fifo_s_valid[i]                      = s_axis_valid_int_s[i];
        assign fifo_s_data[A_WIDTH*i+:A_WIDTH]      = s_axis_data_int_s[A_WIDTH*i+:A_WIDTH];
        assign fifo_s_tkeep[A_WIDTH/8*i+:A_WIDTH/8] = s_axis_tkeep_int_s[A_WIDTH/8*i+:A_WIDTH/8];
        assign fifo_s_tlast[i]                      = s_axis_tlast_int_s[i];
      end
    end
  endgenerate

  // ---------------------------------------------------------------------------
  // Accurate room/level tracking under TKEEP_EN
  //
  // Only the narrow interface's metric is replaced. On the wide side one beat
  // is one atomic-FIFO entry, so the atomic FIFO's own room/level is exact.
  //
  // Occupancy is the difference of two free-running counters, one per clock
  // domain. The far counter's value crosses the clock boundary (never event
  // pulses), so no count is lost under back-to-back transfers and any lag
  // corrects itself. The reported metric is a registered, saturating
  // difference, so the output is a plain register.
  //
  //   RATIO_TYPE=1 (wide slave / narrow master): m_axis_level, in output
  //     words. The write side adds the number of words each wide beat will
  //     produce; the read side adds 1 per narrow handshake. The write count
  //     can jump by up to RATIO per beat, so it cannot use a gray
  //     synchronizer and crosses with sync_data.
  //   RATIO_TYPE=0 (narrow slave / wide master): s_axis_room, in atomic-FIFO
  //     slots. Room is memory, so tkeep does not matter: a narrow write takes
  //     one slot (a TLAST beat is padded to the RATIO boundary and takes
  //     RATIO-s_axis_counter), a wide read frees RATIO. The read side counts
  //     wide beats, a +1 counter, so it crosses with sync_gray at the same
  //     depth as the atomic FIFOs' own read pointer sync.
  //
  // The far count is always stale, which only ever makes the result read low:
  //   level = true level - (words written but not yet in the synced count)
  //   room  = true room  - (slots read but not yet in the synced count)
  // Before saturation the difference can still fall below 0 or exceed
  // FIFO_CAP (see CNT_WIDTH), so the clamp to [0, OUT_MAX] is required.
  //
  // The counters reset with their own domain's reset, like the atomic FIFOs'
  // pointers. As with the atomic FIFOs, s_axis_aresetn and m_axis_aresetn must
  // be asserted together; they may be released at different times.
  // ---------------------------------------------------------------------------
  generate if (TKEEP_EN && RATIO_TYPE) begin : gen_accurate_level

    reg  [$clog2(RATIO):0] word_counter;
    reg  [$clog2(RATIO):0] num_of_words;
    reg                    s_axis_ready_d;
    reg                    s_axis_valid_d;
    reg  [CNT_WIDTH-1:0]   s_words_wr;
    reg  [CNT_WIDTH-1:0]   m_words_rd;
    wire                   m_xfer;
    wire [CNT_WIDTH-1:0]   s_words_wr_m;
    wire [CNT_WIDTH-1:0]   level_0;
    wire [CNT_WIDTH-1:0]   level_1;
    wire [ADDRESS_WIDTH-1:0] level_0_sat;
    wire [ADDRESS_WIDTH-1:0] level_1_sat;
    integer j;

    // words this wide beat will produce on the narrow side: one per lane with
    // any tkeep bit set, or one for an all-null beat that carries TLAST
    always @(posedge s_axis_aclk) begin
      if (!s_axis_aresetn) begin
        num_of_words <= 0;
      end else begin
        word_counter = 0;
        for (j = 0; j < RATIO; j = j + 1) begin
          word_counter = word_counter + (|s_axis_tkeep[A_WIDTH/8*j+:A_WIDTH/8]);
        end
        if (TLAST_EN && (word_counter == 0) && s_axis_tlast) begin
          word_counter = 1;
        end
        num_of_words <= word_counter;
      end
    end

    // num_of_words lags its beat by one cycle, so it is added on the handshake
    // delayed by the same cycle
    always @(posedge s_axis_aclk) begin
      if (!s_axis_aresetn) begin
        s_axis_ready_d <= 1'b0;
        s_axis_valid_d <= 1'b0;
        s_words_wr <= {CNT_WIDTH{1'b0}};
      end else begin
        s_axis_ready_d <= s_axis_ready;
        s_axis_valid_d <= s_axis_valid;
        if (s_axis_ready_d && s_axis_valid_d) begin
          s_words_wr <= s_words_wr + num_of_words;
        end
      end
    end

    assign m_xfer = m_axis_ready && m_axis_valid;

    always @(posedge m_axis_aclk) begin
      if (!m_axis_aresetn) begin
        m_words_rd <= {CNT_WIDTH{1'b0}};
      end else if (m_xfer) begin
        m_words_rd <= m_words_rd + 1'b1;
      end
    end

    sync_data #(
      .NUM_OF_BITS (CNT_WIDTH),
      .ASYNC_CLK   (ASYNC_CLK)
    ) i_wr_count_sync (
      .in_clk   (s_axis_aclk),
      .in_data  (s_words_wr),
      .out_clk  (m_axis_aclk),
      .out_data (s_words_wr_m));

    // The registered level must not count a word that leaves in this cycle.
    // Both candidates, without and with this cycle's read, come from registers
    // only; the handshake just selects one, so it does not pass through the
    // subtract and the saturation. Signed: below 0 while the reader has
    // consumed words that the synchronized write count does not include yet.
    assign level_0 = s_words_wr_m - m_words_rd;
    assign level_1 = s_words_wr_m + ~m_words_rd;  // s_words_wr_m - m_words_rd - 1

    assign level_0_sat = level_0[CNT_WIDTH-1] ? {ADDRESS_WIDTH{1'b0}} :
                         (level_0 > OUT_MAX)  ? OUT_MAX : level_0;
    assign level_1_sat = level_1[CNT_WIDTH-1] ? {ADDRESS_WIDTH{1'b0}} :
                         (level_1 > OUT_MAX)  ? OUT_MAX : level_1;

    always @(posedge m_axis_aclk) begin
      if (!m_axis_aresetn) begin
        m_axis_level_reg <= {ADDRESS_WIDTH{1'b0}};
      end else begin
        m_axis_level_reg <= m_xfer ? level_1_sat : level_0_sat;
      end
    end

  end else if (TKEEP_EN) begin : gen_accurate_room

    localparam BEAT_WIDTH = CNT_WIDTH - $clog2(RATIO);

    reg  [CNT_WIDTH-1:0]  s_slots_wr;
    wire                  s_xfer;
    wire [CNT_WIDTH-1:0]  s_tlast_slots;
    reg  [BEAT_WIDTH-1:0] m_beats_rd;
    wire [BEAT_WIDTH-1:0] m_beats_rd_s;
    wire [CNT_WIDTH-1:0]  room_0;
    wire [CNT_WIDTH-1:0]  room_1;
    wire [CNT_WIDTH-1:0]  room_t;
    wire [ADDRESS_WIDTH-1:0] room_0_sat;
    wire [ADDRESS_WIDTH-1:0] room_1_sat;
    wire [ADDRESS_WIDTH-1:0] room_t_sat;

    assign s_xfer = s_axis_ready && s_axis_valid;
    // slots a TLAST beat takes, padding up to the RATIO boundary
    assign s_tlast_slots = RATIO - s_axis_counter;

    always @(posedge s_axis_aclk) begin
      if (!s_axis_aresetn) begin
        s_slots_wr <= {CNT_WIDTH{1'b0}};
      end else if (s_xfer) begin
        s_slots_wr <= s_axis_tlast ? s_slots_wr + s_tlast_slots : s_slots_wr + 1'b1;
      end
    end

    always @(posedge m_axis_aclk) begin
      if (!m_axis_aresetn) begin
        m_beats_rd <= {BEAT_WIDTH{1'b0}};
      end else if (m_axis_ready && m_axis_valid) begin
        m_beats_rd <= m_beats_rd + 1'b1;
      end
    end

    sync_gray #(
      .DATA_WIDTH (BEAT_WIDTH),
      .ASYNC_CLK  (ASYNC_CLK)
    ) i_rd_count_sync (
      .in_clk     (m_axis_aclk),
      .in_resetn  (m_axis_aresetn),
      .in_count   (m_beats_rd),
      .out_resetn (s_axis_aresetn),
      .out_clk    (s_axis_aclk),
      .out_count  (m_beats_rd_s));

    // The registered room must not offer a slot taken in this cycle. The
    // candidates (no write, a plain write, a TLAST write) come from registers
    // only; the handshake and TLAST just select one, so they do not pass
    // through the subtract and the saturation. Signed: slightly below 0 while
    // the atomic output registers hold entries whose slots the read pointers
    // have already released.
    assign room_0 = FIFO_CAP + {m_beats_rd_s, {$clog2(RATIO){1'b0}}} - s_slots_wr;
    assign room_1 = room_0 - 1'b1;
    assign room_t = room_0 - s_tlast_slots;

    assign room_0_sat = room_0[CNT_WIDTH-1] ? {ADDRESS_WIDTH{1'b0}} :
                        (room_0 > OUT_MAX)  ? OUT_MAX : room_0;
    assign room_1_sat = room_1[CNT_WIDTH-1] ? {ADDRESS_WIDTH{1'b0}} :
                        (room_1 > OUT_MAX)  ? OUT_MAX : room_1;
    assign room_t_sat = room_t[CNT_WIDTH-1] ? {ADDRESS_WIDTH{1'b0}} :
                        (room_t > OUT_MAX)  ? OUT_MAX : room_t;

    always @(posedge s_axis_aclk) begin
      if (!s_axis_aresetn) begin
        s_axis_room_reg <= OUT_MAX;
      end else begin
        s_axis_room_reg <= !s_xfer      ? room_0_sat :
                           s_axis_tlast ? room_t_sat :
                                          room_1_sat;
      end
    end

  end endgenerate

  // write or slave logic
  generate

    if (RATIO_TYPE) begin : big_slave

      for (i=0; i<RATIO; i=i+1) begin: gen_tlast_big_slave
        assign s_axis_valid_int_s[i] = s_axis_valid & s_axis_ready;

        if (TKEEP_EN) begin

          // tlast is asserted for the atomic fifo instances on the following conditions:
          // - for the most significant instance, tlast is the input tlast if any of the tkeep bits for the instance is asserted (so we are not suppressing this transfer)
          // - for the least significant instance, tlast is the input tlast if no tkeep bits are asserted for any instance (transfer is all null bytes)
          // - for the other instances, we store the input tlast if all the following instances have tkeep=0 for all bits and no less significant instance has stored it
          // thus, the tlast is stored on the most significant instance that has non-null bytes (meaning not all tkeep bits are 0), if there are any.
          if (i==RATIO-1) begin
            assign s_axis_tlast_int_s[i] = (|s_axis_tkeep[M_DATA_WIDTH/8*i+:M_DATA_WIDTH/8]) ? s_axis_tlast : 1'b0;
          end else if (i==0) begin
            assign s_axis_tlast_int_s[i] = (~|s_axis_tkeep[(S_DATA_WIDTH/8)-1:(M_DATA_WIDTH/8)]) ? s_axis_tlast : 1'b0;
          end else begin
            assign s_axis_tlast_int_s[i] = (~(|s_axis_tkeep[(S_DATA_WIDTH/8)-1:(M_DATA_WIDTH/8)*(i+1)]) && ~|s_axis_tlast_int_s[i-1:0]) ? s_axis_tlast : 1'b0;
          end

        end else begin

          assign s_axis_tlast_int_s[i] = (i==RATIO-1) ? s_axis_tlast : 1'b0;

        end
      end

      assign s_axis_tkeep_int_s = s_axis_tkeep;
      assign s_axis_data_int_s = s_axis_data;
      // if every instance is ready, the interface is ready
      assign s_axis_ready = &(s_axis_ready_int_s);
      // if one of the atomic instance is full, s_axis_full is asserted
      assign s_axis_full = |s_axis_full_int_s;
      assign s_axis_almost_full = |s_axis_almost_full_int_s;
      // slave is the wide side: the FIFO has the same room as the atomic FIFO
      assign s_axis_room = s_axis_room_int_s[A_ADDRESS-1:0];

    end else begin : small_slave

      reg [RATIO-1:0] s_axis_valid_int_d = {RATIO{1'b0}};

      for (i=0; i<RATIO; i=i+1) begin: gen_tlast_small_slave
        assign s_axis_data_int_s[A_WIDTH*i+:A_WIDTH] = s_axis_data;
        assign s_axis_tkeep_int_s[A_WIDTH/8*i+:A_WIDTH/8] = (s_axis_counter == i) ? s_axis_tkeep : {A_WIDTH/8{1'b0}};
        assign s_axis_tlast_int_s[i] = (s_axis_counter == i) ? s_axis_tlast : 1'b0;
      end

      // insert invalid writes (TKEEP==0) in case if the TLAST arrives before the RATIO
      // boundary
      always @(*) begin
        case ({s_axis_valid, s_axis_tlast})
          2'b00 : s_axis_valid_int_d = {RATIO{1'b0}};
          2'b01 : s_axis_valid_int_d = {RATIO{1'b0}};
          2'b10 : s_axis_valid_int_d = {{RATIO-1{1'b0}}, 1'b1} << s_axis_counter;
          2'b11 : s_axis_valid_int_d = {RATIO{&(s_axis_ready_int_s)}} << s_axis_counter;
        endcase
      end
      assign s_axis_valid_int_s = s_axis_valid_int_d;

      // disable read enable if the TLAST arrives before address handshake occurs
      assign s_axis_ready = (s_axis_tlast) ? &(s_axis_ready_int_s) : s_axis_ready_int_s >> s_axis_counter;

      // FULL/ALMOST_FULL is driven by the current atomic instance
      assign s_axis_almost_full = s_axis_almost_full_int_s >> s_axis_counter;
      assign s_axis_full = s_axis_full_int_s[RATIO-1];

      // FIFO room behavior relies on the TKEEP_EN parameter
      //    When TKEEP_EN == 0, the FIFO reports the room of the last atomic
      //    instance multiplied by RATIO; it is only updated every RATIO reads
      //    and is not the exact room value.
      //    When TKEEP_EN == 1, s_axis_room is the free slot count from
      //    s_axis_room_reg. It lags the read side by a few cycles and only
      //    ever reads low (see gen_accurate_room).
      assign s_axis_room = (TKEEP_EN) ? s_axis_room_reg : {s_axis_room_int_s[A_ADDRESS*(RATIO-1)+:A_ADDRESS], {$clog2(RATIO){1'b1}}};

    end

  endgenerate

  // read or slave logic
  generate
    if (RATIO_TYPE) begin : small_master

      for (i=0; i<RATIO; i=i+1) begin: gen_ready_small_master
        // When TKEEP_EN, we need to discard the data from the internal FIFOs for which tkeep=0.
        // Thus we still need to assert m_axis_ready_int_s for that internal FIFO even without an actual AXI handshake.
        assign m_axis_ready_int_s[i] = (m_axis_counter == i) ? (m_axis_ready ||  (TKEEP_EN && !(|m_axis_tkeep) && !m_axis_valid)) : 0;
      end

      assign m_axis_data = m_axis_data_int_s >> (m_axis_counter*A_WIDTH) ;
      assign m_axis_tkeep = m_axis_tkeep_int_s >> (m_axis_counter*A_WIDTH/8); //m_axis_tkeep is always high when TKEEP_EN == 0

      // VALID/EMPTY/ALMOST_EMPTY is driven by the current atomic instance
      assign m_axis_valid_int = m_axis_valid_int_s >> m_axis_counter;

      // When TLAST_EN=1, we still have to assert m_axis_valid when tlast is
      // high even if all bytes are null due to tkeep. AXI-Streaming only allows
      // us to suppress transfers with all tkeep bits deasserted if tlast is
      // also deasserted.
      if (TLAST_EN) begin
        assign m_axis_valid = m_axis_valid_int & ((|m_axis_tkeep) || m_axis_tlast);
      end else begin
        assign m_axis_valid = m_axis_valid_int & (|m_axis_tkeep);
      end

      assign m_axis_tlast = m_axis_tlast_int_s >> m_axis_counter;

      // FIFO level behavior relies on the TKEEP_EN parameter
      //    When TKEEP_EN == 0, the FIFO reports the level of the last atomic
      //    instance multiplied by RATIO; it is only updated every RATIO reads
      //    and is not the exact level value.
      //    When TKEEP_EN == 1, m_axis_level is the output word count from
      //    m_axis_level_reg. It lags the write side by one sync_data round
      //    trip and only ever reads low (see gen_accurate_level).
      assign m_axis_level = (TKEEP_EN) ? m_axis_level_reg : {m_axis_level_int_s[A_ADDRESS-1:0], {$clog2(RATIO){1'b0}}};
      assign m_axis_almost_empty = m_axis_almost_empty_int_s[RATIO-1];
      assign m_axis_empty = m_axis_empty_int_s[RATIO-1];

    end else begin : big_master

      for (i=0; i<RATIO; i=i+1) begin: gen_ready_big_master
        assign m_axis_ready_int_s[i] = m_axis_ready & (&m_axis_valid_int_s);
      end

      for (i=0; i<RATIO; i=i+1) begin: gen_tkeep_big_master
        assign m_axis_tkeep[i*A_WIDTH/8+:A_WIDTH/8] = ((m_axis_tlast_int_s[i:0] == 0) ||
                                                      (m_axis_tlast_int_s[i])) ?
                                                        m_axis_tkeep_int_s[i*A_WIDTH/8+:A_WIDTH/8] :
                                                        {(A_WIDTH/8){1'b0}};
      end

      assign m_axis_data = m_axis_data_int_s;
      // The interface has valid data only when every atomic instance does,
      // TLAST included: small_slave pads a short packet to the RATIO boundary,
      // so its last row is always complete, and the atomic instances are only
      // popped together, when all of them are valid. Each instance
      // synchronizes its write pointer separately, so lanes of one row can
      // become valid a cycle apart. Asserting valid on a partial row would
      // hand out a beat without popping it and send the row twice.
      assign m_axis_valid_int = &m_axis_valid_int_s;
      assign m_axis_valid = m_axis_valid_int;
      // if one of the atomic instance is empty, m_axis_empty should be asserted
      assign m_axis_empty = |m_axis_empty_int_s;
      assign m_axis_almost_empty = |m_axis_almost_empty_int_s;

      // master is the wide side: the FIFO has the same level as the atomic FIFO
      assign m_axis_level = m_axis_level_int_s[A_ADDRESS-1:0];

      assign m_axis_tlast = (m_axis_valid) ? |m_axis_tlast_int_s : 1'b0;

    end

  endgenerate

  generate
    if (RATIO == 1) begin
      initial begin
        s_axis_counter = 1'b1; //s_axis_counter == 1 is never executed in small_slave
      end
    end else if (RATIO > 1) begin
      if (RATIO_TYPE) begin
        always @(posedge s_axis_aclk) begin
          if (!s_axis_aresetn) begin
            s_axis_counter <= 0;
          end else begin
            if (s_axis_ready && s_axis_valid) begin
              s_axis_counter <= s_axis_counter + 1'b1;
            end
          end
        end
      end else begin
        // in case of a small slave, after an active TLAST reset the counter
        always @(posedge s_axis_aclk) begin
          if (!s_axis_aresetn) begin
            s_axis_counter <= 0;
          end else begin
            if (s_axis_ready && s_axis_valid) begin
              if (s_axis_tlast) begin
                s_axis_counter <= 0;
              end else begin
                s_axis_counter <= s_axis_counter + 1'b1;
              end
            end
          end
        end
      end
    end
  endgenerate

  // master handshake sequencer

  generate
    if (RATIO == 1) begin
      initial begin
        m_axis_counter = 1'b0;
      end
    end else if (RATIO > 1) begin
      always @(posedge m_axis_aclk) begin
        if (!m_axis_aresetn) begin
          m_axis_counter <= 0;
        end else begin
          // Advance the master counter on two conditions:
          // 1. Normal handshake: downstream accepted a valid beat (m_axis_ready && m_axis_valid).
          // 2. Null-beat skip: the atomic FIFO has data (m_axis_valid_int) but all tkeep bits
          //    are zero and the beat is not externally valid (!m_axis_valid). This second check
          //    prevents skipping beats that carry tlast, which AXI-Stream requires to be
          //    handshaked even when tkeep is fully deasserted.
          if ((m_axis_ready && m_axis_valid) || (TKEEP_EN && m_axis_valid_int && !(|m_axis_tkeep) && !m_axis_valid)) begin
            m_axis_counter <= m_axis_counter + 1'b1;
          end
        end
      end
    end
  endgenerate

endmodule
