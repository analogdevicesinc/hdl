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

module dest_axi_stream #(

  parameter ID_WIDTH = 3,
  parameter S_AXIS_DATA_WIDTH = 64,
  parameter BEATS_PER_BURST_WIDTH = 4
) (
  input s_axis_aclk,
  input s_axis_aresetn,

  input enable,
  output enabled,
  output xfer_req,

  output [ID_WIDTH-1:0] response_id,
  output [ID_WIDTH-1:0] data_id,
  input data_eot,
  input response_eot,

  input m_axis_ready,
  output m_axis_valid,
  output [S_AXIS_DATA_WIDTH-1:0] m_axis_data,
  output reg [0:0] m_axis_user = 1'b1,
  output m_axis_last,

  output fifo_ready,
  input fifo_valid,
  input [S_AXIS_DATA_WIDTH-1:0] fifo_data,
  input fifo_last,

  input req_valid,
  output req_ready,
  input req_sync_transfer_start,
  input req_sync,
  input req_xlast,
  input req_islast,

  output response_valid,
  input response_ready,
  output response_resp_eot,
  output [1:0] response_resp
);

`include "inc_id.vh"

  reg [ID_WIDTH-1:0] id = 'h0;

  reg data_enabled = 1'b0;
  reg req_xlast_d = 1'b0;
  reg req_islast_d = 1'b0;
  reg active = 1'b0;
  reg needs_sync = 1'b0;

  wire has_sync;
  // Last beat of the burst
  wire fifo_last_beat;
  // Last beat of the segment
  wire fifo_eot_beat;

  assign has_sync = ~needs_sync | req_sync;

  // fifo_last == 1'b1 implies fifo_valid == 1'b1
  assign fifo_last_beat = fifo_ready & fifo_last;
  assign fifo_eot_beat = fifo_last_beat & data_eot;

  assign req_ready = fifo_eot_beat | ~active;
  assign data_id = id;
  assign xfer_req = active;

  assign m_axis_valid = fifo_valid & active & has_sync;
  assign fifo_ready = m_axis_ready & active & has_sync;
  assign m_axis_last = req_xlast_d & fifo_last & data_eot;
  assign m_axis_data = fifo_data;

  always @(posedge s_axis_aclk) begin
    if (req_ready == 1'b1) begin
      needs_sync <= req_sync_transfer_start;
    end else if (fifo_ready == 1'b1) begin
      needs_sync <= 1'b0;
    end
  end

  always @(posedge s_axis_aclk) begin
    if (s_axis_aresetn == 1'b0) begin
      data_enabled <= 1'b0;
    end else if (enable == 1'b1) begin
      data_enabled <= 1'b1;
    end else if (m_axis_valid == 1'b0 || m_axis_ready == 1'b1) begin
      data_enabled <= 1'b0;
    end
  end

  always @(posedge s_axis_aclk) begin
    if (req_ready == 1'b1) begin
      req_xlast_d <= req_xlast;
      req_islast_d <= req_islast;
    end
  end

  always @(posedge s_axis_aclk) begin
    if (s_axis_aresetn == 1'b0) begin
      active <= 1'b0;
    end else if (req_valid == 1'b1) begin
      active <= 1'b1;
    end else if (fifo_eot_beat == 1'b1) begin
      active <= 1'b0;
    end
  end

  always @(posedge s_axis_aclk) begin
    if (s_axis_aresetn == 1'b0) begin
      id <= 'h00;
    end else if (fifo_last_beat == 1'b1) begin
      id <= inc_id(id);
    end
  end

  always @(posedge s_axis_aclk) begin
    if (s_axis_aresetn == 1'b0) begin
      m_axis_user <= 1'b1;
    end else if (m_axis_valid && m_axis_ready) begin
      m_axis_user <= m_axis_last & req_islast_d;
    end
  end

  response_generator #(
    .ID_WIDTH(ID_WIDTH)
  ) i_response_generator (
    .clk(s_axis_aclk),
    .resetn(s_axis_aresetn),

    .enable(data_enabled),
    .enabled(enabled),

    .request_id(id),
    .response_id(response_id),

    .eot(response_eot),

    .resp_valid(response_valid),
    .resp_ready(response_ready),
    .resp_eot(response_resp_eot),
    .resp_resp(response_resp));

endmodule
