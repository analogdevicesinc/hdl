// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module error_monitor #(
  parameter EVENT_WIDTH = 16,
  parameter CNT_WIDTH = 32
) (
  input clk,
  input reset,
  input active,
  input [EVENT_WIDTH-1:0] error_event,
  input [EVENT_WIDTH-1:0] error_event_mask,
  output reg [CNT_WIDTH-1:0] status_err_cnt = 'h0
);

  localparam EVENT_WIDTH_LOG = $clog2(EVENT_WIDTH);

  reg  [EVENT_WIDTH-1:0] err;

  function [EVENT_WIDTH_LOG-1:0] num_set_bits;
  input [EVENT_WIDTH-1:0] x;
  integer j;
  begin
    num_set_bits = 0;
    for (j = 0; j < EVENT_WIDTH; j = j + 1) begin
      num_set_bits = num_set_bits + x[j];
    end
  end
  endfunction

  always @(posedge clk) begin
    if (active == 1'b1) begin
      err <= (~error_event_mask) & error_event;
    end else begin
      err <= {EVENT_WIDTH{1'b0}};
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      status_err_cnt <= 'h0;
    end else if (~&status_err_cnt[CNT_WIDTH-1:EVENT_WIDTH_LOG]) begin
      status_err_cnt <= status_err_cnt + num_set_bits(err);
    end
  end

endmodule
