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

  ddr3_a,
  ddr3_ba,
  ddr3_ck_p,
  ddr3_ck_n,
  ddr3_cke,
  ddr3_cs_n,
  ddr3_ras_n,
  ddr3_cas_n,
  ddr3_we_n,
  ddr3_reset_n,
  ddr3_dq,
  ddr3_dqs_p,
  ddr3_dqs_n,
  ddr3_odt,
  ddr3_dm,
  ddr3_oct_rzqin,
  eth1_tx_clk,
  eth1_tx_ctl,
  eth1_txd0,
  eth1_txd1,
  eth1_txd2,
  eth1_txd3,
  eth1_rx_clk,
  eth1_rx_ctl,
  eth1_rxd0,
  eth1_rxd1,
  eth1_rxd2,
  eth1_rxd3,
  eth1_mdc,
  eth1_mdio,
  qspi_ss0,
  qspi_clk,
  qspi_io0,
  qspi_io1,
  qspi_io2,
  qspi_io3,
  sdio_clk,
  sdio_cmd,
  sdio_d0,
  sdio_d1,
  sdio_d2,
  sdio_d3,
  usb1_clk,
  usb1_stp,
  usb1_dir,
  usb1_nxt,
  usb1_d0,
  usb1_d1,
  usb1_d2,
  usb1_d3,
  usb1_d4,
  usb1_d5,
  usb1_d6,
  usb1_d7,
  uart0_rx,
  uart0_tx,

  // board gpio

  gpio_bd,

  // i2c

  fmc_a_scl,
  fmc_a_sda,

  // lane interface

  ref_clk,
  rx_data,
  rx_sync,
  rx_sysref,

  // spi

  spi_csn,
  spi_clk,
  spi_sdio);

  // hps

  output  [ 14:0]   ddr3_a;
  output  [  2:0]   ddr3_ba;
  output            ddr3_ck_p;
  output            ddr3_ck_n;
  output            ddr3_cke;
  output            ddr3_cs_n;
  output            ddr3_ras_n;
  output            ddr3_cas_n;
  output            ddr3_we_n;
  output            ddr3_reset_n;
  inout   [ 39:0]   ddr3_dq;
  inout   [  4:0]   ddr3_dqs_p;
  inout   [  4:0]   ddr3_dqs_n;
  output            ddr3_odt;
  output  [  4:0]   ddr3_dm;
  input             ddr3_oct_rzqin;
  output            eth1_tx_clk;
  output            eth1_tx_ctl;
  output            eth1_txd0;
  output            eth1_txd1;
  output            eth1_txd2;
  output            eth1_txd3;
  input             eth1_rx_clk;
  input             eth1_rx_ctl;
  input             eth1_rxd0;
  input             eth1_rxd1;
  input             eth1_rxd2;
  input             eth1_rxd3;
  output            eth1_mdc;
  inout             eth1_mdio;
  output            qspi_ss0;
  output            qspi_clk;
  inout             qspi_io0;
  inout             qspi_io1;
  inout             qspi_io2;
  inout             qspi_io3;
  output            sdio_clk;
  inout             sdio_cmd;
  inout             sdio_d0;
  inout             sdio_d1;
  inout             sdio_d2;
  inout             sdio_d3;
  input             usb1_clk;
  output            usb1_stp;
  input             usb1_dir;
  input             usb1_nxt;
  inout             usb1_d0;
  inout             usb1_d1;
  inout             usb1_d2;
  inout             usb1_d3;
  inout             usb1_d4;
  inout             usb1_d5;
  inout             usb1_d6;
  inout             usb1_d7;
  input             uart0_rx;
  output            uart0_tx;

  // board gpio

  inout   [ 11:0]   gpio_bd;

  // i2c

  inout             fmc_a_scl;
  inout             fmc_a_sda;

  // lane interface

  input             ref_clk;
  input   [  3:0]   rx_data;
  output            rx_sync;
  output            rx_sysref;

  // spi

  output            spi_csn;
  output            spi_clk;
  inout             spi_sdio;

  // internal signals

  wire    [ 63:0]   gpio_i;
  wire    [ 63:0]   gpio_o;
  wire              spi_mosi;
  wire              spi_miso;
  wire              fmc_a_scl_oe;
  wire              fmc_a_sda_oe;

  // i2c

  assign fmc_a_scl = (fmc_a_scl_oe == 1'b1) ? 1'b0 : 1'bz;
  assign fmc_a_sda = (fmc_a_sda_oe == 1'b1) ? 1'b0 : 1'bz;

  // instantiations

  fmcjesdadc1_spi i_fmcjesdadc1_spi (
    .spi_csn (spi_csn),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio));

  ad_iobuf #(.DATA_WIDTH(12)) i_iobuf_bd (
    .dio_t ({8'hff, 4'h0}),
    .dio_i (gpio_o[11:0]),
    .dio_o (gpio_i[11:0]),
    .dio_p (gpio_bd));

  system_bd i_system_bd (
    .a5soc_base_sys_gpio_bd_external_connection_in_port (gpio_i[63:32]),
    .a5soc_base_sys_gpio_bd_external_connection_out_port (gpio_o[63:32]),
    .a5soc_base_sys_gpio_external_connection_in_port (gpio_i[31:0]),
    .a5soc_base_sys_gpio_external_connection_out_port (gpio_o[31:0]),
    .a5soc_base_sys_hps_i2c0_out_data (fmc_a_sda_oe),
    .a5soc_base_sys_hps_i2c0_sda (fmc_a_sda),
    .a5soc_base_sys_hps_i2c0_clk_clk (fmc_a_scl_oe),
    .a5soc_base_sys_hps_i2c0_scl_in_clk (fmc_a_scl),
    .a5soc_base_sys_hps_io_hps_io_emac1_inst_TX_CLK (eth1_tx_clk),
    .a5soc_base_sys_hps_io_hps_io_emac1_inst_TXD0 (eth1_txd0),
    .a5soc_base_sys_hps_io_hps_io_emac1_inst_TXD1 (eth1_txd1),
    .a5soc_base_sys_hps_io_hps_io_emac1_inst_TX_CTL (eth1_tx_ctl),
    .a5soc_base_sys_hps_io_hps_io_emac1_inst_RXD0 (eth1_rxd0),
    .a5soc_base_sys_hps_io_hps_io_emac1_inst_RXD1 (eth1_rxd1),
    .a5soc_base_sys_hps_io_hps_io_emac1_inst_TXD2 (eth1_txd2),
    .a5soc_base_sys_hps_io_hps_io_emac1_inst_TXD3 (eth1_txd3),
    .a5soc_base_sys_hps_io_hps_io_emac1_inst_MDIO (eth1_mdio),
    .a5soc_base_sys_hps_io_hps_io_emac1_inst_MDC (eth1_mdc),
    .a5soc_base_sys_hps_io_hps_io_emac1_inst_RX_CTL (eth1_rx_ctl),
    .a5soc_base_sys_hps_io_hps_io_emac1_inst_RX_CLK (eth1_rx_clk),
    .a5soc_base_sys_hps_io_hps_io_emac1_inst_RXD2 (eth1_rxd2),
    .a5soc_base_sys_hps_io_hps_io_emac1_inst_RXD3 (eth1_rxd3),
    .a5soc_base_sys_hps_io_hps_io_qspi_inst_IO0 (qspi_io0),
    .a5soc_base_sys_hps_io_hps_io_qspi_inst_IO1 (qspi_io1),
    .a5soc_base_sys_hps_io_hps_io_qspi_inst_IO2 (qspi_io2),
    .a5soc_base_sys_hps_io_hps_io_qspi_inst_IO3 (qspi_io3),
    .a5soc_base_sys_hps_io_hps_io_qspi_inst_SS0 (qspi_ss0),
    .a5soc_base_sys_hps_io_hps_io_qspi_inst_CLK (qspi_clk),
    .a5soc_base_sys_hps_io_hps_io_sdio_inst_CMD (sdio_cmd),
    .a5soc_base_sys_hps_io_hps_io_sdio_inst_D0 (sdio_d0),
    .a5soc_base_sys_hps_io_hps_io_sdio_inst_D1 (sdio_d1),
    .a5soc_base_sys_hps_io_hps_io_sdio_inst_CLK (sdio_clk),
    .a5soc_base_sys_hps_io_hps_io_sdio_inst_D2 (sdio_d2),
    .a5soc_base_sys_hps_io_hps_io_sdio_inst_D3 (sdio_d3),
    .a5soc_base_sys_hps_io_hps_io_usb1_inst_D0 (usb1_d0),
    .a5soc_base_sys_hps_io_hps_io_usb1_inst_D1 (usb1_d1),
    .a5soc_base_sys_hps_io_hps_io_usb1_inst_D2 (usb1_d2),
    .a5soc_base_sys_hps_io_hps_io_usb1_inst_D3 (usb1_d3),
    .a5soc_base_sys_hps_io_hps_io_usb1_inst_D4 (usb1_d4),
    .a5soc_base_sys_hps_io_hps_io_usb1_inst_D5 (usb1_d5),
    .a5soc_base_sys_hps_io_hps_io_usb1_inst_D6 (usb1_d6),
    .a5soc_base_sys_hps_io_hps_io_usb1_inst_D7 (usb1_d7),
    .a5soc_base_sys_hps_io_hps_io_usb1_inst_CLK (usb1_clk),
    .a5soc_base_sys_hps_io_hps_io_usb1_inst_STP (usb1_stp),
    .a5soc_base_sys_hps_io_hps_io_usb1_inst_DIR (usb1_dir),
    .a5soc_base_sys_hps_io_hps_io_usb1_inst_NXT (usb1_nxt),
    .a5soc_base_sys_hps_io_hps_io_uart0_inst_RX (uart0_rx),
    .a5soc_base_sys_hps_io_hps_io_uart0_inst_TX (uart0_tx),
    .a5soc_base_sys_hps_memory_mem_a (ddr3_a),
    .a5soc_base_sys_hps_memory_mem_ba (ddr3_ba),
    .a5soc_base_sys_hps_memory_mem_ck (ddr3_ck_p),
    .a5soc_base_sys_hps_memory_mem_ck_n (ddr3_ck_n),
    .a5soc_base_sys_hps_memory_mem_cke (ddr3_cke),
    .a5soc_base_sys_hps_memory_mem_cs_n (ddr3_cs_n),
    .a5soc_base_sys_hps_memory_mem_ras_n (ddr3_ras_n),
    .a5soc_base_sys_hps_memory_mem_cas_n (ddr3_cas_n),
    .a5soc_base_sys_hps_memory_mem_we_n (ddr3_we_n),
    .a5soc_base_sys_hps_memory_mem_reset_n (ddr3_reset_n),
    .a5soc_base_sys_hps_memory_mem_dq (ddr3_dq),
    .a5soc_base_sys_hps_memory_mem_dqs (ddr3_dqs_p),
    .a5soc_base_sys_hps_memory_mem_dqs_n (ddr3_dqs_n),
    .a5soc_base_sys_hps_memory_mem_odt (ddr3_odt),
    .a5soc_base_sys_hps_memory_mem_dm (ddr3_dm),
    .a5soc_base_sys_hps_memory_oct_rzqin (ddr3_oct_rzqin),
    .a5soc_base_sys_hps_spim0_txd (spi_mosi),
    .a5soc_base_sys_hps_spim0_rxd (spi_miso),
    .a5soc_base_sys_hps_spim0_ss_in_n (1'b1),
    .a5soc_base_sys_hps_spim0_ssi_oe_n (spi_csn),
    .a5soc_base_sys_hps_spim0_ss_0_n (),
    .a5soc_base_sys_hps_spim0_ss_1_n (),
    .a5soc_base_sys_hps_spim0_ss_2_n (),
    .a5soc_base_sys_hps_spim0_ss_3_n (),
    .a5soc_base_sys_hps_spim0_sclk_out_clk (spi_clk),
    .fmcjesdadc1_rx_data_rx_serial_data (rx_data),
    .fmcjesdadc1_rx_ref_clk_clk (ref_clk),
    .fmcjesdadc1_rx_sync_rx_sync (rx_sync),
    .fmcjesdadc1_rx_sysref_rx_ext_sysref_out (rx_sysref));

endmodule

// ***************************************************************************
// ***************************************************************************
