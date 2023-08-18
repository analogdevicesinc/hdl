// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_soft_pcs_rx #(
  parameter NUM_LANES = 1,
  parameter DATA_PATH_WIDTH = 4,
  parameter REGISTER_INPUTS = 0,
  parameter INVERT_INPUTS = 0
) (
  input clk,
  input reset,

  input patternalign_en,

  input [NUM_LANES*DATA_PATH_WIDTH*10-1:0] data,

  output reg [NUM_LANES*DATA_PATH_WIDTH*8-1:0] char,
  output reg [NUM_LANES*DATA_PATH_WIDTH-1:0] charisk,
  output reg [NUM_LANES*DATA_PATH_WIDTH-1:0] notintable,
  output reg [NUM_LANES*DATA_PATH_WIDTH-1:0] disperr
);

  localparam LANE_DATA_WIDTH = DATA_PATH_WIDTH * 10;

  wire [NUM_LANES*LANE_DATA_WIDTH-1:0] data_aligned;

  wire [NUM_LANES*DATA_PATH_WIDTH*8-1:0] char_s;
  wire [NUM_LANES*DATA_PATH_WIDTH-1:0] charisk_s;
  wire [NUM_LANES*DATA_PATH_WIDTH-1:0] notintable_s;
  wire [NUM_LANES*DATA_PATH_WIDTH-1:0] disperr_s;

  reg [NUM_LANES-1:0] disparity = {NUM_LANES{1'b0}};
  wire [DATA_PATH_WIDTH:0] disparity_chain[0:NUM_LANES-1];

  wire [NUM_LANES*DATA_PATH_WIDTH*10-1:0] data_s;
  wire patternalign_en_s;

  always @(posedge clk) begin
    char <= char_s;
    charisk <= charisk_s;
    notintable <= notintable_s;
    disperr <= disperr_s;
  end

  generate
  genvar lane;
  genvar i;
  if (REGISTER_INPUTS > 0) begin
    reg                                     patternalign_en_r;
    reg [NUM_LANES*DATA_PATH_WIDTH*10-1:0]  data_r;
    always @(posedge clk) begin
      patternalign_en_r <= patternalign_en;
      data_r  <= data;
    end
    assign patternalign_en_s = patternalign_en_r;
    assign data_s = data_r;
  end else begin
    assign patternalign_en_s = patternalign_en;
    assign data_s = data;
  end

  for (lane = 0; lane < NUM_LANES; lane = lane + 1) begin: gen_lane

    jesd204_pattern_align #(
      .DATA_PATH_WIDTH(DATA_PATH_WIDTH)
    ) i_pattern_align (
      .clk(clk),
      .reset(reset),

      .patternalign_en(patternalign_en_s),
      .in_data(data_s[LANE_DATA_WIDTH*lane+:LANE_DATA_WIDTH]),
      .out_data(data_aligned[LANE_DATA_WIDTH*lane+:LANE_DATA_WIDTH]));

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
      wire [9:0] in_char;
      if (REGISTER_INPUTS > 1) begin
        reg [9:0] in_char_r = 10'b0;
        always @(posedge clk) begin
          in_char_r <= INVERT_INPUTS ? ~data_aligned[j*10+:10] :
                                        data_aligned[j*10+:10];
        end
        assign in_char = in_char_r;
      end else begin
        assign in_char = INVERT_INPUTS ? ~data_aligned[j*10+:10] :
                                          data_aligned[j*10+:10];
      end

      jesd204_8b10b_decoder i_dec (
        .in_char(in_char),
        .out_char(char_s[j*8+:8]),
        .out_charisk(charisk_s[j]),
        .out_notintable(notintable_s[j]),
        .out_disperr(disperr_s[j]),

        .in_disparity(disparity_chain[lane][i]),
        .out_disparity(disparity_chain[lane][i+1]));
    end
  end
  endgenerate

endmodule
