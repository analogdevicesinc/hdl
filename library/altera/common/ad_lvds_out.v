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

module ad_lvds_out #(

  parameter   DEVICE_TYPE = 0,
  parameter   SINGLE_ENDED = 0,
  parameter   IODELAY_ENABLE = 0,
  parameter   IODELAY_CTRL = 0,
  parameter   IODELAY_GROUP = "dev_if_delay_group") (

  // data interface

  input                   tx_clk,
  input                   tx_data_p,
  input                   tx_data_n,
  output                  tx_data_out_p,
  output                  tx_data_out_n,

  // delay-data interface

  input                   up_clk,
  input                   up_dld,
  input       [ 4:0]      up_dwdata,
  output      [ 4:0]      up_drdata,

  // delay-cntrl interface

  input                   delay_clk,
  input                   delay_rst,
  output                  delay_locked);


  // defaults

  assign up_drdata = 5'd0;
  assign delay_locked = 1'b1;

  // instantiations

  generate
  if (DEVICE_TYPE == 0) begin
  alt_ddio_out i_tx_data_oddr (
    .ck (tx_clk),
    .din ({tx_data_p, tx_data_n}),
    .pad_out (tx_data_out_p));
  end
  endgenerate

  generate
  if (DEVICE_TYPE == 1) begin
  altddio_out #(.width (1), .lpm_hint ("UNUSED")) i_tx_data_oddr (
    .outclock (tx_clk),
    .datain_h (tx_data_p),
    .datain_l (tx_data_n),
    .dataout (tx_data_out_p),
    .outclocken (1'b1),
    .oe_out (),
    .oe (1'b1),
    .aclr (1'b0),
    .aset (1'b0),
    .sclr (1'b0),
    .sset (1'b0));
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
