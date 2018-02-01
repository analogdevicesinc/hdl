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

  // clock and resets

  input             sys_clk,
  input             sys_resetn,

  // hps-ddr4 (32)

  input             hps_ddr_ref_clk,
  output            hps_ddr_clk_p,
  output            hps_ddr_clk_n,
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
  inout   [  4:0]   hps_ddr_dqs_p,
  inout   [  4:0]   hps_ddr_dqs_n,
  inout   [ 39:0]   hps_ddr_dq,
  inout   [  4:0]   hps_ddr_dbi_n,
  input             hps_ddr_rzq,

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
  inout   [  3:0]   hps_sdio_d,

  // hps-usb

  input   [  0:0]   hps_usb_clk,
  input   [  0:0]   hps_usb_dir,
  input   [  0:0]   hps_usb_nxt,
  output  [  0:0]   hps_usb_stp,
  inout   [  7:0]   hps_usb_d,

  // hps-uart

  input   [  0:0]   hps_uart0_rx,
  output  [  0:0]   hps_uart0_tx,
  input   [  0:0]   hps_uart1_rx,
  output  [  0:0]   hps_uart1_tx,
  input   [  0:0]   hps_uart1_cts_n,
  output  [  0:0]   hps_uart1_rts_n,

  // hps-i2c (fmc)

  inout   [  0:0]   hps_i2c_sda,
  inout   [  0:0]   hps_i2c_scl,

  // lane interface

  input                   rx_ref_clk,
  input                   rx_sysref,
  output                  rx_sync,
  input       [ 3:0]      rx_serial_data,
  input                   tx_ref_clk,
  input                   tx_sysref,
  input                   tx_sync,
  output      [ 3:0]      tx_serial_data,

  // power-good for FMC

  output                  pg_c2m,

  // gpio

  input                   trig,
  input                   adc_fdb,
  input                   adc_fda,
  input                   dac_irq,
  input       [ 1:0]      clkd_status,
  output                  adc_pd,
  output                  dac_txen,
  output                  dac_reset,
  output                  clkd_sync,

  // spi

  output                  spi_csn_clk,
  output                  spi_csn_dac,
  output                  spi_csn_adc,
  output                  spi_clk,
  inout                   spi_sdio,
  output                  spi_dir);

  // internal signals

  wire              sys_ddr_cal_success;
  wire              sys_ddr_cal_fail;
  wire              sys_hps_resetn;
  wire              sys_resetn_s;
  wire    [ 63:0]   gpio_i;
  wire    [ 63:0]   gpio_o;
  wire              spi_miso_s;
  wire              spi_mosi_s;
  wire    [  7:0]   spi_csn_s;
  wire              dac_fifo_bypass;

  wire        hps_i2c1_scl;
  wire        hps_i2c1_scl_oe;
  wire        hps_i2c1_sda;
  wire        hps_i2c1_sda_oe;

  // assignments

  assign pg_c2m = 1'b1;

  assign spi_csn_adc = spi_csn_s[2];
  assign spi_csn_dac = spi_csn_s[1];
  assign spi_csn_clk = spi_csn_s[0];


  daq2_spi i_daq2_spi (
    .spi_csn (spi_csn_s[2:0]),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi_s),
    .spi_miso (spi_miso_s),
    .spi_sdio (spi_sdio),
    .spi_dir (spi_dir));

  // gpio in & out are separate cores

  assign gpio_i[63:45] = gpio_o[63:45];
  assign dac_fifo_bypass = gpio_o[44];
  assign gpio_i[44:44] = gpio_o[44];
  assign gpio_i[43:43] = trig;

  assign gpio_i[42:40] = gpio_o[42:40];
  assign adc_pd = gpio_o[42];
  assign dac_txen = gpio_o[41];
  assign dac_reset = gpio_o[40];

  assign gpio_i[39:39] = gpio_o[39];

  assign gpio_i[38:38] = gpio_o[38];
  assign clkd_sync = gpio_o[38];

  assign gpio_i[37:37] = gpio_o[37];
  assign gpio_i[36:36] = adc_fdb;
  assign gpio_i[35:35] = adc_fda;
  assign gpio_i[34:34] = dac_irq;
  assign gpio_i[33:32] = clkd_status;

  // peripheral reset

  assign sys_resetn_s = sys_resetn & sys_hps_resetn;

  // hps_i2c1 routed to fmc via fpga io

  ALT_IOBUF scl_iobuf (.i(1'b0), .oe(hps_i2c1_scl_oe), .o(hps_i2c1_scl), .io(hps_i2c_scl));
  ALT_IOBUF sda_iobuf (.i(1'b0), .oe(hps_i2c1_sda_oe), .o(hps_i2c1_sda), .io(hps_i2c_sda));

  // instantiations

  system_bd i_system_bd (
    .sys_clk_clk (sys_clk),
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
    .sys_hps_io_hps_io_phery_emac1_TX_CLK (hps_eth_txclk),
    .sys_hps_io_hps_io_phery_emac1_TXD0 (hps_eth_txd[0]),
    .sys_hps_io_hps_io_phery_emac1_TXD1 (hps_eth_txd[1]),
    .sys_hps_io_hps_io_phery_emac1_TXD2 (hps_eth_txd[2]),
    .sys_hps_io_hps_io_phery_emac1_TXD3 (hps_eth_txd[3]),
    .sys_hps_io_hps_io_phery_emac1_RX_CTL (hps_eth_rxctl),
    .sys_hps_io_hps_io_phery_emac1_TX_CTL (hps_eth_txctl),
    .sys_hps_io_hps_io_phery_emac1_RX_CLK (hps_eth_rxclk),
    .sys_hps_io_hps_io_phery_emac1_RXD0 (hps_eth_rxd[0]),
    .sys_hps_io_hps_io_phery_emac1_RXD1 (hps_eth_rxd[1]),
    .sys_hps_io_hps_io_phery_emac1_RXD2 (hps_eth_rxd[2]),
    .sys_hps_io_hps_io_phery_emac1_RXD3 (hps_eth_rxd[3]),
    .sys_hps_io_hps_io_phery_emac1_MDIO (hps_eth_mdio),
    .sys_hps_io_hps_io_phery_emac1_MDC (hps_eth_mdc),
    .sys_hps_io_hps_io_phery_sdmmc_CMD (hps_sdio_cmd),
    .sys_hps_io_hps_io_phery_sdmmc_D0 (hps_sdio_d[0]),
    .sys_hps_io_hps_io_phery_sdmmc_D1 (hps_sdio_d[1]),
    .sys_hps_io_hps_io_phery_sdmmc_D2 (hps_sdio_d[2]),
    .sys_hps_io_hps_io_phery_sdmmc_D3 (hps_sdio_d[3]),
    .sys_hps_io_hps_io_phery_sdmmc_CCLK (hps_sdio_clk),
    .sys_hps_io_hps_io_phery_usb1_DATA0 (hps_usb_d[0]),
    .sys_hps_io_hps_io_phery_usb1_DATA1 (hps_usb_d[1]),
    .sys_hps_io_hps_io_phery_usb1_DATA2 (hps_usb_d[2]),
    .sys_hps_io_hps_io_phery_usb1_DATA3 (hps_usb_d[3]),
    .sys_hps_io_hps_io_phery_usb1_DATA4 (hps_usb_d[4]),
    .sys_hps_io_hps_io_phery_usb1_DATA5 (hps_usb_d[5]),
    .sys_hps_io_hps_io_phery_usb1_DATA6 (hps_usb_d[6]),
    .sys_hps_io_hps_io_phery_usb1_DATA7 (hps_usb_d[7]),
    .sys_hps_io_hps_io_phery_usb1_CLK (hps_usb_clk),
    .sys_hps_io_hps_io_phery_usb1_STP (hps_usb_stp),
    .sys_hps_io_hps_io_phery_usb1_DIR (hps_usb_dir),
    .sys_hps_io_hps_io_phery_usb1_NXT (hps_usb_nxt),
    .sys_hps_io_hps_io_phery_uart0_RX (hps_uart0_rx),
    .sys_hps_io_hps_io_phery_uart0_TX (hps_uart0_tx),
    .sys_hps_io_hps_io_phery_uart1_RX (hps_uart1_rx),
    .sys_hps_io_hps_io_phery_uart1_TX (hps_uart1_tx),
    .sys_hps_io_hps_io_phery_uart1_CTS_N (hps_uart1_cts_n),
    .sys_hps_io_hps_io_phery_uart1_RTS_N (hps_uart1_rts_n),
    .sys_hps_i2c1_scl_in_clk (hps_i2c1_scl),
    .sys_hps_i2c1_clk_clk (hps_i2c1_scl_oe),
    .sys_hps_i2c1_sda_i (hps_i2c1_sda),
    .sys_hps_i2c1_sda_oe (hps_i2c1_sda_oe),
    .sys_hps_out_rstn_reset_n (sys_hps_resetn),
    .sys_hps_rstn_reset_n (sys_resetn),
    .sys_rstn_reset_n (sys_resetn_s),
    .sys_spi_MISO (spi_miso_s),
    .sys_spi_MOSI (spi_mosi_s),
    .sys_spi_SCLK (spi_clk),
    .sys_spi_SS_n (spi_csn_s),
    .tx_serial_data_tx_serial_data (tx_serial_data),
    .tx_fifo_bypass_bypass (dac_fifo_bypass),
    .tx_ref_clk_clk (tx_ref_clk),
    .tx_sync_export (tx_sync),
    .tx_sysref_export (tx_sysref),
    .rx_serial_data_rx_serial_data (rx_serial_data),
    .rx_ref_clk_clk (rx_ref_clk),
    .rx_sync_export (rx_sync),
    .rx_sysref_export (rx_sysref));

endmodule

// ***************************************************************************
// ***************************************************************************
