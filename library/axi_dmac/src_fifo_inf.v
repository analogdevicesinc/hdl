// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
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

module src_fifo_inf #(

  parameter ID_WIDTH = 3,
  parameter DATA_WIDTH = 64,
  parameter BEATS_PER_BURST_WIDTH = 4
) (
  input clk,
  input resetn,

  input enable,
  output enabled,

  input [ID_WIDTH-1:0] request_id,
  output [ID_WIDTH-1:0] response_id,
  input eot,

  output bl_valid,
  input bl_ready,
  output [BEATS_PER_BURST_WIDTH-1:0] measured_last_burst_length,

  input en,
  input [DATA_WIDTH-1:0] din,
  output reg overflow,
  output xfer_req,

  output fifo_valid,
  output [DATA_WIDTH-1:0] fifo_data,
  output fifo_last,

  input req_valid,
  output req_ready,
  input [BEATS_PER_BURST_WIDTH-1:0] req_last_burst_length,
  input req_sync_transfer_start,
  input req_sync
);

  wire ready;
  wire sync;
  wire valid;

  assign enabled = enable;
  assign sync = req_sync;
  assign valid = en;

  always @(posedge clk)
  begin
    if (enable) begin
      overflow <= en & ~ready;
    end else begin
      overflow <= en;
    end
  end

  data_mover #(
    .ID_WIDTH(ID_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH)
  ) i_data_mover (
    .clk(clk),
    .resetn(resetn),

    .xfer_req(xfer_req),

    .request_id(request_id),
    .response_id(response_id),
    .eot(eot),

    .rewind_req_valid(),
    .rewind_req_ready(1'b0),
    .rewind_req_data(),

    .bl_valid(bl_valid),
    .bl_ready(bl_ready),
    .measured_last_burst_length(measured_last_burst_length),

    .block_descr_to_dst(),

    .source_id(),
    .source_eot(),

    .req_valid(req_valid),
    .req_ready(req_ready),
    .req_last_burst_length(req_last_burst_length),
    .req_sync_transfer_start(req_sync_transfer_start),
    .req_xlast(1'b0),

    .s_axi_ready(ready),
    .s_axi_valid(valid),
    .s_axi_data(din),
    .s_axi_sync(sync),
    .s_axi_last(1'b0),

    .m_axi_valid(fifo_valid),
    .m_axi_data(fifo_data),
    .m_axi_last(fifo_last),
    .m_axi_partial_burst());

endmodule
