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

  dac_clk_in_p,
  dac_clk_in_n,
  dac_clk_out_p,
  dac_clk_out_n,
  dac_frame_out_p,
  dac_frame_out_n,
  dac_data_out_p,
  dac_data_out_n,

  adc_clk_in_p,
  adc_clk_in_n,
  adc_or_in_p,
  adc_or_in_n,
  adc_data_in_p,
  adc_data_in_n,

  ref_clk_out_p,
  ref_clk_out_n,

  iic_scl,
  iic_sda);

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

  inout   [15:0]  gpio_bd;

  output          hdmi_out_clk;
  output          hdmi_vsync;
  output          hdmi_hsync;
  output          hdmi_data_e;
  output  [15:0]  hdmi_data;

  output          spdif;

  input           dac_clk_in_p;
  input           dac_clk_in_n;
  output          dac_clk_out_p;
  output          dac_clk_out_n;
  output          dac_frame_out_p;
  output          dac_frame_out_n;
  output  [15:0]  dac_data_out_p;
  output  [15:0]  dac_data_out_n;

  input           adc_clk_in_p;
  input           adc_clk_in_n;
  input           adc_or_in_n;
  input           adc_or_in_p;
  input   [13:0]  adc_data_in_n;
  input   [13:0]  adc_data_in_p;

  output          ref_clk_out_p;
  output          ref_clk_out_n;

  inout           iic_scl;
  inout           iic_sda;

  // internal registers

  reg     [63:0]  dac_ddata_0 = 'd0;
  reg     [63:0]  dac_ddata_1 = 'd0;
  reg             dac_dma_rd = 'd0;
  reg             adc_data_cnt = 'd0;
  reg             adc_dma_wr = 'd0;
  reg     [31:0]  adc_dma_wdata = 'd0;

  // internal signals

  wire    [31:0]  gpio_i;
  wire    [31:0]  gpio_o;
  wire    [31:0]  gpio_t;
  wire            dac_clk;
  wire            dac_valid_0;
  wire            dac_enable_0;
  wire            dac_valid_1;
  wire            dac_enable_1;
  wire    [63:0]  dac_dma_rdata;
  wire            adc_clk;
  wire            adc_valid_0;
  wire            adc_enable_0;
  wire    [15:0]  adc_data_0;
  wire            adc_valid_1;
  wire            adc_enable_1;
  wire    [15:0]  adc_data_1;
  wire            ref_clk;
  wire            oddr_ref_clk;

  // instantiations

  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE"),
    .INIT (1'b0),
    .SRTYPE ("ASYNC"))
  i_oddr_ref_clk (
    .S (1'b0),
    .CE (1'b1),
    .R (1'b0),
    .C (ref_clk),
    .D1 (1'b1),
    .D2 (1'b0),
    .Q (oddr_ref_clk));

  OBUFDS i_obufds_ref_clk (
    .I (oddr_ref_clk),
    .O (ref_clk_out_p),
    .OB (ref_clk_out_n));

  genvar n;
  generate
  for (n = 0; n <= 15; n = n + 1) begin: g_iobuf_gpio_bd
  IOBUF i_iobuf_gpio_bd (
    .I (gpio_o[n]),
    .O (gpio_i[n]),
    .T (gpio_t[n]),
    .IO (gpio_bd[n]));
  end
  endgenerate

  always @(posedge dac_clk) begin
    dac_dma_rd <= dac_valid_0 & dac_enable_0;
    dac_ddata_1[63:48] <= dac_dma_rdata[63:48];
    dac_ddata_1[47:32] <= dac_dma_rdata[63:48];
    dac_ddata_1[31:16] <= dac_dma_rdata[31:16];
    dac_ddata_1[15: 0] <= dac_dma_rdata[31:16];
    dac_ddata_0[63:48] <= dac_dma_rdata[47:32];
    dac_ddata_0[47:32] <= dac_dma_rdata[47:32];
    dac_ddata_0[31:16] <= dac_dma_rdata[15: 0];
    dac_ddata_0[15: 0] <= dac_dma_rdata[15: 0];
  end

  always @(posedge adc_clk) begin
    adc_data_cnt <= ~adc_data_cnt ;
    case ({adc_enable_1, adc_enable_0})
      2'b10: begin
        adc_dma_wr <= adc_data_cnt;
        adc_dma_wdata <= {adc_data_1, adc_dma_wdata[31:16]};
      end
      2'b01: begin
        adc_dma_wr <= adc_data_cnt;
        adc_dma_wdata <= {adc_data_0, adc_dma_wdata[31:16]};
      end
      default: begin
        adc_dma_wr <= 1'b1;
        adc_dma_wdata <= {adc_data_1, adc_data_0};
      end
    endcase
  end

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
    .adc_clk_in_n (adc_clk_in_n),
    .adc_clk_in_p (adc_clk_in_p),
    .adc_data_0 (adc_data_0),
    .adc_data_1 (adc_data_1),
    .adc_data_in_n (adc_data_in_n),
    .adc_data_in_p (adc_data_in_p),
    .adc_dma_sync (1'b1),
    .adc_dma_wdata (adc_dma_wdata),
    .adc_dma_wr (adc_dma_wr),
    .adc_enable_0 (adc_enable_0),
    .adc_enable_1 (adc_enable_1),
    .adc_or_in_n (adc_or_in_n),
    .adc_or_in_p (adc_or_in_p),
    .adc_valid_0 (adc_valid_0),
    .adc_valid_1 (adc_valid_1),
    .dac_clk (dac_clk),
    .dac_clk_in_n (dac_clk_in_n),
    .dac_clk_in_p (dac_clk_in_p),
    .dac_clk_out_n (dac_clk_out_n),
    .dac_clk_out_p (dac_clk_out_p),
    .dac_data_out_n (dac_data_out_n),
    .dac_data_out_p (dac_data_out_p),
    .dac_ddata_0 (dac_ddata_0),
    .dac_ddata_1 (dac_ddata_1),
    .dac_dma_rd (dac_dma_rd),
    .dac_dma_rdata (dac_dma_rdata),
    .dac_enable_0 (dac_enable_0),
    .dac_enable_1 (dac_enable_1),
    .dac_frame_out_n (dac_frame_out_n),
    .dac_frame_out_p (dac_frame_out_p),
    .dac_valid_0 (dac_valid_0),
    .dac_valid_1 (dac_valid_1),
    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .ref_clk (ref_clk),
    .spdif (spdif));

endmodule

// ***************************************************************************
// ***************************************************************************
