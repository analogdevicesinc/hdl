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

module prcfg_adc #(

  parameter   CHANNEL_ID  = 0) (
  input                   clk,

  // control ports
  input       [31:0]      control,
  output  reg [31:0]      status,

  // FIFO interface
  input                   src_adc_enable,
  input                   src_adc_valid,
  input       [15:0]      src_adc_data,

  output  reg             dst_adc_enable,
  output  reg             dst_adc_valid,
  output  reg [15:0]      dst_adc_data);

  localparam  RP_ID       = 8'hA1;

  reg     [15:0]    adc_pn_data       = 0;

  reg     [ 3:0]    mode;
  reg     [ 3:0]    channel_sel;

  wire              adc_dvalid;
  wire    [15:0]    adc_pn_data_s;
  wire              adc_pn_oos_s;
  wire              adc_pn_err_s;

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

  assign adc_dvalid = src_adc_enable & src_adc_valid;

  always @(posedge clk) begin
    channel_sel  <= control[3:0];
    mode         <= control[7:4];
  end

  // prbs generation
  always @(posedge clk) begin
    if(adc_dvalid == 1'b1) begin
      adc_pn_data <= pn(adc_pn_data_s);
    end
  end

  assign adc_pn_data_s = (adc_pn_oos_s == 1'b1) ? src_adc_ddata : adc_pn_data;

  ad_pnmon #(
    .DATA_WIDTH(32)
  ) i_pn_mon (
    .adc_clk(clk),
    .adc_valid_in(adc_dvalid),
    .adc_data_in(src_adc_ddata),
    .adc_data_pn(adc_pn_data),
    .adc_pn_oos(adc_pn_oos_s),
    .adc_pn_err(adc_pn_err_s));

  // rx path are passed through on test mode
  always @(posedge clk) begin
    dst_adc_enable <= src_adc_enable;
    dst_adc_data   <= src_adc_data;
    dst_adc_valid  <= src_adc_valid;
  end

  // setup status bits for gpio_out
  always @(posedge clk) begin
    if((mode == 3'd2) && (channel_sel == CHANNEL_ID)) begin
      status <= {22'h0, adc_pn_err_s, adc_pn_oos_s, RP_ID};
    end else begin
      status <= {24'h0, RP_ID};
    end
  end

endmodule
