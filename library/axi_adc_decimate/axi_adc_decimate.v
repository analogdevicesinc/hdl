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

`timescale 1ns/100ps

module axi_adc_decimate(

  input                 adc_clk,

  input       [15:0]    adc_data_a,
  input       [15:0]    adc_data_b,
  input                 adc_valid_a,
  input                 adc_valid_b,

  output reg  [15:0]    adc_dec_data_a,
  output reg  [15:0]    adc_dec_data_b,
  output reg            adc_dec_valid_a,
  output reg            adc_dec_valid_b,

  // axi interface

  input                 s_axi_aclk,
  input                 s_axi_aresetn,
  input                 s_axi_awvalid,
  input       [31:0]    s_axi_awaddr,
  input       [ 2:0]    s_axi_awprot,
  output                s_axi_awready,
  input                 s_axi_wvalid,
  input       [31:0]    s_axi_wdata,
  input       [ 3:0]    s_axi_wstrb,
  output                s_axi_wready,
  output                s_axi_bvalid,
  output      [ 1:0]    s_axi_bresp,
  input                 s_axi_bready,
  input                 s_axi_arvalid,
  input       [31:0]    s_axi_araddr,
  input       [ 2:0]    s_axi_arprot,
  output                s_axi_arready,
  output                s_axi_rvalid,
  output      [31:0]    s_axi_rdata,
  output      [ 1:0]    s_axi_rresp,
  input                 s_axi_rready);

  // internal signals

  wire              up_clk;
  wire              up_rstn;
  wire    [13:0]    up_waddr;
  wire    [31:0]    up_wdata;
  wire              up_wack;
  wire              up_wreq;
  wire              up_rack;
  wire    [31:0]    up_rdata;
  wire              up_rreq;
  wire    [13:0]    up_raddr;

  wire    [31:0]    decimation_ratio;
  wire    [31:0]    filter_mask;

  wire    [105:0]   adc_cic_data_a;
  wire              adc_cic_valid_a;
  wire    [105:0]   adc_cic_data_b;
  wire              adc_cic_valid_b;

  wire    [25:0]    adc_fir_data_a;
  wire              adc_fir_valid_a;
  wire    [25:0]    adc_fir_data_b;
  wire              adc_fir_valid_b;

  reg               adc_dec_valid_a_filter;
  reg               adc_dec_valid_b_filter;

  reg     [31:0]    decimation_counter;
  reg     [15:0]    decim_rate_cic;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  cic_decim cic_decimation_a (
    .clk(adc_clk),
    .clk_enable(adc_valid_a),
    .reset(adc_rst),
    .filter_in(adc_data_a[11:0]),
    .rate(decim_rate_cic),
    .load_rate(1'b0),
    .filter_out(adc_cic_data_a),
    .ce_out(adc_cic_valid_a));

  cic_decim cic_decimation_b (
    .clk(adc_clk),
    .clk_enable(adc_valid_b),
    .reset(adc_rst),
    .filter_in(adc_data_b[11:0]),
    .rate(decim_rate_cic),
    .load_rate(1'b0),
    .filter_out(adc_cic_data_b),
    .ce_out(adc_cic_valid_b));

  fir_decim fir_decimation_a (
    .clk(adc_clk),
    .clk_enable(adc_cic_valid_a),
    .reset(adc_rst),
    .filter_in(adc_cic_data_a[11:0]),
    .filter_out(adc_fir_data_a),
    .ce_out(adc_fir_valid_a));

  fir_decim fir_decimation_b (
    .clk(adc_clk),
    .clk_enable(adc_cic_valid_b),
    .reset(adc_rst),
    .filter_in(adc_cic_data_b[11:0]),
    .filter_out(adc_fir_data_b),
    .ce_out(adc_fir_valid_b));

  always @(*) begin
    case (filter_mask)
      16'h1: adc_dec_data_a = {adc_fir_data_a[25], adc_fir_data_a[25:11]};
      16'h2: adc_dec_data_a = {adc_fir_data_a[25], adc_fir_data_a[25:11]};
      16'h3: adc_dec_data_a = {adc_fir_data_a[25], adc_fir_data_a[25:11]};
      16'h6: adc_dec_data_a = {adc_fir_data_a[25], adc_fir_data_a[25:11]};
      16'h7: adc_dec_data_a = {adc_fir_data_a[25], adc_fir_data_a[25:11]};
      default: adc_dec_data_a = adc_data_a;
    endcase

    case (filter_mask)
      16'h1: adc_dec_valid_a_filter = adc_fir_valid_a;
      16'h2: adc_dec_valid_a_filter = adc_fir_valid_a;
      16'h3: adc_dec_valid_a_filter = adc_fir_valid_a;
      16'h6: adc_dec_valid_a_filter = adc_fir_valid_a;
      16'h7: adc_dec_valid_a_filter = adc_fir_valid_a;
      default: adc_dec_valid_a_filter = adc_valid_a;
    endcase

     case (filter_mask)
      16'h1: adc_dec_data_b = {adc_fir_data_b[25], adc_fir_data_b[25:11]};
      16'h2: adc_dec_data_b = {adc_fir_data_b[25], adc_fir_data_b[25:11]};
      16'h3: adc_dec_data_b = {adc_fir_data_b[25], adc_fir_data_b[25:11]};
      16'h6: adc_dec_data_b = {adc_fir_data_b[25], adc_fir_data_b[25:11]};
      16'h7: adc_dec_data_b = {adc_fir_data_b[25], adc_fir_data_b[25:11]};
      default: adc_dec_data_b = adc_data_b;
    endcase

    case (filter_mask)
      16'h1: adc_dec_valid_b_filter = adc_fir_valid_b;
      16'h2: adc_dec_valid_b_filter = adc_fir_valid_b;
      16'h3: adc_dec_valid_b_filter = adc_fir_valid_b;
      16'h6: adc_dec_valid_b_filter = adc_fir_valid_b;
      16'h7: adc_dec_valid_b_filter = adc_fir_valid_b;
      default: adc_dec_valid_b_filter = adc_valid_b;
    endcase

    case (filter_mask)
      16'h1: decim_rate_cic = 16'd5;
      16'h2: decim_rate_cic = 16'd50;
      16'h3: decim_rate_cic = 16'd500;
      16'h6: decim_rate_cic = 16'd5000;
      16'h7: decim_rate_cic = 16'd50000;
      default: decim_rate_cic = 16'd1;
    endcase
  end

  always @(posedge adc_clk) begin
    if (adc_rst == 1'b1) begin
      decimation_counter <= 32'b0;
      adc_dec_valid_a <= 1'b0;
      adc_dec_valid_b <= 1'b0;
    end else begin
      if (adc_dec_valid_a_filter == 1'b1) begin
        if (decimation_counter < decimation_ratio) begin
          decimation_counter <= decimation_counter + 1;
          adc_dec_valid_a <= 1'b0;
          adc_dec_valid_b <= 1'b0;
        end else begin
          decimation_counter <= 0;
          adc_dec_valid_a <= 1'b1;
          adc_dec_valid_b <= 1'b1;
        end
      end else begin
          adc_dec_valid_a <= 1'b0;
          adc_dec_valid_b <= 1'b0;
      end
    end
  end

  axi_adc_decimate_reg axi_adc_decimate_reg (

    .clk (adc_clk),
    .adc_rst (adc_rst),

    .adc_decimation_ratio (decimation_ratio),
    .adc_filter_mask (filter_mask),

    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

 up_axi i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule

// ***************************************************************************
// ***************************************************************************
