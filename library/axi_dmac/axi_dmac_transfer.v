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

`timescale 1ns/100ps

module axi_dmac_transfer #(
  parameter DMA_DATA_WIDTH_SRC = 64,
  parameter DMA_DATA_WIDTH_DEST = 64,
  parameter DMA_DATA_WIDTH_SG = 64,
  parameter DMA_LENGTH_WIDTH = 24,
  parameter DMA_LENGTH_ALIGN = 3,
  parameter BYTES_PER_BEAT_WIDTH_DEST = $clog2(DMA_DATA_WIDTH_DEST/8),
  parameter BYTES_PER_BEAT_WIDTH_SRC = $clog2(DMA_DATA_WIDTH_SRC/8),
  parameter BYTES_PER_BEAT_WIDTH_SG = $clog2(DMA_DATA_WIDTH_SG/8),
  parameter DMA_TYPE_DEST = 0,
  parameter DMA_TYPE_SRC = 2,
  parameter DMA_AXI_ADDR_WIDTH = 32,
  parameter DMA_2D_TRANSFER = 0,
  parameter DMA_2D_TLAST_MODE = 0,
  parameter DMA_SG_TRANSFER = 0,
  parameter ASYNC_CLK_REQ_SRC = 1,
  parameter ASYNC_CLK_SRC_DEST = 1,
  parameter ASYNC_CLK_DEST_REQ = 1,
  parameter ASYNC_CLK_REQ_SG = 1,
  parameter AXI_SLICE_DEST = 0,
  parameter AXI_SLICE_SRC = 0,
  parameter AXIS_TUSER_SYNC = 1,
  parameter MAX_BYTES_PER_BURST = 128,
  parameter BYTES_PER_BURST_WIDTH = 7,
  parameter FIFO_SIZE = 8,
  parameter ID_WIDTH = $clog2(FIFO_SIZE*2),
  parameter AXI_LENGTH_WIDTH_SRC = 8,
  parameter AXI_LENGTH_WIDTH_DEST = 8,
  parameter AXI_LENGTH_WIDTH_SG = 8,
  parameter ENABLE_DIAGNOSTICS_IF = 0,
  parameter ALLOW_ASYM_MEM = 0,
  parameter [3:0] AXI_AXCACHE = 4'b0011,
  parameter [2:0] AXI_AXPROT = 3'b000,
  parameter FRAMELOCK = 0,
  parameter FRAMELOCK_MODE = 0,
  parameter MAX_NUM_FRAMES_WIDTH = 3,
  parameter USE_EXT_SYNC = 0
) (
  input ctrl_clk,
  input ctrl_resetn,

  input ctrl_enable,
  input ctrl_pause,
  input ctrl_hwdesc,
  input ctrl_flock,

  input req_valid,
  output req_ready,

  input [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] req_dest_address,
  input [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC] req_src_address,
  input [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SG] req_sg_address,
  input [DMA_LENGTH_WIDTH-1:0] req_x_length,
  input [DMA_LENGTH_WIDTH-1:0] req_y_length,
  input [DMA_LENGTH_WIDTH-1:0] req_dest_stride,
  input [DMA_LENGTH_WIDTH-1:0] req_src_stride,
  input [MAX_NUM_FRAMES_WIDTH-1:0] req_flock_framenum,
  input                            req_flock_mode,
  input                            req_flock_wait_writer,
  input [MAX_NUM_FRAMES_WIDTH-1:0] req_flock_distance,
  input [DMA_AXI_ADDR_WIDTH-1:0] req_flock_stride,
  input req_sync_transfer_start,
  input req_sync,
  input req_last,
  input req_cyclic,

  output req_eot,
  output [31:0] req_sg_desc_id,
  output [BYTES_PER_BURST_WIDTH-1:0] req_measured_burst_length,
  output req_response_partial,
  output req_response_valid,
  input req_response_ready,

  // Master AXI interface
  input m_dest_axi_aclk,
  input m_dest_axi_aresetn,
  input m_src_axi_aclk,
  input m_src_axi_aresetn,
  input m_sg_axi_aclk,
  input m_sg_axi_aresetn,

  // Write address
  output [DMA_AXI_ADDR_WIDTH-1:0] m_axi_awaddr,
  output [AXI_LENGTH_WIDTH_DEST-1:0] m_axi_awlen,
  output [2:0] m_axi_awsize,
  output [1:0] m_axi_awburst,
  output [2:0] m_axi_awprot,
  output [3:0] m_axi_awcache,
  output m_axi_awvalid,
  input m_axi_awready,

  // Write data
  output [DMA_DATA_WIDTH_DEST-1:0] m_axi_wdata,
  output [(DMA_DATA_WIDTH_DEST/8)-1:0] m_axi_wstrb,
  input m_axi_wready,
  output m_axi_wvalid,
  output m_axi_wlast,

  // Write response
  input m_axi_bvalid,
  input [1:0] m_axi_bresp,
  output m_axi_bready,

  // Read address
  input m_axi_arready,
  output m_axi_arvalid,
  output [DMA_AXI_ADDR_WIDTH-1:0] m_axi_araddr,
  output [AXI_LENGTH_WIDTH_SRC-1:0] m_axi_arlen,
  output [2:0] m_axi_arsize,
  output [1:0] m_axi_arburst,
  output [2:0] m_axi_arprot,
  output [3:0] m_axi_arcache,

  // Read data and response
  input [DMA_DATA_WIDTH_SRC-1:0] m_axi_rdata,
  input m_axi_rlast,
  output m_axi_rready,
  input m_axi_rvalid,
  input [1:0] m_axi_rresp,

  // Read address
  input m_sg_axi_arready,
  output m_sg_axi_arvalid,
  output [DMA_AXI_ADDR_WIDTH-1:0] m_sg_axi_araddr,
  output [AXI_LENGTH_WIDTH_SG-1:0] m_sg_axi_arlen,
  output [2:0] m_sg_axi_arsize,
  output [1:0] m_sg_axi_arburst,
  output [2:0] m_sg_axi_arprot,
  output [3:0] m_sg_axi_arcache,

  // Read data and response
  input [DMA_DATA_WIDTH_SG-1:0] m_sg_axi_rdata,
  input m_sg_axi_rlast,
  output m_sg_axi_rready,
  input m_sg_axi_rvalid,
  input [1:0] m_sg_axi_rresp,

  // Slave streaming AXI interface
  input s_axis_aclk,
  output s_axis_ready,
  input s_axis_valid,
  input [DMA_DATA_WIDTH_SRC-1:0] s_axis_data,
  input [0:0] s_axis_user,
  input s_axis_last,
  output s_axis_xfer_req,

  // Master streaming AXI interface
  input m_axis_aclk,
  input m_axis_ready,
  output m_axis_valid,
  output [DMA_DATA_WIDTH_DEST-1:0] m_axis_data,
  output [0:0]                     m_axis_user,
  output m_axis_last,
  output m_axis_xfer_req,

  // Input FIFO interface
  input fifo_wr_clk,
  input fifo_wr_en,
  input [DMA_DATA_WIDTH_SRC-1:0] fifo_wr_din,
  output fifo_wr_overflow,
  output fifo_wr_xfer_req,

  // Input FIFO interface
  input fifo_rd_clk,
  input fifo_rd_en,
  output fifo_rd_valid,
  output [DMA_DATA_WIDTH_DEST-1:0] fifo_rd_dout,
  output fifo_rd_underflow,
  output fifo_rd_xfer_req,

  output [ID_WIDTH-1:0] dbg_dest_request_id,
  output [ID_WIDTH-1:0] dbg_dest_address_id,
  output [ID_WIDTH-1:0] dbg_dest_data_id,
  output [ID_WIDTH-1:0] dbg_dest_response_id,
  output [ID_WIDTH-1:0] dbg_src_request_id,
  output [ID_WIDTH-1:0] dbg_src_address_id,
  output [ID_WIDTH-1:0] dbg_src_data_id,
  output [ID_WIDTH-1:0] dbg_src_response_id,
  output [11:0] dbg_status,

  // Frame lock interface
  // Writer mode
  input  [MAX_NUM_FRAMES_WIDTH-1:0] m_frame_in,
  input                             m_frame_in_valid,
  output [MAX_NUM_FRAMES_WIDTH-1:0] m_frame_out,
  output                            m_frame_out_valid,
  // Slave mode
  input  [MAX_NUM_FRAMES_WIDTH-1:0] s_frame_in,
  input                             s_frame_in_valid,
  output [MAX_NUM_FRAMES_WIDTH-1:0] s_frame_out,
  output                            s_frame_out_valid,

  // External sync interface
  input src_ext_sync,
  input dest_ext_sync,

  // Diagnostics interface
  output [7:0] dest_diag_level_bursts
);

  wire dma_req_valid;
  wire dma_req_ready;
  wire [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] dma_req_dest_address;
  wire [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC] dma_req_src_address;
  wire [DMA_LENGTH_WIDTH-1:0] dma_req_length;
  wire [BYTES_PER_BURST_WIDTH-1:0] dma_req_measured_burst_length;
  wire dma_req_eot;
  wire dma_response_valid;
  wire dma_response_ready;
  wire dma_response_partial;
  wire dma_req_sync_transfer_start;
  wire dma_req_last;
  wire dma_req_islast;

  wire [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] dma_sg_out_dest_address;
  wire [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC] dma_sg_out_src_address;
  wire [DMA_LENGTH_WIDTH-1:0] dma_sg_x_length;
  wire [DMA_LENGTH_WIDTH-1:0] dma_sg_y_length;
  wire [DMA_LENGTH_WIDTH-1:0] dma_sg_src_stride;
  wire [DMA_LENGTH_WIDTH-1:0] dma_sg_dst_stride;
  wire [31:0] dma_sg_hwdesc_id;
  wire dma_sg_hwdesc_eot;
  wire dma_sg_in_req_valid;
  wire dma_sg_in_req_ready;
  wire dma_sg_out_req_valid;
  wire dma_sg_out_req_ready;

  wire req_clk = ctrl_clk;
  wire req_resetn;

  wire req_enable;

  wire dest_clk;
  wire dest_ext_resetn;
  wire dest_resetn;
  wire dest_enable;
  wire dest_enabled;

  wire src_clk;
  wire src_ext_resetn;
  wire src_resetn;
  wire src_enable;
  wire src_enabled;

  wire sg_clk;
  wire sg_ext_resetn;
  wire sg_resetn;
  wire sg_enable;
  wire sg_enabled;

  wire req_valid_gated;
  wire req_ready_gated;

  wire abort_req;
  wire dma_eot;

  wire ext_sync_ready;
  wire ext_sync_valid;

  axi_dmac_reset_manager #(
    .ASYNC_CLK_REQ_SRC (ASYNC_CLK_REQ_SRC),
    .ASYNC_CLK_SRC_DEST (ASYNC_CLK_SRC_DEST),
    .ASYNC_CLK_DEST_REQ (ASYNC_CLK_DEST_REQ),
    .ASYNC_CLK_REQ_SG (ASYNC_CLK_REQ_SG),
    .DMA_SG_TRANSFER (DMA_SG_TRANSFER)
  ) i_reset_manager (
    .clk (ctrl_clk),
    .resetn (ctrl_resetn),

    .ctrl_enable (ctrl_enable),
    .ctrl_pause (ctrl_pause),
    .ctrl_hwdesc (ctrl_hwdesc),

    .req_resetn (req_resetn),
    .req_enable (req_enable),
    .req_enabled (req_enable),

    .dest_clk (dest_clk),
    .dest_ext_resetn (dest_ext_resetn),
    .dest_resetn (dest_resetn),
    .dest_enable (dest_enable),
    .dest_enabled (dest_enabled),

    .src_clk (src_clk),
    .src_ext_resetn (src_ext_resetn),
    .src_resetn (src_resetn),
    .src_enable (src_enable),
    .src_enabled (src_enabled),

    .sg_clk (sg_clk),
    .sg_ext_resetn (sg_ext_resetn),
    .sg_resetn (sg_resetn),
    .sg_enable (sg_enable),
    .sg_enabled (sg_enabled),

    .dbg_status (dbg_status));

  /*
   * Things become a lot easier if we gate incoming requests in a central place
   * before they are propagated downstream. Otherwise we'd need to take special
   * care to not accidentally accept requests while the DMA is going through a
   * shutdown and reset phase.
   */
  assign req_valid_gated = req_enable & req_valid;
  assign req_ready = req_enable & req_ready_gated;

  assign req_eot = ctrl_hwdesc ? (dma_eot & dma_sg_hwdesc_eot) : dma_eot;
  assign req_sg_desc_id = ctrl_hwdesc ? dma_sg_hwdesc_id : 'h00;
  assign dma_sg_in_req_valid = ctrl_hwdesc ? req_valid_gated : 1'b0;

  /* SG Interface */
  generate if (DMA_SG_TRANSFER == 1) begin

  dmac_sg #(
    .DMA_AXI_ADDR_WIDTH(DMA_AXI_ADDR_WIDTH),
    .DMA_DATA_WIDTH(DMA_DATA_WIDTH_SG),
    .DMA_LENGTH_WIDTH(DMA_LENGTH_WIDTH),
    .AXI_LENGTH_WIDTH(AXI_LENGTH_WIDTH_SG),
    .BYTES_PER_BEAT_WIDTH_DEST(BYTES_PER_BEAT_WIDTH_DEST),
    .BYTES_PER_BEAT_WIDTH_SRC(BYTES_PER_BEAT_WIDTH_SRC),
    .BYTES_PER_BEAT_WIDTH_SG(BYTES_PER_BEAT_WIDTH_SG),
    .ASYNC_CLK_REQ_SG(ASYNC_CLK_REQ_SG),
    .AXI_AXCACHE(AXI_AXCACHE),
    .AXI_AXPROT(AXI_AXPROT)
  ) i_dmac_sg (
    .req_clk(req_clk),
    .req_resetn(req_resetn),
    .req_enable(req_enable),

    .sg_clk(sg_clk),
    .sg_ext_resetn(sg_ext_resetn),
    .sg_resetn(sg_resetn),
    .sg_enable(sg_enable),
    .sg_enabled(sg_enabled),

    .req_in_valid(dma_sg_in_req_valid),
    .req_in_ready(dma_sg_in_req_ready),

    .req_out_valid(dma_sg_out_req_valid),
    .req_out_ready(dma_sg_out_req_ready),

    .req_desc_address(req_sg_address),

    .out_dest_address(dma_sg_out_dest_address),
    .out_src_address(dma_sg_out_src_address),

    .out_x_length(dma_sg_x_length),
    .out_y_length(dma_sg_y_length),
    .out_dest_stride(dma_sg_dst_stride),
    .out_src_stride(dma_sg_src_stride),
    .resp_out_id(dma_sg_hwdesc_id),
    .resp_out_eot(dma_sg_hwdesc_eot),
    .resp_in_valid(dma_eot),

    .m_axi_aclk(m_sg_axi_aclk),
    .m_axi_aresetn(m_sg_axi_aresetn),

    .m_axi_arready(m_sg_axi_arready),
    .m_axi_arvalid(m_sg_axi_arvalid),
    .m_axi_araddr(m_sg_axi_araddr),
    .m_axi_arlen(m_sg_axi_arlen),
    .m_axi_arsize(m_sg_axi_arsize),
    .m_axi_arburst(m_sg_axi_arburst),
    .m_axi_arprot(m_sg_axi_arprot),
    .m_axi_arcache(m_sg_axi_arcache),

    .m_axi_rdata(m_sg_axi_rdata),
    .m_axi_rlast(m_sg_axi_rlast),
    .m_axi_rready(m_sg_axi_rready),
    .m_axi_rvalid(m_sg_axi_rvalid),
    .m_axi_rresp(m_sg_axi_rresp));

  end else begin

  assign sg_clk = 1'b0;
  assign sg_ext_resetn = 1'b0;
  assign sg_enabled = 1'b0;
  assign dma_sg_in_req_ready = 1'b0;
  assign dma_sg_out_req_valid = 1'b0;
  assign dma_sg_hwdesc_eot = 1'b0;
  assign dma_sg_out_dest_address = 'h00;
  assign dma_sg_out_src_address = 'h00;
  assign dma_sg_x_length = 'h00;
  assign dma_sg_y_length = 'h00;
  assign dma_sg_dst_stride = 'h00;
  assign dma_sg_src_stride = 'h00;
  assign dma_sg_hwdesc_id = 'h00;

  end endgenerate

  /* 2D Interface */
  generate if (DMA_2D_TRANSFER == 1) begin

  wire [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] flock_dest_address;
  wire [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC] flock_src_address;
  wire [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] dma_2d_dest_address;
  wire [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC] dma_2d_src_address;
  wire [DMA_LENGTH_WIDTH-1:0] dma_2d_x_length;
  wire [DMA_LENGTH_WIDTH-1:0] dma_2d_y_length;
  wire [DMA_LENGTH_WIDTH-1:0] dma_2d_src_stride;
  wire [DMA_LENGTH_WIDTH-1:0] dma_2d_dst_stride;
  wire dma_2d_eot;

  wire flock_req_valid;
  wire flock_req_ready;
  wire dma_2d_req_valid;
  wire dma_2d_req_ready;
  wire dma_2d_req_ready_s;

  assign dma_2d_req_ready_s = dma_2d_req_ready & ext_sync_ready;
  assign ext_sync_valid = dma_2d_req_valid;

  assign flock_dest_address = ctrl_hwdesc ? dma_sg_out_dest_address : req_dest_address;
  assign flock_src_address = ctrl_hwdesc ? dma_sg_out_src_address : req_src_address;
  assign dma_2d_x_length = ctrl_hwdesc ? dma_sg_x_length : req_x_length;
  assign dma_2d_y_length = ctrl_hwdesc ? dma_sg_y_length : req_y_length;
  assign dma_2d_src_stride = ctrl_hwdesc ? dma_sg_src_stride : req_src_stride;
  assign dma_2d_dst_stride = ctrl_hwdesc ? dma_sg_dst_stride : req_dest_stride;

  assign flock_req_valid = ctrl_hwdesc ? dma_sg_out_req_valid : req_valid_gated;
  assign req_ready_gated = ctrl_hwdesc ? dma_sg_in_req_ready : flock_req_ready;
  assign dma_eot = dma_2d_eot;
  assign dma_sg_out_req_ready = flock_req_ready;

  if (FRAMELOCK == 1) begin
  /* FrameLock Interface */
  axi_dmac_framelock #(
    .DMA_AXI_ADDR_WIDTH (DMA_AXI_ADDR_WIDTH),
    .BYTES_PER_BEAT_WIDTH_DEST (BYTES_PER_BEAT_WIDTH_DEST),
    .BYTES_PER_BEAT_WIDTH_SRC (BYTES_PER_BEAT_WIDTH_SRC),
    .FRAMELOCK_MODE (FRAMELOCK_MODE),
    .MAX_NUM_FRAMES_WIDTH (MAX_NUM_FRAMES_WIDTH)
  ) i_dmac_flock (
    .req_aclk (req_clk),
    .req_aresetn (req_resetn),

    // Interface to UP
    .req_valid (flock_req_valid),
    .req_ready (flock_req_ready),
    .req_dest_address (flock_dest_address),
    .req_src_address (flock_src_address),

    .req_flock_framenum (req_flock_framenum),
    .req_flock_mode (req_flock_mode),
    .req_flock_wait_writer (req_flock_wait_writer),
    .req_flock_distance (req_flock_distance),
    .req_flock_stride (req_flock_stride),
    .req_flock_en (ctrl_flock),
    .req_cyclic (req_cyclic),

    // Interface to 2D
    .out_req_valid (dma_2d_req_valid),
    .out_req_ready (dma_2d_req_ready_s),
    .out_req_dest_address (dma_2d_dest_address),
    .out_req_src_address (dma_2d_src_address),

    .out_eot (dma_2d_eot),
    .out_response_valid (req_response_valid),
    .out_response_ready (req_response_ready),

    .m_frame_in (m_frame_in),
    .m_frame_in_valid (m_frame_in_valid),
    .m_frame_out (m_frame_out),
    .m_frame_out_valid (m_frame_out_valid),
    .s_frame_in (s_frame_in),
    .s_frame_in_valid (s_frame_in_valid),
    .s_frame_out (s_frame_out),
    .s_frame_out_valid (s_frame_out_valid));

  end else begin
  assign dma_2d_req_valid = flock_req_valid;
  assign flock_req_ready = dma_2d_req_ready_s;

  assign dma_2d_dest_address = flock_dest_address;
  assign dma_2d_src_address = flock_src_address;

  assign m_frame_out = 'h0;
  assign m_frame_out_valid = 'h0;
  assign s_frame_out = 'h0;
  assign s_frame_out_valid = 'h0;
  end

  dmac_2d_transfer #(
    .DMA_2D_TLAST_MODE (DMA_2D_TLAST_MODE),
    .DMA_AXI_ADDR_WIDTH (DMA_AXI_ADDR_WIDTH),
    .DMA_LENGTH_WIDTH (DMA_LENGTH_WIDTH),
    .BYTES_PER_BURST_WIDTH (BYTES_PER_BURST_WIDTH),
    .BYTES_PER_BEAT_WIDTH_SRC (BYTES_PER_BEAT_WIDTH_SRC),
    .BYTES_PER_BEAT_WIDTH_DEST (BYTES_PER_BEAT_WIDTH_DEST)
  ) i_2d_transfer (
    .req_aclk (req_clk),
    .req_aresetn (req_resetn),

    .req_eot (dma_2d_eot),
    .req_measured_burst_length (req_measured_burst_length),
    .req_response_partial (req_response_partial),
    .req_response_valid (req_response_valid),
    .req_response_ready (req_response_ready),

    .req_valid (dma_2d_req_valid),
    .req_ready (dma_2d_req_ready),
    .req_dest_address (dma_2d_dest_address),
    .req_src_address (dma_2d_src_address),
    .req_x_length (dma_2d_x_length),
    .req_y_length (dma_2d_y_length),
    .req_dest_stride (dma_2d_dst_stride),
    .req_src_stride (dma_2d_src_stride),
    .req_sync_transfer_start (req_sync_transfer_start),
    .req_last (req_last),

    .out_abort_req (abort_req),
    .out_req_valid (dma_req_valid),
    .out_req_ready (dma_req_ready),
    .out_req_dest_address (dma_req_dest_address),
    .out_req_src_address (dma_req_src_address),
    .out_req_length (dma_req_length),
    .out_req_sync_transfer_start (dma_req_sync_transfer_start),
    .out_req_last (dma_req_last),
    .out_req_islast (dma_req_islast),
    .out_eot (dma_req_eot),
    .out_measured_burst_length (dma_req_measured_burst_length),
    .out_response_partial (dma_response_partial),
    .out_response_valid (dma_response_valid),
    .out_response_ready (dma_response_ready));

  end else begin
  /* External Sync */
  assign dma_req_ready_s = dma_req_ready & ext_sync_ready;
  assign ext_sync_valid = dma_req_valid;

  /* Request */
  assign dma_req_valid = ctrl_hwdesc ? dma_sg_out_req_valid : req_valid_gated;
  assign req_ready_gated = ctrl_hwdesc ? dma_sg_in_req_ready : dma_req_ready;
  assign dma_eot = dma_req_eot;
  assign dma_sg_out_req_ready = dma_req_ready_s;

  assign dma_req_dest_address = ctrl_hwdesc ? dma_sg_out_dest_address : req_dest_address;
  assign dma_req_src_address = ctrl_hwdesc ? dma_sg_out_src_address : req_src_address;
  assign dma_req_length = ctrl_hwdesc ? dma_sg_x_length : req_x_length;
  assign dma_req_sync_transfer_start = req_sync_transfer_start;
  assign dma_req_last = req_last;

  /* Response */
  assign req_measured_burst_length = dma_req_measured_burst_length;
  assign req_response_partial = dma_response_partial;
  assign req_response_valid = dma_response_valid;
  assign dma_response_ready = req_response_ready;

  end endgenerate

  request_arb #(
    .DMA_DATA_WIDTH_SRC (DMA_DATA_WIDTH_SRC),
    .DMA_DATA_WIDTH_DEST (DMA_DATA_WIDTH_DEST),
    .DMA_LENGTH_WIDTH (DMA_LENGTH_WIDTH),
    .DMA_LENGTH_ALIGN (DMA_LENGTH_ALIGN),
    .BYTES_PER_BEAT_WIDTH_DEST (BYTES_PER_BEAT_WIDTH_DEST),
    .BYTES_PER_BEAT_WIDTH_SRC (BYTES_PER_BEAT_WIDTH_SRC),
    .DMA_TYPE_DEST (DMA_TYPE_DEST),
    .DMA_TYPE_SRC (DMA_TYPE_SRC),
    .DMA_AXI_ADDR_WIDTH (DMA_AXI_ADDR_WIDTH),
    .ASYNC_CLK_REQ_SRC (ASYNC_CLK_REQ_SRC),
    .ASYNC_CLK_SRC_DEST (ASYNC_CLK_SRC_DEST),
    .ASYNC_CLK_DEST_REQ (ASYNC_CLK_DEST_REQ),
    .AXI_SLICE_DEST (AXI_SLICE_DEST),
    .AXI_SLICE_SRC (AXI_SLICE_SRC),
    .AXIS_TUSER_SYNC(AXIS_TUSER_SYNC),
    .MAX_BYTES_PER_BURST (MAX_BYTES_PER_BURST),
    .BYTES_PER_BURST_WIDTH (BYTES_PER_BURST_WIDTH),
    .FIFO_SIZE (FIFO_SIZE),
    .ID_WIDTH (ID_WIDTH),
    .AXI_LENGTH_WIDTH_DEST (AXI_LENGTH_WIDTH_DEST),
    .AXI_LENGTH_WIDTH_SRC (AXI_LENGTH_WIDTH_SRC),
    .ENABLE_DIAGNOSTICS_IF (ENABLE_DIAGNOSTICS_IF),
    .ALLOW_ASYM_MEM (ALLOW_ASYM_MEM),
    .AXI_AXCACHE (AXI_AXCACHE),
    .AXI_AXPROT (AXI_AXPROT),
    .USE_EXT_SYNC (USE_EXT_SYNC)
  ) i_request_arb (
    .req_clk (req_clk),
    .req_resetn (req_resetn),

    .req_valid (dma_req_valid),
    .req_ready (dma_req_ready),
    .req_dest_address (dma_req_dest_address),
    .req_src_address (dma_req_src_address),
    .req_length (dma_req_length),
    .req_xlast (dma_req_last),
    .req_islast (dma_req_islast),
    .req_sync_transfer_start (dma_req_sync_transfer_start),
    .req_sync (req_sync),

    .eot (dma_req_eot),
    .measured_burst_length(dma_req_measured_burst_length),
    .response_partial (dma_response_partial),
    .response_valid (dma_response_valid),
    .response_ready (dma_response_ready),

    .abort_req (abort_req),

    .req_enable (req_enable),

    .dest_clk (dest_clk),
    .dest_ext_resetn (dest_ext_resetn),
    .dest_resetn (dest_resetn),
    .dest_enable (dest_enable),
    .dest_enabled (dest_enabled),

    .src_clk (src_clk),
    .src_ext_resetn (src_ext_resetn),
    .src_resetn (src_resetn),
    .src_enable (src_enable),
    .src_enabled (src_enabled),

    .m_dest_axi_aclk (m_dest_axi_aclk),
    .m_dest_axi_aresetn (m_dest_axi_aresetn),
    .m_src_axi_aclk (m_src_axi_aclk),
    .m_src_axi_aresetn (m_src_axi_aresetn),

    .m_axi_awvalid (m_axi_awvalid),
    .m_axi_awready (m_axi_awready),
    .m_axi_awaddr (m_axi_awaddr),
    .m_axi_awlen (m_axi_awlen),
    .m_axi_awsize (m_axi_awsize),
    .m_axi_awburst (m_axi_awburst),
    .m_axi_awprot (m_axi_awprot),
    .m_axi_awcache (m_axi_awcache),

    .m_axi_wvalid (m_axi_wvalid),
    .m_axi_wready (m_axi_wready),
    .m_axi_wdata (m_axi_wdata),
    .m_axi_wstrb (m_axi_wstrb),
    .m_axi_wlast (m_axi_wlast),

    .m_axi_bvalid (m_axi_bvalid),
    .m_axi_bready (m_axi_bready),
    .m_axi_bresp (m_axi_bresp),

    .m_axi_arvalid (m_axi_arvalid),
    .m_axi_arready (m_axi_arready),
    .m_axi_araddr (m_axi_araddr),
    .m_axi_arlen (m_axi_arlen),
    .m_axi_arsize (m_axi_arsize),
    .m_axi_arburst (m_axi_arburst),
    .m_axi_arprot (m_axi_arprot),
    .m_axi_arcache (m_axi_arcache),

    .m_axi_rready (m_axi_rready),
    .m_axi_rvalid (m_axi_rvalid),
    .m_axi_rdata (m_axi_rdata),
    .m_axi_rlast (m_axi_rlast),
    .m_axi_rresp (m_axi_rresp),

    .s_axis_aclk (s_axis_aclk),
    .s_axis_ready (s_axis_ready),
    .s_axis_valid (s_axis_valid),
    .s_axis_data (s_axis_data),
    .s_axis_user (s_axis_user),
    .s_axis_last (s_axis_last),
    .s_axis_xfer_req (s_axis_xfer_req),

    .m_axis_aclk (m_axis_aclk),
    .m_axis_ready (m_axis_ready),
    .m_axis_valid (m_axis_valid),
    .m_axis_data (m_axis_data),
    .m_axis_user (m_axis_user),
    .m_axis_last (m_axis_last),
    .m_axis_xfer_req (m_axis_xfer_req),

    .fifo_wr_clk (fifo_wr_clk),
    .fifo_wr_en (fifo_wr_en),
    .fifo_wr_din (fifo_wr_din),
    .fifo_wr_overflow (fifo_wr_overflow),
    .fifo_wr_xfer_req (fifo_wr_xfer_req),

    .fifo_rd_clk (fifo_rd_clk),
    .fifo_rd_en (fifo_rd_en),
    .fifo_rd_valid (fifo_rd_valid),
    .fifo_rd_dout (fifo_rd_dout),
    .fifo_rd_underflow (fifo_rd_underflow),
    .fifo_rd_xfer_req (fifo_rd_xfer_req),

    .dbg_dest_request_id (dbg_dest_request_id),
    .dbg_dest_address_id (dbg_dest_address_id),
    .dbg_dest_data_id (dbg_dest_data_id),
    .dbg_dest_response_id (dbg_dest_response_id),
    .dbg_src_request_id (dbg_src_request_id),
    .dbg_src_address_id (dbg_src_address_id),
    .dbg_src_data_id (dbg_src_data_id),
    .dbg_src_response_id (dbg_src_response_id),

    .src_ext_sync (src_ext_sync),
    .dest_ext_sync (dest_ext_sync),

    .ext_sync_ready (ext_sync_ready),
    .ext_sync_valid (ext_sync_valid),

    .dest_diag_level_bursts(dest_diag_level_bursts));

endmodule
