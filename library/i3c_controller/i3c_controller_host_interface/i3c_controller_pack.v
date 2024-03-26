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
 * Packs u8 stream into u32.
 * Restrictions:
 * At partial payload, e.g. 3-bytes, the remaining byte value is unknown.
 */

`timescale 1ns/100ps

module i3c_controller_pack (
  input         clk,
  input         reset_n,

  input         u32_ready,
  output        u32_valid,
  output [31:0] u32,

  output [11:0] u8_lvl,

  output       u8_ready,
  input        u8_valid,
  input        u8_last,
  input  [7:0] u8
);

  localparam [0:0] SM_GET = 0;
  localparam [0:0] SM_PUT = 1;

  reg [0:0]  sm;
  reg [1:0]  c;
  reg [7:0]  u32_reg [3:0];
  reg [11:0] u8_lvl_reg;
  reg        u8_last_reg;

  always @(posedge clk) begin
    if (!reset_n) begin
      sm <= SM_GET;
      c <= 2'b00;
      u8_last_reg <= 1'b0;
      u8_lvl_reg <= 0;
    end else begin
      case (sm)
        SM_GET: begin
          u8_last_reg <= u8_last;
          if (u8_valid) begin // tick
            u32_reg[3-c] <= u8;
            u8_lvl_reg <= u8_lvl_reg + 1;
            c <= c + 1;
            if (c == 2'b11 | u8_last) begin
              c <= 2'b00;
              sm <= SM_PUT;
            end
          end
        end
        SM_PUT: begin
          if (u32_ready) begin
            sm <= SM_GET;
            if (u8_last_reg) begin
              u8_lvl_reg <= 0;
            end
          end
        end
      endcase
    end
  end

  assign u8_ready = sm == SM_GET & reset_n;
  assign u32_valid = sm == SM_PUT;
  assign u8_lvl = u8_lvl_reg;

  genvar i;
  generate
    for (i=0; i<4; i=i+1) begin: gen_u32
      assign u32[8*i+7:8*i] = u32_reg[3-i];
    end
  endgenerate

endmodule
