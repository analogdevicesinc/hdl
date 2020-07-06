// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2020 (c) Analog Devices, Inc. All rights reserved.
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

  input   [12:0]  gpio_bd_i,
  output  [ 7:0]  gpio_bd_o,

  // mii interface

  output          reset_n,
  output          mdc_fmc,
  inout           mdio_fmc,
  input   [ 3:0]  mii_rxd,
  input           mii_rx_dv,
  input           mii_rx_er,
  output          mii_tx_er,
  input           mii_rx_clk,
  output  [ 3:0]  mii_txd,
  output          mii_tx_en,
  input           mii_tx_clk,
  input           link_st
);

  // internal signals

  wire    [ 3:0]  mii_txd_extra;

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;

  // assignments
  //
  assign gpio_i[94:36] = gpio_o[94:36];
  assign gpio_i[35] = link_st;
  assign gpio_i[34:21] = gpio_o[35:21];
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_i[ 7: 0] = gpio_o[7:0];

  assign gpio_bd_o = gpio_o[ 7:0];

  // instantiations

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (),
    .spi0_csn (),
    .spi0_miso (1'b0),
    .spi0_mosi (),
    .spi0_sclk (),
    .spi1_csn (),
    .spi1_miso (1'b0),
    .spi1_mosi (),
    .spi1_sclk (),
    .reset_n (reset_n),
    .GMII_ENET1_0_col(1'b0),
    .GMII_ENET1_0_crs(1'b0),
    .GMII_ENET1_0_rx_clk(mii_rx_clk),
    .GMII_ENET1_0_rx_dv(mii_rx_dv),
    .GMII_ENET1_0_rx_er(mii_rx_er),
    .GMII_ENET1_0_rxd({4'h0,mii_rxd}),
    .GMII_ENET1_0_tx_clk(mii_tx_clk),
    .GMII_ENET1_0_tx_en(mii_tx_en),
    .GMII_ENET1_0_tx_er(mii_tx_er),
    .GMII_ENET1_0_txd({mii_txd_extra,mii_txd}),
    .MDIO_ENET1_0_mdc(mdc_fmc),
    .MDIO_ENET1_0_mdio_io(mdio_fmc)
  );

endmodule

// ***************************************************************************
// ***************************************************************************
