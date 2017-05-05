// ***************************************************************************
// ***************************************************************************
// Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
//
// Each core or library found in this collection may have its own licensing terms.
// The user should keep this in in mind while exploring these cores.
//
// Redistribution and use in source and binary forms,
// with or without modification of this file, are permitted under the terms of either
//  (at the option of the user):
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory, or at:
// https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
//
// OR
//
//   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
// https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad_ip_jesd204_tpl_dac_core #(
  parameter DATAPATH_DISABLE = 0,
  parameter NUM_LANES = 1,
  parameter NUM_CHANNELS = 1,
  parameter DATA_PATH_WIDTH = 4
) (
  // dac interface
  input clk,

  output link_valid,
  input link_ready,
  output [NUM_LANES*32-1:0] link_data,

  // dma interface
  output [NUM_CHANNELS-1:0] dac_valid,
  input [NUM_LANES*32-1:0] dac_ddata,

  // Configuration interface

  input dac_sync,
  input dac_dds_format,

  input [NUM_CHANNELS*4-1:0] dac_data_sel,

  input [NUM_CHANNELS*16-1:0] dac_dds_scale_0,
  input [NUM_CHANNELS*16-1:0] dac_dds_init_0,
  input [NUM_CHANNELS*16-1:0] dac_dds_incr_0,
  input [NUM_CHANNELS*16-1:0] dac_dds_scale_1,
  input [NUM_CHANNELS*16-1:0] dac_dds_init_1,
  input [NUM_CHANNELS*16-1:0] dac_dds_incr_1,

  input [NUM_CHANNELS*16-1:0] dac_pat_data_0,
  input [NUM_CHANNELS*16-1:0] dac_pat_data_1,

  output [NUM_CHANNELS-1:0] enable
);

  assign link_valid = 1'b1;

  wire [NUM_LANES*32-1:0] dac_data_s;

  // device interface

  ad_ip_jesd204_tpl_dac_framer #(
    .NUM_LANES (NUM_LANES),
    .NUM_CHANNELS (NUM_CHANNELS)
  ) i_framer (
    .clk (clk),
    .link_data (link_data),
    .dac_data (dac_data_s)
  );

  // dac valid

  assign dac_valid = {NUM_CHANNELS{1'b1}};

  localparam CDW = DATA_PATH_WIDTH * 16;

  generate
  genvar i;
  for (i = 0; i < NUM_CHANNELS; i = i + 1) begin: g_channel
    ad_ip_jesd204_tpl_dac_channel #(
      .DATA_PATH_WIDTH (DATA_PATH_WIDTH),
      .DATAPATH_DISABLE (DATAPATH_DISABLE)
    ) i_channel (
      .clk (clk),
      .dac_enable (enable[i]),
      .dac_data (dac_data_s[CDW*i+:CDW]),
      .dma_data (dac_ddata[CDW*i+:CDW]),

      .dac_data_sync (dac_sync),
      .dac_dds_format (dac_dds_format),

      .dac_data_sel (dac_data_sel[4*i+:4]),

      .dac_dds_scale_0 (dac_dds_scale_0[16*i+:16]),
      .dac_dds_init_0 (dac_dds_init_0[16*i+:16]),
      .dac_dds_incr_0 (dac_dds_incr_0[16*i+:16]),
      .dac_dds_scale_1 (dac_dds_scale_1[16*i+:16]),
      .dac_dds_init_1 (dac_dds_init_1[16*i+:16]),
      .dac_dds_incr_1 (dac_dds_incr_1[16*i+:16]),

      .dac_pat_data_0 (dac_pat_data_0[16*i+:16]),
      .dac_pat_data_1 (dac_pat_data_1[16*i+:16])
    );
  end
  endgenerate

endmodule
