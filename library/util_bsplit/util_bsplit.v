// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
// too bad- we have to do this!

`timescale 1ns/100ps

module util_bsplit #(

  parameter   CHANNEL_DATA_WIDTH     = 1,
  parameter   NUM_OF_CHANNELS    = 8) (

  input       [((NUM_OF_CHANNELS*CHANNEL_DATA_WIDTH)-1):0]  data,

  output      [(CHANNEL_DATA_WIDTH-1):0]  split_data_0,
  output      [(CHANNEL_DATA_WIDTH-1):0]  split_data_1,
  output      [(CHANNEL_DATA_WIDTH-1):0]  split_data_2,
  output      [(CHANNEL_DATA_WIDTH-1):0]  split_data_3,
  output      [(CHANNEL_DATA_WIDTH-1):0]  split_data_4,
  output      [(CHANNEL_DATA_WIDTH-1):0]  split_data_5,
  output      [(CHANNEL_DATA_WIDTH-1):0]  split_data_6,
  output      [(CHANNEL_DATA_WIDTH-1):0]  split_data_7);

  localparam  NUM_OF_CHANNELS_M   = 9;

  // internal signals

  wire    [((NUM_OF_CHANNELS_M*CHANNEL_DATA_WIDTH)-1):0]   data_s;

  // extend and split
  
  assign data_s[((NUM_OF_CHANNELS_M*CHANNEL_DATA_WIDTH)-1):(NUM_OF_CHANNELS*CHANNEL_DATA_WIDTH)] = 'd0;
  assign data_s[((NUM_OF_CHANNELS*CHANNEL_DATA_WIDTH)-1):0] = data;

  assign split_data_0 = data_s[((CHANNEL_DATA_WIDTH*1)-1):(CHANNEL_DATA_WIDTH*0)];
  assign split_data_1 = data_s[((CHANNEL_DATA_WIDTH*2)-1):(CHANNEL_DATA_WIDTH*1)];
  assign split_data_2 = data_s[((CHANNEL_DATA_WIDTH*3)-1):(CHANNEL_DATA_WIDTH*2)];
  assign split_data_3 = data_s[((CHANNEL_DATA_WIDTH*4)-1):(CHANNEL_DATA_WIDTH*3)];
  assign split_data_4 = data_s[((CHANNEL_DATA_WIDTH*5)-1):(CHANNEL_DATA_WIDTH*4)];
  assign split_data_5 = data_s[((CHANNEL_DATA_WIDTH*6)-1):(CHANNEL_DATA_WIDTH*5)];
  assign split_data_6 = data_s[((CHANNEL_DATA_WIDTH*7)-1):(CHANNEL_DATA_WIDTH*6)];
  assign split_data_7 = data_s[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*7)];

endmodule

// ***************************************************************************
// ***************************************************************************
