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

  spdif,

  iic_scl,
  iic_sda,

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
  gpio_enable_0,
  gpio_txnrx_0,
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
  gpio_enable_1,
  gpio_txnrx_1,
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

  inout   [ 14:0] ddr_addr;
  inout   [  2:0] ddr_ba;
  inout           ddr_cas_n;
  inout           ddr_ck_n;
  inout           ddr_ck_p;
  inout           ddr_cke;
  inout           ddr_cs_n;
  inout   [  3:0] ddr_dm;
  inout   [ 31:0] ddr_dq;
  inout   [  3:0] ddr_dqs_n;
  inout   [  3:0] ddr_dqs_p;
  inout           ddr_odt;
  inout           ddr_ras_n;
  inout           ddr_reset_n;
  inout           ddr_we_n;

  inout           fixed_io_ddr_vrn;
  inout           fixed_io_ddr_vrp;
  inout   [ 53:0] fixed_io_mio;
  inout           fixed_io_ps_clk;
  inout           fixed_io_ps_porb;
  inout           fixed_io_ps_srstb;

  inout   [ 14:0] gpio_bd;

  output          hdmi_out_clk;
  output          hdmi_vsync;
  output          hdmi_hsync;
  output          hdmi_data_e;
  output  [ 23:0] hdmi_data;

  output          spdif;

  inout           iic_scl;
  inout           iic_sda;

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
  inout   [  7:0] gpio_status_0;
  inout   [  3:0] gpio_ctl_0;
  inout           gpio_en_agc_0;
  output          mcs_sync;
  inout           gpio_resetb_0;
  inout           gpio_enable_0;
  inout           gpio_txnrx_0;
  inout           gpio_debug_1_0;
  inout           gpio_debug_2_0;
  inout           gpio_calsw_1_0;
  inout           gpio_calsw_2_0;
  inout           gpio_ad5355_rfen;
  inout           gpio_ad5355_lock;

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
  inout   [  7:0] gpio_status_1;
  inout   [  3:0] gpio_ctl_1;
  inout           gpio_en_agc_1;
  inout           gpio_resetb_1;
  inout           gpio_enable_1;
  inout           gpio_txnrx_1;
  inout           gpio_debug_3_1;
  inout           gpio_debug_4_1;
  inout           gpio_calsw_3_1;
  inout           gpio_calsw_4_1;

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
  wire    [ 63:0] gpio_i;
  wire    [ 63:0] gpio_o;
  wire    [ 63:0] gpio_t;
  wire            gpio_open_45_45;
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

  // multi-chip synchronization

  always @(posedge ref_clk or negedge sys_100m_resetn) begin
    if (sys_100m_resetn == 1'b0) begin
      mcs_sync_m <= 3'd0;
      mcs_sync <= 1'd0;
    end else begin
      mcs_sync_m <= {mcs_sync_m[1:0], gpio_o[45]};
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

  ad_iobuf #(.DATA_WIDTH(60)) i_iobuf (
    .dio_t (gpio_t[59:0]),
    .dio_i (gpio_o[59:0]),
    .dio_o (gpio_i[59:0]),
    .dio_p ({ gpio_resetb_1,    // 59
              gpio_ad5355_lock, // 58
              gpio_ad5355_rfen, // 57
              gpio_calsw_4_1,   // 56
              gpio_calsw_3_1,   // 55
              gpio_calsw_2_0,   // 54
              gpio_calsw_1_0,   // 53
              gpio_txnrx_1,     // 52
              gpio_enable_1,    // 51
              gpio_en_agc_1,    // 50
              gpio_txnrx_0,     // 49
              gpio_enable_0,    // 48
              gpio_en_agc_0,    // 47
              gpio_resetb_0,    // 46
              gpio_open_45_45,  // 45
              gpio_open_44_44,  // 44
              gpio_debug_4_1,   // 43
              gpio_debug_3_1,   // 42
              gpio_debug_2_0,   // 41
              gpio_debug_1_0,   // 40
              gpio_ctl_1,       // 36
              gpio_ctl_0,       // 32
              gpio_status_1,    // 24
              gpio_status_0,    // 16
              gpio_open_15_15,  // 15
              gpio_bd}));       //  0

  assign spi_ad9361_0 = spi0_csn[0];
  assign spi_ad9361_1 = spi0_csn[1];
  assign spi_ad5355   = spi0_csn[2];
  assign spi_clk = spi0_clk;
  assign spi_mosi = spi0_mosi;
  assign spi0_miso = spi_miso;

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
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
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
    .spdif (spdif),
    .spi0_clk_i (spi0_clk),
    .spi0_clk_o (spi0_clk),
    .spi0_csn_0_o (spi0_csn[0]),
    .spi0_csn_1_o (spi0_csn[1]),
    .spi0_csn_2_o (spi0_csn[2]),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (spi0_miso),
    .spi0_sdo_i (spi0_mosi),
    .spi0_sdo_o (spi0_mosi),
    .spi1_clk_i (spi1_clk),
    .spi1_clk_o (spi1_clk),
    .spi1_csn_0_o (spi1_csn[0]),
    .spi1_csn_1_o (spi1_csn[1]),
    .spi1_csn_2_o (spi1_csn[2]),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (1'b1),
    .spi1_sdo_i (spi1_mosi),
    .spi1_sdo_o (spi1_mosi),
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
    .tx_frame_out_1_p (tx_frame_out_1_p));

endmodule

// ***************************************************************************
// ***************************************************************************
