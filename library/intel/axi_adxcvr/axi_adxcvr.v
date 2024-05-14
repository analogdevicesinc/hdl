// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/1ps

module axi_adxcvr #(

  // parameters

  parameter   integer ID = 0,
  parameter   [ 7:0]  FPGA_TECHNOLOGY = 0,
  parameter   [ 7:0]  FPGA_FAMILY = 0,
  parameter   [ 7:0]  SPEED_GRADE = 0,
  parameter   [ 7:0]  DEV_PACKAGE = 0,
  parameter   [15:0]  FPGA_VOLTAGE = 0,
  parameter   integer XCVR_TYPE = 0,
  parameter   integer TX_OR_RX_N = 0,
  parameter   integer NUM_OF_LANES = 4,
  parameter           LOCKED_W = (FPGA_TECHNOLOGY == 105) ?  NUM_OF_LANES : 1,
  parameter           READY_W = (FPGA_TECHNOLOGY != 105) ?  NUM_OF_LANES : 1
) (

  // xcvr, lane-pll and ref-pll are shared

  output                        up_rst,
  input    [LOCKED_W-1 : 0]     up_pll_locked,
  input    [NUM_OF_LANES-1:0]   up_rx_lockedtodata,
  input    [READY_W-1  : 0]     up_ready,
  input    [READY_W-1  : 0]     up_reset_ack,

  output                        xcvr_reset,

  input                         s_axi_aclk,
  input                         s_axi_aresetn,
  input                         s_axi_awvalid,
  input   [11:0]                s_axi_awaddr,
  input   [ 2:0]                s_axi_awprot,
  output                        s_axi_awready,
  input                         s_axi_wvalid,
  input   [31:0]                s_axi_wdata,
  input   [ 3:0]                s_axi_wstrb,
  output                        s_axi_wready,
  output                        s_axi_bvalid,
  output  [ 1:0]                s_axi_bresp,
  input                         s_axi_bready,
  input                         s_axi_arvalid,
  input   [11:0]                s_axi_araddr,
  input   [ 2:0]                s_axi_arprot,
  output                        s_axi_arready,
  output                        s_axi_rvalid,
  output  [ 1:0]                s_axi_rresp,
  output  [31:0]                s_axi_rdata,
  input                         s_axi_rready
);

  // internal signals

  wire                          up_rstn;
  wire                          up_clk;
  wire                          up_wreq;
  wire    [ 9:0]                up_waddr;
  wire    [31:0]                up_wdata;
  wire                          up_wack;
  wire                          up_rreq;
  wire    [ 9:0]                up_raddr;
  wire    [31:0]                up_rdata;
  wire                          up_rack;

  // clk & rst

  assign up_rstn = s_axi_aresetn;
  assign up_clk = s_axi_aclk;

  assign xcvr_reset = up_rst;

  // instantiations

  axi_adxcvr_up #(
    .ID (ID),
    .XCVR_TYPE (XCVR_TYPE),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .FPGA_VOLTAGE (FPGA_VOLTAGE),
    .TX_OR_RX_N (TX_OR_RX_N),
    .NUM_OF_LANES (NUM_OF_LANES),
    .READY_W (READY_W)
  ) i_up (
    .up_rst (up_rst),
    .up_pll_locked (&up_pll_locked),
    .up_rx_lockedtodata (&up_rx_lockedtodata),
    .up_ready (up_ready),
    .up_reset_ack (up_reset_ack),
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

  up_axi #(
    .AXI_ADDRESS_WIDTH (12)
  ) i_axi (
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
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule
