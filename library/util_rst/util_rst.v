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

`timescale 1ns/100ps

module util_rst #(

  // Number of synchronization stages, if the design is fast, multiple stages
  // should be used to ensure that the output isn't in a metastable state
  parameter ASYNC_STAGES = 2,
  // Number of synchronization stages, if the design is fast, multiple stages
  // should be used to ensure that the output isn't in a metastable state
  parameter SYNC_STAGES = 2
) (

  // clock reset

  input                   rst_async,
  input                   clk,
  output reg              rstn,
  output reg              rst
);

  // internal registers
  reg [ASYNC_STAGES-1:0] cdc_async_stage = {ASYNC_STAGES{1'b1}};

  wire cdc_sync_stage;

  integer i;

  // simple asynchronous reset block
  always @(posedge clk or posedge rst_async) begin
    if (rst_async) begin
      cdc_async_stage <= {ASYNC_STAGES{1'b1}};
    end else begin
      cdc_async_stage[0] <= 1'b0;
      for (i = 1; i < ASYNC_STAGES; i = i + 1) begin
        cdc_async_stage[i] <= cdc_async_stage[i-1];
      end
    end
  end

  // synchronize the asynchronous reset
  sync_bits #(
    .NUM_OF_BITS(1),
    .ASYNC_CLK(1),
    .SYNC_STAGES(SYNC_STAGES)
  ) i_cdc_async_stage_sync (
    .out_clk(clk),
    .out_resetn(1'b1),
    .in_bits(cdc_async_stage[ASYNC_STAGES-1]),
    .out_bits(cdc_sync_stage));

  // synchronize the active high and low resets
  always @(posedge clk) begin
    rst <= cdc_sync_stage;
    rstn <= ~cdc_sync_stage;
  end

endmodule
