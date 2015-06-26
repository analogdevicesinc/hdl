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
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_hdmi_tx_alt (

  // hdmi interface

  hdmi_clk,
  hdmi_out_clk,

  // 16-bit interface

  hdmi_16_hsync,
  hdmi_16_vsync,
  hdmi_16_data_e,
  hdmi_16_data,
  hdmi_16_es_data,

  // 24-bit interface

  hdmi_24_hsync,
  hdmi_24_vsync,
  hdmi_24_data_e,
  hdmi_24_data,

  // 36-bit interface

  hdmi_36_hsync,
  hdmi_36_vsync,
  hdmi_36_data_e,
  hdmi_36_data,

  // vdma interface

  vdma_clk,
  vdma_valid,
  vdma_data,
  vdma_ready,
  vdma_sop,
  vdma_eop,
  vdma_empty,

  // axi interface

  s_axi_aclk,
  s_axi_aresetn,
  s_axi_awvalid,
  s_axi_awaddr,
  s_axi_awid,
  s_axi_awlen,
  s_axi_awsize,
  s_axi_awburst,
  s_axi_awlock,
  s_axi_awcache,
  s_axi_awprot,
  s_axi_awready,
  s_axi_wvalid,
  s_axi_wdata,
  s_axi_wstrb,
  s_axi_wlast,
  s_axi_wready,
  s_axi_bvalid,
  s_axi_bresp,
  s_axi_bid,
  s_axi_bready,
  s_axi_arvalid,
  s_axi_araddr,
  s_axi_arid,
  s_axi_arlen,
  s_axi_arsize,
  s_axi_arburst,
  s_axi_arlock,
  s_axi_arcache,
  s_axi_arprot,
  s_axi_arready,
  s_axi_rvalid,
  s_axi_rresp,
  s_axi_rdata,
  s_axi_rid,
  s_axi_rlast,
  s_axi_rready);

  parameter PCORE_ID = 0;
  parameter PCORE_AXI_ID_WIDTH = 3;
  parameter PCORE_DEVICE_TYPE = 0;
  parameter PCORE_Cr_Cb_N = 0;
  parameter PCORE_EMBEDDED_SYNC = 0;

  // hdmi interface

  input                               hdmi_clk;
  output                              hdmi_out_clk;

  // 16-bit interface

  output                              hdmi_16_hsync;
  output                              hdmi_16_vsync;
  output                              hdmi_16_data_e;
  output  [15:0]                      hdmi_16_data;
  output  [15:0]                      hdmi_16_es_data;

  // 24-bit interface

  output                              hdmi_24_hsync;
  output                              hdmi_24_vsync;
  output                              hdmi_24_data_e;
  output  [23:0]                      hdmi_24_data;

  // 36-bit interface

  output                              hdmi_36_hsync;
  output                              hdmi_36_vsync;
  output                              hdmi_36_data_e;
  output  [35:0]                      hdmi_36_data;

  // vdma interface

  input                               vdma_clk;
  input                               vdma_valid;
  input   [63:0]                      vdma_data;
  output                              vdma_ready;
  input                               vdma_sop;
  input                               vdma_eop;
  input   [ 3:0]                      vdma_empty;

  // axi interface

  input                               s_axi_aclk;
  input                               s_axi_aresetn;
  input                               s_axi_awvalid;
  input   [13:0]                      s_axi_awaddr;
  input   [(PCORE_AXI_ID_WIDTH-1):0]  s_axi_awid;
  input   [ 7:0]                      s_axi_awlen;
  input   [ 2:0]                      s_axi_awsize;
  input   [ 1:0]                      s_axi_awburst;
  input   [ 0:0]                      s_axi_awlock;
  input   [ 3:0]                      s_axi_awcache;
  input   [ 2:0]                      s_axi_awprot;
  output                              s_axi_awready;
  input                               s_axi_wvalid;
  input   [31:0]                      s_axi_wdata;
  input   [ 3:0]                      s_axi_wstrb;
  input                               s_axi_wlast;
  output                              s_axi_wready;
  output                              s_axi_bvalid;
  output  [ 1:0]                      s_axi_bresp;
  output  [(PCORE_AXI_ID_WIDTH-1):0]  s_axi_bid;
  input                               s_axi_bready;
  input                               s_axi_arvalid;
  input   [13:0]                      s_axi_araddr;
  input   [(PCORE_AXI_ID_WIDTH-1):0]  s_axi_arid;
  input   [ 7:0]                      s_axi_arlen;
  input   [ 2:0]                      s_axi_arsize;
  input   [ 1:0]                      s_axi_arburst;
  input   [ 0:0]                      s_axi_arlock;
  input   [ 3:0]                      s_axi_arcache;
  input   [ 2:0]                      s_axi_arprot;
  output                              s_axi_arready;
  output                              s_axi_rvalid;
  output  [ 1:0]                      s_axi_rresp;
  output  [31:0]                      s_axi_rdata;
  output  [(PCORE_AXI_ID_WIDTH-1):0]  s_axi_rid;
  output                              s_axi_rlast;
  input                               s_axi_rready;

  // internal signals

  wire                                vdma_fsync;

  // defaults

  assign s_axi_bid = s_axi_awid;
  assign s_axi_rid = s_axi_arid;
  assign s_axi_rlast = 1'd0;

  // hdmi tx lite version

  axi_hdmi_tx #(
    .PCORE_ID (PCORE_ID),
    .PCORE_Cr_Cb_N (PCORE_Cr_Cb_N),
    .PCORE_DEVICE_TYPE (PCORE_DEVICE_TYPE),
    .PCORE_EMBEDDED_SYNC (PCORE_EMBEDDED_SYNC))
  i_hdmi_tx (
    .hdmi_clk (hdmi_clk),
    .hdmi_out_clk (hdmi_out_clk),
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
    .m_axis_mm2s_clk (vdma_clk),
    .m_axis_mm2s_fsync (vdma_fsync),
    .m_axis_mm2s_fsync_ret (vdma_fsync),
    .m_axis_mm2s_tvalid (vdma_valid),
    .m_axis_mm2s_tdata (vdma_data),
    .m_axis_mm2s_tkeep (8'hff),
    .m_axis_mm2s_tlast (vdma_eop),
    .m_axis_mm2s_tready (vdma_ready),
    .s_axi_aclk (s_axi_aclk),
    .s_axi_aresetn (s_axi_aresetn),
    .s_axi_awvalid (s_axi_awvalid),
    .s_axi_awaddr ({18'd0, s_axi_awaddr}),
    .s_axi_awready (s_axi_awready),
    .s_axi_wvalid (s_axi_wvalid),
    .s_axi_wdata (s_axi_wdata),
    .s_axi_wstrb (s_axi_wstrb),
    .s_axi_wready (s_axi_wready),
    .s_axi_bvalid (s_axi_bvalid),
    .s_axi_bresp (s_axi_bresp),
    .s_axi_bready (s_axi_bready),
    .s_axi_arvalid (s_axi_arvalid),
    .s_axi_araddr ({18'd0, s_axi_araddr}),
    .s_axi_arready (s_axi_arready),
    .s_axi_rvalid (s_axi_rvalid),
    .s_axi_rresp (s_axi_rresp),
    .s_axi_rdata (s_axi_rdata),
    .s_axi_rready (s_axi_rready));

endmodule

// ***************************************************************************
// ***************************************************************************

