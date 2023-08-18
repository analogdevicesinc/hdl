// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2021, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module align_mux #(
  parameter DATA_PATH_WIDTH = 4
) (
  input clk,
  input [2:0] align,
  input [DATA_PATH_WIDTH*8-1:0] in_data,
  input [DATA_PATH_WIDTH-1:0] in_charisk,
  output [DATA_PATH_WIDTH*8-1:0] out_data,
  output [DATA_PATH_WIDTH-1:0] out_charisk
);

  localparam DPW_LOG2 = DATA_PATH_WIDTH == 8 ? 3 : DATA_PATH_WIDTH == 4 ? 2 : 1;

  wire [DPW_LOG2-1:0]                align_int;
  reg  [DATA_PATH_WIDTH*8-1:0]       in_data_d1;
  reg  [DATA_PATH_WIDTH-1:0]         in_charisk_d1;
  wire [(DATA_PATH_WIDTH*8*2)-1:0]   data;
  wire [(DATA_PATH_WIDTH*2)-1:0]     charisk;

  always @(posedge clk) begin
    in_data_d1 <= in_data;
    in_charisk_d1 <= in_charisk;
  end

  assign data = {in_data, in_data_d1};
  assign charisk = {in_charisk, in_charisk_d1};

  assign align_int = align[DPW_LOG2-1:0];

  assign out_data = data[align_int*8 +: (DATA_PATH_WIDTH*8)];
  assign out_charisk = charisk[align_int +: DATA_PATH_WIDTH];

endmodule
