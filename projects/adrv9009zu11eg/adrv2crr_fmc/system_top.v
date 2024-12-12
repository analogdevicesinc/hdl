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

  inout               i2c0_scl,
  inout               i2c0_sda,

  inout               i2c1_scl,
  inout               i2c1_sda,

  input               oscout_p,
  input               oscout_n,

  output              resetb_ad9545,

  input         qsfp_rx1_p,
  input         qsfp_rx1_n,
  input         qsfp_rx2_p,
  input         qsfp_rx2_n,
  input         qsfp_rx3_p,
  input         qsfp_rx3_n,
  input         qsfp_rx4_p,
  input         qsfp_rx4_n,
  output        qsfp_tx1_p,
  output        qsfp_tx1_n,
  output        qsfp_tx2_p,
  output        qsfp_tx2_n,
  output        qsfp_tx3_p,
  output        qsfp_tx3_n,
  output        qsfp_tx4_p,
  output        qsfp_tx4_n,
  input         qsfp_mgt_refclk_0_p,
  input         qsfp_mgt_refclk_0_n,
  output        qsfp_resetl,
  input         qsfp_modprsl,
  input         qsfp_intl,
  output        qsfp_lpmode,
  output  [3:0] led_qsfp
);

  // internal signals


ad_iobuf #(
    .DATA_WIDTH(1)
  ) i_carrier_iobuf_0 (
    .dio_t ({gpio_t[22]}),
    .dio_i ({gpio_o[22]}),
    .dio_o ({gpio_i[22]}),
    .dio_p ({resetb_ad9545}));   // 22



  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [94:0]  gpio_t;
  wire    [ 7:0]  led;
  assign led_qsfp = (gpio_i[0] == 1'b1) ? led[7:4] : led[3:0];

  assign gpio_i[21:1] = gpio_o[21:1];
  assign gpio_i[94:23] = gpio_o[94:23];

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .sys_reset(1'b0),
    .axi_fan_pwm_o(fan_pwm),
    .axi_fan_tacho_i(fan_tach),
    .spi0_csn(),
    .spi0_miso(),
    .spi0_mosi(),
    .spi0_sclk(),
    .qsfp_rx1_p(qsfp_rx1_p),
    .qsfp_rx1_n(qsfp_rx1_n),
    .qsfp_rx2_p(qsfp_rx2_p),
    .qsfp_rx2_n(qsfp_rx2_n),
    .qsfp_rx3_p(qsfp_rx3_p),
    .qsfp_rx3_n(qsfp_rx3_n),
    .qsfp_rx4_p(qsfp_rx4_p),
    .qsfp_rx4_n(qsfp_rx4_n),
    .qsfp_tx1_p(qsfp_tx1_p),
    .qsfp_tx1_n(qsfp_tx1_n),
    .qsfp_tx2_p(qsfp_tx2_p),
    .qsfp_tx2_n(qsfp_tx2_n),
    .qsfp_tx3_p(qsfp_tx3_p),
    .qsfp_tx3_n(qsfp_tx3_n),
    .qsfp_tx4_p(qsfp_tx4_p),
    .qsfp_tx4_n(qsfp_tx4_n),
    .qsfp_mgt_refclk_0_p(qsfp_mgt_refclk_0_p),
    .qsfp_mgt_refclk_0_n(qsfp_mgt_refclk_0_n),
    .qsfp_modsell(),
    .qsfp_resetl(qsfp_resetl),
    .qsfp_modprsl(qsfp_modprsl),
    .qsfp_intl(qsfp_intl),
    .qsfp_lpmode(qsfp_lpmode),
    .led(led),
    .iic_port_scl_io(i2c1_scl),
    .iic_port_sda_io(i2c1_sda));

endmodule
