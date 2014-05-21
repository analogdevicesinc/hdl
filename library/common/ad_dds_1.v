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

`timescale 1ns/100ps

module ad_dds_1 (

  // interface

  clk,
  angle,
  scale,
  dds_data);

  // interface

  input           clk;
  input   [15:0]  angle;
  input   [15:0]  scale;
  output  [15:0]  dds_data;

  // internal registers

  reg             sine_sign = 'd0;
  reg     [14:0]  sine_magn = 'd0;
  reg     [14:0]  sine_scale_p = 'd0;
  reg     [14:0]  sine_scale_n = 'd0;
  reg             sine_scale_sign = 'd0;
  reg     [15:0]  dds_data = 'd0;

  // internal signals

  wire    [15:0]  sine_s;
  wire    [14:0]  sine_p_s;
  wire    [14:0]  sine_n_s;
  wire    [31:0]  sine_scale_s;
  wire            sine_sign_s;
  wire            scale_sign_s;
  wire    [14:0]  sine_scale_p_s;
  wire    [14:0]  sine_scale_n_s;
  wire            sine_scale_sign_s;

  // sine generator

  ad_dds_sine #(.DELAY_DATA_WIDTH(1)) i_dds_sine (
    .clk (clk),
    .angle (angle),
    .sine (sine_s),
    .ddata_in (1'b0),
    .ddata_out ());

  // sign-magnitude

  assign sine_p_s = sine_s[14:0];
  assign sine_n_s = ~sine_s[14:0] + 1'b1;

  always @(posedge clk) begin
    sine_sign <= sine_s[15];
    if (sine_s[15] == 1'b1) begin
      sine_magn <= sine_n_s;
    end else begin
      sine_magn <= sine_p_s;
    end
  end

  // scale

  ad_mul_u16 #(.DELAY_DATA_WIDTH(2)) i_mul_u16 (
    .clk (clk),
    .data_a ({1'b0, sine_magn}),
    .data_b ({1'b0, scale[14:0]}),
    .data_p (sine_scale_s),
    .ddata_in ({sine_sign, scale[15]}),
    .ddata_out ({sine_sign_s, scale_sign_s}));

  assign sine_scale_p_s = sine_scale_s[28:14];
  assign sine_scale_n_s = ~sine_scale_s[28:14] + 1'b1;
  assign sine_scale_sign_s = sine_sign_s ^ scale_sign_s;

  always @(posedge clk) begin
    sine_scale_p <= sine_scale_p_s;
    sine_scale_n <= sine_scale_n_s;
    sine_scale_sign <= sine_scale_sign_s;
    if (scale[14:0] == 15'd0) begin
      dds_data <= 16'd0;
    end else if (sine_scale_sign == 1'b1) begin
      dds_data <= {1'b1, sine_scale_n};
    end else begin
      dds_data <= {1'b0, sine_scale_p};
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
