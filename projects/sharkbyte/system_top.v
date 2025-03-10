// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2025 Analog Devices, Inc. All rights reserved.
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

  inout   [14:0]  ddr_addr,
  inout   [ 2:0]  ddr_ba,
  inout           ddr_cas_n,
  inout           ddr_ck_n,
  inout           ddr_ck_p,
  inout           ddr_cke,
  inout           ddr_cs_n,
  inout   [ 1:0]  ddr_dm,
  inout   [15:0]  ddr_dq,
  inout   [ 1:0]  ddr_dqs_n,
  inout   [ 1:0]  ddr_dqs_p,
  inout           ddr_odt,
  inout           ddr_ras_n,
  inout           ddr_reset_n,
  inout           ddr_we_n,

  inout           fixed_io_ddr_vrn,
  inout           fixed_io_ddr_vrp,
  inout   [31:0]  fixed_io_mio,
  inout           fixed_io_ps_clk,
  inout           fixed_io_ps_porb,
  inout           fixed_io_ps_srstb,

  // JTAG
  input           jtag_tck,
  input           jtag_tdi,
  input           jtag_tms,
  output          jtag_tdo,   // ? how to connect them? 
  
  // I2C - ?
  inout           iic_scl,
  inout           iic_sca,

  inout           ad9696_ldac,

  // these signals are new, must be added/changed in constraints and base design

  input           clk_in_a1_p, // new, were added to bd, all need constraints mapping
  input           clk_in_a1_n, // new

  input           clk_in_a2_p,
  input           clk_in_a2_n,

  input           fclk_a1_p, // new
  input           fclk_a1_n, // new

  input           fclk_a2_p,
  input           fclk_a2_n, 

  input   [ 7:0]  data_in_a1_p, // new, name should be changed in BD, from previous name
  input   [ 7:0]  data_in_a1_n, // and modify the IP too
  input   [ 7:0]  data_in_a2_p, // new, add those two in BD too
  input   [ 7:0]  data_in_a2_n, // new

  output          spi_a1_csn,
  output          spi_a2_csn,
  output          spi_clk,
  inout           spi_sdio
);

  // internal signals

  wire            spi_miso_s;
  wire            spi_mosi_s;
  wire    [17:0]  gpio_i;
  wire    [17:0]  gpio_o;
  wire    [17:0]  gpio_t;
  wire    [6:0]   ps_gpio;

  // instantiations

  ad_iobuf #(
    .DATA_WIDTH(14)
  ) i_iobuf (
    .dio_t (gpio_t[0]),
    .dio_i (gpio_o[0]),
    .dio_o (gpio_i[0]),
    .dio_p (ad9696_ldac));

  ad_3w_spi #(
    .NUM_OF_SLAVES(2)
  ) i_spi (
    .spi_csn ({spi_a1_csn, spi_a2_csn}),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi_s),
    .spi_miso (spi_miso_s),
    .spi_sdio (spi_sdio),
    .spi_dir ());
    

  assign gpio_i[17:1] = gpio_o[17:1];
  assign ps_gpio[6:0] = ps_gpio[6:0];

  system_wrapper i_system_wrapper (
    .ddr_addr (ddr_addr),
    .ddr_ba (ddr_ba),
    .ddr_cas_n (ddr_cas_n),
    .ddr_ck_n (ddr_ck_n),
    .ddr_ck_p (ddr_ck_p),
    .ddr_cke (ddr_cke),
    .ddr_cs_n (ddr_cs_n),
    .ddr_dm (ddr_dm),
    .ddr_dq (ddr_dq),
    .ddr_dqs_n (ddr_dqs_n),
    .ddr_dqs_p (ddr_dqs_p),
    .ddr_odt (ddr_odt),
    .ddr_ras_n (ddr_ras_n),
    .ddr_reset_n (ddr_reset_n),
    .ddr_we_n (ddr_we_n),
    .fixed_io_ddr_vrn (fixed_io_ddr_vrn),
    .fixed_io_ddr_vrp (fixed_io_ddr_vrp),
    .fixed_io_mio (fixed_io_mio),
    .fixed_io_ps_clk (fixed_io_ps_clk),
    .fixed_io_ps_porb (fixed_io_ps_porb),
    .fixed_io_ps_srstb (fixed_io_ps_srstb),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),

    .spi0_clk_i (1'b0),
    .spi0_clk_o (spi_clk),
    .spi0_csn_0_o (spi_a1_csn), // 1st ADC
    .spi0_csn_1_o (spi_a2_csn), // 2nd ADC
    .spi0_csn_2_o (),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (spi_miso_s),
    .spi0_sdo_i (1'b0),
    .spi0_sdo_o (spi_mosi_s),

    .clk_in_a1_p (clk_in_a1_p),
    .clk_in_a1_n (clk_in_a1_n),
    .clk_in_a2_p (clk_in_a2_p),
    .clk_in_a2_n (clk_in_a2_n),
    
    .fclk_a1_p (fclk_a1_p),
    .fclk_a1_n (fclk_a1_n),
    .fclk_a2_p (fclk_a2_p),
    .fclk_a2_n (fclk_a2_n),

    .data_in_a1_p (data_in_a1_p),
    .data_in_a1_n (data_in_a1_n),
    .data_in_a2_p (data_in_a2_p),
    .data_in_a2_n (data_in_a2_n),

    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sca));

endmodule
