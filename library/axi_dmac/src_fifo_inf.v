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

module dmac_src_fifo_inf (
	input clk,
	input resetn,

	input enable,
	output enabled,
	input sync_id,
	output sync_id_ret,

	input [C_ID_WIDTH-1:0] request_id,
	output [C_ID_WIDTH-1:0] response_id,
	input eot,

	input en,
	input [C_DATA_WIDTH-1:0] din,
	output reg overflow,
	input sync,
	output xfer_req,

	input fifo_ready,
	output fifo_valid,
	output [C_DATA_WIDTH-1:0] fifo_data,

	input req_valid,
	output req_ready,
	input [C_BEATS_PER_BURST_WIDTH-1:0] req_last_burst_length,
	input req_sync_transfer_start
);

parameter C_ID_WIDTH = 3;
parameter C_DATA_WIDTH = 64;
parameter C_BEATS_PER_BURST_WIDTH = 4;

wire ready;

reg needs_sync = 1'b0;
wire has_sync = ~needs_sync | sync;
wire sync_valid = en & ready & has_sync;

always @(posedge clk)
begin
	if (resetn == 1'b0) begin
		needs_sync <= 1'b0;
	end else begin
		if (ready && en && sync) begin
			needs_sync <= 1'b0;
		end else if (req_valid && req_ready) begin
			needs_sync <= req_sync_transfer_start;
		end
	end
end

always @(posedge clk)
begin
	if (resetn == 1'b0) begin
		overflow <= 1'b0;
	end else begin
		if (enable) begin
			overflow <= en & ~ready;
		end else begin
			overflow <= en;
		end
	end
end

assign sync_id_ret = sync_id;

dmac_data_mover # (
	.C_ID_WIDTH(C_ID_WIDTH),
	.C_DATA_WIDTH(C_DATA_WIDTH),
	.C_DISABLE_WAIT_FOR_ID(0),
	.C_BEATS_PER_BURST_WIDTH(C_BEATS_PER_BURST_WIDTH)
) i_data_mover (
	.clk(clk),
	.resetn(resetn),

	.enable(enable),
	.enabled(enabled),
	.sync_id(sync_id),

	.xfer_req(xfer_req),

	.request_id(request_id),
	.response_id(response_id),
	.eot(eot),
	
	.req_valid(req_valid),
	.req_ready(req_ready),
	.req_last_burst_length(req_last_burst_length),

	.s_axi_ready(ready),
	.s_axi_valid(sync_valid),
	.s_axi_data(din),
	.m_axi_ready(fifo_ready),
	.m_axi_valid(fifo_valid),
	.m_axi_data(fifo_data),
	.m_axi_last()
);

endmodule
