// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
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
/**
 * Unpacks u32 packages into u8 stream.
 */

`timescale 1ns/100ps

module i3c_controller_unpack (
  input         clk,
  input         reset_n,
  input         stop,

  output        u32_ready,
  input         u32_valid,
  input  [31:0] u32,

  output [11:0] u8_lvl,

  input         u8_ready,
  output        u8_valid,
  output [7:0]  u8
);

  localparam [0:0] SM_GET = 0;
  localparam [0:0] SM_PUT = 1;

  reg [0:0]  sm;
  reg [1:0]  c;
  reg [11:0] u8_lvl_reg;
  reg [31:0] u32_reg;

  always @(posedge clk) begin
    if (!reset_n | stop) begin
      sm <= SM_GET;
      c <= 2'b00;
      u8_lvl_reg <= 0;
    end else begin
      case (sm)
        SM_GET: begin
          if (u32_valid) begin
            sm <= SM_PUT;
          end
          u32_reg <= u32;
          c <= 2'b00;
        end
        SM_PUT: begin
          if (u8_ready) begin // tick
            u8_lvl_reg <= u8_lvl_reg + 12'b1;
            c <= c + 1;
            if (c == 2'b11) begin
              sm <= SM_GET;
            end
            u32_reg <= u32_reg >> 8;
          end
        end
      endcase
    end
  end

  assign u32_ready = sm == SM_GET & (reset_n | stop);
  assign u8_valid = sm == SM_PUT;
  assign u8_lvl = u8_lvl_reg;
  assign u8 = u32_reg[7:0];

endmodule
