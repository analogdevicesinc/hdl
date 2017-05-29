// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// This core  is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory of
//      the repository (LICENSE_GPL2), and at: <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license as noted in the top level directory, or on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad_lvds_clk #(

  parameter   DEVICE_TYPE   = 0) (

  input                   rst,
  output                  locked,

  input                   clk_in_p,
  input                   clk_in_n,
  output                  clk);

  localparam  SERIES7       = 0;
  localparam  VIRTEX6       = 1;

  // wires

  wire      clk_ibuf_s;

  // defaults

  assign locked = 1'b1;

  // instantiations

  IBUFGDS i_rx_clk_ibuf (
    .I (clk_in_p),
    .IB (clk_in_n),
    .O (clk_ibuf_s));

  generate
  if (DEVICE_TYPE == VIRTEX6) begin
  BUFR #(.BUFR_DIVIDE("BYPASS")) i_clk_rbuf (
    .CLR (1'b0),
    .CE (1'b1),
    .I (clk_ibuf_s),
    .O (clk));
  end else begin
  BUFG i_clk_gbuf (
    .I (clk_ibuf_s),
    .O (clk));
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
