// ***************************************************************************
// ***************************************************************************
// Copyright 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsabilities that he or she has by using this source/core.
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

module pack_ctrl #(
  parameter PORT_ADDRESS_WIDTH = 2,
  parameter MUX_ORDER = 1,
  parameter MIN_STAGE = 0,
  parameter NUM_STAGES = 2
) (
  input [PORT_ADDRESS_WIDTH-1:0] rotate,

  input [2**PORT_ADDRESS_WIDTH-1:0] enable,
  output [2**PORT_ADDRESS_WIDTH*MUX_ORDER*NUM_STAGES-1:0] ctrl,
  output [PORT_ADDRESS_WIDTH:0] enable_count
);

localparam NUM_OF_PORTS = 2**PORT_ADDRESS_WIDTH;

wire [PORT_ADDRESS_WIDTH-1:0] prefix_count[0:NUM_OF_PORTS];

generate
genvar i, j;

assign prefix_count[0] = 0;

for (i = 0; i < 2**PORT_ADDRESS_WIDTH; i = i + 1) begin
  assign prefix_count[i+1] = prefix_count[i] + (enable[i] ? 1'b0 : 1'b1);
end

localparam z = 2**MUX_ORDER;

for (i = 0; i < NUM_STAGES; i = i + 1) begin
  for (j = 0; j < NUM_OF_PORTS; j = j + 1) begin
    localparam k0 = z**((PORT_ADDRESS_WIDTH+MUX_ORDER-1)/MUX_ORDER-1-i-MIN_STAGE);
    localparam k1 = z**(1+i+MIN_STAGE);
    localparam m = (j % k1) * k0;
    localparam n = j / k1;

    if (MUX_ORDER == 1 && j % 2) begin
      assign ctrl[i*NUM_OF_PORTS+j] = ctrl[i*NUM_OF_PORTS+j-1]; // This optimization only works for 2:1 MUXes
    end else begin
      assign ctrl[(i*NUM_OF_PORTS+j)*MUX_ORDER+:MUX_ORDER] = z - (prefix_count[m] + n - rotate) / k0;
    end
  end
end
endgenerate

assign enable_count = NUM_OF_PORTS - prefix_count[NUM_OF_PORTS];

endmodule
