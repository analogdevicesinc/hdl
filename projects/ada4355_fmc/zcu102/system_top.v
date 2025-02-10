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

  input       [12:0]      gpio_bd_i,
  output      [ 7:0]      gpio_bd_o,

  inout                   iic_scl,
  inout                   iic_sda,

  input           dco_p,
  input           dco_n,
  input           da_p,
  input           da_n,
  input           db_p,
  input           db_n,
  input           frame_clock_p,
  input           frame_clock_n,

  input           fpgaclk_p,
  input           fpgaclk_n,

  input           clk_p,
  input           clk_n,

  // GPIOs

  inout           gain_sel0,
  inout           gain_sel1,
  inout           gain_sel2,

  inout           fsel,
  inout           gpio_1p8vd_en,
  inout           gpio_1p8va_en,

  // ADC SPI

  input           ada4355_miso,
  output          ada4355_sclk,
  output          ada4355_csn,
  output          ada4355_mosi,

  input           miso_pot,
  output          sclk_pot,
  output          mosi_pot,
  output          csb_ld_pot,
  output          csb_apd_pot

);

  // internal signals

  wire        [94:0]      gpio_i;
  wire        [94:0]      gpio_o;
  wire        [94:0]      gpio_t;
  wire        [20:0]      gpio_bd;
  wire        [ 2:0]      spi1_csn_s;

  assign gpio_i[94:60] = gpio_o[94:60];
  assign gpio_i[31:21] = gpio_o[31:21];

  assign csb_ld_pot =  spi1_csn_s[0];
  assign csb_apd_pot = spi1_csn_s[1];
  
  // instantiations

  ad_iobuf #(
    .DATA_WIDTH(6)
  ) i_iobuf (
    .dio_t ({gpio_t[37:32]}),
    .dio_i ({gpio_o[37:32]}),
    .dio_o ({gpio_i[37:32]}),
    .dio_p ({ gain_sel0,          // 59
              gain_sel1,         // 33
              gain_sel2,      // 32
              fsel,         
              gpio_1p8vd_en,
              gpio_1p8va_en}));


  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[ 7: 0];

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .spi0_sclk (ada4355_sclk),
    .spi0_csn (ada4355_csn),
    .spi0_miso (ada4355_miso),
    .spi0_mosi (ada4355_mosi),
    .spi1_sclk (sclk_pot),
    .spi1_csn (spi1_csn_s),
    .spi1_miso (miso_pot),
    .spi1_mosi (mosi_pot),


    .dco_p (dco_p),
    .dco_n (dco_n),
    .da_p (da_p),
    .da_n (da_n),
    .db_p (db_p),
    .db_n (db_n),


    .frame_clock_p(frame_clock_p),
    .frame_clock_n(frame_clock_n),
    .sync_n (1'b1));




endmodule
