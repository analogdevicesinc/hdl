// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module soft_pcs_pattern_align_tb;
  parameter VCD_FILE = "soft_pcs_pattern_align_tb.vcd";

  localparam [9:0] PATTERN_P = 10'b1010000011;
  localparam [9:0] PATTERN_N = 10'b0101111100;

  `define TIMEOUT 1000000
  `include "tb_base.v"

  integer counter = 0;

  reg [3:0] bitshift = 4'd0;
  reg [9:0] comma_unaligned;
  reg comma_sync = 1'b0;
  wire [9:0] comma_aligned;
  reg [9:0] comma = PATTERN_P;

  wire comma_match = comma == comma_aligned;

  always @(posedge clk) begin
    if (counter == 63) begin
      if (comma_sync != 1'b1) begin
        failed <= 1'b1;
      end

      comma_sync <= 1'b0;
      counter <= 0;
      bitshift <= {$random} % 10;
      comma <= {$random} % 2 ? PATTERN_P : PATTERN_N;
    end else begin
      counter <= counter + 1'b1;

      // Takes two clock cycles for the new value to propagate
      if (counter > 1) begin
        // Shouldn't loose sync after it gained it
        if (comma_match == 1'b1) begin
          comma_sync <= 1'b1;
        end else if (comma_sync == 1'b1) begin
          failed <= 1'b1;
        end
      end
    end
  end

  always @(*) begin
    case (bitshift)
    4'd0: comma_unaligned <= comma[9:0];
    4'd1: comma_unaligned <= {comma[0],comma[9:1]};
    4'd2: comma_unaligned <= {comma[1:0],comma[9:2]};
    4'd3: comma_unaligned <= {comma[2:0],comma[9:3]};
    4'd4: comma_unaligned <= {comma[3:0],comma[9:4]};
    4'd5: comma_unaligned <= {comma[4:0],comma[9:5]};
    4'd6: comma_unaligned <= {comma[5:0],comma[9:6]};
    4'd7: comma_unaligned <= {comma[6:0],comma[9:7]};
    4'd8: comma_unaligned <= {comma[7:0],comma[9:8]};
    default: comma_unaligned <= {comma[8:0],comma[9]};
    endcase
  end

  jesd204_pattern_align #(
    .DATA_PATH_WIDTH(1)
  ) i_pa (
    .clk(clk),
    .reset(1'b0),
    .patternalign_en(1'b1),

    .in_data(comma_unaligned),
    .out_data(comma_aligned));

endmodule
