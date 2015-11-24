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

`timescale 1ns/100ps

module util_upack (

  // dac interface

  dac_clk,
  dac_enable_0,
  dac_valid_0,
  dac_data_0,
  upack_valid_0,
  dac_enable_1,
  dac_valid_1,
  dac_data_1,
  upack_valid_1,
  dac_enable_2,
  dac_valid_2,
  dac_data_2,
  upack_valid_2,
  dac_enable_3,
  dac_valid_3,
  dac_data_3,
  upack_valid_3,
  dac_enable_4,
  dac_valid_4,
  dac_data_4,
  upack_valid_4,
  dac_enable_5,
  dac_valid_5,
  dac_data_5,
  upack_valid_5,
  dac_enable_6,
  dac_valid_6,
  dac_data_6,
  upack_valid_6,
  dac_enable_7,
  dac_valid_7,
  dac_data_7,
  upack_valid_7,

  dma_xfer_in,
  dac_xfer_out,

  // fifo interface

  dac_valid,
  dac_sync,
  dac_data);

  // parameters

  parameter   CHANNEL_DATA_WIDTH    = 32;
  parameter   NUM_OF_CHANNELS       = 8;

  localparam  NUM_OF_CHANNELS_M     = 8;
  localparam  NUM_OF_CHANNELS_P     = NUM_OF_CHANNELS;
  localparam  CH_SCNT   = CHANNEL_DATA_WIDTH/16;
  localparam  M_WIDTH   = CHANNEL_DATA_WIDTH*NUM_OF_CHANNELS_M;
  localparam  P_WIDTH   = CHANNEL_DATA_WIDTH*NUM_OF_CHANNELS_P;

  // dac interface

  input                               dac_clk;
  input                               dac_enable_0;
  input                               dac_valid_0;
  output  [(CHANNEL_DATA_WIDTH-1):0]  dac_data_0;
  output                              upack_valid_0;
  input                               dac_enable_1;
  input                               dac_valid_1;
  output  [(CHANNEL_DATA_WIDTH-1):0]  dac_data_1;
  output                              upack_valid_1;
  input                               dac_enable_2;
  input                               dac_valid_2;
  output  [(CHANNEL_DATA_WIDTH-1):0]  dac_data_2;
  output                              upack_valid_2;
  input                               dac_enable_3;
  input                               dac_valid_3;
  output  [(CHANNEL_DATA_WIDTH-1):0]  dac_data_3;
  output                              upack_valid_3;
  input                               dac_enable_4;
  input                               dac_valid_4;
  output  [(CHANNEL_DATA_WIDTH-1):0]  dac_data_4;
  output                              upack_valid_4;
  input                               dac_enable_5;
  input                               dac_valid_5;
  output  [(CHANNEL_DATA_WIDTH-1):0]  dac_data_5;
  output                              upack_valid_5;
  input                               dac_enable_6;
  input                               dac_valid_6;
  output  [(CHANNEL_DATA_WIDTH-1):0]  dac_data_6;
  output                              upack_valid_6;
  input                               dac_enable_7;
  input                               dac_valid_7;
  output  [(CHANNEL_DATA_WIDTH-1):0]  dac_data_7;
  output                              upack_valid_7;

  input                               dma_xfer_in;
  output                              dac_xfer_out;

  // fifo interface

  output                              dac_valid;
  output                              dac_sync;
  input   [((NUM_OF_CHANNELS*CHANNEL_DATA_WIDTH)-1):0]    dac_data;

  // internal registers

  reg                               dac_valid = 'd0;
  reg                               dac_sync = 'd0;
  reg     [(M_WIDTH-1):0]           dac_dsf_data = 'd0;
  reg     [  7:0]                   dac_dmx_enable = 'd0;
  reg                               xfer_valid_d1;
  reg                               xfer_valid_d2;
  reg                               xfer_valid_d3;
  reg                               xfer_valid_d4;
  reg                               xfer_valid_d5;
  reg                               dac_xfer_out;

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

  // parameter breaks here (max. 8) -- reduce won't work across 2d arrays.

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
