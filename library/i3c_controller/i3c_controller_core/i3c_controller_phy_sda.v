// ***************************************************************************
// ***************************************************************************
// Copyright 2023 (c) Analog Devices, Inc. All rights reserved.
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
/**
 * Tristate, p 'HIGH for push-pull SDA, and 'LOW for open-drain.
 */

`timescale 1ns/100ps
`default_nettype none

module i3c_controller_phy_sda (
  output wire sdo,
  input  wire sdi,
  input  wire t,
  inout  wire sda
);
  // TODO: Add Intel tristate primitive, select dependin on target.
  IOBUF #(
  ) IOBUF_inst (
     .O(sdo),
     .IO(sda),
     .I(sdi),
     .T(t)
  );
  // Same as, but sometimes Xilinx was not inferring IOBUF from this...
  //assign sda = ~t ? sdi : 1'bZ;
  //assign sdo = sda;
endmodule
