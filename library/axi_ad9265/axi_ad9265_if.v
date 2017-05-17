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
// This is the LVDS/DDR interface, note that overrange is independent of data path,
// software will not be able to relate overrange to a specific sample!

`timescale 1ns/100ps

module axi_ad9265_if #(

  parameter   DEVICE_TYPE = 0,
  parameter   IO_DELAY_GROUP = "adc_if_delay_group") (

  // adc interface (clk, data, over-range)
  // nominal clock 125 MHz, up to 300 MHz

  input                   adc_clk_in_p,
  input                   adc_clk_in_n,
  input       [ 7:0]      adc_data_in_p,
  input       [ 7:0]      adc_data_in_n,
  input                   adc_or_in_p,
  input                   adc_or_in_n,

  // interface outputs

  output                  adc_clk,
  output  reg [15:0]      adc_data,
  output  reg             adc_or,
  output  reg             adc_status,

  // delay control signals

  input                   up_clk,
  input       [ 8:0]      up_dld,
  input       [44:0]      up_dwdata,
  output      [44:0]      up_drdata,
  input                   delay_clk,
  input                   delay_rst,
  output                  delay_locked);


  // internal registers

  reg     [ 7:0]  adc_data_p = 'd0;
  reg     [ 7:0]  adc_data_n = 'd0;
  reg             adc_or_p = 'd0;
  reg             adc_or_n = 'd0;

  // internal signals

  wire    [ 7:0]  adc_data_p_s;
  wire    [ 7:0]  adc_data_n_s;
  wire            adc_or_p_s;
  wire            adc_or_n_s;

  genvar          l_inst;

  always @(posedge adc_clk)
  begin
    adc_status <= 1'b1;
    adc_or <= adc_or_p_s | adc_or_n_s;
    adc_data <= { adc_data_p_s[7], adc_data_n_s[7], adc_data_p_s[6], adc_data_n_s[6], adc_data_p_s[5], adc_data_n_s[5], adc_data_p_s[4], adc_data_n_s[4], adc_data_p_s[3], adc_data_n_s[3], adc_data_p_s[2], adc_data_n_s[2], adc_data_p_s[1], adc_data_n_s[1], adc_data_p_s[0], adc_data_n_s[0]};
  end

  // data interface

  generate
  for (l_inst = 0; l_inst <= 7; l_inst = l_inst + 1) begin : g_adc_if
  ad_lvds_in #(
    .DEVICE_TYPE (DEVICE_TYPE),
    .IODELAY_CTRL (0),
    .IODELAY_GROUP (IO_DELAY_GROUP))
  i_adc_data (
    .rx_clk (adc_clk),
    .rx_data_in_p (adc_data_in_p[l_inst]),
    .rx_data_in_n (adc_data_in_n[l_inst]),
    .rx_data_p (adc_data_p_s[l_inst]),
    .rx_data_n (adc_data_n_s[l_inst]),
    .up_clk (up_clk),
    .up_dld (up_dld[l_inst]),
    .up_dwdata (up_dwdata[((l_inst*5)+4):(l_inst*5)]),
    .up_drdata (up_drdata[((l_inst*5)+4):(l_inst*5)]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked ());
  end
  endgenerate

  // over-range interface

  ad_lvds_in #(
    .DEVICE_TYPE (DEVICE_TYPE),
    .IODELAY_CTRL (1),
    .IODELAY_GROUP (IO_DELAY_GROUP))
  i_adc_or (
    .rx_clk (adc_clk),
    .rx_data_in_p (adc_or_in_p),
    .rx_data_in_n (adc_or_in_n),
    .rx_data_p (adc_or_p_s),
    .rx_data_n (adc_or_n_s),
    .up_clk (up_clk),
    .up_dld (up_dld[8]),
    .up_dwdata (up_dwdata[44:40]),
    .up_drdata (up_drdata[44:40]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked));

  // clock

  ad_lvds_clk #(
    .DEVICE_TYPE (DEVICE_TYPE))
  i_adc_clk (
    .rst (1'b0),
    .locked (),
    .clk_in_p (adc_clk_in_p),
    .clk_in_n (adc_clk_in_n),
    .clk (adc_clk));

endmodule

// ***************************************************************************
// ***************************************************************************
