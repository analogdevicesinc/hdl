// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2019, 2021-2024 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module  jesd204_versal_gt_adapter_tx #(
  parameter LINK_MODE = 2 // 1 - 8B10B, 2 - 64B66B
) (
  output  [127 : 0] txdata,
  output  [  5 : 0] txheader,
  output  [ 15 : 0] txctrl0,
  output  [ 15 : 0] txctrl1,
  output  [  7 : 0] txctrl2,
  // Interface to Link layer core
  input   [ 63 : 0] tx_data,
  input   [  1 : 0] tx_header,
  input   [  3 : 0] tx_charisk,

  input             usr_clk
);

  generate if (LINK_MODE == 2) begin
    wire [63:0] tx_data_flip;
    genvar i;
    for (i = 0; i < 64; i=i+1) begin
      assign tx_data_flip[63-i] = tx_data[i];
    end

    assign txdata   = {64'b0, tx_data_flip};
    assign txheader = {4'b0, tx_header[0], tx_header[1]};
    assign txctrl0  = 16'b0;
    assign txctrl1  = 16'b0;
    assign txctrl2  = 16'b0;
  end else begin
    assign txdata   = {96'b0, tx_data[31:0]};
    assign txheader = {4'b0, tx_header};
    assign txctrl0  = 16'b0;
    assign txctrl1  = 16'b0;
    assign txctrl2  = {4'b0, tx_charisk};
  end
  endgenerate

endmodule
