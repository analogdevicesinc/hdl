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
 * Restrictions:
 * "u32" must have enough elements, won't stall on ~u32_valid.
 * length must be > 0
 */

`timescale 1ns/100ps
`default_nettype none

module i3c_controller_read_byte #(
  parameter DATA_WIDTH = 32
) (
  input  wire clk,
  input  wire resetn,

  output wire u32_ready,
  input  wire u32_valid,
  input  wire [DATA_WIDTH-1:0] u32,
  output wire reg debug_u32_underflow,

  output wire u8_len_ready,
  input  wire u8_len_valid,
  input  wire [11:0] u8_len,

  input  wire u8_ready,
  output wire u8_valid,
  output wire reg [7:0] u8
);
  reg [1:0] sm;
  localparam [1:0]
    idle     = 0,
    first    = 1,
    transfer = 3;

  reg [11:0] u8_len_reg;
  reg [31:0] u32_reg;
  reg [9:0] i;
  reg [1:0] j;

  always @(posedge clk) begin
    if (resetn) begin
      sm <= idle;
      debug_u32_underflow <= 1'b0;
    end else begin
        //      0  000
        //      1  001
        // 3 -> 2  010
        // 4 -> 3  011
        // 5 -> 4  100
        //      5  101
        //      6  110
        //      7 1000
      case (sm)
        idle: begin
          u8_len_reg <= u8_len - 1;
          sm <= u8_len_valid ? first : idle;
        end
        first: begin
          u32_reg <= u32;
          sm <= transfer;
        end
        transfer: begin
          if (u8_ready) begin // tick
            if (j == 2'd0) begin
              u32_reg <= u32;
              if (~|i) begin
                sm <= idle;
              end
            end else begin
              u32_reg <= u32_reg << 8;
            end
            u8_len_reg <= u8_len_reg - 1;
          end
          u8_valid <= 1'b1;
        end
      endcase

      // Debug case
      case (sm)
        first: begin
          debug_u32_underflow <= ~u32_valid;
        end
        transfer: begin
          if (u8_ready && |i && j == 2'd0) begin
            debug_u32_underflow <= ~u32_valid;
          end
        end
      endcase

    end
  end

  assign u8_len_ready = sm == idle ? 1'b1 : 1'b0;
  assign u32_ready = (sm == first) || (sm == transfer && u8_ready && |i) ? 1'b1 : 1'b0;
  assign j = u8_len_reg[1:0];
  assign i = u8_len_reg[11:2];
  assign u8 = u32_reg[31:24];
endmodule
