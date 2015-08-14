// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
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

  sys_rst,
  sys_clk_p,
  sys_clk_n,

  uart_sin,
  uart_sout,

  ddr4_act_n,
  ddr4_addr,
  ddr4_ba,
  ddr4_bg,
  ddr4_ck_p,
  ddr4_ck_n,
  ddr4_cke,
  ddr4_cs_n,
  ddr4_dm_n,
  ddr4_dq,
  ddr4_dqs_p,
  ddr4_dqs_n,
  ddr4_odt,
  ddr4_reset_n,

  mdio_mdc,
  mdio_mdio,
  phy_clk_p,
  phy_clk_n,
  phy_rst_n,
  phy_rx_p,
  phy_rx_n,
  phy_tx_p,
  phy_tx_n,

  fan_pwm,

  gpio_bd,

  iic_scl,
  iic_sda,

  hdmi_out_clk,
  hdmi_hsync,
  hdmi_vsync,
  hdmi_data_e,
  hdmi_data,

  spdif);

  input           sys_rst;
  input           sys_clk_p;
  input           sys_clk_n;

  input           uart_sin;
  output          uart_sout;

  output          ddr4_act_n;
  output  [16:0]  ddr4_addr;
  output  [ 1:0]  ddr4_ba;
  output  [ 0:0]  ddr4_bg;
  output          ddr4_ck_p;
  output          ddr4_ck_n;
  output  [ 0:0]  ddr4_cke;
  output  [ 0:0]  ddr4_cs_n;
  inout   [ 7:0]  ddr4_dm_n;
  inout   [63:0]  ddr4_dq;
  inout   [ 7:0]  ddr4_dqs_p;
  inout   [ 7:0]  ddr4_dqs_n;
  output  [ 0:0]  ddr4_odt;
  output          ddr4_reset_n;

  output          mdio_mdc;
  inout           mdio_mdio;
  input           phy_clk_p;
  input           phy_clk_n;
  output          phy_rst_n;
  input           phy_rx_p;
  input           phy_rx_n;
  output          phy_tx_p;
  output          phy_tx_n;

  output          fan_pwm;

  inout   [16:0]  gpio_bd;

  inout           iic_scl;
  inout           iic_sda;

  output          hdmi_out_clk;
  output          hdmi_hsync;
  output          hdmi_vsync;
  output          hdmi_data_e;
  output  [15:0]  hdmi_data;

  output          spdif;

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;

  // default logic

  assign fan_pwm = 1'b1;

  // instantiations

  ad_iobuf #(.DATA_WIDTH(17)) i_iobuf_bd (
    .dio_t (gpio_t[16:0]),
    .dio_i (gpio_o[16:0]),
    .dio_o (gpio_i[16:0]),
    .dio_p (gpio_bd));

  system_wrapper i_system_wrapper (
    .c0_ddr4_act_n (ddr4_act_n),
    .c0_ddr4_adr (ddr4_addr),
    .c0_ddr4_ba (ddr4_ba),
    .c0_ddr4_bg (ddr4_bg),
    .c0_ddr4_ck_c (ddr4_ck_n),
    .c0_ddr4_ck_t (ddr4_ck_p),
    .c0_ddr4_cke (ddr4_cke),
    .c0_ddr4_cs_n (ddr4_cs_n),
    .c0_ddr4_dm_n (ddr4_dm_n),
    .c0_ddr4_dq (ddr4_dq),
    .c0_ddr4_dqs_c (ddr4_dqs_n),
    .c0_ddr4_dqs_t (ddr4_dqs_p),
    .c0_ddr4_odt (ddr4_odt),
    .c0_ddr4_reset_n (ddr4_reset_n),
    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    .hdmi_16_data (hdmi_data),
    .hdmi_16_data_e (hdmi_data_e),
    .hdmi_16_hsync (hdmi_hsync),
    .hdmi_16_vsync (hdmi_vsync),
    .hdmi_24_data (),
    .hdmi_24_data_e (),
    .hdmi_24_hsync (),
    .hdmi_24_vsync (),
    .hdmi_36_data (),
    .hdmi_36_data_e (),
    .hdmi_36_hsync (),
    .hdmi_36_vsync (),
    .hdmi_out_clk (hdmi_out_clk),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .mb_intr_05 (1'b0),
    .mb_intr_06 (1'b0),
    .mb_intr_12 (1'b0),
    .mb_intr_13 (1'b0),
    .mb_intr_14 (1'b0),
    .mb_intr_15 (1'b0),
    .mdio_mdc (mdio_mdc),
    .mdio_mdio_io (mdio_mdio),
    .phy_clk_clk_n (phy_clk_n),
    .phy_clk_clk_p (phy_clk_p),
    .phy_rst_n (phy_rst_n),
    .phy_sd (1'b1),
    .sgmii_rxn (phy_rx_n),
    .sgmii_rxp (phy_rx_p),
    .sgmii_txn (phy_tx_n),
    .sgmii_txp (phy_tx_p),
    .spdif (spdif),
    .sys_clk_clk_n (sys_clk_n),
    .sys_clk_clk_p (sys_clk_p),
    .sys_rst (sys_rst),
    .uart_sin (uart_sin),
    .uart_sout (uart_sout));

endmodule

// ***************************************************************************
// ***************************************************************************
