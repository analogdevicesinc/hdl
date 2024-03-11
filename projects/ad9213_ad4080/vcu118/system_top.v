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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

`define ECHOED_CLK

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

  // FMC+ IOs

  input                   rx_ref_clk_p,
  input                   rx_ref_clk_n,
  input                   rx_ref_clk_replica_p,
  input                   rx_ref_clk_replica_n,
  input       [15:0]      rx_data_p,
  input       [15:0]      rx_data_n,

  input                   glbl_clk_0_p,
  input                   glbl_clk_0_n,

  input                   rx_sysref_p,
  input                   rx_sysref_n,
  output                  rx_sync_p,
  output                  rx_sync_n,

  output                  fpga_sclk,
  inout                   fpga_sdio,
  output                  fpga_csb,

  output                  adf4371_csb,

  output                  hmc7044_sclk,
  inout                   hmc7044_sdio,
  output                  hmc7044_csb,

  inout       [ 4:0]      gpio,

  output                  rstb,
  output                  hmc_sync_req,

  // FMC connector
  // LVDS data interace
  input                   dco_p,
  input                   dco_n,
  input                   da_p,
  input                   da_n,
  input                   db_p,
  input                   db_n,
  input                   cnv_in_p,
  input                   cnv_in_n,

  // SPI data interface

  output                  gpio0_fmc,
  inout                   gpio1_fmc,
  inout                   gpio2_fmc,
  inout                   gpio3_fmc,
  inout                   adrf5203_ctrl_0,
  inout                   adrf5203_ctrl_1,
  inout                   adrf5203_ctrl_2,
  inout                   adg5419_ctrl,
  inout                   ada4945_disable,
  inout                   adl5580_en,
  inout                   dig_ext_p,
  inout                   dig_ext_n,
  inout                   ltc2644_ldac,
  inout                   ltc2644_clr,
  inout                   ltc2644_tgp,
  inout                   dig_ext_hs_p,
  inout                   dig_ext_hs_n,

  // ADC SPI

  output                  sclk_src,
  output                  cs_n_src,
  input                   sdi_src,

  output                  adl5580_sclk,
  output                  adl5580_csb,
  inout                   adl5580_sdio,

  output                  ltc2644_sclk,
  output                  ltc2644_cs,
  input                   ltc2644_sdi,
  output                  ltc2644_sdo
  );

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;

  wire            spi_miso;
  wire            spi_mosi;
  wire            hmc7044_miso;
  wire            hmc7044_mosi;
  wire    [ 1:0]  hmc7044_csn;
  wire            adl5580_miso;
  wire            adl5580_mosi;

  wire            rx_ref_clk;
  wire            rx_ref_clk_replica;
  wire            rx_sysref;
  wire            rx_sync;

  assign hmc7044_csb = hmc7044_csn[0];
  assign adf4371_csb = hmc7044_csn[1];

  // instantiations

  IBUFDS_GTE4 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (rx_ref_clk_p),
    .IB (rx_ref_clk_n),
    .O (rx_ref_clk),
    .ODIV2 ());

  IBUFDS_GTE4 i_ibufds_rx_ref_clk_replica (
    .CEB (1'd0),
    .I (rx_ref_clk_replica_p),
    .IB (rx_ref_clk_replica_n),
    .O (rx_ref_clk_replica),
    .ODIV2 ());

  IBUFDS i_ibufds_rx_sysref (
    .I (rx_sysref_p),
    .IB (rx_sysref_n),
    .O (rx_sysref));

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  IBUFDS_GTE4 i_ibufds_glbl_clk_0 (
    .I (glbl_clk_0_p),
    .IB (glbl_clk_0_n),
    .ODIV2 (glbl_clk_0));

  BUFG_GT i_bufg_glbl_clk_0(
    .I (glbl_clk_0),
    .O (glbl_clk_buf));

  ad_iobuf #(
    .DATA_WIDTH(5)
  ) i_iobuf (
    .dio_t (gpio_t[36:32]),
    .dio_i (gpio_o[36:32]),
    .dio_o (gpio_i[36:32]),
    .dio_p ({gpio[4:0]}));     // 36-32

  assign hmc_sync_req = gpio_o[37];
  assign rstb         = gpio_o[38];

  ad_iobuf #(
    .DATA_WIDTH(17)
  ) i_iobuf_bd (
    .dio_t (gpio_t[16:0]),
    .dio_i (gpio_o[16:0]),
    .dio_o (gpio_i[16:0]),
    .dio_p (gpio_bd));

  assign gpio_i[63:55] = gpio_o[63:55];
  assign gpio_i[31:17] = gpio_o[31:17];

  ad_3w_spi #(
    .NUM_OF_SLAVES(2)
  ) i_hmc7044_spi (
    .spi_csn (hmc7044_csn[1:0]),
    .spi_clk (hmc7044_sclk),
    .spi_mosi (hmc7044_mosi),
    .spi_miso (hmc7044_miso),
    .spi_sdio (hmc7044_sdio),
    .spi_dir ());

  ad_3w_spi #(
    .NUM_OF_SLAVES(1)
  ) i_ad9213_spi (
    .spi_csn (fpga_csb),
    .spi_clk (fpga_sclk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (fpga_sdio),
    .spi_dir ());

  ad_3w_spi #(
    .NUM_OF_SLAVES(1)
  ) i_adl5580_spi (
    .spi_csn (adl5580_csb),
    .spi_clk (adl5580_sclk),
    .spi_mosi (adl5580_mosi),
    .spi_miso (adl5580_miso),
    .spi_sdio (adl5580_sdio),
    .spi_dir ());

  // instantiations

  ad_iobuf #(
    .DATA_WIDTH(1)
  ) i_gpio_1_mach1 (
    .dio_t(1'b1),
    .dio_i(1'b0),
    .dio_o(filter_data_ready_n),
    .dio_p(gpio1_fmc));

  ad_iobuf #(
    .DATA_WIDTH(15)
  ) i_gpio (
    .dio_t(gpio_t[53:39]),
    .dio_i(gpio_o[53:39]),
    .dio_o(gpio_i[53:39]),
    .dio_p({adrf5203_ctrl_0,
            adrf5203_ctrl_1,
            adrf5203_ctrl_2,
            adg5419_ctrl,
            ada4945_disable,
            adl5580_en,
            gpio3_fmc,
            gpio2_fmc,
            dig_ext_p,
            dig_ext_n,
            ltc2644_ldac,
            ltc2644_clr,
            ltc2644_tgp,
            dig_ext_hs_p,
            dig_ext_hs_n}));

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
    .spi_clk_i (fpga_sclk),
    .spi_clk_o (fpga_sclk),
    .spi_csn_i (fpga_csb),
    .spi_csn_o (fpga_csb),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (spi_mosi),
    .spi_sdo_o (spi_mosi),
    .hmc7044_clk_i (hmc7044_sclk),
    .hmc7044_clk_o (hmc7044_sclk),
    .hmc7044_csn_i (hmc7044_csn),
    .hmc7044_csn_o (hmc7044_csn),
    .hmc7044_sdi_i (hmc7044_miso),
    .hmc7044_sdo_i (hmc7044_mosi),
    .hmc7044_sdo_o (hmc7044_mosi),
    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    // FMC+
    .rx_data_0_n  (rx_data_n[1]),
    .rx_data_0_p  (rx_data_p[1]),
    .rx_data_1_n  (rx_data_n[3]),
    .rx_data_1_p  (rx_data_p[3]),
    .rx_data_2_n  (rx_data_n[2]),
    .rx_data_2_p  (rx_data_p[2]),
    .rx_data_3_n  (rx_data_n[4]),
    .rx_data_3_p  (rx_data_p[4]),
    .rx_data_4_n  (rx_data_n[0]),
    .rx_data_4_p  (rx_data_p[0]),
    .rx_data_5_n  (rx_data_n[15]),
    .rx_data_5_p  (rx_data_p[15]),
    .rx_data_6_n  (rx_data_n[8]),
    .rx_data_6_p  (rx_data_p[8]),
    .rx_data_7_n  (rx_data_n[7]),
    .rx_data_7_p  (rx_data_p[7]),
    .rx_data_8_n  (rx_data_n[5]),
    .rx_data_8_p  (rx_data_p[5]),
    .rx_data_9_n  (rx_data_n[6]),
    .rx_data_9_p  (rx_data_p[6]),
    .rx_data_10_n (rx_data_n[10]),
    .rx_data_10_p (rx_data_p[10]),
    .rx_data_11_n (rx_data_n[9]),
    .rx_data_11_p (rx_data_p[9]),
    .rx_data_12_n (rx_data_n[12]),
    .rx_data_12_p (rx_data_p[12]),
    .rx_data_13_n (rx_data_n[14]),
    .rx_data_13_p (rx_data_p[14]),
    .rx_data_14_n (rx_data_n[13]),
    .rx_data_14_p (rx_data_p[13]),
    .rx_data_15_n (rx_data_n[11]),
    .rx_data_15_p (rx_data_p[11]),

    .rx_ref_clk_0 (rx_ref_clk),
    .rx_ref_clk_1 (rx_ref_clk_replica),
    .glbl_clk_0 (glbl_clk_buf),
    .rx_sync_0 (rx_sync),
    .rx_sysref_0 (rx_sysref),

    .ad4080_clk_i (sclk_src),
    .ad4080_clk_o (sclk_src),
    .ad4080_csn_i (cs_n_src),
    .ad4080_csn_o (cs_n_src),
    .ad4080_sdi_i (sdi_src),

    .ad4080_sdo_o (gpio0_fmc),

    .adl5580_clk_i (adl5580_sclk),
    .adl5580_clk_o (adl5580_sclk),
    .adl5580_csn_i (adl5580_csb),
    .adl5580_csn_o (adl5580_csb),
    .adl5580_sdi_i (adl5580_miso),
    .adl5580_sdo_i (adl5580_mosi),
    .adl5580_sdo_o (adl5580_mosi),

    .ltc2644_clk_i (ltc2644_sclk),
    .ltc2644_clk_o (ltc2644_sclk),
    .ltc2644_csn_i (ltc2644_cs),
    .ltc2644_csn_o (ltc2644_cs),
    .ltc2644_sdi_i (ltc2644_sdi),

    .ltc2644_sdo_o (ltc2644_sdo),

    // FMC
    .dco_p (dco_p),
    .dco_n (dco_n),
    .da_p (da_p),
    .da_n (da_n),
    .db_p (db_p),
    .db_n (db_n),
    .cnv_in_p(cnv_in_p),
    .cnv_in_n(cnv_in_n),
    .filter_data_ready_n(filter_data_ready_n));

endmodule
