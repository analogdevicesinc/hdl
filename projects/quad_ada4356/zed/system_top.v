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

  inout  [14:0] ddr_addr,
  inout  [ 2:0] ddr_ba,
  inout         ddr_cas_n,
  inout         ddr_ck_n,
  inout         ddr_ck_p,
  inout         ddr_cke,
  inout         ddr_cs_n,
  inout  [ 3:0] ddr_dm,
  inout  [31:0] ddr_dq,
  inout  [ 3:0] ddr_dqs_n,
  inout  [ 3:0] ddr_dqs_p,
  inout         ddr_odt,
  inout         ddr_ras_n,
  inout         ddr_reset_n,
  inout         ddr_we_n,

  inout         fixed_io_ddr_vrn,
  inout         fixed_io_ddr_vrp,
  inout  [53:0] fixed_io_mio,
  inout         fixed_io_ps_clk,
  inout         fixed_io_ps_porb,
  inout         fixed_io_ps_srstb,

  inout  [31:0] gpio_bd,

  output        hdmi_out_clk,
  output        hdmi_vsync,
  output        hdmi_hsync,
  output        hdmi_data_e,
  output [15:0] hdmi_data,

  output        i2s_mclk,
  output        i2s_bclk,
  output        i2s_lrclk,
  output        i2s_sdata_out,
  input         i2s_sdata_in,

  output        spdif,

  inout         iic_scl,
  inout         iic_sda,
  inout  [ 1:0] iic_mux_scl,
  inout  [ 1:0] iic_mux_sda,

  input         otg_vbusoc,

  // Quad ADA4356 LVDS data interfaces

  // Instance 0 (DUT A) - bank 34
  input         dco_0_p,
  input         dco_0_n,
  input         d0a_0_p,
  input         d0a_0_n,
  input         d1a_0_p,
  input         d1a_0_n,
  input         frame_0_p,
  input         frame_0_n,

  // Instance 1 (DUT B) - bank 34
  input         dco_1_p,
  input         dco_1_n,
  input         d0a_1_p,
  input         d0a_1_n,
  input         d1a_1_p,
  input         d1a_1_n,
  input         frame_1_p,
  input         frame_1_n,

  // Instance 2 (DUT C) - bank 35
  input         dco_2_p,
  input         dco_2_n,
  input         d0a_2_p,
  input         d0a_2_n,
  input         d1a_2_p,
  input         d1a_2_n,
  input         frame_2_p,
  input         frame_2_n,

  // Instance 3 (DUT D) - bank 35
  input         dco_3_p,
  input         dco_3_n,
  input         d0a_3_p,
  input         d0a_3_n,
  input         d1a_3_p,
  input         d1a_3_n,
  input         frame_3_p,
  input         frame_3_n,

  // ADA4356 SPI interface (shared bus)
  output        sclk,
  output        mosi,
  input         miso,

  // ADA4356 SPI chip selects (active low)
  inout         csb_duta,
  inout         csb_dutb,
  inout         csb_dutc,
  inout         csb_dutd,
  inout         csb_ad9510,

  // TDD LiDAR control
  input         trig_fmc_in,
  output        trig_fmc_out
);

  // internal signals

  wire [63:0] gpio_i;
  wire [63:0] gpio_o;
  wire [63:0] gpio_t;

  wire [ 1:0] iic_mux_scl_i_s;
  wire [ 1:0] iic_mux_scl_o_s;
  wire        iic_mux_scl_t_s;
  wire [ 1:0] iic_mux_sda_i_s;
  wire [ 1:0] iic_mux_sda_o_s;
  wire        iic_mux_sda_t_s;

  // GPIO mapping:
  // [31: 0] - gpio_bd (directly active on Zedboard LEDs/switches/buttons)
  // [32]    - csb_duta
  // [33]    - csb_dutb
  // [34]    - csb_dutc
  // [35]    - csb_dutd
  // [36]    - csb_ad9510
  // [63:37] - unused
  // trig_fmc_in/out connected to TDD controller (not GPIO)

  assign gpio_i[63:37] = gpio_o[63:37];

  ad_iobuf #(
    .DATA_WIDTH(32)
  ) i_gpio_bd (
    .dio_t(gpio_t[31:0]),
    .dio_i(gpio_o[31:0]),
    .dio_o(gpio_i[31:0]),
    .dio_p(gpio_bd));

  ad_iobuf #(
    .DATA_WIDTH(5)
  ) i_iobuf_fmc_gpio (
    .dio_t(gpio_t[36:32]),
    .dio_i(gpio_o[36:32]),
    .dio_o(gpio_i[36:32]),
    .dio_p({csb_ad9510,
            csb_dutd,
            csb_dutc,
            csb_dutb,
            csb_duta}));

  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_iobuf_iic_scl (
    .dio_t ({iic_mux_scl_t_s,iic_mux_scl_t_s}),
    .dio_i (iic_mux_scl_o_s),
    .dio_o (iic_mux_scl_i_s),
    .dio_p (iic_mux_scl));

  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_iobuf_iic_sda (
    .dio_t ({iic_mux_sda_t_s,iic_mux_sda_t_s}),
    .dio_i (iic_mux_sda_o_s),
    .dio_o (iic_mux_sda_i_s),
    .dio_p (iic_mux_sda));

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
    .i2s_bclk (i2s_bclk),
    .i2s_lrclk (i2s_lrclk),
    .i2s_mclk (i2s_mclk),
    .i2s_sdata_in (i2s_sdata_in),
    .i2s_sdata_out (i2s_sdata_out),
    .iic_fmc_scl_io (iic_scl),
    .iic_fmc_sda_io (iic_sda),
    .iic_mux_scl_i (iic_mux_scl_i_s),
    .iic_mux_scl_o (iic_mux_scl_o_s),
    .iic_mux_scl_t (iic_mux_scl_t_s),
    .iic_mux_sda_i (iic_mux_sda_i_s),
    .iic_mux_sda_o (iic_mux_sda_o_s),
    .iic_mux_sda_t (iic_mux_sda_t_s),
    .otg_vbusoc (otg_vbusoc),
    .spdif (spdif),
    .spi0_clk_i (1'b0),
    .spi0_clk_o (sclk),
    .spi0_csn_0_o (),
    .spi0_csn_1_o (),
    .spi0_csn_2_o (),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (miso),
    .spi0_sdo_i (1'b0),
    .spi0_sdo_o (mosi),
    .spi1_clk_i (1'b0),
    .spi1_clk_o (),
    .spi1_csn_0_o (),
    .spi1_csn_1_o (),
    .spi1_csn_2_o (),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (1'b0),
    .spi1_sdo_i (1'b0),
    .spi1_sdo_o (),

    // Quad ADA4356 connections
    .dco_0_p (dco_0_p),
    .dco_0_n (dco_0_n),
    .d0a_0_p (d0a_0_p),
    .d0a_0_n (d0a_0_n),
    .d1a_0_p (d1a_0_p),
    .d1a_0_n (d1a_0_n),
    .frame_0_p (frame_0_p),
    .frame_0_n (frame_0_n),
    .sync_0_n (1'b1),

    .dco_1_p (dco_1_p),
    .dco_1_n (dco_1_n),
    .d0a_1_p (d0a_1_p),
    .d0a_1_n (d0a_1_n),
    .d1a_1_p (d1a_1_p),
    .d1a_1_n (d1a_1_n),
    .frame_1_p (frame_1_p),
    .frame_1_n (frame_1_n),
    .sync_1_n (1'b1),

    .dco_2_p (dco_2_p),
    .dco_2_n (dco_2_n),
    .d0a_2_p (d0a_2_p),
    .d0a_2_n (d0a_2_n),
    .d1a_2_p (d1a_2_p),
    .d1a_2_n (d1a_2_n),
    .frame_2_p (frame_2_p),
    .frame_2_n (frame_2_n),
    .sync_2_n (1'b1),

    .dco_3_p (dco_3_p),
    .dco_3_n (dco_3_n),
    .d0a_3_p (d0a_3_p),
    .d0a_3_n (d0a_3_n),
    .d1a_3_p (d1a_3_p),
    .d1a_3_n (d1a_3_n),
    .frame_3_p (frame_3_p),
    .frame_3_n (frame_3_n),
    .sync_3_n (1'b1),

    // TDD LiDAR control
    .trig_fmc_in (trig_fmc_in),
    .trig_fmc_out (trig_fmc_out));

endmodule
