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

module dmac_src_mm_axi (
	input                           m_axi_aclk,
	input                           m_axi_aresetn,

	input                           req_valid,
	output                          req_ready,
	input [31:BYTES_PER_BEAT_WIDTH]    req_address,
	input [BEATS_PER_BURST_WIDTH-1:0] req_last_burst_length,

	input                           enable,
	output                          enabled,
	input                           pause,
	input                           sync_id,
	output                          sync_id_ret,

	output                          response_valid,
	input                           response_ready,
	output [1:0]                    response_resp,

	input  [ID_WIDTH-1:0]         request_id,
	output [ID_WIDTH-1:0]         response_id,

	output [ID_WIDTH-1:0]         data_id,
	output [ID_WIDTH-1:0]         address_id,
	input                           data_eot,
	input                           address_eot,

	output                          fifo_valid,
	input                           fifo_ready,
	output [DMA_DATA_WIDTH-1:0]   fifo_data,

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
	input  [DMA_DATA_WIDTH-1:0]    m_axi_rdata,
	output                           m_axi_rready,
	input                            m_axi_rvalid,
	input  [ 1:0]                    m_axi_rresp
);

parameter ID_WIDTH = 3;
parameter DMA_DATA_WIDTH = 64;
parameter BYTES_PER_BEAT_WIDTH = 3;
parameter BEATS_PER_BURST_WIDTH = 4;

`include "resp.h"

wire address_enabled;

wire address_req_valid;
wire address_req_ready;
wire data_req_valid;
wire data_req_ready;

assign sync_id_ret = sync_id;
assign response_id = data_id;

assign response_valid = 1'b0;
assign response_resp = RESP_OKAY;

splitter #(
	.NUM_M(2)
) i_req_splitter (
	.clk(m_axi_aclk),
	.resetn(m_axi_aresetn),
	.s_valid(req_valid),
	.s_ready(req_ready),
	.m_valid({
		address_req_valid,
		data_req_valid
	}),
	.m_ready({
		address_req_ready,
		data_req_ready
	})
);

dmac_address_generator #(
	.ID_WIDTH(ID_WIDTH),
	.BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH),
	.BYTES_PER_BEAT_WIDTH(BYTES_PER_BEAT_WIDTH),
	.DMA_DATA_WIDTH(DMA_DATA_WIDTH)
) i_addr_gen (
	.clk(m_axi_aclk),
	.resetn(m_axi_aresetn),

	.enable(enable),
	.enabled(address_enabled),
	.pause(pause),
	.sync_id(sync_id),

	.request_id(request_id),
	.id(address_id),

	.req_valid(address_req_valid),
	.req_ready(address_req_ready),
	.req_address(req_address),
	.req_last_burst_length(req_last_burst_length),

	.eot(address_eot),

	.addr_ready(m_axi_arready),
	.addr_valid(m_axi_arvalid),
	.addr(m_axi_araddr),
	.len(m_axi_arlen),
	.size(m_axi_arsize),
	.burst(m_axi_arburst),
	.prot(m_axi_arprot),
	.cache(m_axi_arcache)
);

dmac_data_mover # (
	.ID_WIDTH(ID_WIDTH),
	.DATA_WIDTH(DMA_DATA_WIDTH),
	.BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH)
) i_data_mover (
	.clk(m_axi_aclk),
	.resetn(m_axi_aresetn),

	.enable(address_enabled),
	.enabled(enabled),
	.sync_id(sync_id),

	.xfer_req(),

	.request_id(address_id),
	.response_id(data_id),
	.eot(data_eot),

	.req_valid(data_req_valid),
	.req_ready(data_req_ready),
	.req_last_burst_length(req_last_burst_length),

	.s_axi_valid(m_axi_rvalid),
	.s_axi_ready(m_axi_rready),
	.s_axi_data(m_axi_rdata),
	.m_axi_valid(fifo_valid),
	.m_axi_ready(fifo_ready),
	.m_axi_data(fifo_data),
	.m_axi_last()
);

reg [1:0] rresp;

always @(posedge m_axi_aclk)
begin
	if (m_axi_rvalid && m_axi_rready) begin
		if (m_axi_rresp != 2'b0)
			rresp <= m_axi_rresp;
	end
end

endmodule
