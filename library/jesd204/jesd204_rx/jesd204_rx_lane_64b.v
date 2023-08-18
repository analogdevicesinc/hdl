// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2020-2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_rx_lane_64b #(
  parameter ELASTIC_BUFFER_SIZE = 256,
  parameter TPL_DATA_PATH_WIDTH = 8,
  parameter ASYNC_CLK = 0
) (
  input clk,
  input reset,

  input device_clk,
  input device_reset,

  input [63:0] phy_data,
  input [1:0] phy_header,
  input phy_block_sync,

  output [TPL_DATA_PATH_WIDTH*8-1:0] rx_data,

  output reg buffer_ready_n = 'b1,
  input all_buffer_ready_n,
  input buffer_release_n,

  input lmfc_edge,
  output emb_lock,

  input cfg_disable_scrambler,
  input [1:0] cfg_header_mode,  // 0 - CRC12 ; 1 - CRC3; 2 - FEC; 3 - CMD
  input [4:0] cfg_rx_thresh_emb_err,
  input [7:0] cfg_beats_per_multiframe,

  input ctrl_err_statistics_reset,
  input [3:0] ctrl_err_statistics_mask,
  output [31:0] status_err_statistics_cnt,

  output [2:0] status_lane_emb_state,
  output reg [7:0] status_lane_skew
);

  reg [11:0] crc12_calculated_prev;

  wire [63:0] data_descrambled_s;
  wire [63:0] data_descrambled;
  wire [63:0] data_descrambled_reordered;
  wire [11:0] crc12_received;
  wire [11:0] crc12_calculated;

  wire event_invalid_header;
  wire event_unexpected_eomb;
  wire event_unexpected_eoemb;
  wire event_crc12_mismatch;
  wire err_cnt_rst;

  wire [63:0] rx_data_msb_s;

  wire eomb;
  wire eoemb;

  wire [7:0] sh_count;

  jesd204_rx_header i_rx_header (
    .clk(clk),
    .reset(reset),

    .sh_lock(phy_block_sync),
    .header(phy_header),

    .cfg_header_mode(cfg_header_mode),
    .cfg_rx_thresh_emb_err(cfg_rx_thresh_emb_err),
    .cfg_beats_per_multiframe(cfg_beats_per_multiframe),

    .emb_lock(emb_lock),

    .valid_eomb(eomb),
    .valid_eoemb(eoemb),
    .crc12(crc12_received),
    .crc3(),
    .fec(),
    .cmd(),
    .sh_count(sh_count),

    .status_lane_emb_state(status_lane_emb_state),
    .event_invalid_header(event_invalid_header),
    .event_unexpected_eomb(event_unexpected_eomb),
    .event_unexpected_eoemb(event_unexpected_eoemb));

  jesd204_crc12 i_crc12 (
    .clk(clk),
    .reset(1'b0),
    .init(eomb),
    .data_in(phy_data),
    .crc12(crc12_calculated));

  reg crc12_on = 'b0;
  always @(posedge clk) begin
    if (reset == 1'b1) begin
      crc12_on <= 1'b0;
    end else if (eomb) begin
      crc12_on <= 1'b1;
    end
  end

  reg crc12_rdy = 'b0;
  always @(posedge clk) begin
    if (reset == 1'b1) begin
      crc12_rdy <= 1'b0;
    end else if (crc12_on && eomb) begin
      crc12_rdy <= 1'b1;
    end
  end

  always @(posedge clk) begin
    if (eomb) begin
      crc12_calculated_prev <= crc12_calculated;
    end
  end

  assign event_crc12_mismatch = crc12_rdy && eomb && (crc12_calculated_prev != crc12_received);

  assign err_cnt_rst = reset || ctrl_err_statistics_reset;

  error_monitor #(
    .EVENT_WIDTH(4),
    .CNT_WIDTH(32)
  ) i_error_monitor (
    .clk(clk),
    .reset(err_cnt_rst),
    .active(1'b1),
    .error_event({
      event_invalid_header,
      event_unexpected_eomb,
      event_unexpected_eoemb,
      event_crc12_mismatch
    }),
    .error_event_mask(ctrl_err_statistics_mask),
    .status_err_cnt(status_err_statistics_cnt));

  jesd204_scrambler_64b #(
    .WIDTH(64),
    .DESCRAMBLE(1)
  ) i_descrambler (
    .clk(clk),
    .reset(1'b0),
    .enable(~cfg_disable_scrambler),
    .data_in(phy_data),
    .data_out(data_descrambled_s));

  pipeline_stage #(
    .WIDTH(64),
    .REGISTERED(1)
  ) i_pipeline_stage2 (
    .clk(clk),
    .in({
        data_descrambled_s
      }),
    .out({
        data_descrambled
      }));

  // Control when data is written to the elastic buffer
  // Start writing to the buffer when current lane is multiblock locked, but if
  // other lanes are not writing in the next half multiblock period stop
  // writing.
  // This limits the supported lane skew to half of the multiframe
  always @(posedge clk) begin
    if (reset | ~emb_lock) begin
      buffer_ready_n <= 1'b1;
    end else if (sh_count == {1'b0,cfg_beats_per_multiframe[7:1]} && all_buffer_ready_n) begin
      buffer_ready_n <= 1'b1;
    end else if (eoemb) begin
      buffer_ready_n <= 1'b0;
    end
  end

  elastic_buffer #(
    .IWIDTH(64),
    .OWIDTH(TPL_DATA_PATH_WIDTH*8),
    .SIZE(ELASTIC_BUFFER_SIZE),
    .ASYNC_CLK(ASYNC_CLK)
  ) i_elastic_buffer (
    .clk(clk),
    .reset(reset),

    .device_clk(device_clk),
    .device_reset(device_reset),

    .wr_data(data_descrambled_reordered),
    .rd_data(rx_data),

    .ready_n(buffer_ready_n),
    .do_release_n(buffer_release_n));

  // Measure the delay from the eoemb to the next LMFC edge.
  always @(posedge clk) begin
    if (lmfc_edge) begin
      status_lane_skew <= sh_count;
    end
  end

  /* Reorder octets LSB first */
  genvar i;
  generate
    for (i = 0; i < 64; i = i + 8) begin: g_link_data
      assign data_descrambled_reordered[i+:8] = data_descrambled[64-1-i-:8];
    end
  endgenerate

endmodule
