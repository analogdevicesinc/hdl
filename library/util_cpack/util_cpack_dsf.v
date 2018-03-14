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

module util_cpack_dsf #(

  parameter   CHANNEL_DATA_WIDTH  = 32,
  parameter   NUM_OF_CHANNELS_I   =  4,
  parameter   NUM_OF_CHANNELS_M   =  8,
  parameter   NUM_OF_CHANNELS_P   =  4) (

  // adc interface

  input                   adc_clk,
  input                   adc_valid,
  input                   adc_enable,
  input       [(CHANNEL_DATA_WIDTH*NUM_OF_CHANNELS_I-1):0]  adc_data,

  // dma interface

  output  reg             adc_dsf_valid,
  output  reg             adc_dsf_sync,
  output  reg [(CHANNEL_DATA_WIDTH*NUM_OF_CHANNELS_P-1):0]  adc_dsf_data);


  localparam  CH_DCNT = NUM_OF_CHANNELS_P - NUM_OF_CHANNELS_I;
  localparam  I_WIDTH = CHANNEL_DATA_WIDTH*NUM_OF_CHANNELS_I;
  localparam  P_WIDTH = CHANNEL_DATA_WIDTH*NUM_OF_CHANNELS_P;
  localparam  M_WIDTH = CHANNEL_DATA_WIDTH*NUM_OF_CHANNELS_M;

  // internal registers

  reg     [  2:0]           adc_samples_int = 'd0;
  reg     [(M_WIDTH-1):0]   adc_data_int = 'd0;
  // internal signals

  wire    [(M_WIDTH-1):0]   adc_data_s;

  // bypass

  generate
  if (NUM_OF_CHANNELS_I == NUM_OF_CHANNELS_P) begin
  assign adc_data_s = 'd0;

  always @(posedge adc_clk) begin
    adc_samples_int <= 'd0;
    adc_data_int <= 'd0;
    if (adc_enable == 1'b1) begin
      adc_dsf_valid <= adc_valid;
      adc_dsf_sync <= 1'b1;
      adc_dsf_data <= adc_data;
    end else begin
      adc_dsf_valid <= 'b0;
      adc_dsf_sync <= 'b0;
      adc_dsf_data <= 'd0;
    end
  end
  end
  endgenerate

  // data store & forward

  generate
  if (NUM_OF_CHANNELS_P > NUM_OF_CHANNELS_I) begin
  reg                       adc_dsf_valid_int = 'd0;
  reg                       adc_dsf_sync_int = 'd0;
  reg     [(P_WIDTH-1):0]   adc_dsf_data_int = 'd0;
  assign adc_data_s[(M_WIDTH-1):I_WIDTH] = 'd0;
  assign adc_data_s[(I_WIDTH-1):0] = adc_data;

  always @(posedge adc_clk) begin
    if (adc_valid == 1'b1) begin
      if (adc_samples_int >= CH_DCNT) begin
        adc_samples_int <= adc_samples_int - CH_DCNT;
      end else begin
        adc_samples_int <= adc_samples_int + NUM_OF_CHANNELS_I;
      end
      adc_data_int <= {adc_data_s[(I_WIDTH-1):0],
        adc_data_int[(M_WIDTH-1):I_WIDTH]};
    end
  end

  always @(posedge adc_clk) begin
    if (adc_samples_int >= CH_DCNT) begin
      adc_dsf_valid_int <= adc_valid;
    end else begin
      adc_dsf_valid_int <= 1'b0;
    end
    if (adc_dsf_sync_int == 1'b1) begin
      if (adc_dsf_valid_int == 1'b1) begin
        adc_dsf_sync_int <= 1'b0;
      end
    end else begin
      if (adc_samples_int == 3'd0) begin
        adc_dsf_sync_int <= 1'b1;
      end
    end
  end

  always @(posedge adc_clk) begin
    if (adc_valid == 1'b1) begin
      case (adc_samples_int)
        3'b111:  adc_dsf_data_int <= {adc_data_s[((CHANNEL_DATA_WIDTH*1)-1):0],
                    adc_data_int[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*1)]};
        3'b110:  adc_dsf_data_int <= {adc_data_s[((CHANNEL_DATA_WIDTH*2)-1):0],
                    adc_data_int[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*2)]};
        3'b101:  adc_dsf_data_int <= {adc_data_s[((CHANNEL_DATA_WIDTH*3)-1):0],
                    adc_data_int[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*3)]};
        3'b100:  adc_dsf_data_int <= {adc_data_s[((CHANNEL_DATA_WIDTH*4)-1):0],
                    adc_data_int[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*4)]};
        3'b011:  adc_dsf_data_int <= {adc_data_s[((CHANNEL_DATA_WIDTH*5)-1):0],
                    adc_data_int[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*5)]};
        3'b010:  adc_dsf_data_int <= {adc_data_s[((CHANNEL_DATA_WIDTH*6)-1):0],
                    adc_data_int[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*6)]};
        3'b001:  adc_dsf_data_int <= {adc_data_s[((CHANNEL_DATA_WIDTH*7)-1):0],
                    adc_data_int[((CHANNEL_DATA_WIDTH*8)-1):(CHANNEL_DATA_WIDTH*7)]};
        3'b000:  adc_dsf_data_int <= adc_data_s;
        default: adc_dsf_data_int <= 'd0;
      endcase
    end
  end

  always @(posedge adc_clk) begin
    if (adc_enable == 1'b1) begin
      adc_dsf_valid <= adc_dsf_valid_int;
      adc_dsf_sync <= adc_dsf_sync_int;
      adc_dsf_data <= adc_dsf_data_int[(P_WIDTH-1):0];
    end else begin
      adc_dsf_valid <= 'b0;
      adc_dsf_sync <= 'b0;
      adc_dsf_data <= 'd0;
    end
  end
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
