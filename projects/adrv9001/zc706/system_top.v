// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
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

  output                  spi_clk,
  output                  spi_dio,
  input                   spi_do,
  output                  spi_en,

  // Device clock passed through 9002
  input                   dev_clk_out,

  inout                   dgpio_0,
  inout                   dgpio_1,
  inout                   dgpio_2,
  inout                   dgpio_3,
  inout                   dgpio_4,
  inout                   dgpio_5,
  inout                   dgpio_6,
  inout                   dgpio_7,
  inout                   dgpio_8,
  inout                   dgpio_9,
  inout                   dgpio_10,
  inout                   dgpio_11,

  inout                   gp_int,
  inout                   mode,
  inout                   reset_trx,

  input                   rx1_dclk_in_n,
  input                   rx1_dclk_in_p,
  output                  rx1_enable,
  input                   rx1_idata_in_n,
  input                   rx1_idata_in_p,
  input                   rx1_qdata_in_n,
  input                   rx1_qdata_in_p,
  input                   rx1_strobe_in_n,
  input                   rx1_strobe_in_p,

  input                   rx2_dclk_in_n,
  input                   rx2_dclk_in_p,
  output                  rx2_enable,
  input                   rx2_idata_in_n,
  input                   rx2_idata_in_p,
  input                   rx2_qdata_in_n,
  input                   rx2_qdata_in_p,
  input                   rx2_strobe_in_n,
  input                   rx2_strobe_in_p,

  output                  tx1_dclk_out_n,
  output                  tx1_dclk_out_p,
  input                   tx1_dclk_in_n,
  input                   tx1_dclk_in_p,
  output                  tx1_enable,
  output                  tx1_idata_out_n,
  output                  tx1_idata_out_p,
  output                  tx1_qdata_out_n,
  output                  tx1_qdata_out_p,
  output                  tx1_strobe_out_n,
  output                  tx1_strobe_out_p,

  output                  tx2_dclk_out_n,
  output                  tx2_dclk_out_p,
  input                   tx2_dclk_in_n,
  input                   tx2_dclk_in_p,
  output                  tx2_enable,
  output                  tx2_idata_out_n,
  output                  tx2_idata_out_p,
  output                  tx2_qdata_out_n,
  output                  tx2_qdata_out_p,
  output                  tx2_strobe_out_n,
  output                  tx2_strobe_out_p,

  inout                   sm_fan_tach,
  input                   vadj_err,
  output                  platform_status,

  inout                   tdd_sync
);

  // internal registers
  // internal signals
  wire   [94:0] gpio_i;
  wire   [94:0] gpio_o;
  wire   [94:0] gpio_t;
  wire   [ 2:0] spi_csn;
  wire          gpio_rx1_enable_in;
  wire          gpio_rx2_enable_in;
  wire          gpio_tx1_enable_in;
  wire          gpio_tx2_enable_in;
  wire          rx1_enable_s;
  wire          rx2_enable_s;
  wire          tx1_enable_s;
  wire          tx2_enable_s;
  wire          tdd_sync_loc;
  wire          tdd_sync_i;
  wire          tdd_sync_cntr;
  wire          mssi_sync;

  // instantiations

  // multi-ssi synchronization
  //
  assign mssi_sync = gpio_o[54];

  assign platform_status = vadj_err;

  ad_iobuf #(
    .DATA_WIDTH(16)
  ) i_iobuf (
    .dio_t (vadj_err ? {16{1'b1}} : gpio_t[47:32]),
    .dio_i ({gpio_o[47:32]}),
    .dio_o ({gpio_i[47:32]}),
    .dio_p ({sm_fan_tach,  // 47
             reset_trx,    // 46
             mode,         // 45
             gp_int,       // 44
             dgpio_11,     // 43
             dgpio_10,     // 42
             dgpio_9,      // 41
             dgpio_8,      // 40
             dgpio_7,      // 39
             dgpio_6,      // 38
             dgpio_5,      // 37
             dgpio_4,      // 36
             dgpio_3,      // 35
             dgpio_2,      // 34
             dgpio_1,      // 33
             dgpio_0 }));  // 32

  assign gpio_rx1_enable_in = gpio_o[48];
  assign gpio_rx2_enable_in = gpio_o[49];
  assign gpio_tx1_enable_in = gpio_o[50];
  assign gpio_tx2_enable_in = gpio_o[51];

  ad_iobuf #(
    .DATA_WIDTH(15)
  ) i_iobuf_bd (
    .dio_t (gpio_t[14:0]),
    .dio_i (gpio_o[14:0]),
    .dio_o (gpio_i[14:0]),
    .dio_p (gpio_bd));

  assign gpio_i[54:48] = gpio_o[54:48];
  assign gpio_i[55] = vadj_err;
  assign gpio_i[63:56] = gpio_o[63:56];

  assign tdd_sync_loc = gpio_o[56];

  // tdd_sync_loc - local sync signal from a GPIO or other source
  // tdd_sync - external sync
  assign tdd_sync_i = tdd_sync_cntr ? tdd_sync_loc : tdd_sync;
  assign tdd_sync = tdd_sync_cntr ? tdd_sync_loc : 1'bz;

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
    .spi0_clk_i (1'b0),
    .spi0_clk_o (spi_clk_s),
    .spi0_csn_0_o (spi_en_s),
    .spi0_csn_1_o (),
    .spi0_csn_2_o (),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (spi_do),
    .spi0_sdo_i (1'b0),
    .spi0_sdo_o (spi_dio_s),
    .spi1_clk_i (1'b0),
    .spi1_clk_o (),
    .spi1_csn_0_o (),
    .spi1_csn_1_o (),
    .spi1_csn_2_o (),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (1'b0),
    .spi1_sdo_i (1'b0),
    .spi1_sdo_o (),

    //FMC connections
    .mssi_sync (mssi_sync),

    .tx_output_enable (~vadj_err),

    .rx1_dclk_in_n (rx1_dclk_in_n),
    .rx1_dclk_in_p (rx1_dclk_in_p),
    .rx1_idata_in_n (rx1_idata_in_n),
    .rx1_idata_in_p (rx1_idata_in_p),
    .rx1_qdata_in_n (rx1_qdata_in_n),
    .rx1_qdata_in_p (rx1_qdata_in_p),
    .rx1_strobe_in_n (rx1_strobe_in_n),
    .rx1_strobe_in_p (rx1_strobe_in_p),

    .rx2_dclk_in_n (rx2_dclk_in_n),
    .rx2_dclk_in_p (rx2_dclk_in_p),
    .rx2_idata_in_n (rx2_idata_in_n),
    .rx2_idata_in_p (rx2_idata_in_p),
    .rx2_qdata_in_n (rx2_qdata_in_n),
    .rx2_qdata_in_p (rx2_qdata_in_p),
    .rx2_strobe_in_n (rx2_strobe_in_n),
    .rx2_strobe_in_p (rx2_strobe_in_p),

    .tx1_dclk_out_n (tx1_dclk_out_n),
    .tx1_dclk_out_p (tx1_dclk_out_p),
    .tx1_dclk_in_n (tx1_dclk_in_n),
    .tx1_dclk_in_p (tx1_dclk_in_p),
    .tx1_idata_out_n (tx1_idata_out_n),
    .tx1_idata_out_p (tx1_idata_out_p),
    .tx1_qdata_out_n (tx1_qdata_out_n),
    .tx1_qdata_out_p (tx1_qdata_out_p),
    .tx1_strobe_out_n (tx1_strobe_out_n),
    .tx1_strobe_out_p (tx1_strobe_out_p),

    .tx2_dclk_out_n (tx2_dclk_out_n),
    .tx2_dclk_out_p (tx2_dclk_out_p),
    .tx2_dclk_in_n (tx2_dclk_in_n),
    .tx2_dclk_in_p (tx2_dclk_in_p),
    .tx2_idata_out_n (tx2_idata_out_n),
    .tx2_idata_out_p (tx2_idata_out_p),
    .tx2_qdata_out_n (tx2_qdata_out_n),
    .tx2_qdata_out_p (tx2_qdata_out_p),
    .tx2_strobe_out_n (tx2_strobe_out_n),
    .tx2_strobe_out_p (tx2_strobe_out_p),

    .rx1_enable (rx1_enable_s),
    .rx2_enable (rx2_enable_s),
    .tx1_enable (tx1_enable_s),
    .tx2_enable (tx2_enable_s),

    .gpio_rx1_enable_in (gpio_rx1_enable_in),
    .gpio_rx2_enable_in (gpio_rx2_enable_in),
    .gpio_tx1_enable_in (gpio_tx1_enable_in),
    .gpio_tx2_enable_in (gpio_tx2_enable_in),

    .tdd_sync (tdd_sync_i),
    .tdd_sync_cntr (tdd_sync_cntr));

  assign spi_clk = vadj_err ? 1'bz : spi_clk_s;
  assign spi_en  = vadj_err ? 1'bz : spi_en_s;
  assign spi_dio = vadj_err ? 1'bz : spi_dio_s;

  assign rx1_enable = vadj_err ? 1'bz : rx1_enable_s;
  assign rx2_enable = vadj_err ? 1'bz : rx2_enable_s;
  assign tx1_enable = vadj_err ? 1'bz : tx1_enable_s;
  assign tx2_enable = vadj_err ? 1'bz : tx2_enable_s;

endmodule
