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

`timescale 1ns/1ps

module ad_cmos_out_core_c5 (

  // data interface

  input               clk,
  input   [ 1:0]      din,
  output              pad_out);

  // instantiations

  altddio_out #(
    .width (1),
    .lpm_hint ("UNUSED"))
  i_altddio_out (
    .outclock (clk),
    .datain_h (din[1]),
    .datain_l (din[0]),
    .dataout (pad_out),
    .outclocken (1'b1),
    .oe_out (),
    .oe (1'b1),
    .aclr (1'b0),
    .aset (1'b0),
    .sclr (1'b0),
    .sset (1'b0));

endmodule

// ***************************************************************************
// ***************************************************************************
