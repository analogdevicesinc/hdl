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

  drp_clk,
  drp_rst,
  drp_sel,
  drp_wr,
  drp_addr,
  drp_wdata,
  drp_rdata,
  drp_ready,
  drp_locked,

  // delay interface

  delay_clk,
  delay_rst,
  delay_sel,
  delay_rwn,
  delay_addr,
  delay_wdata,
  delay_rdata,
  delay_ack_t,
  delay_locked,

  // processor interface

  up_rstn,
  up_clk,
  up_sel,
  up_wr,
  up_addr,
  up_wdata,
  up_rdata,
  up_ack,

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
  input           drp_clk;
  output          drp_rst;
  output          drp_sel;
  output          drp_wr;
  output  [11:0]  drp_addr;
  output  [15:0]  drp_wdata;
  input   [15:0]  drp_rdata;
  input           drp_ready;
  input           drp_locked;

  // delay interface
  input           delay_clk;
  output          delay_rst;
  output          delay_sel;
  output          delay_rwn;
  output  [ 7:0]  delay_addr;
  output  [ 4:0]  delay_wdata;
  input   [ 4:0]  delay_rdata;
  input           delay_ack_t;
  input           delay_locked;

  // processor interface
  input           up_clk;
  input           up_rstn;
  input           up_sel;
  input           up_wr;
  input   [13:0]  up_addr;
  input   [31:0]  up_wdata;
  output  [31:0]  up_rdata;
  output          up_ack;

  output          mmcm_rst;
  output          adc_rst;
  input           adc_status;

  reg     [31:0]  up_rdata;
  reg             up_ack;  

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

  wire    [31:0]  up_rdata_s[0:1];
  wire            up_ack_s[0:1];

  // instantiations
  axi_ad9434_pnmon i_pnmon (
    .adc_clk(adc_clk),
    .adc_data(adc_data),
    .adc_pnseq_sel(adc_pnseq_sel_s),
    .adc_pn_err(adc_pn_err_s),
    .adc_pn_oos(adc_pn_oos_s));

  genvar n;
  generate
  for (n = 0; n < 4; n = n + 1) begin: g_ad_dfmt
   ad_datafmt # (
    .DATA_WIDTH(12))
  i_datafmt (
    .clk(adc_clk),
    .valid(1'b1),
    .data(adc_data[n*12+11:n*12]),
    .valid_out(dma_dvalid),
    .data_out(dma_data[n*16+15:n*16]),
    .dfmt_enable(adc_dfmt_enable_s),
    .dfmt_type(adc_dfmt_type_s),
    .dfmt_se(adc_dfmt_se_s));
  end
  endgenerate

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rdata <= 'd0;
      up_ack <= 'd0;
    end else begin
      up_rdata <= up_rdata_s[0] | up_rdata_s[1];
      up_ack <= up_ack_s[0] | up_ack_s[1];
    end
  end

  up_adc_common #(
    .PCORE_ID(PCORE_ID))
  i_adc_common(
    .mmcm_rst(mmcm_rst),
    .adc_clk(adc_clk),
    .adc_rst(adc_rst),
    .adc_r1_mode(),
    .adc_ddr_edgesel(),
    .adc_pin_mode(),
    .adc_status(adc_status),
    .adc_status_ovf(dma_dovf),
    .adc_status_unf(1'b0),
    .adc_clk_ratio(32'd4),
    .up_status_pn_err(up_status_pn_err_s),
    .up_status_pn_oos(up_status_pn_oos_s),
    .up_status_or(up_status_or_s),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_sel(delay_sel),
    .delay_rwn(delay_rwn),
    .delay_addr(delay_addr),
    .delay_wdata(delay_wdata),
    .delay_rdata(delay_rdata),
    .delay_ack_t(delay_ack_t),
    .delay_locked(delay_locked),
    .drp_clk(drp_clk),
    .drp_rst(drp_rst),
    .drp_sel(drp_sel),
    .drp_wr(drp_wr),
    .drp_addr(drp_addr),
    .drp_wdata(drp_wdata),
    .drp_rdata(drp_rdata),
    .drp_ready(drp_ready),
    .drp_locked(drp_locked),
    .up_usr_chanmax(),
    .adc_usr_chanmax(),
    .up_adc_gpio_in(),
    .up_adc_gpio_out(),
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_sel(up_sel),
    .up_wr(up_wr),
    .up_addr(up_addr),
    .up_wdata(up_wdata),
    .up_rdata(up_rdata_s[0]),
    .up_ack(up_ack_s[0]));

  up_adc_channel #(
    .PCORE_ADC_CHID(0))
  i_adc_channel(
    .adc_clk(adc_clk),
    .adc_rst(adc_rst),
    .adc_enable(),
    .adc_iqcor_enb(),
    .adc_dcfilt_enb(),
    .adc_dfmt_se(adc_dfmt_se_s),
    .adc_dfmt_type(adc_dfmt_type_s),
    .adc_dfmt_enable(adc_dfmt_enable_s),
    .adc_dcfilt_offset(),
    .adc_dcfilt_coeff(),
    .adc_iqcor_coeff_1(),
    .adc_iqcor_coeff_2(),
    .adc_pnseq_sel(adc_pnseq_sel_s),
    .adc_data_sel(),
    .adc_pn_err(adc_pn_err_s),
    .adc_pn_oos(adc_pn_oos_s),
    .adc_or(adc_or),
    .up_adc_pn_err(up_status_pn_err_s),
    .up_adc_pn_oos(up_status_pn_oos_s),
    .up_adc_or(up_status_or_s),
    .up_usr_datatype_be(),
    .up_usr_datatype_signed(),
    .up_usr_datatype_shift(),
    .up_usr_datatype_total_bits(),
    .up_usr_datatype_bits(),
    .up_usr_decimation_m(),
    .up_usr_decimation_n(),
    .adc_usr_datatype_be(1'b0),
    .adc_usr_datatype_signed(1'b1),
    .adc_usr_datatype_shift(8'd0),
    .adc_usr_datatype_total_bits(8'd16),
    .adc_usr_datatype_bits(8'd16),
    .adc_usr_decimation_m(16'd1),
    .adc_usr_decimation_n(16'd1),
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_sel(up_sel),
    .up_wr(up_wr),
    .up_addr(up_addr),
    .up_wdata(up_wdata),
    .up_rdata(up_rdata_s[1]),
    .up_ack(up_ack_s[1]));

endmodule
