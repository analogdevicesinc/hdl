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

  // hps

  output  [ 14:0]   ddr3_a,
  output  [  2:0]   ddr3_ba,
  output            ddr3_ck_p,
  output            ddr3_ck_n,
  output            ddr3_cke,
  output            ddr3_cs_n,
  output            ddr3_ras_n,
  output            ddr3_cas_n,
  output            ddr3_we_n,
  output            ddr3_reset_n,
  inout   [ 39:0]   ddr3_dq,
  inout   [  4:0]   ddr3_dqs_p,
  inout   [  4:0]   ddr3_dqs_n,
  output            ddr3_odt,
  output  [  4:0]   ddr3_dm,
  input             ddr3_oct_rzqin,
  output            eth1_tx_clk,
  output            eth1_tx_ctl,
  output            eth1_txd0,
  output            eth1_txd1,
  output            eth1_txd2,
  output            eth1_txd3,
  input             eth1_rx_clk,
  input             eth1_rx_ctl,
  input             eth1_rxd0,
  input             eth1_rxd1,
  input             eth1_rxd2,
  input             eth1_rxd3,
  output            eth1_mdc,
  inout             eth1_mdio,
  output            qspi_ss0,
  output            qspi_clk,
  inout             qspi_io0,
  inout             qspi_io1,
  inout             qspi_io2,
  inout             qspi_io3,
  output            sdio_clk,
  inout             sdio_cmd,
  inout             sdio_d0,
  inout             sdio_d1,
  inout             sdio_d2,
  inout             sdio_d3,
  input             usb1_clk,
  output            usb1_stp,
  input             usb1_dir,
  input             usb1_nxt,
  inout             usb1_d0,
  inout             usb1_d1,
  inout             usb1_d2,
  inout             usb1_d3,
  inout             usb1_d4,
  inout             usb1_d5,
  inout             usb1_d6,
  inout             usb1_d7,
  input             uart0_rx,
  output            uart0_tx,

  // board gpio

  output  [  3:0]   gpio_bd_o,
  input   [  7:0]   gpio_bd_i,

  // i2c

  inout             fmca_scl,
  inout             fmca_sda,

  // lane interface

  input             ref_clk,
  input   [  3:0]   rx_data,
  output            rx_sync,
  output            rx_sysref,

  // spi

  output            spi_csn,
  output            spi_clk,
  inout             spi_sdio);

  // internal signals

  wire              sys_cpu_clk;
  wire              sys_dma_clk;
  wire              sys_rstn;
  wire              rx_clk;
  wire    [  3:0]   rx_ip_sof;
  wire    [127:0]   rx_ip_data;
  wire    [ 63:0]   gpio_i;
  wire    [ 63:0]   gpio_o;
  wire              spi_mosi;
  wire              spi_miso;
  wire              fmca_scl_oe;
  wire              fmca_sda_oe;

  // i2c

  assign fmca_scl = (fmca_scl_oe == 1'b1) ? 1'b0 : 1'bz;
  assign fmca_sda = (fmca_sda_oe == 1'b1) ? 1'b0 : 1'bz;

  // gpio

  assign gpio_i[63: 8] = gpio_o[63:8];
  assign gpio_i[ 7: 0] = gpio_bd_i;

  assign gpio_bd_o = gpio_o[11:8];

  // sysref

  ad_sysref_gen #(.SYSREF_PERIOD(64)) i_sysref (
    .core_clk (rx_clk),
    .sysref_en (gpio_o[32]),
    .sysref_out (rx_sysref));

  // instantiations

  fmcjesdadc1_spi i_fmcjesdadc1_spi (
    .spi_csn (spi_csn),
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
    .sys_clk_clk (sys_cpu_clk),
    .sys_dma_clk_clk (sys_dma_clk),
    .sys_dma_rst_reset_n (sys_rstn),
    .sys_gpio_bd_in_port (gpio_i[31:0]),
    .sys_gpio_bd_out_port (gpio_o[31:0]),
    .sys_gpio_in_export (gpio_i[63:32]),
    .sys_gpio_out_export (gpio_o[63:32]),
    .sys_hps_cpu_clk_clk (sys_cpu_clk),
    .sys_hps_ddr3_mem_a (ddr3_a),
    .sys_hps_ddr3_mem_ba (ddr3_ba),
    .sys_hps_ddr3_mem_ck (ddr3_ck_p),
    .sys_hps_ddr3_mem_ck_n (ddr3_ck_n),
    .sys_hps_ddr3_mem_cke (ddr3_cke),
    .sys_hps_ddr3_mem_cs_n (ddr3_cs_n),
    .sys_hps_ddr3_mem_ras_n (ddr3_ras_n),
    .sys_hps_ddr3_mem_cas_n (ddr3_cas_n),
    .sys_hps_ddr3_mem_we_n (ddr3_we_n),
    .sys_hps_ddr3_mem_reset_n (ddr3_reset_n),
    .sys_hps_ddr3_mem_dq (ddr3_dq),
    .sys_hps_ddr3_mem_dqs (ddr3_dqs_p),
    .sys_hps_ddr3_mem_dqs_n (ddr3_dqs_n),
    .sys_hps_ddr3_mem_odt (ddr3_odt),
    .sys_hps_ddr3_mem_dm (ddr3_dm),
    .sys_hps_ddr3_oct_rzqin (ddr3_oct_rzqin),
    .sys_hps_dma_clk_clk (sys_dma_clk),
    .sys_hps_i2c0_out_data (fmca_sda_oe),
    .sys_hps_i2c0_sda (fmca_sda),
    .sys_hps_i2c0_clk_clk (fmca_scl_oe),
    .sys_hps_i2c0_scl_clk (fmca_scl),
    .sys_hps_io_hps_io_emac1_inst_TX_CLK (eth1_tx_clk),
    .sys_hps_io_hps_io_emac1_inst_TXD0 (eth1_txd0),
    .sys_hps_io_hps_io_emac1_inst_TXD1 (eth1_txd1),
    .sys_hps_io_hps_io_emac1_inst_TX_CTL (eth1_tx_ctl),
    .sys_hps_io_hps_io_emac1_inst_RXD0 (eth1_rxd0),
    .sys_hps_io_hps_io_emac1_inst_RXD1 (eth1_rxd1),
    .sys_hps_io_hps_io_emac1_inst_TXD2 (eth1_txd2),
    .sys_hps_io_hps_io_emac1_inst_TXD3 (eth1_txd3),
    .sys_hps_io_hps_io_emac1_inst_MDIO (eth1_mdio),
    .sys_hps_io_hps_io_emac1_inst_MDC (eth1_mdc),
    .sys_hps_io_hps_io_emac1_inst_RX_CTL (eth1_rx_ctl),
    .sys_hps_io_hps_io_emac1_inst_RX_CLK (eth1_rx_clk),
    .sys_hps_io_hps_io_emac1_inst_RXD2 (eth1_rxd2),
    .sys_hps_io_hps_io_emac1_inst_RXD3 (eth1_rxd3),
    .sys_hps_io_hps_io_qspi_inst_IO0 (qspi_io0),
    .sys_hps_io_hps_io_qspi_inst_IO1 (qspi_io1),
    .sys_hps_io_hps_io_qspi_inst_IO2 (qspi_io2),
    .sys_hps_io_hps_io_qspi_inst_IO3 (qspi_io3),
    .sys_hps_io_hps_io_qspi_inst_SS0 (qspi_ss0),
    .sys_hps_io_hps_io_qspi_inst_CLK (qspi_clk),
    .sys_hps_io_hps_io_sdio_inst_CMD (sdio_cmd),
    .sys_hps_io_hps_io_sdio_inst_D0 (sdio_d0),
    .sys_hps_io_hps_io_sdio_inst_D1 (sdio_d1),
    .sys_hps_io_hps_io_sdio_inst_CLK (sdio_clk),
    .sys_hps_io_hps_io_sdio_inst_D2 (sdio_d2),
    .sys_hps_io_hps_io_sdio_inst_D3 (sdio_d3),
    .sys_hps_io_hps_io_usb1_inst_D0 (usb1_d0),
    .sys_hps_io_hps_io_usb1_inst_D1 (usb1_d1),
    .sys_hps_io_hps_io_usb1_inst_D2 (usb1_d2),
    .sys_hps_io_hps_io_usb1_inst_D3 (usb1_d3),
    .sys_hps_io_hps_io_usb1_inst_D4 (usb1_d4),
    .sys_hps_io_hps_io_usb1_inst_D5 (usb1_d5),
    .sys_hps_io_hps_io_usb1_inst_D6 (usb1_d6),
    .sys_hps_io_hps_io_usb1_inst_D7 (usb1_d7),
    .sys_hps_io_hps_io_usb1_inst_CLK (usb1_clk),
    .sys_hps_io_hps_io_usb1_inst_STP (usb1_stp),
    .sys_hps_io_hps_io_usb1_inst_DIR (usb1_dir),
    .sys_hps_io_hps_io_usb1_inst_NXT (usb1_nxt),
    .sys_hps_io_hps_io_uart0_inst_RX (uart0_rx),
    .sys_hps_io_hps_io_uart0_inst_TX (uart0_tx),
    .sys_hps_rstn_reset_n (sys_rstn),
    .sys_hps_spim0_txd (spi_mosi),
    .sys_hps_spim0_rxd (spi_miso),
    .sys_hps_spim0_ss_in_n (1'b1),
    .sys_hps_spim0_ssi_oe_n (spi_csn),
    .sys_hps_spim0_ss_0_n (),
    .sys_hps_spim0_ss_1_n (),
    .sys_hps_spim0_ss_2_n (),
    .sys_hps_spim0_ss_3_n (),
    .sys_hps_spim0_sclk_clk (spi_clk),
    .sys_rst_reset_n (sys_rstn));

endmodule

// ***************************************************************************
// ***************************************************************************
