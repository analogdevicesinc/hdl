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

/*
 * Helper module for synchronizing a counter from one clock domain to another
 * using gray code. To work correctly the counter must not change its value by
 * more than one in one clock cycle in the source domain. I.e. the value may
 * change by either -1, 0 or +1.
 */

`timescale 1ns/100ps

module sync_gray #(

  // Bit-width of the counter
  parameter DATA_WIDTH = 1,
  // Whether the input and output clock are asynchronous, if set to 0 the
  // synchronizer will be bypassed and out_count will be in_count.
  parameter ASYNC_CLK = 1
) (
  input in_clk,
  input in_resetn,
  input [DATA_WIDTH-1:0] in_count,
  input out_resetn,
  input out_clk,
  output [DATA_WIDTH-1:0] out_count
);

  generate if (ASYNC_CLK == 1) begin
    reg [DATA_WIDTH-1:0] cdc_sync_stage0 = 'h0;
    reg [DATA_WIDTH-1:0] cdc_sync_stage1 = 'h0;
    reg [DATA_WIDTH-1:0] cdc_sync_stage2 = 'h0;
    reg [DATA_WIDTH-1:0] out_count_m = 'h0;

    function [DATA_WIDTH-1:0] g2b;
      input [DATA_WIDTH-1:0] g;
      reg   [DATA_WIDTH-1:0] b;
      integer i;
      begin
        b[DATA_WIDTH-1] = g[DATA_WIDTH-1];
        for (i = DATA_WIDTH - 2; i >= 0; i =  i - 1)
          b[i] = b[i + 1] ^ g[i];
        g2b = b;
      end
    endfunction

    function [DATA_WIDTH-1:0] b2g;
      input [DATA_WIDTH-1:0] b;
      reg [DATA_WIDTH-1:0] g;
      integer i;
      begin
        g[DATA_WIDTH-1] = b[DATA_WIDTH-1];
        for (i = DATA_WIDTH - 2; i >= 0; i = i -1)
            g[i] = b[i + 1] ^ b[i];
        b2g = g;
      end
    endfunction

    always @(posedge in_clk) begin
      if (in_resetn == 1'b0) begin
        cdc_sync_stage0 <= 'h00;
      end else begin
        cdc_sync_stage0 <= b2g(in_count);
      end
    end

    always @(posedge out_clk) begin
      if (out_resetn == 1'b0) begin
        cdc_sync_stage1 <= 'h00;
        cdc_sync_stage2 <= 'h00;
        out_count_m <= 'h00;
      end else begin
        cdc_sync_stage1 <= cdc_sync_stage0;
        cdc_sync_stage2 <= cdc_sync_stage1;
        out_count_m <= g2b(cdc_sync_stage2);
      end
    end

    assign out_count = out_count_m;
  end else begin
    assign out_count = in_count;
  end endgenerate

endmodule
