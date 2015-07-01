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
// Color Space Conversion, multiplier. This is a simple partial product adder
// that generates the product of the two inputs.

`timescale 1ps/1ps

module ad_csc_1_mul (

  // data_a is signed

  clk,
  data_a,
  data_b,
  data_p,

  // delay match

  ddata_in,
  ddata_out);

  // parameters

  parameter   DELAY_DATA_WIDTH = 16;
  localparam  DW = DELAY_DATA_WIDTH - 1;

  // data_a is signed

  input           clk;
  input   [16:0]  data_a;
  input   [ 7:0]  data_b;
  output  [24:0]  data_p;

  // delay match

  input   [DW:0]  ddata_in;
  output  [DW:0]  ddata_out;

  // internal registers

  reg     [DW:0]  p1_ddata = 'd0;
  reg     [DW:0]  p2_ddata = 'd0;
  reg     [DW:0]  ddata_out = 'd0;
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
