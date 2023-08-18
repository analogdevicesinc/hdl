// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module crc12_tb;
  parameter VCD_FILE = "crc12_tb.vcd";

  `define TIMEOUT 400

  `include "tb_base.v"

  reg [63:0] data_in = 'h0;
  reg [11:0] ref_crc12 = 'h0;
  wire [11:0] crc12;
  reg test_en = 1'b1;
  reg init = 1'b0;

  jesd204_crc12 DUT (
    .clk (clk),
    .reset (1'b0),
    .init (init),
    .data_in (data_in),
    .crc12 (crc12));

  // Test against dataset from the standard
  //  - Test contiguous input stream with init phase
  initial begin
    @(negedge reset);
    @(posedge clk);
    repeat (3) begin
      @(posedge clk) data_in <= 'h80_01_02_03_05_05_04_23;
      init <= 1'b1;
      @(posedge clk) data_in <= 'h0e_43_80_c2_0b_50_81_cd;
      init <= 1'b0;
      @(posedge clk) data_in <= 'h04_e7_83_92_5a_3c_aa_51;
      @(posedge clk) data_in <= 'h05_4d_87_d9_31_3d_11_51;
    end
    @(posedge clk);
    @(posedge clk);
    test_en <= 1'b0;
  end

   initial begin
    @(negedge reset);
    @(posedge clk);
    @(posedge clk);
    repeat(3) begin
      @(posedge clk) ref_crc12 <= 'hd00;
      @(posedge clk) ref_crc12 <= 'h11c;
      @(posedge clk) ref_crc12 <= 'hfea;
      @(posedge clk) ref_crc12 <= 'h5fe;
    end
  end

  always @(posedge clk) begin
    if (ref_crc12 != crc12 && failed == 1'b0 && test_en) begin
      failed <= 1'b1;
    end
  end

endmodule
