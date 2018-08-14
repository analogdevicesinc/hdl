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

  input                   sys_clk,
  input                   sys_resetn,

  // ddr3

  output                  ddr3_clk_p,
  output                  ddr3_clk_n,
  output      [ 14:0]     ddr3_a,
  output      [ 2:0]      ddr3_ba,
  output                  ddr3_cke,
  output                  ddr3_cs_n,
  output                  ddr3_odt,
  output                  ddr3_reset_n,
  output                  ddr3_we_n,
  output                  ddr3_ras_n,
  output                  ddr3_cas_n,
  inout       [ 7:0]      ddr3_dqs_p,
  inout       [ 7:0]      ddr3_dqs_n,
  inout       [ 63:0]     ddr3_dq,
  output      [ 7:0]      ddr3_dm,
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

  // flash

  output                  flash_oen,
  output      [  1:0]     flash_cen,
  output      [ 27:0]     flash_addr,             // drop A0 & A1 for 32 bit data bus
  inout       [ 31:0]     flash_data,
  output                  flash_wen,
  output                  flash_advn,
  output                  flash_clk,
  output                  flash_resetn,

  // lane interface

  input                   rx_ref_clk,
  input                   rx_sysref,
  output                  rx_sync,
  input       [ 3:0]      rx_serial_data,
  input                   tx_ref_clk,
  input                   tx_sysref,
  input                   tx_sync,
  output      [ 3:0]      tx_serial_data,

  // gpio

  input                   trig,
  input                   adc_fdb,
  input                   adc_fda,
  input                   dac_irq,
  input       [ 1:0]      clkd_status,
  output                  adc_pd,
  output                  dac_txen,
  output                  dac_reset,
  output                  clkd_sync,

  // spi

  output                  spi_csn_clk,
  output                  spi_csn_dac,
  output                  spi_csn_adc,
  output                  spi_clk,
  inout                   spi_sdio,
  output                  spi_dir);

  // internal signals

  wire              eth_reset;
  wire              eth_mdio_i;
  wire              eth_mdio_o;
  wire              eth_mdio_t;
  wire    [ 63:0]   gpio_i;
  wire    [ 63:0]   gpio_o;
  wire              spi_miso_s;
  wire              spi_mosi_s;
  wire    [  7:0]   spi_csn_s;
  wire              dac_fifo_bypass;

  // User code space at offset 0x0930_0000 per Intel's Board Update Portal
  // reference design used to program flash

  wire    [23:0]    flash_addr_raw;
  assign flash_addr = flash_addr_raw + 28'h9300000;

  // daq2

  assign spi_csn_adc = spi_csn_s[2];
  assign spi_csn_dac = spi_csn_s[1];
  assign spi_csn_clk = spi_csn_s[0];

  daq2_spi i_daq2_spi (
    .spi_csn (spi_csn_s[2:0]),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi_s),
    .spi_miso (spi_miso_s),
    .spi_sdio (spi_sdio),
    .spi_dir (spi_dir));

  // gpio in & out are separate cores

  assign gpio_i[63:44] = gpio_o[63:44];
  assign dac_fifo_bypass = gpio_o[44];
  assign gpio_i[43:43] = trig;

  assign gpio_i[42:40] = gpio_o[42:40];
  assign adc_pd = gpio_o[42];
  assign dac_txen = gpio_o[41];
  assign dac_reset = gpio_o[40];

  assign gpio_i[39:39] = gpio_o[39:39];

  assign gpio_i[38:38] = gpio_o[38:38];
  assign clkd_sync = gpio_o[38];

  assign gpio_i[37:37] = gpio_o[37:37];
  assign gpio_i[36:36] = adc_fdb;
  assign gpio_i[35:35] = adc_fda;
  assign gpio_i[34:34] = dac_irq;
  assign gpio_i[33:32] = clkd_status;

  // board stuff

  assign eth_resetn = ~eth_reset;
  assign eth_mdio_i = eth_mdio;
  assign eth_mdio = (eth_mdio_t == 1'b1) ? 1'bz : eth_mdio_o;

  assign ddr3_a[14:12] = 3'd0;

  assign gpio_i[31:27] = gpio_o[31:27];
  assign gpio_i[26:16] = gpio_bd_i;
  assign gpio_i[15: 0] = gpio_o[15: 0];

  assign gpio_bd_o = gpio_o[15:0];

  // Common Flash interface assignments

  assign  flash_resetn = 1'b1;         // user_resetn; flash ready after FPGA is configured, reset during configuration
  assign  flash_advn   = 1'b0;
  assign  flash_clk    = 1'b0;
  assign  flash_cen[1] = flash_cen[0]; // select both flash devices for double-wide 32 bit data width


  system_bd i_system_bd (
    .rx_serial_data_rx_serial_data (rx_serial_data),
    .rx_ref_clk_clk (rx_ref_clk),
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
    .sys_spi_MISO (spi_miso_s),
    .sys_spi_MOSI (spi_mosi_s),
    .sys_spi_SCLK (spi_clk),
    .sys_spi_SS_n (spi_csn_s),
    .tx_serial_data_tx_serial_data (tx_serial_data),
    .tx_fifo_bypass_bypass (dac_fifo_bypass),
    .tx_ref_clk_clk (tx_ref_clk),
    .tx_sync_export (tx_sync),
    .tx_sysref_export (tx_sysref),
    .sys_flash_tcm_address_out (flash_addr_raw),
    .sys_flash_tcm_read_n_out (flash_oen),
    .sys_flash_tcm_write_n_out (flash_wen),
    .sys_flash_tcm_data_out (flash_data),
    .sys_flash_tcm_chipselect_n_out (flash_cen[0]));

endmodule

// ***************************************************************************
// ***************************************************************************
