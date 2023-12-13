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
  input           rmii_rx_ref_clk_a,
  input   [1:0]   rmii_rxd_a,
  input           rmii_rx_dv_a,
  input           rmii_rx_er_a,
  output  [1:0]   rmii_txd_a,
  output          rmii_tx_en_a,
  input           link_st_a,
  input           led_0_a,
  output          mac_if_sel_0_a,

  output          reset_b,
  output          mdc_fmc_b,
  inout           mdio_fmc_b,
  input           rmii_rx_ref_clk_b,
  input   [1:0]   rmii_rxd_b,
  input           rmii_rx_dv_b,
  input           rmii_rx_er_b,
  output  [1:0]   rmii_txd_b,
  output          rmii_tx_en_b,
  input           link_st_b,
  input           led_0_b,
  output          mac_if_sel_0_b,

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

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;

  wire            sys_reset_a;
  wire            sys_reset_b;
  wire            gpio_reset_a;
  wire            gpio_reset_b;

  // assignments

  assign mac_if_sel_0_a = 1'b1;
  assign mac_if_sel_0_b = 1'b1;

  // port a - right led (activity/status) yellow only

  assign led_ar_c_c2m = led_0_a;
  assign led_ar_a_c2m = 1'b0;

  // port a - left led (speed mode): 10M=off, 100M=yellow

  assign led_al_c_c2m = 1'b1;
  assign led_al_a_c2m = 1'b0;

  // port b - right led (activity/status) yellow only

  assign led_br_c_c2m = led_0_b;
  assign led_br_a_c2m = 1'b0;

  // port a - left led (speed mode): 10M=off, 100M=yellow

  assign led_bl_c_c2m = 1'b1;
  assign led_bl_a_c2m = 1'b0;

  assign gpio_i[94:36] = gpio_o[94:36];

  assign gpio_reset_a = gpio_o[37];
  assign gpio_reset_b = gpio_o[36];

  assign reset_a = sys_reset_a | gpio_reset_a;
  assign reset_b = sys_reset_b | gpio_reset_b;

  assign gpio_i[35] = link_st_a;
  assign gpio_i[34] = link_st_b;
  assign gpio_i[33:21] = gpio_o[33:21];
  assign gpio_i[20:8] = gpio_bd_i;
  assign gpio_i[ 7:0] = gpio_o[7:0];

  assign gpio_bd_o = gpio_o[ 7:0];

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
    .reset_a (sys_reset_a),
    .reset_b (sys_reset_b),
    .ref_clk_50_a (rmii_rx_ref_clk_a),
    .ref_clk_50_b (rmii_rx_ref_clk_b),
    .MDIO_ENET0_0_mdc(mdc_fmc_a),
    .MDIO_ENET0_0_mdio_io(mdio_fmc_a),
    .RMII_PHY_M_0_crs_dv (rmii_rx_dv_a),
    .RMII_PHY_M_0_rx_er (rmii_rx_er_a),
    .RMII_PHY_M_0_rxd (rmii_rxd_a),
    .RMII_PHY_M_0_tx_en (rmii_tx_en_a),
    .RMII_PHY_M_0_txd (rmii_txd_a),
    .MDIO_ENET1_0_mdc(mdc_fmc_b),
    .MDIO_ENET1_0_mdio_io(mdio_fmc_b),
    .RMII_PHY_M_1_crs_dv (rmii_rx_dv_b),
    .RMII_PHY_M_1_rx_er (rmii_rx_er_b),
    .RMII_PHY_M_1_rxd (rmii_rxd_b),
    .RMII_PHY_M_1_tx_en (rmii_tx_en_b),
    .RMII_PHY_M_1_txd (rmii_txd_b));

endmodule
