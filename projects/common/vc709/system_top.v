// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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

  input           sys_rst,
  input           sys_clk_p,
  input           sys_clk_n,

  input           uart_sin,
  output          uart_sout,

  output  [13:0]  ddr3_addr,
  output  [ 2:0]  ddr3_ba,
  output          ddr3_cas_n,
  output          ddr3_ck_n,
  output          ddr3_ck_p,
  output          ddr3_cke,
  output          ddr3_cs_n,
  output  [ 7:0]  ddr3_dm,
  inout   [63:0]  ddr3_dq,
  inout   [ 7:0]  ddr3_dqs_n,
  inout   [ 7:0]  ddr3_dqs_p,
  output          ddr3_odt,
  output          ddr3_ras_n,
  output          ddr3_reset_n,
  output          ddr3_we_n,

  output  [26:1]  linear_flash_addr,
  output          linear_flash_adv_ldn,
  output          linear_flash_ce_n,
  output          linear_flash_oen,
  output          linear_flash_wen,
  inout   [15:0]  linear_flash_dq_io,

  output          fan_pwm,

  inout   [ 7:0]  gpio_bd_o,
  inout   [12:0]  gpio_bd_i,

  output          iic_rstn,
  inout           iic_scl,
  inout           iic_sda
);

  // internal signals
  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;

  assign gpio_i[63:32] = gpio_o[63:32];
  assign gpio_i[31:21] = gpio_o[31:21];

  // default logic
  assign fan_pwm = 1'b1;
  assign iic_rstn = 1'b1;

  // instantiations
  ad_iobuf #(
    .DATA_WIDTH (21)
  ) i_iobuf_bd (
    .dio_t (gpio_t[20:0]),
    .dio_i (gpio_o[20:0]),
    .dio_o (gpio_i[20:0]),
    .dio_p ({gpio_bd_o, gpio_bd_i}));

  system_wrapper i_system_wrapper (
    .ddr3_addr (ddr3_addr),
    .ddr3_ba (ddr3_ba),
    .ddr3_cas_n (ddr3_cas_n),
    .ddr3_ck_n (ddr3_ck_n),
    .ddr3_ck_p (ddr3_ck_p),
    .ddr3_cke (ddr3_cke),
    .ddr3_cs_n (ddr3_cs_n),
    .ddr3_dm (ddr3_dm),
    .ddr3_dq (ddr3_dq),
    .ddr3_dqs_n (ddr3_dqs_n),
    .ddr3_dqs_p (ddr3_dqs_p),
    .ddr3_odt (ddr3_odt),
    .ddr3_ras_n (ddr3_ras_n),
    .ddr3_reset_n (ddr3_reset_n),
    .ddr3_we_n (ddr3_we_n),

    .linear_flash_addr (linear_flash_addr),
    .linear_flash_adv_ldn (linear_flash_adv_ldn),
    .linear_flash_ce_n (linear_flash_ce_n),
    .linear_flash_oen (linear_flash_oen),
    .linear_flash_wen (linear_flash_wen),
    .linear_flash_dq_io (linear_flash_dq_io),

    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio0_i (gpio_i[31:0]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    .gpio1_i (gpio_i[63:32]),

    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),

    .sys_clk_n (sys_clk_n),
    .sys_clk_p (sys_clk_p),
    .sys_rst (sys_rst),

    .spi_clk_i (),
    .spi_clk_o (),
    .spi_csn_i (1'b1),
    .spi_csn_o (),
    .spi_sdi_i (1'b0),
    .spi_sdo_i (1'b0),
    .spi_sdo_o (),

    .uart_sin (uart_sin),
    .uart_sout (uart_sout));

endmodule
