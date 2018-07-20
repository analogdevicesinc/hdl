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

  input             sys_rst,
  input             sys_clk_p,
  input             sys_clk_n,

  input             uart_sin,
  output            uart_sout,

  output  [ 13:0]   ddr3_addr,
  output  [  2:0]   ddr3_ba,
  output            ddr3_cas_n,
  output  [  0:0]   ddr3_ck_n,
  output  [  0:0]   ddr3_ck_p,
  output  [  0:0]   ddr3_cke,
  output  [  0:0]   ddr3_cs_n,
  output  [  7:0]   ddr3_dm,
  inout   [ 63:0]   ddr3_dq,
  inout   [  7:0]   ddr3_dqs_n,
  inout   [  7:0]   ddr3_dqs_p,
  output  [  0:0]   ddr3_odt,
  output            ddr3_ras_n,
  output            ddr3_reset_n,
  output            ddr3_we_n,

  input             sgmii_rxp,
  input             sgmii_rxn,
  output            sgmii_txp,
  output            sgmii_txn,

  output            phy_rstn,
  input             mgt_clk_p,
  input             mgt_clk_n,
  output            mdio_mdc,
  inout             mdio_mdio,

  output            fan_pwm,

  output  [26:1]    linear_flash_addr,
  output            linear_flash_adv_ldn,
  output            linear_flash_ce_n,
  output            linear_flash_oen,
  output            linear_flash_wen,
  inout   [15:0]    linear_flash_dq_io,

  inout   [  6:0]   gpio_lcd,
  inout   [ 20:0]   gpio_bd,

  output            iic_rstn,
  inout             iic_scl,
  inout             iic_sda,

  input             rx_ref_clk_0_p,
  input             rx_ref_clk_0_n,
  input   [  7:0]   rx_data_0_p,
  input   [  7:0]   rx_data_0_n,
  input             rx_ref_clk_1_p,
  input             rx_ref_clk_1_n,
  input   [  7:0]   rx_data_1_p,
  input   [  7:0]   rx_data_1_n,
  output            rx_sysref_p,
  output            rx_sysref_n,
  output            rx_sync_0_p,
  output            rx_sync_0_n,
  output            rx_sync_1_p,
  output            rx_sync_1_n,

  output            spi_csn_0,
  output            spi_csn_1,
  output            spi_clk,
  inout             spi_sdio,
  output            spi_dirn,
  output            dac_clk,
  output            dac_data,
  output            dac_sync_0,
  output            dac_sync_1,

  output            psync_0,
  output            psync_1,
  input             trig_p,
  input             trig_n,
  output            vdither_p,
  output            vdither_n,
  inout             pwr_good,
  inout             fd_1,
  inout             irq_1,
  inout             fd_0,
  inout             irq_0,
  inout             pwdn_1,
  inout             rst_1,
  output            drst_1,
  output            arst_1,
  inout             pwdn_0,
  inout             rst_0,
  output            drst_0,
  output            arst_0);

  // internal signals

  wire    [ 63:0]   gpio_i;
  wire    [ 63:0]   gpio_o;
  wire    [ 63:0]   gpio_t;
  wire    [  7:0]   spi_csn;
  wire              spi_mosi;
  wire              spi_miso;
  wire              rx_ref_clk_0;
  wire              rx_ref_clk_1;
  wire              psync;
  wire              vcal;

  // spi & misc

  assign iic_rstn = 1'b1;
  assign fan_pwm = 1'b1;
  assign dac_clk = spi_clk;
  assign dac_data = spi_mosi;
  assign dac_sync_1 = spi_csn[3];
  assign dac_sync_0 = spi_csn[2];
  assign spi_csn_1 = spi_csn[1];
  assign spi_csn_0 = spi_csn[0];
  assign drst_1 = 1'b0;
  assign arst_1 = 1'b0;
  assign drst_0 = 1'b0;
  assign arst_0 = 1'b0;
  assign psync_0 = psync;
  assign psync_1 = psync;

  assign gpio_i[63:47]= gpio_o[63:47];
  assign gpio_i[45:45]= gpio_o[45:45];
  assign gpio_i[37:36]= gpio_o[37:36];
  assign gpio_i[33:21]= gpio_o[33:21];

  // lvds buffers

  IBUFDS_GTE2 i_ibufds_rx_ref_clk_0 (
    .CEB (1'd0),
    .I (rx_ref_clk_0_p),
    .IB (rx_ref_clk_0_n),
    .O (rx_ref_clk_0),
    .ODIV2 ());

  IBUFDS_GTE2 i_ibufds_rx_ref_clk_1 (
    .CEB (1'd0),
    .I (rx_ref_clk_1_p),
    .IB (rx_ref_clk_1_n),
    .O (rx_ref_clk_1),
    .ODIV2 ());

  IBUFDS i_ibufds_trig (
    .I (trig_p),
    .IB (trig_n),
    .O (gpio_i[46]));

  OBUFDS i_obufds_vdither (
    .I (vcal),
    .O (vdither_p),
    .OB (vdither_n));

  // spi

  fmcadc5_spi i_fmcadc5_spi (
    .spi_csn_0 (spi_csn[0]),
    .spi_csn_1 (spi_csn[1]),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio),
    .spi_dirn (spi_dirn));

  // fmcadc5 board controls

  ad_iobuf #(.DATA_WIDTH(5)) i_iobuf_fmcadc5 (
    .dio_t (gpio_t[44:40]),
    .dio_i (gpio_o[44:40]),
    .dio_o (gpio_i[44:40]),
    .dio_p ({pwr_good, fd_1, irq_1, fd_0, irq_0}));

  ad_iobuf #(.DATA_WIDTH(2)) i_iobuf_ad9625_1 (
    .dio_t (gpio_t[39:38]),
    .dio_i (gpio_o[39:38]),
    .dio_o (gpio_i[39:38]),
    .dio_p ({pwdn_1, rst_1}));

  ad_iobuf #(.DATA_WIDTH(2)) i_iobuf_ad9625_0 (
    .dio_t (gpio_t[35:34]),
    .dio_i (gpio_o[35:34]),
    .dio_o (gpio_i[35:34]),
    .dio_p ({pwdn_0, rst_0}));

  // vc707 board controls

  ad_iobuf #(.DATA_WIDTH(21)) i_iobuf_bd (
    .dio_t (gpio_t[20:0]),
    .dio_i (gpio_o[20:0]),
    .dio_o (gpio_i[20:0]),
    .dio_p (gpio_bd));

  // ipi design

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
    .linear_flash_dq_io(linear_flash_dq_io),
    .linear_flash_oen (linear_flash_oen),
    .linear_flash_wen (linear_flash_wen),
    .mdio_mdc (mdio_mdc),
    .mdio_mdio_io (mdio_mdio),
    .mgt_clk_clk_n (mgt_clk_n),
    .mgt_clk_clk_p (mgt_clk_p),
    .phy_rstn (phy_rstn),
    .phy_sd (1'b1),
    .psync (psync),
    .rx_data_0_n (rx_data_0_n[0]),
    .rx_data_0_p (rx_data_0_p[0]),
    .rx_data_1_0_n (rx_data_1_n[0]),
    .rx_data_1_0_p (rx_data_1_p[0]),
    .rx_data_1_1_n (rx_data_1_n[1]),
    .rx_data_1_1_p (rx_data_1_p[1]),
    .rx_data_1_2_n (rx_data_1_n[2]),
    .rx_data_1_2_p (rx_data_1_p[2]),
    .rx_data_1_3_n (rx_data_1_n[3]),
    .rx_data_1_3_p (rx_data_1_p[3]),
    .rx_data_1_4_n (rx_data_1_n[4]),
    .rx_data_1_4_p (rx_data_1_p[4]),
    .rx_data_1_5_n (rx_data_1_n[5]),
    .rx_data_1_5_p (rx_data_1_p[5]),
    .rx_data_1_6_n (rx_data_1_n[6]),
    .rx_data_1_6_p (rx_data_1_p[6]),
    .rx_data_1_7_n (rx_data_1_n[7]),
    .rx_data_1_7_p (rx_data_1_p[7]),
    .rx_data_1_n (rx_data_0_n[1]),
    .rx_data_1_p (rx_data_0_p[1]),
    .rx_data_2_n (rx_data_0_n[2]),
    .rx_data_2_p (rx_data_0_p[2]),
    .rx_data_3_n (rx_data_0_n[3]),
    .rx_data_3_p (rx_data_0_p[3]),
    .rx_data_4_n (rx_data_0_n[4]),
    .rx_data_4_p (rx_data_0_p[4]),
    .rx_data_5_n (rx_data_0_n[5]),
    .rx_data_5_p (rx_data_0_p[5]),
    .rx_data_6_n (rx_data_0_n[6]),
    .rx_data_6_p (rx_data_0_p[6]),
    .rx_data_7_n (rx_data_0_n[7]),
    .rx_data_7_p (rx_data_0_p[7]),
    .rx_ref_clk_0 (rx_ref_clk_0),
    .rx_ref_clk_1 (rx_ref_clk_1),
    .rx_sync_0_n (rx_sync_0_n),
    .rx_sync_0_p (rx_sync_0_p),
    .rx_sync_1_n (rx_sync_1_n),
    .rx_sync_1_p (rx_sync_1_p),
    .rx_sysref_n (rx_sysref_n),
    .rx_sysref_p (rx_sysref_p),
    .sgmii_rxn (sgmii_rxn),
    .sgmii_rxp (sgmii_rxp),
    .sgmii_txn (sgmii_txn),
    .sgmii_txp (sgmii_txp),
    .spi_clk (spi_clk),
    .spi_csn (spi_csn),
    .spi_miso (spi_miso),
    .spi_mosi (spi_mosi),
    .sys_clk_n (sys_clk_n),
    .sys_clk_p (sys_clk_p),
    .sys_rst (sys_rst),
    .uart_sin (uart_sin),
    .uart_sout (uart_sout),
    .vcal (vcal));

endmodule

// ***************************************************************************
// ***************************************************************************
