// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

  // BF SPI 01
  output       BF_SPI_SCLK_01,
  output       BF_SPI_CSB_01,
  output       BF_SPI_MOSI_01,
  input        BF_SPI_MISO_01,

  // BF SPI 02
  output       BF_SPI_SCLK_02,
  output       BF_SPI_CSB_02,
  output       BF_SPI_MOSI_02,
  input        BF_SPI_MISO_02,

  // BF SPI 03
  output       BF_SPI_SCLK_03,
  output       BF_SPI_CSB_03,
  output       BF_SPI_MOSI_03,
  input        BF_SPI_MISO_03,

  // BF SPI 04
  output       BF_SPI_SCLK_04,
  output       BF_SPI_CSB_04,
  output       BF_SPI_MOSI_04,
  input        BF_SPI_MISO_04,

  // XUD SPI
  output       XUD_SPI_SCLK,
  output       XUD_SPI_CSB,
  output       XUD_SPI_MOSI,
  input        XUD_SPI_MISO,

  // BF GPIO
  output BF_TR,
  output BF_TX_LOAD,
  output BF_RX_LOAD,

  // BF GPIO 01
  input  PG_PA_VGG_01,
  output BF_PWR_EN_01,
  output BF_PA_ON_01,

  // BF GPIO 02
  input  PG_PA_VGG_02,
  output BF_PWR_EN_02,
  output BF_PA_ON_02,

  // BF GPIO 03
  input  PG_PA_VGG_03,
  output BF_PWR_EN_03,
  output BF_PA_ON_03,

  // BF GPIO 04
  input  PG_PA_VGG_04,
  output BF_PWR_EN_04,
  output BF_PA_ON_04,

  // XUD GPIO
  output XUD_RX_GAIN_MODE,
  output XUD_PLL_OUTPUT_SEL,
  output XUD_TXRX0,
  output XUD_TXRX1,
  output XUD_TXRX2,
  output XUD_TXRX3
);

  // internal signals
  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;

  assign gpio_bd_o = gpio_o[7:0];

  assign gpio_i[94:21] = gpio_o[94:21];
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];

  wire  [20:0]  adsy2301_gpio;

  assign BF_TR              = adsy2301_gpio[0];
  assign BF_TX_LOAD         = adsy2301_gpio[1];
  assign BF_RX_LOAD         = adsy2301_gpio[2];
  assign BF_PWR_EN_01       = adsy2301_gpio[3];
  assign BF_PA_ON_01        = adsy2301_gpio[4];
  assign BF_PWR_EN_02       = adsy2301_gpio[5];
  assign BF_PA_ON_02        = adsy2301_gpio[6];
  assign BF_PWR_EN_03       = adsy2301_gpio[7];
  assign BF_PA_ON_03        = adsy2301_gpio[8];
  assign BF_PWR_EN_04       = adsy2301_gpio[9];
  assign BF_PA_ON_04        = adsy2301_gpio[10];
  assign XUD_RX_GAIN_MODE   = adsy2301_gpio[11];
  assign XUD_PLL_OUTPUT_SEL = adsy2301_gpio[12];
  assign XUD_TXRX0          = adsy2301_gpio[13];
  assign XUD_TXRX1          = adsy2301_gpio[14];
  assign XUD_TXRX2          = adsy2301_gpio[15];
  assign XUD_TXRX3          = adsy2301_gpio[16];

  assign adsy2301_gpio[17]  = PG_PA_VGG_01;
  assign adsy2301_gpio[18]  = PG_PA_VGG_02;
  assign adsy2301_gpio[19]  = PG_PA_VGG_03;
  assign adsy2301_gpio[20]  = PG_PA_VGG_04;

  // instantiations

  system_wrapper i_system_wrapper (
    .gpio_out_tri_o(adsy2301_gpio[16:0]),
    .gpio_in_tri_i(adsy2301_gpio[20:17]),
    .bf_spi_sclk_01(BF_SPI_SCLK_01),
    .bf_spi_csb_01(BF_SPI_CSB_01),
    .bf_spi_mosi_01(BF_SPI_MOSI_01),
    .bf_spi_miso_01(BF_SPI_MISO_01),
    .bf_spi_sclk_02(BF_SPI_SCLK_02),
    .bf_spi_csb_02(BF_SPI_CSB_02),
    .bf_spi_mosi_02(BF_SPI_MOSI_02),
    .bf_spi_miso_02(BF_SPI_MISO_02),
    .bf_spi_sclk_03(BF_SPI_SCLK_03),
    .bf_spi_csb_03(BF_SPI_CSB_03),
    .bf_spi_mosi_03(BF_SPI_MOSI_03),
    .bf_spi_miso_03(BF_SPI_MISO_03),
    .bf_spi_sclk_04(BF_SPI_SCLK_04),
    .bf_spi_csb_04(BF_SPI_CSB_04),
    .bf_spi_mosi_04(BF_SPI_MOSI_04),
    .bf_spi_miso_04(BF_SPI_MISO_04),
    .xud_spi_sclk(XUD_SPI_SCLK),
    .xud_spi_csb(XUD_SPI_CSB),
    .xud_spi_mosi(XUD_SPI_MOSI),
    .xud_spi_miso(XUD_SPI_MISO),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t ());

endmodule
