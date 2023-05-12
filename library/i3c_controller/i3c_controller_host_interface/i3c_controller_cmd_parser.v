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
 * Parse commands.
 * When the first command indicates a pair command (e.g. CCC), await next
 * command to complete request (e.g. add CCC ID to parsed CCC command).
 * If it is a simple command (e.g. private transfer), a "blank" command
 * is not required.
 */

`timescale 1ns/100ps
`default_nettype none

module i3c_controller_cmd_parser #(
) (
  input  wire clk,
  input  wire reset_n,

  // Command FIFO

  output wire cmd_ready,
  input  wire cmd_valid,
  input  wire [31:0] cmd,

  // Command parsed

  output wire        cmdp_valid,
  input  wire        cmdp_ready,
  output reg         cmdp_ccc,
  output reg         cmdp_ccc_bcast,
  output reg  [6:0]  cmdp_ccc_id,
  output reg         cmdp_bcast_header,
  output reg  [1:0]  cmdp_xmit,
  output reg         cmdp_sr,
  output reg  [11:0] cmdp_buffer_len,
  output reg  [6:0]  cmdp_da,
  output reg         cmdp_rnw,
  output wire        cmdp_do_daa,
  input  wire        cmdp_do_daa_ready
);
  wire        cmd_ccc;
  wire        cmd_ccc_bcast;
  wire [6:0]  cmd_ccc_id;
  wire        cmd_bcast_header;
  wire [1:0]  cmd_xmit;
  wire        cmd_sr;
  wire [11:0] cmd_buffer_len;
  wire [6:0]  cmd_da;
  wire        cmd_rnw;

  localparam [6:0] CCC_ENTDAA = 7'd7;

  reg [2:0] sm;
  localparam [2:0]
    receive    = 0,
    xfer_await = 1,
    ccc_await  = 2,
    daa_await  = 3,
    daa_await_ready = 4;

  always @(posedge clk) begin
    if (!reset_n) begin
      sm <= receive;
    end else begin
      case (sm)
        receive: begin
          cmdp_ccc              <= cmd_ccc;
          cmdp_bcast_header     <= cmd_bcast_header;
          cmdp_xmit             <= cmd_xmit;
          cmdp_sr               <= cmd_sr;
          cmdp_buffer_len       <= cmd_buffer_len;
          cmdp_da               <= cmd_da;
          cmdp_rnw              <= cmd_rnw;

          // !cmdp_do_daa_ready disables the interface until daa is finished.
          if (cmd_valid & cmdp_do_daa_ready) begin
            sm <= cmd_ccc ? ccc_await : xfer_await;
          end else begin
            sm <= receive;
          end
        end
        xfer_await: begin
          sm <= cmdp_ready ? receive : sm;
        end
        ccc_await: begin
          cmdp_ccc_bcast <= cmd_ccc_bcast;
          cmdp_ccc_id    <= cmd_ccc_id;

          sm <= cmd_valid ? (cmd_ccc_id == CCC_ENTDAA ? daa_await : xfer_await) : sm;
        end
        daa_await: begin
          sm <= !cmdp_do_daa_ready ? daa_await_ready : sm;
        end
        daa_await_ready: begin
          sm <= cmdp_do_daa_ready ? receive : sm;
        end
        default: begin
          sm <= receive;
        end
      endcase
    end
  end

  assign cmd_ready    = (sm == receive || sm == ccc_await) & reset_n & cmdp_do_daa_ready;
  assign cmdp_valid   = sm == xfer_await & reset_n;
  assign cmdp_do_daa  = sm == daa_await & reset_n;

  assign cmd_ccc              = cmd[30];
  assign cmd_ccc_bcast        = cmd[7];
  assign cmd_ccc_id           = cmd[6:0];
  assign cmd_bcast_header     = cmd[29];
  assign cmd_xmit             = cmd[28:27];
  assign cmd_sr               = cmd[25];
  assign cmd_buffer_len       = cmd[23:12];
  assign cmd_da               = cmd[07:01];
  assign cmd_rnw              = cmd[00];
endmodule
