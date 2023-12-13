// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

module jesd204_phy_glue #(
  parameter WIDTH = 20,
  parameter CONST_WIDTH = 1,
  parameter NUM_OF_LANES = 1,
  parameter LANE_INVERT = 0
) (
  input [WIDTH-1:0] in,
  output [WIDTH-1:0] out,
  output [CONST_WIDTH-1:0] const_out,
  output [NUM_OF_LANES-1:0] polinv
);

/* There really should be a standard component in Qsys that allows to do this */

  assign out = in;
  assign const_out = {CONST_WIDTH{1'b0}};
  assign polinv = LANE_INVERT[NUM_OF_LANES-1:0];

endmodule
