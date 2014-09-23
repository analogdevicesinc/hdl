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

  tx_ref_clk_p,
  tx_ref_clk_n,
  tx_clk_p,
  tx_clk_n,
  tx_frame_p,
  tx_frame_n,
  tx_data_p,
  tx_data_n,

  gpio_adc_fdb,
  gpio_adc_fda,
  gpio_dac_irqn,
  gpio_clkd_status,

  gpio_clkd_pdn,
  gpio_clkd_syncn,
  gpio_resetn,

  spi_csn_clk,
  spi_csn_dac,
  spi_csn_adc,
  spi_clk,
  spi_sdio);

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
  output          rx_sync_p;
  output          rx_sync_n;
  input   [ 1:0]  rx_data_p;
  input   [ 1:0]  rx_data_n;

  input           tx_ref_clk_p;
  input           tx_ref_clk_n;
  output          tx_clk_p;
  output          tx_clk_n;
  output          tx_frame_p;
  output          tx_frame_n;
  output  [15:0]  tx_data_p;
  output  [15:0]  tx_data_n;

  inout           gpio_adc_fdb;
  inout           gpio_adc_fda;
  inout           gpio_dac_irqn;
  inout   [ 1:0]  gpio_clkd_status;

  inout           gpio_clkd_pdn;
  inout           gpio_clkd_syncn;
  inout           gpio_resetn;

  output          spi_csn_clk;
  output          spi_csn_dac;
  output          spi_csn_adc;
  output          spi_clk;
  inout           spi_sdio;

  // internal registers

  reg             dac_drd = 'd0;
  reg    [63:0]   dac_ddata_0 = 'd0;
  reg    [63:0]   dac_ddata_1 = 'd0;
  reg             adc_dwr    = 'd0;
  reg    [63:0]   adc_ddata  = 'd0;

  // internal signals

  wire    [39:0]  gpio_i;
  wire    [39:0]  gpio_o;
  wire    [39:0]  gpio_t;
  wire            rx_ref_clk;
  wire            rx_sysref;
  wire            rx_sync;
  wire    [ 2:0]  spi_csn;
  wire            adc_clk;
  wire    [31:0]  adc_data_a;
  wire    [31:0]  adc_data_b;
  wire            adc_enable_a;
  wire            adc_enable_b;
  wire            dac_clk;
  wire   [127:0]  dac_ddata;
  wire            dac_enable_0;
  wire            dac_enable_1;

  // pack & unpack data

  always @(posedge dac_clk) begin
    case ({dac_enable_1, dac_enable_0})
      2'b11: begin
        dac_drd <= 1'b1;
        dac_ddata_1[63:48] <= dac_ddata[127:112];
        dac_ddata_1[47:32] <= dac_ddata[ 95: 80];
        dac_ddata_1[31:16] <= dac_ddata[ 63: 48];
        dac_ddata_1[15: 0] <= dac_ddata[ 31: 16];
        dac_ddata_0[63:48] <= dac_ddata[111: 96];
        dac_ddata_0[47:32] <= dac_ddata[ 79: 64];
        dac_ddata_0[31:16] <= dac_ddata[ 47: 32];
        dac_ddata_0[15: 0] <= dac_ddata[ 15:  0];
      end
      2'b01: begin
        dac_drd <= ~dac_drd;
        dac_ddata_1 <= 64'd0;
        dac_ddata_0 <= (dac_drd == 1'b1) ? dac_ddata[127:64] : dac_ddata[63:0];
      end
      2'b10: begin
        dac_drd <= ~dac_drd;
        dac_ddata_1 <= (dac_drd == 1'b1) ? dac_ddata[127:64] : dac_ddata[63:0];
        dac_ddata_0 <= 64'd0;
      end
      default: begin
        dac_drd <= 1'b0;
        dac_ddata_1 <= 64'd0;
        dac_ddata_0 <= 64'd0;
      end
    endcase
  end

  always @(posedge adc_clk) begin
    case ({adc_enable_b, adc_enable_a})
      2'b11: begin
        adc_dwr <= 1'b1;
        adc_ddata[63:48] <= adc_data_b[31:16];
        adc_ddata[47:32] <= adc_data_a[31:16];
        adc_ddata[31:16] <= adc_data_b[15: 0];
        adc_ddata[15: 0] <= adc_data_a[15: 0];
      end
      2'b10: begin
        adc_dwr <= ~adc_dwr;
        adc_ddata[63:48] <= adc_data_b[31:16];
        adc_ddata[47:32] <= adc_data_b[15: 0];
        adc_ddata[31:16] <= adc_ddata[63:48];
        adc_ddata[15: 0] <= adc_ddata[47:32];
      end
      2'b01: begin
        adc_dwr <= ~adc_dwr;
        adc_ddata[63:48] <= adc_data_a[31:16];
        adc_ddata[47:32] <= adc_data_a[15: 0];
        adc_ddata[31:16] <= adc_ddata[63:48];
        adc_ddata[15: 0] <= adc_ddata[47:32];
      end
      default: begin
        adc_dwr <= 1'b0;
        adc_ddata[63:48] <= 16'd0;
        adc_ddata[47:32] <= 16'd0;
        adc_ddata[31:16] <= 16'd0;
        adc_ddata[15: 0] <= 16'd0;
      end
    endcase
  end

  // instantiations

  assign spi_csn_adc = spi_csn[2];
  assign spi_csn_dac = spi_csn[1];
  assign spi_csn_clk = spi_csn[0];

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

  daq1_spi i_spi (
    .spi_csn (spi_csn),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio));

  ad_iobuf #(.DATA_WIDTH(23)) i_iobuf (
    .dt({gpio_t[39:32], gpio_t[14:0]}),
    .di({gpio_o[39:32], gpio_o[14:0]}),
    .do({gpio_i[39:32], gpio_i[14:0]}),
    .dio({gpio_adc_fdb,     // 39
          gpio_adc_fda,     // 38
          gpio_dac_irqn,    // 37
          gpio_clkd_status, // 36:35
          gpio_clkd_pdn,    // 34
          gpio_clkd_syncn,  // 33
          gpio_resetn,      // 32
          gpio_bd}));       // 14:0

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
    .adc_clk (adc_clk),
    .adc_data_a (adc_data_a),
    .adc_data_b (adc_data_b),
    .adc_ddata (adc_ddata),
    .adc_dsync (1'b1),
    .adc_dwr (adc_dwr),
    .adc_enable_a (adc_enable_a),
    .adc_enable_b (adc_enable_b),
    .adc_valid_a (),
    .adc_valid_b (),
    .dac_clk (dac_clk),
    .dac_ddata (dac_ddata),
    .dac_ddata_0 (dac_ddata_0),
    .dac_ddata_1 (dac_ddata_1),
    .dac_drd (dac_drd),
    .dac_enable_0 (dac_enable_0),
    .dac_enable_1 (dac_enable_1),
    .dac_valid_0 (),
    .dac_valid_1 (),
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
    .spi_csn_i (spi_csn),
    .spi_csn_o (spi_csn),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (spi_mosi),
    .spi_sdo_o (spi_mosi),
    .tx_clk_n (tx_clk_n),
    .tx_clk_p (tx_clk_p),
    .tx_data_n (tx_data_n),
    .tx_data_p (tx_data_p),
    .tx_frame_n (tx_frame_n),
    .tx_frame_p (tx_frame_p),
    .tx_ref_clk_n (tx_ref_clk_n),
    .tx_ref_clk_p (tx_ref_clk_p));

endmodule

// ***************************************************************************
// ***************************************************************************
