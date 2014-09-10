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

module axi_dma (

  // external interface

  axil_aclk,
  axil_aresetn,
  axil_awvalid,
  axil_awaddr,
  axil_awready,
  axil_wvalid,
  axil_wdata,
  axil_wstrb,
  axil_wready,
  axil_bvalid,
  axil_bresp,
  axil_bready,
  axil_arvalid,
  axil_araddr,
  axil_arready,
  axil_rvalid,
  axil_rdata,
  axil_rresp,
  axil_rready,

  // axi interface

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
  s_axi_rdata,
  s_axi_rresp,
  s_axi_rready,

  // AXIM (dest) interface

  axim_d_aclk,
  axim_d_aresetn,
  axim_d_awaddr,
  axim_d_awlen,
  axim_d_awsize,
  axim_d_awburst,
  axim_d_awprot,
  axim_d_awcache,
  axim_d_awvalid,
  axim_d_awready,
  axim_d_wdata,
  axim_d_wstrb,
  axim_d_wready,
  axim_d_wvalid,
  axim_d_wlast,
  axim_d_bvalid,
  axim_d_bresp,
  axim_d_bready,

  m_dest_axi_aclk,
  m_dest_axi_aresetn,
  m_dest_axi_awaddr,
  m_dest_axi_awlen,
  m_dest_axi_awsize,
  m_dest_axi_awburst,
  m_dest_axi_awprot,
  m_dest_axi_awcache,
  m_dest_axi_awvalid,
  m_dest_axi_awready,
  m_dest_axi_wdata,
  m_dest_axi_wstrb,
  m_dest_axi_wready,
  m_dest_axi_wvalid,
  m_dest_axi_wlast,
  m_dest_axi_bvalid,
  m_dest_axi_bresp,
  m_dest_axi_bready,

  // AXIM (src) interface

  axim_s_aclk,
  axim_s_aresetn,
  axim_s_arready,
  axim_s_arvalid,
  axim_s_araddr,
  axim_s_arlen,
  axim_s_arsize,
  axim_s_arburst,
  axim_s_arprot,
  axim_s_arcache,
  axim_s_rdata,
  axim_s_rready,
  axim_s_rvalid,
  axim_s_rresp,

  m_src_axi_aclk,
  m_src_axi_aresetn,
  m_src_axi_arready,
  m_src_axi_arvalid,
  m_src_axi_araddr,
  m_src_axi_arlen,
  m_src_axi_arsize,
  m_src_axi_arburst,
  m_src_axi_arprot,
  m_src_axi_arcache,
  m_src_axi_rdata,
  m_src_axi_rready,
  m_src_axi_rvalid,
  m_src_axi_rresp,

  // Interrupt

  irq,
  axim_irq);

  // parameters

  parameter   C_S_AXI_MIN_SIZE = 32'hffff;
  parameter   C_BASEADDR = 32'hffffffff;
  parameter   C_HIGHADDR = 32'h00000000;
  parameter   C_DMA_TYPE_DEST = 0;
  parameter   C_DMA_TYPE_SRC = 0;
  parameter   C_DMA_DATA_WIDTH_DEST = 64;
  parameter   C_DMA_DATA_WIDTH_SRC = 64;

  // external interface

  output                                  axil_aclk;
  output                                  axil_aresetn;
  output                                  axil_awvalid;
  output  [31:0]                          axil_awaddr;
  input                                   axil_awready;
  output                                  axil_wvalid;
  output  [31:0]                          axil_wdata;
  output  [ 3:0]                          axil_wstrb;
  input                                   axil_wready;
  input                                   axil_bvalid;
  input   [ 1:0]                          axil_bresp;
  output                                  axil_bready;
  output                                  axil_arvalid;
  output  [31:0]                          axil_araddr;
  input                                   axil_arready;
  input                                   axil_rvalid;
  input   [31:0]                          axil_rdata;
  input   [ 1:0]                          axil_rresp;
  output                                  axil_rready;

  // axi interface

  input                                   s_axi_aclk;
  input                                   s_axi_aresetn;
  input                                   s_axi_awvalid;
  input   [31:0]                          s_axi_awaddr;
  output                                  s_axi_awready;
  input                                   s_axi_wvalid;
  input   [31:0]                          s_axi_wdata;
  input   [ 3:0]                          s_axi_wstrb;
  output                                  s_axi_wready;
  output                                  s_axi_bvalid;
  output  [ 1:0]                          s_axi_bresp;
  input                                   s_axi_bready;
  input                                   s_axi_arvalid;
  input   [31:0]                          s_axi_araddr;
  output                                  s_axi_arready;
  output                                  s_axi_rvalid;
  output  [31:0]                          s_axi_rdata;
  output  [ 1:0]                          s_axi_rresp;
  input                                   s_axi_rready;

  // AXIM (dest) interface

  output                                  axim_d_aclk;
  output                                  axim_d_aresetn;
  input  [31:0]                           axim_d_awaddr;
  input  [ 7:0]                           axim_d_awlen;
  input  [ 2:0]                           axim_d_awsize;
  input  [ 1:0]                           axim_d_awburst;
  input  [ 2:0]                           axim_d_awprot;
  input  [ 3:0]                           axim_d_awcache;
  input                                   axim_d_awvalid;
  output                                  axim_d_awready;
  input  [C_DMA_DATA_WIDTH_DEST-1:0]      axim_d_wdata;
  input  [(C_DMA_DATA_WIDTH_DEST/8)-1:0]  axim_d_wstrb;
  output                                  axim_d_wready;
  input                                   axim_d_wvalid;
  input                                   axim_d_wlast;
  output                                  axim_d_bvalid;
  output [ 1:0]                           axim_d_bresp;
  input                                   axim_d_bready;

  input                                   m_dest_axi_aclk;
  input                                   m_dest_axi_aresetn;
  output [31:0]                           m_dest_axi_awaddr;
  output [ 7:0]                           m_dest_axi_awlen;
  output [ 2:0]                           m_dest_axi_awsize;
  output [ 1:0]                           m_dest_axi_awburst;
  output [ 2:0]                           m_dest_axi_awprot;
  output [ 3:0]                           m_dest_axi_awcache;
  output                                  m_dest_axi_awvalid;
  input                                   m_dest_axi_awready;
  output [C_DMA_DATA_WIDTH_DEST-1:0]      m_dest_axi_wdata;
  output [(C_DMA_DATA_WIDTH_DEST/8)-1:0]  m_dest_axi_wstrb;
  input                                   m_dest_axi_wready;
  output                                  m_dest_axi_wvalid;
  output                                  m_dest_axi_wlast;
  input                                   m_dest_axi_bvalid;
  input  [ 1:0]                           m_dest_axi_bresp;
  output                                  m_dest_axi_bready;

  // AXIM (src) interface

  output                                  axim_s_aclk;
  output                                  axim_s_aresetn;
  output                                  axim_s_arready;
  input                                   axim_s_arvalid;
  input  [31:0]                           axim_s_araddr;
  input  [ 7:0]                           axim_s_arlen;
  input  [ 2:0]                           axim_s_arsize;
  input  [ 1:0]                           axim_s_arburst;
  input  [ 2:0]                           axim_s_arprot;
  input  [ 3:0]                           axim_s_arcache;
  output [C_DMA_DATA_WIDTH_SRC-1:0]       axim_s_rdata;
  input                                   axim_s_rready;
  output                                  axim_s_rvalid;
  output [ 1:0]                           axim_s_rresp;

  input                                   m_src_axi_aclk;
  input                                   m_src_axi_aresetn;
  input                                   m_src_axi_arready;
  output                                  m_src_axi_arvalid;
  output [31:0]                           m_src_axi_araddr;
  output [ 7:0]                           m_src_axi_arlen;
  output [ 2:0]                           m_src_axi_arsize;
  output [ 1:0]                           m_src_axi_arburst;
  output [ 2:0]                           m_src_axi_arprot;
  output [ 3:0]                           m_src_axi_arcache;
  input  [C_DMA_DATA_WIDTH_SRC-1:0]       m_src_axi_rdata;
  output                                  m_src_axi_rready;
  input                                   m_src_axi_rvalid;
  input  [ 1:0]                           m_src_axi_rresp;

  // Interrupt

  input                                   axim_irq;
  output                                  irq;

  // assignments (axil)

  assign axil_aclk = s_axi_aclk;
  assign axil_aresetn = s_axi_aresetn;
  assign axil_awvalid = s_axi_awvalid;
  assign axil_awaddr = s_axi_awaddr;
  assign axil_wvalid = s_axi_wvalid;
  assign axil_wdata = s_axi_wdata;
  assign axil_wstrb = s_axi_wstrb;
  assign axil_bready = s_axi_bready;
  assign axil_arvalid = s_axi_arvalid;
  assign axil_araddr = s_axi_araddr;
  assign axil_rready = s_axi_rready;

  assign s_axi_awready = axil_awready;
  assign s_axi_wready = axil_wready;
  assign s_axi_bvalid = axil_bvalid;
  assign s_axi_bresp = axil_bresp;
  assign s_axi_arready = axil_arready;
  assign s_axi_rvalid = axil_rvalid;
  assign s_axi_rdata = axil_rdata;
  assign s_axi_rresp = axil_rresp;

  // assignments (axim-dest)

  assign axim_d_aclk = m_dest_axi_aclk;
  assign axim_d_aresetn = m_dest_axi_aresetn;
  assign axim_d_awready = m_dest_axi_awready;
  assign axim_d_wready = m_dest_axi_wready;
  assign axim_d_bresp = m_dest_axi_bresp;
  assign axim_d_bvalid = m_dest_axi_bvalid;

  assign m_dest_axi_awaddr = axim_d_awaddr;
  assign m_dest_axi_awlen = axim_d_awlen;
  assign m_dest_axi_awsize = axim_d_awsize;
  assign m_dest_axi_awburst = axim_d_awburst; 
  assign m_dest_axi_awprot = axim_d_awprot;
  assign m_dest_axi_awcache = axim_d_awcache; 
  assign m_dest_axi_awvalid = axim_d_awvalid; 
  assign m_dest_axi_wdata = axim_d_wdata;
  assign m_dest_axi_wstrb = axim_d_wstrb;
  assign m_dest_axi_wvalid = axim_d_wvalid;
  assign m_dest_axi_wlast = axim_d_wlast;
  assign m_dest_axi_bready = axim_d_bready;

  // assignments (axim-src)

  assign axim_s_aclk = m_src_axi_aclk;
  assign axim_s_aresetn = m_src_axi_aresetn;
  assign axim_s_arready = m_src_axi_arready;
  assign axim_s_rresp = m_src_axi_rresp;
  assign axim_s_rdata = m_src_axi_rdata;
  assign axim_s_rvalid = m_src_axi_rvalid;

  assign m_src_axi_araddr = axim_s_araddr;
  assign m_src_axi_arlen = axim_s_arlen;
  assign m_src_axi_arsize = axim_s_arsize;
  assign m_src_axi_arburst = axim_s_arburst; 
  assign m_src_axi_arprot = axim_s_arprot;
  assign m_src_axi_arcache = axim_s_arcache; 
  assign m_src_axi_arvalid = axim_s_arvalid; 
  assign m_src_axi_rready = axim_s_rready;

  // assignments (irq)

  assign irq = axim_irq;

endmodule

// ***************************************************************************
// ***************************************************************************
