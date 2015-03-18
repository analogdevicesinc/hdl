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
  rx_sysref,
  rx_sync,
  rx_data_p,
  rx_data_n,

  spi_csn,
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
  output          rx_sysref;
  output          rx_sync;
  input   [ 3:0]  rx_data_p;
  input   [ 3:0]  rx_data_n;

  output          spi_csn;
  output          spi_clk;
  inout           spi_sdio;

  // internal registers

  reg             dma_0_wr = 'd0;
  reg    [63:0]   dma_0_data = 'd0;
  reg             dma_1_wr = 'd0;
  reg    [63:0]   dma_1_data = 'd0;

  // internal signals

  wire    [14:0]  gpio_i;
  wire    [14:0]  gpio_o;
  wire    [14:0]  gpio_t;
  wire            rx_ref_clk;
  wire            spi_miso;
  wire            spi_mosi;
  wire            adc_clk;
  wire   [127:0]  rx_gt_data;
  wire            adc_0_enable_a;
  wire    [31:0]  adc_0_data_a;
  wire            adc_0_enable_b;
  wire    [31:0]  adc_0_data_b;
  wire            adc_1_enable_a;
  wire    [31:0]  adc_1_data_a;
  wire            adc_1_enable_b;
  wire    [31:0]  adc_1_data_b;

  wire    [15:0]  ps_intrs;

  // pack & unpack here

  always @(posedge adc_clk) begin
    case ({adc_0_enable_b, adc_0_enable_a})
      2'b11: begin
        dma_0_wr <= 1'b1;
        dma_0_data[63:48] <= adc_0_data_b[31:16];
        dma_0_data[47:32] <= adc_0_data_a[31:16];
        dma_0_data[31:16] <= adc_0_data_b[15: 0];
        dma_0_data[15: 0] <= adc_0_data_a[15: 0];
      end
      2'b10: begin
        dma_0_wr <= ~dma_0_wr;
        dma_0_data[63:48] <= adc_0_data_b[31:16];
        dma_0_data[47:32] <= adc_0_data_b[15: 0];
        dma_0_data[31:16] <= dma_0_data[63:48];
        dma_0_data[15: 0] <= dma_0_data[47:32];
      end
      2'b01: begin
        dma_0_wr <= ~dma_0_wr;
        dma_0_data[63:48] <= adc_0_data_a[31:16];
        dma_0_data[47:32] <= adc_0_data_a[15: 0];
        dma_0_data[31:16] <= dma_0_data[63:48];
        dma_0_data[15: 0] <= dma_0_data[47:32];
      end
      default: begin
        dma_0_wr <= 1'b0;
        dma_0_data[63:48] <= 16'd0;
        dma_0_data[47:32] <= 16'd0;
        dma_0_data[31:16] <= 16'd0;
        dma_0_data[15: 0] <= 16'd0;
      end
    endcase
  end

  always @(posedge adc_clk) begin
    case ({adc_1_enable_b, adc_1_enable_a})
      2'b11: begin
        dma_1_wr <= 1'b1;
        dma_1_data[63:48] <= adc_1_data_b[31:16];
        dma_1_data[47:32] <= adc_1_data_a[31:16];
        dma_1_data[31:16] <= adc_1_data_b[15: 0];
        dma_1_data[15: 0] <= adc_1_data_a[15: 0];
      end
      2'b10: begin
        dma_1_wr <= ~dma_1_wr;
        dma_1_data[63:48] <= adc_1_data_b[31:16];
        dma_1_data[47:32] <= adc_1_data_b[15: 0];
        dma_1_data[31:16] <= dma_1_data[63:48];
        dma_1_data[15: 0] <= dma_1_data[47:32];
      end
      2'b01: begin
        dma_1_wr <= ~dma_1_wr;
        dma_1_data[63:48] <= adc_1_data_a[31:16];
        dma_1_data[47:32] <= adc_1_data_a[15: 0];
        dma_1_data[31:16] <= dma_1_data[63:48];
        dma_1_data[15: 0] <= dma_1_data[47:32];
      end
      default: begin
        dma_1_wr <= 1'b0;
        dma_1_data[63:48] <= 16'd0;
        dma_1_data[47:32] <= 16'd0;
        dma_1_data[31:16] <= 16'd0;
        dma_1_data[15: 0] <= 16'd0;
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

  ad_iobuf #(.DATA_WIDTH(15)) i_iobuf (
    .dt (gpio_t),
    .di (gpio_o),
    .do (gpio_i),
    .dio (gpio_bd));

  assign spi_adc_clk = spi_clk;
  assign spi_clk_clk = spi_clk;

  fmcjesdadc1_spi i_fmcjesdadc1_spi (
    .spi_csn (spi_csn),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio));

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
    .adc_0_data_a (adc_0_data_a),
    .adc_0_data_b (adc_0_data_b),
    .adc_0_enable_a (adc_0_enable_a),
    .adc_0_enable_b (adc_0_enable_b),
    .adc_0_valid_a (),
    .adc_0_valid_b (),
    .adc_1_data_a (adc_1_data_a),
    .adc_1_data_b (adc_1_data_b),
    .adc_1_enable_a (adc_1_enable_a),
    .adc_1_enable_b (adc_1_enable_b),
    .adc_1_valid_a (),
    .adc_1_valid_b (),
    .adc_clk (adc_clk),
    .dma_0_data (dma_0_data),
    .dma_0_sync (1'b1),
    .dma_0_wr (dma_0_wr),
    .dma_1_data (dma_1_data),
    .dma_1_sync (1'b1),
    .dma_1_wr (dma_1_wr),
    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .ps_intr_0 (ps_intrs[0]),
    .ps_intr_1 (ps_intrs[1]),
    .ps_intr_2 (ps_intrs[2]),
    .ps_intr_3 (ps_intrs[3]),
    .ps_intr_4 (ps_intrs[4]),
    .ps_intr_5 (ps_intrs[5]),
    .ps_intr_6 (ps_intrs[6]),
    .ps_intr_7 (ps_intrs[7]),
    .ps_intr_8 (ps_intrs[8]),
    .ps_intr_9 (ps_intrs[9]),
    .ps_intr_10 (ps_intrs[10]),
    .ps_intr_11 (ps_intrs[11]),
    .rx_data_n (rx_data_n),
    .rx_data_p (rx_data_p),
    .rx_gt_data (rx_gt_data),
    .rx_gt_data_0 (rx_gt_data[63:0]),
    .rx_gt_data_1 (rx_gt_data[127:64]),
    .rx_ref_clk (rx_ref_clk),
    .rx_sync (rx_sync),
    .rx_sysref (rx_sysref),
    .spdif (spdif),
    .spi_clk_i (1'b0),
    .spi_clk_o (spi_clk),
    .spi_csn_i (1'b1),
    .spi_csn_o (spi_csn),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (1'b0),
    .spi_sdo_o (spi_mosi));

endmodule

// ***************************************************************************
// ***************************************************************************
