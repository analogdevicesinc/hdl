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

module dmac_request_generator #(

  parameter ID_WIDTH = 3,
  parameter BURSTS_PER_TRANSFER_WIDTH = 17)(

  input req_aclk,
  input req_aresetn,

  output [ID_WIDTH-1:0] request_id,
  input [ID_WIDTH-1:0] response_id,

  input req_valid,
  output reg req_ready,
  input [BURSTS_PER_TRANSFER_WIDTH-1:0] req_burst_count,

  input enable,
  input pause,

  output eot
);

`include "inc_id.h"

/*
 * Here we only need to count the number of bursts, which means we can ignore
 * the lower bits of the byte count. The last last burst may not contain the
 * maximum number of bytes, but the address_generator and data_mover will take
 * care that only the requested ammount of bytes is transfered.
 */

reg [BURSTS_PER_TRANSFER_WIDTH-1:0] burst_count = 'h00;
reg [ID_WIDTH-1:0] id;
wire [ID_WIDTH-1:0] id_next = inc_id(id);

assign eot = burst_count == 'h00;
assign request_id = id;

always @(posedge req_aclk) begin
  if (req_ready == 1'b1) begin
    burst_count <= req_burst_count;
  end else if (response_id != id_next && pause == 1'b0) begin
    burst_count <= burst_count - 1'b1;
  end
end

always @(posedge req_aclk)
begin
  if (req_aresetn == 1'b0) begin
    id <= 'h0;
    req_ready <= 1'b1;
  end else if (enable == 1'b0) begin
    req_ready <= 1'b1;
  end else begin
    if (req_ready) begin
      if (req_valid && enable) begin
        req_ready <= 1'b0;
      end
    end else if (response_id != id_next && ~pause) begin
      if (eot)
        req_ready <= 1'b1;
      id <= id_next;
    end
  end
end

endmodule
