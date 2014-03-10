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

  input           clk;
  input   [15:0]  angle;
  output  [15:0]  sine;
  input   [DW:0]  ddata_in;
  output  [DW:0]  ddata_out;

  // internal registers

  reg     [DW:0]  ddata_s2_i = 'd0;
  reg             data_msb_s2_i = 'd0;
  reg     [15:0]  data_delay_s2_i = 'd0;
  reg     [15:0]  data_sine_s2_i = 'd0;
  reg     [DW:0]  ddata_s2 = 'd0;
  reg             data_msb_s2 = 'd0;
  reg     [15:0]  data_sine_s2 = 'd0;
  reg     [DW:0]  ddata_s3_i = 'd0;
  reg             data_msb_s3_i = 'd0;
  reg     [15:0]  data_delay_s3_i = 'd0;
  reg     [15:0]  data_sine_s3_i = 'd0;
  reg     [DW:0]  ddata_s4 = 'd0;
  reg             data_msb = 'd0;
  reg     [14:0]  data_sine_p = 'd0;
  reg     [14:0]  data_sine_n = 'd0;
  reg     [DW:0]  ddata_out = 'd0;
  reg     [15:0]  sine = 'd0;

  // internal signals

  wire    [DW:0]  ddata_s1_s;
  wire            data_msb_s1_s;
  wire    [31:0]  data_sine_s1_s;
  wire    [DW:0]  ddata_s2_i_s;
  wire            data_msb_s2_i_s;
  wire    [15:0]  data_delay_s2_i_s;
  wire    [31:0]  data_sine_s2_i_s;
  wire    [DW:0]  ddata_s2_s;
  wire            data_msb_s2_s;
  wire    [31:0]  data_sine_s2_s;
  wire    [DW:0]  ddata_s3_i_s;
  wire            data_msb_s3_i_s;
  wire    [15:0]  data_delay_s3_i_s;
  wire    [31:0]  data_sine_s3_i_s;
  wire    [DW:0]  ddata_s3_s;
  wire            data_msb_s3_s;
  wire    [31:0]  data_sine_s3_s;

  // level 1 (intermediate) A*x;

  ad_mul_u16 #(.DELAY_DATA_WIDTH(DELAY_DATA_WIDTH+1)) i_mul_s1 (
    .clk (clk),
    .data_a ({1'b0, angle[14:0]}),
    .data_b (16'hc90f),
    .data_p (data_sine_s1_s),
    .ddata_in ({ddata_in, angle[15]}),
    .ddata_out ({ddata_s1_s, data_msb_s1_s}));

  // level 1, (final) B*x;

  ad_mul_u16 #(.DELAY_DATA_WIDTH(DELAY_DATA_WIDTH+17)) i_mul_s2_i (
    .clk (clk),
    .data_a (data_sine_s1_s[30:15]),
    .data_b (16'h19f0),
    .data_p (data_sine_s2_i_s),
    .ddata_in ({ddata_s1_s, data_msb_s1_s, data_sine_s1_s[30:15]}),
    .ddata_out ({ddata_s2_i_s, data_msb_s2_i_s, data_delay_s2_i_s}));

  // level 2 inputs, B*x and (1-A*x)

  always @(posedge clk) begin
    ddata_s2_i <= ddata_s2_i_s;
    data_msb_s2_i <= data_msb_s2_i_s;
    data_delay_s2_i <= data_delay_s2_i_s;
    data_sine_s2_i <= 16'ha2f9 - data_sine_s2_i_s[28:13];
  end

  // level 2, second order (A*x2 + B*x)

  ad_mul_u16 #(.DELAY_DATA_WIDTH(DELAY_DATA_WIDTH+1)) i_mul_s2 (
    .clk (clk),
    .data_a (data_delay_s2_i),
    .data_b (data_sine_s2_i),
    .data_p (data_sine_s2_s),
    .ddata_in ({ddata_s2_i, data_msb_s2_i}),
    .ddata_out ({ddata_s2_s, data_msb_s2_s}));

  always @(posedge clk) begin
    ddata_s2 <= ddata_s2_s;
    data_msb_s2 <= data_msb_s2_s;
    if (data_sine_s2_s[31:29] == 0) begin
      data_sine_s2 <= data_sine_s2_s[28:13];
    end else begin
      data_sine_s2 <= 16'hffff;
    end
  end

  // level 2, intermediate (B*y)

  ad_mul_u16 #(.DELAY_DATA_WIDTH(DELAY_DATA_WIDTH+17)) i_mul_s3_i (
    .clk (clk),
    .data_a (data_sine_s2),
    .data_b (16'h3999),
    .data_p (data_sine_s3_i_s),
    .ddata_in ({ddata_s2, data_msb_s2, data_sine_s2}),
    .ddata_out ({ddata_s3_i_s, data_msb_s3_i_s, data_delay_s3_i_s}));

  always @(posedge clk) begin
    ddata_s3_i <= ddata_s3_i_s;
    data_msb_s3_i <= data_msb_s3_i_s;
    data_delay_s3_i <= data_delay_s3_i_s;
    data_sine_s3_i <= 16'hc666 + data_sine_s3_i_s[31:16];
  end

  // level 2, second order (A*y2 + B*y)

  ad_mul_u16 #(.DELAY_DATA_WIDTH(DELAY_DATA_WIDTH+1)) i_mul_s3 (
    .clk (clk),
    .data_a (data_delay_s3_i),
    .data_b (data_sine_s3_i),
    .data_p (data_sine_s3_s),
    .ddata_in ({ddata_s3_i, data_msb_s3_i}),
    .ddata_out ({ddata_s3_s, data_msb_s3_s}));

  always @(posedge clk) begin
    ddata_s4 <= ddata_s3_s;
    data_msb <= data_msb_s3_s;
    data_sine_p <= data_sine_s3_s[31:17];
    data_sine_n <= ~data_sine_s3_s[31:17] + 1'b1;
    ddata_out <= ddata_s4;
    sine <= (data_msb == 1'b1) ? {1'b1, data_sine_n} : {1'b0, data_sine_p};
  end

endmodule

// ***************************************************************************
// ***************************************************************************
