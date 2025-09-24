// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

`timescale 1ps/1ps
import hsci_master_regs_pkg::*;

module axi_hsci #(
   parameter AXI_ADDR_WIDTH    =    15,
   parameter AXI_DATA_WIDTH    =    32,
   parameter REGMAP_ADDR_WIDTH =    16,
   parameter S_AXI_ADDR_WIDTH  =    18
) (
  input  wire                                s_axi_aclk,
  input  wire                                s_axi_aresetn,

  input   wire [S_AXI_ADDR_WIDTH-1:0]        s_axi_awaddr,
  input   wire [2:0]                         s_axi_awprot,
  input   wire                               s_axi_awvalid,
  input   wire                               s_axi_bready,
  input   wire [AXI_DATA_WIDTH-1:0]          s_axi_wdata,
  input   wire                               s_axi_wvalid,
  input   wire                               s_axi_rready,
  input   wire [(AXI_DATA_WIDTH/8)-1 : 0]    s_axi_wstrb,
  input   wire [S_AXI_ADDR_WIDTH-1:0]        s_axi_araddr,
  input   wire [2:0]                         s_axi_arprot,
  input   wire                               s_axi_arvalid,

  output  wire                               s_axi_wready,
  output  wire                               s_axi_arready,
  output  wire [1:0]                         s_axi_rresp,
  output  wire [AXI_DATA_WIDTH-1:0]          s_axi_rdata,
  output  wire                               s_axi_rvalid,
  output  wire                               s_axi_awready,
  output  wire [1:0]                         s_axi_bresp,
  output  wire                               s_axi_bvalid,

  input   wire                               hsci_pclk,
  output       [7:0]                         hsci_menc_clk,
  output       [7:0]                         hsci_mosi_data,
  input   wire [7:0]                         hsci_miso_data,

  output  wire                               hsci_pll_reset,
  input   wire                               hsci_rst_seq_done,
  input   wire                               hsci_pll_locked,
  input   wire                               hsci_vtc_rdy_bsc_tx,
  input   wire                               hsci_dly_rdy_bsc_tx,
  input   wire                               hsci_vtc_rdy_bsc_rx,
  input   wire                               hsci_dly_rdy_bsc_rx

);

  axi4_lite #(32,18)   axi();

  assign axi.awaddr    =  s_axi_awaddr;
  assign axi.awprot    =  s_axi_awprot;
  assign axi.awvalid   =  s_axi_awvalid;
  assign axi.bready    =  s_axi_bready;
  assign axi.wdata     =  s_axi_wdata;
  assign axi.wvalid    =  s_axi_wvalid;
  assign axi.rready    =  s_axi_rready;
  assign axi.wstrb     =  s_axi_wstrb;
  assign axi.araddr    =  s_axi_araddr;
  assign axi.arprot    =  s_axi_arprot;
  assign axi.arvalid   =  s_axi_arvalid;

  assign s_axi_wready   =  axi.wready;
  assign s_axi_arready  =  axi.arready;
  assign s_axi_rresp    =  axi.rresp;
  assign s_axi_rdata    =  axi.rdata;
  assign s_axi_rvalid   =  axi.rvalid ;
  assign s_axi_awready  =  axi.awready;
  assign s_axi_bresp    =  axi.bresp;
  assign s_axi_bvalid   =  axi.bvalid;

  hsci_master_top #(
    .AXI_ADDR_WIDTH      (AXI_ADDR_WIDTH),
    .AXI_DATA_WIDTH      (AXI_DATA_WIDTH),
    .REGMAP_ADDR_WIDTH   (REGMAP_ADDR_WIDTH),
    .S_AXI_ADDR_WIDTH    (S_AXI_ADDR_WIDTH)
  ) hsci_master_top (
    .axi_clk             (s_axi_aclk),
    .axi_resetn          (s_axi_aresetn),
    .axi                 (axi),
    .hsci_pclk           (hsci_pclk),
    .hsci_menc_clk       (hsci_menc_clk),
    .hsci_mosi_data      (hsci_mosi_data),
    .hsci_miso_data      (hsci_miso_data),
    .hsci_pll_reset      (hsci_pll_reset),
    .hsci_rst_seq_done   (hsci_rst_seq_done),
    .hsci_pll_locked     (hsci_pll_locked),
    .hsci_vtc_rdy_bsc_tx (hsci_vtc_rdy_bsc_tx),
    .hsci_dly_rdy_bsc_tx (hsci_dly_rdy_bsc_tx),
    .hsci_vtc_rdy_bsc_rx (hsci_vtc_rdy_bsc_rx),
    .hsci_dly_rdy_bsc_rx (hsci_dly_rdy_bsc_rx));

endmodule
