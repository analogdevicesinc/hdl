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

module axi_dmac_alt (

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
  s_axi_rready,

  // axi master interface (destination)

	m_dest_axi_aclk,
	m_dest_axi_aresetn,
	m_dest_axi_awvalid,
	m_dest_axi_awaddr,
  m_dest_axi_awid,
	m_dest_axi_awlen,
	m_dest_axi_awsize,
	m_dest_axi_awburst,
  m_dest_axi_awlock,
	m_dest_axi_awcache,
	m_dest_axi_awprot,
	m_dest_axi_awready,
	m_dest_axi_wvalid,
	m_dest_axi_wdata,
	m_dest_axi_wstrb,
	m_dest_axi_wlast,
	m_dest_axi_wready,
	m_dest_axi_bvalid,
	m_dest_axi_bresp,
	m_dest_axi_bid,
	m_dest_axi_bready,
  m_dest_axi_arvalid,
  m_dest_axi_araddr,
  m_dest_axi_arid,
  m_dest_axi_arlen,
  m_dest_axi_arsize,
  m_dest_axi_arburst,
  m_dest_axi_arlock,
  m_dest_axi_arcache,
  m_dest_axi_arprot,
  m_dest_axi_arready,
  m_dest_axi_rvalid,
  m_dest_axi_rresp,
  m_dest_axi_rdata,
  m_dest_axi_rid,
  m_dest_axi_rlast,
  m_dest_axi_rready,

  // axi master interface (source)

	m_src_axi_aclk,
	m_src_axi_aresetn,
	m_src_axi_awvalid,
	m_src_axi_awaddr,
  m_src_axi_awid,
	m_src_axi_awlen,
	m_src_axi_awsize,
	m_src_axi_awburst,
  m_src_axi_awlock,
	m_src_axi_awcache,
	m_src_axi_awprot,
	m_src_axi_awready,
	m_src_axi_wvalid,
	m_src_axi_wdata,
	m_src_axi_wstrb,
	m_src_axi_wlast,
	m_src_axi_wready,
	m_src_axi_bvalid,
	m_src_axi_bresp,
	m_src_axi_bid,
	m_src_axi_bready,
	m_src_axi_arvalid,
	m_src_axi_araddr,
  m_src_axi_arid,
	m_src_axi_arlen,
	m_src_axi_arsize,
	m_src_axi_arburst,
  m_src_axi_arlock,
	m_src_axi_arcache,
	m_src_axi_arprot,
	m_src_axi_arready,
	m_src_axi_rvalid,
	m_src_axi_rresp,
	m_src_axi_rdata,
  m_src_axi_rid,
  m_src_axi_rlast,
	m_src_axi_rready,

  // axis

	s_axis_aclk,
	s_axis_ready,
	s_axis_valid,
	s_axis_data,
	s_axis_user,
	m_axis_aclk,
	m_axis_ready,
	m_axis_valid,
	m_axis_data,

  // fifo

	fifo_wr_clk,
	fifo_wr_en,
	fifo_wr_din,
	fifo_wr_overflow,
	fifo_wr_sync,
	fifo_rd_clk,
	fifo_rd_en,
	fifo_rd_valid,
	fifo_rd_dout,
	fifo_rd_underflow);

  parameter PCORE_ID = 0;
  parameter C_DMA_DATA_WIDTH_SRC = 64;
  parameter C_DMA_DATA_WIDTH_DEST = 64;
  parameter C_DMA_LENGTH_WIDTH = 14;
  parameter C_2D_TRANSFER = 1;
  parameter C_CLKS_ASYNC_REQ_SRC = 1;
  parameter C_CLKS_ASYNC_SRC_DEST = 1;
  parameter C_CLKS_ASYNC_DEST_REQ = 1;
  parameter C_AXI_SLICE_DEST = 0;
  parameter C_AXI_SLICE_SRC = 0;
  parameter C_SYNC_TRANSFER_START = 0;
  parameter C_CYCLIC = 1;
  parameter C_DMA_TYPE_DEST = 0;
  parameter C_DMA_TYPE_SRC = 2;

  // axi slave interface

  input                                     s_axi_aclk;
  input                                     s_axi_aresetn;
  input                                     s_axi_awvalid;
  input   [13:0]                            s_axi_awaddr;
  input   [ 2:0]                            s_axi_awid;
  input   [ 7:0]                            s_axi_awlen;
  input   [ 2:0]                            s_axi_awsize;
  input   [ 1:0]                            s_axi_awburst;
  input   [ 0:0]                            s_axi_awlock;
  input   [ 3:0]                            s_axi_awcache;
  input   [ 2:0]                            s_axi_awprot;
  output                                    s_axi_awready;
  input                                     s_axi_wvalid;
  input   [31:0]                            s_axi_wdata;
  input   [ 3:0]                            s_axi_wstrb;
  input                                     s_axi_wlast;
  output                                    s_axi_wready;
  output                                    s_axi_bvalid;
  output  [ 1:0]                            s_axi_bresp;
  output  [ 2:0]                            s_axi_bid;
  input                                     s_axi_bready;
  input                                     s_axi_arvalid;
  input   [13:0]                            s_axi_araddr;
  input   [ 2:0]                            s_axi_arid;
  input   [ 7:0]                            s_axi_arlen;
  input   [ 2:0]                            s_axi_arsize;
  input   [ 1:0]                            s_axi_arburst;
  input   [ 0:0]                            s_axi_arlock;
  input   [ 3:0]                            s_axi_arcache;
  input   [ 2:0]                            s_axi_arprot;
  output                                    s_axi_arready;
  output                                    s_axi_rvalid;
  output  [ 1:0]                            s_axi_rresp;
  output  [31:0]                            s_axi_rdata;
  output  [ 2:0]                            s_axi_rid;
  output                                    s_axi_rlast;
  input                                     s_axi_rready;

  // axi master interface (destination)

	input                                     m_dest_axi_aclk;
	input                                     m_dest_axi_aresetn;
	output                                    m_dest_axi_awvalid;
	output  [31:0]                            m_dest_axi_awaddr;
  output  [ 2:0]                            m_dest_axi_awid;
	output  [ 7:0]                            m_dest_axi_awlen;
	output  [ 2:0]                            m_dest_axi_awsize;
	output  [ 1:0]                            m_dest_axi_awburst;
  output  [ 0:0]                            m_dest_axi_awlock;
	output  [ 3:0]                            m_dest_axi_awcache;
	output  [ 2:0]                            m_dest_axi_awprot;
	input                                     m_dest_axi_awready;
	output                                    m_dest_axi_wvalid;
	output  [C_DMA_DATA_WIDTH_DEST-1:0]       m_dest_axi_wdata;
	output  [(C_DMA_DATA_WIDTH_DEST/8)-1:0]   m_dest_axi_wstrb;
	output                                    m_dest_axi_wlast;
	input                                     m_dest_axi_wready;
	input                                     m_dest_axi_bvalid;
	input   [ 1:0]                            m_dest_axi_bresp;
	input   [ 2:0]                            m_dest_axi_bid;
	output                                    m_dest_axi_bready;
  output                                    m_dest_axi_arvalid;
  output  [31:0]                            m_dest_axi_araddr;
  output  [ 2:0]                            m_dest_axi_arid;
  output  [ 7:0]                            m_dest_axi_arlen;
  output  [ 2:0]                            m_dest_axi_arsize;
  output  [ 1:0]                            m_dest_axi_arburst;
  output  [ 0:0]                            m_dest_axi_arlock;
  output  [ 3:0]                            m_dest_axi_arcache;
  output  [ 2:0]                            m_dest_axi_arprot;
  input                                     m_dest_axi_arready;
  input                                     m_dest_axi_rvalid;
  input   [ 1:0]                            m_dest_axi_rresp;
  input   [C_DMA_DATA_WIDTH_DEST-1:0]       m_dest_axi_rdata;
  input   [ 2:0]                            m_dest_axi_rid;
  input                                     m_dest_axi_rlast;
  output                                    m_dest_axi_rready;

  // axi master interface (source)

	input                                     m_src_axi_aclk;
	input                                     m_src_axi_aresetn;
	output                                    m_src_axi_awvalid;
	output  [31:0]                            m_src_axi_awaddr;
  output  [ 2:0]                            m_src_axi_awid;
	output  [ 7:0]                            m_src_axi_awlen;
	output  [ 2:0]                            m_src_axi_awsize;
	output  [ 1:0]                            m_src_axi_awburst;
  output  [ 0:0]                            m_src_axi_awlock;
	output  [ 3:0]                            m_src_axi_awcache;
	output  [ 2:0]                            m_src_axi_awprot;
	input                                     m_src_axi_awready;
	output                                    m_src_axi_wvalid;
	output  [C_DMA_DATA_WIDTH_SRC-1:0]        m_src_axi_wdata;
	output  [(C_DMA_DATA_WIDTH_SRC/8)-1:0]    m_src_axi_wstrb;
	output                                    m_src_axi_wlast;
	input                                     m_src_axi_wready;
	input                                     m_src_axi_bvalid;
	input   [ 1:0]                            m_src_axi_bresp;
	input   [ 2:0]                            m_src_axi_bid;
	output                                    m_src_axi_bready;
	output                                    m_src_axi_arvalid;
	output  [31:0]                            m_src_axi_araddr;
  output  [ 2:0]                            m_src_axi_arid;
	output  [ 7:0]                            m_src_axi_arlen;
	output  [ 2:0]                            m_src_axi_arsize;
	output  [ 1:0]                            m_src_axi_arburst;
  output  [ 0:0]                            m_src_axi_arlock;
	output  [ 3:0]                            m_src_axi_arcache;
	output  [ 2:0]                            m_src_axi_arprot;
	input                                     m_src_axi_arready;
	input                                     m_src_axi_rvalid;
	input   [ 1:0]                            m_src_axi_rresp;
	input   [C_DMA_DATA_WIDTH_SRC-1:0]        m_src_axi_rdata;
  input   [ 2:0]                            m_src_axi_rid;
  input                                     m_src_axi_rlast;
	output                                    m_src_axi_rready;

  // axis

	input                                     s_axis_aclk;
	output                                    s_axis_ready;
	input                                     s_axis_valid;
	input   [C_DMA_DATA_WIDTH_SRC-1:0]        s_axis_data;
	input   [ 0:0]                            s_axis_user;
	input                                     m_axis_aclk;
	input                                     m_axis_ready;
	output                                    m_axis_valid;
	output  [C_DMA_DATA_WIDTH_DEST-1:0]       m_axis_data;

  // fifo

	input                                     fifo_wr_clk;
	input                                     fifo_wr_en;
	input   [C_DMA_DATA_WIDTH_SRC-1:0]        fifo_wr_din;
	output                                    fifo_wr_overflow;
	input                                     fifo_wr_sync;
	input                                     fifo_rd_clk;
	input                                     fifo_rd_en;
	output                                    fifo_rd_valid;
	output  [C_DMA_DATA_WIDTH_DEST-1:0]       fifo_rd_dout;
	output                                    fifo_rd_underflow;

  // defaults

  assign s_axi_bid = 3'd0;
  assign s_axi_rid = 3'd0;
  assign s_axi_rlast = 1'd0;

  // instantiation

  axi_dmac #(
    .PCORE_ID (PCORE_ID),
    .C_BASEADDR (32'h00000000),
    .C_HIGHADDR (32'hffffffff),
    .C_DMA_DATA_WIDTH_SRC (C_DMA_DATA_WIDTH_SRC),
    .C_DMA_DATA_WIDTH_DEST (C_DMA_DATA_WIDTH_DEST),
    .C_DMA_LENGTH_WIDTH (C_DMA_LENGTH_WIDTH),
    .C_2D_TRANSFER (C_2D_TRANSFER),
    .C_CLKS_ASYNC_REQ_SRC (C_CLKS_ASYNC_REQ_SRC),
    .C_CLKS_ASYNC_SRC_DEST (C_CLKS_ASYNC_SRC_DEST),
    .C_CLKS_ASYNC_DEST_REQ (C_CLKS_ASYNC_DEST_REQ),
    .C_AXI_SLICE_DEST (C_AXI_SLICE_DEST),
    .C_AXI_SLICE_SRC (C_AXI_SLICE_SRC),
    .C_SYNC_TRANSFER_START (C_SYNC_TRANSFER_START),
    .C_CYCLIC (C_CYCLIC),
    .C_DMA_TYPE_DEST (C_DMA_TYPE_DEST),
    .C_DMA_TYPE_SRC (C_DMA_TYPE_SRC))
  i_axi_dmac (
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
	  .s_axi_rready (s_axi_rready),
	  .s_axi_rresp (s_axi_rresp),
	  .s_axi_rdata (s_axi_rdata),
	  .irq (irq),
	  .m_dest_axi_aclk (m_dest_axi_aclk),
	  .m_dest_axi_aresetn (m_dest_axi_aresetn),
	  .m_src_axi_aclk (m_src_axi_aclk),
	  .m_src_axi_aresetn (m_src_axi_aresetn),
	  .m_dest_axi_awaddr (m_dest_axi_awaddr),
	  .m_dest_axi_awlen (m_dest_axi_awlen),
	  .m_dest_axi_awsize (m_dest_axi_awsize),
	  .m_dest_axi_awburst (m_dest_axi_awburst),
	  .m_dest_axi_awprot (m_dest_axi_awprot),
	  .m_dest_axi_awcache (m_dest_axi_awcache),
	  .m_dest_axi_awvalid (m_dest_axi_awvalid),
	  .m_dest_axi_awready (m_dest_axi_awready),
	  .m_dest_axi_wdata (m_dest_axi_wdata),
	  .m_dest_axi_wstrb (m_dest_axi_wstrb),
	  .m_dest_axi_wready (m_dest_axi_wready),
	  .m_dest_axi_wvalid (m_dest_axi_wvalid),
	  .m_dest_axi_wlast (m_dest_axi_wlast),
	  .m_dest_axi_bvalid (m_dest_axi_bvalid),
	  .m_dest_axi_bresp (m_dest_axi_bresp),
	  .m_dest_axi_bready (m_dest_axi_bready),
	  .m_src_axi_arready (m_src_axi_arready),
	  .m_src_axi_arvalid (m_src_axi_arvalid),
	  .m_src_axi_araddr (m_src_axi_araddr),
	  .m_src_axi_arlen (m_src_axi_arlen),
	  .m_src_axi_arsize (m_src_axi_arsize),
	  .m_src_axi_arburst (m_src_axi_arburst),
	  .m_src_axi_arprot (m_src_axi_arprot),
	  .m_src_axi_arcache (m_src_axi_arcache),
	  .m_src_axi_rdata (m_src_axi_rdata),
	  .m_src_axi_rready (m_src_axi_rready),
	  .m_src_axi_rvalid (m_src_axi_rvalid),
	  .m_src_axi_rresp (m_src_axi_rresp),
	  .s_axis_aclk (s_axis_aclk),
	  .s_axis_ready (s_axis_ready),
	  .s_axis_valid (s_axis_valid),
	  .s_axis_data (s_axis_data),
	  .s_axis_user (s_axis_user),
	  .m_axis_aclk (m_axis_aclk),
	  .m_axis_ready (m_axis_ready),
	  .m_axis_valid (m_axis_valid),
	  .m_axis_data (m_axis_data),
	  .fifo_wr_clk (fifo_wr_clk),
	  .fifo_wr_en (fifo_wr_en),
	  .fifo_wr_din (fifo_wr_din),
	  .fifo_wr_overflow (fifo_wr_overflow),
	  .fifo_wr_sync (fifo_wr_sync),
	  .fifo_rd_clk (fifo_rd_clk),
	  .fifo_rd_en (fifo_rd_en),
	  .fifo_rd_valid (fifo_rd_valid),
	  .fifo_rd_dout (fifo_rd_dout),
	  .fifo_rd_underflow (fifo_rd_underflow));

endmodule

// ***************************************************************************
// ***************************************************************************

