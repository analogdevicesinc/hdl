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

module util_rst_chain #(

  // Number of synchronization stages, if the design is fast, multiple stages
  // should be used to ensure that the output isn't in a metastable state
  parameter ASYNC_STAGES = 2,
  // Number of reset signals to synchronize in the chain
  parameter NUM_OF_RESET = 2
) (

  // clock reset

  input                     rst_async,
  input  [NUM_OF_RESET-1:0] clk,
  output [NUM_OF_RESET-1:0] rstn,
  output [NUM_OF_RESET-1:0] rst
);

  initial begin
    if (ASYNC_STAGES < 2) begin
      $error("The number of asynchronous stages registering the reset shouldn't be at least 2!");
      $finish;
    end
  end

  integer j;

  generate

    genvar i;

    wire [NUM_OF_RESET-1:0] cdc_async_stage_d;

    for (i = 0; i < NUM_OF_RESET; i = i + 1) begin
      // internal registers
      reg [ASYNC_STAGES-1:0] cdc_async_stage = {ASYNC_STAGES{1'b1}};

      // simple reset synchronizer
      always @(posedge clk[i] or posedge rst_async) begin
        if (rst_async) begin
          cdc_async_stage <= {ASYNC_STAGES{1'b1}};
        end else begin
          if (i == 0) begin
            cdc_async_stage[0] <= 1'b0;
          end else begin
            cdc_async_stage[0] <= cdc_async_stage_d[i-1];
          end
          for (j = 1; j < ASYNC_STAGES; j = j + 1) begin
            cdc_async_stage[j] <= cdc_async_stage[j-1];
          end
        end
      end

      assign cdc_async_stage_d[i] = cdc_async_stage[ASYNC_STAGES-1];
    end

    for (i = 0; i < NUM_OF_RESET; i = i + 1) begin
      wire rst_s;

      assign rst_s = (i == 0) ? 1'b0 : rst[i-1];

      util_rst #(
        .ASYNC_STAGES(2),
        .SYNC_STAGES(2)
      ) i_cdc_async_stage_sync (
        .rst_async(cdc_async_stage_d[NUM_OF_RESET-1] || rst_s),
        .clk(clk[i]),
        .rstn(rstn[i]),
        .rst(rst[i]));
    end

  endgenerate

endmodule
