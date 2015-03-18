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

  DDR_addr,
  DDR_ba,
  DDR_cas_n,
  DDR_ck_n,
  DDR_ck_p,
  DDR_cke,
  DDR_cs_n,
  DDR_dm,
  DDR_dq,
  DDR_dqs_n,
  DDR_dqs_p,
  DDR_odt,
  DDR_ras_n,
  DDR_reset_n,
  DDR_we_n,

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

  eth_mdio_io,
  eth_mdio_mdc,
  eth_phy_rst_n,

  FIXED_IO_ddr_vrn,
  FIXED_IO_ddr_vrp,
  FIXED_IO_mio,
  FIXED_IO_ps_clk,
  FIXED_IO_ps_porb,
  FIXED_IO_ps_srstb,

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
/*  muxaddr_out,*/

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
  gpi,

  otg_vbusoc);

  inout   [14:0]  DDR_addr;
  inout   [ 2:0]  DDR_ba;
  inout           DDR_cas_n;
  inout           DDR_ck_n;
  inout           DDR_ck_p;
  inout           DDR_cke;
  inout           DDR_cs_n;
  inout   [ 3:0]  DDR_dm;
  inout   [31:0]  DDR_dq;
  inout   [ 3:0]  DDR_dqs_n;
  inout   [ 3:0]  DDR_dqs_p;
  inout           DDR_odt;
  inout           DDR_ras_n;
  inout           DDR_reset_n;
  inout           DDR_we_n;

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

  inout           eth_mdio_io;
  output          eth_mdio_mdc;
  output          eth_phy_rst_n;

  inout           FIXED_IO_ddr_vrn;
  inout           FIXED_IO_ddr_vrp;
  inout   [53:0]  FIXED_IO_mio;
  inout           FIXED_IO_ps_clk;
  inout           FIXED_IO_ps_porb;
  inout           FIXED_IO_ps_srstb;

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
/*  output  [ 3:0]  muxaddr_out;*/

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
  input   [ 1:0]  gpi;

  input           otg_vbusoc;

  // internal signals

  wire    [34:0]  gpio_i;
  wire    [34:0]  gpio_o;
  wire    [34:0]  gpio_t;
  wire    [ 1:0]  iic_mux_scl_i_s;
  wire    [ 1:0]  iic_mux_scl_o_s;
  wire            iic_mux_scl_t_s;
  wire    [ 1:0]  iic_mux_sda_i_s;
  wire    [ 1:0]  iic_mux_sda_o_s;
  wire            iic_mux_sda_t_s;
  wire    [15:0]  ps_intrs;

  wire            refclk;
  wire            refclk_rst;

  wire            eth_mdio_o;
  wire            eth_mdio_i;
  wire            eth_mdio_t;

  reg             idelayctrl_reset;
  reg [ 3:0]      idelay_reset_cnt;

  // assignments

  assign fmc_sample_n   = gpio_o[32];
  assign gpio_i[34:33]  = gpi[1:0];
  assign vt_enable      = 1'b1;
  assign pwm_m1_dh_o    = 1'b0;
  assign pwm_m1_dl_o    = 1'b0;
  assign pwm_m2_dh_o    = 1'b0;
  assign pwm_m2_dl_o    = 1'b0;
  // instantiations

  ad_iobuf #(
    .DATA_WIDTH(32))
  i_gpio_bd (
    .dt(gpio_t[31:0]),
    .di(gpio_o[31:0]),
    .do(gpio_i[31:0]),
    .dio(gpio_bd));

  ad_iobuf #(
    .DATA_WIDTH(2))
  i_iic_mux_scl (
    .dt({iic_mux_scl_t_s, iic_mux_scl_t_s}),
    .di(iic_mux_scl_o_s),
    .do(iic_mux_scl_i_s),
    .dio(iic_mux_scl));

  ad_iobuf #(
    .DATA_WIDTH(2))
  i_iic_mux_sda (
    .dt({iic_mux_sda_t_s, iic_mux_sda_t_s}),
    .di(iic_mux_sda_o_s),
    .do(iic_mux_sda_i_s),
    .dio(iic_mux_sda));

  ad_iobuf #(
    .DATA_WIDTH(1))
    i_mdio_io (
      .dt(eth_mdio_t),
      .di(eth_mdio_o),
      .do(eth_mdio_i),
      .dio(eth_mdio_io));

    always @(posedge refclk) begin
      if (refclk_rst == 1'b1) begin
        idelay_reset_cnt <= 4'h0;
        idelayctrl_reset <= 1'b1;
      end else begin
        idelayctrl_reset <= 1'b1;
        case (idelay_reset_cnt)
          4'h0: idelay_reset_cnt <= 4'h1;
          4'h1: idelay_reset_cnt <= 4'h2;
          4'h2: idelay_reset_cnt <= 4'h3;
          4'h3: idelay_reset_cnt <= 4'h4;
          4'h4: idelay_reset_cnt <= 4'h5;
          4'h5: idelay_reset_cnt <= 4'h6;
          4'h6: idelay_reset_cnt <= 4'h7;
          4'h7: idelay_reset_cnt <= 4'h8;
          4'h8: idelay_reset_cnt <= 4'h9;
          4'h9: idelay_reset_cnt <= 4'ha;
          4'ha: idelay_reset_cnt <= 4'hb;
          4'hb: idelay_reset_cnt <= 4'hc;
          4'hc: idelay_reset_cnt <= 4'hd;
          4'hd: idelay_reset_cnt <= 4'he;
          default: begin
            idelay_reset_cnt <= 4'he;
            idelayctrl_reset <= 1'b0;
          end
        endcase
      end
    end

    IDELAYCTRL dlyctrl (
      .RDY(),
      .REFCLK(refclk),
      .RST(idelayctrl_reset));

  system_wrapper i_system_wrapper (
    .DDR_addr (DDR_addr),
    .DDR_ba (DDR_ba),
    .DDR_cas_n (DDR_cas_n),
    .DDR_ck_n (DDR_ck_n),
    .DDR_ck_p (DDR_ck_p),
    .DDR_cke (DDR_cke),
    .DDR_cs_n (DDR_cs_n),
    .DDR_dm (DDR_dm),
    .DDR_dq (DDR_dq),
    .DDR_dqs_n (DDR_dqs_n),
    .DDR_dqs_p (DDR_dqs_p),
    .DDR_odt (DDR_odt),
    .DDR_ras_n (DDR_ras_n),
    .DDR_reset_n (DDR_reset_n),
    .DDR_we_n (DDR_we_n),
    .FIXED_IO_ddr_vrn (FIXED_IO_ddr_vrn),
    .FIXED_IO_ddr_vrp (FIXED_IO_ddr_vrp),
    .FIXED_IO_mio (FIXED_IO_mio),
    .FIXED_IO_ps_clk (FIXED_IO_ps_clk),
    .FIXED_IO_ps_porb (FIXED_IO_ps_porb),
    .FIXED_IO_ps_srstb (FIXED_IO_ps_srstb),
    .GPIO_I (gpio_i),
    .GPIO_O (gpio_o),
    .GPIO_T (gpio_t),

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
    .Vaux0_v_n(vauxn0),
    .Vaux0_v_p(vauxp0),
    .Vaux8_v_n(vauxn8),
    .Vaux8_v_p(vauxp8),
    /*.muxaddr_out(muxaddr_out),*/
    .i2s_bclk (i2s_bclk),
    .i2s_lrclk (i2s_lrclk),
    .i2s_mclk (i2s_mclk),
    .i2s_sdata_in (i2s_sdata_in),
    .i2s_sdata_out (i2s_sdata_out),
    .iic_fmc_scl_io (iic_scl),
    .iic_fmc_sda_io (iic_sda),
    .iic_mux_scl_I (iic_mux_scl_i_s),
    .iic_mux_scl_O (iic_mux_scl_o_s),
    .iic_mux_scl_T (iic_mux_scl_t_s),
    .iic_mux_sda_I (iic_mux_sda_i_s),
    .iic_mux_sda_O (iic_mux_sda_o_s),
    .iic_mux_sda_T (iic_mux_sda_t_s),
    .ps_intr_0 (ps_intrs[0]),
    .ps_intr_1 (ps_intrs[1]),
    .ps_intr_2 (ps_intrs[2]),
    .ps_intr_3 (ps_intrs[3]),
    .ps_intr_4 (ps_intrs[4]),
    .ps_intr_5 (ps_intrs[5]),
    .iic_ee2_scl_io(iic_ee2_scl_io),
    .iic_ee2_sda_io(iic_ee2_sda_io),
    .spi_csn_i (1'b1),
    .spi_csn_o (fmc_spi1_sel1_rdc),
    .spi_miso_i (fmc_spi1_miso),
    .spi_mosi_i (1'b0),
    .spi_mosi_o (fmc_spi1_mosi),
    .spi_sclk_i (1'b0),
    .spi_sclk_o (fmc_spi1_sck),
    .refclk(refclk),
    .refclk_rst(refclk_rst),
    .otg_vbusoc (otg_vbusoc),
    .spdif (spdif));

endmodule

// ***************************************************************************
// ***************************************************************************
