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

`timescale 1ns/100ps

module ad_bus_mux #(

  // Channel data width
  parameter DATA_WIDTH = 16) (

  input                    select_path,

  input                    valid_in_0,
  input                    enable_in_0,
  input  [DATA_WIDTH-1:0]  data_in_0,

  input                    valid_in_1,
  input                    enable_in_1,
  input  [DATA_WIDTH-1:0]  data_in_1,

  output                   valid_out,
  output                   enable_out,
  output [DATA_WIDTH-1:0]  data_out);

  assign valid_out  = (select_path == 0) ? valid_in_0   : valid_in_1;
  assign enable_out = (select_path == 0) ? enable_in_0  : enable_in_1;
  assign data_out   = (select_path == 0) ? data_in_0    : data_in_1;

endmodule
