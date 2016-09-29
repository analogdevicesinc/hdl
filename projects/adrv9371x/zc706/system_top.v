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

  ref_clk0_p,
  ref_clk0_n,
  ref_clk1_p,
  ref_clk1_n,
  rx_data_p,
  rx_data_n,
  tx_data_p,
  tx_data_n,
  rx_sync_p,
  rx_sync_n,
  rx_os_sync_p,
  rx_os_sync_n,
  tx_sync_p,
  tx_sync_n,
  sysref_p,
  sysref_n,

  spi_csn_ad9528,
  spi_csn_ad9371,
  spi_clk,
  spi_mosi,
  spi_miso,

  ad9528_reset_b,
  ad9528_sysref_req,
  ad9371_tx1_enable,
  ad9371_tx2_enable,
  ad9371_rx1_enable,
  ad9371_rx2_enable,
  ad9371_test,
  ad9371_reset_b,
  ad9371_gpint,

  ad9371_gpio_00,
  ad9371_gpio_01,
  ad9371_gpio_02,
  ad9371_gpio_03,
  ad9371_gpio_04,
  ad9371_gpio_05,
  ad9371_gpio_06,
  ad9371_gpio_07,
  ad9371_gpio_15,
  ad9371_gpio_08,
  ad9371_gpio_09,
  ad9371_gpio_10,
  ad9371_gpio_11,
  ad9371_gpio_12,
  ad9371_gpio_14,
  ad9371_gpio_13,
  ad9371_gpio_17,
  ad9371_gpio_16,
  ad9371_gpio_18,

  sys_rst,
  sys_clk_p,
  sys_clk_n,

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
  ddr3_we_n);

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

  inout           fixed_io_ddr_vrn;
  inout           fixed_io_ddr_vrp;
  inout   [53:0]  fixed_io_mio;
  inout           fixed_io_ps_clk;
  inout           fixed_io_ps_porb;
  inout           fixed_io_ps_srstb;

  inout   [14:0]  gpio_bd;

  output          hdmi_out_clk;
  output          hdmi_vsync;
  output          hdmi_hsync;
  output          hdmi_data_e;
  output  [23:0]  hdmi_data;

  output          spdif;

  inout           iic_scl;
  inout           iic_sda;

  input           ref_clk0_p;
  input           ref_clk0_n;
  input           ref_clk1_p;
  input           ref_clk1_n;
  input   [ 3:0]  rx_data_p;
  input   [ 3:0]  rx_data_n;
  output  [ 3:0]  tx_data_p;
  output  [ 3:0]  tx_data_n;
  output          rx_sync_p;
  output          rx_sync_n;
  output          rx_os_sync_p;
  output          rx_os_sync_n;
  input           tx_sync_p;
  input           tx_sync_n;
  input           sysref_p;
  input           sysref_n;

  output          spi_csn_ad9528;
  output          spi_csn_ad9371;
  output          spi_clk;
  output          spi_mosi;
  input           spi_miso;

  inout           ad9528_reset_b;
  inout           ad9528_sysref_req;
  inout           ad9371_tx1_enable;
  inout           ad9371_tx2_enable;
  inout           ad9371_rx1_enable;
  inout           ad9371_rx2_enable;
  inout           ad9371_test;
  inout           ad9371_reset_b;
  inout           ad9371_gpint;

  inout           ad9371_gpio_00;
  inout           ad9371_gpio_01;
  inout           ad9371_gpio_02;
  inout           ad9371_gpio_03;
  inout           ad9371_gpio_04;
  inout           ad9371_gpio_05;
  inout           ad9371_gpio_06;
  inout           ad9371_gpio_07;
  inout           ad9371_gpio_15;
  inout           ad9371_gpio_08;
  inout           ad9371_gpio_09;
  inout           ad9371_gpio_10;
  inout           ad9371_gpio_11;
  inout           ad9371_gpio_12;
  inout           ad9371_gpio_14;
  inout           ad9371_gpio_13;
  inout           ad9371_gpio_17;
  inout           ad9371_gpio_16;
  inout           ad9371_gpio_18;

  input           sys_rst;
  input           sys_clk_p;
  input           sys_clk_n;


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

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire            ref_clk0;
  wire            ref_clk1;
  wire            rx_sync;
  wire            rx_os_sync;
  wire            tx_sync;
  wire            sysref;

  // instantiations

  IBUFDS_GTE2 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (ref_clk0_p),
    .IB (ref_clk0_n),
    .O (ref_clk0),
    .ODIV2 ());

  IBUFDS_GTE2 i_ibufds_ref_clk1 (
    .CEB (1'd0),
    .I (ref_clk1_p),
    .IB (ref_clk1_n),
    .O (ref_clk1),
    .ODIV2 ());

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  OBUFDS i_obufds_rx_os_sync (
    .I (rx_os_sync),
    .O (rx_os_sync_p),
    .OB (rx_os_sync_n));

  IBUFDS i_ibufds_tx_sync (
    .I (tx_sync_p),
    .IB (tx_sync_n),
    .O (tx_sync));

  IBUFDS i_ibufds_sysref (
    .I (sysref_p),
    .IB (sysref_n),
    .O (sysref));

  ad_iobuf #(.DATA_WIDTH(28)) i_iobuf (
    .dio_t ({gpio_t[59:32]}),
    .dio_i ({gpio_o[59:32]}),
    .dio_o ({gpio_i[59:32]}),
    .dio_p ({ ad9528_reset_b,       // 59
              ad9528_sysref_req,    // 58
              ad9371_tx1_enable,    // 57
              ad9371_tx2_enable,    // 56
              ad9371_rx1_enable,    // 55
              ad9371_rx2_enable,    // 54
              ad9371_test,          // 53
              ad9371_reset_b,       // 52
              ad9371_gpint,         // 51
              ad9371_gpio_00,       // 50
              ad9371_gpio_01,       // 49
              ad9371_gpio_02,       // 48
              ad9371_gpio_03,       // 47
              ad9371_gpio_04,       // 46
              ad9371_gpio_05,       // 45
              ad9371_gpio_06,       // 44
              ad9371_gpio_07,       // 43
              ad9371_gpio_15,       // 42
              ad9371_gpio_08,       // 41
              ad9371_gpio_09,       // 40
              ad9371_gpio_10,       // 39
              ad9371_gpio_11,       // 38
              ad9371_gpio_12,       // 37
              ad9371_gpio_14,       // 36
              ad9371_gpio_13,       // 35
              ad9371_gpio_17,       // 34
              ad9371_gpio_16,       // 33
              ad9371_gpio_18}));    // 32

  ad_iobuf #(.DATA_WIDTH(15)) i_iobuf_bd (
    .dio_t (gpio_t[14:0]),
    .dio_i (gpio_o[14:0]),
    .dio_o (gpio_i[14:0]),
    .dio_p (gpio_bd));

  system_wrapper i_system_wrapper (
    .dac_fifo_bypass (gpio_o[60]),
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
    .rx_data_0_n (rx_data_n[0]),
    .rx_data_0_p (rx_data_p[0]),
    .rx_data_1_n (rx_data_n[1]),
    .rx_data_1_p (rx_data_p[1]),
    .rx_data_2_n (rx_data_n[2]),
    .rx_data_2_p (rx_data_p[2]),
    .rx_data_3_n (rx_data_n[3]),
    .rx_data_3_p (rx_data_p[3]),
    .rx_ref_clk_0 (ref_clk1),
    .rx_ref_clk_2 (ref_clk1),
    .rx_sync_0 (rx_sync),
    .rx_sync_2 (rx_os_sync),
    .rx_sysref_0 (sysref),
    .rx_sysref_2 (sysref),
    .spdif (spdif),
    .spi0_clk_i (spi_clk),
    .spi0_clk_o (spi_clk),
    .spi0_csn_0_o (spi_csn_ad9528),
    .spi0_csn_1_o (spi_csn_ad9371),
    .spi0_csn_2_o (),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (spi_miso),
    .spi0_sdo_i (spi_mosi),
    .spi0_sdo_o (spi_mosi),
    .spi1_clk_i (1'd0),
    .spi1_clk_o (),
    .spi1_csn_0_o (),
    .spi1_csn_1_o (),
    .spi1_csn_2_o (),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (1'd0),
    .spi1_sdo_i (1'd0),
    .spi1_sdo_o (),
    .sys_clk_clk_n (sys_clk_n),
    .sys_clk_clk_p (sys_clk_p),
    .sys_rst(sys_rst),
    .tx_data_0_n (tx_data_n[0]),
    .tx_data_0_p (tx_data_p[0]),
    .tx_data_1_n (tx_data_n[1]),
    .tx_data_1_p (tx_data_p[1]),
    .tx_data_2_n (tx_data_n[2]),
    .tx_data_2_p (tx_data_p[2]),
    .tx_data_3_n (tx_data_n[3]),
    .tx_data_3_p (tx_data_p[3]),
    .tx_ref_clk_0 (ref_clk1),
    .tx_sync_0 (tx_sync),
    .tx_sysref_0 (sysref));

endmodule

// ***************************************************************************
// ***************************************************************************
