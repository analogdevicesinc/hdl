// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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

module system_top (

  input   [12:0]  gpio_bd_i,
  output  [ 7:0]  gpio_bd_o,

  // dci_p&n enter the chip
  output          dci_p,
  output          dci_n,

  // dco_p&n leave the chip
  input           dco1_p,
  input           dco1_n,

  output  [15:0]  data_p,
  output  [15:0]  data_n,

  output          spi_clk,
  output          spi_dio,
  input           spi_do,
  output          spi_en
);

  // internal signals

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [ 2:0]  spi_csb;

  // defaults

  assign gpio_bd_o = gpio_o[20:13];
  assign gpio_i[94:13] = gpio_o[94:13];
  assign gpio_i[12: 0] = gpio_bd_i;

  assign spi_en = spi_csb[0];

  // instantiations

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (),
    .spi0_csn (spi_csb),
    .spi0_miso (spi_do),
    .spi0_mosi (spi_dio),
    .spi0_sclk (spi_clk),
    .spi1_csn (),
    .spi1_miso (1'b0),
    .spi1_mosi (),
    .spi1_sclk (),
    .dco1_n (dco1_n),
    .dco1_p (dco1_p),
    .dci_n (dci_n),
    .dci_p (dci_p),
    .data_n (data_n),
    .data_p (data_p));

endmodule
