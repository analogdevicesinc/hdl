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

  sys_clk_p,
  sys_clk_n,
  sys_rst,

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
  rx_sync_p,
  rx_sync_n,
  rx_data_p,
  rx_data_n,

  adc_irq,
  adc_fd,
  clk_reset,

  spi_adc_csn,
  spi_adc_clk,
  spi_adc_sdio,
  spi_clk_csn,
  spi_clk_clk,
  spi_clk_sdio);

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

  input           sys_clk_p;
  input           sys_clk_n;
  input           sys_rst;

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
  output          rx_sysref_p;
  output          rx_sysref_n;
  output          rx_sync_p;
  output          rx_sync_n;
  input   [ 7:0]  rx_data_p;
  input   [ 7:0]  rx_data_n;

  inout           adc_irq;
  inout           adc_fd;
  inout           clk_reset;

  output          spi_adc_csn;
  output          spi_adc_clk;
  inout           spi_adc_sdio;
  output          spi_clk_csn;
  output          spi_clk_clk;
  inout           spi_clk_sdio;

  // internal signals

  wire    [17:0]  gpio_i;
  wire    [17:0]  gpio_o;
  wire    [17:0]  gpio_t;
  wire            rx_ref_clk;
  wire            rx_sysref;
  wire            rx_sync;
  wire            spi_clk;
  wire            spi_miso;
  wire            spi_mosi;
  wire    [15:0]  ps_intrs;

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

  ad_iobuf #(.DATA_WIDTH(18)) i_iobuf (
    .dt (gpio_t),
    .di (gpio_o),
    .do (gpio_i),
    .dio ({ clk_reset,  // 17
            adc_irq,    // 16
            adc_fd,     // 15
            gpio_bd})); //  0

  assign spi_adc_clk = spi_clk;
  assign spi_clk_clk = spi_clk;

  fmcadc2_spi i_fmcadc2_spi (
    .spi_adc_csn (spi_adc_csn),
    .spi_clk_csn (spi_clk_csn),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_adc_sdio (spi_adc_sdio),
    .spi_clk_sdio (spi_clk_sdio));

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
    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .ps_intr_0 (ps_intrs[0]),
    .ps_intr_1 (ps_intrs[1]),
    .ps_intr_10 (ps_intrs[10]),
    .ps_intr_11 (ps_intrs[11]),
    .ps_intr_12 (ps_intrs[12]),
    .ps_intr_2 (ps_intrs[2]),
    .ps_intr_3 (ps_intrs[3]),
    .ps_intr_4 (ps_intrs[4]),
    .ps_intr_5 (ps_intrs[5]),
    .ps_intr_6 (ps_intrs[6]),
    .ps_intr_7 (ps_intrs[7]),
    .ps_intr_8 (ps_intrs[8]),
    .ps_intr_9 (ps_intrs[9]),
    .rx_data_n (rx_data_n),
    .rx_data_p (rx_data_p),
    .rx_ref_clk (rx_ref_clk),
    .rx_sync (rx_sync),
    .rx_sysref (rx_sysref),
    .spdif (spdif),
    .spi_clk_i (1'b0),
    .spi_clk_o (spi_clk),
    .spi_csn_i (1'b1),
    .spi_csn_0_o (spi_adc_csn),
    .spi_csn_1_o (spi_clk_csn),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (1'b0),
    .spi_sdo_o (spi_mosi),
    .sys_clk_clk_n (sys_clk_n),
    .sys_clk_clk_p (sys_clk_p),
    .sys_rst (sys_rst));

endmodule

// ***************************************************************************
// ***************************************************************************
