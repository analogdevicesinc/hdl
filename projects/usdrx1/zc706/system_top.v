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
  ddr3_we_n,

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

  spi_fout_enb_clk,
  spi_fout_enb_mlo,
  spi_fout_enb_rst,
  spi_fout_enb_sync,
  spi_fout_enb_sysref,
  spi_fout_enb_trig,
  spi_fout_clk,
  spi_fout_sdio,
  spi_afe_csn,
  spi_afe_clk,
  spi_afe_sdio,
  spi_clk_csn,
  spi_clk_clk,
  spi_clk_sdio,

  afe_rst_p,
  afe_rst_n,
  afe_trig_p,
  afe_trig_n,

  dac_sleep,
  dac_data,
  afe_pdn,
  afe_stby,
  clk_resetn,
  clk_syncn,
  clk_status,
  amp_disbn,
  prc_sck,
  prc_cnv,
  prc_sdo_i,
  prc_sdo_q);

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

  inout           iic_scl;
  inout           iic_sda;

  input           rx_ref_clk_p;
  input           rx_ref_clk_n;
  output          rx_sysref_p;
  output          rx_sysref_n;
  output          rx_sync_p;
  output          rx_sync_n;
  input   [ 7:0]  rx_data_p;
  input   [ 7:0]  rx_data_n;

  output          spi_fout_enb_clk;
  output          spi_fout_enb_mlo;
  output          spi_fout_enb_rst;
  output          spi_fout_enb_sync;
  output          spi_fout_enb_sysref;
  output          spi_fout_enb_trig;
  output          spi_fout_clk;
  output          spi_fout_sdio;
  output  [ 3:0]  spi_afe_csn;
  output          spi_afe_clk;
  inout           spi_afe_sdio;
  output          spi_clk_csn;
  output          spi_clk_clk;
  inout           spi_clk_sdio;

  output          afe_rst_p;
  output          afe_rst_n;
  output          afe_trig_p;
  output          afe_trig_n;

  output          dac_sleep;
  output  [13:0]  dac_data;
  output          afe_pdn;
  output          afe_stby;
  output          clk_resetn;
  output          clk_syncn;
  input           clk_status;
  output          amp_disbn;
  inout           prc_sck;
  inout           prc_cnv;
  inout           prc_sdo_i;
  inout           prc_sdo_q;

  // internal signals

  wire    [ 4:0]  spi_csn;
  wire            spi_clk;
  wire            spi_mosi;
  wire            spi_miso;
  wire            rx_ref_clk;
  wire            rx_sysref;
  wire            rx_sync;
  wire   [511:0]  adc_data;
  wire   [127:0]  adc_data_0;
  wire   [127:0]  adc_data_1;
  wire   [127:0]  adc_data_2;
  wire   [127:0]  adc_data_3;
  wire            adc_valid;
  wire   [  7:0]  adc_valid_0;
  wire   [  7:0]  adc_valid_1;
  wire   [  7:0]  adc_valid_2;
  wire   [  7:0]  adc_valid_3;
  wire   [  7:0]  adc_enable_0;
  wire   [  7:0]  adc_enable_1;
  wire   [  7:0]  adc_enable_2;
  wire   [  7:0]  adc_enable_3;
  wire            adc_dovf;
  wire            adc_dovf_0;
  wire            adc_dovf_1;
  wire            adc_dovf_2;
  wire            adc_dovf_3;
  wire   [255:0]  gt_rx_data;
  wire     [7:0]  gt_rx_sof;
  wire    [63:0]  gt_rx_data_0;
  wire            gt_rx_sof_0;
  wire    [63:0]  gt_rx_data_1;
  wire            gt_rx_sof_1;
  wire    [63:0]  gt_rx_data_2;
  wire            gt_rx_sof_2;
  wire    [63:0]  gt_rx_data_3;
  wire            gt_rx_sof_3;
  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire    [15:0]  ps_intrs;

  // spi assignments

  assign spi_fout_enb_clk     = 1'b0;
  assign spi_fout_enb_mlo     = 1'b0;
  assign spi_fout_enb_rst     = 1'b0;
  assign spi_fout_enb_sync    = 1'b0;
  assign spi_fout_enb_sysref  = 1'b0;
  assign spi_fout_enb_trig    = 1'b0;
  assign spi_fout_sdio        = 1'b0;
  assign spi_afe_csn          = spi_csn[ 4: 1];
  assign spi_clk_csn          = spi_csn[ 0: 0];
  assign spi_fout_clk         = 1'b0;
  assign spi_afe_clk          = spi_clk;
  assign spi_clk_clk          = spi_clk;

  usdrx1_spi i_spi (
    .spi_afe_csn (spi_csn[4:1]),
    .spi_clk_csn (spi_csn[0]),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_afe_sdio (spi_afe_sdio),
    .spi_clk_sdio (spi_clk_sdio));

  // single dma for all channels

  assign gt_rx_data_3 = gt_rx_data[255:192];
  assign gt_rx_data_2 = gt_rx_data[191:128];
  assign gt_rx_data_1 = gt_rx_data[127: 64];
  assign gt_rx_data_0 = gt_rx_data[ 63:  0];
  assign gt_rx_sof_0 = gt_rx_sof [0] | gt_rx_sof [1];
  assign gt_rx_sof_1 = gt_rx_sof [2] | gt_rx_sof [3];
  assign gt_rx_sof_2 = gt_rx_sof [4] | gt_rx_sof [5];
  assign gt_rx_sof_3 = gt_rx_sof [6] | gt_rx_sof [7];

  assign adc_data   = {adc_data_3, adc_data_2, adc_data_1, adc_data_0};
  assign adc_valid  = (|adc_valid_0) | (|adc_valid_1) | (|adc_valid_2) | (|adc_valid_3) ;
  assign adc_dovf_0 = adc_dovf;
  assign adc_dovf_1 = adc_dovf;
  assign adc_dovf_2 = adc_dovf;
  assign adc_dovf_3 = adc_dovf;

  // data interface

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

  // gpio/control interface

  IOBUF i_iobuf_gpio_prc_sdo_q  (
    .I (gpio_o[43]),
    .O (gpio_i[43]),
    .T (gpio_t[43]),
    .IO (prc_sdo_q));

  IOBUF i_iobuf_gpio_prc_sdo_i  (
    .I (gpio_o[42]),
    .O (gpio_i[42]),
    .T (gpio_t[42]),
    .IO (prc_sdo_i));

  IOBUF i_iobuf_gpio_prc_cnv    (
    .I (gpio_o[41]),
    .O (gpio_i[41]),
    .T (gpio_t[41]),
    .IO (prc_cnv));

  IOBUF i_iobuf_gpio_prc_sck    (
    .I (gpio_o[40]),
    .O (gpio_i[40]),
    .T (gpio_t[40]),
    .IO (prc_sck));

  assign dac_sleep  = gpio_o[44];
  assign amp_disbn  = gpio_o[39];
  assign gpio_i[38] = clk_status;
  assign clk_syncn  = gpio_o[37];
  assign clk_resetn = gpio_o[36];
  assign afe_stby   = gpio_o[35];
  assign afe_pdn    = gpio_o[34];

  OBUFDS i_obufds_gpio_afe_trig (
    .I (gpio_o[33]),
    .O (afe_trig_p),
    .OB (afe_trig_n));

  OBUFDS i_obufds_gpio_afe_rst (
    .I (gpio_o[32]),
    .O (afe_rst_p),
    .OB (afe_rst_n));

  genvar n;
  generate
  for (n = 0; n <= 13; n = n + 1) begin: g_iobuf_gpio_dac_data
    assign dac_data[n]   = gpio_o[45+n];
  end
  for (n = 0; n <= 14; n = n + 1) begin: g_iobuf_gpio_bd
  IOBUF i_iobuf_gpio_bd (
    .I (gpio_o[n]),
    .O (gpio_i[n]),
    .T (gpio_t[n]),
    .IO (gpio_bd[n]));
  end
  endgenerate

  system_wrapper i_system_wrapper (
    .sys_clk_clk_n (sys_clk_n),
    .sys_clk_clk_p (sys_clk_p),
    .sys_rst (sys_rst),
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
    .adc_data (adc_data),
    .adc_data_0 (adc_data_0),
    .adc_data_1 (adc_data_1),
    .adc_data_2 (adc_data_2),
    .adc_data_3 (adc_data_3),
    .adc_wr_en(adc_valid),
    .adc_valid_0 (adc_valid_0),
    .adc_valid_1 (adc_valid_1),
    .adc_valid_2 (adc_valid_2),
    .adc_valid_3 (adc_valid_3),
    .adc_enable_0 (adc_enable_0),
    .adc_enable_1 (adc_enable_1),
    .adc_enable_2 (adc_enable_2),
    .adc_enable_3 (adc_enable_3),
    .adc_dovf (adc_dovf),
    .adc_dovf_0 (adc_dovf_0),
    .adc_dovf_1 (adc_dovf_1),
    .adc_dovf_2 (adc_dovf_2),
    .adc_dovf_3 (adc_dovf_3),
    .gt_rx_data (gt_rx_data),
    .gt_rx_sof (gt_rx_sof),
    .gt_rx_data_0 (gt_rx_data_0),
    .gt_rx_sof_0(gt_rx_sof_0),
    .gt_rx_data_1 (gt_rx_data_1),
    .gt_rx_sof_1(gt_rx_sof_1),
    .gt_rx_data_2 (gt_rx_data_2),
    .gt_rx_sof_2(gt_rx_sof_2),
    .gt_rx_data_3 (gt_rx_data_3),
    .gt_rx_sof_3(gt_rx_sof_3),
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
    .rx_data_n (rx_data_n),
    .rx_data_p (rx_data_p),
    .rx_ref_clk (rx_ref_clk),
    .rx_sync (rx_sync),
    .rx_sysref (rx_sysref),
    .spdif (spdif),
    .spi_clk_i (spi_clk),
    .spi_clk_o (spi_clk),
    .spi_csn_i (spi_csn),
    .spi_csn_o (spi_csn),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (spi_mosi),
    .spi_sdo_o (spi_mosi));

endmodule

// ***************************************************************************
// ***************************************************************************
