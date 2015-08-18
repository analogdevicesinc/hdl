// ***************************************************************************
// ***************************************************************************
// Copyright 2015(c) Analog Devices, Inc.
//  Author: Paul Cercueil <paul.cercueil@analog.com>
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


module dmac_sg (
	input req_aclk,
	input req_aresetn,

	input req_enable,

	input req_in_valid,
	output req_in_ready,

	output req_out_valid,
	input req_out_ready,

	input resp_in_valid,

	input [31:C_BYTES_PER_BEAT_WIDTH_SG] req_desc_address,

	output [31:C_BYTES_PER_BEAT_WIDTH_DEST] out_dest_address,
	output [31:C_BYTES_PER_BEAT_WIDTH_SRC] out_src_address,
	output [C_DMA_LENGTH_WIDTH-1:0] out_x_length,
	output [C_DMA_LENGTH_WIDTH-1:0] out_y_length,
	output [C_DMA_LENGTH_WIDTH-1:0] out_dest_stride,
	output [C_DMA_LENGTH_WIDTH-1:0] out_src_stride,
	output [31:0] resp_out_id,
	output resp_out_eot,
	output resp_out_valid,

	// Read address
	input                            m_axi_arready,
	output                           m_axi_arvalid,
	output [31:0]                    m_axi_araddr,
	output [ 7:0]                    m_axi_arlen,
	output [ 2:0]                    m_axi_arsize,
	output [ 1:0]                    m_axi_arburst,
	output [ 2:0]                    m_axi_arprot,
	output [ 3:0]                    m_axi_arcache,

	// Read data and response
	input  [63:0]                    m_axi_rdata,
	output                           m_axi_rready,
	input                            m_axi_rvalid,
	input  [ 1:0]                    m_axi_rresp
);

parameter C_BYTES_PER_BEAT_WIDTH_SG = 3;
parameter C_BYTES_PER_BEAT_WIDTH_DEST = 3;
parameter C_BYTES_PER_BEAT_WIDTH_SRC = 3;
parameter C_DMA_LENGTH_WIDTH = 24;

localparam STATE_IDLE = 0;
localparam STATE_SEND_ADDR = 1;
localparam STATE_RECV_DESC = 2;
localparam STATE_DESC_READY = 3;

localparam FLAG_IS_LAST_HWDESC = 1 << 0;
localparam FLAG_EOT_IRQ = 1 << 1;

reg [31:C_BYTES_PER_BEAT_WIDTH_DEST] dest_addr;
reg [31:C_BYTES_PER_BEAT_WIDTH_SRC] src_addr;
reg [31:C_BYTES_PER_BEAT_WIDTH_SG] next_desc_addr;
reg [C_DMA_LENGTH_WIDTH-1:0] x_length;
reg [C_DMA_LENGTH_WIDTH-1:0] y_length;
reg [C_DMA_LENGTH_WIDTH-1:0] dest_stride;
reg [C_DMA_LENGTH_WIDTH-1:0] src_stride;

reg [1:0] hwdesc_state;
reg [2:0] hwdesc_counter;
reg [31:0] hwdesc_flags;

reg [31:0] hwdesc_id;

assign out_dest_address = dest_addr;
assign out_src_address = src_addr;
assign out_x_length = x_length;
assign out_y_length = y_length;
assign out_dest_stride = dest_stride;
assign out_src_stride = src_stride;

wire fifo_in_valid;
wire fifo_in_ready;
wire fifo_out_valid;
wire fifo_out_ready;
wire fetch_valid;
wire fetch_ready;
wire [32:0] fifo_out_data;

assign req_in_ready = hwdesc_state == STATE_IDLE ? 1'b1 : 1'b0;
assign fetch_valid = hwdesc_state == STATE_DESC_READY ? 1'b1 : 1'b0;
assign m_axi_arvalid = hwdesc_state == STATE_SEND_ADDR ? 1'b1 : 1'b0;
assign m_axi_rready = hwdesc_state == STATE_RECV_DESC ? 1'b1 : 1'b0;

assign m_axi_arsize  = 3'h3;
assign m_axi_arburst = 2'h1;
assign m_axi_arprot  = 3'h0;
assign m_axi_arcache = 4'h3;
assign m_axi_arlen   = 'h5;
assign m_axi_araddr  = {next_desc_addr, {C_BYTES_PER_BEAT_WIDTH_SG{1'b0}}};

always @(posedge req_aclk)
begin
	if (m_axi_rvalid) begin
		hwdesc_counter <= hwdesc_counter + 1'b1;
	end else if (hwdesc_state != STATE_RECV_DESC) begin
		hwdesc_counter <= 1'b0;
	end
end

always @(posedge req_aclk)
begin
	if (hwdesc_state == STATE_IDLE) begin
		next_desc_addr <= req_desc_address;
	end

	if (m_axi_rvalid) begin
		case (hwdesc_counter)
			0: begin
				hwdesc_id <= m_axi_rdata[63:32];
				hwdesc_flags <= m_axi_rdata[31:0];
			end
			1: dest_addr <= m_axi_rdata[31:C_BYTES_PER_BEAT_WIDTH_DEST];
			2: src_addr <= m_axi_rdata[31:C_BYTES_PER_BEAT_WIDTH_SRC];
			3: next_desc_addr <= m_axi_rdata[31:C_BYTES_PER_BEAT_WIDTH_SG];
			4: begin
				x_length <= m_axi_rdata[63:32];
				y_length <= m_axi_rdata[31:0];
			end
			5: begin
				dest_stride <= m_axi_rdata[63:32];
				src_stride <= m_axi_rdata[31:0];
			end
		endcase
	end
end

always @(posedge req_aclk)
begin
	if (req_aresetn == 1'b0) begin
		hwdesc_state <= STATE_IDLE;
	end else begin
		case (hwdesc_state)
			STATE_IDLE: begin
				if (req_in_valid == 1'b1 && req_enable == 1'b1) begin
					hwdesc_state <= STATE_SEND_ADDR;
				end
			end

			STATE_SEND_ADDR: begin
				if (m_axi_arready) begin
					hwdesc_state <= STATE_RECV_DESC;
				end
			end

			STATE_RECV_DESC: begin
				if (m_axi_rvalid == 1'b1 && hwdesc_counter == 5) begin
					hwdesc_state <= STATE_DESC_READY;
				end
			end

			STATE_DESC_READY: begin
				if (req_enable == 1'b0) begin
					hwdesc_state <= STATE_IDLE;
				end else if (fetch_ready == 1'b1) begin
					if (hwdesc_flags & FLAG_IS_LAST_HWDESC) begin
						hwdesc_state <= STATE_IDLE;
					end else begin
						hwdesc_state <= STATE_SEND_ADDR;
					end
				end
			end
		endcase
	end
end

wire fifo_splitter_aresetn;
assign fifo_splitter_aresetn = req_aresetn & (req_enable | ~req_in_ready);

splitter #(
	.C_NUM_M(2)
) i_req_splitter (
	.clk(req_aclk),
	.resetn(fifo_splitter_aresetn),
	.s_valid(fetch_valid),
	.s_ready(fetch_ready),
	.m_valid({
		req_out_valid,
		fifo_in_valid
	}),
	.m_ready({
		req_out_ready,
		fifo_in_ready
	})
);

wire [32:0] fifo_in_data;
assign fifo_in_data = {hwdesc_flags & FLAG_EOT_IRQ ? 1'b1 : 1'b0, hwdesc_id};

util_axis_fifo #(
	.C_DATA_WIDTH(33),
	.C_ADDRESS_WIDTH(3),
	.C_CLKS_ASYNC(0)
) i_fifo (
	.s_axis_aclk(req_aclk),
	.s_axis_aresetn(fifo_splitter_aresetn),

	.s_axis_valid(fifo_in_valid),
	.s_axis_ready(fifo_in_ready),
	.s_axis_data(fifo_in_data),

	.m_axis_aclk(req_aclk),
	.m_axis_aresetn(fifo_splitter_aresetn),

	.m_axis_valid(fifo_out_valid),
	.m_axis_ready(fifo_out_ready),
	.m_axis_data({resp_out_eot, resp_out_id})
);

assign fifo_out_ready = resp_in_valid;
assign resp_out_valid = resp_in_valid;

endmodule
