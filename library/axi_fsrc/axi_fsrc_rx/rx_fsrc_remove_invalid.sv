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

// Removes FSRC invalid samples.

`default_nettype none

module rx_fsrc_remove_invalid #(
  parameter DATA_WIDTH = 512,
  parameter NP = 16
)(
  input  wire                     clk,
  input  wire                     reset,
  input  wire                     fsrc_en,

  input  wire  [DATA_WIDTH-1:0]   in_data,
  input  wire                     in_valid,

  output logic [DATA_WIDTH-1:0]   out_data,
  output logic                    out_valid
);

  localparam NUM_SAMPLES = DATA_WIDTH / NP;
  localparam FSRC_INVALID_SAMPLE = {1'b1, {(NP-1){1'b0}}};

  logic [DATA_WIDTH-1:0]   in_data_d;
  logic                    in_valid_d;
  logic [NUM_SAMPLES-1:0]  invalid_sample;
  logic [DATA_WIDTH-1:0]   out_data_fsrc;
  logic                    out_valid_fsrc;
  genvar ii;

  always_ff @(posedge clk) begin
    if(reset) begin
      in_valid_d <= '0;
    end else begin
      in_valid_d <= in_valid;
    end
  end

  always_ff @(posedge clk) begin
    in_data_d <= in_data;
  end

  for(ii = 0; ii < NUM_SAMPLES; ii=ii+1) begin : invalid_sample_check_gen
    always_ff @(posedge clk) begin
      if(reset) begin
        invalid_sample[ii] <= '0;
      end else begin
        invalid_sample[ii] <= in_data[ii*NP+:NP] == FSRC_INVALID_SAMPLE;
      end
    end
  end

  fill_holes #(
    .WORD_LENGTH  (NP),
    .NUM_WORDS    (NUM_SAMPLES)
  ) fill_holes (
    .clk              (clk),
    .reset            (reset),
    .in_holes         (invalid_sample),
    .in_data          (in_data_d),
    .in_valid         (in_valid_d),
    .out_data         (out_data_fsrc),
    .out_valid        (out_valid_fsrc)
  );

  assign out_data = fsrc_en ? out_data_fsrc : in_data_d;
  assign out_valid = fsrc_en ? out_valid_fsrc : in_valid_d;

endmodule

`default_nettype wire
