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

// Converts a stream of input data with missing words in the bus to
// a stream of output data without missing words.
// `timescale 1ps / 1ps

`default_nettype none

module fill_holes #(
  parameter WORD_LENGTH = 16,
  parameter NUM_WORDS = 4
)(
  input  wire       clk,
  input  wire       reset,

  input  wire  [NUM_WORDS-1:0]                in_holes,
  input  wire  [(WORD_LENGTH*NUM_WORDS)-1:0]  in_data,
  input  wire                                 in_valid,

  output logic [(WORD_LENGTH*NUM_WORDS)-1:0]  out_data,
  output logic                                out_valid
);

  logic [NUM_WORDS-1:0]                     in_holes_d;
  logic [3:1][(WORD_LENGTH*NUM_WORDS)-1:0]  in_data_d;
  logic [4:1]                               in_valid_d;
  logic [NUM_WORDS-1:0] [$clog2(NUM_WORDS)-1:0]     word_sel;
  logic [NUM_WORDS-1:0] [$clog2(NUM_WORDS)-1:0]     word_sel_d;
  logic [NUM_WORDS-1:0] [$clog2(NUM_WORDS+1)-1:0]   non_holes_cnt_total_per_word;
  logic [NUM_WORDS-1:0] [$clog2(NUM_WORDS+1)-1:0]   non_holes_cnt_total_per_word_d;
  logic [(WORD_LENGTH*NUM_WORDS)-1:0]       data_filled;
  logic [(WORD_LENGTH*NUM_WORDS)-1:0]       data_filled_d;
  logic [(WORD_LENGTH*NUM_WORDS*2)-1:0]     data_filled_padded;
  logic [$clog2(NUM_WORDS+1) -1:0]          non_holes_cnt_filled;
  logic [2:1] [$clog2(NUM_WORDS+1)-1:0]     non_holes_cnt_filled_d;
  logic [$clog2(NUM_WORDS+1)-1:0]           non_holes_cnt_filled_valid;
  logic [(WORD_LENGTH*NUM_WORDS*3)-1:0]     data_stored;
  logic [(WORD_LENGTH*NUM_WORDS*3)-1:0]     data_stored_shift_out;
  logic [(WORD_LENGTH*NUM_WORDS*3)-1:0]     data_stored_shift_in;
  logic [$clog2((NUM_WORDS*3)+1)-1:0]       non_holes_cnt_comb_shift_out;
  logic [$clog2((NUM_WORDS*3)+1)-1:0]       non_holes_cnt_comb;
  logic [$clog2((NUM_WORDS*3)+1)-1:0]       non_holes_cnt;
  localparam CNT_WIDTH = $clog2(NUM_WORDS+1);

  genvar jj;

  always @(posedge clk) begin
    if(reset) begin
      in_holes_d <= '0;
      in_data_d <= 'X;
      in_valid_d <=  '0;
    end else begin
      in_holes_d <= in_holes;
      in_data_d <= {in_data_d[2:1], in_data};
      in_valid_d <= {in_valid_d[3:1], in_valid};
    end
  end

  // Lowest word whose running non-holes count equals target, or zero if there is
  // none. Written as a function driving a continuous assign rather than as an
  // always_comb writing one element of a packed array, which not every simulator
  // accepts. Counting down makes the lowest match the one that survives, which is
  // the priority the find-first loop had.
  function [CNT_WIDTH-1:0] find_word;
    input [(NUM_WORDS*CNT_WIDTH)-1:0] cnt;
    input [CNT_WIDTH:0]               target;
    integer kk;
    begin
      find_word = '0;
      for(kk = NUM_WORDS-1; kk >= 0; kk=kk-1) begin
        if(cnt[kk*CNT_WIDTH+:CNT_WIDTH] == target) begin
          find_word = kk[CNT_WIDTH-1:0];
        end
      end
    end
  endfunction

  // Count of non-holes words from 0 to jj for each word jj
  for(jj=0;jj<NUM_WORDS;jj=jj+1) begin : move_holes_gen
    if(jj==0) begin : first
      assign non_holes_cnt_total_per_word[jj] = !in_holes_d[0];
    end else begin : rest
      assign non_holes_cnt_total_per_word[jj] =
        non_holes_cnt_total_per_word[jj-1] + !in_holes_d[jj];
    end

    // Select input word position per-shifted data bus word
    assign word_sel[jj] = find_word(non_holes_cnt_total_per_word_d, jj+1);

    // Register shifted data words
    always @(posedge clk) begin
      word_sel_d[jj] <= word_sel[jj];
      data_filled[jj*WORD_LENGTH+:WORD_LENGTH] <= in_data_d[3][word_sel_d[jj]*WORD_LENGTH+:WORD_LENGTH];
    end
  end

  always @(posedge clk) begin
    non_holes_cnt_total_per_word_d <= non_holes_cnt_total_per_word;
    data_filled_d <= data_filled;
  end

  // Total non-holes words for entire input word
  assign non_holes_cnt_filled = non_holes_cnt_total_per_word_d[NUM_WORDS-1];

  // Register non-holes count
  always @(posedge clk) begin
    if(reset) begin
      non_holes_cnt_filled_valid <= '0;
      non_holes_cnt_filled_d <= 'X;
    end else begin
      non_holes_cnt_filled_valid <= in_valid_d[4] ? non_holes_cnt_filled_d[2] : '0;
      non_holes_cnt_filled_d <= {non_holes_cnt_filled_d[1], non_holes_cnt_filled};
    end
  end

  // Concatenate input data to create output data
  always @(posedge clk) begin
    if(reset) begin
      non_holes_cnt <= '0;
      out_valid <= 1'b0;
      data_stored <= 'X;
    end else begin
      non_holes_cnt <= non_holes_cnt_comb;
      out_valid <= non_holes_cnt_comb >= NUM_WORDS;
      data_stored <= data_stored_shift_in;
    end
  end

  // Number of words after shifting out
  assign non_holes_cnt_comb_shift_out = non_holes_cnt - (out_valid ? NUM_WORDS : '0);
  // Number of words after shifting out and in
  assign non_holes_cnt_comb = non_holes_cnt + non_holes_cnt_filled_valid - (out_valid ? NUM_WORDS : '0);
  // Data after shifting out
  assign data_stored_shift_out = out_valid ? {{(NUM_WORDS*WORD_LENGTH){1'bX}}, data_stored[(NUM_WORDS*WORD_LENGTH)+:(NUM_WORDS*2*WORD_LENGTH)]} : data_stored;
  // Padded to ensure length is enough for data_stored_shift_in
  assign data_filled_padded = {{(NUM_WORDS*2*WORD_LENGTH){1'bX}}, data_filled_d};
  // Data after shifting out and in
  for(jj = 0; jj < NUM_WORDS*3; jj=jj+1) begin : data_stored_shift_in_gen
    assign data_stored_shift_in[jj*WORD_LENGTH+:WORD_LENGTH] = jj < non_holes_cnt_comb_shift_out ? data_stored_shift_out[jj*WORD_LENGTH+:WORD_LENGTH] : data_filled_d[(jj-non_holes_cnt_comb_shift_out)*WORD_LENGTH+:WORD_LENGTH];
  end
  // Output data
  assign out_data = data_stored[(WORD_LENGTH*NUM_WORDS)-1:0];

endmodule

`default_nettype wire
