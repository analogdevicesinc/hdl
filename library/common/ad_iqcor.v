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
// iq correction = a*(i+x) + b*(q+y); offsets are added in dcfilter.
// if SCALE_ONLY is set to 1, b*(q+y) is set to 0, and the module is used for
// scale correction of channel I

`timescale 1ns/100ps

module ad_iqcor #(

  // select i/q if disabled

  parameter   Q_OR_I_N = 0,
  parameter   SCALE_ONLY = 0,
  parameter   DISABLE = 0) (

  // data interface

  input           clk,
  input           valid,
  input   [15:0]  data_in,
  input   [15:0]  data_iq,
  output          valid_out,
  output  [15:0]  data_out,

  // control interface

  input           iqcor_enable,
  input   [15:0]  iqcor_coeff_1,
  input   [15:0]  iqcor_coeff_2);

  // internal registers

  reg             p1_valid = 'd0;
  reg     [33:0]  p1_data_p = 'd0;
  reg             valid_int = 'd0;
  reg     [15:0]  data_int = 'd0;
  reg     [15:0]  iqcor_coeff_1_r = 'd0;
  reg     [15:0]  iqcor_coeff_2_r = 'd0;

  // internal signals

  wire    [15:0]  data_i_s;
  wire    [15:0]  data_q_s;
  wire    [33:0]  p1_data_p_i_s;
  wire            p1_valid_s;
  wire    [15:0]  p1_data_i_s;
  wire    [33:0]  p1_data_p_q_s;
  wire    [15:0]  p1_data_q_s;
  wire    [15:0]  p1_data_i_int;
  wire    [15:0]  p1_data_q_int;

  // data-path disable

  generate
  if (DISABLE == 1) begin
    assign valid_out = valid;
    assign data_out = data_in;
  end else begin
    assign valid_out = valid_int;
    assign data_out = data_int;
  end
  endgenerate

  // swap i & q

  assign data_i_s = (Q_OR_I_N == 1 && SCALE_ONLY == 1'b0) ? data_iq : data_in;
  assign data_q_s = (Q_OR_I_N == 1) ? data_in : data_iq;

  // coefficients are flopped to remove warnings from vivado

  always @(posedge clk) begin
    iqcor_coeff_1_r <= iqcor_coeff_1;
    iqcor_coeff_2_r <= iqcor_coeff_2;
  end

  // scaling functions - i

  ad_mul #(.DELAY_DATA_WIDTH(17)) i_mul_i (
    .clk (clk),
    .data_a ({data_i_s[15], data_i_s}),
    .data_b ({iqcor_coeff_1_r[15], iqcor_coeff_1_r}),
    .data_p (p1_data_p_i_s),
    .ddata_in ({valid, data_i_s}),
    .ddata_out ({p1_valid_s, p1_data_i_s}));

  generate
  if (SCALE_ONLY == 0) begin
    // scaling functions - q

    ad_mul #(.DELAY_DATA_WIDTH(16)) i_mul_q (
      .clk (clk),
      .data_a ({data_q_s[15], data_q_s}),
      .data_b ({iqcor_coeff_2_r[15], iqcor_coeff_2_r}),
      .data_p (p1_data_p_q_s),
      .ddata_in (data_q_s),
      .ddata_out (p1_data_q_s));

  // sum
  end else begin
    assign p1_data_p_q_s = 34'h0;
    assign p1_data_q_s = 16'h0;
  end

  endgenerate
  generate
  if (Q_OR_I_N == 1 && SCALE_ONLY == 0) begin
    reg [15:0]  p1_data_q = 'd0;

    always @(posedge clk) begin
      p1_data_q <= p1_data_q_s;
    end

    assign p1_data_i_int = 16'h0;
    assign p1_data_q_int = p1_data_q;

  // sum
  end else begin
    reg [15:0]  p1_data_i = 'd0;

    always @(posedge clk) begin
      p1_data_i <= p1_data_i_s;
    end

    assign p1_data_i_int = p1_data_i;
    assign p1_data_q_int = 16'h0;
  end
  endgenerate

  always @(posedge clk) begin
    p1_valid <= p1_valid_s;
    p1_data_p <= p1_data_p_i_s + p1_data_p_q_s;
  end
  // output registers

  always @(posedge clk) begin
    valid_int <= p1_valid;
    if (iqcor_enable == 1'b1) begin
      data_int <= p1_data_p[29:14];
    end else if (Q_OR_I_N == 1 && SCALE_ONLY == 0) begin
      data_int <= p1_data_q_int;
    end else begin
      data_int <= p1_data_i_int;
    end
  end


endmodule

// ***************************************************************************
// ***************************************************************************
