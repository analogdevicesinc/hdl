// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_scrambler #(
  parameter WIDTH = 32,
  parameter DESCRAMBLE = 0
) (
  input clk,
  input reset,

  input enable,

  input [WIDTH-1:0] data_in,
  output [WIDTH-1:0] data_out
);

  reg [14:0] state = 'h7f80;
  reg [WIDTH-1:0] swizzle_out;
  wire [WIDTH-1:0] swizzle_in;
  wire [WIDTH-1:0] feedback;
  wire [WIDTH-1+15:0] full_state;

  generate
  genvar i;
  for (i = 0; i < WIDTH / 8; i = i + 1) begin: gen_swizzle
    assign swizzle_in[WIDTH-1-i*8:WIDTH-i*8-8] = data_in[i*8+7:i*8];
    assign data_out[WIDTH-1-i*8:WIDTH-i*8-8] = swizzle_out[i*8+7:i*8];
  end
  endgenerate

  assign full_state = {state,DESCRAMBLE ? swizzle_in : feedback};
  assign feedback = full_state[WIDTH-1+15:15] ^ full_state[WIDTH-1+14:14] ^ swizzle_in;

  always @(*) begin
    if (enable == 1'b0) begin
      swizzle_out = swizzle_in;
    end else begin
      swizzle_out = feedback;
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      state <= 'h7f80;
    end else begin
      state <= full_state[14:0];
    end
  end

endmodule
