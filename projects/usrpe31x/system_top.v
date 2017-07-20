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

  inout   [14:0]  ddr_addr,
  inout   [ 2:0]  ddr_ba,
  inout           ddr_cas_n,
  inout           ddr_ck_n,
  inout           ddr_ck_p,
  inout           ddr_cke,
  inout           ddr_cs_n,
  inout   [ 3:0]  ddr_dm,
  inout   [31:0]  ddr_dq,
  inout   [ 3:0]  ddr_dqs_n,
  inout   [ 3:0]  ddr_dqs_p,
  inout           ddr_odt,
  inout           ddr_ras_n,
  inout           ddr_reset_n,
  inout           ddr_we_n,

  inout           fixed_io_ddr_vrn,
  inout           fixed_io_ddr_vrp,
  inout   [53:0]  fixed_io_mio,
  inout           fixed_io_ps_clk,
  inout           fixed_io_ps_porb,
  inout           fixed_io_ps_srstb,

  input           rx_clk_in,
  input           rx_frame_in,
  input   [11:0]  rx_data_in,
  output          tx_clk_out,
  output          tx_frame_out,
  output  [11:0]  tx_data_out,

  output          enable,
  output          txnrx,
  input           out_clk,

  output          gpio_resetb,
  output          gpio_sync,
  output          gpio_en_agc,
  output  [ 3:0]  gpio_ctl,
  input   [ 7:0]  gpio_status,
  inout   [ 8:0]  gpio_rf,
  output          gpio_tcxo_clk,
  output          gpio_out_clk,

  output          spi_csn,
  output          spi_clk,
  output          spi_mosi,
  input           spi_miso,

  output  [ 2:0]  tx_bandsel,
  output  [ 2:0]  rx_bandsel_1,
  output  [ 1:0]  rx_bandsel_1b,
  output  [ 1:0]  rx_bandsel_1c,
  output  [ 2:0]  rx_bandsel_2,
  output  [ 1:0]  rx_bandsel_2b,
  output  [ 1:0]  rx_bandsel_2c,

  output          tx_enable_1a,
  output          tx_enable_2a,
  output          tx_enable_1b,
  output          tx_enable_2b,

  output          txrx1_antsel_v1,
  output          txrx1_antsel_v2,
  output          txrx2_antsel_v1,
  output          txrx2_antsel_v2,
  output          rx1_antsel_v1,
  output          rx1_antsel_v2,
  output          rx2_antsel_v1,
  output          rx2_antsel_v2,

  output          txrx1_tx_led,
  output          txrx1_rx_led,
  output          txrx2_tx_led,
  output          txrx2_rx_led,
  output          rx1_rx_led,
  output          rx2_rx_led,

  output          tcxo_dac_csn,
  output          tcxo_dac_clk,
  output          tcxo_dac_mosi,
  input           tcxo_clk,

  input           avr_csn,
  input           avr_clk,
  input           avr_mosi,
  output          avr_miso,
  output          avr_irq,

  input           pwr_switch,

  input           pps_gps,
  input           pps_ext,

  inout   [ 5:0]  gpio_bd);

  // internal signals

  wire            pps_s;
  wire    [31:0]  pl_gpio_i;
  wire    [31:0]  pl_gpio_o;
  wire    [31:0]  pl_gpio_t;
  wire    [63:0]  ps_gpio_i;
  wire    [63:0]  ps_gpio_o;
  wire    [63:0]  ps_gpio_t;

  // assignments

  assign pps_s = pps_gps | pps_ext;
  assign tcxo_dac_clk = spi_clk;
  assign tcxo_dac_mosi = spi_mosi;

  // gpio-rf (pl)

  assign gpio_tcxo_clk = tcxo_clk;
  assign gpio_out_clk = out_clk;
  assign pl_gpio_i[31:9] = pl_gpio_o[31:9];

  ad_iobuf #(.DATA_WIDTH(9)) i_iobuf_rf (
    .dio_t (pl_gpio_t[8:0]),
    .dio_i (pl_gpio_o[8:0]),
    .dio_o (pl_gpio_i[8:0]),
    .dio_p (gpio_rf));

  // gpio[63:56] - antennae selects

  assign ps_gpio_i[63:56] = ps_gpio_o[63:56];
  assign txrx1_antsel_v1 = ps_gpio_o[63];
  assign txrx1_antsel_v2 = ps_gpio_o[62];
  assign txrx2_antsel_v1 = ps_gpio_o[61];
  assign txrx2_antsel_v2 = ps_gpio_o[60];
  assign rx1_antsel_v1 = ps_gpio_o[59];
  assign rx1_antsel_v2 = ps_gpio_o[58];
  assign rx2_antsel_v1 = ps_gpio_o[57];
  assign rx2_antsel_v2 = ps_gpio_o[56];

  // gpio[55:48] - antennae leds

  assign ps_gpio_i[55:49] = ps_gpio_o[55:49];
  assign txrx1_tx_led = ps_gpio_o[55];
  assign txrx1_rx_led = ps_gpio_o[54];
  assign txrx2_tx_led = ps_gpio_o[53];
  assign txrx2_rx_led = ps_gpio_o[52];
  assign rx1_rx_led = ps_gpio_o[51];
  assign rx2_rx_led = ps_gpio_o[50];

  // gpio[48:32] - ad9361

  assign ps_gpio_i[48:44] = ps_gpio_o[48:44];
  assign gpio_resetb = ps_gpio_o[46];
  assign gpio_sync = ps_gpio_o[45];
  assign gpio_en_agc = ps_gpio_o[44];

  assign ps_gpio_i[43:40] = ps_gpio_o[43:40];
  assign gpio_ctl = ps_gpio_o[43:40];

  assign ps_gpio_i[39:32] = gpio_status;

  // gpio[31:28] - tx_enable

  assign ps_gpio_i[31:28] = ps_gpio_o[31:28];

  assign tx_enable_1a = ps_gpio_o[31];
  assign tx_enable_2a = ps_gpio_o[30];
  assign tx_enable_1b = ps_gpio_o[29];
  assign tx_enable_2b = ps_gpio_o[28];

  // gpio[27:24] - tx_bandsel

  assign ps_gpio_i[27:24] = ps_gpio_o[27:24];

  assign tx_bandsel = ps_gpio_o[26:24];

  // gpio[23:16] - rx_bandsel(1)

  assign ps_gpio_i[23:16] = ps_gpio_o[23:16];

  assign rx_bandsel_1 = ps_gpio_o[22:20];
  assign rx_bandsel_1b = ps_gpio_o[19:18];
  assign rx_bandsel_1c = ps_gpio_o[17:16];

  // gpio[15:8] - rx_bandsel(2)

  assign ps_gpio_i[15:8] = ps_gpio_o[15:8];

  assign rx_bandsel_2 = ps_gpio_o[14:12];
  assign rx_bandsel_2b = ps_gpio_o[11:10];
  assign rx_bandsel_2c = ps_gpio_o[9:8];

  // gpio[7:0] - board stuff (+ pwr_switch, avr_irq)

  assign ps_gpio_i[7] = ps_gpio_o[7];
  assign avr_irq = ps_gpio_o[7];

  assign ps_gpio_i[6] = pwr_switch;

  ad_iobuf #(.DATA_WIDTH(6)) i_iobuf_bd (
    .dio_t (ps_gpio_t[5:0]),
    .dio_i (ps_gpio_o[5:0]),
    .dio_o (ps_gpio_i[5:0]),
    .dio_p (gpio_bd));

  // instantiations

  system_wrapper i_system_wrapper (
    .ddr_addr (ddr_addr),
    .ddr_ba (ddr_ba),
    .ddr_cas_n (ddr_cas_n),
    .ddr_ck_n (ddr_ck_n),
    .ddr_ck_p (ddr_ck_p),
    .ddr_cke (ddr_cke),
    .ddr_cs_n (ddr_cs_n),
    .ddr_dm (ddr_dm),
    .ddr_dq (ddr_dq),
    .ddr_dqs_n (ddr_dqs_n),
    .ddr_dqs_p (ddr_dqs_p),
    .ddr_odt (ddr_odt),
    .ddr_ras_n (ddr_ras_n),
    .ddr_reset_n (ddr_reset_n),
    .ddr_we_n (ddr_we_n),
    .enable (enable),
    .fixed_io_ddr_vrn (fixed_io_ddr_vrn),
    .fixed_io_ddr_vrp (fixed_io_ddr_vrp),
    .fixed_io_mio (fixed_io_mio),
    .fixed_io_ps_clk (fixed_io_ps_clk),
    .fixed_io_ps_porb (fixed_io_ps_porb),
    .fixed_io_ps_srstb (fixed_io_ps_srstb),
    .pl_gpio_i (pl_gpio_i),
    .pl_gpio_o (pl_gpio_o),
    .pl_gpio_t (pl_gpio_t),
    .ps_gpio_i (ps_gpio_i),
    .ps_gpio_o (ps_gpio_o),
    .ps_gpio_t (ps_gpio_t),
    .ps_intr_00 (1'b0),
    .ps_intr_01 (1'b0),
    .ps_intr_02 (1'b0),
    .ps_intr_03 (1'b0),
    .ps_intr_04 (1'b0),
    .ps_intr_05 (1'b0),
    .ps_intr_06 (1'b0),
    .ps_intr_07 (1'b0),
    .ps_intr_08 (1'b0),
    .ps_intr_09 (1'b0),
    .ps_intr_10 (1'b0),
    .ps_intr_11 (1'b0),
    .ps_intr_14 (1'b0),
    .rx_clk_in (rx_clk_in),
    .rx_data_in (rx_data_in),
    .rx_frame_in (rx_frame_in),
    .spi0_clk (spi_clk),
    .spi0_csn_0 (spi_csn),
    .spi0_csn_1 (tcxo_dac_csn),
    .spi0_csn_2 (),
    .spi0_miso (spi_miso),
    .spi0_mosi (spi_mosi),
    .spi1_clk (avr_clk),
    .spi1_csn (avr_csn),
    .spi1_miso (avr_miso),
    .spi1_mosi (avr_mosi),
    .tdd_sync (pps_s),
    .tx_clk_out (tx_clk_out),
    .tx_data_out (tx_data_out),
    .tx_frame_out (tx_frame_out),
    .txnrx (txnrx),
    .up_enable (ps_gpio_o[47]),
    .up_txnrx (ps_gpio_o[48]));

endmodule

// ***************************************************************************
// ***************************************************************************
