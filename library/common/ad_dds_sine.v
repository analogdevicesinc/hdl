// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//    
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// this is a sine function (approximate), the basic idea is to approximate sine as a
// polynomial function (there are a lot of stuff about this on the web)

`timescale 1ns/100ps

module ad_dds_sine (

  // sine = sin(angle)

  clk,
  angle,
  sine,
  ddata_in,
  ddata_out);

  // parameters

  parameter   DELAY_DATA_WIDTH = 16;
  localparam  DW = DELAY_DATA_WIDTH - 1;

  // sine = sin(angle)

  input             clk;
  input   [ 15:0]   angle;
  output  [ 15:0]   sine;
  input   [ DW:0]   ddata_in;
  output  [ DW:0]   ddata_out;

  // internal registers

  reg     [ 33:0]   s1_data_p = 'd0;
  reg     [ 33:0]   s1_data_n = 'd0;
  reg     [ 15:0]   s1_angle = 'd0;
  reg     [ DW:0]   s1_ddata = 'd0;
  reg     [ 18:0]   s2_data_0 = 'd0;
  reg     [ 18:0]   s2_data_1 = 'd0;
  reg     [ DW:0]   s2_ddata = 'd0;
  reg     [ 18:0]   s3_data = 'd0;
  reg     [ DW:0]   s3_ddata = 'd0;
  reg     [ 33:0]   s4_data2_p = 'd0;
  reg     [ 33:0]   s4_data2_n = 'd0;
  reg     [ 16:0]   s4_data1_p = 'd0;
  reg     [ 16:0]   s4_data1_n = 'd0;
  reg     [ DW:0]   s4_ddata = 'd0;
  reg     [ 16:0]   s5_data2_0 = 'd0;
  reg     [ 16:0]   s5_data2_1 = 'd0;
  reg     [ 16:0]   s5_data1 = 'd0;
  reg     [ DW:0]   s5_ddata = 'd0;
  reg     [ 16:0]   s6_data2 = 'd0;
  reg     [ 16:0]   s6_data1 = 'd0;
  reg     [ DW:0]   s6_ddata = 'd0;
  reg     [ 33:0]   s7_data = 'd0;
  reg     [ DW:0]   s7_ddata = 'd0;
  reg     [ 15:0]   sine = 'd0;
  reg     [ DW:0]   ddata_out = 'd0;

  // internal signals

  wire    [ 15:0]   angle_s;
  wire    [ 33:0]   s1_data_s;
  wire    [ DW:0]   s1_ddata_s;
  wire    [ 15:0]   s1_angle_s;
  wire    [ 33:0]   s4_data2_s;
  wire    [ DW:0]   s4_ddata_s;
  wire    [ 16:0]   s4_data1_s;
  wire    [ 33:0]   s7_data2_s;
  wire    [ 33:0]   s7_data1_s;
  wire    [ DW:0]   s7_ddata_s;

  // make angle 2's complement

  assign angle_s = {~angle[15], angle[14:0]};

  // level 1 - intermediate

  ad_mul #(.DELAY_DATA_WIDTH(DELAY_DATA_WIDTH+16)) i_mul_s1 (
    .clk (clk),
    .data_a ({angle_s[15], angle_s}),
    .data_b ({angle_s[15], angle_s}),
    .data_p (s1_data_s),
    .ddata_in ({ddata_in, angle_s}),
    .ddata_out ({s1_ddata_s, s1_angle_s}));

  // 2's complement versions

  always @(posedge clk) begin
    s1_data_p <= s1_data_s;
    s1_data_n <= ~s1_data_s + 1'b1;
    s1_angle <= s1_angle_s;
    s1_ddata <= s1_ddata_s;
  end

  // select partial products

  always @(posedge clk) begin
    s2_data_0 <= (s1_angle[15] == 1'b0) ? s1_data_n[31:13] : s1_data_p[31:13];
    s2_data_1 <= {s1_angle[15], s1_angle[15:0], 2'b00};
    s2_ddata <= s1_ddata;
  end

  // unit-sine

  always @(posedge clk) begin
    s3_data <= s2_data_0 + s2_data_1;
    s3_ddata <= s2_ddata;
  end

  // level 2 - final

  ad_mul #(.DELAY_DATA_WIDTH(DELAY_DATA_WIDTH+17)) i_mul_s2 (
    .clk (clk),
    .data_a (s3_data[16:0]),
    .data_b (s3_data[16:0]),
    .data_p (s4_data2_s),
    .ddata_in ({s3_ddata, s3_data[16:0]}),
    .ddata_out ({s4_ddata_s, s4_data1_s}));

  // 2's complement versions

  always @(posedge clk) begin
    s4_data2_p <= s4_data2_s;
    s4_data2_n <= ~s4_data2_s + 1'b1;
    s4_data1_p <= s4_data1_s;
    s4_data1_n <= ~s4_data1_s + 1'b1;
    s4_ddata <= s4_ddata_s;
  end

  // select partial products

  always @(posedge clk) begin
    s5_data2_0 <= (s4_data1_p[16] == 1'b1) ? s4_data2_n[31:15] : s4_data2_p[31:15];
    s5_data2_1 <= s4_data1_n;
    s5_data1 <= s4_data1_p;
    s5_ddata <= s4_ddata;
  end

  // corrected-sine

  always @(posedge clk) begin
    s6_data2 <= s5_data2_0 + s5_data2_1;
    s6_data1 <= s5_data1;
    s6_ddata <= s5_ddata;
  end

  // full-scale

  ad_mul #(.DELAY_DATA_WIDTH(1)) i_mul_s3_2 (
    .clk (clk),
    .data_a (s6_data2),
    .data_b (17'h1d08),
    .data_p (s7_data2_s),
    .ddata_in (1'b0),
    .ddata_out ());

  ad_mul #(.DELAY_DATA_WIDTH(DELAY_DATA_WIDTH)) i_mul_s3_1 (
    .clk (clk),
    .data_a (s6_data1),
    .data_b (17'h7fff),
    .data_p (s7_data1_s),
    .ddata_in (s6_ddata),
    .ddata_out (s7_ddata_s));

  // corrected sum

  always @(posedge clk) begin
    s7_data <= s7_data2_s + s7_data1_s;
    s7_ddata <= s7_ddata_s;
  end

  // output registers

  always @(posedge clk) begin
    sine <= s7_data[30:15];
    ddata_out <= s7_ddata;
  end

endmodule

// ***************************************************************************
// ***************************************************************************
