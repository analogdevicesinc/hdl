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

module splitter #(

  parameter NUM_M = 2
) (
  input clk,
  input resetn,

  input s_valid,
  output s_ready,

  output [NUM_M-1:0] m_valid,
  input [NUM_M-1:0] m_ready
);

  reg [NUM_M-1:0] acked;

  assign s_ready = &(m_ready | acked);
  assign m_valid = s_valid ? ~acked : {NUM_M{1'b0}};

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      acked <= {NUM_M{1'b0}};
    end else begin
      if (s_valid & s_ready)
        acked <= {NUM_M{1'b0}};
      else
        acked <= acked | (m_ready & m_valid);
    end
  end

endmodule
