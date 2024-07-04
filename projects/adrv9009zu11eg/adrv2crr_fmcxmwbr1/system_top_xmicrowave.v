// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
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

  input               fan_tach,
  output              fan_pwm,
  input               i2s_sdata_in,
  output              i2s_sdata_out,
  output              i2s_mclk,
  output              i2s_bclk,
  output              i2s_lrclk,
  inout               pmod0_d0,
  inout               pmod0_d1,
  inout               pmod0_d2,
  inout               pmod0_d3,
  inout               pmod0_d4,
  inout               pmod0_d5,
  inout               pmod0_d6,
  inout               pmod0_d7,
  output              gpio_0_exp_n, //CS_HMC7044
  output              gpio_0_exp_p, //MOSI
  input               gpio_1_exp_n, //MISO
  output              gpio_1_exp_p, //SCK
  output              gpio_2_exp_n, //CS_AD9545
  inout               gpio_3_exp_n, //RESET_HMC7044
  inout               gpio_3_exp_p, //RESET_AD9545
  inout               gpio_4_exp_n, //VCXO_SELECT
  output              led_gpio_0,
  output              led_gpio_1,
  output              led_gpio_2,
  output              led_gpio_3,
  inout               dip_gpio_0,
  inout               dip_gpio_1,
  inout               dip_gpio_2,
  inout               dip_gpio_3,
  inout               pb_gpio_0,
  inout               pb_gpio_1,
  inout               pb_gpio_2,
  inout               pb_gpio_3,
  output              resetb_ad9545,
  output              hmc7044_car_reset,
  inout               hmc7044_car_gpio_1,
  inout               hmc7044_car_gpio_2,
  inout               hmc7044_car_gpio_3,
  inout               hmc7044_car_gpio_4,
  output              spi_csn_hmc7044_car,

  inout               i2c0_scl,
  inout               i2c0_sda,

  inout               i2c1_scl,
  inout               i2c1_sda,

  input               oscout_p,
  input               oscout_n,

  input               ref_clk_a_p,
  input               ref_clk_a_n,
  input               core_clk_a_p,
  input               core_clk_a_n,
  input       [ 3:0]  rx_data_a_p,
  input       [ 3:0]  rx_data_a_n,
  output      [ 3:0]  tx_data_a_p,
  output      [ 3:0]  tx_data_a_n,

  output              rx_sync_a_p,
  output              rx_sync_a_n,
  output              rx_os_sync_a_p,
  output              rx_os_sync_a_n,
  input               tx_sync_a_p,
  input               tx_sync_a_n,
  input               tx_sync_a_1_p,
  input               tx_sync_a_1_n,
  input               sysref_a_p,
  input               sysref_a_n,

  inout               adrv9009_tx1_enable_a,
  inout               adrv9009_tx2_enable_a,
  inout               adrv9009_rx1_enable_a,
  inout               adrv9009_rx2_enable_a,
  inout               adrv9009_test_a,
  inout               adrv9009_reset_b_a,
  inout               adrv9009_gpint_a,

  inout               adrv9009_gpio_00_a,
  inout               adrv9009_gpio_01_a,
  inout               adrv9009_gpio_02_a,
  inout               adrv9009_gpio_03_a,
  inout               adrv9009_gpio_04_a,
  inout               adrv9009_gpio_05_a,
  inout               adrv9009_gpio_06_a,
  inout               adrv9009_gpio_07_a,
  inout               adrv9009_gpio_15_a,
  inout               adrv9009_gpio_08_a,
  inout               adrv9009_gpio_09_a,
  inout               adrv9009_gpio_10_a,
  inout               adrv9009_gpio_11_a,
  inout               adrv9009_gpio_12_a,
  inout               adrv9009_gpio_14_a,
  inout               adrv9009_gpio_13_a,
  inout               adrv9009_gpio_17_a,
  inout               adrv9009_gpio_16_a,
  inout               adrv9009_gpio_18_a,

  input               ref_clk_b_p,
  input               ref_clk_b_n,
  input               core_clk_b_p,
  input               core_clk_b_n,
  input       [ 3:0]  rx_data_b_p,
  input       [ 3:0]  rx_data_b_n,
  output      [ 3:0]  tx_data_b_p,
  output      [ 3:0]  tx_data_b_n,

  output              rx_sync_b_p,
  output              rx_sync_b_n,
  output              rx_os_sync_b_p,
  output              rx_os_sync_b_n,
  input               tx_sync_b_p,
  input               tx_sync_b_n,
  input               tx_sync_b_1_p,
  input               tx_sync_b_1_n,
  input               sysref_b_p,
  input               sysref_b_n,

  inout               adrv9009_tx1_enable_b,
  inout               adrv9009_tx2_enable_b,
  inout               adrv9009_rx1_enable_b,
  inout               adrv9009_rx2_enable_b,
  inout               adrv9009_test_b,
  inout               adrv9009_reset_b_b,
  inout               adrv9009_gpint_b,

  inout               adrv9009_gpio_00_b,
  inout               adrv9009_gpio_01_b,
  inout               adrv9009_gpio_02_b,
  inout               adrv9009_gpio_03_b,
  inout               adrv9009_gpio_04_b,
  inout               adrv9009_gpio_05_b,
  inout               adrv9009_gpio_06_b,
  inout               adrv9009_gpio_07_b,
  inout               adrv9009_gpio_15_b,
  inout               adrv9009_gpio_08_b,
  inout               adrv9009_gpio_09_b,
  inout               adrv9009_gpio_10_b,
  inout               adrv9009_gpio_11_b,
  inout               adrv9009_gpio_12_b,
  inout               adrv9009_gpio_14_b,
  inout               adrv9009_gpio_13_b,
  inout               adrv9009_gpio_17_b,
  inout               adrv9009_gpio_16_b,
  inout               adrv9009_gpio_18_b,

  output              hmc7044_reset,
  output              hmc7044_sync,
  inout               hmc7044_gpio_1,
  inout               hmc7044_gpio_2,
  inout               hmc7044_gpio_3,
  inout               hmc7044_gpio_4,

  output              spi_csn_adrv9009_a,
  output              spi_csn_adrv9009_b,
  output              spi_csn_hmc7044,

  input               ddr4_ref_1_clk_n,
  input               ddr4_ref_1_clk_p,

  output              ddr4_rtl_1_act_n,
  output      [16:0]  ddr4_rtl_1_adr,
  output      [1:0]   ddr4_rtl_1_ba,
  output      [0:0]   ddr4_rtl_1_bg,
  output      [0:0]   ddr4_rtl_1_ck_c,
  output      [0:0]   ddr4_rtl_1_ck_t,
  output      [0:0]   ddr4_rtl_1_cke,
  output      [0:0]   ddr4_rtl_1_cs_n,
  inout       [3:0]   ddr4_rtl_1_dm_n,
  inout       [31:0]  ddr4_rtl_1_dq,
  inout       [3:0]   ddr4_rtl_1_dqs_c,
  inout       [3:0]   ddr4_rtl_1_dqs_t,
  output      [0:0]   ddr4_rtl_1_odt,
  output              ddr4_rtl_1_reset_n,
  output              ddr4_rtl_1_par,
  input               ddr4_rtl_1_alert_n,

  output              spi_clk,
  inout               spi_sdio,
  input               spi_miso,

  //iic

  output              sclout1,
  inout               sdaout1,
  output              sclout2,
  inout               sdaout2,

  //spi

  output              spi1_clk,
  output              spi1_copi,
  input               spi1_cipo,
  output              spi1_cs0,
  output              spi1_cs1,
  output              spi1_cs2,
  output              spi1_cs3,
  output              spi1_cs4,
  output              spi1_cs5,
  output              spi1_cs6,
  output              spi1_cs7,

  output              spi2_clk,
  output              spi2_copi,
  input               spi2_cipo,
  output              spi2_cs0,
  output              spi2_cs1,
  output              spi2_cs2,
  output              spi2_cs3,
  output              spi2_cs4,
  output              spi2_cs5,
  output              spi2_cs6,
  output              spi2_cs7,

  // gpio

  inout               gpio0,
  inout               gpio1,
  inout               gpio2,
  inout               gpio3,
  inout               gpio4,
  inout               gpio5,
  inout               gpio6,
  inout               gpio7,

  // gpio dir

  inout               dir_gpio0,
  inout               dir_gpio1,
  inout               dir_gpio2,
  inout               dir_gpio3,
  inout               dir_gpio4,
  inout               dir_gpio5,
  inout               dir_gpio6,
  inout               dir_gpio7
);

  // internal signals

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [94:0]  gpio_t;

  wire    [63:0]  fmcxmwbr1_gpio_i;
  wire    [63:0]  fmcxmwbr1_gpio_o;
  wire    [63:0]  fmcxmwbr1_gpio_t;

  wire    [2:0]   spi_csn;
  wire    [7:0]   spi1_csn;
  wire    [7:0]   spi2_csn;

  wire            ref_clk_a;
  wire            core_clk_a;
  wire            core_clk_a_ds;
  wire            rx_sync_rx;
  wire            tx_sync_a;
  wire            sysref_a;
  wire            ref_clk_b;
  wire            core_clk_b;
  wire            core_clk_b_ds;
  wire            rx_sync_obs;
  wire            rx_os_sync_b;
  wire            tx_sync_b;
  wire            sysref_b;
  wire            tx_sync;
  wire            spi_mosi;
  wire            spi0_miso;
  wire            spi_miso_s;

  reg  [7:0]     spi_3_to_8_csn;

  always @(*) begin
    case (spi_csn)
      3'h0: spi_3_to_8_csn = 8'b11111110;
      3'h1: spi_3_to_8_csn = 8'b11111101;
      3'h2: spi_3_to_8_csn = 8'b11111011;
      3'h3: spi_3_to_8_csn = 8'b11110111;
      3'h4: spi_3_to_8_csn = 8'b11101111;
      3'h5: spi_3_to_8_csn = 8'b11011111;
      3'h6: spi_3_to_8_csn = 8'b10111111;
      default: spi_3_to_8_csn = 8'b11111111;
    endcase
  end

  assign spi_csn_adrv9009_a = spi_3_to_8_csn[0];
  assign spi_csn_adrv9009_b = spi_3_to_8_csn[1];
  assign spi_csn_hmc7044 = spi_3_to_8_csn[2];
  assign spi_csn_hmc7044_car = spi_3_to_8_csn[3];
  assign gpio_0_exp_n = spi_3_to_8_csn[4];
  assign gpio_1_exp_p = spi_clk;
  assign gpio_0_exp_p = spi_mosi;
  assign spi_miso_s = ((spi_3_to_8_csn[4] == 1'b0) | (spi_3_to_8_csn[5] == 1'b0))? gpio_1_exp_n : spi_miso;
  assign gpio_2_exp_n = spi_3_to_8_csn[5];

  assign spi1_cs0 = spi1_csn[0];
  assign spi1_cs1 = spi1_csn[1];
  assign spi1_cs2 = spi1_csn[2];
  assign spi1_cs3 = spi1_csn[3];
  assign spi1_cs4 = spi1_csn[4];
  assign spi1_cs5 = spi1_csn[5];
  assign spi1_cs6 = spi1_csn[6];
  assign spi1_cs7 = spi1_csn[7];

  assign spi2_cs0 = spi2_csn[0];
  assign spi2_cs1 = spi2_csn[1];
  assign spi2_cs2 = spi2_csn[2];
  assign spi2_cs3 = spi2_csn[3];
  assign spi2_cs4 = spi2_csn[4];
  assign spi2_cs5 = spi2_csn[5];
  assign spi2_cs6 = spi2_csn[6];
  assign spi2_cs7 = spi2_csn[7];

  adrv9009zu11eg_spi i_spi (
    .spi_csn(spi_3_to_8_csn),
    .spi_clk(spi_clk),
    .spi_mosi(spi_mosi),
    .spi_miso_i(spi_miso_s),
    .spi_miso_o(spi0_miso),
    .spi_sdio(spi_sdio));

  assign tx_sync = tx_sync_a & tx_sync_b;

  assign gpio_i[94:93] = gpio_o[94:93];
  assign gpio_i[31:28] = gpio_o[31:28];
  assign gpio_i[21:20] = gpio_o[21:20];

  assign fmcxmwbr1_gpio_i[63:16] = fmcxmwbr1_gpio_o[63:16];

  ad_iobuf #(
    .DATA_WIDTH(16)
  ) i_fmcxmwbr1_iobuf (
    .dio_t ({fmcxmwbr1_gpio_t[15:0]}),
    .dio_i ({fmcxmwbr1_gpio_o[15:0]}),
    .dio_o ({fmcxmwbr1_gpio_i[15:0]}),
    .dio_p ({
              dir_gpio7,   // 15
              dir_gpio6,   // 14
              dir_gpio5,   // 13
              dir_gpio4,   // 12
              dir_gpio3,   // 11
              dir_gpio2,   // 10
              dir_gpio1,   // 09
              dir_gpio0,   // 08
              gpio7,       // 07
              gpio6,       // 06
              gpio5,       // 05
              gpio4,       // 04
              gpio3,       // 03
              gpio2,       // 02
              gpio1,       // 01
              gpio0}));    // 00

  ad_iobuf #(
    .DATA_WIDTH(61)
  ) i_iobuf (
    .dio_t ({gpio_t[92:32]}),
    .dio_i ({gpio_o[92:32]}),
    .dio_o ({gpio_i[92:32]}),
    .dio_p ({
              gpio_4_exp_n,             // 92
              gpio_3_exp_n,             // 91
              gpio_3_exp_p,             // 90
              hmc7044_gpio_4,           // 89
              hmc7044_gpio_3,           // 88
              hmc7044_gpio_1,           // 87
              hmc7044_gpio_2,           // 86
              hmc7044_sync,             // 85
              hmc7044_reset,            // 84
              adrv9009_tx2_enable_b,    // 83
              adrv9009_tx1_enable_b,    // 82
              adrv9009_rx2_enable_b,    // 81
              adrv9009_rx1_enable_b,    // 80
              adrv9009_test_b,          // 79
              adrv9009_reset_b_b,       // 78
              adrv9009_gpint_b,         // 77
              adrv9009_gpio_18_b,       // 77
              adrv9009_gpio_17_b,       // 75
              adrv9009_gpio_16_b,       // 74
              adrv9009_gpio_15_b,       // 73
              adrv9009_gpio_14_b,       // 72
              adrv9009_gpio_13_b,       // 71
              adrv9009_gpio_12_b,       // 70
              adrv9009_gpio_11_b,       // 69
              adrv9009_gpio_10_b,       // 68
              adrv9009_gpio_09_b,       // 67
              adrv9009_gpio_08_b,       // 66
              adrv9009_gpio_07_b,       // 65
              adrv9009_gpio_06_b,       // 64
              adrv9009_gpio_05_b,       // 63
              adrv9009_gpio_04_b,       // 62
              adrv9009_gpio_03_b,       // 61
              adrv9009_gpio_02_b,       // 60
              adrv9009_gpio_01_b,       // 58
              adrv9009_gpio_00_b,       // 58
              adrv9009_tx2_enable_a,    // 57
              adrv9009_tx1_enable_a,    // 56
              adrv9009_rx2_enable_a,    // 55
              adrv9009_rx1_enable_a,    // 54
              adrv9009_test_a,          // 53
              adrv9009_reset_b_a,       // 52
              adrv9009_gpint_a,         // 51
              adrv9009_gpio_18_a,       // 50
              adrv9009_gpio_17_a,       // 49
              adrv9009_gpio_16_a,       // 48
              adrv9009_gpio_15_a,       // 47
              adrv9009_gpio_14_a,       // 46
              adrv9009_gpio_13_a,       // 45
              adrv9009_gpio_12_a,       // 44
              adrv9009_gpio_11_a,       // 43
              adrv9009_gpio_10_a,       // 42
              adrv9009_gpio_09_a,       // 41
              adrv9009_gpio_08_a,       // 40
              adrv9009_gpio_07_a,       // 39
              adrv9009_gpio_06_a,       // 38
              adrv9009_gpio_05_a,       // 37
              adrv9009_gpio_04_a,       // 36
              adrv9009_gpio_03_a,       // 35
              adrv9009_gpio_02_a,       // 34
              adrv9009_gpio_01_a,       // 33
              adrv9009_gpio_00_a}));    // 32

  ad_iobuf #(
    .DATA_WIDTH(6)
  ) i_carrier_iobuf_0 (
    .dio_t ({gpio_t[27:22]}),
    .dio_i ({gpio_o[27:22]}),
    .dio_o ({gpio_i[27:22]}),
    .dio_p ({
              hmc7044_car_gpio_4, // 27
              hmc7044_car_gpio_3, // 26
              hmc7044_car_gpio_2, // 25
              hmc7044_car_gpio_1, // 24
              hmc7044_car_reset,  // 23
              resetb_ad9545}));   // 22

  ad_iobuf #(
    .DATA_WIDTH(20)
  ) i_carrier_iobuf_1 (
    .dio_t ({gpio_t[19:0]}),
    .dio_i ({gpio_o[19:0]}),
    .dio_o ({gpio_i[19:0]}),
    .dio_p ({
              pmod0_d7,     // 19
              pmod0_d6,     // 18
              pmod0_d5,     // 17
              pmod0_d4,     // 16
              pmod0_d3,     // 15
              pmod0_d2,     // 14
              pmod0_d1,     // 13
              pmod0_d0,     // 12
              led_gpio_3,   // 11
              led_gpio_2,   // 10
              led_gpio_1,   // 9
              led_gpio_0,   // 8
              dip_gpio_3,   // 7
              dip_gpio_2,   // 6
              dip_gpio_1,   // 5
              dip_gpio_0,   // 4
              pb_gpio_3,    // 3
              pb_gpio_2,    // 2
              pb_gpio_1,    // 1
              pb_gpio_0})); // 0

  IBUFDS_GTE4 i_ibufds_ref_clk_1 (
    .CEB (1'd0),
    .I (ref_clk_a_p),
    .IB (ref_clk_a_n),
    .O (ref_clk_a),
    .ODIV2 ());

  IBUFDS_GTE4 i_ibufds_ref_clk_2 (
    .CEB (1'd0),
    .I (ref_clk_b_p),
    .IB (ref_clk_b_n),
    .O (ref_clk_b),
    .ODIV2 ());

  IBUFDS i_ibufds_sysref_1 (
    .I (sysref_a_p),
    .IB (sysref_a_n),
    .O (sysref_a));

  IBUFDS i_ibufds_sysref_2 (
    .I (sysref_b_p),
    .IB (sysref_b_n),
    .O (sysref_b));

  IBUFDS i_rx_clk_ibuf_1 (
    .I (core_clk_a_p),
    .IB (core_clk_a_n),
    .O (core_clk_a_ds));

  BUFG i_rx_clk_ibufg_1 (
    .I (core_clk_a_ds),
    .O (core_clk_a));

  IBUFDS i_rx_clk_ibuf_2 (
    .I (core_clk_b_p),
    .IB (core_clk_b_n),
    .O (core_clk_b_ds));

  BUFG i_rx_clk_ibufg_2 (
    .I (core_clk_b_ds),
    .O (core_clk_b));

  IBUFDS i_ibufds_tx_sync_1 (
    .I (tx_sync_a_p),
    .IB (tx_sync_a_n),
    .O (tx_sync_a));

  IBUFDS i_ibufds_tx_sync_2 (
    .I (tx_sync_b_p),
    .IB (tx_sync_b_n),
    .O (tx_sync_b));

  OBUFDS i_obufds_rx_sync_1 (
    .I (rx_sync_rx),
    .O (rx_sync_a_p),
    .OB (rx_sync_a_n));

  OBUFDS i_obufds_rx_os_sync_1 (
    .I (rx_sync_obs),
    .O (rx_os_sync_a_p),
    .OB (rx_os_sync_a_n));

  OBUFDS i_obufds_rx_sync_2 (
    .I (rx_sync_rx),
    .O (rx_sync_b_p),
    .OB (rx_sync_b_n));

  OBUFDS i_obufds_rx_os_sync_2 (
    .I (rx_sync_obs),
    .O (rx_os_sync_b_p),
    .OB (rx_os_sync_b_n));

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .ddr4_rtl_1_act_n(ddr4_rtl_1_act_n),
    .ddr4_rtl_1_adr(ddr4_rtl_1_adr),
    .ddr4_rtl_1_ba(ddr4_rtl_1_ba),
    .ddr4_rtl_1_bg(ddr4_rtl_1_bg),
    .ddr4_rtl_1_ck_c(ddr4_rtl_1_ck_c),
    .ddr4_rtl_1_ck_t(ddr4_rtl_1_ck_t),
    .ddr4_rtl_1_cke(ddr4_rtl_1_cke),
    .ddr4_rtl_1_cs_n(ddr4_rtl_1_cs_n),
    .ddr4_rtl_1_dm_n(ddr4_rtl_1_dm_n),
    .ddr4_rtl_1_dq(ddr4_rtl_1_dq),
    .ddr4_rtl_1_dqs_c(ddr4_rtl_1_dqs_c),
    .ddr4_rtl_1_dqs_t(ddr4_rtl_1_dqs_t),
    .ddr4_rtl_1_odt(ddr4_rtl_1_odt),
    .ddr4_rtl_1_reset_n(ddr4_rtl_1_reset_n),
    .ddr4_ref_1_clk_n(ddr4_ref_1_clk_n),
    .ddr4_ref_1_clk_p(ddr4_ref_1_clk_p),
    .sys_reset(1'b0),
    .core_clk_a(core_clk_a),
    .core_clk_b(core_clk_b),
    .ref_clk_a(ref_clk_a),
    .ref_clk_b(ref_clk_b),
    .rx_data_0_n (rx_data_a_n[0]),
    .rx_data_0_p (rx_data_a_p[0]),
    .rx_data_1_n (rx_data_a_n[1]),
    .rx_data_1_p (rx_data_a_p[1]),
    .rx_data_2_n (rx_data_a_n[2]),
    .rx_data_2_p (rx_data_a_p[2]),
    .rx_data_3_n (rx_data_a_n[3]),
    .rx_data_3_p (rx_data_a_p[3]),
    .rx_data_4_n (rx_data_b_n[0]),
    .rx_data_4_p (rx_data_b_p[0]),
    .rx_data_5_n (rx_data_b_n[1]),
    .rx_data_5_p (rx_data_b_p[1]),
    .rx_data_6_n (rx_data_b_n[2]),
    .rx_data_6_p (rx_data_b_p[2]),
    .rx_data_7_n (rx_data_b_n[3]),
    .rx_data_7_p (rx_data_b_p[3]),
    .rx_sync_0 (rx_sync_rx),
    .rx_sync_4 (rx_sync_obs),
    .rx_sysref_0 (sysref_b),
    .rx_sysref_4 (sysref_a),
    .tx_data_0_n (tx_data_a_n[0]),
    .tx_data_0_p (tx_data_a_p[0]),
    .tx_data_1_n (tx_data_a_n[1]),
    .tx_data_1_p (tx_data_a_p[1]),
    .tx_data_2_n (tx_data_a_n[2]),
    .tx_data_2_p (tx_data_a_p[2]),
    .tx_data_3_n (tx_data_a_n[3]),
    .tx_data_3_p (tx_data_a_p[3]),
    .tx_data_4_n (tx_data_b_n[0]),
    .tx_data_4_p (tx_data_b_p[0]),
    .tx_data_5_n (tx_data_b_n[1]),
    .tx_data_5_p (tx_data_b_p[1]),
    .tx_data_6_n (tx_data_b_n[2]),
    .tx_data_6_p (tx_data_b_p[2]),
    .tx_data_7_n (tx_data_b_n[3]),
    .tx_data_7_p (tx_data_b_p[3]),
    .tx_sync_0 (tx_sync),
    .tx_sysref_0 (sysref_a),
    .dac_fifo_bypass(gpio_o[90]),
    .i2s_bclk(i2s_bclk),
    .i2s_lrclk(i2s_lrclk),
    .i2s_mclk(i2s_mclk),
    .i2s_sdata_in(i2s_sdata_in),
    .i2s_sdata_out(i2s_sdata_out),
    .axi_fan_pwm_o(fan_pwm),
    .axi_fan_tacho_i(fan_tach),
    .spi0_csn(spi_csn),
    .spi0_miso(spi0_miso),
    .spi0_mosi(spi_mosi),
    .spi0_sclk(spi_clk),
    .spi1_clk_i (spi1_clk),
    .spi1_clk_o (spi1_clk),
    .spi1_csn_i (spi1_csn),
    .spi1_csn_o (spi1_csn),
    .spi1_sdi_i (spi1_cipo),
    .spi1_sdo_i (spi1_copi),
    .spi1_sdo_o (spi1_copi),
    .spi2_clk_i (spi2_clk),
    .spi2_clk_o (spi2_clk),
    .spi2_csn_i (spi2_csn),
    .spi2_csn_o (spi2_csn),
    .spi2_sdi_i (spi2_cipo),
    .spi2_sdo_i (spi2_copi),
    .spi2_sdo_o (spi2_copi),
    .iic_1_scl_io (sclout1),
    .iic_1_sda_io (sdaout1),
    .iic_2_scl_io (sclout2),
    .iic_2_sda_io (sdaout2),
    .fmcxmwbr1_gpio0_o(fmcxmwbr1_gpio_o[31:0]),
    .fmcxmwbr1_gpio0_t(fmcxmwbr1_gpio_t[31:0]),
    .fmcxmwbr1_gpio0_i(fmcxmwbr1_gpio_i[31:0]),
    .fmcxmwbr1_gpio1_o(fmcxmwbr1_gpio_o[63:32]),
    .fmcxmwbr1_gpio1_t(fmcxmwbr1_gpio_t[63:32]),
    .fmcxmwbr1_gpio1_i(fmcxmwbr1_gpio_i[63:32]));

endmodule
