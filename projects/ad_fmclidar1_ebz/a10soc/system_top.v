// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
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

  // clock and resets

  input                   sys_clk,
  input                   sys_resetn,

  // hps-ddr4 (32)

  input                   hps_ddr_ref_clk,
  output  [  0:0]         hps_ddr_clk_p,
  output  [  0:0]         hps_ddr_clk_n,
  output  [ 16:0]         hps_ddr_a,
  output  [  1:0]         hps_ddr_ba,
  output  [  0:0]         hps_ddr_bg,
  output  [  0:0]         hps_ddr_cke,
  output  [  0:0]         hps_ddr_cs_n,
  output  [  0:0]         hps_ddr_odt,
  output  [  0:0]         hps_ddr_reset_n,
  output  [  0:0]         hps_ddr_act_n,
  output  [  0:0]         hps_ddr_par,
  input   [  0:0]         hps_ddr_alert_n,
  inout   [  3:0]         hps_ddr_dqs_p,
  inout   [  3:0]         hps_ddr_dqs_n,
  inout   [ 31:0]         hps_ddr_dq,
  inout   [  3:0]         hps_ddr_dbi_n,
  input                   hps_ddr_rzq,

  // hps-ethernet

  input   [  0:0]         hps_eth_rxclk,
  input   [  0:0]         hps_eth_rxctl,
  input   [  3:0]         hps_eth_rxd,
  output  [  0:0]         hps_eth_txclk,
  output  [  0:0]         hps_eth_txctl,
  output  [  3:0]         hps_eth_txd,
  output  [  0:0]         hps_eth_mdc,
  inout   [  0:0]         hps_eth_mdio,

  // hps-sdio

  output  [  0:0]         hps_sdio_clk,
  inout   [  0:0]         hps_sdio_cmd,
  inout   [  7:0]         hps_sdio_d,

  // hps-usb

  input   [  0:0]         hps_usb_clk,
  input   [  0:0]         hps_usb_dir,
  input   [  0:0]         hps_usb_nxt,
  output  [  0:0]         hps_usb_stp,
  inout   [  7:0]         hps_usb_d,

  // hps-uart

  input   [  0:0]         hps_uart_rx,
  output  [  0:0]         hps_uart_tx,

  // hps-i2c (shared w fmc-a, fmc-b)

  inout   [  0:0]         hps_i2c_sda,
  inout   [  0:0]         hps_i2c_scl,

  // hps-gpio (max-v-u16)

  inout   [  3:0]         hps_gpio,

  // gpio (max-v-u21)

  input   [  7:0]         gpio_bd_i,
  output  [  3:0]         gpio_bd_o,

  // lane interface

  input                   rx_ref_clk,
  input                   rx_device_clk,
  input                   rx_sysref,
  output                  rx_sync_0,
  output                  rx_sync_1,
  input       [ 3:0]      rx_data,

  input                   adc_fdb,
  input                   adc_fda,
  output                  adc_pdwn,

  // DAQ board's ADC SPI

  output                  spi_adc_csn,
  output                  spi_adc_clk,
  output                  spi_adc_mosi,
  input                   spi_adc_miso,

  // DAQ board's clock chip

  output                  spi_clkgen_csn,
  output                  spi_clkgen_clk,
  output                  spi_clkgen_mosi,
  input                   spi_clkgen_miso,

  // DAQ board's vco chip

  output                  spi_vco_csn,
  output                  spi_vco_clk,
  output                  spi_vco_mosi,

  // AFE board's DAC

  inout                   afe_dac_sda,
  inout                   afe_dac_scl,
  output                  afe_dac_clr_n,
  output                  afe_dac_load,

  // AFE board's ADC

  output                  afe_adc_sclk,
  output                  afe_adc_scn,
  input                   afe_adc_sdi,
  output                  afe_adc_convst,

  // Laser driver differential line

  output                  laser_driver,

  output                  laser_driver_en_n,
  input                   laser_driver_otw_n,

  // GPIO's for the laser board

  inout       [13:0]      laser_gpio,

  // Vref selects for AFE board

  output      [ 7:0]      tia_chsel
);

  // internal signals

  wire  [63:0]    gpio_o;
  wire  [63:0]    gpio_i;
  wire            sys_resetn_s;
  wire            rx_sync_s;

  // assignments

  // gpio in & out are separate cores

  assign gpio_i[51:38] = gpio_o[51:38];

  assign afe_adc_convst = gpio_o[37];
  assign afe_dac_load = gpio_o[36];
  assign afe_dac_clr_n = gpio_o[35];
  assign adc_pdwn = gpio_o[34];

  assign gpio_i[33] = adc_fda;
  assign gpio_i[32] = adc_fdb;

  // board stuff (max-v-u21)

  assign gpio_i[31:12] = gpio_o[31:12];
  assign gpio_i[11: 4] = gpio_bd_i;
  assign gpio_i[ 3: 0] = gpio_o[ 3: 0];
  assign gpio_bd_o = gpio_o[3:0];

  assign rx_sync_0 = rx_sync_s;
  assign rx_sync_1 = rx_sync_s;

  // peripheral reset

  assign sys_resetn_s = sys_resetn & sys_hps_resetn;

  // instantiations

  wire adc_tia_chsel_en_s;
  wire [31:0] adc_data_tia_chsel_s;

  util_tia_chsel #(
    .DATA_WIDTH (32)
  ) i_util_tia_chsel (
    .clk (rx_device_clk),
    .adc_tia_chsel_en (laser_driver),
    .adc_data_tia_chsel (adc_data_tia_chsel_s),
    .tia_chsel (tia_chsel));

  wire dma_sync_s;
  wire fifo_wr_en_s;

  util_axis_syncgen #(
    .ASYNC_SYNC (1)
  ) i_util_axis_syncgen (
    .s_axis_aclk (rx_device_clk),
    .s_axis_aresetn (1'b1),
    .s_axis_ready (1'b1),
    .s_axis_valid (fifo_wr_en_s),
    .ext_sync (laser_driver),
    .s_axis_sync (dma_sync_s));

  // IO Buffers for I2C

  wire i2c_0_scl_out;
  wire i2c_0_scl_in;
  wire i2c_0_sda_in;
  wire i2c_0_sda_oe;

  ALT_IOBUF scl_iobuf (
    .i(1'b0),
    .oe(i2c_0_scl_out),
    .o(i2c_0_scl_in),
    .io(afe_dac_scl));

  ALT_IOBUF sda_iobuf (
    .i(1'b0),
    .oe(i2c_0_sda_oe),
    .o(i2c_0_sda_in),
    .io(afe_dac_sda));

  // Block design instance

  system_bd i_system_bd (
    .sys_clk_clk (sys_clk),
    .sys_gpio_bd_in_port (gpio_i[31:0]),
    .sys_gpio_bd_out_port (gpio_o[31:0]),
    .sys_gpio_in_export (gpio_i[63:32]),
    .sys_gpio_out_export (gpio_o[63:32]),
    .pr_rom_data_nc_rom_data('h0),
    .sys_hps_ddr_mem_ck (hps_ddr_clk_p),
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
    // AFE's DAC I2C interface
    .sys_hps_i2c_0_sda_i (i2c_0_sda_in),
    .sys_hps_i2c_0_sda_oe (i2c_0_sda_oe),
    .sys_hps_i2c_0_scl_out_clk (i2c_0_scl_out),
    .sys_hps_i2c_0_scl_in_clk (i2c_0_scl_in),
    // SPI interface for ADC (AD9694)
    .sys_spi_MISO (spi_adc_miso),
    .sys_spi_MOSI (spi_adc_mosi),
    .sys_spi_SCLK (spi_adc_clk),
    .sys_spi_SS_n (spi_adc_csn),
    // SPI interface for DAQ's clock chip
    .sys_spi_clockgen_MISO (spi_clkgen_miso),
    .sys_spi_clockgen_MOSI (spi_clkgen_mosi),
    .sys_spi_clockgen_SCLK (spi_clkgen_clk),
    .sys_spi_clockgen_SS_n (spi_clkgen_csn),
    // SPI interface for DAQ's VCO
    .sys_spi_vco_MISO (spi_vco_mosi),
    .sys_spi_vco_MOSI (spi_vco_mosi),
    .sys_spi_vco_SCLK (spi_vco_clk),
    .sys_spi_vco_SS_n (spi_vco_csn),
    // SPI interface for AFE's ADC chip
    .sys_spi_afe_adc_MISO (afe_adc_sdi),
    .sys_spi_afe_adc_MOSI (),
    .sys_spi_afe_adc_SCLK (afe_adc_sclk),
    .sys_spi_afe_adc_SS_n (afe_adc_scn),
    // JESD204B for AD9694
    .rx_data_rx_serial_data (rx_data),
    .rx_ref_clk_clk (rx_ref_clk),
    .rx_sync_export (rx_sync_s),
    .rx_sysref_export (rx_sysref),
    .rx_device_clk_clk(rx_device_clk),
    // laser driver related ports
    .laser_driver_driver_pulse (laser_driver),
    .laser_driver_en_n_driver_en_n (laser_driver_en_n),
    .laser_driver_otw_n_driver_otw_n (laser_driver_otw_n),
    .tia_chsel_tia_chsel (tia_chsel),
    .laser_gpio_export (laser_gpio),
    // Dummy ADC channel for TIA
    .adc_data_tia_chsel_data (adc_data_tia_chsel_s),
    .adc_data_tia_chsel_valid (1'b1),
    .adc_data_tia_chsel_enable (1'b1),
    // DMA synchronization
    .fifo_wr_en_out_valid (fifo_wr_en_s),
    .fifo_wr_en_in_valid (fifo_wr_en_s),
    .fifo_wr_sync_sync (dma_sync_s));

endmodule
