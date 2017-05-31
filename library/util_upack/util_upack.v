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

`timescale 1ns/100ps

module util_upack #(

  parameter   CHANNEL_DATA_WIDTH    = 32,
  parameter   NUM_OF_CHANNELS       = 8) (

  // dac interface

  input                   dac_clk,
  input                   dac_enable_0,
  input                   dac_valid_0,
  output      [(CHANNEL_DATA_WIDTH-1):0]  dac_data_0,
  output                  upack_valid_0,
  input                   dac_enable_1,
  input                   dac_valid_1,
  output      [(CHANNEL_DATA_WIDTH-1):0]  dac_data_1,
  output                  upack_valid_1,
  input                   dac_enable_2,
  input                   dac_valid_2,
  output      [(CHANNEL_DATA_WIDTH-1):0]  dac_data_2,
  output                  upack_valid_2,
  input                   dac_enable_3,
  input                   dac_valid_3,
  output      [(CHANNEL_DATA_WIDTH-1):0]  dac_data_3,
  output                  upack_valid_3,
  input                   dac_enable_4,
  input                   dac_valid_4,
  output      [(CHANNEL_DATA_WIDTH-1):0]  dac_data_4,
  output                  upack_valid_4,
  input                   dac_enable_5,
  input                   dac_valid_5,
  output      [(CHANNEL_DATA_WIDTH-1):0]  dac_data_5,
  output                  upack_valid_5,
  input                   dac_enable_6,
  input                   dac_valid_6,
  output      [(CHANNEL_DATA_WIDTH-1):0]  dac_data_6,
  output                  upack_valid_6,
  input                   dac_enable_7,
  input                   dac_valid_7,
  output      [(CHANNEL_DATA_WIDTH-1):0]  dac_data_7,
  output                  upack_valid_7,

  input                   dma_xfer_in,
  output  reg             dac_xfer_out,

  // fifo interface

  output  reg             dac_valid,
  output  reg             dac_sync,
  input       [((NUM_OF_CHANNELS*CHANNEL_DATA_WIDTH)-1):0]  dac_data);


  localparam  NUM_OF_CHANNELS_M     = 8;
  localparam  NUM_OF_CHANNELS_P     = NUM_OF_CHANNELS;
  localparam  CH_SCNT   = CHANNEL_DATA_WIDTH/16;
  localparam  M_WIDTH   = CHANNEL_DATA_WIDTH*NUM_OF_CHANNELS_M;
  localparam  P_WIDTH   = CHANNEL_DATA_WIDTH*NUM_OF_CHANNELS_P;

  // internal registers

  reg     [(M_WIDTH-1):0]           dac_dsf_data = 'd0;
  reg     [  7:0]                   dac_dmx_enable = 'd0;
  reg                               xfer_valid_d1;
  reg                               xfer_valid_d2;
  reg                               xfer_valid_d3;
  reg                               xfer_valid_d4;
  reg                               xfer_valid_d5;

  // internal signals

  wire                              dac_valid_s;
  wire                              dac_dsf_valid_s[(NUM_OF_CHANNELS_M-1):0];
  wire                              dac_dsf_sync_s[(NUM_OF_CHANNELS_M-1):0];
  wire    [(M_WIDTH-1):0]           dac_dsf_data_s[(NUM_OF_CHANNELS_M-1):0];
  wire    [(CH_SCNT-1):0]           dac_dmx_enable_7_s;
  wire    [(CH_SCNT-1):0]           dac_dmx_enable_6_s;
  wire    [(CH_SCNT-1):0]           dac_dmx_enable_5_s;
  wire    [(CH_SCNT-1):0]           dac_dmx_enable_4_s;
  wire    [(CH_SCNT-1):0]           dac_dmx_enable_3_s;
  wire    [(CH_SCNT-1):0]           dac_dmx_enable_2_s;
  wire    [(CH_SCNT-1):0]           dac_dmx_enable_1_s;
  wire    [(CH_SCNT-1):0]           dac_dmx_enable_0_s;

  // loop variables

  genvar                            n;


  assign dac_valid_s =  dac_valid_7 | dac_valid_6 | dac_valid_5 | dac_valid_4 |
                        dac_valid_3 | dac_valid_2 | dac_valid_1 | dac_valid_0;

  assign upack_valid_0  = | dac_dmx_enable & dac_enable_0 & dac_xfer_out;
  assign upack_valid_1  = | dac_dmx_enable & dac_enable_1 & dac_xfer_out;
  assign upack_valid_2  = | dac_dmx_enable & dac_enable_2 & dac_xfer_out;
  assign upack_valid_3  = | dac_dmx_enable & dac_enable_3 & dac_xfer_out;
  assign upack_valid_4  = | dac_dmx_enable & dac_enable_4 & dac_xfer_out;
  assign upack_valid_5  = | dac_dmx_enable & dac_enable_5 & dac_xfer_out;
  assign upack_valid_6  = | dac_dmx_enable & dac_enable_6 & dac_xfer_out;
  assign upack_valid_7  = | dac_dmx_enable & dac_enable_7 & dac_xfer_out;

  always @(posedge dac_clk) begin
    xfer_valid_d1   <= dma_xfer_in;
    xfer_valid_d2   <= xfer_valid_d1;
    xfer_valid_d3   <= xfer_valid_d2;
    xfer_valid_d4   <= xfer_valid_d3;
    xfer_valid_d5   <= xfer_valid_d4;
    if (dac_dmx_enable[NUM_OF_CHANNELS_P-1] == 1'b1) begin
      dac_xfer_out  <= xfer_valid_d4;
    end else begin
      dac_xfer_out  <= xfer_valid_d5;
    end
  end

  always @(posedge dac_clk) begin
    dac_valid <=    dac_dsf_valid_s[7] | dac_dsf_valid_s[6] |
                    dac_dsf_valid_s[5] | dac_dsf_valid_s[4] |
                    dac_dsf_valid_s[3] | dac_dsf_valid_s[2] |
                    dac_dsf_valid_s[1] | dac_dsf_valid_s[0];
    dac_sync <=     dac_dsf_sync_s[7] | dac_dsf_sync_s[6] |
                    dac_dsf_sync_s[5] | dac_dsf_sync_s[4] |
                    dac_dsf_sync_s[3] | dac_dsf_sync_s[2] |
                    dac_dsf_sync_s[1] | dac_dsf_sync_s[0];
    dac_dsf_data <= dac_dsf_data_s[7] | dac_dsf_data_s[6] |
                    dac_dsf_data_s[5] | dac_dsf_data_s[4] |
                    dac_dsf_data_s[3] | dac_dsf_data_s[2] |
                    dac_dsf_data_s[1] | dac_dsf_data_s[0];
    dac_dmx_enable[7] <= | dac_dmx_enable_7_s;
    dac_dmx_enable[6] <= | dac_dmx_enable_6_s;
    dac_dmx_enable[5] <= | dac_dmx_enable_5_s;
    dac_dmx_enable[4] <= | dac_dmx_enable_4_s;
    dac_dmx_enable[3] <= | dac_dmx_enable_3_s;
    dac_dmx_enable[2] <= | dac_dmx_enable_2_s;
    dac_dmx_enable[1] <= | dac_dmx_enable_1_s;
    dac_dmx_enable[0] <= | dac_dmx_enable_0_s;
  end

  // store & fwd

  generate
  if (NUM_OF_CHANNELS_P < NUM_OF_CHANNELS_M) begin
    for (n = NUM_OF_CHANNELS_P; n < NUM_OF_CHANNELS_M; n = n + 1) begin: g_def
      assign dac_dsf_valid_s[n] = 'd0;
      assign dac_dsf_sync_s[n] = 'd0;
      assign dac_dsf_data_s[n] = 'd0;
    end
  end

  for (n = 0; n < NUM_OF_CHANNELS_P; n = n + 1) begin: g_dsf
  util_upack_dsf #(
    .NUM_OF_CHANNELS_P (NUM_OF_CHANNELS_P),
    .NUM_OF_CHANNELS_M (NUM_OF_CHANNELS_M),
    .CHANNEL_DATA_WIDTH (CHANNEL_DATA_WIDTH),
    .NUM_OF_CHANNELS_O ((n+1)))
  i_dsf (
    .dac_clk (dac_clk),
    .dac_valid (dac_valid_s),
    .dac_data (dac_data),
    .dac_dmx_enable (dac_dmx_enable[n]),
    .dac_dsf_valid (dac_dsf_valid_s[n]),
    .dac_dsf_sync (dac_dsf_sync_s[n]),
    .dac_dsf_data (dac_dsf_data_s[n]));
  end
  endgenerate

  // demux

  generate
  for (n = 0; n < CH_SCNT; n = n + 1) begin: g_dmx
  util_upack_dmx i_dmx (
    .dac_clk (dac_clk),
    .dac_enable ({dac_enable_7, dac_enable_6, dac_enable_5, dac_enable_4,
                  dac_enable_3, dac_enable_2, dac_enable_1, dac_enable_0}),
    .dac_data_0 (dac_data_0[((16*n)+15):(16*n)]),
    .dac_data_1 (dac_data_1[((16*n)+15):(16*n)]),
    .dac_data_2 (dac_data_2[((16*n)+15):(16*n)]),
    .dac_data_3 (dac_data_3[((16*n)+15):(16*n)]),
    .dac_data_4 (dac_data_4[((16*n)+15):(16*n)]),
    .dac_data_5 (dac_data_5[((16*n)+15):(16*n)]),
    .dac_data_6 (dac_data_6[((16*n)+15):(16*n)]),
    .dac_data_7 (dac_data_7[((16*n)+15):(16*n)]),
    .dac_dmx_enable ({dac_dmx_enable_7_s[n], dac_dmx_enable_6_s[n],
                      dac_dmx_enable_5_s[n], dac_dmx_enable_4_s[n],
                      dac_dmx_enable_3_s[n], dac_dmx_enable_2_s[n],
                      dac_dmx_enable_1_s[n], dac_dmx_enable_0_s[n]}),
    .dac_dsf_data (dac_dsf_data[((NUM_OF_CHANNELS_M*16*(n+1))-1):(NUM_OF_CHANNELS_M*16*n)]));
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
