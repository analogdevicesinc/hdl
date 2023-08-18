// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020-2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_rx_ctrl_64b #(
  parameter NUM_LANES = 1
) (
  input clk,
  input reset,

  input [NUM_LANES-1:0] cfg_lanes_disable,

  input [NUM_LANES-1:0] phy_block_sync,

  input [NUM_LANES-1:0] emb_lock,

  output all_emb_lock,
  input buffer_release_n,

  output [1:0] status_state,
  output reg event_unexpected_lane_state_error
);

  localparam STATE_RESET = 2'b00;
  localparam STATE_WAIT_BS = 2'b01;
  localparam STATE_BLOCK_SYNC = 2'b10;
  localparam STATE_DATA = 2'b11;

  reg [1:0] state = STATE_RESET;
  reg [1:0] next_state;
  reg [5:0] good_cnt;
  reg rst_good_cnt;
  reg event_unexpected_lane_state_error_nx;

  wire [NUM_LANES-1:0] phy_block_sync_masked;
  wire [NUM_LANES-1:0] emb_lock_masked;
  wire all_block_sync;

  reg [NUM_LANES-1:0] emb_lock_d = {NUM_LANES{1'b0}};
  reg buffer_release_d_n = 1'b1;

  always @(posedge clk) begin
    emb_lock_d <= emb_lock;
    buffer_release_d_n <= buffer_release_n;
  end

  assign phy_block_sync_masked = phy_block_sync | cfg_lanes_disable;
  assign emb_lock_masked = emb_lock_d | cfg_lanes_disable;

  assign all_block_sync = &phy_block_sync_masked;
  assign all_emb_lock = &emb_lock_masked;

  always @(*) begin
    next_state = state;
    rst_good_cnt = 1'b1;
    event_unexpected_lane_state_error_nx = 1'b0;
    case (state)
      STATE_RESET:
        next_state = STATE_WAIT_BS;
      STATE_WAIT_BS:
        if (all_block_sync) begin
          rst_good_cnt = 1'b0;
          if (&good_cnt) begin
            next_state = STATE_BLOCK_SYNC;
          end
        end
      STATE_BLOCK_SYNC:
        if (~all_block_sync) begin
          next_state = STATE_WAIT_BS;
        end else if (all_emb_lock & ~buffer_release_d_n) begin
          rst_good_cnt = 1'b0;
          if (&good_cnt) begin
            next_state = STATE_DATA;
          end
        end
      STATE_DATA:
        if (~all_block_sync) begin
          next_state = STATE_WAIT_BS;
          event_unexpected_lane_state_error_nx = 1'b1;
        end else if (~all_emb_lock | buffer_release_d_n) begin
          next_state = STATE_BLOCK_SYNC;
          event_unexpected_lane_state_error_nx = 1'b1;
        end
    endcase
  end

  // Wait n consecutive valid cycles before jumping into next state
  always @(posedge clk) begin
    if (reset || rst_good_cnt) begin
      good_cnt <= 'h0;
    end else begin
      good_cnt <= good_cnt + 1;
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      state <= STATE_RESET;
    end else begin
      state <= next_state;
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      event_unexpected_lane_state_error <= 1'b0;
    end else begin
      event_unexpected_lane_state_error <= event_unexpected_lane_state_error_nx;
    end
  end

  assign status_state = state;

endmodule
