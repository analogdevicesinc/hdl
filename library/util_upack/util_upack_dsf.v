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

module util_upack_dsf #(

  parameter   NUM_OF_CHANNELS_P   =  4,
  parameter   NUM_OF_CHANNELS_M   =  8,
  parameter   CHANNEL_DATA_WIDTH  = 32,
  parameter   NUM_OF_CHANNELS_O   =  4) (

  // dac interface

  input                   dac_clk,
  input                   dac_valid,
  input       [(P_WIDTH-1):0]  dac_data,

  // dmx interface

  input                   dac_dmx_enable,
  output  reg             dac_dsf_valid,
  output  reg             dac_dsf_sync,
  output  reg [(M_WIDTH-1):0]  dac_dsf_data);


  localparam  CH_SCNT = CHANNEL_DATA_WIDTH/16;
  localparam  P_WIDTH = CHANNEL_DATA_WIDTH*NUM_OF_CHANNELS_P;
  localparam  M_WIDTH = CHANNEL_DATA_WIDTH*NUM_OF_CHANNELS_M;
  localparam  O_WIDTH = CHANNEL_DATA_WIDTH*NUM_OF_CHANNELS_O;
  localparam  E_WIDTH = CHANNEL_DATA_WIDTH*(NUM_OF_CHANNELS_M+1);
  localparam  CH_DCNT = NUM_OF_CHANNELS_P - NUM_OF_CHANNELS_O;

  // internal registers

  reg                       dac_dmx_valid = 'd0;
  reg     [  2:0]           dac_samples_int = 'd0;
  reg                       dac_dmx_valid_d = 'd0;
  reg                       dac_dsf_valid_d = 'd0;
  reg     [  2:0]           dac_samples_int_d = 'd0;
  reg     [(M_WIDTH-1):0]   dac_data_int = 'd0;
  reg     [(M_WIDTH-1):0]   dac_dsf_data_int = 'd0;
  reg                       dac_valid_d1 = 'd0;

  // internal signals

  wire    [  2:0]           dac_samples_int_s;
  wire    [(E_WIDTH-1):0]   dac_data_s;
  wire    [(E_WIDTH-1):0]   dac_data_int_0_s;
  wire    [(E_WIDTH-1):0]   dac_data_int_1_s;
  wire    [M_WIDTH:0]       dac_dsf_data_s;

  // bypass 

  genvar i;
  generate
  if (NUM_OF_CHANNELS_O == NUM_OF_CHANNELS_P) begin
  for (i = 0; i < CH_SCNT ; i = i +1) begin: g_dsf_data
    assign dac_dsf_data_s[(((i +1) * NUM_OF_CHANNELS_M * 16)-1):(i*NUM_OF_CHANNELS_M*16)] =
      dac_data[(((i+1)*16*NUM_OF_CHANNELS_P)-1): (i*16*NUM_OF_CHANNELS_P)];
  end
  end
  endgenerate

  generate
  if (NUM_OF_CHANNELS_O == NUM_OF_CHANNELS_P) begin

  assign dac_samples_int_s = 'd0;
  assign dac_data_s = 'd0;
  assign dac_data_int_0_s = 'd0;
  assign dac_data_int_1_s = 'd0;

  always @(posedge dac_clk) begin
    dac_dmx_valid <= dac_valid & dac_dmx_enable;
    dac_dsf_valid <= dac_valid & dac_dmx_enable;
    dac_dsf_sync <= dac_valid & dac_dmx_enable;
    dac_samples_int <= 'd0;
    dac_dmx_valid_d <= 'd0;
    dac_dsf_valid_d <= 'd0;
    dac_samples_int_d <= 'd0;
    dac_data_int <= 'd0;
    dac_dsf_data_int <= 'd0;
    if (dac_dmx_enable == 1'b1) begin
      dac_dsf_data <= dac_dsf_data_s[(M_WIDTH-1):0];
    end else begin
      dac_dsf_data <= 'd0;
    end
  end
  end
  endgenerate

  // data store & forward

  generate
  if (NUM_OF_CHANNELS_P > NUM_OF_CHANNELS_O) begin

  assign dac_samples_int_s =  (dac_dsf_valid == 1'b1) ? (dac_samples_int + CH_DCNT) :
            ((dac_samples_int >= NUM_OF_CHANNELS_O) ? (dac_samples_int - NUM_OF_CHANNELS_O) : dac_samples_int);

  always @(posedge dac_clk) begin
    dac_dmx_valid <= dac_valid & dac_dmx_enable;
    dac_valid_d1 <= dac_valid;
    if (dac_valid_d1 == 1'b1) begin
      if (dac_samples_int_s < NUM_OF_CHANNELS_O) begin
        dac_dsf_valid <= dac_valid & dac_dmx_enable;
      end else begin
        dac_dsf_valid <= 1'b0;
      end
      if (dac_samples_int_s == 0) begin
        dac_dsf_sync <= dac_valid & dac_dmx_enable;
      end else begin
        dac_dsf_sync <= 1'b0;
      end
    end else begin
      if (dac_samples_int < NUM_OF_CHANNELS_O) begin
        dac_dsf_valid <= dac_valid & dac_dmx_enable;
      end else begin
        dac_dsf_valid <= 1'b0;
      end
      if (dac_samples_int == 0) begin
        dac_dsf_sync <= dac_valid & dac_dmx_enable;
      end else begin
        dac_dsf_sync <= 1'b0;
      end
    end
    if (dac_dmx_valid == 1'b1) begin
      dac_samples_int <= dac_samples_int_s;
    end
  end

  assign dac_data_s[(E_WIDTH-1):P_WIDTH] = 'd0;
  assign dac_data_s[(P_WIDTH-1):0] = dac_data;

  assign dac_data_int_0_s[(E_WIDTH-1):(E_WIDTH-P_WIDTH)] = dac_data;
  assign dac_data_int_0_s[((E_WIDTH-P_WIDTH)-1):0] =
            dac_data_int[(M_WIDTH-1):(M_WIDTH-(E_WIDTH-P_WIDTH))];

  assign dac_data_int_1_s[(E_WIDTH-1):(E_WIDTH-(M_WIDTH-O_WIDTH))] =
            dac_data_int[(M_WIDTH-1):O_WIDTH];
  assign dac_data_int_1_s[((E_WIDTH-(M_WIDTH-O_WIDTH))-1):0] = 'd0;

  always @(posedge dac_clk) begin
    dac_dmx_valid_d <= dac_dmx_valid;
    dac_dsf_valid_d <= dac_dsf_valid;
    dac_samples_int_d <= dac_samples_int;
    if (dac_dsf_valid_d == 1'b1) begin
      dac_data_int <= dac_data_int_0_s[(E_WIDTH-1):(E_WIDTH-M_WIDTH)];
    end else if (dac_dmx_valid_d == 1'b1) begin
      dac_data_int <= dac_data_int_1_s[(E_WIDTH-1):(E_WIDTH-M_WIDTH)];
    end
  end

  always @(posedge dac_clk) begin
    if (dac_dmx_valid_d == 1'b1) begin
      case (dac_samples_int_d)
        3'b111: dac_dsf_data_int <= { dac_data_s[((CHANNEL_DATA_WIDTH*1)-1):0],
                                      dac_data_int[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*1)]};
        3'b110: dac_dsf_data_int <= { dac_data_s[((CHANNEL_DATA_WIDTH*2)-1):0],
                                      dac_data_int[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*2)]};
        3'b101: dac_dsf_data_int <= { dac_data_s[((CHANNEL_DATA_WIDTH*3)-1):0],
                                      dac_data_int[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*3)]};
        3'b100: dac_dsf_data_int <= { dac_data_s[((CHANNEL_DATA_WIDTH*4)-1):0],
                                      dac_data_int[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*4)]};
        3'b011: dac_dsf_data_int <= { dac_data_s[((CHANNEL_DATA_WIDTH*5)-1):0],
                                      dac_data_int[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*5)]};
        3'b010: dac_dsf_data_int <= { dac_data_s[((CHANNEL_DATA_WIDTH*6)-1):0],
                                      dac_data_int[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*6)]};
        3'b001: dac_dsf_data_int <= { dac_data_s[((CHANNEL_DATA_WIDTH*7)-1):0],
                                      dac_data_int[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*7)]};
        3'b000: dac_dsf_data_int <= dac_data_s;
        default: dac_dsf_data_int <= 'd0;
      endcase
    end
  end
  end
  endgenerate

  genvar n;
  generate
  if (NUM_OF_CHANNELS_P > NUM_OF_CHANNELS_O) begin
  assign dac_dsf_data_s[M_WIDTH] = 'd0;
  for (n = 0; n < CH_SCNT; n = n + 1) begin: g_out
  assign dac_dsf_data_s[(((n+1)*NUM_OF_CHANNELS_M*16)-1):(((n*NUM_OF_CHANNELS_M)+NUM_OF_CHANNELS_O)*16)] = 'd0;
  assign dac_dsf_data_s[((((n*NUM_OF_CHANNELS_M)+NUM_OF_CHANNELS_O)*16)-1):(n*NUM_OF_CHANNELS_M*16)] =
    dac_dsf_data_int[(((n+1)*NUM_OF_CHANNELS_O*16)-1):(n*NUM_OF_CHANNELS_O*16)];
  end
  end
  endgenerate

  generate
  if (NUM_OF_CHANNELS_P > NUM_OF_CHANNELS_O) begin
  always @(posedge dac_clk) begin
    if (dac_dmx_enable == 1'b1) begin
      dac_dsf_data <= dac_dsf_data_s[(M_WIDTH-1):0];
    end else begin
      dac_dsf_data <= 'd0;
    end
  end
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
