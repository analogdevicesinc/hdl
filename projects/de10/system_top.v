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

  input             sys_clk,

  // hps-ddr

  output  [ 14:0]   ddr3_a,
  output  [  2:0]   ddr3_ba,
  output            ddr3_reset_n,
  output            ddr3_ck_p,
  output            ddr3_ck_n,
  output            ddr3_cke,
  output            ddr3_cs_n,
  output            ddr3_ras_n,
  output            ddr3_cas_n,
  output            ddr3_we_n,
  inout   [ 31:0]   ddr3_dq,
  inout   [  3:0]   ddr3_dqs_p,
  inout   [  3:0]   ddr3_dqs_n,
  output  [  3:0]   ddr3_dm,
  output            ddr3_odt,
  input             ddr3_rzq,

  // hps-ethernet

  output            eth1_tx_clk,
  output            eth1_tx_ctl,
  output  [  3:0]   eth1_tx_d,
  input             eth1_rx_clk,
  input             eth1_rx_ctl,
  input   [  3:0]   eth1_rx_d,
  output            eth1_mdc,
  inout             eth1_mdio,

  // hps-qspi

  output            qspi_ss0,
  output            qspi_clk,
  inout   [  3:0]   qspi_io,

  // hps-sdio

  output            sdio_clk,
  inout             sdio_cmd,
  inout   [  3:0]   sdio_d,

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

  inout   [ 35:0]   gpio_0,
  inout   [ 35:0]   gpio_1,
  inout   [ 13:0]   gpio_bd,
  inout             hps_gpio_led,
  inout             hps_gpio_pb,

  // adxl345 iic interface

  inout             adxl345_scl,
  inout             adxl345_sda,
  inout             adxl345_int,

  // ltc connector iic/spi interface

  inout             ltc_i2c_spi_sel,
  inout             ltc_i2c_scl,
  inout             ltc_i2c_sda,
  output            ltc_spi_csn,
  output            ltc_spi_clk,
  output            ltc_spi_mosi,
  input             ltc_spi_miso,

  output            hdmi_out_clk,
  output            hdmi_vsync,
  output            hdmi_hsync,
  output            hdmi_data_e,
  output  [ 23:0]   hdmi_data,

  inout             hdmi_i2c_scl,
  inout             hdmi_i2c_sda,
  inout             hdmi_i2s,
  inout             hdmi_lrclk,
  inout             hdmi_mclk,
  inout             hdmi_sclk,

  // arduino interface

  inout             arduino_i2c_scl,
  inout             arduino_i2c_sda,
  output  [  3:0]   arduino_spi_csn,
  output            arduino_spi_clk,
  output            arduino_spi_mosi,
  input             arduino_spi_miso,
  inout             arduino_reset_n,
  inout   [  6:0]   arduino_gpio);

  // internal signals

  wire              sys_resetn;
  wire              i2c2_scl_oe;
  wire              i2c2_scl;
  wire              i2c2_sda_oe;
  wire              i2c2_sda;

  wire              i2c3_scl_oe;
  wire              i2c3_scl;
  wire              i2c3_sda_oe;
  wire              i2c3_sda;

  wire              hdmi_valid_s;
  wire              hdmi_ready_s;
  wire  [ 63:0]     hdmi_data_s;
  wire              hdmi_fs;

  // instantiations

  ALT_IOBUF iobuf_i2c2_scl (
    .i (1'b0),
    .oe (i2c2_scl_oe),
    .o (i2c2_scl),
    .io (arduino_i2c_scl));

  ALT_IOBUF iobuf_i2c2_sda (
    .i (1'b0),
    .oe (i2c2_sda_oe),
    .o (i2c2_sda),
    .io (arduino_i2c_sda));

  ALT_IOBUF iobuf_i2c3_scl (
    .i (1'b0),
    .oe (i2c3_scl_oe),
    .o (i2c3_scl),
    .io (hdmi_i2c_scl));

  ALT_IOBUF iobuf_i2c3_sda (
    .i (1'b0),
    .oe (i2c3_sda_oe),
    .o (i2c3_sda),
    .io (hdmi_i2c_sda));

  system_bd i_system_bd (
    .sys_clk_clk (sys_clk),
    .sys_gpio_0_0_export (gpio_0[31:0]),
    .sys_gpio_0_1_export (gpio_0[35:32]),
    .sys_gpio_1_0_export (gpio_1[31:0]),
    .sys_gpio_1_1_export (gpio_1[35:32]),
    .sys_gpio_arduino_export ({arduino_reset_n, arduino_gpio}),
    .sys_gpio_bd_export (gpio_bd),
    .sys_hps_h2f_reset_reset_n (sys_resetn),
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
    .sys_hps_hps_io_hps_io_qspi_inst_IO0 (qspi_io[0]),
    .sys_hps_hps_io_hps_io_qspi_inst_IO1 (qspi_io[1]),
    .sys_hps_hps_io_hps_io_qspi_inst_IO2 (qspi_io[2]),
    .sys_hps_hps_io_hps_io_qspi_inst_IO3 (qspi_io[3]),
    .sys_hps_hps_io_hps_io_qspi_inst_SS0 (qspi_ss0),
    .sys_hps_hps_io_hps_io_qspi_inst_CLK (qspi_clk),
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
    .sys_hps_hps_io_hps_io_spim1_inst_CLK (ltc_spi_clk),
    .sys_hps_hps_io_hps_io_spim1_inst_MOSI (ltc_spi_mosi),
    .sys_hps_hps_io_hps_io_spim1_inst_MISO (ltc_spi_miso),
    .sys_hps_hps_io_hps_io_spim1_inst_SS0 (ltc_spi_csn),
    .sys_hps_hps_io_hps_io_uart0_inst_RX (uart0_rx),
    .sys_hps_hps_io_hps_io_uart0_inst_TX (uart0_tx),
    .sys_hps_hps_io_hps_io_i2c0_inst_SDA (adxl345_sda),
    .sys_hps_hps_io_hps_io_i2c0_inst_SCL (adxl345_scl),
    .sys_hps_hps_io_hps_io_i2c1_inst_SDA (ltc_i2c_sda),
    .sys_hps_hps_io_hps_io_i2c1_inst_SCL (ltc_i2c_scl),
    .sys_hps_hps_io_hps_io_gpio_inst_GPIO40 (ltc_i2c_spi_sel),
    .sys_hps_hps_io_hps_io_gpio_inst_GPIO53 (hps_gpio_led),
    .sys_hps_hps_io_hps_io_gpio_inst_GPIO54 (hps_gpio_pb),
    .sys_hps_hps_io_hps_io_gpio_inst_GPIO61 (adxl345_int),
    .sys_hps_i2c2_out_data(i2c2_sda_oe),
    .sys_hps_i2c2_sda(i2c2_sda),
    .sys_hps_i2c2_clk_clk(i2c2_scl_oe),
    .sys_hps_i2c2_scl_in_clk(i2c2_scl),
    .sys_hps_irq_in_irq (1'd0),
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
    .sys_hps_spim0_txd (arduino_spi_mosi),
    .sys_hps_spim0_rxd (arduino_spi_miso),
    .sys_hps_spim0_ss_in_n (1'b1),
    .sys_hps_spim0_ssi_oe_n (),
    .sys_hps_spim0_ss_0_n (arduino_spi_csn[0]),
    .sys_hps_spim0_ss_1_n (arduino_spi_csn[1]),
    .sys_hps_spim0_ss_2_n (arduino_spi_csn[2]),
    .sys_hps_spim0_ss_3_n (arduino_spi_csn[3]),
    .sys_hps_spim0_clk_clk (arduino_spi_clk),
    .axi_hdmi_tx_0_hdmi_if_h_clk (hdmi_out_clk),
    .axi_hdmi_tx_0_hdmi_if_h16_hsync (),
    .axi_hdmi_tx_0_hdmi_if_h16_vsync (),
    .axi_hdmi_tx_0_hdmi_if_h16_data_e (),
    .axi_hdmi_tx_0_hdmi_if_h16_data (),
    .axi_hdmi_tx_0_hdmi_if_h16_es_data (),
    .axi_hdmi_tx_0_hdmi_if_h24_hsync (hdmi_hsync),
    .axi_hdmi_tx_0_hdmi_if_h24_vsync (hdmi_vsync),
    .axi_hdmi_tx_0_hdmi_if_h24_data_e (hdmi_data_e),
    .axi_hdmi_tx_0_hdmi_if_h24_data (hdmi_data),
    .axi_hdmi_tx_0_hdmi_if_h36_hsync (),
    .axi_hdmi_tx_0_hdmi_if_h36_vsync (),
    .axi_hdmi_tx_0_hdmi_if_h36_data_e (),
    .axi_hdmi_tx_0_hdmi_if_h36_data (),
    .axi_hdmi_tx_0_vdma_if_valid (hdmi_valid_s),
    .axi_hdmi_tx_0_vdma_if_data (hdmi_data_s),
    .axi_hdmi_tx_0_vdma_if_ready (hdmi_ready_s),
    .axi_hdmi_tx_0_if_vdma_fs_vdma_fs (hdmi_fs),
    .axi_hdmi_tx_0_if_vdma_fs_ret_vdma_fs_ret (hdmi_fs),
    .axi_dmac_0_if_m_axis_valid_valid (hdmi_valid_s),
    .axi_dmac_0_if_m_axis_data_data (hdmi_data_s),
    .axi_dmac_0_if_m_axis_ready_ready (hdmi_ready_s),
    .sys_hps_i2c3_scl_in_clk (i2c3_scl),
    .sys_hps_i2c3_clk_clk (i2c3_scl_oe),
    .sys_hps_i2c3_out_data (i2c3_sda_oe),
    .sys_hps_i2c3_sda (i2c3_sda),
    .sys_rst_reset_n (sys_resetn)
  );

endmodule

// ***************************************************************************
// ***************************************************************************
