// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2019, 2021, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_frame_align_replace_tb;

  parameter VCD_FILE = "jesd204_frame_align_replace_tb.vcd";
  `define TIMEOUT 1000000
  `include "tb_base.v"

  localparam DATA_PATH_WIDTH = 8;
  localparam IS_RX = 1'b1;

  wire [7:0]                    cfg_octets_per_frame = 5;
  wire                          cfg_disable_char_replacement = 1'b0;
  wire                          cfg_disable_scrambler = 1'b1;
  reg [DATA_PATH_WIDTH*8-1:0]   data;
  reg [DATA_PATH_WIDTH-1:0]     eof;
  reg [DATA_PATH_WIDTH-1:0]     eomf;
  reg [DATA_PATH_WIDTH-1:0]     char_is_a;
  reg [DATA_PATH_WIDTH-1:0]     char_is_f;
  wire [DATA_PATH_WIDTH*8-1:0]  data_out;
  wire [DATA_PATH_WIDTH-1:0]    charisk_out;
  reg [31:00] ii;

  initial begin
    forever begin
      for(ii = 0; ii < DATA_PATH_WIDTH; ii = ii + 1) begin
        eof[ii] = $urandom_range(cfg_octets_per_frame) == 0;
        eomf[ii] = $urandom_range(cfg_octets_per_frame*4) == 0;
        char_is_a[ii] = $urandom_range(cfg_octets_per_frame*2) == 0;
        char_is_f[ii] = $urandom_range(cfg_octets_per_frame*2) == 0;
      end
      data = {$urandom, $urandom};
      @(negedge clk);
    end
  end

  jesd204_frame_align_replace #(
    .DATA_PATH_WIDTH              (DATA_PATH_WIDTH),
    .IS_RX                        (IS_RX)
  ) frame_align_replace (
    .clk                          (clk),
    .reset                        (reset),
    .cfg_octets_per_frame         (cfg_octets_per_frame),
    .cfg_disable_char_replacement (cfg_disable_char_replacement),
    .cfg_disable_scrambler        (cfg_disable_scrambler),
    .data                         (data),
    .eof                          (eof),
    .rx_char_is_a                 (char_is_a),
    .rx_char_is_f                 (char_is_f),
    .tx_eomf                      (eomf),
    .data_out                     (data_out),
    .charisk_out                  (charisk_out));

endmodule
