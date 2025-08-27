// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
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
  adc_db,
  adc_rd_n,
  adc_wr_n,
  adc_busy,
  adc_cnvst_n,
  adc_cs_n,
  adc_first_data,
  adc_reset,
  adc_os,
  adc_stby,
  adc_range,
  adc_refsel,
  adc_serpar
);

  inout       [15:0]      adc_db;
  output                  adc_rd_n;
  output                  adc_wr_n;

  input                   adc_busy;
  output                  adc_cnvst_n;
  output                  adc_cs_n;
  input                   adc_first_data;
  output                  adc_reset;
  output      [2:0]       adc_os;
  output                  adc_stby;
  output                  adc_range;
  output                  adc_refsel;
  output                  adc_serpar;

  // internal signals

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [94:0]  gpio_t;

  wire            adc_db_t;
  wire    [15:0]  adc_db_o;
  wire    [15:0]  adc_db_i;

  genvar i;

  // instantiations

  assign adc_serpar = gpio_o[39];
  assign adc_refsel = gpio_o[38];
  assign adc_reset = gpio_o[37];
  assign adc_stby = gpio_o[36];
  assign adc_range = gpio_o[35];
  assign adc_os = gpio_o[34:32];

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
    .rx_busy (adc_busy),
    .rx_cnvst_n (adc_cnvst_n),
    .rx_cs_n (adc_cs_n),
    .rx_db_i (adc_db_i),
    .rx_db_o (adc_db_o),
    .rx_db_t (adc_db_t),
    .rx_first_data (adc_first_data),
    .rx_rd_n (adc_rd_n),
    .rx_wr_n (adc_wr_n));

endmodule
