// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2022 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsabilities that he or she has by using this source/core.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************


`timescale 1ns/100ps

module system_top (

  inout  [31:0]  fmc_gpio_00_io_tri_io,
  inout  [31:0]  fmc_gpio_01_io_tri_io,
  inout  [ 3:0]  fmc_gpio_10_io_tri_io,

  input          ref_clk_fmc_0_p,
  input          ref_clk_fmc_0_n,

  input          ref_clk_fmc_1_p,
  input          ref_clk_fmc_1_n,

  input          ref_clk_1_p,
  input          ref_clk_1_n,

  input          ad9545_clk_in_0_p,
  input          ad9545_clk_in_0_n,
  input          ad9545_clk_in_1_p,
  input          ad9545_clk_in_1_n,

  input          hmc_clk_in_0_p,
  input          hmc_clk_in_0_n,
  input          hmc_clk_in_1_p,
  input          hmc_clk_in_1_n,

  output         pcie_ref_clk_out_p,
  output         pcie_ref_clk_out_n,

  input          vaux_0_v_n,
  input          vaux_0_v_p,
  input          vaux_1_v_n,
  input          vaux_1_v_p,
  input          vaux_2_v_n,
  input          vaux_2_v_p,
  input          vaux_3_v_n,
  input          vaux_3_v_p,
  input          vaux_4_v_n,
  input          vaux_4_v_p,
  input          vaux_5_v_n,
  input          vaux_5_v_p,
  input          vaux_6_v_n,
  input          vaux_6_v_p,
  input          vaux_7_v_n,
  input          vaux_7_v_p,
  input          vn_v_n,
  input          vp_v_p,

  input          rx_n_0,
  input          rx_p_0,
  output         tx_n_0,
  output         tx_p_0,

  input  [ 3:0]  rx_n_1,
  input  [ 3:0]  rx_p_1,
  output [ 3:0]  tx_n_1,
  output [ 3:0]  tx_p_1,

  input  [ 9:0]  rx_n_2,
  input  [ 9:0]  rx_p_2,
  output [ 9:0]  tx_p_2,
  output [ 9:0]  tx_n_2,

  input  [ 7:0]  rx_n_3,
  input  [ 7:0]  rx_p_3,
  output [ 7:0]  tx_n_3,
  output [ 7:0]  tx_p_3,

  input          fan_tach,
  output         fan_pwm,
  input          i2s_sdata_in,
  output         i2s_sdata_out,
  output         i2s_mclk,
  output         i2s_bclk,
  output         i2s_lrclk,

  inout          pmod0_d0,
  inout          pmod0_d1,
  inout          pmod0_d2,
  inout          pmod0_d3,
  inout          pmod0_d4,
  inout          pmod0_d5,
  inout          pmod0_d6,
  inout          pmod0_d7,
  output         led_gpio_0,
  output         led_gpio_1,
  output         led_gpio_2,
  output         led_gpio_3,
  inout          dip_gpio_0,
  inout          dip_gpio_1,
  inout          dip_gpio_2,
  inout          dip_gpio_3,
  inout          pb_gpio_0,
  inout          pb_gpio_1,
  inout          pb_gpio_2,
  inout          pb_gpio_3,

  output         resetb_ad9545,
  output         hmc7044_car_reset,
  inout          hmc7044_car_gpio_1,
  inout          hmc7044_car_gpio_2,
  inout          hmc7044_car_gpio_3,
  inout          hmc7044_car_gpio_4,
  output         spi_csn_hmc7044_car,

  inout          i2c0_scl,
  inout          i2c0_sda,
  inout          i2c1_scl,
  inout          i2c1_sda,

  input          oscout_p,
  input          oscout_n,

  input          ref_clk_a_p,
  input          ref_clk_a_n,
  input          core_clk_a_p,
  input          core_clk_a_n,
  input  [ 3:0]  rx_data_a_p,
  input  [ 3:0]  rx_data_a_n,
  output [ 3:0]  tx_data_a_p,
  output [ 3:0]  tx_data_a_n,

  output         rx_sync_a_p,
  output         rx_sync_a_n,
  output         rx_os_sync_a_p,
  output         rx_os_sync_a_n,
  input          tx_sync_a_p,
  input          tx_sync_a_n,
  input          tx_sync_a_1_p,
  input          tx_sync_a_1_n,
  input          sysref_a_p,
  input          sysref_a_n,

  inout          adrv9009_tx1_enable_a,
  inout          adrv9009_tx2_enable_a,
  inout          adrv9009_rx1_enable_a,
  inout          adrv9009_rx2_enable_a,
  inout          adrv9009_test_a,
  inout          adrv9009_reset_b_a,
  inout          adrv9009_gpint_a,

  inout          adrv9009_gpio_00_a,
  inout          adrv9009_gpio_01_a,
  inout          adrv9009_gpio_02_a,
  inout          adrv9009_gpio_03_a,
  inout          adrv9009_gpio_04_a,
  inout          adrv9009_gpio_05_a,
  inout          adrv9009_gpio_06_a,
  inout          adrv9009_gpio_07_a,
  inout          adrv9009_gpio_15_a,
  inout          adrv9009_gpio_08_a,
  inout          adrv9009_gpio_09_a,
  inout          adrv9009_gpio_10_a,
  inout          adrv9009_gpio_11_a,
  inout          adrv9009_gpio_12_a,
  inout          adrv9009_gpio_14_a,
  inout          adrv9009_gpio_13_a,
  inout          adrv9009_gpio_17_a,
  inout          adrv9009_gpio_16_a,
  inout          adrv9009_gpio_18_a,

  input          ref_clk_b_p,
  input          ref_clk_b_n,
  input          core_clk_b_p,
  input          core_clk_b_n,
  input  [ 3:0]  rx_data_b_p,
  input  [ 3:0]  rx_data_b_n,
  output [ 3:0]  tx_data_b_p,
  output [ 3:0]  tx_data_b_n,

  output         rx_sync_b_p,
  output         rx_sync_b_n,
  output         rx_os_sync_b_p,
  output         rx_os_sync_b_n,
  input          tx_sync_b_p,
  input          tx_sync_b_n,
  input          tx_sync_b_1_p,
  input          tx_sync_b_1_n,
  input          sysref_b_p,
  input          sysref_b_n,

  inout          adrv9009_tx1_enable_b,
  inout          adrv9009_tx2_enable_b,
  inout          adrv9009_rx1_enable_b,
  inout          adrv9009_rx2_enable_b,
  inout          adrv9009_test_b,
  inout          adrv9009_reset_b_b,
  inout          adrv9009_gpint_b,

  inout          adrv9009_gpio_00_b,
  inout          adrv9009_gpio_01_b,
  inout          adrv9009_gpio_02_b,
  inout          adrv9009_gpio_03_b,
  inout          adrv9009_gpio_04_b,
  inout          adrv9009_gpio_05_b,
  inout          adrv9009_gpio_06_b,
  inout          adrv9009_gpio_07_b,
  inout          adrv9009_gpio_15_b,
  inout          adrv9009_gpio_08_b,
  inout          adrv9009_gpio_09_b,
  inout          adrv9009_gpio_10_b,
  inout          adrv9009_gpio_11_b,
  inout          adrv9009_gpio_12_b,
  inout          adrv9009_gpio_14_b,
  inout          adrv9009_gpio_13_b,
  inout          adrv9009_gpio_17_b,
  inout          adrv9009_gpio_16_b,
  inout          adrv9009_gpio_18_b,

  output         hmc7044_reset,
  output         hmc7044_sync,
  inout          hmc7044_gpio_1,
  inout          hmc7044_gpio_2,
  inout          hmc7044_gpio_3,
  inout          hmc7044_gpio_4,

  output         spi_csn_adrv9009_a,
  output         spi_csn_adrv9009_b,
  output         spi_csn_hmc7044,

  input          ddr4_ref_0_clk_n,
  input          ddr4_ref_0_clk_p,
  output         ddr4_rtl_0_act_n,
  output [16:0]  ddr4_rtl_0_adr,
  output [ 1:0]  ddr4_rtl_0_ba,
  output [ 0:0]  ddr4_rtl_0_bg,
  output [ 0:0]  ddr4_rtl_0_ck_c,
  output [ 0:0]  ddr4_rtl_0_ck_t,
  output [ 0:0]  ddr4_rtl_0_cke,
  output [ 0:0]  ddr4_rtl_0_cs_n,
  inout  [ 3:0]  ddr4_rtl_0_dm_n,
  inout  [31:0]  ddr4_rtl_0_dq,
  inout  [ 3:0]  ddr4_rtl_0_dqs_c,
  inout  [ 3:0]  ddr4_rtl_0_dqs_t,
  output [ 0:0]  ddr4_rtl_0_odt,
  output         ddr4_rtl_0_reset_n,
  output         ddr4_rtl_0_par,
  input          ddr4_rtl_0_alert_n,

  input          ddr4_ref_1_clk_n,
  input          ddr4_ref_1_clk_p,
  output         ddr4_rtl_1_act_n,
  output [16:0]  ddr4_rtl_1_adr,
  output [ 1:0]  ddr4_rtl_1_ba,
  output [ 0:0]  ddr4_rtl_1_bg,
  output [ 0:0]  ddr4_rtl_1_ck_c,
  output [ 0:0]  ddr4_rtl_1_ck_t,
  output [ 0:0]  ddr4_rtl_1_cke,
  output [ 0:0]  ddr4_rtl_1_cs_n,
  inout  [ 3:0]  ddr4_rtl_1_dm_n,
  inout  [31:0]  ddr4_rtl_1_dq,
  inout  [ 3:0]  ddr4_rtl_1_dqs_c,
  inout  [ 3:0]  ddr4_rtl_1_dqs_t,
  output [ 0:0]  ddr4_rtl_1_odt,
  output         ddr4_rtl_1_reset_n,
  output         ddr4_rtl_1_par,
  input          ddr4_rtl_1_alert_n,
  output         spi_clk,
  inout          spi_sdio,
  input          spi_miso
);

  // internal signals

  wire  [94:0]  gpio_i;
  wire  [94:0]  gpio_o;
  wire  [94:0]  gpio_t;

  wire  [ 2:0]  spi_csn;

  wire          ref_clk_a;
  wire          core_clk_a;
  wire          rx_sync_rx;
  wire          tx_sync_a;
  wire          sysref_a;
  wire          ref_clk_b;
  wire          core_clk_b;
  wire          rx_sync_obs;
  wire          rx_os_sync_b;
  wire          tx_sync_b;
  wire          sysref_b;
  wire          tx_sync;
  wire          spi_mosi;
  wire          spi0_miso;

  wire  [31:0]  fmc_gpio_00_i;
  wire  [31:0]  fmc_gpio_00_o;
  wire  [31:0]  fmc_gpio_00_t;
  wire  [31:0]  fmc_gpio_01_i;
  wire  [31:0]  fmc_gpio_01_o;
  wire  [31:0]  fmc_gpio_01_t;
  wire  [ 3:0]  fmc_gpio_10_i;
  wire  [ 3:0]  fmc_gpio_10_o;
  wire  [ 3:0]  fmc_gpio_10_t;

  wire          ref_clk_fmc_int_0;
  wire          ref_clk_fmc_0;
  wire          ref_clk_fmc_0_gt;
  wire          ref_clk_1;

  wire          ad9545_clk_0;
  wire          ad9545_clk_1;
  wire          ad9545_clk_int_0;
  wire          ad9545_clk_int_1;

  wire          ref_clk_fmc_int_1;
  wire          ref_clk_fmc_1;

  wire          hmc_clk_0;
  wire          hmc_clk_1;
  wire          hmc_clk_int_0;
  wire          hmc_clk_int_1;
  wire          pcie_ref_clk_out_0;
  wire          pcie_ref_clk_out_1;

  reg   [7:0]   spi_3_to_8_csn;

  always @(*) begin
    case (spi_csn)
      3'h0: spi_3_to_8_csn = 8'b11111110;
      3'h1: spi_3_to_8_csn = 8'b11111101;
      3'h2: spi_3_to_8_csn = 8'b11111011;
      3'h3: spi_3_to_8_csn = 8'b11110111;
      default: spi_3_to_8_csn = 8'b11111111;
    endcase
  end

  assign spi_csn_adrv9009_a = spi_3_to_8_csn[0];
  assign spi_csn_adrv9009_b = spi_3_to_8_csn[1];
  assign spi_csn_hmc7044 = spi_3_to_8_csn[2];
  assign spi_csn_hmc7044_car = spi_3_to_8_csn[3];

  assign tx_sync = tx_sync_a & tx_sync_b;

  assign gpio_i[94:90] = gpio_o[94:90];
  assign gpio_i[31:28] = gpio_o[31:28];
  assign gpio_i[21:20] = gpio_o[21:20];

  adrv9009zu11eg_spi i_spi (
  .spi_csn(spi_3_to_8_csn),
  .spi_clk(spi_clk),
  .spi_mosi(spi_mosi),
  .spi_miso_i(spi_miso),
  .spi_miso_o(spi0_miso),
  .spi_sdio(spi_sdio));

  ad_iobuf #(
    .DATA_WIDTH (58)
  ) i_iobuf (
    .dio_t ({gpio_t[89:32]}),
    .dio_i ({gpio_o[89:32]}),
    .dio_o ({gpio_i[89:32]}),
    .dio_p ({
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
    .DATA_WIDTH (6)
  ) i_carrier_iobuf_0 (
    .dio_t ({gpio_t[27:22]}),
    .dio_i ({gpio_o[27:22]}),
    .dio_o ({gpio_i[27:22]}),
    .dio_p ({
              hmc7044_car_gpio_3, // 27
              hmc7044_car_gpio_2, // 26
              hmc7044_car_gpio_1, // 25
              hmc7044_car_gpio_0, // 24
              hmc7044_car_reset,  // 23
              resetb_ad9545}));   // 22

  ad_iobuf #(
    .DATA_WIDTH (20)
  ) i_carrier_iobuf_1 (
    .dio_t ({gpio_t[19:0]}),
    .dio_i ({gpio_o[19:0]}),
    .dio_o ({gpio_i[19:0]}),
    .dio_p ({
              pmod0_d7,           // 19
              pmod0_d6,           // 18
              pmod0_d5,           // 17
              pmod0_d4,           // 16
              pmod0_d3,           // 15
              pmod0_d2,           // 14
              pmod0_d1,           // 13
              pmod0_d0,           // 12
              led_gpio_3,         // 11
              led_gpio_2,         // 10
              led_gpio_1,         // 9
              led_gpio_0,         // 8
              dip_gpio_3,         // 7
              dip_gpio_2,         // 6
              dip_gpio_1,         // 5
              dip_gpio_0,         // 4
              pb_gpio_3,          // 3
              pb_gpio_2,          // 2
              pb_gpio_1,          // 1
              pb_gpio_0}));       // 0

  ad_iobuf #(
    .DATA_WIDTH (32)
  ) fmc_gpio_00_iobuf (
    .dio_t (fmc_gpio_00_t),
    .dio_i (fmc_gpio_00_o),
    .dio_o (fmc_gpio_00_i),
    .dio_p (fmc_gpio_00_io_tri_io));

  ad_iobuf #(
    .DATA_WIDTH (32)
  ) fmc_gpio_01_iobuf (
    .dio_t (fmc_gpio_01_t),
    .dio_i (fmc_gpio_01_o),
    .dio_o (fmc_gpio_01_i),
    .dio_p (fmc_gpio_01_io_tri_io));

  ad_iobuf #(
    .DATA_WIDTH (4)
  ) fmc_gpio_10_iobuf (
    .dio_t (fmc_gpio_10_t),
    .dio_i (fmc_gpio_10_o),
    .dio_o (fmc_gpio_10_i),
    .dio_p (fmc_gpio_10_io_tri_io));

  IBUFDS_GTE4 ad9545_0 (
    .CEB (1'd0),
    .I (ad9545_clk_in_0_p),
    .IB (ad9545_clk_in_0_n),
    .O (),
    .ODIV2 (ad9545_clk_0));

   BUFG_GT BUFG_GT_inst_0 (
    .O (ad9545_clk_int_0),
    .CE (1'b1),
    .CEMASK (1'b1),
    .CLR (1'b0),
    .CLRMASK (1'b1),
    .DIV (1'b0),
    .I (ad9545_clk_0));

  IBUFDS_GTE4 ad9545_1 (
    .CEB (1'd0),
    .I (ad9545_clk_in_1_p),
    .IB (ad9545_clk_in_1_n),
    .O (),
    .ODIV2 (ad9545_clk_1));

  BUFG_GT BUFG_GT_inst_1 (
    .O (ad9545_clk_int_1),
    .CE (1'b1),
    .CEMASK (1'b1),
    .CLR (1'b0),
    .CLRMASK (1'b1),
    .DIV (1'b0),
    .I (ad9545_clk_1));

  IBUFDS_GTE4 hmc_0 (
    .CEB (1'd0),
    .I (hmc_clk_in_0_p),
    .IB (hmc_clk_in_0_n),
    .O (),
    .ODIV2 (hmc_clk_0));

   BUFG_GT BUFG_GT_inst_2 (
    .O (hmc_clk_int_0),
    .CE (1'b1),
    .CEMASK (1'b1),
    .CLR (1'b0),
    .CLRMASK (1'b1),
    .DIV (1'b0),
    .I (hmc_clk_0));

  IBUFDS_GTE4 hmc_1 (
    .CEB (1'd0),
    .I (hmc_clk_in_1_p),
    .IB (hmc_clk_in_1_n),
    .O (),
    .ODIV2 (hmc_clk_1));

  BUFG_GT BUFG_GT_inst_3 (
    .O (hmc_clk_int_1),
    .CE (1'b1),
    .CEMASK (1'b1),
    .CLR (1'b0),
    .CLRMASK (1'b1),
    .DIV (1'b0),
    .I (hmc_clk_1));

  IBUFDS_GTE4 fmc_0 (
    .CEB (1'd0),
    .I (ref_clk_fmc_0_p),
    .IB (ref_clk_fmc_0_n),
    .O (ref_clk_fmc_0_gt),
    .ODIV2 (ref_clk_fmc_0));

   BUFG_GT BUFG_GT_inst_6 (
    .O (ref_clk_fmc_int_0),
    .CE (1'b1),
    .CEMASK (1'b1),
    .CLR (1'b0),
    .CLRMASK (1'b1),
    .DIV (1'b0),
    .I (ref_clk_fmc_0));

  IBUFDS_GTE4 fmc_1 (
    .CEB (1'd0),
    .I (ref_clk_fmc_1_p),
    .IB (ref_clk_fmc_1_n),
    .O (),
    .ODIV2 (ref_clk_fmc_1));

   BUFG_GT BUFG_GT_inst_5 (
    .O (ref_clk_fmc_int_1),
    .CE (1'b1),
    .CEMASK (1'b1),
    .CLR (1'b0),
    .CLRMASK (1'b1),
    .DIV (1'b0),
    .I (ref_clk_fmc_1));

  OBUFDS OBUFDS_inst (
    .O (pcie_ref_clk_out_p),
    .OB (pcie_ref_clk_out_n),
    .I (pcie_ref_clk_out_1));

   BUFG_GT BUFG_GT_inst_4 (
    .O (pcie_ref_clk_out_1),
    .CE (1'b1),
    .CEMASK (1'b1),
    .CLR (1'b0),
    .CLRMASK (1'b1),
    .DIV (1'b0),
    .I (pcie_ref_clk_out_0));

  IBUFDS_GTE4 i_buf_gth_q0_clk1 (
    .O (ref_clk_1),
    .CEB (1'b0),
    .I (ref_clk_1_p),
    .IB (ref_clk_1_n),
    .ODIV2 (pcie_ref_clk_out_0));

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

  IBUFGDS i_rx_clk_ibufg_1 (
    .I (core_clk_a_p),
    .IB (core_clk_a_n),
    .O (core_clk_a));

  IBUFGDS i_rx_clk_ibufg_2 (
    .I (core_clk_b_p),
    .IB (core_clk_b_n),
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

    .clk_mon_0 (ad9545_clk_int_0),
    .clk_mon_1 (ad9545_clk_int_1),
    .clk_mon_2 (hmc_clk_int_0),
    .clk_mon_3 (hmc_clk_int_1),
    .clk_mon_4 (ref_clk_fmc_int_1),
    .clk_mon_5 (ref_clk_fmc_int_0),

    .ddr4_rtl_0_act_n (ddr4_rtl_0_act_n),
    .ddr4_rtl_0_adr (ddr4_rtl_0_adr),
    .ddr4_rtl_0_ba (ddr4_rtl_0_ba),
    .ddr4_rtl_0_bg (ddr4_rtl_0_bg),
    .ddr4_rtl_0_ck_c (ddr4_rtl_0_ck_c),
    .ddr4_rtl_0_ck_t (ddr4_rtl_0_ck_t),
    .ddr4_rtl_0_cke (ddr4_rtl_0_cke),
    .ddr4_rtl_0_cs_n (ddr4_rtl_0_cs_n),
    .ddr4_rtl_0_dm_n (ddr4_rtl_0_dm_n),
    .ddr4_rtl_0_dq (ddr4_rtl_0_dq),
    .ddr4_rtl_0_dqs_c (ddr4_rtl_0_dqs_c),
    .ddr4_rtl_0_dqs_t (ddr4_rtl_0_dqs_t),
    .ddr4_rtl_0_odt (ddr4_rtl_0_odt),
    .ddr4_rtl_0_reset_n (ddr4_rtl_0_reset_n),
    .ddr4_ref_0_clk_n (ddr4_ref_0_clk_n),
    .ddr4_ref_0_clk_p (ddr4_ref_0_clk_p),

    .ddr4_rtl_1_act_n (ddr4_rtl_1_act_n),
    .ddr4_rtl_1_adr (ddr4_rtl_1_adr),
    .ddr4_rtl_1_ba (ddr4_rtl_1_ba),
    .ddr4_rtl_1_bg (ddr4_rtl_1_bg),
    .ddr4_rtl_1_ck_c (ddr4_rtl_1_ck_c),
    .ddr4_rtl_1_ck_t (ddr4_rtl_1_ck_t),
    .ddr4_rtl_1_cke (ddr4_rtl_1_cke),
    .ddr4_rtl_1_cs_n (ddr4_rtl_1_cs_n),
    .ddr4_rtl_1_dm_n (ddr4_rtl_1_dm_n),
    .ddr4_rtl_1_dq (ddr4_rtl_1_dq),
    .ddr4_rtl_1_dqs_c (ddr4_rtl_1_dqs_c),
    .ddr4_rtl_1_dqs_t (ddr4_rtl_1_dqs_t),
    .ddr4_rtl_1_odt (ddr4_rtl_1_odt),
    .ddr4_rtl_1_reset_n (ddr4_rtl_1_reset_n),
    .sys_reset (1'b0),
    .ddr4_ref_1_clk_n (ddr4_ref_1_clk_n),
    .ddr4_ref_1_clk_p (ddr4_ref_1_clk_p),
    .core_clk_a (core_clk_a),
    .core_clk_b (core_clk_b),
    .ref_clk_a (ref_clk_a),
    .ref_clk_b (ref_clk_b),

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
    .dac_fifo_bypass (gpio_o[90]),

    .ref_clk_0 (ref_clk_fmc_0_gt),
    .ref_clk_1 (ref_clk_1),
    .rx_n_0 (rx_n_0),
    .rx_p_0 (rx_p_0),
    .tx_n_0 (tx_n_0),
    .tx_p_0 (tx_p_0),
    .rx_n_1 (rx_n_1),
    .rx_p_1 (rx_p_1),
    .tx_n_1 (tx_n_1),
    .tx_p_1 (tx_p_1),
    .rx_n_2 (rx_n_2),
    .rx_p_2 (rx_p_2),
    .tx_p_2 (tx_p_2),
    .tx_n_2 (tx_n_2),
    .rx_n_3 (rx_n_3),
    .rx_p_3 (rx_p_3),
    .tx_n_3 (tx_n_3),
    .tx_p_3 (tx_p_3),

    .fmc_gpio_00_i (fmc_gpio_00_i),
    .fmc_gpio_00_o (fmc_gpio_00_o),
    .fmc_gpio_00_t (fmc_gpio_00_t),
    .fmc_gpio_01_i (fmc_gpio_01_i),
    .fmc_gpio_01_o (fmc_gpio_01_o),
    .fmc_gpio_01_t (fmc_gpio_01_t),
    .fmc_gpio_10_i (fmc_gpio_10_i),
    .fmc_gpio_10_o (fmc_gpio_10_o),
    .fmc_gpio_10_t (fmc_gpio_10_t),

    .vaux_0_v_n (vaux_0_v_n),
    .vaux_0_v_p (vaux_0_v_p),
    .vaux_1_v_n (vaux_1_v_n),
    .vaux_1_v_p (vaux_1_v_p),
    .vaux_2_v_n (vaux_2_v_n),
    .vaux_2_v_p (vaux_2_v_p),
    .vaux_3_v_n (vaux_3_v_n),
    .vaux_3_v_p (vaux_3_v_p),
    .vaux_4_v_n (vaux_4_v_n),
    .vaux_4_v_p (vaux_4_v_p),
    .vaux_5_v_n (vaux_5_v_n),
    .vaux_5_v_p (vaux_5_v_p),
    .vaux_6_v_n (vaux_6_v_n),
    .vaux_6_v_p (vaux_6_v_p),
    .vaux_7_v_n (vaux_7_v_n),
    .vaux_7_v_p (vaux_7_v_p),
    .vp_vn_v_n (vn_v_n),
    .vp_vn_v_p (vp_v_p),

    .i2s_bclk (i2s_bclk),
    .i2s_lrclk (i2s_lrclk),
    .i2s_mclk (i2s_mclk),
    .i2s_sdata_in (i2s_sdata_in),
    .i2s_sdata_out (i2s_sdata_out),

    .axi_fan_pwm_o (fan_pwm),
    .axi_fan_tacho_i (fan_tach),

    .spi0_csn (spi_csn),
    .spi0_miso (spi0_miso),
    .spi0_mosi (spi_mosi),
    .spi0_sclk (spi_clk)
  );

endmodule

// ***************************************************************************
// ***************************************************************************
