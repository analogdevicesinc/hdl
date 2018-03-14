// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
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

`timescale 1ns/100ps

module util_upack #(

  parameter   CHANNEL_DATA_WIDTH = 32,
  parameter   NUM_OF_CHANNELS = 8) (

  // dac interface

  input                                                 dac_clk,
  input                                                 dac_enable_0,
  input                                                 dac_valid_0,
  output                                                dac_valid_out_0,
  output  [(CHANNEL_DATA_WIDTH-1):0]                    dac_data_0,
  input                                                 dac_enable_1,
  input                                                 dac_valid_1,
  output                                                dac_valid_out_1,
  output  [(CHANNEL_DATA_WIDTH-1):0]                    dac_data_1,
  input                                                 dac_enable_2,
  input                                                 dac_valid_2,
  output                                                dac_valid_out_2,
  output  [(CHANNEL_DATA_WIDTH-1):0]                    dac_data_2,
  input                                                 dac_enable_3,
  input                                                 dac_valid_3,
  output                                                dac_valid_out_3,
  output  [(CHANNEL_DATA_WIDTH-1):0]                    dac_data_3,
  input                                                 dac_enable_4,
  input                                                 dac_valid_4,
  output                                                dac_valid_out_4,
  output  [(CHANNEL_DATA_WIDTH-1):0]                    dac_data_4,
  input                                                 dac_enable_5,
  input                                                 dac_valid_5,
  output                                                dac_valid_out_5,
  output  [(CHANNEL_DATA_WIDTH-1):0]                    dac_data_5,
  input                                                 dac_enable_6,
  input                                                 dac_valid_6,
  output                                                dac_valid_out_6,
  output  [(CHANNEL_DATA_WIDTH-1):0]                    dac_data_6,
  input                                                 dac_enable_7,
  input                                                 dac_valid_7,
  output                                                dac_valid_out_7,
  output  [(CHANNEL_DATA_WIDTH-1):0]                    dac_data_7,

  // fifo interface

  output                                                dac_valid,
  output                                                dac_sync,
  input   [((NUM_OF_CHANNELS*CHANNEL_DATA_WIDTH)-1):0]  dac_data);

  // internal parameters

  localparam  MAX_CHANNELS = 8;

  // internal registers

  reg                                                   dac_valid_int = 'd0;
  reg                                                   dac_sync_int = 'd0;

  // internal signals

  wire                                                  dac_valid_s;
  wire    [ 7:0]                                        dac_enable_s;
  wire                                                  dac_dsf_valid_m_s;
  wire    [((CHANNEL_DATA_WIDTH*MAX_CHANNELS)-1):0]     dac_dsf_data_m_s;
  wire    [ 7:0]                                        dac_dmx_enable_m_s;
  wire    [(MAX_CHANNELS-1):0]                          dac_dsf_req_s;
  wire    [(MAX_CHANNELS-1):0]                          dac_dsf_sync_s;
  wire    [(MAX_CHANNELS-1):0]                          dac_dsf_valid_s;
  wire    [((CHANNEL_DATA_WIDTH*MAX_CHANNELS)-1):0]     dac_dsf_data_s[(MAX_CHANNELS-1):0];
  wire    [((CHANNEL_DATA_WIDTH/16)-1):0]               dac_dmx_valid_s;
  wire    [((CHANNEL_DATA_WIDTH/16)-1):0]               dac_dmx_enable_7_s;
  wire    [((CHANNEL_DATA_WIDTH/16)-1):0]               dac_dmx_enable_6_s;
  wire    [((CHANNEL_DATA_WIDTH/16)-1):0]               dac_dmx_enable_5_s;
  wire    [((CHANNEL_DATA_WIDTH/16)-1):0]               dac_dmx_enable_4_s;
  wire    [((CHANNEL_DATA_WIDTH/16)-1):0]               dac_dmx_enable_3_s;
  wire    [((CHANNEL_DATA_WIDTH/16)-1):0]               dac_dmx_enable_2_s;
  wire    [((CHANNEL_DATA_WIDTH/16)-1):0]               dac_dmx_enable_1_s;
  wire    [((CHANNEL_DATA_WIDTH/16)-1):0]               dac_dmx_enable_0_s;

  // data interleaving

  assign dac_valid = dac_valid_int;
  assign dac_sync = dac_sync_int;
  assign dac_valid_out_0 = dac_dmx_valid_s[0];
  assign dac_valid_out_1 = dac_dmx_valid_s[0];
  assign dac_valid_out_2 = dac_dmx_valid_s[0];
  assign dac_valid_out_3 = dac_dmx_valid_s[0];
  assign dac_valid_out_4 = dac_dmx_valid_s[0];
  assign dac_valid_out_5 = dac_dmx_valid_s[0];
  assign dac_valid_out_6 = dac_dmx_valid_s[0];
  assign dac_valid_out_7 = dac_dmx_valid_s[0];

  always @(posedge dac_clk) begin
    dac_valid_int <= | dac_dsf_req_s;
    dac_sync_int <= | dac_dsf_sync_s;
  end

  assign dac_valid_s =  dac_valid_7 | dac_valid_6 | dac_valid_5 | dac_valid_4 |
    dac_valid_3 | dac_valid_2 | dac_valid_1 | dac_valid_0;
  assign dac_enable_s = {dac_enable_7, dac_enable_6, dac_enable_5, dac_enable_4,
    dac_enable_3, dac_enable_2, dac_enable_1, dac_enable_0};

  assign dac_dsf_valid_m_s = | dac_dsf_valid_s;
  assign dac_dsf_data_m_s = dac_dsf_data_s[7] | dac_dsf_data_s[6] |
    dac_dsf_data_s[5] | dac_dsf_data_s[4] | dac_dsf_data_s[3] |
    dac_dsf_data_s[2] | dac_dsf_data_s[1] | dac_dsf_data_s[0];

  assign dac_dmx_enable_m_s[7] = | dac_dmx_enable_7_s;
  assign dac_dmx_enable_m_s[6] = | dac_dmx_enable_6_s;
  assign dac_dmx_enable_m_s[5] = | dac_dmx_enable_5_s;
  assign dac_dmx_enable_m_s[4] = | dac_dmx_enable_4_s;
  assign dac_dmx_enable_m_s[3] = | dac_dmx_enable_3_s;
  assign dac_dmx_enable_m_s[2] = | dac_dmx_enable_2_s;
  assign dac_dmx_enable_m_s[1] = | dac_dmx_enable_1_s;
  assign dac_dmx_enable_m_s[0] = | dac_dmx_enable_0_s;

  // instantiations

  genvar n;
  generate

  // defaults

  for (n = NUM_OF_CHANNELS; n < MAX_CHANNELS; n = n + 1) begin: g_defaults
  assign dac_dsf_req_s[n] = 'd0;
  assign dac_dsf_sync_s[n] = 'd0;
  assign dac_dsf_valid_s[n] = 'd0;
  assign dac_dsf_data_s[n] = 'd0;
  end

  // dsf
 
  for (n = 0; n < NUM_OF_CHANNELS; n = n + 1) begin: g_dsf
  util_upack_dsf #(
    .CHANNEL_DATA_WIDTH (CHANNEL_DATA_WIDTH),
    .NUM_OF_CHANNELS (NUM_OF_CHANNELS),
    .MAX_CHANNELS (MAX_CHANNELS),
    .SEL_CHANNELS ((n+1)))
  i_dsf (
    .dac_clk (dac_clk),
    .dac_valid (dac_valid_s),
    .dac_data (dac_data),
    .dac_dmx_enable (dac_dmx_enable_m_s[n]),
    .dac_dsf_req (dac_dsf_req_s[n]),
    .dac_dsf_sync (dac_dsf_sync_s[n]),
    .dac_dsf_valid (dac_dsf_valid_s[n]),
    .dac_dsf_data (dac_dsf_data_s[n]));
  end

  // demux

  for (n = 0; n < (CHANNEL_DATA_WIDTH/16); n = n + 1) begin: g_dmx
  util_upack_dmx i_dmx (
    .dac_clk (dac_clk),
    .dac_enable (dac_enable_s),
    .dac_valid (dac_dmx_valid_s[n]),
    .dac_data_0 (dac_data_0[((16*n)+15):(16*n)]),
    .dac_data_1 (dac_data_1[((16*n)+15):(16*n)]),
    .dac_data_2 (dac_data_2[((16*n)+15):(16*n)]),
    .dac_data_3 (dac_data_3[((16*n)+15):(16*n)]),
    .dac_data_4 (dac_data_4[((16*n)+15):(16*n)]),
    .dac_data_5 (dac_data_5[((16*n)+15):(16*n)]),
    .dac_data_6 (dac_data_6[((16*n)+15):(16*n)]),
    .dac_data_7 (dac_data_7[((16*n)+15):(16*n)]),
    .dac_dmx_enable ({dac_dmx_enable_7_s[n], dac_dmx_enable_6_s[n],
      dac_dmx_enable_5_s[n], dac_dmx_enable_4_s[n], dac_dmx_enable_3_s[n],
      dac_dmx_enable_2_s[n], dac_dmx_enable_1_s[n], dac_dmx_enable_0_s[n]}),
    .dac_dsf_valid (dac_dsf_valid_m_s),
    .dac_dsf_data (dac_dsf_data_m_s[((MAX_CHANNELS*16*(n+1))-1):(MAX_CHANNELS*16*n)]));
  end

  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
