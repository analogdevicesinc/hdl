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

module axi_dmac #(

  parameter ID = 0,
  parameter DMA_DATA_WIDTH_SRC = 64,
  parameter DMA_DATA_WIDTH_DEST = 64,
  parameter DMA_LENGTH_WIDTH = 24,
  parameter DMA_2D_TRANSFER = 0,
  parameter ASYNC_CLK_REQ_SRC = 1,
  parameter ASYNC_CLK_SRC_DEST = 1,
  parameter ASYNC_CLK_DEST_REQ = 1,
  parameter AXI_SLICE_DEST = 0,
  parameter AXI_SLICE_SRC = 0,
  parameter SYNC_TRANSFER_START = 0,
  parameter CYCLIC = 1,
  parameter DMA_AXI_PROTOCOL_DEST = 0,
  parameter DMA_AXI_PROTOCOL_SRC = 0,
  parameter DMA_TYPE_DEST = 0,
  parameter DMA_TYPE_SRC = 2,
  parameter DMA_AXI_ADDR_WIDTH = 32,
  parameter MAX_BYTES_PER_BURST = 128,
  parameter FIFO_SIZE = 8, // In bursts
  parameter AXI_ID_WIDTH_SRC = 1,
  parameter AXI_ID_WIDTH_DEST = 1,
  parameter DMA_AXIS_ID_W = 8,
  parameter DMA_AXIS_DEST_W = 4,
  parameter DISABLE_DEBUG_REGISTERS = 0,
  parameter ENABLE_DIAGNOSTICS_IF = 0,
  parameter ALLOW_ASYM_MEM = 0
) (
  // Slave AXI interface
  input s_axi_aclk,
  input s_axi_aresetn,

  input         s_axi_awvalid,
  input  [10:0] s_axi_awaddr,
  output        s_axi_awready,
  input   [2:0] s_axi_awprot,
  input         s_axi_wvalid,
  input  [31:0] s_axi_wdata,
  input  [ 3:0] s_axi_wstrb,
  output        s_axi_wready,
  output        s_axi_bvalid,
  output [ 1:0] s_axi_bresp,
  input         s_axi_bready,
  input         s_axi_arvalid,
  input  [10:0] s_axi_araddr,
  output        s_axi_arready,
  input   [2:0] s_axi_arprot,
  output        s_axi_rvalid,
  input         s_axi_rready,
  output [ 1:0] s_axi_rresp,
  output [31:0] s_axi_rdata,

  // Interrupt
  output irq,

  // Master AXI interface
  input                                    m_dest_axi_aclk,
  input                                    m_dest_axi_aresetn,

  // Write address
  output [DMA_AXI_ADDR_WIDTH-1:0]          m_dest_axi_awaddr,
  output [7-(4*DMA_AXI_PROTOCOL_DEST):0]   m_dest_axi_awlen,
  output [ 2:0]                            m_dest_axi_awsize,
  output [ 1:0]                            m_dest_axi_awburst,
  output [ 2:0]                            m_dest_axi_awprot,
  output [ 3:0]                            m_dest_axi_awcache,
  output                                   m_dest_axi_awvalid,
  input                                    m_dest_axi_awready,
  output [AXI_ID_WIDTH_DEST-1:0]           m_dest_axi_awid,
  output [DMA_AXI_PROTOCOL_DEST:0]         m_dest_axi_awlock,

  // Write data
  output [DMA_DATA_WIDTH_DEST-1:0]         m_dest_axi_wdata,
  output [(DMA_DATA_WIDTH_DEST/8)-1:0]     m_dest_axi_wstrb,
  input                                    m_dest_axi_wready,
  output                                   m_dest_axi_wvalid,
  output                                   m_dest_axi_wlast,
  output [AXI_ID_WIDTH_DEST-1:0]           m_dest_axi_wid,

  // Write response
  input                                    m_dest_axi_bvalid,
  input  [ 1:0]                            m_dest_axi_bresp,
  output                                   m_dest_axi_bready,
  input  [AXI_ID_WIDTH_DEST-1:0]           m_dest_axi_bid,

  // Unused read interface
  output                                   m_dest_axi_arvalid,
  output [DMA_AXI_ADDR_WIDTH-1:0]          m_dest_axi_araddr,
  output [7-(4*DMA_AXI_PROTOCOL_DEST):0]   m_dest_axi_arlen,
  output [ 2:0]                            m_dest_axi_arsize,
  output [ 1:0]                            m_dest_axi_arburst,
  output [ 3:0]                            m_dest_axi_arcache,
  output [ 2:0]                            m_dest_axi_arprot,
  input                                    m_dest_axi_arready,
  input                                    m_dest_axi_rvalid,
  input  [ 1:0]                            m_dest_axi_rresp,
  input  [DMA_DATA_WIDTH_DEST-1:0]         m_dest_axi_rdata,
  output                                   m_dest_axi_rready,
  output [AXI_ID_WIDTH_DEST-1:0]           m_dest_axi_arid,
  output [DMA_AXI_PROTOCOL_DEST:0]         m_dest_axi_arlock,
  input  [AXI_ID_WIDTH_DEST-1:0]           m_dest_axi_rid,
  input                                    m_dest_axi_rlast,

  // Master AXI interface
  input                                    m_src_axi_aclk,
  input                                    m_src_axi_aresetn,

  // Read address
  input                                    m_src_axi_arready,
  output                                   m_src_axi_arvalid,
  output [DMA_AXI_ADDR_WIDTH-1:0]          m_src_axi_araddr,
  output [7-(4*DMA_AXI_PROTOCOL_SRC):0]    m_src_axi_arlen,
  output [ 2:0]                            m_src_axi_arsize,
  output [ 1:0]                            m_src_axi_arburst,
  output [ 2:0]                            m_src_axi_arprot,
  output [ 3:0]                            m_src_axi_arcache,
  output [AXI_ID_WIDTH_SRC-1:0]            m_src_axi_arid,
  output [DMA_AXI_PROTOCOL_SRC:0]          m_src_axi_arlock,

  // Read data and response
  input  [DMA_DATA_WIDTH_SRC-1:0]          m_src_axi_rdata,
  output                                   m_src_axi_rready,
  input                                    m_src_axi_rvalid,
  input  [ 1:0]                            m_src_axi_rresp,
  input  [AXI_ID_WIDTH_SRC-1:0]            m_src_axi_rid,
  input                                    m_src_axi_rlast,

  // Unused write interface
  output                                   m_src_axi_awvalid,
  output [DMA_AXI_ADDR_WIDTH-1:0]          m_src_axi_awaddr,
  output [7-(4*DMA_AXI_PROTOCOL_SRC):0]    m_src_axi_awlen,
  output [ 2:0]                            m_src_axi_awsize,
  output [ 1:0]                            m_src_axi_awburst,
  output [ 3:0]                            m_src_axi_awcache,
  output [ 2:0]                            m_src_axi_awprot,
  input                                    m_src_axi_awready,
  output                                   m_src_axi_wvalid,
  output [DMA_DATA_WIDTH_SRC-1:0]          m_src_axi_wdata,
  output [(DMA_DATA_WIDTH_SRC/8)-1:0]      m_src_axi_wstrb,
  output                                   m_src_axi_wlast,
  input                                    m_src_axi_wready,
  input                                    m_src_axi_bvalid,
  input  [ 1:0]                            m_src_axi_bresp,
  output                                   m_src_axi_bready,
  output [AXI_ID_WIDTH_SRC-1:0]            m_src_axi_awid,
  output [DMA_AXI_PROTOCOL_SRC:0]          m_src_axi_awlock,
  output [AXI_ID_WIDTH_SRC-1:0]            m_src_axi_wid,
  input  [AXI_ID_WIDTH_SRC-1:0]            m_src_axi_bid,



  // Slave streaming AXI interface
  input                                    s_axis_aclk,
  output                                   s_axis_ready,
  input                                    s_axis_valid,
  input  [DMA_DATA_WIDTH_SRC-1:0]          s_axis_data,
  input  [DMA_DATA_WIDTH_SRC/8-1:0]        s_axis_strb,
  input  [DMA_DATA_WIDTH_SRC/8-1:0]        s_axis_keep,
  input  [0:0]                             s_axis_user,
  input  [DMA_AXIS_ID_W-1:0]               s_axis_id,
  input  [DMA_AXIS_DEST_W-1:0]             s_axis_dest,
  input                                    s_axis_last,
  output                                   s_axis_xfer_req,

  // Master streaming AXI interface
  input                                    m_axis_aclk,
  input                                    m_axis_ready,
  output                                   m_axis_valid,
  output [DMA_DATA_WIDTH_DEST-1:0]         m_axis_data,
  output [DMA_DATA_WIDTH_DEST/8-1:0]       m_axis_strb,
  output [DMA_DATA_WIDTH_DEST/8-1:0]       m_axis_keep,
  output [0:0]                             m_axis_user,
  output [DMA_AXIS_ID_W-1:0]               m_axis_id,
  output [DMA_AXIS_DEST_W-1:0]             m_axis_dest,
  output                                   m_axis_last,
  output                                   m_axis_xfer_req,

  // Input FIFO interface
  input                                    fifo_wr_clk,
  input                                    fifo_wr_en,
  input  [DMA_DATA_WIDTH_SRC-1:0]          fifo_wr_din,
  output                                   fifo_wr_overflow,
  input                                    fifo_wr_sync,
  output                                   fifo_wr_xfer_req,

  // Input FIFO interface
  input                                    fifo_rd_clk,
  input                                    fifo_rd_en,
  output                                   fifo_rd_valid,
  output [DMA_DATA_WIDTH_DEST-1:0]         fifo_rd_dout,
  output                                   fifo_rd_underflow,
  output                                   fifo_rd_xfer_req,

  // Diagnostics interface
  output  [7:0] dest_diag_level_bursts
);


localparam DMA_TYPE_AXI_MM = 0;
localparam DMA_TYPE_AXI_STREAM = 1;
localparam DMA_TYPE_FIFO = 2;

localparam HAS_DEST_ADDR = DMA_TYPE_DEST == DMA_TYPE_AXI_MM;
localparam HAS_SRC_ADDR = DMA_TYPE_SRC == DMA_TYPE_AXI_MM;

// Argh... "[Synth 8-2722] system function call clog2 is not allowed here"
localparam BYTES_PER_BEAT_WIDTH_DEST = DMA_DATA_WIDTH_DEST > 1024 ? 8 :
  DMA_DATA_WIDTH_DEST > 512 ? 7 :
  DMA_DATA_WIDTH_DEST > 256 ? 6 :
  DMA_DATA_WIDTH_DEST > 128 ? 5 :
  DMA_DATA_WIDTH_DEST > 64 ? 4 :
  DMA_DATA_WIDTH_DEST > 32 ? 3 :
  DMA_DATA_WIDTH_DEST > 16 ? 2 :
  DMA_DATA_WIDTH_DEST > 8 ? 1 : 0;
localparam BYTES_PER_BEAT_WIDTH_SRC = DMA_DATA_WIDTH_SRC > 1024 ? 8 :
  DMA_DATA_WIDTH_SRC > 512 ? 7 :
  DMA_DATA_WIDTH_SRC > 256 ? 6 :
  DMA_DATA_WIDTH_SRC > 128 ? 5 :
  DMA_DATA_WIDTH_SRC > 64 ? 4 :
  DMA_DATA_WIDTH_SRC > 32 ? 3 :
  DMA_DATA_WIDTH_SRC > 16 ? 2 :
  DMA_DATA_WIDTH_SRC > 8 ? 1 : 0;
localparam ID_WIDTH = (FIFO_SIZE) > 64 ? 8 :
  (FIFO_SIZE) > 32 ? 7 :
  (FIFO_SIZE) > 16 ? 6 :
  (FIFO_SIZE) > 8 ? 5 :
  (FIFO_SIZE) > 4 ? 4 :
  (FIFO_SIZE) > 2 ? 3 :
  (FIFO_SIZE) > 1 ? 2 : 1;
localparam DBG_ID_PADDING = ID_WIDTH > 8 ? 0 : 8 - ID_WIDTH;

/* AXI3 supports a maximum of 16 beats per burst. AXI4 supports a maximum of
   256 beats per burst. If either bus is AXI3 set the maximum number of beats
   per burst to 16. For non AXI interfaces the maximum beats per burst is in
   theory unlimted. Set it to 1024 to provide a reasonable upper threshold */
localparam BEATS_PER_BURST_LIMIT_DEST =
  (DMA_TYPE_DEST == DMA_TYPE_AXI_MM) ?
    (DMA_AXI_PROTOCOL_DEST == 1 ? 16 : 256) :
    1024;
localparam BYTES_PER_BURST_LIMIT_DEST =
    BEATS_PER_BURST_LIMIT_DEST * DMA_DATA_WIDTH_DEST / 8;
localparam BEATS_PER_BURST_LIMIT_SRC =
  (DMA_TYPE_SRC == DMA_TYPE_AXI_MM) ?
    (DMA_AXI_PROTOCOL_SRC == 1 ? 16 : 256) :
    1024;
localparam BYTES_PER_BURST_LIMIT_SRC =
    BEATS_PER_BURST_LIMIT_SRC * DMA_DATA_WIDTH_SRC / 8;

/* The smaller bus limits the maximum bytes per burst. */
localparam BYTES_PER_BURST_LIMIT =
  (BYTES_PER_BURST_LIMIT_DEST < BYTES_PER_BURST_LIMIT_SRC) ?
  BYTES_PER_BURST_LIMIT_DEST : BYTES_PER_BURST_LIMIT_SRC;

/* Make sure the requested MAX_BYTES_PER_BURST does not exceed what the
   interfaces can support. Limit the value if necessary. */
localparam REAL_MAX_BYTES_PER_BURST =
  BYTES_PER_BURST_LIMIT < MAX_BYTES_PER_BURST ?
    BYTES_PER_BURST_LIMIT : MAX_BYTES_PER_BURST;

/* MM has no alignment requirements */
localparam DMA_LENGTH_ALIGN_SRC =
  DMA_TYPE_SRC == DMA_TYPE_AXI_MM ? 0 : BYTES_PER_BEAT_WIDTH_SRC;
localparam DMA_LENGTH_ALIGN_DEST =
  DMA_TYPE_DEST == DMA_TYPE_AXI_MM ? 0 : BYTES_PER_BEAT_WIDTH_DEST;

/* Choose the larger of the two */
 localparam DMA_LENGTH_ALIGN =
   DMA_LENGTH_ALIGN_SRC < DMA_LENGTH_ALIGN_DEST ?
     DMA_LENGTH_ALIGN_DEST : DMA_LENGTH_ALIGN_SRC;

localparam BYTES_PER_BURST_WIDTH =
  REAL_MAX_BYTES_PER_BURST > 2048 ? 12 :
  REAL_MAX_BYTES_PER_BURST > 1024 ? 11 :
  REAL_MAX_BYTES_PER_BURST > 512 ? 10 :
  REAL_MAX_BYTES_PER_BURST > 256 ? 9 :
  REAL_MAX_BYTES_PER_BURST > 128 ? 8 :
  REAL_MAX_BYTES_PER_BURST > 64 ? 7 :
  REAL_MAX_BYTES_PER_BURST > 32 ? 6 :
  REAL_MAX_BYTES_PER_BURST > 16 ? 5 :
  REAL_MAX_BYTES_PER_BURST > 8 ? 4 :
  REAL_MAX_BYTES_PER_BURST > 4 ? 3 :
  REAL_MAX_BYTES_PER_BURST > 2 ? 2 : 1;

// ID signals from the DMAC, just for debugging
wire [ID_WIDTH-1:0] dest_request_id;
wire [ID_WIDTH-1:0] dest_data_id;
wire [ID_WIDTH-1:0] dest_address_id;
wire [ID_WIDTH-1:0] dest_response_id;
wire [ID_WIDTH-1:0] src_request_id;
wire [ID_WIDTH-1:0] src_data_id;
wire [ID_WIDTH-1:0] src_address_id;
wire [ID_WIDTH-1:0] src_response_id;
wire [11:0] dbg_status;
wire [31:0] dbg_ids0;
wire [31:0] dbg_ids1;

assign m_dest_axi_araddr = 'd0;
assign m_dest_axi_arlen = 'd0;
assign m_dest_axi_arsize = 'd0;
assign m_dest_axi_arburst = 'd0;
assign m_dest_axi_arcache = 'd0;
assign m_dest_axi_arprot = 'd0;
assign m_dest_axi_awid = 'h0;
assign m_dest_axi_awlock = 'h0;
assign m_dest_axi_wid = 'h0;
assign m_dest_axi_arid = 'h0;
assign m_dest_axi_arlock = 'h0;
assign m_src_axi_awaddr = 'd0;
assign m_src_axi_awlen = 'd0;
assign m_src_axi_awsize = 'd0;
assign m_src_axi_awburst = 'd0;
assign m_src_axi_awcache = 'd0;
assign m_src_axi_awprot = 'd0;
assign m_src_axi_wdata = 'd0;
assign m_src_axi_wstrb = 'd0;
assign m_src_axi_wlast = 'd0;
assign m_src_axi_awid = 'h0;
assign m_src_axi_awlock = 'h0;
assign m_src_axi_wid = 'h0;
assign m_src_axi_arid = 'h0;
assign m_src_axi_arlock = 'h0;

wire up_req_eot;
wire [BYTES_PER_BURST_WIDTH-1:0] up_req_measured_burst_length;
wire up_response_partial;
wire up_response_valid;
wire up_response_ready;

wire ctrl_enable;
wire ctrl_pause;

wire up_dma_req_valid;
wire up_dma_req_ready;
wire [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] up_dma_req_dest_address;
wire [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC] up_dma_req_src_address;
wire [DMA_LENGTH_WIDTH-1:0] up_dma_req_x_length;
wire [DMA_LENGTH_WIDTH-1:0] up_dma_req_y_length;
wire [DMA_LENGTH_WIDTH-1:0] up_dma_req_dest_stride;
wire [DMA_LENGTH_WIDTH-1:0] up_dma_req_src_stride;
wire up_dma_req_sync_transfer_start;
wire up_dma_req_last;

assign dbg_ids0 = {
  {DBG_ID_PADDING{1'b0}}, dest_response_id,
  {DBG_ID_PADDING{1'b0}}, dest_data_id,
  {DBG_ID_PADDING{1'b0}}, dest_address_id,
  {DBG_ID_PADDING{1'b0}}, dest_request_id
};

assign dbg_ids1 = {
  {DBG_ID_PADDING{1'b0}}, src_response_id,
  {DBG_ID_PADDING{1'b0}}, src_data_id,
  {DBG_ID_PADDING{1'b0}}, src_address_id,
  {DBG_ID_PADDING{1'b0}}, src_request_id
};

axi_dmac_regmap #(
  .DISABLE_DEBUG_REGISTERS(DISABLE_DEBUG_REGISTERS),
  .BYTES_PER_BEAT_WIDTH_DEST(BYTES_PER_BEAT_WIDTH_DEST),
  .BYTES_PER_BEAT_WIDTH_SRC(BYTES_PER_BEAT_WIDTH_SRC),
  .BYTES_PER_BURST_WIDTH(BYTES_PER_BURST_WIDTH),
  .DMA_TYPE_DEST(DMA_TYPE_DEST),
  .DMA_TYPE_SRC(DMA_TYPE_SRC),
  .DMA_AXI_ADDR_WIDTH(DMA_AXI_ADDR_WIDTH),
  .DMA_LENGTH_WIDTH(DMA_LENGTH_WIDTH),
  .DMA_LENGTH_ALIGN(DMA_LENGTH_ALIGN),
  .DMA_CYCLIC(CYCLIC),
  .HAS_DEST_ADDR(HAS_DEST_ADDR),
  .HAS_SRC_ADDR(HAS_SRC_ADDR),
  .DMA_2D_TRANSFER(DMA_2D_TRANSFER),
  .SYNC_TRANSFER_START(SYNC_TRANSFER_START)
) i_regmap (
  .s_axi_aclk(s_axi_aclk),
  .s_axi_aresetn(s_axi_aresetn),

  .s_axi_awvalid(s_axi_awvalid),
  .s_axi_awaddr(s_axi_awaddr),
  .s_axi_awready(s_axi_awready),
  .s_axi_awprot(s_axi_awprot),
  .s_axi_wvalid(s_axi_wvalid),
  .s_axi_wdata(s_axi_wdata),
  .s_axi_wstrb(s_axi_wstrb),
  .s_axi_wready(s_axi_wready),
  .s_axi_bvalid(s_axi_bvalid),
  .s_axi_bresp(s_axi_bresp),
  .s_axi_bready(s_axi_bready),
  .s_axi_arvalid(s_axi_arvalid),
  .s_axi_araddr(s_axi_araddr),
  .s_axi_arready(s_axi_arready),
  .s_axi_arprot(s_axi_arprot),
  .s_axi_rvalid(s_axi_rvalid),
  .s_axi_rready(s_axi_rready),
  .s_axi_rresp(s_axi_rresp),
  .s_axi_rdata(s_axi_rdata),

  // Interrupt
  .irq(irq),

   // Control interface
  .ctrl_enable(ctrl_enable),
  .ctrl_pause(ctrl_pause),

   // Request interface
  .request_valid(up_dma_req_valid),
  .request_ready(up_dma_req_ready),
  .request_dest_address(up_dma_req_dest_address),
  .request_src_address(up_dma_req_src_address),
  .request_x_length(up_dma_req_x_length),
  .request_y_length(up_dma_req_y_length),
  .request_dest_stride(up_dma_req_dest_stride),
  .request_src_stride(up_dma_req_src_stride),
  .request_sync_transfer_start(up_dma_req_sync_transfer_start),
  .request_last(up_dma_req_last),

  // DMA response interface
  .response_eot(up_req_eot),
  .response_measured_burst_length(up_req_measured_burst_length),
  .response_partial(up_response_partial),
  .response_valid(up_response_valid),
  .response_ready(up_response_ready),

  // Debug interface
  .dbg_dest_addr(m_dest_axi_awaddr),
  .dbg_src_addr(m_src_axi_araddr),
  .dbg_status(dbg_status),
  .dbg_ids0(dbg_ids0),
  .dbg_ids1(dbg_ids1)
);

axi_dmac_transfer #(
  .DMA_DATA_WIDTH_SRC(DMA_DATA_WIDTH_SRC),
  .DMA_DATA_WIDTH_DEST(DMA_DATA_WIDTH_DEST),
  .DMA_LENGTH_WIDTH(DMA_LENGTH_WIDTH),
  .DMA_LENGTH_ALIGN(DMA_LENGTH_ALIGN),
  .BYTES_PER_BEAT_WIDTH_DEST(BYTES_PER_BEAT_WIDTH_DEST),
  .BYTES_PER_BEAT_WIDTH_SRC(BYTES_PER_BEAT_WIDTH_SRC),
  .BYTES_PER_BURST_WIDTH(BYTES_PER_BURST_WIDTH),
  .DMA_TYPE_DEST(DMA_TYPE_DEST),
  .DMA_TYPE_SRC(DMA_TYPE_SRC),
  .DMA_AXI_ADDR_WIDTH(DMA_AXI_ADDR_WIDTH),
  .DMA_2D_TRANSFER(DMA_2D_TRANSFER),
  .ASYNC_CLK_REQ_SRC(ASYNC_CLK_REQ_SRC),
  .ASYNC_CLK_SRC_DEST(ASYNC_CLK_SRC_DEST),
  .ASYNC_CLK_DEST_REQ(ASYNC_CLK_DEST_REQ),
  .AXI_SLICE_DEST(AXI_SLICE_DEST),
  .AXI_SLICE_SRC(AXI_SLICE_SRC),
  .MAX_BYTES_PER_BURST(REAL_MAX_BYTES_PER_BURST),
  .FIFO_SIZE(FIFO_SIZE),
  .ID_WIDTH(ID_WIDTH),
  .AXI_LENGTH_WIDTH_SRC(8-(4*DMA_AXI_PROTOCOL_SRC)),
  .AXI_LENGTH_WIDTH_DEST(8-(4*DMA_AXI_PROTOCOL_DEST)),
  .ENABLE_DIAGNOSTICS_IF(ENABLE_DIAGNOSTICS_IF),
  .ALLOW_ASYM_MEM(ALLOW_ASYM_MEM)
) i_transfer (
  .ctrl_clk(s_axi_aclk),
  .ctrl_resetn(s_axi_aresetn),

  .ctrl_enable(ctrl_enable),
  .ctrl_pause(ctrl_pause),

  .req_valid(up_dma_req_valid),
  .req_ready(up_dma_req_ready),
  .req_dest_address(up_dma_req_dest_address),
  .req_src_address(up_dma_req_src_address),
  .req_x_length(up_dma_req_x_length),
  .req_y_length(up_dma_req_y_length),
  .req_dest_stride(up_dma_req_dest_stride),
  .req_src_stride(up_dma_req_src_stride),
  .req_sync_transfer_start(up_dma_req_sync_transfer_start),
  .req_last(up_dma_req_last),

  .req_eot(up_req_eot),
  .req_measured_burst_length(up_req_measured_burst_length),
  .req_response_partial(up_response_partial),
  .req_response_valid(up_response_valid),
  .req_response_ready(up_response_ready),

  .m_dest_axi_aclk(m_dest_axi_aclk),
  .m_dest_axi_aresetn(m_dest_axi_aresetn),
  .m_src_axi_aclk(m_src_axi_aclk),
  .m_src_axi_aresetn(m_src_axi_aresetn),

  .m_axi_awaddr(m_dest_axi_awaddr),
  .m_axi_awlen(m_dest_axi_awlen),
  .m_axi_awsize(m_dest_axi_awsize),
  .m_axi_awburst(m_dest_axi_awburst),
  .m_axi_awprot(m_dest_axi_awprot),
  .m_axi_awcache(m_dest_axi_awcache),
  .m_axi_awvalid(m_dest_axi_awvalid),
  .m_axi_awready(m_dest_axi_awready),

  .m_axi_wdata(m_dest_axi_wdata),
  .m_axi_wstrb(m_dest_axi_wstrb),
  .m_axi_wready(m_dest_axi_wready),
  .m_axi_wvalid(m_dest_axi_wvalid),
  .m_axi_wlast(m_dest_axi_wlast),

  .m_axi_bvalid(m_dest_axi_bvalid),
  .m_axi_bresp(m_dest_axi_bresp),
  .m_axi_bready(m_dest_axi_bready),

  .m_axi_arready(m_src_axi_arready),
  .m_axi_arvalid(m_src_axi_arvalid),
  .m_axi_araddr(m_src_axi_araddr),
  .m_axi_arlen(m_src_axi_arlen),
  .m_axi_arsize(m_src_axi_arsize),
  .m_axi_arburst(m_src_axi_arburst),
  .m_axi_arprot(m_src_axi_arprot),
  .m_axi_arcache(m_src_axi_arcache),

  .m_axi_rdata(m_src_axi_rdata),
  .m_axi_rready(m_src_axi_rready),
  .m_axi_rvalid(m_src_axi_rvalid),
  .m_axi_rlast(m_src_axi_rlast),
  .m_axi_rresp(m_src_axi_rresp),

  .s_axis_aclk(s_axis_aclk),
  .s_axis_ready(s_axis_ready),
  .s_axis_valid(s_axis_valid),
  .s_axis_data(s_axis_data),
  .s_axis_user(s_axis_user),
  .s_axis_last(s_axis_last),
  .s_axis_xfer_req(s_axis_xfer_req),

  .m_axis_aclk(m_axis_aclk),
  .m_axis_ready(m_axis_ready),
  .m_axis_valid(m_axis_valid),
  .m_axis_data(m_axis_data),
  .m_axis_last(m_axis_last),
  .m_axis_xfer_req(m_axis_xfer_req),

  .fifo_wr_clk(fifo_wr_clk),
  .fifo_wr_en(fifo_wr_en),
  .fifo_wr_din(fifo_wr_din),
  .fifo_wr_overflow(fifo_wr_overflow),
  .fifo_wr_sync(fifo_wr_sync),
  .fifo_wr_xfer_req(fifo_wr_xfer_req),

  .fifo_rd_clk(fifo_rd_clk),
  .fifo_rd_en(fifo_rd_en),
  .fifo_rd_valid(fifo_rd_valid),
  .fifo_rd_dout(fifo_rd_dout),
  .fifo_rd_underflow(fifo_rd_underflow),
  .fifo_rd_xfer_req(fifo_rd_xfer_req),

  // DBG
  .dbg_dest_request_id(dest_request_id),
  .dbg_dest_address_id(dest_address_id),
  .dbg_dest_data_id(dest_data_id),
  .dbg_dest_response_id(dest_response_id),
  .dbg_src_request_id(src_request_id),
  .dbg_src_address_id(src_address_id),
  .dbg_src_data_id(src_data_id),
  .dbg_src_response_id(src_response_id),
  .dbg_status(dbg_status),

  .dest_diag_level_bursts(dest_diag_level_bursts)
);

assign m_dest_axi_arvalid = 1'b0;
assign m_dest_axi_rready = 1'b0;
assign m_dest_axi_araddr = 'h0;
assign m_dest_axi_arlen = 'h0;
assign m_dest_axi_arsize = 'h0;
assign m_dest_axi_arburst = 'h0;
assign m_dest_axi_arcache = 'h0;
assign m_dest_axi_arprot = 'h0;

assign m_src_axi_awvalid = 1'b0;
assign m_src_axi_wvalid = 1'b0;
assign m_src_axi_bready = 1'b0;
assign m_src_axi_awvalid = 'h0;
assign m_src_axi_awaddr = 'h0;
assign m_src_axi_awlen = 'h0;
assign m_src_axi_awsize = 'h0;
assign m_src_axi_awburst = 'h0;
assign m_src_axi_awcache = 'h0;
assign m_src_axi_awprot = 'h0;
assign m_src_axi_wvalid = 'h0;
assign m_src_axi_wdata = 'h0;
assign m_src_axi_wstrb = 'h0;
assign m_src_axi_wlast = 'h0;

assign m_axis_keep = {DMA_DATA_WIDTH_DEST/8{1'b1}};
assign m_axis_strb = {DMA_DATA_WIDTH_DEST/8{1'b1}};
assign m_axis_id = 'h0;
assign m_axis_dest = 'h0;
assign m_axis_user = 'h0;

endmodule
