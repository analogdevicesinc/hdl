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

  input [3:0]  mipi_csi1_data_n,
  input [3:0]  mipi_csi1_data_p,
  input        mipi_csi1_clk_n,
  input        mipi_csi1_clk_p,

  input [3:0]  mipi_csi2_data_n,
  input [3:0]  mipi_csi2_data_p,
  input        mipi_csi2_clk_n,
  input        mipi_csi2_clk_p,

//  output     pps_out,
  input        sfp_rx_n,
  input        sfp_rx_p,
  output       sfp_tx_n,
  output       sfp_tx_p,

  input        sfp_ref_clk_p,
  input        sfp_ref_clk_n,

  output       ad9545_sclk,
  input        ad9545_miso,
  output       ad9545_mosi,
  output       ad9545_cs,
  inout        ad9545_resetb,

  input        refclk_0_p,
  input        refclk_0_n,
  output       refclk_0,

  input        refclk_1_p,
  input        refclk_1_n,
  output       refclk_1,

  input        uart_rxd,
  output       uart_txd,

  inout        fan_tach1,
  inout        fan_tach2,
  inout        fan_pwm,

  inout [11:0] crr_gpio,

  inout        led_gpio,
  inout        btn_gpio,

  inout        sfp_tx_disable,

  inout        tca_i2c_scl,
  inout        tca_i2c_sda,
  inout        tca_i2c_rstn,

  inout        a_gmsl_pwdnb,
  inout        a_gmsl_mfp0,
  inout        a_gmsl_mfp1,
  inout        a_gmsl_mfp2,
  inout        a_gmsl_mfp3,
  inout        a_gmsl_mfp4,
  inout        a_gmsl_mfp5,

  inout        b_gmsl_pwdnb,
  inout        b_gmsl_mfp0,
  inout        b_gmsl_mfp1,
  inout        b_gmsl_mfp2,
  inout        b_gmsl_mfp3,
  inout        b_gmsl_mfp4,
  inout        b_gmsl_mfp5
);

  wire            ap_rstn_frmbuf;
  wire            ap_rstn_v_proc;
  wire            csirxss_rstn;
//  wire            pps_out;

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [94:0]  gpio_t;

//  assign gpio_i[94:0] = gpio_o[94:0];

//  assign csirxss_rstn = gpio_o[1];
//  assign ap_rstn_frmbuf = gpio_o[2];
//  assign ap_rstn_v_proc = gpio_o[3];

  IBUFDS ibufds_0_ad9545 (
    .I (refclk_0_p),
    .IB (refclk_0_n),
    .O (refclk_0));

  IBUFDS ibufds_1_ad9545 (
    .I (refclk_1_p),
    .IB (refclk_1_n),
    .O (refclk_1));

  ad_iobuf #(.DATA_WIDTH(35)) iobuf_0 (
    .dio_t ({gpio_t[34:0]}),
    .dio_i ({gpio_o[34:0]}),
    .dio_o ({gpio_i[34:0]}),
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
              fan_tach2,
              fan_pwm,
              ad9545_resetb,
              sfp_tx_disable,
              tca_i2c_rstn,
              ap_rstn_v_proc,
              ap_rstn_frmbuf,
              csirxss_rstn,
              a_gmsl_pwdnb,
              a_gmsl_mfp0,
              a_gmsl_mfp1,
              a_gmsl_mfp2,
              a_gmsl_mfp3,
              a_gmsl_mfp4,
              a_gmsl_mfp5,
              b_gmsl_pwdnb,
              b_gmsl_mfp0,
              b_gmsl_mfp1,
              b_gmsl_mfp2,
              b_gmsl_mfp3,
              b_gmsl_mfp4,
              b_gmsl_mfp5}));

  // instantiations
  system_wrapper i_system_wrapper (
    .mipi_csi1_data_n (mipi_csi1_data_n),
    .mipi_csi1_data_p (mipi_csi1_data_p),
    .mipi_csi1_clk_n (mipi_csi1_clk_n),
    .mipi_csi1_clk_p (mipi_csi1_clk_p),

    .mipi_csi2_data_n (mipi_csi2_data_n),
    .mipi_csi2_data_p (mipi_csi2_data_p),
    .mipi_csi2_clk_n (mipi_csi2_clk_n),
    .mipi_csi2_clk_p (mipi_csi2_clk_p),

    .ap_rstn_frmbuf (ap_rstn_frmbuf),
    .csirxss_rstn (csirxss_rstn),
    .ap_rstn_v_proc (ap_rstn_v_proc),

    .sfp_txr_grx_n (sfp_rx_n),
    .sfp_txr_grx_p (sfp_rx_p),
    .sfp_txr_gtx_n (sfp_tx_n),
    .sfp_txr_gtx_p (sfp_tx_p),

    .sfp_ref_clk_0_clk_n (sfp_ref_clk_n),
    .sfp_ref_clk_0_clk_p (sfp_ref_clk_p),

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
