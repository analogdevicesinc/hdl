// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module scrambler_64b_tb;
  parameter VCD_FILE = "scrambler_64b_tb.vcd";

  `include "tb_base.v"
  reg failed_t1 = 1'b0;
  reg failed_t2 = 1'b0;

  // Test scrambler against descrambler
  //
  // Descrambled data should match the input of the scrambler.
  reg [63:0] data_in = 'h0;
  reg [63:0] data_out_expected;
  wire [63:0] data_scrambled;
  wire [63:0] data_out;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      data_in <= 'h0001020304050607;
    end else begin
      data_in <= data_in + {8{8'h08}};
    end
  end

  jesd204_scrambler_64b #(
    .DESCRAMBLE(0)
  ) i_scrambler (
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .data_in(data_in),
    .data_out(data_scrambled));

  jesd204_scrambler_64b #(
    .DESCRAMBLE(1)
  ) i_descrambler (
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .data_in(data_scrambled),
    .data_out(data_out));

  always @(posedge clk) begin
    if (data_in != data_out && failed_t1 == 1'b0) begin
      failed_t1 <= 1'b1;
    end
  end

  // Test descrambler against reference data
  //
  // Check if descrambler can synchronize and a stream captured from
  // a scrambler output. The descrambled data stream should match the input of
  // the scrambler.
  reg [63:0] descrambler_data_in = 'h0;
  reg [63:0] data_ref = 'h0;
  wire[63:0] descrambler_data_out;

  integer i;
  reg [63:0] scrambler_64b_input [0:993];
  reg [63:0] scrambler_64b_output [0:993];
  reg t2_enable = 1'b0;

  initial begin
    $readmemh("scrambler_64b_input.txt", scrambler_64b_input);   // Input to a scrambler
    $readmemh("scrambler_64b_output.txt", scrambler_64b_output); // Output of a scrambler
    @(negedge reset);
    @(posedge clk);
    for (i=0;i<994;i=i+1) begin
      @(posedge clk);
      descrambler_data_in <= scrambler_64b_output[i];
      data_ref <= scrambler_64b_input[i];
      if (i==1) t2_enable <= 1'b1;
      if (i==993) t2_enable <= 1'b0;
    end
  end

  jesd204_scrambler_64b #(
    .DESCRAMBLE(1)
  ) i_descrambler2 (
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .data_in(descrambler_data_in),
    .data_out(descrambler_data_out));

  always @(posedge clk) begin
    if (data_ref != descrambler_data_out && failed_t2 == 1'b0 && t2_enable) begin
      failed_t2 <= 1'b1;
    end
  end

  always @(posedge clk) begin
    failed <= failed_t1 || failed_t2;
  end

endmodule
