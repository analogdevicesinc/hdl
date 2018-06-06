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

module ad_ip_jesd204_tpl_adc_deframer #(
  parameter NUM_LANES = 1,
  parameter NUM_CHANNELS = 1,
  parameter CHANNEL_WIDTH = 16
) (
  // jesd interface
  // clk is (line-rate/40)

  input clk,
  input [3:0] link_sof,
  input [NUM_LANES*32-1:0] link_data,

   // adc data output

   output [NUM_LANES*CHANNEL_WIDTH*2-1:0] adc_data
 );

  // Fixed for now
  localparam BITS_PER_SAMPLE = 16;
  localparam SAMPLES_PER_FRAME = 1;
  localparam OCTETS_PER_BEAT = 4;

  localparam BITS_PER_FRAME = BITS_PER_SAMPLE * SAMPLES_PER_FRAME *
                              NUM_CHANNELS / NUM_LANES;
  localparam FRAMES_PER_BEAT = OCTETS_PER_BEAT / (BITS_PER_FRAME / 8);
  localparam TOTAL_BITS = OCTETS_PER_BEAT * 8 * NUM_LANES;

  wire [TOTAL_BITS-1:0] link_data_s;
  wire [TOTAL_BITS-1:0] link_data_msb_s;
  wire [TOTAL_BITS-1:0] frame_data_s;
  wire [TOTAL_BITS-1:0] adc_data_msb_s;

  generate
  genvar i;
  genvar j;

  // Reorder octets LSB first
  for (i = 0; i < NUM_LANES*OCTETS_PER_BEAT; i = i + 1) begin: whatever
    localparam src_lsb = i*8;
    localparam dst_msb = TOTAL_BITS - 1 - src_lsb;

    assign link_data_msb_s[dst_msb-:8] = link_data_s[src_lsb+:8];
  end

  // Group data by frames
  for (i = 0; i < FRAMES_PER_BEAT; i = i + 1) begin: g_frame_outer
    for (j = 0; j < NUM_LANES; j = j + 1) begin: g_frame_inner
      localparam src_lsb = (i + j * FRAMES_PER_BEAT) * BITS_PER_FRAME;
      localparam dst_lsb = (j + i * NUM_LANES) * BITS_PER_FRAME;

      assign frame_data_s[dst_lsb+:BITS_PER_FRAME] = link_data_msb_s[src_lsb+:BITS_PER_FRAME];
    end
  end

  // Group data by channels
  for (i = 0; i < NUM_CHANNELS; i = i + 1) begin: g_framer_outer
    for (j = 0; j < FRAMES_PER_BEAT; j = j + 1) begin: g_framer_inner
      localparam w = SAMPLES_PER_FRAME * BITS_PER_SAMPLE;
      localparam src_lsb = (i + j * NUM_CHANNELS) * w;
      localparam dst_lsb = (j + i * FRAMES_PER_BEAT) * w;

      assign adc_data_msb_s[dst_lsb+:w] = frame_data_s[src_lsb+:w];
    end
  end

  // Reorder samples MSB first and drop tail bits
  for (i = 0; i < NUM_CHANNELS * SAMPLES_PER_FRAME * FRAMES_PER_BEAT; i = i + 1) begin: joho
    localparam dst_lsb = i * CHANNEL_WIDTH;
    localparam src_msb = TOTAL_BITS - 1 - i * BITS_PER_SAMPLE;

    assign adc_data[dst_lsb+:CHANNEL_WIDTH] = adc_data_msb_s[src_msb-:CHANNEL_WIDTH];
  end
  endgenerate

  // frame-alignment

  generate
  genvar n;
  for (n = 0; n < NUM_LANES; n = n + 1) begin: g_xcvr_if
    ad_xcvr_rx_if  i_xcvr_if (
      .rx_clk (clk),
      .rx_ip_sof (link_sof),
      .rx_ip_data (link_data[n*32+:32]),
      .rx_sof (),
      .rx_data (link_data_s[n*32+:32])
    );
  end
  endgenerate

endmodule
