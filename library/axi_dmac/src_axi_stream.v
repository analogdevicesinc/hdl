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

module dmac_src_axi_stream #(

  parameter ID_WIDTH = 3,
  parameter S_AXIS_DATA_WIDTH = 64,
  parameter LENGTH_WIDTH = 24,
  parameter BEATS_PER_BURST_WIDTH = 4)(

  input s_axis_aclk,
  input s_axis_aresetn,

  input enable,
  output enabled,
  input sync_id,
  output sync_id_ret,

  input [ID_WIDTH-1:0] request_id,
  output [ID_WIDTH-1:0] response_id,
  input eot,

  output s_axis_ready,
  input s_axis_valid,
  input [S_AXIS_DATA_WIDTH-1:0] s_axis_data,
  input [0:0] s_axis_user,
  input s_axis_last,
  output s_axis_xfer_req,

  input fifo_ready,
  output fifo_valid,
  output [S_AXIS_DATA_WIDTH-1:0] fifo_data,

  input req_valid,
  output req_ready,
  input [BEATS_PER_BURST_WIDTH-1:0] req_last_burst_length,
  input req_sync_transfer_start,
  input req_xlast
);

reg needs_sync = 1'b0;
reg transfer_abort = 1'b0;
reg req_xlast_d = 1'b0;

wire [S_AXIS_DATA_WIDTH-1:0] data;
wire sync = s_axis_user[0];
wire has_sync = ~needs_sync | sync;
wire data_valid;
wire data_ready;
wire fifo_last;

assign sync_id_ret = sync_id;
assign data = transfer_abort == 1'b1 ? {S_AXIS_DATA_WIDTH{1'b0}} : s_axis_data;
assign data_valid = (s_axis_valid & has_sync) | transfer_abort;
assign s_axis_ready = data_ready & ~transfer_abort;

always @(posedge s_axis_aclk)
begin
  if (s_axis_aresetn == 1'b0) begin
    needs_sync <= 1'b0;
  end else begin
    if (s_axis_valid && s_axis_ready && sync) begin
      needs_sync <= 1'b0;
    end else if (req_valid && req_ready) begin
      needs_sync <= req_sync_transfer_start;
    end
  end
end

/*
 * A 'last' on the external interface indicates the end of an packet. If such a
 * 'last' indicator is observed before the end of the current transfer stop
 * accepting data on the external interface and complete the current transfer by
 * writing zeros to the buffer.
 */
always @(posedge s_axis_aclk) begin
  if (s_axis_aresetn == 1'b0) begin
    transfer_abort <= 1'b0;
  end else if (data_ready == 1'b1 && data_valid == 1'b1) begin
    if (fifo_last == 1'b1 && req_xlast_d == 1'b1) begin
      transfer_abort <= 1'b0;
    end else if (s_axis_last == 1'b1) begin
      transfer_abort <= 1'b1;
    end
  end
end

always @(posedge s_axis_aclk) begin
  if(req_ready == 1'b1) begin
    req_xlast_d <= req_xlast;
  end
end

dmac_data_mover # (
  .ID_WIDTH(ID_WIDTH),
  .DATA_WIDTH(S_AXIS_DATA_WIDTH),
  .DISABLE_WAIT_FOR_ID(0),
  .BEATS_PER_BURST_WIDTH(BEATS_PER_BURST_WIDTH),
  .LAST(1)
) i_data_mover (
  .clk(s_axis_aclk),
  .resetn(s_axis_aresetn),

  .enable(enable),
  .enabled(enabled),
  .sync_id(sync_id),

  .xfer_req(s_axis_xfer_req),

  .request_id(request_id),
  .response_id(response_id),
  .eot(eot),

  .req_valid(req_valid),
  .req_ready(req_ready),
  .req_last_burst_length(req_last_burst_length),

  .s_axi_ready(data_ready),
  .s_axi_valid(data_valid),
  .s_axi_data(data),
  .m_axi_ready(fifo_ready),
  .m_axi_valid(fifo_valid),
  .m_axi_data(fifo_data),
  .m_axi_last(fifo_last)
);

endmodule
