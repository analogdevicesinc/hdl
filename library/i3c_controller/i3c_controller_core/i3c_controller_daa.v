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
 * Does dynamic address assigment DAA, which occurs at bus initialization.
 *
 * The DAA process is:
 * Controller       | Peripheral  | Flow
 * -----------------|-------------|---------
 * S,0x7e,RnW=0     |             |    │
 *                  | ACK         |    │
 * ENTDAA,T         |             |    │
 * Sr               |             | ┌─►│
 * 0x7e,RnW=1       |             | │  ▼
 *                  | ACK         | │  A──┐
 *                  | PID+BCR+DCR | │  │  │
 * DA, Par          |             | │  ▼  │
 *                  | ACK         | └──B  │
 * P                |             |    C◄─┘
 *
 * Notes
 * From A with ACK, continue flow to B, or with NACK, goto C Stop,
 * finishing the DAA. At B, goto on sm state before A, Sr.
 * The first and last ACK are mandatory in the flowchart, if a NACK is received,
 * it is considered an error and the module resets.
 * The controller writes in push-pull mode.
 */

`timescale 1ns/100ps
`default_nettype wire
`include "i3c_controller_word_cmd.v"

module i3c_controller_daa #(
  parameter MAX_DEVS = 15
)(
  input reset_n,
  input clk,

  // Command interface

  input  cmdp_do_daa,
  output cmdp_do_daa_ready,

  // Word command

  output cmdw_valid,
  input  cmdw_ready,
  output [`CMDW_HEADER_WIDTH+8:0] cmdw,
  input  cmdw_nack,

  // Bus status

  input idle_bus,

  // DAA interface

  input pid_bcr_dcr_tick,
  input [63:0] pid_bcr_dcr,

  // uP accessible info

  output rmap_daa_status,
  input  [15:0] rmap_dev_clr,
  output reg [14:0] rmap_devs_ctrl,
  input  [(MAX_DEVS)*9-1:0] rmap_dev_char_0,
  output reg  [(MAX_DEVS)*32-1:0] rmap_dev_char_1,
  output reg  [(MAX_DEVS)*32-1:0] rmap_dev_char_2
);
  // TODO: Use BRAM for dev_char
  integer i;
  reg [3:0] j;
  reg [7:0] cmdw_body;
  reg [`CMDW_HEADER_WIDTH:0] sm;
  reg ctrl;
  reg lock;

  localparam [6:0]
    CCC_ENTDAA = 'h03;

  reg [1:0] smt;
  localparam [1:0]
    idle       = 0,
    transfer   = 1,
    seek       = 2,
    commit     = 3;

  always @(posedge clk) begin
    if (!reset_n) begin
      smt <= idle;
      sm <= `CMDW_NOP;
      j <= 0;
      cmdw_body <= 8'h00;
      ctrl <= 1'b0;
      lock <= 1'b0;
      rmap_devs_ctrl <= 'd0;
    end else if (cmdw_nack) begin
      smt <= idle;
      cmdw_body <= 8'h00;
      ctrl <= 1'b0;
    end else begin
      case (smt)
        idle: begin
          if (cmdp_do_daa & ~lock) begin
            smt <= seek;
            sm <= `CMDW_START;
            lock <= 1'b1;
          end else if (idle_bus) begin
            lock <= 1'b0;
          end

          for (i = 0; i < MAX_DEVS; i = i+1) begin
            if (rmap_dev_clr[15] & rmap_dev_clr[i]) begin
              rmap_devs_ctrl[i] <= 1'b0;
            end
          end
        end
        transfer: begin
          if (cmdw_ready) begin
            case (sm)
              `CMDW_NOP: begin
                ctrl <= 1'b0;
                j <= 0;
                smt <= idle;
              end
              `CMDW_START: begin
                sm <= ctrl ? `CMDW_BCAST_7E_W1 : `CMDW_BCAST_7E_W0;
                ctrl <= 1'b1;
              end
              `CMDW_BCAST_7E_W0: begin
                sm <= `CMDW_CCC_OD;
                cmdw_body <= {1'b0, CCC_ENTDAA}; // BROAD+ENTDAA
              end
              `CMDW_CCC_OD: begin
                sm <= `CMDW_START;
              end
              `CMDW_BCAST_7E_W1: begin
                sm <= `CMDW_PROV_ID_BCR_DCR;
                smt <= seek;
              end
              `CMDW_PROV_ID_BCR_DCR: begin
                sm <= `CMDW_DYN_ADDR;
                cmdw_body <= rmap_dev_char_0[j*9 +: 8];
              end
              `CMDW_DYN_ADDR: begin
                sm <= j == MAX_DEVS-1 ? `CMDW_STOP : `CMDW_START;
                smt <= commit;
              end
              `CMDW_STOP: begin
                 sm <= `CMDW_NOP;
              end
              default: begin
                 sm <= `CMDW_NOP;
              end
            endcase
          end
        end
        seek: begin
          if (rmap_devs_ctrl[j] == 1'b0 & rmap_dev_char_0[j*9+8] == 1'b1) begin
            smt <= transfer;
          end else begin
            j <= j + 1;
          end
          if (rmap_dev_char_0[j*9+8] == 1'b0) begin
            // If I2C, just set it as attached
            rmap_devs_ctrl[j] <= 1'b1;
          end
        end
        commit: begin
          if (cmdw_ready) begin
            rmap_devs_ctrl[j] <= 1'b1;
            smt <= transfer;
          end
        end
      endcase
    end
  end

  always @(posedge clk) begin
    if (reset_n & pid_bcr_dcr_tick) begin
      rmap_dev_char_1[j*32+:32] <= pid_bcr_dcr[63:32];
      rmap_dev_char_2[j*32+:32] <= pid_bcr_dcr[31:0];
    end
  end

  assign cmdw = {sm, cmdw_body};
  assign cmdp_do_daa_ready = ~lock;

  assign rmap_daa_status = ~cmdp_do_daa_ready;
  assign cmdw_valid = smt == transfer;
endmodule
