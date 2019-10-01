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

module jesd204_tx_lane_64b (
  input clk,
  input reset,

  input [63:0] tx_data,
  input tx_ready,

  output reg [63:0] phy_data,
  output     [1:0] phy_header,

  input lmc_edge,
  input lmc_quarter_edge,
  input eoemb,

  // Scrambling mandatory in 64bxxb, keep this for debugging purposes
  input cfg_disable_scrambler,
  input [1:0] cfg_header_mode,
  input cfg_lane_disable

);

reg [63:0] scrambled_data;
reg lmc_edge_d1 = 'b0;
reg lmc_edge_d2 = 'b0;
reg lmc_quarter_edge_d1 = 'b0;
reg lmc_quarter_edge_d2 = 'b0;
reg tx_ready_d1 = 'b0;

wire [63:0] tx_data_msb_s;
wire [63:0] scrambled_data_r;
wire [11:0] crc12;

/* Reorder octets MSB first */
genvar i;
generate
  for (i = 0; i < 64; i = i + 8) begin: g_link_data
    assign tx_data_msb_s[i+:8] = tx_data[64-1-i-:8];
  end
endgenerate

jesd204_scrambler_64b #(
  .WIDTH(64),
  .DESCRAMBLE(0)
) i_scrambler (
  .clk(clk),
  .reset(reset),
  .enable(~cfg_disable_scrambler),
  .data_in(tx_data_msb_s),
  .data_out(scrambled_data_r)
);

always @(posedge clk) begin
  lmc_edge_d1 <= lmc_edge;
  lmc_edge_d2 <= lmc_edge_d1;
  lmc_quarter_edge_d1 <= lmc_quarter_edge;
  lmc_quarter_edge_d2 <= lmc_quarter_edge_d1;
end

always @(posedge clk) begin
  scrambled_data <= scrambled_data_r;
  phy_data <= scrambled_data;
end

always @(posedge clk) begin
  tx_ready_d1 <= tx_ready;
end

jesd204_crc12 i_crc12 (
  .clk(clk),
  .reset(~tx_ready_d1),
  .init(lmc_edge_d2),
  .data_in(scrambled_data),
  .crc12(crc12)
);

jesd204_tx_header i_header_gen (
  .clk(clk),
  .reset(~tx_ready | cfg_lane_disable),

  .cfg_header_mode(cfg_header_mode),

  .lmc_edge(lmc_edge_d2),
  .lmc_quarter_edge(lmc_quarter_edge_d2),

  // Header content to be sent must be valid during lmc_edge
  .eoemb(eoemb),
  .crc3(3'b0),
  .crc12(crc12),
  .fec(26'b0),
  .cmd(19'b0),

  .header(phy_header)

);


endmodule
