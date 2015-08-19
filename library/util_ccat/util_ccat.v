// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//    
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// too bad- we have to do this!

`timescale 1ns/100ps

module util_ccat (

  data_0,
  data_1,
  data_2,
  data_3,
  data_4,
  data_5,
  data_6,
  data_7,

  ccat_data);

  // parameters

  parameter   CHANNEL_DATA_WIDTH     = 1;
  parameter   NUM_OF_CHANNELS    = 8;
  localparam  NUM_OF_CHANNELS_M   = 8;

  // interface

  input   [(CHANNEL_DATA_WIDTH-1):0]             data_0;
  input   [(CHANNEL_DATA_WIDTH-1):0]             data_1;
  input   [(CHANNEL_DATA_WIDTH-1):0]             data_2;
  input   [(CHANNEL_DATA_WIDTH-1):0]             data_3;
  input   [(CHANNEL_DATA_WIDTH-1):0]             data_4;
  input   [(CHANNEL_DATA_WIDTH-1):0]             data_5;
  input   [(CHANNEL_DATA_WIDTH-1):0]             data_6;
  input   [(CHANNEL_DATA_WIDTH-1):0]             data_7;
  output  [((NUM_OF_CHANNELS*CHANNEL_DATA_WIDTH)-1):0]    ccat_data;

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
