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

module dmac_dest_fifo_inf (
	input clk,
	input resetn,

	input enable,
	output enabled,
	input sync_id,
	output sync_id_ret,

	input [C_ID_WIDTH-1:0] request_id,
	output [C_ID_WIDTH-1:0] response_id,
	output [C_ID_WIDTH-1:0] data_id,
	input data_eot,
	input response_eot,

	input en,
	output [C_DATA_WIDTH-1:0] dout,
	output valid,
	output underflow,

        output xfer_req,

	output fifo_ready,
	input fifo_valid,
	input [C_DATA_WIDTH-1:0] fifo_data,

	input req_valid,
	output req_ready,
	input [C_BEATS_PER_BURST_WIDTH-1:0] req_last_burst_length,

	output response_valid,
	input response_ready,
	output response_resp_eot,
	output [1:0] response_resp
);

parameter C_ID_WIDTH = 3;
parameter C_DATA_WIDTH = 64;
parameter C_BEATS_PER_BURST_WIDTH = 4;

assign sync_id_ret = sync_id;
wire data_enabled;

wire _fifo_ready;
assign fifo_ready = _fifo_ready | ~enabled;

reg en_d1;
wire data_ready;
wire data_valid;

always @(posedge clk)
begin
	if (resetn == 1'b0) begin
		en_d1 <= 1'b0;
	end else begin
		en_d1 <= en;
	end
end

assign underflow = en_d1 & (~data_valid | ~enable);
assign data_ready = en_d1 & (data_valid | ~enable);
assign valid = en_d1 & data_valid & enable;

dmac_data_mover # (
	.C_ID_WIDTH(C_ID_WIDTH),
	.C_DATA_WIDTH(C_DATA_WIDTH),
	.C_BEATS_PER_BURST_WIDTH(C_BEATS_PER_BURST_WIDTH),
	.C_DISABLE_WAIT_FOR_ID(0)
) i_data_mover (
	.clk(clk),
	.resetn(resetn),

	.enable(enable),
	.enabled(data_enabled),
	.sync_id(sync_id),
        .xfer_req(xfer_req),

	.request_id(request_id),
	.response_id(data_id),
	.eot(data_eot),
	
	.req_valid(req_valid),
	.req_ready(req_ready),
	.req_last_burst_length(req_last_burst_length),

	.s_axi_ready(_fifo_ready),
	.s_axi_valid(fifo_valid),
	.s_axi_data(fifo_data),
	.m_axi_ready(data_ready),
	.m_axi_valid(data_valid),
	.m_axi_data(dout),
	.m_axi_last()
);

dmac_response_generator # (
	.C_ID_WIDTH(C_ID_WIDTH)
) i_response_generator (
	.clk(clk),
	.resetn(resetn),

	.enable(data_enabled),
	.enabled(enabled),
	.sync_id(sync_id),

	.request_id(data_id),
	.response_id(response_id),

	.eot(response_eot),

	.resp_valid(response_valid),
	.resp_ready(response_ready),
	.resp_eot(response_resp_eot),
	.resp_resp(response_resp)
);

endmodule
