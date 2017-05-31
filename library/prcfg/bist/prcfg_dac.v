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

`timescale 1ns/1ns

module prcfg_dac#(

  parameter   CHANNEL_ID = 0) (

  input                   clk,

  // control ports
  input       [31:0]      control,
  output  reg [31:0]      status,

  // FIFO interface
  output  reg             src_dac_enable,
  input       [15:0]      src_dac_data,
  output  reg             src_dac_valid,

  input                   dst_dac_enable,
  output  reg [15:0]      dst_dac_data,
  input                   dst_dac_valid);

  localparam  RP_ID      = 8'hA1;

  reg     [15:0]    dac_prbs       = 32'hA2F19C;

  reg     [ 2:0]    counter        = 0;
  reg               pattern        = 0;
  reg     [15:0]    sin_tone       = 0;
  reg     [15:0]    cos_tone       = 0;

  reg     [ 3:0]    mode;

  wire    [15:0]    dac_pattern_s;

  // prbs function
  function [15:0] pn;
    input [15:0] din;
    reg   [15:0] dout;
    begin
      dout[15] = din[14] ^ din[15];
      dout[14] = din[13] ^ din[14];
      dout[13] = din[12] ^ din[13];
      dout[12] = din[11] ^ din[12];
      dout[11] = din[10] ^ din[11];
      dout[10] = din[ 9] ^ din[10];
      dout[ 9] = din[ 8] ^ din[ 9];
      dout[ 8] = din[ 7] ^ din[ 8];
      dout[ 7] = din[ 6] ^ din[ 7];
      dout[ 6] = din[ 5] ^ din[ 6];
      dout[ 5] = din[ 4] ^ din[ 5];
      dout[ 4] = din[ 3] ^ din[ 4];
      dout[ 3] = din[ 2] ^ din[ 3];
      dout[ 2] = din[ 1] ^ din[ 2];
      dout[ 1] = din[ 0] ^ din[ 1];
      dout[ 0] = din[14] ^ din[15] ^ din[ 0];
      pn = dout;
    end
  endfunction

  always @(posedge clk) begin
    status <= {24'h0, RP_ID};
    mode   <= control[7:4];
  end

  // sine tone generation
  always @(posedge clk) begin
    if ((dst_dac_enable == 1'h1) && (dst_dac_valid == 1'h1)) begin
      counter <= counter + 1;
    end
  end

  always @(counter) begin
    case(counter)
      3'd0  : begin
                sin_tone <= 16'h0000;
                cos_tone <= 16'h7FFF;
              end
      3'd1  : begin
                sin_tone <= 16'h5A82;
                cos_tone <= 16'h5A82;
              end
      3'd2  : begin
                sin_tone <= 16'h7FFF;
                cos_tone <= 16'h0000;
              end
      3'd3  : begin
                sin_tone <= 16'h5A82;
                cos_tone <= 16'hA57E;
              end
      3'd4  : begin
                sin_tone <= 16'h0000;
                cos_tone <= 16'h8001;
              end
      3'd5  : begin
                sin_tone <= 16'hA57E;
                cos_tone <= 16'hA57E;
              end
      3'd6  : begin
                sin_tone <= 16'h8001;
                cos_tone <= 16'h0000;
              end
      3'd7  : begin
                sin_tone <= 16'hA57E;
                cos_tone <= 16'h5A82;
              end
    endcase
  end

  // prbs generation
  always @(posedge clk) begin
    if((dst_dac_enable == 1'h1) && (dst_dac_valid == 1'h1)) begin
      dac_prbs <= pn(dac_prbs);
    end
  end

  // constant pattern generator
  always @(posedge clk) begin
    if((dst_dac_enable == 1'h1) && (dst_dac_valid == 1'h1)) begin
      pattern <= ~pattern;
    end
  end

  assign dac_pattern_s = (pattern == 1'h1) ? 16'h5555 : 16'hAAAA;

  // output mux for tx side
  always @(posedge clk) begin
    src_dac_enable <= dst_dac_enable;
    src_dac_valid  <= (mode == 0) ? dst_dac_valid  : 1'b0;
  end

  always @(posedge clk) begin
    case(mode)
      4'h0    : begin
                  dst_dac_data <= src_dac_data;
                end
      4'h1    : begin
                  dst_dac_data <= {cos_tone, sin_tone};
                end
      4'h2    : begin
                  dst_dac_data <= dac_prbs;
                end
      4'h3    : begin
                  dst_dac_data <= dac_pattern_s;
                end
      default : begin
                  dst_dac_data <= src_dac_data;
                end
    endcase
  end
endmodule
