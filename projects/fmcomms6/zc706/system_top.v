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

  adc_clk_in_p,
  adc_clk_in_n,
  adc_or_in_p,
  adc_or_in_n,
  adc_data_in_p,
  adc_data_in_n,

  spi_adf4351_csn,
  spi_ad9652_csn,
  spi_ad9517_csn,
  spi_clk,
  spi_sdio,
  adf4351_ld);

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

  input           adc_clk_in_p;
  input           adc_clk_in_n;
  input           adc_or_in_p;
  input           adc_or_in_n;
  input   [15:0]  adc_data_in_p;
  input   [15:0]  adc_data_in_n;

  output          spi_adf4351_csn;
  output          spi_ad9652_csn;
  output          spi_ad9517_csn;
  output          spi_clk;
  inout           spi_sdio;
  inout           adf4351_ld;

  // internal registers

  reg             adc_dwr = 'd0;
  reg     [31:0]  adc_ddata = 'd0;

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire    [ 2:0]  spi0_csn;
  wire            spi0_clk;
  wire            spi0_mosi;
  wire            spi0_miso;
  wire    [ 2:0]  spi1_csn;
  wire            spi1_clk;
  wire            spi1_mosi;
  wire            spi1_miso;
  wire            adc_clk;
  wire            adc_valid_0;
  wire            adc_enable_0;
  wire    [15:0]  adc_data_0;
  wire            adc_valid_1;
  wire            adc_enable_1;
  wire    [15:0]  adc_data_1;

  // pack-unpack place holder

  always @(posedge adc_clk) begin
    case ({adc_enable_1, adc_enable_0})
      2'b10: begin
        adc_dwr <= ~adc_dwr;
        adc_ddata <= {adc_data_1, adc_ddata[31:16]};
      end
      2'b01: begin
        adc_dwr <= ~adc_dwr;
        adc_ddata <= {adc_data_0, adc_ddata[31:16]};
      end
      default: begin
        adc_dwr <= 1'b1;
        adc_ddata <= {adc_data_1, adc_data_0};
      end
    endcase
  end

  // spi

  assign spi_clk = spi0_clk;
  assign spi_ad9517_csn = spi0_csn[0];
  assign spi_ad9652_csn = spi0_csn[1];
  assign spi_adf4351_csn = spi0_csn[2];

  // instantiations

  fmcomms6_spi i_spi (
    .spi_csn (spi0_csn),
    .spi_clk (spi0_clk),
    .spi_mosi (spi0_mosi),
    .spi_miso (spi0_miso),
    .spi_sdio (spi_sdio));

  ad_iobuf #(.DATA_WIDTH(1)) i_iobuf (
    .dio_t (gpio_t[32]),
    .dio_i (gpio_o[32]),
    .dio_o (gpio_i[32]),
    .dio_p (adf4351_ld));

  ad_iobuf #(.DATA_WIDTH(15)) i_iobuf_bd (
    .dio_t (gpio_t[14:0]),
    .dio_i (gpio_o[14:0]),
    .dio_o (gpio_i[14:0]),
    .dio_p (gpio_bd));

  system_wrapper i_system_wrapper (
    .adc_clk (adc_clk),
    .adc_clk_in_n (adc_clk_in_n),
    .adc_clk_in_p (adc_clk_in_p),
    .adc_data_0 (adc_data_0),
    .adc_data_1 (adc_data_1),
    .adc_data_in_n (adc_data_in_n),
    .adc_data_in_p (adc_data_in_p),
    .adc_ddata (adc_ddata),
    .adc_dwr (adc_dwr),
    .adc_enable_0 (adc_enable_0),
    .adc_enable_1 (adc_enable_1),
    .adc_or_in_n (adc_or_in_n),
    .adc_or_in_p (adc_or_in_p),
    .adc_valid_0 (adc_valid_0),
    .adc_valid_1 (adc_valid_1),
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
    .ps_intr_12 (1'b0),
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
    .spi1_sdo_o (spi1_mosi));

endmodule

// ***************************************************************************
// ***************************************************************************
