// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

module dmac_src_fifo_inf #(

  parameter ID_WIDTH = 3,
  parameter DATA_WIDTH = 64,
  parameter BEATS_PER_BURST_WIDTH = 4)(

  input clk,
  input resetn,

  input enable,
  output enabled,
  input sync_id,
  output sync_id_ret,

  input [ID_WIDTH-1:0] request_id,
  output [ID_WIDTH-1:0] response_id,
  input eot,

  input en,
  input [DATA_WIDTH-1:0] din,
  output reg overflow,
  input sync,
  output xfer_req,

  input fifo_ready,
  output fifo_valid,
  output [DATA_WIDTH-1:0] fifo_data,

  input req_valid,
  output req_ready,
  input [BEATS_PER_BURST_WIDTH-1:0] req_last_burst_length,
  input req_sync_transfer_start
);

wire ready;

reg needs_sync = 1'b0;
wire has_sync = ~needs_sync | sync;
wire sync_valid = en & ready & has_sync;

always @(posedge clk)
begin
  if (resetn == 1'b0) begin
    needs_sync <= 1'b0;
  end else begin
    if (ready && en && sync) begin
      needs_sync <= 1'b0;
    end else if (req_valid && req_ready) begin
      needs_sync <= req_sync_transfer_start;
    end
  end
end

always @(posedge clk)
begin
  if (resetn == 1'b0) begin
    overflow <= 1'b0;
  end else begin
    if (enable) begin
      overflow <= en & ~ready;
    end else begin
      overflow <= en;
    end
  end
end

assign sync_id_ret = sync_id;

dmac_data_mover # (
  .ID_WIDTH(ID_WIDTH),
  .DATA_WIDTH(DATA_WIDTH),
  .DISABLE_WAIT_FOR_ID(0),
  .BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH)
) i_data_mover (
  .clk(clk),
  .resetn(resetn),

  .enable(enable),
  .enabled(enabled),
  .sync_id(sync_id),

  .xfer_req(xfer_req),

  .request_id(request_id),
  .response_id(response_id),
  .eot(eot),

  .req_valid(req_valid),
  .req_ready(req_ready),
  .req_last_burst_length(req_last_burst_length),

  .s_axi_ready(ready),
  .s_axi_valid(sync_valid),
  .s_axi_data(din),
  .m_axi_ready(fifo_ready),
  .m_axi_valid(fifo_valid),
  .m_axi_data(fifo_data),
  .m_axi_last()
);

endmodule
