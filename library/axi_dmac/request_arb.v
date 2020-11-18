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

module dmac_request_arb #(
  parameter DMA_DATA_WIDTH_SRC = 64,
  parameter DMA_DATA_WIDTH_DEST = 64,
  parameter DMA_LENGTH_WIDTH = 24,
  parameter DMA_LENGTH_ALIGN = 3,
  parameter BYTES_PER_BEAT_WIDTH_DEST = $clog2(DMA_DATA_WIDTH_DEST/8),
  parameter BYTES_PER_BEAT_WIDTH_SRC = $clog2(DMA_DATA_WIDTH_SRC/8),
  parameter DMA_TYPE_DEST = 0,
  parameter DMA_TYPE_SRC = 2,
  parameter DMA_AXI_ADDR_WIDTH = 32,
  parameter ASYNC_CLK_REQ_SRC = 1,
  parameter ASYNC_CLK_SRC_DEST = 1,
  parameter ASYNC_CLK_DEST_REQ = 1,
  parameter AXI_SLICE_DEST = 0,
  parameter AXI_SLICE_SRC = 0,
  parameter MAX_BYTES_PER_BURST = 128,
  parameter BYTES_PER_BURST_WIDTH = 7,
  parameter FIFO_SIZE = 8,
  parameter ID_WIDTH = $clog2(FIFO_SIZE*2),
  parameter AXI_LENGTH_WIDTH_SRC = 8,
  parameter AXI_LENGTH_WIDTH_DEST = 8,
  parameter ENABLE_DIAGNOSTICS_IF = 0,
  parameter ALLOW_ASYM_MEM = 0
)(
  input req_clk,
  input req_resetn,

  input req_valid,
  output req_ready,
  input [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] req_dest_address,
  input [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC] req_src_address,
  input [DMA_LENGTH_WIDTH-1:0] req_length,
  input req_xlast,
  input req_sync_transfer_start,

  output eot,
  output [BYTES_PER_BURST_WIDTH-1:0] measured_burst_length,
  output response_partial,
  output response_valid,
  input response_ready,

  output abort_req,

  // Master AXI interface
  input                               m_dest_axi_aclk,
  input                               m_dest_axi_aresetn,
  input                               m_src_axi_aclk,
  input                               m_src_axi_aresetn,

  // Write address
  output [DMA_AXI_ADDR_WIDTH-1:0]     m_axi_awaddr,
  output [AXI_LENGTH_WIDTH_DEST-1:0]  m_axi_awlen,
  output [ 2:0]                       m_axi_awsize,
  output [ 1:0]                       m_axi_awburst,
  output [ 2:0]                       m_axi_awprot,
  output [ 3:0]                       m_axi_awcache,
  output                              m_axi_awvalid,
  input                               m_axi_awready,

  // Write data
  output [DMA_DATA_WIDTH_DEST-1:0]     m_axi_wdata,
  output [(DMA_DATA_WIDTH_DEST/8)-1:0] m_axi_wstrb,
  input                                m_axi_wready,
  output                               m_axi_wvalid,
  output                               m_axi_wlast,

  // Write response
  input                               m_axi_bvalid,
  input  [ 1:0]                       m_axi_bresp,
  output                              m_axi_bready,

  // Read address
  input                               m_axi_arready,
  output                              m_axi_arvalid,
  output [DMA_AXI_ADDR_WIDTH-1:0]     m_axi_araddr,
  output [AXI_LENGTH_WIDTH_SRC-1:0]   m_axi_arlen,
  output [ 2:0]                       m_axi_arsize,
  output [ 1:0]                       m_axi_arburst,
  output [ 2:0]                       m_axi_arprot,
  output [ 3:0]                       m_axi_arcache,

  // Read data and response
  input  [DMA_DATA_WIDTH_SRC-1:0]     m_axi_rdata,
  output                              m_axi_rready,
  input                               m_axi_rvalid,
  input                               m_axi_rlast,
  input  [ 1:0]                       m_axi_rresp,

  // Slave streaming AXI interface
  input                               s_axis_aclk,
  output                              s_axis_ready,
  input                               s_axis_valid,
  input  [DMA_DATA_WIDTH_SRC-1:0]     s_axis_data,
  input                               s_axis_last,
  input  [0:0]                        s_axis_user,
  output                              s_axis_xfer_req,

  // Master streaming AXI interface
  input                               m_axis_aclk,
  input                               m_axis_ready,
  output                              m_axis_valid,
  output [DMA_DATA_WIDTH_DEST-1:0]    m_axis_data,
  output                              m_axis_last,
  output                              m_axis_xfer_req,

  // Input FIFO interface
  input                               fifo_wr_clk,
  input                               fifo_wr_en,
  input  [DMA_DATA_WIDTH_SRC-1:0]     fifo_wr_din,
  output                              fifo_wr_overflow,
  input                               fifo_wr_sync,
  output                              fifo_wr_xfer_req,

  // Input FIFO interface
  input                               fifo_rd_clk,
  input                               fifo_rd_en,
  output                              fifo_rd_valid,
  output [DMA_DATA_WIDTH_DEST-1:0]    fifo_rd_dout,
  output                              fifo_rd_underflow,
  output                              fifo_rd_xfer_req,

  output [ID_WIDTH-1:0]               dbg_dest_request_id,
  output [ID_WIDTH-1:0]               dbg_dest_address_id,
  output [ID_WIDTH-1:0]               dbg_dest_data_id,
  output [ID_WIDTH-1:0]               dbg_dest_response_id,
  output [ID_WIDTH-1:0]               dbg_src_request_id,
  output [ID_WIDTH-1:0]               dbg_src_address_id,
  output [ID_WIDTH-1:0]               dbg_src_data_id,
  output [ID_WIDTH-1:0]               dbg_src_response_id,

  input req_enable,

  output dest_clk,
  input dest_resetn,
  output dest_ext_resetn,
  input dest_enable,
  output dest_enabled,

  output src_clk,
  input src_resetn,
  output src_ext_resetn,
  input src_enable,
  output src_enabled,

  // Diagnostics interface
  output  [7:0] dest_diag_level_bursts
);

localparam DMA_TYPE_MM_AXI = 0;
localparam DMA_TYPE_STREAM_AXI = 1;
localparam DMA_TYPE_FIFO = 2;

localparam DMA_ADDRESS_WIDTH_DEST = DMA_AXI_ADDR_WIDTH - BYTES_PER_BEAT_WIDTH_DEST;
localparam DMA_ADDRESS_WIDTH_SRC = DMA_AXI_ADDR_WIDTH - BYTES_PER_BEAT_WIDTH_SRC;

// Bytes per burst is the same for both dest and src, but bytes per beat may
// differ, so beats per burst may also differ

localparam BEATS_PER_BURST_WIDTH_SRC = BYTES_PER_BURST_WIDTH - BYTES_PER_BEAT_WIDTH_SRC;
localparam BEATS_PER_BURST_WIDTH_DEST = BYTES_PER_BURST_WIDTH - BYTES_PER_BEAT_WIDTH_DEST;

localparam BURSTS_PER_TRANSFER_WIDTH = DMA_LENGTH_WIDTH - BYTES_PER_BURST_WIDTH;


reg eot_mem_src[0:2**ID_WIDTH-1];
reg eot_mem_dest[0:2**ID_WIDTH-1];
wire request_eot;
wire source_eot;

wire [ID_WIDTH-1:0] request_id;
wire [ID_WIDTH-1:0] source_id;
wire [ID_WIDTH-1:0] response_id;

wire enabled_src;
wire enabled_dest;

wire req_gen_valid;
wire req_gen_ready;
wire src_dest_valid;
wire src_dest_ready;
wire req_src_valid;
wire req_src_ready;

wire dest_req_valid;
wire dest_req_ready;
wire [DMA_ADDRESS_WIDTH_DEST-1:0] dest_req_dest_address;
wire dest_req_xlast;

wire dest_response_valid;
wire dest_response_ready;
wire [1:0] dest_response_resp;
wire dest_response_resp_eot;
wire [BYTES_PER_BURST_WIDTH-1:0] dest_response_data_burst_length;
wire dest_response_partial;

wire [ID_WIDTH-1:0] dest_request_id;
wire [ID_WIDTH-1:0] dest_data_request_id;
wire [ID_WIDTH-1:0] dest_data_response_id;
wire [ID_WIDTH-1:0] dest_response_id;

wire dest_valid;
wire dest_ready;
wire [DMA_DATA_WIDTH_DEST-1:0] dest_data;
wire [DMA_DATA_WIDTH_DEST/8-1:0] dest_strb;
wire dest_last;
wire dest_fifo_valid;
wire dest_fifo_ready;
wire [DMA_DATA_WIDTH_DEST-1:0] dest_fifo_data;
wire [DMA_DATA_WIDTH_DEST/8-1:0] dest_fifo_strb;
wire dest_fifo_last;

wire src_req_valid;
wire src_req_ready;
wire [DMA_ADDRESS_WIDTH_DEST-1:0] src_req_dest_address;
wire [DMA_ADDRESS_WIDTH_SRC-1:0] src_req_src_address;
wire [BEATS_PER_BURST_WIDTH_SRC-1:0] src_req_last_burst_length;
wire [BYTES_PER_BEAT_WIDTH_SRC-1:0] src_req_last_beat_bytes;
wire src_req_sync_transfer_start;
wire src_req_xlast;

reg [DMA_ADDRESS_WIDTH_DEST-1:0] src_req_dest_address_cur = 'h0;
reg src_req_xlast_cur = 1'b0;

/* TODO
wire src_response_valid;
wire src_response_ready;
wire src_response_empty;
wire [1:0] src_response_resp;
*/

wire [ID_WIDTH-1:0] src_request_id;
reg [ID_WIDTH-1:0] src_throttled_request_id;
wire [ID_WIDTH-1:0] src_data_request_id;
wire [ID_WIDTH-1:0] src_response_id;

wire src_valid;
wire [DMA_DATA_WIDTH_SRC-1:0] src_data;
wire [BYTES_PER_BEAT_WIDTH_SRC-1:0] src_valid_bytes;
wire src_last;
wire src_partial_burst;
wire block_descr_to_dst;
wire src_fifo_valid;
wire [DMA_DATA_WIDTH_SRC-1:0] src_fifo_data;
wire [BYTES_PER_BEAT_WIDTH_SRC-1:0] src_fifo_valid_bytes;
wire src_fifo_last;
wire src_fifo_partial_burst;

wire                                 src_bl_valid;
wire                                 src_bl_ready;
wire [BEATS_PER_BURST_WIDTH_SRC-1:0] src_burst_length;

wire [BYTES_PER_BURST_WIDTH-1:0] dest_burst_info_length;
wire                             dest_burst_info_partial;
wire [ID_WIDTH-1:0] dest_burst_info_id;
wire                dest_burst_info_write;

reg src_dest_valid_hs = 1'b0;
wire src_dest_valid_hs_masked;
wire src_dest_ready_hs;

wire req_rewind_req_valid;
wire req_rewind_req_ready;
wire [ID_WIDTH+3-1:0] req_rewind_req_data;

wire completion_req_valid;
wire completion_req_ready;
wire completion_req_last;
wire [1:0] completion_transfer_id;

wire rewind_req_valid;
wire rewind_req_ready;
wire [ID_WIDTH+3-1:0] rewind_req_data;

reg src_throttler_enabled = 1'b1;
wire src_throttler_enable;
wire rewind_state;

/* Unused for now
wire response_src_valid;
wire response_src_ready = 1'b1;
wire [1:0] response_src_resp;
*/

assign dbg_dest_request_id = dest_request_id;
assign dbg_dest_response_id = dest_response_id;
assign dbg_src_request_id = src_request_id;
assign dbg_src_response_id = src_response_id;

always @(posedge req_clk)
begin
  eot_mem_src[request_id] <= request_eot;
end

always @(posedge src_clk)
begin
  eot_mem_dest[source_id] <= source_eot;
end


generate if (DMA_TYPE_DEST == DMA_TYPE_MM_AXI) begin

wire                                  dest_bl_valid;
wire                                  dest_bl_ready;
wire [BEATS_PER_BURST_WIDTH_DEST-1:0] dest_burst_length;
wire [BEATS_PER_BURST_WIDTH_SRC-1:0] dest_src_burst_length;

assign dest_clk = m_dest_axi_aclk;
assign dest_ext_resetn = m_dest_axi_aresetn;

wire [ID_WIDTH-1:0] dest_address_id;
wire dest_address_eot = eot_mem_dest[dest_address_id];
wire dest_response_eot = eot_mem_dest[dest_response_id];

assign dbg_dest_address_id = dest_address_id;
assign dbg_dest_data_id = dest_data_response_id;

assign dest_data_request_id = dest_address_id;

dmac_dest_mm_axi #(
  .ID_WIDTH(ID_WIDTH),
  .DMA_DATA_WIDTH(DMA_DATA_WIDTH_DEST),
  .DMA_ADDR_WIDTH(DMA_AXI_ADDR_WIDTH),
  .BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH_DEST),
  .BYTES_PER_BEAT_WIDTH(BYTES_PER_BEAT_WIDTH_DEST),
  .MAX_BYTES_PER_BURST(MAX_BYTES_PER_BURST),
  .BYTES_PER_BURST_WIDTH(BYTES_PER_BURST_WIDTH),
  .AXI_LENGTH_WIDTH(AXI_LENGTH_WIDTH_DEST)
) i_dest_dma_mm (
  .m_axi_aclk(m_dest_axi_aclk),
  .m_axi_aresetn(dest_resetn),

  .enable(dest_enable),
  .enabled(dest_enabled),

  .req_valid(dest_req_valid),
  .req_ready(dest_req_ready),
  .req_address(dest_req_dest_address),

  .bl_valid(dest_bl_valid),
  .bl_ready(dest_bl_ready),
  .measured_last_burst_length(dest_burst_length),

  .response_valid(dest_response_valid),
  .response_ready(dest_response_ready),
  .response_resp(dest_response_resp),
  .response_resp_eot(dest_response_resp_eot),
  .response_resp_partial(dest_response_partial),
  .response_data_burst_length(dest_response_data_burst_length),

  .request_id(dest_request_id),
  .response_id(dest_response_id),

  .address_id(dest_address_id),

  .address_eot(dest_address_eot),
  .response_eot(dest_response_eot),

  .fifo_valid(dest_valid),
  .fifo_ready(dest_ready),
  .fifo_data(dest_data),
  .fifo_strb(dest_strb),
  .fifo_last(dest_last),

  .dest_burst_info_length(dest_burst_info_length),
  .dest_burst_info_partial(dest_burst_info_partial),
  .dest_burst_info_id(dest_burst_info_id),
  .dest_burst_info_write(dest_burst_info_write),

  .m_axi_awready(m_axi_awready),
  .m_axi_awvalid(m_axi_awvalid),
  .m_axi_awaddr(m_axi_awaddr),
  .m_axi_awlen(m_axi_awlen),
  .m_axi_awsize(m_axi_awsize),
  .m_axi_awburst(m_axi_awburst),
  .m_axi_awprot(m_axi_awprot),
  .m_axi_awcache(m_axi_awcache),
  .m_axi_wready(m_axi_wready),
  .m_axi_wvalid(m_axi_wvalid),
  .m_axi_wdata(m_axi_wdata),
  .m_axi_wstrb(m_axi_wstrb),
  .m_axi_wlast(m_axi_wlast),

  .m_axi_bvalid(m_axi_bvalid),
  .m_axi_bresp(m_axi_bresp),
  .m_axi_bready(m_axi_bready)
);

util_axis_fifo #(
  .DATA_WIDTH(BEATS_PER_BURST_WIDTH_SRC),
  .ADDRESS_WIDTH(0),
  .ASYNC_CLK(ASYNC_CLK_SRC_DEST)
) i_src_dest_bl_fifo (
  .s_axis_aclk(src_clk),
  .s_axis_aresetn(src_resetn),
  .s_axis_valid(src_bl_valid),
  .s_axis_ready(src_bl_ready),
  .s_axis_full(),
  .s_axis_data(src_burst_length),
  .s_axis_room(),

  .m_axis_aclk(dest_clk),
  .m_axis_aresetn(dest_resetn),
  .m_axis_valid(dest_bl_valid),
  .m_axis_ready(dest_bl_ready),
  .m_axis_data(dest_src_burst_length),
  .m_axis_level(),
  .m_axis_empty()
);

// Adapt burst length from source width to destination width by either
// truncation or completion with ones.
if (BEATS_PER_BURST_WIDTH_SRC == BEATS_PER_BURST_WIDTH_DEST) begin
assign dest_burst_length = dest_src_burst_length;
end

if (BEATS_PER_BURST_WIDTH_SRC < BEATS_PER_BURST_WIDTH_DEST) begin
assign dest_burst_length = {dest_src_burst_length,
                           {BEATS_PER_BURST_WIDTH_DEST - BEATS_PER_BURST_WIDTH_SRC{1'b1}}};
end

if (BEATS_PER_BURST_WIDTH_SRC > BEATS_PER_BURST_WIDTH_DEST) begin
assign dest_burst_length = dest_src_burst_length[BEATS_PER_BURST_WIDTH_SRC-1 -: BEATS_PER_BURST_WIDTH_DEST];
end

end else begin

assign m_axi_awvalid = 1'b0;
assign m_axi_awaddr = 'h00;
assign m_axi_awlen = 'h00;
assign m_axi_awsize = 'h00;
assign m_axi_awburst = 'h00;
assign m_axi_awprot = 'h00;
assign m_axi_awcache = 'h00;

assign m_axi_wvalid = 1'b0;
assign m_axi_wdata = 'h00;
assign m_axi_wstrb = 'h00;
assign m_axi_wlast = 1'b0;

assign m_axi_bready = 1'b0;

assign src_bl_ready = 1'b1;

assign dest_response_partial = 1'b0;
assign dest_response_data_burst_length = 'h0;

end

if (DMA_TYPE_DEST == DMA_TYPE_STREAM_AXI) begin

assign dest_clk = m_axis_aclk;
assign dest_ext_resetn = 1'b1;

wire [ID_WIDTH-1:0] data_id;

wire data_eot = eot_mem_dest[data_id];
wire response_eot = eot_mem_dest[dest_response_id];

assign dest_data_request_id = dest_request_id;

assign dbg_dest_address_id = 'h00;
assign dbg_dest_data_id = data_id;


dmac_dest_axi_stream #(
  .ID_WIDTH(ID_WIDTH),
  .S_AXIS_DATA_WIDTH(DMA_DATA_WIDTH_DEST),
  .BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH_DEST)
) i_dest_dma_stream (
  .s_axis_aclk(m_axis_aclk),
  .s_axis_aresetn(dest_resetn),

  .enable(dest_enable),
  .enabled(dest_enabled),

  .req_valid(dest_req_valid),
  .req_ready(dest_req_ready),
  .req_xlast(dest_req_xlast),

  .response_valid(dest_response_valid),
  .response_ready(dest_response_ready),
  .response_resp(dest_response_resp),
  .response_resp_eot(dest_response_resp_eot),

  .response_id(dest_response_id),
  .data_id(data_id),
  .xfer_req(m_axis_xfer_req),

  .data_eot(data_eot),
  .response_eot(response_eot),

  .fifo_valid(dest_valid),
  .fifo_ready(dest_ready),
  .fifo_data(dest_data),
  .fifo_last(dest_last),

  .m_axis_valid(m_axis_valid),
  .m_axis_ready(m_axis_ready),
  .m_axis_data(m_axis_data),
  .m_axis_last(m_axis_last)
);

end else begin

assign m_axis_valid = 1'b0;
assign m_axis_last = 1'b0;
assign m_axis_xfer_req = 1'b0;
assign m_axis_data = 'h00;

end

if (DMA_TYPE_DEST == DMA_TYPE_FIFO) begin

assign dest_clk = fifo_rd_clk;
assign dest_ext_resetn = 1'b1;

wire [ID_WIDTH-1:0] data_id;

wire data_eot = eot_mem_dest[data_id];
wire response_eot = eot_mem_dest[dest_response_id];

assign dest_data_request_id = dest_request_id;

assign dbg_dest_address_id = 'h00;
assign dbg_dest_data_id = data_id;

dmac_dest_fifo_inf #(
  .ID_WIDTH(ID_WIDTH),
  .DATA_WIDTH(DMA_DATA_WIDTH_DEST),
  .BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH_DEST)
) i_dest_dma_fifo (
  .clk(fifo_rd_clk),
  .resetn(dest_resetn),

  .enable(dest_enable),
  .enabled(dest_enabled),

  .req_valid(dest_req_valid),
  .req_ready(dest_req_ready),

  .response_valid(dest_response_valid),
  .response_ready(dest_response_ready),
  .response_resp(dest_response_resp),
  .response_resp_eot(dest_response_resp_eot),

  .response_id(dest_response_id),
  .data_id(data_id),

  .data_eot(data_eot),
  .response_eot(response_eot),

  .fifo_valid(dest_valid),
  .fifo_ready(dest_ready),
  .fifo_data(dest_data),
  .fifo_last(dest_last),

  .en(fifo_rd_en),
  .valid(fifo_rd_valid),
  .dout(fifo_rd_dout),
  .underflow(fifo_rd_underflow),
  .xfer_req(fifo_rd_xfer_req)
);

end else begin

assign fifo_rd_valid = 1'b0;
assign fifo_rd_dout = 'h0;
assign fifo_rd_underflow = 1'b0;
assign fifo_rd_xfer_req = 1'b0;

end endgenerate

generate if (DMA_TYPE_SRC == DMA_TYPE_MM_AXI) begin

wire [ID_WIDTH-1:0] src_data_id;
wire [ID_WIDTH-1:0] src_address_id;
wire src_address_eot = eot_mem_src[src_address_id];

assign source_id = src_address_id;
assign source_eot = src_address_eot;

assign src_clk = m_src_axi_aclk;
assign src_ext_resetn = m_src_axi_aresetn;

assign dbg_src_address_id = src_address_id;
assign dbg_src_data_id = src_data_id;

dmac_src_mm_axi #(
  .ID_WIDTH(ID_WIDTH),
  .DMA_DATA_WIDTH(DMA_DATA_WIDTH_SRC),
  .DMA_ADDR_WIDTH(DMA_AXI_ADDR_WIDTH),
  .BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH_SRC),
  .BYTES_PER_BEAT_WIDTH(BYTES_PER_BEAT_WIDTH_SRC),
  .AXI_LENGTH_WIDTH(AXI_LENGTH_WIDTH_SRC)
) i_src_dma_mm (
  .m_axi_aclk(m_src_axi_aclk),
  .m_axi_aresetn(src_resetn),

  .enable(src_enable),
  .enabled(src_enabled),

  .req_valid(src_req_valid),
  .req_ready(src_req_ready),
  .req_address(src_req_src_address),
  .req_last_burst_length(src_req_last_burst_length),
  .req_last_beat_bytes(src_req_last_beat_bytes),

  .bl_valid(src_bl_valid),
  .bl_ready(src_bl_ready),
  .measured_last_burst_length(src_burst_length),

/* TODO
  .response_valid(src_response_valid),
  .response_ready(src_response_ready),
  .response_resp(src_response_resp),
*/

  .request_id(src_throttled_request_id),
  .response_id(src_response_id),
  .address_id(src_address_id),
  .data_id(src_data_id),

  .address_eot(src_address_eot),

  .fifo_valid(src_valid),
  .fifo_data(src_data),
  .fifo_valid_bytes(src_valid_bytes),
  .fifo_last(src_last),

  .m_axi_arready(m_axi_arready),
  .m_axi_arvalid(m_axi_arvalid),
  .m_axi_araddr(m_axi_araddr),
  .m_axi_arlen(m_axi_arlen),
  .m_axi_arsize(m_axi_arsize),
  .m_axi_arburst(m_axi_arburst),
  .m_axi_arprot(m_axi_arprot),
  .m_axi_arcache(m_axi_arcache),

  .m_axi_rready(m_axi_rready),
  .m_axi_rvalid(m_axi_rvalid),
  .m_axi_rdata(m_axi_rdata),
  .m_axi_rlast(m_axi_rlast),
  .m_axi_rresp(m_axi_rresp)
);

end else begin

assign m_axi_arvalid = 1'b0;
assign m_axi_araddr = 'h00;
assign m_axi_arlen = 'h00;
assign m_axi_arsize = 'h00;
assign m_axi_arburst = 'h00;
assign m_axi_arcache = 'h00;
assign m_axi_arprot = 'h00;
assign m_axi_rready = 1'b0;

end

if (DMA_TYPE_SRC == DMA_TYPE_STREAM_AXI) begin

assign src_clk = s_axis_aclk;
assign src_ext_resetn = 1'b1;

wire src_eot = eot_mem_src[src_response_id];

assign dbg_src_address_id = 'h00;
assign dbg_src_data_id = 'h00;

/* TODO
assign src_response_valid = 1'b0;
assign src_response_resp = 2'b0;
*/


dmac_src_axi_stream #(
  .ID_WIDTH(ID_WIDTH),
  .S_AXIS_DATA_WIDTH(DMA_DATA_WIDTH_SRC),
  .BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH_SRC)
) i_src_dma_stream (
  .s_axis_aclk(s_axis_aclk),
  .s_axis_aresetn(src_resetn),

  .enable(src_enable),
  .enabled(src_enabled),

  .req_valid(src_req_valid),
  .req_ready(src_req_ready),
  .req_last_burst_length(src_req_last_burst_length),
  .req_sync_transfer_start(src_req_sync_transfer_start),
  .req_xlast(src_req_xlast),

  .request_id(src_throttled_request_id),
  .response_id(src_response_id),

  .eot(src_eot),

  .rewind_req_valid(rewind_req_valid),
  .rewind_req_ready(rewind_req_ready),
  .rewind_req_data(rewind_req_data),

  .bl_valid(src_bl_valid),
  .bl_ready(src_bl_ready),
  .measured_last_burst_length(src_burst_length),

  .block_descr_to_dst(block_descr_to_dst),

  .source_id(source_id),
  .source_eot(source_eot),

  .fifo_valid(src_valid),
  .fifo_data(src_data),
  .fifo_last(src_last),
  .fifo_partial_burst(src_partial_burst),

  .s_axis_valid(s_axis_valid),
  .s_axis_ready(s_axis_ready),
  .s_axis_data(s_axis_data),
  .s_axis_last(s_axis_last),
  .s_axis_user(s_axis_user),
  .s_axis_xfer_req(s_axis_xfer_req)
);

assign src_valid_bytes = {BYTES_PER_BEAT_WIDTH_SRC{1'b1}};

util_axis_fifo #(
  .DATA_WIDTH(ID_WIDTH + 3),
  .ADDRESS_WIDTH(0),
  .ASYNC_CLK(ASYNC_CLK_REQ_SRC)
) i_rewind_req_fifo (
  .s_axis_aclk(src_clk),
  .s_axis_aresetn(src_resetn),
  .s_axis_valid(rewind_req_valid),
  .s_axis_ready(rewind_req_ready),
  .s_axis_full(),
  .s_axis_data(rewind_req_data),
  .s_axis_room(),

  .m_axis_aclk(req_clk),
  .m_axis_aresetn(req_resetn),
  .m_axis_valid(req_rewind_req_valid),
  .m_axis_ready(req_rewind_req_ready),
  .m_axis_data(req_rewind_req_data),
  .m_axis_level(),
  .m_axis_empty()
);

end else begin

assign s_axis_ready = 1'b0;
assign s_axis_xfer_req = 1'b0;
assign rewind_req_valid = 1'b0;
assign rewind_req_data = 'h0;

assign req_rewind_req_valid = 'b0;
assign req_rewind_req_data = 'h0;

assign src_partial_burst = 1'b0;
assign block_descr_to_dst = 1'b0;

end

if (DMA_TYPE_SRC == DMA_TYPE_FIFO) begin

wire src_eot = eot_mem_src[src_response_id];

assign source_id = src_response_id;
assign source_eot = src_eot;

assign src_clk = fifo_wr_clk;
assign src_ext_resetn = 1'b1;

assign dbg_src_address_id = 'h00;
assign dbg_src_data_id = 'h00;

/* TODO
assign src_response_valid = 1'b0;
assign src_response_resp = 2'b0;
*/

dmac_src_fifo_inf #(
  .ID_WIDTH(ID_WIDTH),
  .DATA_WIDTH(DMA_DATA_WIDTH_SRC),
  .BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH_SRC)
) i_src_dma_fifo (
  .clk(fifo_wr_clk),
  .resetn(src_resetn),

  .enable(src_enable),
  .enabled(src_enabled),

  .req_valid(src_req_valid),
  .req_ready(src_req_ready),
  .req_last_burst_length(src_req_last_burst_length),
  .req_sync_transfer_start(src_req_sync_transfer_start),

  .request_id(src_throttled_request_id),
  .response_id(src_response_id),

  .eot(src_eot),

  .bl_valid(src_bl_valid),
  .bl_ready(src_bl_ready),
  .measured_last_burst_length(src_burst_length),

  .fifo_valid(src_valid),
  .fifo_data(src_data),
  .fifo_last(src_last),

  .en(fifo_wr_en),
  .din(fifo_wr_din),
  .overflow(fifo_wr_overflow),
  .sync(fifo_wr_sync),
  .xfer_req(fifo_wr_xfer_req)
);

assign src_valid_bytes = {BYTES_PER_BEAT_WIDTH_SRC{1'b1}};

end else begin

assign fifo_wr_overflow = 1'b0;
assign fifo_wr_xfer_req = 1'b0;

end endgenerate

sync_bits #(
  .NUM_OF_BITS(ID_WIDTH),
  .ASYNC_CLK(ASYNC_CLK_REQ_SRC)
) i_sync_src_request_id (
  .out_clk(src_clk),
  .out_resetn(1'b1),
  .in_bits(request_id),
  .out_bits(src_request_id)
);

`include "inc_id.vh"

function compare_id;
  input [ID_WIDTH-1:0] a;
  input [ID_WIDTH-1:0] b;
  begin
    compare_id = a[ID_WIDTH-1] == b[ID_WIDTH-1];
    if (ID_WIDTH >= 2) begin
      if (a[ID_WIDTH-2] == b[ID_WIDTH-2]) begin
        compare_id = 1'b1;
      end
    end
    if (ID_WIDTH >= 3) begin
      if (a[ID_WIDTH-3:0] != b[ID_WIDTH-3:0]) begin
        compare_id = 1'b1;
      end
    end
  end
endfunction

sync_event #(.ASYNC_CLK(ASYNC_CLK_REQ_SRC)) sync_rewind (
  .in_clk(req_clk),
  .in_event(rewind_state),
  .out_clk(src_clk),
  .out_event(src_throttler_enable)
);

always @(posedge src_clk) begin
  if (src_resetn == 1'b0) begin
    src_throttler_enabled <= 'b1;
  end else if (rewind_req_valid) begin
    src_throttler_enabled <= 'b0;
  end else if (src_throttler_enable) begin
    src_throttler_enabled <= 'b1;
  end
end

/*
 * Make sure that we do not request more data than what fits into the
 * store-and-forward burst memory.
 * Throttler must be blocked during rewind since it does not tolerate
 * a decrement of the request ID.
 */
always @(posedge src_clk) begin
  if (src_resetn == 1'b0) begin
    src_throttled_request_id <= 'h00;
  end else if (rewind_req_valid) begin
    src_throttled_request_id <= rewind_req_data[ID_WIDTH-1:0];
  end else if (src_throttled_request_id != src_request_id &&
               compare_id(src_throttled_request_id, src_data_request_id) &&
               src_throttler_enabled) begin
    src_throttled_request_id <= inc_id(src_throttled_request_id);
  end
end

sync_bits #(
  .NUM_OF_BITS(ID_WIDTH),
  .ASYNC_CLK(ASYNC_CLK_DEST_REQ)
) i_sync_req_response_id (
  .out_clk(req_clk),
  .out_resetn(1'b1),
  .in_bits(dest_response_id),
  .out_bits(response_id)
);

axi_register_slice #(
  .DATA_WIDTH(DMA_DATA_WIDTH_SRC + BYTES_PER_BEAT_WIDTH_SRC + 2),
  .FORWARD_REGISTERED(AXI_SLICE_SRC),
  .BACKWARD_REGISTERED(0)
) i_src_slice (
  .clk(src_clk),
  .resetn(src_resetn),
  .s_axi_valid(src_valid),
  .s_axi_ready(),
  .s_axi_data({src_data,src_valid_bytes,src_last,src_partial_burst}),
  .m_axi_valid(src_fifo_valid),
  .m_axi_ready(1'b1), /* No backpressure */
  .m_axi_data({src_fifo_data,src_fifo_valid_bytes,src_fifo_last,src_fifo_partial_burst})
);

axi_dmac_burst_memory #(
  .DATA_WIDTH_SRC(DMA_DATA_WIDTH_SRC),
  .DATA_WIDTH_DEST(DMA_DATA_WIDTH_DEST),
  .ID_WIDTH(ID_WIDTH),
  .MAX_BYTES_PER_BURST(MAX_BYTES_PER_BURST),
  .ASYNC_CLK(ASYNC_CLK_SRC_DEST),
  .BYTES_PER_BEAT_WIDTH_SRC(BYTES_PER_BEAT_WIDTH_SRC),
  .BYTES_PER_BURST_WIDTH(BYTES_PER_BURST_WIDTH),
  .DMA_LENGTH_ALIGN(DMA_LENGTH_ALIGN),
  .ENABLE_DIAGNOSTICS_IF(ENABLE_DIAGNOSTICS_IF),
  .ALLOW_ASYM_MEM(ALLOW_ASYM_MEM)
) i_store_and_forward (
  .src_clk(src_clk),
  .src_reset(~src_resetn),
  .src_data_valid(src_fifo_valid),
  .src_data(src_fifo_data),
  .src_data_last(src_fifo_last),
  .src_data_valid_bytes(src_fifo_valid_bytes),
  .src_data_partial_burst(src_fifo_partial_burst),

  .src_data_request_id(src_data_request_id),

  .dest_clk(dest_clk),
  .dest_reset(~dest_resetn),
  .dest_data_valid(dest_fifo_valid),
  .dest_data_ready(dest_fifo_ready),
  .dest_data(dest_fifo_data),
  .dest_data_last(dest_fifo_last),
  .dest_data_strb(dest_fifo_strb),

  .dest_burst_info_length(dest_burst_info_length),
  .dest_burst_info_partial(dest_burst_info_partial),
  .dest_burst_info_id(dest_burst_info_id),
  .dest_burst_info_write(dest_burst_info_write),

  .dest_request_id(dest_request_id),
  .dest_data_request_id(dest_data_request_id),
  .dest_data_response_id(dest_data_response_id),

  .dest_diag_level_bursts(dest_diag_level_bursts)
);

axi_register_slice #(
  .DATA_WIDTH(DMA_DATA_WIDTH_DEST + DMA_DATA_WIDTH_DEST / 8 + 1),
  .FORWARD_REGISTERED(AXI_SLICE_DEST),
  .BACKWARD_REGISTERED(AXI_SLICE_DEST)
) i_dest_slice (
  .clk(dest_clk),
  .resetn(dest_resetn),
  .s_axi_valid(dest_fifo_valid),
  .s_axi_ready(dest_fifo_ready),
  .s_axi_data({
    dest_fifo_last,
    dest_fifo_strb,
    dest_fifo_data
  }),
  .m_axi_valid(dest_valid),
  .m_axi_ready(dest_ready),
  .m_axi_data({
    dest_last,
    dest_strb,
    dest_data
  })
);

// Don't let the request generator run in advance more than one descriptor
// The descriptor FIFO should not block the start of the request generator
// since it becomes ready earlier.
assign req_gen_valid = req_valid & req_ready;
assign req_src_valid = req_valid & req_ready;
assign req_ready = req_gen_ready & req_src_ready;

util_axis_fifo #(
  .DATA_WIDTH(DMA_ADDRESS_WIDTH_DEST + 1),
  .ADDRESS_WIDTH(0),
  .ASYNC_CLK(ASYNC_CLK_SRC_DEST)
) i_dest_req_fifo (
  .s_axis_aclk(src_clk),
  .s_axis_aresetn(src_resetn),
  .s_axis_valid(src_dest_valid_hs_masked),
  .s_axis_ready(src_dest_ready_hs),
  .s_axis_full(),
  .s_axis_data({
    src_req_dest_address_cur,
    src_req_xlast_cur
  }),
  .s_axis_room(),

  .m_axis_aclk(dest_clk),
  .m_axis_aresetn(dest_resetn),
  .m_axis_valid(dest_req_valid),
  .m_axis_ready(dest_req_ready),
  .m_axis_data({
    dest_req_dest_address,
    dest_req_xlast
  }),
  .m_axis_level(),
  .m_axis_empty()
);

util_axis_fifo #(
  .DATA_WIDTH(DMA_ADDRESS_WIDTH_DEST + DMA_ADDRESS_WIDTH_SRC + BYTES_PER_BURST_WIDTH + 2),
  .ADDRESS_WIDTH(0),
  .ASYNC_CLK(ASYNC_CLK_REQ_SRC)
) i_src_req_fifo (
  .s_axis_aclk(req_clk),
  .s_axis_aresetn(req_resetn),
  .s_axis_valid(req_src_valid),
  .s_axis_ready(req_src_ready),
  .s_axis_full(),
  .s_axis_data({
    req_dest_address,
    req_src_address,
    req_length[BYTES_PER_BURST_WIDTH-1:0],
    req_sync_transfer_start,
    req_xlast
  }),
  .s_axis_room(),

  .m_axis_aclk(src_clk),
  .m_axis_aresetn(src_resetn),
  .m_axis_valid(src_req_spltr_valid),
  .m_axis_ready(src_req_spltr_ready),
  .m_axis_data({
    src_req_dest_address,
    src_req_src_address,
    src_req_last_burst_length,
    src_req_last_beat_bytes,
    src_req_sync_transfer_start,
    src_req_xlast
  }),
  .m_axis_level(),
  .m_axis_empty()
);

// Save the descriptor in the source clock domain since the submission to
// destination is delayed.
always @(posedge src_clk) begin
  if (src_req_valid == 1'b1 && src_req_ready == 1'b1) begin
    src_req_dest_address_cur <= src_req_dest_address;
    src_req_xlast_cur <= src_req_xlast;
  end
end

always @(posedge src_clk) begin
  if (src_resetn == 1'b0) begin
    src_dest_valid_hs <= 1'b0;
  end else if (src_req_valid == 1'b1 && src_req_ready == 1'b1) begin
    src_dest_valid_hs <= 1'b1;
  end else if (src_dest_ready_hs == 1'b1) begin
    src_dest_valid_hs <= 1'b0;
  end
end

// Forward the descriptor to the destination only after the source decided to
// do so
assign src_dest_valid_hs_masked = src_dest_valid_hs == 1'b1 && block_descr_to_dst == 1'b0;
assign src_req_spltr_ready = src_req_ready && src_dest_ready_hs;
assign src_req_valid = src_req_spltr_valid && src_req_spltr_ready;


/* Unused for now
util_axis_fifo #(
  .DATA_WIDTH(2),
  .ADDRESS_WIDTH(0),
  .ASYNC_CLK(ASYNC_CLK_REQ_SRC)
) i_src_response_fifo (
  .s_axis_aclk(src_clk),
  .s_axis_aresetn(src_resetn),
  .s_axis_valid(src_response_valid),
  .s_axis_ready(src_response_ready),
  .s_axis_empty(src_response_empty),
  .s_axis_data(src_response_resp),
  .m_axis_aclk(req_clk),
  .m_axis_aresetn(req_resetn),
  .m_axis_valid(response_src_valid),
  .m_axis_ready(response_src_ready),
  .m_axis_data(response_src_resp)
);
assign src_response_empty = 1'b1;
assign src_response_ready = 1'b1;
*/

dmac_request_generator #(
  .ID_WIDTH(ID_WIDTH),
  .BURSTS_PER_TRANSFER_WIDTH(BURSTS_PER_TRANSFER_WIDTH)
) i_req_gen (
  .clk(req_clk),
  .resetn(req_resetn),

  .request_id(request_id),
  .response_id(response_id),

  .rewind_req_valid(req_rewind_req_valid),
  .rewind_req_ready(req_rewind_req_ready),
  .rewind_req_data(req_rewind_req_data),
  .rewind_state(rewind_state),

  .abort_req(abort_req),

  .completion_req_valid(completion_req_valid),
  .completion_req_ready(completion_req_ready),
  .completion_req_last(completion_req_last),
  .completion_transfer_id(completion_transfer_id),

  .req_valid(req_gen_valid),
  .req_ready(req_gen_ready),
  .req_burst_count(req_length[DMA_LENGTH_WIDTH-1:BYTES_PER_BURST_WIDTH]),
  .req_xlast(req_xlast),

  .enable(req_enable),

  .eot(request_eot)
);

axi_dmac_response_manager #(
  .DMA_DATA_WIDTH_SRC(DMA_DATA_WIDTH_SRC),
  .DMA_DATA_WIDTH_DEST(DMA_DATA_WIDTH_DEST),
  .DMA_LENGTH_WIDTH(DMA_LENGTH_WIDTH),
  .BYTES_PER_BURST_WIDTH(BYTES_PER_BURST_WIDTH),
  .BYTES_PER_BEAT_WIDTH_SRC(BYTES_PER_BEAT_WIDTH_SRC),
  .ASYNC_CLK_DEST_REQ(ASYNC_CLK_DEST_REQ)
) i_response_manager(
  .dest_clk(dest_clk),
  .dest_resetn(dest_resetn),
  .dest_response_valid(dest_response_valid),
  .dest_response_ready(dest_response_ready),
  .dest_response_resp(dest_response_resp),
  .dest_response_partial(dest_response_partial),
  .dest_response_resp_eot(dest_response_resp_eot),
  .dest_response_data_burst_length(dest_response_data_burst_length),

  .req_clk(req_clk),
  .req_resetn(req_resetn),
  .response_eot(eot),
  .measured_burst_length(measured_burst_length),
  .response_partial(response_partial),
  .response_valid(response_valid),
  .response_ready(response_ready),

  .completion_req_valid(completion_req_valid),
  .completion_req_ready(completion_req_ready),
  .completion_req_last(completion_req_last),
  .completion_transfer_id(completion_transfer_id)

);


endmodule
