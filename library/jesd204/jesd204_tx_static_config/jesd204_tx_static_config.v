// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020-2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_tx_static_config #(
  parameter NUM_LANES = 1,
  parameter NUM_LINKS = 1,
  parameter OCTETS_PER_FRAME = 1,
  parameter FRAMES_PER_MULTIFRAME = 32,
  parameter NUM_CONVERTERS = 1,
  parameter N = 16,
  parameter NP = 16,
  parameter HIGH_DENSITY = 1,
  parameter SCR = 1,
  parameter LINK_MODE = 1,  // 2 - 64B/66B;  1 - 8B/10B
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
  output cfg_continuous_cgs,
  output cfg_continuous_ilas,
  output cfg_skip_ilas,
  output [7:0] cfg_mframes_per_ilas,
  output cfg_disable_char_replacement,
  output cfg_disable_scrambler,

  output [9:0] device_cfg_octets_per_multiframe,
  output [7:0] device_cfg_octets_per_frame,
  output [7:0] device_cfg_beats_per_multiframe,
  output [7:0] device_cfg_lmfc_offset,
  output device_cfg_sysref_oneshot,
  output device_cfg_sysref_disable,

  input ilas_config_rd,
  input [1:0] ilas_config_addr,
  output [NUM_LANES*DATA_PATH_WIDTH*8-1:0] ilas_config_data
);

  assign cfg_lanes_disable = {NUM_LANES{1'b0}};
  assign cfg_links_disable = {NUM_LINKS{1'b0}};
  assign cfg_octets_per_multiframe = (FRAMES_PER_MULTIFRAME * OCTETS_PER_FRAME) - 1;
  assign cfg_octets_per_frame = OCTETS_PER_FRAME - 1;
  assign cfg_continuous_cgs = 1'b0;
  assign cfg_continuous_ilas = 1'b0;
  assign cfg_skip_ilas = 1'b0;
  assign cfg_mframes_per_ilas = 3;
  assign cfg_disable_char_replacement = 1'b0;
  assign cfg_disable_scrambler = SCR ? 1'b0 : 1'b1;

  assign device_cfg_octets_per_multiframe = (FRAMES_PER_MULTIFRAME * OCTETS_PER_FRAME) - 1;
  assign device_cfg_octets_per_frame = OCTETS_PER_FRAME - 1;
  assign device_cfg_beats_per_multiframe = ((FRAMES_PER_MULTIFRAME * OCTETS_PER_FRAME) /
                                            TPL_DATA_PATH_WIDTH) - 1;
  assign device_cfg_lmfc_offset = 1;
  assign device_cfg_sysref_oneshot = SYSREF_ONE_SHOT;
  assign device_cfg_sysref_disable = SYSREF_DISABLE;

  jesd204_ilas_cfg_static #(
    .DID(8'h00),
    .BID(5'h00),
    .L(NUM_LANES - 1),
    .SCR(SCR),
    .F(OCTETS_PER_FRAME - 1),
    .K(FRAMES_PER_MULTIFRAME - 1),
    .M(NUM_CONVERTERS - 1),
    .N(N),
    .NP(NP),
    .SUBCLASSV(3'h1),
    .S(5'h00),
    .JESDV(3'h1),
    .CF(5'h00),
    .HD(HIGH_DENSITY),
    .NUM_LANES(NUM_LANES),
    .DATA_PATH_WIDTH(DATA_PATH_WIDTH)
  ) i_ilas_config (
    .clk(clk),
    .ilas_config_addr(ilas_config_addr),
    .ilas_config_rd(ilas_config_rd),
    .ilas_config_data(ilas_config_data));

endmodule
