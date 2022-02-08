// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2019 (c) Analog Devices, Inc. All rights reserved.
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

  // clock and resets

  input             sys_clk,
  input             sys_resetn,

  // hps-ddr4 (32)

  input             hps_ddr_ref_clk,
  output  [  0:0]   hps_ddr_clk_p,
  output  [  0:0]   hps_ddr_clk_n,
  output  [ 16:0]   hps_ddr_a,
  output  [  1:0]   hps_ddr_ba,
  output  [  0:0]   hps_ddr_bg,
  output  [  0:0]   hps_ddr_cke,
  output  [  0:0]   hps_ddr_cs_n,
  output  [  0:0]   hps_ddr_odt,
  output  [  0:0]   hps_ddr_reset_n,
  output  [  0:0]   hps_ddr_act_n,
  output  [  0:0]   hps_ddr_par,
  input   [  0:0]   hps_ddr_alert_n,
  inout   [  3:0]   hps_ddr_dqs_p,
  inout   [  3:0]   hps_ddr_dqs_n,
  inout   [ 31:0]   hps_ddr_dq,
  inout   [  3:0]   hps_ddr_dbi_n,
  input             hps_ddr_rzq,


  // hps-ethernet

  input   [  0:0]   hps_eth_rxclk,
  input   [  0:0]   hps_eth_rxctl,
  input   [  3:0]   hps_eth_rxd,
  output  [  0:0]   hps_eth_txclk,
  output  [  0:0]   hps_eth_txctl,
  output  [  3:0]   hps_eth_txd,
  output  [  0:0]   hps_eth_mdc,
  inout   [  0:0]   hps_eth_mdio,

  // hps-sdio

  output  [  0:0]   hps_sdio_clk,
  inout   [  0:0]   hps_sdio_cmd,
  inout   [  7:0]   hps_sdio_d,

  // hps-usb

  input   [  0:0]   hps_usb_clk,
  input   [  0:0]   hps_usb_dir,
  input   [  0:0]   hps_usb_nxt,
  output  [  0:0]   hps_usb_stp,
  inout   [  7:0]   hps_usb_d,

  // hps-uart

  input   [  0:0]   hps_uart_rx,
  output  [  0:0]   hps_uart_tx,

  // hps-i2c (shared w fmc-a, fmc-b)

  inout   [  0:0]   hps_i2c_sda,
  inout   [  0:0]   hps_i2c_scl,

  // hps-gpio (max-v-u16)

  inout   [  3:0]   hps_gpio,

  // gpio (max-v-u21)

  input   [  7:0]   gpio_bd_i,
  output  [  3:0]   gpio_bd_o,

  // RGMII interfaces

  output          reset_a,
  output          mdc_fmc_a,
  inout           mdio_fmc_a,
  input   [3:0]   rgmii_rxd_a,
  input           rgmii_rx_ctl_a,
  input           rgmii_rxc_a,
  output  [3:0]   rgmii_txd_a,
  output          rgmii_tx_ctl_a,
  output          rgmii_txc_a,
  input           link_st_a,
  input           int_n_a,
  input           led_0_a,

  output          reset_b,
  output          mdc_fmc_b,
  inout           mdio_fmc_b,
  input   [3:0]   rgmii_rxd_b,
  input           rgmii_rx_ctl_b,
  input           rgmii_rxc_b,
  output  [3:0]   rgmii_txd_b,
  output          rgmii_tx_ctl_b,
  output          rgmii_txc_b,
  input           link_st_b,
  input           int_n_b,
  input           led_0_b,

  // LEDs

  output          led_ar_c_c2m,
  output          led_ar_a_c2m,
  output          led_al_c_c2m,
  output          led_al_a_c2m,

  output          led_br_c_c2m,
  output          led_br_a_c2m,
  output          led_bl_c_c2m,
  output          led_bl_a_c2m
);

  // internal signals

  wire              sys_ddr_cal_success;
  wire              sys_ddr_cal_fail;
  wire              sys_hps_resetn;
  wire              sys_resetn_s;
  wire    [ 63:0]   gpio_i;
  wire    [ 63:0]   gpio_o;

  wire              hps_emac_mdi_i_a;
  wire              hps_emac_mdo_o_a;
  wire              hps_emac_mdo_o_e_a;

  wire              hps_emac_mdi_i_b;
  wire              hps_emac_mdo_o_b;
  wire              hps_emac_mdo_o_e_b;

  wire              loopback_phy_tx_clk_i_0;
  wire              loopback_phy_tx_clk_o_0;
  wire              loopback_rst_tx_n_0;
  wire              loopback_rst_rx_n_0;
  wire    [  7:0]   loopback_phy_txd_0;
  wire              loopback_phy_txen_0;
  wire              loopback_phy_txer_0;
  wire    [  1:0]   loopback_phy_mac_speed_0;
  wire              loopback_phy_rx_clk_0;
  wire              loopback_phy_rxdv_0;
  wire              loopback_phy_rxer_0;
  wire    [  7:0]   loopback_phy_rxd_0;
  wire              loopback_phy_col_0;
  wire              loopback_phy_crs_0;

  wire              loopback_phy_tx_clk_i_1;
  wire              loopback_phy_tx_clk_o_1;
  wire              loopback_phy_rx_clk_1;
  wire              loopback_rst_tx_n_1;
  wire              loopback_rst_rx_n_1;
  wire    [  7:0]   loopback_phy_txd_1;
  wire              loopback_phy_txen_1;
  wire              loopback_phy_txer_1;
  wire    [  1:0]   loopback_phy_mac_speed_1;
  wire              loopback_phy_rxdv_1;
  wire              loopback_phy_rxer_1;
  wire    [  7:0]   loopback_phy_rxd_1;
  wire              loopback_phy_col_1;
  wire              loopback_phy_crs_1;

  // assignments

  // port a - right led (activity/status)

  assign led_ar_c_c2m = led_0_a;
  assign led_ar_a_c2m = 1'b0;

  // port a - left led (speed mode): 10M=off, 100M=yellow, 1G=green

  assign led_al_c_c2m = loopback_phy_mac_speed_0[0];
  assign led_al_a_c2m = loopback_phy_mac_speed_0[1];

  // port b - right led (activity/status)

  assign led_br_c_c2m = led_0_b;
  assign led_br_a_c2m = 1'b0;

  // port a - left led (speed mode): 10M=off, 100M=yellow, 1G=green

  assign led_bl_c_c2m = loopback_phy_mac_speed_1[1];
  assign led_bl_a_c2m = loopback_phy_mac_speed_1[0];

  assign gpio_i[63:36] = gpio_o[63:36];

  assign gpio_i[35] = link_st_a;
  assign gpio_i[34] = link_st_b;
  assign gpio_i[33] = int_n_a;
  assign gpio_i[32] = int_n_b;

  // board stuff (max-v-u21)

  assign gpio_i[31:12] = gpio_o[31:12];
  assign gpio_i[ 3: 0] = gpio_o[ 3: 0];

  assign gpio_i[11: 4] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[3:0];

  ALT_IOBUF md_iobuf_a (.i(hps_emac_mdo_o_a), .oe(hps_emac_mdo_o_e_a), .o(hps_emac_mdi_i_a), .io(mdio_fmc_a));
  ALT_IOBUF md_iobuf_b (.i(hps_emac_mdo_o_b), .oe(hps_emac_mdo_o_e_b), .o(hps_emac_mdi_i_b), .io(mdio_fmc_b));

  // peripheral reset

  assign sys_resetn_s = sys_resetn & sys_hps_resetn;
  assign reset_a = ~sys_resetn_s;
  assign reset_b = ~sys_resetn_s;

  // instantiations

  system_bd i_system_bd (
    .sys_clk_clk (sys_clk),
    .sys_gpio_bd_in_port (gpio_i[31:0]),
    .sys_gpio_bd_out_port (gpio_o[31:0]),
    .sys_gpio_in_export (gpio_i[63:32]),
    .sys_gpio_out_export (gpio_o[63:32]),
    .sys_hps_ddr_mem_ck (hps_ddr_clk_p),
    .pr_rom_data_nc_rom_data('h0),
    .sys_hps_ddr_mem_ck_n (hps_ddr_clk_n),
    .sys_hps_ddr_mem_a (hps_ddr_a),
    .sys_hps_ddr_mem_act_n (hps_ddr_act_n),
    .sys_hps_ddr_mem_ba (hps_ddr_ba),
    .sys_hps_ddr_mem_bg (hps_ddr_bg),
    .sys_hps_ddr_mem_cke (hps_ddr_cke),
    .sys_hps_ddr_mem_cs_n (hps_ddr_cs_n),
    .sys_hps_ddr_mem_odt (hps_ddr_odt),
    .sys_hps_ddr_mem_reset_n (hps_ddr_reset_n),
    .sys_hps_ddr_mem_par (hps_ddr_par),
    .sys_hps_ddr_mem_alert_n (hps_ddr_alert_n),
    .sys_hps_ddr_mem_dqs (hps_ddr_dqs_p),
    .sys_hps_ddr_mem_dqs_n (hps_ddr_dqs_n),
    .sys_hps_ddr_mem_dq (hps_ddr_dq),
    .sys_hps_ddr_mem_dbi_n (hps_ddr_dbi_n),
    .sys_hps_ddr_oct_oct_rzqin (hps_ddr_rzq),
    .sys_hps_ddr_ref_clk_clk (hps_ddr_ref_clk),
    .sys_hps_ddr_rstn_reset_n (sys_resetn),
    .sys_hps_io_hps_io_phery_emac0_TX_CLK (hps_eth_txclk),
    .sys_hps_io_hps_io_phery_emac0_TXD0 (hps_eth_txd[0]),
    .sys_hps_io_hps_io_phery_emac0_TXD1 (hps_eth_txd[1]),
    .sys_hps_io_hps_io_phery_emac0_TXD2 (hps_eth_txd[2]),
    .sys_hps_io_hps_io_phery_emac0_TXD3 (hps_eth_txd[3]),
    .sys_hps_io_hps_io_phery_emac0_RX_CTL (hps_eth_rxctl),
    .sys_hps_io_hps_io_phery_emac0_TX_CTL (hps_eth_txctl),
    .sys_hps_io_hps_io_phery_emac0_RX_CLK (hps_eth_rxclk),
    .sys_hps_io_hps_io_phery_emac0_RXD0 (hps_eth_rxd[0]),
    .sys_hps_io_hps_io_phery_emac0_RXD1 (hps_eth_rxd[1]),
    .sys_hps_io_hps_io_phery_emac0_RXD2 (hps_eth_rxd[2]),
    .sys_hps_io_hps_io_phery_emac0_RXD3 (hps_eth_rxd[3]),
    .sys_hps_io_hps_io_phery_emac0_MDIO (hps_eth_mdio),
    .sys_hps_io_hps_io_phery_emac0_MDC (hps_eth_mdc),
    .sys_hps_io_hps_io_phery_sdmmc_CMD (hps_sdio_cmd),
    .sys_hps_io_hps_io_phery_sdmmc_D0 (hps_sdio_d[0]),
    .sys_hps_io_hps_io_phery_sdmmc_D1 (hps_sdio_d[1]),
    .sys_hps_io_hps_io_phery_sdmmc_D2 (hps_sdio_d[2]),
    .sys_hps_io_hps_io_phery_sdmmc_D3 (hps_sdio_d[3]),
    .sys_hps_io_hps_io_phery_sdmmc_D4 (hps_sdio_d[4]),
    .sys_hps_io_hps_io_phery_sdmmc_D5 (hps_sdio_d[5]),
    .sys_hps_io_hps_io_phery_sdmmc_D6 (hps_sdio_d[6]),
    .sys_hps_io_hps_io_phery_sdmmc_D7 (hps_sdio_d[7]),
    .sys_hps_io_hps_io_phery_sdmmc_CCLK (hps_sdio_clk),
    .sys_hps_io_hps_io_phery_usb0_DATA0 (hps_usb_d[0]),
    .sys_hps_io_hps_io_phery_usb0_DATA1 (hps_usb_d[1]),
    .sys_hps_io_hps_io_phery_usb0_DATA2 (hps_usb_d[2]),
    .sys_hps_io_hps_io_phery_usb0_DATA3 (hps_usb_d[3]),
    .sys_hps_io_hps_io_phery_usb0_DATA4 (hps_usb_d[4]),
    .sys_hps_io_hps_io_phery_usb0_DATA5 (hps_usb_d[5]),
    .sys_hps_io_hps_io_phery_usb0_DATA6 (hps_usb_d[6]),
    .sys_hps_io_hps_io_phery_usb0_DATA7 (hps_usb_d[7]),
    .sys_hps_io_hps_io_phery_usb0_CLK (hps_usb_clk),
    .sys_hps_io_hps_io_phery_usb0_STP (hps_usb_stp),
    .sys_hps_io_hps_io_phery_usb0_DIR (hps_usb_dir),
    .sys_hps_io_hps_io_phery_usb0_NXT (hps_usb_nxt),
    .sys_hps_io_hps_io_phery_uart1_RX (hps_uart_rx),
    .sys_hps_io_hps_io_phery_uart1_TX (hps_uart_tx),
    .sys_hps_io_hps_io_phery_i2c1_SDA (hps_i2c_sda),
    .sys_hps_io_hps_io_phery_i2c1_SCL (hps_i2c_scl),
    .sys_hps_io_hps_io_gpio_gpio1_io5 (hps_gpio[0]),
    .sys_hps_io_hps_io_gpio_gpio1_io14 (hps_gpio[1]),
    .sys_hps_io_hps_io_gpio_gpio1_io16 (hps_gpio[2]),
    .sys_hps_io_hps_io_gpio_gpio1_io17 (hps_gpio[3]),
    .sys_hps_out_rstn_reset_n (sys_hps_resetn),
    .sys_hps_rstn_reset_n (sys_resetn),
    .sys_rstn_reset_n (sys_resetn_s),

    .sys_hps_emac1_md_clk_clk (mdc_fmc_a),
    .gmii_to_rgmii_adapter_0_phy_rgmii_rgmii_rx_clk (rgmii_rxc_a),
    .gmii_to_rgmii_adapter_0_phy_rgmii_rgmii_rxd (rgmii_rxd_a),
    .gmii_to_rgmii_adapter_0_phy_rgmii_rgmii_rx_ctl (rgmii_rx_ctl_a),
    .gmii_to_rgmii_adapter_0_phy_rgmii_rgmii_tx_clk (rgmii_txc_a),
    .gmii_to_rgmii_adapter_0_phy_rgmii_rgmii_txd (rgmii_txd_a),
    .gmii_to_rgmii_adapter_0_phy_rgmii_rgmii_tx_ctl (rgmii_tx_ctl_a),
    .hps_emac_interface_splitter_0_mdio_gmii_mdi_i (hps_emac_mdi_i_a),
    .hps_emac_interface_splitter_0_mdio_gmii_mdo_o (hps_emac_mdo_o_a),
    .hps_emac_interface_splitter_0_mdio_gmii_mdo_o_e (hps_emac_mdo_o_e_a),
    .hps_emac_interface_splitter_0_ptp_ptp_aux_ts_trig_i (),
    .hps_emac_interface_splitter_0_ptp_ptp_pps_o (),
    .hps_emac_interface_splitter_0_ptp_ptp_tstmp_data  (),
    .hps_emac_interface_splitter_0_ptp_ptp_tstmp_en  (),

    .gmii_to_rgmii_adapter_0_hps_gmii_rst_tx_n (loopback_rst_tx_n_0),
    .gmii_to_rgmii_adapter_0_hps_gmii_rst_rx_n (loopback_rst_rx_n_0),
    .gmii_to_rgmii_adapter_0_hps_gmii_phy_txd_o (loopback_phy_txd_0),
    .gmii_to_rgmii_adapter_0_hps_gmii_phy_txen_o (loopback_phy_txen_0),
    .gmii_to_rgmii_adapter_0_hps_gmii_phy_txer_o (loopback_phy_txer_0),
    .gmii_to_rgmii_adapter_0_hps_gmii_phy_mac_speed_o (loopback_phy_mac_speed_0),
    .gmii_to_rgmii_adapter_0_hps_gmii_phy_tx_clk_i (loopback_phy_tx_clk_i_0),
    .gmii_to_rgmii_adapter_0_hps_gmii_phy_tx_clk_o (loopback_phy_tx_clk_o_0),
    .gmii_to_rgmii_adapter_0_hps_gmii_phy_rx_clk_i (loopback_phy_rx_clk_0),
    .gmii_to_rgmii_adapter_0_hps_gmii_phy_rxdv_i (loopback_phy_rxdv_0),
    .gmii_to_rgmii_adapter_0_hps_gmii_phy_rxer_i (loopback_phy_rxer_0),
    .gmii_to_rgmii_adapter_0_hps_gmii_phy_rxd_i (loopback_phy_rxd_0),
    .gmii_to_rgmii_adapter_0_hps_gmii_phy_col_i (loopback_phy_col_0),
    .gmii_to_rgmii_adapter_0_hps_gmii_phy_crs_i (loopback_phy_crs_0),
    .hps_emac_interface_splitter_0_hps_gmii_phy_tx_clk_i (loopback_phy_tx_clk_i_0),
    .hps_emac_interface_splitter_0_hps_gmii_phy_tx_clk_o (loopback_phy_tx_clk_o_0),
    .hps_emac_interface_splitter_0_hps_gmii_phy_rx_clk_i (loopback_phy_rx_clk_0),
    .hps_emac_interface_splitter_0_hps_gmii_phy_rxdv_i (loopback_phy_rxdv_0),
    .hps_emac_interface_splitter_0_hps_gmii_phy_rxer_i (loopback_phy_rxer_0),
    .hps_emac_interface_splitter_0_hps_gmii_phy_rxd_i (loopback_phy_rxd_0[3:0]),
    .hps_emac_interface_splitter_0_hps_gmii_phy_col_i (loopback_phy_col_0),
    .hps_emac_interface_splitter_0_hps_gmii_phy_crs_i (loopback_phy_crs_0),
    .hps_emac_interface_splitter_0_hps_gmii_rst_tx_n (loopback_rst_tx_n_0),
    .hps_emac_interface_splitter_0_hps_gmii_rst_rx_n (loopback_rst_rx_n_0),
    .hps_emac_interface_splitter_0_hps_gmii_phy_txd_o (loopback_phy_txd_0[3:0]),
    .hps_emac_interface_splitter_0_hps_gmii_phy_txen_o (loopback_phy_txen_0),
    .hps_emac_interface_splitter_0_hps_gmii_phy_txer_o (loopback_phy_txer_0),
    .hps_emac_interface_splitter_0_hps_gmii_phy_mac_speed_o (loopback_phy_mac_speed_0),

    .hps_emac_interface_splitter_1_hps_gmii_rst_tx_n (loopback_rst_tx_n_1),
    .hps_emac_interface_splitter_1_hps_gmii_rst_rx_n (loopback_rst_rx_n_1),
    .hps_emac_interface_splitter_1_hps_gmii_phy_rx_clk_i (loopback_phy_rx_clk_1),
    .hps_emac_interface_splitter_1_hps_gmii_phy_tx_clk_i (loopback_phy_tx_clk_i_1),
    .hps_emac_interface_splitter_1_hps_gmii_phy_tx_clk_o (loopback_phy_tx_clk_o_1),
    .hps_emac_interface_splitter_1_hps_gmii_phy_txd_o (loopback_phy_txd_1),
    .hps_emac_interface_splitter_1_hps_gmii_phy_txen_o (loopback_phy_txen_1),
    .hps_emac_interface_splitter_1_hps_gmii_phy_txer_o (loopback_phy_txer_1),
    .hps_emac_interface_splitter_1_hps_gmii_phy_rxd_i (loopback_phy_rxd_1),
    .hps_emac_interface_splitter_1_hps_gmii_phy_rxdv_i (loopback_phy_rxdv_1),
    .hps_emac_interface_splitter_1_hps_gmii_phy_rxer_i (loopback_phy_rxer_1),
    .hps_emac_interface_splitter_1_hps_gmii_phy_col_i (loopback_phy_col_1),
    .hps_emac_interface_splitter_1_hps_gmii_phy_crs_i (loopback_phy_crs_1),
    .hps_emac_interface_splitter_1_hps_gmii_phy_mac_speed_o (loopback_phy_mac_speed_1),
    .gmii_to_rgmii_adapter_1_hps_gmii_rst_tx_n (loopback_rst_tx_n_1),
    .gmii_to_rgmii_adapter_1_hps_gmii_rst_rx_n (loopback_rst_rx_n_1),
    .gmii_to_rgmii_adapter_1_hps_gmii_phy_rx_clk_i (loopback_phy_rx_clk_1),
    .gmii_to_rgmii_adapter_1_hps_gmii_phy_tx_clk_i (loopback_phy_tx_clk_i_1),
    .gmii_to_rgmii_adapter_1_hps_gmii_phy_tx_clk_o (loopback_phy_tx_clk_o_1),
    .gmii_to_rgmii_adapter_1_hps_gmii_phy_txd_o (loopback_phy_txd_1[3:0]),
    .gmii_to_rgmii_adapter_1_hps_gmii_phy_txen_o (loopback_phy_txen_1),
    .gmii_to_rgmii_adapter_1_hps_gmii_phy_txer_o (loopback_phy_txer_1),
    .gmii_to_rgmii_adapter_1_hps_gmii_phy_rxd_i (loopback_phy_rxd_1[3:0]),
    .gmii_to_rgmii_adapter_1_hps_gmii_phy_rxdv_i (loopback_phy_rxdv_1),
    .gmii_to_rgmii_adapter_1_hps_gmii_phy_rxer_i (loopback_phy_rxer_1),
    .gmii_to_rgmii_adapter_1_hps_gmii_phy_col_i (loopback_phy_col_1),
    .gmii_to_rgmii_adapter_1_hps_gmii_phy_crs_i (loopback_phy_crs_1),
    .gmii_to_rgmii_adapter_1_hps_gmii_phy_mac_speed_o (loopback_phy_mac_speed_1),

    .sys_hps_emac2_md_clk_clk (mdc_fmc_b),
    .gmii_to_rgmii_adapter_1_phy_rgmii_rgmii_rx_clk (rgmii_rxc_b),
    .gmii_to_rgmii_adapter_1_phy_rgmii_rgmii_rxd (rgmii_rxd_b),
    .gmii_to_rgmii_adapter_1_phy_rgmii_rgmii_rx_ctl (rgmii_rx_ctl_b),
    .gmii_to_rgmii_adapter_1_phy_rgmii_rgmii_tx_clk (rgmii_txc_b),
    .gmii_to_rgmii_adapter_1_phy_rgmii_rgmii_txd (rgmii_txd_b),
    .gmii_to_rgmii_adapter_1_phy_rgmii_rgmii_tx_ctl (rgmii_tx_ctl_b),
    .hps_emac_interface_splitter_1_mdio_gmii_mdi_i (hps_emac_mdi_i_b),
    .hps_emac_interface_splitter_1_mdio_gmii_mdo_o (hps_emac_mdo_o_b),
    .hps_emac_interface_splitter_1_mdio_gmii_mdo_o_e (hps_emac_mdo_o_e_b),
    .hps_emac_interface_splitter_1_ptp_ptp_aux_ts_trig_i (),
    .hps_emac_interface_splitter_1_ptp_ptp_pps_o (),
    .hps_emac_interface_splitter_1_ptp_ptp_tstmp_data  (),
    .hps_emac_interface_splitter_1_ptp_ptp_tstmp_en  ()
    );

endmodule

// ***************************************************************************
// ***************************************************************************
