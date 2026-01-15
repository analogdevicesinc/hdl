// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

  input   [12:0]  gpio_bd_i,
  output  [ 7:0]  gpio_bd_o,

  // GPIO
  output FPGA_TRIG,
  input  UDC_PG,
  output TR_PULSE,
  output TX_LOAD,
  output RX_LOAD,
  inout  FPGA_BOOT_GOOD,

  // CMD SPI
  output CMD_SPI_SCLK,
  output CMD_SPI_CSB,
  output CMD_SPI_MOSI,
  input  CMD_SPI_MISO,

  // Aurora
  input        aurora_refclk_p,
  input        aurora_refclk_n,
  output [1:0] aurora_txp,
  output [1:0] aurora_txn,
  input  [1:0] aurora_rxp,
  input  [1:0] aurora_rxn
);

  // internal signals
  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;

  assign gpio_bd_o = gpio_o[7:0];

  assign gpio_i[94:21] = gpio_o[94:21];
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];

  wire [5:0] adsy2301_3_gpio_i;
  wire [5:0] adsy2301_3_gpio_o;
  wire [5:0] adsy2301_3_gpio_t;

  assign RX_LOAD    = adsy2301_3_gpio_o[1];
  assign TX_LOAD    = adsy2301_3_gpio_o[2];
  assign TR_PULSE   = adsy2301_3_gpio_o[3];
  assign FPGA_TRIG  = adsy2301_3_gpio_o[5];

  assign adsy2301_3_gpio_i[4]  = UDC_PG;

  // instantiations

  ad_iobuf #(
    .DATA_WIDTH(1)
  ) i_iobuf (
    .dio_t (adsy2301_3_gpio_t[0]),
    .dio_i (adsy2301_3_gpio_o[0]),
    .dio_o (adsy2301_3_gpio_i[0]),
    .dio_p (FPGA_BOOT_GOOD));

  system_wrapper i_system_wrapper (
    .gpio_pins_i (adsy2301_3_gpio_i),
    .gpio_pins_o (adsy2301_3_gpio_o),
    .gpio_pins_t (adsy2301_3_gpio_t),
    .cmd_spi_sclk(CMD_SPI_SCLK),
    .cmd_spi_csb(CMD_SPI_CSB),
    .cmd_spi_mosi(CMD_SPI_MOSI),
    .cmd_spi_miso(CMD_SPI_MISO),
    .gt_diff_refclk_clk_p(aurora_refclk_p),
    .gt_diff_refclk_clk_n(aurora_refclk_n),
    .gt_serial_tx_txp(aurora_txp),
    .gt_serial_tx_txn(aurora_txn),
    .gt_serial_rx_rxp(aurora_rxp),
    .gt_serial_rx_rxn(aurora_rxn),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t ());

endmodule
