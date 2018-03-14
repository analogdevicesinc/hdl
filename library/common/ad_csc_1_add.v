// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
// Color Space Conversion, adder. This is a simple adder, but had to be
// pipe-lined for faster clock rates. The delay input is delay-matched to
// the sum pipe-line stages

`timescale 1ps/1ps

module ad_csc_1_add #(

  parameter   DELAY_DATA_WIDTH = 16) (

  // all signed

  input                   clk,
  input       [24:0]      data_1,
  input       [24:0]      data_2,
  input       [24:0]      data_3,
  input       [24:0]      data_4,
  output  reg [ 7:0]      data_p,

  // delay match

  input       [DW:0]      ddata_in,
  output  reg [DW:0]      ddata_out);

  localparam  DW = DELAY_DATA_WIDTH - 1;

  // internal registers

  reg     [DW:0]  p1_ddata = 'd0;
  reg     [24:0]  p1_data_1 = 'd0;
  reg     [24:0]  p1_data_2 = 'd0;
  reg     [24:0]  p1_data_3 = 'd0;
  reg     [24:0]  p1_data_4 = 'd0;
  reg     [DW:0]  p2_ddata = 'd0;
  reg     [24:0]  p2_data_0 = 'd0;
  reg     [24:0]  p2_data_1 = 'd0;
  reg     [DW:0]  p3_ddata = 'd0;
  reg     [24:0]  p3_data = 'd0;

  // internal signals

  wire    [24:0]  p1_data_1_p_s;
  wire    [24:0]  p1_data_1_n_s;
  wire    [24:0]  p1_data_1_s;
  wire    [24:0]  p1_data_2_p_s;
  wire    [24:0]  p1_data_2_n_s;
  wire    [24:0]  p1_data_2_s;
  wire    [24:0]  p1_data_3_p_s;
  wire    [24:0]  p1_data_3_n_s;
  wire    [24:0]  p1_data_3_s;
  wire    [24:0]  p1_data_4_p_s;
  wire    [24:0]  p1_data_4_n_s;
  wire    [24:0]  p1_data_4_s;

  // pipe line stage 1, get the two's complement versions

  assign p1_data_1_p_s = {1'b0, data_1[23:0]};
  assign p1_data_1_n_s = ~p1_data_1_p_s + 1'b1;
  assign p1_data_1_s = (data_1[24] == 1'b1) ? p1_data_1_n_s : p1_data_1_p_s;

  assign p1_data_2_p_s = {1'b0, data_2[23:0]};
  assign p1_data_2_n_s = ~p1_data_2_p_s + 1'b1;
  assign p1_data_2_s = (data_2[24] == 1'b1) ? p1_data_2_n_s : p1_data_2_p_s;

  assign p1_data_3_p_s = {1'b0, data_3[23:0]};
  assign p1_data_3_n_s = ~p1_data_3_p_s + 1'b1;
  assign p1_data_3_s = (data_3[24] == 1'b1) ? p1_data_3_n_s : p1_data_3_p_s;

  assign p1_data_4_p_s = {1'b0, data_4[23:0]};
  assign p1_data_4_n_s = ~p1_data_4_p_s + 1'b1;
  assign p1_data_4_s = (data_4[24] == 1'b1) ? p1_data_4_n_s : p1_data_4_p_s;

  always @(posedge clk) begin
    p1_ddata <= ddata_in;
    p1_data_1 <= p1_data_1_s;
    p1_data_2 <= p1_data_2_s;
    p1_data_3 <= p1_data_3_s;
    p1_data_4 <= p1_data_4_s;
  end

  // pipe line stage 2, get the sum (intermediate, 4->2)

  always @(posedge clk) begin
    p2_ddata <= p1_ddata;
    p2_data_0 <= p1_data_1 + p1_data_2;
    p2_data_1 <= p1_data_3 + p1_data_4;
  end

  // pipe line stage 3, get the sum (final, 2->1)

  always @(posedge clk) begin
    p3_ddata <= p2_ddata;
    p3_data <= p2_data_0 + p2_data_1;
  end

  // output registers, output is unsigned (0 if sum is < 0) and saturated.
  // the inputs are expected to be 1.4.20 format (output is 8bits).

  always @(posedge clk) begin
    ddata_out <= p3_ddata;
    if (p3_data[24] == 1'b1) begin
      data_p <= 8'h00;
    end else if (p3_data[23:20] == 'd0) begin
      data_p <= p3_data[19:12];
    end else begin
      data_p <= 8'hff;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
