// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// This core  is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory of
//      the repository (LICENSE_GPL2), and at: <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license as noted in the top level directory, or on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module up_clock_mon (

  // processor interface

  input                   up_rstn,
  input                   up_clk,
  output  reg [31:0]      up_d_count,

  // device interface

  input                   d_rst,
  input                   d_clk);

  // internal registers

  reg     [15:0]  up_count = 'd0;
  reg             up_count_toggle = 'd0;
  reg             up_count_toggle_m1 = 'd0;
  reg             up_count_toggle_m2 = 'd0;
  reg             up_count_toggle_m3 = 'd0;
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
