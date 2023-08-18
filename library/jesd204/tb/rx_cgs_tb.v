// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module rx_cgs_tb;
  parameter VCD_FILE = "rx_cgs_tb.vcd";

  `define TIMEOUT 1000
  `include "tb_base.v"

  reg [3:0] char_is_error = 4'b0000;
  reg [3:0] char_is_cgs = 4'b1111;

  integer counter = 'h00;
  wire ready;
  reg ready_prev = 1'b0;
/*
  always @(posedge clk) begin
    if ($random % 2 == 0)
      char_is_error <= 4'b1111;
    else
      char_is_error <= 4'b0000;
  end
*/
  always @(posedge clk) begin
    counter <= counter + 1;
    if (counter == 'h20) begin
      char_is_cgs <= 4'b0001;
    end else if (counter > 'h20) begin
      char_is_cgs <= 4'b0000;
    end
  end

  jesd204_rx_cgs i_rx_cgs (
    .clk(clk),
    .reset(reset),
    .char_is_cgs(char_is_cgs),
    .char_is_error(char_is_error),

    .ready(ready));

  reg lost_sync = 1'b0;

  always @(posedge clk) begin
    ready_prev <= ready;
    if (ready_prev == 1'b1 && ready == 1'b0) begin
      lost_sync <= 1'b1;
    end
    failed <= lost_sync | ~ready;
  end

endmodule
