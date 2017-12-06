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

module pack_interconnect #(
  parameter PORT_DATA_WIDTH = 16,
  parameter PORT_ADDRESS_WIDTH = 3,
  parameter MUX_ORDER = 2,
  parameter NUM_STAGES = 2,
  parameter PACK = 0 // 0 = Unpack, 1 = Pack
) (
  input [2**PORT_ADDRESS_WIDTH*MUX_ORDER*NUM_STAGES-1:0] ctrl,

  input [PORT_DATA_WIDTH * 2**PORT_ADDRESS_WIDTH-1:0] data_in,
  output [PORT_DATA_WIDTH * 2**PORT_ADDRESS_WIDTH-1:0] data_out
);

localparam MUXES_PER_STAGE = 2**PORT_ADDRESS_WIDTH;
localparam NUM_PORTS = 2**PORT_ADDRESS_WIDTH;
localparam TOTAL_DATA_WIDTH = PORT_DATA_WIDTH * NUM_PORTS;

wire [TOTAL_DATA_WIDTH-1:0] interconnect[0:NUM_STAGES];

generate
genvar i, j;

if (PACK == 1) begin
  assign interconnect[NUM_STAGES] = data_in;
  assign data_out = interconnect[0];
end else begin
  assign interconnect[0] = data_in;
  assign data_out = interconnect[NUM_STAGES];
end

localparam z = 2**MUX_ORDER;

/* Do perfect shuffle, either in forward or reverse direction */
for (i = 0; i < NUM_STAGES; i = i + 1) begin
  wire [TOTAL_DATA_WIDTH-1:0] inter = interconnect[i];

  for (j = 0; j < MUXES_PER_STAGE; j = j + 1) begin
    localparam w = PORT_DATA_WIDTH;

    wire [MUX_ORDER-1:0] sel = ctrl[(i*MUXES_PER_STAGE+j)*MUX_ORDER+:MUX_ORDER] + j % z;

    if (PACK == 1) begin
      localparam k = j * NUM_PORTS / z;
      localparam dst_lsb = k % NUM_PORTS + k / NUM_PORTS;
      assign interconnect[i][dst_lsb*w+:w] = interconnect[i+1][(j/z*z+sel)*w+:w];
    end else begin
      localparam k = NUM_PORTS / z;
      assign interconnect[i+1][j*w+:w] = interconnect[i][(j/z+sel*k)*w+:w];
    end
  end
end

endgenerate

endmodule
