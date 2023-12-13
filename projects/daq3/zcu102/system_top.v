// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
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

  input       [12:0]      gpio_bd_i,
  output      [ 7:0]      gpio_bd_o,

  input                   rx_ref_clk_p,
  input                   rx_ref_clk_n,
  input                   rx_sysref_p,
  input                   rx_sysref_n,
  output                  rx_sync_p,
  output                  rx_sync_n,
  input       [ 3:0]      rx_data_p,
  input       [ 3:0]      rx_data_n,

  input                   tx_ref_clk_p,
  input                   tx_ref_clk_n,
  input                   tx_sysref_p,
  input                   tx_sysref_n,
  input                   tx_sync_p,
  input                   tx_sync_n,
  output      [ 3:0]      tx_data_p,
  output      [ 3:0]      tx_data_n,

  input                   trig_p,
  input                   trig_n,

  inout                   adc_fdb,
  inout                   adc_fda,
  inout                   dac_irq,
  inout       [ 1:0]      clkd_status,

  inout                   adc_pd,
  inout                   dac_txen,
  output                  sysref_p,
  output                  sysref_n,

  output                  spi_csn_clk,
  output                  spi_csn_dac,
  output                  spi_csn_adc,
  output                  spi_clk,
  inout                   spi_sdio,
  output                  spi_dir
);

  // internal signals

  wire        [94:0]      gpio_i;
  wire        [94:0]      gpio_o;
  wire        [94:0]      gpio_t;
  wire        [20:0]      gpio_bd;
  wire        [ 2:0]      spi_csn;
  wire                    spi_mosi;
  wire                    spi_miso;
  wire                    trig;
  wire                    rx_ref_clk;
  wire                    rx_sysref;
  wire                    rx_sync;
  wire                    tx_ref_clk;
  wire                    tx_sysref;
  wire                    tx_sync;

  // spi

  assign spi_csn_adc = spi_csn[2];
  assign spi_csn_dac = spi_csn[1];
  assign spi_csn_clk = spi_csn[0];

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

  daq3_spi i_spi (
    .spi_csn (spi_csn),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio),
    .spi_dir (spi_dir));

  OBUFDS i_obufds_sysref (
    .I (gpio_o[40]),
    .O (sysref_p),
    .OB (sysref_n));

  IBUFDS i_ibufds_trig (
    .I (trig_p),
    .IB (trig_n),
    .O (trig));

  assign gpio_i[94:40] = gpio_o[94:40];
  assign gpio_i[39] = trig;

  ad_iobuf #(
    .DATA_WIDTH(7)
  ) i_iobuf (
    .dio_t (gpio_t[38:32]),
    .dio_i (gpio_o[38:32]),
    .dio_o (gpio_i[38:32]),
    .dio_p ({ adc_pd,           // 38
              dac_txen,         // 37
              adc_fdb,          // 36
              adc_fda,          // 35
              dac_irq,          // 34
              clkd_status}));   // 32

  assign gpio_i[31:21] = gpio_o[31:21];

  /* Board GPIOS. Buttons, LEDs, etc... */
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[7:0];

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
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
    .dac_fifo_bypass(gpio_o[41]),
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
    .tx_sysref_0 (tx_sysref));

endmodule
