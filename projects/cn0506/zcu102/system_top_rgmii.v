// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

  input           ref_clk_125_p,
  input           ref_clk_125_n,

  // RGMII interface

  output          reset_a,
  output          mdc_fmc_a,
  inout           mdio_fmc_a,
  input   [3:0]   rgmii_rxd_a,
  input           rgmii_rx_ctl_a,
  input           rgmii_rxc_a,
  output  [3:0]   rgmii_txd_a,
  output          rgmii_tx_ctl_a,
  output          rgmii_txc_a,
  input           link_st_a,
  input           int_n_a,
  input           led_0_a,

  output          reset_b,
  output          mdc_fmc_b,
  inout           mdio_fmc_b,
  input   [3:0]   rgmii_rxd_b,
  input           rgmii_rx_ctl_b,
  input           rgmii_rxc_b,
  output  [3:0]   rgmii_txd_b,
  output          rgmii_tx_ctl_b,
  output          rgmii_txc_b,
  input           link_st_b,
  input           int_n_b,
  input           led_0_b,

  // LEDs

  output          led_ar_c_c2m,
  output          led_ar_a_c2m,
  output          led_al_c_c2m,
  output          led_al_a_c2m,

  output          led_br_c_c2m,
  output          led_br_a_c2m,
  output          led_bl_c_c2m,
  output          led_bl_a_c2m
);

  // internal signals

  wire            reset;

  wire    [ 1:0]  speed_mode_a_s;
  wire    [ 1:0]  speed_mode_b_s;

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;

  assign reset_a = reset;
  assign reset_b = reset;

  // port a - right led (activity/status) yellow only

  assign led_ar_c_c2m = led_0_a;
  assign led_ar_a_c2m = 1'b0;

  // port a - left led (speed mode): 10M=off, 100M=yellow, 1G=green

  assign led_al_c_c2m = speed_mode_a_s[0];
  assign led_al_a_c2m = speed_mode_a_s[1];

  // port b - right led (activity/status) yellow only

  assign led_br_c_c2m = led_0_b;
  assign led_br_a_c2m = 1'b0;

  // port a - left led (speed mode): 10M=off, 100M=yellow, 1G=green

  assign led_bl_c_c2m = speed_mode_b_s[0];
  assign led_bl_a_c2m = speed_mode_b_s[1];

  assign gpio_i[94:36] = gpio_o[94:36];

  assign gpio_i[35] = link_st_a;
  assign gpio_i[34] = link_st_b;
  assign gpio_i[33] = int_n_a;
  assign gpio_i[32] = int_n_b;

  assign gpio_i[31:21] = gpio_o[31:21];

  assign gpio_i[ 7:0] = gpio_o[7:0];

  assign gpio_bd_o = gpio_o[ 7:0];
  assign gpio_i[20:8] = gpio_bd_i;

  IBUFDS i_ibufds_sysref_1 (
    .I (ref_clk_125_p),
    .IB (ref_clk_125_n),
    .O (ref_clk_125));

  // instantiations

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

    .reset (reset),

    .clock_speed_0(),
    .MDIO_PHY_0_mdc (mdc_fmc_a),
    .MDIO_PHY_0_mdio_io (mdio_fmc_a),
    .RGMII_0_rd (rgmii_rxd_a),
    .RGMII_0_rx_ctl (rgmii_rx_ctl_a),
    .RGMII_0_rxc (rgmii_rxc_a),
    .RGMII_0_td (rgmii_txd_a),
    .RGMII_0_tx_ctl (rgmii_tx_ctl_a),
    .RGMII_0_txc (rgmii_txc_a),
    .ref_clk_125 (ref_clk_125),
    .speed_mode_a (speed_mode_a_s),

    .MDIO_PHY_1_mdc (mdc_fmc_b),
    .MDIO_PHY_1_mdio_io (mdio_fmc_b),
    .RGMII_1_rd (rgmii_rxd_b),
    .RGMII_1_rx_ctl (rgmii_rx_ctl_b),
    .RGMII_1_rxc (rgmii_rxc_b),
    .RGMII_1_td (rgmii_txd_b),
    .RGMII_1_tx_ctl (rgmii_tx_ctl_b),
    .RGMII_1_txc (rgmii_txc_b),
    .speed_mode_b (speed_mode_b_s));

endmodule
