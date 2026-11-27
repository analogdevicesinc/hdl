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

// Checks lfsr_input, configured as the JESD204C FEC parity generator, against
// a bit-serial division by g(x) = x^26 + x^21 + x^17 + x^9 + x^4 + 1 with
// random shift counts, shift enables and shift register resets.

module tb_lfsr_input;
  localparam LFSR_WIDTH = 26;
  localparam [LFSR_WIDTH:1] RESET_VAL = {LFSR_WIDTH{1'b0}};
  localparam [LFSR_WIDTH:1] LFSR_POLYNOMIAL = 26'h2210110;
  localparam [25:0] G_LOW = (1 << 21) | (1 << 17) | (1 << 9) | (1 << 4) | 1;
  localparam MAX_SHIFT_CNT = 64;
  localparam NUM_STEPS = 3000;

  parameter VCD_FILE = {"tb_lfsr_input.vcd"};
  `include "tb_base.v"

  logic [MAX_SHIFT_CNT-1:0]           data_out;
  logic [LFSR_WIDTH:1]                shift_reg;
  logic                               rst = 1'b1;
  logic                               shift_reg_reset = 1'b0;
  logic                               shift_en = 1'b0;
  logic [$clog2(MAX_SHIFT_CNT)-1:0]   shift_cnt = '0;
  logic [MAX_SHIFT_CNT-1:0]           data_in = '0;

  // Remainder of the bits shifted so far; bit i is the coefficient of x^i
  logic [25:0]                        rem = '0;
  logic [25:0]                        exp_shift_reg = '0;
  logic [MAX_SHIFT_CNT-1:0]           exp_data_out = '0;
  logic [MAX_SHIFT_CNT-1:0]           exp_data_out_mask = '0;
  // Expectations for the outputs currently visible (inputs of the previous edge)
  logic [25:0]                        chk_shift_reg = '0;
  logic [MAX_SHIFT_CNT-1:0]           chk_data_out = '0;
  logic [MAX_SHIFT_CNT-1:0]           chk_data_out_mask = '0;
  logic                               chk_valid = 1'b0;
  int                                 step = 0;
  int                                 errors = 0;

  function automatic logic [25:0] div_step(input logic [25:0] r, input logic b);
    logic fb;
    fb = r[25] ^ b;
    return {r[24:0], 1'b0} ^ (fb ? G_LOW : 26'd0);
  endfunction

  function automatic logic [25:0] to_rem(input logic [LFSR_WIDTH:1] sr);
    for (int k = 0; k < 26; k++) to_rem[k] = sr[26-k];
  endfunction

  always @(posedge clk) begin
    if (chk_valid) begin
      if (to_rem(shift_reg) !== chk_shift_reg) begin
        $display("step %0d: shift_reg %h, expected %h", step, to_rem(shift_reg), chk_shift_reg);
        errors = errors + 1;
      end
      if ((data_out & chk_data_out_mask) !== (chk_data_out & chk_data_out_mask)) begin
        $display("step %0d: data_out %h, expected %h", step, data_out & chk_data_out_mask, chk_data_out & chk_data_out_mask);
        errors = errors + 1;
      end
    end
    chk_valid = !rst;
    chk_shift_reg = exp_shift_reg;
    chk_data_out = exp_data_out;
    chk_data_out_mask = exp_data_out_mask;

    if (step == 4) rst <= 1'b0;
    step <= step + 1;

    shift_en <= ($urandom % 4) != 0;
    shift_reg_reset <= ($urandom % 10) == 0;
    shift_cnt <= $urandom % MAX_SHIFT_CNT;
    data_in <= {$urandom, $urandom};

    if (step == NUM_STEPS) begin
      if (errors != 0) failed <= 1'b1;
      $display("%0d steps, %0d errors", NUM_STEPS, errors);
      if (errors == 0)
        $display("SUCCESS");
      else
        $display("FAILED");
      $finish;
    end
  end

  // Model the values applied at this edge, checked at the next one
  always @(negedge clk) begin
    if (rst) begin
      rem = '0;
      exp_shift_reg = '0;
      exp_data_out_mask = '0;
    end else if (shift_en) begin
      logic [25:0] r;
      r = rem;
      for (int j = 0; j <= shift_cnt; j++) begin
        exp_data_out[j] = r[25];
        r = div_step(r, data_in[j]);
      end
      exp_data_out_mask = (MAX_SHIFT_CNT'(1) << (shift_cnt + 1)) - 1;
      exp_shift_reg = r;
      rem = shift_reg_reset ? '0 : r;
    end else if (shift_reg_reset) begin
      exp_shift_reg = '0;
      rem = '0;
    end
  end

  lfsr_input #(
    .LFSR_WIDTH        (LFSR_WIDTH),
    .RESET_VAL         (RESET_VAL),
    .LFSR_POLYNOMIAL   (LFSR_POLYNOMIAL),
    .MAX_SHIFT_CNT     (MAX_SHIFT_CNT)
  ) lfsr_input (
    .data_out          (data_out),
    .shift_reg         (shift_reg),
    .shift_reg_next    (),
    .clk               (clk),
    .rst               (rst),
    .shift_reg_reset   (shift_reg_reset),
    .shift_en          (shift_en),
    .shift_cnt         (shift_cnt),
    .data_in           (data_in));

endmodule

`default_nettype wire
