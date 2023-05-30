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
  parameter DA_LENGTH = 4,
  parameter DA_LENGTH_WIDTH = 2,
  // See I3C Target Address Restrictions for valid values
  parameter [7*DA_LENGTH-1:0] DA = {7'h0b, 7'h0a, 7'h09, 7'h08}
)(
  input reset_n,
  input clk,

  // Command interface

  input  cmdp_do_daa,
  output cmdp_do_daa_ready,

  // Word command

  input  cmdw_ready,
  output [`CMDW_HEADER_WIDTH+8:0] cmdw,
  input  cmdw_nack,

  // uP accessible info

  output rmap_daa_status_in_progress,
  output [DA_LENGTH_WIDTH-1:0] rmap_daa_status_registered,
  input  [DA_LENGTH_WIDTH-1:0] rmap_daa_peripheral_index,
  output [6:0] rmap_daa_peripheral_da
);
  reg [DA_LENGTH_WIDTH-1:0] da_reg;
  reg [7:0] cmdw_body;
  reg [`CMDW_HEADER_WIDTH:0] sm;
  reg ctrl;

  localparam [6:0]
    CCC_ENTDAA = 'h03;

  always @(posedge clk) begin
    if (!reset_n) begin
      da_reg <= 0;
    end else begin
      if (sm == `CMDW_NOP & cmdp_do_daa) begin
        sm <= `CMDW_START;
      end
    end
    if (!reset_n | cmdw_nack) begin
      sm <= `CMDW_NOP;
      cmdw_body <= 8'h00;
      ctrl <= 1'b0;
    end else if (cmdw_ready) begin
      case (sm)
        `CMDW_NOP: begin
          ctrl <= 1'b0;
          da_reg <= 0;
        end
        `CMDW_START: begin
          sm <= ctrl ? `CMDW_BCAST_7E_W1 : `CMDW_BCAST_7E_W0;
          ctrl <= 1'b1;
        end
        `CMDW_BCAST_7E_W0: begin
          sm <= `CMDW_CCC;
          cmdw_body <= {1'b0, CCC_ENTDAA}; // BROAD+ENTDAA
        end
        `CMDW_CCC: begin
          sm <= `CMDW_START;
        end
        `CMDW_BCAST_7E_W1: begin
          sm <= `CMDW_PROV_ID_BCR_DCR;
        end
        `CMDW_PROV_ID_BCR_DCR: begin
          sm <= `CMDW_DYN_ADDR;
          cmdw_body <= {DA[7*da_reg +:7], ~^DA[7*da_reg +:7]};
        end
        `CMDW_DYN_ADDR: begin
          // If there is no more DA available, exit
          // However, DA should have at least the # peripherals expected in
          // the bus
          sm <= da_reg == DA_LENGTH-1 ? `CMDW_STOP : `CMDW_START;
          da_reg <= da_reg + 1;
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

  assign cmdw = {sm, cmdw_body};
  assign cmdp_do_daa_ready = sm == `CMDW_NOP & reset_n;

  assign rmap_daa_status_in_progress = ~cmdp_do_daa_ready;
  assign rmap_daa_status_registered  = da_reg;
  assign rmap_daa_peripheral_da = DA[7*rmap_daa_peripheral_index+:7];
endmodule
