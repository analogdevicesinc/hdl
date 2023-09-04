// ***************************************************************************
// ***************************************************************************
// Copyright 2022 - 2023 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  input   [12:0]  gpio_bd_i,
  output  [ 7:0]  gpio_bd_o,

   // dac interface

  inout           ad3552r_ldacn,
  inout           ad3552r_alertn,
  inout           ad3552r_gpio_6,
  inout           ad3552r_gpio_7,
  inout           ad3552r_gpio_8,
  inout           ad3552r_gpio_9,
  inout   [ 3:0]  ad3552r_spi_sdio,
  output          ad3552r_resetn,
  output          ad3552r_qspi_sel,
  output          ad3552r_spi_cs,
  output          ad3552r_spi_sclk,

  inout           tsn_gpio0,
  inout           tsn_gpio1,
  inout           tsn_gpio2,
  inout           tsn_gpio3,

  inout           tsn_timer1,
  inout           tsn_timer2,
  inout           tsn_timer3,

  input          tsn_rst_n
);

  // internal signals
  
  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [94:0]  gpio_t;

  wire    [ 3:0]  ad3552r_spi_sdo;
  wire    [ 3:0]  ad3552r_spi_sdi;
  wire            ad3552r_spi_t;
  
  wire            tsn_timer1_s;
  wire            tsn_timer2_s;
  wire            tsn_timer3_s;

  assign gpio_bd_o = gpio_o[7:0];
  assign gpio_i[94:43] = gpio_o[94:43];
  assign gpio_i[31:21] = gpio_o[31:21];
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];

  assign ad3552r_qspi_sel = 1'b1;
  assign ad3552r_resetn   = gpio_o[42];


 // TSN TIMERS signals IOBUF

  ad_iobuf #(
    .DATA_WIDTH(3)
  ) tsn_timers_iobuf (
    .dio_t(3'b111),
    .dio_i(3'b000),
    .dio_o({tsn_timer1_s,
           tsn_timer2_s,
           tsn_timer3_s}),
    .dio_p({tsn_timer1,
            tsn_timer2,
            tsn_timer3}));

  // DAC QSPI signals IOBUF

  ad_iobuf #(
    .DATA_WIDTH(4)
  ) i_dac_0_spi_iobuf (
    .dio_t({4{ad3552r_spi_t}}),
    .dio_i(ad3552r_spi_sdo),
    .dio_o(ad3552r_spi_sdi),
    .dio_p(ad3552r_spi_sdio));

  // TSN GPIO's signals IOBUF

    ad_iobuf #(
      .DATA_WIDTH(4)
    ) tsn_gpio_iobuf (
      .dio_t(gpio_t[41:38]),
      .dio_i(gpio_o[41:38]),
      .dio_o(gpio_i[41:38]),
      .dio_p({tsn_gpio3,
              tsn_gpio2,
              tsn_gpio1,
              tsn_gpio0}));

   // DAC GPIO's signals IOBUF

  ad_iobuf #(
    .DATA_WIDTH(6)
  ) i_ad3552r_iobuf (
    .dio_t(gpio_t[37:32]),
    .dio_i(gpio_o[37:32]),
    .dio_o(gpio_i[37:32]),
    .dio_p({ad3552r_gpio_9,
            ad3552r_gpio_8,
            ad3552r_gpio_7,
            ad3552r_gpio_6,
            ad3552r_alertn,
            ad3552r_ldacn}));

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),

    .spi0_csn (),
    .spi0_miso (1'b0),
    .spi0_mosi (),
    .spi0_sclk (),
    .spi1_csn (),
    .spi1_miso (1'b0),
    .spi1_mosi (),
    .spi1_sclk (),

    //dac interface

    .dac_sclk(ad3552r_spi_sclk),
    .dac_csn(ad3552r_spi_cs),
    .dac_spi_sdi(ad3552r_spi_sdi),
    .dac_spi_sdo(ad3552r_spi_sdo),
    .dac_spi_sdo_t(ad3552r_spi_t),
    
    // external synchronization signals
    
    .ext_reference_clk(tsn_timer2_s),
    .ext_trigger(tsn_timer3_s));
endmodule
