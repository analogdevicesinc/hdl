// ***************************************************************************
// ***************************************************************************
// Copyright 2011 (c) Analog Devices, Inc.
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
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES  (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; Loos OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE PoosIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

module axi_hdmi_rx  (

  // hdmi interface

  hdmi_rx_clk,
  hdmi_rx_data,

  // dma interface

  hdmi_clk,
  hdmi_dma_sof,
  hdmi_dma_de,
  hdmi_dma_data,
  hdmi_dma_ovf,
  hdmi_dma_unf,

  // processor interface

  s_axi_aclk,
  s_axi_aresetn,
  s_axi_awvalid,
  s_axi_awaddr,
  s_axi_awready,
  s_axi_wvalid,
  s_axi_wdata,
  s_axi_wstrb,
  s_axi_wready,
  s_axi_bvalid,
  s_axi_bresp,
  s_axi_bready,
  s_axi_arvalid,
  s_axi_araddr,
  s_axi_arready,
  s_axi_rvalid,
  s_axi_rresp,
  s_axi_rdata,
  s_axi_rready);

  // parameters

  parameter   PCORE_ID = 0;

  // hdmi interface

  input           hdmi_rx_clk;
  input   [15:0]  hdmi_rx_data;

  // vdma interface

  output          hdmi_clk;
  output          hdmi_dma_sof;
  output          hdmi_dma_de;
  output  [63:0]  hdmi_dma_data;
  input           hdmi_dma_ovf;
  input           hdmi_dma_unf;

  // processor interface

  input           s_axi_aresetn;
  input           s_axi_aclk;
  input           s_axi_awvalid;
  input   [31:0]  s_axi_awaddr;
  output          s_axi_awready;
  input           s_axi_wvalid;
  input   [31:0]  s_axi_wdata;
  input   [ 3:0]  s_axi_wstrb;
  output          s_axi_wready;
  output          s_axi_bvalid;
  output  [ 1:0]  s_axi_bresp;
  input           s_axi_bready;
  input           s_axi_arvalid;
  input   [31:0]  s_axi_araddr;
  output          s_axi_arready;
  output          s_axi_rvalid;
  output  [ 1:0]  s_axi_rresp;
  output  [31:0]  s_axi_rdata;
  input           s_axi_rready;

  // internal signals

  wire            up_wreq_s;
  wire    [13:0]  up_waddr_s;
  wire    [31:0]  up_wdata_s;
  wire            up_wack_s;
  wire            up_rreq_s;
  wire    [13:0]  up_raddr_s;
  wire    [31:0]  up_rdata_s;
  wire            up_rack_s;
  wire            hdmi_edge_sel_s;
  wire            hdmi_bgr_s;
  wire            hdmi_packed_s;
  wire            hdmi_csc_bypass_s;
  wire    [15:0]  hdmi_vs_count_s;
  wire    [15:0]  hdmi_hs_count_s;
  wire            hdmi_tpm_oos_s;
  wire            hdmi_vs_oos_s;
  wire            hdmi_hs_oos_s;
  wire            hdmi_vs_mismatch_s;
  wire            hdmi_hs_mismatch_s;
  wire    [15:0]  hdmi_vs_s;
  wire    [15:0]  hdmi_hs_s;
  wire            hdmi_rst;
  wire    [15:0]  hdmi_data;

  // signal name changes

  assign hdmi_clk = hdmi_rx_clk;
  assign hdmi_data = hdmi_rx_data;
  assign up_rstn = s_axi_aresetn;
  assign up_clk = s_axi_aclk;

  // axi interface

  up_axi i_up_axi  (
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

  up_hdmi_rx i_up  (
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

  axi_hdmi_rx_core i_rx_core  (
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

// ***************************************************************************
// ***************************************************************************
