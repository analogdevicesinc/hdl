// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2019-2025 Analog Devices, Inc. All rights reserved.
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

module system_top #(
  parameter NUM_LINKS = 1
) (
  input   [12:0]  gpio_bd_i,
  output  [ 7:0]  gpio_bd_o,

  input           tx_ref_clk_p,
  input           tx_ref_clk_n,
  input   [ 1:0]  tx_sync_p,
  input   [ 1:0]  tx_sync_n,
  output  [ 7:0]  tx_data_p,
  output  [ 7:0]  tx_data_n,

  output          spi_csn_dac,
  output          spi_csn_clk,
  output          spi_csn_clk2,
  input           spi_miso,
  output          spi_mosi,
  output          spi_clk,
  output          spi_en,

  output          fmc_txen_0,
  output          fmc_hmc849vctrl
);

  // internal signals

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [94:0]  gpio_t;
  wire    [ 2:0]  spi0_csn;
  wire    [ 2:0]  spi1_csn;
  wire            tx_ref_clk;
  wire    [ 1:0]  tx_sync;
  wire            dac_fifo_bypass;

  // spi

  /* spi_en is active low
  * AD9161-FMC-EBZ, AD9162-FMC-EBZ, AD9163-FMC-EBZ, AD9164-FMC-EBZ
  */

  assign spi_en = 0;

  assign spi_csn_dac  = spi0_csn[1];    // AD916(1,2,3,4)
  assign spi_csn_clk  = spi0_csn[0];    // AD9508
  assign spi_csn_clk2 = spi0_csn[2];    // ADF4355

  /* JESD204 clocks and control signals */
  IBUFDS_GTE4 i_ibufds_tx_ref_clk (
    .CEB (1'd0),
    .I (tx_ref_clk_p),
    .IB (tx_ref_clk_n),
    .O (tx_ref_clk),
    .ODIV2 ());

  IBUFDS i_ibufds_tx_sync_0 (
    .I (tx_sync_p[0]),
    .IB (tx_sync_n[0]),
    .O (tx_sync[0]));

  IBUFDS i_ibufds_tx_sync_1 (
    .I (tx_sync_p[1]),
    .IB (tx_sync_n[1]),
    .O (tx_sync[1]));

  /* FMC GPIOs */
  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_iobuf (
    .dio_t (gpio_t[23:22]),
    .dio_i (gpio_o[23:22]),
    .dio_o (gpio_i[23:22]),
    .dio_p ({
      fmc_hmc849vctrl,
      fmc_txen_0
    }));

  assign dac_fifo_bypass = gpio_o[21];

  /* Board GPIOS. Buttons, LEDs, etc... */
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[7:0];

  assign gpio_i[94:24] = gpio_o[94:24];
  assign gpio_i[ 7: 0] = gpio_o[7:0];

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .dac_fifo_bypass(dac_fifo_bypass),
    .spi0_csn (spi0_csn),
    .spi0_miso (spi_miso),
    .spi0_mosi (spi_mosi),
    .spi0_sclk (spi_clk),
    .spi1_csn (spi1_csn),
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
    .tx_sync_0 (tx_sync[NUM_LINKS-1:0]),
    .tx_sysref_0 (tx_sync[1]));

endmodule
