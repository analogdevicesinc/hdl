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

module jesd204_tx_lane #(
  parameter DATA_PATH_WIDTH = 4
) (
  input clk,

  input [DATA_PATH_WIDTH-1:0] eof,
  input eomf,

  input cgs_enable,

  input [DATA_PATH_WIDTH*8-1:0] ilas_data,
  input [DATA_PATH_WIDTH-1:0] ilas_charisk,

  input [DATA_PATH_WIDTH*8-1:0] tx_data,
  input tx_ready,

  output reg [DATA_PATH_WIDTH*8-1:0] phy_data,
  output reg [DATA_PATH_WIDTH-1:0] phy_charisk,

  input cfg_disable_scrambler
);

wire [DATA_PATH_WIDTH*8-1:0] scrambled_data;
wire [7:0] scrambled_char[0:DATA_PATH_WIDTH-1];
reg [7:0] char_align[0:DATA_PATH_WIDTH-1];

jesd204_scrambler #(
  .WIDTH(DATA_PATH_WIDTH*8),
  .DESCRAMBLE(0)
) i_scrambler (
  .clk(clk),
  .reset(~tx_ready),
  .enable(~cfg_disable_scrambler),
  .data_in(tx_data),
  .data_out(scrambled_data)
);

generate
genvar i;

for (i = 0; i < DATA_PATH_WIDTH; i = i + 1) begin: gen_char
  assign scrambled_char[i] = scrambled_data[i*8+7:i*8];

  always @(*) begin
    if (i == DATA_PATH_WIDTH-1 && eomf == 1'b1) begin
      char_align[i] = 8'h7c; // /A/
    end else begin
      char_align[i] = 8'hfc; // /F/
    end
  end

  always @(posedge clk) begin
    if (cgs_enable == 1'b1) begin
      phy_charisk[i] <= 1'b1;
    end else if (eof[i] == 1'b1 && scrambled_char[i] == char_align[i]) begin
      phy_charisk[i] <= 1'b1;
    end else begin
      phy_charisk[i] <= ilas_charisk[i];
    end
  end
end

endgenerate

always @(posedge clk) begin
  if (cgs_enable == 1'b1) begin
    phy_data <= {DATA_PATH_WIDTH{8'hbc}};
  end else begin
    phy_data <= (tx_ready) ? scrambled_data : ilas_data;
  end
end

endmodule
