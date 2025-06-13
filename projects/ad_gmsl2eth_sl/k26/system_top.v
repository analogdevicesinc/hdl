// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (
  /*
   * PLL
   */
  output        ref_ad9545_pl,

  input  [ 3:0] mipi_ch0_data_n,
  input  [ 3:0] mipi_ch0_data_p,
  input         mipi_ch0_clk_n,
  input         mipi_ch0_clk_p,

  input  [ 3:0] mipi_ch1_data_n,
  input  [ 3:0] mipi_ch1_data_p,
  input         mipi_ch1_clk_n,
  input         mipi_ch1_clk_p,

  /*
   * Ethernet: SFP+
   */
  input         sfp_rx_p,
  input         sfp_rx_n,
  output        sfp_tx_p,
  output        sfp_tx_n,
  input         sfp_mgt_refclk_p,
  input         sfp_mgt_refclk_n,
  output        sfp_tx_disable,

  inout         sfp_i2c_scl,
  inout         sfp_i2c_sda,
  inout         sfp_i2c_rstn,
  inout         sfp_i2c_en,

  inout         tca_i2c_scl,
  inout         tca_i2c_sda,

  output        ad9545_sclk,
  input         ad9545_miso,
  output        ad9545_mosi,
  output        ad9545_cs,
  output        ad9545_resetb,

  inout         fan_tach,
  inout         fan_pwm,

  output        led0_user,

  output        mfp_3_p1,
  output        mfp_2_p1,
  output        mfp_1_p1,
  output        mfp_0_p1,
  output        mfp_3_p2,
  output        mfp_2_p2,
  output        mfp_1_p2,
  output        mfp_0_p2
);

  wire   [1:0]  sfp_led;

  wire  [94:0]  gpio_i;
  wire  [94:0]  gpio_o;
  wire  [94:0]  gpio_t;
  wire          ap_rstn_frmbuf_0;
  wire          ap_rstn_frmbuf_1;
  wire          ap_rstn_frmbuf_2;
  wire          ap_rstn_frmbuf_3;
  wire          ap_rstn_frmbuf_4;
  wire          ap_rstn_frmbuf_5;
  wire          ap_rstn_frmbuf_6;
  wire          ap_rstn_frmbuf_7;
  wire          csirxss_rstn;

  assign csirxss_rstn = gpio_o[0];
  assign ap_rstn_frmbuf_0 = gpio_o[2];
  assign ap_rstn_frmbuf_1 = gpio_o[3];
  assign ap_rstn_frmbuf_2 = gpio_o[4];
  assign ap_rstn_frmbuf_3 = gpio_o[5];
  assign ap_rstn_frmbuf_4 = gpio_o[6];
  assign ap_rstn_frmbuf_5 = gpio_o[7];
  assign ap_rstn_frmbuf_6 = gpio_o[8];
  assign ap_rstn_frmbuf_7 = gpio_o[9];

  assign sfp_i2c_rstn = gpio_o[10];
  assign sfp_i2c_en = 1'b0;

  ad_iobuf #(
    .DATA_WIDTH(2)
  ) iobuf_0 (
    .dio_t ({gpio_t[23:22]}),
    .dio_i ({gpio_o[23:22]}),
    .dio_o ({gpio_i[23:22]}),
    .dio_p ({
      fan_tach,
      fan_pwm}));

  assign gpio_i[21:0] = gpio_o[21:0];
  assign gpio_i[94:24] = gpio_o[94:24];

  assign ad9545_resetb = 1'b1;
  assign led0_user = sfp_led[0];

  wire  sfp_tx_fault;   // input
  wire  sfp_rx_los;     // input
  wire  sfp_mod_abs;    // input

  assign sfp_tx_fault = 1'b0;
  assign sfp_rx_los = 1'b0;
  assign sfp_mod_abs = 1'b0;

  // instantiations
  system_wrapper i_system_wrapper (
    .ap_rstn_frmbuf_0 (ap_rstn_frmbuf_0),
    .ap_rstn_frmbuf_1 (ap_rstn_frmbuf_1),
    .ap_rstn_frmbuf_2 (ap_rstn_frmbuf_2),
    .ap_rstn_frmbuf_3 (ap_rstn_frmbuf_3),
    .ap_rstn_frmbuf_4 (ap_rstn_frmbuf_4),
    .ap_rstn_frmbuf_5 (ap_rstn_frmbuf_5),
    .ap_rstn_frmbuf_6 (ap_rstn_frmbuf_6),
    .ap_rstn_frmbuf_7 (ap_rstn_frmbuf_7),
    .csirxss_rstn (csirxss_rstn),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .mfp_3_p1 (mfp_3_p1),
    .mfp_2_p1 (mfp_2_p1),
    .mfp_1_p1 (mfp_1_p1),
    .mfp_0_p1 (mfp_0_p1),
    .mfp_3_p2 (mfp_3_p2),
    .mfp_2_p2 (mfp_2_p2),
    .mfp_1_p2 (mfp_1_p2),
    .mfp_0_p2 (mfp_0_p2),
    .mipi_phy_if_0_clk_n (mipi_ch0_clk_n),
    .mipi_phy_if_0_clk_p (mipi_ch0_clk_p),
    .mipi_phy_if_0_data_n (mipi_ch0_data_n),
    .mipi_phy_if_0_data_p (mipi_ch0_data_p),
    .mipi_phy_if_1_clk_n (mipi_ch1_clk_n),
    .mipi_phy_if_1_clk_p (mipi_ch1_clk_p),
    .mipi_phy_if_1_data_n (mipi_ch1_data_n),
    .mipi_phy_if_1_data_p (mipi_ch1_data_p),
    .ref_clk0 (ref_ad9545_pl),
    .sfp_mgt_refclk_n (sfp_mgt_refclk_n),
    .sfp_mgt_refclk_p (sfp_mgt_refclk_p),
    .sfp_rx_n (sfp_rx_n),
    .sfp_rx_p (sfp_rx_p),
    .sfp_tx_n (sfp_tx_n),
    .sfp_tx_p (sfp_tx_p),
    .sfp_tx_disable (sfp_tx_disable),
    .sfp_tx_fault(sfp_tx_fault),
    .sfp_rx_los(sfp_rx_los),
    .sfp_mod_abs(sfp_mod_abs),
    .sfp_iic_scl_io(sfp_i2c_scl),
    .sfp_iic_sda_io(sfp_i2c_sda),
    .tca_iic_scl_io(tca_i2c_scl),
    .tca_iic_sda_io(tca_i2c_sda),
    .led(),
    .sfp_led(sfp_led),
    .spi0_csn (ad9545_cs),
    .spi0_miso (ad9545_miso),
    .spi0_mosi (ad9545_mosi),
    .spi0_sclk (ad9545_sclk));

endmodule
