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

`timescale 1ns/100ps

module axi_hdmi_tx #(

  parameter   ID = 0,
  parameter   CR_CB_N = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   INTERFACE = "16_BIT",
  parameter   OUT_CLK_POLARITY = 0) (

  // hdmi interface

  input                   hdmi_clk,
  output                  hdmi_out_clk,

  // 16-bit interface

  output                  hdmi_16_hsync,
  output                  hdmi_16_vsync,
  output                  hdmi_16_data_e,
  output      [15:0]      hdmi_16_data,
  output      [15:0]      hdmi_16_es_data,

  // 24-bit interface

  output                  hdmi_24_hsync,
  output                  hdmi_24_vsync,
  output                  hdmi_24_data_e,
  output      [23:0]      hdmi_24_data,

  // 36-bit interface

  output                  hdmi_36_hsync,
  output                  hdmi_36_vsync,
  output                  hdmi_36_data_e,
  output      [35:0]      hdmi_36_data,

  // vdma interface

  input                   vdma_clk,
  input                   vdma_end_of_frame,
  input                   vdma_valid,
  input       [63:0]      vdma_data,
  output                  vdma_ready,

  // axi interface

  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input       [15:0]      s_axi_awaddr,
  input       [ 2:0]      s_axi_awprot,
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
  input       [ 2:0]      s_axi_arprot,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [ 1:0]      s_axi_rresp,
  output      [31:0]      s_axi_rdata,
  input                   s_axi_rready);

  /* 0 = Launch on rising edge, 1 = Launch on falling edge */

  localparam  EMBEDDED_SYNC = (INTERFACE == "16_BIT_EMBEDDED_SYNC") ? 1 : 0;
  localparam  XILINX_7SERIES = 1;
  localparam  XILINX_ULTRASCALE = 2;
  localparam  INTEL_5SERIES = 101;

  // reset and clocks

  wire            up_rstn;
  wire            up_clk;
  wire            hdmi_rst;
  wire            vdma_rst;

  // internal signals

  wire            up_wreq_s;
  wire    [13:0]  up_waddr_s;
  wire    [31:0]  up_wdata_s;
  wire            up_wack_s;
  wire            up_rreq_s;
  wire    [13:0]  up_raddr_s;
  wire    [31:0]  up_rdata_s;
  wire            up_rack_s;
  wire            hdmi_csc_bypass_s;
  wire            hdmi_ss_bypass_s;
  wire    [ 1:0]  hdmi_srcsel_s;
  wire    [23:0]  hdmi_const_rgb_s;
  wire    [15:0]  hdmi_hl_active_s;
  wire    [15:0]  hdmi_hl_width_s;
  wire    [15:0]  hdmi_hs_width_s;
  wire    [15:0]  hdmi_he_max_s;
  wire    [15:0]  hdmi_he_min_s;
  wire    [15:0]  hdmi_vf_active_s;
  wire    [15:0]  hdmi_vf_width_s;
  wire    [15:0]  hdmi_vs_width_s;
  wire    [15:0]  hdmi_ve_max_s;
  wire    [15:0]  hdmi_ve_min_s;
  wire    [23:0]  hdmi_clip_max_s;
  wire    [23:0]  hdmi_clip_min_s;
  wire            hdmi_fs_toggle_s;
  wire    [ 8:0]  hdmi_raddr_g_s;
  wire            hdmi_tpm_oos_s;
  wire            hdmi_status_s;
  wire            vdma_wr_s;
  wire    [ 8:0]  vdma_waddr_s;
  wire    [47:0]  vdma_wdata_s;
  wire            vdma_fs_ret_toggle_s;
  wire    [ 8:0]  vdma_fs_waddr_s;
  wire            vdma_ovf_s;
  wire            vdma_unf_s;
  wire            vdma_tpm_oos_s;

  // signal name changes

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

  up_hdmi_tx i_up (
    .hdmi_clk (hdmi_clk),
    .hdmi_rst (hdmi_rst),
    .hdmi_csc_bypass (hdmi_csc_bypass_s),
    .hdmi_ss_bypass (hdmi_ss_bypass_s),
    .hdmi_srcsel (hdmi_srcsel_s),
    .hdmi_const_rgb (hdmi_const_rgb_s),
    .hdmi_hl_active (hdmi_hl_active_s),
    .hdmi_hl_width (hdmi_hl_width_s),
    .hdmi_hs_width (hdmi_hs_width_s),
    .hdmi_he_max (hdmi_he_max_s),
    .hdmi_he_min (hdmi_he_min_s),
    .hdmi_vf_active (hdmi_vf_active_s),
    .hdmi_vf_width (hdmi_vf_width_s),
    .hdmi_vs_width (hdmi_vs_width_s),
    .hdmi_ve_max (hdmi_ve_max_s),
    .hdmi_ve_min (hdmi_ve_min_s),
    .hdmi_clip_max (hdmi_clip_max_s),
    .hdmi_clip_min (hdmi_clip_min_s),
    .hdmi_status (hdmi_status_s),
    .hdmi_tpm_oos (hdmi_tpm_oos_s),
    .hdmi_clk_ratio (32'd1),
    .vdma_clk (vdma_clk),
    .vdma_rst (vdma_rst),
    .vdma_ovf (vdma_ovf_s),
    .vdma_unf (vdma_unf_s),
    .vdma_tpm_oos (vdma_tpm_oos_s),
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

  // vdma interface

  axi_hdmi_tx_vdma i_vdma (
    .hdmi_fs_toggle (hdmi_fs_toggle_s),
    .hdmi_raddr_g (hdmi_raddr_g_s),
    .vdma_clk (vdma_clk),
    .vdma_rst (vdma_rst),
    .vdma_valid (vdma_valid),
    .vdma_data (vdma_data),
    .vdma_ready (vdma_ready),
    .vdma_end_of_frame (vdma_end_of_frame),
    .vdma_wr (vdma_wr_s),
    .vdma_waddr (vdma_waddr_s),
    .vdma_wdata (vdma_wdata_s),
    .vdma_fs_ret_toggle (vdma_fs_ret_toggle_s),
    .vdma_fs_waddr (vdma_fs_waddr_s),
    .vdma_tpm_oos (vdma_tpm_oos_s),
    .vdma_ovf (vdma_ovf_s),
    .vdma_unf (vdma_unf_s));

  // hdmi interface

  axi_hdmi_tx_core #(
    .CR_CB_N(CR_CB_N),
    .EMBEDDED_SYNC(EMBEDDED_SYNC))
  i_tx_core (
    .hdmi_clk (hdmi_clk),
    .hdmi_rst (hdmi_rst),
    .hdmi_16_hsync (hdmi_16_hsync),
    .hdmi_16_vsync (hdmi_16_vsync),
    .hdmi_16_data_e (hdmi_16_data_e),
    .hdmi_16_data (hdmi_16_data),
    .hdmi_16_es_data (hdmi_16_es_data),
    .hdmi_24_hsync (hdmi_24_hsync),
    .hdmi_24_vsync (hdmi_24_vsync),
    .hdmi_24_data_e (hdmi_24_data_e),
    .hdmi_24_data (hdmi_24_data),
    .hdmi_36_hsync (hdmi_36_hsync),
    .hdmi_36_vsync (hdmi_36_vsync),
    .hdmi_36_data_e (hdmi_36_data_e),
    .hdmi_36_data (hdmi_36_data),
    .hdmi_fs_toggle (hdmi_fs_toggle_s),
    .hdmi_raddr_g (hdmi_raddr_g_s),
    .hdmi_tpm_oos (hdmi_tpm_oos_s),
    .hdmi_status (hdmi_status_s),
    .vdma_clk (vdma_clk),
    .vdma_wr (vdma_wr_s),
    .vdma_waddr (vdma_waddr_s),
    .vdma_wdata (vdma_wdata_s),
    .vdma_fs_ret_toggle (vdma_fs_ret_toggle_s),
    .vdma_fs_waddr (vdma_fs_waddr_s),
    .hdmi_csc_bypass (hdmi_csc_bypass_s),
    .hdmi_ss_bypass (hdmi_ss_bypass_s),
    .hdmi_srcsel (hdmi_srcsel_s),
    .hdmi_const_rgb (hdmi_const_rgb_s),
    .hdmi_hl_active (hdmi_hl_active_s),
    .hdmi_hl_width (hdmi_hl_width_s),
    .hdmi_hs_width (hdmi_hs_width_s),
    .hdmi_he_max (hdmi_he_max_s),
    .hdmi_he_min (hdmi_he_min_s),
    .hdmi_vf_active (hdmi_vf_active_s),
    .hdmi_vf_width (hdmi_vf_width_s),
    .hdmi_vs_width (hdmi_vs_width_s),
    .hdmi_ve_max (hdmi_ve_max_s),
    .hdmi_ve_min (hdmi_ve_min_s),
    .hdmi_clip_max (hdmi_clip_max_s),
    .hdmi_clip_min (hdmi_clip_min_s));

  // hdmi output clock

  generate
  if (FPGA_TECHNOLOGY == XILINX_ULTRASCALE) begin
  ODDRE1 #(.SRVAL(1'b0)) i_clk_oddr (
    .SR (1'b0),
    .D1 (~OUT_CLK_POLARITY),
    .D2 (OUT_CLK_POLARITY),
    .C (hdmi_clk),
    .Q (hdmi_out_clk));
  end
  if (FPGA_TECHNOLOGY == INTEL_5SERIES) begin
  altddio_out #(.WIDTH(1)) i_clk_oddr (
    .aclr (1'b0),
    .aset (1'b0),
    .sclr (1'b0),
    .sset (1'b0),
    .oe (1'b1),
    .outclocken (1'b1),
    .datain_h (~OUT_CLK_POLARITY),
    .datain_l (OUT_CLK_POLARITY),
    .outclock (hdmi_clk),
    .oe_out (),
    .dataout (hdmi_out_clk));
  end
  if (FPGA_TECHNOLOGY == XILINX_7SERIES) begin
  ODDR #(.INIT(1'b0)) i_clk_oddr (
    .R (1'b0),
    .S (1'b0),
    .CE (1'b1),
    .D1 (~OUT_CLK_POLARITY),
    .D2 (OUT_CLK_POLARITY),
    .C (hdmi_clk),
    .Q (hdmi_out_clk));
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
