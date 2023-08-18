// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module loopback_64b_tb;
  parameter VCD_FILE = "loopback_64b_tb.vcd";
  parameter NUM_LANES = 4;
  parameter NUM_LINKS = 1;
  parameter OCTETS_PER_FRAME = 8;
  parameter FRAMES_PER_MULTIFRAME = 32;
  parameter ENABLE_SCRAMBLER = 1;
  parameter BUFFER_EARLY_RELEASE = 0;
  parameter LANE_DELAY = 1;
  parameter DATA_PATH_WIDTH = 8;

  localparam BEATS_PER_MULTIFRAME = OCTETS_PER_FRAME * FRAMES_PER_MULTIFRAME / 8;
  localparam TX_LATENCY = 3 + i_tx.NUM_OUTPUT_PIPELINE;
  localparam RX_LATENCY = 3;
  localparam BASE_LATENCY = TX_LATENCY + RX_LATENCY;

  `include "tb_base.v"

  reg [5:0] tx_counter = 'h00;
  reg [5:0] rx_counter = 'h00;
  wire tx_ready;
  wire rx_valid;
  wire [NUM_LANES*64-1:0] rx_data;
  reg data_mismatch = 1'b1;

  always @(posedge clk) begin
    if (tx_ready == 1'b1) begin
      tx_counter <= tx_counter + 1'b1;
    end
  end

  reg rx_valid_d1 = 1'b0;

  always @(posedge clk) begin
    rx_valid_d1 <= rx_valid;
    if (rx_valid == 1'b1) begin
      if (rx_valid_d1 == 1'b0) begin
        // Resynchronize counter to the first received data
        rx_counter <= rx_data[7:2] + 1'b1;
      end else begin
        rx_counter <= rx_counter + 1'b1;
      end
    end
  end

  wire [63:0] tx_data =
      {{tx_counter,2'h0,tx_counter,2'h1,tx_counter,2'h2,tx_counter,2'h3},
       {tx_counter,2'h3,tx_counter,2'h2,tx_counter,2'h1,tx_counter,2'h0}};
  wire [63:0] rx_ref_data =
      {{rx_counter,2'h0,rx_counter,2'h1,rx_counter,2'h2,rx_counter,2'h3},
       {rx_counter,2'h3,rx_counter,2'h2,rx_counter,2'h1,rx_counter,2'h0}};

  wire [NUM_LANES*64-1:0] phy_data_out;
  wire [NUM_LANES*2-1:0] phy_header_out;
  wire [NUM_LANES*64-1:0] phy_data_in;
  wire [NUM_LANES*2-1:0] phy_header_in;

  reg [NUM_LANES-1:0] phy_block_sync = {NUM_LANES{1'b1}};

  reg [5:0] sysref_counter = 'h00;
  reg sysref_rx = 1'b0;
  reg sysref_tx = 1'b0;

  always @(posedge clk) begin
    if (sysref_counter == 'h2f)
      sysref_rx <= ~sysref_rx;
    sysref_counter <= sysref_counter + 1'b1;
    sysref_tx <= sysref_rx;
  end

  localparam MAX_LANE_DELAY = LANE_DELAY + NUM_LANES;

  reg [10:0] phy_delay_fifo_wr;
  reg [(2+64)*NUM_LANES-1:0] phy_delay_fifo[0:MAX_LANE_DELAY-1];

  always @(posedge clk) begin
    phy_delay_fifo[phy_delay_fifo_wr] <= {phy_header_out,phy_data_out};

    if (reset == 1'b1 || phy_delay_fifo_wr == MAX_LANE_DELAY-1) begin
      phy_delay_fifo_wr <= 'h00;
    end else begin
      phy_delay_fifo_wr <= phy_delay_fifo_wr + 1'b1;
    end
  end

  genvar i;
  generate for (i = 0; i < NUM_LANES; i = i + 1) begin
    localparam OFF = MAX_LANE_DELAY - (i + LANE_DELAY);

    assign phy_data_in[64*i+63:64*i] =
      phy_delay_fifo[(phy_delay_fifo_wr + OFF) % MAX_LANE_DELAY][64*i+63:64*i];

    assign phy_header_in[2*i+1:2*i] =
      phy_delay_fifo[(phy_delay_fifo_wr + OFF) % MAX_LANE_DELAY][2*i+1+NUM_LANES*64 : 2*i+64*NUM_LANES];

  end endgenerate

  wire [NUM_LANES-1:0] tx_cfg_lanes_disable;
  wire [NUM_LINKS-1:0] tx_cfg_links_disable;
  wire [9:0] tx_cfg_octets_per_multiframe;
  wire [7:0] tx_cfg_octets_per_frame;
  wire [7:0] tx_device_cfg_lmfc_offset;
  wire [9:0] tx_device_cfg_octets_per_multiframe;
  wire [7:0] tx_device_cfg_octets_per_frame;
  wire [7:0] tx_device_cfg_beats_per_multiframe;
  wire tx_device_cfg_sysref_disable;
  wire tx_device_cfg_sysref_oneshot;
  wire tx_cfg_continuous_cgs;
  wire tx_cfg_continuous_ilas;
  wire tx_cfg_skip_ilas;
  wire [7:0] tx_cfg_mframes_per_ilas;
  wire tx_cfg_disable_char_replacement;
  wire tx_cfg_disable_scrambler;

  wire tx_ilas_config_rd;
  wire [1:0] tx_ilas_config_addr;
  wire [DATA_PATH_WIDTH*8*NUM_LANES-1:0] tx_ilas_config_data;

  jesd204_tx_static_config #(
    .NUM_LANES(NUM_LANES),
    .NUM_LINKS(NUM_LINKS),
    .OCTETS_PER_FRAME(OCTETS_PER_FRAME),
    .FRAMES_PER_MULTIFRAME(FRAMES_PER_MULTIFRAME),
    .SCR(ENABLE_SCRAMBLER),
    .LINK_MODE(2),
    .DATA_PATH_WIDTH(DATA_PATH_WIDTH),
    .TPL_DATA_PATH_WIDTH(DATA_PATH_WIDTH)
  ) i_tx_cfg (
    .clk(clk),

    .cfg_lanes_disable(tx_cfg_lanes_disable),
    .cfg_links_disable(tx_cfg_links_disable),
    .cfg_octets_per_multiframe(tx_cfg_octets_per_multiframe),
    .cfg_octets_per_frame(tx_cfg_octets_per_frame),
    .cfg_continuous_cgs(tx_cfg_continuous_cgs),
    .cfg_continuous_ilas(tx_cfg_continuous_ilas),
    .cfg_skip_ilas(tx_cfg_skip_ilas),
    .cfg_mframes_per_ilas(tx_cfg_mframes_per_ilas),
    .cfg_disable_char_replacement(tx_cfg_disable_char_replacement),
    .cfg_disable_scrambler(tx_cfg_disable_scrambler),

    .device_cfg_octets_per_multiframe(tx_device_cfg_octets_per_multiframe),
    .device_cfg_octets_per_frame(tx_device_cfg_octets_per_frame),
    .device_cfg_beats_per_multiframe(tx_device_cfg_beats_per_multiframe),
    .device_cfg_lmfc_offset(tx_device_cfg_lmfc_offset),
    .device_cfg_sysref_disable(tx_device_cfg_sysref_disable),
    .device_cfg_sysref_oneshot(tx_device_cfg_sysref_oneshot),

    .ilas_config_rd(tx_ilas_config_rd),
    .ilas_config_addr(tx_ilas_config_addr),
    .ilas_config_data(tx_ilas_config_data));

  jesd204_tx #(
    .NUM_LANES(NUM_LANES),
    .NUM_LINKS(NUM_LINKS),
    .LINK_MODE(2),
    .DATA_PATH_WIDTH(DATA_PATH_WIDTH),
    .TPL_DATA_PATH_WIDTH(DATA_PATH_WIDTH),
    .ASYNC_CLK(0),
    .ENABLE_CHAR_REPLACE(1)
  ) i_tx (
    .clk(clk),
    .reset(reset),

    .device_clk(clk),
    .device_reset(reset),

    .phy_data(phy_data_out),
    .phy_charisk(),
    .phy_header(phy_header_out),

    .sysref(sysref_tx),
    .lmfc_edge(),
    .lmfc_clk(),

    .sync(),

    .tx_data({NUM_LANES{tx_data}}),
    .tx_ready(tx_ready),
    .tx_eof(),
    .tx_sof(),
    .tx_somf(),
    .tx_eomf(),
    .tx_valid(),

    .cfg_lanes_disable(tx_cfg_lanes_disable),
    .cfg_links_disable(tx_cfg_links_disable),
    .cfg_octets_per_multiframe(tx_cfg_octets_per_multiframe),
    .cfg_octets_per_frame(tx_cfg_octets_per_frame),
    .cfg_continuous_cgs(tx_cfg_continuous_cgs),
    .cfg_continuous_ilas(tx_cfg_continuous_ilas),
    .cfg_skip_ilas(tx_cfg_skip_ilas),
    .cfg_mframes_per_ilas(tx_cfg_mframes_per_ilas),
    .cfg_disable_char_replacement(tx_cfg_disable_char_replacement),
    .cfg_disable_scrambler(tx_cfg_disable_scrambler),

    .device_cfg_octets_per_multiframe(tx_device_cfg_octets_per_multiframe),
    .device_cfg_octets_per_frame(tx_device_cfg_octets_per_frame),
    .device_cfg_beats_per_multiframe(tx_device_cfg_beats_per_multiframe),
    .device_cfg_lmfc_offset(tx_device_cfg_lmfc_offset),
    .device_cfg_sysref_disable(tx_device_cfg_sysref_disable),
    .device_cfg_sysref_oneshot(tx_device_cfg_sysref_oneshot),

    .ilas_config_rd(tx_ilas_config_rd),
    .ilas_config_addr(tx_ilas_config_addr),
    .ilas_config_data(tx_ilas_config_data),

    .ctrl_manual_sync_request(1'b0),

    .device_event_sysref_edge(),
    .device_event_sysref_alignment_error(),

    .status_sync(),
    .status_state(),

    .status_synth_params0(),
    .status_synth_params1(),
    .status_synth_params2());

  wire [NUM_LANES-1:0] rx_cfg_lanes_disable;
  wire [NUM_LINKS-1:0] rx_cfg_links_disable;
  wire [9:0] rx_cfg_octets_per_multiframe;
  wire [7:0] rx_cfg_octets_per_frame;
  wire [7:0] rx_device_cfg_lmfc_offset;
  wire [9:0] rx_device_cfg_octets_per_multiframe;
  wire [7:0] rx_device_cfg_octets_per_frame;
  wire [7:0] rx_device_cfg_beats_per_multiframe;
  wire rx_device_cfg_sysref_disable;
  wire rx_device_cfg_sysref_oneshot;
  wire rx_device_cfg_buffer_early_release;
  wire [7:0] rx_device_cfg_buffer_delay;
  wire rx_cfg_disable_scrambler;
  wire rx_cfg_disable_char_replacement;
  wire [NUM_LANES*3-1:0] status_lane_emb_state;
  wire [7:0] rx_cfg_frame_align_err_threshold;

  jesd204_rx_static_config #(
    .NUM_LANES(NUM_LANES),
    .OCTETS_PER_FRAME(OCTETS_PER_FRAME),
    .FRAMES_PER_MULTIFRAME(FRAMES_PER_MULTIFRAME),
    .SCR(ENABLE_SCRAMBLER),
    .BUFFER_EARLY_RELEASE(BUFFER_EARLY_RELEASE),
    .LINK_MODE(2)
  ) i_rx_cfg (
    .clk(clk),

    .cfg_lanes_disable(rx_cfg_lanes_disable),
    .cfg_links_disable(rx_cfg_links_disable),
    .cfg_octets_per_multiframe(rx_cfg_octets_per_multiframe),
    .cfg_octets_per_frame(rx_cfg_octets_per_frame),
    .cfg_disable_scrambler(rx_cfg_disable_scrambler),
    .cfg_disable_char_replacement(rx_cfg_disable_char_replacement),
    .cfg_frame_align_err_threshold(rx_cfg_frame_align_err_threshold),

    .device_cfg_octets_per_multiframe(rx_device_cfg_octets_per_multiframe),
    .device_cfg_octets_per_frame(rx_device_cfg_octets_per_frame),
    .device_cfg_beats_per_multiframe(rx_device_cfg_beats_per_multiframe),
    .device_cfg_lmfc_offset(rx_device_cfg_lmfc_offset),
    .device_cfg_sysref_disable(rx_device_cfg_sysref_disable),
    .device_cfg_sysref_oneshot(rx_device_cfg_sysref_oneshot),
    .device_cfg_buffer_early_release(rx_device_cfg_buffer_early_release),
    .device_cfg_buffer_delay(rx_device_cfg_buffer_delay));

  jesd204_rx #(
    .NUM_LANES(NUM_LANES),
    .LINK_MODE(2),
    .DATA_PATH_WIDTH(DATA_PATH_WIDTH),
    .TPL_DATA_PATH_WIDTH(DATA_PATH_WIDTH),
    .ASYNC_CLK(0)
  ) i_rx (
    .clk(clk),
    .reset(reset),

    .device_clk(clk),
    .device_reset(reset),

    .phy_data(phy_data_in),
    .phy_header(phy_header_in),
    .phy_charisk({NUM_LANES*DATA_PATH_WIDTH{1'b0}}),
    .phy_notintable({NUM_LANES*DATA_PATH_WIDTH{1'b0}}),
    .phy_disperr({NUM_LANES*DATA_PATH_WIDTH{1'b0}}),
    .phy_block_sync(phy_block_sync),

    .sysref(sysref_rx),
    .lmfc_edge(),
    .lmfc_clk(),

    .device_event_sysref_alignment_error(),
    .device_event_sysref_edge(),
    .event_frame_alignment_error(),
    .event_unexpected_lane_state_error(),

    .sync(),

    .phy_en_char_align(),

    .rx_data(rx_data),
    .rx_valid(rx_valid),
    .rx_eof(),
    .rx_sof(),
    .rx_eomf(),
    .rx_somf(),

    .cfg_lanes_disable(rx_cfg_lanes_disable),
    .cfg_links_disable(rx_cfg_links_disable),
    .cfg_octets_per_multiframe(rx_cfg_octets_per_multiframe),
    .cfg_octets_per_frame(rx_cfg_octets_per_frame),
    .cfg_disable_char_replacement(rx_cfg_disable_char_replacement),
    .cfg_disable_scrambler(rx_cfg_disable_scrambler),

    .device_cfg_octets_per_multiframe(rx_device_cfg_octets_per_multiframe),
    .device_cfg_octets_per_frame(rx_device_cfg_octets_per_frame),
    .device_cfg_beats_per_multiframe(rx_device_cfg_beats_per_multiframe),
    .device_cfg_lmfc_offset(rx_device_cfg_lmfc_offset),
    .device_cfg_sysref_disable(rx_device_cfg_sysref_disable),
    .device_cfg_sysref_oneshot(rx_device_cfg_sysref_oneshot),
    .device_cfg_buffer_early_release(rx_device_cfg_buffer_early_release),
    .device_cfg_buffer_delay(rx_device_cfg_buffer_delay),

    .ctrl_err_statistics_reset(1'b0),
    .ctrl_err_statistics_mask(7'b0),

    .cfg_frame_align_err_threshold(rx_cfg_frame_align_err_threshold),

    .status_err_statistics_cnt(),

    .ilas_config_valid(),
    .ilas_config_addr(),
    .ilas_config_data(),

    .status_ctrl_state(),
    .status_lane_cgs_state(),

    .status_lane_ifs_ready(),
    .status_lane_latency(),
    .status_lane_emb_state(status_lane_emb_state),
    .status_lane_frame_align_err_cnt(),

    .status_synth_params0(),
    .status_synth_params1(),
    .status_synth_params2());

  integer ii;
  reg rx_status_mismatch = 1'b0;
  initial begin
    @(posedge rx_valid);
    for (ii=0;ii<NUM_LANES;ii=ii+1) begin
      #5000;
      if (status_lane_emb_state !== {NUM_LANES{3'b100}}) rx_status_mismatch = 1;
      phy_block_sync[ii] = 1'b0;
      #5000;
      phy_block_sync[ii] = 1'b1;
    end
    #5000;
    if (status_lane_emb_state !== {NUM_LANES{3'b100}}) rx_status_mismatch = 1;
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      data_mismatch <= 1'b0;
    end else if (rx_valid_d1 && rx_valid) begin
      if (rx_data !== {NUM_LANES{rx_ref_data}}) begin
        data_mismatch <= 1'b1;
      end
    end
  end

  always @(*) begin
    if (data_mismatch || rx_status_mismatch) begin
      failed <= 1'b1;
    end else begin
      failed <= 1'b0;
    end
  end
endmodule
