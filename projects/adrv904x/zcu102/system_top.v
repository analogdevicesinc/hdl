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
  input                   core_clk_p,
  input                   core_clk_n,
  input                   ref_clk0_p,
  input                   ref_clk0_n,
  input                   ref_clk1_p,
  input                   ref_clk1_n,
  input       [ 7:0]      rx_data_p,
  input       [ 7:0]      rx_data_n,
  output      [ 7:0]      tx_data_p,
  output      [ 7:0]      tx_data_n,
  output                  rx_sync_p,
  output                  rx_sync_n,
  output                  rx_os_sync_p,
  output                  rx_os_sync_n,
  input                   tx_sync_p,
  input                   tx_sync_n,
  input                   tx_sync_1_p,
  input                   tx_sync_1_n,
  input                   tx_sync_2_p,
  input                   tx_sync_2_n,

  input                   sysref_in_p,
  input                   sysref_in_n,
  output                  sysref_out_p,
  output                  sysref_out_n,

  input       [12:0]      gpio_bd_i,
  output      [ 7:0]      gpio_bd_o,

  output                  spi_csn_ad9528,
  output                  spi_csn_adrv904x,
  output                  spi_clk,
  output                  spi_mosi,
  input                   spi_miso,

  inout                   ad9528_reset_b,
  inout                   ad9528_sysref_req,
  inout                   adrv904x_trx0_enable,
  inout                   adrv904x_trx1_enable,
  inout                   adrv904x_trx2_enable,
  inout                   adrv904x_trx3_enable,
  inout                   adrv904x_trx4_enable,
  inout                   adrv904x_trx5_enable,
  inout                   adrv904x_trx6_enable,
  inout                   adrv904x_trx7_enable,
  inout                   adrv904x_orx0_enable,
  inout                   adrv904x_orx1_enable,
  inout                   adrv904x_test,
  inout                   adrv904x_reset_b,

  inout       [23:0]      adrv904x_gpio
);

  // internal signals

  wire        [94:0]      gpio_i;
  wire        [94:0]      gpio_o;
  wire        [94:0]      gpio_t;
  wire        [ 2:0]      spi_csn;
  wire                    rx_sync;
  wire                    rx_os_sync;
  wire                    tx_sync;
  wire                    sysref;
  wire                    ref_clk0;
  wire                    ref_clk1;

  assign gpio_i[94:70] = gpio_o[94:70];
  assign gpio_i[31:21] = gpio_o[31:21];

  assign sysref_out = 0;

  // instantiations

  IBUFDS i_ibufds_core_clk (
    .I (core_clk_p),
    .IB (core_clk_n),
    .O (core_clk));

  BUFG i_ibufg_core_clk (
    .I (core_clk),
    .O (core_clk_buf));

  IBUFDS_GTE4 i_ibufds_ref_clk0 (
    .CEB (1'd0),
    .I (ref_clk0_p),
    .IB (ref_clk0_n),
    .O (ref_clk0),
    .ODIV2 (ref_clk0_odiv2));

  IBUFDS_GTE4 i_ibufds_ref_clk1 (
    .CEB (1'd0),
    .I (ref_clk1_p),
    .IB (ref_clk1_n),
    .O (ref_clk1),
    .ODIV2 (ref_clk1_odiv2));

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  OBUFDS i_obufds_rx_os_sync (
    .I (rx_os_sync),
    .O (rx_os_sync_p),
    .OB (rx_os_sync_n));

  OBUFDS i_obufds_sysref_out (
    .I (sysref_out),
    .O (sysref_out_p),
    .OB (sysref_out_n));

  IBUFDS i_ibufds_tx_sync (
    .I (tx_sync_p),
    .IB (tx_sync_n),
    .O (tx_sync));

  IBUFDS i_ibufds_tx_sync_1 (
    .I (tx_sync_1_p),
    .IB (tx_sync_1_n),
    .O (tx_sync_1));

  IBUFDS i_ibufds_tx_sync_2 (
    .I (tx_sync_2_p),
    .IB (tx_sync_2_n),
    .O (tx_sync_2));

  IBUFDS i_ibufds_sysref (
    .I (sysref_in_p),
    .IB (sysref_in_n),
    .O (sysref));

  ad_iobuf #(
    .DATA_WIDTH(38)
  ) i_iobuf (
    .dio_t ({gpio_t[69:32]}),
    .dio_i ({gpio_o[69:32]}),
    .dio_o ({gpio_i[69:32]}),
    .dio_p ({ ad9528_reset_b,       // 69
              ad9528_sysref_req,    // 68
              adrv904x_trx0_enable, // 67
              adrv904x_trx1_enable, // 66
              adrv904x_trx2_enable, // 65
              adrv904x_trx3_enable, // 64
              adrv904x_trx4_enable, // 63
              adrv904x_trx5_enable, // 62
              adrv904x_trx6_enable, // 61
              adrv904x_trx7_enable, // 60
              adrv904x_orx0_enable, // 59
              adrv904x_orx1_enable, // 58
              adrv904x_test,        // 57
              adrv904x_reset_b,     // 56
              adrv904x_gpio}));     // 55-32

  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[ 7: 0];

  assign spi_csn_ad9528 =  spi_csn[1];
  assign spi_csn_adrv904x =  spi_csn[0];

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .core_clk(core_clk_buf),
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
    .rx_ref_clk_0 (ref_clk0),
    .rx_ref_clk_1 (ref_clk0),
    .rx_os_ref_clk_0 (ref_clk),
    .rx_sync_0 (rx_sync),
    .rx_os_sync (rx_os_sync),
    .rx_sysref_0 (sysref),
    .rx_os_sysref (sysref),
    .spi0_sclk (spi_clk),
    .spi0_csn (spi_csn),
    .spi0_miso (spi_miso),
    .spi0_mosi (spi_mosi),
    .spi1_sclk (),
    .spi1_csn (),
    .spi1_miso (1'b0),
    .spi1_mosi (),
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
    .tx_ref_clk_0 (ref_clk0),
    .tx_ref_clk_1 (ref_clk0),
    .tx_sync_0 (tx_sync),
    .tx_sysref_0 (sysref),
    .ext_sync_in (sysref));

endmodule
