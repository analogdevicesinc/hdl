// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

module system_top # (
  parameter TX_JESD_L = 8,
  parameter TX_NUM_LINKS = 1,
  parameter RX_JESD_L = 8,
  parameter RX_NUM_LINKS = 1,
  parameter SHARED_DEVCLK = 0,
  parameter JESD_MODE = "8B10B",
  parameter TDD_SUPPORT = 0
) (

  input   [12:0]  gpio_bd_i,
  output  [ 7:0]  gpio_bd_o,

  // AD9081

  input  [1:0]  agc0,
  input  [1:0]  agc1,
  input  [1:0]  agc2,
  input  [1:0]  agc3,
  input         clkin6_n,
  input         clkin6_p,
  input         clkin10_n,
  input         clkin10_p,
  input         fpga_refclk_in_n,
  input         fpga_refclk_in_p,
  input  [RX_JESD_L*RX_NUM_LINKS-1:0]  rx_data_n,
  input  [RX_JESD_L*RX_NUM_LINKS-1:0]  rx_data_p,
  output [TX_JESD_L*TX_NUM_LINKS-1:0]  tx_data_n,
  output [TX_JESD_L*TX_NUM_LINKS-1:0]  tx_data_p,
  input    fpga_syncin_0_n,
  input    fpga_syncin_0_p,
  inout    fpga_syncin_1_n,
  inout    fpga_syncin_1_p,
  output   fpga_syncout_0_n,
  output   fpga_syncout_0_p,
  inout    fpga_syncout_1_n,
  inout    fpga_syncout_1_p,
  inout  [10:0] gpio,
  inout         hmc_gpio1,
  output        hmc_sync,
  input  [1:0]  irqb,
  output        rstb,
  output [1:0]  rxen,
  output        spi0_csb,
  input         spi0_miso,
  output        spi0_mosi,
  output        spi0_sclk,
  output        spi1_csb,
  output        spi1_sclk,
  inout         spi1_sdio,
  input         sysref2_n,
  input         sysref2_p,
  output [1:0]  txen,

  // BF SPI 01
  output       BF_SPI_SCLK_01,
  output       BF_SPI_CSB_01,
  output       BF_SPI_MOSI_01,
  input        BF_SPI_MISO_01,

  // BF SPI 02
  output       BF_SPI_SCLK_02,
  output       BF_SPI_CSB_02,
  output       BF_SPI_MOSI_02,
  input        BF_SPI_MISO_02,

  // BF SPI 03
  output       BF_SPI_SCLK_03,
  output       BF_SPI_CSB_03,
  output       BF_SPI_MOSI_03,
  input        BF_SPI_MISO_03,

  // BF SPI 04
  output       BF_SPI_SCLK_04,
  output       BF_SPI_CSB_04,
  output       BF_SPI_MOSI_04,
  input        BF_SPI_MISO_04,

  // XUD SPI
  output       XUD_SPI_SCLK,
  output       XUD_SPI_CSB,
  output       XUD_SPI_MOSI,
  input        XUD_SPI_MISO,

  // BF GPIO 01
  output TR_01,
  output TX_LOAD_01,
  output RX_LOAD_01,
  input  PG_PA_VGG_01,
  output BF_PWR_EN_01,
  output BF_PA_ON_01,

  // BF GPIO 02
  output TR_02,
  output TX_LOAD_02,
  output RX_LOAD_02,
  input  PG_PA_VGG_02,
  output BF_PWR_EN_02,
  output BF_PA_ON_02,

  // BF GPIO 03
  output TR_03,
  output TX_LOAD_03,
  output RX_LOAD_03,
  input  PG_PA_VGG_03,
  output BF_PWR_EN_03,
  output BF_PA_ON_03,

  // BF GPIO 04
  output TR_04,
  output TX_LOAD_04,
  output RX_LOAD_04,
  input  PG_PA_VGG_04,
  output BF_PWR_EN_04,
  output BF_PA_ON_04,

  // XUD GPIO
  output XUD_RX_GAIN_MODE,
  output XUD_PLL_OUTPUT_SEL,
  output XUD_TXRX0,
  output XUD_TXRX1,
  output XUD_TXRX2,
  output XUD_TXRX3,

  // Debug FMC TDD
  output tdd_sync_in_debug,
  output tdd_sync_out_debug,
  output tdd_enable_debug
);

  // internal signals
  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [94:0]  gpio_t;
  
  wire    [ 2:0]  spi0_csn;
  wire    [ 2:0]  spi1_csn;
  wire            spi1_mosi;
  wire            spi1_miso;

  wire            ref_clk;
  wire            sysref;
  wire    [TX_NUM_LINKS-1:0]   tx_syncin;
  wire    [RX_NUM_LINKS-1:0]   rx_syncout;

  wire    [7:0]   rx_data_p_loc;
  wire    [7:0]   rx_data_n_loc;
  wire    [7:0]   tx_data_p_loc;
  wire    [7:0]   tx_data_n_loc;

  wire            clkin6;
  wire            clkin10;
  wire            tx_device_clk;
  wire            rx_device_clk_internal;
  wire            rx_device_clk;

  wire            tdd_sync;
  wire            tdd_sync_out;
  wire    [20:0]  tdd_channels;
  wire            tdd_enabled;
  wire            tdd_support;

  assign gpio_bd_o = gpio_o[7:0];

  assign tdd_sync = gpio_i[21];

  wire  [29:0]  adsy2301_gpio;

  assign tdd_enabled = tdd_channels[0];
  assign tdd_support = TDD_SUPPORT ? tdd_enabled : 1'b0;

  assign TR_01              = tdd_support ? tdd_channels[1]  : adsy2301_gpio[0];
  assign TX_LOAD_01         = tdd_support ? tdd_channels[2]  : adsy2301_gpio[1];
  assign RX_LOAD_01         = tdd_support ? tdd_channels[3]  : adsy2301_gpio[2];
  assign BF_PWR_EN_01       = tdd_support ? tdd_channels[4]  : adsy2301_gpio[3];
  assign BF_PA_ON_01        = tdd_support ? tdd_channels[5]  : adsy2301_gpio[4];
  assign TR_02              = tdd_support ? tdd_channels[6]  : adsy2301_gpio[5];
  assign TX_LOAD_02         = tdd_support ? tdd_channels[7]  : adsy2301_gpio[6];
  assign RX_LOAD_02         = tdd_support ? tdd_channels[8]  : adsy2301_gpio[7];
  assign BF_PWR_EN_02       = tdd_support ? tdd_channels[9]  : adsy2301_gpio[8];
  assign BF_PA_ON_02        = tdd_support ? tdd_channels[10] : adsy2301_gpio[9];
  assign TR_03              = tdd_support ? tdd_channels[11] : adsy2301_gpio[10];
  assign TX_LOAD_03         = tdd_support ? tdd_channels[12] : adsy2301_gpio[11];
  assign RX_LOAD_03         = tdd_support ? tdd_channels[13] : adsy2301_gpio[12];
  assign BF_PWR_EN_03       = tdd_support ? tdd_channels[14] : adsy2301_gpio[13];
  assign BF_PA_ON_03        = tdd_support ? tdd_channels[15] : adsy2301_gpio[14];
  assign TR_04              = tdd_support ? tdd_channels[16] : adsy2301_gpio[15];
  assign TX_LOAD_04         = tdd_support ? tdd_channels[17] : adsy2301_gpio[16];
  assign RX_LOAD_04         = tdd_support ? tdd_channels[18] : adsy2301_gpio[17];
  assign BF_PWR_EN_04       = tdd_support ? tdd_channels[19] : adsy2301_gpio[18];
  assign BF_PA_ON_04        = tdd_support ? tdd_channels[20] : adsy2301_gpio[19];

  assign XUD_RX_GAIN_MODE   = adsy2301_gpio[20];
  assign XUD_PLL_OUTPUT_SEL = adsy2301_gpio[21];
  assign XUD_TXRX0          = adsy2301_gpio[22];
  assign XUD_TXRX1          = adsy2301_gpio[23];
  assign XUD_TXRX2          = adsy2301_gpio[24];
  assign XUD_TXRX3          = adsy2301_gpio[25];

  assign adsy2301_gpio[26]  = PG_PA_VGG_01;
  assign adsy2301_gpio[27]  = PG_PA_VGG_02;
  assign adsy2301_gpio[28]  = PG_PA_VGG_03;
  assign adsy2301_gpio[29]  = PG_PA_VGG_04;

  assign tdd_sync_in_debug  = tdd_sync;
  assign tdd_sync_out_debug = tdd_sync_out;
  assign tdd_enable_debug   = tdd_enabled;

  IBUFDS_GTE4 i_ibufds_ref_clk (
    .CEB (1'd0),
    .I (fpga_refclk_in_p),
    .IB (fpga_refclk_in_n),
    .O (ref_clk),
    .ODIV2 ());

  IBUFDS i_ibufds_sysref (
    .I (sysref2_p),
    .IB (sysref2_n),
    .O (sysref));

  IBUFDS i_ibufds_tx_device_clk (
    .I (clkin6_p),
    .IB (clkin6_n),
    .O (clkin6));

  IBUFDS i_ibufds_rx_device_clk (
    .I (clkin10_p),
    .IB (clkin10_n),
    .O (clkin10));

  IBUFDS i_ibufds_syncin_0 (
    .I (fpga_syncin_0_p),
    .IB (fpga_syncin_0_n),
    .O (tx_syncin[0]));

  OBUFDS i_obufds_syncout_0 (
    .I (rx_syncout[0]),
    .O (fpga_syncout_0_p),
    .OB (fpga_syncout_0_n));

  BUFG i_tx_device_clk (
    .I (clkin6),
    .O (tx_device_clk));

  BUFG i_rx_device_clk (
    .I (clkin10),
    .O (rx_device_clk_internal));

  assign rx_device_clk = SHARED_DEVCLK ? tx_device_clk : rx_device_clk_internal;

  // spi

  assign spi0_csb = spi0_csn[0];
  assign spi1_csb = spi1_csn[0];

  ad_3w_spi #(
    .NUM_OF_SLAVES(1)
  ) i_spi (
    .spi_csn (spi1_csn[0]),
    .spi_clk (spi1_sclk),
    .spi_mosi (spi1_mosi),
    .spi_miso (spi1_miso),
    .spi_sdio (spi1_sdio),
    .spi_dir ());

  // gpios

  ad_iobuf #(
    .DATA_WIDTH(12)
  ) i_iobuf (
    .dio_t (gpio_t[43:32]),
    .dio_i (gpio_o[43:32]),
    .dio_o (gpio_i[43:32]),
    .dio_p ({hmc_gpio1,       // 43
             gpio[10:0]}));   // 42-32

  assign gpio_i[44] = agc0[0];
  assign gpio_i[45] = agc0[1];
  assign gpio_i[46] = agc1[0];
  assign gpio_i[47] = agc1[1];
  assign gpio_i[48] = agc2[0];
  assign gpio_i[49] = agc2[1];
  assign gpio_i[50] = agc3[0];
  assign gpio_i[51] = agc3[1];
  assign gpio_i[52] = irqb[0];
  assign gpio_i[53] = irqb[1];

  assign hmc_sync = gpio_o[54];
  assign rstb     = gpio_o[55];
  assign rxen[0]  = gpio_o[56];
  assign rxen[1]  = gpio_o[57];
  assign txen[0]  = gpio_o[58];
  assign txen[1]  = gpio_o[59];

  generate
  if (TX_NUM_LINKS > 1 & JESD_MODE == "8B10B") begin
    assign tx_syncin[1] = fpga_syncin_1_p;
  end else begin
    ad_iobuf #(
      .DATA_WIDTH(2)
    ) i_syncin_iobuf (
      .dio_t (gpio_t[61:60]),
      .dio_i (gpio_o[61:60]),
      .dio_o (gpio_i[61:60]),
      .dio_p ({fpga_syncin_1_n,      // 61
               fpga_syncin_1_p}));   // 60
  end

  if (RX_NUM_LINKS > 1 & JESD_MODE == "8B10B") begin
    assign fpga_syncout_1_p = rx_syncout[1];
    assign fpga_syncout_1_n = 0;
  end else begin
    ad_iobuf #(
      .DATA_WIDTH(2)
    ) i_syncout_iobuf (
      .dio_t (gpio_t[63:62]),
      .dio_i (gpio_o[63:62]),
      .dio_o (gpio_i[63:62]),
      .dio_p ({fpga_syncout_1_n,      // 63
               fpga_syncout_1_p}));   // 62
  end
  endgenerate
  /* Board GPIOS. Buttons, LEDs, etc... */
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[7:0];

  // Unused GPIOs
  assign gpio_i[94:64] = gpio_o[94:64];
  assign gpio_i[31:22] = gpio_o[31:22];
  assign gpio_i[7:0] = gpio_o[7:0];

  // instantiations

  system_wrapper i_system_wrapper (
    .gpio_out_tri_o (adsy2301_gpio[25:0]),
    .gpio_in_tri_i (adsy2301_gpio[29:26]),
    .bf_spi_sclk_01 (BF_SPI_SCLK_01),
    .bf_spi_csb_01 (BF_SPI_CSB_01),
    .bf_spi_mosi_01 (BF_SPI_MOSI_01),
    .bf_spi_miso_01 (BF_SPI_MISO_01),
    .bf_spi_sclk_02 (BF_SPI_SCLK_02),
    .bf_spi_csb_02 (BF_SPI_CSB_02),
    .bf_spi_mosi_02 (BF_SPI_MOSI_02),
    .bf_spi_miso_02 (BF_SPI_MISO_02),
    .bf_spi_sclk_03 (BF_SPI_SCLK_03),
    .bf_spi_csb_03 (BF_SPI_CSB_03),
    .bf_spi_mosi_03 (BF_SPI_MOSI_03),
    .bf_spi_miso_03 (BF_SPI_MISO_03),
    .bf_spi_sclk_04 (BF_SPI_SCLK_04),
    .bf_spi_csb_04 (BF_SPI_CSB_04),
    .bf_spi_mosi_04 (BF_SPI_MOSI_04),
    .bf_spi_miso_04 (BF_SPI_MISO_04),
    .xud_spi_sclk (XUD_SPI_SCLK),
    .xud_spi_csb (XUD_SPI_CSB),
    .xud_spi_mosi (XUD_SPI_MOSI),
    .xud_spi_miso (XUD_SPI_MISO),
    .tdd_sync (tdd_sync),
    .tdd_sync_out (tdd_sync_out),
    .tdd_channels (tdd_channels),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .spi0_csn (spi0_csn),
    .spi0_miso (spi0_miso),
    .spi0_mosi (spi0_mosi),
    .spi0_sclk (spi0_sclk),
    .spi1_csn (spi1_csn),
    .spi1_miso (spi1_miso),
    .spi1_mosi (spi1_mosi),
    .spi1_sclk (spi1_sclk),
    // FMC HPC
    .rx_data_0_n (rx_data_n_loc[0]),
    .rx_data_0_p (rx_data_p_loc[0]),
    .rx_data_1_n (rx_data_n_loc[1]),
    .rx_data_1_p (rx_data_p_loc[1]),
    .rx_data_2_n (rx_data_n_loc[2]),
    .rx_data_2_p (rx_data_p_loc[2]),
    .rx_data_3_n (rx_data_n_loc[3]),
    .rx_data_3_p (rx_data_p_loc[3]),
    .rx_data_4_n (rx_data_n_loc[4]),
    .rx_data_4_p (rx_data_p_loc[4]),
    .rx_data_5_n (rx_data_n_loc[5]),
    .rx_data_5_p (rx_data_p_loc[5]),
    .rx_data_6_n (rx_data_n_loc[6]),
    .rx_data_6_p (rx_data_p_loc[6]),
    .rx_data_7_n (rx_data_n_loc[7]),
    .rx_data_7_p (rx_data_p_loc[7]),
    .tx_data_0_n (tx_data_n_loc[0]),
    .tx_data_0_p (tx_data_p_loc[0]),
    .tx_data_1_n (tx_data_n_loc[1]),
    .tx_data_1_p (tx_data_p_loc[1]),
    .tx_data_2_n (tx_data_n_loc[2]),
    .tx_data_2_p (tx_data_p_loc[2]),
    .tx_data_3_n (tx_data_n_loc[3]),
    .tx_data_3_p (tx_data_p_loc[3]),
    .tx_data_4_n (tx_data_n_loc[4]),
    .tx_data_4_p (tx_data_p_loc[4]),
    .tx_data_5_n (tx_data_n_loc[5]),
    .tx_data_5_p (tx_data_p_loc[5]),
    .tx_data_6_n (tx_data_n_loc[6]),
    .tx_data_6_p (tx_data_p_loc[6]),
    .tx_data_7_n (tx_data_n_loc[7]),
    .tx_data_7_p (tx_data_p_loc[7]),
    .ref_clk_q0 (ref_clk),
    .ref_clk_q1 (ref_clk),
    .rx_device_clk (rx_device_clk),
    .tx_device_clk (tx_device_clk),
    .rx_sync_0 (rx_syncout),
    .tx_sync_0 (tx_syncin),
    .rx_sysref_0 (sysref),
    .tx_sysref_0 (sysref));

  assign rx_data_p_loc[RX_JESD_L*RX_NUM_LINKS-1:0] = rx_data_p[RX_JESD_L*RX_NUM_LINKS-1:0];
  assign rx_data_n_loc[RX_JESD_L*RX_NUM_LINKS-1:0] = rx_data_n[RX_JESD_L*RX_NUM_LINKS-1:0];

  assign tx_data_p[TX_JESD_L*TX_NUM_LINKS-1:0] = tx_data_p_loc[TX_JESD_L*TX_NUM_LINKS-1:0];
  assign tx_data_n[TX_JESD_L*TX_NUM_LINKS-1:0] = tx_data_n_loc[TX_JESD_L*TX_NUM_LINKS-1:0];

endmodule
