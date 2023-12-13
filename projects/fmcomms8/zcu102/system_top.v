// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
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

  input       [12:0]  gpio_bd_i,
  output      [ 7:0]  gpio_bd_o,

  inout               iic_scl,
  inout               iic_sda,

  input               ref_clk_c_p,
  input               ref_clk_c_n,
  input               core_clk_c_p,
  input               core_clk_c_n,
  input       [ 3:0]  rx_data_c_p,
  input       [ 3:0]  rx_data_c_n,
  output      [ 3:0]  tx_data_c_p,
  output      [ 3:0]  tx_data_c_n,

  output              rx_sync_c_p,
  output              rx_sync_c_n,
  output              rx_os_sync_c_p,
  output              rx_os_sync_c_n,
  input               tx_sync_c_p,
  input               tx_sync_c_n,
  input               tx_sync_c_1_p,
  input               tx_sync_c_1_n,
  input               sysref_c_p,
  input               sysref_c_n,

  inout               adrv9009_tx1_enable_c,
  inout               adrv9009_tx2_enable_c,
  inout               adrv9009_rx1_enable_c,
  inout               adrv9009_rx2_enable_c,
  inout               adrv9009_reset_b_c,
  inout               adrv9009_gpint_c,

  inout               adrv9009_gpio_00_c,
  inout               adrv9009_gpio_01_c,
  inout               adrv9009_gpio_02_c,
  inout               adrv9009_gpio_03_c,
  inout               adrv9009_gpio_04_c,
  inout               adrv9009_gpio_05_c,
  inout               adrv9009_gpio_06_c,
  inout               adrv9009_gpio_07_c,
  inout               adrv9009_gpio_08_c,

  input               ref_clk_d_p,
  input               ref_clk_d_n,
  input               core_clk_d_p,
  input               core_clk_d_n,
  input       [ 3:0]  rx_data_d_p,
  input       [ 3:0]  rx_data_d_n,
  output      [ 3:0]  tx_data_d_p,
  output      [ 3:0]  tx_data_d_n,

  output              rx_sync_d_p,
  output              rx_sync_d_n,
  output              rx_os_sync_d_p,
  output              rx_os_sync_d_n,
  input               tx_sync_d_p,
  input               tx_sync_d_n,
  input               tx_sync_d_1_p,
  input               tx_sync_d_1_n,
  input               sysref_d_p,
  input               sysref_d_n,

  inout               adrv9009_tx1_enable_d,
  inout               adrv9009_tx2_enable_d,
  inout               adrv9009_rx1_enable_d,
  inout               adrv9009_rx2_enable_d,
  inout               adrv9009_reset_b_d,
  inout               adrv9009_gpint_d,

  inout               adrv9009_gpio_00_d,
  inout               adrv9009_gpio_01_d,
  inout               adrv9009_gpio_02_d,
  inout               adrv9009_gpio_03_d,
  inout               adrv9009_gpio_04_d,
  inout               adrv9009_gpio_05_d,
  inout               adrv9009_gpio_06_d,
  inout               adrv9009_gpio_07_d,
  inout               adrv9009_gpio_08_d,

  input               fan_tach,
  input               fan_pwm,
  output              hmc7044_reset,
  inout               hmc7044_sync,
  inout               hmc7044_gpio_1,
  inout               hmc7044_gpio_2,
  inout               hmc7044_gpio_3,
  inout               hmc7044_gpio_4,
  output              spi_csn_hmc7044,
  output              spi_csn_adrv9009_c,
  output              spi_csn_adrv9009_d,

  output              spi_clk,
  inout               spi_sdio,
  input               spi_miso
);

  // internal signals

  wire        [94:0]      gpio_i;
  wire        [94:0]      gpio_o;
  wire        [94:0]      gpio_t;
  wire        [20:0]      gpio_bd;

  wire    [2:0]   spi_csn;

  wire            ref_clk_c;
  wire            core_clk_c;
  wire            core_clk_c_ds;
  wire            rx_sync_rx;
  wire            tx_sync_c;
  wire            sysref_c;
  wire            ref_clk_d;
  wire            core_clk_d;
  wire            core_clk_d_ds;
  wire            rx_sync_obs;
  wire            rx_os_sync_d;
  wire            tx_sync_d;
  wire            sysref_d;
  wire            tx_sync;
  wire            spi_mosi;
  wire            spi0_miso;

  // The csn bus from the SPI controller needs to be decoded as
  // is-decoded-cs = <1> is set in the device tree.
  reg  [7:0]     spi_3_to_8_csn;
  always @(*) begin
    case (spi_csn)
      3'h0: spi_3_to_8_csn = 8'b11111110;
      3'h1: spi_3_to_8_csn = 8'b11111101;
      3'h2: spi_3_to_8_csn = 8'b11111011;
      default: spi_3_to_8_csn = 8'b11111111;
    endcase
  end

  assign spi_csn_adrv9009_c = spi_3_to_8_csn[0];
  assign spi_csn_adrv9009_d = spi_3_to_8_csn[1];
  assign spi_csn_hmc7044 = spi_3_to_8_csn[2];

  fmcomms8_spi i_spi (
    .spi_csn(spi_3_to_8_csn),
    .spi_clk(spi_clk),
    .spi_mosi(spi_mosi),
    .spi_miso_i(spi_miso),
    .spi_miso_o(spi0_miso),
    .spi_sdio(spi_sdio));

  assign tx_sync = tx_sync_c & tx_sync_d;

  assign gpio_i[94:68] = gpio_o[94:68];
  assign gpio_i[31:21] = gpio_o[31:21];
  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[ 7: 0];

  // instantiations
  ad_iobuf #(
    .DATA_WIDTH(36)
  ) i_iobuf (
    .dio_t ({gpio_t[67:32]}),
    .dio_i ({gpio_o[67:32]}),
    .dio_o ({gpio_i[67:32]}),
    .dio_p ({
              hmc7044_gpio_4,           // 67
              hmc7044_gpio_3,           // 66
              hmc7044_gpio_2,           // 65
              hmc7044_gpio_1,           // 64
              hmc7044_sync,             // 63
              hmc7044_reset,            // 62
              adrv9009_tx2_enable_d,    // 61
              adrv9009_tx1_enable_d,    // 60
              adrv9009_rx2_enable_d,    // 59
              adrv9009_rx1_enable_d,    // 58
              adrv9009_reset_b_d,       // 57
              adrv9009_gpint_d,         // 56
              adrv9009_gpio_08_d,       // 55
              adrv9009_gpio_07_d,       // 54
              adrv9009_gpio_06_d,       // 53
              adrv9009_gpio_05_d,       // 52
              adrv9009_gpio_04_d,       // 51
              adrv9009_gpio_03_d,       // 50
              adrv9009_gpio_02_d,       // 49
              adrv9009_gpio_01_d,       // 48
              adrv9009_gpio_00_d,       // 47
              adrv9009_tx2_enable_c,    // 46
              adrv9009_tx1_enable_c,    // 45
              adrv9009_rx2_enable_c,    // 44
              adrv9009_rx1_enable_c,    // 43
              adrv9009_reset_b_c,       // 42
              adrv9009_gpint_c,         // 41
              adrv9009_gpio_08_c,       // 40
              adrv9009_gpio_07_c,       // 39
              adrv9009_gpio_06_c,       // 38
              adrv9009_gpio_05_c,       // 37
              adrv9009_gpio_04_c,       // 36
              adrv9009_gpio_03_c,       // 35
              adrv9009_gpio_02_c,       // 34
              adrv9009_gpio_01_c,       // 33
              adrv9009_gpio_00_c}));    // 32

  IBUFDS_GTE4 i_ibufds_ref_clk_1 (
    .CEB (1'd0),
    .I (ref_clk_c_p),
    .IB (ref_clk_c_n),
    .O (ref_clk_c),
    .ODIV2 ());

  IBUFDS_GTE4 i_ibufds_ref_clk_2 (
    .CEB (1'd0),
    .I (ref_clk_d_p),
    .IB (ref_clk_d_n),
    .O (ref_clk_d),
    .ODIV2 ());

  IBUFDS i_ibufds_sysref_1 (
    .I (sysref_c_p),
    .IB (sysref_c_n),
    .O (sysref_c));

  IBUFDS i_ibufds_sysref_2 (
    .I (sysref_d_p),
    .IB (sysref_d_n),
    .O (sysref_d));

  IBUFDS i_rx_clk_ibuf_1 (
    .I (core_clk_c_p),
    .IB (core_clk_c_n),
    .O (core_clk_c_ds));

  BUFG i_rx_clk_ibufg_1 (
    .I (core_clk_c_ds),
    .O (core_clk_c));

  IBUFDS i_rx_clk_ibuf_2 (
    .I (core_clk_d_p),
    .IB (core_clk_d_n),
    .O (core_clk_d_ds));

  BUFG i_rx_clk_ibufg_2(
    .I (core_clk_d_ds),
    .O (core_clk_d));

  IBUFDS i_ibufds_tx_sync_1 (
    .I (tx_sync_c_p),
    .IB (tx_sync_c_n),
    .O (tx_sync_c));

  IBUFDS i_ibufds_tx_sync_2 (
    .I (tx_sync_d_p),
    .IB (tx_sync_d_n),
    .O (tx_sync_d));

  OBUFDS i_obufds_rx_sync_1 (
    .I (rx_sync_rx),
    .O (rx_sync_c_p),
    .OB (rx_sync_c_n));

  OBUFDS i_obufds_rx_os_sync_1 (
    .I (rx_sync_obs),
    .O (rx_os_sync_c_p),
    .OB (rx_os_sync_c_n));

  OBUFDS i_obufds_rx_sync_2 (
    .I (rx_sync_rx),
    .O (rx_sync_d_p),
    .OB (rx_sync_d_n));

  OBUFDS i_obufds_rx_os_sync_2 (
    .I (rx_sync_obs),
    .O (rx_os_sync_d_p),
    .OB (rx_os_sync_d_n));

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),

    .core_clk_c(core_clk_c),
    .core_clk_d(core_clk_d),
    .ref_clk_c(ref_clk_c),
    .ref_clk_d(ref_clk_d),
    .rx_data_0_n (rx_data_c_n[0]),
    .rx_data_0_p (rx_data_c_p[0]),
    .rx_data_1_n (rx_data_c_n[1]),
    .rx_data_1_p (rx_data_c_p[1]),
    .rx_data_2_n (rx_data_c_n[2]),
    .rx_data_2_p (rx_data_c_p[2]),
    .rx_data_3_n (rx_data_c_n[3]),
    .rx_data_3_p (rx_data_c_p[3]),
    .rx_data_4_n (rx_data_d_n[0]),
    .rx_data_4_p (rx_data_d_p[0]),
    .rx_data_5_n (rx_data_d_n[1]),
    .rx_data_5_p (rx_data_d_p[1]),
    .rx_data_6_n (rx_data_d_n[2]),
    .rx_data_6_p (rx_data_d_p[2]),
    .rx_data_7_n (rx_data_d_n[3]),
    .rx_data_7_p (rx_data_d_p[3]),
    .rx_sync_0 (rx_sync_rx),
    .rx_sync_4 (rx_sync_obs),
    .rx_sysref_0 (sysref_d),
    .rx_sysref_4 (sysref_c),
    .tx_data_0_n (tx_data_c_n[0]),
    .tx_data_0_p (tx_data_c_p[0]),
    .tx_data_1_n (tx_data_c_n[1]),
    .tx_data_1_p (tx_data_c_p[1]),
    .tx_data_2_n (tx_data_c_n[2]),
    .tx_data_2_p (tx_data_c_p[2]),
    .tx_data_3_n (tx_data_c_n[3]),
    .tx_data_3_p (tx_data_c_p[3]),
    .tx_data_4_n (tx_data_d_n[0]),
    .tx_data_4_p (tx_data_d_p[0]),
    .tx_data_5_n (tx_data_d_n[1]),
    .tx_data_5_p (tx_data_d_p[1]),
    .tx_data_6_n (tx_data_d_n[2]),
    .tx_data_6_p (tx_data_d_p[2]),
    .tx_data_7_n (tx_data_d_n[3]),
    .tx_data_7_p (tx_data_d_p[3]),
    .tx_sync_0 (tx_sync),
    .tx_sysref_0 (sysref_c),
    .dac_fifo_bypass(gpio_o[68]),

    .spi0_sclk (spi_clk),
    .spi0_csn (spi_csn),
    .spi0_miso (spi0_miso),
    .spi0_mosi (spi_mosi),
    .spi1_sclk (),
    .spi1_csn (),
    .spi1_miso (1'b0),
    .spi1_mosi ());

endmodule
