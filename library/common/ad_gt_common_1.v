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

`timescale 1ns/1ps

module ad_gt_common_1 #(

  parameter   integer ID = 0,
  parameter   integer GTH_OR_GTX_N = 0,
  parameter   integer QPLL0_ENABLE = 1,
  parameter   integer QPLL0_REFCLK_DIV = 2,
  parameter   [26:0]  QPLL0_CFG = 27'h06801C1,
  parameter   integer QPLL0_FBDIV_RATIO = 1'b1,
  parameter   [ 9:0]  QPLL0_FBDIV = 10'b0000110000,
  parameter   integer QPLL1_ENABLE = 1,
  parameter   integer QPLL1_REFCLK_DIV = 2,
  parameter   [26:0]  QPLL1_CFG = 27'h06801C1,
  parameter   integer QPLL1_FBDIV_RATIO = 1'b1,
  parameter   [ 9:0]  QPLL1_FBDIV = 10'b0000110000) (

  // reset and clocks

  input                   qpll0_rst,
  input                   qpll0_ref_clk_in,
  input                   qpll1_rst,
  input                   qpll1_ref_clk_in,

  output      [ 7:0]      qpll_clk,
  output      [ 7:0]      qpll_ref_clk,
  output      [ 7:0]      qpll_locked,

  // bus interface

  input                   up_rstn,
  input                   up_clk,
  input                   up_wreq,
  input       [13:0]      up_waddr,
  input       [31:0]      up_wdata,
  output                  up_wack,
  input                   up_rreq,
  input       [13:0]      up_raddr,
  output      [31:0]      up_rdata,
  output                  up_rack);


  // internal signals

  wire            up_drp_qpll0_sel_s;
  wire            up_drp_qpll0_wr_s;
  wire    [11:0]  up_drp_qpll0_addr_s;
  wire    [15:0]  up_drp_qpll0_wdata_s;
  wire    [15:0]  up_drp_qpll0_rdata_s;
  wire            up_drp_qpll0_ready_s;
  wire            up_drp_qpll1_sel_s;
  wire            up_drp_qpll1_wr_s;
  wire    [11:0]  up_drp_qpll1_addr_s;
  wire    [15:0]  up_drp_qpll1_wdata_s;
  wire    [15:0]  up_drp_qpll1_rdata_s;
  wire            up_drp_qpll1_ready_s;

  // replicate to match channels

  assign qpll_clk[1] = qpll_clk[0];
  assign qpll_ref_clk[1] = qpll_ref_clk[0];
  assign qpll_locked[1] = qpll_locked[0];

  assign qpll_clk[2] = qpll_clk[0];
  assign qpll_ref_clk[2] = qpll_ref_clk[0];
  assign qpll_locked[2] = qpll_locked[0];

  assign qpll_clk[3] = qpll_clk[0];
  assign qpll_ref_clk[3] = qpll_ref_clk[0];
  assign qpll_locked[3] = qpll_locked[0];

  assign qpll_clk[5] = qpll_clk[4];
  assign qpll_ref_clk[5] = qpll_ref_clk[4];
  assign qpll_locked[5] = qpll_locked[4];

  assign qpll_clk[6] = qpll_clk[4];
  assign qpll_ref_clk[6] = qpll_ref_clk[4];
  assign qpll_locked[6] = qpll_locked[4];

  assign qpll_clk[7] = qpll_clk[4];
  assign qpll_ref_clk[7] = qpll_ref_clk[4];
  assign qpll_locked[7] = qpll_locked[4];

  // instantiations

  ad_gt_common #(
    .GTH_OR_GTX_N (GTH_OR_GTX_N),
    .QPLL_ENABLE (QPLL0_ENABLE),
    .QPLL_REFCLK_DIV (QPLL0_REFCLK_DIV),
    .QPLL_CFG (QPLL0_CFG),
    .QPLL_FBDIV_RATIO (QPLL0_FBDIV_RATIO),
    .QPLL_FBDIV (QPLL0_FBDIV))
  i_qpll_0 (
    .qpll_ref_clk_in (qpll0_ref_clk_in),
    .qpll_rst (qpll0_rst),
    .qpll_clk (qpll_clk[0]),
    .qpll_ref_clk (qpll_ref_clk[0]),
    .qpll_locked (qpll_locked[0]),
    .up_clk (up_clk),
    .up_drp_sel (up_drp_qpll0_sel_s),
    .up_drp_addr (up_drp_qpll0_addr_s),
    .up_drp_wr (up_drp_qpll0_wr_s),
    .up_drp_wdata (up_drp_qpll0_wdata_s),
    .up_drp_rdata (up_drp_qpll0_rdata_s),
    .up_drp_ready (up_drp_qpll0_ready_s));

  ad_gt_common #(
    .GTH_OR_GTX_N (GTH_OR_GTX_N),
    .QPLL_ENABLE (QPLL1_ENABLE),
    .QPLL_REFCLK_DIV (QPLL1_REFCLK_DIV),
    .QPLL_CFG (QPLL1_CFG),
    .QPLL_FBDIV_RATIO (QPLL1_FBDIV_RATIO),
    .QPLL_FBDIV (QPLL1_FBDIV))
  i_qpll_1 (
    .qpll_ref_clk_in (qpll1_ref_clk_in),
    .qpll_rst (qpll1_rst),
    .qpll_clk (qpll_clk[4]),
    .qpll_ref_clk (qpll_ref_clk[4]),
    .qpll_locked (qpll_locked[4]),
    .up_clk (up_clk),
    .up_drp_sel (up_drp_qpll1_sel_s),
    .up_drp_addr (up_drp_qpll1_addr_s),
    .up_drp_wr (up_drp_qpll1_wr_s),
    .up_drp_wdata (up_drp_qpll1_wdata_s),
    .up_drp_rdata (up_drp_qpll1_rdata_s),
    .up_drp_ready (up_drp_qpll1_ready_s));

  up_gt #(
    .GTH_OR_GTX_N (GTH_OR_GTX_N))
  i_up (
    .up_drp_qpll0_sel (up_drp_qpll0_sel_s),
    .up_drp_qpll0_wr (up_drp_qpll0_wr_s),
    .up_drp_qpll0_addr (up_drp_qpll0_addr_s),
    .up_drp_qpll0_wdata (up_drp_qpll0_wdata_s),
    .up_drp_qpll0_rdata (up_drp_qpll0_rdata_s),
    .up_drp_qpll0_ready (up_drp_qpll0_ready_s),
    .up_drp_qpll1_sel (up_drp_qpll1_sel_s),
    .up_drp_qpll1_wr (up_drp_qpll1_wr_s),
    .up_drp_qpll1_addr (up_drp_qpll1_addr_s),
    .up_drp_qpll1_wdata (up_drp_qpll1_wdata_s),
    .up_drp_qpll1_rdata (up_drp_qpll1_rdata_s),
    .up_drp_qpll1_ready (up_drp_qpll1_ready_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule

// ***************************************************************************
// ***************************************************************************

