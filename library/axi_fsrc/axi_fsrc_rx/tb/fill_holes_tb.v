// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

// fill_holes compacts a beat that carries holes into a dense stream, emitting a
// beat only once NUM_WORDS real words have accumulated. The check is that the
// words come out in the order they went in, none lost and none repeated, for a
// random hole pattern including the all-holes and no-holes beats.

module fill_holes_tb;
  parameter VCD_FILE = {"fill_holes_tb.vcd"};

  `define TIMEOUT 400000
  `include "../../../common/tb/tb_base.v"

  localparam WORD = 16;
  localparam WORDS = 8;
  localparam HOLE = {1'b1, {(WORD-1){1'b0}}};

  reg  [WORDS-1:0]      in_holes = {WORDS{1'b0}};
  reg  [WORD*WORDS-1:0] in_data = {WORDS*WORD{1'b0}};
  reg                   in_valid = 1'b0;
  wire [WORD*WORDS-1:0] out_data;
  wire                  out_valid;

  fill_holes #(
    .WORD_LENGTH (WORD),
    .NUM_WORDS (WORDS)
  ) i_dut (
    .clk (clk),
    .reset (reset),
    .in_holes (in_holes),
    .in_data (in_data),
    .in_valid (in_valid),
    .out_data (out_data),
    .out_valid (out_valid));

  // Words pushed in, in order, so the output can be compared against them. The
  // ring only has to outrun the core's pipeline depth.
  localparam EXP_DEPTH = 4096;
  reg [WORD-1:0] expected [0:EXP_DEPTH-1];
  integer wr = 0;
  integer rd = 0;
  integer payload = 1;

  integer i;
  reg [WORDS-1:0] holes;

  task drive_beat;
    begin
      for (i = 0; i < WORDS; i = i + 1) begin
        if (holes[i] == 1'b1) begin
          in_data[i*WORD +: WORD] = HOLE;
        end else begin
          in_data[i*WORD +: WORD] = payload[WORD-1:0];
          expected[wr % EXP_DEPTH] = payload[WORD-1:0];
          wr = wr + 1;
          payload = payload + 1;
          // Keep clear of the sentinel so a payload can never look like a hole.
          if (payload[WORD-1] == 1'b1) payload = 1;
        end
      end
      in_holes = holes;
      in_valid = 1'b1;
    end
  endtask

  integer beat = 0;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      in_valid <= 1'b0;
    end else begin
      // Walk the corner cases first, then go random.
      case (beat)
        0: holes = {WORDS{1'b0}};
        1: holes = {WORDS{1'b1}};
        2: holes = {WORDS{1'b0}};
        3: holes = {{(WORDS-1){1'b0}}, 1'b1};
        4: holes = {1'b1, {(WORDS-1){1'b0}}};
        default: holes = $random;
      endcase
      beat = beat + 1;
      drive_beat;
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b0 && out_valid == 1'b1) begin
      for (i = 0; i < WORDS; i = i + 1) begin
        if (out_data[i*WORD +: WORD] !== expected[(rd + i) % EXP_DEPTH]) begin
          $display("ERROR: word %0d: got %h expected %h", rd + i,
                   out_data[i*WORD +: WORD], expected[(rd + i) % EXP_DEPTH]);
          failed <= 1'b1;
        end
      end
      rd = rd + WORDS;
    end
  end

  initial begin
    #(`TIMEOUT - 100);
    $display("INFO: pushed %0d words, checked %0d", wr, rd);
    // Everything but the last partial beat and the pipeline fill must come out.
    if (rd < wr - 8*WORDS) begin
      $display("ERROR: only %0d of %0d words came out", rd, wr);
      failed <= 1'b1;
    end
  end

endmodule
