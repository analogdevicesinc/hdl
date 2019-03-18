// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2018 (c) Analog Devices, Inc. All rights reserved.
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

module io_vip #(
  parameter WIDTH = 1
)(
  // System Signals
  input  clk,
  input  in = 1'b0,
  output out
);

  logic mode = 0; // 1 - driver, 0 - monitor

  io_vip_if #(WIDTH) IF (.CLK(clk));

  assign IF.IO = mode ? 'hz : in;
  assign out = IF.IO;

  function void set_driver_mode();
    mode = 1;
    IF.set_intf_driver();
  endfunction

  function void set_monitor_mode();
    mode = 0;
    IF.set_intf_monitor();
  endfunction

endmodule
