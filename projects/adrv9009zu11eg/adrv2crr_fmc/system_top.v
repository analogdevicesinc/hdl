// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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
  input       [ 1:0]  rx_data_a_p,
  input       [ 1:0]  rx_data_a_n,

  output              rx_sync_a_p,
  output              rx_sync_a_n,
  input               sysref_a_p,
  input               sysref_a_n,

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

  output              hmc7044_reset,
  output              hmc7044_sync,
  inout               hmc7044_gpio_1,
  inout               hmc7044_gpio_2,
  inout               hmc7044_gpio_3,
  inout               hmc7044_gpio_4,

  output              spi_csn_adrv9009_a,
  output              spi_csn_hmc7044,

  // input               ddr4_ref_1_clk_n,
  // input               ddr4_ref_1_clk_p,

  // output              ddr4_rtl_1_act_n,
  // output      [16:0]  ddr4_rtl_1_adr,
  // output      [1:0]   ddr4_rtl_1_ba,
  // output      [0:0]   ddr4_rtl_1_bg,
  // output      [0:0]   ddr4_rtl_1_ck_c,
  // output      [0:0]   ddr4_rtl_1_ck_t,
  // output      [0:0]   ddr4_rtl_1_cke,
  // output      [0:0]   ddr4_rtl_1_cs_n,
  // inout       [3:0]   ddr4_rtl_1_dm_n,
  // inout       [31:0]  ddr4_rtl_1_dq,
  // inout       [3:0]   ddr4_rtl_1_dqs_c,
  // inout       [3:0]   ddr4_rtl_1_dqs_t,
  // output      [0:0]   ddr4_rtl_1_odt,
  // output              ddr4_rtl_1_reset_n,
  // output              ddr4_rtl_1_par,
  // input               ddr4_rtl_1_alert_n,
  output              spi_clk,
  inout               spi_sdio,
  input               spi_miso
);

  // internal signals

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [94:0]  gpio_t;

  wire    [2:0]   spi_csn;

  wire            ref_clk_a;
  wire            core_clk_a;
  wire            core_clk_a_ds;
  wire            rx_sync_rx;
  wire            sysref_a;
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
  assign spi_csn_hmc7044 = spi_3_to_8_csn[2];
  assign spi_csn_hmc7044_car = spi_3_to_8_csn[3];
  assign gpio_0_exp_n = spi_3_to_8_csn[4];
  assign gpio_1_exp_p = spi_clk;
  assign gpio_0_exp_p = spi_mosi;
  assign spi_miso_s = ((spi_3_to_8_csn[4] == 1'b0) | (spi_3_to_8_csn[5] == 1'b0))? gpio_1_exp_n : spi_miso;
  assign gpio_2_exp_n = spi_3_to_8_csn[5];

  adrv9009zu11eg_spi i_spi (
    .spi_csn(spi_3_to_8_csn),
    .spi_clk(spi_clk),
    .spi_mosi(spi_mosi),
    .spi_miso_i(spi_miso_s),
    .spi_miso_o(spi0_miso),
    .spi_sdio(spi_sdio));

  assign gpio_i[94:93] = gpio_o[94:93];
  assign gpio_i[31:28] = gpio_o[31:28];
  assign gpio_i[21:20] = gpio_o[21:20];

  ad_iobuf #(
    .DATA_WIDTH(33)
  ) i_iobuf (
    .dio_t ({gpio_t[64:32]}),
    .dio_i ({gpio_o[64:32]}),
    .dio_o ({gpio_i[64:32]}),
    .dio_p ({ gpio_4_exp_n,             // 64
              gpio_3_exp_n,             // 63
              gpio_3_exp_p,             // 62
              hmc7044_gpio_4,           // 61
              hmc7044_gpio_3,           // 60
              hmc7044_gpio_1,           // 59
              hmc7044_gpio_2,           // 58
              hmc7044_sync,             // 57
              hmc7044_reset,            // 56
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

  IBUFDS i_ibufds_sysref_1 (
    .I (sysref_a_p),
    .IB (sysref_a_n),
    .O (sysref_a));

  IBUFDS i_rx_clk_ibuf_1 (
    .I (core_clk_a_p),
    .IB (core_clk_a_n),
    .O (core_clk_a_ds));

  BUFG i_clk_bufg_1 (
    .I (core_clk_a_ds),
    .O (core_clk_a));

  OBUFDS i_obufds_rx_sync_1 (
    .I (rx_sync_rx),
    .O (rx_sync_a_p),
    .OB (rx_sync_a_n));

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
//    .ddr4_rtl_1_act_n(ddr4_rtl_1_act_n),
//    .ddr4_rtl_1_adr(ddr4_rtl_1_adr),
//    .ddr4_rtl_1_ba(ddr4_rtl_1_ba),
//    .ddr4_rtl_1_bg(ddr4_rtl_1_bg),
//    .ddr4_rtl_1_ck_c(ddr4_rtl_1_ck_c),
//    .ddr4_rtl_1_ck_t(ddr4_rtl_1_ck_t),
//    .ddr4_rtl_1_cke(ddr4_rtl_1_cke),
//    .ddr4_rtl_1_cs_n(ddr4_rtl_1_cs_n),
//    .ddr4_rtl_1_dm_n(ddr4_rtl_1_dm_n),
//    .ddr4_rtl_1_dq(ddr4_rtl_1_dq),
//    .ddr4_rtl_1_dqs_c(ddr4_rtl_1_dqs_c),
//    .ddr4_rtl_1_dqs_t(ddr4_rtl_1_dqs_t),
//    .ddr4_rtl_1_odt(ddr4_rtl_1_odt),
//    .ddr4_rtl_1_reset_n(ddr4_rtl_1_reset_n),
    .sys_reset(1'b0),
//    .ddr4_ref_1_clk_n(ddr4_ref_1_clk_n),
//    .ddr4_ref_1_clk_p(ddr4_ref_1_clk_p),
    .core_clk_a(core_clk_a),
    .ref_clk_a(ref_clk_a),
    .rx_data_0_n (rx_data_a_n[0]),
    .rx_data_0_p (rx_data_a_p[0]),
    .rx_data_1_n (rx_data_a_n[1]),
    .rx_data_1_p (rx_data_a_p[1]),
    .rx_sync_0 (rx_sync_rx),
    .rx_sysref_0 (sysref_a),
    .axi_fan_pwm_o(fan_pwm),
    .axi_fan_tacho_i(fan_tach),
    .spi0_csn(spi_csn),
    .spi0_miso(spi0_miso),
    .spi0_mosi(spi_mosi),
    .spi0_sclk(spi_clk));

endmodule
