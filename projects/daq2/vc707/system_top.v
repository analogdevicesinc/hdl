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

`timescale 1ns/100ps

module system_top (

  sys_rst,
  sys_clk_p,
  sys_clk_n,

  uart_sin,
  uart_sout,

  ddr3_reset_n,
  ddr3_addr,
  ddr3_ba,
  ddr3_cas_n,
  ddr3_ras_n,
  ddr3_we_n,
  ddr3_ck_n,
  ddr3_ck_p,
  ddr3_cke,
  ddr3_cs_n,
  ddr3_dm,
  ddr3_dq,
  ddr3_dqs_n,
  ddr3_dqs_p,
  ddr3_odt,

  sgmii_rxp,
  sgmii_rxn,
  sgmii_txp,
  sgmii_txn,

  phy_rstn,
  mgt_clk_p,
  mgt_clk_n,
  mdio_mdc,
  mdio_mdio,

  linear_flash_addr,
  linear_flash_adv_ldn,
  linear_flash_ce_n,
  linear_flash_dq_io,
  linear_flash_oen,
  linear_flash_wen,

  fan_pwm,

  gpio_lcd,
  gpio_bd,

  iic_rstn,
  iic_scl,
  iic_sda,

  rx_ref_clk_p,
  rx_ref_clk_n,
  rx_sysref_p,
  rx_sysref_n,
  rx_sync_p,
  rx_sync_n,
  rx_data_p,
  rx_data_n,

  tx_ref_clk_p,
  tx_ref_clk_n,
  tx_sysref_p,
  tx_sysref_n,
  tx_sync_p,
  tx_sync_n,
  tx_data_p,
  tx_data_n,

  trig_p,
  trig_n,

  adc_fdb,
  adc_fda,
  dac_irq,
  clkd_status,

  adc_pd,
  dac_txen,
  dac_reset,
  clkd_sync,

  spi_csn_clk,
  spi_csn_dac,
  spi_csn_adc,
  spi_clk,
  spi_sdio,
  spi_dir);

  input             sys_rst;
  input             sys_clk_p;
  input             sys_clk_n;

  input             uart_sin;
  output            uart_sout;

  output            ddr3_reset_n;
  output  [13:0]    ddr3_addr;
  output  [ 2:0]    ddr3_ba;
  output            ddr3_cas_n;
  output            ddr3_ras_n;
  output            ddr3_we_n;
  output  [ 0:0]    ddr3_ck_n;
  output  [ 0:0]    ddr3_ck_p;
  output  [ 0:0]    ddr3_cke;
  output  [ 0:0]    ddr3_cs_n;
  output  [ 7:0]    ddr3_dm;
  inout   [63:0]    ddr3_dq;
  inout   [ 7:0]    ddr3_dqs_n;
  inout   [ 7:0]    ddr3_dqs_p;
  output  [ 0:0]    ddr3_odt;

  input             sgmii_rxp;
  input             sgmii_rxn;
  output            sgmii_txp;
  output            sgmii_txn;

  output            phy_rstn;
  input             mgt_clk_p;
  input             mgt_clk_n;
  output            mdio_mdc;
  inout             mdio_mdio;

  output  [26:1]    linear_flash_addr;
  output            linear_flash_adv_ldn;
  output            linear_flash_ce_n;
  inout   [15:0]    linear_flash_dq_io;
  output            linear_flash_oen;
  output            linear_flash_wen;

  output            fan_pwm;

  inout   [ 6:0]    gpio_lcd;
  inout   [20:0]    gpio_bd;

  output            iic_rstn;
  inout             iic_scl;
  inout             iic_sda;

  input             rx_ref_clk_p;
  input             rx_ref_clk_n;
  input             rx_sysref_p;
  input             rx_sysref_n;
  output            rx_sync_p;
  output            rx_sync_n;
  input   [ 3:0]    rx_data_p;
  input   [ 3:0]    rx_data_n;

  input             tx_ref_clk_p;
  input             tx_ref_clk_n;
  input             tx_sysref_p;
  input             tx_sysref_n;
  input             tx_sync_p;
  input             tx_sync_n;
  output  [ 3:0]    tx_data_p;
  output  [ 3:0]    tx_data_n;

  input             trig_p;
  input             trig_n;

  inout             adc_fdb;
  inout             adc_fda;
  inout             dac_irq;
  inout   [ 1:0]    clkd_status;

  inout             adc_pd;
  inout             dac_txen;
  inout             dac_reset;
  inout             clkd_sync;

  output            spi_csn_clk;
  output            spi_csn_dac;
  output            spi_csn_adc;
  output            spi_clk;
  inout             spi_sdio;
  output            spi_dir;

  // internal signals

  wire    [63:0]    gpio_i;
  wire    [63:0]    gpio_o;
  wire    [63:0]    gpio_t;
  wire    [ 7:0]    spi_csn;
  wire              spi_mosi;
  wire              spi_miso;
  wire              trig;
  wire              rx_ref_clk;
  wire              rx_sysref;
  wire              rx_sync;
  wire              tx_ref_clk;
  wire              tx_sysref;
  wire              tx_sync;

  // spi

  assign spi_csn_adc = spi_csn[2];
  assign spi_csn_dac = spi_csn[1];
  assign spi_csn_clk = spi_csn[0];

  // default logic

  assign fan_pwm = 1'b1;
  assign iic_rstn = 1'b1;

  // instantiations

  IBUFDS_GTE2 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (rx_ref_clk_p),
    .IB (rx_ref_clk_n),
    .O (rx_ref_clk),
    .ODIV2 ());

  IBUFDS i_ibufds_rx_sysref (
    .I (rx_sysref_p),
    .IB (rx_sysref_n),
    .O (rx_sysref));

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  IBUFDS_GTE2 i_ibufds_tx_ref_clk (
    .CEB (1'd0),
    .I (tx_ref_clk_p),
    .IB (tx_ref_clk_n),
    .O (tx_ref_clk),
    .ODIV2 ());

  IBUFDS i_ibufds_tx_sysref (
    .I (tx_sysref_p),
    .IB (tx_sysref_n),
    .O (tx_sysref));

  IBUFDS i_ibufds_tx_sync (
    .I (tx_sync_p),
    .IB (tx_sync_n),
    .O (tx_sync));

  daq2_spi i_spi (
    .spi_csn (spi_csn[2:0]),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio),
    .spi_dir (spi_dir));

  IBUFDS i_ibufds_trig (
    .I (trig_p),
    .IB (trig_n),
    .O (trig));

  assign gpio_i[43] = trig;

  ad_iobuf #(.DATA_WIDTH(9)) i_iobuf (
    .dio_t ({gpio_t[42:40], gpio_t[38], gpio_t[36:32]}),
    .dio_i ({gpio_o[42:40], gpio_o[38], gpio_o[36:32]}),
    .dio_o ({gpio_i[42:40], gpio_i[38], gpio_i[36:32]}),
    .dio_p ({ adc_pd,           // 42
              dac_txen,         // 41
              dac_reset,        // 40
              clkd_sync,        // 38
              adc_fdb,          // 36
              adc_fda,          // 35
              dac_irq,          // 34
              clkd_status}));   // 32

  ad_iobuf #(.DATA_WIDTH(21)) i_iobuf_bd (
    .dio_t (gpio_t[20:0]),
    .dio_i (gpio_o[20:0]),
    .dio_o (gpio_i[20:0]),
    .dio_p (gpio_bd));

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
    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    .gpio_lcd_tri_io (gpio_lcd),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .linear_flash_addr (linear_flash_addr),
    .linear_flash_adv_ldn (linear_flash_adv_ldn),
    .linear_flash_ce_n (linear_flash_ce_n),
    .linear_flash_dq_io (linear_flash_dq_io),
    .linear_flash_oen (linear_flash_oen),
    .linear_flash_wen (linear_flash_wen),
    .mb_intr_06 (1'd0),
    .mb_intr_07 (1'd0),
    .mb_intr_08 (1'd0),
    .mb_intr_14 (1'd0),
    .mb_intr_15 (1'd0),
    .mdio_mdc (mdio_mdc),
    .mdio_mdio_io (mdio_mdio),
    .mgt_clk_clk_n (mgt_clk_n),
    .mgt_clk_clk_p (mgt_clk_p),
    .phy_rstn (phy_rstn),
    .phy_sd (1'b1),
    .rx_data_n (rx_data_n),
    .rx_data_p (rx_data_p),
    .rx_ref_clk (rx_ref_clk),
    .rx_sync (rx_sync),
    .rx_sysref (rx_sysref),
    .sgmii_rxn (sgmii_rxn),
    .sgmii_rxp (sgmii_rxp),
    .sgmii_txn (sgmii_txn),
    .sgmii_txp (sgmii_txp),
    .spi_clk_i (spi_clk),
    .spi_clk_o (spi_clk),
    .spi_csn_i (spi_csn),
    .spi_csn_o (spi_csn),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (spi_mosi),
    .spi_sdo_o (spi_mosi),
    .sys_clk_n (sys_clk_n),
    .sys_clk_p (sys_clk_p),
    .sys_rst (sys_rst),
    .tx_data_n (tx_data_n),
    .tx_data_p (tx_data_p),
    .tx_ref_clk (tx_ref_clk),
    .tx_sync (tx_sync),
    .tx_sysref (tx_sysref),
    .uart_sin (uart_sin),
    .uart_sout (uart_sout));

endmodule

// ***************************************************************************
// ***************************************************************************
