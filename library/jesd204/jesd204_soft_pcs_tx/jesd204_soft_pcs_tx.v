// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_soft_pcs_tx #(
  parameter NUM_LANES = 1,
  parameter DATA_PATH_WIDTH = 4,
  parameter INVERT_OUTPUTS = 0
) (
  input clk,
  input reset,

  input [NUM_LANES*DATA_PATH_WIDTH*8-1:0] char,
  input [NUM_LANES*DATA_PATH_WIDTH-1:0] charisk,

  output reg [NUM_LANES*DATA_PATH_WIDTH*10-1:0] data
);

  reg [NUM_LANES-1:0] disparity = 'h00;

  wire [DATA_PATH_WIDTH:0] disparity_chain[0:NUM_LANES-1];
  wire [NUM_LANES*DATA_PATH_WIDTH*10-1:0] data_s;

  always @(posedge clk) begin
    data <= INVERT_OUTPUTS ? ~data_s : data_s;
  end

  generate
  genvar lane;
  genvar i;
  for (lane = 0; lane < NUM_LANES; lane = lane + 1) begin: gen_lane
    assign disparity_chain[lane][0] = disparity[lane];

    always @(posedge clk) begin
      if (reset == 1'b1) begin
        disparity[lane] <= 1'b0;
      end else begin
        disparity[lane] <= disparity_chain[lane][DATA_PATH_WIDTH];
      end
    end

    for (i = 0; i < DATA_PATH_WIDTH; i = i + 1) begin: gen_dpw
      localparam j = DATA_PATH_WIDTH * lane + i;

      jesd204_8b10b_encoder i_enc (
        .in_char(char[j*8+:8]),
        .in_charisk(charisk[j]),
        .out_char(data_s[j*10+:10]),

        .in_disparity(disparity_chain[lane][i]),
        .out_disparity(disparity_chain[lane][i+1]));
    end
  end
  endgenerate

endmodule
