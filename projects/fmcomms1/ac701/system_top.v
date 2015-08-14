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

  phy_reset_n,
  phy_mdc,
  phy_mdio,
  phy_tx_clk,
  phy_tx_ctrl,
  phy_tx_data,
  phy_rx_clk,
  phy_rx_ctrl,
  phy_rx_data,

  fan_pwm,

  gpio_lcd,
  gpio_bd,

  iic_rstn,
  iic_scl,
  iic_sda,

  dac_clk_in_p,
  dac_clk_in_n,
  dac_clk_out_p,
  dac_clk_out_n,
  dac_frame_out_p,
  dac_frame_out_n,
  dac_data_out_p,
  dac_data_out_n,

  adc_clk_in_p,
  adc_clk_in_n,
  adc_or_in_p,
  adc_or_in_n,
  adc_data_in_p,
  adc_data_in_n,

  ref_clk_out_p,
  ref_clk_out_n);

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

  output          phy_reset_n;
  output          phy_mdc;
  inout           phy_mdio;
  output          phy_tx_clk;
  output          phy_tx_ctrl;
  output  [ 3:0]  phy_tx_data;
  input           phy_rx_clk;
  input           phy_rx_ctrl;
  input   [ 3:0]  phy_rx_data;

  output          fan_pwm;

  inout   [ 6:0]  gpio_lcd;
  inout   [12:0]  gpio_bd;

  output          iic_rstn;
  inout           iic_scl;
  inout           iic_sda;

  input           dac_clk_in_p;
  input           dac_clk_in_n;
  output          dac_clk_out_p;
  output          dac_clk_out_n;
  output          dac_frame_out_p;
  output          dac_frame_out_n;
  output   [15:0] dac_data_out_p;
  output   [15:0] dac_data_out_n;

  input           adc_clk_in_p;
  input           adc_clk_in_n;
  input           adc_or_in_p;
  input           adc_or_in_n;
  input   [13:0]  adc_data_in_p;
  input   [13:0]  adc_data_in_n;

  output          ref_clk_out_p;
  output          ref_clk_out_n;

  // internal registers

  reg     [63:0]  dac_ddata_0 = 'd0;
  reg     [63:0]  dac_ddata_1 = 'd0;
  reg             dac_dma_rd = 'd0;
  reg             adc_data_cnt = 'd0;
  reg             adc_dma_wr = 'd0;
  reg     [31:0]  adc_dma_wdata = 'd0;

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire            dac_clk;
  wire            dac_valid_0;
  wire            dac_enable_0;
  wire            dac_valid_1;
  wire            dac_enable_1;
  wire    [63:0]  dac_dma_rdata;
  wire            adc_clk;
  wire            adc_valid_0;
  wire            adc_enable_0;
  wire    [15:0]  adc_data_0;
  wire            adc_valid_1;
  wire            adc_enable_1;
  wire    [15:0]  adc_data_1;
  wire            ref_clk;
  wire            oddr_ref_clk;

  // assignments

  assign mgt_clk_sel  = 2'd0;
  assign fan_pwm      = 1'b1;
  assign iic_rstn     = 1'b1;

  // instantiations

 ad_iobuf #(.DATA_WIDTH(13)) i_iobuf_sw_led (
    .dio_t (gpio_t[12:0]),
    .dio_i (gpio_o[12:0]),
    .dio_o (gpio_i[12:0]),
    .dio_p (gpio_bd));

  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE"),
    .INIT (1'b0),
    .SRTYPE ("ASYNC"))
  i_oddr_ref_clk (
    .S (1'b0),
    .CE (1'b1),
    .R (1'b0),
    .C (ref_clk),
    .D1 (1'b1),
    .D2 (1'b0),
    .Q (oddr_ref_clk));

  OBUFDS i_obufds_ref_clk (
    .I (oddr_ref_clk),
    .O (ref_clk_out_p),
    .OB (ref_clk_out_n));

   always @(posedge dac_clk) begin
    dac_dma_rd <= dac_valid_0 & dac_enable_0;
    dac_ddata_1[63:48] <= dac_dma_rdata[63:48];
    dac_ddata_1[47:32] <= dac_dma_rdata[63:48];
    dac_ddata_1[31:16] <= dac_dma_rdata[31:16];
    dac_ddata_1[15: 0] <= dac_dma_rdata[31:16];
    dac_ddata_0[63:48] <= dac_dma_rdata[47:32];
    dac_ddata_0[47:32] <= dac_dma_rdata[47:32];
    dac_ddata_0[31:16] <= dac_dma_rdata[15: 0];
    dac_ddata_0[15: 0] <= dac_dma_rdata[15: 0];
  end

  always @(posedge adc_clk) begin
    adc_data_cnt <= ~adc_data_cnt;
    case ({adc_enable_1, adc_enable_0})
      2'b10: begin
        adc_dma_wr <= adc_data_cnt;
        adc_dma_wdata <= {adc_data_1, adc_dma_wdata[31:16]};
      end
      2'b01: begin
        adc_dma_wr <= adc_data_cnt;
        adc_dma_wdata <= {adc_data_0, adc_dma_wdata[31:16]};
      end
      default: begin
        adc_dma_wr <= 1'b1;
        adc_dma_wdata <= {adc_data_1, adc_data_0};
      end
    endcase
  end

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
    .gpio_lcd_tri_io (gpio_lcd),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio0_i (gpio_i[31:0]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    .gpio1_i (gpio_i[63:32]),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .mb_intr_06 (1'b0),
    .mb_intr_07 (1'b0),
    .mb_intr_08 (1'b0),
    .mb_intr_14 (1'b0),
    .mb_intr_15 (1'b0),
    .adc_clk (adc_clk),
    .adc_clk_in_n (adc_clk_in_n),
    .adc_clk_in_p (adc_clk_in_p),
    .adc_data_0 (adc_data_0),
    .adc_data_1 (adc_data_1),
    .adc_data_in_n (adc_data_in_n),
    .adc_data_in_p (adc_data_in_p),
    .adc_dma_wdata (adc_dma_wdata),
    .adc_dma_wr (adc_dma_wr),
    .adc_enable_0 (adc_enable_0),
    .adc_enable_1 (adc_enable_1),
    .adc_or_in_n (adc_or_in_n),
    .adc_or_in_p (adc_or_in_p),
    .adc_valid_0 (adc_valid_0),
    .adc_valid_1 (adc_valid_1),
    .dac_clk (dac_clk),
    .dac_clk_in_n (dac_clk_in_n),
    .dac_clk_in_p (dac_clk_in_p),
    .dac_clk_out_n (dac_clk_out_n),
    .dac_clk_out_p (dac_clk_out_p),
    .dac_data_out_n (dac_data_out_n),
    .dac_data_out_p (dac_data_out_p),
    .dac_ddata_0 (dac_ddata_0),
    .dac_ddata_1 (dac_ddata_1),
    .dac_dma_rd (dac_dma_rd),
    .dac_dma_rdata (dac_dma_rdata),
    .dac_enable_0 (dac_enable_0),
    .dac_enable_1 (dac_enable_1),
    .dac_frame_out_n (dac_frame_out_n),
    .dac_frame_out_p (dac_frame_out_p),
    .dac_valid_0 (dac_valid_0),
    .dac_valid_1 (dac_valid_1),
    .ref_clk (ref_clk),
    .mdio_io (phy_mdio),
    .mdio_mdc (phy_mdc),
    .phy_rst_n (phy_reset_n),
    .rgmii_rd (phy_rx_data),
    .rgmii_rx_ctl (phy_rx_ctrl),
    .rgmii_rxc (phy_rx_clk),
    .rgmii_td (phy_tx_data),
    .rgmii_tx_ctl (phy_tx_ctrl),
    .rgmii_txc (phy_tx_clk),
    .sys_clk_n (sys_clk_n),
    .sys_clk_p (sys_clk_p),
    .sys_rst (sys_rst),
    .uart_sin (uart_sin),
    .uart_sout (uart_sout));
endmodule

// ***************************************************************************
// ***************************************************************************
