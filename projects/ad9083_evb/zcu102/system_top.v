// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
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

  input                   ref_clk0_p,
  input                   ref_clk0_n,

  input                   glblclk_p,
  input                   glblclk_n,

  input       [ 3:0]      rx_data_p,
  input       [ 3:0]      rx_data_n,
  output                  rx_sync_p,
  output                  rx_sync_n,

  input                   sysref_p,
  input                   sysref_n,

  inout                   pwdn,
  inout                   rstb,
  inout                   refsel,

  inout                   spi_sdio,
  output                  spi_csn_clk,
  output                  spi_csn_adc,
  output                  spi_clk
);

  // internal signals

  wire        [94:0]      gpio_i;
  wire        [94:0]      gpio_o;
  wire        [94:0]      gpio_t;
  wire        [20:0]      gpio_bd;
  wire                    ref_clk0;
  wire                    rx_sync;
  wire                    sysref;
  wire                    sysref_s;
  wire                    rx_ref_core_clk0_s;
  wire                    rx_ref_core_clk0;

  wire         [ 2:0]     spi0_csn;
  wire                    spi0_clk;
  wire                    spi0_mosi;
  wire                    spi0_miso;
  wire                    spi_miso;
  wire                    spi_mosi;

  assign gpio_i[94:35] = gpio_o[94:35];
  assign gpio_i[31:21] = gpio_o[31:21];
  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];

  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[7:0];

  assign spi_csn_adc = spi0_csn[0];
  assign spi_csn_clk = spi0_csn[1];
  assign spi_clk = spi0_clk;
  assign spi_mosi = spi0_mosi;
  assign spi0_miso = spi_miso;

  // instantiations

  IBUFDS IBUFDS_inst (
    .O(rx_ref_core_clk0_s),
    .I(glblclk_p),
    .IB(glblclk_n));

  BUFG BUFG_inst (
    .O(rx_ref_core_clk0),
    .I(rx_ref_core_clk0_s));

  IBUFDS_GTE4 i_ibufds_ref_clk0 (
    .CEB (1'd0),
    .I (ref_clk0_p),
    .IB (ref_clk0_n),
    .O (ref_clk0),
    .ODIV2 ());

  ad_3w_spi #(
    .NUM_OF_SLAVES(2)
  ) i_spi (
    .spi_csn(spi0_csn[1:0]),
    .spi_clk(spi_clk),
    .spi_mosi(spi_mosi),
    .spi_miso(spi_miso),
    .spi_sdio(spi_sdio),
    .spi_dir(spidbg_dir));

  ad_iobuf #(
    .DATA_WIDTH(3)
  ) i_iobuf (
    .dio_t ({gpio_t[34:32]}),
    .dio_i ({gpio_o[34:32]}),
    .dio_o ({gpio_i[34:32]}),
    .dio_p ({refsel,         // 34
             rstb,           // 33
             pwdn}));        // 32

  IBUFDS i_ibufds_sysref (
    .I (sysref_p),
    .IB (sysref_n),
    .O (sysref));

//  BUFG i_bufg_gt_sysref(
//    .I(sysref_s),
//    .O(sysref));

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

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
    .rx_ref_clk_0 (ref_clk0),
    .rx_core_clk_0 (rx_ref_core_clk0),
    .rx_sync_0 (rx_sync),
    .rx_sysref_0 (sysref),
    .spi0_sclk (spi0_clk),
    .spi0_csn (spi0_csn),
    .spi0_miso (spi0_miso),
    .spi0_mosi (spi0_mosi),
    .spi1_csn (),
    .spi1_miso (),
    .spi1_mosi (),
    .spi1_sclk ());

endmodule
