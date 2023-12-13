// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

  inout   [14:0]      ddr_addr,
  inout   [ 2:0]      ddr_ba,
  inout               ddr_cas_n,
  inout               ddr_ck_n,
  inout               ddr_ck_p,
  inout               ddr_cke,
  inout               ddr_cs_n,
  inout   [ 3:0]      ddr_dm,
  inout   [31:0]      ddr_dq,
  inout   [ 3:0]      ddr_dqs_n,
  inout   [ 3:0]      ddr_dqs_p,
  inout               ddr_odt,
  inout               ddr_ras_n,
  inout               ddr_reset_n,
  inout               ddr_we_n,

  inout               fixed_io_ddr_vrn,
  inout               fixed_io_ddr_vrp,
  inout   [53:0]      fixed_io_mio,
  inout               fixed_io_ps_clk,
  inout               fixed_io_ps_porb,
  inout               fixed_io_ps_srstb,

  inout   [14:0]      gpio_bd,

  output              hdmi_out_clk,
  output              hdmi_vsync,
  output              hdmi_hsync,
  output              hdmi_data_e,
  output  [23:0]      hdmi_data,

  output              spdif,

  input               sys_rst,
  input               sys_clk_p,
  input               sys_clk_n,

  inout               iic_scl,
  inout               iic_sda,

  // mii interface

  output              reset_a,
  output              mdc_fmc_a,
  inout               mdio_fmc_a,
  input               rmii_rx_ref_clk_a,
  input   [ 1:0]      rmii_rxd_a,
  input               rmii_rx_er_a,
  input               rmii_rx_dv_a,
  output  [ 1:0]      rmii_txd_a,
  output              rmii_tx_en_a,
  input               link_st_a,
  input               led_0_a,
  output              mac_if_sel_0_a,

  output              reset_b,
  output              mdc_fmc_b,
  inout               mdio_fmc_b,
  input               rmii_rx_ref_clk_b,
  input   [ 1:0]      rmii_rxd_b,
  input               rmii_rx_er_b,
  input               rmii_rx_dv_b,
  output  [ 1:0]      rmii_txd_b,
  output              rmii_tx_en_b,
  input               link_st_b,
  input               led_0_b,
  output              mac_if_sel_0_b,

  // LEDs

  output              led_ar_c_c2m,
  output              led_ar_a_c2m,
  output              led_al_c_c2m,
  output              led_al_a_c2m,

  output              led_br_c_c2m,
  output              led_br_a_c2m,
  output              led_bl_c_c2m,
  output              led_bl_a_c2m
);

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;

  // assignments

  assign mac_if_sel_0_a = 1'b1;
  assign mac_if_sel_0_b = 1'b1;

  // port a - right led (activity/status) yellow only

  assign led_ar_c_c2m = led_0_a;
  assign led_ar_a_c2m = 1'b0;

  // port a - left led (speed mode) hard-coded to 100M=yellow no feedback from mac

  assign led_al_c_c2m = 1'b1;
  assign led_al_a_c2m = 1'b0;

  // port b - right led (activity/status) yellow only

  assign led_br_c_c2m = led_0_b;
  assign led_br_a_c2m = 1'b0;

  // port b - left led (speed mode) hard-coded to 100M=yellow no feedback from mac

  assign led_bl_c_c2m = 1'b1;
  assign led_bl_a_c2m = 1'b0;

  assign gpio_i[63:36] = gpio_o[63:36];

  assign gpio_reset_a = gpio_o[37];
  assign gpio_reset_b = gpio_o[36];

  assign reset_a = sys_reset_a | gpio_reset_a;
  assign reset_b = sys_reset_b | gpio_reset_b;

  assign gpio_i[35] = link_st_a;
  assign gpio_i[34] = link_st_b;
  assign gpio_i[33:15] = gpio_o[33:15];

  // instantiations

  ad_iobuf #(
    .DATA_WIDTH(15)
  ) i_iobuf_bd (
    .dio_t (gpio_t[14:0]),
    .dio_i (gpio_o[14:0]),
    .dio_o (gpio_i[14:0]),
    .dio_p (gpio_bd));

  system_wrapper i_system_wrapper (
    .ddr_addr (ddr_addr),
    .ddr_ba (ddr_ba),
    .ddr_cas_n (ddr_cas_n),
    .ddr_ck_n (ddr_ck_n),
    .ddr_ck_p (ddr_ck_p),
    .ddr_cke (ddr_cke),
    .ddr_cs_n (ddr_cs_n),
    .ddr_dm (ddr_dm),
    .ddr_dq (ddr_dq),
    .ddr_dqs_n (ddr_dqs_n),
    .ddr_dqs_p (ddr_dqs_p),
    .ddr_odt (ddr_odt),
    .ddr_ras_n (ddr_ras_n),
    .ddr_reset_n (ddr_reset_n),
    .ddr_we_n (ddr_we_n),
    .fixed_io_ddr_vrn (fixed_io_ddr_vrn),
    .fixed_io_ddr_vrp (fixed_io_ddr_vrp),
    .fixed_io_mio (fixed_io_mio),
    .fixed_io_ps_clk (fixed_io_ps_clk),
    .fixed_io_ps_porb (fixed_io_ps_porb),
    .fixed_io_ps_srstb (fixed_io_ps_srstb),
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
    .spi0_clk_i (1'b0),
    .spi0_clk_o (),
    .spi0_csn_0_o (),
    .spi0_csn_1_o (),
    .spi0_csn_2_o (),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (1'b0),
    .spi0_sdo_i (1'b0),
    .spi0_sdo_o (),
    .spi1_clk_i (1'b0),
    .spi1_clk_o (),
    .spi1_csn_0_o (),
    .spi1_csn_1_o (),
    .spi1_csn_2_o (),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (1'b0),
    .spi1_sdo_i (1'b0),
    .spi1_sdo_o(),
    .reset_a (sys_reset_a),
    .reset_b (sys_reset_b),
    .ref_clk_50_a (rmii_rx_ref_clk_a),
    .ref_clk_50_b (rmii_rx_ref_clk_b),
    .MDIO_ETHERNET_0_0_mdc(mdc_fmc_a),
    .MDIO_ETHERNET_0_0_mdio_io(mdio_fmc_a),
    .RMII_PHY_M_0_crs_dv (rmii_rx_dv_a),
    .RMII_PHY_M_0_rx_er (rmii_rx_er_a),
    .RMII_PHY_M_0_rxd (rmii_rxd_a),
    .RMII_PHY_M_0_tx_en (rmii_tx_en_a),
    .RMII_PHY_M_0_txd (rmii_txd_a),
    .MDIO_ETHERNET_1_0_mdc(mdc_fmc_b),
    .MDIO_ETHERNET_1_0_mdio_io(mdio_fmc_b),
    .RMII_PHY_M_1_crs_dv (rmii_rx_dv_b),
    .RMII_PHY_M_1_rx_er (rmii_rx_er_b),
    .RMII_PHY_M_1_rxd (rmii_rxd_b),
    .RMII_PHY_M_1_tx_en (rmii_tx_en_b),
    .RMII_PHY_M_1_txd (rmii_txd_b));

endmodule
