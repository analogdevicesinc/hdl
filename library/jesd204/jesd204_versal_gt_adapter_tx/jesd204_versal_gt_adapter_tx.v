// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2019, 2021 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module  jesd204_versal_gt_adapter_tx (
  output  [127 : 0] txdata,
  output    [5 : 0] txheader,

  // Interface to Link layer core
  input      [63:0] tx_data,
  input       [1:0] tx_header,

  input             usr_clk
);

  wire [63:0] tx_data_flip;
  genvar i;
  for (i = 0; i < 64; i=i+1) begin
    assign tx_data_flip[63-i] = tx_data[i];
  end

  assign txdata = {64'b0,tx_data_flip};
  // Flip header bits and data
  assign txheader = {4'b0,tx_header[0],tx_header[1]};

endmodule
