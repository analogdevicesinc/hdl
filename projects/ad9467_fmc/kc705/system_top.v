// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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

  input                   sys_rst,
  input                   sys_clk_p,
  input                   sys_clk_n,

  input                   uart_sin,
  output                  uart_sout,

  output      [ 2:0]      ddr3_1_n,
  output      [ 1:0]      ddr3_1_p,
  output                  ddr3_reset_n,
  output      [13:0]      ddr3_addr,
  output      [ 2:0]      ddr3_ba,
  output                  ddr3_cas_n,
  output                  ddr3_ras_n,
  output                  ddr3_we_n,
  output      [ 0:0]      ddr3_ck_n,
  output      [ 0:0]      ddr3_ck_p,
  output      [ 0:0]      ddr3_cke,
  output      [ 0:0]      ddr3_cs_n,
  output      [ 7:0]      ddr3_dm,
  inout       [63:0]      ddr3_dq,
  inout       [ 7:0]      ddr3_dqs_n,
  inout       [ 7:0]      ddr3_dqs_p,
  output      [ 0:0]      ddr3_odt,

  output                  mdio_mdc,
  inout                   mdio_mdio,
  output                  mii_rst_n,
  input                   mii_col,
  input                   mii_crs,
  input                   mii_rx_clk,
  input                   mii_rx_er,
  input                   mii_rx_dv,
  input       [ 3:0]      mii_rxd,
  input                   mii_tx_clk,
  output                  mii_tx_en,
  output      [ 3:0]      mii_txd,

  output      [26:1]      linear_flash_addr,
  output                  linear_flash_adv_ldn,
  output                  linear_flash_ce_n,
  inout       [15:0]      linear_flash_dq_io,
  output                  linear_flash_oen,
  output                  linear_flash_wen,

  output                  fan_pwm,

  inout       [ 6:0]      gpio_lcd,
  inout       [16:0]      gpio_bd,

  output                  iic_rstn,
  inout                   iic_scl,
  inout                   iic_sda,

  input                   adc_clk_in_n,
  input                   adc_clk_in_p,
  input       [ 7:0]      adc_data_in_n,
  input       [ 7:0]      adc_data_in_p,
  input                   adc_data_or_n,
  input                   adc_data_or_p,
  output                  spi_clk,
  output                  spi_csn_adc,
  output                  spi_csn_clk,
  inout                   spi_sdio);

  // internal signals
  wire   [ 7:0]   spi_csn;
  wire            spi_miso;
  wire            spi_mosi;

  wire   [63:0]   gpio_i;
  wire   [63:0]   gpio_o;
  wire   [63:0]   gpio_t;

  assign ddr3_1_p = 2'b11;
  assign ddr3_1_n = 3'b000;
  assign fan_pwm = 1'b1;
  assign iic_rstn = 1'b1;

  assign spi_csn_adc = spi_csn[0];
  assign spi_csn_clk = spi_csn[1];

  ad9467_spi i_spi (
      .spi_csn(spi_csn[1:0]),
      .spi_clk(spi_clk),
      .spi_mosi(spi_mosi),
      .spi_miso(spi_miso),
      .spi_sdio(spi_sdio)
      );

  ad_iobuf #(.DATA_WIDTH(17)) i_iobuf_sw_led (
     .dio_t (gpio_t[16:0]),
     .dio_i (gpio_o[16:0]),
     .dio_o (gpio_i[16:0]),
     .dio_p (gpio_bd));

  assign gpio_i[63:32] = gpio_o[63:32];
  assign gpio_i[31:17] = gpio_o[31:17];

  system_wrapper i_system_wrapper (
      .ddr3_addr (ddr3_addr),
      .ddr3_ba (ddr3_ba),
      .ddr3_cas_n (ddr3_cas_n),
      .ddr3_ck_n (ddr3_ck_n),
      .ddr3_ck_p (ddr3_ck_p),
      .ddr3_cke (ddr3_cke),
      .ddr3_cs_n (ddr3_cs_n),
      .ddr3_dm (ddr3_dm),
      .ddr3_dq (ddr3_dq),
      .ddr3_dqs_n (ddr3_dqs_n),
      .ddr3_dqs_p (ddr3_dqs_p),
      .ddr3_odt (ddr3_odt),
      .ddr3_ras_n (ddr3_ras_n),
      .ddr3_reset_n (ddr3_reset_n),
      .ddr3_we_n (ddr3_we_n),
      .gpio_lcd_tri_io (gpio_lcd),
      .gpio0_o (gpio_o[31:0]),
      .gpio0_t (gpio_t[31:0]),
      .gpio0_i (gpio_i[31:0]),
      .gpio1_o (gpio_o[63:32]),
      .gpio1_t (gpio_t[63:32]),
      .gpio1_i (gpio_i[63:32]),
      .iic_main_scl_io (iic_scl),
      .iic_main_sda_io (iic_sda),
      .mdio_mdc (mdio_mdc),
      .mdio_mdio_io (mdio_mdio),
      .mii_col (mii_col),
      .mii_crs (mii_crs),
      .mii_rst_n (mii_rst_n),
      .mii_rx_clk (mii_rx_clk),
      .mii_rx_dv (mii_rx_dv),
      .mii_rx_er (mii_rx_er),
      .mii_rxd (mii_rxd),
      .mii_tx_clk (mii_tx_clk),
      .mii_tx_en (mii_tx_en),
      .mii_txd (mii_txd),
      .linear_flash_addr (linear_flash_addr),
      .linear_flash_adv_ldn (linear_flash_adv_ldn),
      .linear_flash_ce_n (linear_flash_ce_n),
      .linear_flash_dq_io (linear_flash_dq_io),
      .linear_flash_oen (linear_flash_oen),
      .linear_flash_wen (linear_flash_wen),
      .sys_clk_n (sys_clk_n),
      .sys_clk_p (sys_clk_p),
      .sys_rst (sys_rst),
      .uart_sin (uart_sin),
      .uart_sout (uart_sout),
      .adc_clk_in_n (adc_clk_in_n),
      .adc_clk_in_p (adc_clk_in_p),
      .adc_data_in_n (adc_data_in_n),
      .adc_data_in_p (adc_data_in_p),
      .adc_data_or_n (adc_data_or_n),
      .adc_data_or_p (adc_data_or_p),
      .spi_clk_i (1'b0),
      .spi_clk_o (spi_clk),
      .spi_csn_i (1'b1),
      .spi_csn_o (spi_csn),
      .spi_sdi_i (spi_miso),
      .spi_sdo_i (1'b0),
      .spi_sdo_o (spi_mosi));

  endmodule

// ***************************************************************************
// ***************************************************************************
