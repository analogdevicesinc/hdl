// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
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
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT,
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, INTELLECTUAL PROPERTY RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
// USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad9434_core (

  // device interface

  adc_clk,
  adc_data,
  adc_or,

  // dma interface

  dma_dvalid,
  dma_data,
  dma_dovf,

  // drp interface

  up_drp_sel,
  up_drp_wr,
  up_drp_addr,
  up_drp_wdata,
  up_drp_rdata,
  up_drp_ready,
  up_drp_locked,

  // delay interface

  up_dld,
  up_dwdata,
  up_drdata,
  delay_clk,
  delay_rst,
  delay_locked,

  // processor interface

  up_rstn,
  up_clk,
  up_wreq,
  up_waddr,
  up_wdata,
  up_wack,
  up_rreq,
  up_raddr,
  up_rdata,
  up_rack,

  // status and control signals

  mmcm_rst,
  adc_rst,
  adc_status);

  // parameters
  parameter PCORE_ID = 0;

  // device interface
  input           adc_clk;
  input  [47:0]   adc_data;
  input           adc_or;

  // dma interface
  output          dma_dvalid;
  output [63:0]   dma_data;
  input           dma_dovf;

  // drp interface
  output          up_drp_sel;
  output          up_drp_wr;
  output  [11:0]  up_drp_addr;
  output  [15:0]  up_drp_wdata;
  input   [15:0]  up_drp_rdata;
  input           up_drp_ready;
  input           up_drp_locked;

  // delay interface
  output  [12:0]  up_dld;
  output  [64:0]  up_dwdata;
  input   [64:0]  up_drdata;
  input           delay_clk;
  output          delay_rst;
  input           delay_locked;

  // processor interface
  input           up_clk;
  input           up_rstn;
  input           up_wreq;
  input   [13:0]  up_waddr;
  input   [31:0]  up_wdata;
  output          up_wack;
  input           up_rreq;
  input   [13:0]  up_raddr;
  output  [31:0]  up_rdata;
  output          up_rack;

  output          mmcm_rst;
  output          adc_rst;
  input           adc_status;

  // internal registers
  reg             up_wack;
  reg     [31:0]  up_rdata;
  reg             up_rack;

  // internal signals
  wire            up_status_pn_err_s;
  wire            up_status_pn_oos_s;
  wire            up_status_or_s;

  wire            adc_dfmt_se_s;
  wire            adc_dfmt_type_s;
  wire            adc_dfmt_enable_s;

  wire    [ 3:0]  adc_pnseq_sel_s;
  wire            adc_pn_err_s;
  wire            adc_pn_oos_s;

  wire            up_wack_s[0:2];
  wire    [31:0]  up_rdata_s[0:2];
  wire            up_rack_s[0:2];

  // instantiations
  axi_ad9434_pnmon i_pnmon (
    .adc_clk (adc_clk),
    .adc_data (adc_data),
    .adc_pnseq_sel (adc_pnseq_sel_s),
    .adc_pn_err (adc_pn_err_s),
    .adc_pn_oos (adc_pn_oos_s));

  genvar n;
  generate
  for (n = 0; n < 4; n = n + 1) begin: g_ad_dfmt
   ad_datafmt # (
    .DATA_WIDTH(12))
  i_datafmt (
    .clk (adc_clk),
    .valid (1'b1),
    .data (adc_data[n*12+11:n*12]),
    .valid_out (dma_dvalid),
    .data_out (dma_data[n*16+15:n*16]),
    .dfmt_enable (adc_dfmt_enable_s),
    .dfmt_type (adc_dfmt_type_s),
    .dfmt_se (adc_dfmt_se_s));
  end
  endgenerate

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rdata <= 'd0;
      up_rack <= 'd0;
      up_wack <= 'd0;
    end else begin
      up_rdata <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2];
      up_rack <= up_rack_s[0] | up_rack_s[1] | up_rack_s[2];
      up_wack <= up_wack_s[0] | up_wack_s[1] | up_wack_s[2];
    end
  end

  up_adc_common #(
    .PCORE_ID(PCORE_ID))
  i_adc_common(
    .mmcm_rst (mmcm_rst),

    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_r1_mode (),
    .adc_ddr_edgesel (),
    .adc_pin_mode (),
    .adc_status (adc_status),
    .adc_sync_status (1'd0),
    .adc_status_ovf (dma_dovf),
    .adc_status_unf (1'b0),
    .adc_clk_ratio (32'd4),
    .adc_start_code (),
    .adc_sync (),

    .up_status_pn_err (up_status_pn_err_s),
    .up_status_pn_oos (up_status_pn_oos_s),
    .up_status_or (up_status_or_s),

    .up_drp_sel (up_drp_sel),
    .up_drp_wr (up_drp_wr),
    .up_drp_addr (up_drp_addr),
    .up_drp_wdata (up_drp_wdata),
    .up_drp_rdata (up_drp_rdata),
    .up_drp_ready (up_drp_ready),
    .up_drp_locked (up_drp_locked),

    .up_usr_chanmax (),
    .adc_usr_chanmax (8'd0),
    .up_adc_gpio_in (32'd0),
    .up_adc_gpio_out (),

    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[0]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[0]),
    .up_rack (up_rack_s[0]));

  up_adc_channel #(
    .PCORE_ADC_CHID(0))
  i_adc_channel(
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_enable (),
    .adc_iqcor_enb (),
    .adc_dcfilt_enb (),
    .adc_dfmt_se (adc_dfmt_se_s),
    .adc_dfmt_type (adc_dfmt_type_s),
    .adc_dfmt_enable (adc_dfmt_enable_s),
    .adc_dcfilt_offset (),
    .adc_dcfilt_coeff (),
    .adc_iqcor_coeff_1 (),
    .adc_iqcor_coeff_2 (),
    .adc_pnseq_sel (adc_pnseq_sel_s),
    .adc_data_sel (),
    .adc_pn_err (adc_pn_err_s),
    .adc_pn_oos (adc_pn_oos_s),
    .adc_or (adc_or),
    .up_adc_pn_err (up_status_pn_err_s),
    .up_adc_pn_oos (up_status_pn_oos_s),
    .up_adc_or (up_status_or_s),
    .up_usr_datatype_be (),
    .up_usr_datatype_signed (),
    .up_usr_datatype_shift (),
    .up_usr_datatype_total_bits (),
    .up_usr_datatype_bits (),
    .up_usr_decimation_m (),
    .up_usr_decimation_n (),
    .adc_usr_datatype_be (1'b0),
    .adc_usr_datatype_signed (1'b1),
    .adc_usr_datatype_shift (8'd0),
    .adc_usr_datatype_total_bits (8'd16),
    .adc_usr_datatype_bits (8'd16),
    .adc_usr_decimation_m (16'd1),
    .adc_usr_decimation_n (16'd1),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[1]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[1]),
    .up_rack (up_rack_s[1]));

  // adc delay control

  up_delay_cntrl #(.IO_WIDTH(13), .IO_BASEADDR(6'h02)) i_delay_cntrl (
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked),
    .up_dld (up_dld),
    .up_dwdata (up_dwdata),
    .up_drdata (up_drdata),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[2]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[2]),
    .up_rack (up_rack_s[2]));

endmodule
