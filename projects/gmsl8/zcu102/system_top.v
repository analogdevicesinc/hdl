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
// freedoms and responsabilities that he or she has by using this source/core.
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

  input   [12:0]    gpio_bd_i,
  output  [ 7:0]    gpio_bd_o,

  output            gpio_pmod_0,

  input    [3:0]    mipi_ch0_data_n,
  input    [3:0]    mipi_ch0_data_p,
  input             mipi_ch0_clk_n,
  input             mipi_ch0_clk_p,

  input             bg3_pin6_nc_0
);

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire            ap_rstn_frmbuf;
  wire            csirxss_rstn;

  assign gpio_pmod_0 = gpio_o[23];

  assign gpio_i[94:24] = gpio_o[94:24];

  assign gpio_i[ 7:0] = gpio_o[7:0];

  assign csirxss_rstn = gpio_o[22];
  assign ap_rstn_frmbuf = gpio_o[21];

  assign gpio_bd_o = gpio_o[ 7:0];
  assign gpio_i[20:8] = gpio_bd_i;

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (),

    .spi0_csn (),
    .spi0_miso (1'b0),
    .spi0_mosi (),
    .spi0_sclk (),
    .spi1_csn (),
    .spi1_miso (1'b0),
    .spi1_mosi (),
    .spi1_sclk (),
    .bg3_pin6_nc (bg3_pin6_nc_0),
    .ap_rstn_frmbuf (ap_rstn_frmbuf),
    .csirxss_rstn (csirxss_rstn),

    .mipi_csi_ch0_data_n (mipi_ch0_data_n),
    .mipi_csi_ch0_data_p (mipi_ch0_data_p),
    .mipi_csi_ch0_clk_n (mipi_ch0_clk_n),
    .mipi_csi_ch0_clk_p (mipi_ch0_clk_p));

endmodule
