// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2023, 2025 Analog Devices, Inc. All rights reserved.
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
  input           tx_clk,
  output          txiq,
  output  [11:0]  txd,

  output          ad9963_resetn,
  output          ad9963_csn,
  output          adf4360_cs,
  output          spi_clk,
  inout           spi_sdio,

  output          en_power_analog,

  inout           iic_scl,
  inout           iic_sda
);

  // internal signals

  wire    [16:0]  gpio_i;
  wire    [16:0]  gpio_o;
  wire    [16:0]  gpio_t;

  wire    [15:0]  data_i;
  wire    [15:0]  data_o;
  wire    [15:0]  data_t;

  wire    [ 1:0]  iop_data_i;
  wire    [ 1:0]  iop_data_o;
  wire    [ 1:0]  iop_data_t;

  // IOP SPI signals
  wire            iop_spi_io0_i;
  wire            iop_spi_io0_o;
  wire            iop_spi_io0_t;
  wire            iop_spi_io1_i;
  wire            iop_spi_io1_o;
  wire            iop_spi_io1_t;
  wire            iop_spi_sck_i;
  wire            iop_spi_sck_o;
  wire            iop_spi_sck_t;
  wire    [ 0:0]  iop_spi_ss_i;
  wire    [ 0:0]  iop_spi_ss_o;
  wire            iop_spi_ss_t;

  // IOP I2C signals
  wire            iop_iic_scl_i;
  wire            iop_iic_scl_o;
  wire            iop_iic_scl_t;
  wire            iop_iic_sda_i;
  wire            iop_iic_sda_o;
  wire            iop_iic_sda_t;

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

  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_iobuf (
    .dio_t (gpio_t[ 1:0]),
    .dio_i (gpio_o[ 1:0]),
    .dio_o (gpio_i[ 1:0]),
    .dio_p ({ en_power_analog,
              ad9963_resetn}));

  assign gpio_i[16:2] = gpio_o[16:2];

  // Split data_bd: [7:0] for IOP PMOD, [15:8] for Logic Analyzer
  // IOP PMOD pin mapping:
  // data_bd[0]: I2C SDA
  // data_bd[1]: I2C SCL
  // data_bd[2]: SPI CS
  // data_bd[3]: SPI MOSI (io0)
  // data_bd[4]: SPI MISO (io1)
  // data_bd[5]: SPI SCK
  // data_bd[6-7]: GPIO

  // I2C IOBUFs
  ad_iobuf #(.DATA_WIDTH(1)) i_iop_iic_sda (
    .dio_t(iop_iic_sda_t),
    .dio_i(iop_iic_sda_o),
    .dio_o(iop_iic_sda_i),
    .dio_p(data_bd[0]));

  ad_iobuf #(.DATA_WIDTH(1)) i_iop_iic_scl (
    .dio_t(iop_iic_scl_t),
    .dio_i(iop_iic_scl_o),
    .dio_o(iop_iic_scl_i),
    .dio_p(data_bd[1]));

  // SPI IOBUFs
  ad_iobuf #(.DATA_WIDTH(1)) i_iop_spi_ss (
    .dio_t(iop_spi_ss_t),
    .dio_i(iop_spi_ss_o[0]),
    .dio_o(iop_spi_ss_i[0]),
    .dio_p(data_bd[2]));

  ad_iobuf #(.DATA_WIDTH(1)) i_iop_spi_io0 (
    .dio_t(iop_spi_io0_t),
    .dio_i(iop_spi_io0_o),
    .dio_o(iop_spi_io0_i),
    .dio_p(data_bd[3]));

  ad_iobuf #(.DATA_WIDTH(1)) i_iop_spi_io1 (
    .dio_t(iop_spi_io1_t),
    .dio_i(iop_spi_io1_o),
    .dio_o(iop_spi_io1_i),
    .dio_p(data_bd[4]));

  ad_iobuf #(.DATA_WIDTH(1)) i_iop_spi_sck (
    .dio_t(iop_spi_sck_t),
    .dio_i(iop_spi_sck_o),
    .dio_o(iop_spi_sck_i),
    .dio_p(data_bd[5]));

  // GPIO IOBUFs (2 pins)
  ad_iobuf #(.DATA_WIDTH(2)) i_data_bd_iop_gpio (
    .dio_t(iop_data_t[1:0]),
    .dio_i(iop_data_o[1:0]),
    .dio_o(iop_data_i[1:0]),
    .dio_p(data_bd[7:6]));

  ad_iobuf #(
    .DATA_WIDTH(8)
  ) i_data_bd_la (
    .dio_t(data_t[15:8]),
    .dio_i(data_o[15:8]),
    .dio_o(data_i[15:8]),
    .dio_p(data_bd[15:8]));

  // Tie off unused lower 8 bits of logic analyzer data ports
  assign data_i[7:0] = 8'h00;
  assign data_t[7:0] = 8'hFF;  // High-Z

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
    .iop_data_i(iop_data_i),
    .iop_data_o(iop_data_o),
    .iop_data_t(iop_data_t),
    .iop_iic_scl_i(iop_iic_scl_i),
    .iop_iic_scl_o(iop_iic_scl_o),
    .iop_iic_scl_t(iop_iic_scl_t),
    .iop_iic_sda_i(iop_iic_sda_i),
    .iop_iic_sda_o(iop_iic_sda_o),
    .iop_iic_sda_t(iop_iic_sda_t),
    .iop_spi_io0_i(iop_spi_io0_i),
    .iop_spi_io0_o(iop_spi_io0_o),
    .iop_spi_io0_t(iop_spi_io0_t),
    .iop_spi_io1_i(iop_spi_io1_i),
    .iop_spi_io1_o(iop_spi_io1_o),
    .iop_spi_io1_t(iop_spi_io1_t),
    .iop_spi_sck_i(iop_spi_sck_i),
    .iop_spi_sck_o(iop_spi_sck_o),
    .iop_spi_sck_t(iop_spi_sck_t),
    .iop_spi_ss_i(iop_spi_ss_i),
    .iop_spi_ss_o(iop_spi_ss_o),
    .iop_spi_ss_t(iop_spi_ss_t),
    .trigger_i(trigger_i),
    .trigger_o(trigger_o),
    .trigger_t(trigger_t),
    .rx_clk(rx_clk),
    .rxiq(rxiq),
    .rxd(rxd),
    .tx_clk(tx_clk),
    .txiq(txiq),
    .txd(txd),
    .spi0_clk_i (spi0_clk),
    .spi0_clk_o (spi0_clk),
    .spi0_csn_0_o (spi0_csn[0]),
    .spi0_csn_1_o (spi0_csn[1]),
    .spi0_csn_2_o (),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (spi0_miso),
    .spi0_sdo_i (spi0_mosi),
    .spi0_sdo_o (spi0_mosi));

endmodule
