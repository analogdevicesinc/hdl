// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module pipeline_stage #(
  parameter REGISTERED = 1,
  parameter WIDTH = 1
) (
  input clk,
  input [WIDTH-1:0] in,
  output [WIDTH-1:0] out
);

  generate if (REGISTERED == 0) begin
    assign out = in;
  end else begin
    (* shreg_extract = "no" *)  reg [REGISTERED*WIDTH-1:0] in_dly = {REGISTERED*WIDTH{1'b0}};
    always @(posedge clk) in_dly <= {in_dly,in};
    assign out = in_dly[REGISTERED*WIDTH-1 -: WIDTH];
  end endgenerate

endmodule
