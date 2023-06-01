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

  input  wire cmdr_ready,
  output wire cmdr_valid,
  output wire [31:0] cmdr,

  // Command parsed

  output wire        cmdp_valid,
  input  wire        cmdp_ready,
  output wire        cmdp_ccc,
  output wire        cmdp_ccc_bcast,
  output wire [6:0]  cmdp_ccc_id,
  output wire        cmdp_bcast_header,
  output wire [1:0]  cmdp_xmit,
  output wire        cmdp_sr,
  output wire [11:0] cmdp_buffer_len,
  output wire [6:0]  cmdp_da,
  output wire        cmdp_rnw,
  output wire        cmdp_do_daa,
  input  wire        cmdp_do_daa_ready,

  input  wire rd_bytes_ready,
  output wire rd_bytes_valid,
  input  wire wr_bytes_ready,
  output wire wr_bytes_valid
);
  wire cmd_ccc;
  wire [6:0] cmd_ccc_id;
  reg  [31:0] cmdr1;
  reg  [31:0] cmdr2;

  localparam [6:0] CCC_ENTDAA = 7'd7;

  reg [2:0] sm;
  localparam [2:0]
    receive      = 0,
    buffer_setup = 1,
    xfer_await   = 2,
    ccc_await    = 3,
    daa_await    = 4,
    daa_await_ready = 5,
    receipt_1   = 6,
    receipt_2   = 7;

  always @(posedge clk) begin
    if (!reset_n) begin
      sm  <= receive;
    end else begin
      case (sm)
        receive: begin
          cmdr1 <= cmd;
          // !cmdp_do_daa_ready disables the interface until daa is finished.
          if (cmd_valid & cmdp_do_daa_ready) begin
            sm <= buffer_setup;
          end else begin
            sm <= receive;
          end
        end
        buffer_setup: begin
          if ((rd_bytes_ready & !cmdp_rnw) | (wr_bytes_ready & cmdp_rnw)) begin
            sm <= cmd_ccc ? ccc_await : xfer_await;
          end else begin
            sm <= sm;
          end
        end
        xfer_await: begin
          sm <= cmdp_ready ? receipt_1 : sm;
        end
        ccc_await: begin
          cmdr2 <= cmd;
          sm <= cmd_valid ? (cmd_ccc_id == CCC_ENTDAA ? daa_await : xfer_await) : sm;
        end
        daa_await: begin
          sm <= !cmdp_do_daa_ready ? daa_await_ready : sm;
        end
        daa_await_ready: begin
          sm <= cmdp_do_daa_ready ? receipt_1 : sm;
        end
        receipt_1: begin
          sm <= cmdr_ready ? (cmdp_ccc ? receipt_2 : receive) : sm;
        end
        receipt_2: begin
          sm <= cmdr_ready ? receive : sm;
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

  assign cmd_ccc               = cmd  [30];
  assign cmdp_ccc              = cmdr1[30];
  assign cmdp_ccc_bcast        = cmdr2[7];
  assign cmdp_ccc_id           = cmdr2[6:0];
  assign cmd_ccc_id            = cmd  [6:0];
  assign cmdp_bcast_header     = cmdr1[29];
  assign cmdp_xmit             = cmdr1[28:27];
  assign cmdp_sr               = cmdr1[25];
  assign cmdp_buffer_len       = cmdr1[23:12];
  assign cmdp_da               = cmdr1[07:01];
  assign cmdp_rnw              = cmdr1[00];

  assign cmdr = sm == receipt_2 ? cmdr2 : cmdr1;
  assign cmdr_valid = sm == receipt_1 | sm == receipt_2;

  assign rd_bytes_valid = (sm == buffer_setup & ~cmdp_rnw);
  assign wr_bytes_valid = (sm == buffer_setup &  cmdp_rnw);
endmodule
