// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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

// This IP serves as storage interfacing element for external memories like
// HBM or DDR4 which have AXI3 or AXI4 data interfaces.
//
// The core leverages the axi_dmac as building blocks by merging an array of
// simplex DMA channels into duplex AXI channels. The core will split the
// incoming data from the source AXIS interface to multiple AXI channels,
// and in the read phase will merge the multiple AXI channels into a single
// AXIS destination interface.
// The number of duplex channels is set by syntheses parameter and must be
// set with the ratio of AXIS and AXI3/4 interface.
//
// Underflow or Overflow conditions are reported back to the data offload
// through the control/status interface.
//

// Constraints:
//   min(SRC_DATA_WIDTH,DST_DATA_WIDTH) / NUM_M >= 8
//   In case multiple AXI channels are used the source and destination AXIS
//   interfaces widths must match.

`timescale 1ns/100ps

module util_hbm #(
  parameter TX_RX_N = 1,

  parameter SRC_DATA_WIDTH = 512,
  parameter DST_DATA_WIDTH = 512,

  parameter LENGTH_WIDTH = 32,

  // Memory interface parameters
  parameter AXI_PROTOCOL = 0,   // 0 - AXI4 ;  1 - AXI3
  parameter AXI_DATA_WIDTH = 256,
  parameter AXI_ADDR_WIDTH = 32,

  parameter MEM_TYPE = 2,  // 1 - DDR ; 2 - HBM

  // This will size the storage per master where each segment is 256MB
  parameter HBM_SEGMENTS_PER_MASTER = 4,
  parameter HBM_SEGMENT_INDEX = 0,

  // DDR parameters
  parameter DDR_BASE_ADDDRESS = 0,

  // Number of AXI masters
  parameter NUM_M = 2,

  // Data mover parameters
  parameter SRC_FIFO_SIZE = 8, // In AXI bursts
  parameter DST_FIFO_SIZE = 8
) (
  input                                    wr_request_enable,
  input                                    wr_request_valid,
  output                                   wr_request_ready,
  input   [LENGTH_WIDTH-1:0]               wr_request_length,
  output  [LENGTH_WIDTH-1:0]               wr_response_measured_length,
  output  reg                              wr_response_eot = 1'b0,
  output                                   wr_overflow,

  input                                    rd_request_enable,
  input                                    rd_request_valid,
  output                                   rd_request_ready,
  input   [LENGTH_WIDTH-1:0]               rd_request_length,
  output  reg                              rd_response_eot = 1'b0,
  output                                   rd_underflow,

  // Slave streaming AXI interface
  input                                    s_axis_aclk,
  input                                    s_axis_aresetn,
  output                                   s_axis_ready,
  input                                    s_axis_valid,
  input  [SRC_DATA_WIDTH-1:0]              s_axis_data,
  input  [SRC_DATA_WIDTH/8-1:0]            s_axis_strb,
  input  [SRC_DATA_WIDTH/8-1:0]            s_axis_keep,
  input  [0:0]                             s_axis_user,
  input                                    s_axis_last,

  // Master streaming AXI interface
  input                                    m_axis_aclk,
  input                                    m_axis_aresetn,
  input                                    m_axis_ready,
  output                                   m_axis_valid,
  output [DST_DATA_WIDTH-1:0]              m_axis_data,
  output [DST_DATA_WIDTH/8-1:0]            m_axis_strb,
  output [DST_DATA_WIDTH/8-1:0]            m_axis_keep,
  output [0:0]                             m_axis_user,
  output                                   m_axis_last,

  // Master AXI3 interface
  input                                    m_axi_aclk,
  input                                    m_axi_aresetn,

  // Write address
  output [NUM_M*AXI_ADDR_WIDTH-1:0]        m_axi_awaddr,
  output [NUM_M*(8-(4*AXI_PROTOCOL))-1:0]  m_axi_awlen,
  output [NUM_M*3-1:0]                     m_axi_awsize,
  output [NUM_M*2-1:0]                     m_axi_awburst,
  output [NUM_M-1:0]                       m_axi_awvalid,
  input  [NUM_M-1:0]                       m_axi_awready,

  // Write data
  output [NUM_M*AXI_DATA_WIDTH-1:0]        m_axi_wdata,
  output [NUM_M*(AXI_DATA_WIDTH/8)-1:0]    m_axi_wstrb,
  input  [NUM_M-1:0]                       m_axi_wready,
  output [NUM_M-1:0]                       m_axi_wvalid,
  output [NUM_M-1:0]                       m_axi_wlast,

  // Write response
  input  [NUM_M-1:0]                       m_axi_bvalid,
  input  [NUM_M*2-1:0]                     m_axi_bresp,
  output [NUM_M-1:0]                       m_axi_bready,

  // Read address
  input  [NUM_M-1:0]                       m_axi_arready,
  output [NUM_M-1:0]                       m_axi_arvalid,
  output [NUM_M*AXI_ADDR_WIDTH-1:0]        m_axi_araddr,
  output [NUM_M*(8-(4*AXI_PROTOCOL))-1:0]  m_axi_arlen,
  output [NUM_M*3-1:0]                     m_axi_arsize,
  output [NUM_M*2-1:0]                     m_axi_arburst,

  // Read data and response
  input  [NUM_M*AXI_DATA_WIDTH-1:0]        m_axi_rdata,
  output [NUM_M-1:0]                       m_axi_rready,
  input  [NUM_M-1:0]                       m_axi_rvalid,
  input  [NUM_M*2-1:0]                     m_axi_rresp,
  input  [NUM_M-1:0]                       m_axi_rlast
);

  localparam DMA_TYPE_AXI_MM = 0;
  localparam DMA_TYPE_AXI_STREAM = 1;
  localparam DMA_TYPE_FIFO = 2;

  localparam SRC_DATA_WIDTH_PER_M = SRC_DATA_WIDTH / NUM_M;
  localparam DST_DATA_WIDTH_PER_M = DST_DATA_WIDTH / NUM_M;

  localparam AXI_BYTES_PER_BEAT_WIDTH = $clog2(AXI_DATA_WIDTH/8);
  localparam SRC_BYTES_PER_BEAT_WIDTH = $clog2(SRC_DATA_WIDTH_PER_M/8);
  localparam DST_BYTES_PER_BEAT_WIDTH = $clog2(DST_DATA_WIDTH_PER_M/8);

  // Size bursts to the max possible size
  //  AXI 3 1 burst is 16 beats
  //  AXI 4 1 burst is 256 beats
  // Limit one burst to 4096 bytes
  localparam MAX_BYTES_PER_BURST = (AXI_PROTOCOL ? 16 : 256) * AXI_DATA_WIDTH/8;
  localparam MAX_BYTES_PER_BURST_LMT = MAX_BYTES_PER_BURST >= 4096 ? 4096 :
                                       MAX_BYTES_PER_BURST;
  localparam BYTES_PER_BURST_WIDTH = $clog2(MAX_BYTES_PER_BURST_LMT);

  localparam AXI_ALEN = (8-(4*AXI_PROTOCOL));

  localparam NUM_M_LOG2 = $clog2(NUM_M);

  genvar i;

  wire [NUM_M-1:0] wr_request_ready_loc;
  wire [NUM_M-1:0] rd_request_ready_loc;
  wire [NUM_M-1:0] wr_request_eot_loc;
  wire [NUM_M-1:0] rd_request_eot_loc;
  wire [NUM_M-1:0] rd_response_valid_loc;
  wire [NUM_M-1:0] wr_response_valid_loc;
  wire             wr_eot_pending_all;
  wire             rd_eot_pending_all;

  assign wr_request_ready = &wr_request_ready_loc;
  assign rd_request_ready = &rd_request_ready_loc;

  // Aggregate end of transfer from all masters
  reg [NUM_M-1:0] wr_eot_pending = {NUM_M{1'b0}};
  reg [NUM_M-1:0] rd_eot_pending = {NUM_M{1'b0}};

  assign wr_eot_pending_all = &wr_eot_pending;
  assign rd_eot_pending_all = &rd_eot_pending;

  wire [NUM_M-1:0] s_axis_ready_loc;
  assign s_axis_ready = &s_axis_ready_loc;

  wire [NUM_M-1:0] m_axis_last_loc;
  assign m_axis_last = &m_axis_last_loc;

  wire [NUM_M-1:0] m_axis_valid_loc;
  assign m_axis_valid = &m_axis_valid_loc;

  wire [NUM_M-1:0] wr_response_ready_loc;
  wire [NUM_M-1:0] rd_response_ready_loc;

  wire [NUM_M-1:0] wr_overflow_loc;
  wire [NUM_M-1:0] rd_underflow_loc;

  // Measure stored data in case transfer is shorter than programmed,
  //  do the measurement only with the first master, all others should be
  //  similar.
  localparam LW_PER_M = LENGTH_WIDTH-NUM_M_LOG2;
  wire [NUM_M*BYTES_PER_BURST_WIDTH-1:0] wr_measured_burst_length;
  reg [LW_PER_M-1:0] wr_response_measured_length_per_m = 'h0;
  always @(posedge s_axis_aclk) begin
    if (wr_request_enable == 1'b0) begin
      wr_response_measured_length_per_m <= {LW_PER_M{1'h0}};
    end else if (wr_response_valid_loc[0] == 1'b1 && wr_response_ready_loc[0] == 1'b1) begin
      wr_response_measured_length_per_m <= wr_response_measured_length_per_m +
        {{LW_PER_M-BYTES_PER_BURST_WIDTH{1'b0}},wr_measured_burst_length[BYTES_PER_BURST_WIDTH-1:0]} +
        {{LW_PER_M-1{1'b0}},~wr_request_eot_loc[0]};
    end else if (wr_response_eot == 1'b1) begin
      wr_response_measured_length_per_m <= {LW_PER_M{1'h0}};
    end
  end
  assign wr_response_measured_length = {wr_response_measured_length_per_m,{NUM_M_LOG2{1'b1}}};

  always @(posedge s_axis_aclk) begin
    wr_response_eot <= wr_eot_pending_all;
  end

  always @(posedge m_axis_aclk) begin
    rd_response_eot <= rd_eot_pending_all;
  end

  generate
  for (i = 0; i < NUM_M; i=i+1) begin

    wire [11:0] rd_dbg_status;
    wire rd_needs_reset;
    wire s_axis_xfer_req;
    wire m_axis_xfer_req;

    reg rd_needs_reset_d = 1'b0;

    // 2Gb (256MB) per segment
    localparam ADDR_OFFSET = (MEM_TYPE == 1) ? DDR_BASE_ADDDRESS :
       (HBM_SEGMENT_INDEX+i) * HBM_SEGMENTS_PER_MASTER * 256 * 1024 * 1024 ;

    always @(posedge s_axis_aclk) begin
      if (wr_eot_pending_all) begin
        wr_eot_pending[i] <= 1'b0;
      end else if (wr_request_eot_loc[i] & wr_response_valid_loc[i]) begin
        wr_eot_pending[i] <= 1'b1;
      end
    end

    // For last burst wait until all masters are done
    assign wr_response_ready_loc[i] = wr_request_eot_loc[i] ? wr_eot_pending_all : wr_response_valid_loc[i];

    // Overflow whenever s_axis_ready deasserts during capture (RX_PATH)
    assign wr_overflow_loc[i] =  TX_RX_N[0] ? 1'b0 : s_axis_xfer_req & ~s_axis_ready_loc[i];

    // AXIS to AXI3
    axi_dmac_transfer #(
      .DMA_DATA_WIDTH_SRC(SRC_DATA_WIDTH_PER_M),
      .DMA_DATA_WIDTH_DEST(AXI_DATA_WIDTH),
      .DMA_LENGTH_WIDTH(LENGTH_WIDTH),
      .DMA_LENGTH_ALIGN(SRC_BYTES_PER_BEAT_WIDTH),
      .BYTES_PER_BEAT_WIDTH_DEST(AXI_BYTES_PER_BEAT_WIDTH),
      .BYTES_PER_BEAT_WIDTH_SRC(SRC_BYTES_PER_BEAT_WIDTH),
      .BYTES_PER_BURST_WIDTH(BYTES_PER_BURST_WIDTH),
      .DMA_TYPE_DEST(DMA_TYPE_AXI_MM),
      .DMA_TYPE_SRC(DMA_TYPE_AXI_STREAM),
      .DMA_AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
      .DMA_2D_TRANSFER(1'b0),
      .ASYNC_CLK_REQ_SRC(0),
      .ASYNC_CLK_SRC_DEST(1),
      .ASYNC_CLK_DEST_REQ(1),
      .AXI_SLICE_DEST(1),
      .AXI_SLICE_SRC(1),
      .MAX_BYTES_PER_BURST(MAX_BYTES_PER_BURST_LMT),
      .FIFO_SIZE(SRC_FIFO_SIZE),
      .ID_WIDTH($clog2(SRC_FIFO_SIZE)),
      .AXI_LENGTH_WIDTH_SRC(8-(4*AXI_PROTOCOL)),
      .AXI_LENGTH_WIDTH_DEST(8-(4*AXI_PROTOCOL)),
      .ENABLE_DIAGNOSTICS_IF(0),
      .ALLOW_ASYM_MEM(1)
    ) i_wr_transfer (
      .ctrl_clk(s_axis_aclk),
      .ctrl_resetn(s_axis_aresetn),

       // Control interface
      .ctrl_enable(wr_request_enable),
      .ctrl_pause(1'b0),
      .ctrl_hwdesc(1'b0),

      .req_valid(wr_request_valid),
      .req_ready(wr_request_ready_loc[i]),
      .req_dest_address(ADDR_OFFSET[AXI_ADDR_WIDTH-1:AXI_BYTES_PER_BEAT_WIDTH]),
      .req_src_address('h0),
      .req_sg_address('h0),
      .req_x_length(wr_request_length >> NUM_M_LOG2),
      .req_y_length(0),
      .req_dest_stride(0),
      .req_src_stride(0),
      .req_sync_transfer_start(1'b0),
      .req_last(1'b1),

      .req_eot(wr_request_eot_loc[i]),
      .req_sg_desc_id(),
      .req_measured_burst_length(wr_measured_burst_length[BYTES_PER_BURST_WIDTH*i+:BYTES_PER_BURST_WIDTH]),
      .req_response_partial(),
      .req_response_valid(wr_response_valid_loc[i]),
      .req_response_ready(wr_response_ready_loc[i]),

      .m_dest_axi_aclk(m_axi_aclk),
      .m_dest_axi_aresetn(m_axi_aresetn),
      .m_src_axi_aclk(1'b0),
      .m_src_axi_aresetn(1'b0),
      .m_sg_axi_aclk(1'b0),
      .m_sg_axi_aresetn(1'b0),

      .m_axi_awaddr(m_axi_awaddr[AXI_ADDR_WIDTH*i+:AXI_ADDR_WIDTH]),
      .m_axi_awlen(m_axi_awlen[AXI_ALEN*i+:AXI_ALEN]),
      .m_axi_awsize(m_axi_awsize[3*i+:3]),
      .m_axi_awburst(m_axi_awburst[2*i+:2]),
      .m_axi_awprot(),
      .m_axi_awcache(),
      .m_axi_awvalid(m_axi_awvalid[i]),
      .m_axi_awready(m_axi_awready[i]),

      .m_axi_wdata(m_axi_wdata[AXI_DATA_WIDTH*i+:AXI_DATA_WIDTH]),
      .m_axi_wstrb(m_axi_wstrb[(AXI_DATA_WIDTH/8)*i+:(AXI_DATA_WIDTH/8)]),
      .m_axi_wready(m_axi_wready[i]),
      .m_axi_wvalid(m_axi_wvalid[i]),
      .m_axi_wlast(m_axi_wlast[i]),

      .m_axi_bvalid(m_axi_bvalid[i]),
      .m_axi_bresp(m_axi_bresp[2*i+:2]),
      .m_axi_bready(m_axi_bready[i]),

      .m_axi_arready(1'b0),
      .m_axi_arvalid(),
      .m_axi_araddr(),
      .m_axi_arlen(),
      .m_axi_arsize(),
      .m_axi_arburst(),
      .m_axi_arprot(),
      .m_axi_arcache(),

      .m_axi_rdata('h0),
      .m_axi_rlast(1'b0),
      .m_axi_rready(),
      .m_axi_rvalid(1'b0),
      .m_axi_rresp(2'b00),

      .m_sg_axi_arready(1'b0),
      .m_sg_axi_arvalid(),
      .m_sg_axi_araddr(),
      .m_sg_axi_arlen(),
      .m_sg_axi_arsize(),
      .m_sg_axi_arburst(),
      .m_sg_axi_arprot(),
      .m_sg_axi_arcache(),

      .m_sg_axi_rdata('h0),
      .m_sg_axi_rlast(1'b0),
      .m_sg_axi_rready(),
      .m_sg_axi_rvalid(1'b0),
      .m_sg_axi_rresp(2'b00),

      .s_axis_aclk(s_axis_aclk),
      .s_axis_ready(s_axis_ready_loc[i]),
      .s_axis_valid(s_axis_valid),
      .s_axis_data(s_axis_data[SRC_DATA_WIDTH_PER_M*i+:SRC_DATA_WIDTH_PER_M]),
      .s_axis_user(s_axis_user),
      .s_axis_last(s_axis_last),
      .s_axis_xfer_req(s_axis_xfer_req),

      .m_axis_aclk(1'b0),
      .m_axis_ready(1'b1),
      .m_axis_valid(),
      .m_axis_data(),
      .m_axis_last(),
      .m_axis_xfer_req(),

      .fifo_wr_clk(1'b0),
      .fifo_wr_en(1'b0),
      .fifo_wr_din('b0),
      .fifo_wr_overflow(),
      .fifo_wr_sync(),
      .fifo_wr_xfer_req(),

      .fifo_rd_clk(1'b0),
      .fifo_rd_en(1'b0),
      .fifo_rd_valid(),
      .fifo_rd_dout(),
      .fifo_rd_underflow(),
      .fifo_rd_xfer_req(),

      // DBG
      .dbg_dest_request_id(),
      .dbg_dest_address_id(),
      .dbg_dest_data_id(),
      .dbg_dest_response_id(),
      .dbg_src_request_id(),
      .dbg_src_address_id(),
      .dbg_src_data_id(),
      .dbg_src_response_id(),
      .dbg_status(),

      .dest_diag_level_bursts());

    always @(posedge m_axis_aclk) begin
      rd_needs_reset_d <= rd_needs_reset;
    end

    // Generate an end of transfer at the end of flush marked by rd_needs_reset
    always @(posedge m_axis_aclk) begin
      if (rd_eot_pending_all) begin
        rd_eot_pending[i] <= 1'b0;
      end else if ((rd_request_eot_loc[i] & rd_response_valid_loc[i]) ||
                   (~rd_needs_reset & rd_needs_reset_d)) begin
        rd_eot_pending[i] <= 1'b1;
      end
    end

    assign rd_response_ready_loc[i] = rd_request_eot_loc[i] ? rd_eot_pending_all : rd_response_valid_loc[i];

    // Underflow whenever m_axis_valid deasserts during play (TX_PATH)
    assign rd_underflow_loc[i] = ~TX_RX_N[0] ? 1'b0 : m_axis_xfer_req & m_axis_ready & ~m_axis_valid_loc[i];

    // AXI3 to MAXIS
    axi_dmac_transfer #(
      .DMA_DATA_WIDTH_SRC(AXI_DATA_WIDTH),
      .DMA_DATA_WIDTH_DEST(DST_DATA_WIDTH_PER_M),
      .DMA_LENGTH_WIDTH(LENGTH_WIDTH),
      .DMA_LENGTH_ALIGN(DST_BYTES_PER_BEAT_WIDTH),
      .BYTES_PER_BEAT_WIDTH_DEST(DST_BYTES_PER_BEAT_WIDTH),
      .BYTES_PER_BEAT_WIDTH_SRC(AXI_BYTES_PER_BEAT_WIDTH),
      .BYTES_PER_BURST_WIDTH(BYTES_PER_BURST_WIDTH),
      .DMA_TYPE_DEST(DMA_TYPE_AXI_STREAM),
      .DMA_TYPE_SRC(DMA_TYPE_AXI_MM),
      .DMA_AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
      .DMA_2D_TRANSFER(1'b0),
      .ASYNC_CLK_REQ_SRC(1),
      .ASYNC_CLK_SRC_DEST(1),
      .ASYNC_CLK_DEST_REQ(0),
      .AXI_SLICE_DEST(1),
      .AXI_SLICE_SRC(1),
      .MAX_BYTES_PER_BURST(MAX_BYTES_PER_BURST_LMT),
      .FIFO_SIZE(DST_FIFO_SIZE),
      .ID_WIDTH($clog2(DST_FIFO_SIZE)),
      .AXI_LENGTH_WIDTH_SRC(8-(4*AXI_PROTOCOL)),
      .AXI_LENGTH_WIDTH_DEST(8-(4*AXI_PROTOCOL)),
      .ENABLE_DIAGNOSTICS_IF(0),
      .ALLOW_ASYM_MEM(1)
    ) i_rd_transfer (
      .ctrl_clk(m_axis_aclk),
      .ctrl_resetn(m_axis_aresetn),

       // Control interface
      .ctrl_enable(rd_request_enable),
      .ctrl_pause(1'b0),
      .ctrl_hwdesc(1'b0),

      .req_valid(rd_request_valid),
      .req_ready(rd_request_ready_loc[i]),
      .req_dest_address(0),
      .req_src_address(ADDR_OFFSET[AXI_ADDR_WIDTH-1:AXI_BYTES_PER_BEAT_WIDTH]),
      .req_sg_address('h0),
      .req_x_length(rd_request_length >> NUM_M_LOG2),
      .req_y_length(0),
      .req_dest_stride(0),
      .req_src_stride(0),
      .req_sync_transfer_start(1'b0),
      .req_last(1'b1),

      .req_eot(rd_request_eot_loc[i]),
      .req_sg_desc_id(),
      .req_measured_burst_length(),
      .req_response_partial(),
      .req_response_valid(rd_response_valid_loc[i]),
      .req_response_ready(rd_response_ready_loc[i]),

      .m_dest_axi_aclk(1'b0),
      .m_dest_axi_aresetn(1'b0),
      .m_src_axi_aclk(m_axi_aclk),
      .m_src_axi_aresetn(m_axi_aresetn),
      .m_sg_axi_aclk(1'b0),
      .m_sg_axi_aresetn(1'b0),

      .m_axi_awaddr(),
      .m_axi_awlen(),
      .m_axi_awsize(),
      .m_axi_awburst(),
      .m_axi_awprot(),
      .m_axi_awcache(),
      .m_axi_awvalid(),
      .m_axi_awready(1'b1),

      .m_axi_wdata(),
      .m_axi_wstrb(),
      .m_axi_wready(1'b1),
      .m_axi_wvalid(),
      .m_axi_wlast(),

      .m_axi_bvalid(1'b0),
      .m_axi_bresp(),
      .m_axi_bready(),

      .m_axi_arready(m_axi_arready[i]),
      .m_axi_arvalid(m_axi_arvalid[i]),
      .m_axi_araddr(m_axi_araddr[AXI_ADDR_WIDTH*i+:AXI_ADDR_WIDTH]),
      .m_axi_arlen(m_axi_arlen[AXI_ALEN*i+:AXI_ALEN]),
      .m_axi_arsize(m_axi_arsize[3*i+:3]),
      .m_axi_arburst(m_axi_arburst[2*i+:2]),
      .m_axi_arprot(),
      .m_axi_arcache(),

      .m_axi_rdata(m_axi_rdata[AXI_DATA_WIDTH*i+:AXI_DATA_WIDTH]),
      .m_axi_rlast(m_axi_rlast[i]),
      .m_axi_rready(m_axi_rready[i]),
      .m_axi_rvalid(m_axi_rvalid[i]),
      .m_axi_rresp(m_axi_rresp[2*i+:2]),

      .m_sg_axi_arready (1'b0),
      .m_sg_axi_arvalid (),
      .m_sg_axi_araddr (),
      .m_sg_axi_arlen (),
      .m_sg_axi_arsize (),
      .m_sg_axi_arburst (),
      .m_sg_axi_arprot (),
      .m_sg_axi_arcache (),

      .m_sg_axi_rdata ('h0),
      .m_sg_axi_rlast (1'b0),
      .m_sg_axi_rready (),
      .m_sg_axi_rvalid (1'b0),
      .m_sg_axi_rresp (2'b00),

      .s_axis_aclk(1'b0),
      .s_axis_ready(),
      .s_axis_valid(1'b0),
      .s_axis_data(),
      .s_axis_user(),
      .s_axis_last(),
      .s_axis_xfer_req(),

      .m_axis_aclk(m_axis_aclk),
      .m_axis_ready((m_axis_ready & m_axis_valid) | rd_needs_reset),
      .m_axis_valid(m_axis_valid_loc[i]),
      .m_axis_data(m_axis_data[DST_DATA_WIDTH_PER_M*i+:DST_DATA_WIDTH_PER_M]),
      .m_axis_last(m_axis_last_loc[i]),
      .m_axis_xfer_req(m_axis_xfer_req),

      .fifo_wr_clk(1'b0),
      .fifo_wr_en(1'b0),
      .fifo_wr_din('b0),
      .fifo_wr_overflow(),
      .fifo_wr_sync(),
      .fifo_wr_xfer_req(),

      .fifo_rd_clk(1'b0),
      .fifo_rd_en(1'b0),
      .fifo_rd_valid(),
      .fifo_rd_dout(),
      .fifo_rd_underflow(),
      .fifo_rd_xfer_req(),

      // DBG
      .dbg_dest_request_id(),
      .dbg_dest_address_id(),
      .dbg_dest_data_id(),
      .dbg_dest_response_id(),
      .dbg_src_request_id(),
      .dbg_src_address_id(),
      .dbg_src_data_id(),
      .dbg_src_response_id(),
      .dbg_status(rd_dbg_status),

      .dest_diag_level_bursts());

    assign rd_needs_reset = rd_dbg_status[11];

  end
  endgenerate

  assign wr_overflow = |wr_overflow_loc;

  assign rd_underflow = |rd_underflow_loc;

endmodule
