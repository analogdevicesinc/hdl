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
// freedoms and responsabilities that he or she has by using this source/core.
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

`timescale 1ps/1ps

module axi_ad9361_serdes_clk #(

  // parameters

  parameter       DEVICE_TYPE = 0) (

  // clock and divided clock

  input           rst,
  input           clk_in_p,
  input           clk_in_n,
  output          clk,
  output          div_clk,
  output          out_clk,
  output          loaden,
  output  [ 7:0]  phase,

  // drp interface

  input           up_clk,
  input           up_rstn,
  input           up_drp_sel,
  input           up_drp_wr,
  input   [11:0]  up_drp_addr,
  input   [31:0]  up_drp_wdata,
  output  [31:0]  up_drp_rdata,
  output          up_drp_ready,
  output          up_drp_locked);

  // local parameter

  localparam ARRIA10 = 0;
  localparam CYCLONE5 = 1;

  // internal registers

  reg             up_drp_sel_int = 'd0;
  reg             up_drp_rd_int = 'd0;
  reg             up_drp_wr_int = 'd0;
  reg     [ 8:0]  up_drp_addr_int = 'd0;
  reg     [31:0]  up_drp_wdata_int = 'd0;
  reg     [31:0]  up_drp_rdata_int = 'd0;
  reg             up_drp_ready_int = 'd0;
  reg             up_drp_locked_int_m = 'd0;
  reg             up_drp_locked_int = 'd0;

  // internal signals

  wire            up_drp_reset;
  wire    [31:0]  up_drp_rdata_int_s;
  wire            up_drp_busy_int_s;
  wire            up_drp_locked_int_s;
  wire            loaden_s;
  wire            clk_s;

  // defaults

  assign up_drp_reset = ~up_rstn;
  assign out_clk = div_clk;
  assign up_drp_rdata = up_drp_rdata_int;
  assign up_drp_ready = up_drp_ready_int;
  assign up_drp_locked = up_drp_locked_int;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_drp_sel_int <= 1'b0;
      up_drp_rd_int <= 1'b0;
      up_drp_wr_int <= 1'b0;
      up_drp_addr_int <= 9'd0;
      up_drp_wdata_int <= 32'd0;
      up_drp_rdata_int <= 32'd0;
      up_drp_ready_int <= 1'b0;
      up_drp_locked_int_m <= 1'd0;
      up_drp_locked_int <= 1'd0;
    end else begin
      if (up_drp_sel_int == 1'b1) begin
        if (up_drp_busy_int_s == 1'b0) begin
          up_drp_sel_int <= 1'b0;
          up_drp_rd_int <= 1'b0;
          up_drp_wr_int <= 1'b0;
          up_drp_addr_int <= 9'd0;
          up_drp_wdata_int <= 32'd0;
          up_drp_rdata_int <= up_drp_rdata_int_s;
          up_drp_ready_int <= 1'b1;
        end
      end else if (up_drp_sel == 1'b1) begin
        up_drp_sel_int <= 1'b1;
        up_drp_rd_int <= ~up_drp_wr;
        up_drp_wr_int <= up_drp_wr;
        up_drp_addr_int <= up_drp_addr[8:0];
        up_drp_wdata_int <= up_drp_wdata;
        up_drp_rdata_int <= 32'd0;
        up_drp_ready_int <= 1'b0;
      end else begin
        up_drp_sel_int <= 1'b0;
        up_drp_rd_int <= 1'b0;
        up_drp_wr_int <= 1'b0;
        up_drp_addr_int <= 9'd0;
        up_drp_wdata_int <= 32'd0;
        up_drp_rdata_int <= 32'd0;
        up_drp_ready_int <= 1'b0;
      end
      up_drp_locked_int_m <= up_drp_locked_int_s;
      up_drp_locked_int <= up_drp_locked_int_m;
    end
  end

  generate

  if (DEVICE_TYPE == ARRIA10) begin
  axi_ad9361_serdes_clk_core i_core (
    .rst_reset (rst),
    .ref_clk_clk (clk_in_p),
    .locked_export (up_drp_locked_int_s),
    .hs_phase_phout (phase),
    .hs_clk_lvds_clk (clk),
    .loaden_loaden (loaden),
    .ls_clk_clk (div_clk));
  end

  if (DEVICE_TYPE == CYCLONE5) begin
  assign phase = 8'd0;
  axi_ad9361_serdes_clk_pll i_core (
    .rst_reset (rst),
    .ref_clk_clk (clk_in_p),
    .locked_export (up_drp_locked_int_s),
    .hs_clk_clk (clk_s),
    .loaden_clk (loaden_s),
    .ls_clk_clk (div_clk),
    .drp_clk_clk (up_clk),
    .drp_rst_reset (up_drp_reset),
    .pll_reconfig_waitrequest (up_drp_busy_int_s),
    .pll_reconfig_read (up_drp_rd_int),
    .pll_reconfig_write (up_drp_wr_int),
    .pll_reconfig_readdata (up_drp_rdata_int_s),
    .pll_reconfig_address (up_drp_addr_int[5:0]),
    .pll_reconfig_writedata (up_drp_wdata_int));

  cyclonev_pll_lvds_output #(
    .pll_loaden_enable_disable ("true"),
    .pll_lvdsclk_enable_disable ("true"))
  i_clk_buf (
    .ccout ({loaden_s, clk_s}),
    .loaden (loaden),
    .lvdsclk (clk));
  end

  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
