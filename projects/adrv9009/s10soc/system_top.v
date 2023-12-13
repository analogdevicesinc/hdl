// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
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

  input             sys_clk,
  input             fpga_resetn,
  input             hps_ref_clk,

  // hps-ddr4 (72)

  input             hps_ddr_ref_clk,
  input             hps_ddr_rzq,
  output  [ 16:0]   hps_ddr_a,
  output  [  0:0]   hps_ddr_act_n,
  input   [  0:0]   hps_ddr_alert_n,
  output  [  1:0]   hps_ddr_ba,
  output  [  0:0]   hps_ddr_bg,
  output  [  0:0]   hps_ddr_ck,
  output  [  0:0]   hps_ddr_ck_n,
  output  [  0:0]   hps_ddr_cke,
  output  [  0:0]   hps_ddr_odt,
  output  [  0:0]   hps_ddr_par,
  output  [  0:0]   hps_ddr_cs_n,
  output  [  0:0]   hps_ddr_reset_n,
  inout   [  8:0]   hps_ddr_dqs_p,
  inout   [  8:0]   hps_ddr_dqs_n,
  inout   [  8:0]   hps_ddr_dbi_n,
  inout   [ 71:0]   hps_ddr_dq,

  // hps-ethernet

  input   [  0:0]   hps_emac_rx_clk,
  input   [  0:0]   hps_emac_rx_ctl,
  input   [  3:0]   hps_emac_rx,
  output  [  0:0]   hps_emac_tx_clk,
  output  [  0:0]   hps_emac_tx_ctl,
  output  [  3:0]   hps_emac_tx,
  output  [  0:0]   hps_emac_mdc,
  inout   [  0:0]   hps_emac_mdio,

  // hps-usb

  input   [  0:0]   hps_usb_clk,
  input   [  0:0]   hps_usb_dir,
  input   [  0:0]   hps_usb_nxt,
  output  [  0:0]   hps_usb_stp,
  inout   [  7:0]   hps_usb_data,

  // hps-uart

  input   [  0:0]   hps_uart_rx,
  output  [  0:0]   hps_uart_tx,

  // hps-i2c (shared w fmc-a, fmc-b)

  inout   [  0:0]   hps_i2c_sda,
  inout   [  0:0]   hps_i2c_scl,

  // fpga-gpio motherboard (led/dpsw/button)

  input   [  3:0]   fpga_gpio_dpsw,
  input   [  3:0]   fpga_gpio_btn,
  output  [  3:0]   fpga_gpio_led,

  // sdmmc-interface

  output            hps_sdmmc_clk,
  inout             hps_sdmmc_cmd,
  inout   [  3:0]   hps_sdmmc_data,

  // jtag-interface

  input             hps_jtag_tck,
  input             hps_jtag_tms,
  output            hps_jtag_tdo,
  input             hps_jtag_tdi,

  // hps-OOBE daughter card peripherals

  inout             hps_gpio_eth_irq,
  inout             hps_gpio_usb_oci,
  inout   [  1:0]   hps_gpio_btn,
  inout   [  2:0]   hps_gpio_led,

  // adrv9009-interface

  input             ref_clk0,
  input             ref_clk1,
  input   [  3:0]   rx_serial_data,
  output  [  3:0]   tx_serial_data,
  output            rx_sync,
  output            rx_os_sync,
  input             tx_sync,
  input             tx_sync_1,
  input             sysref,

  output            ad9528_reset_b,
  output            ad9528_sysref_req,
  output            adrv9009_tx1_enable,
  output            adrv9009_tx2_enable,
  output            adrv9009_rx1_enable,
  output            adrv9009_rx2_enable,
  output            adrv9009_test,
  output            adrv9009_reset_b,
  input             adrv9009_gpint,

  inout   [ 18:0]   adrv9009_gpio,

  output            spi_csn_ad9528,
  output            spi_csn_adrv9009,
  output            spi_clk,
  output            spi_mosi,
  input             spi_miso
);

  // internal signals

  wire    [ 63:0]   gpio_i;
  wire    [ 63:0]   gpio_o;
  wire    [  7:0]   spi_csn_s;
  wire              dac_fifo_bypass;
  wire              ninit_done_s;
  wire              h2f_reset_s;
  wire              sys_resetn_s;

  // motherboard-gpio

  assign gpio_i[3:0]   = fpga_gpio_dpsw;
  assign gpio_i[7:4]   = fpga_gpio_btn;
  assign gpio_i[31:11]  = gpio_o[31:11];
  assign fpga_gpio_led = gpio_o[10:8];

  // assignments

  assign spi_csn_ad9528 = spi_csn_s[0];
  assign spi_csn_adrv9009 = spi_csn_s[1];

  // gpio (adrv9009)

  assign gpio_i[50:32] = gpio_o[50:32];
  assign gpio_i[51:51] = adrv9009_gpint;
  assign gpio_i[59:52] = gpio_o[59:52];
  assign gpio_i[63:60] = gpio_o[63:60];

  assign dac_fifo_bypass     = gpio_o[60];
  assign ad9528_reset_b      = gpio_o[59];
  assign ad9528_sysref_req   = gpio_o[58];
  assign adrv9009_tx1_enable = gpio_o[57];
  assign adrv9009_tx2_enable = gpio_o[56];
  assign adrv9009_rx1_enable = gpio_o[55];
  assign adrv9009_rx2_enable = gpio_o[54];
  assign adrv9009_test       = gpio_o[53];
  assign adrv9009_reset_b    = gpio_o[52];

  // system reset is a combination of external reset, HPS reset and S10 init
  // done reset
  assign sys_resetn_s = fpga_resetn & ~h2f_reset_s & ~ninit_done_s;

  // instantiations

  system_bd i_system_bd (
    .sys_clk_clk                          ( sys_clk ),
    .sys_rst_reset_n                      ( sys_resetn_s ),
    .h2f_reset_reset                      ( h2f_reset_s ),
    .rst_ninit_done_ninit_done            ( ninit_done_s ),
    .sys_gpio_bd_in_port                  ( gpio_i[31: 0] ),
    .sys_gpio_bd_out_port                 ( gpio_o[31: 0] ),
    .sys_gpio_in_export                   ( gpio_i[63:32] ),
    .sys_gpio_out_export                  ( gpio_o[63:32] ),
    .sys_hps_io_hps_io_phery_emac0_TX_CLK ( hps_emac_tx_clk ),
    .sys_hps_io_hps_io_phery_emac0_TXD0   ( hps_emac_tx[0] ),
    .sys_hps_io_hps_io_phery_emac0_TXD1   ( hps_emac_tx[1] ),
    .sys_hps_io_hps_io_phery_emac0_TXD2   ( hps_emac_tx[2] ),
    .sys_hps_io_hps_io_phery_emac0_TXD3   ( hps_emac_tx[3] ),
    .sys_hps_io_hps_io_phery_emac0_RX_CTL ( hps_emac_rx_ctl ),
    .sys_hps_io_hps_io_phery_emac0_TX_CTL ( hps_emac_tx_ctl ),
    .sys_hps_io_hps_io_phery_emac0_RX_CLK ( hps_emac_rx_clk ),
    .sys_hps_io_hps_io_phery_emac0_RXD0   ( hps_emac_rx[0] ),
    .sys_hps_io_hps_io_phery_emac0_RXD1   ( hps_emac_rx[1] ),
    .sys_hps_io_hps_io_phery_emac0_RXD2   ( hps_emac_rx[2] ),
    .sys_hps_io_hps_io_phery_emac0_RXD3   ( hps_emac_rx[3] ),
    .sys_hps_io_hps_io_phery_emac0_MDIO   ( hps_emac_mdio ),
    .sys_hps_io_hps_io_phery_emac0_MDC    ( hps_emac_mdc ),
    .sys_hps_io_hps_io_phery_sdmmc_CMD    ( hps_sdmmc_cmd ),
    .sys_hps_io_hps_io_phery_sdmmc_D0     ( hps_sdmmc_data[0]),
    .sys_hps_io_hps_io_phery_sdmmc_D1     ( hps_sdmmc_data[1]),
    .sys_hps_io_hps_io_phery_sdmmc_D2     ( hps_sdmmc_data[2]),
    .sys_hps_io_hps_io_phery_sdmmc_D3     ( hps_sdmmc_data[3]),
    .sys_hps_io_hps_io_phery_sdmmc_CCLK   ( hps_sdmmc_clk ),
    .sys_hps_io_hps_io_phery_usb0_DATA0   ( hps_usb_data[0] ),
    .sys_hps_io_hps_io_phery_usb0_DATA1   ( hps_usb_data[1] ),
    .sys_hps_io_hps_io_phery_usb0_DATA2   ( hps_usb_data[2] ),
    .sys_hps_io_hps_io_phery_usb0_DATA3   ( hps_usb_data[3] ),
    .sys_hps_io_hps_io_phery_usb0_DATA4   ( hps_usb_data[4] ),
    .sys_hps_io_hps_io_phery_usb0_DATA5   ( hps_usb_data[5] ),
    .sys_hps_io_hps_io_phery_usb0_DATA6   ( hps_usb_data[6] ),
    .sys_hps_io_hps_io_phery_usb0_DATA7   ( hps_usb_data[7] ),
    .sys_hps_io_hps_io_phery_usb0_CLK     ( hps_usb_clk ),
    .sys_hps_io_hps_io_phery_usb0_STP     ( hps_usb_stp ),
    .sys_hps_io_hps_io_phery_usb0_DIR     ( hps_usb_dir ),
    .sys_hps_io_hps_io_phery_usb0_NXT     ( hps_usb_nxt ),
    .sys_hps_io_hps_io_phery_uart0_RX     ( hps_uart_rx ),
    .sys_hps_io_hps_io_phery_uart0_TX     ( hps_uart_tx ),
    .sys_hps_io_hps_io_phery_i2c1_SDA     ( hps_i2c_sda ),
    .sys_hps_io_hps_io_phery_i2c1_SCL     ( hps_i2c_scl ),
    .sys_hps_io_hps_io_gpio_gpio1_io0     ( hps_gpio_eth_irq ),
    .sys_hps_io_hps_io_gpio_gpio1_io1     ( hps_gpio_usb_oci ),
    .sys_hps_io_hps_io_gpio_gpio1_io4     ( hps_gpio_btn[0] ),
    .sys_hps_io_hps_io_gpio_gpio1_io5     ( hps_gpio_btn[1] ),
    .sys_hps_io_hps_io_jtag_tck           ( hps_jtag_tck ),
    .sys_hps_io_hps_io_jtag_tms           ( hps_jtag_tms ),
    .sys_hps_io_hps_io_jtag_tdo           ( hps_jtag_tdo ),
    .sys_hps_io_hps_io_jtag_tdi           ( hps_jtag_tdi ),
    .sys_hps_io_hps_io_hps_ocs_clk        ( hps_ref_clk ),
    .sys_hps_io_hps_io_gpio_gpio1_io19    ( hps_gpio_led[1] ),
    .sys_hps_io_hps_io_gpio_gpio1_io20    ( hps_gpio_led[0] ),
    .sys_hps_io_hps_io_gpio_gpio1_io21    ( hps_gpio_led[2] ),
    .sys_hps_ddr_ref_clk_clk              ( hps_ddr_ref_clk ),
    .sys_hps_ddr_oct_oct_rzqin            ( hps_ddr_rzq ),
    .sys_hps_ddr_mem_ck                   ( hps_ddr_ck ),
    .sys_hps_ddr_mem_ck_n                 ( hps_ddr_ck_n ),
    .sys_hps_ddr_mem_a                    ( hps_ddr_a ),
    .sys_hps_ddr_mem_act_n                ( hps_ddr_act_n ),
    .sys_hps_ddr_mem_ba                   ( hps_ddr_ba ),
    .sys_hps_ddr_mem_bg                   ( hps_ddr_bg ),
    .sys_hps_ddr_mem_cke                  ( hps_ddr_cke ),
    .sys_hps_ddr_mem_cs_n                 ( hps_ddr_cs_n ),
    .sys_hps_ddr_mem_odt                  ( hps_ddr_odt ),
    .sys_hps_ddr_mem_reset_n              ( hps_ddr_reset_n ),
    .sys_hps_ddr_mem_par                  ( hps_ddr_par ),
    .sys_hps_ddr_mem_alert_n              ( hps_ddr_alert_n ),
    .sys_hps_ddr_mem_dqs                  ( hps_ddr_dqs_p ),
    .sys_hps_ddr_mem_dqs_n                ( hps_ddr_dqs_n ),
    .sys_hps_ddr_mem_dq                   ( hps_ddr_dq ),
    .sys_hps_ddr_mem_dbi_n                ( hps_ddr_dbi_n ),
    .sys_spi_MISO                         ( spi_miso ),
    .sys_spi_MOSI                         ( spi_mosi ),
    .sys_spi_SCLK                         ( spi_clk ),
    .sys_spi_SS_n                         ( spi_csn_s ),
    .adrv9009_gpio_export                 ( adrv9009_gpio ),
    .tx_serial_data_tx_serial_data        ( tx_serial_data ),
    .tx_fifo_bypass_bypass                ( dac_fifo_bypass ),
    .tx_ref_clk_clk                       ( ref_clk1 ),
    .tx_sync_export                       ( tx_sync ),
    .tx_sysref_export                     ( sysref ),
    .rx_serial_data_rx_serial_data        ( rx_serial_data[1:0] ),
    .rx_os_serial_data_rx_serial_data     ( rx_serial_data[3:2] ),
    .rx_os_ref_clk_clk                    ( ref_clk1 ),
    .rx_os_sync_export                    ( rx_os_sync ),
    .rx_os_sysref_export                  ( sysref ),
    .rx_ref_clk_clk                       ( ref_clk1 ),
    .rx_sync_export                       ( rx_sync ),
    .rx_sysref_export                     ( sysref ));

endmodule
