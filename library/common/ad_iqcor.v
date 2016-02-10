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
// iq correction = a*(i+x) + b*(q+y); offsets are added in dcfilter.

`timescale 1ns/100ps

module ad_iqcor (

  // data interface

  clk,
  valid,
  data_in,
  data_iq,
  valid_out,
  data_out,

  // control interface

  iqcor_enable,
  iqcor_coeff_1,
  iqcor_coeff_2);

  // select i/q if disabled

  parameter Q_OR_I_N = 0;

  // data interface

  input           clk;
  input           valid;
  input   [15:0]  data_in;
  input   [15:0]  data_iq;
  output          valid_out;
  output  [15:0]  data_out;

  // control interface

  input           iqcor_enable;
  input   [15:0]  iqcor_coeff_1;
  input   [15:0]  iqcor_coeff_2;

  // internal registers

  reg             p1_valid = 'd0;
  reg     [15:0]  p1_data_i = 'd0;
  reg     [15:0]  p1_data_q = 'd0;
  reg     [33:0]  p1_data_p = 'd0;
  reg             valid_out = 'd0;
  reg     [15:0]  data_out = 'd0;
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

  // swap i & q

  assign data_i_s = (Q_OR_I_N == 1) ? data_iq : data_in;
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

  // scaling functions - q

  ad_mul #(.DELAY_DATA_WIDTH(16)) i_mul_q (
    .clk (clk),
    .data_a ({data_q_s[15], data_q_s}),
    .data_b ({iqcor_coeff_2_r[15], iqcor_coeff_2_r}),
    .data_p (p1_data_p_q_s),
    .ddata_in (data_q_s),
    .ddata_out (p1_data_q_s));

  // sum

  always @(posedge clk) begin
    p1_valid <= p1_valid_s;
    p1_data_i <= p1_data_i_s;
    p1_data_q <= p1_data_q_s;
    p1_data_p <= p1_data_p_i_s + p1_data_p_q_s;
  end

  // output registers

  always @(posedge clk) begin
    valid_out <= p1_valid;
    if (iqcor_enable == 1'b1) begin
      data_out <= p1_data_p[29:14];
    end else if (Q_OR_I_N == 1) begin
      data_out <= p1_data_q;
    end else begin
      data_out <= p1_data_i;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
