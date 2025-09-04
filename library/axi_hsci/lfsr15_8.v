// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/1ps

module lfsr15_8 (
  input clk,
  input rstn,
  input en,
  output [7:0] pn_out
);

  wire stuck;
  reg [14:0] lfsr;

  assign stuck = &lfsr;

   // LFSR that produces 8 bits per cycle
  always @ (posedge clk or negedge rstn) begin
    if (rstn == 0)
      lfsr[14:0] <= 15'h7fff;
    else begin
      if (en) begin
	      lfsr[14:9] <= lfsr[6:1];
        lfsr[8]    <= (stuck == 1'b1) ? 1: lfsr[0];
        lfsr[7]    <= lfsr[14] ^ lfsr[13];
        lfsr[6]    <= lfsr[13] ^ lfsr[12];
        lfsr[5]    <= lfsr[12] ^ lfsr[11];
        lfsr[4]    <= lfsr[11] ^ lfsr[10];
        lfsr[3]    <= lfsr[10] ^ lfsr[9];
        lfsr[2]    <= lfsr[9]  ^ lfsr[8];
        lfsr[1]    <= lfsr[8]  ^ lfsr[7];
        lfsr[0]    <= lfsr[7]  ^ lfsr[6];
      end else
        lfsr <= lfsr;
    end
  end

  assign pn_out = lfsr[7:0];

endmodule
