// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

// A simple edge detector circuit

`timescale 1ns/100ps

module ad_edge_detect #(

  parameter   EDGE = 0
) (
  input                   clk,
  input                   rst,

  input                   signal_in,
  output  reg             signal_out
);

  localparam  POS_EDGE = 0;
  localparam  NEG_EDGE = 1;
  localparam  ANY_EDGE = 2;

  reg         ff_m1 = 0;
  reg         ff_m2 = 0;

  always @(posedge clk) begin
    if (rst == 1) begin
      ff_m1 <= 0;
      ff_m2 <= 0;
    end else begin
      ff_m1 <= signal_in;
      ff_m2 <= ff_m1;
    end
  end

  always @(posedge clk) begin
    if (rst == 1) begin
      signal_out <= 1'b0;
    end else begin
      if (EDGE == POS_EDGE) begin
        signal_out <= ff_m1 & ~ff_m2;
      end else if (EDGE == NEG_EDGE) begin
        signal_out <= ~ff_m1 & ff_m2;
      end else begin
        signal_out <= ff_m1 ^ ff_m2;
      end
    end
  end

endmodule
