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

  input       [12:0]      gpio_bd_i,
  output      [ 7:0]      gpio_bd_o,

  output                  gpio0,
  output                  gpio1,
  output                  gpio2,
  output                  gpio3,
  output                  gpio4,
  output                  gpio5,
  output                  gpio6,
  output                  gpio7,

  output                  spi_sel_a,
  output                  spi_clk,
  output                  spi_mosi,
  input                   spi_miso);

  // internal signals

  wire        [94:0]      gpio_i;
  wire        [94:0]      gpio_o;
  wire        [94:0]      gpio_t;
  wire        [20:0]      gpio_bd;
  wire        [ 2:0]      spi0_csn;

  // instantiations

  assign gpio_bd_o = gpio_o[20:13];
  
  assign gpio_i[12: 0] = gpio_bd_i;
  assign gpio_i[94:13] = gpio_o[94:13];
  
  assign gpio0 = gpio_o[32];
  assign gpio1 = gpio_o[33];
  assign gpio2 = gpio_o[34];
  assign gpio3 = gpio_o[35];
  assign gpio4 = gpio_o[36];
  assign gpio5 = gpio_o[37];
  assign gpio6 = gpio_o[38];
  assign gpio7 = gpio_o[39];
  
  assign spi_sel_a = spi0_csn[0];

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (),
    .spi0_sclk (spi_clk),
    .spi0_csn (spi0_csn),
    .spi0_miso (spi_miso),
    .spi0_mosi (spi_mosi),
    .spi1_sclk (),
    .spi1_csn (),
    .spi1_miso (1'b0),
    .spi1_mosi ());

endmodule

// ***************************************************************************
// ***************************************************************************
