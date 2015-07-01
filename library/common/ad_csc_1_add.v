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
// Color Space Conversion, adder. This is a simple adder, but had to be
// pipe-lined for faster clock rates. The delay input is delay-matched to
// the sum pipe-line stages

`timescale 1ps/1ps

module ad_csc_1_add (

  // all signed

  clk,
  data_1,
  data_2,
  data_3,
  data_4,
  data_p,

  // delay match

  ddata_in,
  ddata_out);

  // parameters

  parameter   DELAY_DATA_WIDTH = 16;
  localparam  DW = DELAY_DATA_WIDTH - 1;

  // all signed

  input           clk;
  input   [24:0]  data_1;
  input   [24:0]  data_2;
  input   [24:0]  data_3;
  input   [24:0]  data_4;
  output  [ 7:0]  data_p;

  // delay match

  input   [DW:0]  ddata_in;
  output  [DW:0]  ddata_out;

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
  reg     [DW:0]  ddata_out = 'd0;
  reg     [ 7:0]  data_p = 'd0;

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
