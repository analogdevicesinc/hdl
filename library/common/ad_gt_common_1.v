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

  drp_clk,
  drp_sel,
  drp_addr,
  drp_wr,
  drp_wdata,
  drp_rdata,
  drp_ready,
  drp_lanesel,
  drp_rx_rate);

  // parameters

  parameter   DRP_ID = 0;
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

  input           drp_clk;
  input           drp_sel;
  input   [11:0]  drp_addr;
  input           drp_wr;
  input   [15:0]  drp_wdata;
  output  [15:0]  drp_rdata;
  output          drp_ready;
  input   [ 7:0]  drp_lanesel;
  output  [ 7:0]  drp_rx_rate;

  // internal registers

  reg             drp_sel_int;
  reg     [11:0]  drp_addr_int;
  reg             drp_wr_int;
  reg     [15:0]  drp_wdata_int;
  reg     [15:0]  drp_rdata;
  reg             drp_ready;
  reg     [ 7:0]  drp_rx_rate;

  // internal wires

  wire    [15:0]  drp_rdata_s;
  wire            drp_ready_s;

  // drp control

  always @(posedge drp_clk) begin
    if (drp_lanesel == DRP_ID) begin
      drp_sel_int <= drp_sel;
      drp_addr_int <= drp_addr;
      drp_wr_int <= drp_wr;
      drp_wdata_int <= drp_wdata;
      drp_rdata <= drp_rdata_s;
      drp_ready <= drp_ready_s;
      drp_rx_rate <= 8'hff;
    end else begin
      drp_sel_int <= 1'd0;
      drp_addr_int <= 12'd0;
      drp_wr_int <= 1'd0;
      drp_wdata_int <= 16'd0;
      drp_rdata <= 16'd0;
      drp_ready <= 1'd0;
      drp_rx_rate <= 8'd0;
    end
  end

  // instantiations

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
    .DRPCLK (drp_clk),
    .DRPEN (drp_sel_int),
    .DRPADDR (drp_addr_int[7:0]),
    .DRPWE (drp_wr_int),
    .DRPDI (drp_wdata_int),
    .DRPDO (drp_rdata_s),
    .DRPRDY (drp_ready_s),
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
    .QPLLLOCKDETCLK (drp_clk),
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

endmodule

// ***************************************************************************
// ***************************************************************************

