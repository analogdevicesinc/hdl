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

module jesd204_ilas_config_static #(
  parameter DID = 8'h00,
  parameter BID = 4'h0,
  parameter L = 5'h3,
  parameter SCR = 1'b1,
  parameter F = 8'h01,
  parameter K = 5'h1f,
  parameter M = 8'h3,
  parameter N = 5'h0f,
  parameter CS = 2'h0,
  parameter NP = 5'h0f,
  parameter SUBCLASSV = 3'h1,
  parameter S = 5'h00,
  parameter JESDV = 3'h1,
  parameter CF = 5'h00,
  parameter HD = 1'b1,
  parameter NUM_LANES = 1
) (
  input clk,

  input [1:0] ilas_config_addr,
  input ilas_config_rd,
  output reg [32*NUM_LANES-1:0] ilas_config_data
);

wire [31:0] ilas_mem[0:3];

assign ilas_mem[0][15:0] = 8'h00;
assign ilas_mem[0][23:16] = DID;         // DID
assign ilas_mem[0][27:24] = BID;         // BID
assign ilas_mem[0][31:28] = 4'h0;        // ADJCNT
assign ilas_mem[1][4:0] = 5'h00;         // LID
assign ilas_mem[1][5] = 1'b0;            // PHADJ
assign ilas_mem[1][6] = 1'b0;            // ADJDIR
assign ilas_mem[1][7] = 1'b0;            // X
assign ilas_mem[1][12:8] = L;            // L
assign ilas_mem[1][14:13] = 2'b00;       // X
assign ilas_mem[1][15] = SCR;            // SCR
assign ilas_mem[1][23:16] = F;           // F
assign ilas_mem[1][28:24] = K;           // K
assign ilas_mem[1][31:29] = 3'b000;      // X
assign ilas_mem[2][7:0] = M;             // M
assign ilas_mem[2][12:8] = N;            // N
assign ilas_mem[2][13] = 1'b0;           // X
assign ilas_mem[2][15:14] = CS;          // CS
assign ilas_mem[2][20:16] = NP;          // N'
assign ilas_mem[2][23:21] = SUBCLASSV;   // SUBCLASSV
assign ilas_mem[2][28:24] = S;           // S
assign ilas_mem[2][31:29] = JESDV;       // JESDV
assign ilas_mem[3][4:0] = CF;            // CF
assign ilas_mem[3][6:5] = 2'b00;         // X
assign ilas_mem[3][7] = HD;              // HD
assign ilas_mem[3][23:8] = 16'h0000;     // X
assign ilas_mem[3][31:24] = ilas_mem[0][23:16] + ilas_mem[0][31:24] +
  ilas_mem[1][4:0] + ilas_mem[1][5] + ilas_mem[1][6] + ilas_mem[1][12:8] +
  ilas_mem[1][15] + ilas_mem[1][23:16] + ilas_mem[1][28:24] +
  ilas_mem[2][7:0] + ilas_mem[2][12:8] + ilas_mem[2][15:14] +
  ilas_mem[2][20:16] + ilas_mem[2][23:21] + ilas_mem[2][28:24] +
  ilas_mem[2][31:29] + ilas_mem[3][4:0] + ilas_mem[3][7];

generate
genvar i;

for (i = 0; i < NUM_LANES; i = i + 1) begin: gen_lane
  always @(posedge clk) begin
    if (ilas_config_rd == 1'b1) begin
      ilas_config_data[i*32+31:i*32] <= ilas_mem[ilas_config_addr];

      /* Overwrite special cases */
      case (ilas_config_addr)
      'h1: ilas_config_data[i*32+4:i*32] <= i;
      'h3: ilas_config_data[i*32+31:i*32+24] <= ilas_mem[ilas_config_addr][31:24] + i;
      endcase
    end
  end
end
endgenerate

endmodule
