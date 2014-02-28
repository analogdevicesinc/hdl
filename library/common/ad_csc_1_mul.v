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

  reg             p1_sign = 'd0;
  reg     [DW:0]  p1_ddata = 'd0;
  reg     [23:0]  p1_data_p_0 = 'd0;
  reg     [23:0]  p1_data_p_1 = 'd0;
  reg     [23:0]  p1_data_p_2 = 'd0;
  reg     [23:0]  p1_data_p_3 = 'd0;
  reg     [23:0]  p1_data_p_4 = 'd0;
  reg             p2_sign = 'd0;
  reg     [DW:0]  p2_ddata = 'd0;
  reg     [23:0]  p2_data_p_0 = 'd0;
  reg     [23:0]  p2_data_p_1 = 'd0;
  reg             p3_sign = 'd0;
  reg     [DW:0]  p3_ddata = 'd0;
  reg     [23:0]  p3_data_p_0 = 'd0;
  reg     [DW:0]  ddata_out = 'd0;
  reg     [24:0]  data_p = 'd0;

  // internal wires

  wire    [16:0]  p1_data_a_1p_17_s;
  wire    [16:0]  p1_data_a_1n_17_s;
  wire    [23:0]  p1_data_a_1p_s;
  wire    [23:0]  p1_data_a_1n_s;
  wire    [23:0]  p1_data_a_2p_s;
  wire    [23:0]  p1_data_a_2n_s;

  // pipe line stage 1, get the two's complement versions

  assign p1_data_a_1p_17_s = {1'b0, data_a[15:0]};
  assign p1_data_a_1n_17_s = ~p1_data_a_1p_17_s + 1'b1;

  assign p1_data_a_1p_s = {{7{p1_data_a_1p_17_s[16]}}, p1_data_a_1p_17_s};
  assign p1_data_a_1n_s = {{7{p1_data_a_1n_17_s[16]}}, p1_data_a_1n_17_s};
  assign p1_data_a_2p_s = {{6{p1_data_a_1p_17_s[16]}}, p1_data_a_1p_17_s, 1'b0};
  assign p1_data_a_2n_s = {{6{p1_data_a_1n_17_s[16]}}, p1_data_a_1n_17_s, 1'b0};

  // pipe line stage 1, get the partial products

  always @(posedge clk) begin
    p1_sign <= data_a[16];
    p1_ddata <= ddata_in;
    case (data_b[1:0])
      2'b11: p1_data_p_0 <= p1_data_a_1n_s;
      2'b10: p1_data_p_0 <= p1_data_a_2n_s;
      2'b01: p1_data_p_0 <= p1_data_a_1p_s;
      default: p1_data_p_0 <= 24'd0;
    endcase
    case (data_b[3:1])
      3'b011: p1_data_p_1 <= {p1_data_a_2p_s[21:0], 2'd0};
      3'b100: p1_data_p_1 <= {p1_data_a_2n_s[21:0], 2'd0};
      3'b001: p1_data_p_1 <= {p1_data_a_1p_s[21:0], 2'd0};
      3'b010: p1_data_p_1 <= {p1_data_a_1p_s[21:0], 2'd0};
      3'b101: p1_data_p_1 <= {p1_data_a_1n_s[21:0], 2'd0};
      3'b110: p1_data_p_1 <= {p1_data_a_1n_s[21:0], 2'd0};
      default: p1_data_p_1 <= 24'd0;
    endcase
    case (data_b[5:3])
      3'b011: p1_data_p_2 <= {p1_data_a_2p_s[19:0], 4'd0};
      3'b100: p1_data_p_2 <= {p1_data_a_2n_s[19:0], 4'd0};
      3'b001: p1_data_p_2 <= {p1_data_a_1p_s[19:0], 4'd0};
      3'b010: p1_data_p_2 <= {p1_data_a_1p_s[19:0], 4'd0};
      3'b101: p1_data_p_2 <= {p1_data_a_1n_s[19:0], 4'd0};
      3'b110: p1_data_p_2 <= {p1_data_a_1n_s[19:0], 4'd0};
      default: p1_data_p_2 <= 24'd0;
    endcase
    case (data_b[7:5])
      3'b011: p1_data_p_3 <= {p1_data_a_2p_s[17:0], 6'd0};
      3'b100: p1_data_p_3 <= {p1_data_a_2n_s[17:0], 6'd0};
      3'b001: p1_data_p_3 <= {p1_data_a_1p_s[17:0], 6'd0};
      3'b010: p1_data_p_3 <= {p1_data_a_1p_s[17:0], 6'd0};
      3'b101: p1_data_p_3 <= {p1_data_a_1n_s[17:0], 6'd0};
      3'b110: p1_data_p_3 <= {p1_data_a_1n_s[17:0], 6'd0};
      default: p1_data_p_3 <= 24'd0;
    endcase
    case (data_b[7])
      1'b1: p1_data_p_4 <= {p1_data_a_1p_s[15:0], 8'd0};
      default: p1_data_p_4 <= 24'd0;
    endcase
  end

  // pipe line stage 2, get the sum (intermediate 5 -> 2)

  always @(posedge clk) begin
    p2_sign <= p1_sign;
    p2_ddata <= p1_ddata;
    p2_data_p_0 <= p1_data_p_0 + p1_data_p_1 + p1_data_p_4;
    p2_data_p_1 <= p1_data_p_2 + p1_data_p_3;
  end

  // pipe line stage 2, get the sum (final 2 -> 1)

  always @(posedge clk) begin
    p3_sign <= p2_sign;
    p3_ddata <= p2_ddata;
    p3_data_p_0 <= p2_data_p_0 + p2_data_p_1;
  end

  // output registers (truncation occurs after addition, see ad_csc_1_add.v)

  always @(posedge clk) begin
    ddata_out <= p3_ddata;
    data_p <= {p3_sign, p3_data_p_0};
  end

endmodule

// ***************************************************************************
// ***************************************************************************
