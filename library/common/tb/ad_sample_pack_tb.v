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

// ad_sample_pack: every enable mask and sample_slots_select against the position
// formula.
//
// The model places the slots of each valid cycle with the inverse of the
// formula: position d is slot d%ss of sample (d/ss)/K of
// the ((d/ss)%K)-th enabled channel, ss the slots per sample. Every output word must be the next
// OUT_SLOTS slots of the model queue. Each configuration runs with dense and
// sparse ivalid.

`timescale 1ns/100ps

module ad_sample_pack_tb;

  parameter VCD_FILE = "ad_sample_pack_tb.vcd";

  `define TIMEOUT 200000000
  `include "tb_base.v"

  wire [19:0] c_fail;
  wire [19:0] c_done;

  ad_sample_pack_case #(.NUM_CH(2), .CH_SLOTS(2), .OUT_SLOTS(4), .SEED(1)) i_c0 (.clk(clk), .fail(c_fail[0]), .done(c_done[0]));
  ad_sample_pack_case #(.NUM_CH(1), .CH_SLOTS(4), .OUT_SLOTS(4), .SEED(2)) i_c1 (.clk(clk), .fail(c_fail[1]), .done(c_done[1]));
  ad_sample_pack_case #(.NUM_CH(4), .CH_SLOTS(2), .OUT_SLOTS(8), .SEED(3)) i_c2 (.clk(clk), .fail(c_fail[2]), .done(c_done[2]));
  ad_sample_pack_case #(.NUM_CH(4), .CH_SLOTS(1), .OUT_SLOTS(4), .SEED(4)) i_c3 (.clk(clk), .fail(c_fail[3]), .done(c_done[3]));
  ad_sample_pack_case #(.NUM_CH(2), .CH_SLOTS(4), .OUT_SLOTS(8), .SEED(5), .CDC(1)) i_c4 (.clk(clk), .fail(c_fail[4]), .done(c_done[4]));
  ad_sample_pack_case #(.NUM_CH(4), .CH_SLOTS(4), .OUT_SLOTS(16), .SEED(6)) i_c5 (.clk(clk), .fail(c_fail[5]), .done(c_done[5]));
  ad_sample_pack_case #(.NUM_CH(8), .CH_SLOTS(2), .OUT_SLOTS(16), .SEED(7)) i_c6 (.clk(clk), .fail(c_fail[6]), .done(c_done[6]));
  ad_sample_pack_case #(.NUM_CH(2), .CH_SLOTS(1), .OUT_SLOTS(2), .SEED(8)) i_c7 (.clk(clk), .fail(c_fail[7]), .done(c_done[7]));
  // fixed sample size: sample_slots_select is ignored and a sample is one slot
  ad_sample_pack_case #(.NUM_CH(2), .CH_SLOTS(2), .OUT_SLOTS(4), .SEED(9), .ENABLE_SAMPLE_SLOTS_SELECT(0)) i_c8 (.clk(clk), .fail(c_fail[8]), .done(c_done[8]));
  ad_sample_pack_case #(.NUM_CH(4), .CH_SLOTS(2), .OUT_SLOTS(8), .SEED(10), .ENABLE_SAMPLE_SLOTS_SELECT(0)) i_c9 (.clk(clk), .fail(c_fail[9]), .done(c_done[9]));
  // pipeline variants
  ad_sample_pack_case #(.NUM_CH(2), .CH_SLOTS(2), .OUT_SLOTS(4), .SEED(11), .PIPE(0)) i_c10 (.clk(clk), .fail(c_fail[10]), .done(c_done[10]));
  ad_sample_pack_case #(.NUM_CH(4), .CH_SLOTS(2), .OUT_SLOTS(8), .SEED(12), .PIPE(1)) i_c11 (.clk(clk), .fail(c_fail[11]), .done(c_done[11]));
  ad_sample_pack_case #(.NUM_CH(8), .CH_SLOTS(2), .OUT_SLOTS(16), .SEED(13), .PIPE(3)) i_c12 (.clk(clk), .fail(c_fail[12]), .done(c_done[12]));
  ad_sample_pack_case #(.NUM_CH(8), .CH_SLOTS(2), .OUT_SLOTS(16), .SEED(14), .PIPE(9)) i_c13 (.clk(clk), .fail(c_fail[13]), .done(c_done[13]));
  ad_sample_pack_case #(.NUM_CH(4), .CH_SLOTS(4), .OUT_SLOTS(16), .SEED(15), .MASK(64'h4)) i_c14 (.clk(clk), .fail(c_fail[14]), .done(c_done[14]));
  ad_sample_pack_case #(.NUM_CH(4), .CH_SLOTS(8), .OUT_SLOTS(32), .SEED(16), .MASK(64'hA)) i_c15 (.clk(clk), .fail(c_fail[15]), .done(c_done[15]));
  // single slots dropped as well, a random slot_enable with every configuration
  ad_sample_pack_case #(.NUM_CH(2), .CH_SLOTS(2), .OUT_SLOTS(4), .SEED(17), .SLOTEN(1)) i_c16 (.clk(clk), .fail(c_fail[16]), .done(c_done[16]));
  ad_sample_pack_case #(.NUM_CH(4), .CH_SLOTS(2), .OUT_SLOTS(8), .SEED(18), .SLOTEN(1), .PIPE(2), .CDC(1)) i_c17 (.clk(clk), .fail(c_fail[17]), .done(c_done[17]));
  // channels and slots kept on by parameter: the channel mask alone, and both with slot_enable
  ad_sample_pack_case #(.NUM_CH(4), .CH_SLOTS(2), .OUT_SLOTS(8), .SEED(19), .EMASK(64'h4)) i_c18 (.clk(clk), .fail(c_fail[18]), .done(c_done[18]));
  ad_sample_pack_case #(.NUM_CH(4), .CH_SLOTS(2), .OUT_SLOTS(8), .SEED(20), .SLOTEN(1), .EMASK(64'h1), .SMASK(64'h8)) i_c19 (.clk(clk), .fail(c_fail[19]), .done(c_done[19]));

  // tb_base reports SUCCESS at its timeout unless failed is set.
  initial failed = 1'b1;

  initial begin
    wait (&c_done);
    @(posedge clk);
    failed = |c_fail;
    if (failed == 1'b0) $display("SUCCESS");
    else                $display("FAILED");
    $finish;
  end

endmodule

module ad_sample_pack_case #(
  parameter NUM_CH    = 2,
  parameter CH_SLOTS  = 2,
  parameter OUT_SLOTS = 4,
  parameter SEED      = 1,
  parameter ENABLE_SAMPLE_SLOTS_SELECT = 1,
  parameter PIPE      = -1,
  parameter CDC       = 0,
  parameter SLOTEN    = 0,
  parameter [63:0] EMASK = 64'd0,
  parameter [63:0] SMASK = 64'd0,
  parameter [63:0] MASK = 64'd0
) (
  input       clk,
  output reg  fail = 1'b0,
  output reg  done = 1'b0
);

  localparam SLOT_W = 16;
  localparam MW  = $clog2(CH_SLOTS+1);
  localparam LW  = (CH_SLOTS >= 256) ? 4 : (CH_SLOTS >= 16) ? 3 : (CH_SLOTS >= 4) ? 2 : 1;
  localparam NSS = $clog2(CH_SLOTS) + 1;
  localparam N  = NUM_CH*CH_SLOTS;

  reg                            reset = 1'b1;
  reg  [NUM_CH-1:0]              enable = 'd0;
  reg  [N-1:0]                   slot_enable = {N{1'b1}};
  // the slots and channels the model keeps, the masks included
  wire [N-1:0]                   sen = (SLOTEN != 0) ? slot_enable | SMASK[N-1:0] : {N{1'b1}};
  wire [NUM_CH-1:0]              men = enable | EMASK[NUM_CH-1:0];
  reg  [LW-1:0]                  sample_slots_select = 'd0;
  reg  [NUM_CH*CH_SLOTS*SLOT_W-1:0] idata = 'd0;
  reg                            ivalid = 1'b0;
  wire [OUT_SLOTS*SLOT_W-1:0]    odata;
  wire                           ovalid;
  wire                           osync;
  // slots per sample as the model uses it; 0 for an invalid select, no output
  wire [MW-1:0]                  ss = (ENABLE_SAMPLE_SLOTS_SELECT == 0) ? 'd1 :
                                      (sample_slots_select < NSS) ? (1 << sample_slots_select) : 'd0;

  ad_sample_pack #(
    .SLOT_W(SLOT_W),
    .NUM_CH(NUM_CH),
    .CH_SLOTS(CH_SLOTS),
    .OUT_SLOTS(OUT_SLOTS),
    .SAMPLE_SLOTS_SELECT_WIDTH(LW),
    .ENABLE_SAMPLE_SLOTS_SELECT(ENABLE_SAMPLE_SLOTS_SELECT),
    .CONFIG_CDC(CDC),
    .SLOT_ENABLE(SLOTEN),
    .ALWAYS_ENABLE_MASK(EMASK[NUM_CH-1:0]),
    .ALWAYS_SLOT_ENABLE_MASK(SMASK[N-1:0]),
    .PIPE_STAGES(PIPE),
    .PIPE_MASK(MASK)
  ) i_dut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .sample_slots_select(sample_slots_select),
    .slot_enable(slot_enable),
    .config_hold(1'b0),
    .idata(idata),
    .ivalid(ivalid),
    .odata(odata),
    .ovalid(ovalid),
    .osync(osync));

  reg  [SLOT_W-1:0] q [0:65535];
  // Set on the slots that start a round of the enabled channels.
  reg               tq [0:65535];
  integer qw = 0, qr = 0;
  integer seed = SEED;
  integer nwords = 0;
  integer ck, rk, mk, d, qq, mm, r, s, c, kk, cnt, rate, cfg, nss, src, seen, sm;

  // Model: the slots of every valid cycle in interleaved order, kept if their
  // channel and slot are enabled; a round starts at its first kept slot.
  always @(posedge clk) begin
    if (ivalid && !reset) begin
      for (kk = 0; (1 << kk) <= CH_SLOTS; kk = kk + 1) begin
        if (ss == (1 << kk)) begin
          seen = 0;
          for (d = 0; d < N; d = d + 1) begin
            if (d % (NUM_CH << kk) == 0) seen = 0;
            c   = (d >> kk) % NUM_CH;
            s   = (d >> kk) / NUM_CH;
            mm  = d % (1 << kk);
            src = c*CH_SLOTS + s*(1 << kk) + mm;
            if (men[c] && sen[src]) begin
              q[qw[15:0]] = idata[src*SLOT_W +: SLOT_W];
              tq[qw[15:0]] = !seen;
              seen = 1;
              qw = qw + 1;
            end
          end
        end
      end
    end
  end

  always @(posedge clk) begin
    if (ovalid) begin
      if (qr != qw && osync !== tq[qr[15:0]]) begin
        if (!fail) $display("FAIL %0dx%0d->%0d: enable %b sample_slots_select %0d word %0d osync %b expected %b",
          NUM_CH, CH_SLOTS, OUT_SLOTS, enable, sample_slots_select, nwords, osync, tq[qr[15:0]]);
        fail <= 1'b1;
      end
      for (ck = 0; ck < OUT_SLOTS; ck = ck + 1) begin
        if (qr == qw) begin
          if (!fail) $display("FAIL %0dx%0d->%0d: output slot %0d with nothing pending",
            NUM_CH, CH_SLOTS, OUT_SLOTS, ck);
          fail <= 1'b1;
        end else begin
          if (odata[ck*SLOT_W +: SLOT_W] !== q[qr[15:0]]) begin
            if (!fail) $display("FAIL %0dx%0d->%0d: enable %b sample_slots_select %0d word %0d slot %0d expected %04x got %04x",
              NUM_CH, CH_SLOTS, OUT_SLOTS, enable, sample_slots_select, nwords, ck, q[qr[15:0]], odata[ck*SLOT_W +: SLOT_W]);
            fail <= 1'b1;
          end
          qr = qr + 1;
        end
      end
      nwords = nwords + 1;
    end
  end

  task idle(input integer cycles);
    integer t;
    begin
      for (t = 0; t < cycles; t = t + 1) begin
        @(posedge clk);
        ivalid <= 1'b0;
      end
    end
  endtask

  task run(input integer cycles, input integer p);
    integer t;
    begin
      for (t = 0; t < cycles; t = t + 1) begin
        @(posedge clk);
        ivalid <= (($random(seed) & 255) < p);
        for (rk = 0; rk < NUM_CH*CH_SLOTS; rk = rk + 1)
          idata[rk*SLOT_W +: SLOT_W] <= $random(seed);
      end
    end
  endtask

  initial begin
    idle(8);
    for (cfg = 1; cfg < (1 << NUM_CH); cfg = cfg + 1) begin
      // Invalid values included, they must give no output.
      // every valid sample_slots_select and the first invalid one
      for (nss = 0; nss <= NSS; nss = nss + 1) begin
        // with SLOTEN every slot_enable value up to 4 slots, a random one above
        for (sm = 0; sm < ((SLOTEN != 0 && N <= 4) ? (1 << N) : 1); sm = sm + 1) begin
          for (rate = 0; rate < 2; rate = rate + 1) begin
            // Drain whole words, then drop the partial one with the change.
            idle(32);
            if (qw - qr >= OUT_SLOTS) begin
              if (!fail) $display("FAIL %0dx%0d->%0d: enable %b sample_slots_select %0d, %0d slots not delivered",
                NUM_CH, CH_SLOTS, OUT_SLOTS, enable, sample_slots_select, qw - qr);
              fail <= 1'b1;
            end
            qr = qw;
            @(posedge clk);
            reset  <= 1'b1;
            enable <= cfg;
            sample_slots_select <= nss;
            if (SLOTEN != 0) slot_enable <= (N <= 4) ? sm : $random(seed);
            idle(4);
            @(posedge clk);
            reset <= 1'b0;
            // The input is dropped until the routing table is filled.
            idle(NUM_CH*CH_SLOTS*(NUM_CH*CH_SLOTS + 2) + 16);
            run(400, rate ? 80 : 256);
          end
        end
      end
    end
    idle(32);
    $display("%0dx%0d->%0d: %0d words, %0d slots left in the last configuration %s",
      NUM_CH, CH_SLOTS, OUT_SLOTS, nwords, qw - qr, fail ? "FAIL" : "ok");
    done <= 1'b1;
  end

endmodule
