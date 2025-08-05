// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************


`timescale 1ns / 100ps
`default_nettype none

// LFSR with input
module lfsr_input #(
   parameter LFSR_WIDTH = 32,
   parameter [LFSR_WIDTH:1] RESET_VAL = {LFSR_WIDTH{1'b0}},
   // LFSR_POLYNOMIAL[0] must be 1 and is omitted
   parameter [LFSR_WIDTH:1] LFSR_POLYNOMIAL = {LFSR_WIDTH{1'b0}},
   parameter MAX_SHIFT_CNT = 64
)(
   // One cycle after shift_en = 1,
   //   data_out[shift_cnt:0] contains the next shift_cnt + 1 output bits
   //   data_out[MAX_SHIFT_CNT-1:shift_cnt+1] is undefined
   output logic [MAX_SHIFT_CNT-1:0]               data_out,
   // Value of the shift register updated one cycle after shift_en is asserted
   output logic [LFSR_WIDTH:1]                    shift_reg,
   // Value of the shift register if shift_en is asserted for each value of shift_cnt from 1 to MAX_SHIFT_CNT
   output logic [LFSR_WIDTH:1]                    shift_reg_next[MAX_SHIFT_CNT-1:0],
   input  wire                                    clk,
   input  wire                                    rst,
   input  wire                                    shift_reg_reset,
   input  wire                                    shift_en,
   // Number of bits to shift - 1
   input  wire   [$clog2(MAX_SHIFT_CNT)-1:0]      shift_cnt,
   input  wire   [MAX_SHIFT_CNT-1:0]              data_in
);

  function automatic [LFSR_WIDTH:1] lfsr_galois_next(input [LFSR_WIDTH:1] cur, input next_data_in);
    int ii;
    reg next_msb;
    next_msb = cur[1] ^ next_data_in;
    lfsr_galois_next[LFSR_WIDTH] = next_msb;
    for(ii = LFSR_WIDTH-1; ii > 0; ii=ii-1) begin : shift_reg_gen
      lfsr_galois_next[ii] = cur[ii+1] ^ (next_msb & LFSR_POLYNOMIAL[ii]);
    end
  endfunction

  wire [MAX_SHIFT_CNT-1:0]                 data_out_next;
  reg  [LFSR_WIDTH:1]                      shift_reg_in_start;
  wire [LFSR_WIDTH:1]                      shift_reg_in_next[MAX_SHIFT_CNT-1:0];
  genvar jj;



  // Generate shift register values for each number of shifts
  for(jj = 0; jj < MAX_SHIFT_CNT; jj = jj + 1) begin : shift_gen
    // Shift register input is output of previous shift register value
    if(jj == 0) begin : zero_gen
      assign shift_reg_in_next[jj] = shift_reg_in_start;
    end else begin : non_zero_gen
      assign shift_reg_in_next[jj] = shift_reg_next[jj-1];
    end

    // Output bit is the LSb of the shift register
    assign data_out_next[jj] = shift_reg_in_next[jj][1];

    assign shift_reg_next[jj] = lfsr_galois_next(shift_reg_in_next[jj], data_in[jj]);
  end

  always @(posedge clk) begin
      if(shift_reg_reset || rst) begin
        shift_reg_in_start <= RESET_VAL;
      end else if(shift_en) begin
        shift_reg_in_start <= shift_reg_next[shift_cnt];
      end
  end

  always @(posedge clk) begin
    if(rst) begin
      shift_reg <= RESET_VAL;
    end else begin
      if(shift_en) begin
        shift_reg <= shift_reg_next[shift_cnt];
        data_out <= data_out_next;
      end else if(shift_reg_reset) begin
        shift_reg <= RESET_VAL;
      end
    end
  end

endmodule

`default_nettype wire
