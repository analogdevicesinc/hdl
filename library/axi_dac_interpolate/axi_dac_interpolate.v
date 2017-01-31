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

module axi_dac_interpolate(

  input                 dac_clk,

  input       [15:0]    dac_data_a,
  input       [15:0]    dac_data_b,
  input                 dac_valid_a,
  input                 dac_valid_b,

  output  reg [15:0]    dac_int_data_a,
  output  reg [15:0]    dac_int_data_b,
  output  reg           dac_int_valid_a,
  output  reg           dac_int_valid_b,

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

  wire    [31:0]    interpolation_ratio_a;
  wire    [31:0]    interpolation_ratio_b;
  wire    [31:0]    filter_mask_a;
  wire    [31:0]    filter_mask_b;

  wire              dac_fir_valid_a;
  wire    [35:0]    dac_fir_data_a;
  wire              dac_fir_valid_b;
  wire    [35:0]    dac_fir_data_b;

  wire              dac_cic_valid_a;
  wire    [109:0]   dac_cic_data_a;
  wire              dac_cic_valid_b;
  wire    [109:0]   dac_cic_data_b;

  wire              dma_transfer_suspend;

  reg               dac_filt_int_valid_a;
  reg               dac_filt_int_valid_b;
  reg     [15:0]    interp_rate_cic_a;
  reg     [15:0]    interp_rate_cic_b;
  reg     [31:0]    filter_mask_a_d1;
  reg     [31:0]    filter_mask_b_d1;
  reg               cic_change_rate_a;
  reg               cic_change_rate_b;
  reg     [31:0]    interpolation_counter_a;
  reg     [31:0]    interpolation_counter_b;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  ad_rst i_core_rst_reg (.preset(~up_rstn), .clk(dac_clk), .rst(dac_rst));

  fir_interp fir_interpolation_a (
    .clk (dac_clk),
    .clk_enable (dac_cic_valid_a),
    .reset (dac_rst | dma_transfer_suspend),
    .filter_in (dac_data_a),
    .filter_out (dac_fir_data_a),
    .ce_out (dac_fir_valid_a));

  fir_interp fir_interpolation_b (
    .clk (dac_clk),
    .clk_enable (dac_cic_valid_b),
    .reset (dac_rst | dma_transfer_suspend),
    .filter_in (dac_data_b),
    .filter_out (dac_fir_data_b),
    .ce_out (dac_fir_valid_b));

  cic_interp cic_interpolation_a (
    .clk (dac_clk),
    .clk_enable (dac_valid_a),
    .reset (dac_rst | cic_change_rate_a | dma_transfer_suspend),
    .rate (interp_rate_cic_a),
    .load_rate (1'b0),
    .filter_in (dac_fir_data_a[30:0]),
    .filter_out (dac_cic_data_a),
    .ce_out (dac_cic_valid_a));

  cic_interp cic_interpolation_b (
    .clk (dac_clk),
    .clk_enable (dac_valid_b),
    .reset (dac_rst | cic_change_rate_b | dma_transfer_suspend),
    .rate (interp_rate_cic_b),
    .load_rate (1'b0),
    .filter_in (dac_fir_data_b[30:0]),
    .filter_out (dac_cic_data_b),
    .ce_out (dac_cic_valid_b));

  always @(posedge dac_clk) begin
    filter_mask_a_d1 <= filter_mask_a;
    filter_mask_b_d1 <= filter_mask_b;
    if (filter_mask_a_d1 != filter_mask_a) begin
      cic_change_rate_a <= 1'b1;
    end else begin
      cic_change_rate_a <= 1'b0;
    end
    if (filter_mask_b_d1 != filter_mask_b) begin
      cic_change_rate_b <= 1'b1;
    end else begin
      cic_change_rate_b <= 1'b0;
    end
  end

  always @(posedge dac_clk) begin
    if (interpolation_ratio_a == 0 || interpolation_ratio_a == 1) begin
      dac_int_valid_a <= dac_filt_int_valid_a;
    end else begin
      if (dac_filt_int_valid_a == 1'b1) begin
        if (interpolation_counter_a  < interpolation_ratio_a) begin
          interpolation_counter_a <= interpolation_counter_a + 1;
          dac_int_valid_a <= 1'b0;
        end else begin
          interpolation_counter_a <= 0;
          dac_int_valid_a <= 1'b1;
        end
      end else begin
        dac_int_valid_a <= 1'b0;
      end
    end
  end

  always @(posedge dac_clk) begin
    if (interpolation_ratio_b == 0 || interpolation_ratio_b == 1) begin
      dac_int_valid_b <= dac_filt_int_valid_b;
    end else begin
      if (dac_filt_int_valid_b == 1'b1) begin
        if (interpolation_counter_b  < interpolation_ratio_b) begin
          interpolation_counter_b <= interpolation_counter_b + 1;
          dac_int_valid_b <= 1'b0;
        end else begin
          interpolation_counter_b <= 0;
          dac_int_valid_b <= 1'b1;
        end
      end else begin
        dac_int_valid_b <= 1'b0;
      end
    end
  end

  always @(*) begin
    case (filter_mask_a)
      16'h1: dac_int_data_a = dac_cic_data_a[31:16];
      16'h2: dac_int_data_a = dac_cic_data_a[31:16];
      16'h3: dac_int_data_a = dac_cic_data_a[31:16];
      16'h6: dac_int_data_a = dac_cic_data_a[31:16];
      16'h7: dac_int_data_a = dac_cic_data_a[31:16];
      default: dac_int_data_a = dac_data_a;
    endcase

    case (filter_mask_a)
      16'h1: dac_filt_int_valid_a = dac_fir_valid_a;
      16'h2: dac_filt_int_valid_a = dac_fir_valid_a;
      16'h3: dac_filt_int_valid_a = dac_fir_valid_a;
      16'h6: dac_filt_int_valid_a = dac_fir_valid_a;
      16'h7: dac_filt_int_valid_a = dac_fir_valid_a;
      default: dac_filt_int_valid_a = dac_valid_a & !dma_transfer_suspend;
    endcase

    case (filter_mask_b)
      16'h1: dac_int_data_b = dac_cic_data_b[31:16];
      16'h2: dac_int_data_b = dac_cic_data_b[31:16];
      16'h3: dac_int_data_b = dac_cic_data_b[31:16];
      16'h6: dac_int_data_b = dac_cic_data_b[31:16];
      16'h7: dac_int_data_b = dac_cic_data_b[31:16];
      default: dac_int_data_b = dac_data_b;
    endcase

    case (filter_mask_b)
      16'h1: dac_filt_int_valid_b = dac_fir_valid_b;
      16'h2: dac_filt_int_valid_b = dac_fir_valid_b;
      16'h3: dac_filt_int_valid_b = dac_fir_valid_b;
      16'h6: dac_filt_int_valid_b = dac_fir_valid_b;
      16'h7: dac_filt_int_valid_b = dac_fir_valid_b;
      default: dac_filt_int_valid_b = dac_valid_b & !dma_transfer_suspend;
    endcase

    case (filter_mask_a)
      16'h1: interp_rate_cic_a = 16'd5;
      16'h2: interp_rate_cic_a = 16'd50;
      16'h3: interp_rate_cic_a = 16'd500;
      16'h6: interp_rate_cic_a = 16'd5000;
      16'h7: interp_rate_cic_a = 16'd50000;
      default: interp_rate_cic_a = 16'd1;
    endcase

    case (filter_mask_b)
      16'h1: interp_rate_cic_b = 16'd5;
      16'h2: interp_rate_cic_b = 16'd50;
      16'h3: interp_rate_cic_b = 16'd500;
      16'h6: interp_rate_cic_b = 16'd5000;
      16'h7: interp_rate_cic_b = 16'd50000;
      default: interp_rate_cic_b = 16'd1;
    endcase
  end

  axi_dac_interpolate_reg axi_dac_interpolate_reg_inst (

    .clk (dac_clk),

    .dac_interpolation_ratio_a (interpolation_ratio_a),
    .dac_filter_mask_a (filter_mask_a),
    .dac_interpolation_ratio_b (interpolation_ratio_b),
    .dac_filter_mask_b (filter_mask_b),

    .dma_transfer_suspend (dma_transfer_suspend),

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
