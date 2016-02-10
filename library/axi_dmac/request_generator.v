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

module dmac_request_generator (
	input req_aclk,
	input req_aresetn,

	output [ID_WIDTH-1:0] request_id,
	input [ID_WIDTH-1:0] response_id,

	input req_valid,
	output reg req_ready,
	input [BURSTS_PER_TRANSFER_WIDTH-1:0] req_burst_count,

	input enable,
	input pause,

	output eot
);

parameter ID_WIDTH = 3;
parameter BURSTS_PER_TRANSFER_WIDTH = 17;

`include "inc_id.h"

/*
 * Here we only need to count the number of bursts, which means we can ignore
 * the lower bits of the byte count. The last last burst may not contain the
 * maximum number of bytes, but the address_generator and data_mover will take
 * care that only the requested ammount of bytes is transfered.
 */

reg [BURSTS_PER_TRANSFER_WIDTH-1:0] burst_count = 'h00;
reg [ID_WIDTH-1:0] id;
wire [ID_WIDTH-1:0] id_next = inc_id(id);

assign eot = burst_count == 'h00;
assign request_id = id;

always @(posedge req_aclk)
begin
	if (req_aresetn == 1'b0) begin
		burst_count <= 'h00;
		id <= 'h0;
		req_ready <= 1'b1;
	end else if (enable == 1'b0) begin
		req_ready <= 1'b1;
	end else begin
		if (req_ready) begin
			if (req_valid && enable) begin
				burst_count <= req_burst_count;
				req_ready <= 1'b0;
			end
		end else if (response_id != id_next && ~pause) begin
			if (eot)
				req_ready <= 1'b1;
			burst_count <= burst_count - 1'b1;
			id <= id_next;
		end
	end
end

endmodule
