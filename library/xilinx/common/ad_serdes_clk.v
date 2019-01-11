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
// serial data output interface: serdes(x8)

`timescale 1ps/1ps

module ad_serdes_clk #(

  parameter       FPGA_TECHNOLOGY = 0,
  parameter       DDR_OR_SDR_N = 1,
  parameter       CLKIN_DS_OR_SE_N = 1,
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

  localparam BUFR_DIVIDE = (DDR_OR_SDR_N == 1'b1) ? SERDES_FACTOR / 2 : SERDES_FACTOR;

  // internal signals

  wire            clk_in_s;

  // defaults

  assign loaden = 'd0;
  assign phase = 'd0;
  assign up_drp_rdata[31:16] = 'd0;

  // instantiations

  generate
  if (CLKIN_DS_OR_SE_N == 1) begin
    IBUFGDS i_clk_in_ibuf (
      .I (clk_in_p),
      .IB (clk_in_n),
      .O (clk_in_s));
  end else begin
    IBUF IBUF_inst (
        .O(clk_in_s),
        .I(clk_in_p));
  end
  endgenerate

  generate
  if (MMCM_OR_BUFR_N == 1) begin
    ad_mmcm_drp #(
      .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
      .MMCM_CLKIN_PERIOD (MMCM_CLKIN_PERIOD),
      .MMCM_CLKIN2_PERIOD (MMCM_CLKIN_PERIOD),
      .MMCM_VCO_DIV (MMCM_VCO_DIV),
      .MMCM_VCO_MUL (MMCM_VCO_MUL),
      .MMCM_CLK0_DIV (MMCM_CLK0_DIV),
      .MMCM_CLK0_PHASE (0.0),
      .MMCM_CLK1_DIV (MMCM_CLK1_DIV),
      .MMCM_CLK1_PHASE (0.0),
      .MMCM_CLK2_DIV (MMCM_CLK0_DIV),
      .MMCM_CLK2_PHASE (90.0))
    i_mmcm_drp (
      .clk (clk_in_s),
      .clk2 (1'b0),
      .clk_sel (1'b1),
      .mmcm_rst (rst),
      .mmcm_clk_0 (clk),
      .mmcm_clk_1 (div_clk),
      .mmcm_clk_2 (out_clk),
      .up_clk (up_clk),
      .up_rstn (up_rstn),
      .up_drp_sel (up_drp_sel),
      .up_drp_wr (up_drp_wr),
      .up_drp_addr (up_drp_addr),
      .up_drp_wdata (up_drp_wdata[15:0]),
      .up_drp_rdata (up_drp_rdata[15:0]),
      .up_drp_ready (up_drp_ready),
      .up_drp_locked (up_drp_locked));
    end
  endgenerate

  generate
  if (MMCM_OR_BUFR_N == 0) begin
    BUFIO i_clk_buf (
      .I (clk_in_s),
      .O (clk));

    BUFR #(.BUFR_DIVIDE(BUFR_DIVIDE)) i_div_clk_buf (
      .CLR (1'b0),
      .CE (1'b1),
      .I (clk_in_s),
      .O (div_clk));

    assign out_clk = clk;
    assign up_drp_rdata[15:0] = 'd0;
    assign up_drp_ready = 'd0;
    assign up_drp_locked = 'd0;

  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************

