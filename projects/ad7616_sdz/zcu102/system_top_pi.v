// ***************************************************************************
// ***************************************************************************
// Copyright 2023 (c) Analog Devices, Inc. All rights reserved.
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
  inout   [31:0]  gpio_bd,

  inout   [15:0]  adc_db,
  output          adc_rd_n,
  output          adc_wr_n,

  output          adc_cs_n,
  output          adc_reset_n,
  output          adc_convst,
  input           adc_busy,
  output          adc_seq_en,
  output  [ 1:0]  adc_hw_rngsel,
  output  [ 2:0]  adc_chsel
);

  // internal signals

  assign gpio_bd_o = gpio_o[7:0];

  assign gpio_i[94:21] = gpio_o[94:21];
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];

  // internal signals

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [94:0]  gpio_t;

  wire            adc_db_t;
  wire    [15:0]  adc_db_o;
  wire    [15:0]  adc_db_i;

  genvar i;

  // instantiations

  ad_iobuf #(
    .DATA_WIDTH(7)
  ) i_iobuf_adc_cntrl (
    .dio_t ({gpio_t[43:41], gpio_t[37], gpio_t[35:33]}),
    .dio_i ({gpio_o[43:41], gpio_o[37], gpio_o[35:33]}),
    .dio_o ({gpio_i[43:41], gpio_i[37], gpio_i[35:33]}),
    .dio_p ({adc_reset_n,        // 43
             adc_hw_rngsel,      // 42:41
             adc_seq_en,         // 37
             adc_chsel}));       // 35:33

  assign gpio_i[94:44] = gpio_o[94:44];
  assign gpio_i[40:38] = gpio_o[40:38];
  assign gpio_i[36] = gpio_o[36];

  generate
    for (i = 0; i < 16; i = i + 1) begin: adc_db_io
      ad_iobuf i_iobuf_adc_db (
        .dio_t(adc_db_t),
        .dio_i(adc_db_o[i]),
        .dio_o(adc_db_i[i]),
        .dio_p(adc_db[i]));
    end
  endgenerate

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    
    .spi0_csn (1'b1),
    .spi0_miso (1'b0),
    .spi0_mosi (),
    .spi0_sclk (),
    .spi1_csn (1'b1),
    .spi1_miso (1'b0),
    .spi1_mosi (),
    .spi1_sclk (),
    .rx_cnvst (adc_convst),
    .rx_cs_n (adc_cs_n),
    .rx_busy (adc_busy),
    .rx_db_o (adc_db_o),
    .rx_db_i (adc_db_i),
    .rx_db_t (adc_db_t),
    .rx_rd_n (adc_rd_n),
    .rx_wr_n (adc_wr_n));

endmodule
