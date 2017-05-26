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

module axi_ad9361_cmos_out #(

  parameter   DEVICE_TYPE = 0) (

  // data interface

  input               tx_clk,
  input               tx_data_p,
  input               tx_data_n,
  output              tx_data_out);

  // local parameter

  localparam ARRIA10 = 0;
  localparam CYCLONE5 = 1;

  // instantiations

  generate

  if (DEVICE_TYPE == ARRIA10) begin
  axi_ad9361_cmos_out_core i_tx_data_oddr (
    .clk_export (tx_clk),
    .din_export ({tx_data_p, tx_data_n}),
    .pad_out_export (tx_data_out));
  end

  if (DEVICE_TYPE == CYCLONE5) begin
  altddio_out #(
    .width (1),
    .lpm_hint ("UNUSED"))
  i_altddio_out (
    .outclock (tx_clk),
    .datain_h (tx_data_p),
    .datain_l (tx_data_n),
    .dataout (tx_data_out),
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
