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
// software programmable clock generator (still needs a reference input!)

`timescale 1ns/100ps

module axi_clkgen #(

  parameter         ID = 0,
  parameter         FPGA_TECHNOLOGY = 0,
  parameter         FPGA_FAMILY = 0,
  parameter         SPEED_GRADE = 0,
  parameter         DEV_PACKAGE = 0,
  parameter         FPGA_VOLTAGE = 0,
  parameter         CLKSEL_EN = 0,
  parameter real    CLKIN_PERIOD  = 5.000,
  parameter real    CLKIN2_PERIOD  = 5.000,
  parameter integer VCO_DIV = 11,
  parameter real    VCO_MUL = 49.000,
  parameter real    CLK0_DIV = 6.000,
  parameter real    CLK0_PHASE = 0.000,
  parameter integer CLK1_DIV = 6,
  parameter real    CLK1_PHASE = 0.000) (

  // clocks

  input                   clk,
  input                   clk2,
  output                  clk_0,
  output                  clk_1,

  // axi interface

  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input       [15:0]      s_axi_awaddr,
  output                  s_axi_awready,
  input                   s_axi_wvalid,
  input       [31:0]      s_axi_wdata,
  input       [ 3:0]      s_axi_wstrb,
  output                  s_axi_wready,
  output                  s_axi_bvalid,
  output      [ 1:0]      s_axi_bresp,
  input                   s_axi_bready,
  input                   s_axi_arvalid,
  input       [15:0]      s_axi_araddr,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [31:0]      s_axi_rdata,
  output      [ 1:0]      s_axi_rresp,
  input                   s_axi_rready,
  input       [ 2:0]      s_axi_awprot,
  input       [ 2:0]      s_axi_arprot);


  // reset and clocks

  wire            mmcm_rst;
  wire            clk_sel_s;
  wire            up_clk_sel_s;
  wire            up_rstn;
  wire            up_clk;

  // internal signals

  wire            up_drp_sel_s;
  wire            up_drp_wr_s;
  wire    [11:0]  up_drp_addr_s;
  wire    [15:0]  up_drp_wdata_s;
  wire    [15:0]  up_drp_rdata_s;
  wire            up_drp_ready_s;
  wire            up_drp_locked_s;
  wire            up_wreq_s;
  wire    [13:0]  up_waddr_s;
  wire    [31:0]  up_wdata_s;
  wire            up_wack_s;
  wire            up_rreq_s;
  wire    [13:0]  up_raddr_s;
  wire    [31:0]  up_rdata_s;
  wire            up_rack_s;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // up bus interface

  up_axi i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

  // processor interface

  up_clkgen #(
    .ID(ID),
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .FPGA_FAMILY(FPGA_FAMILY),
    .SPEED_GRADE(SPEED_GRADE),
    .DEV_PACKAGE(DEV_PACKAGE),
    .FPGA_VOLTAGE(FPGA_VOLTAGE)
  ) i_up_clkgen (
    .mmcm_rst (mmcm_rst),
    .clk_sel (up_clk_sel_s),
    .up_drp_sel (up_drp_sel_s),
    .up_drp_wr (up_drp_wr_s),
    .up_drp_addr (up_drp_addr_s),
    .up_drp_wdata (up_drp_wdata_s),
    .up_drp_rdata (up_drp_rdata_s),
    .up_drp_ready (up_drp_ready_s),
    .up_drp_locked (up_drp_locked_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

  // If CLKSEL_EN is not active, the clk0 port of the MMCM is used, this
  // should be used when the MMCM has only one active clock source

  generate if (CLKSEL_EN == 1) begin
    assign clk_sel_s = up_clk_sel_s;
  end else begin
    assign clk_sel_s = 1'b1;
  end
  endgenerate

  // mmcm instantiations

  ad_mmcm_drp #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .MMCM_CLKIN_PERIOD (CLKIN_PERIOD),
    .MMCM_CLKIN2_PERIOD (CLKIN2_PERIOD),
    .MMCM_VCO_DIV (VCO_DIV),
    .MMCM_VCO_MUL (VCO_MUL),
    .MMCM_CLK0_DIV (CLK0_DIV),
    .MMCM_CLK0_PHASE (CLK0_PHASE),
    .MMCM_CLK1_DIV (CLK1_DIV),
    .MMCM_CLK1_PHASE (CLK1_PHASE))
  i_mmcm_drp (
    .clk (clk),
    .clk2 (clk2),
    .clk_sel(clk_sel_s),
    .mmcm_rst (mmcm_rst),
    .mmcm_clk_0 (clk_0),
    .mmcm_clk_1 (clk_1),
    .mmcm_clk_2 (),
    .up_clk (up_clk),
    .up_rstn (up_rstn),
    .up_drp_sel (up_drp_sel_s),
    .up_drp_wr (up_drp_wr_s),
    .up_drp_addr (up_drp_addr_s),
    .up_drp_wdata (up_drp_wdata_s),
    .up_drp_rdata (up_drp_rdata_s),
    .up_drp_ready (up_drp_ready_s),
    .up_drp_locked (up_drp_locked_s));

endmodule

// ***************************************************************************
// ***************************************************************************
