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
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  sys_rst,
  sys_clk_p,
  sys_clk_n,

  uart_sin,
  uart_sout,

  ddr3_addr,
  ddr3_ba,
  ddr3_cas_n,
  ddr3_ck_n,
  ddr3_ck_p,
  ddr3_cke,
  ddr3_cs_n,
  ddr3_dm,
  ddr3_dq,
  ddr3_dqs_n,
  ddr3_dqs_p,
  ddr3_odt,
  ddr3_ras_n,
  ddr3_reset_n,
  ddr3_we_n,

  phy_reset_n,
  phy_mdc,
  phy_mdio,
  phy_tx_clk,
  phy_tx_ctrl,
  phy_tx_data,
  phy_rx_clk,
  phy_rx_ctrl,
  phy_rx_data,

  fan_pwm,

  gpio_lcd,
  gpio_bd,

  iic_rstn,
  iic_scl,
  iic_sda,

  rx_clk_in_p,
  rx_clk_in_n,
  rx_frame_in_p,
  rx_frame_in_n,
  rx_data_in_p,
  rx_data_in_n,

  tx_clk_out_p,
  tx_clk_out_n,
  tx_frame_out_p,
  tx_frame_out_n,
  tx_data_out_p,
  tx_data_out_n,

  txnrx,
  enable,

  gpio_resetb,
  gpio_sync,
  gpio_en_agc,
  gpio_ctl,
  gpio_status,

  spi_csn_0,
  spi_clk,
  spi_mosi,
  spi_miso
 );

  input           sys_rst;
  input           sys_clk_p;
  input           sys_clk_n;

  input           uart_sin;
  output          uart_sout;

  output  [13:0]  ddr3_addr;
  output  [ 2:0]  ddr3_ba;
  output          ddr3_cas_n;
  output  [ 0:0]  ddr3_ck_n;
  output  [ 0:0]  ddr3_ck_p;
  output  [ 0:0]  ddr3_cke;
  output  [ 0:0]  ddr3_cs_n;
  output  [ 7:0]  ddr3_dm;
  inout   [63:0]  ddr3_dq;
  inout   [ 7:0]  ddr3_dqs_n;
  inout   [ 7:0]  ddr3_dqs_p;
  output  [ 0:0]  ddr3_odt;
  output          ddr3_ras_n;
  output          ddr3_reset_n;
  output          ddr3_we_n;

  output          phy_reset_n;
  output          phy_mdc;
  inout           phy_mdio;
  output          phy_tx_clk;
  output          phy_tx_ctrl;
  output  [ 3:0]  phy_tx_data;
  input           phy_rx_clk;
  input           phy_rx_ctrl;
  input   [ 3:0]  phy_rx_data;

  output          fan_pwm;

  inout   [ 6:0]  gpio_lcd;
  inout   [12:0]  gpio_bd;

  output          iic_rstn;
  inout           iic_scl;
  inout           iic_sda;

  input           rx_clk_in_p;
  input           rx_clk_in_n;
  input           rx_frame_in_p;
  input           rx_frame_in_n;
  input   [ 5:0]  rx_data_in_p;
  input   [ 5:0]  rx_data_in_n;

  output          tx_clk_out_p;
  output          tx_clk_out_n;
  output          tx_frame_out_p;
  output          tx_frame_out_n;
  output  [ 5:0]  tx_data_out_p;
  output  [ 5:0]  tx_data_out_n;

  output          txnrx;
  output          enable;

  inout           gpio_resetb;
  inout           gpio_sync;
  inout           gpio_en_agc;
  inout   [ 3:0]  gpio_ctl;
  inout   [ 7:0]  gpio_status;

  output          spi_csn_0;
  output          spi_clk;
  output          spi_mosi;
  input           spi_miso;

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire    [ 7:0]  spi_csn;
  wire            spi_clk;
  wire            spi_mosi;
  wire            spi_miso;

  wire            tdd_enable_s;
  wire            gpio_enable;
  wire            gpio_txnrx;
  wire            enable_s;
  wire            txnrx_s;

  // assignments

  assign fan_pwm      = 1'b1;
  assign iic_rstn     = 1'b1;
  assign spi_csn_0    = spi_csn[0];

  assign enable = (tdd_enable_s == 1'b1) ? enable_s : gpio_enable;
  assign txnrx  = (tdd_enable_s == 1'b1) ? txnrx_s  : gpio_txnrx;

  // instantiations

  ad_iobuf #(.DATA_WIDTH(17)) i_iobuf (
    .dio_t (gpio_t[48:32]),
    .dio_i (gpio_o[48:32]),
    .dio_o (gpio_i[48:32]),
    .dio_p ({ gpio_txnrx,
              gpio_enable,
              gpio_resetb,
              gpio_sync,
              gpio_en_agc,
              gpio_ctl,
              gpio_status}));

  ad_iobuf #(.DATA_WIDTH(13)) i_iobuf_sw_led (
    .dio_t (gpio_t[12:0]),
    .dio_i (gpio_o[12:0]),
    .dio_o (gpio_i[12:0]),
    .dio_p (gpio_bd));

  system_wrapper i_system_wrapper (
    .ddr3_addr (ddr3_addr),
    .ddr3_ba (ddr3_ba),
    .ddr3_cas_n (ddr3_cas_n),
    .ddr3_ck_n (ddr3_ck_n),
    .ddr3_ck_p (ddr3_ck_p),
    .ddr3_cke (ddr3_cke),
    .ddr3_cs_n (ddr3_cs_n),
    .ddr3_dm (ddr3_dm),
    .ddr3_dq (ddr3_dq),
    .ddr3_dqs_n (ddr3_dqs_n),
    .ddr3_dqs_p (ddr3_dqs_p),
    .ddr3_odt (ddr3_odt),
    .ddr3_ras_n (ddr3_ras_n),
    .ddr3_reset_n (ddr3_reset_n),
    .ddr3_we_n (ddr3_we_n),
    .gpio_lcd_tri_io (gpio_lcd),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio0_i (gpio_i[31:0]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    .gpio1_i (gpio_i[63:32]),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .mb_intr_06 (1'b0),
    .mb_intr_07 (1'b0),
    .mb_intr_08 (1'b0),
    .mb_intr_14 (1'b0),
    .mb_intr_15 (1'b0),
    .mdio_io (phy_mdio),
    .mdio_mdc (phy_mdc),
    .phy_rst_n (phy_reset_n),
    .rgmii_rd (phy_rx_data),
    .rgmii_rx_ctl (phy_rx_ctrl),
    .rgmii_rxc (phy_rx_clk),
    .rgmii_td (phy_tx_data),
    .rgmii_tx_ctl (phy_tx_ctrl),
    .rgmii_txc (phy_tx_clk),
    .sys_clk_n (sys_clk_n),
    .sys_clk_p (sys_clk_p),
    .sys_rst (sys_rst),
    .spi_clk_i (spi_clk),
    .spi_clk_o (spi_clk),
    .spi_csn_i (spi_csn),
    .spi_csn_o (spi_csn),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (spi_mosi),
    .spi_sdo_o (spi_mosi),
    .rx_clk_in_n (rx_clk_in_n),
    .rx_clk_in_p (rx_clk_in_p),
    .rx_data_in_n (rx_data_in_n),
    .rx_data_in_p (rx_data_in_p),
    .rx_frame_in_n (rx_frame_in_n),
    .rx_frame_in_p (rx_frame_in_p),
    .tx_clk_out_n (tx_clk_out_n),
    .tx_clk_out_p (tx_clk_out_p),
    .tx_data_out_n (tx_data_out_n),
    .tx_data_out_p (tx_data_out_p),
    .tx_frame_out_n (tx_frame_out_n),
    .tx_frame_out_p (tx_frame_out_p),
    .uart_sin (uart_sin),
    .uart_sout (uart_sout),
    .enable (enable_s),
    .txnrx (txnrx_s),
    .tdd_enable (tdd_enable_s));

endmodule

// ***************************************************************************
// ***************************************************************************
