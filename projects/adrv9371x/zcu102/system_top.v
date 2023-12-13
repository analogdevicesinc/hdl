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

  inout                   iic_scl,
  inout                   iic_sda,

  input                   ref_clk0_p,
  input                   ref_clk0_n,
  input                   ref_clk1_p,
  input                   ref_clk1_n,
  input       [ 3:0]      rx_data_p,
  input       [ 3:0]      rx_data_n,
  output      [ 3:0]      tx_data_p,
  output      [ 3:0]      tx_data_n,
  output                  rx_sync_p,
  output                  rx_sync_n,
  output                  rx_os_sync_p,
  output                  rx_os_sync_n,
  input                   tx_sync_p,
  input                   tx_sync_n,
  input                   sysref_p,
  input                   sysref_n,

  output                  spi_csn_ad9528,
  output                  spi_csn_ad9371,
  output                  spi_clk,
  output                  spi_mosi,
  input                   spi_miso,

  inout                   ad9528_reset_b,
  inout                   ad9528_sysref_req,
  inout                   ad9371_tx1_enable,
  inout                   ad9371_tx2_enable,
  inout                   ad9371_rx1_enable,
  inout                   ad9371_rx2_enable,
  inout                   ad9371_test,
  inout                   ad9371_reset_b,
  inout                   ad9371_gpint,

  inout                   ad9371_gpio_00,
  inout                   ad9371_gpio_01,
  inout                   ad9371_gpio_02,
  inout                   ad9371_gpio_03,
  inout                   ad9371_gpio_04,
  inout                   ad9371_gpio_05,
  inout                   ad9371_gpio_06,
  inout                   ad9371_gpio_07,
  inout                   ad9371_gpio_15,
  inout                   ad9371_gpio_08,
  inout                   ad9371_gpio_09,
  inout                   ad9371_gpio_10,
  inout                   ad9371_gpio_11,
  inout                   ad9371_gpio_12,
  inout                   ad9371_gpio_14,
  inout                   ad9371_gpio_13,
  inout                   ad9371_gpio_17,
  inout                   ad9371_gpio_16,
  inout                   ad9371_gpio_18
);

  // internal signals

  wire        [94:0]      gpio_i;
  wire        [94:0]      gpio_o;
  wire        [94:0]      gpio_t;
  wire        [20:0]      gpio_bd;
  wire        [ 2:0]      spi_csn;
  wire                    ref_clk0;
  wire                    ref_clk1;
  wire                    rx_sync;
  wire                    rx_os_sync;
  wire                    tx_sync;
  wire                    sysref;

  // instantiations

  IBUFDS_GTE4 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (ref_clk0_p),
    .IB (ref_clk0_n),
    .O (ref_clk0),
    .ODIV2 ());

  IBUFDS_GTE4  #(
    .REFCLK_HROW_CK_SEL(2'b00) // ODIV2 = O
  ) i_ibufds_ref_clk1 (
    .CEB (1'd0),
    .I (ref_clk1_p),
    .IB (ref_clk1_n),
    .O (ref_clk1),
    .ODIV2 (ref_clk1_odiv2));

  BUFG_GT i_bufg_ref_clk (
    .I (ref_clk1_odiv2),
    .O (ref_clk1_bufg));

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  OBUFDS i_obufds_rx_os_sync (
    .I (rx_os_sync),
    .O (rx_os_sync_p),
    .OB (rx_os_sync_n));

  IBUFDS i_ibufds_tx_sync (
    .I (tx_sync_p),
    .IB (tx_sync_n),
    .O (tx_sync));

  IBUFDS i_ibufds_sysref (
    .I (sysref_p),
    .IB (sysref_n),
    .O (sysref));

  ad_iobuf #(
    .DATA_WIDTH(28)
  ) i_iobuf (
    .dio_t ({gpio_t[59:32]}),
    .dio_i ({gpio_o[59:32]}),
    .dio_o ({gpio_i[59:32]}),
    .dio_p ({ ad9528_reset_b,       // 59
              ad9528_sysref_req,    // 58
              ad9371_tx1_enable,    // 57
              ad9371_tx2_enable,    // 56
              ad9371_rx1_enable,    // 55
              ad9371_rx2_enable,    // 54
              ad9371_test,          // 53
              ad9371_reset_b,       // 52
              ad9371_gpint,         // 51
              ad9371_gpio_00,       // 50
              ad9371_gpio_01,       // 49
              ad9371_gpio_02,       // 48
              ad9371_gpio_03,       // 47
              ad9371_gpio_04,       // 46
              ad9371_gpio_05,       // 45
              ad9371_gpio_06,       // 44
              ad9371_gpio_07,       // 43
              ad9371_gpio_15,       // 42
              ad9371_gpio_08,       // 41
              ad9371_gpio_09,       // 40
              ad9371_gpio_10,       // 39
              ad9371_gpio_11,       // 38
              ad9371_gpio_12,       // 37
              ad9371_gpio_14,       // 36
              ad9371_gpio_13,       // 35
              ad9371_gpio_17,       // 34
              ad9371_gpio_16,       // 33
              ad9371_gpio_18}));    // 32

  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_i[31:21] = gpio_o[31:21];
  assign gpio_i[94:60] = gpio_o[94:60];

  assign gpio_bd_o = gpio_o[ 7: 0];

  assign spi_csn_ad9528 =  spi_csn[0];
  assign spi_csn_ad9371 =  spi_csn[1];

  system_wrapper i_system_wrapper (
    .dac_fifo_bypass (gpio_o[60]),
    .adc_fir_filter_active (gpio_o[61]),
    .dac_fir_filter_active (gpio_o[62]),
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
    .rx_ref_clk_0 (ref_clk1),
    .rx_ref_clk_2 (ref_clk1),
    .rx_sync_0 (rx_sync),
    .rx_sync_2 (rx_os_sync),
    .rx_sysref_0 (sysref),
    .rx_sysref_2 (sysref),
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
    .tx_ref_clk_0 (ref_clk1),
    .tx_sync_0 (tx_sync),
    .tx_sysref_0 (sysref),
    .ref_clk (ref_clk1_bufg));

endmodule
