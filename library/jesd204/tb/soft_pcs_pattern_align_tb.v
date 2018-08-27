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

module soft_pcs_pattern_align_tb;
  parameter VCD_FILE = "soft_pcs_pattern_align_tb.vcd";

  localparam [9:0] PATTERN_P = 10'b1010000011;
  localparam [9:0] PATTERN_N = 10'b0101111100;

  `define TIMEOUT 1000000
  `include "tb_base.v"

  integer counter = 0;

  reg [3:0] bitshift = 4'd0;
  reg [9:0] comma_unaligned;
  reg comma_sync = 1'b0;
  wire [9:0] comma_aligned;
  reg [9:0] comma = PATTERN_P;

  wire comma_match = comma == comma_aligned;

  always @(posedge clk) begin
    if (counter == 63) begin
      if (comma_sync != 1'b1) begin
        failed <= 1'b1;
      end

      comma_sync <= 1'b0;
      counter <= 0;
      bitshift <= {$random} % 10;
      comma <= {$random} % 2 ? PATTERN_P : PATTERN_N;
    end else begin
      counter <= counter + 1'b1;

      // Takes two clock cycles for the new value to propagate
      if (counter > 1) begin
        // Shouldn't loose sync after it gained it
        if (comma_match == 1'b1) begin
          comma_sync <= 1'b1;
        end else if (comma_sync == 1'b1) begin
          failed <= 1'b1;
        end
      end
    end
  end

  always @(*) begin
    case (bitshift)
    4'd0: comma_unaligned <= comma[9:0];
    4'd1: comma_unaligned <= {comma[0],comma[9:1]};
    4'd2: comma_unaligned <= {comma[1:0],comma[9:2]};
    4'd3: comma_unaligned <= {comma[2:0],comma[9:3]};
    4'd4: comma_unaligned <= {comma[3:0],comma[9:4]};
    4'd5: comma_unaligned <= {comma[4:0],comma[9:5]};
    4'd6: comma_unaligned <= {comma[5:0],comma[9:6]};
    4'd7: comma_unaligned <= {comma[6:0],comma[9:7]};
    4'd8: comma_unaligned <= {comma[7:0],comma[9:8]};
    default: comma_unaligned <= {comma[8:0],comma[9]};
    endcase
  end

  jesd204_pattern_align #(
    .DATA_PATH_WIDTH(1)
  ) i_pa (
    .clk(clk),
    .reset(1'b0),
    .patternalign_en(1'b1),

    .in_data(comma_unaligned),
    .out_data(comma_aligned)
  );

endmodule
