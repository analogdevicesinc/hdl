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

  input   [12:0]  gpio_bd_i,
  output  [ 7:0]  gpio_bd_o,

  // Externally controlled ad469x 

  input           pmod_spi_cnv,
  input           pmod_spi_csb,
  input           pmod_spi_sck,
  input           pmod_spi_sdi,
  output          pmod_spi_sdo,

  input           pmod_spi_sof_cnv_pulse,
  input           pmod_spi_pad_dig_resetn,
  output          pmod_spi_gpio_0,
  output          pmod_spi_hb_led
);

  // internal signals
  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;

  assign gpio_bd_o = gpio_o[7:0];

  assign gpio_i[94:37] = gpio_o[94:37];
  assign gpio_i[31:21] = gpio_o[31:21];
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];


//// ad469x UPDATES //////

  wire            clk_8mhz;
  wire            clk_4mhz;

 
  wire ps_spi_csb;
  wire ps_spi_sck;
  wire ps_spi_sdi;
  wire ps_spi_sdo;

  wire ps_spi_cnv;
  wire ps_spi_sof_cnv_pulse;
  wire ps_spi_pad_dig_resetn;

  wire ps_spi_gpio_0;
  wire ps_spi_hb_led;

 
  assign ps_spi_cnv            = gpio_o[32];
  assign ps_spi_sof_cnv_pulse  = gpio_o[33];
  assign ps_spi_pad_dig_resetn = gpio_o[34];
  assign gpio_i[35]            = ps_spi_gpio_0;
  assign gpio_i[36]            = ps_spi_hb_led;
 
////////////////////////////

   // here first ad469x modules should be instantiated
// this module is controlled by the PS in the ZCU102
   
  ad469x_module digital_1 (
    .cnv(ps_spi_cnv),
    .csb(ps_spi_csb),
    .sck(ps_spi_sck),
    .sdi(ps_spi_sdi),
    .sdo(ps_spi_sdo),
    .sof_cnv_pulse(ps_spi_sof_cnv_pulse),
    .pad_dig_resetn(ps_spi_pad_dig_resetn),
    .gpio_0(ps_spi_gpio_0),
    .hb_led(ps_spi_hb_led),
    .hb_clk(clk_8mhz),
    .dig_post_proc_clk(clk_4mhz));

// this module is controlled trough the PMOD by the CoraZ7s

  ad469x_module digital_2 (
    .cnv(pmod_spi_cnv),
    .csb(pmod_spi_csb),
    .sck(pmod_spi_sck),
    .sdi(pmod_spi_sdi),
    .sdo(pmod_spi_sdo),
    .sof_cnv_pulse(pmod_spi_sof_cnv_pulse),
    .pad_dig_resetn(pmod_spi_pad_dig_resetn),
    .gpio_0(pmod_spi_gpio_0),
    .hb_led(pmod_spi_hb_led),
    .hb_clk(clk_8mhz),
    .dig_post_proc_clk(clk_4mhz));

    BUFGCE_DIV #(
      .BUFGCE_DIVIDE (2),
      .IS_CE_INVERTED (1'b0),
      .IS_CLR_INVERTED (1'b0),
      .IS_I_INVERTED (1'b0)
   ) i_div_clk_buf (
      .O (clk_4mhz),
      .CE (1'b1),
      .CLR (1'b0),
      .I (clk_8mhz));


  // instantiations
  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (),

    .spi0_csn (ps_spi_csb),
    .spi0_miso (ps_spi_sdo),
    .spi0_mosi (ps_spi_sdi),
    .spi0_sclk (ps_spi_sck),
    .spi1_csn (1'b1),
    .spi1_miso (1'b0),
    .spi1_mosi (),
    .spi1_sclk (),
    .clk_8MHz(clk_8mhz),
    .clk_4MHz(clk_4mhz),
    
    .debug_probe0(ps_spi_csb),
    .debug_probe1(ps_spi_sck),
    .debug_probe2(ps_spi_sdi),
    .debug_probe3(ps_spi_sdo),
    .debug_probe4(ps_spi_cnv),
    .debug_probe5(ps_spi_sof_cnv_pulse),
    .debug_probe6(ps_spi_pad_dig_resetn),
    .debug_probe7(ps_spi_gpio_0),
    .debug_probe8(ps_spi_hb_led),

    .debug_probe9(pmod_spi_csb),
    .debug_probe10(pmod_spi_sck),
    .debug_probe11(pmod_spi_sdi),
    .debug_probe12(pmod_spi_sdo),
    .debug_probe13(pmod_spi_cnv),
    .debug_probe14(pmod_spi_sof_cnv_pulse),
    .debug_probe15(pmod_spi_pad_dig_resetn),
    .debug_probe16(pmod_spi_gpio_0),
    .debug_probe17(pmod_spi_hb_led));
endmodule
