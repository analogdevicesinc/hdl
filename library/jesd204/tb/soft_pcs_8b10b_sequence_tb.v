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

module soft_pcs_8b10b_sequence_tb;
  parameter VCD_FILE = "soft_pcs_8b10b_sequence_tb.vcd";

  `include "tb_base.v"

  // Send a random sequence of characters to the decoder and make sure the
  // decoder produces the same character sequence and no disparity or
  // not-in-table errors

  wire [9:0] raw_data;

  reg [7:0] encoder_char = 'h00;
  reg encoder_charisk = 1'b0;

  wire [7:0] decoder_char;
  wire decoder_charisk;
  wire decoder_notintable;
  wire decoder_disperr;

  reg encoder_disparity = 1'b0;
  wire encoder_disparity_s;
  reg decoder_disparity = 1'b0;
  wire decoder_disparity_s;

  integer x;

  reg inject_enc_disparity_error = 1'b0;

/*
  always @(posedge clk) begin
    if ({$random} % 256 == 0) begin
      inject_enc_disparity_error <= 1'b1;
    end else begin
      inject_enc_disparity_error <= 1'b0;
    end
  end
*/

  always @(posedge clk) begin
    x = {$random} % (256 + 5);
    if (x < 256) begin
      encoder_char <= x & 8'hff;
      encoder_charisk <= 1'b0;
    end else begin
      case (x - 256)
      0: encoder_char <= {3'd0,5'd28};
      1: encoder_char <= {3'd3,5'd28};
      2: encoder_char <= {3'd4,5'd28};
      3: encoder_char <= {3'd5,5'd28};
      4: encoder_char <= {3'd7,5'd28};
      endcase
      encoder_charisk <= 1'b1;
    end
    encoder_disparity <= encoder_disparity_s ^ inject_enc_disparity_error;
    decoder_disparity <= decoder_disparity_s;
  end

  jesd204_8b10b_encoder i_enc (
    .in_char(encoder_char),
    .in_charisk(encoder_charisk),
    .out_char(raw_data),

    .in_disparity(encoder_disparity),
    .out_disparity(encoder_disparity_s)
  );

  jesd204_8b10b_decoder i_dec (
    .in_char(raw_data),
    .out_char(decoder_char),
    .out_notintable(decoder_notintable),
    .out_disperr(decoder_disperr),
    .out_charisk(decoder_charisk),

    .in_disparity(decoder_disparity),
    .out_disparity(decoder_disparity_s)
  );

   wire char_mismatch = encoder_char != decoder_char;
   wire charisk_mismatch = encoder_charisk != decoder_charisk;

   always @(posedge clk) begin
     if (char_mismatch == 1'b1 || charisk_mismatch == 1'b1 ||
         decoder_notintable == 1'b1 || decoder_disperr == 1'b1) begin
       failed <= 1'b1;
     end
   end

endmodule
