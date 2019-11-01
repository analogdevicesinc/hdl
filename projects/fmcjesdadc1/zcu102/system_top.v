
// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2019 (c) Analog Devices, Inc. All rights reserved.
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

  input                   rx_ref_clk_p,
  input                   rx_ref_clk_n,
  output                  rx_sysref,
  output                  rx_sync,
  input       [ 3:0]      rx_data_p,
  input       [ 3:0]      rx_data_n,

  output                  spi_csn_0,
  output                  spi_clk,
  inout                   spi_sdio);

  // internal signals

  wire        [94:0]      gpio_i;
  wire        [94:0]      gpio_o;
  wire        [94:0]      gpio_t;
  wire        [20:0]      gpio_bd;
  wire        [ 2:0]      spi_csn;
  wire                    spi_mosi;
  wire                    spi_miso;
  wire                    rx_ref_clk;
  wire                    rx_clk;

  // spi

  assign spi_csn_0 = spi_csn[0];

  // instantiations

  IBUFDS_GTE4 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (rx_ref_clk_p),
    .IB (rx_ref_clk_n),
    .O (rx_ref_clk),
    .ODIV2 ());

  fmcjesdadc1_spi i_fmcjesdadc1_spi (
    .spi_csn (spi_csn_0),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio));

  ad_sysref_gen #(.SYSREF_PERIOD(64)) i_sysref (
    .core_clk (rx_clk),
    .sysref_en (gpio_o[32]),
    .sysref_out (rx_sysref));

  assign gpio_i[94:32] = gpio_o[94:32];
  assign gpio_i[31:21] = gpio_o[31:21];

  assign gpio_i[20:8] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[ 7:0];

  assign gpio_i[ 7:0] = gpio_o[ 7:0];

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .rx_data_0_n (rx_data_n[0]),
    .rx_data_0_p (rx_data_p[0]),
    .rx_data_1_n (rx_data_n[1]),
    .rx_data_1_p (rx_data_p[1]),
    .rx_data_2_n (rx_data_n[2]),
    .rx_data_2_p (rx_data_p[2]),
    .rx_data_3_n (rx_data_n[3]),
    .rx_data_3_p (rx_data_p[3]),
    .rx_ref_clk_0 (rx_ref_clk),
    .rx_sync_0 (rx_sync),
    .rx_sysref_0 (rx_sysref),
    .rx_core_clk (rx_clk),
    .spi0_csn (spi_csn),
    .spi0_miso (spi_miso),
    .spi0_mosi (spi_mosi),
    .spi0_sclk (spi_clk),
    .spi1_csn (),
    .spi1_miso (1'd0),
    .spi1_mosi (),
    .spi1_sclk ());

endmodule

// ***************************************************************************
// ***************************************************************************
