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

  localparam TAIL_BITS = (16 - CHANNEL_WIDTH);
  localparam DATA_PATH_WIDTH = 2 * NUM_LANES / NUM_CHANNELS;
  localparam H = NUM_LANES / NUM_CHANNELS / 2;
  localparam HD = NUM_LANES > NUM_CHANNELS ? 1 : 0;
  localparam OCT_OFFSET = HD ? 32 : 8;

  wire [NUM_LANES*32-1:0] link_data_s;

  // data multiplex

  genvar i;
  genvar j;
  generate
  for (i = 0; i < NUM_CHANNELS; i = i + 1) begin: g_deframer_outer
    for (j = 0; j < DATA_PATH_WIDTH; j = j + 1) begin: g_deframer_inner
      localparam k = j + i * DATA_PATH_WIDTH;
      localparam adc_lsb = k * CHANNEL_WIDTH;
      localparam oct0_lsb = HD ? ((i * H + j % H) * 64 + (j / H) * 8) : (k * 16);
      localparam oct1_lsb = oct0_lsb + OCT_OFFSET + TAIL_BITS;

      assign adc_data[adc_lsb+:CHANNEL_WIDTH] = {
          link_data_s[oct0_lsb+:8],
          link_data_s[oct1_lsb+:8-TAIL_BITS]
        };
    end
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
