// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
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
  input                   sys_clk_n,
  input                   sys_clk_p,

  output                  ddr4_act_n,
  output      [16:0]      ddr4_adr,
  output       [1:0]      ddr4_ba,
  output       [1:0]      ddr4_bg,
  output                  ddr4_ck_c,
  output                  ddr4_ck_t,
  output                  ddr4_cke,
  output                  ddr4_cs_n,
  inout        [7:0]      ddr4_dm_n,
  inout       [63:0]      ddr4_dq,
  inout        [7:0]      ddr4_dqs_c,
  inout        [7:0]      ddr4_dqs_t,
  output                  ddr4_odt,
  output                  ddr4_reset_n,

  output       [ 3:0]     gpio_led,
  input        [ 3:0]     gpio_dip_sw,
  input        [ 1:0]     gpio_pb,

  input                   core_clk_p,
  input                   core_clk_n,
  input                   ref_clk0_p,
  input                   ref_clk0_n,
  input                   ref_clk1_p,
  input                   ref_clk1_n,
  input        [ 7:0]     rx_data_p,
  input        [ 7:0]     rx_data_n,
  output       [ 7:0]     tx_data_p,
  output       [ 7:0]     tx_data_n,
  output                  rx_sync_p,
  output                  rx_sync_n,
  output                  rx_sync_1_p,
  output                  rx_sync_1_n,
  input                   tx_sync_p,
  input                   tx_sync_n,
  input                   tx_sync_1_p,
  input                   tx_sync_1_n,
  input                   tx_sync_2_p,
  input                   tx_sync_2_n,

  input                   sysref_p,
  input                   sysref_n,
  output                  sysref_out_p,
  output                  sysref_out_n,

  output                  spi_csn_ad9528,
  output                  spi_csn_adrv904x,
  output                  spi_clk,
  output                  spi_mosi,
  input                   spi_miso,

  inout                   ad9528_reset_b,
  inout                   ad9528_sysref_req,
  inout                   adrv904x_trx0_enable,
  inout                   adrv904x_trx1_enable,
  inout                   adrv904x_trx2_enable,
  inout                   adrv904x_trx3_enable,
  inout                   adrv904x_trx4_enable,
  inout                   adrv904x_trx5_enable,
  inout                   adrv904x_trx6_enable,
  inout                   adrv904x_trx7_enable,
  inout                   adrv904x_orx0_enable,
  inout                   adrv904x_orx1_enable,
  inout                   adrv904x_test,
  output                  adrv904x_reset_b,

  inout       [23:0]      adrv904x_gpio
);

  // internal signals
  wire    [95:0]  gpio_i;
  wire    [95:0]  gpio_o;
  wire    [95:0]  gpio_t;

  // Board GPIOS. Buttons, LEDs, etc...
  assign gpio_led = gpio_o[3:0];
  assign gpio_i[3:0] = gpio_o[3:0];
  assign gpio_i[7:4] = gpio_dip_sw;
  assign gpio_i[9:8] = gpio_pb;

  // Unused GPIOs
  assign gpio_i[95:77] = gpio_o[95:77];
  assign gpio_i[31:10] = gpio_o[31:10];

  wire        [ 2:0]      spi_csn;
  wire                    rx_sync;
  wire                    tx_sync;
  wire                    sysref;
  wire                    ref_clk0;
  wire                    ref_clk1;
  wire        [ 7:0]      rx_data_p_loc;
  wire        [ 7:0]      rx_data_n_loc;
  wire        [ 7:0]      tx_data_p_loc;
  wire        [ 7:0]      tx_data_n_loc;

  wire                    gt_reset;
  wire                    gt_reset_s;
  wire                    rx_reset_pll_and_datapath;
  wire                    tx_reset_pll_and_datapath;
  wire                    rx_reset_datapath;
  wire                    tx_reset_datapath;
  wire                    gt_resetdone;
  wire                    gt_powergood;
  wire                    mst_resetdone;

  // instantiations

  IBUFDS i_ibufds_core_clk (
    .I (core_clk_p),
    .IB (core_clk_n),
    .O (core_clk));

  BUFG i_ibufg_core_clk (
    .I (core_clk),
    .O (core_clk_buf));

  IBUFDS_GTE5 i_ibufds_ref_clk0 (
    .CEB (1'd0),
    .I (ref_clk0_p),
    .IB (ref_clk0_n),
    .O (ref_clk0),
    .ODIV2 (ref_clk0_odiv2));

  IBUFDS_GTE5 i_ibufds_ref_clk1 (
    .CEB (1'd0),
    .I (ref_clk1_p),
    .IB (ref_clk1_n),
    .O (ref_clk1),
    .ODIV2 (ref_clk1_odiv2));

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  OBUFDS i_obufds_rx_sync_1 (
    .I (rx_sync_1),
    .O (rx_sync_1_p),
    .OB (rx_sync_1_n));

  OBUFDS i_obufds_sysref_out (
    .I (sysref_out),
    .O (sysref_out_p),
    .OB (sysref_out_n));

  IBUFDS i_ibufds_tx_sync (
    .I (tx_sync_p),
    .IB (tx_sync_n),
    .O (tx_sync));

  IBUFDS i_ibufds_tx_sync_1 (
    .I (tx_sync_1_p),
    .IB (tx_sync_1_n),
    .O (tx_sync_1));

  IBUFDS i_ibufds_tx_sync_2 (
    .I (tx_sync_2_p),
    .IB (tx_sync_2_n),
    .O (tx_sync_2));

  IBUFDS i_ibufds_sysref (
    .I (sysref_p),
    .IB (sysref_n),
    .O (sysref));

  ad_iobuf #(
    .DATA_WIDTH(37)
  ) i_iobuf (
    .dio_t ({gpio_t[68:32]}),
    .dio_i ({gpio_o[68:32]}),
    .dio_o ({gpio_i[68:32]}),
    .dio_p ({ ad9528_reset_b,       // 68
              ad9528_sysref_req,    // 67
              adrv904x_trx0_enable, // 66
              adrv904x_trx1_enable, // 65
              adrv904x_trx2_enable, // 64
              adrv904x_trx3_enable, // 63
              adrv904x_trx4_enable, // 62
              adrv904x_trx5_enable, // 61
              adrv904x_trx6_enable, // 60
              adrv904x_trx7_enable, // 59
              adrv904x_orx0_enable, // 58
              adrv904x_orx1_enable, // 57
              adrv904x_test,        // 56
              adrv904x_gpio}));     // 55-32

  assign adrv904x_reset_b = gpio_o[69];

  assign gpio_i[70] = gt_resetdone;
  assign gpio_i[71] = mst_resetdone;
  assign gt_reset   = gpio_o[72];
  assign rx_reset_pll_and_datapath = gpio_o[73];
  assign tx_reset_pll_and_datapath = gpio_o[74];
  assign rx_reset_datapath = gpio_o[75];
  assign tx_reset_datapath = gpio_o[76];

  assign gt_reset_s    = gt_reset & gt_powergood;
  assign mst_resetdone = gt_resetdone;

  assign spi_csn_ad9528 =  spi_csn[1];
  assign spi_csn_adrv904x =  spi_csn[0];

  system_wrapper i_system_wrapper (
    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    .gpio2_i (gpio_i[95:64]),
    .gpio2_o (gpio_o[95:64]),
    .gpio2_t (gpio_t[95:64]),
    .ddr4_dimm1_sma_clk_clk_n (sys_clk_n),
    .ddr4_dimm1_sma_clk_clk_p (sys_clk_p),
    .ddr4_dimm1_act_n (ddr4_act_n),
    .ddr4_dimm1_adr (ddr4_adr),
    .ddr4_dimm1_ba (ddr4_ba),
    .ddr4_dimm1_bg (ddr4_bg),
    .ddr4_dimm1_ck_c (ddr4_ck_c),
    .ddr4_dimm1_ck_t (ddr4_ck_t),
    .ddr4_dimm1_cke (ddr4_cke),
    .ddr4_dimm1_cs_n (ddr4_cs_n),
    .ddr4_dimm1_dm_n (ddr4_dm_n),
    .ddr4_dimm1_dq (ddr4_dq),
    .ddr4_dimm1_dqs_c (ddr4_dqs_c),
    .ddr4_dimm1_dqs_t (ddr4_dqs_t),
    .ddr4_dimm1_odt (ddr4_odt),
    .ddr4_dimm1_reset_n (ddr4_reset_n),
    .gt_reset (gt_reset_s),
    .gt_reset_rx_datapath (rx_reset_datapath),
    .gt_reset_tx_datapath (tx_reset_datapath),
    .gt_reset_rx_pll_and_datapath (rx_reset_pll_and_datapath),
    .gt_reset_tx_pll_and_datapath (tx_reset_pll_and_datapath),
    .gt_powergood (gt_powergood),
    .rx_resetdone (gt_resetdone),
    .tx_resetdone (gt_resetdone),
    .core_clk(core_clk_buf),
    .rx_0_p  (rx_data_p_loc[3:0]),
    .rx_0_n  (rx_data_n_loc[3:0]),
    .rx_1_p  (rx_data_p_loc[7:4]),
    .rx_1_n  (rx_data_n_loc[7:4]),
    .rx_ref_clk_0 (ref_clk0),
    .rx_ref_clk_1 (ref_clk0),
    .rx_sysref_0 (sysref),
    .spi0_sclk (spi_clk),
    .spi0_csn (spi_csn),
    .spi0_miso (spi_miso),
    .spi0_mosi (spi_mosi),
    .spi1_sclk (),
    .spi1_csn (),
    .spi1_miso (1'b0),
    .spi1_mosi (),
    .tx_0_p  (tx_data_p_loc[3:0]),
    .tx_0_n  (tx_data_n_loc[3:0]),
    .tx_1_p  (tx_data_p_loc[7:4]),
    .tx_1_n  (tx_data_n_loc[7:4]),
    .tx_ref_clk_0 (ref_clk0),
    .tx_ref_clk_1 (ref_clk0),
    .tx_sysref_0 (sysref),
    .ext_sync_in (sysref));

  assign rx_data_p_loc[7:0] = rx_data_p[7:0];
  assign rx_data_n_loc[7:0] = rx_data_n[7:0];

  assign tx_data_p[7:0] = tx_data_p_loc[7:0];
  assign tx_data_n[7:0] = tx_data_n_loc[7:0];

endmodule
