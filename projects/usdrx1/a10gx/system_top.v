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

  input                   sys_clk,
  input                   sys_resetn,

  // ddr3

  output                  ddr3_clk_p,
  output                  ddr3_clk_n,
  output      [ 14:0]     ddr3_a,
  output      [  2:0]     ddr3_ba,
  output                  ddr3_cke,
  output                  ddr3_cs_n,
  output                  ddr3_odt,
  output                  ddr3_reset_n,
  output                  ddr3_we_n,
  output                  ddr3_ras_n,
  output                  ddr3_cas_n,
  inout       [  7:0]     ddr3_dqs_p,
  inout       [  7:0]     ddr3_dqs_n,
  inout       [ 63:0]     ddr3_dq,
  output      [  7:0]     ddr3_dm,
  input                   ddr3_rzq,
  input                   ddr3_ref_clk,

  // ethernet

  input                   eth_ref_clk,
  input                   eth_rxd,
  output                  eth_txd,
  output                  eth_mdc,
  inout                   eth_mdio,
  output                  eth_resetn,
  input                   eth_intn,

  // board gpio

  input       [ 10:0]     gpio_bd_i,
  output      [ 15:0]     gpio_bd_o,

  // lane interface

  input                   ref_clk,
  input                   rx_sysref,
  output                  rx_sync,
  input       [  3:0]     rx_data,

  // spi

  output                  spi_csn,
  output                  spi_clk,
  inout                   spi_sdio);

  // internal signals

  wire                    rx_clk;
  wire        [  3:0]     rx_ip_sof;
  wire        [127:0]     rx_ip_data;
  wire                    eth_reset;
  wire                    eth_mdio_i;
  wire                    eth_mdio_o;
  wire                    eth_mdio_t;
  wire        [ 63:0]     gpio_i;
  wire        [ 63:0]     gpio_o;
  wire                    spi_miso;
  wire                    spi_mosi;
  wire        [  7:0]     spi_csn_s;

  // gpio in & out are separate cores

  assign gpio_i[63:32] = gpio_o[63:32];

  // board stuff

  assign eth_resetn = ~eth_reset;
  assign eth_mdio_i = eth_mdio;
  assign eth_mdio = (eth_mdio_t == 1'b1) ? 1'bz : eth_mdio_o;

  assign ddr3_a[14:12] = 3'd0;

  assign gpio_i[31:27] = gpio_o[31:27];
  assign gpio_i[15: 0] = gpio_o[15:0];

  // instantiations
 
  assign spi_csn = spi_csn_s[0];

  fmcjesdadc1_spi i_fmcjesdadc1_spi (
    .spi_csn (spi_csn_s[0]),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio));

  system_bd i_system_bd (
    .rx_core_clk_clk (rx_clk),
    .rx_data_0_rx_serial_data (rx_data[0]),
    .rx_data_1_rx_serial_data (rx_data[1]),
    .rx_data_2_rx_serial_data (rx_data[2]),
    .rx_data_3_rx_serial_data (rx_data[3]),
    .rx_ip_data_data (rx_ip_data),
    .rx_ip_data_valid (),
    .rx_ip_data_ready (1'b1),
    .rx_ip_data_0_data (rx_ip_data[63:0]),
    .rx_ip_data_0_valid (1'b1),
    .rx_ip_data_0_ready (),
    .rx_ip_data_1_data (rx_ip_data[127:64]),
    .rx_ip_data_1_valid (1'b1),
    .rx_ip_data_1_ready (),
    .rx_ip_sof_export (rx_ip_sof),
    .rx_ip_sof_0_export (rx_ip_sof),
    .rx_ip_sof_1_export (rx_ip_sof),
    .rx_ref_clk_clk (ref_clk),
    .rx_sync_export (rx_sync),
    .rx_sysref_export (rx_sysref),
    .sys_clk_clk (sys_clk),
    .sys_ddr3_cntrl_mem_mem_ck (ddr3_clk_p),
    .sys_ddr3_cntrl_mem_mem_ck_n (ddr3_clk_n),
    .sys_ddr3_cntrl_mem_mem_a (ddr3_a[11:0]),
    .sys_ddr3_cntrl_mem_mem_ba (ddr3_ba),
    .sys_ddr3_cntrl_mem_mem_cke (ddr3_cke),
    .sys_ddr3_cntrl_mem_mem_cs_n (ddr3_cs_n),
    .sys_ddr3_cntrl_mem_mem_odt (ddr3_odt),
    .sys_ddr3_cntrl_mem_mem_reset_n (ddr3_reset_n),
    .sys_ddr3_cntrl_mem_mem_we_n (ddr3_we_n),
    .sys_ddr3_cntrl_mem_mem_ras_n (ddr3_ras_n),
    .sys_ddr3_cntrl_mem_mem_cas_n (ddr3_cas_n),
    .sys_ddr3_cntrl_mem_mem_dqs (ddr3_dqs_p[7:0]),
    .sys_ddr3_cntrl_mem_mem_dqs_n (ddr3_dqs_n[7:0]),
    .sys_ddr3_cntrl_mem_mem_dq (ddr3_dq[63:0]),
    .sys_ddr3_cntrl_mem_mem_dm (ddr3_dm[7:0]),
    .sys_ddr3_cntrl_oct_oct_rzqin (ddr3_rzq),
    .sys_ddr3_cntrl_pll_ref_clk_clk (ddr3_ref_clk),
    .sys_ethernet_mdio_mdc (eth_mdc),
    .sys_ethernet_mdio_mdio_in (eth_mdio_i),
    .sys_ethernet_mdio_mdio_out (eth_mdio_o),
    .sys_ethernet_mdio_mdio_oen (eth_mdio_t),
    .sys_ethernet_ref_clk_clk (eth_ref_clk),
    .sys_ethernet_reset_reset (eth_reset),
    .sys_ethernet_sgmii_rxp_0 (eth_rxd),
    .sys_ethernet_sgmii_txp_0 (eth_txd),
    .sys_gpio_bd_in_port (gpio_i[31:0]),
    .sys_gpio_bd_out_port (gpio_o[31:0]),
    .sys_gpio_in_export (gpio_i[63:32]),
    .sys_gpio_out_export (gpio_o[63:32]),
    .sys_rst_reset_n (sys_resetn),
    .sys_spi_MISO (spi_miso),
    .sys_spi_MOSI (spi_mosi_s),
    .sys_spi_SCLK (spi_clk),
    .sys_spi_SS_n (spi_csn_s));

endmodule

// ***************************************************************************
// ***************************************************************************
