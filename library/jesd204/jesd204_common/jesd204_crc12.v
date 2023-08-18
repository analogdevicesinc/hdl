// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_crc12 #(
  parameter WIDTH = 64
) (
  input clk,
  input reset,

  input init,

  input [WIDTH-1:0] data_in,
  output [11:0] crc12
);

  reg [11:0] state = 12'b0;

  wire [WIDTH-1:0] feedback;
  wire [WIDTH-1+12:0] full_state;

  assign full_state = {init ? 12'h0 : state, feedback};
  assign feedback = full_state[WIDTH-1+12:12] ^
                    full_state[WIDTH-1:11] ^
                    full_state[WIDTH-1:10] ^
                    full_state[WIDTH-1:9] ^
                    full_state[WIDTH-1:4] ^
                    full_state[WIDTH-1:3] ^
                    data_in;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      state <= 12'b0;
    end else begin
      state <= full_state[11:0] ^
              {full_state[10:0],1'b0} ^
              {full_state[9:0],2'b0} ^
              {full_state[8:0],3'b0} ^
              {full_state[3:0],8'b0} ^
              {full_state[2:0],9'b0};
    end
  end

  assign crc12 = state;

endmodule
