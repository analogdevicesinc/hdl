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

module prcfg_dac#(

  parameter   CHANNEL_ID  = 0) (

  input                   clk,

  // control ports
  input       [31:0]      control,
  output      [31:0]      status,

  // FIFO interface
  output  reg             src_dac_enable,
  input       [15:0]      src_dac_data,
  output  reg             src_dac_valid,

  input                   dst_dac_enable,
  output  reg [15:0]      dst_dac_data,
  input                   dst_dac_valid);

  localparam  RP_ID       = 8'hA0;

  assign status = {24'h0, RP_ID};

  always @(posedge clk) begin
    src_dac_enable  <= dst_dac_enable;
    dst_dac_data    <= src_dac_data;
    src_dac_valid   <= dst_dac_valid;
  end
endmodule
