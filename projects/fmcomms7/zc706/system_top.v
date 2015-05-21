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

  tx_ref_clk_p,
  tx_ref_clk_n,
  tx_sysref_p,
  tx_sysref_n,
  tx_sync0_p,
  tx_sync0_n,
  tx_sync1_p,
  tx_sync1_n,
  tx_data_p,
  tx_data_n,

  trig_p,
  trig_n,

  spi_csn_clk,
  spi_csn_dac,
  spi_csn_adc,
  spi_clk,
  spi_sdio,
  spi_dir,

  spi2_csn_adf4355_1,
  spi2_csn_adf4355_2,
  spi2_csn_hmc1044_1,
  spi2_csn_hmc1044_2,
  spi2_csn_hmc1044_3,
  spi2_csn_adl5240_1,
  spi2_csn_adl5240_2,
  spi2_csn_hmc271_1,
  spi2_csn_hmc271_2,
  spi2_clk,
  spi2_sdo,
  spi2_sdi_hmc271_1,
  spi2_sdi_hmc271_2,

  clk_gpio,
  adc_fda,
  adc_fdb,
  dac_irq,
  adf4355_1_ld,
  adf4355_2_ld,
  xo_en,
  clk_sync,
  adf4355_2_pd,
  dac_txen0,
  dac_txen1,
  hmc271_1_reset,
  hmc271_2_reset,
  hmc349_sel,
  hmc922_a,
  hmc922_b);

  inout  [ 14:0]  ddr_addr;
  inout  [  2:0]  ddr_ba;
  inout           ddr_cas_n;
  inout           ddr_ck_n;
  inout           ddr_ck_p;
  inout           ddr_cke;
  inout           ddr_cs_n;
  inout  [  3:0]  ddr_dm;
  inout  [ 31:0]  ddr_dq;
  inout  [  3:0]  ddr_dqs_n;
  inout  [  3:0]  ddr_dqs_p;
  inout           ddr_odt;
  inout           ddr_ras_n;
  inout           ddr_reset_n;
  inout           ddr_we_n;

  inout           fixed_io_ddr_vrn;
  inout           fixed_io_ddr_vrp;
  inout  [ 53:0]  fixed_io_mio;
  inout           fixed_io_ps_clk;
  inout           fixed_io_ps_porb;
  inout           fixed_io_ps_srstb;

  inout  [ 14:0]  gpio_bd;

  output          hdmi_out_clk;
  output          hdmi_vsync;
  output          hdmi_hsync;
  output          hdmi_data_e;
  output [ 23:0]  hdmi_data;

  output          spdif;

  input           sys_rst;
  input           sys_clk_p;
  input           sys_clk_n;

  output [ 13:0]  ddr3_addr;
  output [  2:0]  ddr3_ba;
  output          ddr3_cas_n;
  output [  0:0]  ddr3_ck_n;
  output [  0:0]  ddr3_ck_p;
  output [  0:0]  ddr3_cke;
  output [  0:0]  ddr3_cs_n;
  output [  7:0]  ddr3_dm;
  inout  [ 63:0]  ddr3_dq;
  inout  [  7:0]  ddr3_dqs_n;
  inout  [  7:0]  ddr3_dqs_p;
  output [  0:0]  ddr3_odt;
  output          ddr3_ras_n;
  output          ddr3_reset_n;
  output          ddr3_we_n;

  inout           iic_scl;
  inout           iic_sda;

  input           rx_ref_clk_p;
  input           rx_ref_clk_n;
  input           rx_sysref_p;
  input           rx_sysref_n;
  output          rx_sync_p;
  output          rx_sync_n;
  input  [  3:0]  rx_data_p;
  input  [  3:0]  rx_data_n;

  input           tx_ref_clk_p;
  input           tx_ref_clk_n;
  input           tx_sysref_p;
  input           tx_sysref_n;
  input           tx_sync0_p;
  input           tx_sync0_n;
  input           tx_sync1_p;
  input           tx_sync1_n;
  output [  7:0]  tx_data_p;
  output [  7:0]  tx_data_n;

  input           trig_p;
  input           trig_n;

  output          spi_csn_clk;
  output          spi_csn_dac;
  output          spi_csn_adc;
  output          spi_clk;
  inout           spi_sdio;
  output          spi_dir;

  output          spi2_csn_adf4355_1;
  output          spi2_csn_adf4355_2;
  output          spi2_csn_hmc1044_1;
  output          spi2_csn_hmc1044_2;
  output          spi2_csn_hmc1044_3;
  output          spi2_csn_adl5240_1;
  output          spi2_csn_adl5240_2;
  output          spi2_csn_hmc271_1;
  output          spi2_csn_hmc271_2;
  output          spi2_clk;
  output          spi2_sdo;
  input           spi2_sdi_hmc271_1;
  input           spi2_sdi_hmc271_2;

  inout  [  3:0]  clk_gpio;
  inout           adc_fda;
  inout           adc_fdb;
  inout           dac_irq;
  inout           adf4355_1_ld;
  inout           adf4355_2_ld;
  inout           xo_en;
  inout           clk_sync;
  inout           adf4355_2_pd;
  inout           dac_txen0;
  inout           dac_txen1;
  inout           hmc271_1_reset;
  inout           hmc271_2_reset;
  inout           hmc349_sel;
  inout           hmc922_a;
  inout           hmc922_b;

  // internal registers

  reg             dac_drd = 'd0;
  reg    [ 63:0]  dac_ddata_0 = 'd0;
  reg    [ 63:0]  dac_ddata_1 = 'd0;
  reg    [ 63:0]  dac_ddata_2 = 'd0;
  reg    [ 63:0]  dac_ddata_3 = 'd0;
  reg             adc_dsync = 'd0;
  reg             adc_dwr = 'd0;
  reg    [127:0]  adc_ddata = 'd0;

  // internal signals

  wire   [ 63:0]  gpio_i;
  wire   [ 63:0]  gpio_o;
  wire   [ 63:0]  gpio_t;
  wire   [  2:0]  spi0_csn;
  wire            spi0_clk;
  wire            spi0_mosi;
  wire            spi0_miso;
  wire   [  2:0]  spi1_csn;
  wire            spi1_clk;
  wire            spi1_mosi;
  wire            spi1_miso;
  wire   [ 11:0]  spi2_csn;
  wire            spi2_mosi;
  wire            spi2_miso;
  wire            trig;
  wire            rx_ref_clk;
  wire            rx_sysref;
  wire            rx_sync;
  wire            tx_ref_clk;
  wire            tx_sysref;
  wire            tx_sync0;
  wire            tx_sync1;
  wire            tx_sync;
  wire            dac_clk;
  wire   [255:0]  dac_ddata;
  wire            dac_enable_0;
  wire            dac_enable_1;
  wire            dac_enable_2;
  wire            dac_enable_3;
  wire            dac_valid_0;
  wire            dac_valid_1;
  wire            dac_valid_2;
  wire            dac_valid_3;
  wire            adc_clk;
  wire   [ 63:0]  adc_data_0;
  wire   [ 63:0]  adc_data_1;
  wire            adc_enable_0;
  wire            adc_enable_1;
  wire            adc_valid_0;
  wire            adc_valid_1;

  // adc-dac data

  always @(posedge dac_clk) begin
    case ({dac_enable_3, dac_enable_2, dac_enable_1, dac_enable_0})
      4'b1111: begin
        dac_drd <= dac_valid_0 & dac_valid_1 & dac_valid_2 & dac_valid_3;
        dac_ddata_0[15: 0] <= dac_ddata[((16* 0)+15):(16* 0)];
        dac_ddata_1[15: 0] <= dac_ddata[((16* 1)+15):(16* 1)];
        dac_ddata_2[15: 0] <= dac_ddata[((16* 2)+15):(16* 2)];
        dac_ddata_3[15: 0] <= dac_ddata[((16* 3)+15):(16* 3)];
        dac_ddata_0[31:16] <= dac_ddata[((16* 4)+15):(16* 4)];
        dac_ddata_1[31:16] <= dac_ddata[((16* 5)+15):(16* 5)];
        dac_ddata_2[31:16] <= dac_ddata[((16* 6)+15):(16* 6)];
        dac_ddata_3[31:16] <= dac_ddata[((16* 7)+15):(16* 7)];
        dac_ddata_0[47:32] <= dac_ddata[((16* 8)+15):(16* 8)];
        dac_ddata_1[47:32] <= dac_ddata[((16* 9)+15):(16* 9)];
        dac_ddata_2[47:32] <= dac_ddata[((16*10)+15):(16*10)];
        dac_ddata_3[47:32] <= dac_ddata[((16*11)+15):(16*11)];
        dac_ddata_0[63:48] <= dac_ddata[((16*12)+15):(16*12)];
        dac_ddata_1[63:48] <= dac_ddata[((16*13)+15):(16*13)];
        dac_ddata_2[63:48] <= dac_ddata[((16*14)+15):(16*14)];
        dac_ddata_3[63:48] <= dac_ddata[((16*15)+15):(16*15)];
      end
      4'b1100: begin
        dac_drd <= dac_valid_2 & dac_valid_3 & ~dac_drd;
        dac_ddata_0 <= 64'd0;
        dac_ddata_1 <= 64'd0;
        if (dac_drd == 1'b1) begin
          dac_ddata_2[15: 0] <= dac_ddata[((16* 0)+15):(16* 0)];
          dac_ddata_3[15: 0] <= dac_ddata[((16* 1)+15):(16* 1)];
          dac_ddata_2[31:16] <= dac_ddata[((16* 2)+15):(16* 2)];
          dac_ddata_3[31:16] <= dac_ddata[((16* 3)+15):(16* 3)];
          dac_ddata_2[47:32] <= dac_ddata[((16* 4)+15):(16* 4)];
          dac_ddata_3[47:32] <= dac_ddata[((16* 5)+15):(16* 5)];
          dac_ddata_2[63:48] <= dac_ddata[((16* 6)+15):(16* 6)];
          dac_ddata_3[63:48] <= dac_ddata[((16* 7)+15):(16* 7)];
        end else begin
          dac_ddata_2[15: 0] <= dac_ddata[((16* 8)+15):(16* 8)];
          dac_ddata_3[15: 0] <= dac_ddata[((16* 9)+15):(16* 9)];
          dac_ddata_2[31:16] <= dac_ddata[((16*10)+15):(16*10)];
          dac_ddata_3[31:16] <= dac_ddata[((16*11)+15):(16*11)];
          dac_ddata_2[47:32] <= dac_ddata[((16*12)+15):(16*12)];
          dac_ddata_3[47:32] <= dac_ddata[((16*13)+15):(16*13)];
          dac_ddata_2[63:48] <= dac_ddata[((16*14)+15):(16*14)];
          dac_ddata_3[63:48] <= dac_ddata[((16*15)+15):(16*15)];
        end
      end
      4'b0011: begin
        dac_drd <= dac_valid_0 & dac_valid_1 & ~dac_drd;
        dac_ddata_2 <= 64'd0;
        dac_ddata_3 <= 64'd0;
        if (dac_drd == 1'b1) begin
          dac_ddata_0[15: 0] <= dac_ddata[((16* 0)+15):(16* 0)];
          dac_ddata_1[15: 0] <= dac_ddata[((16* 1)+15):(16* 1)];
          dac_ddata_0[31:16] <= dac_ddata[((16* 2)+15):(16* 2)];
          dac_ddata_1[31:16] <= dac_ddata[((16* 3)+15):(16* 3)];
          dac_ddata_0[47:32] <= dac_ddata[((16* 4)+15):(16* 4)];
          dac_ddata_1[47:32] <= dac_ddata[((16* 5)+15):(16* 5)];
          dac_ddata_0[63:48] <= dac_ddata[((16* 6)+15):(16* 6)];
          dac_ddata_1[63:48] <= dac_ddata[((16* 7)+15):(16* 7)];
        end else begin
          dac_ddata_0[15: 0] <= dac_ddata[((16* 8)+15):(16* 8)];
          dac_ddata_1[15: 0] <= dac_ddata[((16* 9)+15):(16* 9)];
          dac_ddata_0[31:16] <= dac_ddata[((16*10)+15):(16*10)];
          dac_ddata_1[31:16] <= dac_ddata[((16*11)+15):(16*11)];
          dac_ddata_0[47:32] <= dac_ddata[((16*12)+15):(16*12)];
          dac_ddata_1[47:32] <= dac_ddata[((16*13)+15):(16*13)];
          dac_ddata_0[63:48] <= dac_ddata[((16*14)+15):(16*14)];
          dac_ddata_1[63:48] <= dac_ddata[((16*15)+15):(16*15)];
        end
      end
      default: begin
        dac_drd <= 1'b0;
        dac_ddata_0 <= 64'd0;
        dac_ddata_1 <= 64'd0;
        dac_ddata_2 <= 64'd0;
        dac_ddata_3 <= 64'd0;
      end
    endcase
  end

  always @(posedge adc_clk) begin
    case ({adc_enable_1, adc_enable_0})
      2'b11: begin
        adc_dsync <= 1'b1;
        adc_dwr <= adc_valid_1 & adc_valid_0;
        adc_ddata[127:112] <= adc_data_1[63:48];
        adc_ddata[111: 96] <= adc_data_0[63:48];
        adc_ddata[ 95: 80] <= adc_data_1[47:32];
        adc_ddata[ 79: 64] <= adc_data_0[47:32];
        adc_ddata[ 63: 48] <= adc_data_1[31:16];
        adc_ddata[ 47: 32] <= adc_data_0[31:16];
        adc_ddata[ 31: 16] <= adc_data_1[15: 0];
        adc_ddata[ 15:  0] <= adc_data_0[15: 0];
      end
      2'b10: begin
        adc_dsync <= 1'b1;
        adc_dwr <= adc_valid_1 & ~adc_dwr;
        adc_ddata[127:112] <= adc_data_1[63:48];
        adc_ddata[111: 96] <= adc_data_1[47:32];
        adc_ddata[ 95: 80] <= adc_data_1[31:16];
        adc_ddata[ 79: 64] <= adc_data_1[15: 0];
        adc_ddata[ 63: 48] <= adc_ddata[127:112];
        adc_ddata[ 47: 32] <= adc_ddata[111: 96];
        adc_ddata[ 31: 16] <= adc_ddata[ 95: 80];
        adc_ddata[ 15:  0] <= adc_ddata[ 79: 64];
      end
      2'b01: begin
        adc_dsync <= 1'b1;
        adc_dwr <= adc_valid_0 & ~adc_dwr;
        adc_ddata[127:112] <= adc_data_0[63:48];
        adc_ddata[111: 96] <= adc_data_0[47:32];
        adc_ddata[ 95: 80] <= adc_data_0[31:16];
        adc_ddata[ 79: 64] <= adc_data_0[15: 0];
        adc_ddata[ 63: 48] <= adc_ddata[127:112];
        adc_ddata[ 47: 32] <= adc_ddata[111: 96];
        adc_ddata[ 31: 16] <= adc_ddata[ 95: 80];
        adc_ddata[ 15:  0] <= adc_ddata[ 79: 64];
      end
      default: begin
        adc_dsync <= 1'b0;
        adc_dwr <= 1'b0;
        adc_ddata <= 128'd0;
      end
    endcase
  end

  // spi

  assign spi_csn_adc = spi0_csn[2];
  assign spi_csn_dac = spi0_csn[1];
  assign spi_csn_clk = spi0_csn[0];

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

  IBUFDS i_ibufds_tx_sync0 (
    .I (tx_sync0_p),
    .IB (tx_sync0_n),
    .O (tx_sync0));

  IBUFDS i_ibufds_tx_sync1 (
    .I (tx_sync1_p),
    .IB (tx_sync1_n),
    .O (tx_sync1));

  assign tx_sync = tx_sync0 & tx_sync1;

  fmcomms7_spi i_spi (
    .spi_csn (spi0_csn),
    .spi_clk (spi_clk),
    .spi_mosi (spi0_mosi),
    .spi_miso (spi0_miso),
    .spi_sdio (spi_sdio),
    .spi_dir (spi_dir));

  IBUFDS i_ibufds_trig (
    .I (trig_p),
    .IB (trig_n),
    .O (trig));

  assign spi2_csn_adf4355_1 = spi2_csn[0];
  assign spi2_csn_adf4355_2 = spi2_csn[1];
  assign spi2_csn_hmc1044_1 = spi2_csn[2];
  assign spi2_csn_hmc1044_2 = spi2_csn[3];
  assign spi2_csn_hmc1044_3 = spi2_csn[4];
  assign spi2_csn_adl5240_1 = spi2_csn[5];
  assign spi2_csn_adl5240_2 = spi2_csn[6];
  assign spi2_csn_hmc271_1 = spi2_csn[7];
  assign spi2_csn_hmc271_2 = spi2_csn[8];
  assign spi2_sdo = spi2_mosi;
  assign spi2_miso =  (~spi2_csn[7]  & spi2_sdi_hmc271_1) |
                      (~spi2_csn[8]  & spi2_sdi_hmc271_2);

  assign gpio_i[51] = trig;
  assign spi_clk = spi0_clk;

  ad_iobuf #(.DATA_WIDTH(19)) i_iobuf (
    .dio_t (gpio_t[50:32]),
    .dio_i (gpio_o[50:32]),
    .dio_o (gpio_i[50:32]),
    .dio_p ({ xo_en,            // 50
              clk_sync,         // 49
              adf4355_2_pd,     // 48
              dac_txen0,        // 47
              dac_txen1,        // 46
              hmc271_1_reset,   // 45
              hmc271_2_reset,   // 44
              hmc349_sel,       // 43
              hmc922_a,         // 42
              hmc922_b,         // 41
              adf4355_2_ld,     // 40
              adf4355_1_ld,     // 39
              dac_irq,          // 38
              adc_fdb,          // 37
              adc_fda,          // 36
              clk_gpio[3],      // 35
              clk_gpio[2],      // 34
              clk_gpio[1],      // 33
              clk_gpio[0]}));   // 32

  ad_iobuf #(.DATA_WIDTH(15)) i_iobuf_bd (
    .dio_t (gpio_t[14:0]),
    .dio_i (gpio_o[14:0]),
    .dio_o (gpio_i[14:0]),
    .dio_p (gpio_bd));

  system_wrapper i_system_wrapper (
    .adc_clk (adc_clk),
    .adc_data_0 (adc_data_0),
    .adc_data_1 (adc_data_1),
    .adc_ddata (adc_ddata),
    .adc_dsync (adc_dsync),
    .adc_dwr (adc_dwr),
    .adc_enable_0 (adc_enable_0),
    .adc_enable_1 (adc_enable_1),
    .adc_valid_0 (adc_valid_0),
    .adc_valid_1 (adc_valid_1),
    .dac_clk (dac_clk),
    .dac_ddata (dac_ddata),
    .dac_ddata_0 (dac_ddata_0),
    .dac_ddata_1 (dac_ddata_1),
    .dac_ddata_2 (dac_ddata_2),
    .dac_ddata_3 (dac_ddata_3),
    .dac_drd (dac_drd),
    .dac_enable_0 (dac_enable_0),
    .dac_enable_1 (dac_enable_1),
    .dac_enable_2 (dac_enable_2),
    .dac_enable_3 (dac_enable_3),
    .dac_valid_0 (dac_valid_0),
    .dac_valid_1 (dac_valid_1),
    .dac_valid_2 (dac_valid_2),
    .dac_valid_3 (dac_valid_3),
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
    .ps_intr_11 (1'b0),
    .rx_data_n (rx_data_n),
    .rx_data_p (rx_data_p),
    .rx_ref_clk (rx_ref_clk),
    .rx_sync (rx_sync),
    .rx_sysref (rx_sysref),
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
    .spi2_clk_i (spi2_clk),
    .spi2_clk_o (spi2_clk),
    .spi2_csn_i (12'hfff),
    .spi2_csn_o (spi2_csn),
    .spi2_sdi_i (spi2_miso),
    .spi2_sdo_i (spi2_mosi),
    .spi2_sdo_o (spi2_mosi),
    .sys_clk_clk_n (sys_clk_n),
    .sys_clk_clk_p (sys_clk_p),
    .sys_rst (sys_rst),
    .tx_data_n (tx_data_n),
    .tx_data_p (tx_data_p),
    .tx_ref_clk (tx_ref_clk),
    .tx_sync (tx_sync),
    .tx_sysref (tx_sysref));

endmodule

// ***************************************************************************
// ***************************************************************************
