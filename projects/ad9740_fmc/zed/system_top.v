// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

module system_top #(
  parameter DAC_RESOLUTION = 14
) (

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

  inout           fixed_io_ddr_vrn,
  inout           fixed_io_ddr_vrp,
  inout   [53:0]  fixed_io_mio,
  inout           fixed_io_ps_clk,
  inout           fixed_io_ps_porb,
  inout           fixed_io_ps_srstb,

  inout   [31:0]  gpio_bd,

  output          hdmi_out_clk,
  output          hdmi_vsync,
  output          hdmi_hsync,
  output          hdmi_data_e,
  output  [15:0]  hdmi_data,

  output          spdif,

  output          i2s_mclk,
  output          i2s_bclk,
  output          i2s_lrclk,
  output          i2s_sdata_out,
  input           i2s_sdata_in,

  inout           iic_scl,
  inout           iic_sda,
  inout   [ 1:0]  iic_mux_scl,
  inout   [ 1:0]  iic_mux_sda,

  input           otg_vbusoc,

  // adf4351 interface

  output          adf4351_ce,
  output          adf4351_clk,
  output          adf4351_csn,
  output          adf4351_mosi,

  // ad9740 interface

  input           ad9740_clk_p,
  input           ad9740_clk_n,
  output  [13:0]  ad9740_data
);

  localparam ZERO_BITS = 14 - DAC_RESOLUTION;

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire    [ 1:0]  iic_mux_scl_i_s;
  wire    [ 1:0]  iic_mux_scl_o_s;
  wire            iic_mux_scl_t_s;
  wire    [ 1:0]  iic_mux_sda_i_s;
  wire    [ 1:0]  iic_mux_sda_o_s;
  wire            iic_mux_sda_t_s;
  wire            ad9740_clk_ds;
  wire            ad9740_clk_bufg;
  wire            ad9740_clk;
  wire            ad9740_pll_locked;
  wire            ad9740_pll_fb;
  wire    [27:0]  ad9740_data_int;
  wire    [13:0]  ad9740_data_d1;
  wire    [13:0]  ad9740_data_d2;

  assign gpio_i[63:32] = gpio_o[63:32];
  assign adf4351_ce = 1'b1;

  // DDR data: d1 = rising edge (first sample), d2 = falling edge (second sample)
  assign ad9740_data_d1 = ad9740_data_int[13:0];
  assign ad9740_data_d2 = ad9740_data_int[27:14];

  // Differential input buffer for DAC clock (210 MHz)
  IBUFDS i_ad9740_clk_ibuf_ds (
    .I (ad9740_clk_p),
    .IB (ad9740_clk_n),
    .O (ad9740_clk_ds));

  // PLL: divide input clock by 2 for logic, ODDR outputs DDR data
  // Optimized for wide frequency range: 107 MHz to 210 MHz input
  // VCO = CLKIN * 15 / 2 = CLKIN * 7.5 (valid range: 802-1575 MHz)
  // CLKOUT = VCO / 15 = CLKIN / 2
  PLLE2_BASE #(
    .BANDWIDTH          ("OPTIMIZED"),
    .CLKFBOUT_MULT      (15),         // VCO = CLKIN * 15 / 2
    .CLKFBOUT_PHASE     (0.0),
    .CLKIN1_PERIOD      (4.761),      // 210 MHz nominal (adjust for actual freq)
    .CLKOUT0_DIVIDE     (15),         // CLKOUT = VCO / 15 = CLKIN / 2
    .CLKOUT0_DUTY_CYCLE (0.5),
    .CLKOUT0_PHASE      (0.0),
    .DIVCLK_DIVIDE      (2),          // Divide input by 2 before multiplier
    .REF_JITTER1        (0.010),
    .STARTUP_WAIT       ("FALSE")
  ) i_ad9740_pll (
    .CLKFBOUT (ad9740_pll_fb),
    .CLKOUT0  (ad9740_clk_bufg),
    .CLKOUT1  (),
    .CLKOUT2  (),
    .CLKOUT3  (),
    .CLKOUT4  (),
    .CLKOUT5  (),
    .LOCKED   (ad9740_pll_locked),
    .CLKFBIN  (ad9740_pll_fb),
    .CLKIN1   (ad9740_clk_ds),
    .PWRDWN   (1'b0),
    .RST      (1'b0));

  BUFG i_ad9740_clk_bufg (
    .I (ad9740_clk_bufg),
    .O (ad9740_clk));

  // ODDR primitives for DAC data output (DDR on 105 MHz = 210 MSPS)
  genvar i;
  generate
    for (i = 0; i < 14; i = i + 1) begin : gen_oddr
      if (i >= ZERO_BITS) begin : gen_oddr_data
        ODDR #(
          .DDR_CLK_EDGE ("SAME_EDGE"),
          .INIT         (1'b0),
          .SRTYPE       ("ASYNC")
        ) i_oddr (
          .Q  (ad9740_data[i]),
          .C  (ad9740_clk),
          .CE (1'b1),
          .D1 (ad9740_data_d1[i]),
          .D2 (ad9740_data_d2[i]),
          .R  (1'b0),
          .S  (1'b0));
      end else begin : gen_oddr_zero
        ODDR #(
          .DDR_CLK_EDGE ("SAME_EDGE"),
          .INIT         (1'b0),
          .SRTYPE       ("ASYNC")
        ) i_oddr (
          .Q  (ad9740_data[i]),
          .C  (ad9740_clk),
          .CE (1'b1),
          .D1 (1'b0),
          .D2 (1'b0),
          .R  (1'b0),
          .S  (1'b0));
      end
    end
  endgenerate

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
    .ad9740_clk (ad9740_clk),
    .ad9740_data (ad9740_data_int[27:0]),
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
    .spi0_clk_o (adf4351_clk),
    .spi0_csn_0_o (adf4351_csn),
    .spi0_csn_1_o (),
    .spi0_csn_2_o (),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (1'b0),
    .spi0_sdo_i (1'b0),
    .spi0_sdo_o (adf4351_mosi),
    .spi1_clk_i (1'b0),
    .spi1_clk_o (),
    .spi1_csn_0_o (),
    .spi1_csn_1_o (),
    .spi1_csn_2_o (),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (1'b0),
    .spi1_sdo_i (1'b0),
    .spi1_sdo_o ());

endmodule
