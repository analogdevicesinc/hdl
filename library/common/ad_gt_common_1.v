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

`timescale 1ns/1ps

module ad_gt_common_1 (

  // reset and clocks

  rst,
  ref_clk,
  qpll_clk,
  qpll_ref_clk,
  qpll_locked,

  // drp interface

  up_clk,
  up_drp_sel,
  up_drp_addr,
  up_drp_wr,
  up_drp_wdata,
  up_drp_rdata,
  up_drp_ready,
  up_drp_lanesel,
  up_drp_rxrate);

  // parameters

  parameter   DRP_ID = 0;
  parameter   GTH_GTX_N = 0;
  parameter   QPLL_REFCLK_DIV = 2;
  parameter   QPLL_CFG = 27'h06801C1;
  parameter   QPLL_FBDIV_RATIO = 1'b1;
  parameter   QPLL_FBDIV =  10'b0000110000;

  // reset and clocks

  input           rst;
  input           ref_clk;
  output          qpll_clk;
  output          qpll_ref_clk;
  output          qpll_locked;

  // drp interface

  input           up_clk;
  input           up_drp_sel;
  input   [11:0]  up_drp_addr;
  input           up_drp_wr;
  input   [15:0]  up_drp_wdata;
  output  [15:0]  up_drp_rdata;
  output          up_drp_ready;
  input   [ 7:0]  up_drp_lanesel;
  output  [ 7:0]  up_drp_rxrate;

  // internal registers

  reg             up_drp_sel_int;
  reg     [11:0]  up_drp_addr_int;
  reg             up_drp_wr_int;
  reg     [15:0]  up_drp_wdata_int;
  reg     [15:0]  up_drp_rdata;
  reg             up_drp_ready;
  reg     [ 7:0]  up_drp_rxrate;

  // internal wires

  wire    [15:0]  up_drp_rdata_s;
  wire            up_drp_ready_s;

  // drp control

  always @(posedge up_clk) begin
    if (up_drp_lanesel == DRP_ID) begin
      up_drp_sel_int <= up_drp_sel;
      up_drp_addr_int <= up_drp_addr;
      up_drp_wr_int <= up_drp_wr;
      up_drp_wdata_int <= up_drp_wdata;
      up_drp_rdata <= up_drp_rdata_s;
      up_drp_ready <= up_drp_ready_s;
      up_drp_rxrate <= 8'hff;
    end else begin
      up_drp_sel_int <= 1'd0;
      up_drp_addr_int <= 12'd0;
      up_drp_wr_int <= 1'd0;
      up_drp_wdata_int <= 16'd0;
      up_drp_rdata <= 16'd0;
      up_drp_ready <= 1'd0;
      up_drp_rxrate <= 8'd0;
    end
  end

  // instantiations

  generate
  if (GTH_GTX_N == 0) begin
  GTXE2_COMMON #(
    .SIM_RESET_SPEEDUP ("TRUE"),
    .SIM_QPLLREFCLK_SEL (3'b001),
    .SIM_VERSION ("3.0"),
    .BIAS_CFG (64'h0000040000001000),
    .COMMON_CFG (32'h00000000),
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
    .QPLL_REFCLK_DIV (QPLL_REFCLK_DIV))
  i_gtxe2_common (
    .DRPCLK (up_clk),
    .DRPEN (up_drp_sel_int),
    .DRPADDR (up_drp_addr_int[7:0]),
    .DRPWE (up_drp_wr_int),
    .DRPDI (up_drp_wdata_int),
    .DRPDO (up_drp_rdata_s),
    .DRPRDY (up_drp_ready_s),
    .GTGREFCLK (1'd0),
    .GTNORTHREFCLK0 (1'd0),
    .GTNORTHREFCLK1 (1'd0),
    .GTREFCLK0 (ref_clk),
    .GTREFCLK1 (1'd0),
    .GTSOUTHREFCLK0 (1'd0),
    .GTSOUTHREFCLK1 (1'd0),
    .QPLLDMONITOR (),
    .QPLLOUTCLK (qpll_clk),
    .QPLLOUTREFCLK (qpll_ref_clk),
    .REFCLKOUTMONITOR (),
    .QPLLFBCLKLOST (),
    .QPLLLOCK (qpll_locked),
    .QPLLLOCKDETCLK (up_clk),
    .QPLLLOCKEN (1'd1),
    .QPLLOUTRESET (1'd0),
    .QPLLPD (1'd0),
    .QPLLREFCLKLOST (),
    .QPLLREFCLKSEL (3'b001),
    .QPLLRESET (rst),
    .QPLLRSVD1 (16'b0000000000000000),
    .QPLLRSVD2 (5'b11111),
    .BGBYPASSB (1'd1),
    .BGMONITORENB (1'd1),
    .BGPDB (1'd1),
    .BGRCALOVRD (5'b00000),
    .PMARSVD (8'b00000000),
    .RCALENB (1'd1));
  end

  if (GTH_GTX_N == 1) begin
  GTHE3_COMMON #(
    .SIM_RESET_SPEEDUP ("TRUE"),
    .SIM_VERSION (2),
    .SARC_EN (1'b1),
    .SARC_SEL (1'b0),
    .SDM0_DATA_PIN_SEL (1'b0),
    .SDM0_WIDTH_PIN_SEL (1'b0),
    .SDM1_DATA_PIN_SEL (1'b0),
    .SDM1_WIDTH_PIN_SEL (1'b0),
    .BIAS_CFG0 (16'b0000000000000000),
    .BIAS_CFG1 (16'b0000000000000000),
    .BIAS_CFG2 (16'b0000000000000000),
    .BIAS_CFG3 (16'b0000000001000000),
    .BIAS_CFG4 (16'b0000000000000000),
    .COMMON_CFG0 (16'b0000000000000000),
    .COMMON_CFG1 (16'b0000000000000000),
    .POR_CFG (16'b0000000000000100),
    .QPLL0_CFG0 (16'b0011000000011100),
    .QPLL0_CFG1 (16'b0000000000011000),
    .QPLL0_CFG1_G3 (16'b0000000000011000),
    .QPLL0_CFG2 (16'b0000000001001000),
    .QPLL0_CFG2_G3 (16'b0000000001001000),
    .QPLL0_CFG3 (16'b0000000100100000),
    .QPLL0_CFG4 (16'b0000000000001001),
    .QPLL0_INIT_CFG0 (16'b0000000000000000),
    .QPLL0_LOCK_CFG (16'b0010010111101000),
    .QPLL0_LOCK_CFG_G3 (16'b0010010111101000),
    .QPLL0_SDM_CFG0 (16'b0000000000000000),
    .QPLL0_SDM_CFG1 (16'b0000000000000000),
    .QPLL0_SDM_CFG2 (16'b0000000000000000),
    .QPLL1_CFG0 (16'b0011000000011100),
    .QPLL1_CFG1 (16'b0000000000011000),
    .QPLL1_CFG1_G3 (16'b0000000000011000),
    .QPLL1_CFG2 (16'b0000000001000000),
    .QPLL1_CFG2_G3 (16'b0000000001000000),
    .QPLL1_CFG3 (16'b0000000100100000),
    .QPLL1_CFG4 (16'b0000000000001001),
    .QPLL1_INIT_CFG0 (16'b0000000000000000),
    .QPLL1_LOCK_CFG (16'b0010010111101000),
    .QPLL1_LOCK_CFG_G3 (16'b0010010111101000),
    .QPLL1_SDM_CFG0 (16'b0000000000000000),
    .QPLL1_SDM_CFG1 (16'b0000000000000000),
    .QPLL1_SDM_CFG2 (16'b0000000000000000),
    .RSVD_ATTR0 (16'b0000000000000000),
    .RSVD_ATTR1 (16'b0000000000000000),
    .RSVD_ATTR2 (16'b0000000000000000),
    .RSVD_ATTR3 (16'b0000000000000000),
    .SDM0DATA1_0 (16'b0000000000000000),
    .SDM0INITSEED0_0 (16'b0000000000000000),
    .SDM1DATA1_0 (16'b0000000000000000),
    .SDM1INITSEED0_0 (16'b0000000000000000),
    .RXRECCLKOUT0_SEL (2'b00),
    .RXRECCLKOUT1_SEL (2'b00),
    .QPLL0_INIT_CFG1 (8'b00000000),
    .QPLL1_INIT_CFG1 (8'b00000000),
    .SDM0DATA1_1 (9'b000000000),
    .SDM0INITSEED0_1 (9'b000000000),
    .SDM1DATA1_1 (9'b000000000),
    .SDM1INITSEED0_1 (9'b000000000),
    .BIAS_CFG_RSVD (10'b0000000000),
    .QPLL0_CP (10'b0000011111),
    .QPLL0_CP_G3 (10'b1111111111),
    .QPLL0_LPF (10'b1111111111),
    .QPLL0_LPF_G3 (10'b0000010101),
    .QPLL1_CP (10'b0000011111),
    .QPLL1_CP_G3 (10'b1111111111),
    .QPLL1_LPF (10'b1111111111),
    .QPLL1_LPF_G3 (10'b0000010101),
    .QPLL0_FBDIV (QPLL_FBDIV),
    .QPLL0_FBDIV_G3 (80),
    .QPLL0_REFCLK_DIV (QPLL_REFCLK_DIV),
    .QPLL1_FBDIV (QPLL_FBDIV),
    .QPLL1_FBDIV_G3 (80),
    .QPLL1_REFCLK_DIV (QPLL_REFCLK_DIV))
  i_gthe3_common (
    .BGBYPASSB (1'd1),
    .BGMONITORENB (1'd1),
    .BGPDB (1'd1),
    .BGRCALOVRD (5'b11111),
    .BGRCALOVRDENB (1'd1),
    .DRPADDR (up_drp_addr_int[8:0]),
    .DRPCLK (up_clk),
    .DRPDI (up_drp_wdata_int),
    .DRPEN (up_drp_sel_int),
    .DRPWE (up_drp_wr_int),
    .GTGREFCLK0 (1'd0),
    .GTGREFCLK1 (1'd0),
    .GTNORTHREFCLK00 (1'd0),
    .GTNORTHREFCLK01 (1'd0),
    .GTNORTHREFCLK10 (1'd0),
    .GTNORTHREFCLK11 (1'd0),
    .GTREFCLK00 (ref_clk),
    .GTREFCLK01 (1'd0),
    .GTREFCLK10 (1'd0),
    .GTREFCLK11 (1'd0),
    .GTSOUTHREFCLK00 (1'd0),
    .GTSOUTHREFCLK01 (1'd0),
    .GTSOUTHREFCLK10 (1'd0),
    .GTSOUTHREFCLK11 (1'd0),
    .PMARSVD0 (8'd0),
    .PMARSVD1 (8'd0),
    .QPLLRSVD1 (8'd0),
    .QPLLRSVD2 (5'd0),
    .QPLLRSVD3 (5'd0),
    .QPLLRSVD4 (8'd0),
    .QPLL0CLKRSVD0 (1'd0),
    .QPLL0CLKRSVD1 (1'd0),
    .QPLL0LOCKDETCLK (up_clk),
    .QPLL0LOCKEN (1'd1),
    .QPLL0PD (1'd0),
    .QPLL0REFCLKSEL (3'b001),
    .QPLL0RESET (rst),
    .QPLL1CLKRSVD0 (1'd0),
    .QPLL1CLKRSVD1 (1'd0),
    .QPLL1LOCKDETCLK (1'd0),
    .QPLL1LOCKEN (1'd0),
    .QPLL1PD (1'd1),
    .QPLL1REFCLKSEL (3'b001),
    .QPLL1RESET (1'd1),
    .RCALENB (1'd1),
    .DRPDO (up_drp_rdata_s),
    .DRPRDY (up_drp_ready_s),
    .PMARSVDOUT0 (),
    .PMARSVDOUT1 (),
    .QPLLDMONITOR0 (),
    .QPLLDMONITOR1 (),
    .QPLL0FBCLKLOST (),
    .QPLL0LOCK (qpll_locked),
    .QPLL0OUTCLK (qpll_clk),
    .QPLL0OUTREFCLK (qpll_ref_clk),
    .QPLL0REFCLKLOST (),
    .QPLL1FBCLKLOST (),
    .QPLL1LOCK (),
    .QPLL1OUTCLK (),
    .QPLL1OUTREFCLK (),
    .QPLL1REFCLKLOST (),
    .REFCLKOUTMONITOR0 (),
    .REFCLKOUTMONITOR1 (),
    .RXRECCLK0_SEL (),
    .RXRECCLK1_SEL ());
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************

