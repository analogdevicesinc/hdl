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
// freedoms and responsabilities that he or she has by using this source/core.
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

  input            sys_clk,

  // hps-ddr

  output  [14:0]    ddr3_a,
  output  [ 2:0]    ddr3_ba,
  output            ddr3_reset_n,
  output            ddr3_ck_p,
  output            ddr3_ck_n,
  output            ddr3_cke,
  output            ddr3_cs_n,
  output            ddr3_ras_n,
  output            ddr3_cas_n,
  output            ddr3_we_n,
  inout   [31:0]    ddr3_dq,
  inout   [ 3:0]    ddr3_dqs_p,
  inout   [ 3:0]    ddr3_dqs_n,
  output  [ 3:0]    ddr3_dm,
  output            ddr3_odt,
  input             ddr3_rzq,

  // hps-ethernet

  output            eth1_tx_clk,
  output            eth1_tx_ctl,
  output  [ 3:0]    eth1_tx_d,
  input             eth1_rx_clk,
  input             eth1_rx_ctl,
  input   [ 3:0]    eth1_rx_d,
  output            eth1_mdc,
  inout             eth1_mdio,

  // hps-sdio

  output            sdio_clk,
  inout             sdio_cmd,
  inout   [ 3:0]    sdio_d,

  // hps-spim1

  output            spim1_ss0,
  output            spim1_clk,
  output            spim1_mosi,
  input             spim1_miso,

  // hps-usb

  input             usb1_clk,
  output            usb1_stp,
  input             usb1_dir,
  input             usb1_nxt,
  inout   [ 7:0]    usb1_d,

  // hps-uart

  input             uart0_rx,
  output            uart0_tx,
  inout             hps_conv_usb_n,

  // board gpio

  output  [ 3:0]    gpio_bd_o,
  input   [ 7:0]    gpio_bd_i,

  // RGMII interfaces

  output            mdc,
  inout             mdio,
  input   [ 3:0]    rgmii_rxd,
  input             rgmii_rx_ctl,
  input             rgmii_rxc,
  output  [ 3:0]    rgmii_txd,
  output            rgmii_tx_ctl,
  output            rgmii_txc,
  input             int_n);

  // internal signals

  wire              sys_resetn;
  wire    [63:0]    gpio_i;
  wire    [63:0]    gpio_o;

  wire              hps_emac_mdi_i;
  wire              hps_emac_mdo_o;
  wire              hps_emac_mdo_o_e;

  wire              loopback_phy_tx_clk_i_0;
  wire              loopback_phy_tx_clk_o_0;
  wire              loopback_rst_tx_n_0;
  wire              loopback_rst_rx_n_0;
  wire    [ 7:0]    loopback_phy_txd_0;
  wire              loopback_phy_txen_0;
  wire              loopback_phy_txer_0;
  wire    [ 1:0]    loopback_phy_mac_speed_0;
  wire              loopback_phy_rx_clk_0;
  wire              loopback_phy_rxdv_0;
  wire              loopback_phy_rxer_0;
  wire    [ 7:0]    loopback_phy_rxd_0;
  wire              loopback_phy_col_0;
  wire              loopback_phy_crs_0;

  // instantiations

  assign gpio_i[63:12] = gpio_o[63:12];

  assign gpio_i[11:4] = gpio_bd_i[7:0];
  assign gpio_bd_o[3:0] = gpio_o[3:0];

  ALT_IOBUF md_iobuf_a (
    .i(hps_emac_mdo_o),
    .oe(hps_emac_mdo_o_e),
    .o(hps_emac_mdi_i),
    .io(mdio));

  system_bd i_system_bd (
    .sys_clk_clk (sys_clk),
    .sys_hps_h2f_reset_reset_n (sys_resetn),
    .sys_hps_memory_mem_a (ddr3_a),
    .sys_hps_memory_mem_ba (ddr3_ba),
    .sys_hps_memory_mem_ck (ddr3_ck_p),
    .sys_hps_memory_mem_ck_n (ddr3_ck_n),
    .sys_hps_memory_mem_cke (ddr3_cke),
    .sys_hps_memory_mem_cs_n (ddr3_cs_n),
    .sys_hps_memory_mem_ras_n (ddr3_ras_n),
    .sys_hps_memory_mem_cas_n (ddr3_cas_n),
    .sys_hps_memory_mem_we_n (ddr3_we_n),
    .sys_hps_memory_mem_reset_n (ddr3_reset_n),
    .sys_hps_memory_mem_dq (ddr3_dq),
    .sys_hps_memory_mem_dqs (ddr3_dqs_p),
    .sys_hps_memory_mem_dqs_n (ddr3_dqs_n),
    .sys_hps_memory_mem_odt (ddr3_odt),
    .sys_hps_memory_mem_dm (ddr3_dm),
    .sys_hps_memory_oct_rzqin (ddr3_rzq),

    .sys_hps_i2c0_out_data (i2c0_out_data),
    .sys_hps_i2c0_sda (i2c0_sda),
    .sys_hps_i2c0_clk_clk (i2c0_out_clk),
    .sys_hps_i2c0_scl_in_clk (i2c0_scl_in_clk),

    .sys_rst_reset_n (sys_resetn),
    .sys_hps_hps_io_hps_io_sdio_inst_CMD (sdio_cmd),
    .sys_hps_hps_io_hps_io_sdio_inst_D0 (sdio_d[0]),
    .sys_hps_hps_io_hps_io_sdio_inst_D1 (sdio_d[1]),
    .sys_hps_hps_io_hps_io_sdio_inst_CLK (sdio_clk),
    .sys_hps_hps_io_hps_io_sdio_inst_D2 (sdio_d[2]),
    .sys_hps_hps_io_hps_io_sdio_inst_D3 (sdio_d[3]),
    .sys_hps_hps_io_hps_io_usb1_inst_D0 (usb1_d[0]),
    .sys_hps_hps_io_hps_io_usb1_inst_D1 (usb1_d[1]),
    .sys_hps_hps_io_hps_io_usb1_inst_D2 (usb1_d[2]),
    .sys_hps_hps_io_hps_io_usb1_inst_D3 (usb1_d[3]),
    .sys_hps_hps_io_hps_io_usb1_inst_D4 (usb1_d[4]),
    .sys_hps_hps_io_hps_io_usb1_inst_D5 (usb1_d[5]),
    .sys_hps_hps_io_hps_io_usb1_inst_D6 (usb1_d[6]),
    .sys_hps_hps_io_hps_io_usb1_inst_D7 (usb1_d[7]),
    .sys_hps_hps_io_hps_io_usb1_inst_CLK (usb1_clk),
    .sys_hps_hps_io_hps_io_usb1_inst_STP (usb1_stp),
    .sys_hps_hps_io_hps_io_usb1_inst_DIR (usb1_dir),
    .sys_hps_hps_io_hps_io_usb1_inst_NXT (usb1_nxt),
    .sys_hps_hps_io_hps_io_uart0_inst_RX (uart0_rx),
    .sys_hps_hps_io_hps_io_uart0_inst_TX (uart0_tx),
    .sys_hps_hps_io_hps_io_spim1_inst_CLK (spim1_clk),
    .sys_hps_hps_io_hps_io_spim1_inst_MOSI (spim1_mosi),
    .sys_hps_hps_io_hps_io_spim1_inst_MISO (spim1_miso),
    .sys_hps_hps_io_hps_io_spim1_inst_SS0 (spim1_ss0),
    .sys_gpio_bd_in_port (gpio_i[31:0]),
    .sys_gpio_bd_out_port (gpio_o[31:0]),
    .sys_gpio_in_export (gpio_i[63:32]),
    .sys_gpio_out_export (gpio_o[63:32]),
    .sys_hps_hps_io_hps_io_gpio_inst_GPIO09 (hps_conv_usb_n),
    .sys_hps_emac1_md_clk_clk (mdc),
    .gmii_to_rgmii_adapter_0_phy_rgmii_rgmii_rx_clk (rgmii_rxc),
    .gmii_to_rgmii_adapter_0_phy_rgmii_rgmii_rxd (rgmii_rxd),
    .gmii_to_rgmii_adapter_0_phy_rgmii_rgmii_rx_ctl (rgmii_rx_ctl),
    .gmii_to_rgmii_adapter_0_phy_rgmii_rgmii_tx_clk (rgmii_txc),
    .gmii_to_rgmii_adapter_0_phy_rgmii_rgmii_txd (rgmii_txd),
    .gmii_to_rgmii_adapter_0_phy_rgmii_rgmii_tx_ctl (rgmii_tx_ctl),
    .hps_emac_interface_splitter_0_mdio_gmii_mdi_i (hps_emac_mdi_i),
    .hps_emac_interface_splitter_0_mdio_gmii_mdo_o (hps_emac_mdo_o),
    .hps_emac_interface_splitter_0_mdio_gmii_mdo_o_e (hps_emac_mdo_o_e),
    .hps_emac_interface_splitter_0_ptp_ptp_aux_ts_trig_i (),
    .hps_emac_interface_splitter_0_ptp_ptp_pps_o (),
    .hps_emac_interface_splitter_0_ptp_ptp_tstmp_data (),
    .hps_emac_interface_splitter_0_ptp_ptp_tstmp_en ()

    );

endmodule

// ***************************************************************************
// ***************************************************************************
