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

  input                   glblclk_p,
  input                   glblclk_n,

  input       [ 3:0]      rx_data_p,
  input       [ 3:0]      rx_data_n,
  output                  rx_sync_p,
  output                  rx_sync_n,

  input                   sysref_p,
  input                   sysref_n,

  output                  pwdn,
  output                  rstb,

  output                  spi_sdio,
  input                   spi_sdo,
  output                  spi_csn_clk,
  output                  spi_csn_adc,
  output                  spi_clk,
  output                  adc_lvsft_en,
  output                  clkd_lvsft_en,

  output                  spi_bus0_sck,
  output                  spi_bus0_sdi,
  input                   spi_bus0_sdo,
  output                  spi_bus0_csn_f2,
  output                  spi_bus0_csn_sen,

  output                  spi_bus1_sck,
  output                  spi_bus1_sdi,
  input                   spi_bus1_sdo,
  output                  spi_bus1_csn_dat1,
  output                  spi_bus1_csn_dat2,

  output                  spi_adl5960_1_sck,
  inout                   spi_adl5960_1_sdio,
  output                  spi_adl5960_1_csn1,
  output                  spi_adl5960_1_csn2,
  output                  spi_adl5960_1_csn3,
  output                  spi_adl5960_1_csn4,

  output                  spi_adl5960_2_sck,
  inout                   spi_adl5960_2_sdio,
  output                  spi_adl5960_2_csn5,
  output                  spi_adl5960_2_csn6,
  output                  spi_adl5960_2_csn7,
  output                  spi_adl5960_2_csn8,

  output                  adl5960_temp_1,
  output                  adl5960_temp_2,
  output                  adl5960_temp_3,
  output                  adl5960_temp_4,
  output                  adl5960_temp_5,
  output                  adl5960_temp_6,
  output                  adl5960_temp_7,
  output                  adl5960_temp_8,

  output                  gpio_sw0,
  output                  gpio_sw1,
  output                  gpio_sw2,
  output                  gpio_sw3_v1,
  output                  gpio_sw3_v2,
  output                  gpio_sw4_v1,
  output                  gpio_sw4_v2,

  output      [ 7:0]      prten,

  output                  adl5960x_sync1
);

  // internal signals

  wire        [94:0]      gpio_i;
  wire        [94:0]      gpio_o;
  wire        [94:0]      gpio_t;
  wire        [20:0]      gpio_bd;
  wire                    ref_clk0;
  wire                    rx_sync;
  wire                    sysref;
  wire                    rx_ref_core_clk0_s;
  wire                    rx_ref_core_clk0;

  wire         [ 2:0]     spi0_csn;
  wire                    spi0_mosi;
  wire                    spi0_miso;

  wire         [ 2:0]     spi_bus0_csn;
  wire         [ 1:0]     spi_bus1_csn;

  wire         [ 3:0]     spi_adl5960_1_csn_s;
  wire                    spi_adl5960_1_clk_s;
  wire                    spi_adl5960_1_mosi_s;
  wire                    spi_adl5960_1_miso_s;

  wire         [ 3:0]     spi_adl5960_2_csn_s;
  wire                    spi_adl5960_2_clk_s;
  wire                    spi_adl5960_2_mosi_s;
  wire                    spi_adl5960_2_miso_s;
  wire         [ 2:0]     pr_check;

  // assignments

  assign spi_csn_adc = spi0_csn[0];
  assign spi_csn_clk = spi0_csn[1];

  assign spi_bus0_csn_sen = spi_bus0_csn[2];
  assign spi_bus0_csn_f2 = spi_bus0_csn[1];

  assign spi_bus1_csn_dat1 = spi_bus1_csn[0];
  assign spi_bus1_csn_dat2 = spi_bus1_csn[1];

  assign spi_adl5960_1_sck = spi_adl5960_1_clk_s;
  assign spi_adl5960_1_csn1 = spi_adl5960_1_csn_s[0];
  assign spi_adl5960_1_csn2 = spi_adl5960_1_csn_s[1];
  assign spi_adl5960_1_csn3 = spi_adl5960_1_csn_s[2];
  assign spi_adl5960_1_csn4 = spi_adl5960_1_csn_s[3];

  assign spi_adl5960_2_sck = spi_adl5960_2_clk_s;
  assign spi_adl5960_2_csn5 = spi_adl5960_2_csn_s[0];
  assign spi_adl5960_2_csn6 = spi_adl5960_2_csn_s[1];
  assign spi_adl5960_2_csn7 = spi_adl5960_2_csn_s[2];
  assign spi_adl5960_2_csn8 = spi_adl5960_2_csn_s[3];

  assign adl5960_temp_8 = gpio_o[48];
  assign adl5960_temp_7 = gpio_o[47];
  assign adl5960_temp_6 = gpio_o[46];
  assign adl5960_temp_5 = gpio_o[45];
  assign adl5960_temp_4 = gpio_o[44];
  assign adl5960_temp_3 = gpio_o[43];
  assign adl5960_temp_2 = gpio_o[42];
  assign adl5960_temp_1 = gpio_o[41];
  assign gpio_sw3_v2 = gpio_o[40];
  assign gpio_sw4_v2 = gpio_o[40];
  assign gpio_sw3_v1 = gpio_o[39];
  assign gpio_sw4_v1 = gpio_o[39];
  assign gpio_sw2 = gpio_o[38];
  assign gpio_sw1 = gpio_o[37];
  assign gpio_sw0 = gpio_o[36];
  assign adl5960x_sync1 = gpio_o[35];
  assign rstb = gpio_o[33];
  assign pwdn = gpio_o[32];

  assign pr_check = {gpio_o[38],gpio_o[40],gpio_o[39]};
  assign prten = (pr_check == 3'b000) ? 8'd1 :
                 (pr_check == 3'b001) ? 8'd2 :
                 (pr_check == 3'b010) ? 8'd4 : 8'd0;

  assign gpio_i[94:32] = gpio_o[94:32];
  assign gpio_i[31:21] = gpio_o[31:21];
  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];

  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[7:0];

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

  assign adc_lvsft_en  = spi_csn_adc;
  assign clkd_lvsft_en = spi_csn_clk;

  ad_3w_spi #(
    .NUM_OF_SLAVES(4)
  ) i_spi_adl5960_1 (
    .spi_csn(spi_adl5960_1_csn_s),
    .spi_clk(spi_adl5960_1_clk_s),
    .spi_mosi(spi_adl5960_1_mosi_s),
    .spi_miso(spi_adl5960_1_miso_s),
    .spi_sdio(spi_adl5960_1_sdio),
    .spi_dir());

  ad_3w_spi #(
    .NUM_OF_SLAVES(4)
  ) i_spi_adl5960_2 (
    .spi_csn(spi_adl5960_2_csn_s),
    .spi_clk(spi_adl5960_2_clk_s),
    .spi_mosi(spi_adl5960_2_mosi_s),
    .spi_miso(spi_adl5960_2_miso_s),
    .spi_sdio(spi_adl5960_2_sdio),
    .spi_dir());

  IBUFDS i_ibufds_sysref (
    .I (sysref_p),
    .IB (sysref_n),
    .O (sysref));

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
    .spi0_sclk (spi_clk),
    .spi0_csn (spi0_csn),
    .spi0_miso (spi_sdo),
    .spi0_mosi (spi_sdio),
    .spi1_csn (spi_bus0_csn),
    .spi1_miso (spi_bus0_sdo),
    .spi1_mosi (spi_bus0_sdi),
    .spi1_sclk (spi_bus0_sck),
    .spi_bus1_csn_i (spi_bus1_csn),
    .spi_bus1_csn_o (spi_bus1_csn),
    .spi_bus1_clk_i (spi_bus1_sck),
    .spi_bus1_clk_o (spi_bus1_sck),
    .spi_bus1_sdo_i (spi_bus1_sdi),
    .spi_bus1_sdo_o (spi_bus1_sdi),
    .spi_bus1_sdi_i (spi_bus1_sdo),
    .spi_adl5960_1_csn_i (spi_adl5960_1_csn_s),
    .spi_adl5960_1_csn_o (spi_adl5960_1_csn_s),
    .spi_adl5960_1_clk_i (spi_adl5960_1_clk_s),
    .spi_adl5960_1_clk_o (spi_adl5960_1_clk_s),
    .spi_adl5960_1_sdo_i (spi_adl5960_1_mosi_s),
    .spi_adl5960_1_sdo_o (spi_adl5960_1_mosi_s),
    .spi_adl5960_1_sdi_i (spi_adl5960_1_miso_s),
    .spi_adl5960_2_csn_i (spi_adl5960_2_csn_s),
    .spi_adl5960_2_csn_o (spi_adl5960_2_csn_s),
    .spi_adl5960_2_clk_i (spi_adl5960_2_clk_s),
    .spi_adl5960_2_clk_o (spi_adl5960_2_clk_s),
    .spi_adl5960_2_sdo_i (spi_adl5960_2_mosi_s),
    .spi_adl5960_2_sdo_o (spi_adl5960_2_mosi_s),
    .spi_adl5960_2_sdi_i (spi_adl5960_2_miso_s));

endmodule
