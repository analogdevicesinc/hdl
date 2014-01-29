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

	output s_axi_ready,
	input s_axi_valid,
	input [C_DATA_WIDTH-1:0] s_axi_data,

	input m_axi_ready,
	output m_axi_valid,
	output [C_DATA_WIDTH-1:0] m_axi_data,
	output m_axi_last,

	input req_valid,
	output req_ready,
	input [3:0] req_last_burst_length
);

parameter C_ID_WIDTH = 3;
parameter C_DATA_WIDTH = 64;
parameter C_DISABLE_WAIT_FOR_ID = 1;

`include "inc_id.h"

reg [3:0] last_burst_length;
reg [C_ID_WIDTH-1:0] id = 'h00;
reg [C_ID_WIDTH-1:0] id_next;
reg [3:0] beat_counter = 'h00;
wire last;
wire last_load;
reg pending_burst;
reg active;

assign response_id = id;

assign last = beat_counter == (eot ? last_burst_length : 4'hf);

assign s_axi_ready = m_axi_ready & pending_burst & active;
assign m_axi_valid = s_axi_valid & pending_burst & active;
assign m_axi_data = s_axi_data;
assign m_axi_last = last;

// If we want to support zero delay between transfers we have to assert
// req_ready on the same cycle on which the last load happens.
assign last_load = s_axi_ready && s_axi_valid && last && eot;
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
	if (resetn == 1'b0) begin
		beat_counter <= 'h0;
	end else begin
		if (req_ready && req_valid) begin
			beat_counter <= 'h0;
		end else if (s_axi_ready && s_axi_valid) begin
			beat_counter <= beat_counter + 1'b1;
		end
	end
end

always @(posedge clk) begin
	if (req_ready && req_valid) begin
		last_burst_length <= req_last_burst_length;
	end
end

always @(posedge clk) begin
	if (resetn == 1'b0) begin
		active <= 1'b0;
	end else begin
		if (~enabled) begin
			active <= 1'b0;
		end else if (req_ready && req_valid) begin
			active <= 1'b1;
		end else if (last_load) begin
			active <= 1'b0;
		end
	end
end

always @(*)
begin
	if ((s_axi_ready && s_axi_valid && last) ||
		(sync_id && id != request_id))
		id_next <= inc_id(id);
	else
		id_next <= id;
end

always @(posedge clk) begin
	if (resetn == 1'b0) begin
		id <= 'h0;
		pending_burst <= 1'b0;
	end else begin
		id <= id_next;
		pending_burst <= id_next != request_id;
	end
end

endmodule
