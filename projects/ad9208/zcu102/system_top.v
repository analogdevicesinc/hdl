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

  input   [12:0]  gpio_bd_i,
  output  [ 7:0]  gpio_bd_o,

  input           rx_core_clk_p,
  input           rx_core_clk_n,
  input           rx_ref_clk_p,
  input           rx_ref_clk_n,
  input           rx_sysref_p,
  input           rx_sysref_n,
  output          rx_sync_p,
  output          rx_sync_n,
  input   [ 7:0]  rx_data_p,
  input   [ 7:0]  rx_data_n,

  inout           pwdn,
  inout           fda,
  inout           fdb,
  inout           gpio_a1,
  inout           gpio_b1,

  output          spi_csb_adt7320,
  output          spi_sdi_adt7320,
  input           spi_sdo_adt7320,
  output          spi_clk_adt7320,

  output          spi_csn_adc,
  output          spi_csn_vref,
  output          spi_clk_adc,
  input           spi_miso_adc,
  output          spi_mosi_adc,

  output          pmod_spi_csn,
  output          pmod_spi_mosi,
  input           pmod_spi_miso,
  output          pmod_spi_clk
);


  // internal signals

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [94:0]  gpio_t;
  wire    [20:0]  gpio_bd;
  wire    [ 2:0]  spi_csn;
  wire    [ 2:0]  spi_csn_1;
  wire            rx_ref_clk;
  wire            rx_core_clk;
  wire            rx_sysref;
  wire            rx_sysref_s;
  wire            rx_sync;

  assign spi_miso = | ({spi_sdo_adt7320, spi_miso_adc, spi_miso_adc} & ~spi_csn);
  assign spi_mosi_adc = spi_mosi;
  assign spi_sdi_adt7320 = spi_mosi;
  assign spi_clk_adt7320 = spi_clk;
  assign spi_clk_adc = spi_clk;

  assign pmod_spi_csn = spi_csn_1[0];

  assign gpio_i[94:37] = gpio_o[94:37];
  assign gpio_i[31:21] = gpio_o[31:21];
  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];


  assign spi_csn_adc = spi_csn[0];
  assign spi_csn_vref = spi_csn[1];
  assign spi_csb_adt7320 = spi_csn[2];

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
    .O (rx_sysref_s));

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  IBUFDS i_ibufds_rx_core_clk (
    .I (rx_core_clk_n),
    .IB (rx_core_clk_p),
    .O (rx_core_clk));

  IDDRE1 #(
    .DDR_CLK_EDGE("OPPOSITE_EDGE"),
    .IS_CB_INVERTED(1),
    .IS_C_INVERTED(1'b0)
  ) iddre1_sysref (
    .Q1(rx_sysref),
    .Q2(),
    .C(rx_core_clk),
    .CB(rx_core_clk),
    .D(rx_sysref_s),
    .R(1'b0));

  ad_iobuf #(.DATA_WIDTH(5)) i_iobuf (
    .dio_t ({gpio_t[36:32]}),
    .dio_i ({gpio_o[36:32]}),
    .dio_o ({gpio_i[36:32]}),
    .dio_p ({ gpio_b1,    // 36
              gpio_a1,    // 35
              fdb,        // 34
              fda,        // 33
              pwdn}));    // 32

  assign gpio_i[20:8] = gpio_bd_i;
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
  .rx_data_4_n (rx_data_n[4]),
  .rx_data_4_p (rx_data_p[4]),
  .rx_data_5_n (rx_data_n[5]),
  .rx_data_5_p (rx_data_p[5]),
  .rx_data_6_n (rx_data_n[6]),
  .rx_data_6_p (rx_data_p[6]),
  .rx_data_7_n (rx_data_n[7]),
  .rx_data_7_p (rx_data_p[7]),
  .rx_core_clk (rx_core_clk),
  .rx_ref_clk_0 (rx_ref_clk),
  .rx_sync_0 (rx_sync),
  .rx_sysref_0 (rx_sysref),
  .spi0_csn (spi_csn),
  .spi0_miso (spi_miso),
  .spi0_mosi (spi_mosi),
  .spi0_sclk (spi_clk),
  .spi1_csn (spi_csn_1),
  .spi1_miso (pmod_spi_miso),
  .spi1_mosi (pmod_spi_mosi),
  .spi1_sclk (pmod_spi_clk));

endmodule

// ***************************************************************************
// ***************************************************************************
