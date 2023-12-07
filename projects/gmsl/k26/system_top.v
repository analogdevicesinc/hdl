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

  input  [ 3:0] mipi_ch0_data_n,
  input  [ 3:0] mipi_ch0_data_p,
  input         mipi_ch0_clk_n,
  input         mipi_ch0_clk_p,

  input  [ 3:0] mipi_ch1_data_n,
  input  [ 3:0] mipi_ch1_data_p,
  input         mipi_ch1_clk_n,
  input         mipi_ch1_clk_p,

  input         clk_125mhz_p,
  input         clk_125mhz_n,

  input         sfp0_rx_p,
  input         sfp0_rx_n,
  output        sfp0_tx_p,
  output        sfp0_tx_n,

  input         sfp_mgt_refclk_0_p,
  input         sfp_mgt_refclk_0_n,
  inout         sfp_tx_disable,

  output        ad9545_sclk,
  input         ad9545_miso,
  output        ad9545_mosi,
  output        ad9545_cs,
  inout         ad9545_resetb,

  input         refclk_0_p,
  input         refclk_0_n,
  output        refclk_0,

  input         refclk_1_p,
  input         refclk_1_n,
  output        refclk_1,

  input         refclk_2_p,
  input         refclk_2_n,
  output        refclk_2,

  input         uart_rxd,
  output        uart_txd,

  inout         fan_tach1,
  inout         fan_pwm,

  inout [11:0]  crr_gpio,

  inout         led_gpio,
  inout         btn_gpio,

  inout         en_i2c_alt,
  inout         tca_i2c_scl,
  inout         tca_i2c_sda,
  inout         tca_i2c_rstn,

  inout         a_gmsl_pwdnb,
  inout         a_gmsl_mfp0,
  inout         a_gmsl_mfp1,
  inout         a_gmsl_mfp2,
  inout         a_gmsl_mfp3,
  inout         a_gmsl_mfp4,
  inout         a_gmsl_mfp5,
  inout         a_gmsl_mfp6,
  inout         a_gmsl_mfp7,
  inout         a_gmsl_mfp8,

  inout         b_gmsl_pwdnb,
  inout         b_gmsl_mfp0,
  inout         b_gmsl_mfp1,
  inout         b_gmsl_mfp2,
  inout         b_gmsl_mfp3,
  inout         b_gmsl_mfp4,
  inout         b_gmsl_mfp5,
  inout         b_gmsl_mfp6,
  inout         b_gmsl_mfp7,
  inout         b_gmsl_mfp8
);

  wire          csirxss_rstn;
  wire          zynq_pl_reset;
  wire          zynq_pl_clk;
  wire          clk_125mhz_ibufg;
  wire          ap_rstn_frmbuf1;
  wire          ap_rstn_frmbuf2;
  wire          ap_rstn_frmbuf3;
  wire          ap_rstn_frmbuf4;
  wire          ap_rstn_frmbuf5;
  wire          ap_rstn_frmbuf6;
  wire          ap_rstn_frmbuf7;
  wire          ap_rstn_frmbuf8;
  wire          csirxss_rstn1;
  wire          csirxss_rstn2;
  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [94:0]  gpio_t;

  assign gpio_i[94:48] = gpio_o[94:48];

  assign csirxss_rstn = gpio_o[0];
//  assign csirxss_rstn2 = gpio_o[1];

  assign ap_rstn_frmbuf0 = gpio_o[2];
  assign ap_rstn_frmbuf1 = gpio_o[3];
  assign ap_rstn_frmbuf2 = gpio_o[4];
  assign ap_rstn_frmbuf3 = gpio_o[5];
  assign ap_rstn_frmbuf4 = gpio_o[6];
  assign ap_rstn_frmbuf5 = gpio_o[7];
  assign ap_rstn_frmbuf6 = gpio_o[8];
  assign ap_rstn_frmbuf7 = gpio_o[9];
  IBUFGDS #(
    .DIFF_TERM("FALSE"),
    .IBUF_LOW_PWR("FALSE")
  )
  clk_125mhz_ibufg_inst (
    .O   (clk_125mhz_ibufg),
    .I   (clk_125mhz_p),
    .IB  (clk_125mhz_n)
  );

  IBUFDS ibufds_0_ad9545 (
    .I (refclk_0_p),
    .IB (refclk_0_n),
    .O (refclk_0));

  IBUFDS ibufds_1_ad9545 (
    .I (refclk_1_p),
    .IB (refclk_1_n),
    .O (refclk_1));

  IBUFDS ibufds_2_ad9545 (
    .I (refclk_2_p),
    .IB (refclk_2_n),
    .O (refclk_2));

  ad_iobuf #(.DATA_WIDTH(30)) iobuf_0 (
    .dio_t ({gpio_t[39:10]}),
    .dio_i ({gpio_o[39:10]}),
    .dio_o ({gpio_i[39:10]}),
    .dio_p ({
      crr_gpio[11],
      crr_gpio[10],
      crr_gpio[9],
      crr_gpio[8],
      crr_gpio[7],
      crr_gpio[6],
      crr_gpio[5],
      crr_gpio[4],
      crr_gpio[3],
      crr_gpio[2],
      crr_gpio[1],
      crr_gpio[0],
      fan_tach1,
      fan_pwm,
      ad9545_resetb,
      sfp_tx_disable,
      tca_i2c_rstn,
      en_i2c_alt,
      a_gmsl_pwdnb,
//      a_gmsl_mfp0,
//      a_gmsl_mfp1,
//      a_gmsl_mfp2,
//      a_gmsl_mfp3,
      a_gmsl_mfp4,
      a_gmsl_mfp5,
      a_gmsl_mfp6,
      a_gmsl_mfp7,
      a_gmsl_mfp8,
      b_gmsl_pwdnb,
//      b_gmsl_mfp0,
//      b_gmsl_mfp1,
//      b_gmsl_mfp2,
//      b_gmsl_mfp3,
      b_gmsl_mfp4,
      b_gmsl_mfp5,
      b_gmsl_mfp6,
      b_gmsl_mfp7,
      b_gmsl_mfp8}));

  // instantiations
  system_wrapper i_system_wrapper (
    .mipi_csi_ch0_data_n (mipi_ch0_data_n),
    .mipi_csi_ch0_data_p (mipi_ch0_data_p),
    .mipi_csi_ch0_clk_n (mipi_ch0_clk_n),
    .mipi_csi_ch0_clk_p (mipi_ch0_clk_p),
    .mipi_csi_ch1_data_n (mipi_ch1_data_n),
    .mipi_csi_ch1_data_p (mipi_ch1_data_p),
    .mipi_csi_ch1_clk_n (mipi_ch1_clk_n),
    .mipi_csi_ch1_clk_p (mipi_ch1_clk_p),
    .ap_rstn_frmbuf_0 (ap_rstn_frmbuf1),
    .ap_rstn_frmbuf_1 (ap_rstn_frmbuf2),
    .ap_rstn_frmbuf_2 (ap_rstn_frmbuf3),
    .ap_rstn_frmbuf_3 (ap_rstn_frmbuf4),
    .ap_rstn_frmbuf_4 (ap_rstn_frmbuf5),
    .ap_rstn_frmbuf_5 (ap_rstn_frmbuf6),
    .ap_rstn_frmbuf_6 (ap_rstn_frmbuf7),
    .ap_rstn_frmbuf_7 (ap_rstn_frmbuf8),
    .mfp_0_p1(a_gmsl_mfp0),
    .mfp_1_p1(a_gmsl_mfp1),
    .mfp_2_p1(a_gmsl_mfp2),
    .mfp_3_p1(a_gmsl_mfp3),
    .mfp_0_p2(b_gmsl_mfp0),
    .mfp_1_p2(b_gmsl_mfp1),
    .mfp_2_p2(b_gmsl_mfp2),
    .mfp_3_p2(b_gmsl_mfp3),
    .csirxss_rstn (csirxss_rstn),
    .sfp0_rx_n (sfp0_rx_n),
    .sfp0_rx_p (sfp0_rx_p),
    .sfp0_tx_n (sfp0_tx_n),
    .sfp0_tx_p (sfp0_tx_p),
    .sfp_mgt_refclk_0_p (sfp_mgt_refclk_0_p),
    .sfp_mgt_refclk_0_n (sfp_mgt_refclk_0_n),
//    .pps_out(pps_out),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .emio_uart_rxd(uart_rxd),
    .emio_uart_txd(uart_txd),
    .tca_iic_scl_io(tca_i2c_scl),
    .tca_iic_sda_io(tca_i2c_sda),
    .spi0_csn (ad9545_cs),
    .spi0_miso (ad9545_miso),
    .spi0_mosi (ad9545_mosi),
    .spi0_sclk (ad9545_sclk));

endmodule
