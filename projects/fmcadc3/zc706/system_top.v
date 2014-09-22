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

  sys_clk_p,
  sys_clk_n,

  DDR3_addr,
  DDR3_ba,
  DDR3_cas_n,
  DDR3_ck_n,
  DDR3_ck_p,
  DDR3_cke,
  DDR3_cs_n,
  DDR3_dm,
  DDR3_dq,
  DDR3_dqs_n,
  DDR3_dqs_p,
  DDR3_odt,
  DDR3_ras_n,
  DDR3_reset_n,
  DDR3_we_n,

  DDR_addr,
  DDR_ba,
  DDR_cas_n,
  DDR_ck_n,
  DDR_ck_p,
  DDR_cke,
  DDR_cs_n,
  DDR_dm,
  DDR_dq,
  DDR_dqs_n,
  DDR_dqs_p,
  DDR_odt,
  DDR_ras_n,
  DDR_reset_n,
  DDR_we_n,

  FIXED_IO_ddr_vrn,
  FIXED_IO_ddr_vrp,
  FIXED_IO_mio,
  FIXED_IO_ps_clk,
  FIXED_IO_ps_porb,
  FIXED_IO_ps_srstb,

  gpio_bd,

  hdmi_out_clk,
  hdmi_vsync,
  hdmi_hsync,
  hdmi_data_e,
  hdmi_data,
  
  spdif,

  iic_scl,
  iic_sda,

  rx_ref_clk_p,
  rx_ref_clk_n,
  rx_sysref_p,
  rx_sysref_n,
  rx_sync_0_p,
  rx_sync_0_n,
  rx_sync_1_p,
  rx_sync_1_n,
  rx_data_p,
  rx_data_n,
  
  ad9528_rstn,
  ad9528_status,
  ad9234_1_fda;
  ad9234_1_fdb;
  ad9234_2_fda;
  ad9234_2_fdb;
 
  ad9528_csn,
  ada4961_1a_csn,
  ada4961_1b_csn,
  ad9234_1_csn,
  ada4961_2a_csn,
  ada4961_2b_csn,
  ad9234_2_csn,
  spi_clk,
  spi_sdio);

  input           sys_clk_p;
  input           sys_clk_n;

  output  [13:0]  DDR3_addr;
  output  [ 2:0]  DDR3_ba;
  output          DDR3_cas_n;
  output  [ 0:0]  DDR3_ck_n;
  output  [ 0:0]  DDR3_ck_p;
  output  [ 0:0]  DDR3_cke;
  output  [ 0:0]  DDR3_cs_n;
  output  [ 7:0]  DDR3_dm;
  inout   [63:0]  DDR3_dq;
  inout   [ 7:0]  DDR3_dqs_n;
  inout   [ 7:0]  DDR3_dqs_p;
  output  [ 0:0]  DDR3_odt;
  output          DDR3_ras_n;
  output          DDR3_reset_n;
  output          DDR3_we_n;

  inout   [14:0]  DDR_addr;
  inout   [ 2:0]  DDR_ba;
  inout           DDR_cas_n;
  inout           DDR_ck_n;
  inout           DDR_ck_p;
  inout           DDR_cke;
  inout           DDR_cs_n;
  inout   [ 3:0]  DDR_dm;
  inout   [31:0]  DDR_dq;
  inout   [ 3:0]  DDR_dqs_n;
  inout   [ 3:0]  DDR_dqs_p;
  inout           DDR_odt;
  inout           DDR_ras_n;
  inout           DDR_reset_n;
  inout           DDR_we_n;

  inout           FIXED_IO_ddr_vrn;
  inout           FIXED_IO_ddr_vrp;
  inout   [53:0]  FIXED_IO_mio;
  inout           FIXED_IO_ps_clk;
  inout           FIXED_IO_ps_porb;
  inout           FIXED_IO_ps_srstb;

  inout   [14:0]  gpio_bd;

  output          hdmi_out_clk;
  output          hdmi_vsync;
  output          hdmi_hsync;
  output          hdmi_data_e;
  output  [23:0]  hdmi_data;
  
  output          spdif;

  inout           iic_scl;
  inout           iic_sda;

  input           rx_ref_clk_p;
  input           rx_ref_clk_n;
  input           rx_sysref_p;
  input           rx_sysref_n;
  output          rx_sync_0_p;
  output          rx_sync_0_n;
  output          rx_sync_1_p;
  output          rx_sync_1_n;
  input   [ 7:0]  rx_data_p;
  input   [ 7:0]  rx_data_n;
  
  inout           ad9528_rstn;
  inout           ad9528_status;
  inout           ad9234_1_fda;
  inout           ad9234_1_fdb;
  inout           ad9234_2_fda;
  inout           ad9234_2_fdb;
  
  output          ad9528_csn;
  output          ada4961_1a_csn;
  output          ada4961_1b_csn;
  output          ad9234_1_csn;
  output          ada4961_2a_csn;
  output          ada4961_2b_csn;
  output          ad9234_2_csn;
  output          spi_clk;
  inout           spi_sdio;

  // internal registers

  reg     [ 1:0]  adc_dcnt = 'd0;
  reg             adc_dsync = 'd0;
  reg             adc_dwr = 'd0;
  reg    [255:0]  adc_ddata = 'd0;
  
  // internal signals

  wire    [37:0]  gpio_i;
  wire    [37:0]  gpio_o;
  wire    [37:0]  gpio_t;
  wire            rx_ref_clk;
  wire            rx_sysref;
  wire            rx_sync;
  wire            spi_mosi;
  wire            spi_miso;
  wire            adc_clk;
  wire    [63:0]  adc_data_0;
  wire    [63:0]  adc_data_1;
  wire    [63:0]  adc_data_2;
  wire    [63:0]  adc_data_3;
  wire            adc_enable_0;
  wire            adc_enable_1;
  wire            adc_enable_2;
  wire            adc_enable_3;
  wire            adc_valid_0;
  wire            adc_valid_1;
  wire            adc_valid_2;
  wire            adc_valid_3;
  wire   [255:0]  gt_data;

  // adc-pack place holder

  always @(posedge adc_clk) begin
    adc_dcnt <= adc_dcnt + 1'b1;
    case ({adc_enable_3, adc_enable_2, adc_enable_1, adc_enable_0})
      4'b1111: begin
        adc_dsync <= 1'b1;
        adc_dwr <= adc_valid_3 & adc_valid_2 & adc_valid_1 & adc_valid_0;
        adc_ddata[255:240] <= adc_data_3[63:48];
        adc_ddata[239:224] <= adc_data_2[63:48];
        adc_ddata[223:208] <= adc_data_1[63:48];
        adc_ddata[207:192] <= adc_data_0[63:48];
        adc_ddata[191:176] <= adc_data_3[47:32];
        adc_ddata[175:160] <= adc_data_2[47:32];
        adc_ddata[159:144] <= adc_data_1[47:32];
        adc_ddata[143:128] <= adc_data_0[47:32];
        adc_ddata[127:112] <= adc_data_3[31:16];
        adc_ddata[111: 96] <= adc_data_2[31:16];
        adc_ddata[ 95: 80] <= adc_data_1[31:16];
        adc_ddata[ 79: 64] <= adc_data_0[31:16];
        adc_ddata[ 63: 48] <= adc_data_3[15: 0];
        adc_ddata[ 47: 32] <= adc_data_2[15: 0];
        adc_ddata[ 31: 16] <= adc_data_1[15: 0];
        adc_ddata[ 15:  0] <= adc_data_0[15: 0];
      end
      4'b0001: begin
        adc_dsync <= 1'b1;
        adc_dwr <= adc_valid_0 & adc_dcnt[0] & adc_dcnt[1];
        adc_ddata[255:240] <= adc_data_0[63:48];
        adc_ddata[239:224] <= adc_data_0[47:32];
        adc_ddata[223:208] <= adc_data_0[31:16];
        adc_ddata[207:192] <= adc_data_0[15: 0];
        adc_ddata[191:176] <= adc_ddata[255:240];
        adc_ddata[175:160] <= adc_ddata[239:224];
        adc_ddata[159:144] <= adc_ddata[223:208];
        adc_ddata[143:128] <= adc_ddata[207:192];
        adc_ddata[127:112] <= adc_ddata[191:176];
        adc_ddata[111: 96] <= adc_ddata[175:160];
        adc_ddata[ 95: 80] <= adc_ddata[159:144];
        adc_ddata[ 79: 64] <= adc_ddata[143:128];
        adc_ddata[ 63: 48] <= adc_ddata[127:112];
        adc_ddata[ 47: 32] <= adc_ddata[111: 96];
        adc_ddata[ 31: 16] <= adc_ddata[ 95: 80];
        adc_ddata[ 15:  0] <= adc_ddata[ 79: 64];
      end
      4'b0010: begin
        adc_dsync <= 1'b1;
        adc_dwr <= adc_valid_1 & adc_dcnt[0] & adc_dcnt[1];
        adc_ddata[255:240] <= adc_data_1[63:48];
        adc_ddata[239:224] <= adc_data_1[47:32];
        adc_ddata[223:208] <= adc_data_1[31:16];
        adc_ddata[207:192] <= adc_data_1[15: 0];
        adc_ddata[191:176] <= adc_ddata[255:240];
        adc_ddata[175:160] <= adc_ddata[239:224];
        adc_ddata[159:144] <= adc_ddata[223:208];
        adc_ddata[143:128] <= adc_ddata[207:192];
        adc_ddata[127:112] <= adc_ddata[191:176];
        adc_ddata[111: 96] <= adc_ddata[175:160];
        adc_ddata[ 95: 80] <= adc_ddata[159:144];
        adc_ddata[ 79: 64] <= adc_ddata[143:128];
        adc_ddata[ 63: 48] <= adc_ddata[127:112];
        adc_ddata[ 47: 32] <= adc_ddata[111: 96];
        adc_ddata[ 31: 16] <= adc_ddata[ 95: 80];
        adc_ddata[ 15:  0] <= adc_ddata[ 79: 64];
      end
      4'b0100: begin
        adc_dsync <= 1'b1;
        adc_dwr <= adc_valid_2 & adc_dcnt[0] & adc_dcnt[1];
        adc_ddata[255:240] <= adc_data_2[63:48];
        adc_ddata[239:224] <= adc_data_2[47:32];
        adc_ddata[223:208] <= adc_data_2[31:16];
        adc_ddata[207:192] <= adc_data_2[15: 0];
        adc_ddata[191:176] <= adc_ddata[255:240];
        adc_ddata[175:160] <= adc_ddata[239:224];
        adc_ddata[159:144] <= adc_ddata[223:208];
        adc_ddata[143:128] <= adc_ddata[207:192];
        adc_ddata[127:112] <= adc_ddata[191:176];
        adc_ddata[111: 96] <= adc_ddata[175:160];
        adc_ddata[ 95: 80] <= adc_ddata[159:144];
        adc_ddata[ 79: 64] <= adc_ddata[143:128];
        adc_ddata[ 63: 48] <= adc_ddata[127:112];
        adc_ddata[ 47: 32] <= adc_ddata[111: 96];
        adc_ddata[ 31: 16] <= adc_ddata[ 95: 80];
        adc_ddata[ 15:  0] <= adc_ddata[ 79: 64];
      end
      4'b1000: begin
        adc_dsync <= 1'b1;
        adc_dwr <= adc_valid_3 & adc_dcnt[0] & adc_dcnt[1];
        adc_ddata[255:240] <= adc_data_3[63:48];
        adc_ddata[239:224] <= adc_data_3[47:32];
        adc_ddata[223:208] <= adc_data_3[31:16];
        adc_ddata[207:192] <= adc_data_3[15: 0];
        adc_ddata[191:176] <= adc_ddata[255:240];
        adc_ddata[175:160] <= adc_ddata[239:224];
        adc_ddata[159:144] <= adc_ddata[223:208];
        adc_ddata[143:128] <= adc_ddata[207:192];
        adc_ddata[127:112] <= adc_ddata[191:176];
        adc_ddata[111: 96] <= adc_ddata[175:160];
        adc_ddata[ 95: 80] <= adc_ddata[159:144];
        adc_ddata[ 79: 64] <= adc_ddata[143:128];
        adc_ddata[ 63: 48] <= adc_ddata[127:112];
        adc_ddata[ 47: 32] <= adc_ddata[111: 96];
        adc_ddata[ 31: 16] <= adc_ddata[ 95: 80];
        adc_ddata[ 15:  0] <= adc_ddata[ 79: 64];
      end
      default: begin
        adc_dsync <= 1'b0;
        adc_dwr <= 1'b0;
        adc_ddata <= 256'd0;
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

  IBUFDS i_ibufds_rx_sysref (
    .I (rx_sysref_p),
    .IB (rx_sysref_n),
    .O (rx_sysref));

  OBUFDS i_obufds_rx_sync_0 (
    .I (rx_sync),
    .O (rx_sync_0_p),
    .OB (rx_sync_0_n));

  OBUFDS i_obufds_rx_sync_1 (
    .I (rx_sync),
    .O (rx_sync_1_p),
    .OB (rx_sync_1_n));

  assign ada4961_1a_csn = 1'b1;
  assign ada4961_1b_csn = 1'b1;
  assign ada4961_2a_csn = 1'b1;
  assign ada4961_2b_csn = 1'b1;

  fmcadc3_spi i_spi (
    .ad9528_csn (ad9528_csn),
    .ad9234_1_csn (ad9234_1_csn),
    .ad9234_2_csn (ad9234_2_csn),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio));

  ad_iobuf #(.DATA_WIDTH(38)) i_iobuf (
    .dt ({gpio_t[37:32], gpio_t[14:0]}),
    .di ({gpio_o[37:32], gpio_o[14:0]}),
    .do ({gpio_i[37:32], gpio_i[14:0]}),
    .dio ({ ad9234_2_fdb,  // 37
            ad9234_2_fda,  // 36
            ad9234_1_fdb,  // 35
            ad9234_1_fda,  // 34
            ad9528_status, // 33
            ad9528_rstn,   // 32
            gpio_bd}));    //  0

  system_wrapper i_system_wrapper (
    .DDR3_addr (DDR3_addr),
    .DDR3_ba (DDR3_ba),
    .DDR3_cas_n (DDR3_cas_n),
    .DDR3_ck_n (DDR3_ck_n),
    .DDR3_ck_p (DDR3_ck_p),
    .DDR3_cke (DDR3_cke),
    .DDR3_cs_n (DDR3_cs_n),
    .DDR3_dm (DDR3_dm),
    .DDR3_dq (DDR3_dq),
    .DDR3_dqs_n (DDR3_dqs_n),
    .DDR3_dqs_p (DDR3_dqs_p),
    .DDR3_odt (DDR3_odt),
    .DDR3_ras_n (DDR3_ras_n),
    .DDR3_reset_n (DDR3_reset_n),
    .DDR3_we_n (DDR3_we_n),
    .DDR_addr (DDR_addr),
    .DDR_ba (DDR_ba),
    .DDR_cas_n (DDR_cas_n),
    .DDR_ck_n (DDR_ck_n),
    .DDR_ck_p (DDR_ck_p),
    .DDR_cke (DDR_cke),
    .DDR_cs_n (DDR_cs_n),
    .DDR_dm (DDR_dm),
    .DDR_dq (DDR_dq),
    .DDR_dqs_n (DDR_dqs_n),
    .DDR_dqs_p (DDR_dqs_p),
    .DDR_odt (DDR_odt),
    .DDR_ras_n (DDR_ras_n),
    .DDR_reset_n (DDR_reset_n),
    .DDR_we_n (DDR_we_n),
    .FIXED_IO_ddr_vrn (FIXED_IO_ddr_vrn),
    .FIXED_IO_ddr_vrp (FIXED_IO_ddr_vrp),
    .FIXED_IO_mio (FIXED_IO_mio),
    .FIXED_IO_ps_clk (FIXED_IO_ps_clk),
    .FIXED_IO_ps_porb (FIXED_IO_ps_porb),
    .FIXED_IO_ps_srstb (FIXED_IO_ps_srstb),
    .GPIO_I (gpio_i),
    .GPIO_O (gpio_o),
    .GPIO_T (gpio_t),
    .adc_clk (adc_clk),
    .adc_data_0 (adc_data_0),
    .adc_data_1 (adc_data_1),
    .adc_data_2 (adc_data_2),
    .adc_data_3 (adc_data_3),
    .adc_ddata (adc_ddata),
    .adc_dsync (adc_dsync),
    .adc_dwr (adc_dwr),
    .adc_enable_0 (adc_enable_0),
    .adc_enable_1 (adc_enable_1),
    .adc_enable_2 (adc_enable_2),
    .adc_enable_3 (adc_enable_3),
    .adc_valid_0 (adc_valid_0),
    .adc_valid_1 (adc_valid_1),
    .adc_valid_2 (adc_valid_2),
    .adc_valid_3 (adc_valid_3),
    .gt_data (gt_data),
    .gt_data_0 (gt_data[127:0]),
    .gt_data_1 (gt_data[255:128]),
    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .rx_data_n (rx_data_n),
    .rx_data_p (rx_data_p),
    .rx_ref_clk (rx_ref_clk),
    .rx_sync (rx_sync),
    .rx_sysref (rx_sysref),
    .spdif (spdif),
    .spi_clk_i (spi_clk),
    .spi_clk_o (spi_clk),
    .spi_csn_0 (ad9528_csn),
    .spi_csn_1 (ad9234_1_csn),
    .spi_csn_2 (ad9234_2_csn),
    .spi_csn_i (1'b1),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (spi_mosi),
    .spi_sdo_o (spi_mosi),
    .sys_clk_clk_n (sys_clk_n),
    .sys_clk_clk_p (sys_clk_p));

endmodule

// ***************************************************************************
// ***************************************************************************
