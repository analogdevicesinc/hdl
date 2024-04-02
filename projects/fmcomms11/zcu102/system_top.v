// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2019-2024 Analog Devices, Inc. All rights reserved.
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

  inout   [14:0]  gpio_bd,

  output          rx_sync_p,
  output          rx_sync_n,
  input   [ 7:0]  rx_data_p,
  input   [ 7:0]  rx_data_n,

  input           trx_ref_clk_p,
  input           trx_ref_clk_n,
  input           tx_sync_p,
  input           tx_sync_n,
  output  [ 7:0]  tx_data_p,
  output  [ 7:0]  tx_data_n,

  input           usr_clk_p,
  input           usr_clk_n,

  inout           adf4355_muxout,
  inout           ad9162_txen,
  inout           ad9625_irq,
  inout           ad9162_irq,

  output          spi_csn_ad9625,
  output          spi_csn_ad9162,
  output          spi_csn_ad9508,
  output          spi_csn_adl5240,
  output          spi_csn_adf4355,
  output          spi_csn_hmc1119,
  output          spi_clk,
  inout           spi_sdio,
  output          spi_dir
);

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire    [ 2:0]  spi0_csn;
  wire            spi0_sclk;
  wire            spi0_mosi;
  wire            spi0_miso;
  wire    [ 2:0]  spi1_csn;
  wire            spi1_sclk;
  wire            spi1_mosi;
  wire            spi1_miso;
  wire            rx_sync;
  wire            trx_ref_clk;
  wire            tx_sync;
  wire            usr_clk;

  // instantiations

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  IBUFDS_GTE4 i_ibufds_tx_ref_clk (
    .CEB (1'd0),
    .I (trx_ref_clk_p),
    .IB (trx_ref_clk_n),
    .O (trx_ref_clk),
    .ODIV2 ());

  IBUFDS i_ibufds_tx_sync (
    .I (tx_sync_p),
    .IB (tx_sync_n),
    .O (tx_sync));

  IBUFDS_GTE4 i_ibufds_usr_clk (
    .CEB (1'd0),
    .I (usr_clk_p),
    .IB (usr_clk_n),
    .O (usr_clk),
    .ODIV2 ());

  fmcomms11_spi i_spi (
    .spi_csn (spi0_csn),
    .spi_clk (spi_clk),
    .spi_mosi (spi0_mosi),
    .spi_miso (spi0_miso),
    .spi_csn_ad9625 (spi_csn_ad9625),
    .spi_csn_ad9162 (spi_csn_ad9162),
    .spi_csn_ad9508 (spi_csn_ad9508),
    .spi_csn_adl5240 (spi_csn_adl5240),
    .spi_csn_adf4355 (spi_csn_adf4355),
    .spi_csn_hmc1119 (spi_csn_hmc1119),
    .spi_sdio (spi_sdio),
    .spi_dir (spi_dir));

  assign spi_clk = spi0_sclk;

  assign gpio_i[63:36] = gpio_o[63:36];

  ad_iobuf #(
    .DATA_WIDTH(4)
  ) i_iobuf (
    .dio_t ({gpio_t[35:32]}),
    .dio_i ({gpio_o[35:32]}),
    .dio_o ({gpio_i[35:32]}),
    .dio_p ({ adf4355_muxout,   // 35
              ad9162_txen,      // 34
              ad9625_irq,       // 33
              ad9162_irq}));    // 32

  assign gpio_i[31:15] = gpio_o[31:15];

  ad_iobuf #(
    .DATA_WIDTH(15)
  ) i_iobuf_bd (
    .dio_t (gpio_t[14:0]),
    .dio_i (gpio_o[14:0]),
    .dio_o (gpio_i[14:0]),
    .dio_p (gpio_bd));

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
    .rx_data_4_n (rx_data_n[4]),
    .rx_data_4_p (rx_data_p[4]),
    .rx_data_5_n (rx_data_n[5]),
    .rx_data_5_p (rx_data_p[5]),
    .rx_data_6_n (rx_data_n[6]),
    .rx_data_6_p (rx_data_p[6]),
    .rx_data_7_n (rx_data_n[7]),
    .rx_data_7_p (rx_data_p[7]),
    .rx_ref_clk_0 (trx_ref_clk),
    .rx_sync_0 (rx_sync),
    .rx_sysref_0 (1'b0),
    .spi0_sclk (spi0_sclk),
    .spi0_csn (spi0_csn),
    .spi0_mosi (spi0_mosi),
    .spi0_miso (spi0_miso),
    .spi1_sclk (spi1_sclk),
    .spi1_csn (spi1_csn),
    .spi1_mosi (spi1_mosi),
    .spi1_miso (spi1_miso),
    .tx_data_0_n (tx_data_n[0]),
    .tx_data_0_p (tx_data_p[0]),
    .tx_data_1_n (tx_data_n[1]),
    .tx_data_1_p (tx_data_p[1]),
    .tx_data_2_n (tx_data_n[2]),
    .tx_data_2_p (tx_data_p[2]),
    .tx_data_3_n (tx_data_n[3]),
    .tx_data_3_p (tx_data_p[3]),
    .tx_data_4_n (tx_data_n[4]),
    .tx_data_4_p (tx_data_p[4]),
    .tx_data_5_n (tx_data_n[5]),
    .tx_data_5_p (tx_data_p[5]),
    .tx_data_6_n (tx_data_n[6]),
    .tx_data_6_p (tx_data_p[6]),
    .tx_data_7_n (tx_data_n[7]),
    .tx_data_7_p (tx_data_p[7]),
    .tx_ref_clk_0 (trx_ref_clk),
    .tx_sync_0 (tx_sync),
    .tx_sysref_0 (1'b0),
    .dac_fifo_bypass (gpio_o[60]));

endmodule
