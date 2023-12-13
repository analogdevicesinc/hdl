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

  // mii interface

  output          reset_a,
  output          mdc_fmc_a,
  inout           mdio_fmc_a,
  input   [3:0]   mii_rxd_a,
  input           mii_rx_dv_a,
  input           mii_rx_clk_a,
  output  [3:0]   mii_txd_a,
  input           mii_rx_er_a,
  output          mii_tx_en_a,
  input           mii_tx_clk_a,
  input           link_st_a,
  input           mii_crs_a,
  input           led_0_a,

  output          reset_b,
  output          mdc_fmc_b,
  inout           mdio_fmc_b,
  input   [3:0]   mii_rxd_b,
  input           mii_rx_er_b,
  input           mii_rx_dv_b,
  input           mii_rx_clk_b,
  output  [3:0]   mii_txd_b,
  output          mii_tx_en_b,
  input           mii_tx_clk_b,
  input           link_st_b,
  input           mii_crs_b,
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

  wire    [ 2:0]  speed_mode_a_s;
  wire    [ 2:0]  speed_mode_b_s;

  wire    [ 3:0]  mii_txd_extra_a;
  wire    [ 3:0]  mii_txd_extra_b;

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;

  assign reset_a = reset;
  assign reset_b = reset;

  // port a - right led (activity/status) yellow only

  assign led_ar_c_c2m = led_0_a;
  assign led_ar_a_c2m = 1'b0;

  // port a - left led (speed mode): 10M=off, 100M=yellow

  assign led_al_c_c2m = speed_mode_a_s[0];
  assign led_al_a_c2m = speed_mode_a_s[1];

  // port b - right led (activity/status) yellow only

  assign led_br_c_c2m = led_0_b;
  assign led_br_a_c2m = 1'b0;

  // port a - left led (speed mode): 10M=off, 100M=yellow

  assign led_bl_c_c2m = speed_mode_b_s[0];
  assign led_bl_a_c2m = speed_mode_b_s[1];

  assign gpio_i[94:36] = gpio_o[94:36];

  assign gpio_i[35] = link_st_a;
  assign gpio_i[34] = link_st_b;

  assign gpio_i[33:21] = gpio_o[33:21];

  assign gpio_i[ 7:0] = gpio_o[7:0];

  assign gpio_bd_o = gpio_o[ 7:0];
  assign gpio_i[20:8] = gpio_bd_i;

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

    .GMII_ENET0_0_col(led_0_a),
    .GMII_ENET0_0_crs(mii_crs_a),
    .GMII_ENET0_0_rx_clk(mii_rx_clk_a),
    .GMII_ENET0_0_rx_dv(mii_rx_dv_a),
    .GMII_ENET0_0_rx_er(mii_rx_er_a),
    .GMII_ENET0_0_rxd({4'h0,mii_rxd_a}),
    .GMII_ENET0_0_tx_clk(mii_tx_clk_a),
    .GMII_ENET0_0_tx_en(mii_tx_en_a),
    .GMII_ENET0_0_tx_er(),
    .GMII_ENET0_0_txd({mii_txd_extra_a,mii_txd_a}),
    .GMII_ENET0_0_speed_mode(speed_mode_a_s),
    .MDIO_ENET0_0_mdc(mdc_fmc_a),
    .MDIO_ENET0_0_mdio_io(mdio_fmc_a),

    .GMII_ENET1_0_col(led_0_b),
    .GMII_ENET1_0_crs(mii_crs_b),
    .GMII_ENET1_0_rx_clk(mii_rx_clk_b),
    .GMII_ENET1_0_rx_dv(mii_rx_dv_b),
    .GMII_ENET1_0_rx_er(mii_rx_er_b),
    .GMII_ENET1_0_rxd({4'h0,mii_rxd_b}),
    .GMII_ENET1_0_tx_clk(mii_tx_clk_b),
    .GMII_ENET1_0_tx_en(mii_tx_en_b),
    .GMII_ENET1_0_tx_er(),
    .GMII_ENET1_0_txd({mii_txd_extra_b,mii_txd_b}),
    .GMII_ENET1_0_speed_mode(speed_mode_b_s),
    .MDIO_ENET1_0_mdc(mdc_fmc_b),
    .MDIO_ENET1_0_mdio_io(mdio_fmc_b));

endmodule
