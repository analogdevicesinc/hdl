// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

// Combinational width adapter: zero-extends into the MSBs when widening,
// discards the MSBs when narrowing, and is a plain wire when the widths match.
// Carries no state and no handshake, so it is safe downstream of a source that
// cannot be back-pressured.

module util_width_extend #(

  parameter IN_DATA_WIDTH = 32,
  parameter OUT_DATA_WIDTH = 32
) (
  input  [IN_DATA_WIDTH-1:0]  data_in,
  output [OUT_DATA_WIDTH-1:0] data_out
);

  generate
    if (OUT_DATA_WIDTH > IN_DATA_WIDTH) begin
      assign data_out = {{OUT_DATA_WIDTH-IN_DATA_WIDTH{1'b0}}, data_in};
    end else if (OUT_DATA_WIDTH < IN_DATA_WIDTH) begin
      // Only where the dropped MSBs are known padding
      assign data_out = data_in[OUT_DATA_WIDTH-1:0];
    end else begin
      assign data_out = data_in;
    end
  endgenerate

endmodule
