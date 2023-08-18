// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module scrambler_tb;
  parameter VCD_FILE = "scrambler_tb.vcd";

  `include "tb_base.v"

  reg [31:0] data_in;
  reg [31:0] data_out_expected;
  wire [31:0] data_scrambled;
  wire [31:0] data_out;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      data_in <= 'h03020100;
    end else begin
      data_in <= data_in + {4{8'h04}};
    end
  end

  jesd204_scrambler #(
    .DESCRAMBLE(0)
  ) i_scrambler (
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .data_in(data_in),
    .data_out(data_scrambled));

  jesd204_scrambler #(
    .DESCRAMBLE(1)
  ) i_descrambler (
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .data_in(data_scrambled),
    .data_out(data_out));

  always @(posedge clk) begin
    if (data_in != data_out && failed == 1'b0) begin
      failed <= 1'b1;
    end
  end

endmodule
