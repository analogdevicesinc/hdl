// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2021, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

/*
 * Regardless of the phase relationship between LMFC and sync the output of the
 * ctrl core should be the same as long as the sync signal is in the same lmfc
 * cycle.
 */

`timescale 1ns/100ps

module tx_ctrl_phase_tb;
  parameter VCD_FILE = "tx_ctrl_phase.vcd";
  parameter BEATS_PER_LMFC = 20;

  `include "tb_base.v"

  reg lmfc_edge = 1'b0;
  reg a_sync = 1'b0;
  reg b_sync = 1'b0;

  wire [31:0] a_ilas_data;
  wire [3:0] a_ilas_charisk;
  wire [1:0] a_ilas_config_addr;
  wire a_ilas_config_rd;
  wire a_tx_ready;
  wire a_lane_cgs_enable;

  wire [31:0] b_ilas_data;
  wire [3:0] b_ilas_charisk;
  wire [1:0] b_ilas_config_addr;
  wire b_ilas_config_rd;
  wire b_tx_ready;
  wire b_lane_cgs_enable;

  wire [9:0] cfg_octets_per_multiframe = BEATS_PER_LMFC*4-1;

  reg reset2 = 1'b1;

  integer reset_counter = 0;
  integer beat_counter = 0;
  integer lmfc_counter = 0;
  integer b_offset = 0;

  always @(posedge clk) begin
    if (reset2 == 1'b1) begin
      if (reset_counter == 7) begin
        reset2 <= 1'b0;
        reset_counter <= 0;
      end else begin
        reset_counter <= reset_counter + 1;
      end
    end

    if (reset2 == 1'b1) begin
      beat_counter <= 0;
      a_sync <= 1'b0;
      b_sync <= 1'b0;
    end else begin
      beat_counter <= beat_counter + 1'b1;
      if (beat_counter == BEATS_PER_LMFC*2) begin
        a_sync <= 1'b1;
      end

      if (beat_counter == BEATS_PER_LMFC*2 + b_offset) begin
        b_sync <= 1'b1;
      end

      if (beat_counter == BEATS_PER_LMFC*9) begin
        b_offset <= b_offset + 1;
        reset2 <= 1'b1;
      end
    end

    if (reset2 == 1'b1) begin
      lmfc_counter <= BEATS_PER_LMFC-3;
    end else begin
      lmfc_counter <= lmfc_counter + 1;
      if (lmfc_counter == BEATS_PER_LMFC-1) begin
        lmfc_counter <= 0;
        lmfc_edge <= 1'b1;
      end else begin
        lmfc_edge <= 1'b0;
      end
    end
  end

  jesd204_tx_ctrl i_tx_ctrl_a (
    .clk(clk),
    .reset(reset2),

    .sync(a_sync),
    .lmfc_edge(lmfc_edge),
    .somf(),
    .somf_early2({3'b0,lmfc_edge}),
    .eomf(),

    .lane_cgs_enable(a_lane_cgs_enable),
    .eof_reset(),

    .tx_ready(a_tx_ready),
    .tx_ready_nx(),
    .tx_next_mf_ready(),

    .ilas_data(a_ilas_data),
    .ilas_charisk(a_ilas_charisk),

    .ilas_config_addr(a_ilas_config_addr),
    .ilas_config_rd(a_ilas_config_rd),
    .ilas_config_data('h00),

    .cfg_lanes_disable(1'b0),
    .cfg_links_disable(1'b0),
    .cfg_continuous_cgs(1'b0),
    .cfg_continuous_ilas(1'b0),
    .cfg_skip_ilas(1'b0),
    .cfg_mframes_per_ilas(8'h3),
    .cfg_octets_per_multiframe(cfg_octets_per_multiframe),

    .ctrl_manual_sync_request(1'b0),

    .status_sync(),
    .status_state());

  jesd204_tx_ctrl i_tx_ctrl_b (
    .clk(clk),
    .reset(reset2),

    .sync(b_sync),
    .lmfc_edge(lmfc_edge),
    .somf(),
    .somf_early2({3'b0,lmfc_edge}),
    .eomf(),

    .lane_cgs_enable(b_lane_cgs_enable),
    .eof_reset(),

    .tx_ready(b_tx_ready),
    .tx_ready_nx(),
    .tx_next_mf_ready(),

    .ilas_data(b_ilas_data),
    .ilas_charisk(b_ilas_charisk),

    .ilas_config_addr(b_ilas_config_addr),
    .ilas_config_rd(b_ilas_config_rd),
    .ilas_config_data('h00),

    .cfg_lanes_disable(1'b0),
    .cfg_links_disable(1'b0),
    .cfg_continuous_cgs(1'b0),
    .cfg_continuous_ilas(1'b0),
    .cfg_skip_ilas(1'b0),
    .cfg_mframes_per_ilas(8'h3),
    .cfg_octets_per_multiframe(cfg_octets_per_multiframe),

    .ctrl_manual_sync_request(1'b0),

    .status_sync(),
    .status_state());

  reg status = 1'b1;

  always @(*) begin
    if (reset2 == 1'b1) begin
      status <= 1'b1;
    end else if (a_ilas_data != b_ilas_data ||
      a_ilas_charisk != b_ilas_charisk ||
      a_ilas_config_addr != b_ilas_config_addr ||
      a_ilas_config_rd != b_ilas_config_rd ||
      a_lane_cgs_enable != b_lane_cgs_enable ||
      a_tx_ready != b_tx_ready) begin
      status <= 1'b0;
    end
  end

  reg message_shown = 1'b0;

  always @(posedge clk) begin
    if (status == 1'b0 && message_shown == 1'b0 && b_offset < BEATS_PER_LMFC) begin
      $display("FAILED at offset %0d", b_offset);
      message_shown <= 1'b1;
    end
  end

  always @(posedge clk) begin
    if (b_offset == BEATS_PER_LMFC+1) begin
      if (message_shown == 1'b0)
        $display("SUCCESS");
      $finish;
    end
  end

endmodule
