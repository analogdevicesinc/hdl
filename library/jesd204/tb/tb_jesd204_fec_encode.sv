// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
// Short identifier: ADIJESD204
//
// The ADI JESD204 Core is released under the following license, which is
// different than all other HDL cores in this repository.
//
// Please read this, and understand the freedoms and responsibilities you have by
// using this source code/core.
//
// The JESD204 HDL, is copyright (C) 2016-2026 Analog Devices Inc.
//
// This core is free software, you can use run, copy, study, change, ask questions
// about and improve this core. Distribution of source, or resulting binaries
// (including those inside an FPGA or ASIC) require you to release the source of
// the entire project (excluding the system libraries provide by the
// tools/compiler/FPGA vendor). These are the terms of the GNU General Public
// License version 2 as published by the Free Software Foundation.
//
// This core  is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
// PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License version 2
// along with this source code, and binary. If not, see
// <http://www.gnu.org/licenses/>.
//
// Commercial licenses (with commercial support) of this JESD204 core are also
// available under terms different than the General Public License (e.g. they do
// not require you to accompany any image (FPGA or ASIC) using the JESD204 core
// with any corresponding source code). For these alternate terms you must
// purchase a license from Analog Devices Technology Licensing Office. Users
// interested in such a license should contact jesd204-licensing@analog.com for
// more information. This commercial license is sub-licensable (if you purchase
// chips from Analog Devices, incorporate them into your PCB level product, and
// purchase a JESD204 license, end users of your product will also have a license
// to use this core in a commercial setting without releasing their source code).
//
// In addition, we kindly ask you to acknowledge ADI in any program, application
// or publication in which you use this JESD204 HDL core. (You are not required to
// do so; it is up to your common sense to decide whether you want to comply with
// this request or not.) For general publications, we suggest referencing: "The
// design and implementation of the JESD204 HDL Core used in this project is
// copyright (C) 2016-2026, Analog Devices, Inc."
// ***************************************************************************
// ***************************************************************************

`timescale 1ns / 100ps
`default_nettype none

// Checks jesd204_fec_encode against a bit-serial division of each 2048-bit
// block by g(x). data_in[0] is the first bit of a word and eomb marks the
// last word of a block, as the encoder expects.

module tb_jesd204_fec_encode;
  localparam DATA_WIDTH = 64;
  localparam [25:0] G_LOW = (1 << 21) | (1 << 17) | (1 << 9) | (1 << 4) | 1;
  localparam NUM_BLOCKS = 60;

  parameter VCD_FILE = {"tb_jesd204_fec_encode.vcd"};
  `include "tb_base.v"

  logic [25:0]            fec;
  logic                   rst = 1'b1;
  logic                   eomb = 1'b0;
  logic [DATA_WIDTH-1:0]  data_in = '0;
  logic [25:0]            rem = '0;
  logic [25:0]            exp_fec = '0;
  logic                   check = 1'b0;
  logic                   check_d = 1'b0;
  logic [25:0]            exp_fec_d = '0;
  int                     cnt = 0;
  int                     blocks = 0;
  int                     errors = 0;

  function automatic logic [25:0] div_word(input logic [25:0] r, input logic [DATA_WIDTH-1:0] w);
    logic fb;
    for (int j = 0; j < DATA_WIDTH; j++) begin
      fb = r[25] ^ w[j];
      r = {r[24:0], 1'b0} ^ (fb ? G_LOW : 26'd0);
    end
    return r;
  endfunction

  initial begin
    repeat (4) @(posedge clk);
    rst <= 1'b0;
  end

  always @(posedge clk) begin
    // fec is valid one edge after the encoder samples eomb
    if (check_d) begin
      if (fec !== exp_fec_d) begin
        $display("block %0d: fec %h, expected %h", blocks, fec, exp_fec_d);
        errors = errors + 1;
      end
      blocks = blocks + 1;
    end
    check_d = check;
    exp_fec_d = exp_fec;
    check = 1'b0;

    if (!rst) begin
      data_in <= {$urandom, $urandom};
      eomb <= (cnt % 32) == 31;
      cnt <= cnt + 1;
    end

    if (blocks == NUM_BLOCKS) begin
      if (errors != 0) failed <= 1'b1;
      $display("%0d blocks, %0d errors", NUM_BLOCKS, errors);
      if (errors == 0)
        $display("SUCCESS");
      else
        $display("FAILED");
      $finish;
    end
  end

  always @(negedge clk) begin
    if (!rst && cnt > 0) begin
      rem = div_word(rem, data_in);
      if (eomb) begin
        exp_fec = rem;
        rem = '0;
        check = 1'b1;
      end
    end
  end

  jesd204_fec_encode #(
    .DATA_WIDTH  (DATA_WIDTH)
  ) jesd204_fec_encode (
    .fec         (fec),
    .clk         (clk),
    .rst         (rst),
    .shift_en    (~rst),
    .eomb        (eomb),
    .data_in     (data_in));

endmodule

`default_nettype wire
