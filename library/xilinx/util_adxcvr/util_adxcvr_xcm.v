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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/1ps

module util_adxcvr_xcm #(

  // parameters

  parameter   integer XCVR_TYPE = 0,
  parameter   integer QPLL_REFCLK_DIV = 1,
  parameter   integer QPLL_FBDIV_RATIO = 1,
  parameter   [15:0]  POR_CFG = 16'b0000000000000110,
  parameter   [15:0]  PPF0_CFG = 16'b0000011000000000,
  parameter   [26:0]  QPLL_CFG = 27'h0680181,
  parameter   [ 9:0]  QPLL_FBDIV =  10'b0000110000,
  parameter   [15:0]  QPLL_CFG0 = 16'b0011001100011100,
  parameter   [15:0]  QPLL_CFG1 = 16'b1101000000111000,
  parameter   [15:0]  QPLL_CFG1_G3 = 16'b1101000000111000,
  parameter   [15:0]  QPLL_CFG2 = 16'b0000111111000000,
  parameter   [15:0]  QPLL_CFG2_G3 = 16'b0000111111000000,
  parameter   [15:0]  QPLL_CFG3 = 16'b0000000100100000,
  parameter   [15:0]  QPLL_CFG4 = 16'b0000000000000011,
  parameter   [15:0]  QPLL_CP_G3 = 10'b0000011111,
  parameter   [15:0]  QPLL_LPF = 10'b0100110111,
  parameter   [15:0]  QPLL_CP = 10'b0001111111

) (

  // reset and clocks

  input           qpll_ref_clk,
  input           qpll_sel,
  output          qpll2ch_clk,
  output          qpll2ch_ref_clk,
  output          qpll2ch_locked,

  output          qpll1_clk,
  output          qpll1_ref_clk,
  output          qpll1_locked,

  // drp interface

  input           up_rstn,
  input           up_clk,
  input           up_qpll_rst,
  input           up_cm_enb,
  input   [11:0]  up_cm_addr,
  input           up_cm_wr,
  input   [15:0]  up_cm_wdata,
  output  [15:0]  up_cm_rdata,
  output          up_cm_ready);

  localparam GTXE2_TRANSCEIVERS = 2;
  localparam GTHE3_TRANSCEIVERS = 5;
  localparam GTHE4_TRANSCEIVERS = 8;
  localparam GTYE4_TRANSCEIVERS = 9;

  // internal registers

  reg             up_enb_int = 'd0;
  reg     [11:0]  up_addr_int = 'd0;
  reg             up_wr_int = 'd0;
  reg     [15:0]  up_wdata_int = 'd0;
  reg     [15:0]  up_rdata_int = 'd0;
  reg             up_ready_int = 'd0;
  reg             up_sel_int = 'd0;

  // internal signals

  wire    [15:0]  up_rdata_s;
  wire            up_ready_s;

  // drp access

  assign up_cm_rdata = up_rdata_int;
  assign up_cm_ready = up_ready_int;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_enb_int <= 1'd0;
      up_addr_int <= 12'd0;
      up_wr_int <= 1'd0;
      up_wdata_int <= 16'd0;
      up_rdata_int <= 16'd0;
      up_ready_int <= 1'd0;
      up_sel_int <= 1'b0;
    end else begin
      if (up_cm_enb == 1'b1) begin
        up_enb_int <= up_cm_enb;
        up_addr_int <= up_cm_addr;
        up_wr_int <= up_cm_wr;
        up_wdata_int <= up_cm_wdata;
      end else begin
        up_enb_int <= 1'd0;
        up_addr_int <= 12'd0;
        up_wr_int <= 1'd0;
        up_wdata_int <= 16'd0;
      end

      if (up_cm_enb == 1'b1) begin
        up_sel_int <= 1'b1;
      end else if (up_ready_s == 1'b1) begin
        up_sel_int <= 1'b0;
      end

      if (up_sel_int == 1'b1) begin
        up_ready_int <= up_ready_s;
        up_rdata_int <= up_rdata_s;
      end else begin
        up_ready_int <= 1'b0;
        up_rdata_int <= 'h00;
      end
    end
  end

  // instantiations

  generate
  if (XCVR_TYPE == GTXE2_TRANSCEIVERS) begin
  assign qpll1_locked = 1'b0;
  assign qpll1_clk = 1'b0;
  assign qpll1_ref_clk = 1'b0;
  GTXE2_COMMON #(
    .BIAS_CFG (64'h0000040000001000),
    .COMMON_CFG (32'h00000000),
    .IS_DRPCLK_INVERTED (1'b0),
    .IS_GTGREFCLK_INVERTED (1'b0),
    .IS_QPLLLOCKDETCLK_INVERTED (1'b0),
    .QPLL_CFG (QPLL_CFG),
    .QPLL_CLKOUT_CFG (4'b0000),
    .QPLL_COARSE_FREQ_OVRD (6'b010000),
    .QPLL_COARSE_FREQ_OVRD_EN (1'b0),
    .QPLL_CP (10'b0000011111),
    .QPLL_CP_MONITOR_EN (1'b0),
    .QPLL_DMONITOR_SEL (1'b0),
    .QPLL_FBDIV (QPLL_FBDIV),
    .QPLL_FBDIV_MONITOR_EN (1'b0),
    .QPLL_FBDIV_RATIO (QPLL_FBDIV_RATIO),
    .QPLL_INIT_CFG (24'h000006),
    .QPLL_LOCK_CFG (16'h21E8),
    .QPLL_LPF (4'b1111),
    .QPLL_REFCLK_DIV (QPLL_REFCLK_DIV),
    .SIM_QPLLREFCLK_SEL (3'b001),
    .SIM_RESET_SPEEDUP ("TRUE"),
    .SIM_VERSION ("4.0"))
  i_gtxe2_common (
    .QPLLDMONITOR (),
    .QPLLFBCLKLOST (),
    .REFCLKOUTMONITOR (),
    .BGBYPASSB (1'h1),
    .BGMONITORENB (1'h1),
    .BGPDB (1'h1),
    .BGRCALOVRD (5'h1f),
    .DRPADDR (up_addr_int[7:0]),
    .DRPCLK (up_clk),
    .DRPDI (up_wdata_int),
    .DRPDO (up_rdata_s),
    .DRPEN (up_enb_int),
    .DRPRDY (up_ready_s),
    .DRPWE (up_wr_int),
    .GTGREFCLK (1'h0),
    .GTNORTHREFCLK0 (1'h0),
    .GTNORTHREFCLK1 (1'h0),
    .GTREFCLK0 (qpll_ref_clk),
    .GTREFCLK1 (1'h0),
    .GTSOUTHREFCLK0 (1'h0),
    .GTSOUTHREFCLK1 (1'h0),
    .PMARSVD (8'h0),
    .QPLLLOCK (qpll2ch_locked),
    .QPLLLOCKDETCLK (up_clk),
    .QPLLLOCKEN (1'h1),
    .QPLLOUTCLK (qpll2ch_clk),
    .QPLLOUTREFCLK (qpll2ch_ref_clk),
    .QPLLOUTRESET (1'h0),
    .QPLLPD (1'h0),
    .QPLLREFCLKLOST (),
    .QPLLREFCLKSEL (3'h1),
    .QPLLRESET (up_qpll_rst),
    .QPLLRSVD1 (16'h0),
    .QPLLRSVD2 (5'h1f),
    .RCALENB (1'h1));
  end
  endgenerate

  generate
  if (XCVR_TYPE == GTHE3_TRANSCEIVERS) begin
  GTHE3_COMMON #(
    .BIAS_CFG0 (16'h0000),
    .BIAS_CFG1 (16'h0000),
    .BIAS_CFG2 (16'h0000),
    .BIAS_CFG3 (16'h0040),
    .BIAS_CFG4 (16'h0000),
    .BIAS_CFG_RSVD (10'b0000000000),
    .COMMON_CFG0 (16'h0000),
    .COMMON_CFG1 (16'h0000),
    .POR_CFG (16'h0004),
    .QPLL0_CFG0 (16'h321c),
    .QPLL0_CFG1 (16'h1018),
    .QPLL0_CFG1_G3 (16'h1018),
    .QPLL0_CFG2 (16'h0048),
    .QPLL0_CFG2_G3 (16'h0048),
    .QPLL0_CFG3 (16'h0120),
    .QPLL0_CFG4 (16'h0000),
    .QPLL0_CP (10'b0000011111),
    .QPLL0_CP_G3 (10'b1111111111),
    .QPLL0_FBDIV (QPLL_FBDIV),
    .QPLL0_FBDIV_G3 (80),
    .QPLL0_INIT_CFG0 (16'h02b2),
    .QPLL0_INIT_CFG1 (8'h00),
    .QPLL0_LOCK_CFG (16'h21e8),
    .QPLL0_LOCK_CFG_G3 (16'h21e8),
    .QPLL0_LPF (10'b1111111111),
    .QPLL0_LPF_G3 (10'b0000010101),
    .QPLL0_REFCLK_DIV (QPLL_REFCLK_DIV),
    .QPLL0_SDM_CFG0 (16'b0000000000000000),
    .QPLL0_SDM_CFG1 (16'b0000000000000000),
    .QPLL0_SDM_CFG2 (16'b0000000000000000),
    .QPLL1_CFG0 (16'h321c),
    .QPLL1_CFG1 (16'h1018),
    .QPLL1_CFG1_G3 (16'h1018),
    .QPLL1_CFG2 (16'h0040),
    .QPLL1_CFG2_G3 (16'h0040),
    .QPLL1_CFG3 (16'h0120),
    .QPLL1_CFG4 (16'h0000),
    .QPLL1_CP (10'b0000011111),
    .QPLL1_CP_G3 (10'b1111111111),
    .QPLL1_FBDIV (QPLL_FBDIV),
    .QPLL1_FBDIV_G3 (80),
    .QPLL1_INIT_CFG0 (16'h02b2),
    .QPLL1_INIT_CFG1 (8'h00),
    .QPLL1_LOCK_CFG (16'h21e8),
    .QPLL1_LOCK_CFG_G3 (16'h21e8),
    .QPLL1_LPF (10'b1111111111),
    .QPLL1_LPF_G3 (10'b0000010101),
    .QPLL1_REFCLK_DIV (QPLL_REFCLK_DIV),
    .QPLL1_SDM_CFG0 (16'b0000000000000000),
    .QPLL1_SDM_CFG1 (16'b0000000000000000),
    .QPLL1_SDM_CFG2 (16'b0000000000000000),
    .RSVD_ATTR0 (16'h0000),
    .RSVD_ATTR1 (16'h0000),
    .RSVD_ATTR2 (16'h0000),
    .RSVD_ATTR3 (16'h0000),
    .RXRECCLKOUT0_SEL (2'b00),
    .RXRECCLKOUT1_SEL (2'b00),
    .SARC_EN (1'b1),
    .SARC_SEL (1'b0),
    .SDM0DATA1_0 (16'b0000000000000000),
    .SDM0DATA1_1 (9'b000000000),
    .SDM0INITSEED0_0 (16'b0000000000000000),
    .SDM0INITSEED0_1 (9'b000000000),
    .SDM0_DATA_PIN_SEL (1'b0),
    .SDM0_WIDTH_PIN_SEL (1'b0),
    .SDM1DATA1_0 (16'b0000000000000000),
    .SDM1DATA1_1 (9'b000000000),
    .SDM1INITSEED0_0 (16'b0000000000000000),
    .SDM1INITSEED0_1 (9'b000000000),
    .SDM1_DATA_PIN_SEL (1'b0),
    .SDM1_WIDTH_PIN_SEL (1'b0),
    .SIM_MODE ("FAST"),
    .SIM_RESET_SPEEDUP ("TRUE"),
    .SIM_VERSION (2))
  i_gthe3_common (
    .BGBYPASSB (1'h1),
    .BGMONITORENB (1'h1),
    .BGPDB (1'h1),
    .BGRCALOVRD (5'h1f),
    .BGRCALOVRDENB (1'h1),
    .DRPADDR (up_addr_int[8:0]),
    .DRPCLK (up_clk),
    .DRPDI (up_wdata_int),
    .DRPDO (up_rdata_s),
    .DRPEN (up_enb_int),
    .DRPRDY (up_ready_s),
    .DRPWE (up_wr_int),
    .GTGREFCLK0 (1'h0),
    .GTGREFCLK1 (1'h0),
    .GTNORTHREFCLK00 (1'h0),
    .GTNORTHREFCLK01 (1'h0),
    .GTNORTHREFCLK10 (1'h0),
    .GTNORTHREFCLK11 (1'h0),
    .GTREFCLK00 (qpll_ref_clk),
    .GTREFCLK01 (1'h0),
    .GTREFCLK10 (1'h0),
    .GTREFCLK11 (1'h0),
    .GTSOUTHREFCLK00 (1'h0),
    .GTSOUTHREFCLK01 (1'h0),
    .GTSOUTHREFCLK10 (1'h0),
    .GTSOUTHREFCLK11 (1'h0),
    .PMARSVD0 (8'h0),
    .PMARSVD1 (8'h0),
    .PMARSVDOUT0 (),
    .PMARSVDOUT1 (),
    .QPLL0CLKRSVD0 (1'h0),
    .QPLL0CLKRSVD1 (1'h0),
    .QPLL0FBCLKLOST (),
    .QPLL0LOCK (qpll2ch_locked),
    .QPLL0LOCKDETCLK (up_clk),
    .QPLL0LOCKEN (1'h1),
    .QPLL0OUTCLK (qpll2ch_clk),
    .QPLL0OUTREFCLK (qpll2ch_ref_clk),
    .QPLL0PD (1'h0),
    .QPLL0REFCLKLOST (),
    .QPLL0REFCLKSEL (3'h1),
    .QPLL0RESET (up_qpll_rst),
    .QPLL1CLKRSVD0 (1'h0),
    .QPLL1CLKRSVD1 (1'h0),
    .QPLL1FBCLKLOST (),
    .QPLL1LOCK (qpll1_locked),
    .QPLL1LOCKDETCLK (up_clk),
    .QPLL1LOCKEN (1'h1),
    .QPLL1OUTCLK (qpll1_clk),
    .QPLL1OUTREFCLK (qpll1_ref_clk),
    .QPLL1PD (~qpll_sel),
    .QPLL1REFCLKLOST (),
    .QPLL1REFCLKSEL (3'h1),
    .QPLL1RESET (up_qpll_rst),
    .QPLLDMONITOR0 (),
    .QPLLDMONITOR1 (),
    .QPLLRSVD1 (8'h0),
    .QPLLRSVD2 (5'h0),
    .QPLLRSVD3 (5'h0),
    .QPLLRSVD4 (8'h0),
    .RCALENB (1'h1),
    .REFCLKOUTMONITOR0 (),
    .REFCLKOUTMONITOR1 (),
    .RXRECCLK0_SEL (),
    .RXRECCLK1_SEL ());
  end
  endgenerate

  generate
  if (XCVR_TYPE == GTHE4_TRANSCEIVERS) begin
  GTHE4_COMMON #(
    .AEN_QPLL0_FBDIV (1'b1),
    .AEN_QPLL1_FBDIV (1'b1),
    .AEN_SDM0TOGGLE (1'b0),
    .AEN_SDM1TOGGLE (1'b0),
    .A_SDM0TOGGLE (1'b0),
    .A_SDM1DATA_HIGH (9'b000000000),
    .A_SDM1DATA_LOW (16'b0000000000000000),
    .A_SDM1TOGGLE (1'b0),
    .BIAS_CFG0 (16'b0000000000000000),
    .BIAS_CFG1 (16'b0000000000000000),
    .BIAS_CFG2 (16'b0000000100100100),
    .BIAS_CFG3 (16'b0000000001000001),
    .BIAS_CFG4 (16'b0000000000010000),
    .BIAS_CFG_RSVD (16'b0000000000000000),
    .COMMON_CFG0 (16'b0000000000000000),
    .COMMON_CFG1 (16'b0000000000000000),
    .POR_CFG (POR_CFG),
    .PPF0_CFG (PPF0_CFG),
    .PPF1_CFG (16'b0000011000000000),
    .QPLL0CLKOUT_RATE ("HALF"),
    .QPLL0_CFG0 (QPLL_CFG0),
    .QPLL0_CFG1 (QPLL_CFG1),
    .QPLL0_CFG1_G3 (QPLL_CFG1_G3),
    .QPLL0_CFG2 (QPLL_CFG2),
    .QPLL0_CFG2_G3 (QPLL_CFG2_G3),
    .QPLL0_CFG3 (QPLL_CFG3),
    .QPLL0_CFG4 (QPLL_CFG4),
    .QPLL0_CP (QPLL_CP),
    .QPLL0_CP_G3 (QPLL_CP_G3),
    .QPLL0_FBDIV (QPLL_FBDIV),
    .QPLL0_FBDIV_G3 (160),
    .QPLL0_INIT_CFG0 (16'b0000001010110010),
    .QPLL0_INIT_CFG1 (8'b00000000),
    .QPLL0_LOCK_CFG (16'b0010010111101000),
    .QPLL0_LOCK_CFG_G3 (16'b0010010111101000),
    .QPLL0_LPF (QPLL_LPF),
    .QPLL0_LPF_G3 (10'b0111010101),
    .QPLL0_PCI_EN (1'b0),
    .QPLL0_RATE_SW_USE_DRP (1'b1),
    .QPLL0_REFCLK_DIV (QPLL_REFCLK_DIV),
    .QPLL0_SDM_CFG0 (16'b0000000010000000),
    .QPLL0_SDM_CFG1 (16'b0000000000000000),
    .QPLL0_SDM_CFG2 (16'b0000000000000000),
    .QPLL1CLKOUT_RATE ("HALF"),
    .QPLL1_CFG0 (QPLL_CFG0),
    .QPLL1_CFG1 (QPLL_CFG1),
    .QPLL1_CFG1_G3 (QPLL_CFG1_G3),
    .QPLL1_CFG2 (QPLL_CFG2),
    .QPLL1_CFG2_G3 (QPLL_CFG2_G3),
    .QPLL1_CFG3 (QPLL_CFG3),
    .QPLL1_CFG4 (QPLL_CFG4),
    .QPLL1_CP (10'b1111111111),
    .QPLL1_CP_G3 (10'b0011111111),
    .QPLL1_FBDIV (QPLL_FBDIV),
    .QPLL1_FBDIV_G3 (80),
    .QPLL1_INIT_CFG0 (16'b0000001010110010),
    .QPLL1_INIT_CFG1 (8'b00000000),
    .QPLL1_LOCK_CFG (16'b0010010111101000),
    .QPLL1_LOCK_CFG_G3 (16'b0010010111101000),
    .QPLL1_LPF (10'b0100110101),
    .QPLL1_LPF_G3 (10'b0111010100),
    .QPLL1_PCI_EN (1'b0),
    .QPLL1_RATE_SW_USE_DRP (1'b1),
    .QPLL1_REFCLK_DIV (QPLL_REFCLK_DIV),
    .QPLL1_SDM_CFG0 (16'b0000000010000000),
    .QPLL1_SDM_CFG1 (16'b0000000000000000),
    .QPLL1_SDM_CFG2 (16'b0000000000000000),
    .RSVD_ATTR0 (16'b0000000000000000),
    .RSVD_ATTR1 (16'b0000000000000000),
    .RSVD_ATTR2 (16'b0000000000000000),
    .RSVD_ATTR3 (16'b0000000000000000),
    .RXRECCLKOUT0_SEL (2'b00),
    .RXRECCLKOUT1_SEL (2'b00),
    .SARC_ENB (1'b0),
    .SARC_SEL (1'b0),
    .SDM0INITSEED0_0 (16'b0000000100010001),
    .SDM0INITSEED0_1 (9'b000010001),
    .SDM1INITSEED0_0 (16'b0000000100010001),
    .SDM1INITSEED0_1 (9'b000010001),
    .SIM_MODE ("FAST"),
    .SIM_RESET_SPEEDUP ("TRUE"))
  i_gthe4_common (
    .BGBYPASSB (1'd1),
    .BGMONITORENB (1'd1),
    .BGPDB (1'd1),
    .BGRCALOVRD (5'b11111),
    .BGRCALOVRDENB (1'd1),
    .DRPADDR ({4'd0, up_addr_int}),
    .DRPCLK (up_clk),
    .DRPDI (up_wdata_int),
    .DRPDO (up_rdata_s),
    .DRPEN (up_enb_int),
    .DRPRDY (up_ready_s),
    .DRPWE (up_wr_int),
    .GTGREFCLK0 (1'd0),
    .GTGREFCLK1 (1'd0),
    .GTNORTHREFCLK00 (1'd0),
    .GTNORTHREFCLK01 (1'd0),
    .GTNORTHREFCLK10 (1'd0),
    .GTNORTHREFCLK11 (1'd0),
    .GTREFCLK00 (qpll_ref_clk),
    .GTREFCLK01 (qpll_ref_clk),
    .GTREFCLK10 (1'd0),
    .GTREFCLK11 (1'd0),
    .GTSOUTHREFCLK00 (1'd0),
    .GTSOUTHREFCLK01 (1'd0),
    .GTSOUTHREFCLK10 (1'd0),
    .GTSOUTHREFCLK11 (1'd0),
    .PCIERATEQPLL0 (3'd0),
    .PCIERATEQPLL1 (3'd0),
    .PMARSVD0 (8'd0),
    .PMARSVD1 (8'd0),
    .PMARSVDOUT0 (),
    .PMARSVDOUT1 (),
    .QPLL0CLKRSVD0 (1'd0),
    .QPLL0CLKRSVD1 (1'd0),
    .QPLL0FBCLKLOST (),
    .QPLL0FBDIV (8'd0),
    .QPLL0LOCK (qpll2ch_locked),
    .QPLL0LOCKDETCLK (up_clk),
    .QPLL0LOCKEN (1'd1),
    .QPLL0OUTCLK (qpll2ch_clk),
    .QPLL0OUTREFCLK (qpll2ch_ref_clk),
    .QPLL0PD (qpll_sel),
    .QPLL0REFCLKLOST (),
    .QPLL0REFCLKSEL (3'b001),
    .QPLL0RESET (up_qpll_rst),
    .QPLL1CLKRSVD0 (1'd0),
    .QPLL1CLKRSVD1 (1'd0),
    .QPLL1FBCLKLOST (),
    .QPLL1FBDIV (8'd0),
    .QPLL1LOCK (qpll1_locked),
    .QPLL1LOCKDETCLK (up_clk),
    .QPLL1LOCKEN (1'd1),
    .QPLL1OUTCLK (qpll1_clk),
    .QPLL1OUTREFCLK (qpll1_ref_clk),
    .QPLL1PD (~qpll_sel),
    .QPLL1REFCLKLOST (),
    .QPLL1REFCLKSEL (3'b001),
    .QPLL1RESET (up_qpll_rst),
    .QPLLDMONITOR0 (),
    .QPLLDMONITOR1 (),
    .QPLLRSVD1 (8'd0),
    .QPLLRSVD2 (5'd0),
    .QPLLRSVD3 (5'd0),
    .QPLLRSVD4 (8'd0),
    .RCALENB (1'd1),
    .REFCLKOUTMONITOR0 (),
    .REFCLKOUTMONITOR1 (),
    .RXRECCLK0SEL (),
    .RXRECCLK1SEL (),
    .SDM0DATA (25'd0),
    .SDM0FINALOUT (),
    .SDM0RESET (1'd0),
    .SDM0TESTDATA (),
    .SDM0TOGGLE (1'd0),
    .SDM0WIDTH (2'd0),
    .SDM1DATA (25'd0),
    .SDM1FINALOUT (),
    .SDM1RESET (1'd0),
    .SDM1TESTDATA (),
    .SDM1TOGGLE (1'd0),
    .SDM1WIDTH (2'd0),
    .TCONGPI (10'd0),
    .TCONGPO (),
    .TCONPOWERUP (1'd0),
    .TCONRESET (2'd0),
    .TCONRSVDIN1 (2'd0),
    .TCONRSVDOUT0 ());
  end
  endgenerate

  generate
  if (XCVR_TYPE == GTYE4_TRANSCEIVERS) begin
    GTYE4_COMMON #(
      .AEN_QPLL0_FBDIV (1'b1),
      .AEN_QPLL1_FBDIV (1'b1),
      .AEN_SDM0TOGGLE (1'b0),
      .AEN_SDM1TOGGLE (1'b0),
      .A_SDM0TOGGLE (1'b0),
      .A_SDM1DATA_HIGH (9'b000000000),
      .A_SDM1DATA_LOW (16'b0000000000000000),
      .A_SDM1TOGGLE (1'b0),
      .BIAS_CFG0 (16'b0000000000000000),
      .BIAS_CFG1 (16'b0000000000000000),
      .BIAS_CFG2 (16'b0000000100100100),
      .BIAS_CFG3 (16'b0000000001000001),
      .BIAS_CFG4 (16'b0000000000010000),
      .BIAS_CFG_RSVD (16'b0000000000000000),
      .COMMON_CFG0 (16'b0000000000000000),
      .COMMON_CFG1 (16'b0000000000000000),
      .POR_CFG (16'b0000000000000000),
      .PPF0_CFG (PPF0_CFG),
      .PPF1_CFG (16'b0000011000000000),
      .QPLL0CLKOUT_RATE ("HALF"),
      .QPLL0_CFG0 (QPLL_CFG0),
      .QPLL0_CFG1 (QPLL_CFG1),
      .QPLL0_CFG1_G3 (QPLL_CFG1_G3),
      .QPLL0_CFG2 (QPLL_CFG2),
      .QPLL0_CFG2_G3 (QPLL_CFG2_G3),
      .QPLL0_CFG3 (QPLL_CFG3),
      .QPLL0_CFG4 (QPLL_CFG4),
      .QPLL0_CP (10'b0011111111),
      .QPLL0_CP_G3 (10'b0000001111),
      .QPLL0_FBDIV (QPLL_FBDIV),
      .QPLL0_FBDIV_G3 (160),
      .QPLL0_INIT_CFG0 (16'b0000001010110010),
      .QPLL0_INIT_CFG1 (8'b00000000),
      .QPLL0_LOCK_CFG (16'b0010010111101000),
      .QPLL0_LOCK_CFG_G3 (16'b0010010111101000),
      .QPLL0_LPF (QPLL_LPF),
      .QPLL0_LPF_G3 (10'b0111010101),
      .QPLL0_PCI_EN (1'b0),
      .QPLL0_RATE_SW_USE_DRP (1'b1),
      .QPLL0_REFCLK_DIV (QPLL_REFCLK_DIV),
      .QPLL0_SDM_CFG0 (16'b0000000010000000),
      .QPLL0_SDM_CFG1 (16'b0000000000000000),
      .QPLL0_SDM_CFG2 (16'b0000000000000000),
      .QPLL1CLKOUT_RATE ("HALF"),
      .QPLL1_CFG0 (QPLL_CFG0),
      .QPLL1_CFG1 (QPLL_CFG1),
      .QPLL1_CFG1_G3 (QPLL_CFG1_G3),
      .QPLL1_CFG2 (QPLL_CFG2),
      .QPLL1_CFG2_G3 (QPLL_CFG2_G3),
      .QPLL1_CFG3 (QPLL_CFG3),
      .QPLL1_CFG4 (QPLL_CFG4),
      .QPLL1_CP (10'b0011111111),
      .QPLL1_CP_G3 (10'b0001111111),
      .QPLL1_FBDIV (QPLL_FBDIV),
      .QPLL1_FBDIV_G3 (80),
      .QPLL1_INIT_CFG0 (16'b0000001010110010),
      .QPLL1_INIT_CFG1 (8'b00000000),
      .QPLL1_LOCK_CFG (16'b0010010111101000),
      .QPLL1_LOCK_CFG_G3 (16'b0010010111101000),
      .QPLL1_LPF (10'b1000011111),
      .QPLL1_LPF_G3 (10'b0111010100),
      .QPLL1_PCI_EN (1'b0),
      .QPLL1_RATE_SW_USE_DRP (1'b1),
      .QPLL1_REFCLK_DIV (QPLL_REFCLK_DIV),
      .QPLL1_SDM_CFG0 (16'b0000000010000000),
      .QPLL1_SDM_CFG1 (16'b0000000000000000),
      .QPLL1_SDM_CFG2 (16'b0000000000000000),
      .RSVD_ATTR0 (16'b0000000000000000),
      .RSVD_ATTR1 (16'b0000000000000000),
      .RSVD_ATTR2 (16'b0000000000000000),
      .RSVD_ATTR3 (16'b0000000000000000),
      .RXRECCLKOUT0_SEL (2'b00),
      .RXRECCLKOUT1_SEL (2'b00),
      .SARC_ENB (1'b0),
      .SARC_SEL (1'b0),
      .SDM0INITSEED0_0 (16'b0000000100010001),
      .SDM0INITSEED0_1 (9'b000010001),
      .SDM1INITSEED0_0 (16'b0000000100010001),
      .SDM1INITSEED0_1 (9'b000010001),
      .SIM_MODE ("FAST"),
      .SIM_RESET_SPEEDUP ("TRUE"),
      .SIM_DEVICE ("ULTRASCALE_PLUS"),
      .UB_CFG0 (16'b0000000000000000),
      .UB_CFG1 (16'b0000000000000000),
      .UB_CFG2 (16'b0000000000000000),
      .UB_CFG3 (16'b0000000000000000),
      .UB_CFG4 (16'b0000000000000000),
      .UB_CFG5 (16'b0000010000000000),
      .UB_CFG6 (16'b0000000000000000))
    i_gtye4_common (
      .BGBYPASSB (1'b1),
      .BGMONITORENB (1'b1),
      .BGPDB (1'b1),
      .BGRCALOVRD (5'b11111),
      .BGRCALOVRDENB (1'b1),
      .DRPADDR ({4'd0, up_addr_int}),
      .DRPCLK (up_clk),
      .DRPDI (up_wdata_int),
      .DRPEN (up_enb_int),
      .DRPWE (up_wr_int),
      .GTGREFCLK0 (1'b0),
      .GTGREFCLK1 (1'b0),
      .GTNORTHREFCLK00 (1'b0),
      .GTNORTHREFCLK01 (1'b0),
      .GTNORTHREFCLK10 (1'b0),
      .GTNORTHREFCLK11 (1'b0),
      .GTREFCLK00 (qpll_ref_clk),
      .GTREFCLK01 (qpll_ref_clk),
      .GTREFCLK10 (1'b0),
      .GTREFCLK11 (1'b0),
      .GTSOUTHREFCLK00 (1'b0),
      .GTSOUTHREFCLK01 (1'b0),
      .GTSOUTHREFCLK10 (1'b0),
      .GTSOUTHREFCLK11 (1'b0),
      .PCIERATEQPLL0 (3'b0),
      .PCIERATEQPLL1 (3'b0),
      .PMARSVD0 (8'b0),
      .PMARSVD1 (8'b0),
      .QPLL0CLKRSVD0 (1'b0),
      .QPLL0CLKRSVD1 (1'b0),
      .QPLL0FBDIV (8'b0),
      .QPLL0LOCKDETCLK (up_clk),
      .QPLL0LOCKEN (1'b1),
      .QPLL0PD (qpll_sel),
      .QPLL0REFCLKSEL (3'b1),
      .QPLL0RESET (up_qpll_rst),
      .QPLL1CLKRSVD0 (1'b0),
      .QPLL1CLKRSVD1 (1'b0),
      .QPLL1FBDIV (8'b0),
      .QPLL1LOCKDETCLK (up_clk),
      .QPLL1LOCKEN (1'b1),
      .QPLL1PD (~qpll_sel),
      .QPLL1REFCLKSEL (3'b1),
      .QPLL1RESET (up_qpll_rst),
      .QPLLRSVD1 (8'b0),
      .QPLLRSVD2 (5'b0),
      .QPLLRSVD3 (5'b0),
      .QPLLRSVD4 (8'b0),
      .RCALENB (1'b1),
      .SDM0DATA (25'b0),
      .SDM0RESET (1'b0),
      .SDM0TOGGLE (1'b0),
      .SDM0WIDTH (2'b0),
      .SDM1DATA (25'b0),
      .SDM1RESET (1'b0),
      .SDM1TOGGLE (1'b0),
      .SDM1WIDTH (2'b0),
      .UBCFGSTREAMEN (1'b0),
      .UBDO (16'b0),
      .UBDRDY (1'b0),
      .UBENABLE (1'b0),
      .UBGPI (2'b0),
      .UBINTR (2'b0),
      .UBIOLMBRST (1'b0),
      .UBMBRST (1'b0),
      .UBMDMCAPTURE (1'b0),
      .UBMDMDBGRST (1'b0),
      .UBMDMDBGUPDATE (1'b0),
      .UBMDMREGEN (4'b0),
      .UBMDMSHIFT (1'b0),
      .UBMDMSYSRST (1'b0),
      .UBMDMTCK (1'b0),
      .UBMDMTDI (1'b0),
      .DRPDO ( up_rdata_s),
      .DRPRDY ( up_ready_s),
      .PMARSVDOUT0 (),
      .PMARSVDOUT1 (),
      .QPLL0FBCLKLOST (),
      .QPLL0LOCK ( qpll2ch_locked),
      .QPLL0OUTCLK ( qpll2ch_clk),
      .QPLL0OUTREFCLK ( qpll2ch_ref_clk),
      .QPLL0REFCLKLOST (),
      .QPLL1FBCLKLOST (),
      .QPLL1LOCK ( qpll1_locked),
      .QPLL1OUTCLK ( qpll1_clk),
      .QPLL1OUTREFCLK ( qpll1_ref_clk),
      .QPLL1REFCLKLOST (),
      .QPLLDMONITOR0 (),
      .QPLLDMONITOR1 (),
      .REFCLKOUTMONITOR0 (),
      .REFCLKOUTMONITOR1 (),
      .RXRECCLK0SEL (),
      .RXRECCLK1SEL (),
      .SDM0FINALOUT (),
      .SDM0TESTDATA (),
      .SDM1FINALOUT (),
      .SDM1TESTDATA (),
      .UBDADDR (),
      .UBDEN (),
      .UBDI (),
      .UBDWE (),
      .UBMDMTDO (),
      .UBRSVDOUT (),
      .UBTXUART ());
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************

