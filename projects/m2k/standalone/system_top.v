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
  inout   [ 1:0]  ddr_dm,
  inout   [15:0]  ddr_dq,
  inout   [ 1:0]  ddr_dqs_n,
  inout   [ 1:0]  ddr_dqs_p,
  inout           ddr_odt,
  inout           ddr_ras_n,
  inout           ddr_reset_n,
  inout           ddr_we_n,

  inout           fixed_io_ddr_vrn,
  inout           fixed_io_ddr_vrp,
  inout   [31:0]  fixed_io_mio,
  inout           fixed_io_ps_clk,
  inout           fixed_io_ps_porb,
  inout           fixed_io_ps_srstb,

  inout   [15:0]  data_bd,
  inout   [ 1:0]  trigger_bd,

  input           rx_clk,
  input           rxiq,
  input   [11:0]  rxd,
  output          tx_clk,
  output          txiq,
  output  [11:0]  txd,

  output          ad9963_resetn,
  output          ad9963_csn,
  output          adf4360_cs,
  output          spi_clk,
  inout           spi_sdio,

  output          en_power_analog,

  inout           iic_scl,
  inout           iic_sda);

  // internal signals

  wire    [16:0]  gpio_i;
  wire    [16:0]  gpio_o;
  wire    [16:0]  gpio_t;

  wire    [15:0]  data_i;
  wire    [15:0]  data_o;
  wire    [15:0]  data_t;

  wire    [ 1:0]  trigger_i;
  wire    [ 1:0]  trigger_o;
  wire    [ 1:0]  trigger_t;

  wire    [ 1:0]  spi0_csn;
  wire            spi0_clk;
  wire            spi0_mosi;
  wire            spi0_miso;

  assign ad9963_csn = spi0_csn[0];
  assign adf4360_cs = spi0_csn[1];
  assign spi_clk = spi0_clk;
  assign spi_mosi = spi0_mosi;
  assign spi0_miso = spi_miso;

  // instantiations

  ad_iobuf #(.DATA_WIDTH(2)) i_iobuf (
    .dio_t (gpio_t[ 1:0]),
    .dio_i (gpio_o[ 1:0]),
    .dio_o (gpio_i[ 1:0]),
    .dio_p ({ en_power_analog,
              ad9963_resetn}));

  ad_iobuf #(
    .DATA_WIDTH(16)
  ) i_data_bd (
    .dio_t(data_t[15:0]),
    .dio_i(data_o[15:0]),
    .dio_o(data_i[15:0]),
    .dio_p(data_bd));

  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_trigger_bd (
    .dio_t(trigger_t[1:0]),
    .dio_i(trigger_o[1:0]),
    .dio_o(trigger_i[1:0]),
    .dio_p(trigger_bd));

  m2k_spi i_m2k_spi (
    .ad9963_csn (ad9963_csn),
    .adf4360_cs (adf4360_cs),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio));

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
    .fixed_io_ddr_vrn (fixed_io_ddr_vrn),
    .fixed_io_ddr_vrp (fixed_io_ddr_vrp),
    .fixed_io_mio (fixed_io_mio),
    .fixed_io_ps_clk (fixed_io_ps_clk),
    .fixed_io_ps_porb (fixed_io_ps_porb),
    .fixed_io_ps_srstb (fixed_io_ps_srstb),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .data_i(data_i),
    .data_o(data_o),
    .data_t(data_t),
    .trigger_i(trigger_i),
    .trigger_o(trigger_o),
    .trigger_t(trigger_t),
    .rx_clk(rx_clk),
    .rxiq(rxiq),
    .rxd(rxd),
    .tx_clk(tx_clk),
    .txiq(txiq),
    .txd(txd),
    .ps_intr_00 (1'b0),
    .ps_intr_01 (1'b0),
    .ps_intr_02 (1'b0),
    .ps_intr_03 (1'b0),
    .ps_intr_04 (1'b0),
    .ps_intr_05 (1'b0),
    .ps_intr_06 (1'b0),
    .ps_intr_07 (1'b0),
    .ps_intr_11 (1'b0),
    .ps_intr_15 (1'b0),
    .spi0_clk_i (spi0_clk),
    .spi0_clk_o (spi0_clk),
    .spi0_csn_0_o (spi0_csn[0]),
    .spi0_csn_1_o (spi0_csn[1]),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (spi0_miso),
    .spi0_sdo_i (spi0_mosi),
    .spi0_sdo_o (spi0_mosi));

endmodule

// ***************************************************************************
// ***************************************************************************
