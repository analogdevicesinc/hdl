// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2021, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module rx_tb;
  parameter VCD_FILE = "rx_tb.vcd";
  parameter NUM_LANES = 1;
  parameter NUM_LINKS = 1;
  parameter OCTETS_PER_FRAME = 8;
  parameter FRAMES_PER_MULTIFRAME = 32;

  `include "tb_base.v"

  integer phy_reset_counter = 'h00;
  integer align_counter = 'h00;

  reg phy_ready = 1'b0;
  reg aligned = 1'b0;

  wire en_align;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      phy_reset_counter <= 'h00;
      phy_ready <= 1'b0;
    end else begin
      if (phy_reset_counter == 'h40) begin
        phy_ready <= 1'b1;
      end else begin
        phy_reset_counter <= phy_reset_counter + 1'b1;
      end
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      aligned <= 1'b0;
      align_counter <= 'h00;
    end else if (phy_ready == 1'b1) begin
      if (en_align == 1'b1) begin
        if (align_counter == 'h20) begin
          aligned <= 1'b1;
        end else begin
          align_counter <= align_counter + 1;
        end
      end
    end
  end

  localparam KCHAR_ILAS_START = {3'd0,5'd28};
  localparam KCHAR_LANE_ALIGN = {3'd3,5'd28};
  localparam KCHAR_ILAS_CONFIG = {3'd4,5'd28};
  localparam KCHAR_CGS = {3'd5,5'd28};
  localparam KCHAR_FRAME_ALIGN = {3'd7,5'd28};

  reg [31:0] data = KCHAR_CGS;
  reg [3:0] charisk = 4'b1111;
  reg [3:0] disperr = 4'b0000;
  reg [3:0] notintable = 4'b0000;
  wire [NUM_LINKS-1:0] sync;

  integer counter = 'h00;
  wire [31:0] counter2 = (counter - 'h10) * 4;

  always @(posedge clk) begin
    if ( &sync == 1'b0 ) begin
      counter <= 'h00;
      charisk <= 4'b1111;
      data <= {KCHAR_CGS,KCHAR_CGS,KCHAR_CGS,KCHAR_CGS};
    end else begin
      counter <= counter + 1;
      if (counter >= 'h8 && counter < 'h28) begin
        if (counter % 'h8 == 'h0) begin
          if (counter != 'h10) begin
            data <= {24'h00,KCHAR_ILAS_START};
            charisk <= 4'b0001;
          end else begin
            data <= {16'hffaa,KCHAR_ILAS_CONFIG,KCHAR_ILAS_START};
            charisk <= 4'b0011;
          end
        end else if (counter % 'h8 == 'h7) begin
          data <= {KCHAR_LANE_ALIGN,24'h00};
          charisk <= 4'b1000;
        end else begin
          data <= {32'h00};
          charisk <= 4'b0000;
        end
      end else if (counter > 'h10) begin
        data <= (counter2 + 'h2) << 24 |
            (counter2 + 'h1) << 16 |
            (counter2 + 'h0) << 8 |
            (counter2 - 'h1);
        charisk <= 4'b0000;
      end
    end
  end

  wire [NUM_LANES-1:0] cfg_lanes_disable;
  wire [NUM_LINKS-1:0] cfg_links_disable;
  wire [9:0] cfg_octets_per_multiframe;
  wire [7:0] cfg_octets_per_frame;
  wire [7:0] device_cfg_lmfc_offset;
  wire [9:0] device_cfg_octets_per_multiframe;
  wire [7:0] device_cfg_octets_per_frame;
  wire [7:0] device_cfg_beats_per_multiframe;
  wire device_cfg_sysref_disable;
  wire device_cfg_sysref_oneshot;
  wire device_cfg_buffer_early_release;
  wire [7:0] device_cfg_buffer_delay;
  wire cfg_disable_scrambler;
  wire cfg_disable_char_replacement;
  wire [7:0] cfg_frame_align_err_threshold;

  always @(posedge clk) begin
    if ($urandom % 400 == 0)
      disperr <= 4'b1111;
    else if ($urandom % 400 == 1)
      disperr <= 4'b0001;
    else if ($urandom % 400 == 2)
      disperr <= 4'b0011;
    else if ($urandom % 400 == 3)
      disperr <= 4'b0111;
    else
      disperr <= 4'b0000;
  end
  wire [NUM_LANES*32-1:0] status_err_statistics_cnt;

  jesd204_rx_static_config #(
    .NUM_LANES(NUM_LANES),
    .NUM_LINKS(NUM_LINKS),
    .OCTETS_PER_FRAME(OCTETS_PER_FRAME),
    .FRAMES_PER_MULTIFRAME(FRAMES_PER_MULTIFRAME)
  ) i_cfg (
    .clk(clk),

    .cfg_lanes_disable(cfg_lanes_disable),
    .cfg_links_disable(cfg_links_disable),
    .cfg_octets_per_multiframe(cfg_octets_per_multiframe),
    .cfg_octets_per_frame(cfg_octets_per_frame),
    .cfg_disable_scrambler(cfg_disable_scrambler),
    .cfg_disable_char_replacement(cfg_disable_char_replacement),
    .cfg_frame_align_err_threshold(cfg_frame_align_err_threshold),

    .device_cfg_octets_per_multiframe(device_cfg_octets_per_multiframe),
    .device_cfg_octets_per_frame(device_cfg_octets_per_frame),
    .device_cfg_beats_per_multiframe(device_cfg_beats_per_multiframe),
    .device_cfg_lmfc_offset(device_cfg_lmfc_offset),
    .device_cfg_sysref_disable(device_cfg_sysref_disable),
    .device_cfg_sysref_oneshot(device_cfg_sysref_oneshot),
    .device_cfg_buffer_early_release(device_cfg_buffer_early_release),
    .device_cfg_buffer_delay(device_cfg_buffer_delay));

  jesd204_rx #(
    .NUM_LANES(NUM_LANES),
    .NUM_LINKS(NUM_LINKS)
  ) i_rx (
    .clk(clk),
    .reset(reset),

    .device_clk(clk),
    .device_reset(reset),

    .phy_data({NUM_LANES{data}}),
    .phy_header({2*NUM_LANES{1'b0}}),
    .phy_charisk({NUM_LANES{charisk}}),
    .phy_notintable({NUM_LANES{notintable}}),
    .phy_disperr({NUM_LANES{disperr}}),
    .phy_block_sync({NUM_LANES{1'b0}}),

    .sysref(sysref),
    .lmfc_edge(),
    .lmfc_clk(),

    .device_event_sysref_alignment_error(),
    .device_event_sysref_edge(),
    .event_frame_alignment_error(),
    .event_unexpected_lane_state_error(),

    .sync(sync),

    .phy_en_char_align(en_align),

    .rx_data(),
    .rx_valid(),
    .rx_eof(),
    .rx_sof(),
    .rx_eomf(),
    .rx_somf(),

    .cfg_lanes_disable(cfg_lanes_disable),
    .cfg_links_disable(cfg_links_disable),
    .cfg_octets_per_multiframe(cfg_octets_per_multiframe),
    .cfg_octets_per_frame(cfg_octets_per_frame),
    .cfg_disable_char_replacement(cfg_disable_char_replacement),
    .cfg_disable_scrambler(cfg_disable_scrambler),

    .device_cfg_octets_per_multiframe(device_cfg_octets_per_multiframe),
    .device_cfg_octets_per_frame(device_cfg_octets_per_frame),
    .device_cfg_beats_per_multiframe(device_cfg_beats_per_multiframe),
    .device_cfg_lmfc_offset(device_cfg_lmfc_offset),
    .device_cfg_sysref_disable(device_cfg_sysref_disable),
    .device_cfg_sysref_oneshot(device_cfg_sysref_oneshot),
    .device_cfg_buffer_early_release(device_cfg_buffer_early_release),
    .device_cfg_buffer_delay(device_cfg_buffer_delay),

    .ctrl_err_statistics_reset(1'b0),
    .ctrl_err_statistics_mask(7'h7),

    .cfg_frame_align_err_threshold(cfg_frame_align_err_threshold),

    .status_err_statistics_cnt(status_err_statistics_cnt),

    .ilas_config_valid(),
    .ilas_config_addr(),
    .ilas_config_data(),

    .status_ctrl_state(),
    .status_lane_cgs_state(),

    .status_lane_ifs_ready(),
    .status_lane_latency(),
    .status_lane_emb_state(),
    .status_lane_frame_align_err_cnt(),

    .status_synth_params0(),
    .status_synth_params1(),
    .status_synth_params2());

endmodule
