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

module util_ccat #(

  parameter   CHANNEL_DATA_WIDTH     = 1,
  parameter   NUM_OF_CHANNELS    = 8) (

  input       [(CHANNEL_DATA_WIDTH-1):0]  data_0,
  input       [(CHANNEL_DATA_WIDTH-1):0]  data_1,
  input       [(CHANNEL_DATA_WIDTH-1):0]  data_2,
  input       [(CHANNEL_DATA_WIDTH-1):0]  data_3,
  input       [(CHANNEL_DATA_WIDTH-1):0]  data_4,
  input       [(CHANNEL_DATA_WIDTH-1):0]  data_5,
  input       [(CHANNEL_DATA_WIDTH-1):0]  data_6,
  input       [(CHANNEL_DATA_WIDTH-1):0]  data_7,

  output      [((NUM_OF_CHANNELS*CHANNEL_DATA_WIDTH)-1):0]  ccat_data);

  localparam  NUM_OF_CHANNELS_M   = 8;

  // internal signals

  wire    [((NUM_OF_CHANNELS_M*CHANNEL_DATA_WIDTH)-1):0]   data_s;

  // concatenate

  assign data_s[((CHANNEL_DATA_WIDTH*1)-1):(CHANNEL_DATA_WIDTH*0)] = data_0;
  assign data_s[((CHANNEL_DATA_WIDTH*2)-1):(CHANNEL_DATA_WIDTH*1)] = data_1;
  assign data_s[((CHANNEL_DATA_WIDTH*3)-1):(CHANNEL_DATA_WIDTH*2)] = data_2;
  assign data_s[((CHANNEL_DATA_WIDTH*4)-1):(CHANNEL_DATA_WIDTH*3)] = data_3;
  assign data_s[((CHANNEL_DATA_WIDTH*5)-1):(CHANNEL_DATA_WIDTH*4)] = data_4;
  assign data_s[((CHANNEL_DATA_WIDTH*6)-1):(CHANNEL_DATA_WIDTH*5)] = data_5;
  assign data_s[((CHANNEL_DATA_WIDTH*7)-1):(CHANNEL_DATA_WIDTH*6)] = data_6;
  assign data_s[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*7)] = data_7;

  assign ccat_data = data_s[((NUM_OF_CHANNELS*CHANNEL_DATA_WIDTH)-1):0];

endmodule

// ***************************************************************************
// ***************************************************************************
