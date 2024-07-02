// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2019, 2021, 2024 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module  jesd204_versal_gt_adapter_tx (
  output reg [127 : 0] txdata,
  output reg   [5 : 0] txheader,

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

  // Flip header bits and data
  always @(posedge usr_clk) begin
    txdata <= {64'b0, tx_data_flip};
    txheader <= {4'b0, tx_header[0], tx_header[1]};
  end

endmodule
