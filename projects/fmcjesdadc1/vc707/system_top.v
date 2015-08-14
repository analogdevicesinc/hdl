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
  gpio_bd,

  iic_rstn,
  iic_scl,
  iic_sda,

  rx_ref_clk_p,
  rx_ref_clk_n,
  rx_sysref,
  rx_sync,
  rx_data_p,
  rx_data_n,

  spi_csn_0,
  spi_clk,
  spi_sdio);

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

  output  [26:1]  linear_flash_addr;
  output          linear_flash_adv_ldn;
  output          linear_flash_ce_n;
  output          linear_flash_oen;
  output          linear_flash_wen;
  inout   [15:0]  linear_flash_dq_io;

  inout  [ 6:0]   gpio_lcd;
  inout   [20:0]  gpio_bd;

  output          iic_rstn;
  inout           iic_scl;
  inout           iic_sda;

  input           rx_ref_clk_p;
  input           rx_ref_clk_n;
  output          rx_sysref;
  output          rx_sync;
  input   [ 3:0]  rx_data_p;
  input   [ 3:0]  rx_data_n;

  output          spi_csn_0;
  output          spi_clk;
  inout           spi_sdio;

  // internal registers

  reg             dma_0_wr = 'd0;
  reg    [63:0]   dma_0_data = 'd0;
  reg             dma_1_wr = 'd0;
  reg    [63:0]   dma_1_data = 'd0;

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire    [ 7:0]  spi_csn;
  wire            spi_clk;
  wire            spi_mosi;
  wire            spi_miso;
  wire            rx_ref_clk;
  wire            adc_clk;
  wire   [127:0]  rx_gt_data;
  wire            adc_0_enable_a;
  wire    [31:0]  adc_0_data_a;
  wire            adc_0_enable_b;
  wire    [31:0]  adc_0_data_b;
  wire            adc_1_enable_a;
  wire    [31:0]  adc_1_data_a;
  wire            adc_1_enable_b;
  wire    [31:0]  adc_1_data_b;
  wire    [31:0]  mb_intrs;

  assign ddr3_1_p = 2'b11;
  assign ddr3_1_n = 3'b000;
  assign iic_rstn = 1'b1;
  assign fan_pwm = 1'b1;
  assign spi_csn_0 = spi_csn[0];

  // pack & unpack here

  always @(posedge adc_clk) begin
    case ({adc_0_enable_b, adc_0_enable_a})
      2'b11: begin
        dma_0_wr <= 1'b1;
        dma_0_data[63:48] <= adc_0_data_b[31:16];
        dma_0_data[47:32] <= adc_0_data_a[31:16];
        dma_0_data[31:16] <= adc_0_data_b[15: 0];
        dma_0_data[15: 0] <= adc_0_data_a[15: 0];
      end
      2'b10: begin
        dma_0_wr <= ~dma_0_wr;
        dma_0_data[63:48] <= adc_0_data_b[31:16];
        dma_0_data[47:32] <= adc_0_data_b[15: 0];
        dma_0_data[31:16] <= dma_0_data[63:48];
        dma_0_data[15: 0] <= dma_0_data[47:32];
      end
      2'b01: begin
        dma_0_wr <= ~dma_0_wr;
        dma_0_data[63:48] <= adc_0_data_a[31:16];
        dma_0_data[47:32] <= adc_0_data_a[15: 0];
        dma_0_data[31:16] <= dma_0_data[63:48];
        dma_0_data[15: 0] <= dma_0_data[47:32];
      end
      default: begin
        dma_0_wr <= 1'b0;
        dma_0_data[63:48] <= 16'd0;
        dma_0_data[47:32] <= 16'd0;
        dma_0_data[31:16] <= 16'd0;
        dma_0_data[15: 0] <= 16'd0;
      end
    endcase
  end

  always @(posedge adc_clk) begin
    case ({adc_1_enable_b, adc_1_enable_a})
      2'b11: begin
        dma_1_wr <= 1'b1;
        dma_1_data[63:48] <= adc_1_data_b[31:16];
        dma_1_data[47:32] <= adc_1_data_a[31:16];
        dma_1_data[31:16] <= adc_1_data_b[15: 0];
        dma_1_data[15: 0] <= adc_1_data_a[15: 0];
      end
      2'b10: begin
        dma_1_wr <= ~dma_1_wr;
        dma_1_data[63:48] <= adc_1_data_b[31:16];
        dma_1_data[47:32] <= adc_1_data_b[15: 0];
        dma_1_data[31:16] <= dma_1_data[63:48];
        dma_1_data[15: 0] <= dma_1_data[47:32];
      end
      2'b01: begin
        dma_1_wr <= ~dma_1_wr;
        dma_1_data[63:48] <= adc_1_data_a[31:16];
        dma_1_data[47:32] <= adc_1_data_a[15: 0];
        dma_1_data[31:16] <= dma_1_data[63:48];
        dma_1_data[15: 0] <= dma_1_data[47:32];
      end
      default: begin
        dma_1_wr <= 1'b0;
        dma_1_data[63:48] <= 16'd0;
        dma_1_data[47:32] <= 16'd0;
        dma_1_data[31:16] <= 16'd0;
        dma_1_data[15: 0] <= 16'd0;
      end
    endcase
  end

  // instantiations

  IBUFDS_GTE2 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (rx_ref_clk_p),
    .IB (rx_ref_clk_n),
    .O (rx_ref_clk),
    .ODIV2 ());

  ad_iobuf #(.DATA_WIDTH(21)) i_iobuf (
    .dio_t (gpio_t[20:0]),
    .dio_i (gpio_o[20:0]),
    .dio_o (gpio_i[20:0]),
    .dio_p (gpio_bd));

  fmcjesdadc1_spi i_fmcjesdadc1_spi (
    .spi_csn (spi_csn_0),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio));

  // instantiations

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
    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    .gpio_lcd_tri_io (gpio_lcd),
    .adc_0_data_a (adc_0_data_a),
    .adc_0_data_b (adc_0_data_b),
    .adc_0_enable_a (adc_0_enable_a),
    .adc_0_enable_b (adc_0_enable_b),
    .adc_0_valid_a (),
    .adc_0_valid_b (),
    .adc_1_data_a (adc_1_data_a),
    .adc_1_data_b (adc_1_data_b),
    .adc_1_enable_a (adc_1_enable_a),
    .adc_1_enable_b (adc_1_enable_b),
    .adc_1_valid_a (),
    .adc_1_valid_b (),
    .adc_clk (adc_clk),
    .dma_0_data (dma_0_data),
    .dma_0_sync (1'b1),
    .dma_0_wr (dma_0_wr),
    .dma_1_data (dma_1_data),
    .dma_1_sync (1'b1),
    .dma_1_wr (dma_1_wr),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .mb_intr_06 (1'b0),
    .mb_intr_07 (1'b0),
    .mb_intr_08 (1'b0),
    .mb_intr_14 (mb_intrs[14]),
    .mb_intr_15 (mb_intrs[15]),
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
    .sys_clk_n (sys_clk_n),
    .sys_clk_p (sys_clk_p),
    .sys_rst (sys_rst),
    .uart_sin (uart_sin),
    .uart_sout (uart_sout),
    .rx_data_n (rx_data_n),
    .rx_data_p (rx_data_p),
    .rx_gt_data (rx_gt_data),
    .rx_gt_data_0 (rx_gt_data[63:0]),
    .rx_gt_data_1 (rx_gt_data[127:64]),
    .rx_ref_clk (rx_ref_clk),
    .rx_sync (rx_sync),
    .rx_sysref (rx_sysref),
    .spi_clk_i (1'b0),
    .spi_clk_o (spi_clk),
    .spi_csn_i (8'hff),
    .spi_csn_o (spi_csn),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (1'b0),
    .spi_sdo_o (spi_mosi));

endmodule

// ***************************************************************************
// ***************************************************************************
