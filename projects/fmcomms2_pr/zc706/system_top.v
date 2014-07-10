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

  wire    [48:0]  gpio_i;
  wire    [48:0]  gpio_o;
  wire    [48:0]  gpio_t;
  wire    [16:0]  gpio_wire;

  wire            clk;
  wire            dma_dac_dunf;
  wire            core_dac_dunf;
  wire    [63:0]  dma_dac_ddata;
  wire    [63:0]  core_dac_ddata;
  wire            dma_dac_drd;
  wire            core_dac_drd;

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

  // instantiations
  ad_iobuf #(.DATA_WIDTH(49)) i_iobuf_gpio_ps7 (
    .dt (gpio_t[48:0]),
    .di (gpio_o[48:0]),
    .do (gpio_i[48:0]),
    .dio ({ gpio_txnrx,   // 48
            gpio_enable,  // 47
            gpio_resetb,  // 46
            gpio_sync,    // 45
            gpio_en_agc,  // 44
            gpio_ctl,     // 40
            gpio_status,  // 32
            gpio_wire,    // 15
            gpio_bd}));   // 0

  prcfg_system_top i_prcfg_system_top (
    .clk(clk),
    .adc_gpio_input(adc_gpio_input),
    .adc_gpio_output(adc_gpio_output),
    .dac_gpio_input(dac_gpio_input),
    .dac_gpio_output(dac_gpio_output),
    .dma_dac_drd(dma_dac_drd),
    .dma_dac_dunf(dma_dac_dunf),
    .dma_dac_ddata(dma_dac_ddata),
    .core_dac_drd(core_dac_drd),
    .core_dac_dunf(core_dac_dunf),
    .core_dac_ddata(core_dac_ddata),
    .core_adc_dwr(core_adc_dwr),
    .core_adc_dsync(core_adc_dsync),
    .core_adc_ddata(core_adc_ddata),
    .core_adc_ovf(core_adc_ovf),
    .dma_adc_dwr(dma_adc_dwr),
    .dma_adc_dsync(dma_adc_dsync),
    .dma_adc_ddata(dma_adc_ddata),
    .dma_adc_ovf(dma_adc_ovf));

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

    .rx_clk_in_n (rx_clk_in_n),
    .rx_clk_in_p (rx_clk_in_p),
    .rx_data_in_n (rx_data_in_n),
    .rx_data_in_p (rx_data_in_p),
    .rx_frame_in_n (rx_frame_in_n),
    .rx_frame_in_p (rx_frame_in_p),

    .spdif (spdif),

    .spi_csn_i (1'b1),
    .spi_csn_o (spi_csn),
    .spi_miso_i (spi_miso),
    .spi_mosi_i (1'b0),
    .spi_mosi_o (spi_mosi),
    .spi_sclk_i (1'b0),
    .spi_sclk_o (spi_clk),

    .tx_clk_out_n (tx_clk_out_n),
    .tx_clk_out_p (tx_clk_out_p),
    .tx_data_out_n (tx_data_out_n),
    .tx_data_out_p (tx_data_out_p),
    .tx_frame_out_n (tx_frame_out_n),
    .tx_frame_out_p (tx_frame_out_p),
    // pr related ports
    .clk(clk),

    .dma_dac_drd(dma_dac_drd),
    .dma_dac_dunf(dma_dac_dunf),
    .dma_dac_ddata(dma_dac_ddata),
    .core_dac_drd(core_dac_drd),
    .core_dac_dunf(core_dac_dunf),
    .core_dac_ddata(core_dac_ddata),

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
  output                dma_dac_drd,
  input                 dma_dac_dunf,
  input       [63:0]    dma_dac_ddata,
  input                 core_dac_drd,
  output                core_dac_dunf,
  output      [63:0]    core_dac_ddata,
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
