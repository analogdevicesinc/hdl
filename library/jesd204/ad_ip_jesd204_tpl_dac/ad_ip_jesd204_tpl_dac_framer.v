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

module ad_ip_jesd204_tpl_dac_framer #(
  parameter NUM_LANES = 8,
  parameter NUM_CHANNELS = 4
) (
  // jesd interface
  // clk is (line-rate/40)

  input clk,
  output [NUM_LANES*32-1:0] link_data,

  // dac interface

  input [NUM_LANES*32-1:0] dac_data
);

  localparam DATA_PATH_WIDTH = 2 * NUM_LANES / NUM_CHANNELS;
  localparam H = NUM_LANES / NUM_CHANNELS / 2;
  localparam HD = NUM_LANES > NUM_CHANNELS ? 1 : 0;
  localparam OCT_OFFSET = HD ? 32 : 8;

  // internal registers

  reg    [NUM_LANES*32-1:0]  link_data_r = 'd0;
  wire   [NUM_LANES*32-1:0]  link_data_s;

  always @(posedge clk) begin
    link_data_r <= link_data_s;
  end

  assign link_data = link_data_r;

  generate
  genvar i;
  genvar j;
  for (i = 0; i < NUM_CHANNELS; i = i + 1) begin: g_framer_outer
    for (j = 0; j < DATA_PATH_WIDTH; j = j + 1) begin: g_framer_inner
      localparam k = j + i * DATA_PATH_WIDTH;
      localparam dac_lsb = k * 16;
      localparam oct0_lsb = HD ? ((i * H + j % H) * 64 + (j / H) * 8) : (k * 16);
      localparam oct1_lsb = oct0_lsb + OCT_OFFSET;

      assign link_data_s[oct0_lsb+:8] = dac_data[dac_lsb+8+:8];
      assign link_data_s[oct1_lsb+:8] = dac_data[dac_lsb+:8];
    end
  end
  endgenerate

endmodule
