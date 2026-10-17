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

// Sample packer with a run time sample size.
//
// Every valid cycle each of the NUM_CH channels delivers CH_SLOTS slots of
// SLOT_W bits. A sample takes 2**sample_slots_select slots. The slots of the enabled
// channels leave packed, N = NUM_CH*CH_SLOTS per word, round by round: round r
// holds sample r of every enabled channel, channel by channel. osync marks the
// words whose slot 0 starts a round.
//
// NUM_CH and CH_SLOTS are powers of two. A sample_slots_select above
// log2(CH_SLOTS) gives no output. sample_slots_select is used with
// ENABLE_SAMPLE_SLOTS_SELECT set; otherwise a sample is one slot. With
// SLOT_ENABLE set, slot_enable drops single slots of the enabled channels as
// well, e.g. one of two channels that share a word; a round then starts at
// its first kept slot. A bit set in ALWAYS_ENABLE_MASK keeps its channel enabled,
// and with SLOT_ENABLE set a bit set in ALWAYS_SLOT_ENABLE_MASK keeps its slot
// enabled, whatever enable and slot_enable say; at 0, the default, they force
// nothing. With CONFIG_CDC set, enable, sample_slots_select and
// slot_enable pass a sync_bits, i_config_sync, so each bit may come from any
// clock; false path to its cdc_sync_stage1. Reset drops the partial word and
// the input while it is high. A change of enable, sample_slots_select or slot_enable
// refills the routing table and drops the input for N*(N+2) + 3 cycles; so
// does power up. With CONFIG_HOLD set, changes wait
// while config_hold is high, e.g. during a transfer, so a buffer never mixes
// layouts; a change that arrives within a few cycles of its rise may wait a
// transfer.
//
// Datapath, one level per LUT:
//   level 0: the interleave, which keeps the slots of a sample together and
//     puts the samples in round order,
//   log4(N) butterfly levels: level m sets the bits 2m and 2m+1 of the
//     position of every enabled slot to those of its destination, the
//     write pointer wp plus its rank among the enabled slots, mod N. Taken
//     LSB first this never makes two slots meet, so one network both packs
//     and rotates into the word buffer. With an odd log2(N) the last level
//     is a 2:1 mux,
//   the merge into the word buffer and odata.
// enable and sample_slots_select only change with a restart, so the selects of
// every level, the keep mask and the round start of entry 0 depend on wp
// alone. They are computed once into a table addressed by wp, a distributed
// RAM, which is read in the register after level 0.
//
// Pipeline registers: there is always one after level 0. The others are
// placed as in ad_sample_compact: PIPE_STAGES -1 automatic from LEVEL_BUDGET,
// n registers spread evenly over the levels, or PIPE_MASK by hand, bit g =
// register after level g. The registers advance every cycle; a word leaves a
// fixed number of cycles after its last slot arrives.

`timescale 1ns/100ps

module ad_sample_pack #(
  parameter SLOT_W              = 16,
  parameter NUM_CH              = 2,
  parameter CH_SLOTS            = 2,
  parameter OUT_SLOTS           = NUM_CH*CH_SLOTS,
  // Width of sample_slots_select, enough for log2(CH_SLOTS)
  parameter SAMPLE_SLOTS_SELECT_WIDTH = (CH_SLOTS >= 256) ? 4 : (CH_SLOTS >= 16) ? 3 : (CH_SLOTS >= 4) ? 2 : 1,
  parameter ENABLE_SAMPLE_SLOTS_SELECT = 0,
  parameter CONFIG_CDC          = 0,
  parameter SLOT_ENABLE         = 0,
  parameter [NUM_CH-1:0] ALWAYS_ENABLE_MASK = 'd0,
  parameter [NUM_CH*CH_SLOTS-1:0] ALWAYS_SLOT_ENABLE_MASK = 'd0,
  parameter CONFIG_HOLD         = 0,
  parameter PIPE_STAGES         = -1,
  parameter LEVEL_BUDGET        = 0,
  parameter [63:0] PIPE_MASK    = 64'd0
) (
  input                                   clk,
  input                                   reset,

  input       [NUM_CH-1:0]                enable,
  // log2 of the slots per sample
  input       [SAMPLE_SLOTS_SELECT_WIDTH-1:0] sample_slots_select,
  // Bit c*CH_SLOTS + s: slot s of channel c; used with SLOT_ENABLE set.
  input       [NUM_CH*CH_SLOTS-1:0]       slot_enable,
  // With CONFIG_HOLD, while high, enable, sample_slots_select and slot_enable keep their last values.
  input                                   config_hold,

  input       [NUM_CH*CH_SLOTS*SLOT_W-1:0] idata,
  input                                   ivalid,

  output reg  [OUT_SLOTS*SLOT_W-1:0]      odata = 'd0,
  output reg                              ovalid = 1'b0,
  output reg                              osync = 1'b0
);

  // Number of slots per cycle, in and out
  localparam N   = NUM_CH*CH_SLOTS;
  // Width of the decoded slots per sample
  localparam MW  = $clog2(CH_SLOTS+1);
  // sample_slots_select Width
  localparam LW  = SAMPLE_SLOTS_SELECT_WIDTH;
  // Number of Sample Sizes: 1, 2, 4 ... CH_SLOTS slots
  localparam NSS = $clog2(CH_SLOTS) + 1;
  // Pointer Width, wp and slot indices
  localparam PW  = (N > 1) ? $clog2(N) : 1;
  // Count Width, counts up to 2*N - 1
  localparam CW  = PW + 1;
  // Number of binary butterfly levels
  localparam NB  = (N > 1) ? $clog2(N) : 0;
  // Number of radix-4 butterfly levels
  localparam NQ  = (NB + 1) / 2;
  // Number of Levels Total: interleave, butterfly, merge
  localparam NLT = NQ + 2;
  // Level Budget: levels per cycle at about 200 MHz on xc7z020
  localparam LB  = (LEVEL_BUDGET > 0) ? LEVEL_BUDGET :
                   (N <= 16) ? 4 : (N <= 32) ? 3 : 2;
  // Registers requested
  localparam R0  = (PIPE_STAGES >= 0) ? PIPE_STAGES : (NLT + LB - 1) / LB - 1;
  // Register Quantity, at most one per level
  localparam RQ  = (R0 < NLT - 1) ? R0 : NLT - 1;
  // Table Width: two select bits per position and level, the keep mask, the round start of entry 0
  localparam TW  = 2*N*NQ + N + 1;

  // Level after which register m of rq sits.
  function integer pos;
    input integer m;
    input integer rq;
    input integer nlt;
    begin
      pos = (m * nlt) / (rq + 1) - 1;
    end
  endfunction

  // A register after level g; the one after level 0 holds the table read.
  function is_reg_f;
    input integer g;
    input integer rq;
    input integer nlt;
    input [63:0] mask;
    integer m;
    begin
      is_reg_f = (g == 0);
      if (mask != 0) begin
        if (mask[g]) is_reg_f = 1;
      end else begin
        for (m = 1; m <= rq; m = m + 1)
          if (pos(m, rq, nlt) == g) is_reg_f = 1;
      end
    end
  endfunction

  generate
  if ((NUM_CH & (NUM_CH-1)) != 0 || (CH_SLOTS & (CH_SLOTS-1)) != 0 ||
      OUT_SLOTS != N) begin : g_cfg_error
    $error("ad_sample_pack: NUM_CH and CH_SLOTS must be powers of two, OUT_SLOTS = NUM_CH*CH_SLOTS");
    ad_sample_pack_ERROR_config i_cfg_error ();
  end
  if (PIPE_STAGES < -1) begin : g_par_error
    $error("ad_sample_pack: PIPE_STAGES must be at least -1");
    ad_sample_pack_ERROR_bad_parameter i_par_error ();
  end
  endgenerate

  genvar l, j;
  integer i, k, c, w, g, h, q;

  // ---------------------------------------------------------------------------
  // Run configuration and the slot properties that depend on it alone.
  // ---------------------------------------------------------------------------

  // A value passed on the way of the crossing only adds a restart.
  wire [NUM_CH-1:0] enable_c;
  wire [LW-1:0]     sample_slots_select_s;
  wire [N-1:0]      slot_enable_c;

  sync_bits #(
    .NUM_OF_BITS(NUM_CH + LW + N),
    .ASYNC_CLK(CONFIG_CDC != 0)
  ) i_config_sync (
    .in_bits({slot_enable, sample_slots_select, enable}),
    .out_resetn(1'b1),
    .out_clk(clk),
    .out_bits({slot_enable_c, sample_slots_select_s, enable_c}));

  wire [NUM_CH-1:0] enable_s       = enable_c | ALWAYS_ENABLE_MASK;

  // Slots per sample; 0, no output, above CH_SLOTS.
  wire [MW-1:0]     sample_slots_s = (ENABLE_SAMPLE_SLOTS_SELECT == 0) ? 'd1 :
                                     (sample_slots_select_s < NSS) ? (1 << sample_slots_select_s) : 'd0;
  // Without SLOT_ENABLE every slot of an enabled channel is kept.
  wire [N-1:0]      slot_enable_s  = (SLOT_ENABLE == 0) ? {N{1'b1}} : slot_enable_c | ALWAYS_SLOT_ENABLE_MASK;

  // ss: Sample Slots, en: channel ENable, sen: Slot ENable, as used by the current run
  reg  [MW-1:0]     ss = 'd1;
  reg  [NUM_CH-1:0] en = 'd0;
  reg  [N-1:0]      sen = 'd0;
  // Round size minus 1, NUM_CH*ss - 1, for the round starts of the fill engine with SLOT_ENABLE
  reg  [PW-1:0]     rmask = 'd0;
  // uen: Unit ENable, urs: Unit starts a Round, per slot in interleaved order
  reg  [N-1:0]      uen = 'd0;
  reg  [N-1:0]      urs = 'd0;

  reg  [NUM_CH-1:0] first_s;
  reg  [N-1:0]      uen_s;
  reg  [N-1:0]      urs_s;

  // A change of the run configuration, registered to keep the compare off the fill engine.
  reg               restart = 1'b1;

  wire              hold = (CONFIG_HOLD != 0) && config_hold;

  // The interleaved slot j belongs to channel (j/ss)%NUM_CH; a round starts at the lowest enabled one.
  always @(*) begin
    first_s = 'd0;
    for (c = NUM_CH-1; c >= 0; c = c - 1) begin
      if (enable_s[c]) begin
        first_s = 'd0;
        first_s[c] = 1'b1;
      end
    end
    uen_s = 'd0;
    urs_s = 'd0;
    for (k = 0; k < NSS; k = k + 1) begin
      if (sample_slots_s == (1 << k)) begin
        for (i = 0; i < N; i = i + 1) begin
          uen_s[i] = enable_s[(i >> k) % NUM_CH] &
                     slot_enable_s[((i >> k) % NUM_CH)*CH_SLOTS + ((i >> k) / NUM_CH)*(1 << k) + i % (1 << k)];
          urs_s[i] = first_s[(i >> k) % NUM_CH] && (i % (1 << k) == 0);
        end
      end
    end
  end

  always @(posedge clk) begin
    if (!hold) begin
      ss      <= sample_slots_s;
      en      <= enable_s;
      sen     <= slot_enable_s;
      rmask   <= NUM_CH*sample_slots_s - 1;
      uen     <= uen_s;
      urs     <= urs_s;
    end
    restart <= !hold && (sample_slots_s != ss || enable_s != en ||
               (SLOT_ENABLE != 0 && slot_enable_s != sen));
  end

  // ---------------------------------------------------------------------------
  // Fill engine: one table row per wp value, one slot per cycle.
  // ---------------------------------------------------------------------------

  // fbusy: the table is being filled, the input is dropped meanwhile.
  // fw/fi: Fill Write pointer value (table row) / Input slot, frk: Rank of slot fi among the enabled ones.
  reg               fbusy = 1'b1;
  reg  [PW-1:0]     fw = 'd0;
  reg  [CW-1:0]     fi = 'd0;
  reg  [CW-1:0]     frk = 'd0;
  // Stage B of the engine: slot fb_i of rank fb_rk is enabled (fb_e) and starts a round (fb_r).
  reg               fb_e = 1'b0;
  reg               fb_r = 1'b0;
  reg  [PW-1:0]     fb_i = 'd0;
  reg  [PW-1:0]     fb_dst = 'd0;
  // Row under construction: selects, keep mask, round start of entry 0
  reg  [2*N*NQ-1:0] row_s = 'd0;
  reg  [N-1:0]      row_k = 'd0;
  reg               row_r0 = 1'b0;
  // Kept slots per valid cycle
  reg  [CW-1:0]     kcnt = 'd0;
  // f_seen: a kept slot came earlier in the round of slot fi; f_first: fi starts a round
  reg               f_seen = 1'b0;
  wire              f_first = (fi[PW-1:0] & rmask) == 0;
  wire              f_seen_nx = ~f_first & f_seen;

  (* ram_style = "distributed" *) reg [TW-1:0] tab [0:N-1];

  // q_dst: position of slot fb_i after level m, its bits up to 2m+1 taken from the destination
  reg  [PW-1:0]     q_dst;

  always @(posedge clk) begin
    if (restart) begin
      fbusy  <= 1'b1;
      fw     <= 'd0;
      fi     <= 'd0;
      frk    <= 'd0;
      fb_e   <= 1'b0;
      row_k  <= 'd0;
      row_r0 <= 1'b0;
    end else if (fbusy) begin
      // Stage A: fetch slot fi; its destination is wp + rank.
      fb_e   <= (fi < N) && uen[fi[PW-1:0]];
      // With slot enables a round starts at its first kept slot, which is known only here.
      fb_r   <= (SLOT_ENABLE != 0) ? ~f_seen_nx : urs[fi[PW-1:0]];
      f_seen <= f_seen_nx | ((fi < N) && uen[fi[PW-1:0]]);
      fb_i   <= fi[PW-1:0];
      fb_dst <= fw + frk[PW-1:0];
      if (fi < N && uen[fi[PW-1:0]]) frk <= frk + 1'b1;

      // Stage B: scatter the slot into the row.
      if (fb_e) begin
        for (h = 0; h < NQ; h = h + 1) begin
          q_dst = (fb_i & ~((4 << (2*h)) - 1)) | (fb_dst & ((4 << (2*h)) - 1));
          for (q = 0; q < N; q = q + 1)
            if (q == q_dst) row_s[(h*N + q)*2 +: 2] <= (fb_i >> (2*h)) & 2'd3;
        end
        row_k[fb_dst] <= 1'b1;
        if (fb_dst == 0) row_r0 <= fb_r;
      end

      if (fi == N + 1) begin
        tab[fw] <= {row_r0, row_k, row_s};
        kcnt    <= frk;
        row_k   <= 'd0;
        row_r0  <= 1'b0;
        fi      <= 'd0;
        frk     <= 'd0;
        fw      <= fw + 1'b1;
        if (fw == N - 1) fbusy <= 1'b0;
      end else begin
        fi <= fi + 1'b1;
      end
    end
  end

  wire stop = reset || restart || fbusy;

  // ---------------------------------------------------------------------------
  // Datapath
  // ---------------------------------------------------------------------------

  // wp: Write Pointer, wp_nx: its NeXt value, done: this valid cycle completes a word.
  reg  [PW-1:0] wp = 'd0;

  wire          v0     = ivalid & ~stop;
  wire [CW-1:0] wp_add = wp + (v0 ? kcnt : 'd0);
  wire          done   = (wp_add >= N);
  wire [PW-1:0] wp_nx  = done ? wp_add - N : wp_add;

  always @(posedge clk) begin
    if (stop) wp <= 'd0;
    else      wp <= wp_nx;
  end

  // Level inputs: dd Data, dt Table row, dw wp, ddn done, dv Valid.
  wire [N*SLOT_W-1:0] dd  [0:NLT-1];
  wire [TW-1:0]       dt  [0:NLT-1];
  wire [PW-1:0]       dw  [0:NLT-1];
  wire                ddn [0:NLT-1];
  wire                dv  [0:NLT-1];

  // xi: the interleave, group w of ss slots of channel c goes to position w*NUM_CH + c.
  reg  [N*SLOT_W-1:0] xi;

  always @(*) begin
    xi = 'd0;
    for (k = 0; k < NSS; k = k + 1)
      if (ss == (1 << k))
        for (c = 0; c < NUM_CH; c = c + 1)
          for (w = 0; w < (CH_SLOTS >> k); w = w + 1)
            for (g = 0; g < (1 << k); g = g + 1)
              xi[((w*NUM_CH + c)*(1 << k) + g)*SLOT_W +: SLOT_W] =
                idata[(c*CH_SLOTS + w*(1 << k) + g)*SLOT_W +: SLOT_W];
  end

  assign dd[0]  = idata;
  assign dt[0]  = 'd0;
  assign dw[0]  = wp;
  assign ddn[0] = done;
  assign dv[0]  = v0;

  generate
  for (l = 0; l < NLT - 1; l = l + 1) begin : g_lvl
    // xd/xt: Data / Table row after this level
    wire [N*SLOT_W-1:0] xd;
    wire [TW-1:0]       xt = (l == 0) ? tab[wp] : dt[l];

    if (l == 0) begin : g_il
      assign xd = xi;
    end else begin : g_bf
      // Butterfly level m = l-1: position j takes j with bits 2m, 2m+1 set to the select.
      localparam S = 2*(l-1);

      for (j = 0; j < N; j = j + 1) begin : g_j
        localparam J0 = j & ~(3 << S);
        wire [1:0] sel = dt[l][((l-1)*N + j)*2 +: 2];

        if (S + 1 < NB) begin : g_m4
          assign xd[j*SLOT_W +: SLOT_W] = sel[1] ?
            (sel[0] ? dd[l][(J0 + (3 << S))*SLOT_W +: SLOT_W] : dd[l][(J0 + (2 << S))*SLOT_W +: SLOT_W]) :
            (sel[0] ? dd[l][(J0 + (1 << S))*SLOT_W +: SLOT_W] : dd[l][J0*SLOT_W +: SLOT_W]);
        end else begin : g_m2
          assign xd[j*SLOT_W +: SLOT_W] = sel[0] ?
            dd[l][(J0 + (1 << S))*SLOT_W +: SLOT_W] : dd[l][J0*SLOT_W +: SLOT_W];
        end
      end
    end

    // Optional register after this level; always after level 0.
    if (is_reg_f(l, RQ, NLT, PIPE_MASK)) begin : g_reg
      reg [N*SLOT_W-1:0] q_d  = 'd0;
      reg [TW-1:0]       q_t  = 'd0;
      reg [PW-1:0]       q_w  = 'd0;
      reg                q_dn = 1'b0;
      reg                q_v  = 1'b0;

      always @(posedge clk) begin
        q_d <= xd;
        q_t <= xt;
        q_w <= dw[l];
        if (stop) begin
          q_dn <= 1'b0;
          q_v  <= 1'b0;
        end else begin
          q_dn <= ddn[l];
          q_v  <= dv[l];
        end
      end

      assign dd[l+1]  = q_d;
      assign dt[l+1]  = q_t;
      assign dw[l+1]  = q_w;
      assign ddn[l+1] = q_dn;
      assign dv[l+1]  = q_v;
    end else begin : g_comb
      assign dd[l+1]  = xd;
      assign dt[l+1]  = xt;
      assign dw[l+1]  = dw[l];
      assign ddn[l+1] = ddn[l];
      assign dv[l+1]  = dv[l];
    end
  end
  endgenerate

  // ---------------------------------------------------------------------------
  // Merge into the word buffer and odata.
  // ---------------------------------------------------------------------------

  // f_*: Final Data / Keep / wp / done / Round start of entry 0
  wire [N*SLOT_W-1:0] f_d    = dd[NLT-1];
  wire [N-1:0]        f_k    = dt[NLT-1][2*N*NQ +: N] & {N{dv[NLT-1]}};
  wire [PW-1:0]       f_wp   = dw[NLT-1];
  wire                f_done = ddn[NLT-1];
  wire                f_r0   = dt[NLT-1][TW-1];

  // Buffer of the partial word; entry e is written when its keep bit is set.
  reg  [SLOT_W-1:0] slot [0:N-1];
  // Round start bit of buffer entry 0, the only one osync needs.
  reg               slot_r0 = 1'b0;

  initial begin
    for (i = 0; i < N; i = i + 1) slot[i] = 'd0;
  end

  always @(posedge clk) begin
    for (i = 0; i < N; i = i + 1)
      if (f_k[i]) slot[i] <= f_d[i*SLOT_W +: SLOT_W];
    if (f_k[0]) slot_r0 <= f_r0;
  end

  always @(posedge clk) begin
    if (stop) begin
      ovalid <= 1'b0;
      osync  <= 1'b0;
    end else begin
      ovalid <= f_done;
      osync  <= f_done & ((f_wp == 0 && f_k[0]) ? f_r0 : slot_r0);
    end
  end

  // The entries from wp on that this cycle writes complete the word, the ones
  // below wp are stored; the written entries below wp start the next word.
  always @(posedge clk) begin
    for (i = 0; i < N; i = i + 1)
      odata[i*SLOT_W +: SLOT_W] <= (i >= f_wp && f_k[i]) ? f_d[i*SLOT_W +: SLOT_W] : slot[i];
  end

endmodule
