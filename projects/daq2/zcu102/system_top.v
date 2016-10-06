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

  input   [12:0]  gpio_bd_i,
  output  [ 7:0]  gpio_bd_o,

  input           rx_ref_clk_p,
  input           rx_ref_clk_n,
  input           rx_sysref_p,
  input           rx_sysref_n,
  output          rx_sync_p,
  output          rx_sync_n,
  input   [ 3:0]  rx_data_p,
  input   [ 3:0]  rx_data_n,

  input           tx_ref_clk_p,
  input           tx_ref_clk_n,
  input           tx_sysref_p,
  input           tx_sysref_n,
  input           tx_sync_p,
  input           tx_sync_n,
  output  [ 3:0]  tx_data_p,
  output  [ 3:0]  tx_data_n,

  input           trig_p,
  input           trig_n,

  input           adc_fdb,
  input           adc_fda,
  input           dac_irq,
  input   [ 1:0]  clkd_status,

  output          adc_pd,
  output          dac_txen,
  output          dac_reset,
  output          clkd_sync,

  output          spi_csn_clk,
  output          spi_csn_dac,
  output          spi_csn_adc,
  output          spi_clk,
  inout           spi_sdio,
  output          spi_dir);

  // internal signals

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [ 2:0]  spi_csn;
  wire            spi_mosi;
  wire            spi_miso;
  wire            trig;
  wire            rx_ref_clk;
  wire            rx_sysref;
  wire            rx_sync;
  wire            tx_ref_clk;
  wire            tx_sysref;
  wire            tx_sync;

  // spi

  assign spi_csn_adc = spi_csn[2];
  assign spi_csn_dac = spi_csn[1];
  assign spi_csn_clk = spi_csn[0];

  // instantiations

  IBUFDS_GTE4 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (rx_ref_clk_p),
    .IB (rx_ref_clk_n),
    .O (rx_ref_clk),
    .ODIV2 ());

  IBUFDS i_ibufds_rx_sysref (
    .I (rx_sysref_p),
    .IB (rx_sysref_n),
    .O (rx_sysref));

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  IBUFDS_GTE4 i_ibufds_tx_ref_clk (
    .CEB (1'd0),
    .I (tx_ref_clk_p),
    .IB (tx_ref_clk_n),
    .O (tx_ref_clk),
    .ODIV2 ());

  IBUFDS i_ibufds_tx_sysref (
    .I (tx_sysref_p),
    .IB (tx_sysref_n),
    .O (tx_sysref));

  IBUFDS i_ibufds_tx_sync (
    .I (tx_sync_p),
    .IB (tx_sync_n),
    .O (tx_sync));

  daq2_spi i_spi (
    .spi_csn (spi_csn),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio),
    .spi_dir (spi_dir));

  IBUFDS i_ibufds_trig (
    .I (trig_p),
    .IB (trig_n),
    .O (trig));

  assign adc_pd = gpio_o[42];
  assign dac_txen = gpio_o[41];
  assign dac_reset = gpio_o[40];
  assign clkd_sync = gpio_o[38];
  assign gpio_bd_o = gpio_o[7:0];

  assign gpio_i[94:44] = gpio_o[94:44];
  assign gpio_i[43:43] = trig;
  assign gpio_i[42:37] = gpio_o[42:37];
  assign gpio_i[36:36] = adc_fdb;
  assign gpio_i[35:35] = adc_fda;
  assign gpio_i[34:34] = dac_irq;
  assign gpio_i[33:32] = clkd_status;
  assign gpio_i[31:21] = gpio_o[31:21];
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_i[ 7: 0] = gpio_o[7:0];

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .ps_intr_00 (1'd0),
    .ps_intr_01 (1'd0),
    .ps_intr_02 (1'd0),
    .ps_intr_03 (1'd0),
    .ps_intr_04 (1'd0),
    .ps_intr_05 (1'd0),
    .ps_intr_06 (1'd0),
    .ps_intr_07 (1'd0),
    .ps_intr_08 (1'd0),
    .ps_intr_09 (1'd0),
    .ps_intr_10 (1'd0),
    .ps_intr_11 (1'd0),
    .ps_intr_14 (1'd0),
    .ps_intr_15 (1'd0),
    .rx_data_0_n (rx_data_n[0]),
    .rx_data_0_p (rx_data_p[0]),
    .rx_data_1_n (rx_data_n[1]),
    .rx_data_1_p (rx_data_p[1]),
    .rx_data_2_n (rx_data_n[2]),
    .rx_data_2_p (rx_data_p[2]),
    .rx_data_3_n (rx_data_n[3]),
    .rx_data_3_p (rx_data_p[3]),
    .rx_ref_clk_0 (rx_ref_clk),
    .rx_sync_0 (rx_sync),
    .rx_sysref_0 (rx_sysref),
    .spi0_csn (spi_csn),
    .spi0_miso (spi_miso),
    .spi0_mosi (spi_mosi),
    .spi0_sclk (spi_clk),
    .spi1_csn (),
    .spi1_miso (1'd0),
    .spi1_mosi (),
    .spi1_sclk (),
    .tx_data_0_n (tx_data_n[0]),
    .tx_data_0_p (tx_data_p[0]),
    .tx_data_1_n (tx_data_n[1]),
    .tx_data_1_p (tx_data_p[1]),
    .tx_data_2_n (tx_data_n[2]),
    .tx_data_2_p (tx_data_p[2]),
    .tx_data_3_n (tx_data_n[3]),
    .tx_data_3_p (tx_data_p[3]),
    .tx_ref_clk_0 (tx_ref_clk),
    .tx_sync_0 (tx_sync),
    .tx_sysref_0 (tx_sysref));

endmodule

// ***************************************************************************
// ***************************************************************************
