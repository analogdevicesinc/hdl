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

module util_axis_resize (
	input                       clk,
	input                       resetn,

	input                       s_valid,
	output                      s_ready,
	input [SLAVE_DATA_WIDTH-1:0]  s_data,

	output                      m_valid,
	input                       m_ready,
	output [MASTER_DATA_WIDTH-1:0] m_data
);

parameter MASTER_DATA_WIDTH = 64;
parameter SLAVE_DATA_WIDTH = 64;
parameter BIG_ENDIAN = 0;

generate if (SLAVE_DATA_WIDTH == MASTER_DATA_WIDTH) begin

assign m_valid = s_valid;
assign s_ready = m_ready;
assign m_data = s_data;

end else if (SLAVE_DATA_WIDTH < MASTER_DATA_WIDTH) begin

localparam RATIO = MASTER_DATA_WIDTH / SLAVE_DATA_WIDTH;

reg [MASTER_DATA_WIDTH-1:0] data;
reg [$clog2(RATIO)-1:0] count;
reg valid;

always @(posedge clk)
begin
	if (resetn == 1'b0) begin
		count <= RATIO - 1;
		valid <= 1'b0;
	end else begin
		if (count == 'h00 && s_ready == 1'b1 && s_valid == 1'b1)
			valid <= 1'b1;
		else if (m_ready == 1'b1)
			valid <= 1'b0;

		if (s_ready == 1'b1 && s_valid == 1'b1) begin
			if (count == 'h00)
				count <= RATIO - 1;
			else
				count <= count - 1'b1;
		end
	end
end

always @(posedge clk)
begin
	if (s_ready == 1'b1 && s_valid == 1'b1)
		if (BIG_ENDIAN == 1) begin
			data <= {data[MASTER_DATA_WIDTH-SLAVE_DATA_WIDTH-1:0], s_data};
		end else begin
			data <= {s_data, data[MASTER_DATA_WIDTH-1:SLAVE_DATA_WIDTH]};
		end
end

assign s_ready = ~valid || m_ready;
assign m_valid = valid;
assign m_data = data;

end else begin

localparam RATIO = SLAVE_DATA_WIDTH / MASTER_DATA_WIDTH;

reg [SLAVE_DATA_WIDTH-1:0] data;
reg [$clog2(RATIO)-1:0] count;
reg valid;

always @(posedge clk)
begin
	if (resetn == 1'b0) begin
		count <= RATIO - 1;
		valid <= 1'b0;
	end else begin
		if (s_valid == 1'b1 && s_ready == 1'b1)
			valid <= 1'b1;
		else if (count == 'h0 && m_ready == 1'b1 && m_valid == 1'b1)
			valid <= 1'b0;

		if (m_ready == 1'b1 && m_valid == 1'b1) begin
			if (count == 'h00)
				count <= RATIO - 1;
			else
				count <= count - 1'b1;
		end
	end
end

always @(posedge clk)
begin
	if (s_ready == 1'b1 && s_valid == 1'b1) begin
		data <= s_data;
	end else if (m_ready == 1'b1 && m_valid == 1'b1) begin
		if (BIG_ENDIAN == 1) begin
			data[SLAVE_DATA_WIDTH-1:MASTER_DATA_WIDTH] <= data[SLAVE_DATA_WIDTH-MASTER_DATA_WIDTH-1:0];
		end else begin
			data[SLAVE_DATA_WIDTH-MASTER_DATA_WIDTH-1:0] <= data[SLAVE_DATA_WIDTH-1:MASTER_DATA_WIDTH];
		end
	end
end

assign s_ready = ~valid || (m_ready && count == 'h0);
assign m_valid = valid;
assign m_data = BIG_ENDIAN == 1 ?
	data[SLAVE_DATA_WIDTH-1:SLAVE_DATA_WIDTH-MASTER_DATA_WIDTH] :
	data[MASTER_DATA_WIDTH-1:0];

end
endgenerate

endmodule
