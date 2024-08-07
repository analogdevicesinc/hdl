// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2019, 2021, 2024 Analog Devices, Inc. All rights reserved.
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

  reg [63:0]   txdata_d;
  reg [ 1:0]   txheader_d;
  reg [ 3:0]   txcharisk_d;

  always @(posedge usr_clk) begin
    txdata_d <= tx_data;
    txheader_d <= tx_header;
    txcharisk_d <= tx_charisk;
  end

  generate if (LINK_MODE == 2) begin
    wire [63:0] tx_data_flip;
    wire [ 1:0] tx_header_flip;
    genvar i;
    for (i = 0; i < 64; i=i+1) begin
      assign tx_data_flip[63-i] = txdata_d[i];
    end
    assign tx_header_flip = {txheader_d[0], txheader_d[1]};

    // Flip header bits and data
    assign txdata   = {64'b0, tx_data_flip};
    assign txheader = {4'b0, tx_header_flip};

    assign txctrl0  = 16'b0;
    assign txctrl1  = 16'b0;
    assign txctrl2  = 16'b0;
  end else begin
    assign txdata   = {96'b0, txdata_d[31:0]};
    assign txheader = {4'b0, txheader_d};
    assign txctrl2  = {4'b0, txcharisk_d};
    assign txctrl0  = 16'b0;
    assign txctrl1  = 16'b0;
  end
  endgenerate

endmodule
