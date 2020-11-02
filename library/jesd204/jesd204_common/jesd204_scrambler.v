//
// The ADI JESD204 Core is released under the following license, which is
// different than all other HDL cores in this repository.
//
// Please read this, and understand the freedoms and responsibilities you have
// by using this source code/core.
//
// The JESD204 HDL, is copyright © 2016-2017 Analog Devices Inc.
//
// This core is free software, you can use run, copy, study, change, ask
// questions about and improve this core. Distribution of source, or resulting
// binaries (including those inside an FPGA or ASIC) require you to release the
// source of the entire project (excluding the system libraries provide by the
// tools/compiler/FPGA vendor). These are the terms of the GNU General Public
// License version 2 as published by the Free Software Foundation.
//
// This core  is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License version 2
// along with this source code, and binary.  If not, see
// <http://www.gnu.org/licenses/>.
//
// Commercial licenses (with commercial support) of this JESD204 core are also
// available under terms different than the General Public License. (e.g. they
// do not require you to accompany any image (FPGA or ASIC) using the JESD204
// core with any corresponding source code.) For these alternate terms you must
// purchase a license from Analog Devices Technology Licensing Office. Users
// interested in such a license should contact jesd204-licensing@analog.com for
// more information. This commercial license is sub-licensable (if you purchase
// chips from Analog Devices, incorporate them into your PCB level product, and
// purchase a JESD204 license, end users of your product will also have a
// license to use this core in a commercial setting without releasing their
// source code).
//
// In addition, we kindly ask you to acknowledge ADI in any program, application
// or publication in which you use this JESD204 HDL core. (You are not required
// to do so; it is up to your common sense to decide whether you want to comply
// with this request or not.) For general publications, we suggest referencing :
// “The design and implementation of the JESD204 HDL Core used in this project
// is copyright © 2016-2017, Analog Devices, Inc.”
//

`timescale 1ns/100ps

module jesd204_scrambler #(
  parameter WIDTH = 32,
  parameter DESCRAMBLE = 0
) (
  input clk,
  input reset,

  input enable,

  input [WIDTH-1:0] data_in,
  output [WIDTH-1:0] data_out
);

reg [14:0] state = 'h7f80;
reg [WIDTH-1:0] swizzle_out;
wire [WIDTH-1:0] swizzle_in;
wire [WIDTH-1:0] feedback;
wire [WIDTH-1+15:0] full_state;

generate
genvar i;
for (i = 0; i < WIDTH / 8; i = i + 1) begin: gen_swizzle
  assign swizzle_in[WIDTH-1-i*8:WIDTH-i*8-8] = data_in[i*8+7:i*8];
  assign data_out[WIDTH-1-i*8:WIDTH-i*8-8] = swizzle_out[i*8+7:i*8];
end
endgenerate

assign full_state = {state,DESCRAMBLE ? swizzle_in : feedback};
assign feedback = full_state[WIDTH-1+15:15] ^ full_state[WIDTH-1+14:14] ^ swizzle_in;

always @(*) begin
  if (enable == 1'b0) begin
    swizzle_out = swizzle_in;
  end else begin
    swizzle_out = feedback;
  end
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    state <= 'h7f80;
  end else begin
    state <= full_state[14:0];
  end
end

endmodule
