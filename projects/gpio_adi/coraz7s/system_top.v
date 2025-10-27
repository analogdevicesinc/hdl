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
//
`timescale 1ns/100ps

module system_top (

  // DDR interface
  inout   [14:0]  ddr_addr,
  inout   [ 2:0]  ddr_ba,
  inout           ddr_cas_n,
  inout           ddr_ck_n,
  inout           ddr_ck_p,
  inout           ddr_cke,
  inout           ddr_cs_n,
  inout   [ 3:0]  ddr_dm,
  inout   [31:0]  ddr_dq,
  inout   [ 3:0]  ddr_dqs_n,
  inout   [ 3:0]  ddr_dqs_p,
  inout           ddr_odt,
  inout           ddr_ras_n,
  inout           ddr_reset_n,
  inout           ddr_we_n,

  // Fixed IO for PS
  inout           fixed_io_ddr_vrn,
  inout           fixed_io_ddr_vrp,
  inout   [53:0]  fixed_io_mio,
  inout           fixed_io_ps_clk,
  inout           fixed_io_ps_porb,
  inout           fixed_io_ps_srstb,

  // Buttons and LEDs
  inout   [ 1:0]  btn,
  inout   [ 5:0]  led,

  // I2C for Arduino header
  inout           iic_ard_scl,
  inout           iic_ard_sda

);

  // Internal GPIO
  (* MARK_DEBUG = "TRUE" *) wire [31:0] gpio_i;
  (* MARK_DEBUG = "TRUE" *) wire [31:0] gpio_o;
  (* MARK_DEBUG = "TRUE" *) wire [31:0] gpio_t;

  // IO Buffers for buttons (inputs)
  ad_iobuf #(
    .DATA_WIDTH (2)
  ) i_iobuf_buttons (
    .dio_t (gpio_t[1:0]),
    .dio_i (gpio_o[1:0]),
    .dio_o (gpio_i[1:0]),
    .dio_p (btn)
  );

  // IO Buffers for LEDs (outputs)
  ad_iobuf #(
    .DATA_WIDTH (6)
  ) i_iobuf_leds (
    .dio_t (gpio_t[7:2]),
    .dio_i (gpio_o[7:2]),
    .dio_o (gpio_i[7:2]),
    .dio_p (led)
  );

  wire [23:0] gpio_unused = 24'b0;
  assign gpio_i = {gpio_unused, gpio_i[7:0]};

  system_wrapper i_system_wrapper (
    .ddr_addr         (ddr_addr),
    .ddr_ba           (ddr_ba),
    .ddr_cas_n        (ddr_cas_n),
    .ddr_ck_n         (ddr_ck_n),
    .ddr_ck_p         (ddr_ck_p),
    .ddr_cke          (ddr_cke),
    .ddr_cs_n         (ddr_cs_n),
    .ddr_dm           (ddr_dm),
    .ddr_dq           (ddr_dq),
    .ddr_dqs_n        (ddr_dqs_n),
    .ddr_dqs_p        (ddr_dqs_p),
    .ddr_odt          (ddr_odt),
    .ddr_ras_n        (ddr_ras_n),
    .ddr_reset_n      (ddr_reset_n),
    .ddr_we_n         (ddr_we_n),

    .fixed_io_ddr_vrn (fixed_io_ddr_vrn),
    .fixed_io_ddr_vrp (fixed_io_ddr_vrp),
    .fixed_io_mio     (fixed_io_mio),
    .fixed_io_ps_clk  (fixed_io_ps_clk),
    .fixed_io_ps_porb (fixed_io_ps_porb),
    .fixed_io_ps_srstb(fixed_io_ps_srstb),

    .gpio_i           (gpio_i),
    .gpio_o           (gpio_o),
    .gpio_t           (gpio_t),

    .iic_ard_scl_io   (iic_ard_scl),
    .iic_ard_sda_io   (iic_ard_sda)
  );

endmodule

