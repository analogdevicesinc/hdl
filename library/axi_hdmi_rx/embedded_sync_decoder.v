// ***************************************************************************
// ***************************************************************************
// Copyright 2011-2013(c) Analog Devices, Inc.
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
// ***************************************************************************
// ***************************************************************************

module embedded_sync_decoder(
	input clk,
	input [15:0] data_in,
	output reg hs_de,
	output reg vs_de,
	output reg [15:0] data_out
);

	reg [15:0] data_d = 'd0;
	reg hs_de_rcv_d = 'd0;
	reg vs_de_rcv_d = 'd0;
	reg [15:0] data_2d = 'd0;
	reg hs_de_rcv_2d = 'd0;
	reg vs_de_rcv_2d = 'd0;
	reg [15:0] data_3d = 'd0;
	reg hs_de_rcv_3d = 'd0;
	reg vs_de_rcv_3d = 'd0;
	reg [15:0] data_4d = 'd0;
	reg hs_de_rcv_4d = 'd0;
	reg vs_de_rcv_4d = 'd0;
	reg hs_de_rcv = 'd0;
	reg vs_de_rcv = 'd0;

	// delay to get rid of eav's 4 bytes
	always @(posedge clk) begin
		data_d <= data_in;
		data_2d <= data_d;
		data_3d <= data_2d;
		data_4d <= data_3d;
		data_out <= data_4d;

		hs_de_rcv_d <= hs_de_rcv;
		vs_de_rcv_d <= vs_de_rcv;
		hs_de_rcv_2d <= hs_de_rcv_d;
		vs_de_rcv_2d <= vs_de_rcv_d;
		hs_de_rcv_3d <= hs_de_rcv_2d;
		vs_de_rcv_3d <= vs_de_rcv_2d;
		hs_de_rcv_4d <= hs_de_rcv_3d;
		vs_de_rcv_4d <= vs_de_rcv_3d;
		hs_de <= hs_de_rcv & hs_de_rcv_4d;
		vs_de <= vs_de_rcv & vs_de_rcv_4d;
	end

	reg [1:0] preamble_cnt = 'd0;
		
	// check for sav and eav and generate the corresponding enables
	always @(posedge clk) begin
		if ((data_in == 16'hffff) || (data_in == 16'h0000)) begin
			preamble_cnt <= preamble_cnt + 1'b1;
		end else begin
			preamble_cnt <= 'd0;
		end
	
		if (preamble_cnt == 3'h3) begin
			if ((data_in == 16'hb6b6) || (data_in == 16'h9d9d)) begin
				hs_de_rcv <= 1'b0;
				vs_de_rcv <= ~data_in[13];
			end else if ((data_in == 16'habab) || (data_in == 16'h8080)) begin
				hs_de_rcv <= 1'b1;
				vs_de_rcv <= ~data_in[13];
			end
		end
	end

endmodule
