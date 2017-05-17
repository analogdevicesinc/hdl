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

`timescale 1ns/100ps

module axi_ad6676_if #(

  parameter DEVICE_TYPE = 0) (

  // jesd interface
  // rx_clk is (line-rate/40)

  input                   rx_clk,
  input       [ 3:0]      rx_sof,
  input       [63:0]      rx_data,

  // adc data output

  output                  adc_clk,
  input                   adc_rst,
  output      [31:0]      adc_data_a,
  output      [31:0]      adc_data_b,
  output                  adc_or_a,
  output                  adc_or_b,
  output  reg             adc_status);


  // internal registers

  // internal signals

  wire    [15:0]  adc_data_a_s1_s;
  wire    [15:0]  adc_data_a_s0_s;
  wire    [15:0]  adc_data_b_s1_s;
  wire    [15:0]  adc_data_b_s0_s;
  wire    [63:0]  rx_data_s;

  // adc clock is the reference clock

  assign adc_clk = rx_clk;
  assign adc_or_a = 1'b0;
  assign adc_or_b = 1'b0;

  // adc channels

  assign adc_data_a = {adc_data_a_s1_s, adc_data_a_s0_s};
  assign adc_data_b = {adc_data_b_s1_s, adc_data_b_s0_s};

  // data multiplex

  assign adc_data_a_s1_s = {rx_data[23:16], rx_data[31:24]};
  assign adc_data_a_s0_s = {rx_data[ 7: 0], rx_data[15: 8]};
  assign adc_data_b_s1_s = {rx_data[55:48], rx_data[63:56]};
  assign adc_data_b_s0_s = {rx_data[39:32], rx_data[47:40]};

  // status

  always @(posedge rx_clk) begin
    if (adc_rst == 1'b1) begin
      adc_status <= 1'b0;
    end else begin
      adc_status <= 1'b1;
    end
  end

  // frame-alignment

  genvar n;

  generate
  for (n = 0; n < 2; n = n + 1) begin: g_xcvr_if
  ad_xcvr_rx_if #(.DEVICE_TYPE (DEVICE_TYPE)) i_xcvr_if (
    .rx_clk (rx_clk),
    .rx_ip_sof (rx_sof),
    .rx_ip_data (rx_data[((n*32)+31):(n*32)]),
    .rx_sof (),
    .rx_data (rx_data_s[((n*32)+31):(n*32)]));
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************

