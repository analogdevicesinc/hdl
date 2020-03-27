// ***************************************************************************
// ***************************************************************************
// Copyright 2019 - 2020 (c) Analog Devices, Inc. All rights reserved.
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

  output  [14:0]   ddr3_a,
  output  [ 2:0]   ddr3_ba,
  output           ddr3_reset_n,
  output           ddr3_ck_p,
  output           ddr3_ck_n,
  output           ddr3_cke,
  output           ddr3_cs_n,
  output           ddr3_ras_n,
  output           ddr3_cas_n,
  output           ddr3_we_n,
  inout   [31:0]   ddr3_dq,
  inout   [ 3:0]   ddr3_dqs_p,
  inout   [ 3:0]   ddr3_dqs_n,
  output  [ 3:0]   ddr3_dm,
  output           ddr3_odt,
  input            ddr3_rzq,

  // hps-ethernet

  output            eth1_tx_clk,
  output            eth1_tx_ctl,
  output  [  3:0]   eth1_tx_d,
  input             eth1_rx_clk,
  input             eth1_rx_ctl,
  input   [  3:0]   eth1_rx_d,
  output            eth1_mdc,
  inout             eth1_mdio,

  // hps-sdio

  output            sdio_clk,
  inout             sdio_cmd,
  inout   [  3:0]   sdio_d,

  // hps-spim1-lcd

  output            spim1_ss0,
  output            spim1_clk,
  output            spim1_mosi,
  input             spim1_miso,

  // hps-usb

  input             usb1_clk,
  output            usb1_stp,
  input             usb1_dir,
  input             usb1_nxt,
  inout   [  7:0]   usb1_d,

  // hps-uart

  input             uart0_rx,
  output            uart0_tx,

  // board gpio

  output  [  3:0]   gpio_bd_o,
  input   [  7:0]   gpio_bd_i,

  // ad77681

  input            ad77681_spi_miso,
  output           ad77681_spi_mosi,
  output           ad77681_spi_sclk,
  output           ad77681_spi_cs,
  input            ad77681_drdy,

  output           ad77681_reset,
  inout            ad77681_sync_in,
  input            ad77681_fda_dis,
  input            ad77681_fda_mode,
  input            ad77681_dac_buf_en,
  inout            ad77681_io_int,

  // spi interface

  output           spi_csn,
  output           spi_clk,
  output           spi_mosi,
  input            spi_miso);

  // internal signals

  wire             sys_resetn;
  wire    [63:0]   gpio_i;
  wire    [63:0]   gpio_o;

  // instantiations

  assign gpio_i[63:39] = gpio_o[63:39];
  
  assign gpio_i[38] = ad77681_io_int;
  assign gpio_i[37] = ad77681_drdy;
  assign gpio_i[36] = ad77681_fda_dis;
  assign gpio_i[35] = ad77681_fda_mode;
  assign gpio_i[34] = ad77681_dac_buf_en;
  assign gpio_i[33] = ad77681_sync_in;
  assign ad77681_reset = gpio_o[32];

  assign gpio_i[31:0] = gpio_o[31:0];

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
    .sys_rst_reset_n (sys_resetn),
    .sys_hps_hps_io_hps_io_emac1_inst_TX_CLK (eth1_tx_clk),
    .sys_hps_hps_io_hps_io_emac1_inst_TXD0 (eth1_tx_d[0]),
    .sys_hps_hps_io_hps_io_emac1_inst_TXD1 (eth1_tx_d[1]),
    .sys_hps_hps_io_hps_io_emac1_inst_TXD2 (eth1_tx_d[2]),
    .sys_hps_hps_io_hps_io_emac1_inst_TXD3 (eth1_tx_d[3]),
    .sys_hps_hps_io_hps_io_emac1_inst_RXD0 (eth1_rx_d[0]),
    .sys_hps_hps_io_hps_io_emac1_inst_MDIO (eth1_mdio),
    .sys_hps_hps_io_hps_io_emac1_inst_MDC (eth1_mdc),
    .sys_hps_hps_io_hps_io_emac1_inst_RX_CTL (eth1_rx_ctl),
    .sys_hps_hps_io_hps_io_emac1_inst_TX_CTL (eth1_tx_ctl),
    .sys_hps_hps_io_hps_io_emac1_inst_RX_CLK (eth1_rx_clk),
    .sys_hps_hps_io_hps_io_emac1_inst_RXD1 (eth1_rx_d[1]),
    .sys_hps_hps_io_hps_io_emac1_inst_RXD2 (eth1_rx_d[2]),
    .sys_hps_hps_io_hps_io_emac1_inst_RXD3 (eth1_rx_d[3]),
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
    .sys_spi_MISO (spi_miso),
    .sys_spi_MOSI (spi_mosi),
    .sys_spi_SCLK (spi_clk),
    .sys_spi_SS_n (spi_csn),
    .spi_engine_sdo_sdo (ad77681_spi_mosi),
    .spi_engine_sdo_t_sdo_t (),
    .spi_engine_sdi_sdi (ad77681_spi_miso),
    .spi_engine_cs_cs (ad77681_spi_cs),
    .spi_engine_sclk_clk (ad77681_spi_sclk),
    .spi_engine_trigger_trigger (ad77681_drdy));

endmodule

// ***************************************************************************
// ***************************************************************************
