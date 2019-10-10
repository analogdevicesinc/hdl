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

module jesd204_tx_static_config #(
  parameter NUM_LANES = 1,
  parameter NUM_LINKS = 1,
  parameter OCTETS_PER_FRAME = 1,
  parameter FRAMES_PER_MULTIFRAME = 32,
  parameter NUM_CONVERTERS = 1,
  parameter N = 16,
  parameter NP = 16,
  parameter HIGH_DENSITY = 1,
  parameter SCR = 1,
  parameter LINK_MODE = 1  // 2 - 64B/66B;  1 - 8B/10B
) (
  input clk,

  output [NUM_LANES-1:0] cfg_lanes_disable,
  output [NUM_LINKS-1:0] cfg_links_disable,
  output [7:0] cfg_beats_per_multiframe,
  output [7:0] cfg_octets_per_frame,
  output [7:0] cfg_lmfc_offset,
  output cfg_sysref_oneshot,
  output cfg_sysref_disable,
  output cfg_continuous_cgs,
  output cfg_continuous_ilas,
  output cfg_skip_ilas,
  output [7:0] cfg_mframes_per_ilas,
  output cfg_disable_char_replacement,
  output cfg_disable_scrambler,

  input ilas_config_rd,
  input [1:0] ilas_config_addr,
  output [32*NUM_LANES-1:0] ilas_config_data
);

/* Only 4 is supported at the moment for 8b/10b and 8 for 64b */
localparam DATA_PATH_WIDTH = LINK_MODE == 2 ? 8 : 4;

assign cfg_beats_per_multiframe = (FRAMES_PER_MULTIFRAME * OCTETS_PER_FRAME / DATA_PATH_WIDTH) - 1;
assign cfg_octets_per_frame = OCTETS_PER_FRAME - 1;
assign cfg_lmfc_offset = 3;
assign cfg_sysref_oneshot = 1'b0;
assign cfg_sysref_disable = 1'b0;
assign cfg_continuous_cgs = 1'b0;
assign cfg_continuous_ilas = 1'b0;
assign cfg_skip_ilas = 1'b0;
assign cfg_mframes_per_ilas = 3;
assign cfg_disable_scrambler = SCR ? 1'b0 : 1'b1;
assign cfg_disable_char_replacement = cfg_disable_scrambler;
assign cfg_lanes_disable = {NUM_LANES{1'b0}};
assign cfg_links_disable = {NUM_LINKS{1'b0}};

jesd204_ilas_config_static #(
  .DID(8'h00),
  .BID(5'h00),
  .L(NUM_LANES - 1),
  .SCR(SCR),
  .F(OCTETS_PER_FRAME - 1),
  .K(FRAMES_PER_MULTIFRAME - 1),
  .M(NUM_CONVERTERS - 1),
  .N(N),
  .NP(NP),
  .SUBCLASSV(3'h1),
  .S(5'h00),
  .JESDV(3'h1),
  .CF(5'h00),
  .HD(HIGH_DENSITY),
  .NUM_LANES(NUM_LANES)
) i_ilas_config (
  .clk(clk),
  .ilas_config_addr(ilas_config_addr),
  .ilas_config_rd(ilas_config_rd),
  .ilas_config_data(ilas_config_data)
);

endmodule
