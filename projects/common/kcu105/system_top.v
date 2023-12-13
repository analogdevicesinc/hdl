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

  output          fan_pwm,

  inout   [16:0]  gpio_bd,

  inout           iic_scl,
  inout           iic_sda
);

  // internal signals
  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;

  assign gpio_i[63:32] = gpio_o[63:32];
  assign gpio_i[31:17] = gpio_o[31:17];

  // default logic
  assign fan_pwm = 1'b1;

  // instantiations
  ad_iobuf #(
    .DATA_WIDTH (17)
  ) i_iobuf_bd (
    .dio_t (gpio_t[16:0]),
    .dio_i (gpio_o[16:0]),
    .dio_o (gpio_i[16:0]),
    .dio_p (gpio_bd));

  system_wrapper i_system_wrapper (
    .c0_ddr4_act_n (ddr4_act_n),
    .c0_ddr4_adr (ddr4_addr),
    .c0_ddr4_ba (ddr4_ba),
    .c0_ddr4_bg (ddr4_bg),
    .c0_ddr4_ck_c (ddr4_ck_n),
    .c0_ddr4_ck_t (ddr4_ck_p),
    .c0_ddr4_cke (ddr4_cke),
    .c0_ddr4_cs_n (ddr4_cs_n),
    .c0_ddr4_dm_n (ddr4_dm_n),
    .c0_ddr4_dq (ddr4_dq),
    .c0_ddr4_dqs_c (ddr4_dqs_n),
    .c0_ddr4_dqs_t (ddr4_dqs_p),
    .c0_ddr4_odt (ddr4_odt),
    .c0_ddr4_reset_n (ddr4_reset_n),

    .gpio0_i (gpio_i[31: 0]),
    .gpio0_o (gpio_o[31: 0]),
    .gpio0_t (gpio_t[31: 0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),

    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),

    .mdio_mdc (mdio_mdc),
    .mdio_mdio_io (mdio_mdio),
    .phy_clk_clk_n (phy_clk_n),
    .phy_clk_clk_p (phy_clk_p),
    .phy_rst_n (phy_rst_n),
    .phy_sd (1'b1),
    .sgmii_rxn (phy_rx_n),
    .sgmii_rxp (phy_rx_p),
    .sgmii_txn (phy_tx_n),
    .sgmii_txp (phy_tx_p),

    .spi_clk_i (),
    .spi_clk_o (),
    .spi_csn_i (1'b1),
    .spi_csn_o (),
    .spi_sdi_i (1'b0),
    .spi_sdo_i (1'b0),
    .spi_sdo_o (),

    .sys_clk_clk_n (sys_clk_n),
    .sys_clk_clk_p (sys_clk_p),
    .sys_rst (sys_rst),

    .uart_sin (uart_sin),
    .uart_sout (uart_sout));

endmodule
