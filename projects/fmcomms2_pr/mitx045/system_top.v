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

  i2s_mclk,
  i2s_bclk,
  i2s_lrclk,
  i2s_sdata_out,
  i2s_sdata_in,

  iic_scl,
  iic_sda,

  rx_clk_in_p,
  rx_clk_in_n,
  rx_frame_in_p,
  rx_frame_in_n,
  rx_data_in_p,
  rx_data_in_n,
  tx_clk_out_p,
  tx_clk_out_n,
  tx_frame_out_p,
  tx_frame_out_n,
  tx_data_out_p,
  tx_data_out_n,

  gpio_txnrx,
  gpio_enable,
  gpio_resetb,
  gpio_sync,
  gpio_en_agc,
  gpio_ctl,
  gpio_status,

  spi_csn,
  spi_clk,
  spi_mosi,
  spi_miso);

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

  inout   [11:0]  gpio_bd;

  output          hdmi_out_clk;
  output          hdmi_vsync;
  output          hdmi_hsync;
  output          hdmi_data_e;
  output  [15:0]  hdmi_data;

  output          spdif;

  output          i2s_mclk;
  output          i2s_bclk;
  output          i2s_lrclk;
  output          i2s_sdata_out;
  input           i2s_sdata_in;

  inout           iic_scl;
  inout           iic_sda;

  input           rx_clk_in_p;
  input           rx_clk_in_n;
  input           rx_frame_in_p;
  input           rx_frame_in_n;
  input   [ 5:0]  rx_data_in_p;
  input   [ 5:0]  rx_data_in_n;
  output          tx_clk_out_p;
  output          tx_clk_out_n;
  output          tx_frame_out_p;
  output          tx_frame_out_n;
  output  [ 5:0]  tx_data_out_p;
  output  [ 5:0]  tx_data_out_n;

  inout           gpio_txnrx;
  inout           gpio_enable;
  inout           gpio_resetb;
  inout           gpio_sync;
  inout           gpio_en_agc;
  inout   [ 3:0]  gpio_ctl;
  inout   [ 7:0]  gpio_status;

  output          spi_csn;
  output          spi_clk;
  output          spi_mosi;
  input           spi_miso;

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;

  wire            clk;
  wire            dma_dac_dunf;
  wire            core_dac_dunf;
  wire    [63:0]  dma_dac_ddata;
  wire    [63:0]  core_dac_ddata;
  wire            dma_dac_en;
  wire            core_dac_en;
  wire            dma_dac_dvalid;
  wire            core_dac_dvalid;

  wire            dma_adc_ovf;
  wire            core_adc_ovf;
  wire    [63:0]  dma_adc_ddata;
  wire    [63:0]  core_adc_ddata;
  wire            dma_adc_dwr;
  wire            core_adc_dwr;
  wire            dma_adc_dsync;
  wire            core_adc_dsync;

  // PR GPIOs
  wire    [31:0]  adc_gpio_input;
  wire    [31:0]  adc_gpio_output;
  wire    [31:0]  dac_gpio_input;
  wire    [31:0]  dac_gpio_output;

  ad_iobuf #(.DATA_WIDTH(29)) i_iobuf (
    .dio_t ({gpio_t[48:32], gpio_t[11:0]}),
    .dio_i ({gpio_o[48:32], gpio_o[11:0]}),
    .dio_o ({gpio_i[48:32], gpio_i[11:0]}),
    .dio_p ({ gpio_txnrx,   // 48
              gpio_enable,  // 47
              gpio_resetb,  // 46
              gpio_sync,    // 45
              gpio_en_agc,  // 44
              gpio_ctl,     // 40
              gpio_status,  // 32
              gpio_bd}));   // 0

  prcfg_system_top i_prcfg_system_top (
    .clk(clk),
    .adc_gpio_input(adc_gpio_input),
    .adc_gpio_output(adc_gpio_output),
    .dac_gpio_input(dac_gpio_input),
    .dac_gpio_output(dac_gpio_output),
    .dma_dac_en(dma_dac_en),
    .dma_dac_dunf(dma_dac_dunf),
    .dma_dac_ddata(dma_dac_ddata),
    .dma_dac_dvalid(dma_dac_dvalid),
    .core_dac_en(core_dac_en),
    .core_dac_dunf(core_dac_dunf),
    .core_dac_ddata(core_dac_ddata),
    .core_dac_dvalid(core_dac_dvalid),
    .core_adc_dwr(core_adc_dwr),
    .core_adc_dsync(core_adc_dsync),
    .core_adc_ddata(core_adc_ddata),
    .core_adc_ovf(core_adc_ovf),
    .dma_adc_dwr(dma_adc_dwr),
    .dma_adc_dsync(dma_adc_dsync),
    .dma_adc_ddata(dma_adc_ddata),
    .dma_adc_ovf(dma_adc_ovf));

  system_wrapper i_system_wrapper (
    .DDR_addr (ddr_addr),
    .DDR_ba (ddr_ba),
    .DDR_cas_n (ddr_cas_n),
    .DDR_ck_n (ddr_ck_n),
    .DDR_ck_p (ddr_ck_p),
    .DDR_cke (ddr_cke),
    .DDR_cs_n (ddr_cs_n),
    .DDR_dm (ddr_dm),
    .DDR_dq (ddr_dq),
    .DDR_dqs_n (ddr_dqs_n),
    .DDR_dqs_p (ddr_dqs_p),
    .DDR_odt (ddr_odt),
    .DDR_ras_n (ddr_ras_n),
    .DDR_reset_n (ddr_reset_n),
    .DDR_we_n (ddr_we_n),
    .FIXED_IO_ddr_vrn (fixed_io_ddr_vrn),
    .FIXED_IO_ddr_vrp (fixed_io_ddr_vrp),
    .FIXED_IO_mio (fixed_io_mio),
    .FIXED_IO_ps_clk (fixed_io_ps_clk),
    .FIXED_IO_ps_porb (fixed_io_ps_porb),
    .FIXED_IO_ps_srstb (fixed_io_ps_srstb),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .i2s_bclk (i2s_bclk),
    .i2s_lrclk (i2s_lrclk),
    .i2s_mclk (i2s_mclk),
    .i2s_sdata_in (i2s_sdata_in),
    .i2s_sdata_out (i2s_sdata_out),
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
    .rx_clk_in_n (rx_clk_in_n),
    .rx_clk_in_p (rx_clk_in_p),
    .rx_data_in_n (rx_data_in_n),
    .rx_data_in_p (rx_data_in_p),
    .rx_frame_in_n (rx_frame_in_n),
    .rx_frame_in_p (rx_frame_in_p),
    .spdif (spdif),
    .spi0_csn_i (1'b1),
    .spi0_csn_0_o (spi_csn),
    .spi0_sdi_i (spi_miso),
    .spi0_sdo_i (1'b0),
    .spi0_sdo_o (spi_mosi),
    .spi0_clk_i (1'b0),
    .spi0_clk_o (spi_clk),
    .tx_clk_out_n (tx_clk_out_n),
    .tx_clk_out_p (tx_clk_out_p),
    .tx_data_out_n (tx_data_out_n),
    .tx_data_out_p (tx_data_out_p),
    .tx_frame_out_n (tx_frame_out_n),
    .tx_frame_out_p (tx_frame_out_p),
    // pr related ports
    .clk(clk),
    .dma_dac_en(dma_dac_en),
    .dma_dac_dunf(dma_dac_dunf),
    .dma_dac_ddata(dma_dac_ddata),
    .dma_dac_dvalid(dma_dac_dvalid),
    .core_dac_en(core_dac_en),
    .core_dac_dunf(core_dac_dunf),
    .core_dac_ddata(core_dac_ddata),
    .core_dac_dvalid(core_dac_dvalid),
    .core_adc_dwr(core_adc_dwr),
    .core_adc_dsync(core_adc_dsync),
    .core_adc_ddata(core_adc_ddata),
    .core_adc_ovf(core_adc_ovf),
    .dma_adc_dwr(dma_adc_dwr),
    .dma_adc_dsync(dma_adc_dsync),
    .dma_adc_ddata(dma_adc_ddata),
    .dma_adc_ovf(dma_adc_ovf),
    .up_dac_gpio_in(dac_gpio_output),
    .up_adc_gpio_in(adc_gpio_output),
    .up_dac_gpio_out(dac_gpio_input),
    .up_adc_gpio_out(adc_gpio_input));

endmodule

// black box definition for PR module
(* black_box *) module prcfg_system_top (
  input                 clk,
  input       [31:0]    adc_gpio_input,
  output      [31:0]    adc_gpio_output,
  input       [31:0]    dac_gpio_input,
  output      [31:0]    dac_gpio_output,
  output                dma_dac_en,
  input                 dma_dac_dunf,
  input       [63:0]    dma_dac_ddata,
  input                 dma_dac_dvalid,
  input                 core_dac_en,
  output                core_dac_dunf,
  output      [63:0]    core_dac_ddata,
  output                core_dac_dvalid,
  input                 core_adc_dwr,
  input                 core_adc_dsync,
  input       [63:0]    core_adc_ddata,
  output                core_adc_ovf,
  output                dma_adc_dwr,
  output                dma_adc_dsync,
  output      [63:0]    dma_adc_ddata,
  input                 dma_adc_ovf);

endmodule

// ***************************************************************************
// ***************************************************************************
