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

module crc12_tb;
  parameter VCD_FILE = "crc12_tb.vcd";

  `define TIMEOUT 400

  `include "tb_base.v"

  reg [63:0] data_in = 'h0;
  reg [11:0] ref_crc12 = 'h0;
  wire [11:0] crc12;
  reg test_en = 1'b1;
  reg init = 1'b0;

  jesd204_crc12 DUT (
    .clk (clk),
    .reset (1'b0),
    .init (init),
    .data_in (data_in),
    .crc12 (crc12)
  );

  // Test against dataset from the standard
  //  - Test contiguous input stream with init phase
  initial begin
    @(negedge reset);
    @(posedge clk);
    repeat (3) begin
      @(posedge clk) data_in <= 'h80_01_02_03_05_05_04_23;
      init <= 1'b1;
      @(posedge clk) data_in <= 'h0e_43_80_c2_0b_50_81_cd;
      init <= 1'b0;
      @(posedge clk) data_in <= 'h04_e7_83_92_5a_3c_aa_51;
      @(posedge clk) data_in <= 'h05_4d_87_d9_31_3d_11_51;
    end
    @(posedge clk);
    @(posedge clk);
    test_en <= 1'b0;
  end

   initial begin
    @(negedge reset);
    @(posedge clk);
    @(posedge clk);
    repeat(3) begin
      @(posedge clk) ref_crc12 <= 'hd00;
      @(posedge clk) ref_crc12 <= 'h11c;
      @(posedge clk) ref_crc12 <= 'hfea;
      @(posedge clk) ref_crc12 <= 'h5fe;
    end
  end


  always @(posedge clk) begin
    if (ref_crc12 != crc12 && failed == 1'b0 && test_en) begin
      failed <= 1'b1;
    end
  end

endmodule
