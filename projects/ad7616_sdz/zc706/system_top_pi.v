// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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

  inout       [14:0]      ddr_addr,
  inout       [ 2:0]      ddr_ba,
  inout                   ddr_cas_n,
  inout                   ddr_ck_n,
  inout                   ddr_ck_p,
  inout                   ddr_cke,
  inout                   ddr_cs_n,
  inout       [ 3:0]      ddr_dm,
  inout       [31:0]      ddr_dq,
  inout       [ 3:0]      ddr_dqs_n,
  inout       [ 3:0]      ddr_dqs_p,
  inout                   ddr_odt,
  inout                   ddr_ras_n,
  inout                   ddr_reset_n,
  inout                   ddr_we_n,

  inout                   fixed_io_ddr_vrn,
  inout                   fixed_io_ddr_vrp,
  inout       [53:0]      fixed_io_mio,
  inout                   fixed_io_ps_clk,
  inout                   fixed_io_ps_porb,
  inout                   fixed_io_ps_srstb,

  inout       [14:0]      gpio_bd,

  output                  hdmi_out_clk,
  output                  hdmi_vsync,
  output                  hdmi_hsync,
  output                  hdmi_data_e,
  output      [23:0]      hdmi_data,

  output                  spdif,

  inout                   iic_scl,
  inout                   iic_sda,

  inout       [15:0]      adc_db,
  output                  adc_rd_n,
  output                  adc_wr_n,

  output                  adc_cs_n,
  output                  adc_reset_n,
  output                  adc_convst,
  input                   adc_busy,
  output                  adc_seq_en,
  output      [ 1:0]      adc_hw_rngsel,
  output      [ 2:0]      adc_chsel);

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;

  wire            adc_db_t;
  wire    [15:0]  adc_db_o;
  wire    [15:0]  adc_db_i;

  genvar i;

  // instantiations

  ad_iobuf #(.DATA_WIDTH(7)) i_iobuf_adc_cntrl (
    .dio_t ({gpio_t[43:41], gpio_t[37], gpio_t[35:33]}),
    .dio_i ({gpio_o[43:41], gpio_o[37], gpio_o[35:33]}),
    .dio_o ({gpio_i[43:41], gpio_i[37], gpio_i[35:33]}),
    .dio_p ({adc_reset_n,        // 43
             adc_hw_rngsel,      // 42:41
             adc_seq_en,         // 37
             adc_chsel}));       // 35:33

  generate
    for (i = 0; i < 16; i = i + 1) begin: adc_db_io
      ad_iobuf i_iobuf_adc_db (
        .dio_t(adc_db_t),
        .dio_i(adc_db_o[i]),
        .dio_o(adc_db_i[i]),
        .dio_p(adc_db[i]));
    end
  endgenerate

  ad_iobuf #(
    .DATA_WIDTH(15)
  ) i_iobuf_gpio (
    .dio_t(gpio_t[14:0]),
    .dio_i(gpio_o[14:0]),
    .dio_o(gpio_i[14:0]),
    .dio_p(gpio_bd));

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
    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .spdif (spdif),
    .rx_cnvst (adc_convst),
    .rx_cs_n (adc_cs_n),
    .rx_busy (adc_busy),
    .rx_db_o (adc_db_o),
    .rx_db_i (adc_db_i),
    .rx_db_t (adc_db_t),
    .rx_rd_n (adc_rd_n),
    .rx_wr_n (adc_wr_n)
  );

endmodule

// ***************************************************************************
// ***************************************************************************
