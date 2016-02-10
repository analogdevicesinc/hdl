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

module util_axis_fifo (
	input m_axis_aclk,
	input m_axis_aresetn,
	input m_axis_ready,
	output m_axis_valid,
	output [DATA_WIDTH-1:0] m_axis_data,
	output [ADDRESS_WIDTH:0] m_axis_level,

	input s_axis_aclk,
	input s_axis_aresetn,
	output s_axis_ready,
	input s_axis_valid,
	input [DATA_WIDTH-1:0] s_axis_data,
	output s_axis_empty,
	output [ADDRESS_WIDTH:0] s_axis_room
);

parameter DATA_WIDTH = 64;
parameter ASYNC_CLK = 1;
parameter ADDRESS_WIDTH = 4;
parameter S_AXIS_REGISTERED = 1;

generate if (ADDRESS_WIDTH == 0) begin

reg [DATA_WIDTH-1:0] cdc_sync_fifo_ram;
reg s_axis_waddr = 1'b0;
reg m_axis_raddr = 1'b0;

wire m_axis_waddr;
wire s_axis_raddr;

sync_bits #(
	.NUM_OF_BITS(1),
	.ASYNC_CLK(ASYNC_CLK)
) i_waddr_sync (
	.out_clk(m_axis_aclk),
	.out_resetn(m_axis_aresetn),
	.in(s_axis_waddr),
	.out(m_axis_waddr)
);

sync_bits #(
	.NUM_OF_BITS(1),
	.ASYNC_CLK(ASYNC_CLK)
) i_raddr_sync (
	.out_clk(s_axis_aclk),
	.out_resetn(s_axis_aresetn),
	.in(m_axis_raddr),
	.out(s_axis_raddr)
);

assign m_axis_valid = m_axis_raddr != m_axis_waddr;
assign m_axis_level = m_axis_valid;
assign s_axis_ready = s_axis_raddr == s_axis_waddr;
assign s_axis_empty = s_axis_ready;
assign s_axis_room = s_axis_ready;

always @(posedge s_axis_aclk) begin
	if (s_axis_ready)
		cdc_sync_fifo_ram <= s_axis_data;
end

always @(posedge s_axis_aclk) begin
	if (s_axis_aresetn == 1'b0) begin
		s_axis_waddr <= 1'b0;
	end else begin
		if (s_axis_ready & s_axis_valid) begin
			s_axis_waddr <= s_axis_waddr + 1'b1;
		end
	end
end

always @(posedge m_axis_aclk) begin
	if (m_axis_aresetn == 1'b0) begin
		m_axis_raddr <= 1'b0;
	end else begin
		if (m_axis_valid & m_axis_ready)
			m_axis_raddr <= m_axis_raddr + 1'b1;
	end
end

assign m_axis_data = cdc_sync_fifo_ram;

end else begin

reg [DATA_WIDTH-1:0] ram[0:2**ADDRESS_WIDTH-1];

wire [ADDRESS_WIDTH-1:0] s_axis_waddr;
wire [ADDRESS_WIDTH-1:0] m_axis_raddr;
wire _m_axis_ready;
wire _m_axis_valid;

if (ASYNC_CLK == 1) begin

fifo_address_gray_pipelined #(
	.ADDRESS_WIDTH(ADDRESS_WIDTH)
) i_address_gray (
	.m_axis_aclk(m_axis_aclk),
	.m_axis_aresetn(m_axis_aresetn),
	.m_axis_ready(_m_axis_ready),
	.m_axis_valid(_m_axis_valid),
	.m_axis_raddr(m_axis_raddr),
	.m_axis_level(m_axis_level),

	.s_axis_aclk(s_axis_aclk),
	.s_axis_aresetn(s_axis_aresetn),
	.s_axis_ready(s_axis_ready),
	.s_axis_valid(s_axis_valid),
	.s_axis_empty(s_axis_empty),
	.s_axis_waddr(s_axis_waddr),
	.s_axis_room(s_axis_room)
);

end else begin

fifo_address_sync #(
	.ADDRESS_WIDTH(ADDRESS_WIDTH)
) i_address_sync (
	.clk(m_axis_aclk),
	.resetn(m_axis_aresetn),
	.m_axis_ready(_m_axis_ready),
	.m_axis_valid(_m_axis_valid),
	.m_axis_raddr(m_axis_raddr),
	.m_axis_level(m_axis_level),

	.s_axis_ready(s_axis_ready),
	.s_axis_valid(s_axis_valid),
	.s_axis_empty(s_axis_empty),
	.s_axis_waddr(s_axis_waddr),
	.s_axis_room(s_axis_room)
);

end

always @(posedge s_axis_aclk) begin
	if (s_axis_ready)
		ram[s_axis_waddr] <= s_axis_data;
end

if (S_AXIS_REGISTERED == 1) begin

reg [DATA_WIDTH-1:0] data;
reg valid;

always @(posedge m_axis_aclk) begin
	if (m_axis_aresetn == 1'b0) begin
		valid <= 1'b0;
	end else begin
		if (_m_axis_valid)
			valid <= 1'b1;
		else if (m_axis_ready)
			valid <= 1'b0;
	end
end

always @(posedge m_axis_aclk) begin
	if (~valid || m_axis_ready)
		data <= ram[m_axis_raddr];
end

assign _m_axis_ready = ~valid || m_axis_ready;
assign m_axis_data = data;
assign m_axis_valid = valid;

end else begin

assign _m_axis_ready = m_axis_ready;
assign m_axis_valid = _m_axis_valid;
assign m_axis_data = ram[m_axis_raddr];

end

end endgenerate

endmodule
