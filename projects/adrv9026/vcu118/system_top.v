// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
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

  input                   sys_rst,
  input                   sys_clk_p,
  input                   sys_clk_n,

  input                   uart_sin,
  output                  uart_sout,

  output                  ddr4_act_n,
  output      [16:0]      ddr4_addr,
  output      [ 1:0]      ddr4_ba,
  output                  ddr4_bg,
  output                  ddr4_ck_p,
  output                  ddr4_ck_n,
  output                  ddr4_cke,
  output                  ddr4_cs_n,
  inout       [ 7:0]      ddr4_dm_n,
  inout       [63:0]      ddr4_dq,
  inout       [ 7:0]      ddr4_dqs_p,
  inout       [ 7:0]      ddr4_dqs_n,
  output                  ddr4_odt,
  output                  ddr4_reset_n,

  output                  mdio_mdc,
  inout                   mdio_mdio,
  input                   phy_clk_p,
  input                   phy_clk_n,
  output                  phy_rst_n,
  input                   phy_rx_p,
  input                   phy_rx_n,
  output                  phy_tx_p,
  output                  phy_tx_n,

  inout       [16:0]      gpio_bd,

  output                  iic_rstn,
  inout                   iic_scl,
  inout                   iic_sda,

  input                   ref_clk_p,
  input                   ref_clk_n,
  input                   core_clk_p,
  input                   core_clk_n,
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
  input                   tx_sync_1_p,
  input                   tx_sync_1_n,
  input                   sysref_p,
  input                   sysref_n,

  output                  spi_csn_ad9528,
  output                  spi_csn_adrv9026,
  output                  spi_clk,
  output                  spi_mosi,
  input                   spi_miso,

  inout                   ad9528_reset_b,
  inout                   ad9528_sysref_req,
  inout                   adrv9026_tx1_enable,
  inout                   adrv9026_tx2_enable,
  inout                   adrv9026_tx3_enable,
  inout                   adrv9026_tx4_enable,
  inout                   adrv9026_rx1_enable,
  inout                   adrv9026_rx2_enable,
  inout                   adrv9026_rx3_enable,
  inout                   adrv9026_rx4_enable,
  inout                   adrv9026_test,
  inout                   adrv9026_reset_b,
  inout                   adrv9026_gpint1,
  inout                   adrv9026_gpint2,
  inout                   adrv9026_orx_ctrl_a,
  inout                   adrv9026_orx_ctrl_b,
  inout                   adrv9026_orx_ctrl_c,
  inout                   adrv9026_orx_ctrl_d,

  inout                   adrv9026_gpio_00,
  inout                   adrv9026_gpio_01,
  inout                   adrv9026_gpio_02,
  inout                   adrv9026_gpio_03,
  inout                   adrv9026_gpio_04,
  inout                   adrv9026_gpio_05,
  inout                   adrv9026_gpio_06,
  inout                   adrv9026_gpio_07,
  inout                   adrv9026_gpio_08,
  inout                   adrv9026_gpio_09,
  inout                   adrv9026_gpio_10,
  inout                   adrv9026_gpio_11,
  inout                   adrv9026_gpio_12,
  inout                   adrv9026_gpio_13,
  inout                   adrv9026_gpio_14,
  inout                   adrv9026_gpio_15,
  inout                   adrv9026_gpio_16,
  inout                   adrv9026_gpio_17,
  inout                   adrv9026_gpio_18
);

  // internal signals

  wire        [63:0]      gpio_i;
  wire        [63:0]      gpio_o;
  wire        [63:0]      gpio_t;
  wire        [ 1:0]      spi_csn;
  wire                    ref_clk;
  wire                    rx_sync;
  wire                    rx_os_sync;
  wire                    tx_sync;
  wire                    tx_sync_1;
  wire                    sysref;

  assign iic_rstn = 1'b1;

  // instantiations
  ad_iobuf #(
    .DATA_WIDTH (17)
  ) i_iobuf_bd (
    .dio_t (gpio_t[16:0]),
    .dio_i (gpio_o[16:0]),
    .dio_o (gpio_i[16:0]),
    .dio_p (gpio_bd));

  assign gpio_i[25:17] = gpio_o[25:17];

  // instantiations

  IBUFDS_GTE4 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (ref_clk_p),
    .IB (ref_clk_n),
    .O (ref_clk),
    .ODIV2 ());

  IBUFDS i_core_clk_ibufds_1 (
    .I (core_clk_p),
    .IB (core_clk_n),
    .O (core_clk_in));

  BUFG i_core_clk_bufg (
    .I (core_clk_in),
    .O (core_clk));

  OBUFDS i_obufds_rx_sync (
    .I (~rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  OBUFDS i_obufds_rx_os_sync (
    .I (~rx_os_sync),
    .O (rx_os_sync_p),
    .OB (rx_os_sync_n));

  IBUFDS i_ibufds_tx_sync (
    .I (tx_sync_p),
    .IB (tx_sync_n),
    .O (tx_sync));

  IBUFDS i_ibufds_tx_sync_1 (
    .I (tx_sync_1_p),
    .IB (tx_sync_1_n),
    .O (tx_sync_1));

  IBUFDS i_ibufds_sysref (
    .I (sysref_p),
    .IB (sysref_n),
    .O (sysref));

  ad_iobuf #(
    .DATA_WIDTH(37)
    ) i_iobuf (
    .dio_t ({gpio_t[62:26]}),
    .dio_i ({gpio_o[62:26]}),
    .dio_o ({gpio_i[62:26]}),
    .dio_p ({ ad9528_reset_b,       // 62
              ad9528_sysref_req,    // 61
              adrv9026_tx1_enable,  // 60
              adrv9026_tx2_enable,  // 59
              adrv9026_tx3_enable,  // 58
              adrv9026_tx4_enable,  // 57
              adrv9026_rx1_enable,  // 56
              adrv9026_rx2_enable,  // 55
              adrv9026_rx3_enable,  // 54
              adrv9026_rx4_enable,  // 53
              adrv9026_test,        // 52
              adrv9026_reset_b,     // 51
              adrv9026_gpint1,      // 50
              adrv9026_gpint2,      // 49
              adrv9026_orx_ctrl_a,  // 48
              adrv9026_orx_ctrl_b,  // 47
              adrv9026_orx_ctrl_c,  // 46
              adrv9026_orx_ctrl_d,  // 45
              adrv9026_gpio_00,     // 44
              adrv9026_gpio_01,     // 43
              adrv9026_gpio_02,     // 42
              adrv9026_gpio_03,     // 41
              adrv9026_gpio_04,     // 40
              adrv9026_gpio_05,     // 39
              adrv9026_gpio_06,     // 38
              adrv9026_gpio_07,     // 37
              adrv9026_gpio_08,     // 36
              adrv9026_gpio_09,     // 35
              adrv9026_gpio_10,     // 34
              adrv9026_gpio_11,     // 33
              adrv9026_gpio_12,     // 32
              adrv9026_gpio_13,     // 31
              adrv9026_gpio_14,     // 30
              adrv9026_gpio_15,     // 29
              adrv9026_gpio_16,     // 28
              adrv9026_gpio_17,     // 27
              adrv9026_gpio_18}));  // 26

  assign spi_csn_adrv9026 =  spi_csn[0];
  assign spi_csn_ad9528 =  spi_csn[1];

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

    .spi_clk_i (spi_clk),
    .spi_clk_o (spi_clk),
    .spi_csn_i (spi_csn),
    .spi_csn_o (spi_csn),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (spi_mosi),
    .spi_sdo_o (spi_mosi),

    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[62:32]),
    .gpio1_o (gpio_o[62:32]),
    .gpio1_t (gpio_t[62:32]),
    .core_clk (core_clk),
    .rx_data_0_n (rx_data_n[0]),
    .rx_data_0_p (rx_data_p[0]),
    .rx_data_1_n (rx_data_n[1]),
    .rx_data_1_p (rx_data_p[1]),
    .rx_data_2_n (rx_data_n[2]),
    .rx_data_2_p (rx_data_p[2]),
    .rx_data_3_n (rx_data_n[3]),
    .rx_data_3_p (rx_data_p[3]),
    .rx_ref_clk_0 (ref_clk),
    .rx_os_ref_clk_0 (ref_clk),
    .rx_sync_0 (rx_sync),
    .rx_os_sync (rx_os_sync),
    .rx_sysref_0 (sysref),
    .rx_os_sysref (sysref),
    .tx_data_0_n (tx_data_n[0]),
    .tx_data_0_p (tx_data_p[0]),
    .tx_data_1_n (tx_data_n[1]),
    .tx_data_1_p (tx_data_p[1]),
    .tx_data_2_n (tx_data_n[2]),
    .tx_data_2_p (tx_data_p[2]),
    .tx_data_3_n (tx_data_n[3]),
    .tx_data_3_p (tx_data_p[3]),
    .tx_ref_clk_0 (ref_clk),
    .tx_sync_0 (tx_sync),
    .tx_sysref_0 (sysref));

endmodule
