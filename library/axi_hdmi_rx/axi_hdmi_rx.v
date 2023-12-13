// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

module axi_hdmi_rx  #(

  parameter   ID = 0,
  parameter   IO_INTERFACE = 1
) (

  // hdmi interface

  input                   hdmi_rx_clk,
  input       [15:0]      hdmi_rx_data,

  // dma interface

  output                  hdmi_clk,
  output                  hdmi_dma_sof,
  output                  hdmi_dma_de,
  output      [63:0]      hdmi_dma_data,
  input                   hdmi_dma_ovf,
  input                   hdmi_dma_unf,

  // processor interface

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
  output      [ 1:0]      s_axi_rresp,
  output      [31:0]      s_axi_rdata,
  input                   s_axi_rready,
  input       [ 2:0]      s_axi_awprot,
  input       [ 2:0]      s_axi_arprot
);

  // internal signals

  wire                    up_wreq_s;
  wire        [13:0]      up_waddr_s;
  wire        [31:0]      up_wdata_s;
  wire                    up_wack_s;
  wire                    up_rreq_s;
  wire        [13:0]      up_raddr_s;
  wire        [31:0]      up_rdata_s;
  wire                    up_rack_s;
  wire                    hdmi_edge_sel_s;
  wire                    hdmi_bgr_s;
  wire                    hdmi_packed_s;
  wire                    hdmi_csc_bypass_s;
  wire        [15:0]      hdmi_vs_count_s;
  wire        [15:0]      hdmi_hs_count_s;
  wire                    hdmi_tpm_oos_s;
  wire                    hdmi_vs_oos_s;
  wire                    hdmi_hs_oos_s;
  wire                    hdmi_vs_mismatch_s;
  wire                    hdmi_hs_mismatch_s;
  wire        [15:0]      hdmi_vs_s;
  wire        [15:0]      hdmi_hs_s;
  wire                    hdmi_rst;
  wire        [15:0]      hdmi_data;

  // signal name changes

  assign hdmi_clk = hdmi_rx_clk;
  assign hdmi_data = hdmi_rx_data;
  assign up_rstn = s_axi_aresetn;
  assign up_clk = s_axi_aclk;

  // axi interface

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

  up_hdmi_rx i_up (
    .hdmi_clk (hdmi_clk),
    .hdmi_rst (hdmi_rst),
    .hdmi_edge_sel (hdmi_edge_sel_s),
    .hdmi_bgr (hdmi_bgr_s),
    .hdmi_packed (hdmi_packed_s),
    .hdmi_csc_bypass (hdmi_csc_bypass_s),
    .hdmi_vs_count (hdmi_vs_count_s),
    .hdmi_hs_count (hdmi_hs_count_s),
    .hdmi_dma_ovf (hdmi_dma_ovf),
    .hdmi_dma_unf (hdmi_dma_unf),
    .hdmi_tpm_oos (hdmi_tpm_oos_s),
    .hdmi_vs_oos (hdmi_vs_oos_s),
    .hdmi_hs_oos (hdmi_hs_oos_s),
    .hdmi_vs_mismatch (hdmi_vs_mismatch_s),
    .hdmi_hs_mismatch (hdmi_hs_mismatch_s),
    .hdmi_vs (hdmi_vs_s),
    .hdmi_hs (hdmi_hs_s),
    .hdmi_clk_ratio (32'd1),
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

  // hdmi interface

  axi_hdmi_rx_core i_rx_core (
    .hdmi_clk (hdmi_clk),
    .hdmi_rst (hdmi_rst),
    .hdmi_data (hdmi_data),
    .hdmi_edge_sel (hdmi_edge_sel_s),
    .hdmi_bgr (hdmi_bgr_s),
    .hdmi_packed (hdmi_packed_s),
    .hdmi_csc_bypass (hdmi_csc_bypass_s),
    .hdmi_vs_count (hdmi_vs_count_s),
    .hdmi_hs_count (hdmi_hs_count_s),
    .hdmi_tpm_oos (hdmi_tpm_oos_s),
    .hdmi_vs_oos (hdmi_vs_oos_s),
    .hdmi_hs_oos (hdmi_hs_oos_s),
    .hdmi_vs_mismatch (hdmi_vs_mismatch_s),
    .hdmi_hs_mismatch (hdmi_hs_mismatch_s),
    .hdmi_vs (hdmi_vs_s),
    .hdmi_hs (hdmi_hs_s),
    .hdmi_dma_sof (hdmi_dma_sof),
    .hdmi_dma_de (hdmi_dma_de),
    .hdmi_dma_data (hdmi_dma_data));

endmodule
