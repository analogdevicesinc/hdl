// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_scrambler_64b #(
  parameter WIDTH = 64,
  parameter DESCRAMBLE = 0
) (
  input clk,
  input reset,

  input enable,

  input [WIDTH-1:0] data_in,
  output reg [WIDTH-1:0] data_out
);

  reg [57:0] state = {1'b1,57'b0};
  wire [WIDTH-1:0] feedback;
  wire [WIDTH-1+58:0] full_state;

  assign full_state = {state,DESCRAMBLE ? data_in : feedback};
  assign feedback = full_state[WIDTH-1+58:58] ^ full_state[WIDTH-1:39] ^ data_in;

  always @(*) begin
    if (enable == 1'b0) begin
      data_out = data_in;
    end else begin
      data_out = feedback;
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      state <= {1'b1,57'b0};
    end else begin
      state <= full_state[57:0] ^ {full_state[38:0],19'b0};
    end
  end

endmodule
