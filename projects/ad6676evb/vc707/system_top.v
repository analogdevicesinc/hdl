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

  adc_oen,
  adc_sela,
  adc_selb,
  adc_s0,
  adc_s1,
  adc_resetb,
  adc_agc1,
  adc_agc2,
  adc_agc3,
  adc_agc4,

  spi_csn,
  spi_clk,
  spi_mosi,
  spi_miso);

  input           sys_rst;
  input           sys_clk_p;
  input           sys_clk_n;

  input           uart_sin;
  output          uart_sout;

  output          ddr3_reset_n;
  output  [13:0]  ddr3_addr;
  output  [ 2:0]  ddr3_ba;
  output          ddr3_cas_n;
  output          ddr3_ras_n;
  output          ddr3_we_n;
  output  [ 0:0]  ddr3_ck_n;
  output  [ 0:0]  ddr3_ck_p;
  output  [ 0:0]  ddr3_cke;
  output  [ 0:0]  ddr3_cs_n;
  output  [ 7:0]  ddr3_dm;
  inout   [63:0]  ddr3_dq;
  inout   [ 7:0]  ddr3_dqs_n;
  inout   [ 7:0]  ddr3_dqs_p;
  output  [ 0:0]  ddr3_odt;

  input           sgmii_rxp;
  input           sgmii_rxn;
  output          sgmii_txp;
  output          sgmii_txn;

  output          phy_rstn;
  input           mgt_clk_p;
  input           mgt_clk_n;
  output          mdio_mdc;
  inout           mdio_mdio;

  output  [26:1]  linear_flash_addr;
  output          linear_flash_adv_ldn;
  output          linear_flash_ce_n;
  inout   [15:0]  linear_flash_dq_io;
  output          linear_flash_oen;
  output          linear_flash_wen;

  output          fan_pwm;

  inout   [ 6:0]  gpio_lcd;
  inout   [20:0]  gpio_bd;

  output          iic_rstn;
  inout           iic_scl;
  inout           iic_sda;

  input           rx_ref_clk_p;
  input           rx_ref_clk_n;
  output          rx_sysref_p;
  output          rx_sysref_n;
  output          rx_sync_p;
  output          rx_sync_n;
  input   [ 1:0]  rx_data_p;
  input   [ 1:0]  rx_data_n;

  inout           adc_oen;
  inout           adc_sela;
  inout           adc_selb;
  inout           adc_s0;
  inout           adc_s1;
  inout           adc_resetb;
  inout           adc_agc1;
  inout           adc_agc2;
  inout           adc_agc3;
  inout           adc_agc4;

  output          spi_csn;
  output          spi_clk;
  output          spi_mosi;
  input           spi_miso;

  // internal registers

  reg             adc_dwr = 'd0;
  reg     [63:0]  adc_ddata = 'd0;

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire    [ 6:0]  spi_csn_open;
  wire            spi_mosi;
  wire            spi_miso;
  wire            rx_ref_clk;
  wire            rx_sysref;
  wire            rx_sync;
  wire            adc_clk;
  wire            adc_enable_a;
  wire    [31:0]  adc_data_a;
  wire            adc_enable_b;
  wire    [31:0]  adc_data_b;

  // pack & unpack here

  always @(posedge adc_clk) begin
    case ({adc_enable_b, adc_enable_a})
      2'b11: begin
        adc_dwr <= 1'b1;
        adc_ddata[63:48] <= adc_data_b[31:16];
        adc_ddata[47:32] <= adc_data_a[31:16];
        adc_ddata[31:16] <= adc_data_b[15: 0];
        adc_ddata[15: 0] <= adc_data_a[15: 0];
      end
      2'b10: begin
        adc_dwr <= ~adc_dwr;
        adc_ddata[63:48] <= adc_data_b[31:16];
        adc_ddata[47:32] <= adc_data_b[15: 0];
        adc_ddata[31:16] <= adc_ddata[63:48];
        adc_ddata[15: 0] <= adc_ddata[47:32];
      end
      2'b01: begin
        adc_dwr <= ~adc_dwr;
        adc_ddata[63:48] <= adc_data_a[31:16];
        adc_ddata[47:32] <= adc_data_a[15: 0];
        adc_ddata[31:16] <= adc_ddata[63:48];
        adc_ddata[15: 0] <= adc_ddata[47:32];
      end
      default: begin
        adc_dwr <= 1'b0;
        adc_ddata[63:48] <= 16'd0;
        adc_ddata[47:32] <= 16'd0;
        adc_ddata[31:16] <= 16'd0;
        adc_ddata[15: 0] <= 16'd0;
      end
    endcase
  end

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

  OBUFDS i_obufds_rx_sysref (
    .I (rx_sysref),
    .O (rx_sysref_p),
    .OB (rx_sysref_n));

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  ad_iobuf #(.DATA_WIDTH(10)) i_iobuf (
    .dio_t (gpio_t[41:32]),
    .dio_i (gpio_o[41:32]),
    .dio_o (gpio_i[41:32]),
    .dio_p ({ adc_oen,
              adc_sela,
              adc_selb,
              adc_s0,
              adc_s1,
              adc_resetb,
              adc_agc1,
              adc_agc2,
              adc_agc3,
              adc_agc4}));

  ad_iobuf #(.DATA_WIDTH(15)) i_iobuf_bd (
    .dio_t (gpio_t[14:0]),
    .dio_i (gpio_o[14:0]),
    .dio_o (gpio_i[14:0]),
    .dio_p (gpio_bd));

  system_wrapper i_system_wrapper (
    .adc_clk (adc_clk),
    .adc_data_a (adc_data_a),
    .adc_data_b (adc_data_b),
    .adc_ddata (adc_ddata),
    .adc_dsync (1'b1),
    .adc_dwr (adc_dwr),
    .adc_enable_a (adc_enable_a),
    .adc_enable_b (adc_enable_b),
    .adc_valid_a (),
    .adc_valid_b (),
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
    .mb_intr_06 (1'b0),
    .mb_intr_07 (1'b0),
    .mb_intr_08 (1'b0),
    .mb_intr_12 (1'b0),
    .mb_intr_14 (1'b0),
    .mb_intr_15 (1'b0),
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
    .spi_csn_i ({spi_csn_open, spi_csn}),
    .spi_csn_o ({spi_csn_open, spi_csn}),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (spi_mosi),
    .spi_sdo_o (spi_mosi),
    .sys_clk_n (sys_clk_n),
    .sys_clk_p (sys_clk_p),
    .sys_rst (sys_rst),
    .uart_sin (uart_sin),
    .uart_sout (uart_sout));

endmodule

// ***************************************************************************
// ***************************************************************************
