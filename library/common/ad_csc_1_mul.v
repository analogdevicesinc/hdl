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
// freedoms and responsabilities that he or she has by using this source/core.
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
// Color Space Conversion, multiplier. This is a simple partial product adder
// that generates the product of the two inputs.

`timescale 1ps/1ps

module ad_csc_1_mul #(

  parameter   DELAY_DATA_WIDTH = 16) (

  // data_a is signed

  input                   clk,
  input       [16:0]      data_a,
  input       [ 7:0]      data_b,
  output      [24:0]      data_p,

  // delay match

  input       [DW:0]      ddata_in,
  output  reg [DW:0]      ddata_out);

  localparam  DW = DELAY_DATA_WIDTH - 1;

  // internal registers

  reg     [DW:0]  p1_ddata = 'd0;
  reg     [DW:0]  p2_ddata = 'd0;
  reg             p1_sign = 'd0;
  reg             p2_sign = 'd0;
  reg             sign_p = 'd0;

  // internal signals

  wire    [25:0]  data_p_s;

  // a/b reg, m-reg, p-reg delay match

  always @(posedge clk) begin
    p1_ddata <= ddata_in;
    p2_ddata <= p1_ddata;
    ddata_out <= p2_ddata;
  end

  always @(posedge clk) begin
    p1_sign <= data_a[16];
    p2_sign <= p1_sign;
    sign_p <= p2_sign;
  end

  assign data_p = {sign_p, data_p_s[23:0]};

  MULT_MACRO #(
    .LATENCY (3),
    .WIDTH_A (17),
    .WIDTH_B (9))
  i_mult_macro (
    .CE (1'b1),
    .RST (1'b0),
    .CLK (clk),
    .A ({1'b0, data_a[15:0]}),
    .B ({1'b0, data_b}),
    .P (data_p_s));

endmodule

// ***************************************************************************
// ***************************************************************************
