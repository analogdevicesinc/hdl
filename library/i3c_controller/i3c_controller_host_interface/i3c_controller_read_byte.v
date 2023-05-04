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
 * Unpacks u32 packages into u8 stream.
 * Restrictions:
 * "u32" must have enough elements, won't stall on ~u32_valid,
 * with exception of the first item, when both u8_len_valid and u32_valid
 * must be high at the same time to initiate the transfer.
 * Length must be > 0
 */

`timescale 1ns/100ps
`default_nettype none

module i3c_controller_read_byte (
  input  wire clk,
  input  wire reset_n,

  output wire u32_ready,
  input  wire u32_valid,
  input  wire [31:0] u32,

  output wire u8_len_ready,
  input  wire u8_len_valid,
  input  wire [11:0] u8_len,

  input  wire u8_ready,
  output wire u8_valid,
  output wire [7:0] u8,

  output reg debug_u32_underflow
);
  reg [0:0] sm;
  localparam [0:0]
    idle     = 0,
    transfer = 1;

  reg [11:0] u8_len_reg;
  reg [31:0] u32_reg;
  wire [9:0] i;
  wire [1:0] j;
  reg  [1:0] c;

  always @(posedge clk) begin
    if (!reset_n) begin
      sm <= idle;
      c <= 2'b00;
    end else begin
      case (sm)
        idle: begin
          u8_len_reg <= u8_len - 1;
          sm <= u8_len_valid & u32_valid ? transfer : idle;
          u32_reg <= u32;
          c <= 2'b11;
        end
        transfer: begin
          if (u8_ready) begin // tick
            if (~|i && j == ~c) begin
                sm <= idle;
            end
            if (c == 2'd0) begin
              u8_len_reg <= u8_len_reg - 12'b100;
              u32_reg <= u32;
            end else begin
              u32_reg <= u32_reg << 8;
            end
            c <= c - 1;
          end
        end
        default: begin
          sm <= idle;
        end
      endcase
    end
  end

  // Debug signals
  always @(posedge clk) begin
    if (~reset_n) begin
      debug_u32_underflow <= 1'b0;
    end else begin
      case (sm)
        idle: begin
          debug_u32_underflow <= ~u32_valid & u8_len_valid;
        end
        transfer: begin
          if (u8_ready & |i & j == 2'd0) begin
            debug_u32_underflow <= ~u32_valid;
          end
        end
      endcase

    end
  end

  assign u8_len_ready = (sm == idle);
  assign u32_ready = (sm == idle & u8_len_valid & u32_valid) || (sm == transfer & u8_ready & |i & c == 2'b00);
  assign u8_valid = (sm == transfer);
  assign j = u8_len_reg[1:0];
  assign i = u8_len_reg[11:2];
  assign u8 = u32_reg[31:24];
endmodule
