// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
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

module axi_dmac_ext_sync #(
  parameter USE_EXT_SYNC = 0,
  parameter ASYNC_CLK_REQ_SRC = 1,
  parameter ASYNC_CLK_DEST_REQ = 1
) (

  input req_clk,
  input req_resetn,

  input src_clk,
  input src_resetn,

  input dest_clk,
  input dest_resetn,

  // External sync interface
  input src_ext_sync,
  input dest_ext_sync,

  // Interface to requester
  output ext_sync_ready,
  input ext_sync_valid
);

  generate if (USE_EXT_SYNC == 1) begin

    reg src_ext_sync_d = 1'b0;
    reg dest_ext_sync_d = 1'b0;
    reg ext_sync_ready_s = 1'b0;

    wire req_ext_sync;
    wire req_src_ext_sync;
    wire req_dest_ext_sync;

    always @(posedge src_clk) begin
      src_ext_sync_d <= src_ext_sync;
    end

    always @(posedge dest_clk) begin
      dest_ext_sync_d <= dest_ext_sync;
    end

    sync_event #(
      .ASYNC_CLK(ASYNC_CLK_REQ_SRC)
    ) sync_src_sync (
      .in_clk(src_clk),
      .in_event(src_ext_sync & ~src_ext_sync_d),
      .out_clk(req_clk),
      .out_event(req_src_ext_sync));

    sync_event #(
      .ASYNC_CLK(ASYNC_CLK_DEST_REQ)
    ) sync_dest_sync (
      .in_clk(dest_clk),
      .in_event(dest_ext_sync & ~dest_ext_sync_d),
      .out_clk(req_clk),
      .out_event(req_dest_ext_sync));

    always @(posedge req_clk) begin
      if (req_resetn == 1'b0) begin
        ext_sync_ready_s <= 1'b0;
      end else if (req_ext_sync == 1'b1) begin
        ext_sync_ready_s <= 1'b1;
      end else if (ext_sync_valid == 1'b1) begin
        ext_sync_ready_s <= 1'b0;
      end
    end

    assign req_ext_sync = req_src_ext_sync | req_dest_ext_sync;
    assign ext_sync_ready = ext_sync_ready_s;

  end else begin
    assign ext_sync_ready = 1'b1;
  end
  endgenerate

endmodule
