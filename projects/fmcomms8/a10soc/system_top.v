// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
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

  // clock and resets

  input             sys_clk,
  input             sys_resetn,

  // hps-ddr4 (32)

  input             hps_ddr_ref_clk,
  output  [  0:0]   hps_ddr_clk_p,
  output  [  0:0]   hps_ddr_clk_n,
  output  [ 16:0]   hps_ddr_a,
  output  [  1:0]   hps_ddr_ba,
  output  [  0:0]   hps_ddr_bg,
  output  [  0:0]   hps_ddr_cke,
  output  [  0:0]   hps_ddr_cs_n,
  output  [  0:0]   hps_ddr_odt,
  output  [  0:0]   hps_ddr_reset_n,
  output  [  0:0]   hps_ddr_act_n,
  output  [  0:0]   hps_ddr_par,
  input   [  0:0]   hps_ddr_alert_n,
  inout   [  3:0]   hps_ddr_dqs_p,
  inout   [  3:0]   hps_ddr_dqs_n,
  inout   [ 31:0]   hps_ddr_dq,
  inout   [  3:0]   hps_ddr_dbi_n,
  input             hps_ddr_rzq,

  // pl-ddr4

  input             sys_ddr_ref_clk,
  output  [  0:0]   sys_ddr_clk_p,
  output  [  0:0]   sys_ddr_clk_n,
  output  [ 16:0]   sys_ddr_a,
  output  [  1:0]   sys_ddr_ba,
  output  [  0:0]   sys_ddr_bg,
  output  [  0:0]   sys_ddr_cke,
  output  [  0:0]   sys_ddr_cs_n,
  output  [  0:0]   sys_ddr_odt,
  output  [  0:0]   sys_ddr_reset_n,
  output  [  0:0]   sys_ddr_act_n,
  output  [  0:0]   sys_ddr_par,
  input   [  0:0]   sys_ddr_alert_n,
  inout   [  7:0]   sys_ddr_dqs_p,
  inout   [  7:0]   sys_ddr_dqs_n,
  inout   [ 63:0]   sys_ddr_dq,
  inout   [  7:0]   sys_ddr_dbi_n,
  input             sys_ddr_rzq,

  // hps-ethernet

  input   [  0:0]   hps_eth_rxclk,
  input   [  0:0]   hps_eth_rxctl,
  input   [  3:0]   hps_eth_rxd,
  output  [  0:0]   hps_eth_txclk,
  output  [  0:0]   hps_eth_txctl,
  output  [  3:0]   hps_eth_txd,
  output  [  0:0]   hps_eth_mdc,
  inout   [  0:0]   hps_eth_mdio,

  // hps-sdio

  output  [  0:0]   hps_sdio_clk,
  inout   [  0:0]   hps_sdio_cmd,
  inout   [  7:0]   hps_sdio_d,

  // hps-usb

  input   [  0:0]   hps_usb_clk,
  input   [  0:0]   hps_usb_dir,
  input   [  0:0]   hps_usb_nxt,
  output  [  0:0]   hps_usb_stp,
  inout   [  7:0]   hps_usb_d,

  // hps-uart

  input   [  0:0]   hps_uart_rx,
  output  [  0:0]   hps_uart_tx,

  // hps-i2c (shared w fmc-a, fmc-b)

  inout   [  0:0]   hps_i2c_sda,
  inout   [  0:0]   hps_i2c_scl,

  // hps-gpio (max-v-u16)

  inout   [  3:0]   hps_gpio,

  // gpio (max-v-u21)

  input   [  7:0]   gpio_bd_i,
  output  [  3:0]   gpio_bd_o,

  // adrv9009-interface

  input             ref_clk_c,
  input             core_clk_c,
  input   [  3:0]   rx_serial_data_c,
  output  [  3:0]   tx_serial_data_c,
  output            rx_sync_c,
  output            rx_os_sync_c,
  input             tx_sync_c,
  input             tx_sync_c_1,
  input             sysref_c,

  output            adrv9009_tx1_enable_c,
  output            adrv9009_tx2_enable_c,
  output            adrv9009_rx1_enable_c,
  output            adrv9009_rx2_enable_c,
  output            adrv9009_reset_b_c,
  input             adrv9009_gpint_c,

  inout             adrv9009_gpio_00_c,
  inout             adrv9009_gpio_01_c,
  inout             adrv9009_gpio_02_c,
  inout             adrv9009_gpio_03_c,
  inout             adrv9009_gpio_04_c,
  inout             adrv9009_gpio_05_c,
  inout             adrv9009_gpio_06_c,
  inout             adrv9009_gpio_07_c,
  inout             adrv9009_gpio_08_c,

  input             ref_clk_d,
  input             core_clk_d,
  input   [  3:0]   rx_serial_data_d,
  output  [  3:0]   tx_serial_data_d,
  output            rx_sync_d,
  output            rx_os_sync_d,
  input             tx_sync_d,
  input             tx_sync_d_1,
  input             sysref_d,

  output            adrv9009_tx1_enable_d,
  output            adrv9009_tx2_enable_d,
  output            adrv9009_rx1_enable_d,
  output            adrv9009_rx2_enable_d,
  output            adrv9009_reset_b_d,
  input             adrv9009_gpint_d,

  inout             adrv9009_gpio_00_d,
  inout             adrv9009_gpio_01_d,
  inout             adrv9009_gpio_02_d,
  inout             adrv9009_gpio_03_d,
  inout             adrv9009_gpio_04_d,
  inout             adrv9009_gpio_05_d,
  inout             adrv9009_gpio_06_d,
  inout             adrv9009_gpio_07_d,
  inout             adrv9009_gpio_08_d,

  input             fan_tach,
  input             fan_pwm,
  output            hmc7044_reset,
  output            hmc7044_sync,
  inout             hmc7044_gpio_1,
  inout             hmc7044_gpio_2,
  inout             hmc7044_gpio_3,
  inout             hmc7044_gpio_4,
  output            spi_csn_hmc7044,
  output            spi_csn_adrv9009_c,
  output            spi_csn_adrv9009_d,

  output            spi_clk,
  inout             spi_sdio,
  input             spi_miso
);

  // internal signals

  wire              sys_ddr_cal_success;
  wire              sys_ddr_cal_fail;
  wire              sys_hps_resetn;
  wire              sys_resetn_s;
  wire    [ 63:0]   gpio_i;
  wire    [ 63:0]   gpio_o;
  wire    [  7:0]   spi_csn_s;
  wire              dac_fifo_bypass;
  wire              spi_mosi;
  wire              spi0_miso;

  wire              rx_sync;
  wire              rx_os_sync;
  wire              tx_sync;

  wire    [ 22:0]   fmcomms8_gpio;

  // assignments

  assign spi_csn_adrv9009_c = spi_csn_s[0];
  assign spi_csn_adrv9009_d = spi_csn_s[1];
  assign spi_csn_hmc7044 = spi_csn_s[2];

  fmcomms8_spi i_spi (
    .spi_csn(spi_csn_s),
    .spi_clk(spi_clk),
    .spi_mosi(spi_mosi),
    .spi_miso_i(spi_miso),
    .spi_miso_o(spi0_miso),
    .spi_sdio(spi_sdio));

  assign rx_sync_c = rx_sync;
  assign rx_sync_d = rx_sync;

  assign rx_os_sync_c = rx_os_sync;
  assign rx_os_sync_d = rx_os_sync;

  assign tx_sync = tx_sync_c & tx_sync_d;

  assign adrv9009_gpio_00_c = fmcomms8_gpio[0];
  assign adrv9009_gpio_01_c = fmcomms8_gpio[1];
  assign adrv9009_gpio_02_c = fmcomms8_gpio[2];
  assign adrv9009_gpio_03_c = fmcomms8_gpio[3];
  assign adrv9009_gpio_04_c = fmcomms8_gpio[4];
  assign adrv9009_gpio_05_c = fmcomms8_gpio[5];
  assign adrv9009_gpio_06_c = fmcomms8_gpio[6];
  assign adrv9009_gpio_07_c = fmcomms8_gpio[7];
  assign adrv9009_gpio_08_c = fmcomms8_gpio[8];

  assign adrv9009_gpio_00_d = fmcomms8_gpio[9];
  assign adrv9009_gpio_01_d = fmcomms8_gpio[10];
  assign adrv9009_gpio_02_d = fmcomms8_gpio[11];
  assign adrv9009_gpio_03_d = fmcomms8_gpio[12];
  assign adrv9009_gpio_04_d = fmcomms8_gpio[13];
  assign adrv9009_gpio_05_d = fmcomms8_gpio[14];
  assign adrv9009_gpio_06_d = fmcomms8_gpio[15];
  assign adrv9009_gpio_07_d = fmcomms8_gpio[16];
  assign adrv9009_gpio_08_d = fmcomms8_gpio[17];

  assign hmc7044_gpio_1 = fmcomms8_gpio[18];
  assign hmc7044_gpio_2 = fmcomms8_gpio[19];
  assign hmc7044_gpio_3 = fmcomms8_gpio[20];
  assign hmc7044_gpio_4 = fmcomms8_gpio[21];
  assign hmc7044_reset = gpio_o[45];
  assign hmc7044_sync = gpio_o[46];

  assign adrv9009_tx1_enable_d = gpio_o[39];
  assign adrv9009_tx2_enable_d = gpio_o[40];
  assign adrv9009_rx1_enable_d = gpio_o[41];
  assign adrv9009_rx2_enable_d = gpio_o[42];
  assign adrv9009_reset_b_d = gpio_o[43];
  assign gpio_i[44] = adrv9009_gpint_d;

  assign adrv9009_tx1_enable_c = gpio_o[33];
  assign adrv9009_tx2_enable_c = gpio_o[34];
  assign adrv9009_rx1_enable_c = gpio_o[35];
  assign adrv9009_rx2_enable_c = gpio_o[36];
  assign adrv9009_reset_b_c = gpio_o[37];
  assign gpio_i[38] = adrv9009_gpint_c;

  assign dac_fifo_bypass = gpio_o[32];

  assign gpio_i[63:45] = gpio_o[63:45];
  assign gpio_i[43:39] = gpio_o[43:39];
  assign gpio_i[37:32] = gpio_o[37:32];

  // board stuff (max-v-u21)

  assign gpio_i[31:14] = gpio_o[31:14];
  assign gpio_i[13:13] = sys_ddr_cal_success;
  assign gpio_i[12:12] = sys_ddr_cal_fail;
  assign gpio_i[11: 4] = gpio_bd_i;
  assign gpio_i[ 3: 0] = gpio_o[3:0];

  assign gpio_bd_o = gpio_o[3:0];

  // peripheral reset

  assign sys_resetn_s = sys_resetn & sys_hps_resetn;

  // instantiations

  system_bd i_system_bd (
    .sys_clk_clk (sys_clk),
    .sys_ddr_mem_mem_ck (sys_ddr_clk_p),
    .sys_ddr_mem_mem_ck_n (sys_ddr_clk_n),
    .sys_ddr_mem_mem_a (sys_ddr_a),
    .sys_ddr_mem_mem_act_n (sys_ddr_act_n),
    .sys_ddr_mem_mem_ba (sys_ddr_ba),
    .sys_ddr_mem_mem_bg (sys_ddr_bg),
    .sys_ddr_mem_mem_cke (sys_ddr_cke),
    .sys_ddr_mem_mem_cs_n (sys_ddr_cs_n),
    .sys_ddr_mem_mem_odt (sys_ddr_odt),
    .sys_ddr_mem_mem_reset_n (sys_ddr_reset_n),
    .sys_ddr_mem_mem_par (sys_ddr_par),
    .sys_ddr_mem_mem_alert_n (sys_ddr_alert_n),
    .sys_ddr_mem_mem_dqs (sys_ddr_dqs_p),
    .sys_ddr_mem_mem_dqs_n (sys_ddr_dqs_n),
    .sys_ddr_mem_mem_dq (sys_ddr_dq),
    .sys_ddr_mem_mem_dbi_n (sys_ddr_dbi_n),
    .sys_ddr_oct_oct_rzqin (sys_ddr_rzq),
    .sys_ddr_ref_clk_clk (sys_ddr_ref_clk),
    .sys_ddr_status_local_cal_success (sys_ddr_cal_success),
    .sys_ddr_status_local_cal_fail (sys_ddr_cal_fail),
    .sys_gpio_bd_in_port (gpio_i[31:0]),
    .sys_gpio_bd_out_port (gpio_o[31:0]),
    .sys_gpio_in_export (gpio_i[63:32]),
    .sys_gpio_out_export (gpio_o[63:32]),
    .sys_hps_ddr_mem_ck (hps_ddr_clk_p),
    .sys_hps_ddr_mem_ck_n (hps_ddr_clk_n),
    .sys_hps_ddr_mem_a (hps_ddr_a),
    .sys_hps_ddr_mem_act_n (hps_ddr_act_n),
    .sys_hps_ddr_mem_ba (hps_ddr_ba),
    .sys_hps_ddr_mem_bg (hps_ddr_bg),
    .sys_hps_ddr_mem_cke (hps_ddr_cke),
    .sys_hps_ddr_mem_cs_n (hps_ddr_cs_n),
    .sys_hps_ddr_mem_odt (hps_ddr_odt),
    .sys_hps_ddr_mem_reset_n (hps_ddr_reset_n),
    .sys_hps_ddr_mem_par (hps_ddr_par),
    .sys_hps_ddr_mem_alert_n (hps_ddr_alert_n),
    .sys_hps_ddr_mem_dqs (hps_ddr_dqs_p),
    .sys_hps_ddr_mem_dqs_n (hps_ddr_dqs_n),
    .sys_hps_ddr_mem_dq (hps_ddr_dq),
    .sys_hps_ddr_mem_dbi_n (hps_ddr_dbi_n),
    .sys_hps_ddr_oct_oct_rzqin (hps_ddr_rzq),
    .sys_hps_ddr_ref_clk_clk (hps_ddr_ref_clk),
    .sys_hps_ddr_rstn_reset_n (sys_resetn),
    .sys_hps_io_hps_io_phery_emac0_TX_CLK (hps_eth_txclk),
    .sys_hps_io_hps_io_phery_emac0_TXD0 (hps_eth_txd[0]),
    .sys_hps_io_hps_io_phery_emac0_TXD1 (hps_eth_txd[1]),
    .sys_hps_io_hps_io_phery_emac0_TXD2 (hps_eth_txd[2]),
    .sys_hps_io_hps_io_phery_emac0_TXD3 (hps_eth_txd[3]),
    .sys_hps_io_hps_io_phery_emac0_RX_CTL (hps_eth_rxctl),
    .sys_hps_io_hps_io_phery_emac0_TX_CTL (hps_eth_txctl),
    .sys_hps_io_hps_io_phery_emac0_RX_CLK (hps_eth_rxclk),
    .sys_hps_io_hps_io_phery_emac0_RXD0 (hps_eth_rxd[0]),
    .sys_hps_io_hps_io_phery_emac0_RXD1 (hps_eth_rxd[1]),
    .sys_hps_io_hps_io_phery_emac0_RXD2 (hps_eth_rxd[2]),
    .sys_hps_io_hps_io_phery_emac0_RXD3 (hps_eth_rxd[3]),
    .sys_hps_io_hps_io_phery_emac0_MDIO (hps_eth_mdio),
    .sys_hps_io_hps_io_phery_emac0_MDC (hps_eth_mdc),
    .sys_hps_io_hps_io_phery_sdmmc_CMD (hps_sdio_cmd),
    .sys_hps_io_hps_io_phery_sdmmc_D0 (hps_sdio_d[0]),
    .sys_hps_io_hps_io_phery_sdmmc_D1 (hps_sdio_d[1]),
    .sys_hps_io_hps_io_phery_sdmmc_D2 (hps_sdio_d[2]),
    .sys_hps_io_hps_io_phery_sdmmc_D3 (hps_sdio_d[3]),
    .sys_hps_io_hps_io_phery_sdmmc_D4 (hps_sdio_d[4]),
    .sys_hps_io_hps_io_phery_sdmmc_D5 (hps_sdio_d[5]),
    .sys_hps_io_hps_io_phery_sdmmc_D6 (hps_sdio_d[6]),
    .sys_hps_io_hps_io_phery_sdmmc_D7 (hps_sdio_d[7]),
    .sys_hps_io_hps_io_phery_sdmmc_CCLK (hps_sdio_clk),
    .sys_hps_io_hps_io_phery_usb0_DATA0 (hps_usb_d[0]),
    .sys_hps_io_hps_io_phery_usb0_DATA1 (hps_usb_d[1]),
    .sys_hps_io_hps_io_phery_usb0_DATA2 (hps_usb_d[2]),
    .sys_hps_io_hps_io_phery_usb0_DATA3 (hps_usb_d[3]),
    .sys_hps_io_hps_io_phery_usb0_DATA4 (hps_usb_d[4]),
    .sys_hps_io_hps_io_phery_usb0_DATA5 (hps_usb_d[5]),
    .sys_hps_io_hps_io_phery_usb0_DATA6 (hps_usb_d[6]),
    .sys_hps_io_hps_io_phery_usb0_DATA7 (hps_usb_d[7]),
    .sys_hps_io_hps_io_phery_usb0_CLK (hps_usb_clk),
    .sys_hps_io_hps_io_phery_usb0_STP (hps_usb_stp),
    .sys_hps_io_hps_io_phery_usb0_DIR (hps_usb_dir),
    .sys_hps_io_hps_io_phery_usb0_NXT (hps_usb_nxt),
    .sys_hps_io_hps_io_phery_uart1_RX (hps_uart_rx),
    .sys_hps_io_hps_io_phery_uart1_TX (hps_uart_tx),
    .sys_hps_io_hps_io_phery_i2c1_SDA (hps_i2c_sda),
    .sys_hps_io_hps_io_phery_i2c1_SCL (hps_i2c_scl),
    .sys_hps_io_hps_io_gpio_gpio1_io5 (hps_gpio[0]),
    .sys_hps_io_hps_io_gpio_gpio1_io14 (hps_gpio[1]),
    .sys_hps_io_hps_io_gpio_gpio1_io16 (hps_gpio[2]),
    .sys_hps_io_hps_io_gpio_gpio1_io17 (hps_gpio[3]),
    .sys_hps_out_rstn_reset_n (sys_hps_resetn),
    .sys_hps_rstn_reset_n (sys_resetn),
    .sys_rstn_reset_n (sys_resetn_s),
    .sys_spi_MISO (spi0_miso),
    .sys_spi_MOSI (spi_mosi),
    .sys_spi_SCLK (spi_clk),
    .sys_spi_SS_n (spi_csn_s),
    .tx_serial_data_tx_serial_data ({tx_serial_data_d,tx_serial_data_c}),
    .tx_fifo_bypass_bypass (dac_fifo_bypass),
    .fmcomms8_gpio_export (fmcomms8_gpio),
    .core_clk_c_clk (core_clk_c),
    .core_clk_d_clk (core_clk_d),
    .tx_ref_clk_clk (ref_clk_c),
    .tx_sync_export (tx_sync),
    .tx_sysref_export (sysref_c),
    .rx_serial_data_rx_serial_data ({rx_serial_data_d[1:0],rx_serial_data_c[1:0]}),
    .rx_os_serial_data_rx_serial_data ({rx_serial_data_d[3:2],rx_serial_data_c[3:2]}),
    .rx_os_ref_clk_clk (ref_clk_c),
    .rx_os_sync_export (rx_os_sync),
    .rx_os_sysref_export (sysref_c),
    .rx_ref_clk_clk (ref_clk_d),
    .rx_sync_export (rx_sync),
    .rx_sysref_export (sysref_c));

endmodule
