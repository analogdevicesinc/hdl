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
  parameter NUM_LANES = 1,
  parameter NUM_CHANNELS = 1,
  parameter SAMPLES_PER_FRAME = 1,
  parameter CONVERTER_RESOLUTION = 14,
  parameter BITS_PER_SAMPLE = 16,
  parameter OCTETS_PER_BEAT = 4,
  parameter DATA_PATH_WIDTH = 1,
  parameter LINK_DATA_WIDTH = NUM_LANES * OCTETS_PER_BEAT * 8,
  parameter DMA_DATA_WIDTH = DATA_PATH_WIDTH * BITS_PER_SAMPLE * NUM_CHANNELS,
  parameter TWOS_COMPLEMENT = 1
) (
  input clk,

  input [NUM_CHANNELS-1:0] dfmt_enable,
  input [NUM_CHANNELS-1:0] dfmt_sign_extend,
  input [NUM_CHANNELS-1:0] dfmt_type,

  input [NUM_CHANNELS*4-1:0] pn_seq_sel,
  output [NUM_CHANNELS-1:0] pn_err,
  output [NUM_CHANNELS-1:0] pn_oos,

  output [NUM_CHANNELS-1:0] adc_valid,
  output [DMA_DATA_WIDTH-1:0] adc_data,

  input adc_sync,
  output adc_sync_status,
  input adc_sync_in,
  output adc_rst_sync,

  input link_valid,
  output link_ready,
  input [OCTETS_PER_BEAT-1:0] link_sof,
  input [LINK_DATA_WIDTH-1:0] link_data
);
  // Raw and formatted channel data widths
  localparam CDW_RAW = CONVERTER_RESOLUTION * DATA_PATH_WIDTH;
  localparam ADC_DATA_WIDTH = CDW_RAW * NUM_CHANNELS;
  localparam CDW_FMT = BITS_PER_SAMPLE * DATA_PATH_WIDTH;

  wire [ADC_DATA_WIDTH-1:0] raw_data_s;

  reg adc_sync_armed = 1'b0;
  reg adc_sync_in_d1 = 1'b0;
  reg adc_sync_d1 = 1'b0;

  assign link_ready = 1'b1;
  assign adc_valid = {NUM_CHANNELS{link_valid}};
  assign adc_sync_status = adc_sync_armed;
  assign adc_rst_sync = adc_sync_armed;

  always @(posedge clk) begin
    adc_sync_in_d1 <= adc_sync_in;
    adc_sync_d1 <= adc_sync;
    if ((~adc_sync_d1 & adc_sync) == 1'b1) begin
      adc_sync_armed <= ~adc_sync_armed;
    end else if ((~adc_sync_in_d1 & adc_sync_in) == 1'b1) begin
      adc_sync_armed <= 1'b0;
    end
  end

  // synchronization logic

  ad_ip_jesd204_tpl_adc_deframer #(
    .NUM_LANES (NUM_LANES),
    .NUM_CHANNELS (NUM_CHANNELS),
    .BITS_PER_SAMPLE (BITS_PER_SAMPLE),
    .CONVERTER_RESOLUTION  (CONVERTER_RESOLUTION),
    .SAMPLES_PER_FRAME (SAMPLES_PER_FRAME),
    .OCTETS_PER_BEAT (OCTETS_PER_BEAT),
    .LINK_DATA_WIDTH (LINK_DATA_WIDTH),
    .ADC_DATA_WIDTH (ADC_DATA_WIDTH)
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
      .DATA_PATH_WIDTH (DATA_PATH_WIDTH),
      .CONVERTER_RESOLUTION (CONVERTER_RESOLUTION),
      .TWOS_COMPLEMENT (TWOS_COMPLEMENT),
      .BITS_PER_SAMPLE (BITS_PER_SAMPLE)
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
