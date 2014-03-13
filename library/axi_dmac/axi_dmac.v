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

module axi_dmac (
	// Slave AXI interface
	input s_axi_aclk,
	input s_axi_aresetn,

	input         s_axi_awvalid,
	input  [31:0] s_axi_awaddr,
	output        s_axi_awready,
	input         s_axi_wvalid,
	input  [31:0] s_axi_wdata,
	input  [ 3:0] s_axi_wstrb,
	output        s_axi_wready,
	output        s_axi_bvalid,
	output [ 1:0] s_axi_bresp,
	input         s_axi_bready,
	input         s_axi_arvalid,
	input  [31:0] s_axi_araddr,
	output        s_axi_arready,
	output        s_axi_rvalid,
	input         s_axi_rready,
	output [ 1:0] s_axi_rresp,
	output [31:0] s_axi_rdata,

	// Interrupt
	output reg irq,

	// Master AXI interface
	input                                    m_dest_axi_aclk,
	input                                    m_dest_axi_aresetn,
	input                                    m_src_axi_aclk,
	input                                    m_src_axi_aresetn,

	// Write address
	output [31:0]                            m_dest_axi_awaddr,
	output [ 7:0]                            m_dest_axi_awlen,
	output [ 2:0]                            m_dest_axi_awsize,
	output [ 1:0]                            m_dest_axi_awburst,
	output [ 2:0]                            m_dest_axi_awprot,
	output [ 3:0]                            m_dest_axi_awcache,
	output                                   m_dest_axi_awvalid,
	input                                    m_dest_axi_awready,

	// Write data
	output [C_DMA_DATA_WIDTH_DEST-1:0]       m_dest_axi_wdata,
	output [(C_DMA_DATA_WIDTH_DEST/8)-1:0]   m_dest_axi_wstrb,
	input                                    m_dest_axi_wready,
	output                                   m_dest_axi_wvalid,
	output                                   m_dest_axi_wlast,

	// Write response
	input                                    m_dest_axi_bvalid,
	input  [ 1:0]                            m_dest_axi_bresp,
	output                                   m_dest_axi_bready,

	// Read address
	input                                    m_src_axi_arready,
	output                                   m_src_axi_arvalid,
	output [31:0]                            m_src_axi_araddr,
	output [ 7:0]                            m_src_axi_arlen,
	output [ 2:0]                            m_src_axi_arsize,
	output [ 1:0]                            m_src_axi_arburst,
	output [ 2:0]                            m_src_axi_arprot,
	output [ 3:0]                            m_src_axi_arcache,

	// Read data and response
	input  [C_DMA_DATA_WIDTH_SRC-1:0]        m_src_axi_rdata,
	output                                   m_src_axi_rready,
	input                                    m_src_axi_rvalid,
	input  [ 1:0]                            m_src_axi_rresp,

	// Slave streaming AXI interface
	input                                    s_axis_aclk,
	output                                   s_axis_ready,
	input                                    s_axis_valid,
	input  [C_DMA_DATA_WIDTH_SRC-1:0]        s_axis_data,
	input  [0:0]                             s_axis_user,

	// Master streaming AXI interface
	input                                    m_axis_aclk,
	input                                    m_axis_ready,
	output                                   m_axis_valid,
	output [C_DMA_DATA_WIDTH_DEST-1:0]       m_axis_data,

	// Input FIFO interface
	input                                    fifo_wr_clk,
	input                                    fifo_wr_en,
	input  [C_DMA_DATA_WIDTH_SRC-1:0]        fifo_wr_din,
	output                                   fifo_wr_overflow,
	input                                    fifo_wr_sync,

	// Input FIFO interface
	input                                    fifo_rd_clk,
	input                                    fifo_rd_en,
	output                                   fifo_rd_valid,
	output [C_DMA_DATA_WIDTH_DEST-1:0]       fifo_rd_dout,
	output                                   fifo_rd_underflow
);

parameter PCORE_ID = 0;

parameter C_BASEADDR = 32'hffffffff;
parameter C_HIGHADDR = 32'h00000000;
parameter C_DMA_DATA_WIDTH_SRC = 64;
parameter C_DMA_DATA_WIDTH_DEST = 64;
parameter C_ADDR_ALIGN_BITS = 3;
parameter C_DMA_LENGTH_WIDTH = 14;
parameter C_2D_TRANSFER = 1;

parameter C_CLKS_ASYNC_REQ_SRC = 1;
parameter C_CLKS_ASYNC_SRC_DEST = 1;
parameter C_CLKS_ASYNC_DEST_REQ = 1;

parameter C_AXI_SLICE_DEST = 0;
parameter C_AXI_SLICE_SRC = 0;
parameter C_SYNC_TRANSFER_START = 0;
parameter C_CYCLIC = 1;

parameter C_DMA_TYPE_DEST = DMA_TYPE_AXI_MM;
parameter C_DMA_TYPE_SRC = DMA_TYPE_FIFO;

localparam DMA_TYPE_AXI_MM = 0;
localparam DMA_TYPE_AXI_STREAM = 1;
localparam DMA_TYPE_FIFO = 2;

localparam PCORE_VERSION = 'h00040061;
localparam DMA_ADDR_WIDTH = 32 - C_ADDR_ALIGN_BITS;

localparam HAS_DEST_ADDR = C_DMA_TYPE_DEST == DMA_TYPE_AXI_MM;
localparam HAS_SRC_ADDR = C_DMA_TYPE_SRC == DMA_TYPE_AXI_MM;

// Register interface signals
reg  [31:0]  up_rdata = 'd0;
wire         up_wr;
wire         up_sel;
wire [31:0]  up_wdata;
wire [13:0]  up_addr;
wire         up_write;

// Scratch register
reg [31:0] up_scratch = 'h00;

// Control bits
reg up_enable = 'h00;
reg up_pause = 'h00;

// Start and end of transfer
wire up_eot; // Asserted for one cycle when a transfer has been completed
wire up_sot; // Asserted for one cycle when a transfer has been queued

// Interupt handling
reg [1:0] up_irq_mask = 'h3;
reg [1:0] up_irq_source = 'h0;
wire [1:0] up_irq_pending;
wire [1:0] up_irq_trigger;
wire [1:0] up_irq_source_clear;

// DMA transfer signals
reg  up_dma_req_valid = 1'b0;
wire up_dma_req_ready;

reg [1:0] up_transfer_id;
reg [1:0] up_transfer_id_eot;
reg [3:0] up_transfer_done_bitmap;

reg [31:C_ADDR_ALIGN_BITS]   up_dma_dest_address = 'h00;
reg [31:C_ADDR_ALIGN_BITS]   up_dma_src_address = 'h00;
reg [C_DMA_LENGTH_WIDTH-1:0] up_dma_x_length = 'h00;
reg [C_DMA_LENGTH_WIDTH-1:0] up_dma_y_length = 'h00;
reg [C_DMA_LENGTH_WIDTH-1:0] up_dma_src_stride = 'h00;
reg [C_DMA_LENGTH_WIDTH-1:0] up_dma_dest_stride = 'h00;
wire up_dma_sync_transfer_start = C_SYNC_TRANSFER_START ? 1'b1 : 1'b0;

// ID signals from the DMAC, just for debugging
wire [2:0] dest_request_id;
wire [2:0] dest_data_id;
wire [2:0] dest_address_id;
wire [2:0] dest_response_id;
wire [2:0] src_request_id;
wire [2:0] src_data_id;
wire [2:0] src_address_id;
wire [2:0] src_response_id;
wire [7:0] dbg_status;

up_axi #(
	.PCORE_BASEADDR (C_BASEADDR),
	.PCORE_HIGHADDR (C_HIGHADDR)
) i_up_axi (
	.up_rstn(s_axi_aresetn),
	.up_clk(s_axi_aclk),
	.up_axi_awvalid(s_axi_awvalid),
	.up_axi_awaddr(s_axi_awaddr),
	.up_axi_awready(s_axi_awready),
	.up_axi_wvalid(s_axi_wvalid),
	.up_axi_wdata(s_axi_wdata),
	.up_axi_wstrb(s_axi_wstrb),
	.up_axi_wready(s_axi_wready),
	.up_axi_bvalid(s_axi_bvalid),
	.up_axi_bresp(s_axi_bresp),
	.up_axi_bready(s_axi_bready),
	.up_axi_arvalid(s_axi_arvalid),
	.up_axi_araddr(s_axi_araddr),
	.up_axi_arready(s_axi_arready),
	.up_axi_rvalid(s_axi_rvalid),
	.up_axi_rresp(s_axi_rresp),
	.up_axi_rdata(s_axi_rdata),
	.up_axi_rready(s_axi_rready),
	.up_wr(up_wr),
	.up_sel(up_sel),
	.up_addr(up_addr),
	.up_wdata(up_wdata),
	.up_rdata(up_rdata),
	.up_ack(up_sel)
);

// IRQ handling
assign up_irq_pending = ~up_irq_mask & up_irq_source;
assign up_irq_trigger  = {up_eot, up_sot};
assign up_irq_source_clear = (up_write == 1'b1 && up_addr[11:0] == 12'h021) ? up_wdata[1:0] : 0;

always @(posedge s_axi_aclk)
begin
	if (s_axi_aresetn == 1'b0)
		irq <= 1'b0;
	else
		irq <= |up_irq_pending;
end

always @(posedge s_axi_aclk)
begin
	if (s_axi_aresetn == 1'b0) begin
		up_irq_source <= 2'b00;
	end else begin
		up_irq_source <= up_irq_trigger | (up_irq_source & ~up_irq_source_clear);
	end
end

// Register Interface
assign up_write = up_wr & up_sel;

always @(posedge s_axi_aclk)
begin
	if (s_axi_aresetn == 1'b0) begin
		up_enable <= 'h00;
		up_pause <= 'h00;
		up_dma_src_address <= 'h00;
		up_dma_dest_address <= 'h00;
		up_dma_y_length <= 'h00;
		up_dma_x_length <= 'h00;
		up_dma_dest_stride <= 'h00;
		up_dma_src_stride <= 'h00;
		up_irq_mask <= 3'b11;
		up_dma_req_valid <= 1'b0;
		up_scratch <= 'h00;
	end else begin
		if (up_enable == 1'b1) begin
			if (up_write && up_addr[11:0] == 12'h102) begin
				up_dma_req_valid <= up_dma_req_valid | up_wdata[0];
			end else if (up_sot) begin
				up_dma_req_valid <= 1'b0;
			end
		end else begin
			up_dma_req_valid <= 1'b0;
		end

		if (up_write) begin
			case (up_addr[11:0])
			12'h002: up_scratch <= up_wdata;
			12'h020: up_irq_mask <= up_wdata;
			12'h100: {up_pause, up_enable} <= up_wdata[1:0];
			12'h104: up_dma_dest_address <= up_wdata[31:C_ADDR_ALIGN_BITS];
			12'h105: up_dma_src_address <= up_wdata[31:C_ADDR_ALIGN_BITS];
			12'h106: up_dma_x_length <= up_wdata[C_DMA_LENGTH_WIDTH-1:0];
			12'h107: up_dma_y_length <= up_wdata[C_DMA_LENGTH_WIDTH-1:0];
			12'h108: up_dma_dest_stride <= up_wdata[C_DMA_LENGTH_WIDTH-1:0];
			12'h109: up_dma_src_stride <= up_wdata[C_DMA_LENGTH_WIDTH-1:0];
			endcase
		end
	end
end

always @(posedge s_axi_aclk)
begin
	if (s_axi_aresetn == 1'b0) begin
		up_rdata <= 'h00;
	end else begin
		case (up_addr[11:0])
		12'h000: up_rdata <= PCORE_VERSION;
		12'h001: up_rdata <= PCORE_ID;
		12'h002: up_rdata <= up_scratch;
		12'h020: up_rdata <= up_irq_mask;
		12'h021: up_rdata <= up_irq_pending;
		12'h022: up_rdata <= up_irq_source;
		12'h100: up_rdata <= {up_pause, up_enable};
		12'h101: up_rdata <= up_transfer_id;
		12'h102: up_rdata <= up_dma_req_valid;
		12'h103: up_rdata <= 'h00; // Flags
		12'h104: up_rdata <= HAS_DEST_ADDR ? {up_dma_dest_address,{C_ADDR_ALIGN_BITS{1'b0}}} : 'h00;
		12'h105: up_rdata <= HAS_SRC_ADDR ? {up_dma_src_address,{C_ADDR_ALIGN_BITS{1'b0}}} : 'h00;
		12'h106: up_rdata <= up_dma_x_length;
		12'h107: up_rdata <= C_2D_TRANSFER ? up_dma_y_length : 'h00;
		12'h108: up_rdata <= C_2D_TRANSFER ? up_dma_dest_stride : 'h00;
		12'h109: up_rdata <= C_2D_TRANSFER ? up_dma_src_stride : 'h00;
		12'h10a: up_rdata <= up_transfer_done_bitmap;
		12'h10b: up_rdata <= up_transfer_id_eot;
		12'h10c: up_rdata <= 'h00; // Status
		12'h10d: up_rdata <= m_dest_axi_awaddr; //HAS_DEST_ADDR ? 'h00 : 'h00; // Current dest address
		12'h10e: up_rdata <= m_src_axi_araddr; //HAS_SRC_ADDR ? 'h00 : 'h00; // Current src address
		12'h10f: up_rdata <= {src_response_id, 1'b0, src_data_id, 1'b0, src_address_id, 1'b0, src_request_id,
							1'b0, dest_response_id, 1'b0, dest_data_id, 1'b0, dest_address_id, 1'b0, dest_request_id};
		12'h110: up_rdata <= dbg_status;
		default: up_rdata <= 'h00;
		endcase
	end
end

// Request ID and Request done bitmap handling
always @(posedge s_axi_aclk)
begin
	if (s_axi_aresetn == 1'b0 || up_enable == 1'b0) begin
		up_transfer_id <= 'h0;
		up_transfer_id_eot <= 'h0;
		up_transfer_done_bitmap <= 'h0;
	end begin
		if (up_dma_req_valid == 1'b1 && up_dma_req_ready == 1'b1) begin
			up_transfer_id <= up_transfer_id + 1'b1;
			up_transfer_done_bitmap[up_transfer_id] <= 1'b0;
		end
		if (up_eot == 1'b1) begin
			up_transfer_done_bitmap[up_transfer_id_eot] <= 1'b1;
			up_transfer_id_eot <= up_transfer_id_eot + 1'b1;
		end
	end
end

wire dma_req_valid;
wire dma_req_ready;
wire [31:C_ADDR_ALIGN_BITS] dma_req_dest_address;
wire [31:C_ADDR_ALIGN_BITS] dma_req_src_address;
wire [C_DMA_LENGTH_WIDTH-1:0] dma_req_length;
wire dma_req_eot;
wire dma_req_sync_transfer_start;
wire up_req_eot;

assign up_sot = C_CYCLIC ? 1'b0 : up_dma_req_valid & up_dma_req_ready;
assign up_eot = C_CYCLIC ? 1'b0 : up_req_eot;


generate if (C_2D_TRANSFER == 1) begin

dmac_2d_transfer #(
	.C_DMA_LENGTH_WIDTH(C_DMA_LENGTH_WIDTH),
	.C_ADDR_ALIGN_BITS(C_ADDR_ALIGN_BITS)
) i_2d_transfer (
	.req_aclk(s_axi_aclk),
	.req_aresetn(s_axi_aresetn),

	.req_eot(up_req_eot),

	.req_valid(up_dma_req_valid),
	.req_ready(up_dma_req_ready),
	.req_dest_address(up_dma_dest_address),
	.req_src_address(up_dma_src_address),
	.req_x_length(up_dma_x_length),
	.req_y_length(up_dma_y_length),
	.req_dest_stride(up_dma_dest_stride),
	.req_src_stride(up_dma_src_stride),
	.req_sync_transfer_start(up_dma_sync_transfer_start),

	.out_req_valid(dma_req_valid),
	.out_req_ready(dma_req_ready),
	.out_req_dest_address(dma_req_dest_address),
	.out_req_src_address(dma_req_src_address),
	.out_req_length(dma_req_length),
	.out_req_sync_transfer_start(dma_req_sync_transfer_start),
	.out_eot(dma_req_eot)
);

end else begin

assign dma_req_valid = up_dma_req_valid;
assign up_dma_req_ready = dma_req_ready;
assign dma_req_dest_address = up_dma_dest_address;
assign dma_req_src_address = up_dma_src_address;
assign dma_req_length = up_dma_x_length;
assign dma_req_sync_transfer_start = up_dma_sync_transfer_start;
assign up_req_eot = dma_req_eot;

end endgenerate

dmac_request_arb #(
	.C_ID_WIDTH(3),
	.C_DMA_DATA_WIDTH_SRC(C_DMA_DATA_WIDTH_SRC),
	.C_DMA_DATA_WIDTH_DEST(C_DMA_DATA_WIDTH_DEST),
	.C_DMA_LENGTH_WIDTH(C_DMA_LENGTH_WIDTH),
	.C_ADDR_ALIGN_BITS(C_ADDR_ALIGN_BITS),
	.C_DMA_TYPE_DEST(C_DMA_TYPE_DEST),
	.C_DMA_TYPE_SRC(C_DMA_TYPE_SRC),
	.C_CLKS_ASYNC_REQ_SRC(C_CLKS_ASYNC_REQ_SRC),
	.C_CLKS_ASYNC_SRC_DEST(C_CLKS_ASYNC_SRC_DEST),
	.C_CLKS_ASYNC_DEST_REQ(C_CLKS_ASYNC_DEST_REQ),
	.C_AXI_SLICE_DEST(C_AXI_SLICE_DEST),
	.C_AXI_SLICE_SRC(C_AXI_SLICE_SRC)
) i_request_arb (
	.req_aclk(s_axi_aclk),
	.req_aresetn(s_axi_aresetn),

	.enable(up_enable),
	.pause(up_pause),

	.req_valid(dma_req_valid),
	.req_ready(dma_req_ready),
	.req_dest_address(dma_req_dest_address),
	.req_src_address(dma_req_src_address),
	.req_length(dma_req_length),
	.req_sync_transfer_start(dma_req_sync_transfer_start),

	.eot(dma_req_eot),

	
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
	.m_axi_rresp(m_src_axi_rresp),

	
	.s_axis_aclk(s_axis_aclk),
	.s_axis_ready(s_axis_ready),
	.s_axis_valid(s_axis_valid),
	.s_axis_data(s_axis_data),
	.s_axis_user(s_axis_user),

	
	.m_axis_aclk(m_axis_aclk),
	.m_axis_ready(m_axis_ready),
	.m_axis_valid(m_axis_valid),
	.m_axis_data(m_axis_data),

	
	.fifo_wr_clk(fifo_wr_clk),
	.fifo_wr_en(fifo_wr_en),
	.fifo_wr_din(fifo_wr_din),
	.fifo_wr_overflow(fifo_wr_overflow),
	.fifo_wr_sync(fifo_wr_sync),

	
	.fifo_rd_clk(fifo_rd_clk),
	.fifo_rd_en(fifo_rd_en),
	.fifo_rd_valid(fifo_rd_valid),
	.fifo_rd_dout(fifo_rd_dout),
	.fifo_rd_underflow(fifo_rd_underflow),

	// DBG
	.dbg_dest_request_id(dest_request_id),
	.dbg_dest_address_id(dest_address_id),
	.dbg_dest_data_id(dest_data_id),
	.dbg_dest_response_id(dest_response_id),
	.dbg_src_request_id(src_request_id),
	.dbg_src_address_id(src_address_id),
	.dbg_src_data_id(src_data_id),
	.dbg_src_response_id(src_response_id),
	.dbg_status(dbg_status)
);

endmodule
