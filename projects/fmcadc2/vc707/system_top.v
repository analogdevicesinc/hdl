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

  ddr3_addr,
  ddr3_ba,
  ddr3_cas_n,
  ddr3_ck_n,
  ddr3_ck_p,
  ddr3_cke,
  ddr3_cs_n,
  ddr3_dm,
  ddr3_dq,
  ddr3_dqs_n,
  ddr3_dqs_p,
  ddr3_odt,
  ddr3_ras_n,
  ddr3_reset_n,
  ddr3_we_n,

  sgmii_rxp,
  sgmii_rxn,
  sgmii_txp,
  sgmii_txn,

  phy_rstn,
  mgt_clk_p,
  mgt_clk_n,
  mdio_mdc,
  mdio_mdio,

  fan_pwm,

  linear_flash_addr,
  linear_flash_adv_ldn,
  linear_flash_ce_n,
  linear_flash_oen,
  linear_flash_wen,
  linear_flash_dq_io,

  gpio_lcd,
  gpio_led,
  gpio_sw,

  iic_rstn,
  iic_scl,
  iic_sda,

  hdmi_out_clk,
  hdmi_hsync,
  hdmi_vsync,
  hdmi_data_e,
  hdmi_data,

  spdif,

  rx_ref_clk_p,
  rx_ref_clk_n,
  rx_sysref_p,
  rx_sysref_n,
  rx_sync_p,
  rx_sync_n,
  rx_data_p,
  rx_data_n,

  adc_irq,
  adc_fd,
  clk_reset,

  spi_adc_csn,
  spi_adc_clk,
  spi_adc_sdio,
  spi_clk_csn,
  spi_clk_clk,
  spi_clk_sdio);

  input           sys_rst;
  input           sys_clk_p;
  input           sys_clk_n;

  input           uart_sin;
  output          uart_sout;

  output  [13:0]  ddr3_addr;
  output  [ 2:0]  ddr3_ba;
  output          ddr3_cas_n;
  output  [ 0:0]  ddr3_ck_n;
  output  [ 0:0]  ddr3_ck_p;
  output  [ 0:0]  ddr3_cke;
  output  [ 0:0]  ddr3_cs_n;
  output  [ 7:0]  ddr3_dm;
  inout   [63:0]  ddr3_dq;
  inout   [ 7:0]  ddr3_dqs_n;
  inout   [ 7:0]  ddr3_dqs_p;
  output  [ 0:0]  ddr3_odt;
  output          ddr3_ras_n;
  output          ddr3_reset_n;
  output          ddr3_we_n;

  input           sgmii_rxp;
  input           sgmii_rxn;
  output          sgmii_txp;
  output          sgmii_txn;

  output          phy_rstn;
  input           mgt_clk_p;
  input           mgt_clk_n;
  output          mdio_mdc;
  inout           mdio_mdio;

  output          fan_pwm;

  output  [26:1]    linear_flash_addr;
  output            linear_flash_adv_ldn;
  output            linear_flash_ce_n;
  output            linear_flash_oen;
  output            linear_flash_wen;
  inout   [15:0]    linear_flash_dq_io;

  output  [ 6:0]  gpio_lcd;
  output  [ 7:0]  gpio_led;
  input   [12:0]  gpio_sw;

  output          iic_rstn;
  inout           iic_scl;
  inout           iic_sda;

  output          hdmi_out_clk;
  output          hdmi_hsync;
  output          hdmi_vsync;
  output          hdmi_data_e;
  output  [35:0]  hdmi_data;

  output          spdif;

  input           rx_ref_clk_p;
  input           rx_ref_clk_n;
  output          rx_sysref_p;
  output          rx_sysref_n;
  output          rx_sync_p;
  output          rx_sync_n;
  input   [ 7:0]  rx_data_p;
  input   [ 7:0]  rx_data_n;

  inout           adc_irq;
  inout           adc_fd;
  inout           clk_reset;

  output          spi_adc_csn;
  output          spi_adc_clk;
  inout           spi_adc_sdio;
  output          spi_clk_csn;
  output          spi_clk_clk;
  inout           spi_clk_sdio;

  // internal signals

  wire    [ 2:0]  gpio_i;
  wire    [ 2:0]  gpio_o;
  wire    [ 2:0]  gpio_t;
  wire            rx_ref_clk;
  wire            rx_sysref;
  wire            rx_sync;
  wire            spi_clk;
  wire            spi_miso;
  wire            spi_mosi;
  wire    [31:0]  mb_intrs;

  // instantiations

  IBUFDS_GTE2 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (rx_ref_clk_p),
    .IB (rx_ref_clk_n),
    .O (rx_ref_clk),
    .ODIV2 ());

  OBUFDS i_obufds_rx_sysref (
    .I (rx_sysref),
    .O (rx_sysref_p),
    .OB (rx_sysref_n));

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  ad_iobuf #(.DATA_WIDTH(3)) i_iobuf (
    .dt (gpio_t),
    .di (gpio_o),
    .do (gpio_i),
    .dio ({ clk_reset,  //  2
            adc_irq,    //  1
            adc_fd}));  //  0

  assign spi_adc_clk = spi_clk;
  assign spi_clk_clk = spi_clk;

  fmcadc2_spi i_fmcadc2_spi (
    .spi_adc_csn (spi_adc_csn),
    .spi_clk_csn (spi_clk_csn),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_adc_sdio (spi_adc_sdio),
    .spi_clk_sdio (spi_clk_sdio));

  assign fan_pwm = 1'b1;

  system_wrapper i_system_wrapper (
    .ddr3_addr (ddr3_addr),
    .ddr3_ba (ddr3_ba),
    .ddr3_cas_n (ddr3_cas_n),
    .ddr3_ck_n (ddr3_ck_n),
    .ddr3_ck_p (ddr3_ck_p),
    .ddr3_cke (ddr3_cke),
    .ddr3_cs_n (ddr3_cs_n),
    .ddr3_dm (ddr3_dm),
    .ddr3_dq (ddr3_dq),
    .ddr3_dqs_n (ddr3_dqs_n),
    .ddr3_dqs_p (ddr3_dqs_p),
    .ddr3_odt (ddr3_odt),
    .ddr3_ras_n (ddr3_ras_n),
    .ddr3_reset_n (ddr3_reset_n),
    .ddr3_we_n (ddr3_we_n),
    .linear_flash_addr (linear_flash_addr),
    .linear_flash_adv_ldn (linear_flash_adv_ldn),
    .linear_flash_ce_n (linear_flash_ce_n),
    .linear_flash_oen (linear_flash_oen),
    .linear_flash_wen (linear_flash_wen),
    .linear_flash_dq_io(linear_flash_dq_io),
    .gpio_lcd_tri_o (gpio_lcd),
    .gpio_led_tri_o (gpio_led),
    .gpio_sw_tri_i (gpio_sw),
    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .iic_rstn (iic_rstn),
    .mb_intr_11 (mb_intrs[11]),
    .mb_intr_12 (mb_intrs[12]),
    .mb_intr_15 (mb_intrs[15]),
    .mb_intr_16 (mb_intrs[16]),
    .mb_intr_17 (mb_intrs[17]),
    .mb_intr_18 (mb_intrs[18]),
    .mb_intr_19 (mb_intrs[19]),
    .mb_intr_20 (mb_intrs[20]),
    .mb_intr_21 (mb_intrs[21]),
    .mb_intr_22 (mb_intrs[22]),
    .mb_intr_23 (mb_intrs[23]),
    .mb_intr_24 (mb_intrs[24]),
    .mb_intr_25 (mb_intrs[25]),
    .mb_intr_26 (mb_intrs[26]),
    .mb_intr_27 (mb_intrs[27]),
    .mb_intr_28 (mb_intrs[28]),
    .mb_intr_29 (mb_intrs[29]),
    .mb_intr_30 (mb_intrs[30]),
    .mb_intr_31 (mb_intrs[31]),
    .mdio_mdc (mdio_mdc),
    .mdio_mdio_io (mdio_mdio),
    .mgt_clk_clk_n (mgt_clk_n),
    .mgt_clk_clk_p (mgt_clk_p),
    .phy_rstn (phy_rstn),
    .phy_sd (1'b1),
    .sgmii_rxn (sgmii_rxn),
    .sgmii_rxp (sgmii_rxp),
    .sgmii_txn (sgmii_txn),
    .sgmii_txp (sgmii_txp),
    .spdif (spdif),
    .sys_clk_n (sys_clk_n),
    .sys_clk_p (sys_clk_p),
    .sys_rst (sys_rst),
    .uart_sin (uart_sin),
    .uart_sout (uart_sout),
    .rx_data_n (rx_data_n),
    .rx_data_p (rx_data_p),
    .rx_ref_clk (rx_ref_clk),
    .rx_sync (rx_sync),
    .rx_sysref (rx_sysref),
    .gpio_ad9625_i (gpio_i),
    .gpio_ad9625_o (gpio_o),
    .gpio_ad9625_t (gpio_t),
    .spi_clk_i (1'b0),
    .spi_clk_o (spi_clk),
    .spi_csn_i (1'b1),
    .spi_csn_o ({spi_clk_csn, spi_adc_csn}),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (1'b0),
    .spi_sdo_o (spi_mosi));

endmodule

// ***************************************************************************
// ***************************************************************************
