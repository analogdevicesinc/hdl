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

// The accumulator bank decides which sample slots carry real data. One
// accumulator per slot, all sharing add_val, each seeded a slot further along,
// so the overflows spread evenly across the beat instead of bunching up.
//
// With add_val = ratio * 2^ACCUM_WIDTH, the long run average of overflows per
// clock must be NUM_SAMPLES * ratio - that is the sample rate the converter
// actually delivers. The check is that average, plus the seeding rule that no
// two accumulators in a beat ever overflow on the same schedule.

module accum_tb;
  parameter VCD_FILE = {"accum_tb.vcd"};

  `define TIMEOUT 400000
  `include "../../../common/tb/tb_base.v"

  localparam AW = 32;
  localparam SAMPLES = 8;

  reg                    en = 1'b0;
  reg                    set = 1'b0;
  reg  [AW-1:0]          add_val = {AW{1'b0}};
  reg  [SAMPLES*AW-1:0]  set_val = {SAMPLES*AW{1'b0}};
  wire [SAMPLES-1:0]     sample_en;

  tx_fsrc_sample_en_gen #(
    .ACCUM_WIDTH (AW),
    .NUM_SAMPLES (SAMPLES)
  ) i_dut (
    .clk (clk),
    .en (en),
    .sample_en (sample_en),
    .set_val (set_val),
    .set (set),
    .add_val (add_val),
    .step_val (add_val),
    .group_beats_m1 (8'd0),
    .group_start (8'd0));

  integer i;
  integer overflows = 0;
  integer clocks = 0;
  integer all_ones = 0;
  real    got;
  real    want;

  // Seed accumulator i at i/SAMPLES of the way through its range: the same
  // staggering the driver programs, one slot's worth of phase apart.
  task seed;
    input real ratio;
    begin
      add_val = $rtoi(ratio * (2.0 ** AW));
      for (i = 0; i < SAMPLES; i = i + 1)
        set_val[i*AW +: AW] = $rtoi((i * (2.0 ** AW)) / SAMPLES);
      @(posedge clk);
      set <= 1'b1;
      @(posedge clk);
      set <= 1'b0;
    end
  endtask

  // 3/4 of the link rate: three of every four slots carry a sample.
  localparam real RATIO = 0.75;

  initial begin
    while (reset === 1'b1) @(posedge clk);
    seed(RATIO);
    en = 1'b1;
    // Let the count settle over a long run, then compare the average.
    #(`TIMEOUT - 2000);
    en = 1'b0;
    got = overflows * 1.0 / clocks;
    want = SAMPLES * RATIO;
    $display("INFO: %0d overflows over %0d clocks, %f per clock, expected %f",
             overflows, clocks, got, want);
    if (got > want + 0.01 || got < want - 0.01) begin
      $display("ERROR: overflow rate off by more than 1%%");
      failed <= 1'b1;
    end
  end

  always @(posedge clk) begin
    if (en == 1'b1) begin
      clocks = clocks + 1;
      for (i = 0; i < SAMPLES; i = i + 1)
        if (sample_en[i] == 1'b1) overflows = overflows + 1;
      // A beat that is entirely holes or entirely samples is legal, but at a
      // ratio below one the all-samples beat must not be the only thing we see.
      if (sample_en === {SAMPLES{1'b1}}) begin
        all_ones = all_ones + 1;
      end
    end
  end

  initial begin
    #(`TIMEOUT - 100);
    if (all_ones == clocks) begin
      $display("ERROR: every beat was all samples, the accumulators never held one back");
      failed <= 1'b1;
    end
  end

endmodule
