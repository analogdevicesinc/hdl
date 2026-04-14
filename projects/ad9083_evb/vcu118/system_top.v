// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

  input           sys_rst,
  input           sys_clk_p,
  input           sys_clk_n,

  input           uart_sin,
  output          uart_sout,

  output          ddr4_act_n,
  output  [16:0]  ddr4_addr,
  output  [ 1:0]  ddr4_ba,
  output          ddr4_bg,
  output          ddr4_ck_p,
  output          ddr4_ck_n,
  output          ddr4_cke,
  output          ddr4_cs_n,
  inout   [ 7:0]  ddr4_dm_n,
  inout   [63:0]  ddr4_dq,
  inout   [ 7:0]  ddr4_dqs_p,
  inout   [ 7:0]  ddr4_dqs_n,
  output          ddr4_odt,
  output          ddr4_reset_n,

  output          mdio_mdc,
  inout           mdio_mdio,
  input           phy_clk_p,
  input           phy_clk_n,
  output          phy_rst_n,
  input           phy_rx_p,
  input           phy_rx_n,
  output          phy_tx_p,
  output          phy_tx_n,

  inout   [16:0]  gpio_bd,

  output          iic_rstn,
  inout           iic_scl,
  inout           iic_sda,

  input           ref_clk0_p,
  input           ref_clk0_n,

  input           glblclk_p,
  input           glblclk_n,

  input   [ 3:0]  rx_data_p,
  input   [ 3:0]  rx_data_n,
  output          rx_sync_p,
  output          rx_sync_n,

  input           sysref_p,
  input           sysref_n,

  inout           pwdn,
  inout           rstb,
  inout           refsel,

  inout           spi_sdio,
  output          spi_csn_clk,
  output          spi_csn_adc,
  output          spi_clk

);

  // internal signals
  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;

  wire    [ 7:0]  spi0_csn;
  wire            spi0_mosi;
  wire            spi0_miso;

  wire            core_clk_in;
  wire            core_clk;
  wire            ref_clk;
  wire            sync;
  wire            sysref;

  assign gpio_i[63:35] = gpio_o[63:35];
  assign gpio_i[31:18] = gpio_o[31:18];
  assign iic_rstn = 1'b1;

  assign spi_csn_adc = spi0_csn[0];
  assign spi_csn_clk = spi0_csn[1];

  // instantiations
  ad_iobuf #(
    .DATA_WIDTH (17)
  ) i_iobuf_bd (
    .dio_t (gpio_t[16:0]),
    .dio_i (gpio_o[16:0]),
    .dio_o (gpio_i[16:0]),
    .dio_p (gpio_bd));

  IBUFDS i_core_clk_ibufds_1 (
    .O(core_clk_in),
    .I(glblclk_p),
    .IB(glblclk_n));

  BUFG i_core_clk_bufg(
    .O(core_clk),
    .I(core_clk_in));

  IBUFDS_GTE4 i_ibufds_ref_clk0 (
    .CEB (1'd0),
    .I (ref_clk0_p),
    .IB (ref_clk0_n),
    .O (ref_clk),
    .ODIV2 ());

  ad_3w_spi #(
    .NUM_OF_SLAVES(2)
  ) i_spi (
    .spi_csn(spi0_csn[1:0]),
    .spi_clk(spi_clk),
    .spi_mosi(spi0_mosi),
    .spi_miso(spi0_miso),
    .spi_sdio(spi_sdio),
    .spi_dir());

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

  OBUFDS i_obufds_rx_sync (
    .I (sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  system_wrapper i_system_wrapper (
    .sys_rst (sys_rst),
    .sys_clk_clk_n (sys_clk_n),
    .sys_clk_clk_p (sys_clk_p),

    .ddr4_act_n (ddr4_act_n),
    .ddr4_adr (ddr4_addr),
    .ddr4_ba (ddr4_ba),
    .ddr4_bg (ddr4_bg),
    .ddr4_ck_c (ddr4_ck_n),
    .ddr4_ck_t (ddr4_ck_p),
    .ddr4_cke (ddr4_cke),
    .ddr4_cs_n (ddr4_cs_n),
    .ddr4_dm_n (ddr4_dm_n),
    .ddr4_dq (ddr4_dq),
    .ddr4_dqs_c (ddr4_dqs_n),
    .ddr4_dqs_t (ddr4_dqs_p),
    .ddr4_odt (ddr4_odt),
    .ddr4_reset_n (ddr4_reset_n),

    .phy_sd (1'b1),
    .phy_rst_n (phy_rst_n),
    .sgmii_rxn (phy_rx_n),
    .sgmii_rxp (phy_rx_p),
    .sgmii_txn (phy_tx_n),
    .sgmii_txp (phy_tx_p),
    .mdio_mdc (mdio_mdc),
    .mdio_mdio_io (mdio_mdio),
    .sgmii_phyclk_clk_n (phy_clk_n),
    .sgmii_phyclk_clk_p (phy_clk_p),

    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),

    .uart_sin (uart_sin),
    .uart_sout (uart_sout),

    .rx_data_0_n (rx_data_n[0]),
    .rx_data_0_p (rx_data_p[0]),
    .rx_data_1_n (rx_data_n[1]),
    .rx_data_1_p (rx_data_p[1]),
    .rx_data_2_n (rx_data_n[2]),
    .rx_data_2_p (rx_data_p[2]),
    .rx_data_3_n (rx_data_n[3]),
    .rx_data_3_p (rx_data_p[3]),
    .rx_ref_clk_0 (ref_clk),
    .rx_core_clk_0 (core_clk),
    .rx_sync_0 (sync),
    .rx_sysref_0 (sysref),

    .spi_clk_i (spi_clk),
    .spi_clk_o (spi_clk),
    .spi_csn_i (spi0_csn),
    .spi_csn_o (spi0_csn),
    .spi_sdi_i (spi0_miso),
    .spi_sdo_i (spi0_mosi),
    .spi_sdo_o (spi0_mosi),

    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]));

endmodule
