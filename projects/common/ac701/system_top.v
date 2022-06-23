// ***************************************************************************
// ***************************************************************************
// Copyright 2011 - 2022 (c) Analog Devices, Inc. All rights reserved.
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

  input           sys_rst,
  input           sys_clk_p,
  input           sys_clk_n,

  input           uart_sin,
  output          uart_sout,

  output  [13:0]  ddr3_addr,
  output  [ 2:0]  ddr3_ba,
  output          ddr3_cas_n,
  output          ddr3_ck_n,
  output          ddr3_ck_p,
  output          ddr3_cke,
  output          ddr3_cs_n,
  output  [ 7:0]  ddr3_dm,
  inout   [63:0]  ddr3_dq,
  inout   [ 7:0]  ddr3_dqs_n,
  inout   [ 7:0]  ddr3_dqs_p,
  output          ddr3_odt,
  output          ddr3_ras_n,
  output          ddr3_reset_n,
  output          ddr3_we_n,

  input           sgmii_rxp,
  input           sgmii_rxn,
  output          sgmii_txp,
  output          sgmii_txn,

  output          phy_rstn,
  input           mgt_clk_p,
  input           mgt_clk_n,
  output          mdio_mdc,
  inout           mdio_mdio,

  output          fan_pwm,

  output  [ 6:0]  gpio_lcd,
  output  [ 7:0]  gpio_led,
  input   [12:0]  gpio_sw,

  output          iic_rstn,
  inout           iic_scl,
  inout           iic_sda,

  output          hdmi_out_clk,
  output          hdmi_hsync,
  output          hdmi_vsync,
  output          hdmi_data_e,
  output  [23:0]  hdmi_data,

  output          spdif
);

  // instantiations
  system_wrapper i_system_wrapper (
    .sys_clk_n (sys_clk_n),
    .sys_clk_p (sys_clk_p),
    .sys_rst (sys_rst),

    .uart_sin (uart_sin),
    .uart_sout (uart_sout),

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

    .sgmii_rxn (sgmii_rxn),
    .sgmii_rxp (sgmii_rxp),
    .sgmii_txn (sgmii_txn),
    .sgmii_txp (sgmii_txp),
    .mdio_mdc (mdio_mdc),
    .mdio_mdio_io (mdio_mdio),
    .mgt_clk_clk_n (mgt_clk_n),
    .mgt_clk_clk_p (mgt_clk_p),
    .phy_rstn (phy_rstn),

    .fan_pwm (fan_pwm),

    .gpio_lcd_tri_o (gpio_lcd),
    .gpio_led_tri_o (gpio_led),
    .gpio_sw_tri_i (gpio_sw),

    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .iic_rstn (iic_rstn),

    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),

    .spdif (spdif));

endmodule
