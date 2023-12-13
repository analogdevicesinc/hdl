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

module system_top #(
  parameter RX_JESD_L = 8
) (
  input                   sys_rst,
  input                   sys_clk_p,
  input                   sys_clk_n,

  input                   uart_sin,
  output                  uart_sout,

  output                  ddr3_reset_n,
  output      [13:0]      ddr3_addr,
  output      [ 2:0]      ddr3_ba,
  output                  ddr3_cas_n,
  output                  ddr3_ras_n,
  output                  ddr3_we_n,
  output      [ 0:0]      ddr3_ck_n,
  output      [ 0:0]      ddr3_ck_p,
  output      [ 0:0]      ddr3_cke,
  output      [ 0:0]      ddr3_cs_n,
  output      [ 7:0]      ddr3_dm,
  inout       [63:0]      ddr3_dq,
  inout       [ 7:0]      ddr3_dqs_n,
  inout       [ 7:0]      ddr3_dqs_p,
  output      [ 0:0]      ddr3_odt,

  input                   sgmii_rxp,
  input                   sgmii_rxn,
  output                  sgmii_txp,
  output                  sgmii_txn,

  output                  phy_rstn,
  input                   mgt_clk_p,
  input                   mgt_clk_n,
  output                  mdio_mdc,
  inout                   mdio_mdio,

  output      [26:1]      linear_flash_addr,
  output                  linear_flash_adv_ldn,
  output                  linear_flash_ce_n,
  inout       [15:0]      linear_flash_dq_io,
  output                  linear_flash_oen,
  output                  linear_flash_wen,

  output                  fan_pwm,

  inout       [ 6:0]      gpio_lcd,
  inout       [20:0]      gpio_bd,

  output                  iic_rstn,
  inout                   iic_scl,
  inout                   iic_sda,

  input                   rx_ref_clk_p,
  input                   rx_ref_clk_n,
  output                  rx_sysref_p,
  output                  rx_sysref_n,
  output                  rx_sync_p,
  output                  rx_sync_n,
  input  [RX_JESD_L-1:0]  rx_data_p,
  input  [RX_JESD_L-1:0]  rx_data_n,

  inout                   adc_irq,
  inout                   adc_fd,

  output                  spi_adc_csn,
  output                  spi_adc_clk,
  inout                   spi_adc_sdio,

  output                  spi_adf4355_data_or_csn_0,
  output                  spi_adf4355_clk_or_csn_1,
  output                  spi_adf4355_le_or_clk,
  inout                   spi_adf4355_ce_or_sdio
);

  // internal signals

  wire    [63:0]    gpio_i;
  wire    [63:0]    gpio_o;
  wire    [63:0]    gpio_t;
  wire    [ 7:0]    spi_csn;
  wire              spi_mosi;
  wire              spi_miso;
  wire              rx_ref_clk;
  wire              rx_sync;
  wire              rx_sysref;
  wire              rx_clk;
  wire    [ 7:0]    rx_data_p_loc;
  wire    [ 7:0]    rx_data_n_loc;

  // default logic

  assign fan_pwm = 1'b1;
  assign iic_rstn = 1'b1;

  // instantiations

  IBUFDS_GTE2 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (rx_ref_clk_p),
    .IB (rx_ref_clk_n),
    .O (rx_ref_clk),
    .ODIV2 ());

  OBUFDS i_obufds_rx_sysref (
    .I (rx_sysref),
    .O (rx_sysref_p),
    .OB (rx_sysref_n));

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  fmcadc2_spi i_fmcadc2_spi (
    .spi_adf4355 (gpio_o[36]),
    .spi_adf4355_ce (gpio_o[37]),
    .spi_clk (spi_clk),
    .spi_csn (spi_csn[2:0]),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_adc_csn (spi_adc_csn),
    .spi_adc_clk (spi_adc_clk),
    .spi_adc_sdio (spi_adc_sdio),
    .spi_adf4355_data_or_csn_0 (spi_adf4355_data_or_csn_0),
    .spi_adf4355_clk_or_csn_1 (spi_adf4355_clk_or_csn_1),
    .spi_adf4355_le_or_clk (spi_adf4355_le_or_clk),
    .spi_adf4355_ce_or_sdio (spi_adf4355_ce_or_sdio));

  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_iobuf (
    .dio_t (gpio_t[33:32]),
    .dio_i (gpio_o[33:32]),
    .dio_o (gpio_i[33:32]),
    .dio_p ({adc_irq, adc_fd}));

  ad_iobuf #(
    .DATA_WIDTH(21)
  ) i_iobuf_bd (
    .dio_t (gpio_t[20:0]),
    .dio_i (gpio_o[20:0]),
    .dio_o (gpio_i[20:0]),
    .dio_p (gpio_bd));

  assign gpio_i[63:34] = gpio_o[63:34];
  assign gpio_i[31:21] = gpio_o[31:21];

  ad_sysref_gen i_sysref (
    .core_clk (rx_clk),
    .sysref_en (gpio_o[34]),
    .sysref_out (rx_sysref));

  system_wrapper i_system_wrapper (
    .ddr3_addr (ddr3_addr),
    .ddr3_ba (ddr3_ba),
    .ddr3_cas_n (ddr3_cas_n),
    .ddr3_ck_n (ddr3_ck_n),
    .ddr3_ck_p (ddr3_ck_p),
    .ddr3_cke (ddr3_cke),
    .ddr3_cs_n (ddr3_cs_n),
    .ddr3_dm (ddr3_dm),
    .ddr3_dq (ddr3_dq),
    .ddr3_dqs_n (ddr3_dqs_n),
    .ddr3_dqs_p (ddr3_dqs_p),
    .ddr3_odt (ddr3_odt),
    .ddr3_ras_n (ddr3_ras_n),
    .ddr3_reset_n (ddr3_reset_n),
    .ddr3_we_n (ddr3_we_n),
    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    .gpio_lcd_tri_io (gpio_lcd),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .linear_flash_addr (linear_flash_addr),
    .linear_flash_adv_ldn (linear_flash_adv_ldn),
    .linear_flash_ce_n (linear_flash_ce_n),
    .linear_flash_dq_io (linear_flash_dq_io),
    .linear_flash_oen (linear_flash_oen),
    .linear_flash_wen (linear_flash_wen),
    .mdio_mdc (mdio_mdc),
    .mdio_mdio_io (mdio_mdio),
    .mgt_clk_clk_n (mgt_clk_n),
    .mgt_clk_clk_p (mgt_clk_p),
    .phy_rstn (phy_rstn),
    .phy_sd (1'b1),
    .rx_data_0_n (rx_data_n_loc[0]),
    .rx_data_0_p (rx_data_p_loc[0]),
    .rx_data_1_n (rx_data_n_loc[1]),
    .rx_data_1_p (rx_data_p_loc[1]),
    .rx_data_2_n (rx_data_n_loc[2]),
    .rx_data_2_p (rx_data_p_loc[2]),
    .rx_data_3_n (rx_data_n_loc[3]),
    .rx_data_3_p (rx_data_p_loc[3]),
    .rx_data_4_n (rx_data_n_loc[4]),
    .rx_data_4_p (rx_data_p_loc[4]),
    .rx_data_5_n (rx_data_n_loc[5]),
    .rx_data_5_p (rx_data_p_loc[5]),
    .rx_data_6_n (rx_data_n_loc[6]),
    .rx_data_6_p (rx_data_p_loc[6]),
    .rx_data_7_n (rx_data_n_loc[7]),
    .rx_data_7_p (rx_data_p_loc[7]),
    .rx_ref_clk_0 (rx_ref_clk),
    .rx_sync_0 (rx_sync),
    .rx_sysref_0 (rx_sysref),
    .rx_core_clk (rx_clk),
    .sgmii_rxn (sgmii_rxn),
    .sgmii_rxp (sgmii_rxp),
    .sgmii_txn (sgmii_txn),
    .sgmii_txp (sgmii_txp),
    .spi_clk_i (spi_clk),
    .spi_clk_o (spi_clk),
    .spi_csn_i (spi_csn),
    .spi_csn_o (spi_csn),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (spi_mosi),
    .spi_sdo_o (spi_mosi),
    .sys_clk_n (sys_clk_n),
    .sys_clk_p (sys_clk_p),
    .sys_rst (sys_rst),
    .uart_sin (uart_sin),
    .uart_sout (uart_sout));

  assign rx_data_p_loc[RX_JESD_L-1:0] = rx_data_p[RX_JESD_L-1:0];
  assign rx_data_n_loc[RX_JESD_L-1:0] = rx_data_n[RX_JESD_L-1:0];

endmodule
