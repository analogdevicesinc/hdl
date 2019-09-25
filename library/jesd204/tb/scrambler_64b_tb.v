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

module scrambler_64b_tb;
  parameter VCD_FILE = "scrambler_64b_tb.vcd";

  `include "tb_base.v"
  reg failed_t1 = 1'b0;
  reg failed_t2 = 1'b0;

  // Test scrambler against descrambler
  //
  // Descrambled data should match the input of the scrambler.
  reg [63:0] data_in = 'h0;
  reg [63:0] data_out_expected;
  wire [63:0] data_scrambled;
  wire [63:0] data_out;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      data_in <= 'h0001020304050607;
    end else begin
      data_in <= data_in + {8{8'h08}};
    end
  end


  jesd204_scrambler_64b #(
    .DESCRAMBLE(0)
  ) i_scrambler (
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .data_in(data_in),
    .data_out(data_scrambled)
  );

  jesd204_scrambler_64b #(
    .DESCRAMBLE(1)
  ) i_descrambler (
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .data_in(data_scrambled),
    .data_out(data_out)
  );
  always @(posedge clk) begin
    if (data_in != data_out && failed_t1 == 1'b0) begin
      failed_t1 <= 1'b1;
    end
  end

  // Test descrambler against reference data
  //
  // Check if descrambler can synchronize and a stream captured from
  // a scrambler output. The descrambled data stream should match the input of
  // the scrambler.
  reg [63:0] descrambler_data_in = 'h0;
  reg [63:0] data_ref = 'h0;
  wire[63:0] descrambler_data_out;

  integer i;
  reg [63:0] scrambler_64b_input [0:993];
  reg [63:0] scrambler_64b_output [0:993];
  reg t2_enable = 1'b0;

  initial begin
    $readmemh("scrambler_64b_input.txt", scrambler_64b_input);   // Input to a scrambler
    $readmemh("scrambler_64b_output.txt", scrambler_64b_output); // Output of a scrambler
    @(negedge reset);
    @(posedge clk);
    for (i=0;i<994;i=i+1) begin
      @(posedge clk);
      descrambler_data_in <= scrambler_64b_output[i];
      data_ref <= scrambler_64b_input[i];
      if (i==1) t2_enable <= 1'b1;
      if (i==993) t2_enable <= 1'b0;
    end
  end

  jesd204_scrambler_64b #(
    .DESCRAMBLE(1)
  ) i_descrambler2 (
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .data_in(descrambler_data_in),
    .data_out(descrambler_data_out)
  );

  always @(posedge clk) begin
    if (data_ref != descrambler_data_out && failed_t2 == 1'b0 && t2_enable) begin
      failed_t2 <= 1'b1;
    end
  end

  always @(posedge clk) begin
    failed <= failed_t1 || failed_t2;
  end


endmodule
