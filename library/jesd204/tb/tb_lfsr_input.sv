// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

module tb_lfsr_input;

  localparam LFSR_WIDTH = 26;
  localparam [LFSR_WIDTH:1] RESET_VAL = {LFSR_WIDTH{1'b0}};
  localparam [LFSR_WIDTH:1] LFSR_POLYNOMIAL = 26'h2210110;
  localparam MAX_SHIFT_CNT = 64;

  // localparam INPUT_DATA_WIDTH = 64;
  // localparam logic [INPUT_DATA_WIDTH-1:0] DATA_VALUE = 64'h8001020305050423;
  localparam INPUT_DATA_WIDTH = 2048;
  localparam logic [INPUT_DATA_WIDTH-1:0] DATA_VALUE = {1'b1, 2047'b0};

  logic [INPUT_DATA_WIDTH-1:0] DATA_VALUE_REVERSED;
  logic [MAX_SHIFT_CNT-1:0]    data;

  logic [MAX_SHIFT_CNT-1:0]           data_out;
  logic [LFSR_WIDTH:1]                shift_reg;
  reg                                 clk = 1'b0;
  logic                               rst;
  logic                               shift_en;
  logic [$clog2(MAX_SHIFT_CNT)-1:0]   shift_cnt;
  logic [MAX_SHIFT_CNT-1:0]           data_in;

  int                                 data_in_cnt;
  int ii;

  always #5 clk = ~clk;

  // 𝑥^26 + 𝑥^21 + 𝑥^17 + 𝑥^9 + 𝑥^4 + 1
  // 100001000100000001000010001
  // Remove the MSb (x^26) term because it represents the loopback from LSb of the LFSR to the MSb
  // 0000 1000 1000 0000 1000 0100 01
  // Reverse the order of the taps because the LSb of the LFSR contains the MSb of the FEC data
  // 10 0010 0001 0000 0001 0001 0000

  // S0                     S25   FEC register index
  // 26                       1   LFSR_POLYNOMIAL index
  // X0001000010000000100010000
  // X0 0010 0001 0000 0001 0001 0000





  initial begin
    for(ii = 0; ii < INPUT_DATA_WIDTH; ii = ii + 1) begin
      DATA_VALUE_REVERSED[ii] = DATA_VALUE[INPUT_DATA_WIDTH-1-ii];
    end
    rst = 1'b1;
    #100ns;
    rst = 1'b0;
  end

  always_ff @(posedge clk) begin
    if(rst) begin
      shift_en <= 1'b0;
      data <= DATA_VALUE_REVERSED;
      data_in_cnt <= '0;
    end else begin
      if(data_in_cnt < INPUT_DATA_WIDTH) begin
        // Shift data in MSb-first by reversing the data
        data_in <= data[0+:MAX_SHIFT_CNT];
        data <= data >> (shift_cnt+1);
        shift_en <= 1'b1;
        data_in_cnt <= data_in_cnt + (shift_cnt + 1);
      end else begin
        shift_en <= 1'b0;
      end
    end
  end

  assign shift_cnt = 63;

  lfsr_input #(
    .LFSR_WIDTH        (LFSR_WIDTH),
    .RESET_VAL         (RESET_VAL),
    .LFSR_POLYNOMIAL   (LFSR_POLYNOMIAL),
    .MAX_SHIFT_CNT     (MAX_SHIFT_CNT)
  ) lfsr_input (
    .data_out          (data_out),
    .shift_reg         (shift_reg),
    .clk               (clk),
    .rst               (rst),
    .shift_en          (shift_en),
    .shift_cnt         (shift_cnt),
    .data_in           (data_in)
  );

endmodule

`default_nettype wire
