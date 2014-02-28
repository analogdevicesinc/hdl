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

module ad_iqcor (

  // data interface

  clk,
  valid,
  data_i,
  data_q,
  valid_out,
  data_out,

  // control interface

  iqcor_enable,
  iqcor_coeff_1,
  iqcor_coeff_2);

  // select i/q if disabled

  parameter IQSEL = 0;

  // data interface

  input           clk;
  input           valid;
  input   [15:0]  data_i;
  input   [15:0]  data_q;
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
  reg             p2_valid = 'd0;
  reg             p2_sign_i = 'd0;
  reg             p2_sign_q = 'd0;
  reg     [14:0]  p2_magn_i = 'd0;
  reg     [14:0]  p2_magn_q = 'd0;
  reg             p3_valid = 'd0;
  reg     [15:0]  p3_data_i = 'd0;
  reg     [15:0]  p3_data_q = 'd0;
  reg             p4_valid = 'd0;
  reg     [15:0]  p4_data = 'd0;
  reg             valid_out = 'd0;
  reg     [15:0]  data_out = 'd0;

  // internal signals

  wire    [15:0]  p2_data_i_s;
  wire    [15:0]  p2_data_q_s;
  wire            p3_valid_s;
  wire    [31:0]  p3_magn_i_s;
  wire            p3_sign_i_s;
  wire    [31:0]  p3_magn_q_s;
  wire            p3_sign_q_s;
  wire    [15:0]  p3_data_2s_i_p_s;
  wire    [15:0]  p3_data_2s_q_p_s;
  wire    [15:0]  p3_data_2s_i_n_s;
  wire    [15:0]  p3_data_2s_q_n_s;

  // apply offsets first

  always @(posedge clk) begin
    p1_valid <= valid;
    p1_data_i <= data_i;
    p1_data_q <= data_q;
  end

  // convert to sign-magnitude

  assign p2_data_i_s = ~p1_data_i + 1'b1;
  assign p2_data_q_s = ~p1_data_q + 1'b1;

  always @(posedge clk) begin
    p2_valid <= p1_valid;
    p2_sign_i <= p1_data_i[15] ^ iqcor_coeff_1[15];
    p2_sign_q <= p1_data_q[15] ^ iqcor_coeff_2[15];
    p2_magn_i <= (p1_data_i[15] == 1'b1) ? p2_data_i_s[14:0] : p1_data_i[14:0];
    p2_magn_q <= (p1_data_q[15] == 1'b1) ? p2_data_q_s[14:0] : p1_data_q[14:0];
  end

  // scaling functions - i

  ad_mul_u16 #(.DELAY_DATA_WIDTH(2)) i_mul_u16_i (
    .clk (clk),
    .data_a ({1'b0, p2_magn_i}),
    .data_b ({1'b0, iqcor_coeff_1[14:0]}),
    .data_p (p3_magn_i_s),
    .ddata_in ({p2_valid, p2_sign_i}),
    .ddata_out ({p3_valid_s, p3_sign_i_s}));

  // scaling functions - q

  ad_mul_u16 #(.DELAY_DATA_WIDTH(1)) i_mul_u16_q (
    .clk (clk),
    .data_a ({1'b0, p2_magn_q}),
    .data_b ({1'b0, iqcor_coeff_2[14:0]}),
    .data_p (p3_magn_q_s),
    .ddata_in (p2_sign_q),
    .ddata_out (p3_sign_q_s));

  // convert to 2s-complements

  assign p3_data_2s_i_p_s = {1'b0, p3_magn_i_s[28:14]};
  assign p3_data_2s_q_p_s = {1'b0, p3_magn_q_s[28:14]};
  assign p3_data_2s_i_n_s = ~p3_data_2s_i_p_s + 1'b1;
  assign p3_data_2s_q_n_s = ~p3_data_2s_q_p_s + 1'b1;

  always @(posedge clk) begin
    p3_valid <= p3_valid_s;
    p3_data_i <= (p3_sign_i_s == 1'b1) ? p3_data_2s_i_n_s : p3_data_2s_i_p_s;
    p3_data_q <= (p3_sign_q_s == 1'b1) ? p3_data_2s_q_n_s : p3_data_2s_q_p_s;
  end

  // corrected output is sum of two

  always @(posedge clk) begin
    p4_valid <= p3_valid;
    p4_data <= p3_data_i + p3_data_q;
  end

  // output registers

  always @(posedge clk) begin
    if (iqcor_enable == 1'b1) begin
      valid_out <= p4_valid;
      data_out <= p4_data;
    end else if (IQSEL == 1) begin
      valid_out <= valid;
      data_out <= data_q;
    end else begin
      valid_out <= valid;
      data_out <= data_i;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
