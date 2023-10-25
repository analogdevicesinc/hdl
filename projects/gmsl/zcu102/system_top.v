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

// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2019-2023 The Regents of the University of California
 * Copyright (c) 2021-2023 MissingLinkElectronics Inc.
 */

`timescale 1ns/100ps

module system_top (

  input       [12:0]      gpio_bd_i,
  output      [ 7:0]      gpio_bd_o,

  input       [ 3:0]      mipi_ch0_data_n,
  input       [ 3:0]      mipi_ch0_data_p,
  input                   mipi_ch0_clk_n,
  input                   mipi_ch0_clk_p,

  input                   bg3_pin6_nc_0,

  /*
  * Clock: 125MHz LVDS
  */
  input                   clk_125mhz_p,
  input                   clk_125mhz_n,
  input                   clk_user_si570_p,
  input                   clk_user_si570_n,

  /*
   * Ethernet: SFP+
  */
  input                   sfp0_rx_p,
  input                   sfp0_rx_n,
  output                  sfp0_tx_p,
  output                  sfp0_tx_n,
  input                   sfp1_rx_p,
  input                   sfp1_rx_n,
  output                  sfp1_tx_p,
  output                  sfp1_tx_n,
  input                   sfp2_rx_p,
  input                   sfp2_rx_n,
  output                  sfp2_tx_p,
  output                  sfp2_tx_n,
  input                   sfp3_rx_p,
  input                   sfp3_rx_n,
  output                  sfp3_tx_p,
  output                  sfp3_tx_n,
  input                   sfp_mgt_refclk_0_p,
  input                   sfp_mgt_refclk_0_n,
  output                  sfp0_tx_disable_b,
  output                  sfp1_tx_disable_b,
  output                  sfp2_tx_disable_b,
  output                  sfp3_tx_disable_b
);

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire            ap_rstn_frmbuf;
  wire            ap_rstn_frmbuf1;
  wire            ap_rstn_frmbuf2;
  wire            ap_rstn_frmbuf3;
  wire            csirxss_rstn;
  wire            zynq_pl_reset;
  wire            zynq_pl_clk;

  assign gpio_i[94:26] = gpio_o[94:26];

  assign csirxss_rstn = gpio_o[21];
  assign ap_rstn_frmbuf = gpio_o[22];
  assign ap_rstn_frmbuf1 = gpio_o[23];
  assign ap_rstn_frmbuf2 = gpio_o[24];
  assign ap_rstn_frmbuf3 = gpio_o[25];

  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[ 7: 0];

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
    .ap_rstn_frmbuf1 (ap_rstn_frmbuf1),
    .ap_rstn_frmbuf2 (ap_rstn_frmbuf2),
    .ap_rstn_frmbuf3 (ap_rstn_frmbuf3),
    .csirxss_rstn (csirxss_rstn),

    .mipi_csi_ch0_data_n (mipi_ch0_data_n),
    .mipi_csi_ch0_data_p (mipi_ch0_data_p),
    .mipi_csi_ch0_clk_n (mipi_ch0_clk_n),
    .mipi_csi_ch0_clk_p (mipi_ch0_clk_p),

    .clk_125mhz_p (clk_125mhz_p),
    .clk_125mhz_n (clk_125mhz_n),
    .clk_user_si570_p (clk_user_si570_p),
    .clk_user_si570_n (clk_user_si570_n),
    .sfp0_rx_p (sfp0_rx_p),
    .sfp0_rx_n (sfp0_rx_n),
    .sfp0_tx_p (sfp0_tx_p),
    .sfp0_tx_n (sfp0_tx_n),
    .sfp1_rx_p (sfp1_rx_p),
    .sfp1_rx_n (sfp1_rx_n),
    .sfp1_tx_p (sfp1_tx_p),
    .sfp1_tx_n (sfp1_tx_n),
    .sfp2_rx_p (sfp2_rx_p),
    .sfp2_rx_n (sfp2_rx_n),
    .sfp2_tx_p (sfp2_tx_p),
    .sfp2_tx_n (sfp2_tx_n),
    .sfp3_rx_p (sfp3_rx_p),
    .sfp3_rx_n (sfp3_rx_n),
    .sfp3_tx_p (sfp3_tx_p),
    .sfp3_tx_n (sfp3_tx_n),
    .sfp_mgt_refclk_0_p (sfp_mgt_refclk_0_p),
    .sfp_mgt_refclk_0_n (sfp_mgt_refclk_0_n),
    .sfp0_tx_disable_b (sfp0_tx_disable_b),
    .sfp1_tx_disable_b (sfp1_tx_disable_b),
    .sfp2_tx_disable_b (sfp2_tx_disable_b),
    .sfp3_tx_disable_b (sfp3_tx_disable_b));

endmodule
