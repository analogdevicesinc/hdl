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

`timescale 1ns/1ps

module axi_adxcvr_mstatus (

  input           up_rstn,
  input           up_clk,

  input           up_pll_locked_in,
  input           up_rst_done_in,
  input           up_pll_locked,
  input           up_rst_done,
  output          up_pll_locked_out,
  output          up_rst_done_out);

  // parameters

  parameter   integer XCVR_ID = 0;
  parameter   integer NUM_OF_LANES = 8;

  // internal registers

  reg             up_pll_locked_int = 'd0;
  reg             up_rst_done_int = 'd0;

  // internal signals

  wire            up_pll_locked_s;
  wire            up_rst_done_s;

  // daisy-chain the signals

  assign up_pll_locked_out = up_pll_locked_int;
  assign up_rst_done_out = up_rst_done_int;

  assign up_pll_locked_s = (XCVR_ID < NUM_OF_LANES) ? up_pll_locked : 1'b1;
  assign up_rst_done_s = (XCVR_ID < NUM_OF_LANES) ? up_rst_done : 1'b1;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_pll_locked_int <= 1'd0;
      up_rst_done_int <= 1'd0;
    end else begin
      up_pll_locked_int <= up_pll_locked_in & up_pll_locked_s;
      up_rst_done_int <= up_rst_done_in & up_rst_done_s;
    end
  end

endmodule     

// ***************************************************************************
// ***************************************************************************

