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

module util_upack_dsf #(

  parameter   CHANNEL_DATA_WIDTH = 32,
  parameter   NUM_OF_CHANNELS = 4,
  parameter   MAX_CHANNELS = 8,
  parameter   SEL_CHANNELS = 4) (

  // dac interface

  input                                                 dac_clk,
  input                                                 dac_valid,
  input   [((CHANNEL_DATA_WIDTH*NUM_OF_CHANNELS)-1):0]  dac_data,

  // dmx interface

  input                                                 dac_dmx_enable,
  output                                                dac_dsf_req,
  output                                                dac_dsf_sync,
  output                                                dac_dsf_valid,
  output  [((CHANNEL_DATA_WIDTH*MAX_CHANNELS)-1):0]     dac_dsf_data);

  // internal parameters

  localparam  INT_WIDTH = CHANNEL_DATA_WIDTH*NUM_OF_CHANNELS;
  localparam  MAX_WIDTH = CHANNEL_DATA_WIDTH*MAX_CHANNELS;
  localparam  SEL_WIDTH = CHANNEL_DATA_WIDTH*SEL_CHANNELS;
  localparam  EXT_WIDTH = CHANNEL_DATA_WIDTH*(MAX_CHANNELS+1);

  // internal registers

  reg                                                   dac_valid_d1 = 'd0;
  reg                                                   dac_dsf_req_d1 = 'd0;
  reg                                                   dac_dsf_sync_d1 = 'd0;
  reg                                                   dac_valid_d2 = 'd0;

  reg                                                   dac_valid_d4 = 'd0;
  reg     [(MAX_WIDTH-1):0]                             dac_data_d4 = 'd0;

  // internal signals

  wire    [  2:0]                                       dac_samples_i_s;
  wire    [  2:0]                                       dac_samples_s;
  wire    [(EXT_WIDTH-1):0]                             dac_data_d2_s;
  wire    [(EXT_WIDTH-1):0]                             dac_data_i_d2_0_s;
  wire    [(EXT_WIDTH-1):0]                             dac_data_i_d2_1_s;
  wire    [(MAX_WIDTH-1):0]                             dac_data_d3_s;

  // bypass (all channels selected)

  genvar i;
  generate
  if (SEL_CHANNELS == NUM_OF_CHANNELS) begin

  assign dac_dsf_req = dac_dsf_req_d1;
  assign dac_dsf_sync = dac_dsf_sync_d1;
  assign dac_dsf_valid = dac_valid_d4;
  assign dac_dsf_data = dac_data_d4;

  assign dac_samples_i_s = 3'd0;
  assign dac_samples_s = 'd0;

  always @(posedge dac_clk) begin
    dac_valid_d1 <= dac_valid & dac_dmx_enable;
    dac_dsf_req_d1 <= dac_valid & dac_dmx_enable;
    dac_dsf_sync_d1 <= dac_valid & dac_dmx_enable;
  end

  assign dac_data_d2_s = 'd0;
  assign dac_data_i_d2_0_s = 'd0;
  assign dac_data_i_d2_1_s = 'd0;

  always @(posedge dac_clk) begin
    dac_valid_d2 <= dac_valid_d1;
  end

  for (i = 0; i < (CHANNEL_DATA_WIDTH/16); i = i +1) begin: g_dsf_data_0
  assign dac_data_d3_s[(((i +1)*MAX_CHANNELS*16)-1):(i*MAX_CHANNELS*16)] =
    dac_data[(((i+1)*16*NUM_OF_CHANNELS)-1):(i*16*NUM_OF_CHANNELS)];
  end

  always @(posedge dac_clk) begin
    if (dac_dmx_enable == 1'b1) begin
      dac_valid_d4 <= dac_valid_d2;
      dac_data_d4 <= dac_data_d3_s[(MAX_WIDTH-1):0];
    end else begin
      dac_valid_d4 <= 1'd0;
      dac_data_d4 <= 'd0;
    end
  end

  end
  endgenerate

  // data store & forward (not all channels selected)

  generate
  if (NUM_OF_CHANNELS > SEL_CHANNELS) begin
  reg [  2:0]           dac_samples_d1 = 'd0;
  reg                   dac_dsf_req_d2 = 'd0;
  reg [  2:0]           dac_samples_d2 = 'd0;
  reg                   dac_valid_d3 = 'd0;
  reg [(MAX_WIDTH-1):0] dac_data_i_d3 = 'd0;
  reg [(MAX_WIDTH-1):0] dac_data_d3 = 'd0;

  assign dac_dsf_req = dac_dsf_req_d1;
  assign dac_dsf_sync = dac_dsf_sync_d1;
  assign dac_dsf_valid = dac_valid_d4;
  assign dac_dsf_data = dac_data_d4;

  assign dac_samples_i_s = (dac_valid_d1 == 1'b1) ? dac_samples_s : dac_samples_d1;
  assign dac_samples_s = (dac_dsf_req_d1 == 1'b1) ? (dac_samples_d1+(NUM_OF_CHANNELS-SEL_CHANNELS)) :
    ((dac_samples_d1 >= SEL_CHANNELS) ? (dac_samples_d1-SEL_CHANNELS) : dac_samples_d1);

  always @(posedge dac_clk) begin
    dac_valid_d1 <= dac_valid & dac_dmx_enable;
    if ((dac_dmx_enable == 1'b0) || (dac_samples_i_s >= SEL_CHANNELS)) begin
      dac_dsf_req_d1 <= 1'b0;
    end else begin
      dac_dsf_req_d1 <= dac_valid;
    end
    if ((dac_dmx_enable == 1'b1) && (dac_samples_i_s == 3'd0)) begin
      dac_dsf_sync_d1 <= 1'b0;
    end else begin
      dac_dsf_sync_d1 <= dac_valid;
    end
    if (dac_dmx_enable == 1'b0) begin
      dac_samples_d1 <= 3'd0;
    end else if (dac_valid_d1 == 1'b1) begin
      dac_samples_d1 <= dac_samples_s;
    end
  end

  assign dac_data_d2_s[(EXT_WIDTH-1):INT_WIDTH] = 'd0;
  assign dac_data_d2_s[(INT_WIDTH-1):0] = dac_data;

  assign dac_data_i_d2_0_s[(EXT_WIDTH-1):(EXT_WIDTH-INT_WIDTH)] = dac_data;
  assign dac_data_i_d2_0_s[((EXT_WIDTH-INT_WIDTH)-1):0] =
    dac_data_i_d3[(MAX_WIDTH-1):(MAX_WIDTH-(EXT_WIDTH-INT_WIDTH))];

  assign dac_data_i_d2_1_s[(EXT_WIDTH-1):(EXT_WIDTH-(MAX_WIDTH-SEL_WIDTH))] =
    dac_data_i_d3[(MAX_WIDTH-1):SEL_WIDTH];
  assign dac_data_i_d2_1_s[((EXT_WIDTH-(MAX_WIDTH-SEL_WIDTH))-1):0] = 'd0;

  always @(posedge dac_clk) begin
    dac_valid_d2 <= dac_valid_d1;
    dac_dsf_req_d2 <= dac_dsf_req_d1;
    dac_samples_d2 <= dac_samples_d1;
  end

  always @(posedge dac_clk) begin
    dac_valid_d3 <= dac_valid_d2;
    if (dac_dsf_req_d2 == 1'b1) begin
      dac_data_i_d3 <= dac_data_i_d2_0_s[(EXT_WIDTH-1):(EXT_WIDTH-MAX_WIDTH)];
    end else if (dac_valid_d2 == 1'b1) begin
      dac_data_i_d3 <= dac_data_i_d2_1_s[(EXT_WIDTH-1):(EXT_WIDTH-MAX_WIDTH)];
    end
    if (dac_valid_d2 == 1'b1) begin
      case (dac_samples_d2)
        3'b111: dac_data_d3 <= {dac_data_d2_s[((CHANNEL_DATA_WIDTH*1)-1):0],
                  dac_data_i_d3[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*1)]};
        3'b110: dac_data_d3 <= {dac_data_d2_s[((CHANNEL_DATA_WIDTH*2)-1):0],
                  dac_data_i_d3[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*2)]};
        3'b101: dac_data_d3 <= {dac_data_d2_s[((CHANNEL_DATA_WIDTH*3)-1):0],
                  dac_data_i_d3[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*3)]};
        3'b100: dac_data_d3 <= {dac_data_d2_s[((CHANNEL_DATA_WIDTH*4)-1):0],
                  dac_data_i_d3[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*4)]};
        3'b011: dac_data_d3 <= {dac_data_d2_s[((CHANNEL_DATA_WIDTH*5)-1):0],
                  dac_data_i_d3[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*5)]};
        3'b010: dac_data_d3 <= {dac_data_d2_s[((CHANNEL_DATA_WIDTH*6)-1):0],
                  dac_data_i_d3[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*6)]};
        3'b001: dac_data_d3 <= {dac_data_d2_s[((CHANNEL_DATA_WIDTH*7)-1):0],
                  dac_data_i_d3[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*7)]};
        3'b000: dac_data_d3 <= dac_data_d2_s;
        default: dac_data_d3 <= 'd0;
      endcase
    end
  end

  for (i = 0; i < (CHANNEL_DATA_WIDTH/16); i = i + 1) begin: g_dsf_data_1
  assign dac_data_d3_s[(((i+1)*MAX_CHANNELS*16)-1):(((i*MAX_CHANNELS)+SEL_CHANNELS)*16)] = 'd0;
  assign dac_data_d3_s[((((i*MAX_CHANNELS)+SEL_CHANNELS)*16)-1):(i*MAX_CHANNELS*16)] =
    dac_data_d3[(((i+1)*SEL_CHANNELS*16)-1):(i*SEL_CHANNELS*16)];
  end

  always @(posedge dac_clk) begin
    if (dac_dmx_enable == 1'b1) begin
      dac_valid_d4 <= dac_valid_d3;
      dac_data_d4 <= dac_data_d3_s[(MAX_WIDTH-1):0];
    end else begin
      dac_valid_d4 <= 1'd0;
      dac_data_d4 <= 'd0;
    end
  end

  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
