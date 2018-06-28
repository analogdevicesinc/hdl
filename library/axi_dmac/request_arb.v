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

module dmac_request_arb #(
  parameter DMA_DATA_WIDTH_SRC = 64,
  parameter DMA_DATA_WIDTH_DEST = 64,
  parameter DMA_LENGTH_WIDTH = 24,
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
  parameter FIFO_SIZE = 8,
  parameter ID_WIDTH = $clog2(FIFO_SIZE*2),
  parameter AXI_LENGTH_WIDTH_SRC = 8,
  parameter AXI_LENGTH_WIDTH_DEST = 8,
  parameter ENABLE_DIAGNOSTICS_IF = 0)(

  input req_clk,
  input req_resetn,

  input req_valid,
  output req_ready,
  input [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] req_dest_address,
  input [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC] req_src_address,
  input [DMA_LENGTH_WIDTH-1:0] req_length,
  input req_xlast,
  input req_sync_transfer_start,

  output reg eot,

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
localparam BYTES_PER_BURST_WIDTH =
  MAX_BYTES_PER_BURST > 2048 ? 12 :
  MAX_BYTES_PER_BURST > 1024 ? 11 :
  MAX_BYTES_PER_BURST > 512 ? 10 :
  MAX_BYTES_PER_BURST > 256 ? 9 :
  MAX_BYTES_PER_BURST > 128 ? 8 :
  MAX_BYTES_PER_BURST > 64 ? 7 :
  MAX_BYTES_PER_BURST > 32 ? 6 :
  MAX_BYTES_PER_BURST > 16 ? 5 :
  MAX_BYTES_PER_BURST > 8 ? 4 :
  MAX_BYTES_PER_BURST > 4 ? 3 :
  MAX_BYTES_PER_BURST > 2 ? 2 : 1;
localparam BEATS_PER_BURST_WIDTH_SRC = BYTES_PER_BURST_WIDTH - BYTES_PER_BEAT_WIDTH_SRC;
localparam BEATS_PER_BURST_WIDTH_DEST = BYTES_PER_BURST_WIDTH - BYTES_PER_BEAT_WIDTH_DEST;

localparam BURSTS_PER_TRANSFER_WIDTH = DMA_LENGTH_WIDTH - BYTES_PER_BURST_WIDTH;

reg eot_mem[0:2**ID_WIDTH-1];
wire request_eot;

wire [ID_WIDTH-1:0] request_id;
wire [ID_WIDTH-1:0] response_id;

wire enabled_src;
wire enabled_dest;

wire req_gen_valid;
wire req_gen_ready;
wire req_dest_valid;
wire req_dest_ready;
wire req_src_valid;
wire req_src_ready;

wire dest_req_valid;
wire dest_req_ready;
wire [DMA_ADDRESS_WIDTH_DEST-1:0] dest_req_address;
wire [BEATS_PER_BURST_WIDTH_DEST-1:0] dest_req_last_burst_length;
wire dest_req_xlast;

wire dest_response_valid;
wire dest_response_ready;
wire dest_response_empty;
wire [1:0] dest_response_resp;
wire dest_response_resp_eot;

wire [ID_WIDTH-1:0] dest_request_id;
wire [ID_WIDTH-1:0] dest_data_request_id;
wire [ID_WIDTH-1:0] dest_data_response_id;
wire [ID_WIDTH-1:0] dest_response_id;

wire dest_valid;
wire dest_ready;
wire [DMA_DATA_WIDTH_DEST-1:0] dest_data;
wire dest_last;
wire dest_fifo_valid;
wire dest_fifo_ready;
wire [DMA_DATA_WIDTH_DEST-1:0] dest_fifo_data;
wire dest_fifo_last;

wire src_req_valid;
wire src_req_ready;
wire [DMA_ADDRESS_WIDTH_SRC-1:0] src_req_address;
wire [BEATS_PER_BURST_WIDTH_SRC-1:0] src_req_last_burst_length;
wire src_req_sync_transfer_start;
wire src_req_xlast;

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
wire src_last;
wire src_fifo_valid;
wire [DMA_DATA_WIDTH_SRC-1:0] src_fifo_data;
wire src_fifo_last;

wire response_dest_valid;
wire response_dest_ready = 1'b1;
wire [1:0] response_dest_resp;
wire response_dest_resp_eot;

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
  eot_mem[request_id] <= request_eot;
end

always @(posedge req_clk)
begin
  if (req_resetn == 1'b0) begin
    eot <= 1'b0;
  end else begin
    eot <= response_dest_valid & response_dest_ready & response_dest_resp_eot;
  end
end

generate if (DMA_TYPE_DEST == DMA_TYPE_MM_AXI) begin

assign dest_clk = m_dest_axi_aclk;
assign dest_ext_resetn = m_dest_axi_aresetn;

wire [ID_WIDTH-1:0] dest_address_id;
wire dest_address_eot = eot_mem[dest_address_id];
wire dest_response_eot = eot_mem[dest_response_id];

assign dbg_dest_address_id = dest_address_id;
assign dbg_dest_data_id = dest_data_response_id;

assign dest_data_request_id = dest_address_id;

dmac_dest_mm_axi #(
  .ID_WIDTH(ID_WIDTH),
  .DMA_DATA_WIDTH(DMA_DATA_WIDTH_DEST),
  .DMA_ADDR_WIDTH(DMA_AXI_ADDR_WIDTH),
  .BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH_DEST),
  .BYTES_PER_BEAT_WIDTH(BYTES_PER_BEAT_WIDTH_DEST),
  .AXI_LENGTH_WIDTH(AXI_LENGTH_WIDTH_DEST)
) i_dest_dma_mm (
  .m_axi_aclk(m_dest_axi_aclk),
  .m_axi_aresetn(dest_resetn),

  .enable(dest_enable),
  .enabled(dest_enabled),

  .req_valid(dest_req_valid),
  .req_ready(dest_req_ready),
  .req_address(dest_req_address),
  .req_last_burst_length(dest_req_last_burst_length),

  .response_valid(dest_response_valid),
  .response_ready(dest_response_ready),
  .response_resp(dest_response_resp),
  .response_resp_eot(dest_response_resp_eot),

  .request_id(dest_request_id),
  .response_id(dest_response_id),

  .address_id(dest_address_id),

  .address_eot(dest_address_eot),
  .response_eot(dest_response_eot),

  .fifo_valid(dest_valid),
  .fifo_ready(dest_ready),
  .fifo_data(dest_data),
  .fifo_last(dest_last),

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

end

if (DMA_TYPE_DEST == DMA_TYPE_STREAM_AXI) begin

assign dest_clk = m_axis_aclk;
assign dest_ext_resetn = 1'b1;

wire [ID_WIDTH-1:0] data_id;

wire data_eot = eot_mem[data_id];
wire response_eot = eot_mem[dest_response_id];

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
  .req_last_burst_length(dest_req_last_burst_length),
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

wire data_eot = eot_mem[data_id];
wire response_eot = eot_mem[dest_response_id];

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

assign src_clk = m_src_axi_aclk;
assign src_ext_resetn = m_src_axi_aresetn;

wire [ID_WIDTH-1:0] src_data_id;
wire [ID_WIDTH-1:0] src_address_id;
wire src_address_eot = eot_mem[src_address_id];

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
  .req_address(src_req_address),
  .req_last_burst_length(src_req_last_burst_length),

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

wire src_eot = eot_mem[src_response_id];

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

  .fifo_valid(src_valid),
  .fifo_data(src_data),
  .fifo_last(src_last),

  .s_axis_valid(s_axis_valid),
  .s_axis_ready(s_axis_ready),
  .s_axis_data(s_axis_data),
  .s_axis_last(s_axis_last),
  .s_axis_user(s_axis_user),
  .s_axis_xfer_req(s_axis_xfer_req)
);

end else begin

assign s_axis_ready = 1'b0;
assign s_axis_xfer_req = 1'b0;

end

if (DMA_TYPE_SRC == DMA_TYPE_FIFO) begin

assign src_clk = fifo_wr_clk;
assign src_ext_resetn = 1'b1;

wire src_eot = eot_mem[src_response_id];

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

  .fifo_valid(src_valid),
  .fifo_data(src_data),
  .fifo_last(src_last),

  .en(fifo_wr_en),
  .din(fifo_wr_din),
  .overflow(fifo_wr_overflow),
  .sync(fifo_wr_sync),
  .xfer_req(fifo_wr_xfer_req)
);

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
  .in(request_id),
  .out(src_request_id)
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

/*
 * Make sure that we do not request more data than what fits into the
 * store-and-forward burst memory.
 */
always @(posedge src_clk) begin
  if (src_resetn == 1'b0) begin
    src_throttled_request_id <= 'h00;
  end else if (src_throttled_request_id != src_request_id &&
               compare_id(src_throttled_request_id, src_data_request_id)) begin
    src_throttled_request_id <= inc_id(src_throttled_request_id);
  end
end

sync_bits #(
  .NUM_OF_BITS(ID_WIDTH),
  .ASYNC_CLK(ASYNC_CLK_DEST_REQ)
) i_sync_req_response_id (
  .out_clk(req_clk),
  .out_resetn(1'b1),
  .in(dest_response_id),
  .out(response_id)
);

axi_register_slice #(
  .DATA_WIDTH(DMA_DATA_WIDTH_SRC + 1),
  .FORWARD_REGISTERED(AXI_SLICE_SRC),
  .BACKWARD_REGISTERED(0)
) i_src_slice (
  .clk(src_clk),
  .resetn(src_resetn),
  .s_axi_valid(src_valid),
  .s_axi_ready(),
  .s_axi_data({src_data,src_last}),
  .m_axi_valid(src_fifo_valid),
  .m_axi_ready(1'b1), /* No backpressure */
  .m_axi_data({src_fifo_data,src_fifo_last})
);

axi_dmac_burst_memory #(
  .DATA_WIDTH_SRC(DMA_DATA_WIDTH_SRC),
  .DATA_WIDTH_DEST(DMA_DATA_WIDTH_DEST),
  .ID_WIDTH(ID_WIDTH),
  .MAX_BYTES_PER_BURST(MAX_BYTES_PER_BURST),
  .ASYNC_CLK(ASYNC_CLK_SRC_DEST),
  .ENABLE_DIAGNOSTICS_IF(ENABLE_DIAGNOSTICS_IF)
) i_store_and_forward (
  .src_clk(src_clk),
  .src_reset(~src_resetn),
  .src_data_valid(src_fifo_valid),
  .src_data(src_fifo_data),
  .src_data_last(src_fifo_last),

  .src_data_request_id(src_data_request_id),

  .dest_clk(dest_clk),
  .dest_reset(~dest_resetn),
  .dest_data_valid(dest_fifo_valid),
  .dest_data_ready(dest_fifo_ready),
  .dest_data(dest_fifo_data),
  .dest_data_last(dest_fifo_last),

  .dest_request_id(dest_request_id),
  .dest_data_request_id(dest_data_request_id),
  .dest_data_response_id(dest_data_response_id),

  .dest_diag_level_bursts(dest_diag_level_bursts)
);

axi_register_slice #(
  .DATA_WIDTH(DMA_DATA_WIDTH_DEST + 1),
  .FORWARD_REGISTERED(AXI_SLICE_DEST),
  .BACKWARD_REGISTERED(AXI_SLICE_DEST)
) i_dest_slice (
  .clk(dest_clk),
  .resetn(dest_resetn),
  .s_axi_valid(dest_fifo_valid),
  .s_axi_ready(dest_fifo_ready),
  .s_axi_data({
    dest_fifo_last,
    dest_fifo_data
  }),
  .m_axi_valid(dest_valid),
  .m_axi_ready(dest_ready),
  .m_axi_data({
    dest_last,
    dest_data
  })
);

splitter #(
  .NUM_M(3)
) i_req_splitter (
  .clk(req_clk),
  .resetn(req_resetn),
  .s_valid(req_valid),
  .s_ready(req_ready),
  .m_valid({
    req_gen_valid,
    req_dest_valid,
    req_src_valid
  }),
  .m_ready({
    req_gen_ready,
    req_dest_ready,
    req_src_ready
  })
);

util_axis_fifo #(
  .DATA_WIDTH(DMA_ADDRESS_WIDTH_DEST + BEATS_PER_BURST_WIDTH_DEST + 1),
  .ADDRESS_WIDTH(0),
  .ASYNC_CLK(ASYNC_CLK_DEST_REQ)
) i_dest_req_fifo (
  .s_axis_aclk(req_clk),
  .s_axis_aresetn(req_resetn),
  .s_axis_valid(req_dest_valid),
  .s_axis_ready(req_dest_ready),
  .s_axis_empty(),
  .s_axis_data({
    req_dest_address,
    req_length[BYTES_PER_BURST_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST],
    req_xlast
  }),
  .s_axis_room(),

  .m_axis_aclk(dest_clk),
  .m_axis_aresetn(dest_resetn),
  .m_axis_valid(dest_req_valid),
  .m_axis_ready(dest_req_ready),
  .m_axis_data({
    dest_req_address,
    dest_req_last_burst_length,
    dest_req_xlast
  }),
  .m_axis_level()
);

util_axis_fifo #(
  .DATA_WIDTH(DMA_ADDRESS_WIDTH_SRC + BEATS_PER_BURST_WIDTH_SRC + 2),
  .ADDRESS_WIDTH(0),
  .ASYNC_CLK(ASYNC_CLK_REQ_SRC)
) i_src_req_fifo (
  .s_axis_aclk(req_clk),
  .s_axis_aresetn(req_resetn),
  .s_axis_valid(req_src_valid),
  .s_axis_ready(req_src_ready),
  .s_axis_empty(),
  .s_axis_data({
    req_src_address,
    req_length[BYTES_PER_BURST_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC],
    req_sync_transfer_start,
    req_xlast
  }),
  .s_axis_room(),

  .m_axis_aclk(src_clk),
  .m_axis_aresetn(src_resetn),
  .m_axis_valid(src_req_valid),
  .m_axis_ready(src_req_ready),
  .m_axis_data({
    src_req_address,
    src_req_last_burst_length,
    src_req_sync_transfer_start,
    src_req_xlast
  }),
  .m_axis_level()
);

util_axis_fifo #(
  .DATA_WIDTH(1),
  .ADDRESS_WIDTH(0),
  .ASYNC_CLK(ASYNC_CLK_DEST_REQ)
) i_dest_response_fifo (
  .s_axis_aclk(dest_clk),
  .s_axis_aresetn(dest_resetn),
  .s_axis_valid(dest_response_valid),
  .s_axis_ready(dest_response_ready),
  .s_axis_empty(dest_response_empty),
  .s_axis_data(dest_response_resp_eot),
  .s_axis_room(),

  .m_axis_aclk(req_clk),
  .m_axis_aresetn(req_resetn),
  .m_axis_valid(response_dest_valid),
  .m_axis_ready(response_dest_ready),
  .m_axis_data(response_dest_resp_eot),
  .m_axis_level()
);

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

  .req_valid(req_gen_valid),
  .req_ready(req_gen_ready),
  .req_burst_count(req_length[DMA_LENGTH_WIDTH-1:BYTES_PER_BURST_WIDTH]),

  .enable(req_enable),

  .eot(request_eot)
);

endmodule
