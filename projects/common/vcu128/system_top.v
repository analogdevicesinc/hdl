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
  output  [ 1:0]  ddr4_cs_n,
  inout   [ 8:0]  ddr4_dm_n,
  inout   [71:0]  ddr4_dq,
  inout   [ 8:0]  ddr4_dqs_p,
  inout   [ 8:0]  ddr4_dqs_n,
  output          ddr4_odt,
  output          ddr4_reset_n,

  output          mdio_mdc,
  inout           mdio_mdio,
  input           phy_clk_p,
  input           phy_clk_n,
  input           phy_rx_p,
  input           phy_rx_n,
  output          phy_tx_p,
  output          phy_tx_n,
  input           phy_dummy_port_in,

  inout   [ 7:0]  gpio_bd,

  inout           iic_scl,
  inout           iic_sda
);

  // internal signals
  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;

  assign gpio_i[63:32] = gpio_o[63:32];
  assign gpio_i[31: 9] = gpio_o[31: 9];

  // instantiations
  ad_iobuf #(
    .DATA_WIDTH (8)
  ) i_iobuf_bd (
    .dio_t (gpio_t[ 7:0]),
    .dio_i (gpio_o[ 7:0]),
    .dio_o (gpio_i[ 7:0]),
    .dio_p (gpio_bd ));

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
    .phy_dummy_port_in (phy_dummy_port_in),
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

    .spi_clk_i (),
    .spi_clk_o (),
    .spi_csn_i (1'b1),
    .spi_csn_o (1'b1),
    .spi_sdi_i (1'b0),
    .spi_sdo_i (),
    .spi_sdo_o (),

    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]));

endmodule
