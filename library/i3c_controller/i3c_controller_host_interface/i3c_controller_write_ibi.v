// ***************************************************************************
// ***************************************************************************
// Copyright 2023 (c) Analog Devices, Inc. All rights reserved.
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
/**
 * Just move the IBI.
 */

`timescale 1ns/100ps
`default_nettype none

module i3c_controller_write_ibi (
  input  wire clk,
  input  wire reset_n,

  input  wire out_ready,
  output wire out_valid,
  output wire [31:0] out,

  output wire in_ready,
  input  wire in_valid,
  input  wire [14:0] in
);
  reg [0:0] sm;
  localparam [0:0]
    idle     = 0,
    move     = 1;

  reg [6:0] da;
  reg [7:0] mdb;
  reg [7:0] sync;

  always @(posedge clk) begin
    if (!reset_n) begin
      sm <= idle;
      sync <= 8'd0;
    end else begin
      case (sm)
        idle: begin
          sm <= in_valid ? move : sm;
          da   <= in[14:8];
          mdb  <= in[7:0];
        end
        move: begin
          sm <= out_ready ? idle : sm;
          sync <= out_ready ? sync+1 : sync;
        end
      endcase
    end
  end

  assign out = {8'd0, da, 1'b0, mdb, sync};
  assign in_ready = sm == idle;
  assign out_valid = sm == move;
endmodule
