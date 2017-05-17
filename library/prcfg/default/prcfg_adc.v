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

`timescale 1ns/1ns

module prcfg_adc #(

  parameter   CHANNEL_ID  = 0) (
  input                   clk,

  // control ports
  input       [31:0]      control,
  output      [31:0]      status,

  // FIFO interface
  input                   src_adc_enable,
  input                   src_adc_valid,
  input       [15:0]      src_adc_data,

  output  reg             dst_adc_enable,
  output  reg             dst_adc_valid,
  output  reg [15:0]      dst_adc_data);

  localparam  RP_ID       = 8'hA0;

  assign status = {24'h0, RP_ID};

  always @(posedge clk) begin
    dst_adc_enable <= src_adc_enable;
    dst_adc_valid <= src_adc_valid;
    dst_adc_data <= src_adc_data;
  end
endmodule
