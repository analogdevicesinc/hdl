// ***************************************************************************
// ***************************************************************************
// Copyright 2022 (c) Analog Devices, Inc. All rights reserved.
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

  inout       [14:0]      gpio_bd,

  output                  hdmi_out_clk,
  output                  hdmi_vsync,
  output                  hdmi_hsync,
  output                  hdmi_data_e,
  output      [23:0]      hdmi_data,

  output                  spdif,

  input                   sys_rst,
  input                   sys_clk_p,
  input                   sys_clk_n,

  inout                   iic_scl,
  inout                   iic_sda,

  // project specific signals

  output      [ 3:0]      rx_clk_p,
  output      [ 3:0]      rx_clk_n,

  output      [ 3:0]      rx_cnv_p,
  output      [ 3:0]      rx_cnv_n,

  input       [ 3:0]      rx_dco_p,
  input       [ 3:0]      rx_dco_n,

  input       [ 3:0]      rx_da_p,
  input       [ 3:0]      rx_da_n,

  input       [ 3:0]      rx_db_p,
  input       [ 3:0]      rx_db_n,

  output      [ 1:0]      dac_cs,
  output      [ 1:0]      dac_sclk,
  output      [ 1:0]      dac_sdio0,
  input       [ 1:0]      dac_sdio1,
  input       [ 1:0]      dac_sdio2,
  input       [ 1:0]      dac_sdio3,

  input                   spi_miso,
  output                  spi_mosi,
  output                  spi_sck,
  output                  spi_csb,

  output                  direction,
  output                  reset,

  input                   alert_2,
  input                   alert_1,
  output                  ldac_2,
  output                  ldac_1
);

  // internal signals

  wire   [63:0]   gpio_i;
  wire   [63:0]   gpio_o;
  wire   [63:0]   gpio_t;
  wire   [ 2:0]   spi0_csn;
  wire            spi0_clk;
  wire            spi0_mosi;
  wire            spi0_miso;
  wire   [ 2:0]   spi1_csn;
  wire            spi1_clk;
  wire            spi1_mosi;
  wire            spi1_miso;
  wire            trig;
  wire            rx_ref_clk;
  wire            rx_sysref;
  wire            rx_sync;

  wire   [ 3:0]   rx_cnv_s;
  wire   [ 3:0]   rx_cnv;
  wire   [ 3:0]   ltc_clk;

  wire            clk_gate;
  wire            sampling_clk_s;

  // assignations

  assign gpio_i[63:44] = gpio_o[63:44];
  assign gpio_i[39] = gpio_o[39];
  assign gpio_i[37] = gpio_o[37];
  assign gpio_i[31:15] = gpio_o[31:15];

  // spi

  assign spi_csn_adc = spi0_csn[2];
  assign spi_csn_dac = spi0_csn[1];
  assign spi_csn_clk = spi0_csn[0];

  // instantiations

  ad_iobuf #(
    .DATA_WIDTH(15)
  ) i_iobuf_bd (
    .dio_t (gpio_t[14:0]),
    .dio_i (gpio_o[14:0]),
    .dio_o (gpio_i[14:0]),
    .dio_p (gpio_bd));

  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE")
  ) i_tx_clk_oddr0 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (clk_gate),
    .D2 (1'b0),
    .Q (ltc_clk[0]));

  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE")
  ) i_tx_clk_oddr1 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (clk_gate),
    .D2 (1'b0),
    .Q (ltc_clk[1]));

  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE")
  ) i_tx_clk_oddr2 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (clk_gate),
    .D2 (1'b0),
    .Q (ltc_clk[2]));

  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE")
  ) i_tx_clk_oddr3 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (clk_gate),
    .D2 (1'b0),
    .Q (ltc_clk[3]));

  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE")
  ) i_cnv_oddr0 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (rx_cnv[0]),
    .D2 (rx_cnv[0]),
    .Q (rx_cnv_s[0]));

  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE")
  ) i_cnv_oddr1 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (rx_cnv[1]),
    .D2 (rx_cnv[1]),
    .Q (rx_cnv_s[1]));

  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE")
  ) i_cnv_oddr2 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (rx_cnv[2]),
    .D2 (rx_cnv[2]),
    .Q (rx_cnv_s[2]));

  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE")
  ) i_cnv_oddr3 (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (sampling_clk_s),
    .D1 (rx_cnv[3]),
    .D2 (rx_cnv[3]),
    .Q (rx_cnv_s[3]));

  OBUFDS i_tx_data_obuf0 (
    .I (ltc_clk[0]),
    .O (rx_clk_p[0]),
    .OB (rx_clk_n[0]));

  OBUFDS i_tx_data_obuf1 (
    .I (ltc_clk[1]),
    .O (rx_clk_p[1]),
    .OB (rx_clk_n[1]));

  OBUFDS i_tx_data_obuf2 (
    .I (ltc_clk[2]),
    .O (rx_clk_p[2]),
    .OB (rx_clk_n[2]));

  OBUFDS i_tx_data_obuf3 (
    .I (ltc_clk[3]),
    .O (rx_clk_p[3]),
    .OB (rx_clk_n[3]));

  OBUFDS OBUFDS_cnv0 (
    .O (rx_cnv_p[0]),
    .OB (rx_cnv_n[0]),
    .I (rx_cnv_s[0]));

  OBUFDS OBUFDS_cnv1 (
    .O (rx_cnv_p[1]),
    .OB (rx_cnv_n[1]),
    .I (rx_cnv_s[1]));

  OBUFDS OBUFDS_cnv2 (
    .O (rx_cnv_p[2]),
    .OB (rx_cnv_n[2]),
    .I (rx_cnv_s[2]));

  OBUFDS OBUFDS_cnv3 (
    .O (rx_cnv_p[3]),
    .OB (rx_cnv_n[3]),
    .I (rx_cnv_s[3]));

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .spdif (spdif),

    .spi0_clk_i (spi0_clk),
    .spi0_clk_o (spi0_clk),
    .spi0_csn_0_o (spi0_csn[0]),
    .spi0_csn_1_o (spi0_csn[1]),
    .spi0_csn_2_o (spi0_csn[2]),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (spi0_miso),
    .spi0_sdo_i (spi0_mosi),
    .spi0_sdo_o (spi0_mosi),

    .spi1_clk_i (spi1_clk),
    .spi1_clk_o (spi1_clk),
    .spi1_csn_0_o (spi1_csn[0]),
    .spi1_csn_1_o (spi1_csn[1]),
    .spi1_csn_2_o (spi1_csn[2]),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (1'b1),
    .spi1_sdo_i (spi1_mosi),
    .spi1_sdo_o (spi1_mosi),

    .rx_0_dco_p   (rx_dco_p[0]),
    .rx_0_dco_n   (rx_dco_n[0]),
    .rx_0_cnv     (rx_cnv[0]),
    .rx_0_da_p    (rx_da_p[0]),
    .rx_0_da_n    (rx_da_n[0]),
    .rx_0_db_p    (rx_db_p[0]),
    .rx_0_db_n    (rx_db_n[0]),

    .rx_1_dco_p   (rx_dco_p[1]),
    .rx_1_dco_n   (rx_dco_n[1]),
    .rx_1_cnv     (rx_cnv[1]),
    .rx_1_da_p    (rx_da_p[1]),
    .rx_1_da_n    (rx_da_n[1]),
    .rx_1_db_p    (rx_db_p[1]),
    .rx_1_db_n    (rx_db_n[1]),

    .rx_2_dco_p   (rx_dco_p[2]),
    .rx_2_dco_n   (rx_dco_n[2]),
    .rx_2_cnv     (rx_cnv[2]),
    .rx_2_da_p    (rx_da_p[2]),
    .rx_2_da_n    (rx_da_n[2]),
    .rx_2_db_p    (rx_db_p[2]),
    .rx_2_db_n    (rx_db_n[2]),

    .rx_3_dco_p   (rx_dco_p[3]),
    .rx_3_dco_n   (rx_dco_n[3]),
    .rx_3_cnv     (rx_cnv[3]),
    .rx_3_da_p    (rx_da_p[3]),
    .rx_3_da_n    (rx_da_n[3]),
    .rx_3_db_p    (rx_db_p[3]),
    .rx_3_db_n    (rx_db_n[3]),

    .sampling_clk (sampling_clk_s));

endmodule
