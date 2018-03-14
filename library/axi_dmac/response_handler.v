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

module dmac_response_handler #(

  parameter ID_WIDTH = 3)(

  input clk,
  input resetn,

  input bvalid,
  output bready,
  input [1:0] bresp,

  output reg [ID_WIDTH-1:0] id,
  input [ID_WIDTH-1:0] request_id,
  input sync_id,

  input enable,
  output reg enabled,

  input eot,

  output resp_valid,
  input resp_ready,
  output resp_eot,
  output [1:0] resp_resp
);

`include "resp.h"
`include "inc_id.h"

assign resp_resp = bresp;
assign resp_eot = eot;

wire active = id != request_id && enabled;

assign bready = active && resp_ready;
assign resp_valid = active && bvalid;

// We have to wait for all responses before we can disable the response handler
always @(posedge clk) begin
  if (resetn == 1'b0) begin
    enabled <= 1'b0;
  end else begin
  if (enable)
      enabled <= 1'b1;
  else if (request_id == id)
      enabled <= 1'b0;
  end
end

always @(posedge clk) begin
  if (resetn == 1'b0) begin
    id <= 'h0;
  end else begin
    if ((bready && bvalid) ||
        (sync_id && id != request_id))
      id <= inc_id(id);
  end
end

endmodule
