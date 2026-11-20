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

// Holds the valid of both channels, and the FIFOs in reset, until each has
// given its first valid, so both FIFOs start empty and fill at the same time.
// The first valid comes after the bit alignment lock (axi_ad408x
// VALID_AFTER_BIT_ALIGN). When the filter enables of both channels become the
// same again after a change, both channels start together once more; at any
// other time the stream is not held.

module ad4880_valid_gate (

  // channel A, on its adc_clk
  input       a_clk,
  input       a_rst,
  input       a_valid_in,
  input       a_filter_en,
  output      a_valid_out,
  // FIFO reset on the a_clk side
  output      a_fifo_resetn,

  // channel B, on its adc_clk
  input       b_clk,
  input       b_rst,
  input       b_valid_in,
  input       b_filter_en,
  output      b_valid_out,
  // FIFO reset on the b_clk side
  output      b_fifo_resetn
);

  reg         a_started = 1'b0;
  reg         b_started = 1'b0;
  reg   [2:0] a_hold = 3'd0;
  reg   [2:0] b_hold = 3'd0;
  reg         a_filter_same_d = 1'b1;
  reg         b_filter_same_d = 1'b1;

  wire  [1:0] a_started_s;
  wire  [1:0] b_started_s;
  wire  [1:0] a_filter_s;
  wire  [1:0] b_filter_s;
  wire        a_filter_same;
  wire        b_filter_same;
  wire        a_realign;
  wire        b_realign;

  // the filter enables of both channels on each clock; both the same again
  // (rising edge of the XNOR) restarts the channels together

  sync_bits #(
    .NUM_OF_BITS (2),
    .ASYNC_CLK (1)
  ) i_a_filter_sync (
    .in_bits ({b_filter_en, a_filter_en}),
    .out_resetn (1'b1),
    .out_clk (a_clk),
    .out_bits (a_filter_s));

  sync_bits #(
    .NUM_OF_BITS (2),
    .ASYNC_CLK (1)
  ) i_b_filter_sync (
    .in_bits ({b_filter_en, a_filter_en}),
    .out_resetn (1'b1),
    .out_clk (b_clk),
    .out_bits (b_filter_s));

  assign a_filter_same = ~^a_filter_s;
  assign b_filter_same = ~^b_filter_s;
  assign a_realign = a_filter_same & ~a_filter_same_d;
  assign b_realign = b_filter_same & ~b_filter_same_d;

  // a restart clears the flag for 8 cycles, long enough for the other clock
  // to see it

  always @(posedge a_clk) begin
    a_filter_same_d <= a_filter_same;
    if (a_rst == 1'b1) begin
      a_started <= 1'b0;
      a_hold <= 3'd0;
    end else if (a_realign == 1'b1) begin
      a_started <= 1'b0;
      a_hold <= 3'd7;
    end else if (a_hold != 3'd0) begin
      a_hold <= a_hold - 1'b1;
    end else if (a_valid_in == 1'b1) begin
      a_started <= 1'b1;
    end
  end

  always @(posedge b_clk) begin
    b_filter_same_d <= b_filter_same;
    if (b_rst == 1'b1) begin
      b_started <= 1'b0;
      b_hold <= 3'd0;
    end else if (b_realign == 1'b1) begin
      b_started <= 1'b0;
      b_hold <= 3'd7;
    end else if (b_hold != 3'd0) begin
      b_hold <= b_hold - 1'b1;
    end else if (b_valid_in == 1'b1) begin
      b_started <= 1'b1;
    end
  end

  // both flags through the same synchronizer in each domain, so both gates
  // open within a clock cycle of each other

  sync_bits #(
    .NUM_OF_BITS (2),
    .ASYNC_CLK (1)
  ) i_a_sync (
    .in_bits ({b_started, a_started}),
    .out_resetn (~a_rst),
    .out_clk (a_clk),
    .out_bits (a_started_s));

  sync_bits #(
    .NUM_OF_BITS (2),
    .ASYNC_CLK (1)
  ) i_b_sync (
    .in_bits ({b_started, a_started}),
    .out_resetn (~b_rst),
    .out_clk (b_clk),
    .out_bits (b_started_s));

  assign a_fifo_resetn = &a_started_s;
  assign b_fifo_resetn = &b_started_s;

  assign a_valid_out = a_valid_in & a_fifo_resetn;
  assign b_valid_out = b_valid_in & b_fifo_resetn;

endmodule
