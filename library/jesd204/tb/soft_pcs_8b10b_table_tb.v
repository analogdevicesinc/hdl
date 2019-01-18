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

module soft_pcs_8b10b_table_tb;
  parameter VCD_FILE = "soft_pcs_8b10b_table_tb.vcd";

  `include "tb_base.v"

  // Build a table of all valid 8b10b words using the encoder and then check
  // for every possible 10-bit value that the decoder correctly reports the
  // not-in-table flag

  reg [1023:0] valid_table = 'h00;

  reg [8:0] counter = 10'h00;

  reg [7:0] encoder_char = 8'h00;
  reg encoder_charisk = 1'b0;
  reg encoder_disparity = 1'b0;
  wire [9:0] encoder_raw;

  wire [7:0] decoder_char;
  wire decoder_notintable;
  wire decoder_charisk;
  reg [9:0] decoder_raw = 10'h00;

  reg build_k28 = 1'b0;
  reg build_table = 1'b1;

  reg decoder_disparity = 1'b0;
  wire decoder_disparity_s;

  always @(posedge clk) begin
    counter <= counter + 1'b1;

    if (counter == 'h1ff) begin
      build_k28 <= 1'b1;
    end else if (counter == 'h9 && build_k28 == 1'b1) begin
      build_table <= 1'b0;
    end
  end

  always @(*) begin
    encoder_disparity <= counter[0];
    if (build_k28 == 1'b0) begin
      encoder_char <= counter[8:1];
      encoder_charisk <= 1'b0;
    end else begin
      case (counter[8:1])
      0: encoder_char <= {3'd0,5'd28};
      1: encoder_char <= {3'd3,5'd28};
      2: encoder_char <= {3'd4,5'd28};
      3: encoder_char <= {3'd5,5'd28};
      4: encoder_char <= {3'd7,5'd28};
      endcase
      encoder_charisk <= 1'b1;
    end
  end

  jesd204_8b10b_encoder i_enc (
    .in_char(encoder_char),
    .in_charisk(encoder_charisk),
    .in_disparity(encoder_disparity),
    .out_char(encoder_raw)
  );

  always @(posedge clk) begin
    if (build_table == 1'b1) begin
      valid_table[encoder_raw] <= 1'b1;
    end
  end

  always @(posedge clk) begin
    if (build_table == 1'b0) begin
      decoder_disparity <= ~decoder_disparity;
      if (decoder_disparity == 1'b1 && decoder_raw != 'h3ff) begin
        decoder_raw <= decoder_raw + 1'b1;
      end
    end
  end

  always @(posedge clk) begin
  end

  jesd204_8b10b_decoder i_dec (
    .in_char(build_table ? encoder_raw : decoder_raw),
    .out_char(decoder_char),
    .out_notintable(decoder_notintable),
    .out_charisk(decoder_charisk),

    .in_disparity(decoder_disparity),
    .out_disparity(decoder_disparity_s)
  );

  wire decoder_should_be_in_table = valid_table[decoder_raw];

  always @(posedge clk) begin
    if (build_table == 1'b0) begin
      if (decoder_notintable == decoder_should_be_in_table) begin
        $display("%b.%b, %d", decoder_raw[9:6], decoder_raw[5:0],
          decoder_should_be_in_table);
        failed <= 1'b1;
      end
     end
  end

endmodule
