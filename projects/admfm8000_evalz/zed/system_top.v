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

  inout       [31:0]      gpio_bd,

  output                  hdmi_out_clk,
  output                  hdmi_vsync,
  output                  hdmi_hsync,
  output                  hdmi_data_e,
  output      [15:0]      hdmi_data,

  output                  i2s_mclk,
  output                  i2s_bclk,
  output                  i2s_lrclk,
  output                  i2s_sdata_out,
  input                   i2s_sdata_in,

  output                  spdif,

  inout                   iic_scl,
  inout                   iic_sda,
  inout       [ 1:0]      iic_mux_scl,
  inout       [ 1:0]      iic_mux_sda,

  output                  spi_clk,
  output                  spi_mosi,
  input                   spi_miso,
  output                  dds_csb,
  output                  pll_le,
  inout                   pll_ce,
  output                  att_le,

  input                   dds_pdclk,
  output      [15:0]      dds_d,
  output      [ 1:0]      dds_f,
  output                  dds_txenable,

  input                   dds_sync_clk,
  output                  dds_main_reset,
  output                  dds_drctrl,
  output                  dds_drhold,
  input                   dds_drover,
  output                  dds_ext_pwr_dwn,
  output                  dds_io_reset,
  output                  dds_io_update,
  output                  dds_osk,
  output                  dds_profile0,
  output                  dds_profile1,
  output                  dds_profile2,
  input                   dds_ram_swp_ovr,

  input                   otg_vbusoc,

  // LVDS data interace

  // ADC A

  input           adca_dco_p,
  input           adca_dco_n,

  input           adca_da_p,
  input           adca_da_n,

  // ADC B

  input           adcb_dco_p,
  input           adcb_dco_n,

  input           adcb_da_p,
  input           adcb_da_n,

  // GPIOs

  output          adca_gp0_dir,
  output          adca_gp1_dir,
  output          adca_gpio1_fmc,

  output          adcb_gpio1_fmc,

  input           pwrgd,
  output          en_psu,
  output          pd_v33b,
  output          en_ifvga,
  output          ad9508_sync,

  // ADC SPI

  input           adca_ad4080_miso,
  output          adca_ad4080_sclk,
  output          adca_ad4080_csn,
  output          adca_ad4080_mosi,

  input           adcb_ad4080_miso,
  output          adcb_ad4080_sclk,
  output          adcb_ad4080_csn,
  output          adcb_ad4080_mosi,

  // Clock SPI

  input           ad9508_adf4350_miso,
  output          ad9508_adf4350_sclk,
  output          ad9508_adf4350_mosi,
  output          ad9508_csn,
  output          syncb
);

  // internal registers

  reg io_update_m1 = 'd0;
  reg osk_m1 = 'd0;
  reg io_update_m2 = 'd0;
  reg osk_m2 = 'd0;

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire    [ 1:0]  iic_mux_scl_i_s;
  wire    [ 1:0]  iic_mux_scl_o_s;
  wire            iic_mux_scl_t_s;
  wire    [ 1:0]  iic_mux_sda_i_s;
  wire    [ 1:0]  iic_mux_sda_o_s;
  wire            iic_mux_sda_t_s;
  wire            sync_clk;
  wire    [ 2:0]  dds_profile;

  wire            adca_filter_data_ready_n;
  wire            adcb_filter_data_ready_n;

  wire    [ 1:0]  ad4080_a_spi_csn_s;
  wire            adc_spi_miso_s;

  // instantiations

  assign adca_gp0_dir = 1'b0;
  assign adca_gp1_dir = 1'b0;

  assign adca_filter_data_ready_n  = 1'b0;
  assign adcb_filter_data_ready_n  = 1'b0;

  // single SPI master (ad4080_a_spi) shared by both AD4080 ADCs:
  // one chip-select per device, shared SCLK/MOSI, MISO muxed by active CSN
  assign adca_ad4080_csn  = ad4080_a_spi_csn_s[0];
  assign adcb_ad4080_csn  = ad4080_a_spi_csn_s[1];

  assign adcb_ad4080_sclk = adca_ad4080_sclk;
  assign adcb_ad4080_mosi = adca_ad4080_mosi;

  // MISO from both devices onto the shared SPI MISO line (both selected is illegal)
  assign adc_spi_miso_s = adca_ad4080_csn ? adcb_ad4080_miso :
                          adcb_ad4080_csn ? adca_ad4080_miso :
                          1'b0;

  assign adcb_gpio1_fmc = gpio_o[42];
  assign adca_gpio1_fmc = gpio_o[43];

  assign en_psu         = 1'b1;
  assign en_ifvga       = pwrgd;
  assign pd_v33b        = 1'b1;
  assign ad9508_sync    = ~gpio_o[41];

  assign dds_io_reset   = gpio_o[36];
  assign dds_main_reset = gpio_o[37];
  assign dds_ext_pwr_dwn = gpio_o[38];
  assign dds_io_update  = io_update_m2;
  assign dds_osk        = osk_m2;

  always @(posedge sync_clk) begin
    io_update_m1 <= gpio_o[39];
    osk_m1 <= gpio_o[40];

    io_update_m2 <= io_update_m1;
    osk_m2 <= osk_m1;
  end

  assign gpio_i[40:36] = gpio_o[40:36];
  assign gpio_i[43:41] = gpio_o[43:41];
  assign gpio_i[44] = pwrgd;
  assign gpio_i[63:45] = gpio_o[63:45];

  IBUFG i_sync_clk (
    .I (dds_sync_clk),
    .O (sync_clk));

  assign dds_profile0 = dds_profile[0];
  assign dds_profile1 = dds_profile[1];
  assign dds_profile2 = dds_profile[2];

  ad_iobuf #(
    .DATA_WIDTH(32)
  ) i_iobuf (
    .dio_t(gpio_t[31:0]),
    .dio_i(gpio_o[31:0]),
    .dio_o(gpio_i[31:0]),
    .dio_p(gpio_bd));

  assign gpio_i[35:33] = gpio_o[35:33];

  ad_iobuf #(
    .DATA_WIDTH(1)
  ) dds_iobuf (
    .dio_t(gpio_t[32]),
    .dio_i(gpio_o[32]),
    .dio_o(gpio_i[32]),
    .dio_p(pll_ce));          //32

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
    .otg_vbusoc (otg_vbusoc),
    .spdif (spdif),
    .spi0_clk_i (spi_clk),
    .spi0_clk_o (spi_clk),
    .spi0_csn_0_o (dds_csb),
    .spi0_csn_1_o (pll_le),
    .spi0_csn_2_o (att_le),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (spi_miso),
    .spi0_sdo_i (spi_mosi),
    .spi0_sdo_o (spi_mosi),
    .spi1_clk_i (1'b0),
    .spi1_clk_o (ad9508_adf4350_sclk),
    .spi1_csn_0_o (ad9508_csn),
    .spi1_csn_1_o (syncb),
    .spi1_csn_2_o (),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (ad9508_adf4350_miso),
    .spi1_sdo_i (1'b0),
    .spi1_sdo_o (ad9508_adf4350_mosi),

    .dds_sync_clk (sync_clk),
    .dds_drover (dds_drover),
    .dds_drctrl (dds_drctrl),
    .dds_drhold (dds_drhold),
    .dds_profile (dds_profile),
    .dds_ram_swp_ovr (dds_ram_swp_ovr),
    .dds_pdclk (dds_pdclk),
    .db_o (dds_d),
    .f_o (dds_f),
    .dds_txenable (dds_txenable),

    .adca_dco_p (adca_dco_p),
    .adca_dco_n (adca_dco_n),
    .adca_da_p (adca_da_p),
    .adca_da_n (adca_da_n),
    .adca_filter_data_ready_n(adca_filter_data_ready_n),
    .adca_sync_n (ad9508_sync),

    .adcb_dco_p (adcb_dco_p),
    .adcb_dco_n (adcb_dco_n),
    .adcb_da_p (adcb_da_p),
    .adcb_da_n (adcb_da_n),
    .adcb_filter_data_ready_n(adcb_filter_data_ready_n),
    .adcb_sync_n (ad9508_sync),

    .ad4080_a_spi_csn_o(ad4080_a_spi_csn_s),
    .ad4080_a_spi_csn_i(2'b11),
    .ad4080_a_spi_clk_i(1'b0),
    .ad4080_a_spi_clk_o(adca_ad4080_sclk),
    .ad4080_a_spi_sdo_i(1'b0),
    .ad4080_a_spi_sdo_o(adca_ad4080_mosi),
    .ad4080_a_spi_sdi_i(adc_spi_miso_s));

endmodule
