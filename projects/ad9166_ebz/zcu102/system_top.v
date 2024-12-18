// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2019-2024 Analog Devices, Inc. All rights reserved.
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
  input   [12:0]  gpio_bd_i,
  output  [ 7:0]  gpio_bd_o,

  input           tx_ref_clk_p,
  input           tx_ref_clk_n,
  input           tx_sysref_p,
  input           tx_sysref_n,
  input           tx_sync_p,
  input           tx_sync_n,
  output  [ 7:0]  tx_data_p,
  output  [ 7:0]  tx_data_n,

  input           spi_miso,
  output          spi_mosi,
  output          spi_clk,
  output          spi_en,

  output          spi_csn_dac,
  output          spi_csn_hmc7044,
  output          spi_cs_adf4372,
  output          spi_cs_amp,

  output          fmc_txen,

  output          pmod_spi_clk,
  output          pmod_spi_csn,
  output          pmod_spi_mosi,
  input           pmod_spi_miso,
  inout   [ 3:0]  pmod_gpio
);

  // internal signals

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [94:0]  gpio_t;
  wire    [ 2:0]  spi1_csn;
  wire    [ 3:0]  spi_fmc_csn;
  wire            tx_ref_clk;
  wire            tx_sysref;
  wire            tx_sync;

  // active low
  assign spi_en = 1'b0;

  // PL SPI connected to axi_quad_spi because they share the same SPI lines
  assign spi_csn_dac = spi_fmc_csn[0];      // FMC_CS1
  assign spi_csn_hmc7044 = spi_fmc_csn[1];  // FMC_CS2
  assign spi_csn_adf4372 = spi_fmc_csn[2];  // FMC_CS3
  assign spi_csn_amp = spi_fmc_csn[3];      // FMC_CS4

  /* JESD204 clocks and control signals */
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

  /* FMC GPIO */
  ad_iobuf #(
    .DATA_WIDTH (1)
  ) i_iobuf (
    .dio_t (gpio_t[25]),
    .dio_i (gpio_o[25]),
    .dio_o (gpio_i[25]),
    .dio_p (fmc_txen));

  assign dac_fifo_bypass = gpio_o[40];

  /* PMOD GPIOs 48-51 */
  ad_iobuf #(
    .DATA_WIDTH(4)
  ) i_iobuf_pmod (
    .dio_t (gpio_t[48+:4]),
    .dio_i (gpio_o[48+:4]),
    .dio_o (gpio_i[48+:4]),
    .dio_p (pmod_gpio));

  /* PMOD SPI */
  assign pmod_spi_csn = spi1_csn[0];

  /* Board GPIOS. Buttons, LEDs, etc... */
  assign gpio_i[24: 8] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[7:0];

  assign gpio_i[94:52] = gpio_o[94:52];
  assign gpio_i[47:32] = gpio_o[47:32];
  assign gpio_i[31:26] = gpio_o[31:26];
  assign gpio_i[ 7: 0] = gpio_o[7:0];

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .dac_fifo_bypass (dac_fifo_bypass),
    .spi0_csn (),
    .spi0_miso (),
    .spi0_mosi (),
    .spi0_sclk (),
    .spi1_csn (spi1_csn),
    .spi1_miso (pmod_spi_miso),
    .spi1_mosi (pmod_spi_mosi),
    .spi1_sclk (pmod_spi_clk),
    .spi_fmc_csn_i (spi_fmc_csn),
    .spi_fmc_csn_o (spi_fmc_csn),
    .spi_fmc_clk_i (spi_clk),
    .spi_fmc_clk_o (spi_clk),
    .spi_fmc_sdo_i (spi_mosi),
    .spi_fmc_sdo_o (spi_mosi),
    .spi_fmc_sdi_i (spi_miso),
    .tx_data_0_n (tx_data_n[0]),
    .tx_data_0_p (tx_data_p[0]),
    .tx_data_1_n (tx_data_n[1]),
    .tx_data_1_p (tx_data_p[1]),
    .tx_data_2_n (tx_data_n[2]),
    .tx_data_2_p (tx_data_p[2]),
    .tx_data_3_n (tx_data_n[3]),
    .tx_data_3_p (tx_data_p[3]),
    .tx_data_4_n (tx_data_n[4]),
    .tx_data_4_p (tx_data_p[4]),
    .tx_data_5_n (tx_data_n[5]),
    .tx_data_5_p (tx_data_p[5]),
    .tx_data_6_n (tx_data_n[6]),
    .tx_data_6_p (tx_data_p[6]),
    .tx_data_7_n (tx_data_n[7]),
    .tx_data_7_p (tx_data_p[7]),
    .tx_ref_clk_0 (tx_ref_clk),
    .tx_ref_clk_4 (tx_ref_clk),
    .tx_sync_0 (tx_sync),
    .tx_sysref_0 (tx_sysref));

endmodule
