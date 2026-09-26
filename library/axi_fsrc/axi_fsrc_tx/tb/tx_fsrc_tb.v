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

// tx_fsrc spreads the samples it is given over a wider set of slots, filling
// the slots it skips with the sentinel Apollo's interpolator discards. Inserting
// holes means fewer real samples leave per beat than arrive, so the core has to
// back-pressure its source; a source that ignores in_ready loses samples.
//
// Checks:
//   - stripping the sentinels from the output reproduces the input stream
//     exactly, in order, on every converter;
//   - the sentinel slots are the same on every converter, which is what lets the
//     receive side compact each converter independently and stay in lockstep;
//   - in_ready really does go low, so the test is exercising the back-pressure
//     rather than running at a rate where it never engages;
//   - the delivered sample rate matches the programmed accumulator ratio.

module tx_fsrc_tb;
  parameter VCD_FILE = {"tx_fsrc_tb.vcd"};

  `define TIMEOUT 400000
  `include "../../../common/tb/tb_base.v"

  localparam NP = 16;
  localparam SAMPLES = 4;
  localparam DW = NP * SAMPLES;
  localparam CONV = 2;
  localparam AW = 32;
  localparam HOLE = {1'b1, {(NP-1){1'b0}}};
  localparam real RATIO = 0.75;

  reg               fsrc_en = 1'b0;
  reg               fsrc_data_en = 1'b0;
  reg               accum_set = 1'b0;
  reg  [AW-1:0]     accum_add_val = {AW{1'b0}};
  reg  [SAMPLES*AW-1:0] accum_set_val = {SAMPLES*AW{1'b0}};

  wire [CONV-1:0]        in_ready;
  reg  [CONV*DW-1:0]     in_data = {CONV*DW{1'b0}};
  reg  [CONV-1:0]        in_valid = {CONV{1'b0}};
  wire [CONV*DW-1:0]     out_data;
  wire [CONV-1:0]        out_valid;
  reg  [CONV-1:0]        out_ready = {CONV{1'b1}};

  tx_fsrc #(
    .NP (NP),
    .DATA_WIDTH (DW),
    .MAX_CONV (CONV),
    .ACCUM_WIDTH (AW)
  ) i_dut (
    .clk (clk),
    .reset (reset),
    .fsrc_en (fsrc_en),
    .fsrc_data_en (fsrc_data_en),
    .conv_mask ({CONV{1'b1}}),
    .accum_set_val (accum_set_val),
    .accum_set (accum_set),
    .accum_add_val (accum_add_val),
    .accum_step_val (accum_add_val),
    .group_beats_m1 (8'd0),
    .group_start (8'd0),
    .in_ready (in_ready),
    .in_data (in_data),
    .in_valid (in_valid),
    .out_data (out_data),
    .out_valid (out_valid),
    .out_ready (out_ready));

  localparam EXP_DEPTH = 4096;
  reg [NP-1:0] expected [0:CONV*EXP_DEPTH-1];
  integer wr = 0;
  integer rd = 0;
  integer payload = 1;
  integer running = 0;
  integer stalled = 0;
  integer holes_seen = 0;
  integer slots_seen = 0;

  integer i;
  integer c;

  // Converter c carries payloads offset by c*SPAN, so a sample that ended up on
  // the wrong converter is visible.
  localparam SPAN = 4096;

  task load_beat;
    begin
      for (i = 0; i < SAMPLES; i = i + 1) begin
        for (c = 0; c < CONV; c = c + 1) begin
          in_data[c*DW + i*NP +: NP] = c*SPAN + payload;
          expected[c*EXP_DEPTH + (wr % EXP_DEPTH)] = c*SPAN + payload;
        end
        wr = wr + 1;
        payload = payload + 1;
        if (payload >= SPAN) payload = 1;
      end
    end
  endtask

  initial begin
    accum_add_val = $rtoi(RATIO * (2.0 ** AW));
    for (i = 0; i < SAMPLES; i = i + 1)
      accum_set_val[i*AW +: AW] = $rtoi((i * (2.0 ** AW)) / SAMPLES);
    while (reset === 1'b1) @(posedge clk);
    fsrc_en = 1'b1;
    @(posedge clk);
    accum_set <= 1'b1;
    @(posedge clk);
    accum_set <= 1'b0;
    fsrc_data_en = 1'b1;
    load_beat;
    in_valid = {CONV{1'b1}};
    running = 1;
  end

  // Source: hold the beat until the core takes it, which is the handshake a
  // source that cannot be back-pressured would get wrong.
  always @(posedge clk) begin
    if (reset == 1'b1) begin
      in_valid <= {CONV{1'b0}};
    end else if (running == 1) begin
      if (in_valid[0] == 1'b1 && in_ready[0] == 1'b1) begin
        load_beat;
      end else if (in_valid[0] == 1'b1 && in_ready[0] == 1'b0) begin
        stalled = stalled + 1;
      end
      // Every converter must accept together, otherwise the scalar handshake the
      // top level presents to the transport layer would not be sound.
      if (in_ready !== {CONV{1'b0}} && in_ready !== {CONV{1'b1}}) begin
        $display("ERROR: in_ready split across converters: %b", in_ready);
        failed <= 1'b1;
      end
    end
  end

  // Sink: stall at random so the output side back-pressure is exercised too.
  always @(posedge clk) begin
    if (reset == 1'b0) out_ready <= {CONV{($random % 5) != 0}};
  end

  reg [SAMPLES-1:0] holes_0;
  reg [SAMPLES-1:0] holes_c;

  always @(posedge clk) begin
    if (reset == 1'b0 && running == 1 && out_valid[0] == 1'b1 && out_ready[0] == 1'b1) begin
      if (out_valid !== {CONV{1'b1}}) begin
        $display("ERROR: out_valid split across converters: %b", out_valid);
        failed <= 1'b1;
      end
      for (i = 0; i < SAMPLES; i = i + 1)
        holes_0[i] = out_data[0*DW + i*NP +: NP] === HOLE;
      for (c = 1; c < CONV; c = c + 1) begin
        for (i = 0; i < SAMPLES; i = i + 1)
          holes_c[i] = out_data[c*DW + i*NP +: NP] === HOLE;
        if (holes_c !== holes_0) begin
          $display("ERROR: conv %0d holes %b but conv 0 holes %b", c, holes_c, holes_0);
          failed <= 1'b1;
        end
      end
      slots_seen = slots_seen + SAMPLES;
      for (i = 0; i < SAMPLES; i = i + 1) begin
        if (holes_0[i] == 1'b1) begin
          holes_seen = holes_seen + 1;
        end else begin
          for (c = 0; c < CONV; c = c + 1) begin
            if (out_data[c*DW + i*NP +: NP] !== expected[c*EXP_DEPTH + (rd % EXP_DEPTH)]) begin
              $display("ERROR: conv %0d sample %0d: got %h expected %h", c, rd,
                       out_data[c*DW + i*NP +: NP],
                       expected[c*EXP_DEPTH + (rd % EXP_DEPTH)]);
              failed <= 1'b1;
            end
          end
          rd = rd + 1;
        end
      end
    end
  end

  real got;

  initial begin
    #(`TIMEOUT - 100);
    got = (slots_seen - holes_seen) * 1.0 / slots_seen;
    $display("INFO: %0d samples in, %0d out over %0d slots, %f real, expected %f",
             wr, rd, slots_seen, got, RATIO);
    $display("INFO: source stalled on %0d clocks", stalled);
    if (rd == 0 || slots_seen == 0) begin
      $display("ERROR: no data moved");
      failed <= 1'b1;
    end
    if (stalled == 0) begin
      $display("ERROR: in_ready never went low, back-pressure was not exercised");
      failed <= 1'b1;
    end
    if (got > RATIO + 0.02 || got < RATIO - 0.02) begin
      $display("ERROR: delivered sample rate does not match the accumulator ratio");
      failed <= 1'b1;
    end
  end

endmodule
