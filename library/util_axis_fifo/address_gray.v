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

module fifo_address_gray (
	input m_axis_aclk,
	input m_axis_aresetn,
	input m_axis_ready,
	output reg m_axis_valid,
	output [C_ADDRESS_WIDTH-1:0] m_axis_raddr_next,
	output reg [C_ADDRESS_WIDTH:0] m_axis_level,

	input s_axis_aclk,
	input s_axis_aresetn,
	output reg s_axis_ready,
	input s_axis_valid,
	output reg s_axis_empty,
	output [C_ADDRESS_WIDTH-1:0] s_axis_waddr,
	output reg [C_ADDRESS_WIDTH:0] s_axis_room
);

parameter C_ADDRESS_WIDTH = 4;

reg [C_ADDRESS_WIDTH:0] _s_axis_waddr = 'h00;
reg [C_ADDRESS_WIDTH:0] _s_axis_waddr_next;

reg [C_ADDRESS_WIDTH:0] _m_axis_raddr = 'h00;
reg [C_ADDRESS_WIDTH:0] _m_axis_raddr_next;

reg [C_ADDRESS_WIDTH:0] s_axis_waddr_gray = 'h00;
wire [C_ADDRESS_WIDTH:0] s_axis_waddr_gray_next;
wire [C_ADDRESS_WIDTH:0] s_axis_raddr_gray;

reg [C_ADDRESS_WIDTH:0] m_axis_raddr_gray = 'h00;
wire [C_ADDRESS_WIDTH:0] m_axis_raddr_gray_next;
wire [C_ADDRESS_WIDTH:0] m_axis_waddr_gray;

assign s_axis_waddr = _s_axis_waddr[C_ADDRESS_WIDTH-1:0];
assign m_axis_raddr_next = _m_axis_raddr_next[C_ADDRESS_WIDTH-1:0];

always @(*)
begin
	if (s_axis_ready && s_axis_valid)
		_s_axis_waddr_next <= _s_axis_waddr + 1;
	else
		_s_axis_waddr_next <= _s_axis_waddr;
end

assign s_axis_waddr_gray_next = _s_axis_waddr_next ^ _s_axis_waddr_next[C_ADDRESS_WIDTH:1];

always @(posedge s_axis_aclk)
begin
	if (s_axis_aresetn == 1'b0) begin
		_s_axis_waddr <= 'h00;
		s_axis_waddr_gray <= 'h00;
	end else begin
		_s_axis_waddr <= _s_axis_waddr_next;
		s_axis_waddr_gray <= s_axis_waddr_gray_next;
	end
end

always @(*)
begin
	if (m_axis_ready && m_axis_valid)
		_m_axis_raddr_next <= _m_axis_raddr + 1;
	else
		_m_axis_raddr_next <= _m_axis_raddr;
end

assign m_axis_raddr_gray_next = _m_axis_raddr_next ^ _m_axis_raddr_next[C_ADDRESS_WIDTH:1];

always @(posedge m_axis_aclk)
begin
	if (m_axis_aresetn == 1'b0) begin
		_m_axis_raddr <= 'h00;
		m_axis_raddr_gray <= 'h00;
	end else begin
		_m_axis_raddr <= _m_axis_raddr_next;
		m_axis_raddr_gray <= m_axis_raddr_gray_next;
	end
end

sync_bits #(
	.NUM_BITS(C_ADDRESS_WIDTH + 1)
) i_waddr_sync (
	.out_clk(m_axis_aclk),
	.out_resetn(m_axis_aresetn),
	.in(s_axis_waddr_gray),
	.out(m_axis_waddr_gray)
);

sync_bits #(
	.NUM_BITS(C_ADDRESS_WIDTH + 1)
) i_raddr_sync (
	.out_clk(s_axis_aclk),
	.out_resetn(s_axis_aresetn),
	.in(m_axis_raddr_gray),
	.out(s_axis_raddr_gray)
);

always @(posedge s_axis_aclk)
begin
	if (s_axis_aresetn == 1'b0) begin
		s_axis_ready <= 1'b1;
		s_axis_empty <= 1'b1;
	end else begin
		s_axis_ready <= (s_axis_raddr_gray[C_ADDRESS_WIDTH] == s_axis_waddr_gray_next[C_ADDRESS_WIDTH] ||
			s_axis_raddr_gray[C_ADDRESS_WIDTH-1] == s_axis_waddr_gray_next[C_ADDRESS_WIDTH-1] ||
			s_axis_raddr_gray[C_ADDRESS_WIDTH-2:0] != s_axis_waddr_gray_next[C_ADDRESS_WIDTH-2:0]);
		s_axis_empty <= s_axis_raddr_gray == s_axis_waddr_gray_next;
	end
end

always @(posedge m_axis_aclk)
begin
	if (s_axis_aresetn == 1'b0)
		m_axis_valid <= 1'b0;
	else begin
		m_axis_valid <= m_axis_waddr_gray != m_axis_raddr_gray_next;
	end
end

endmodule

