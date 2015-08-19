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

/*
 * Helper module for synchronizing a counter from one clock domain to another
 * using gray code. To work correctly the counter must not change its value by
 * more than one in one clock cycle in the source domain. I.e. the value may
 * change by either -1, 0 or +1.
 */
module sync_gray (
	input in_clk,
	input in_resetn,
	input [DATA_WIDTH-1:0] in_count,
	input out_resetn,
	input out_clk,
	output [DATA_WIDTH-1:0] out_count
);

// Bit-width of the counter
parameter DATA_WIDTH = 1;
// Whether the input and output clock are asynchronous, if set to 0 the
// synchronizer will be bypassed and out_count will be in_count.
parameter ASYNC_CLK = 1;

reg [DATA_WIDTH-1:0] cdc_sync_stage0 = 'h0;
reg [DATA_WIDTH-1:0] cdc_sync_stage1 = 'h0;
reg [DATA_WIDTH-1:0] cdc_sync_stage2 = 'h0;
reg [DATA_WIDTH-1:0] out_count_m = 'h0;

function [DATA_WIDTH-1:0] g2b;
	input [DATA_WIDTH-1:0] g;
	reg   [DATA_WIDTH-1:0] b;
	integer i;
	begin
		b[DATA_WIDTH-1] = g[DATA_WIDTH-1];
		for (i = DATA_WIDTH - 2; i >= 0; i =  i - 1)
			b[i] = b[i + 1] ^ g[i];
		g2b = b;
	end
endfunction

function [DATA_WIDTH-1:0] b2g;
	input [DATA_WIDTH-1:0] b;
	reg [DATA_WIDTH-1:0] g;
	integer i;
	begin
		g[DATA_WIDTH-1] = b[DATA_WIDTH-1];
		for (i = DATA_WIDTH - 2; i >= 0; i = i -1)
				g[i] = b[i + 1] ^ b[i];
		b2g = g;
	end
endfunction

always @(posedge in_clk) begin
	if (in_resetn == 1'b0) begin
		cdc_sync_stage0 <= 'h00;
	end else begin
		cdc_sync_stage0 <= b2g(in_count);
	end
end

always @(posedge out_clk) begin
	if (out_resetn == 1'b0) begin
		cdc_sync_stage1 <= 'h00;
		cdc_sync_stage2 <= 'h00;
		out_count_m <= 'h00;
	end else begin
		cdc_sync_stage1 <= cdc_sync_stage0;
		cdc_sync_stage2 <= cdc_sync_stage1;
		out_count_m <= g2b(cdc_sync_stage2);
	end
end

assign out_count = ASYNC_CLK ? out_count_m : in_count;

endmodule
