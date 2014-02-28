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
 * Helper module for synchronizing bit signals from one clock domain to another.
 * It uses the standard approach of 2 FF in series.
 * Note, that while the module allows to synchronize multiple bits at once it is
 * only able to synchronize multi-bit signals where at max one bit changes per
 * clock cycle (e.g. a gray counter).
 */
module sync_bits
(
	input [NUM_BITS-1:0] in,
	input out_resetn,
	input out_clk,
	output [NUM_BITS-1:0] out
);

// Number of bits to synchronize
parameter NUM_BITS = 1;
// Whether input and output clocks are asynchronous, if 0 the synchronizer will
// be bypassed and the output signal equals the input signal.
parameter CLK_ASYNC = 1;

reg [NUM_BITS-1:0] out_m1 = 'h0;
reg [NUM_BITS-1:0] out_m2 = 'h0;

always @(posedge out_clk)
begin
	if (out_resetn == 1'b0) begin
		out_m1 <= 'b0;
		out_m2 <= 'b0;
	end else begin
		out_m1 <= in;
	    out_m2 <= out_m1;	
	end
end

assign out = CLK_ASYNC ? out_m2 : in;

endmodule
