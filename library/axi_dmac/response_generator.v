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

module response_generator #(

  parameter ID_WIDTH = 3
) (
  input clk,
  input resetn,

  input enable,
  output reg enabled,

  input [ID_WIDTH-1:0] request_id,
  output reg [ID_WIDTH-1:0] response_id,

  input eot,

  output resp_valid,
  input resp_ready,
  output resp_eot,
  output [1:0] resp_resp
);

`include "inc_id.vh"
`include "resp.vh"

  assign resp_resp = RESP_OKAY;
  assign resp_eot = eot;

  assign resp_valid = request_id != response_id && enabled;

  // We have to wait for all responses before we can disable the response handler
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      enabled <= 1'b0;
    end else if (enable == 1'b1) begin
      enabled <= 1'b1;
    end else if (request_id == response_id) begin
      enabled <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      response_id <= 'h0;
    end else if (resp_valid == 1'b1 && resp_ready == 1'b1) begin
      response_id <= inc_id(response_id);
    end
  end

endmodule
