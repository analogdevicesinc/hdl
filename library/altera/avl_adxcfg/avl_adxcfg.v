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

`timescale 1ns/1ps

module avl_adxcfg (

  // reconfig sharing

  input           rcfg_clk,
  input           rcfg_reset_n,

  input           rcfg_in_read_0,
  input           rcfg_in_write_0,
  input   [ 9:0]  rcfg_in_address_0,
  input   [31:0]  rcfg_in_writedata_0,
  output  [31:0]  rcfg_in_readdata_0,
  output          rcfg_in_waitrequest_0,

  input           rcfg_in_read_1,
  input           rcfg_in_write_1,
  input   [ 9:0]  rcfg_in_address_1,
  input   [31:0]  rcfg_in_writedata_1,
  output  [31:0]  rcfg_in_readdata_1,
  output          rcfg_in_waitrequest_1,

  output          rcfg_out_read_0,
  output          rcfg_out_write_0,
  output  [ 9:0]  rcfg_out_address_0,
  output  [31:0]  rcfg_out_writedata_0,
  input   [31:0]  rcfg_out_readdata_0,
  input           rcfg_out_waitrequest_0,

  output          rcfg_out_read_1,
  output          rcfg_out_write_1,
  output  [ 9:0]  rcfg_out_address_1,
  output  [31:0]  rcfg_out_writedata_1,
  input   [31:0]  rcfg_out_readdata_1,
  input           rcfg_out_waitrequest_1);

  // internal registers

  reg     [ 1:0]  rcfg_select = 'd0;
  reg             rcfg_read_int = 'd0;
  reg             rcfg_write_int = 'd0;
  reg     [ 9:0]  rcfg_address_int = 'd0;
  reg     [31:0]  rcfg_writedata_int = 'd0;
  reg     [31:0]  rcfg_readdata_int = 'd0;
  reg             rcfg_waitrequest_int_0 = 'd1;
  reg             rcfg_waitrequest_int_1 = 'd1;

  // internal signals

  wire    [31:0]  rcfg_readdata_s;
  wire            rcfg_waitrequest_s;

  // xcvr sharing requires same bus (sw must make sure they are mutually exclusive access).

  assign rcfg_out_read_0 = rcfg_read_int;
  assign rcfg_out_write_0 = rcfg_write_int;
  assign rcfg_out_address_0 = rcfg_address_int;
  assign rcfg_out_writedata_0 = rcfg_writedata_int;
  assign rcfg_out_read_1 = rcfg_read_int;
  assign rcfg_out_write_1 = rcfg_write_int;
  assign rcfg_out_address_1 = rcfg_address_int;
  assign rcfg_out_writedata_1 = rcfg_writedata_int;
  assign rcfg_in_readdata_0 = rcfg_readdata_int;
  assign rcfg_in_readdata_1 = rcfg_readdata_int;
  assign rcfg_in_waitrequest_0 = rcfg_waitrequest_int_0;
  assign rcfg_in_waitrequest_1 = rcfg_waitrequest_int_1;

  assign rcfg_readdata_s = rcfg_out_readdata_1 & rcfg_out_readdata_0;
  assign rcfg_waitrequest_s = rcfg_out_waitrequest_1 & rcfg_out_waitrequest_0;

  always @(negedge rcfg_reset_n or posedge rcfg_clk) begin
    if (rcfg_reset_n == 0) begin
      rcfg_select <= 2'd0;
      rcfg_read_int <= 1'd0;
      rcfg_write_int <= 1'd0;
      rcfg_address_int <= 10'd0;
      rcfg_writedata_int <= 32'd0;
      rcfg_readdata_int <= 32'd0;
      rcfg_waitrequest_int_0 <= 1'b1;
      rcfg_waitrequest_int_1 <= 1'b1;
    end else begin
      if (rcfg_select[1] == 1'b1) begin
        if (rcfg_waitrequest_s == 1'b0) begin
          rcfg_select <= 2'd0;
          rcfg_read_int <= 1'b0;
          rcfg_write_int <= 1'b0;
          rcfg_address_int <= 10'd0;
          rcfg_writedata_int <= 32'd0;
        end
        rcfg_readdata_int <= rcfg_readdata_s;
        rcfg_waitrequest_int_0 <= rcfg_waitrequest_s | rcfg_select[0];
        rcfg_waitrequest_int_1 <= rcfg_waitrequest_s | ~rcfg_select[0];
      end else if ((rcfg_in_read_0 == 1'b1) || (rcfg_in_write_0 == 1'b1)) begin
        rcfg_select <= 2'b10;
        rcfg_read_int <= rcfg_in_read_0;
        rcfg_write_int <= rcfg_in_write_0;
        rcfg_address_int <= rcfg_in_address_0;
        rcfg_writedata_int <= rcfg_in_writedata_0;
        rcfg_readdata_int <= 32'd0;
        rcfg_waitrequest_int_0 <= 1'b1;
        rcfg_waitrequest_int_1 <= 1'b1;
      end else if ((rcfg_in_read_1 == 1'b1) || (rcfg_in_write_1 == 1'b1)) begin
        rcfg_select <= 2'b11;
        rcfg_read_int <= rcfg_in_read_1;
        rcfg_write_int <= rcfg_in_write_1;
        rcfg_address_int <= rcfg_in_address_1;
        rcfg_writedata_int <= rcfg_in_writedata_1;
        rcfg_readdata_int <= 32'd0;
        rcfg_waitrequest_int_0 <= 1'b1;
        rcfg_waitrequest_int_1 <= 1'b1;
      end else begin
        rcfg_select <= 2'd0;
        rcfg_read_int <= 1'd0;
        rcfg_write_int <= 1'd0;
        rcfg_address_int <= 10'd0;
        rcfg_writedata_int <= 32'd0;
        rcfg_readdata_int <= 32'd0;
        rcfg_waitrequest_int_0 <= 1'b1;
        rcfg_waitrequest_int_1 <= 1'b1;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************

