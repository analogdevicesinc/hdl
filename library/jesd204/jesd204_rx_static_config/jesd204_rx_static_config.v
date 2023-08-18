// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020-2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_rx_static_config #(
  parameter NUM_LANES = 1,
  parameter NUM_LINKS = 1,
  parameter OCTETS_PER_FRAME = 1,
  parameter FRAMES_PER_MULTIFRAME = 32,
  parameter SCR = 1,
  parameter BUFFER_EARLY_RELEASE = 0,
  parameter LINK_MODE = 1, // 2 - 64B/66B;  1 - 8B/10B
  parameter SYSREF_DISABLE = 0,
  parameter SYSREF_ONE_SHOT = 0,
  /* Only 4, 8 are supported at the moment for 8b/10b and 8 for 64b */
  parameter DATA_PATH_WIDTH = LINK_MODE == 2 ? 8 : 4,
  parameter TPL_DATA_PATH_WIDTH = LINK_MODE == 2 ? 8 : 4
) (
  input clk,

  output [NUM_LANES-1:0] cfg_lanes_disable,
  output [NUM_LINKS-1:0] cfg_links_disable,
  output [9:0] cfg_octets_per_multiframe,
  output [7:0] cfg_octets_per_frame,
  output cfg_disable_scrambler,
  output cfg_disable_char_replacement,
  output [7:0] cfg_frame_align_err_threshold,

  output [9:0] device_cfg_octets_per_multiframe,
  output [7:0] device_cfg_octets_per_frame,
  output [7:0] device_cfg_beats_per_multiframe,
  output [7:0] device_cfg_lmfc_offset,
  output device_cfg_sysref_oneshot,
  output device_cfg_sysref_disable,
  output device_cfg_buffer_early_release,
  output [7:0] device_cfg_buffer_delay
);

  assign cfg_octets_per_multiframe = (FRAMES_PER_MULTIFRAME * OCTETS_PER_FRAME) - 1;
  assign cfg_octets_per_frame = OCTETS_PER_FRAME - 1;
  assign device_cfg_octets_per_multiframe = (FRAMES_PER_MULTIFRAME * OCTETS_PER_FRAME) - 1;
  assign device_cfg_octets_per_frame = OCTETS_PER_FRAME - 1;
  assign device_cfg_beats_per_multiframe = ((FRAMES_PER_MULTIFRAME * OCTETS_PER_FRAME) /
                                            TPL_DATA_PATH_WIDTH) - 1;
  assign device_cfg_lmfc_offset = 1;
  assign device_cfg_sysref_oneshot = SYSREF_ONE_SHOT;
  assign device_cfg_sysref_disable = SYSREF_DISABLE;
  assign device_cfg_buffer_delay = 'h0;
  assign device_cfg_buffer_early_release = BUFFER_EARLY_RELEASE;
  assign cfg_lanes_disable = {NUM_LANES{1'b0}};
  assign cfg_links_disable = {NUM_LINKS{1'b0}};
  assign cfg_disable_scrambler = SCR ? 1'b0 : 1'b1;
  assign cfg_disable_char_replacement = 1'b0;
  assign cfg_frame_align_err_threshold = 8'd4;

endmodule
