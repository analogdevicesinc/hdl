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

  input           sys_rst,
  input           sys_clk_p,
  input           sys_clk_n,

  input           uart_sin,
  output          uart_sout,

  output          ddr3_reset_n,
  output  [13:0]  ddr3_addr,
  output  [ 2:0]  ddr3_ba,
  output          ddr3_cas_n,
  output          ddr3_ras_n,
  output          ddr3_we_n,
  output  [ 0:0]  ddr3_ck_n,
  output  [ 0:0]  ddr3_ck_p,
  output  [ 0:0]  ddr3_cke,
  output  [ 0:0]  ddr3_cs_n,
  output  [ 7:0]  ddr3_dm,
  inout   [63:0]  ddr3_dq,
  inout   [ 7:0]  ddr3_dqs_n,
  inout   [ 7:0]  ddr3_dqs_p,
  output  [ 0:0]  ddr3_odt,

  output  [26:1]  linear_flash_addr,
  output          linear_flash_adv_ldn,
  output          linear_flash_ce_n,
  inout   [15:0]  linear_flash_dq_io,
  output          linear_flash_oen,
  output          linear_flash_wen,

  output          fan_pwm,

  input   [12:0]  gpio_bd_i,
  output  [ 7:0]  gpio_bd_o,

  output          iic_rstn,
  inout           iic_scl,
  inout           iic_sda,

  input           rx_ref_clk_p,
  input           rx_ref_clk_n,
  input           rx_sysref_p,
  input           rx_sysref_n,
  output          rx_sync_p,
  output          rx_sync_n,
  input   [ 3:0]  rx_data_p,
  input   [ 3:0]  rx_data_n,

  input           tx_ref_clk_p,
  input           tx_ref_clk_n,
  input           tx_sysref_p,
  input           tx_sysref_n,
  input           tx_sync_p,
  input           tx_sync_n,
  output  [ 3:0]  tx_data_p,
  output  [ 3:0]  tx_data_n,

  input           trig_p,
  input           trig_n,

  input           adc_fdb,
  input           adc_fda,
  input           dac_irq,
  input   [ 1:0]  clkd_status,

  output          adc_pd,
  output          dac_txen,
  output          dac_reset,
  output          clkd_sync,

  output          spi_csn_clk,
  output          spi_csn_dac,
  output          spi_csn_adc,
  output          spi_clk,
  inout           spi_sdio,
  output          spi_dir);

  // internal signals

  wire    [18:0]  gpio_i;
  wire    [11:0]  gpio_o;
  wire    [ 2:0]  spi_csn;
  wire            spi_mosi;
  wire            spi_miso;
  wire            trig;
  wire            rx_ref_clk;
  wire            rx_sysref;
  wire            rx_sync;
  wire            tx_ref_clk;
  wire            tx_sysref;
  wire            tx_sync;

  // spi

  assign spi_csn_adc = spi_csn[2];
  assign spi_csn_dac = spi_csn[1];
  assign spi_csn_clk = spi_csn[0];

  // default logic
  
  assign fan_pwm = 1'b1;
  assign iic_rstn = 1'b1;

  // instantiations

  IBUFDS_GTE4 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (rx_ref_clk_p),
    .IB (rx_ref_clk_n),
    .O (rx_ref_clk),
    .ODIV2 ());

  IBUFDS i_ibufds_rx_sysref (
    .I (rx_sysref_p),
    .IB (rx_sysref_n),
    .O (rx_sysref));

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  IBUFDS_GTE4 i_ibufds_tx_ref_clk (
    .CEB (1'd0),
    .I (tx_ref_clk_p),
    .IB (tx_ref_clk_n),
    .O (tx_ref_clk),
    .ODIV2 ());

  IBUFDS i_ibufds_tx_sysref (
    .I (tx_sysref_p),
    .IB (tx_sysref_n),
    .O (tx_sysref));

  IBUFDS i_ibufds_tx_sync (
    .I (tx_sync_p),
    .IB (tx_sync_n),
    .O (tx_sync));

  daq2_spi i_spi (
    .spi_csn (spi_csn),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio),
    .spi_dir (spi_dir));

  IBUFDS i_ibufds_trig (
    .I (trig_p),
    .IB (trig_n),
    .O (trig));

  assign adc_pd = gpio_o[11];
  assign dac_txen = gpio_o[10];
  assign dac_reset = gpio_o[9];
  assign clkd_sync = gpio_o[8];
  assign gpio_bd_o = gpio_o[7:0];

  assign gpio_i[94:19] = gpio_o[94:19];
  assign gpio_i[18:18] = trig;
  assign gpio_i[17:17] = adc_fdb;
  assign gpio_i[16:16] = adc_fda;
  assign gpio_i[15:15] = dac_irq;
  assign gpio_i[14:13] = clkd_status;
  assign gpio_i[12: 0] = gpio_bd_i;

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
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .linear_flash_addr (linear_flash_addr),
    .linear_flash_adv_ldn (linear_flash_adv_ldn),
    .linear_flash_ce_n (linear_flash_ce_n),
    .linear_flash_dq_io (linear_flash_dq_io),
    .linear_flash_oen (linear_flash_oen),
    .linear_flash_wen (linear_flash_wen),
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
    .spi0_csn (spi_csn),
    .spi0_miso (spi_miso),
    .spi0_mosi (spi_mosi),
    .spi0_sclk (spi_clk),
    .spi1_csn (),
    .spi1_miso (1'd0),
    .spi1_mosi (),
    .spi1_sclk (),
    .tx_data_0_n (tx_data_n[0]),
    .tx_data_0_p (tx_data_p[0]),
    .tx_data_1_n (tx_data_n[1]),
    .tx_data_1_p (tx_data_p[1]),
    .tx_data_2_n (tx_data_n[2]),
    .tx_data_2_p (tx_data_p[2]),
    .tx_data_3_n (tx_data_n[3]),
    .tx_data_3_p (tx_data_p[3]),
    .tx_ref_clk_0 (tx_ref_clk),
    .tx_sync_0 (tx_sync),
    .tx_sysref_0 (tx_sysref),
    .uart_sin (uart_sin),
    .uart_sout (uart_sout));

endmodule

// ***************************************************************************
// ***************************************************************************
