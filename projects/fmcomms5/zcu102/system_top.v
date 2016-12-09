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

  gpio_bd_i,
  gpio_bd_o,

  rx_clk_in_0_p,
  rx_clk_in_0_n,
  rx_frame_in_0_p,
  rx_frame_in_0_n,
  rx_data_in_0_p,
  rx_data_in_0_n,
  tx_clk_out_0_p,
  tx_clk_out_0_n,
  tx_frame_out_0_p,
  tx_frame_out_0_n,
  tx_data_out_0_p,
  tx_data_out_0_n,
  gpio_status_0,
  gpio_ctl_0,
  gpio_en_agc_0,
  mcs_sync,
  gpio_resetb_0,
  enable_0,
  txnrx_0,
  gpio_debug_1_0,
  gpio_debug_2_0,
  gpio_calsw_1_0,
  gpio_calsw_2_0,
  gpio_ad5355_rfen,
  gpio_ad5355_lock,

  rx_clk_in_1_p,
  rx_clk_in_1_n,
  rx_frame_in_1_p,
  rx_frame_in_1_n,
  rx_data_in_1_p,
  rx_data_in_1_n,
  tx_clk_out_1_p,
  tx_clk_out_1_n,
  tx_frame_out_1_p,
  tx_frame_out_1_n,
  tx_data_out_1_p,
  tx_data_out_1_n,
  gpio_status_1,
  gpio_ctl_1,
  gpio_en_agc_1,
  gpio_resetb_1,
  enable_1,
  txnrx_1,
  gpio_debug_3_1,
  gpio_debug_4_1,
  gpio_calsw_3_1,
  gpio_calsw_4_1,

  spi_ad9361_0,
  spi_ad9361_1,
  spi_ad5355,
  spi_clk,
  spi_mosi,
  spi_miso,

  ref_clk_p,
  ref_clk_n);

  input   [12:0]  gpio_bd_i;
  output  [ 7:0]  gpio_bd_o;

  input           rx_clk_in_0_p;
  input           rx_clk_in_0_n;
  input           rx_frame_in_0_p;
  input           rx_frame_in_0_n;
  input   [  5:0] rx_data_in_0_p;
  input   [  5:0] rx_data_in_0_n;
  output          tx_clk_out_0_p;
  output          tx_clk_out_0_n;
  output          tx_frame_out_0_p;
  output          tx_frame_out_0_n;
  output  [  5:0] tx_data_out_0_p;
  output  [  5:0] tx_data_out_0_n;
  input   [  7:0] gpio_status_0;
  output  [  3:0] gpio_ctl_0;
  output          gpio_en_agc_0;
  output          mcs_sync;
  output          gpio_resetb_0;
  output          enable_0;
  output          txnrx_0;
  output          gpio_debug_1_0;
  output          gpio_debug_2_0;
  output          gpio_calsw_1_0;
  output          gpio_calsw_2_0;
  output          gpio_ad5355_rfen;
  input           gpio_ad5355_lock;

  input           rx_clk_in_1_p;
  input           rx_clk_in_1_n;
  input           rx_frame_in_1_p;
  input           rx_frame_in_1_n;
  input   [  5:0] rx_data_in_1_p;
  input   [  5:0] rx_data_in_1_n;
  output          tx_clk_out_1_p;
  output          tx_clk_out_1_n;
  output          tx_frame_out_1_p;
  output          tx_frame_out_1_n;
  output  [  5:0] tx_data_out_1_p;
  output  [  5:0] tx_data_out_1_n;
  input   [  7:0] gpio_status_1;
  output  [  3:0] gpio_ctl_1;
  output          gpio_en_agc_1;
  output          gpio_resetb_1;
  output          enable_1;
  output          txnrx_1;
  output          gpio_debug_3_1;
  output          gpio_debug_4_1;
  output          gpio_calsw_3_1;
  output          gpio_calsw_4_1;

  output          spi_ad9361_0;
  output          spi_ad9361_1;
  output          spi_ad5355;
  output          spi_clk;
  output          spi_mosi;
  input           spi_miso;

  input           ref_clk_p;
  input           ref_clk_n;

  // internal registers

  reg     [  2:0] mcs_sync_m = 'd0;
  reg             mcs_sync = 'd0;

  // internal signals

  wire            sys_100m_resetn;
  wire            ref_clk_s;
  wire            ref_clk;
  wire    [ 94:0] gpio_i;
  wire    [ 94:0] gpio_o;
  wire            gpio_sync;
  wire            gpio_open_44_44;
  wire            gpio_open_15_15;
  wire    [ 2:0]  spi0_csn;
  wire            spi0_clk;
  wire            spi0_mosi;
  wire            spi0_miso;
  wire    [ 2:0]  spi1_csn;
  wire            spi1_clk;
  wire            spi1_mosi;
  wire            spi1_miso;
  wire            txnrx_0;
  wire            enable_0;
  wire            txnrx_1;
  wire            enable_1;

  // multi-chip synchronization

  always @(posedge ref_clk or negedge sys_100m_resetn) begin
    if (sys_100m_resetn == 1'b0) begin
      mcs_sync_m <= 3'd0;
      mcs_sync <= 1'd0;
    end else begin
      mcs_sync_m <= {mcs_sync_m[1:0], gpio_sync};
      mcs_sync <= mcs_sync_m[2] & ~mcs_sync_m[1];
    end
  end

  // instantiations

  IBUFGDS i_ref_clk_ibuf (
    .I (ref_clk_p),
    .IB (ref_clk_n),
    .O (ref_clk_s));

  BUFR #(.BUFR_DIVIDE("BYPASS")) i_ref_clk_rbuf (
    .CLR (1'b0),
    .CE (1'b1),
    .I (ref_clk_s),
    .O (ref_clk));

  assign gpio_resetb_1 = gpio_o[65];
  assign gpio_i[64] = gpio_ad5355_lock;
  assign gpio_ad5355_rfen = gpio_o[63];
  assign gpio_calsw_4_1 = gpio_o[62];
  assign gpio_calsw_3_1 = gpio_o[61];
  assign gpio_calsw_2_0 = gpio_o[60];
  assign gpio_calsw_1_0 = gpio_o[59];
  assign gpio_txnrx_1 = gpio_o[58];
  assign gpio_enable_1 = gpio_o[57];
  assign gpio_en_agc_1 = gpio_o[56];
  assign gpio_txnrx_0 = gpio_o[55];
  assign gpio_enable_0 = gpio_o[54];
  assign gpio_en_agc_0 = gpio_o[53];
  assign gpio_resetb_0 = gpio_o[52];
  assign gpio_sync = gpio_o[51];
  assign gpio_open_44_44 = gpio_o[50];
  assign gpio_debug_4_0 = gpio_o[49];
  assign gpio_debug_3_0 = gpio_o[48];
  assign gpio_debug_2_0 = gpio_o[47];
  assign gpio_debug_1_0 = gpio_o[46];
  assign gpio_ctl_1 = gpio_o[45:42];
  assign gpio_ctl_0 = gpio_o[41:38];
  assign gpio_i[37:30] = gpio_status_1;
  assign gpio_i[29:22] = gpio_status_0;
  assign gpio_open_15_15 = gpio_o[21];
  assign gpio_bd_o = gpio_o[20:13];
  assign gpio_i[12: 0] = gpio_bd_i;

  assign gpio_i[94:65] = gpio_o[94:65];
  assign gpio_i[63:38] = gpio_o[63:38];
  assign gpio_i[21:14] = gpio_o[21:14];

  assign spi_ad9361_0 = spi0_csn[0];
  assign spi_ad9361_1 = spi0_csn[1];
  assign spi_ad5355   = spi0_csn[2];
  assign spi_clk = spi0_clk;
  assign spi_mosi = spi0_mosi;
  assign spi0_miso = spi_miso;
  assign spi1_miso = 1'b0;

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .ps_intr_00 (1'b0),
    .ps_intr_01 (1'b0),
    .ps_intr_02 (1'b0),
    .ps_intr_03 (1'b0),
    .ps_intr_04 (1'b0),
    .ps_intr_05 (1'b0),
    .ps_intr_06 (1'b0),
    .ps_intr_07 (1'b0),
    .ps_intr_08 (1'b0),
    .ps_intr_09 (1'b0),
    .ps_intr_10 (1'b0),
    .ps_intr_11 (1'b0),
    .ps_intr_14 (1'b0),
    .ps_intr_15 (1'b0),
    .rx_clk_in_0_n (rx_clk_in_0_n),
    .rx_clk_in_0_p (rx_clk_in_0_p),
    .rx_clk_in_1_n (rx_clk_in_1_n),
    .rx_clk_in_1_p (rx_clk_in_1_p),
    .rx_data_in_0_n (rx_data_in_0_n),
    .rx_data_in_0_p (rx_data_in_0_p),
    .rx_data_in_1_n (rx_data_in_1_n),
    .rx_data_in_1_p (rx_data_in_1_p),
    .rx_frame_in_0_n (rx_frame_in_0_n),
    .rx_frame_in_0_p (rx_frame_in_0_p),
    .rx_frame_in_1_n (rx_frame_in_1_n),
    .rx_frame_in_1_p (rx_frame_in_1_p),
    .spi0_csn (spi0_csn),
    .spi0_miso (spi0_miso),
    .spi0_mosi (spi0_mosi),
    .spi0_sclk (spi0_clk),
    .spi1_csn (spi1_csn),
    .spi1_miso (spi1_miso),
    .spi1_mosi (spi1_mosi),
    .spi1_sclk (spi1_clk),
    .sys_100m_resetn (sys_100m_resetn),
    .tx_clk_out_0_n (tx_clk_out_0_n),
    .tx_clk_out_0_p (tx_clk_out_0_p),
    .tx_clk_out_1_n (tx_clk_out_1_n),
    .tx_clk_out_1_p (tx_clk_out_1_p),
    .tx_data_out_0_n (tx_data_out_0_n),
    .tx_data_out_0_p (tx_data_out_0_p),
    .tx_data_out_1_n (tx_data_out_1_n),
    .tx_data_out_1_p (tx_data_out_1_p),
    .tx_frame_out_0_n (tx_frame_out_0_n),
    .tx_frame_out_0_p (tx_frame_out_0_p),
    .tx_frame_out_1_n (tx_frame_out_1_n),
    .tx_frame_out_1_p (tx_frame_out_1_p),
    .txnrx_0 (txnrx_0),
    .enable_0 (enable_0),
    .up_enable_0 (gpio_enable_0),
    .up_txnrx_0 (gpio_txnrx_0),
    .txnrx_1 (txnrx_1),
    .enable_1 (enable_1),
    .up_enable_1 (gpio_enable_1),
    .up_txnrx_1 (gpio_txnrx_1));

endmodule

// ***************************************************************************
// ***************************************************************************
