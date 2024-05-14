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

`timescale 1ns/100ps

module gpio_slave (
  input         reset_n,
  input         clk,
  input         sync,
  input         mosi,
  output        miso,

  input   [7:0] leds,
  output  [7:0] dipsw
);

  wire [7:0] i_leds;
  reg  [7:0] i_dipsw;
  reg  [7:0] q_leds;
  reg  [7:0] q_dipsw;

  assign i_leds = ~leds;
  assign miso   = q_leds[0];
  assign dipsw  = q_dipsw;

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      i_dipsw <= 8'b00000000;
    end else begin
      i_dipsw <= {mosi, i_dipsw[7:1]};
    end
  end

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      q_leds  <= 8'b11111111;
      q_dipsw <= 8'b00000000;
    end else if (sync) begin
      q_leds  <= i_leds;
      q_dipsw <= i_dipsw;
    end else begin
      q_leds  <= {1'b1, q_leds[7:1]};
      q_dipsw <= q_dipsw;
    end
  end

endmodule
