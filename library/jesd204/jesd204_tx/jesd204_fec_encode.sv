// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns / 100ps

// JESD204C FEC encoder
module jesd204_fec_encode #(
   parameter DATA_WIDTH = 64
)(
   output logic [25:0]                        fec,
   input  wire                                clk,
   input  wire                                rst,
   input  wire                                shift_en,
   input  wire                                eomb,
   input  wire  [DATA_WIDTH-1:0]              data_in
);

  localparam [$clog2(DATA_WIDTH)-1:0] SHIFT_CNT = DATA_WIDTH-1;

  // 𝑥^26 + 𝑥^21 + 𝑥^17 + 𝑥^9 + 𝑥^4 + 1
  // 100001000100000001000010001
  // Remove the MSb (x^26) term because it represents the loopback from LSb of the LFSR to the MSb
  // 0000 1000 1000 0000 1000 0100 01
  // Reverse the order of the taps because the LSb of the LFSR contains the MSb of the FEC data
  // 10 0010 0001 0000 0001 0001 0000
  localparam [26:1] FEC_POLYNOMIAL = 26'h2210110;

  logic [25:0] fec_reversed;
  genvar ii;

  // Reverse order of FEC bits so that fec[25:0] matches FEC[25:0] from the JESD204 specification
  for(ii = 0; ii < 26; ii = ii + 1) begin : reverse_gen
    assign fec[ii] = fec_reversed[25-ii];
  end

  lfsr_input #(
    .LFSR_WIDTH        (26),
    .RESET_VAL         ('0),
    .LFSR_POLYNOMIAL   (FEC_POLYNOMIAL),
    .MAX_SHIFT_CNT     (DATA_WIDTH)
  ) lfsr_input (
    .data_out          (),
    .shift_reg         (fec_reversed),
    .shift_reg_next    (),
    .clk               (clk),
    .rst               (rst),
    .shift_en          (shift_en),
    .shift_reg_reset   (eomb),
    .shift_cnt         (SHIFT_CNT),
    .data_in           (data_in)
  );

endmodule
