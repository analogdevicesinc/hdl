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

module dmac_data_mover (
	input clk,
	input resetn,

	input [C_ID_WIDTH-1:0] request_id,
	output [C_ID_WIDTH-1:0] response_id,
	input sync_id,
	input eot,

	input enable,
	output reg enabled,

	output xfer_req,

	output s_axi_ready,
	input s_axi_valid,
	input [C_DATA_WIDTH-1:0] s_axi_data,

	input m_axi_ready,
	output m_axi_valid,
	output [C_DATA_WIDTH-1:0] m_axi_data,
	output m_axi_last,

	input req_valid,
	output req_ready,
	input [C_BEATS_PER_BURST_WIDTH-1:0] req_last_burst_length
);

parameter C_ID_WIDTH = 3;
parameter C_DATA_WIDTH = 64;
parameter C_DISABLE_WAIT_FOR_ID = 1;
parameter C_BEATS_PER_BURST_WIDTH = 4;
localparam MAX_BEATS_PER_BURST = 2**(C_BEATS_PER_BURST_WIDTH);

`include "inc_id.h"

reg [C_BEATS_PER_BURST_WIDTH-1:0] last_burst_length = 'h00;
reg [C_BEATS_PER_BURST_WIDTH-1:0] beat_counter = 'h00;
reg [C_ID_WIDTH-1:0] id = 'h00;
reg [C_ID_WIDTH-1:0] id_next = 'h00;

reg pending_burst = 1'b0;
reg active = 1'b0;
reg last_eot = 1'b0;
reg last_non_eot = 1'b0;

wire last_load;
wire last;

assign xfer_req = active;

assign response_id = id;

assign last = eot ? last_eot : last_non_eot;

assign s_axi_ready = m_axi_ready & pending_burst & active;
assign m_axi_valid = s_axi_valid & pending_burst & active;
assign m_axi_data = s_axi_data;
assign m_axi_last = last;

// If we want to support zero delay between transfers we have to assert
// req_ready on the same cycle on which the last load happens.
assign last_load = s_axi_ready && s_axi_valid && last_eot && eot;
assign req_ready = last_load || ~active;

always @(posedge clk) begin
	if (resetn == 1'b0) begin
		enabled <= 1'b0;
	end else begin
		if (enable) begin
			enabled <= 1'b1;
		end else begin
			if (C_DISABLE_WAIT_FOR_ID == 0) begin
				// We are not allowed to just deassert valid, so wait until the
				// current beat has been accepted
				if (~s_axi_valid || m_axi_ready)
					enabled <= 1'b0;
			end else begin
				// For memory mapped AXI busses we have to complete all pending
				// burst requests before we can disable the data mover.
				if (response_id == request_id)
					enabled <= 1'b0;
			end
		end
	end
end

always @(posedge clk) begin
	if (req_ready) begin
		last_eot <= req_last_burst_length == 'h0; 
		last_non_eot <= 1'b0;
		beat_counter <= 'h1;
	end else if (s_axi_ready && s_axi_valid) begin
		last_eot <= beat_counter == last_burst_length;
		last_non_eot <= beat_counter == MAX_BEATS_PER_BURST - 1;
		beat_counter <= beat_counter + 1;
	end
end

always @(posedge clk) begin
	if (req_ready)
		last_burst_length <= req_last_burst_length;
end

always @(posedge clk) begin
	if (enabled == 1'b0 || resetn == 1'b0) begin
		active <= 1'b0;
	end else if (req_valid) begin
		active <= 1'b1;
	end else if (last_load) begin
		active <= 1'b0;
	end
end

always @(*)
begin
	if ((s_axi_ready && s_axi_valid && last) ||
		(sync_id && pending_burst))
		id_next <= inc_id(id);
	else
		id_next <= id;
end

always @(posedge clk) begin
	if (resetn == 1'b0) begin
		id <= 'h0;
	end else begin
		id <= id_next;
	end
end

always @(posedge clk) begin
	pending_burst <= id_next != request_id;
end

endmodule
