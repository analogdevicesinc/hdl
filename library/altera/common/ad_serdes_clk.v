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

`timescale 1ps/1ps

module __ad_serdes_clk__ #(

  // parameters

  parameter       DEVICE_TYPE = 0,
  parameter       DDR_OR_SDR_N = 1,
  parameter       SERDES_FACTOR = 8,
  parameter       MMCM_OR_BUFR_N = 1,
  parameter       MMCM_CLKIN_PERIOD  = 1.667,
  parameter       MMCM_VCO_DIV  = 6,
  parameter       MMCM_VCO_MUL = 12.000,
  parameter       MMCM_CLK0_DIV = 2.000,
  parameter       MMCM_CLK1_DIV = 6) (

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
  __ad_serdes_clk_1__ i_core (
    .rst_reset (rst),
    .ref_clk_clk (clk_in_p),
    .locked_export (up_drp_locked_int_s),
    .hs_phase_phout (phase),
    .hs_clk_lvds_clk (clk),
    .loaden_loaden (loaden),
    .ls_clk_clk (div_clk),
    .drp_clk_clk (up_clk),
    .drp_rst_reset (up_drp_reset),
    .pll_reconfig_waitrequest (up_drp_busy_int_s),
    .pll_reconfig_read (up_drp_rd_int),
    .pll_reconfig_write (up_drp_wr_int),
    .pll_reconfig_readdata (up_drp_rdata_int_s),
    .pll_reconfig_address (up_drp_addr_int),
    .pll_reconfig_writedata (up_drp_wdata_int));
  end
  endgenerate

  generate
  if (DEVICE_TYPE == CYCLONE5) begin

  assign phase = 8'd0;

  __ad_serdes_clk_1__ i_core (
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
