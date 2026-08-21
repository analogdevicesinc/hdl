// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2019-2026 Analog Devices, Inc. All rights reserved.
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

  output        spdif,

  output        i2s_mclk,
  output        i2s_bclk,
  output        i2s_lrclk,
  output        i2s_sdata_out,
  input         i2s_sdata_in,

  inout         iic_scl,
  inout         iic_sda,
  inout  [ 1:0] iic_mux_scl,
  inout  [ 1:0] iic_mux_sda,

  input         otg_vbusoc,

  // ad4134 SPI configuration interface

  input         emg_spi_sdi,
  output        emg_spi_sdo,
  output        emg_spi_sclk,
  output [ 1:0] emg_spi_cs,

  // ad4134 data interface

  output        emg_dclk,
  input  [ 7:0] emg_din,
  output        emg_odr,

  // ad4134 GPIO lines

  inout  [ 1:0] emg_resetn,
  inout  [ 1:0] emg_pdn,
  inout  [ 1:0] emg_mode,
  inout  [ 7:0] emg_gpio,
  inout         emg_pinbspi,
  inout         emg_dclkmode,

  // ad4134 reference clock (not used by default)

  output        emg_sdpclk,

  // amplifier SPI interface

  output [ 7:0] emg_amp_cs,
  output        emg_amp_sdi,
  input         emg_amp_sdo,
  output        emg_amp_sclk,

  // channel enables CH4..CH7

  output [ 3:0] emg_ch_en,

  // SW phase 2 - AD5940 / MAX30011, pins reserved and held idle

  output        emg_ad5940_cs,
  output        emg_ad5940_sclk,
  output        emg_ad5940_sdi,
  input         emg_ad5940_sdo,

  output        emg_max30011_cs,
  output        emg_max30011_sclk,
  output        emg_max30011_sdi,
  input         emg_max30011_sdo
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

  wire [1:0]  cs;
  wire        resetn;

  // instantiations
  assign emg_spi_cs = gpio_o[50] ? {cs[0], cs[0]} : cs;
  assign emg_amp_cs = gpio_o[58:51];

  // CH4..CH7 enables reuse the top of the EMIO GPIO range.  The PS7 EMIO GPIO is
  // 64 bits wide and the rest of it is already allocated, so [63:60] are taken from
  // the read-back range rather than adding an axi_gpio for four bits.
  assign emg_ch_en = gpio_o[63:60];
  assign gpio_i[63:48] = gpio_o[63:48];

  // SW phase 2 - AD5940 and MAX30011 are on the FMC but have no controller in the
  // block design yet.  Hold both buses idle (chip selects high, no clock activity)
  // so the pins are constrained and the board routing is exercised.
  assign emg_ad5940_cs = 1'b1;
  assign emg_ad5940_sclk = 1'b0;
  assign emg_ad5940_sdi = 1'b0;

  assign emg_max30011_cs = 1'b1;
  assign emg_max30011_sclk = 1'b0;
  assign emg_max30011_sdi = 1'b0;

  ad_iobuf #(
    .DATA_WIDTH(14)
  ) i_iobuf_emg_gpio (
    .dio_t(gpio_t[47:34]),
    .dio_i(gpio_o[47:34]),
    .dio_o(gpio_i[47:34]),
    .dio_p({emg_dclkmode,    // [47]
            emg_pinbspi,     // [46]
            emg_gpio,        // [45:38]
            emg_mode,        // [37:36]
            emg_pdn }));     // [35:34]

  // gpio_o[33] reserved in devicetree for reset
  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_iobuf_emg_resetn (
    .dio_t({gpio_t[32], gpio_t[32]}),
    .dio_i({gpio_o[32], gpio_o[32]}),
    .dio_o(gpio_i[33:32]),
    .dio_p(emg_resetn));      // [33:32]

  ad_iobuf #(
    .DATA_WIDTH(32)
  ) i_iobuf (
    .dio_t(gpio_t[31:0]),
    .dio_i(gpio_o[31:0]),
    .dio_o(gpio_i[31:0]),
    .dio_p(gpio_bd));

  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_iic_mux_scl (
    .dio_t({iic_mux_scl_t_s, iic_mux_scl_t_s}),
    .dio_i(iic_mux_scl_o_s),
    .dio_o(iic_mux_scl_i_s),
    .dio_p(iic_mux_scl));

  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_iic_mux_sda (
    .dio_t({iic_mux_sda_t_s, iic_mux_sda_t_s}),
    .dio_i(iic_mux_sda_o_s),
    .dio_o(iic_mux_sda_i_s),
    .dio_p(iic_mux_sda));

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
    .spi0_clk_i (emg_spi_sclk),
    .spi0_clk_o (emg_spi_sclk),
    .spi0_csn_0_o (cs[0]),
    .spi0_csn_1_o (cs[1]),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (emg_spi_sdi),
    .spi0_sdo_i (emg_spi_sdo),
    .spi0_sdo_o (emg_spi_sdo),
    .emg_di_sdo (),
    .emg_di_sdo_t (),
    .emg_di_sdi (emg_din),
    .emg_di_cs (),
    .emg_di_sclk (emg_dclk),
    .emg_odr (emg_odr),
    .emg_sdpclk (emg_sdpclk),
    .spi1_clk_i (emg_amp_sclk),
    .spi1_clk_o (emg_amp_sclk),
    .spi1_csn_0_o (),
    .spi1_csn_1_o (),
    .spi1_csn_2_o (),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (emg_amp_sdo),
    .spi1_sdo_i (emg_amp_sdi),
    .spi1_sdo_o (emg_amp_sdi),
    .otg_vbusoc (otg_vbusoc),
    .spdif (spdif));

endmodule
