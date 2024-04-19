// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
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
  input           clk_125,
  input           resetn,

  input           sw_4,
  input           sw_5,
  input   [7:0]   dip_sw_1_to_8,
  output  [23:0]  leds_0_to_23,

  input           uart_rx,
  output          uart_tx,

  input           spi_miso,
  output          spi_sclk,
  output          spi_ssn,
  output          spi_mosi,

  inout           iic_scl,
  inout           iic_sda
);

  wire    [31:0]  gpio0_o;
  wire    [31:0]  gpio0_i;
  wire    [31:0]  gpio0_en_o;

  wire    [31:0]  gpio1_o;
  wire    [31:0]  gpio1_i;
  wire    [31:0]  gpio1_en_o;

  assign leds_0_to_23 = gpio0_o[23:0];
  assign gpio0_i[31:24] = dip_sw_1_to_8;
  assign gpio1_i[31:30] = {sw_5, sw_4};
  assign gpio1_i[29:0] = gpio1_o[29:0];

  template_lfcpnx template_lfcpnx_inst (
    .gpio0_o(gpio0_o),
    .gpio0_i(gpio0_i),
    .gpio0_en_o(gpio0_en_o),
    .gpio1_o(gpio1_o),
    .gpio1_i(gpio1_i),
    .gpio1_en_o(gpio1_en_o),
    .scl_io (iic_scl),
    .sda_io (iic_sda),
    .rstn_i (resetn),
    .ssn_o (spi_ssn),
    .mosi_o (spi_mosi),
    .sclk_o (spi_sclk),
    .miso_i (spi_miso),
    .rxd_i (uart_rx),
    .txd_o (uart_tx),
    .clk_125 (clk_125));

endmodule
