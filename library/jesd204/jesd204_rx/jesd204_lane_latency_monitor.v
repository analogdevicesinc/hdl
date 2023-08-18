// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2021, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_lane_latency_monitor #(
  parameter NUM_LANES = 1,
  parameter DATA_PATH_WIDTH = 4
) (
  input clk,
  input reset,

  input [NUM_LANES-1:0] lane_ready,
  input [NUM_LANES*3-1:0] lane_frame_align,

  output [14*NUM_LANES-1:0] lane_latency,
  output [NUM_LANES-1:0] lane_latency_ready
);

  localparam DPW_LOG2 = DATA_PATH_WIDTH == 8 ? 3 : DATA_PATH_WIDTH == 4 ? 2 : 1;
  localparam BEAT_CNT_WIDTH = 14-DPW_LOG2;

  reg [BEAT_CNT_WIDTH-1:0] beat_counter;

  reg [BEAT_CNT_WIDTH-1:0] lane_latency_mem[0:NUM_LANES-1];
  reg [NUM_LANES-1:0] lane_captured = 'h00;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      beat_counter <= 'h0;
    end else if (beat_counter != {BEAT_CNT_WIDTH{1'b1}}) begin
      beat_counter <= beat_counter + 1'b1;
    end
  end

  generate
  genvar i;

  for (i = 0; i < NUM_LANES; i = i + 1) begin: gen_lane
    always @(posedge clk) begin
      if (reset == 1'b1) begin
        lane_latency_mem[i] <= 'h00;
        lane_captured[i] <= 1'b0;
      end else if (lane_ready[i] == 1'b1 && lane_captured[i] == 1'b0) begin
        lane_latency_mem[i] <= beat_counter;
        lane_captured[i] <= 1'b1;
      end
    end

    assign lane_latency[i*14+13:i*14] = {lane_latency_mem[i],lane_frame_align[(i*3)+DPW_LOG2-1:i*3]};
    assign lane_latency_ready[i] = lane_captured[i];
  end
  endgenerate

endmodule
