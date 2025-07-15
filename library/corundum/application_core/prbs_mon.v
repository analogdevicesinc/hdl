// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
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

// Uses Ficonacci style LFSR

`timescale 1ns/100ps

module prbs_mon #(

  parameter DATA_WIDTH = 32,
  parameter POLYNOMIAL_WIDTH = 31,
  parameter OUT_OF_SYNC_THRESHOLD = 16
) (

  input  wire                                                           clk,
  input  wire                                                           rstn,

  input  wire                                                           init,

  input  wire [DATA_WIDTH-1:0]                                          input_data,
  input  wire                                                           input_valid,

  output reg                                                            error_sample,
  output reg  [$clog2(DATA_WIDTH+1)-1:0]                                error_bits,
  output reg                                                            out_of_sync,
  output reg  [$clog2(DATA_WIDTH+1)*$clog2(OUT_OF_SYNC_THRESHOLD)-1:0]  out_of_sync_total_error_bit,

  input  wire [POLYNOMIAL_WIDTH-1:0]                                    polynomial,
  input  wire                                                           inverted
);

  /* Common polynomials:
   * 7'h60 // PRBS7
   * 9'h110 // PRBS9
   * 11'h500 // PRBS11
   * 13'h1B00 // PRBS13
   * 15'h6000 // PRBS15
   * 20'h80004 // PRBS20
   * 23'h420000 // PRBS23
   * 31'h48000000 // PRBS31
   * 48'hC00000000000 // PRBS48
   */

  // calculate the PRBS data based on the last input data
  localparam MAX_WIDTH = (DATA_WIDTH > POLYNOMIAL_WIDTH) ? DATA_WIDTH : POLYNOMIAL_WIDTH;

  wire [DATA_WIDTH-1:0] calculated_prbs_data;

  reg  [POLYNOMIAL_WIDTH-1:0] internal_state;
  wire [POLYNOMIAL_WIDTH-1:0] polynomial_state;

  prbs #(
    .DATA_WIDTH(DATA_WIDTH),
    .POLYNOMIAL_WIDTH(POLYNOMIAL_WIDTH)
  ) prbs_inst (
    .input_data(internal_state),
    .polynomial(polynomial),
    .inverted(inverted),
    .state(polynomial_state),
    .output_data(calculated_prbs_data)
  );

  reg state;  // 0 - Waiting for initial sync value
              // 1 - Running

  reg [$clog2(OUT_OF_SYNC_THRESHOLD)-1:0] oos_counter;

  // check all bits if they are correct
  localparam DATA_WIDTH_2 = 2**$clog2(DATA_WIDTH);

  reg [DATA_WIDTH_2-1:0] bit_errors;

  always @(posedge clk)
  begin
    if (!rstn) begin
      bit_errors <= {DATA_WIDTH_2{1'b0}};
    end else begin
      if (!state || init || out_of_sync) begin
        bit_errors <= {DATA_WIDTH_2{1'b0}};
      end else begin
        if (input_valid) begin
          bit_errors <= {{DATA_WIDTH_2-DATA_WIDTH{1'b0}}, input_data ^ calculated_prbs_data};
        end
      end
    end
  end

  // count the number of error bits
  integer i, j;
  integer new_block, last_block;

  reg [($clog2(DATA_WIDTH+1)-1):0] bit_error_counter [DATA_WIDTH_2-2:0];

  always @(posedge clk)
  begin
    if (!rstn) begin
      for (i = 0; i < DATA_WIDTH_2-1; i = i + 1) begin
        bit_error_counter[i] <= {$clog2(DATA_WIDTH+1){1'b0}};
      end
    end else begin
      if (!state || init || out_of_sync) begin
        for (i = 0; i < DATA_WIDTH_2-1; i = i + 1) begin
          bit_error_counter[i] <= {$clog2(DATA_WIDTH+1){1'b0}};
        end
      end else begin
        if (input_valid) begin
          for (j = 0; j < DATA_WIDTH_2/2; j = j + 1) begin
            bit_error_counter[j] <= bit_errors[j*2] + bit_errors[j*2 + 1];
          end
          last_block = DATA_WIDTH_2/2;

          for (i = 1; i < $clog2(DATA_WIDTH_2); i = i + 1) begin
            new_block = DATA_WIDTH_2/(2**(i+1));
            for (j = 0; j < new_block; j = j + 1) begin
              bit_error_counter[last_block + j] <= bit_error_counter[last_block - j*2 - 1] + bit_error_counter[last_block - j*2 - 2];
            end
            last_block = last_block + new_block;
          end
        end
      end
    end
  end

  // count error bits while system is going out of sync
  always @(posedge clk)
  begin
    if (!rstn) begin
      out_of_sync_total_error_bit <= {$clog2(DATA_WIDTH+1)*$clog2(OUT_OF_SYNC_THRESHOLD){1'b0}};
    end else begin
      if (input_valid) begin
        if (bit_error_counter[DATA_WIDTH_2-2] != {$clog2(DATA_WIDTH+1){1'b0}}) begin
          out_of_sync_total_error_bit <= out_of_sync_total_error_bit + bit_error_counter[DATA_WIDTH_2-2];
        end else begin
          out_of_sync_total_error_bit <= {$clog2(DATA_WIDTH+1)*$clog2(OUT_OF_SYNC_THRESHOLD){1'b0}};
        end
      end
    end
  end

  // check if there are errors in the PRBS sequence
  always @(posedge clk)
  begin
    if (!rstn) begin
      internal_state <= {{MAX_WIDTH-DATA_WIDTH{1'b0}}, input_data};
      state <= 1'b0;
      out_of_sync <= 1'b0;
      oos_counter <= {$clog2(OUT_OF_SYNC_THRESHOLD){1'b0}};
      error_sample <= 1'b0;
      error_bits <= {$clog2(DATA_WIDTH+1){1'b0}};
    end else begin
      out_of_sync <= 1'b0;
      if (init) begin
        state <= 1'b0;
        oos_counter <= {$clog2(OUT_OF_SYNC_THRESHOLD){1'b0}};
        error_sample <= 1'b0;
        error_bits <= {$clog2(DATA_WIDTH+1){1'b0}};
      end else begin
        if (input_valid) begin
          if (!state) begin
            internal_state <= {{MAX_WIDTH-DATA_WIDTH{1'b0}}, input_data};
            state <= 1'b1;
            error_sample <= 1'b0;
            error_bits <= {$clog2(DATA_WIDTH+1){1'b0}};
          end else begin
            internal_state <= polynomial_state;
            error_sample <= (bit_error_counter[DATA_WIDTH_2-2] == {$clog2(DATA_WIDTH+1){1'b0}}) ? 1'b0 : 1'b1;
            error_bits <= bit_error_counter[DATA_WIDTH_2-2];
            if (bit_error_counter[DATA_WIDTH_2-2] != 0) begin
              if (oos_counter == OUT_OF_SYNC_THRESHOLD-1) begin
                oos_counter <= {$clog2(OUT_OF_SYNC_THRESHOLD){1'b0}};
                state <= 1'b0;
                out_of_sync <= 1'b1;
              end else begin
                oos_counter <= oos_counter + 1'b1;
              end
            end else begin
              oos_counter <= {$clog2(OUT_OF_SYNC_THRESHOLD){1'b0}};
            end
          end
        end
      end
    end
  end

endmodule
