// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

/*
 * GPIOs of the bridge, written and read one pin at a time by the GPIO_W and
 * GPIO_R bridge instructions, see spi_translator_decoder.v. Up to 256 pins,
 * each with an output value, a direction (0 = output, 1 = input; the same
 * polarity as the gpio_t tristate control) and an input level synchronized to
 * clk. Writes act immediately; an index at or above NUM_OF_GPIO is ignored on
 * write and reads 0.
 *
 * DEFAULT_DIR and DEFAULT_OUT set the state after reset, one bit per pin. By
 * default every pin is an output driven low. For regulator enables, set each
 * DEFAULT_OUT bit to the level that keeps its regulator off (1 for an
 * active-low enable), so nothing powers up before software sequences it; give
 * pins driven by another device, such as power-good outputs, a DEFAULT_DIR bit
 * of 1 so the two never drive them against each other.
 */

module spi_translator_gpio #(
  parameter NUM_OF_GPIO = 8,
  parameter [NUM_OF_GPIO-1:0] DEFAULT_DIR = {NUM_OF_GPIO{1'b0}},
  parameter [NUM_OF_GPIO-1:0] DEFAULT_OUT = {NUM_OF_GPIO{1'b0}}
) (
  input                       clk,
  input                       resetn,

  // one pin per write: sel 0 = OUT, 1 = DIR

  input                       wr_en,
  input       [7:0]           wr_index,
  input                       wr_sel,
  input                       wr_value,

  // one pin per read: {5'b0, DIR, OUT, IN}

  input       [7:0]           rd_index,
  output      [7:0]           rd_data,

  // pins; connect through ad_iobuf, gpio_t high means input

  input   [NUM_OF_GPIO-1:0]   gpio_i,
  output  [NUM_OF_GPIO-1:0]   gpio_o,
  output  [NUM_OF_GPIO-1:0]   gpio_t
);

  reg   [NUM_OF_GPIO-1:0]     gpio_out = DEFAULT_OUT;
  reg   [NUM_OF_GPIO-1:0]     gpio_dir = DEFAULT_DIR;

  wire  [NUM_OF_GPIO-1:0]     gpio_in;
  wire                        rd_valid;

  assign gpio_o = gpio_out;
  assign gpio_t = gpio_dir;

  assign rd_valid = (rd_index < NUM_OF_GPIO);
  assign rd_data  = rd_valid ? {5'h00, gpio_dir[rd_index], gpio_out[rd_index], gpio_in[rd_index]}
                             : 8'h00;

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      gpio_out <= DEFAULT_OUT;
      gpio_dir <= DEFAULT_DIR;
    end else if (wr_en && wr_index < NUM_OF_GPIO) begin
      if (wr_sel) begin
        gpio_dir[wr_index] <= wr_value;
      end else begin
        gpio_out[wr_index] <= wr_value;
      end
    end
  end

  sync_bits #(
    .NUM_OF_BITS (NUM_OF_GPIO),
    .ASYNC_CLK (1)
  ) i_gpio_sync (
    .in_bits (gpio_i),
    .out_clk (clk),
    .out_resetn (resetn),
    .out_bits (gpio_in));

endmodule
