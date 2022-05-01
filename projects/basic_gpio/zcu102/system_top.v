// ***************************************************************************
// ***************************************************************************
// Copyright 2021 (c) Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

module system_top (
  output [ 7:0] tdd_out
);
  // internal signals

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [94:0]  gpio_t;
  
  wire    [ 2: 0] spi0_csn;
  wire            spi0_sclk;
  wire            spi0_mosi;
  wire            spi0_miso;
  wire    [ 2: 0] spi1_csn;
  wire            spi1_sclk;
  wire            spi1_mosi;
  wire            spi1_miso;

  // Unused GPIOs
  assign gpio_i[94:0] = 'h0;

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .spi0_csn (spi0_csn),
    .spi0_sclk (spi0_sclk),
    .spi0_mosi (spi0_mosi),
    .spi0_miso (spi0_miso),
    .spi1_csn (spi1_csn),
    .spi1_sclk (spi1_sclk),
    .spi1_mosi (spi1_mosi),
    .spi1_miso (spi1_miso),
    .tdd_out   (tdd_out)
  );

endmodule

// ***************************************************************************
// ***************************************************************************
