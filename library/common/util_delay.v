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

module util_delay #(

  parameter DATA_WIDTH = 1,
  // the minimum valid value for DELAY_CYCLES is 1
  parameter DELAY_CYCLES = 1) (

  input                             clk,
  input                             reset,
  input                             din,
  output  [DATA_WIDTH-1:0]          dout);

  reg     [DATA_WIDTH-1:0]          dbuf[0:(DELAY_CYCLES-1)];

  always @(posedge clk) begin
    if (reset) begin
      dbuf[0] <= 0;
    end else begin
      dbuf[0] <= din;
    end
  end

  generate
  genvar i;
    for (i = 1; i < DELAY_CYCLES; i=i+1) begin:register_pipe
      always @(posedge clk) begin
        if (reset) begin
          dbuf[i] <= 0;
        end else begin
          dbuf[i] <= dbuf[i-1];
        end
      end
    end
  endgenerate

  assign dout = dbuf[(DELAY_CYCLES-1)];

endmodule
