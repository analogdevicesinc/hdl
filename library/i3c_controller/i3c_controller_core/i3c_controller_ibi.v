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
 * Enable in-band interrupts IBI, which occurs when the bus is in idle.
 */

`timescale 1ns/100ps
`default_nettype wire
`include "i3c_controller_word_cmd.v"

module i3c_controller_ibi #(
)(
  input reset_n,
  input clk,

  // Command interface

  input  cmdp_ready,
  input  cmdp_do_daa_ready,

  output ibi_ready,

  // Word command

  input  cmdw_ready,
  output [`CMDW_HEADER_WIDTH+8:0] cmdw,
  input  cmdw_nack,
  
  output wire cmdw_rx_ready,
  input  wire cmdw_rx_valid,
  input  wire [7:0] cmdw_rx

  // uP accessible info

  input  [1:0] rmap_ibi_config
);
  wire enable;
  wire auto;

  reg [7:0] cmdw_body;
  reg [`CMDW_HEADER_WIDTH:0] sm;
  reg skip_start;

  localparam [1:0]
    await      = 0,
    ensure     = 1,
    transfer   = 2;

  reg [1:0] smt;

  always @(posedge clk) begin
    if (!reset_n) begin
      ibi_ready <= 1'b0;
      sm <= `CMDW_NOP;
      cmdw_body <= 8'h00;
      ctrl <= 1'b0;
      skip_start = 1'b0;
    end else begin
      case (smt)
        await: begin
          // Idle
          sm <= `CMDW_NOP;
          skip_start = 1'b0;
          if (cmdp_do_daa_ready & cmdp_ready) begin
            if (trigger) begin
              smt <= ensure;
            end else if (auto & ~sdo_bit) begin
              smt <= ensure;
              skip_start = 1'b1;
            end
          end
        end
        ensure: begin
          if (cmdp_ready) begin
            smt <= tranfer;
            sm <= skip_start ? `CMDW_MSG_RX : `CMDW_START;
          end else begin
            smt <= await;
          end
        end
        transfer: begin
          if (cmdw_ready) begin
            case (sm)
              `CMDW_NOP: begin
                ctrl <= 1'b0;
                da_reg <= 0;
              end
              `CMDW_START: begin
                sm <=  `CMDW_MSG_RX;
                ctrl <= 1'b1;
              end
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
        default: begin
        end
      endcase
    end
  end

  assign ibi_ready = smt == await;
  assign cmdw = {sm, cmdw_body};
  assign cmdp_do_daa_ready = sm == `CMDW_NOP & reset_n;

  assign enable = rmap_ibi_config[0];
  assign auto = rmap_ibi_config[1]; 
endmodule
