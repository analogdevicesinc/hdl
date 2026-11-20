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

// Slot compactor.
//
// Every cycle up to IN_SLOTS slots of SLOT_W bits arrive, each with its own
// keep bit. The kept slots are collected in arrival order and every OUT_SLOTS
// of them leave as one output word with ovalid. Dropped slots leave no gap: the
// output stream is exactly the sequence of kept slots. A slot is typically one
// sample; a wider sample can occupy several slots that are always kept
// together.
//
// Slot 0 is the earliest in both directions, and it occupies the least
// significant bits of the word. On an AXI bus this puts the earlier slot at the
// lower address, so the memory image is the same as with one slot per beat.
//
// odata is only valid in the cycle ovalid is set; it may change in between.
//
// The datapath is a chain of levels:
//   log2(IN_SLOTS) prefix levels count the dropped slots below every slot,
//   log2(IN_SLOTS) network levels move every kept slot down by that count,
//     so the d-th kept slot of a cycle comes out at position d together with
//     its keep bit,
//   the rotation by the write pointer wp into a buffer of OUT_SLOTS entries,
//     so every word starts at entry 0, log2(OUT_SLOTS) levels,
//   the merge into the buffer and odata, one level.
// The cycle that fills the last entry loads odata from the buffer and from the
// slots it brings itself; the slots past the end of the word wrap to the start
// of the buffer.
//
// PIPE_STAGES is the number of registers in the chain, spread evenly over the
// levels by the same rule for every size:
//  -1: automatic, the fewest registers that leave no cycle with more than
//      LEVEL_BUDGET levels; LEVEL_BUDGET = 0 takes 4 up to 16 slots, 3 up to
//      32 and 2 above, measured at about 200 MHz on 7 series
//   0: no register
//   n: n registers, at most one per level
// PIPE_MASK, if not 0, places the registers by hand instead: bit g puts one
// after level g.
// A mux rotation cannot be split; registers that would fall into it go in
// front of it. Levels after a register in a barrel rotation use a copy of wp
// delayed with the data. The wp update itself, an add and a compare, is one
// cycle and is not split; it bounds the clock rate.
//
// ROT_IMPL selects the rotation independently:
//   0: automatic, a barrel if a register falls into the rotation or, without
//      any register, if IN_SLOTS >= 4 and OUT_SLOTS > IN_SLOTS; otherwise a mux
//   1: every entry is an IN_SLOTS:1 mux selected by wp
//   2: barrel rotation by wp
//
// There is no backpressure. Up to IN_SLOTS slots arrive per cycle and up to
// OUT_SLOTS leave, so IN_SLOTS <= OUT_SLOTS keeps the buffer from overflowing.
// Slots that do not fill a whole word stay in the buffer until reset. A word
// leaves LATENCY cycles after the slot that completes it arrives.
//
// With ASYNC_RESET the write pointer, the pipeline keep bits and ovalid are
// reset asynchronously, so ovalid drops as soon as reset rises, also while clk
// is stopped.
//
// Example, IN_SLOTS = 4, OUT_SLOTS = 4, PIPE_STAGES = 0, slots listed as
// [0 1 2 3]:
//
//   cycle  idata      ikeep      written              wp  ovalid  odata
//     0    [a b c d]  [1 0 1 1]  e0=a e1=c e2=d       0     0
//     1    [e f g h]  [0 1 1 0]  e3=f e0=g            3     0
//     2    [i j k l]  [1 1 1 1]  e1=i e2=j e3=k e0=l  1     1    [a c d f]
//     3    [m n o p]  [0 0 0 1]  e1=p                 1     1    [g i j k]
//     4    [q r s t]  [1 0 0 0]  e2=q                 2     0
//     5    [u v w x]  [0 1 0 0]  e3=v                 3     0
//     6                                               0     1    [l p q v]
//
//   The kept slots leave in order as [a c d f] [g i j k] [l p q v], with no
//   gap for the dropped ones. f completes the first word in cycle 1 and the
//   word leaves in cycle 2; g wraps around to e0 in the same cycle. In cycle
//   2 l goes to e0 while [g i j k] is loaded, which still takes g, the value
//   before the write. After cycle 3 l p wait in the buffer until v completes
//   their word.

`timescale 1ns/100ps

module ad_sample_compact #(
  parameter SLOT_W           = 16,
  parameter IN_SLOTS         = 2,
  parameter OUT_SLOTS        = 2,
  parameter ASYNC_RESET      = 0,
  parameter ROT_IMPL         = 0,
  parameter PIPE_STAGES      = -1,
  parameter LEVEL_BUDGET     = 0,
  parameter [63:0] PIPE_MASK = 64'd0
) (
  input                               clk,
  input                               reset,

  input       [IN_SLOTS*SLOT_W-1:0]   idata,
  input       [IN_SLOTS-1:0]          ikeep,

  output reg  [OUT_SLOTS*SLOT_W-1:0]  odata = 'd0,
  output reg                          ovalid = 1'b0
);

  // buffer depth
  localparam DEPTH = OUT_SLOTS;

  // Pointer Width, wp
  localparam PW = ($clog2(DEPTH) < 1) ? 1 : $clog2(DEPTH);
  // Count Width, up to 2*DEPTH
  localparam CW = $clog2(2*DEPTH+1);
  // Index Width of an input slot
  localparam IW = (IN_SLOTS > 1) ? $clog2(IN_SLOTS) : 1;
  // Shift Width, dropped count 0..IN_SLOTS
  localparam SW = IW + 1;
  // Number of Prefix levels, also the number of network levels
  localparam NP = (IN_SLOTS > 1) ? $clog2(IN_SLOTS) : 0;
  // Number of Rotation levels
  localparam NR = (DEPTH > 1) ? $clog2(DEPTH) : 0;

  // Levels 0 to NLT - 1: prefix, network, rotation, then the merge into the
  // buffer and odata. The rotation counts log2(OUT_SLOTS) levels either way,
  // a mux just cannot be split, so its registers move in front of it.
  // Number of Levels Total
  localparam NLT  = 2 * NP + NR + 1;
  // Rotation Start level
  localparam RS0  = 2 * NP;
  // Level Budget: levels per cycle at about 200 MHz on xc7z020; wider levels route longer.
  localparam LB   = (LEVEL_BUDGET > 0) ? LEVEL_BUDGET :
                    (IN_SLOTS <= 16) ? 4 : (IN_SLOTS <= 32) ? 3 : 2;
  // Registers requested
  localparam R0   = (PIPE_STAGES >= 0) ? PIPE_STAGES : (NLT + LB - 1) / LB - 1;
  // Register Quantity, at most one per level
  localparam RQ   = (R0 < NLT - 1) ? R0 : NLT - 1;

  // Level after which register m of rq sits, before any move.
  function integer pos;
    input integer m;
    input integer rq;
    input integer nlt;
    begin
      pos = (m * nlt) / (rq + 1) - 1;
    end
  endfunction

  // A register after level g, with the mux moves applied.
  function is_reg_f;
    input integer g;
    input integer rq;
    input integer nlt;
    input integer mux;
    input [63:0] mask;
    integer m, q;
    begin
      is_reg_f = 0;
      for (m = 0; m < nlt - 1; m = m + 1) begin
        q = m;
        if (mux != 0 && q >= RS0) q = RS0 - 1;
        if (mask != 0 && mask[m] && q == g) is_reg_f = 1;
      end
      for (m = 1; m <= rq; m = m + 1) begin
        q = pos(m, rq, nlt);
        if (mux != 0 && q >= RS0) q = RS0 - 1;
        if (mask == 0 && q == g) is_reg_f = 1;
      end
    end
  endfunction

  // A register would fall into the rotation.
  function rot_reg_f;
    input integer rq;
    input integer nlt;
    input [63:0] mask;
    integer m, q;
    begin
      rot_reg_f = 0;
      for (m = 0; m < nlt - 1; m = m + 1)
        if (mask != 0 && mask[m] && m >= RS0) rot_reg_f = 1;
      for (m = 1; m <= rq; m = m + 1) begin
        q = pos(m, rq, nlt);
        if (mask == 0 && q >= RS0) rot_reg_f = 1;
      end
    end
  endfunction

  // ROTation implementation: 1 mux, 2 barrel. MUX = 1 for the mux rotation.
  localparam ROT = (ROT_IMPL != 0) ? ROT_IMPL :
                   (NR > 0 && rot_reg_f(RQ, NLT, PIPE_MASK)) ? 2 :
                   (PIPE_MASK == 0 && RQ == 0 && IN_SLOTS >= 4 && OUT_SLOTS > IN_SLOTS) ? 2 : 1;
  localparam MUX = (ROT == 2) ? 0 : 1;

  // Registers actually placed; sets LATENCY.
  function integer nregs_f;
    input integer dummy;
    integer g;
    begin
      nregs_f = 0;
      for (g = 0; g < NLT - 1; g = g + 1)
        if (is_reg_f(g, RQ, NLT, MUX, PIPE_MASK)) nregs_f = nregs_f + 1;
    end
  endfunction

  localparam LATENCY = nregs_f(0) + 1;

  generate
  if (IN_SLOTS > OUT_SLOTS) begin : g_cfg_error
    $error("ad_sample_compact: IN_SLOTS must not exceed OUT_SLOTS");
    ad_sample_compact_ERROR_in_slots_exceed_out_slots i_cfg_error ();
  end
  if (ROT_IMPL > 2 || PIPE_STAGES < -1) begin : g_par_error
    $error("ad_sample_compact: ROT_IMPL must be 0 to 2, PIPE_STAGES at least -1");
    ad_sample_compact_ERROR_bad_parameter i_par_error ();
  end
  endgenerate

  // Async / Sync ReSeT; ASYNC_RESET selects one, the other is tied off.
  wire arst = (ASYNC_RESET != 0) ? reset : 1'b0;
  wire srst = (ASYNC_RESET != 0) ? 1'b0 : reset;

  genvar p, l, r, j;
  integer i, e;

  // Prefix levels: ppf[j] ends up as the number of dropped slots 0 to j.
  // pd/pk: Prefix-level Data/Keep, ppf: Prefix sum of dropped slots (Prefix Field).
  wire [IN_SLOTS*SLOT_W-1:0] pd  [0:NP];
  wire [IN_SLOTS-1:0]        pk  [0:NP];
  wire [IN_SLOTS*SW-1:0]     ppf [0:NP];

  assign pd[0] = idata;
  assign pk[0] = ikeep;

  generate
  for (j = 0; j < IN_SLOTS; j = j + 1) begin : g_pf0
    assign ppf[0][j*SW +: SW] = {{IW{1'b0}}, ~ikeep[j]};
  end

  for (p = 0; p < NP; p = p + 1) begin : g_pf
    // next ppf row
    wire [IN_SLOTS*SW-1:0] nxt;

    for (j = 0; j < IN_SLOTS; j = j + 1) begin : g_j
      if (j >= (1 << p)) begin : g_add
        assign nxt[j*SW +: SW] = ppf[p][j*SW +: SW] + ppf[p][(j-(1<<p))*SW +: SW];
      end else begin : g_keep
        assign nxt[j*SW +: SW] = ppf[p][j*SW +: SW];
      end
    end

    // Optional register after this level; data passes along unchanged.
    if (is_reg_f(p, RQ, NLT, MUX, PIPE_MASK)) begin : g_reg
      reg [IN_SLOTS*SLOT_W-1:0] q_d  = 'd0;
      reg [IN_SLOTS*SW-1:0]     q_pf = 'd0;
      reg [IN_SLOTS-1:0]        q_k  = 'd0;

      always @(posedge clk) begin
        q_d  <= pd[p];
        q_pf <= nxt;
      end

      always @(posedge clk or posedge arst) begin
        if (arst || srst) q_k <= 'd0;
        else              q_k <= pk[p];
      end

      assign pd[p+1]  = q_d;
      assign pk[p+1]  = q_k;
      assign ppf[p+1] = q_pf;
    end else begin : g_comb
      assign pd[p+1]  = pd[p];
      assign pk[p+1]  = pk[p];
      assign ppf[p+1] = nxt;
    end
  end
  endgenerate

  // Network levels: level l moves a slot down by 2^l if bit l of its distance
  // ns is set. nn is the number of kept slots.
  // nd/nk/ns/nn: Network-level Data/Keep/Shift distance/Number kept.
  // xd/xk/xs: the same after this level; q_*: their registered copies.
  wire [IN_SLOTS*SLOT_W-1:0] nd [0:NP];
  wire [IN_SLOTS-1:0]        nk [0:NP];
  wire [IN_SLOTS*SW-1:0]     ns [0:NP];
  wire [CW-1:0]              nn [0:NP];

  assign nd[0] = pd[NP];
  assign nk[0] = pk[NP];
  assign nn[0] = IN_SLOTS - ppf[NP][(IN_SLOTS-1)*SW +: SW];

  generate
  for (j = 0; j < IN_SLOTS; j = j + 1) begin : g_ns0
    if (j == 0) begin : g_first
      assign ns[0][0 +: SW] = 'd0;
    end else begin : g_rest
      assign ns[0][j*SW +: SW] = ppf[NP][(j-1)*SW +: SW];
    end
  end

  for (l = 0; l < NP; l = l + 1) begin : g_net
    wire [IN_SLOTS*SLOT_W-1:0] xd;
    wire [IN_SLOTS-1:0]        xk;
    wire [IN_SLOTS*SW-1:0]     xs;

    // Slot j takes slot j+2^l if that one moves; a slot that moves clears its own keep bit.
    for (j = 0; j < IN_SLOTS; j = j + 1) begin : g_j
      if (j + (1 << l) < IN_SLOTS) begin : g_mv
        wire take = nk[l][j+(1<<l)] & ns[l][(j+(1<<l))*SW + l];
        assign xd[j*SLOT_W +: SLOT_W] = take ? nd[l][(j+(1<<l))*SLOT_W +: SLOT_W] :
                                               nd[l][j*SLOT_W +: SLOT_W];
        assign xk[j] = take | (nk[l][j] & ~ns[l][j*SW + l]);
        assign xs[j*SW +: SW] = take ? ns[l][(j+(1<<l))*SW +: SW] : ns[l][j*SW +: SW];
      end else begin : g_top
        assign xd[j*SLOT_W +: SLOT_W] = nd[l][j*SLOT_W +: SLOT_W];
        assign xk[j] = nk[l][j] & ~ns[l][j*SW + l];
        assign xs[j*SW +: SW] = ns[l][j*SW +: SW];
      end
    end

    if (is_reg_f(NP + l, RQ, NLT, MUX, PIPE_MASK)) begin : g_reg
      reg [IN_SLOTS*SLOT_W-1:0] q_d = 'd0;
      reg [IN_SLOTS*SW-1:0]     q_s = 'd0;
      reg [IN_SLOTS-1:0]        q_k = 'd0;
      reg [CW-1:0]              q_n = 'd0;

      always @(posedge clk) begin
        q_d <= xd;
        q_s <= xs;
      end

      always @(posedge clk or posedge arst) begin
        if (arst || srst) begin
          q_k <= 'd0;
          q_n <= 'd0;
        end else begin
          q_k <= xk;
          q_n <= nn[l];
        end
      end

      assign nd[l+1] = q_d;
      assign nk[l+1] = q_k;
      assign ns[l+1] = q_s;
      assign nn[l+1] = q_n;
    end else begin : g_comb
      assign nd[l+1] = xd;
      assign nk[l+1] = xk;
      assign ns[l+1] = xs;
      assign nn[l+1] = nn[l];
    end
  end
  endgenerate

  // The write pointer advances by the kept count at the first rotation level.
  // wp: Write Pointer, wp_nx: its NeXt value, done: this cycle completes a word.
  reg  [PW-1:0] wp = 'd0;

  wire [CW-1:0] wp_add = wp + nn[NP];
  wire          done   = (wp_add >= DEPTH);
  wire [PW-1:0] wp_nx  = done ? wp_add - DEPTH : wp_add;

  // f_*: the rotated slots with the wp and done of their cycle (Final level).
  wire [DEPTH*SLOT_W-1:0] f_d;
  wire [DEPTH-1:0]        f_k;
  wire [PW-1:0]           f_wp;
  wire                    f_done;

  generate
  // Barrel: level r rotates up by 2^r if bit r of wp is set.
  // rd/rk/rw/rdn: Rotation-level Data/Keep/Write pointer/DoNe.
  if (ROT == 2) begin : g_rot_barrel
    wire [DEPTH*SLOT_W-1:0] rd  [0:NR];
    wire [DEPTH-1:0]        rk  [0:NR];
    wire [PW-1:0]           rw  [0:NR];
    wire                    rdn [0:NR];

    for (j = 0; j < DEPTH; j = j + 1) begin : g_pad
      if (j < IN_SLOTS) begin : g_in
        assign rd[0][j*SLOT_W +: SLOT_W] = nd[NP][j*SLOT_W +: SLOT_W];
        assign rk[0][j] = nk[NP][j];
      end else begin : g_zero
        assign rd[0][j*SLOT_W +: SLOT_W] = 'd0;
        assign rk[0][j] = 1'b0;
      end
    end
    assign rw[0]  = wp;
    assign rdn[0] = done;

    for (r = 0; r < NR; r = r + 1) begin : g_rot
      wire [DEPTH*SLOT_W-1:0] xd;
      wire [DEPTH-1:0]        xk;

      for (j = 0; j < DEPTH; j = j + 1) begin : g_j
        assign xd[j*SLOT_W +: SLOT_W] = rw[r][r] ?
          rd[r][((j + DEPTH - (1 << r)) % DEPTH)*SLOT_W +: SLOT_W] : rd[r][j*SLOT_W +: SLOT_W];
        assign xk[j] = rw[r][r] ? rk[r][(j + DEPTH - (1 << r)) % DEPTH] : rk[r][j];
      end

      if (is_reg_f(2 * NP + r, RQ, NLT, MUX, PIPE_MASK)) begin : g_reg
        reg [DEPTH*SLOT_W-1:0] q_d  = 'd0;
        reg [DEPTH-1:0]        q_k  = 'd0;
        reg [PW-1:0]           q_w  = 'd0;
        reg                    q_dn = 1'b0;

        always @(posedge clk) begin
          q_d <= xd;
        end

        always @(posedge clk or posedge arst) begin
          if (arst || srst) begin
            q_k  <= 'd0;
            q_w  <= 'd0;
            q_dn <= 1'b0;
          end else begin
            q_k  <= xk;
            q_w  <= rw[r];
            q_dn <= rdn[r];
          end
        end

        assign rd[r+1]  = q_d;
        assign rk[r+1]  = q_k;
        assign rw[r+1]  = q_w;
        assign rdn[r+1] = q_dn;
      end else begin : g_comb
        assign rd[r+1]  = xd;
        assign rk[r+1]  = xk;
        assign rw[r+1]  = rw[r];
        assign rdn[r+1] = rdn[r];
      end
    end

    assign f_d    = rd[NR];
    assign f_k    = rk[NR];
    assign f_wp   = rw[NR];
    assign f_done = rdn[NR];
  // Mux: entry e takes slot (e - wp) mod DEPTH.
  // md/mk: Mux Data/Keep, off: OFFset of entry e from wp.
  end else begin : g_rot_mux
    reg [DEPTH*SLOT_W-1:0] md;
    reg [DEPTH-1:0]        mk;
    reg [PW-1:0]           off;

    always @(*) begin
      for (e = 0; e < DEPTH; e = e + 1) begin
        off = (e >= wp) ? e - wp : e + DEPTH - wp;
        md[e*SLOT_W +: SLOT_W] = 'd0;
        mk[e] = 1'b0;
        for (i = 0; i < IN_SLOTS; i = i + 1) begin
          if (off == i) begin
            md[e*SLOT_W +: SLOT_W] = nd[NP][i*SLOT_W +: SLOT_W];
            mk[e] = nk[NP][i];
          end
        end
      end
    end

    assign f_d    = md;
    assign f_k    = mk;
    assign f_wp   = wp;
    assign f_done = done;
  end
  endgenerate

  // Buffer of the partial word; entry e is written when its rotated keep bit is set.
  reg  [SLOT_W-1:0] slot [0:DEPTH-1];

  initial begin
    for (i = 0; i < DEPTH; i = i + 1) slot[i] = 'd0;
  end

  always @(posedge clk) begin
    for (i = 0; i < DEPTH; i = i + 1)
      if (f_k[i]) slot[i] <= f_d[i*SLOT_W +: SLOT_W];
  end

  always @(posedge clk or posedge arst) begin
    if (arst || srst) begin
      wp      <= 'd0;
      ovalid  <= 1'b0;
    end else begin
      wp      <= wp_nx;
      ovalid  <= f_done;
    end
  end

  // The entries from wp on that this cycle writes complete the word, the ones
  // below wp are stored; the written entries below wp start the next word.
  always @(posedge clk) begin
    for (i = 0; i < OUT_SLOTS; i = i + 1)
      odata[i*SLOT_W +: SLOT_W] <= (i >= f_wp && f_k[i]) ? f_d[i*SLOT_W +: SLOT_W] : slot[i];
  end

endmodule
