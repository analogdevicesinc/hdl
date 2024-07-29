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

  input                   ref_clk_p,
  input                   ref_clk_n,
  input                   core_clk_p,
  input                   core_clk_n,
  input       [ 3:0]      rx_data_p,
  input       [ 3:0]      rx_data_n,
  output      [ 3:0]      tx_data_p,
  output      [ 3:0]      tx_data_n,
  output                  rx_sync_p,
  output                  rx_sync_n,
  output                  rx_os_sync_p,
  output                  rx_os_sync_n,
  input                   tx_sync_p,
  input                   tx_sync_n,
  input                   tx_sync_1_p,
  input                   tx_sync_1_n,
  input                   sysref_p,
  input                   sysref_n,

  output                  spi_csn_ad9528,
  output                  spi_csn_adrv9026,
  output                  spi_clk,
  output                  spi_mosi,
  input                   spi_miso,

  inout                   ad9528_reset_b,
  inout                   ad9528_sysref_req,
  inout                   adrv9026_tx1_enable,
  inout                   adrv9026_tx2_enable,
  inout                   adrv9026_tx3_enable,
  inout                   adrv9026_tx4_enable,
  inout                   adrv9026_rx1_enable,
  inout                   adrv9026_rx2_enable,
  inout                   adrv9026_rx3_enable,
  inout                   adrv9026_rx4_enable,
  inout                   adrv9026_test,
  output                  adrv9026_reset_b,
  inout                   adrv9026_gpint1,
  inout                   adrv9026_gpint2,
  inout                   adrv9026_orx_ctrl_a,
  inout                   adrv9026_orx_ctrl_b,
  inout                   adrv9026_orx_ctrl_c,
  inout                   adrv9026_orx_ctrl_d,

  inout                   adrv9026_gpio_00,
  inout                   adrv9026_gpio_01,
  inout                   adrv9026_gpio_02,
  inout                   adrv9026_gpio_03,
  inout                   adrv9026_gpio_04,
  inout                   adrv9026_gpio_05,
  inout                   adrv9026_gpio_06,
  inout                   adrv9026_gpio_07,
  inout                   adrv9026_gpio_08,
  inout                   adrv9026_gpio_09,
  inout                   adrv9026_gpio_10,
  inout                   adrv9026_gpio_11,
  inout                   adrv9026_gpio_12,
  inout                   adrv9026_gpio_13,
  inout                   adrv9026_gpio_14,
  inout                   adrv9026_gpio_15,
  inout                   adrv9026_gpio_16,
  inout                   adrv9026_gpio_17,
  inout                   adrv9026_gpio_18
);

  // internal signals

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
  assign gpio_i[95:76] = gpio_o[95:76];
  assign gpio_i[31:10] = gpio_o[31:10];

  wire        [ 2:0]      spi_csn;
  wire                    ref_clk;
  wire                    rx_sync;
  wire                    rx_os_sync;
  wire                    tx_sync;
  wire                    tx_sync_1;
  wire                    sysref;
  wire        [ 3:0]      rx_data_p_loc;
  wire        [ 3:0]      rx_data_n_loc;
  wire        [ 3:0]      tx_data_p_loc;
  wire        [ 3:0]      tx_data_n_loc;
  wire                    gt_reset;
  wire                    gt_reset_s;
  wire                    rx_reset_pll_and_datapath;
  wire                    tx_reset_pll_and_datapath;
  wire                    rx_reset_datapath;
  wire                    tx_reset_datapath;
  wire                    gt_resetdone;
  wire                    gt_powergood;
  wire                    mst_resetdone;

  assign rx_os_sync = 1'b0;
  assign adrv9026_reset_b = gpio_o[68];

  assign gpio_i[69] = gt_resetdone;
  assign gpio_i[70] = mst_resetdone;
  assign gt_reset   = gpio_o[71];
  assign rx_reset_pll_and_datapath = gpio_o[72];
  assign tx_reset_pll_and_datapath = gpio_o[73];
  assign rx_reset_datapath = gpio_o[74];
  assign tx_reset_datapath = gpio_o[75];

  // instantiations

  IBUFDS_GTE5 i_ibufds_ref_clk (
    .CEB (1'd0),
    .I (ref_clk_p),
    .IB (ref_clk_n),
    .O (ref_clk),
    .ODIV2 (ref_clk_odiv));

  IBUFDS i_core_clk_ibufds_1 (
    .I (core_clk_p),
    .IB (core_clk_n),
    .O (core_clk_in));

  BUFG i_core_clk_bufg (
    .I (core_clk_in),
    .O (core_clk));

  OBUFDS i_obufds_rx_sync (
    .I (~rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  OBUFDS i_obufds_rx_os_sync (
    .I (rx_os_sync),
    .O (rx_os_sync_p),
    .OB (rx_os_sync_n));

  IBUFDS i_ibufds_tx_sync (
    .I (tx_sync_p),
    .IB (tx_sync_n),
    .O (tx_sync));

  IBUFDS i_ibufds_tx_sync_1 (
    .I (tx_sync_1_p),
    .IB (tx_sync_1_n),
    .O (tx_sync_1));

  IBUFDS i_ibufds_sysref (
    .I (sysref_p),
    .IB (sysref_n),
    .O (sysref));

  ad_iobuf #(
    .DATA_WIDTH(36)
    ) i_iobuf (
    .dio_t ({gpio_t[67:32]}),
    .dio_i ({gpio_o[67:32]}),
    .dio_o ({gpio_i[67:32]}),
    .dio_p ({ ad9528_reset_b,       // 67
              ad9528_sysref_req,    // 66
              adrv9026_tx1_enable,  // 65
              adrv9026_tx2_enable,  // 64
              adrv9026_tx3_enable,  // 63
              adrv9026_tx4_enable,  // 62
              adrv9026_rx1_enable,  // 61
              adrv9026_rx2_enable,  // 60
              adrv9026_rx3_enable,  // 59
              adrv9026_rx4_enable,  // 58
              adrv9026_test,        // 57
              adrv9026_gpint1,      // 56
              adrv9026_gpint2,      // 55
              adrv9026_orx_ctrl_a,  // 54
              adrv9026_orx_ctrl_b,  // 53
              adrv9026_orx_ctrl_c,  // 52
              adrv9026_orx_ctrl_d,  // 51
              adrv9026_gpio_00,     // 50
              adrv9026_gpio_01,     // 49
              adrv9026_gpio_02,     // 48
              adrv9026_gpio_03,     // 47
              adrv9026_gpio_04,     // 46
              adrv9026_gpio_05,     // 45
              adrv9026_gpio_06,     // 44
              adrv9026_gpio_07,     // 43
              adrv9026_gpio_08,     // 42
              adrv9026_gpio_09,     // 41
              adrv9026_gpio_10,     // 40
              adrv9026_gpio_11,     // 39
              adrv9026_gpio_12,     // 38
              adrv9026_gpio_13,     // 37
              adrv9026_gpio_14,     // 36
              adrv9026_gpio_15,     // 35
              adrv9026_gpio_16,     // 34
              adrv9026_gpio_17,     // 33
              adrv9026_gpio_18}));  // 32

  assign spi_csn_adrv9026 =  spi_csn[0];
  assign spi_csn_ad9528 =  spi_csn[1];

  assign gt_reset_s    = gt_reset & gt_powergood;
  assign mst_resetdone = gt_resetdone;

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
    .spi0_sclk (spi_clk),
    .spi0_csn (spi_csn),
    .spi0_miso (spi_miso),
    .spi0_mosi (spi_mosi),
    .spi1_sclk (),
    .spi1_csn (),
    .spi1_miso (1'b0),
    .spi1_mosi (),
    .gt_powergood (gt_powergood),
    .gt_reset (gt_reset_s),
    .gt_reset_rx_datapath (rx_reset_datapath),
    .gt_reset_tx_datapath (tx_reset_datapath),
    .gt_reset_rx_pll_and_datapath (rx_reset_pll_and_datapath),
    .gt_reset_tx_pll_and_datapath (tx_reset_pll_and_datapath),
    .rx_resetdone (gt_resetdone),
    .tx_resetdone (gt_resetdone),
    .core_clk (core_clk),
    .rx_ref_clk_0 (ref_clk),
    .rx_0_n (rx_data_n_loc[3:0]),
    .rx_0_p (rx_data_p_loc[3:0]),
    .rx_sync_0 (rx_sync),
    .rx_sysref_0 (sysref),
    .tx_ref_clk_0 (ref_clk),
    .tx_0_n (tx_data_n_loc[3:0]),
    .tx_0_p (tx_data_p_loc[3:0]),
    .tx_sync_0 (tx_sync),
    .tx_sysref_0 (sysref));

  assign rx_data_p_loc[3:0] = rx_data_p[3:0];
  assign rx_data_n_loc[3:0] = rx_data_n[3:0];

  assign tx_data_p[3:0] = tx_data_p_loc[3:0];
  assign tx_data_n[3:0] = tx_data_n_loc[3:0];

endmodule
