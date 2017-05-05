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

module ad_ip_jesd204_tpl_adc_core #(
  parameter NUM_CHANNELS = 1,
  parameter CHANNEL_WIDTH = 14,
  parameter NUM_LANES = 1,
  parameter TWOS_COMPLEMENT = 1,
  parameter DATA_PATH_WIDTH = 1
) (
  input clk,

  input [NUM_CHANNELS-1:0] dfmt_enable,
  input [NUM_CHANNELS-1:0] dfmt_sign_extend,
  input [NUM_CHANNELS-1:0] dfmt_type,

  input [NUM_CHANNELS*4-1:0] pn_seq_sel,
  output [NUM_CHANNELS-1:0] pn_err,
  output [NUM_CHANNELS-1:0] pn_oos,

  output [NUM_CHANNELS-1:0] adc_valid,
  output [NUM_LANES*32-1:0] adc_data,

  input link_valid,
  output link_ready,
  input [3:0] link_sof,
  input [NUM_LANES*32-1:0] link_data
);
  // Raw and formated channel data widths
  localparam CDW_RAW = CHANNEL_WIDTH * DATA_PATH_WIDTH;
  localparam CDW_FMT = 16 * DATA_PATH_WIDTH;

  wire [NUM_CHANNELS*CHANNEL_WIDTH*DATA_PATH_WIDTH-1:0] raw_data_s;

  assign link_ready = 1'b1;
  assign adc_valid = {NUM_CHANNELS{1'b1}};

  ad_ip_jesd204_tpl_adc_deframer #(
    .NUM_LANES (NUM_LANES),
    .NUM_CHANNELS (NUM_CHANNELS),
    .CHANNEL_WIDTH (CHANNEL_WIDTH)
  ) i_deframer (
    .clk (clk),
    .link_sof (link_sof),
    .link_data (link_data),
    .adc_data (raw_data_s)
  );

  generate
  genvar i;
  for (i = 0; i < NUM_CHANNELS; i = i + 1) begin: g_channel
    ad_ip_jesd204_tpl_adc_channel #(
      .CHANNEL_WIDTH (CHANNEL_WIDTH),
      .DATA_PATH_WIDTH (DATA_PATH_WIDTH),
      .TWOS_COMPLEMENT (TWOS_COMPLEMENT)
    ) i_channel (
      .clk (clk),

      .raw_data (raw_data_s[CDW_RAW*i+:CDW_RAW]),
      .fmt_data (adc_data[CDW_FMT*i+:CDW_FMT]),

      .dfmt_enable (dfmt_enable[i]),
      .dfmt_sign_extend (dfmt_sign_extend[i]),
      .dfmt_type (dfmt_type[i]),

      .pn_seq_sel (pn_seq_sel[i*4+:4]),
      .pn_err (pn_err[i]),
      .pn_oos (pn_oos[i])
    );
  end
  endgenerate

endmodule
