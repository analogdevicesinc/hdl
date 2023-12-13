// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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

  input                   sysref_p,
  input                   sysref_n,

  input       [ 3:0]      rx_data_p,
  input       [ 3:0]      rx_data_n,
  output                  rx_sync_p,
  output                  rx_sync_n,

  output                  spi_csn,
  output                  spi_clk,
  output                  spi_mosi,
  input                   spi_miso,

  inout                   fda,
  inout                   fdb,
  inout                   pwdn,

  output                  pmod_spi_csn,
  output                  pmod_spi_mosi,
  input                   pmod_spi_miso,
  output                  pmod_spi_clk
);

  // internal signals

  wire        [94:0]      gpio_i;
  wire        [94:0]      gpio_o;
  wire        [94:0]      gpio_t;
  wire        [20:0]      gpio_bd;
  wire                    ref_clk0;
  wire                    rx_sync;
  wire                    rx_ref_core_clk0_s;
  wire                    rx_ref_core_clk0;
  wire         [2:0]      spi0_csn;
  wire         [2:0]      spi1_csn;
  wire                    sysref_s;
  wire                    sysref_0;

  assign gpio_i[94:35] = gpio_o[94:35];
  assign gpio_i[31:21] = gpio_o[31:21];
  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];

  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[7:0];

  assign spi_csn = spi0_csn[0];
  assign pmod_spi_csn = spi1_csn[0];

  // instantiations

  ad_iobuf #(
    .DATA_WIDTH(3)
  ) i_iobuf (
    .dio_t ({gpio_t[34:32]}),
    .dio_i ({gpio_o[34:32]}),
    .dio_o ({gpio_i[34:32]}),
    .dio_p ({fdb,        // 34
             fda,        // 33
             pwdn}));    // 32

  IBUFDS_GTE4 i_ibufds_ref_clk0 (
    .CEB (1'd0),
    .I (ref_clk0_p),
    .IB (ref_clk0_n),
    .O (ref_clk0),
    .ODIV2 (rx_ref_core_clk0_s));

  BUFG_GT i_bufg_gt_ref_core_clk(
    .I(rx_ref_core_clk0_s),
    .CE (1'b1),
    .CEMASK(1'b1),
    .CLR (1'b0),
    .CLRMASK(1'b1),
    .DIV (3'b000),
    .O(rx_ref_core_clk0));

  IBUFDS_GTE4 i_ibufds_sysref (
    .CEB (1'd0),
    .I (sysref_p),
    .IB (sysref_n),
    .O (),
    .ODIV2 (sysref_s));

  BUFG_GT i_bufg_gt_sysref(
    .I(sysref_s),
    .CE (1'b1),
    .CEMASK(1'b1),
    .CLR (1'b0),
    .CLRMASK(1'b1),
    .DIV (3'b000),
    .O(sysref_0));

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
    .rx_sysref_0 (sysref_0),
    .spi0_csn (spi0_csn),
    .spi0_miso (spi_miso),
    .spi0_mosi (spi_mosi),
    .spi0_sclk (spi_clk),
    .spi1_csn (spi1_csn),
    .spi1_miso (pmod_spi_miso),
    .spi1_mosi (pmod_spi_mosi),
    .spi1_sclk (pmod_spi_clk));

endmodule
