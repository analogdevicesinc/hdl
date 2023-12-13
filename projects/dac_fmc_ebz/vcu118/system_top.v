// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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
  parameter NUM_LINKS = 2,
  parameter DEVICE_CODE = 0
) (
  input                   sys_rst,
  input                   sys_clk_p,
  input                   sys_clk_n,

  input                   uart_sin,
  output                  uart_sout,

  output                  ddr4_act_n,
  output      [16:0]      ddr4_addr,
  output      [ 1:0]      ddr4_ba,
  output      [ 0:0]      ddr4_bg,
  output                  ddr4_ck_p,
  output                  ddr4_ck_n,
  output      [ 0:0]      ddr4_cke,
  output      [ 0:0]      ddr4_cs_n,
  inout       [ 7:0]      ddr4_dm_n,
  inout       [63:0]      ddr4_dq,
  inout       [ 7:0]      ddr4_dqs_p,
  inout       [ 7:0]      ddr4_dqs_n,
  output      [ 0:0]      ddr4_odt,
  output                  ddr4_reset_n,

  output                  mdio_mdc,
  inout                   mdio_mdio,
  input                   phy_clk_p,
  input                   phy_clk_n,
  output                  phy_rst_n,
  input                   phy_rx_p,
  input                   phy_rx_n,
  output                  phy_tx_p,
  output                  phy_tx_n,

  inout       [16:0]      gpio_bd,

  output                  iic_rstn,
  inout                   iic_scl,
  inout                   iic_sda,

  input                   tx_ref_clk_121_p,
  input                   tx_ref_clk_121_n,
  input                   tx_ref_clk_126_p,
  input                   tx_ref_clk_126_n,
  input                   tx_sysref_p,
  input                   tx_sysref_n,
  input       [ 1:0]      tx_sync_p,
  input       [ 1:0]      tx_sync_n,
  output      [ 7:0]      tx_data_p,
  output      [ 7:0]      tx_data_n,

  output                  spi_csn_dac,
  output                  spi_csn_clk,
  output                  spi_csn_clk2,
  input                   spi_miso,
  output                  spi_mosi,
  output                  spi_clk,
  output                  spi_en,

  inout       [ 4:0]      dac_ctrl
);

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire    [ 2:0]  spi_csn;
  wire            tx_ref_clk;
  wire            tx_sysref;
  wire    [ 1:0]  tx_sync;
  wire            tx_sysref_loc;

  assign iic_rstn = 1'b1;
  // spi

  // spi_en is active ...
  //   ... high for AD9135-FMC-EBZ, AD9136-FMC-EBZ, AD9144-FMC-EBZ,
  //   ... low for AD9171-FMC-EBZ, AD9172-FMC-EBZ, AD9173-FMC-EBZ
  // If you are planning to build a bitstream for just one of those boards you
  // can hardwire the logic level here.
  //
  assign spi_en = (DEVICE_CODE <= 2);

  //                                        9135/9144/9172    916(1,2,3,4)
  assign spi_csn_dac  = spi_csn[1];
  assign spi_csn_clk  = spi_csn[0];    //   HMC7044          AD9508
  assign spi_csn_clk2 = spi_csn[2];    //   NC               ADF4355

  /* JESD204 clocks and control signals */
  IBUFDS_GTE4 i_ibufds_tx_ref_clk_121 (
    .CEB (1'd0),
    .I (tx_ref_clk_121_p),
    .IB (tx_ref_clk_121_n),
    .O (tx_ref_clk_121),
    .ODIV2 ());

  IBUFDS_GTE4 i_ibufds_tx_ref_clk_126 (
    .CEB (1'd0),
    .I (tx_ref_clk_126_p),
    .IB (tx_ref_clk_126_n),
    .O (tx_ref_clk_126),
    .ODIV2 ());

  IBUFDS i_ibufds_tx_sysref (
    .I (tx_sysref_p),
    .IB (tx_sysref_n),
    .O (tx_sysref));

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
    .DATA_WIDTH(5)
  ) i_iobuf (
    .dio_t (gpio_t[21+:5]),
    .dio_i (gpio_o[21+:5]),
    .dio_o (gpio_i[21+:5]),
    .dio_p ({
      dac_ctrl           /* 25 - 21 */
    }));

  /*
  * Control signals for different FMC boards:
  *
  * dac_ctrl  FMC   9144 like    9162 like       9172 like
  *        0  H13   FMC_TXEN_0   FMC_TXEN_0      FMC_PE_CTRL
  *        1  C10   NC           NC              FMC_TXEN_0
  *        2  C11   NC           NC              FMC_TXEN_1
  *        3  H14   FMC_TXEN_1   NC              NC
  *        4  D15   NC           FMC_HMC849VCTL  NC
  */

  assign dac_fifo_bypass = gpio_o[40];

  /* Board GPIOS. Buttons, LEDs, etc... */
  ad_iobuf #(
    .DATA_WIDTH(17)
  ) i_iobuf_bd (
    .dio_t (gpio_t[0+:17]),
    .dio_i (gpio_o[0+:17]),
    .dio_o (gpio_i[0+:17]),
    .dio_p (gpio_bd));

  assign gpio_i[63:26] = gpio_o[63:26];
  assign gpio_i[20:17] = gpio_o[20:17];

  system_wrapper i_system_wrapper (
    .ddr4_act_n (ddr4_act_n),
    .ddr4_adr (ddr4_addr),
    .ddr4_ba (ddr4_ba),
    .ddr4_bg (ddr4_bg),
    .ddr4_ck_c (ddr4_ck_n),
    .ddr4_ck_t (ddr4_ck_p),
    .ddr4_cke (ddr4_cke),
    .ddr4_cs_n (ddr4_cs_n),
    .ddr4_dm_n (ddr4_dm_n),
    .ddr4_dq (ddr4_dq),
    .ddr4_dqs_c (ddr4_dqs_n),
    .ddr4_dqs_t (ddr4_dqs_p),
    .ddr4_odt (ddr4_odt),
    .ddr4_reset_n (ddr4_reset_n),
    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .mdio_mdc (mdio_mdc),
    .mdio_mdio_io (mdio_mdio),
    .sgmii_phyclk_clk_n (phy_clk_n),
    .sgmii_phyclk_clk_p (phy_clk_p),
    .phy_rst_n (phy_rst_n),
    .phy_sd (1'b1),
    .sgmii_rxn (phy_rx_n),
    .sgmii_rxp (phy_rx_p),
    .sgmii_txn (phy_tx_n),
    .sgmii_txp (phy_tx_p),
    .spi_clk_i (spi_clk),
    .spi_clk_o (spi_clk),
    .spi_csn_i (spi_csn),
    .spi_csn_o (spi_csn),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (spi_mosi),
    .spi_sdo_o (spi_mosi),
    .sys_clk_clk_n (sys_clk_n),
    .sys_clk_clk_p (sys_clk_p),
    .sys_rst (sys_rst),
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
    .tx_ref_clk_0 (tx_ref_clk_126),
    .tx_ref_clk_4 (tx_ref_clk_121),
    .tx_sync_0 (tx_sync),
    .tx_sysref_0 (tx_sysref),
    .uart_sin (uart_sin),
    .uart_sout (uart_sout),
    .dac_fifo_bypass (dac_fifo_bypass));

  // AD9161/2/4-FMC-EBZ works only in single link,
  // The FMC connector instead of SYNC1 has SYSREF connected to it
  assign tx_sysref_loc = (DEVICE_CODE == 3) ? tx_sync[1] : tx_sysref;

endmodule
