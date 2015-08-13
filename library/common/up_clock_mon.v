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

`timescale 1ns/100ps

module up_clock_mon (

  // processor interface

  up_rstn,
  up_clk,
  up_d_count,

  // device interface

  d_rst,
  d_clk);

  // processor interface

  input           up_rstn;
  input           up_clk;
  output  [31:0]  up_d_count;

  // device interface

  input           d_rst;
  input           d_clk;

  // internal registers

  reg     [15:0]  up_count = 'd0;
  reg             up_count_toggle = 'd0;
  reg             up_count_toggle_m1 = 'd0;
  reg             up_count_toggle_m2 = 'd0;
  reg             up_count_toggle_m3 = 'd0;
  reg     [31:0]  up_d_count = 'd0;
  reg             d_count_toggle_m1 = 'd0;
  reg             d_count_toggle_m2 = 'd0;
  reg             d_count_toggle_m3 = 'd0;
  reg             d_count_toggle = 'd0;
  reg     [31:0]  d_count_hold = 'd0;
  reg     [32:0]  d_count = 'd0;

  // internal signals

  wire            up_count_toggle_s;
  wire            d_count_toggle_s;

  // processor reference

  assign up_count_toggle_s = up_count_toggle_m3 ^ up_count_toggle_m2;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_count <= 'd0;
      up_count_toggle <= 'd0;
      up_count_toggle_m1 <= 'd0;
      up_count_toggle_m2 <= 'd0;
      up_count_toggle_m3 <= 'd0;
      up_d_count <= 'd0;
    end else begin
      up_count <= up_count + 1'b1;
      if (up_count == 16'd0) begin
        up_count_toggle <= ~up_count_toggle;
      end
      up_count_toggle_m1 <= d_count_toggle;
      up_count_toggle_m2 <= up_count_toggle_m1;
      up_count_toggle_m3 <= up_count_toggle_m2;
      if (up_count_toggle_s == 1'b1) begin
        up_d_count <= d_count_hold;
      end
    end
  end

  // device free running

  assign d_count_toggle_s = d_count_toggle_m3 ^ d_count_toggle_m2;

  always @(posedge d_clk or posedge d_rst) begin
    if (d_rst == 1'b1) begin
      d_count_toggle_m1 <= 'd0;
      d_count_toggle_m2 <= 'd0;
      d_count_toggle_m3 <= 'd0;
    end else begin
      d_count_toggle_m1 <= up_count_toggle;
      d_count_toggle_m2 <= d_count_toggle_m1;
      d_count_toggle_m3 <= d_count_toggle_m2;
    end
  end

  always @(posedge d_clk) begin
    if (d_count_toggle_s == 1'b1) begin
      d_count_toggle <= ~d_count_toggle;
      d_count_hold <= d_count[31:0];
    end
    if (d_count_toggle_s == 1'b1) begin
      d_count <= 33'd1;
    end else if (d_count[32] == 1'b0) begin
      d_count <= d_count + 1'b1;
    end else begin
      d_count <= {33{1'b1}};
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
