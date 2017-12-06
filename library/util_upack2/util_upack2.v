// ***************************************************************************
// ***************************************************************************
// Copyright 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsabilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

module util_upack2 #(
  parameter NUM_OF_CHANNELS = 4,
  parameter SAMPLE_DATA_WIDTH = 16,
  parameter SAMPLES_PER_CHANNEL = 1
) (
  input clk,
  input reset,

  input enable_0,
  input enable_1,
  input enable_2,
  input enable_3,
  input enable_4,
  input enable_5,
  input enable_6,
  input enable_7,

  input fifo_rd_en,
  output fifo_rd_valid,
  output fifo_rd_underflow,

  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_0,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_1,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_2,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_3,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_4,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_5,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_6,
  output [SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] fifo_rd_data_7,

  input s_axis_valid,
  output s_axis_ready,
  input [NUM_OF_CHANNELS*SAMPLE_DATA_WIDTH*SAMPLES_PER_CHANNEL-1:0] s_axis_data
);

localparam CHANNEL_DATA_WIDTH = SAMPLE_DATA_WIDTH * SAMPLES_PER_CHANNEL;

/* FIXME: Find out how to do this in the IP-XACT */

wire [NUM_OF_CHANNELS-1:0] enable;
wire [7:0] enable_s;
wire [CHANNEL_DATA_WIDTH*NUM_OF_CHANNELS-1:0] fifo_rd_data;
wire [CHANNEL_DATA_WIDTH*8-1:0] fifo_rd_data_s;

util_upack2_impl #(
  .NUM_OF_CHANNELS(NUM_OF_CHANNELS),
  .SAMPLE_DATA_WIDTH(SAMPLE_DATA_WIDTH),
  .SAMPLES_PER_CHANNEL(SAMPLES_PER_CHANNEL)
) i_upack (
  .clk(clk),
  .reset(reset),

  .enable(enable),

  .fifo_rd_en(fifo_rd_en),
  .fifo_rd_valid(fifo_rd_valid),
  .fifo_rd_underflow(fifo_rd_underflow),
  .fifo_rd_data(fifo_rd_data),

  .s_axis_valid(s_axis_valid),
  .s_axis_ready(s_axis_ready),
  .s_axis_data(s_axis_data)
);

assign enable_s = {enable_7,enable_6,enable_5,enable_4,enable_3,enable_2,enable_1,enable_0};
assign enable = enable_s[NUM_OF_CHANNELS-1:0];

assign fifo_rd_data_s = {{(8-NUM_OF_CHANNELS)*CHANNEL_DATA_WIDTH{1'b0}},fifo_rd_data};

assign fifo_rd_data_0 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*0+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_1 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*1+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_2 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*2+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_3 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*3+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_4 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*4+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_5 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*5+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_6 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*6+:CHANNEL_DATA_WIDTH];
assign fifo_rd_data_7 = fifo_rd_data_s[CHANNEL_DATA_WIDTH*7+:CHANNEL_DATA_WIDTH];

endmodule
