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

module dmac_data_mover #(

  parameter ID_WIDTH = 3,
  parameter DATA_WIDTH = 64,
  parameter DISABLE_WAIT_FOR_ID = 1,
  parameter BEATS_PER_BURST_WIDTH = 4,
  parameter LAST = 0)( /* 0 = last asserted at the end of each burst, 1 = last only asserted at the end of the transfer */

  input clk,
  input resetn,

  input [ID_WIDTH-1:0] request_id,
  output [ID_WIDTH-1:0] response_id,
  input sync_id,
  input eot,

  input enable,
  output reg enabled,

  output xfer_req,

  output s_axi_ready,
  input s_axi_valid,
  input [DATA_WIDTH-1:0] s_axi_data,

  input m_axi_ready,
  output m_axi_valid,
  output [DATA_WIDTH-1:0] m_axi_data,
  output m_axi_last,

  input req_valid,
  output req_ready,
  input [BEATS_PER_BURST_WIDTH-1:0] req_last_burst_length
);

localparam BEAT_COUNTER_MAX = {BEATS_PER_BURST_WIDTH{1'b1}};

`include "inc_id.h"

reg [BEATS_PER_BURST_WIDTH-1:0] last_burst_length = 'h00;
reg [BEATS_PER_BURST_WIDTH-1:0] beat_counter = 'h00;
reg [ID_WIDTH-1:0] id = 'h00;
reg [ID_WIDTH-1:0] id_next = 'h00;

reg pending_burst = 1'b0;
reg active = 1'b0;
reg last_eot = 1'b0;
reg last_non_eot = 1'b0;

wire last_load;
wire last;

assign xfer_req = active;

assign response_id = id;

assign last = eot ? last_eot : last_non_eot;

assign s_axi_ready = m_axi_ready & pending_burst & active;
assign m_axi_valid = s_axi_valid & pending_burst & active;
assign m_axi_data = s_axi_data;
assign m_axi_last = LAST ? (last_eot & eot) : last;

// If we want to support zero delay between transfers we have to assert
// req_ready on the same cycle on which the last load happens.
assign last_load = s_axi_ready && s_axi_valid && last_eot && eot;
assign req_ready = last_load || ~active;

always @(posedge clk) begin
  if (resetn == 1'b0) begin
    enabled <= 1'b0;
  end else begin
    if (enable) begin
      enabled <= 1'b1;
    end else begin
      if (DISABLE_WAIT_FOR_ID == 0) begin
        // We are not allowed to just deassert valid, so wait until the
        // current beat has been accepted
        if (~s_axi_valid || m_axi_ready)
          enabled <= 1'b0;
      end else begin
        // For memory mapped AXI busses we have to complete all pending
        // burst requests before we can disable the data mover.
        if (response_id == request_id)
          enabled <= 1'b0;
      end
    end
  end
end

always @(posedge clk) begin
  if (req_ready) begin
    last_eot <= req_last_burst_length == 'h0;
    last_non_eot <= 1'b0;
    beat_counter <= 'h1;
  end else if (s_axi_ready && s_axi_valid) begin
    last_eot <= beat_counter == last_burst_length;
    last_non_eot <= beat_counter == BEAT_COUNTER_MAX;
    beat_counter <= beat_counter + 1'b1;
  end
end

always @(posedge clk) begin
  if (req_ready)
    last_burst_length <= req_last_burst_length;
end

always @(posedge clk) begin
  if (enabled == 1'b0 || resetn == 1'b0) begin
    active <= 1'b0;
  end else if (req_valid) begin
    active <= 1'b1;
  end else if (last_load) begin
    active <= 1'b0;
  end
end

always @(*)
begin
  if ((s_axi_ready && s_axi_valid && last) ||
    (sync_id && pending_burst))
    id_next <= inc_id(id);
  else
    id_next <= id;
end

always @(posedge clk) begin
  if (resetn == 1'b0) begin
    id <= 'h0;
  end else begin
    id <= id_next;
  end
end

always @(posedge clk) begin
  pending_burst <= id_next != request_id;
end

endmodule
