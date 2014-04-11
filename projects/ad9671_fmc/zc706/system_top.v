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
  rx_sync_p,
  rx_sync_n,
  rx_data_p,
  rx_data_n,

  spi_ad9671_csn,
  spi_ad9671_clk,
  spi_ad9671_sdio,
  spi_ad9516_csn,
  spi_ad9516_clk,
  spi_ad9516_sdio,
  spi_ad9553_csn,
  spi_ad9553_clk,
  spi_ad9553_sdio,

  reset_ad9516,
  reset_ad9671,
  trig,
  prci_sck,
  prci_cnv,
  prci_sdo,
  prcq_sck,
  prcq_cnv,
  prcq_sdo);

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
  output          rx_sysref_p;
  output          rx_sysref_n;
  output          rx_sync_p;
  output          rx_sync_n;
  input   [ 3:0]  rx_data_p;
  input   [ 3:0]  rx_data_n;

  output          spi_ad9671_csn;
  output          spi_ad9671_clk;
  inout           spi_ad9671_sdio;
  output          spi_ad9516_csn;
  output          spi_ad9516_clk;
  inout           spi_ad9516_sdio;
  output          spi_ad9553_csn;
  output          spi_ad9553_clk;
  inout           spi_ad9553_sdio;

  inout           reset_ad9516;
  inout           reset_ad9671;
  inout           trig;
  inout           prci_sck;
  inout           prci_cnv;
  inout           prci_sdo;
  inout           prcq_sck;
  inout           prcq_cnv;
  inout           prcq_sdo;

  // internal signals

  wire    [ 2:0]  spi_csn;
  wire            spi_clk;
  wire            spi_mosi;
  wire            spi_miso;
  wire            rx_ref_clk;
  wire            rx_sysref;
  wire            rx_sync;
  wire    [23:0]  gpio_i;
  wire    [23:0]  gpio_o;
  wire    [23:0]  gpio_t;

  // spi

  assign spi_ad9671_csn = spi_csn[0];
  assign spi_ad9516_csn = spi_csn[1];
  assign spi_ad9553_csn = spi_csn[2];
  assign spi_ad9671_clk = spi_clk;
  assign spi_ad9516_clk = spi_clk;
  assign spi_ad9553_clk = spi_clk;

  ad9671_fmc_spi i_spi (
    .spi_ad9671_csn (spi_csn[2]),
    .spi_ad9516_csn (spi_csn[1]),
    .spi_ad9553_csn (spi_csn[0]),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_ad9671_sdio (spi_ad9671_sdio),
    .spi_ad9516_sdio (spi_ad9516_sdio),
    .spi_ad9553_sdio (spi_ad9553_sdio));

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

  // gpio/ctl interface

  IOBUF i_iobuf_gpio_reset_ad9516 (
    .I (gpio_o[23]),
    .O (gpio_i[23]),
    .T (gpio_t[23]),
    .IO (reset_ad9516));

  IOBUF i_iobuf_gpio_reset_ad9671 (
    .I (gpio_o[22]),
    .O (gpio_i[22]),
    .T (gpio_t[22]),
    .IO (reset_ad9671));

  IOBUF i_iobuf_gpio_trig (
    .I (gpio_o[21]),
    .O (gpio_i[21]),
    .T (gpio_t[21]),
    .IO (trig));

  IOBUF i_iobuf_gpio_prci_sck (
    .I (gpio_o[20]),
    .O (gpio_i[20]),
    .T (gpio_t[20]),
    .IO (prci_sck));

  IOBUF i_iobuf_gpio_prci_cnv (
    .I (gpio_o[19]),
    .O (gpio_i[19]),
    .T (gpio_t[19]),
    .IO (prci_cnv));

  IOBUF i_iobuf_gpio_prci_sdo (
    .I (gpio_o[18]),
    .O (gpio_i[18]),
    .T (gpio_t[18]),
    .IO (prci_sdo));

  IOBUF i_iobuf_gpio_prcq_sck (
    .I (gpio_o[17]),
    .O (gpio_i[17]),
    .T (gpio_t[17]),
    .IO (prcq_sck));

  IOBUF i_iobuf_gpio_prcq_cnv (
    .I (gpio_o[16]),
    .O (gpio_i[16]),
    .T (gpio_t[16]),
    .IO (prcq_cnv));

  IOBUF i_iobuf_gpio_prcq_sdo (
    .I (gpio_o[15]),
    .O (gpio_i[15]),
    .T (gpio_t[15]),
    .IO (prcq_sdo));

  genvar n;
  generate
  for (n = 0; n <= 14; n = n + 1) begin: g_iobuf_gpio_bd
  IOBUF i_iobuf_gpio_bd (
    .I (gpio_o[n]),
    .O (gpio_i[n]),
    .T (gpio_t[n]),
    .IO (gpio_bd[n]));
  end
  endgenerate

  system_wrapper i_system_wrapper (
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
    .rx_data_n (rx_data_n),
    .rx_data_p (rx_data_p),
    .rx_ref_clk (rx_ref_clk),
    .rx_sync (rx_sync),
    .rx_sysref (rx_sysref),
    .spdif (spdif),
    .spi_clk_i (spi_clk),
    .spi_clk_o (spi_clk),
    .spi_csn_0_o (spi_csn[0]),
    .spi_csn_1_o (spi_csn[1]),
    .spi_csn_2_o (spi_csn[2]),
    .spi_csn_i (1'b1),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (spi_mosi),
    .spi_sdo_o (spi_mosi));

endmodule

// ***************************************************************************
// ***************************************************************************
