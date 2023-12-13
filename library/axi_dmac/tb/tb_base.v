// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2018-2023 Analog Devices, Inc. All rights reserved.
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

  reg clk = 1'b0;
  reg [3:0] reset_shift = 4'b1111;
  reg trigger_reset = 1'b0;
  wire reset;
  wire resetn = ~reset;

  reg failed = 1'b0;

  initial
  begin
    $dumpfile (VCD_FILE);
    $dumpvars;
`ifdef TIMEOUT
    #`TIMEOUT
`else
    #100000
`endif
    if (failed == 1'b0)
      $display("SUCCESS");
    else
      $display("FAILED");
    $finish;
  end

  always @(*) #10 clk <= ~clk;
  always @(posedge clk) begin
    if (trigger_reset == 1'b1) begin
      reset_shift <= 3'b111;
    end else begin
      reset_shift <= {reset_shift[2:0],1'b0};
    end
  end

  assign reset = reset_shift[3];

  task do_trigger_reset;
  begin
    @(posedge clk) trigger_reset <= 1'b1;
    @(posedge clk) trigger_reset <= 1'b0;
  end
  endtask
