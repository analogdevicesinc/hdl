// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  // clock and resets

  input             sys_clk,
  input             sys_resetn,

  // hps-ddr4 (32)

  input             hps_ddr_ref_clk,
  output  [  0:0]   hps_ddr_clk_p,
  output  [  0:0]   hps_ddr_clk_n,
  output  [ 16:0]   hsp_ddr_a,
  output  [  1:0]   hps_ddr_ba,
  output  [  0:0]   hps_ddr_bg,
  output  [  0:0]   hps_ddr_cke,
  output  [  0:0]   hps_ddr_cs_n,
  output  [  0:0]   hps_ddr_odt,
  output  [  0:0]   hps_ddr_reset_n,
  output  [  0:0]   hps_ddr_act_n,
  output  [  0:0]   hps_ddr_par,
  input   [  0:0]   hps_ddr_alert_n,
  inout   [  3:0]   hps_ddr_dqs_p,
  inout   [  3:0]   hps_ddr_dqs_n,
  inout   [ 31:0]   hps_ddr_dq,
  inout   [  3:0]   hps_ddr_dbi_n,
  input             hps_ddr_rzq,

  // hps-ethernet

  input   [  0:0]   hps_eth_rxclk,
  input   [  0:0]   hps_eth_rxctl,
  input   [  3:0]   hps_eth_rxd,
  output  [  0:0]   hps_eth_txclk,
  output  [  0:0]   hps_eth_txctl,
  output  [  3:0]   hps_eth_txd,
  output  [  0:0]   hps_eth_mdc,
  inout   [  0:0]   hps_eth_mdio,

  // hps-sdio

  output  [  0:0]   hps_sdio_clk,
  inout   [  0:0]   hps_sdio_cmd,
  inout   [  7:0]   hps_sdio_d,

  // hps-usb

  input   [  0:0]   hps_usb_clk,
  input   [  0:0]   hps_usb_dir,
  input   [  0:0]   hps_usb_nxt,
  output  [  0:0]   hps_usb_stp,
  inout   [  7:0]   hps_usb_d,

  // hps-uart

  input   [  0:0]   hps_uart_rx,
  output  [  0:0]   hps_uart_tx,

  // hps-i2c (shared w fmc-a, fmc-b)

  inout   [  0:0]   hps_i2c_sda,
  inout   [  0:0]   hps_i2c_scl,

  // hps-gpio (max-v-u16)

  inout   [  3:0]   hps_gpio,
          
  // gpio (max-v-u21)

  input   [  7:0]   gpio_bd_i,
  output  [  3:0]   gpio_bd_o,

  // ad9361-interface

  input             rx_clk_in,
  input             rx_frame_in,
  input   [  5:0]   rx_data_in,
  output            tx_clk_out,
  output            tx_frame_out,
  output  [  5:0]   tx_data_out,
  output            enable,
  output            txnrx,

  output            gpio_resetb,
  output            gpio_sync,
  output            gpio_en_agc,
  output  [  3:0]   gpio_ctl,
  input   [  7:0]   gpio_status,

  output            spi_csn,
  output            spi_clk,
  output            spi_mosi,
  input             spi_miso);

  // internal signals

  wire    [ 31:0]   gpio_i;
  wire    [ 31:0]   gpio_o;

  // gpio (ad9361)

  assign gpio_i[31:24] = gpio_o[31:24];
  assign gpio_i[23:16] = gpio_status;

  assign gpio_resetb = gpio_o[22];
  assign gpio_sync = gpio_o[21];
  assign gpio_en_agc = gpio_o[20];
  assign gpio_ctl = gpio_o[19:16];

  // gpio (max-v-u21)

  assign gpio_i[15:8] = gpio_o[15:8];
  assign gpio_i[ 7:0] = gpio_bd_i;

  assign gpio_bd_o = gpio_o[3:0];

  // instantiations

  system_bd i_system_bd (
    .ad9361_if_rx_clk_in_p (rx_clk_in),
    .ad9361_if_rx_clk_in_n (1'b0),
    .ad9361_if_rx_frame_in_p (rx_frame_in),
    .ad9361_if_rx_frame_in_n (1'b0),
    .ad9361_if_rx_data_in_p (rx_data_in),
    .ad9361_if_rx_data_in_n (6'd0),
    .ad9361_if_tx_clk_out_p (tx_clk_out),
    .ad9361_if_tx_clk_out_n (),
    .ad9361_if_tx_frame_out_p (tx_frame_out),
    .ad9361_if_tx_frame_out_n (),
    .ad9361_if_tx_data_out_p (tx_data_out),
    .ad9361_if_tx_data_out_n (),
    .ad9361_if_enable (enable),
    .ad9361_if_txnrx (txnrx),
    .delay_clk_clk (1'b0),
    .hps_ddr_mem_ck (hps_ddr_clk_p),
    .hps_ddr_mem_ck_n (hps_ddr_clk_n),
    .hps_ddr_mem_a (hsp_ddr_a),
    .hps_ddr_mem_act_n (hps_ddr_act_n),
    .hps_ddr_mem_ba (hps_ddr_ba),
    .hps_ddr_mem_bg (hps_ddr_bg),
    .hps_ddr_mem_cke (hps_ddr_cke),
    .hps_ddr_mem_cs_n (hps_ddr_cs_n),
    .hps_ddr_mem_odt (hps_ddr_odt),
    .hps_ddr_mem_reset_n (hps_ddr_reset_n),
    .hps_ddr_mem_par (hps_ddr_par),
    .hps_ddr_mem_alert_n (hps_ddr_alert_n),
    .hps_ddr_mem_dqs (hps_ddr_dqs_p),
    .hps_ddr_mem_dqs_n (hps_ddr_dqs_n),
    .hps_ddr_mem_dq (hps_ddr_dq),
    .hps_ddr_mem_dbi_n (hps_ddr_dbi_n),
    .hps_ddr_oct_oct_rzqin (hps_ddr_rzq),
    .hps_ddr_ref_clk_clk (hps_ddr_ref_clk),
    .hps_gpio_gp_in (gpio_i),
    .hps_gpio_gp_out (gpio_o),
    .hps_io_hps_io_phery_emac0_TX_CLK (hps_eth_txclk),
    .hps_io_hps_io_phery_emac0_TXD0 (hps_eth_txd[0]),
    .hps_io_hps_io_phery_emac0_TXD1 (hps_eth_txd[1]),
    .hps_io_hps_io_phery_emac0_TXD2 (hps_eth_txd[2]),
    .hps_io_hps_io_phery_emac0_TXD3 (hps_eth_txd[3]),
    .hps_io_hps_io_phery_emac0_RX_CTL (hps_eth_rxctl),
    .hps_io_hps_io_phery_emac0_TX_CTL (hps_eth_txctl),
    .hps_io_hps_io_phery_emac0_RX_CLK (hps_eth_rxclk),
    .hps_io_hps_io_phery_emac0_RXD0 (hps_eth_rxd[0]),
    .hps_io_hps_io_phery_emac0_RXD1 (hps_eth_rxd[1]),
    .hps_io_hps_io_phery_emac0_RXD2 (hps_eth_rxd[2]),
    .hps_io_hps_io_phery_emac0_RXD3 (hps_eth_rxd[3]),
    .hps_io_hps_io_phery_emac0_MDIO (hps_eth_mdio),
    .hps_io_hps_io_phery_emac0_MDC (hps_eth_mdc),
    .hps_io_hps_io_phery_sdmmc_CMD (hps_sdio_cmd),
    .hps_io_hps_io_phery_sdmmc_D0 (hps_sdio_d[0]),
    .hps_io_hps_io_phery_sdmmc_D1 (hps_sdio_d[1]),
    .hps_io_hps_io_phery_sdmmc_D2 (hps_sdio_d[2]),
    .hps_io_hps_io_phery_sdmmc_D3 (hps_sdio_d[3]),
    .hps_io_hps_io_phery_sdmmc_D4 (hps_sdio_d[4]),
    .hps_io_hps_io_phery_sdmmc_D5 (hps_sdio_d[5]),
    .hps_io_hps_io_phery_sdmmc_D6 (hps_sdio_d[6]),
    .hps_io_hps_io_phery_sdmmc_D7 (hps_sdio_d[7]),
    .hps_io_hps_io_phery_sdmmc_CCLK (hps_sdio_clk),
    .hps_io_hps_io_phery_usb0_DATA0 (hps_usb_d[0]),
    .hps_io_hps_io_phery_usb0_DATA1 (hps_usb_d[1]),
    .hps_io_hps_io_phery_usb0_DATA2 (hps_usb_d[2]),
    .hps_io_hps_io_phery_usb0_DATA3 (hps_usb_d[3]),
    .hps_io_hps_io_phery_usb0_DATA4 (hps_usb_d[4]),
    .hps_io_hps_io_phery_usb0_DATA5 (hps_usb_d[5]),
    .hps_io_hps_io_phery_usb0_DATA6 (hps_usb_d[6]),
    .hps_io_hps_io_phery_usb0_DATA7 (hps_usb_d[7]),
    .hps_io_hps_io_phery_usb0_CLK (hps_usb_clk),
    .hps_io_hps_io_phery_usb0_STP (hps_usb_stp),
    .hps_io_hps_io_phery_usb0_DIR (hps_usb_dir),
    .hps_io_hps_io_phery_usb0_NXT (hps_usb_nxt),
    .hps_io_hps_io_phery_uart1_RX (hps_uart_rx),
    .hps_io_hps_io_phery_uart1_TX (hps_uart_tx),
    .hps_io_hps_io_phery_i2c1_SDA (hps_i2c_sda),
    .hps_io_hps_io_phery_i2c1_SCL (hps_i2c_scl),
    .hps_io_hps_io_gpio_gpio1_io5 (hps_gpio[0]),
    .hps_io_hps_io_gpio_gpio1_io14 (hps_gpio[1]),
    .hps_io_hps_io_gpio_gpio1_io16 (hps_gpio[2]),
    .hps_io_hps_io_gpio_gpio1_io17 (hps_gpio[3]),
    .hps_spi0_mosi_o (spi_mosi),
    .hps_spi0_miso_i (spi_miso),
    .hps_spi0_ss_in_n (1'b1),
    .hps_spi0_mosi_oe (),
    .hps_spi0_ss0_n_o (spi_csn),
    .hps_spi0_ss1_n_o (),
    .hps_spi0_ss2_n_o (),
    .hps_spi0_ss3_n_o (),
    .hps_spi0_sclk_clk (spi_clk),
    .hps_spi1_mosi_o (),
    .hps_spi1_miso_i (1'b0),
    .hps_spi1_ss_in_n (1'b1),
    .hps_spi1_mosi_oe (),
    .hps_spi1_ss0_n_o (),
    .hps_spi1_ss1_n_o (),
    .hps_spi1_ss2_n_o (),
    .hps_spi1_ss3_n_o (),
    .hps_spi1_sclk_clk (),
    .sys_clk_clk (sys_clk),
    .sys_reset_reset_n (sys_resetn),
    .up_enable_up_enable (gpio_o[23]),
    .up_txnrx_up_txnrx (gpio_o[24]));

endmodule

// ***************************************************************************
// ***************************************************************************
