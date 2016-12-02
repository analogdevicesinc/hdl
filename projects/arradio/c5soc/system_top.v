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

  // hps-spim1-lcd

  output            spim1_ss0,
  output            spim1_clk,
  output            spim1_mosi,
  input             spim1_miso,

  // hps-uart

  input             uart0_rx,
  output            uart0_tx,

  // board gpio

  output  [  3:0]   gpio_bd_o,
  input   [  7:0]   gpio_bd_i,

  // display

  output            vga_clk,
  output            vga_blank_n,
  output            vga_sync_n,
  output            vga_hsync,
  output            vga_vsync,
  output  [  7:0]   vga_red,
  output  [  7:0]   vga_grn,
  output  [  7:0]   vga_blu,

  // ad9361

  input             rx_clk_in,
  input             rx_frame_in,
  input   [  5:0]   rx_data_in,
  output            tx_clk_out,
  output            tx_frame_out,
  output  [  5:0]   tx_data_out,
  output            enable,
  output            txnrx,

  // gpio interface

  output            ad9361_resetb,
  output            ad9361_en_agc,
  output            ad9361_sync,

  // spi interface

  output            spi_csn,
  output            spi_clk,
  output            spi_mosi,
  input             spi_miso);

  // internal signals

  wire              sys_resetn;
  wire    [ 31:0]   sys_gpio_i;
  wire    [ 31:0]   sys_gpio_o;
  wire    [  4:0]   gpio;

  // defaults

  assign gpio_bd_o = sys_gpio_o[3:0];

  assign sys_gpio_i[31:8] = sys_gpio_o[31:8];
  assign sys_gpio_i[ 7:0] = gpio_bd_i;
  
  assign vga_blank_n = 1'b1;
  assign vga_sync_n = 1'b0;

  assign ad9361_resetb = gpio[4];
  assign ad9361_en_agc = gpio[3];
  assign ad9361_sync = gpio[2];

  // instantiations

  system_bd i_system_bd (
    .axi_ad9361_delay_clk_clk (1'd0),
    .axi_ad9361_device_if_rx_clk_in_p (rx_clk_in),
    .axi_ad9361_device_if_rx_clk_in_n (1'd0),
    .axi_ad9361_device_if_rx_frame_in_p (rx_frame_in),
    .axi_ad9361_device_if_rx_frame_in_n (1'd0),
    .axi_ad9361_device_if_rx_data_in_p (rx_data_in),
    .axi_ad9361_device_if_rx_data_in_n (6'd0),
    .axi_ad9361_device_if_tx_clk_out_p (tx_clk_out),
    .axi_ad9361_device_if_tx_clk_out_n (),
    .axi_ad9361_device_if_tx_frame_out_p (tx_frame_out),
    .axi_ad9361_device_if_tx_frame_out_n (),
    .axi_ad9361_device_if_tx_data_out_p (tx_data_out),
    .axi_ad9361_device_if_tx_data_out_n (),
    .axi_ad9361_device_if_enable (enable),
    .axi_ad9361_device_if_txnrx (txnrx),
    .axi_ad9361_up_enable_up_enable (gpio[1]),
    .axi_ad9361_up_txnrx_up_txnrx (gpio[0]),
    .gpio_export (gpio),
    .spi_MISO (spi_miso),
    .spi_MOSI (spi_mosi),
    .spi_SCLK (spi_clk),
    .spi_SS_n (spi_csn),
    .sys_clk_clk (sys_clk),
    .sys_gpio_in_port (sys_gpio_i),
    .sys_gpio_out_port (sys_gpio_o),
    .sys_hps_io_hps_io_emac1_inst_TX_CLK (eth1_tx_clk),
    .sys_hps_io_hps_io_emac1_inst_TXD0 (eth1_tx_d[0]),
    .sys_hps_io_hps_io_emac1_inst_TXD1 (eth1_tx_d[1]),
    .sys_hps_io_hps_io_emac1_inst_TXD2 (eth1_tx_d[2]),
    .sys_hps_io_hps_io_emac1_inst_TXD3 (eth1_tx_d[3]),
    .sys_hps_io_hps_io_emac1_inst_RXD0 (eth1_rx_d[0]),
    .sys_hps_io_hps_io_emac1_inst_MDIO (eth1_mdio),
    .sys_hps_io_hps_io_emac1_inst_MDC (eth1_mdc),
    .sys_hps_io_hps_io_emac1_inst_RX_CTL (eth1_rx_ctl),
    .sys_hps_io_hps_io_emac1_inst_TX_CTL (eth1_tx_ctl),
    .sys_hps_io_hps_io_emac1_inst_RX_CLK (eth1_rx_clk),
    .sys_hps_io_hps_io_emac1_inst_RXD1 (eth1_rx_d[1]),
    .sys_hps_io_hps_io_emac1_inst_RXD2 (eth1_rx_d[2]),
    .sys_hps_io_hps_io_emac1_inst_RXD3 (eth1_rx_d[3]),
    .sys_hps_io_hps_io_qspi_inst_IO0 (qspi_io[0]),
    .sys_hps_io_hps_io_qspi_inst_IO1 (qspi_io[1]),
    .sys_hps_io_hps_io_qspi_inst_IO2 (qspi_io[2]),
    .sys_hps_io_hps_io_qspi_inst_IO3 (qspi_io[3]),
    .sys_hps_io_hps_io_qspi_inst_SS0 (qspi_ss0),
    .sys_hps_io_hps_io_qspi_inst_CLK (qspi_clk),
    .sys_hps_io_hps_io_sdio_inst_CMD (sdio_cmd),
    .sys_hps_io_hps_io_sdio_inst_D0 (sdio_d[0]),
    .sys_hps_io_hps_io_sdio_inst_D1 (sdio_d[1]),
    .sys_hps_io_hps_io_sdio_inst_CLK (sdio_clk),
    .sys_hps_io_hps_io_sdio_inst_D2 (sdio_d[2]),
    .sys_hps_io_hps_io_sdio_inst_D3 (sdio_d[3]),
    .sys_hps_io_hps_io_usb1_inst_D0 (usb1_d[0]),
    .sys_hps_io_hps_io_usb1_inst_D1 (usb1_d[1]),
    .sys_hps_io_hps_io_usb1_inst_D2 (usb1_d[2]),
    .sys_hps_io_hps_io_usb1_inst_D3 (usb1_d[3]),
    .sys_hps_io_hps_io_usb1_inst_D4 (usb1_d[4]),
    .sys_hps_io_hps_io_usb1_inst_D5 (usb1_d[5]),
    .sys_hps_io_hps_io_usb1_inst_D6 (usb1_d[6]),
    .sys_hps_io_hps_io_usb1_inst_D7 (usb1_d[7]),
    .sys_hps_io_hps_io_usb1_inst_CLK (usb1_clk),
    .sys_hps_io_hps_io_usb1_inst_STP (usb1_stp),
    .sys_hps_io_hps_io_usb1_inst_DIR (usb1_dir),
    .sys_hps_io_hps_io_usb1_inst_NXT (usb1_nxt),
    .sys_hps_io_hps_io_spim1_inst_CLK (spim1_clk),
    .sys_hps_io_hps_io_spim1_inst_MOSI (spim1_mosi),
    .sys_hps_io_hps_io_spim1_inst_MISO (spim1_miso),
    .sys_hps_io_hps_io_spim1_inst_SS0 (spim1_ss0),
    .sys_hps_io_hps_io_uart0_inst_RX (uart0_rx),
    .sys_hps_io_hps_io_uart0_inst_TX (uart0_tx),
    .sys_hps_mem_mem_a (ddr3_a),
    .sys_hps_mem_mem_ba (ddr3_ba),
    .sys_hps_mem_mem_ck (ddr3_ck_p),
    .sys_hps_mem_mem_ck_n (ddr3_ck_n),
    .sys_hps_mem_mem_cke (ddr3_cke),
    .sys_hps_mem_mem_cs_n (ddr3_cs_n),
    .sys_hps_mem_mem_ras_n (ddr3_ras_n),
    .sys_hps_mem_mem_cas_n (ddr3_cas_n),
    .sys_hps_mem_mem_we_n (ddr3_we_n),
    .sys_hps_mem_mem_reset_n (ddr3_reset_n),
    .sys_hps_mem_mem_dq (ddr3_dq),
    .sys_hps_mem_mem_dqs (ddr3_dqs_p),
    .sys_hps_mem_mem_dqs_n (ddr3_dqs_n),
    .sys_hps_mem_mem_odt (ddr3_odt),
    .sys_hps_mem_mem_dm (ddr3_dm),
    .sys_hps_mem_oct_rzqin (ddr3_rzq),
    .sys_hps_reset_reset_n (sys_resetn),
    .sys_reset_reset_n (sys_resetn),
    .vga_clk_clk (vga_clk),
    .vga_if_vid_clk (vga_clk),
    .vga_if_vid_data ({vga_red, vga_grn, vga_blu}),
    .vga_if_underflow (),
    .vga_if_vid_datavalid (),
    .vga_if_vid_v_sync (vga_vsync),
    .vga_if_vid_h_sync (vga_hsync),
    .vga_if_vid_f (),
    .vga_if_vid_h (),
    .vga_if_vid_v ());

endmodule

// ***************************************************************************
// ***************************************************************************
