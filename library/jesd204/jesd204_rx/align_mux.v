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

module align_mux #(
  parameter DATA_PATH_WIDTH = 4
) (
  input clk,
  input [1:0] align,
  input [DATA_PATH_WIDTH*8-1:0] in_data,
  input [DATA_PATH_WIDTH-1:0] in_charisk,
  output reg [DATA_PATH_WIDTH*8-1:0] out_data,
  output reg [DATA_PATH_WIDTH-1:0] out_charisk
);

reg [DATA_PATH_WIDTH*8-1:0] in_data_d1;
reg [DATA_PATH_WIDTH-1:0] in_charisk_d1;

always @(posedge clk) begin
  in_data_d1 <= in_data;
  in_charisk_d1 <= in_charisk;
end

always @(*) begin
  case (align)
  'h0: out_data = in_data_d1;
  'h1: out_data = {in_data[7:0],in_data_d1[31:8]};
  'h2: out_data = {in_data[15:0],in_data_d1[31:16]};
  'h3: out_data = {in_data[23:0],in_data_d1[31:24]};
  endcase

  case (align)
  'h0: out_charisk = in_charisk_d1;
  'h1: out_charisk = {in_charisk[0:0],in_charisk_d1[3:1]};
  'h2: out_charisk = {in_charisk[1:0],in_charisk_d1[3:2]};
  'h3: out_charisk = {in_charisk[2:0],in_charisk_d1[3:3]};
  endcase
end

endmodule
