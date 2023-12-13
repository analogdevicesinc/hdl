// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_gpreg_clock_mon #(

  parameter   ID = 0,
  parameter   BUF_ENABLE = 0
) (

  // clock

  input                   d_clk,

  // bus interface

  input                   up_rstn,
  input                   up_clk,
  input                   up_wreq,
  input       [13:0]      up_waddr,
  input       [31:0]      up_wdata,
  output  reg             up_wack,
  input                   up_rreq,
  input       [13:0]      up_raddr,
  output  reg [31:0]      up_rdata,
  output  reg             up_rack
);

  // internal registers

  reg             up_d_preset = 'd0;
  reg             up_d_resetn = 'd0;

  // internal signals

  wire            up_wreq_s;
  wire            up_rreq_s;
  wire    [31:0]  up_d_count_s;
  wire            d_rst;
  wire            d_clk_g;

  // decode block select

  assign up_wreq_s = (up_waddr[13:4] == ID) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[13:4] == ID) ? up_rreq : 1'b0;

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_d_preset <= 1'd1;
      up_wack <= 'd0;
      up_d_resetn <= 'd0;
    end else begin
      up_d_preset <= ~up_d_resetn;
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h0)) begin
        up_d_resetn <= up_wdata[0];
      end
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr[3:0])
          4'b0000: up_rdata <= {31'd0, up_d_resetn};
          4'b0010: up_rdata <= up_d_count_s;
          default: up_rdata <= 32'd0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  // clock monitor

  up_clock_mon i_clock_mon (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_d_count (up_d_count_s),
    .d_rst (d_rst),
    .d_clk (d_clk_g));

  ad_rst i_d_rst_reg (
    .rst_async (up_d_preset),
    .clk (d_clk_g),
    .rstn (),
    .rst (d_rst));

  generate
  if (BUF_ENABLE == 1) begin
  BUFG i_bufg (
    .I (d_clk),
    .O (d_clk_g));
  end else begin
  assign d_clk_g = d_clk;
  end
  endgenerate

endmodule
