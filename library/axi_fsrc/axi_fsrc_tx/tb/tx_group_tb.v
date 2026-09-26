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

// The whole axi_fsrc_tx, programmed over AXI the way the driver does, against
// what Apollo's JRx rate match FIFO accepts: holes in groups of NS samples, a
// conv_clk worth, each group all valid or all invalid, group g valid when
// ((N-M) + M*g) mod N + M >= N. Every converter carries a ramp tagged with its
// index, so a lost, repeated or misplaced sample shows up as a ramp break or a
// wrong tag.

module tx_group_tb;
  parameter VCD_FILE = {"tx_group_tb.vcd"};
  parameter integer SAMPLES = 4;
  parameter integer NS = 8;
  parameter integer N = 5;
  parameter integer M = 4;
  parameter integer GSTART = 0;
  parameter integer CONV = 4;

  `define TIMEOUT 400000
  `include "../../../common/tb/tb_base.v"

  localparam NP = 16;
  localparam DW = NP * SAMPLES;
  localparam AW = 56;
  localparam [AW-1:0] BIAS = 1 << 20;
  localparam integer P = (NS <= SAMPLES) ? SAMPLES / NS : 1;
  localparam integer G = (NS > SAMPLES) ? NS / SAMPLES : 1;
  localparam integer LOG = 16384;

  reg  [CONV*DW-1:0] data_in;
  wire               data_in_ready;
  wire [CONV*DW-1:0] data_out;
  wire               data_out_valid;

  reg        awvalid = 0, wvalid = 0;
  reg [15:0] awaddr = 0;
  reg [31:0] wdata = 0;
  wire awready, wready, bvalid;

  axi_fsrc_tx #(.DATA_WIDTH (DW), .NP (NP), .MAX_CONV (CONV), .ACCUM_WIDTH (AW)) i_dut (
    .clk (clk), .reset (reset), .tx_data_start (1'b0),
    .data_in (data_in), .data_in_valid (1'b1), .data_in_ready (data_in_ready),
    .data_out (data_out), .data_out_valid (data_out_valid), .data_out_ready (1'b1),
    .s_axi_aclk (clk), .s_axi_aresetn (~reset),
    .s_axi_awvalid (awvalid), .s_axi_awaddr (awaddr), .s_axi_awprot (3'b0), .s_axi_awready (awready),
    .s_axi_wvalid (wvalid), .s_axi_wdata (wdata), .s_axi_wstrb (4'hf), .s_axi_wready (wready),
    .s_axi_bvalid (bvalid), .s_axi_bresp (), .s_axi_bready (1'b1),
    .s_axi_arvalid (1'b0), .s_axi_araddr (16'h0), .s_axi_arprot (3'b0), .s_axi_arready (),
    .s_axi_rvalid (), .s_axi_rresp (), .s_axi_rdata (), .s_axi_rready (1'b1));

  task axi_write(input [15:0] a, input [31:0] d);
    begin
      @(posedge clk); awaddr <= a; wdata <= d; awvalid <= 1; wvalid <= 1;
      @(posedge clk); while (awready !== 1'b1 || wready !== 1'b1) @(posedge clk);
      awvalid <= 0; wvalid <= 0; while (bvalid !== 1'b1) @(posedge clk); @(posedge clk);
    end
  endtask

  function [AW-1:0] fixed_up(input [127:0] num);
    fixed_up = ((num << AW) / N) + 1;
  endfunction

  function rule(input integer g);
    rule = (((N - M) + M * g) % N + M) >= N;
  endfunction

  // ramp source: converter c sends {0, c, n}, n counts accepted samples
  integer c, i, n_in = 0;
  always @(*)
    for (c = 0; c < CONV; c = c + 1)
      for (i = 0; i < SAMPLES; i = i + 1)
        data_in[c*DW + i*NP +: NP] = {1'b0, c[2:0], 12'(n_in + i)};
  always @(posedge clk) if (!reset && data_in_ready) n_in <= n_in + SAMPLES;

  reg          running = 1'b0;
  reg          valid_log [0:LOG*SAMPLES-1];
  integer      nlog = 0, gaps = 0, tag_err = 0, ramp_err = 0, fs_err = 0;
  reg   [11:0] last [0:CONV-1];
  reg          seen [0:CONV-1];
  reg          v;

  always @(posedge clk) if (running && nlog < LOG) begin
    if (!data_out_valid) gaps = gaps + 1;
    for (i = 0; i < SAMPLES; i = i + 1) begin
      v = data_out[i*NP +: NP] !== 16'h8000;
      valid_log[nlog*SAMPLES + i] = v;
      for (c = 0; c < CONV; c = c + 1) begin
        // all converters carry holes in the same slots
        if ((data_out[c*DW + i*NP +: NP] !== 16'h8000) !== v) fs_err = fs_err + 1;
        if (data_out[c*DW + i*NP +: NP] !== 16'h8000) begin
          if (data_out[c*DW + i*NP + 12 +: 3] !== c[2:0]) tag_err = tag_err + 1;
          if (seen[c] && data_out[c*DW + i*NP +: 12] !== 12'(last[c] + 1)) ramp_err = ramp_err + 1;
          last[c] = data_out[c*DW + i*NP +: 12];
          seen[c] = 1'b1;
        end
      end
    end
    nlog = nlog + 1;
  end

  reg [AW-1:0] add_val, step_val, seed;
  integer k, s0, a, g, mixed, best_mixed, best_a, mism, best_mism, nval;
  initial begin
    for (c = 0; c < CONV; c = c + 1) seen[c] = 1'b0;
    while (reset === 1'b1) @(posedge clk);
    repeat (10) @(posedge clk);
    if (N == M) begin
      add_val = {AW{1'b1}};
      step_val = 0;
    end else begin
      add_val = ((128'd1 << AW) * M) / N;
      step_val = fixed_up((M * P) % N);
    end
    axi_write(16'h18, 32'hffff);
    axi_write(16'h44, (G - 1) | (GSTART << 8));
    for (k = 0; k < SAMPLES; k = k + 1) begin
      seed = (N == M) ? BIAS : fixed_up(((N - M) + M * ((P > 1) ? k / NS : 0)) % N) + BIAS;
      axi_write(16'h28, seed[31:0]); axi_write(16'h2c, seed >> 32); axi_write(16'h24, k);
    end
    axi_write(16'h1c, add_val[31:0]); axi_write(16'h20, add_val >> 32);
    axi_write(16'h38, step_val[31:0]); axi_write(16'h3c, step_val >> 32);
    axi_write(16'h14, 32'h4);      // accumulator set
    axi_write(16'h10, 32'h1);      // enable
    axi_write(16'h14, 32'h1);      // start
    running <= 1'b1;
    while (nlog < LOG) @(posedge clk);

    // pattern starts at the first sample that carries data; groups can only
    // begin on a beat boundary, so try every alignment within one group
    s0 = 0;
    while (s0 < LOG*SAMPLES && !valid_log[s0]) s0 = s0 + 1;
    s0 = s0 - (s0 % SAMPLES);
    best_mixed = 1 << 30; best_a = 0;
    for (a = 0; a < NS; a = a + SAMPLES) begin
      mixed = 0;
      for (g = 0; (s0 + a + (g+1)*NS) <= LOG*SAMPLES; g = g + 1)
        for (k = 1; k < NS; k = k + 1)
          if (valid_log[s0 + a + g*NS + k] !== valid_log[s0 + a + g*NS]) mixed = mixed + 1;
      if (mixed < best_mixed) begin best_mixed = mixed; best_a = a; end
    end
    best_mism = 1 << 30; nval = 0;
    for (a = 0; a < N; a = a + 1) begin
      mism = 0;
      for (g = 0; (s0 + best_a + (g+1)*NS) <= LOG*SAMPLES; g = g + 1)
        if (valid_log[s0 + best_a + g*NS] !== rule(g + a)) mism = mism + 1;
      if (mism < best_mism) best_mism = mism;
    end
    for (k = s0; k < LOG*SAMPLES; k = k + 1) nval = nval + valid_log[k];
    $display("INFO: SAMPLES=%0d NS=%0d N/M=%0d/%0d GSTART=%0d: valid %0d/%0d, mixed groups %0d, group rule mismatches %0d, ramp breaks %0d, wrong tags %0d, holes not on all converters %0d, out_valid low %0d",
             SAMPLES, NS, N, M, GSTART, nval, LOG*SAMPLES - s0, best_mixed, best_mism, ramp_err, tag_err, fs_err, gaps);
    if (best_mixed || best_mism || ramp_err || tag_err || fs_err || gaps) failed <= 1'b1;
    running <= 1'b0;
  end

endmodule
