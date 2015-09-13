// ***************************************************************************
// ***************************************************************************
// Copyright 2013(c) Analog Devices, Inc.
//  Author: Lars-Peter Clausen <lars@metafoo.de>
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

module dmac_request_arb (
	input req_aclk,
	input req_aresetn,

	input req_valid,
	output req_ready,
	input [31:C_BYTES_PER_BEAT_WIDTH_DEST] req_dest_address,
	input [31:C_BYTES_PER_BEAT_WIDTH_SRC] req_src_address,
	input [C_DMA_LENGTH_WIDTH-1:0] req_length,
        input req_xlast,
	input req_sync_transfer_start,

	output reg eot,

	input                               enable,
	input                               pause,

	// Master AXI interface
	input                               m_dest_axi_aclk,
	input                               m_dest_axi_aresetn,
	input                               m_src_axi_aclk,
	input                               m_src_axi_aresetn,

	// Write address
	output [31:0]                       m_axi_awaddr,
	output [ 7:0]                       m_axi_awlen,
	output [ 2:0]                       m_axi_awsize,
	output [ 1:0]                       m_axi_awburst,
	output [ 2:0]                       m_axi_awprot,
	output [ 3:0]                       m_axi_awcache,
	output                              m_axi_awvalid,
	input                               m_axi_awready,

	// Write data
	output [C_DMA_DATA_WIDTH_DEST-1:0]     m_axi_wdata,
	output [(C_DMA_DATA_WIDTH_DEST/8)-1:0] m_axi_wstrb,
	input                               m_axi_wready,
	output                              m_axi_wvalid,
	output                              m_axi_wlast,

	// Write response
	input                               m_axi_bvalid,
	input  [ 1:0]                       m_axi_bresp,
	output                              m_axi_bready,

	// Read address
	input                               m_axi_arready,
	output                              m_axi_arvalid,
	output [31:0]                       m_axi_araddr,
	output [ 7:0]                       m_axi_arlen,
	output [ 2:0]                       m_axi_arsize,
	output [ 1:0]                       m_axi_arburst,
	output [ 2:0]                       m_axi_arprot,
	output [ 3:0]                       m_axi_arcache,

	// Read data and response
	input  [C_DMA_DATA_WIDTH_SRC-1:0]   m_axi_rdata,
	output                              m_axi_rready,
	input                               m_axi_rvalid,
	input  [ 1:0]                       m_axi_rresp,

	// Slave streaming AXI interface
	input                               s_axis_aclk,
	output                              s_axis_ready,
	input                               s_axis_valid,
	input  [C_DMA_DATA_WIDTH_SRC-1:0]   s_axis_data,
	input  [0:0]                        s_axis_user,
	output                              s_axis_xfer_req,

	// Master streaming AXI interface
	input                               m_axis_aclk,
	input                               m_axis_ready,
	output                              m_axis_valid,
	output [C_DMA_DATA_WIDTH_DEST-1:0]  m_axis_data,
        output                              m_axis_last,
        output                              m_axis_xfer_req,

	// Input FIFO interface
	input                               fifo_wr_clk,
	input                               fifo_wr_en,
	input  [C_DMA_DATA_WIDTH_SRC-1:0]   fifo_wr_din,
	output                              fifo_wr_overflow,
	input                               fifo_wr_sync,
	output                              fifo_wr_xfer_req,

	// Input FIFO interface
	input                               fifo_rd_clk,
	input                               fifo_rd_en,
	output                              fifo_rd_valid,
	output [C_DMA_DATA_WIDTH_DEST-1:0]  fifo_rd_dout,
	output                              fifo_rd_underflow,
        output                              fifo_rd_xfer_req,

	output [C_ID_WIDTH-1:0]				dbg_dest_request_id,
	output [C_ID_WIDTH-1:0]				dbg_dest_address_id,
	output [C_ID_WIDTH-1:0]				dbg_dest_data_id,
	output [C_ID_WIDTH-1:0]				dbg_dest_response_id,
	output [C_ID_WIDTH-1:0]				dbg_src_request_id,
	output [C_ID_WIDTH-1:0]				dbg_src_address_id,
	output [C_ID_WIDTH-1:0]				dbg_src_data_id,
	output [C_ID_WIDTH-1:0]				dbg_src_response_id,
	output [7:0]                        dbg_status
);

parameter C_DMA_DATA_WIDTH_SRC = 64;
parameter C_DMA_DATA_WIDTH_DEST = 64;
parameter C_DMA_LENGTH_WIDTH = 24;

parameter C_BYTES_PER_BEAT_WIDTH_DEST = $clog2(C_DMA_DATA_WIDTH_DEST/8);
parameter C_BYTES_PER_BEAT_WIDTH_SRC = $clog2(C_DMA_DATA_WIDTH_SRC/8);

parameter C_DMA_TYPE_DEST = DMA_TYPE_MM_AXI;
parameter C_DMA_TYPE_SRC = DMA_TYPE_FIFO;

parameter C_CLKS_ASYNC_REQ_SRC = 1;
parameter C_CLKS_ASYNC_SRC_DEST = 1;
parameter C_CLKS_ASYNC_DEST_REQ = 1;

parameter C_AXI_SLICE_DEST = 0;
parameter C_AXI_SLICE_SRC = 0;

parameter C_MAX_BYTES_PER_BURST = 128;
parameter C_FIFO_SIZE = 4;

parameter C_ID_WIDTH = $clog2(C_FIFO_SIZE * 2);

localparam DMA_TYPE_MM_AXI = 0;
localparam DMA_TYPE_STREAM_AXI = 1;
localparam DMA_TYPE_FIFO = 2;

localparam DMA_ADDR_WIDTH_DEST = 32 - C_BYTES_PER_BEAT_WIDTH_DEST;
localparam DMA_ADDR_WIDTH_SRC = 32 - C_BYTES_PER_BEAT_WIDTH_SRC;

localparam DMA_DATA_WIDTH = C_DMA_DATA_WIDTH_SRC < C_DMA_DATA_WIDTH_DEST ?
	C_DMA_DATA_WIDTH_DEST : C_DMA_DATA_WIDTH_SRC;



// Bytes per burst is the same for both dest and src, but bytes per beat may
// differ, so beats per burst may also differ

parameter BYTES_PER_BURST_WIDTH = $clog2(C_MAX_BYTES_PER_BURST);
localparam BEATS_PER_BURST_WIDTH_SRC = BYTES_PER_BURST_WIDTH - C_BYTES_PER_BEAT_WIDTH_SRC;
localparam BEATS_PER_BURST_WIDTH_DEST = BYTES_PER_BURST_WIDTH - C_BYTES_PER_BEAT_WIDTH_DEST;

localparam BURSTS_PER_TRANSFER_WIDTH = C_DMA_LENGTH_WIDTH - BYTES_PER_BURST_WIDTH;

reg [0:2**C_ID_WIDTH-1] eot_mem;
wire request_eot;

wire [C_ID_WIDTH-1:0] request_id;
wire [C_ID_WIDTH-1:0] response_id;

wire enabled_src;
wire enabled_dest;
wire sync_id;
wire sync_id_ret_dest;
wire sync_id_ret_src;

wire dest_enable;
wire dest_enabled;
wire dest_pause;
wire dest_sync_id;
wire dest_sync_id_ret;
wire src_enable;
wire src_enabled;
wire src_pause;
wire src_sync_id;
wire src_sync_id_ret;

wire req_dest_valid;
wire req_dest_ready;
wire req_dest_empty;
wire req_src_valid;
wire req_src_ready;
wire req_src_empty;

wire dest_clk;
wire dest_resetn;
wire dest_req_valid;
wire dest_req_ready;
wire [DMA_ADDR_WIDTH_DEST-1:0] dest_req_address;
wire [BEATS_PER_BURST_WIDTH_DEST-1:0] dest_req_last_burst_length;
wire [C_BYTES_PER_BEAT_WIDTH_DEST-1:0] dest_req_last_beat_bytes;
wire dest_req_xlast;

wire dest_response_valid;
wire dest_response_ready;
wire dest_response_empty;
wire [1:0] dest_response_resp;
wire dest_response_resp_eot;

wire [C_ID_WIDTH-1:0] dest_request_id;
wire [C_ID_WIDTH-1:0] dest_response_id;

wire dest_valid;
wire dest_ready;
wire [C_DMA_DATA_WIDTH_DEST-1:0] dest_data;
wire dest_fifo_repacked_valid;
wire dest_fifo_repacked_ready;
wire [C_DMA_DATA_WIDTH_DEST-1:0] dest_fifo_repacked_data;
wire dest_fifo_valid;
wire dest_fifo_ready;
wire [DMA_DATA_WIDTH-1:0] dest_fifo_data;

wire src_clk;
wire src_resetn;
wire src_req_valid;
wire src_req_ready;
wire [DMA_ADDR_WIDTH_SRC-1:0] src_req_address;
wire [BEATS_PER_BURST_WIDTH_SRC-1:0] src_req_last_burst_length;
wire src_req_sync_transfer_start;

wire src_response_valid;
wire src_response_ready;
wire src_response_empty;
wire [1:0] src_response_resp;

wire [C_ID_WIDTH-1:0] src_request_id;
wire [C_ID_WIDTH-1:0] src_response_id;

wire src_valid;
wire src_ready;
wire [C_DMA_DATA_WIDTH_SRC-1:0] src_data;
wire src_fifo_valid;
wire src_fifo_ready;
wire [C_DMA_DATA_WIDTH_SRC-1:0] src_fifo_data;
wire src_fifo_repacked_valid;
wire src_fifo_repacked_ready;
wire [DMA_DATA_WIDTH-1:0] src_fifo_repacked_data;
wire src_fifo_empty;

wire fifo_empty;

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

assign sync_id = ~enabled_dest && ~enabled_src && request_id != response_id;

reg enabled;
reg do_enable;

// Enable src and dest if we are in sync
always @(posedge req_aclk)
begin
	if (req_aresetn == 1'b0) begin
		do_enable <= 1'b0;
	end else begin
		if (enable) begin
			// First make sure we are fully disabled
			if (~sync_id_ret_dest && ~sync_id_ret_src &&
				response_id == request_id && ~enabled_dest && ~enabled_src &&
				req_dest_empty && req_src_empty && fifo_empty)
				do_enable <= 1'b1;
		end else begin
			do_enable <= 1'b0;
		end
	end
end

// Flag enabled once both src and dest are enabled
always @(posedge req_aclk)
begin
	if (req_aresetn == 1'b0) begin
		enabled <= 1'b0;
	end else begin
		if (do_enable == 1'b0)
			enabled <= 1'b0;
		else if (enabled_dest && enabled_src)
			enabled <= 1'b1;
	end
end

assign dbg_status = {do_enable, enabled, enabled_dest, enabled_src, fifo_empty,
	sync_id, sync_id_ret_dest, sync_id_ret_src};

always @(posedge req_aclk)
begin
	eot_mem[request_id] <= request_eot;
end

always @(posedge req_aclk)
begin
	if (req_aresetn == 1'b0) begin
		eot <= 1'b0;
	end else begin
		eot <= response_dest_valid & response_dest_ready & response_dest_resp_eot;
	end
end

generate if (C_CLKS_ASYNC_REQ_SRC) begin

wire src_async_resetn_source;

if (C_DMA_TYPE_SRC == DMA_TYPE_MM_AXI) begin
assign src_async_resetn_source = m_src_axi_aresetn;
end else begin
assign src_async_resetn_source = req_aresetn;
end

reg [2:0] src_reset_shift = 3'b111;
assign src_resetn = ~src_reset_shift[2];

always @(negedge src_async_resetn_source or posedge src_clk) begin
	if (src_async_resetn_source == 1'b0)
		src_reset_shift <= 3'b111;
	else
		src_reset_shift <= {src_reset_shift[1:0], 1'b0};
end

end else begin
assign src_resetn = req_aresetn;
end endgenerate

generate if (C_CLKS_ASYNC_DEST_REQ) begin
wire dest_async_resetn_source;

if (C_DMA_TYPE_DEST == DMA_TYPE_MM_AXI) begin
assign dest_async_resetn_source = m_dest_axi_aresetn;
end else begin
assign dest_async_resetn_source = req_aresetn;
end

reg [2:0] dest_reset_shift = 3'b111;
assign dest_resetn = ~dest_reset_shift[2];

always @(negedge dest_async_resetn_source or posedge dest_clk) begin
	if (dest_async_resetn_source == 1'b0)
		dest_reset_shift <= 3'b111;
	else
		dest_reset_shift <= {dest_reset_shift[1:0], 1'b0};
end

end else begin
assign dest_resetn = req_aresetn;
end endgenerate

generate if (C_DMA_TYPE_DEST == DMA_TYPE_MM_AXI) begin

assign dest_clk = m_dest_axi_aclk;

wire [C_ID_WIDTH-1:0] dest_data_id;
wire [C_ID_WIDTH-1:0] dest_address_id;
wire dest_address_eot = eot_mem[dest_address_id];
wire dest_data_eot = eot_mem[dest_data_id];
wire dest_response_eot = eot_mem[dest_response_id];

assign dbg_dest_address_id = dest_address_id;
assign dbg_dest_data_id = dest_data_id;

dmac_dest_mm_axi #(
	.C_ID_WIDTH(C_ID_WIDTH),
	.C_DMA_DATA_WIDTH(C_DMA_DATA_WIDTH_DEST),
	.C_BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH_DEST),
	.C_BYTES_PER_BEAT_WIDTH(C_BYTES_PER_BEAT_WIDTH_DEST)
) i_dest_dma_mm (
	.m_axi_aclk(m_dest_axi_aclk),
	.m_axi_aresetn(dest_resetn),

	.enable(dest_enable),
	.enabled(dest_enabled),
	.pause(dest_pause),

	.req_valid(dest_req_valid),
	.req_ready(dest_req_ready),
	.req_address(dest_req_address),
	.req_last_burst_length(dest_req_last_burst_length),
	.req_last_beat_bytes(dest_req_last_beat_bytes),

	.response_valid(dest_response_valid),
	.response_ready(dest_response_ready),
	.response_resp(dest_response_resp),
	.response_resp_eot(dest_response_resp_eot),

	.request_id(dest_request_id),
	.response_id(dest_response_id),
	.sync_id(dest_sync_id),
	.sync_id_ret(dest_sync_id_ret),

	.data_id(dest_data_id),
	.address_id(dest_address_id),

	.address_eot(dest_address_eot),
	.data_eot(dest_data_eot),
	.response_eot(dest_response_eot),

	.fifo_valid(dest_valid),
	.fifo_ready(dest_ready),
	.fifo_data(dest_data),

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

if (C_DMA_TYPE_DEST == DMA_TYPE_STREAM_AXI) begin

assign dest_clk = m_axis_aclk;

wire [C_ID_WIDTH-1:0] data_id;

wire data_eot = eot_mem[data_id];
wire response_eot = eot_mem[dest_response_id];

assign dbg_dest_address_id = 'h00;
assign dbg_dest_data_id = data_id;

dmac_dest_axi_stream #(
	.C_ID_WIDTH(C_ID_WIDTH),
	.C_S_AXIS_DATA_WIDTH(C_DMA_DATA_WIDTH_DEST),
	.C_BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH_DEST)
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

	.request_id(dest_request_id),
	.response_id(dest_response_id),
	.data_id(data_id),
	.sync_id(dest_sync_id),
	.sync_id_ret(dest_sync_id_ret),
        .xfer_req(m_axis_xfer_req),

	.data_eot(data_eot),
	.response_eot(response_eot),

	.fifo_valid(dest_valid),
	.fifo_ready(dest_ready),
	.fifo_data(dest_data),

	.m_axis_valid(m_axis_valid),
	.m_axis_ready(m_axis_ready),
	.m_axis_data(m_axis_data),
        .m_axis_last(m_axis_last)
);

end else begin

assign m_axis_valid = 1'b0;
assign m_axis_data = 'h00;

end 

if (C_DMA_TYPE_DEST == DMA_TYPE_FIFO) begin

assign dest_clk = fifo_rd_clk;

wire [C_ID_WIDTH-1:0] data_id;

wire data_eot = eot_mem[data_id];
wire response_eot = eot_mem[dest_response_id];

assign dbg_dest_address_id = 'h00;
assign dbg_dest_data_id = data_id;

dmac_dest_fifo_inf #(
	.C_ID_WIDTH(C_ID_WIDTH),
	.C_DATA_WIDTH(C_DMA_DATA_WIDTH_DEST),
	.C_BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH_DEST)
) i_dest_dma_fifo (
	.clk(fifo_rd_clk),
	.resetn(dest_resetn),

	.enable(dest_enable),
	.enabled(dest_enabled),

	.req_valid(dest_req_valid),
	.req_ready(dest_req_ready),
	.req_last_burst_length(dest_req_last_burst_length),

	.response_valid(dest_response_valid),
	.response_ready(dest_response_ready),
	.response_resp(dest_response_resp),
	.response_resp_eot(dest_response_resp_eot),

	.request_id(dest_request_id),
	.response_id(dest_response_id),
	.data_id(data_id),
	.sync_id(dest_sync_id),
	.sync_id_ret(dest_sync_id_ret),

	.data_eot(data_eot),
	.response_eot(response_eot),

	.fifo_valid(dest_valid),
	.fifo_ready(dest_ready),
	.fifo_data(dest_data),

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

end endgenerate

generate if (C_DMA_TYPE_SRC == DMA_TYPE_MM_AXI) begin

assign src_clk = m_src_axi_aclk;

wire [C_ID_WIDTH-1:0] src_data_id;
wire [C_ID_WIDTH-1:0] src_address_id;
wire src_address_eot = eot_mem[src_address_id];
wire src_data_eot = eot_mem[src_data_id];

assign dbg_src_address_id = src_address_id;
assign dbg_src_data_id = src_data_id;

dmac_src_mm_axi #(
	.C_ID_WIDTH(C_ID_WIDTH),
	.C_DMA_DATA_WIDTH(C_DMA_DATA_WIDTH_SRC),
	.C_BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH_SRC),
	.C_BYTES_PER_BEAT_WIDTH(C_BYTES_PER_BEAT_WIDTH_SRC)
) i_src_dma_mm (
	.m_axi_aclk(m_src_axi_aclk),
	.m_axi_aresetn(src_resetn),

	.pause(src_pause),
	.enable(src_enable),
	.enabled(src_enabled),
	.sync_id(src_sync_id),
	.sync_id_ret(src_sync_id_ret),

	.req_valid(src_req_valid),
	.req_ready(src_req_ready),
	.req_address(src_req_address),
	.req_last_burst_length(src_req_last_burst_length),

	.response_valid(src_response_valid),
	.response_ready(src_response_ready),
	.response_resp(src_response_resp),

	.request_id(src_request_id),
	.response_id(src_response_id),
	.address_id(src_address_id),
	.data_id(src_data_id),

	.address_eot(src_address_eot),
	.data_eot(src_data_eot),

	.fifo_valid(src_valid),
	.fifo_ready(src_ready),
	.fifo_data(src_data),

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

if (C_DMA_TYPE_SRC == DMA_TYPE_STREAM_AXI) begin

assign src_clk = s_axis_aclk;

wire src_eot = eot_mem[src_response_id];

assign dbg_src_address_id = 'h00;
assign dbg_src_data_id = 'h00;

/* TODO */
assign src_response_valid = 1'b0;
assign src_response_resp = 2'b0;

dmac_src_axi_stream #(
	.C_ID_WIDTH(C_ID_WIDTH),
	.C_S_AXIS_DATA_WIDTH(C_DMA_DATA_WIDTH_SRC),
	.C_BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH_SRC)
) i_src_dma_stream (
	.s_axis_aclk(s_axis_aclk),
	.s_axis_aresetn(src_resetn),

	.enable(src_enable),
	.enabled(src_enabled),
	.sync_id(src_sync_id),
	.sync_id_ret(src_sync_id_ret),

	.req_valid(src_req_valid),
	.req_ready(src_req_ready),
	.req_last_burst_length(src_req_last_burst_length),
	.req_sync_transfer_start(src_req_sync_transfer_start),

	.request_id(src_request_id),
	.response_id(src_response_id),

	.eot(src_eot),

	.fifo_valid(src_valid),
	.fifo_ready(src_ready),
	.fifo_data(src_data),

	.s_axis_valid(s_axis_valid),
	.s_axis_ready(s_axis_ready),
	.s_axis_data(s_axis_data),
	.s_axis_user(s_axis_user),
	.s_axis_xfer_req(s_axis_xfer_req)
);

end else begin

assign s_axis_ready = 1'b0;

end

if (C_DMA_TYPE_SRC == DMA_TYPE_FIFO) begin

assign src_clk = fifo_wr_clk;

wire src_eot = eot_mem[src_response_id];

assign dbg_src_address_id = 'h00;
assign dbg_src_data_id = 'h00;

/* TODO */
assign src_response_valid = 1'b0;
assign src_response_resp = 2'b0;

dmac_src_fifo_inf #(
	.C_ID_WIDTH(C_ID_WIDTH),
	.C_DATA_WIDTH(C_DMA_DATA_WIDTH_SRC),
	.C_BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH_SRC)
) i_src_dma_fifo (
	.clk(fifo_wr_clk),
	.resetn(src_resetn),

	.enable(src_enable),
	.enabled(src_enabled),
	.sync_id(src_sync_id),
	.sync_id_ret(src_sync_id_ret),

	.req_valid(src_req_valid),
	.req_ready(src_req_ready),
	.req_last_burst_length(src_req_last_burst_length),
	.req_sync_transfer_start(src_req_sync_transfer_start),

	.request_id(src_request_id),
	.response_id(src_response_id),

	.eot(src_eot),

	.fifo_valid(src_valid),
	.fifo_ready(src_ready),
	.fifo_data(src_data),

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
	.NUM_BITS(C_ID_WIDTH),
	.CLK_ASYNC(C_CLKS_ASYNC_REQ_SRC)
) i_sync_src_request_id (
	.out_clk(src_clk),
	.out_resetn(src_resetn),
	.in(request_id),
	.out(src_request_id)
);

sync_bits #(
	.NUM_BITS(C_ID_WIDTH),
	.CLK_ASYNC(C_CLKS_ASYNC_SRC_DEST)
) i_sync_dest_request_id (
	.out_clk(dest_clk),
	.out_resetn(dest_resetn),
	.in(src_response_id),
	.out(dest_request_id)
);

sync_bits #(
	.NUM_BITS(C_ID_WIDTH),
	.CLK_ASYNC(C_CLKS_ASYNC_DEST_REQ)
) i_sync_req_response_id (
	.out_clk(req_aclk),
	.out_resetn(req_aresetn),
	.in(dest_response_id),
	.out(response_id)
);

axi_register_slice #(
	.DATA_WIDTH(C_DMA_DATA_WIDTH_SRC),
	.FORWARD_REGISTERED(C_AXI_SLICE_SRC),
	.BACKWARD_REGISTERED(C_AXI_SLICE_SRC)
) i_src_slice (
	.clk(src_clk),
	.resetn(src_resetn),
	.s_axi_valid(src_valid),
	.s_axi_ready(src_ready),
	.s_axi_data(src_data),
	.m_axi_valid(src_fifo_valid),
	.m_axi_ready(src_fifo_ready),
	.m_axi_data(src_fifo_data)
);

util_axis_resize #(
	.C_S_DATA_WIDTH(C_DMA_DATA_WIDTH_SRC),
	.C_M_DATA_WIDTH(DMA_DATA_WIDTH)
) i_src_repack (
	.clk(src_clk),
	.resetn(src_resetn & src_enable),
	.s_valid(src_fifo_valid),
	.s_ready(src_fifo_ready),
	.s_data(src_fifo_data),
	.m_valid(src_fifo_repacked_valid),
	.m_ready(src_fifo_repacked_ready),
	.m_data(src_fifo_repacked_data)
);

util_axis_fifo #(
	.C_DATA_WIDTH(DMA_DATA_WIDTH),
	.C_ADDRESS_WIDTH($clog2(C_MAX_BYTES_PER_BURST / (DMA_DATA_WIDTH / 8) * C_FIFO_SIZE)),
	.C_CLKS_ASYNC(C_CLKS_ASYNC_SRC_DEST)
) i_fifo (
	.s_axis_aclk(src_clk),
	.s_axis_aresetn(src_resetn),
	.s_axis_valid(src_fifo_repacked_valid),
	.s_axis_ready(src_fifo_repacked_ready),
	.s_axis_data(src_fifo_repacked_data),
	.s_axis_empty(src_fifo_empty),

	.m_axis_aclk(dest_clk),
	.m_axis_aresetn(dest_resetn),
	.m_axis_valid(dest_fifo_valid),
	.m_axis_ready(dest_fifo_ready),
	.m_axis_data(dest_fifo_data)
);

util_axis_resize #(
	.C_S_DATA_WIDTH(DMA_DATA_WIDTH),
	.C_M_DATA_WIDTH(C_DMA_DATA_WIDTH_DEST)
) i_dest_repack (
	.clk(dest_clk),
	.resetn(dest_resetn & dest_enable),
	.s_valid(dest_fifo_valid),
	.s_ready(dest_fifo_ready),
	.s_data(dest_fifo_data),
	.m_valid(dest_fifo_repacked_valid),
	.m_ready(dest_fifo_repacked_ready),
	.m_data(dest_fifo_repacked_data)
);

wire _dest_valid;
wire _dest_ready;
wire [C_DMA_DATA_WIDTH_DEST-1:0] _dest_data;

axi_register_slice #(
	.DATA_WIDTH(C_DMA_DATA_WIDTH_DEST),
	.FORWARD_REGISTERED(C_AXI_SLICE_DEST)
) i_dest_slice2 (
	.clk(dest_clk),
	.resetn(dest_resetn),
	.s_axi_valid(dest_fifo_repacked_valid),
	.s_axi_ready(dest_fifo_repacked_ready),
	.s_axi_data(dest_fifo_repacked_data),
	.m_axi_valid(_dest_valid),
	.m_axi_ready(_dest_ready),
	.m_axi_data(_dest_data)
);

axi_register_slice #(
	.DATA_WIDTH(C_DMA_DATA_WIDTH_DEST),
	.FORWARD_REGISTERED(C_AXI_SLICE_DEST),
	.BACKWARD_REGISTERED(C_AXI_SLICE_DEST)
) i_dest_slice (
	.clk(dest_clk),
	.resetn(dest_resetn),
	.s_axi_valid(_dest_valid),
	.s_axi_ready(_dest_ready),
	.s_axi_data(_dest_data),
	.m_axi_valid(dest_valid),
	.m_axi_ready(dest_ready),
	.m_axi_data(dest_data)
);


// We do not accept any requests until all components are enabled
reg _req_valid = 1'b0;
wire _req_ready;

always @(posedge req_aclk)
begin
	if (req_aresetn == 1'b0) begin
		_req_valid <= 1'b0;
	end else begin
		if (_req_valid == 1'b1 && _req_ready == 1'b1) begin
			_req_valid <= 1'b0;
		end else if (req_valid == 1'b1 && enabled == 1'b1) begin
			_req_valid <= 1'b1;
		end
	end
end

assign req_ready = _req_ready & _req_valid & enable;

splitter #(
	.C_NUM_M(3)
) i_req_splitter (
	.clk(req_aclk),
	.resetn(req_aresetn),
	.s_valid(_req_valid),
	.s_ready(_req_ready),
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
	.C_DATA_WIDTH(DMA_ADDR_WIDTH_DEST + BEATS_PER_BURST_WIDTH_DEST + C_BYTES_PER_BEAT_WIDTH_DEST + 1),
	.C_ADDRESS_WIDTH(0),
	.C_CLKS_ASYNC(C_CLKS_ASYNC_DEST_REQ)
) i_dest_req_fifo (
	.s_axis_aclk(req_aclk),
	.s_axis_aresetn(req_aresetn),
	.s_axis_valid(req_dest_valid),
	.s_axis_ready(req_dest_ready),
	.s_axis_empty(req_dest_empty),
	.s_axis_data({
		req_dest_address,
		req_length[BYTES_PER_BURST_WIDTH-1:C_BYTES_PER_BEAT_WIDTH_DEST],
		req_length[C_BYTES_PER_BEAT_WIDTH_DEST-1:0],
                req_xlast
	}),
	.m_axis_aclk(dest_clk),
	.m_axis_aresetn(dest_resetn),
	.m_axis_valid(dest_req_valid),
	.m_axis_ready(dest_req_ready),
	.m_axis_data({
		dest_req_address,
		dest_req_last_burst_length,
		dest_req_last_beat_bytes,
                dest_req_xlast
	})
);

util_axis_fifo #(
	.C_DATA_WIDTH(DMA_ADDR_WIDTH_SRC + BEATS_PER_BURST_WIDTH_SRC + 1),
	.C_ADDRESS_WIDTH(0),
	.C_CLKS_ASYNC(C_CLKS_ASYNC_REQ_SRC)
) i_src_req_fifo (
	.s_axis_aclk(req_aclk),
	.s_axis_aresetn(req_aresetn),
	.s_axis_valid(req_src_valid),
	.s_axis_ready(req_src_ready),
	.s_axis_empty(req_src_empty),
	.s_axis_data({
		req_src_address,
		req_length[BYTES_PER_BURST_WIDTH-1:C_BYTES_PER_BEAT_WIDTH_SRC],
		req_sync_transfer_start
	}),
	.m_axis_aclk(src_clk),
	.m_axis_aresetn(src_resetn),
	.m_axis_valid(src_req_valid),
	.m_axis_ready(src_req_ready),
	.m_axis_data({
		src_req_address,
		src_req_last_burst_length,
		src_req_sync_transfer_start
	})
);

util_axis_fifo #(
	.C_DATA_WIDTH(3),
	.C_ADDRESS_WIDTH(0),
	.C_CLKS_ASYNC(C_CLKS_ASYNC_DEST_REQ)
) i_dest_response_fifo (
	.s_axis_aclk(dest_clk),
	.s_axis_aresetn(dest_resetn),
	.s_axis_valid(dest_response_valid),
	.s_axis_ready(dest_response_ready),
	.s_axis_empty(dest_response_empty),
	.s_axis_data(dest_response_resp_eot),
	.m_axis_aclk(req_aclk),
	.m_axis_aresetn(req_aresetn),
	.m_axis_valid(response_dest_valid),
	.m_axis_ready(response_dest_ready),
	.m_axis_data(response_dest_resp_eot)
);

/* Unused for now
util_axis_fifo #(
	.C_DATA_WIDTH(2),
	.C_ADDRESS_WIDTH(0),
	.C_CLKS_ASYNC(C_CLKS_ASYNC_REQ_SRC)
) i_src_response_fifo (
	.s_axis_aclk(src_clk),
	.s_axis_aresetn(src_resetn),
	.s_axis_valid(src_response_valid),
	.s_axis_ready(src_response_ready),
	.s_axis_empty(src_response_empty),
	.s_axis_data(src_response_resp),
	.m_axis_aclk(req_aclk),
	.m_axis_aresetn(req_aresetn),
	.m_axis_valid(response_src_valid),
	.m_axis_ready(response_src_ready),
	.m_axis_data(response_src_resp)
);*/
assign src_response_empty = 1'b1;
assign src_response_ready = 1'b1;

dmac_request_generator #(
	.C_ID_WIDTH(C_ID_WIDTH),
	.C_BURSTS_PER_TRANSFER_WIDTH(BURSTS_PER_TRANSFER_WIDTH)
) i_req_gen (
	.req_aclk(req_aclk),
	.req_aresetn(req_aresetn),

	.request_id(request_id),
	.response_id(response_id),

	.req_valid(req_gen_valid),
	.req_ready(req_gen_ready),
	.req_burst_count(req_length[C_DMA_LENGTH_WIDTH-1:BYTES_PER_BURST_WIDTH]),

	.enable(do_enable),
	.pause(pause),

	.eot(request_eot)
);

sync_bits #(
	.NUM_BITS(3),
	.CLK_ASYNC(C_CLKS_ASYNC_DEST_REQ)
) i_sync_control_dest (
	.out_clk(dest_clk),
	.out_resetn(dest_resetn),
	.in({do_enable, pause, sync_id}),
	.out({dest_enable, dest_pause, dest_sync_id})
);

sync_bits #(
	.NUM_BITS(2),
	.CLK_ASYNC(C_CLKS_ASYNC_DEST_REQ)
) i_sync_status_dest (
	.out_clk(req_aclk),
	.out_resetn(req_aresetn),
	.in({dest_enabled | ~dest_response_empty, dest_sync_id_ret}),
	.out({enabled_dest, sync_id_ret_dest})
);

sync_bits #(
	.NUM_BITS(3),
	.CLK_ASYNC(C_CLKS_ASYNC_REQ_SRC)
) i_sync_control_src (
	.out_clk(src_clk),
	.out_resetn(src_resetn),
	.in({do_enable, pause, sync_id}),
	.out({src_enable, src_pause, src_sync_id})
);

sync_bits #(
	.NUM_BITS(3),
	.CLK_ASYNC(C_CLKS_ASYNC_REQ_SRC)
) i_sync_status_src (
	.out_clk(req_aclk),
	.out_resetn(req_aresetn),
	.in({src_enabled | ~src_response_empty, src_sync_id_ret, src_fifo_empty}),
	.out({enabled_src, sync_id_ret_src, fifo_empty})
);

endmodule
