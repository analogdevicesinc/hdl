// ***************************************************************************
// ***************************************************************************
// Copyright 2021 (c) Analog Devices, Inc. All rights reserved.
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

  input       [12:0]      gpio_bd_i,
  output      [ 7:0]      gpio_bd_o,
  output                  ext_csb_tile4,
  output                  ext_csb_tile2,
  output                  ext_csb_tile3,
  output                  ext_csb_tile1,
  output                  sdo,
  output                  sclk,
  input                   sdi,
  inout                   ext_reset,
  inout                   ext_update,
  inout                   ext_rstb,
  inout                   ext_mute,
  output                  iic_scl,
  inout                   iic_sda);

  // internal signals

  wire        [94:0]      gpio_i;
  wire        [94:0]      gpio_o;
  wire        [94:0]      gpio_t;
  wire        [20:0]      gpio_bd;
  wire        [ 2:0]      spi_csn;
  
  reg         [7:0]       spi_3_to_8_csn;
  
  always @(*) begin
    case (spi_csn)
      3'h0: spi_3_to_8_csn = 8'b11111110;
      3'h1: spi_3_to_8_csn = 8'b11111101;
      3'h2: spi_3_to_8_csn = 8'b11111011;
      3'h3: spi_3_to_8_csn = 8'b11110111;
      default: spi_3_to_8_csn = 8'b11111111;
    endcase
  end

  // instantiations

  assign ext_csb_tile1 = spi_3_to_8_csn[0];
  assign ext_csb_tile2 = spi_3_to_8_csn[1];
  assign ext_csb_tile3 = spi_3_to_8_csn[2];
  assign ext_csb_tile4 = spi_3_to_8_csn[3];

  assign gpio_bd_o = gpio_o[20:13];
  
  assign gpio_i[12: 0] = gpio_bd_i;
  assign gpio_i[31:13] = gpio_o[31:13];
  assign gpio_i[94:36] = gpio_o[94:36];

  ad_iobuf #(.DATA_WIDTH(4)) i_iobuf (
   .dio_t (gpio_t[35:32]),
   .dio_i (gpio_o[35:32]),
   .dio_o (gpio_i[35:32]),
   .dio_p ({
             ext_reset,            // 35
             ext_update,           // 34
             ext_rstb,             // 33
             ext_mute}));          // 32
  
  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (),
    .iic_ka_band_scl_io (iic_scl),
    .iic_ka_band_sda_io (iic_sda),
    .spi0_sclk (sclk),
    .spi0_csn (spi_csn),
    .spi0_miso (sdi),
    .spi0_mosi (sdo),
    .spi1_sclk (),
    .spi1_csn (),
    .spi1_miso (1'b0),
    .spi1_mosi ());

endmodule

// ***************************************************************************
// ***************************************************************************
