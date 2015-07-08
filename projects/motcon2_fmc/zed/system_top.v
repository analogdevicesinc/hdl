// ***************************************************************************
// ***************************************************************************
// Copyright 2015(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  ddr_addr,
  ddr_ba,
  ddr_cas_n,
  ddr_ck_n,
  ddr_ck_p,
  ddr_cke,
  ddr_cs_n,
  ddr_dm,
  ddr_dq,
  ddr_dqs_n,
  ddr_dqs_p,
  ddr_odt,
  ddr_ras_n,
  ddr_reset_n,
  ddr_we_n,

  eth1_rgmii_rd,
  eth1_rgmii_rx_ctl,
  eth1_rgmii_rxc,
  eth1_rgmii_td,
  eth1_rgmii_tx_ctl,
  eth1_rgmii_txc,

  eth2_rgmii_rd,
  eth2_rgmii_rx_ctl,
  eth2_rgmii_rxc,
  eth2_rgmii_td,
  eth2_rgmii_tx_ctl,
  eth2_rgmii_txc,

  eth_mdio_p,
  eth_mdio_mdc,
  eth_phy_rst_n,

  fixed_io_ddr_vrn,
  fixed_io_ddr_vrp,
  fixed_io_mio,
  fixed_io_ps_clk,
  fixed_io_ps_porb,
  fixed_io_ps_srstb,

  gpio_bd,

  hdmi_out_clk,
  hdmi_vsync,
  hdmi_hsync,
  hdmi_data_e,
  hdmi_data,

  position_m1_i,
  position_m2_i,
  adc_clk_o,
  adc_m1_ia_dat_i,
  adc_m1_ib_dat_i,
  adc_m1_vbus_dat_i,
  fmc_m1_en_o,
  fmc_m2_en_o,
  adc_m2_ia_dat_i,
  adc_m2_ib_dat_i,
  adc_m2_vbus_dat_i,
  pwm_m1_ah_o,
  pwm_m1_al_o,
  pwm_m1_bh_o,
  pwm_m1_bl_o,
  pwm_m1_ch_o,
  pwm_m1_cl_o,
  pwm_m1_dh_o,
  pwm_m1_dl_o,
  pwm_m2_ah_o,
  pwm_m2_al_o,
  pwm_m2_bh_o,
  pwm_m2_bl_o,
  pwm_m2_ch_o,
  pwm_m2_cl_o,
  pwm_m2_dh_o,
  pwm_m2_dl_o,
  vt_enable,
  vauxn0,
  vauxn8,
  vauxp0,
  vauxp8,
  muxaddr_out,

  i2s_mclk,
  i2s_bclk,
  i2s_lrclk,
  i2s_sdata_out,
  i2s_sdata_in,

  spdif,

  iic_scl,
  iic_sda,
  iic_mux_scl,
  iic_mux_sda,

  iic_ee2_scl_io,
  iic_ee2_sda_io,

  fmc_spi1_sel1_rdc,
  fmc_spi1_miso,
  fmc_spi1_mosi,
  fmc_spi1_sck,
  fmc_sample_n,
  gpo,

  otg_vbusoc);

  inout   [14:0]  ddr_addr;
  inout   [ 2:0]  ddr_ba;
  inout           ddr_cas_n;
  inout           ddr_ck_n;
  inout           ddr_ck_p;
  inout           ddr_cke;
  inout           ddr_cs_n;
  inout   [ 3:0]  ddr_dm;
  inout   [31:0]  ddr_dq;
  inout   [ 3:0]  ddr_dqs_n;
  inout   [ 3:0]  ddr_dqs_p;
  inout           ddr_odt;
  inout           ddr_ras_n;
  inout           ddr_reset_n;
  inout           ddr_we_n;

  input   [3:0]   eth1_rgmii_rd;
  input           eth1_rgmii_rx_ctl;
  input           eth1_rgmii_rxc;
  output  [3:0]   eth1_rgmii_td;
  output          eth1_rgmii_tx_ctl;
  output          eth1_rgmii_txc;

  input   [3:0]   eth2_rgmii_rd;
  input           eth2_rgmii_rx_ctl;
  input           eth2_rgmii_rxc;
  output  [3:0]   eth2_rgmii_td;
  output          eth2_rgmii_tx_ctl;
  output          eth2_rgmii_txc;

  inout           eth_mdio_p;
  output          eth_mdio_mdc;
  output          eth_phy_rst_n;

  inout           fixed_io_ddr_vrn;
  inout           fixed_io_ddr_vrp;
  inout   [53:0]  fixed_io_mio;
  inout           fixed_io_ps_clk;
  inout           fixed_io_ps_porb;
  inout           fixed_io_ps_srstb;

  inout   [31:0]  gpio_bd;

  output          hdmi_out_clk;
  output          hdmi_vsync;
  output          hdmi_hsync;
  output          hdmi_data_e;
  output  [15:0]  hdmi_data;

  input  [2:0]    position_m1_i;
  input  [2:0]    position_m2_i;
  output          adc_clk_o;
  output          fmc_m1_en_o;
  input           adc_m1_ia_dat_i;
  input           adc_m1_ib_dat_i;
  input           adc_m1_vbus_dat_i;
  output          fmc_m2_en_o;
  input           adc_m2_ia_dat_i;
  input           adc_m2_ib_dat_i;
  input           adc_m2_vbus_dat_i;
  output          pwm_m1_ah_o;
  output          pwm_m1_al_o;
  output          pwm_m1_bh_o;
  output          pwm_m1_bl_o;
  output          pwm_m1_ch_o;
  output          pwm_m1_cl_o;
  output          pwm_m1_dh_o;
  output          pwm_m1_dl_o;
  output          pwm_m2_ah_o;
  output          pwm_m2_al_o;
  output          pwm_m2_bh_o;
  output          pwm_m2_bl_o;
  output          pwm_m2_ch_o;
  output          pwm_m2_cl_o;
  output          pwm_m2_dh_o;
  output          pwm_m2_dl_o;

  output          vt_enable;

  input           vauxn0;
  input           vauxn8;
  input           vauxp0;
  input           vauxp8;
  output  [ 1:0]  muxaddr_out;

  output          spdif;

  output          i2s_mclk;
  output          i2s_bclk;
  output          i2s_lrclk;
  output          i2s_sdata_out;
  input           i2s_sdata_in;

  inout           iic_scl;
  inout           iic_sda;
  inout   [ 1:0]  iic_mux_scl;
  inout   [ 1:0]  iic_mux_sda;

  inout           iic_ee2_scl_io;
  inout           iic_ee2_sda_io;

  output          fmc_spi1_sel1_rdc;
  input           fmc_spi1_miso;
  output          fmc_spi1_mosi;
  output          fmc_spi1_sck;
  output          fmc_sample_n;
  output  [ 3:0]  gpo;

  input           otg_vbusoc;

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

  wire            eth_mdio_o;
  wire            eth_mdio_i;
  wire            eth_mdio_t;

  // assignments

  assign fmc_sample_n   = gpio_o[32];
  assign vt_enable      = 1'b1;
  assign pwm_m1_dh_o    = 1'b0;
  assign pwm_m1_dl_o    = 1'b0;
  assign pwm_m2_dh_o    = 1'b0;
  assign pwm_m2_dl_o    = 1'b0;
  // instantiations

  ad_iobuf #(
    .DATA_WIDTH(32))
  i_gpio_bd (
    .dio_t(gpio_t[31:0]),
    .dio_i(gpio_o[31:0]),
    .dio_o(gpio_i[31:0]),
    .dio_p(gpio_bd));

  ad_iobuf #(
    .DATA_WIDTH(2))
  i_iic_mux_scl (
    .dio_t({iic_mux_scl_t_s, iic_mux_scl_t_s}),
    .dio_i(iic_mux_scl_o_s),
    .dio_o(iic_mux_scl_i_s),
    .dio_p(iic_mux_scl));

  ad_iobuf #(
    .DATA_WIDTH(2))
  i_iic_mux_sda (
    .dio_t({iic_mux_sda_t_s, iic_mux_sda_t_s}),
    .dio_i(iic_mux_sda_o_s),
    .dio_o(iic_mux_sda_i_s),
    .dio_p(iic_mux_sda));

  ad_iobuf #(
    .DATA_WIDTH(1))
    i_mdio_p (
      .dio_t(eth_mdio_t),
      .dio_i(eth_mdio_o),
      .dio_o(eth_mdio_i),
      .dio_p(eth_mdio_p));

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

    .eth1_rgmii_rd(eth1_rgmii_rd),
    .eth1_rgmii_rx_ctl(eth1_rgmii_rx_ctl),
    .eth1_rgmii_rxc(eth1_rgmii_rxc),
    .eth1_rgmii_td(eth1_rgmii_td),
    .eth1_rgmii_tx_ctl(eth1_rgmii_tx_ctl),
    .eth1_rgmii_txc(eth1_rgmii_txc),

    .eth2_rgmii_rd(eth2_rgmii_rd),
    .eth2_rgmii_rx_ctl(eth2_rgmii_rx_ctl),
    .eth2_rgmii_rxc(eth2_rgmii_rxc),
    .eth2_rgmii_td(eth2_rgmii_td),
    .eth2_rgmii_tx_ctl(eth2_rgmii_tx_ctl),
    .eth2_rgmii_txc(eth2_rgmii_txc),

    .eth_phy_rst_n(eth_phy_rst_n),
    .eth_mdio_o(eth_mdio_o),
    .eth_mdio_t(eth_mdio_t),
    .eth_mdio_i(eth_mdio_i),
    .eth_mdio_mdc(eth_mdio_mdc),

    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .position_m1_i(position_m1_i),
    .position_m2_i(position_m2_i),
    .adc_clk_o(adc_clk_o),
    .fmc_m1_en_o(fmc_m1_en_o),
    .adc_m1_ia_dat_i(adc_m1_ia_dat_i),
    .adc_m1_ib_dat_i(adc_m1_ib_dat_i),
    .adc_m1_vbus_dat_i(adc_m1_vbus_dat_i),
    .fmc_m2_en_o(fmc_m2_en_o),
    .adc_m2_ia_dat_i(adc_m2_ia_dat_i),
    .adc_m2_ib_dat_i(adc_m2_ib_dat_i),
    .adc_m2_vbus_dat_i(adc_m2_vbus_dat_i),
    .gpo_o(gpo),
    .pwm_m1_ah_o(pwm_m1_ah_o),
    .pwm_m1_al_o(pwm_m1_al_o),
    .pwm_m1_bh_o(pwm_m1_bh_o),
    .pwm_m1_bl_o(pwm_m1_bl_o),
    .pwm_m1_ch_o(pwm_m1_ch_o),
    .pwm_m1_cl_o(pwm_m1_cl_o),
    .pwm_m2_ah_o(pwm_m2_ah_o),
    .pwm_m2_al_o(pwm_m2_al_o),
    .pwm_m2_bh_o(pwm_m2_bh_o),
    .pwm_m2_bl_o(pwm_m2_bl_o),
    .pwm_m2_ch_o(pwm_m2_ch_o),
    .pwm_m2_cl_o(pwm_m2_cl_o),
    .vaux0_v_n(vauxn0),
    .vaux0_v_p(vauxp0),
    .vaux8_v_n(vauxn8),
    .vaux8_v_p(vauxp8),
    .muxaddr_out(muxaddr_out),
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
    .ps_intr_00 (1'b0),
    .ps_intr_01 (1'b0),
    .ps_intr_02 (1'b0),
    .ps_intr_03 (1'b0),
    .ps_intr_04 (1'b0),
    .iic_ee2_scl_io(iic_ee2_scl_io),
    .iic_ee2_sda_io(iic_ee2_sda_io),
    .spi0_clk_i (1'b0),
    .spi0_clk_o (fmc_spi1_sck),
    .spi0_csn_0_o (fmc_spi1_sel1_rdc),
    .spi0_csn_1_o (),
    .spi0_csn_2_o (),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (fmc_spi1_miso),
    .spi0_sdo_i (1'b0),
    .spi0_sdo_o (fmc_spi1_mosi),
    .spi1_clk_i (1'b0),
    .spi1_clk_o (),
    .spi1_csn_0_o (),
    .spi1_csn_1_o (),
    .spi1_csn_2_o (),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (1'b0),
    .spi1_sdo_i (1'b0),
    .spi1_sdo_o (),
    .otg_vbusoc (otg_vbusoc),
    .spdif (spdif));

endmodule

// ***************************************************************************
// ***************************************************************************
