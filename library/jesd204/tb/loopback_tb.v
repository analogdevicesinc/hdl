// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module loopback_tb;
  parameter VCD_FILE = "loopback_tb.vcd";
  parameter NUM_LANES = 4;
  parameter NUM_LINKS = 1;
  parameter OCTETS_PER_FRAME = 1;
  parameter FRAMES_PER_MULTIFRAME = 28;
  parameter NUM_CONVERTERS = 1;
  parameter N = 16;
  parameter NP = 16;
  parameter HIGH_DENSITY = 1'b0;
  parameter ENABLE_SCRAMBLER = 1;
  parameter BUFFER_EARLY_RELEASE = 1;
  parameter SYSREF_DISABLE = 0;
  parameter SYSREF_ONE_SHOT = 0;
  parameter LANE_DELAY = 1;
  parameter DATA_PATH_WIDTH = 4;
  parameter DATA_RANDOM = ENABLE_SCRAMBLER ? 0 : 1;

  localparam DPW_LOG2 = DATA_PATH_WIDTH == 8 ? 3 : DATA_PATH_WIDTH == 4 ? 2 : 1;
  localparam BEATS_PER_MULTIFRAME = OCTETS_PER_FRAME * FRAMES_PER_MULTIFRAME / 4;
  localparam TX_LATENCY = 4 + i_tx.NUM_OUTPUT_PIPELINE;
  wire [31:0] RX_LATENCY = 3 + i_rx.CHAR_INFO_REGISTERED + i_rx.ALIGN_MUX_REGISTERED + i_rx.SCRAMBLER_REGISTERED;
  wire [31:0] BASE_LATENCY = TX_LATENCY + RX_LATENCY;
  localparam SYSREF_HALF_COUNT = OCTETS_PER_FRAME * FRAMES_PER_MULTIFRAME;

  `define TIMEOUT 1000000
  `include "tb_base.v"

  reg [5:0] tx_counter = 'h00;
  reg [5:0] rx_counter = 'h00;
  reg [NUM_LANES*DATA_PATH_WIDTH*8-1:0] rx_mask = 64'hffffffffffff0000;
  wire tx_ready;
  wire rx_valid;
  wire [NUM_LANES*DATA_PATH_WIDTH*8-1:0] rx_data;
  wire [DATA_PATH_WIDTH-1:0] rx_eof;
  wire [DATA_PATH_WIDTH-1:0] rx_sof;
  reg data_mismatch = 1'b1;
  wire [NUM_LINKS-1:0] sync;

  always @(posedge clk) begin
    if (sync == 1'b0) begin
      tx_counter <= 'h00000000;
    end else if (tx_ready == 1'b1) begin
      tx_counter <= tx_counter + 1'b1;
    end
  end

  always @(posedge clk) begin
    if (sync == 1'b0) begin
      rx_counter <= 'h00000000;
      if (ENABLE_SCRAMBLER == 1'b1) begin
        rx_mask <= {NUM_LANES{64'hffffffffffff0000}}; // First two octets are invalid due to scrambling
      end else begin
        rx_mask <= {NUM_LANES{64'hffffffffffffffff}};
      end
    end else if (rx_valid == 1'b1) begin
      rx_counter <= rx_counter + 1'b1;
      rx_mask <= {NUM_LANES{64'hffffffffffffffff}};
    end
  end

  reg  [(DATA_PATH_WIDTH*8)-1:0] tx_random_data;
  wire [(DATA_PATH_WIDTH*8)-1:0] tx_data;
  wire [(DATA_PATH_WIDTH*8)-1:0] rx_ref_data;

  genvar ii;
  generate
  for(ii = 0; ii < DATA_PATH_WIDTH; ii=ii+1) begin : data_gen
    wire [1:0] ii_sig = ii;

    always @(posedge clk) begin
      tx_random_data[ii*8+:8] <= $urandom();
    end

    assign tx_data[ii*8+:8] = DATA_RANDOM ? tx_random_data[ii*8+:8] : {tx_counter, ii_sig};
    assign rx_ref_data[ii*8+:8] = {rx_counter, ii_sig};
  end
  endgenerate

  wire [NUM_LANES*DATA_PATH_WIDTH*8-1:0] phy_data_out;
  wire [NUM_LANES*DATA_PATH_WIDTH-1:0] phy_charisk_out;
  wire [NUM_LANES*DATA_PATH_WIDTH*8-1:0] phy_data_in;
  wire [NUM_LANES*DATA_PATH_WIDTH-1:0] phy_charisk_in;

  reg [9:0] sysref_counter = 'h00;
  reg sysref_rx = 1'b0;
  reg sysref_tx = 1'b0;

  always @(posedge clk) begin
    if (sysref_counter == (SYSREF_HALF_COUNT-1)) begin
      sysref_rx <= ~sysref_rx;
      sysref_counter <= 'b0;
    end else begin
      sysref_counter <= sysref_counter + 1'b1;
    end
    sysref_tx <= sysref_rx;
  end

  localparam MAX_LANE_DELAY = LANE_DELAY + NUM_LANES;

  reg [10:0] phy_delay_fifo_wr;
  reg [DATA_PATH_WIDTH*9*NUM_LANES-1:0] phy_delay_fifo[0:MAX_LANE_DELAY-1];

  always @(posedge clk) begin
    phy_delay_fifo[phy_delay_fifo_wr] <= {phy_charisk_out,phy_data_out};

    if (reset == 1'b1 || phy_delay_fifo_wr == MAX_LANE_DELAY-1) begin
      phy_delay_fifo_wr <= 'h00;
    end else begin
      phy_delay_fifo_wr <= phy_delay_fifo_wr + 1'b1;
    end
  end

  genvar i;
  generate for (i = 0; i < NUM_LANES; i = i + 1) begin
    localparam OFF = MAX_LANE_DELAY - (i + LANE_DELAY);
    assign phy_data_in[DATA_PATH_WIDTH*8*i+(DATA_PATH_WIDTH*8)-1:DATA_PATH_WIDTH*8*i] =
      phy_delay_fifo[(phy_delay_fifo_wr + OFF) % MAX_LANE_DELAY][DATA_PATH_WIDTH*8*i+(DATA_PATH_WIDTH*8)-1:DATA_PATH_WIDTH*8*i];
    assign phy_charisk_in[DATA_PATH_WIDTH*i+DATA_PATH_WIDTH-1:DATA_PATH_WIDTH*i] =
      phy_delay_fifo[(phy_delay_fifo_wr + OFF) % MAX_LANE_DELAY][DATA_PATH_WIDTH*i+DATA_PATH_WIDTH-1+NUM_LANES*DATA_PATH_WIDTH*8:DATA_PATH_WIDTH*i+DATA_PATH_WIDTH*8*NUM_LANES];
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
  wire tx_lmfc_edge;
  wire tx_lmfc_clk;
  wire [DATA_PATH_WIDTH-1:0] tx_eof;
  wire [DATA_PATH_WIDTH-1:0] tx_sof;

  wire tx_ilas_config_rd;
  wire [1:0] tx_ilas_config_addr;
  wire [DATA_PATH_WIDTH*8*NUM_LANES-1:0] tx_ilas_config_data;
  wire tx_event_sysref_edge;
  wire tx_event_sysref_alignment_error;
  wire [NUM_LINKS-1:0] tx_status_sync;
  wire [1:0] tx_status_state;

  jesd204_tx_static_config #(
    .NUM_LANES(NUM_LANES),
    .NUM_LINKS(NUM_LINKS),
    .OCTETS_PER_FRAME(OCTETS_PER_FRAME),
    .FRAMES_PER_MULTIFRAME(FRAMES_PER_MULTIFRAME),
    .NUM_CONVERTERS(NUM_CONVERTERS),
    .N(N),
    .NP(NP),
    .HIGH_DENSITY(HIGH_DENSITY),
    .SCR(ENABLE_SCRAMBLER),
    .LINK_MODE(1),
    .SYSREF_DISABLE(SYSREF_DISABLE),
    .SYSREF_ONE_SHOT(SYSREF_ONE_SHOT),
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
    .NUM_OUTPUT_PIPELINE(0),
    .LINK_MODE(1),
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
    .phy_charisk(phy_charisk_out),
    .phy_header(),

    .sysref(sysref_tx),
    .lmfc_edge(tx_lmfc_edge),
    .lmfc_clk(tx_lmfc_clk),

    .sync(sync),

    .tx_data({NUM_LANES{tx_data}}),
    .tx_ready(tx_ready),
    .tx_eof(tx_eof),
    .tx_sof(tx_sof),
    .tx_somf(),
    .tx_eomf(),
    .tx_valid(1'b1),

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

    .device_event_sysref_edge (tx_event_sysref_edge),
    .device_event_sysref_alignment_error (tx_event_sysref_alignment_error),

    .status_sync (tx_status_sync),
    .status_state (tx_status_state),

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
  wire [NUM_LANES-1:0] rx_status_lane_ifs_ready;
  wire [NUM_LANES*14-1:0] rx_status_lane_latency;
  wire [NUM_LANES*8-1:0] rx_status_lane_frame_align_err_cnt;
  wire [7:0] rx_cfg_frame_align_err_threshold;
  wire [32*NUM_LANES-1:0] rx_status_err_statistics_cnt;
  wire rx_lmfc_edge;
  wire rx_lmfc_clk;
  wire rx_event_sysref_alignment_error;
  wire rx_event_sysref_edge;
  wire [NUM_LANES-1:0] rx_ilas_config_valid;
  wire [NUM_LANES*2-1:0] rx_ilas_config_addr;
  wire [NUM_LANES*DATA_PATH_WIDTH*8-1:0] rx_ilas_config_data;
  wire [1:0] rx_status_ctrl_state;
  wire [2*NUM_LANES-1:0] rx_status_lane_cgs_state;
  wire rx_phy_en_char_align;

  jesd204_rx_static_config #(
    .NUM_LANES(NUM_LANES),
    .NUM_LINKS(NUM_LINKS),
    .OCTETS_PER_FRAME(OCTETS_PER_FRAME),
    .FRAMES_PER_MULTIFRAME(FRAMES_PER_MULTIFRAME),
    .SCR(ENABLE_SCRAMBLER),
    .BUFFER_EARLY_RELEASE(BUFFER_EARLY_RELEASE),
    .LINK_MODE(1),
    .SYSREF_DISABLE(SYSREF_DISABLE),
    .SYSREF_ONE_SHOT(SYSREF_ONE_SHOT),
    .DATA_PATH_WIDTH(DATA_PATH_WIDTH),
    .TPL_DATA_PATH_WIDTH(DATA_PATH_WIDTH)
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
    .NUM_LINKS(NUM_LINKS),
    .NUM_INPUT_PIPELINE(1),
    .LINK_MODE(1),
    .DATA_PATH_WIDTH(DATA_PATH_WIDTH),
    .ENABLE_FRAME_ALIGN_CHECK(1),
    .ENABLE_FRAME_ALIGN_ERR_RESET(1),
    .TPL_DATA_PATH_WIDTH(DATA_PATH_WIDTH),
    .ASYNC_CLK(0),
    .ENABLE_CHAR_REPLACE(1)
  ) i_rx (
    .clk(clk),
    .reset(reset),

    .device_clk(clk),
    .device_reset(reset),

    .phy_data(phy_data_in),
    .phy_header({2*NUM_LANES{1'b0}}),
    .phy_charisk(phy_charisk_in),
    .phy_notintable({NUM_LANES*DATA_PATH_WIDTH{1'b0}}),
    .phy_disperr({NUM_LANES*DATA_PATH_WIDTH{1'b0}}),
    .phy_block_sync({NUM_LANES{1'b0}}),

    .sysref(sysref_rx),
    .lmfc_edge(rx_lmfc_edge),
    .lmfc_clk(rx_lmfc_clk),

    .device_event_sysref_alignment_error(rx_event_sysref_alignment_error),
    .device_event_sysref_edge(rx_event_sysref_edge),
    .event_frame_alignment_error(),
    .event_unexpected_lane_state_error(),

    .sync(sync),

    .phy_en_char_align(rx_phy_en_char_align),

    .rx_data(rx_data),
    .rx_valid(rx_valid),
    .rx_eof(rx_eof),
    .rx_sof(rx_sof),
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

    .status_err_statistics_cnt(rx_status_err_statistics_cnt),

    .ilas_config_valid(rx_ilas_config_valid),
    .ilas_config_addr(rx_ilas_config_addr),
    .ilas_config_data(rx_ilas_config_data),

    .status_ctrl_state(rx_status_ctrl_state),
    .status_lane_cgs_state(rx_status_lane_cgs_state),

    .status_lane_ifs_ready(rx_status_lane_ifs_ready),
    .status_lane_latency(rx_status_lane_latency),
    .status_lane_emb_state(),
    .status_lane_frame_align_err_cnt(rx_status_lane_frame_align_err_cnt),

    .status_synth_params0(),
    .status_synth_params1(),
    .status_synth_params2());

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      data_mismatch <= 1'b0;
    end else if (rx_valid == 1'b1) begin
      if ((rx_data & rx_mask) !== ({NUM_LANES{rx_ref_data}} & rx_mask)) begin
        data_mismatch <= 1'b1;
      end
    end
  end

  reg [NUM_LANES-1:0] lane_latency_match;

  generate for (i = 0; i < NUM_LANES; i = i + 1) begin
    wire [31:0] LANE_OFFSET = BASE_LATENCY + LANE_DELAY + BEATS_PER_MULTIFRAME + i;

    always @(posedge clk) begin
      if (rx_status_lane_ifs_ready[i] == 1'b1 &&
          rx_status_lane_latency[i*14+13:i*14+DPW_LOG2] == LANE_OFFSET) begin
        lane_latency_match[i] <= 1'b1;
      end else begin
        lane_latency_match[i] <= 1'b0;
      end
    end
  end endgenerate

  always @(*) begin
    if (rx_valid !== 1'b1 || tx_ready !== 1'b1 || data_mismatch == 1'b1 ||
        &lane_latency_match != 1'b1) begin
      failed <= 1'b1;
    end else begin
      failed <= 1'b0;
    end
  end
endmodule
