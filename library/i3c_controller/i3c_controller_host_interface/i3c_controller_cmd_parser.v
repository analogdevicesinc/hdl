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

`timescale 1ns/100ps
`default_nettype none

module i3c_controller_cmd_parser #(
  parameter DEFAULT_CLK_DIV = 0
) (
  input  wire clk,
  input  wire reset_n,

  // Command FIFO

  output reg  cmd_ready,
  input  wire cmd_valid,
  input  wire [31:0] cmd,

  // Command parsed

  output reg  cmdp_valid,
  input  wire cmdp_ready,
  output reg  cmdp_ccc,
  output reg  cmdp_broad_header,
  output reg  [1:0] cmdp_xmit,
  output reg  cmdp_sr,
  output reg  [11:0] cmdp_buffer_len,
  output reg  [6:0] cmdp_da,
  output reg  cmdp_rnw,
  output reg  cmdp_do_daa
);
  reg [1:0] sm;
  localparam [1:0]
    idle  = 0,
    init  = 1,
    await = 2;

  always @(posedge clk) begin
    if (!reset_n) begin
      cmd_ready <= 1'b0;
      cmdp_valid <= 1'b0;
      sm <= idle;
    end else begin
      case (sm)
        idle: begin
          sm <= cmd_valid ? init : idle;
          cmdp_valid <= cmd_valid;
          cmd_ready <= 1'b1;
        end
        init: begin
          cmd_ready <= 1'b0;
          sm <= await;
        end
        await: begin
          cmd_ready <= cmdp_ready ? 1'b1: 1'b0;
          cmdp_valid <= 1'b0;
          sm <= cmdp_ready ? idle : await;
        end
        default: begin
          sm <= idle;
        end
      endcase
    end



  end

endmodule
