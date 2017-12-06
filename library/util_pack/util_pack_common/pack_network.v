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

`timescale 1ns/100ps

module pack_network #(
  parameter PORT_ADDRESS_WIDTH = 1,
  parameter MUX_ORDER = 1,
  parameter MIN_STAGE = 1,
  parameter NUM_STAGES = 1,
  parameter PACK = 0,
  parameter PORT_DATA_WIDTH = 16
) (
  input clk,
  input ce_ctrl,

  input [PORT_ADDRESS_WIDTH-1:0] rotate,
  input [2**PORT_ADDRESS_WIDTH*PORT_ADDRESS_WIDTH-1:0] prefix_count,

  input [PORT_DATA_WIDTH * 2**PORT_ADDRESS_WIDTH-1:0] data_in,
  output [PORT_DATA_WIDTH * 2**PORT_ADDRESS_WIDTH-1:0] data_out
);

  localparam CTRL_WIDTH = 2**PORT_ADDRESS_WIDTH * NUM_STAGES * MUX_ORDER;

  wire [CTRL_WIDTH-1:0] ctrl_s;
  reg [CTRL_WIDTH-1:0] ctrl = 'h00;
  wire [CTRL_WIDTH-1:0] ctrl_;

  pack_ctrl #(
    .PORT_ADDRESS_WIDTH (PORT_ADDRESS_WIDTH),
    .MUX_ORDER (MUX_ORDER),
    .MIN_STAGE (MIN_STAGE),
    .NUM_STAGES (NUM_STAGES),
    .PACK (PACK)
  ) i_ctrl (
    .rotate(rotate),
    .prefix_count(prefix_count),
    .ctrl(ctrl_s)
  );

  always @(posedge clk) begin
    if (ce_ctrl == 1'b1) begin
      ctrl <= ctrl_s;
    end
  end

  /*
   * Special optimization for 2-MUXes. In this case both control signals are
   * the same.
   */
  generate
    genvar i;
    if (MUX_ORDER == 1) begin
      for (i = 1; i < CTRL_WIDTH; i = i + 2) begin: gen_ctrl
        assign ctrl_[i] = ctrl[i];
        assign ctrl_[i-1] = ~ctrl[i];
      end
    end else begin
      assign ctrl_ = ctrl;
    end
  endgenerate

  pack_interconnect #(
    .PORT_DATA_WIDTH (PORT_DATA_WIDTH),
    .PORT_ADDRESS_WIDTH (PORT_ADDRESS_WIDTH),
    .MUX_ORDER (MUX_ORDER),
    .NUM_STAGES (NUM_STAGES),
    .PACK (PACK)
  ) i_interconnect (
    .ctrl(ctrl_),

    .data_in(data_in),
    .data_out(data_out)
  );

endmodule
