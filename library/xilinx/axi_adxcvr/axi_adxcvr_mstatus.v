// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/1ps

module axi_adxcvr_mstatus (

  input           up_rstn,
  input           up_clk,

  input           up_pll_locked_in,
  input           up_rst_done_in,
  input           up_prbserr_in,
  input           up_prbslocked_in,
  input   [ 1:0]  up_bufstatus_in,
  input           up_pll_locked,
  input           up_rst_done,
  input           up_prbserr,
  input           up_prbslocked,
  input   [ 1:0]  up_bufstatus,
  output          up_pll_locked_out,
  output          up_rst_done_out,
  output          up_prbserr_out,
  output          up_prbslocked_out,
  output  [ 1:0]  up_bufstatus_out
);

  // parameters

  parameter   integer XCVR_ID = 0;
  parameter   integer NUM_OF_LANES = 8;

  // internal registers

  reg             up_pll_locked_int = 'd0;
  reg             up_rst_done_int = 'd0;
  reg             up_prbserr_int = 'd0;
  reg             up_prbslocked_int = 'd0;
  reg     [ 1:0]  up_bufstatus_int = 2'd00;

  // internal signals

  wire            up_pll_locked_s;
  wire            up_rst_done_s;
  wire            up_prbserr_s;
  wire            up_prbslocked_s;
  wire    [ 1:0]  up_bufstatus_s;

  // daisy-chain the signals

  assign up_pll_locked_out = up_pll_locked_int;
  assign up_rst_done_out = up_rst_done_int;
  assign up_prbserr_out = up_prbserr_int;
  assign up_prbslocked_out = up_prbslocked_int;
  assign up_bufstatus_out = up_bufstatus_int;

  assign up_pll_locked_s = (XCVR_ID < NUM_OF_LANES) ? up_pll_locked : 1'b1;
  assign up_rst_done_s = (XCVR_ID < NUM_OF_LANES) ? up_rst_done : 1'b1;
  assign up_prbserr_s = (XCVR_ID < NUM_OF_LANES) ? up_prbserr : 1'b0;
  assign up_prbslocked_s = (XCVR_ID < NUM_OF_LANES) ? up_prbslocked : 1'b1;
  assign up_bufstatus_s = (XCVR_ID < NUM_OF_LANES) ? up_bufstatus : 2'b00;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_pll_locked_int <= 1'd0;
      up_rst_done_int <= 1'd0;
      up_prbserr_int <= 1'd0;
      up_prbslocked_int <= 1'd0;
      up_bufstatus_int <= 2'd00;
    end else begin
      up_pll_locked_int <= up_pll_locked_in & up_pll_locked_s;
      up_rst_done_int <= up_rst_done_in & up_rst_done_s;
      up_prbserr_int <= up_prbserr_in | up_prbserr_s;
      up_prbslocked_int <= up_prbslocked_in & up_prbslocked_s;
      up_bufstatus_int[0] <= up_bufstatus_in[0] | up_bufstatus_s[0];
      up_bufstatus_int[1] <= up_bufstatus_in[1] | up_bufstatus_s[1];
    end
  end

endmodule
