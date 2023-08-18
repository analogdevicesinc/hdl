// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2020-2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_rx_frame_align #(
  parameter DATA_PATH_WIDTH = 4,
  parameter ENABLE_CHAR_REPLACE = 0
) (
  input                             clk,
  input                             reset,
  input [9:0]                       cfg_octets_per_multiframe,
  input [7:0]                       cfg_octets_per_frame,
  input                             cfg_disable_char_replacement,
  input                             cfg_disable_scrambler,
  input [DATA_PATH_WIDTH-1:0]       charisk28,
  input [DATA_PATH_WIDTH*8-1:0]     data,

  output [DATA_PATH_WIDTH*8-1:0]    data_replaced,
  output reg [7:0]                  align_err_cnt
);

  // Reset alignment error count on good multiframe alignment,
  // or on good frame or multiframe alignment
  // If disabled, misalignments could me masked if
  // due to cfg_octets_per_multiframe mismatch or due to
  // a slip of a multiple of cfg_octets_per_frame octets
  localparam RESET_COUNT_ON_MF_ONLY = 1'b1;

  localparam DPW_LOG2 = DATA_PATH_WIDTH == 8 ? 3 :
    DATA_PATH_WIDTH == 4 ? 2 : 1;

  function automatic [DPW_LOG2*2:0] count_ones(input [DATA_PATH_WIDTH*2-1:0] val);
    reg [DPW_LOG2*2-1:0] ii;
    begin
      count_ones = 0;
      for(ii = 0; ii != (DATA_PATH_WIDTH*2-1); ii=ii+1) begin
        count_ones = count_ones + val[ii];
      end
    end
  endfunction

  reg  [DATA_PATH_WIDTH-1:0]        char_is_a;
  reg  [DATA_PATH_WIDTH-1:0]        char_is_f;
  wire [DATA_PATH_WIDTH-1:0]        eof;
  wire [DATA_PATH_WIDTH-1:0]        eomf;
  reg  [DATA_PATH_WIDTH-1:0]        eof_err;
  reg  [DATA_PATH_WIDTH-1:0]        eof_good;
  reg  [DATA_PATH_WIDTH-1:0]        eomf_err;
  reg  [DATA_PATH_WIDTH-1:0]        eomf_good;
  reg                               align_good;
  reg                               align_err;
  reg  [DPW_LOG2*2:0]               cur_align_err_cnt;
  wire [8:0]                        align_err_cnt_next;

  wire [7:0] cfg_beats_per_multiframe = cfg_octets_per_multiframe>>DPW_LOG2;

  jesd204_frame_mark #(
    .DATA_PATH_WIDTH (DATA_PATH_WIDTH)
  ) i_frame_mark (
    .clk (clk),
    .reset (reset),
    .cfg_octets_per_multiframe (cfg_octets_per_multiframe),
    .cfg_beats_per_multiframe (cfg_beats_per_multiframe),
    .cfg_octets_per_frame (cfg_octets_per_frame),
    .sof (),
    .eof (eof),
    .somf (),
    .eomf (eomf));

  genvar ii;
  generate
  for (ii = 0; ii < DATA_PATH_WIDTH; ii = ii + 1) begin: gen_k_char
    always @(*) begin
      char_is_a[ii] = 1'b0;
      char_is_f[ii] = 1'b0;

      if(charisk28[ii]) begin
        if(data[ii*8+7:ii*8+5] == 3'd3) begin
          char_is_a[ii] = 1'b1;
        end
        if(data[ii*8+7:ii*8+5] == 3'd7) begin
          char_is_f[ii] = 1'b1;
        end
      end
    end

    always @(posedge clk) begin
      if(reset) begin
        eomf_err[ii] <= 1'b0;
        eomf_good[ii] <= 1'b0;
        eof_err[ii] <= 1'b0;
        eof_good[ii] <= 1'b0;
      end else begin
        eomf_err[ii]  <= char_is_a[ii] && !eomf[ii];
        eomf_good[ii] <= char_is_a[ii] && eomf[ii];
        eof_err[ii]   <= char_is_f[ii] && !eof[ii];
        eof_good[ii]  <= char_is_f[ii] && eof[ii];
      end
    end
  end
  endgenerate

  always @(posedge clk) begin
    if(reset) begin
      align_good <= 1'b0;
      align_err <= 1'b0;
    end else begin
      if(RESET_COUNT_ON_MF_ONLY) begin
        align_good <= |eomf_good;
      end else begin
        align_good <= |({eomf_good, eof_good});
      end

      align_err <= |({eomf_err, eof_err});
    end
  end

  assign align_err_cnt_next = {1'b0, align_err_cnt} + cur_align_err_cnt;

  // Alignment error counter
  // Resets upon good alignment
  always @(posedge clk) begin
    if(reset) begin
      align_err_cnt <= 8'd0;
      cur_align_err_cnt <= 'd0;
    end else begin
      cur_align_err_cnt <= count_ones({eomf_err, eof_err});

      if(align_good && !align_err) begin
        align_err_cnt <= 8'd0;
      end else if(align_err_cnt_next[8]) begin
        align_err_cnt <= 8'hFF;
      end else begin
        align_err_cnt <= align_err_cnt_next[7:0];
      end
    end
  end

  jesd204_frame_align_replace #(
    .DATA_PATH_WIDTH (DATA_PATH_WIDTH),
    .IS_RX (1'b1),
    .ENABLED (ENABLE_CHAR_REPLACE)
  ) i_align_replace (
    .clk (clk),
    .reset (reset),
    .cfg_octets_per_frame (cfg_octets_per_frame),
    .cfg_disable_char_replacement (cfg_disable_char_replacement),
    .cfg_disable_scrambler (cfg_disable_scrambler),
    .data (data),
    .eof (eof),
    .rx_char_is_a (char_is_a),
    .rx_char_is_f (char_is_f),
    .tx_eomf ({DATA_PATH_WIDTH{1'b0}}),
    .data_out (data_replaced),
    .charisk_out ());

endmodule
