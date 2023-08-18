// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020-2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_frame_mark_tb;

  parameter VCD_FILE = "jesd204_frame_mark_tb.vcd";
  `define TIMEOUT 1000000
  `include "tb_base.v"

  localparam DATA_PATH_WIDTH = 8;

  wire [9:0]                  cfg_octets_per_multiframe = 23;
  wire [7:0]                  cfg_beats_per_multiframe = 2;
  wire [7:0]                  cfg_octets_per_frame = 5;
  wire [DATA_PATH_WIDTH-1:0]  sof;
  wire [DATA_PATH_WIDTH-1:0]  somf;
  wire [DATA_PATH_WIDTH-1:0]  eof;
  wire [DATA_PATH_WIDTH-1:0]  eomf;

  jesd204_frame_mark #(
    .DATA_PATH_WIDTH            (DATA_PATH_WIDTH)
  ) frame_mark (
    .clk                        (clk),
    .reset                      (reset),
    .cfg_octets_per_multiframe  (cfg_octets_per_multiframe),
    .cfg_beats_per_multiframe   (cfg_beats_per_multiframe),
    .cfg_octets_per_frame       (cfg_octets_per_frame),
    .sof                        (sof),
    .eof                        (eof),
    .somf                       (somf),
    .eomf                       (eomf));

endmodule
