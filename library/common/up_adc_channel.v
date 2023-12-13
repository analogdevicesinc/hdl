// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module up_adc_channel #(

  // parameters

  parameter   COMMON_ID = 6'h01,
  parameter   CHANNEL_ID = 4'h0,
  parameter   USERPORTS_DISABLE = 0,
  parameter   DATAFORMAT_DISABLE = 0,
  parameter   DCFILTER_DISABLE = 0,
  parameter   IQCORRECTION_DISABLE = 0
) (

  // adc interface

  input           adc_clk,
  input           adc_rst,
  output          adc_enable,
  output          adc_iqcor_enb,
  output          adc_dcfilt_enb,
  output          adc_dfmt_se,
  output          adc_dfmt_type,
  output          adc_dfmt_enable,
  output  [15:0]  adc_dcfilt_offset,
  output  [15:0]  adc_dcfilt_coeff,
  output  [15:0]  adc_iqcor_coeff_1,
  output  [15:0]  adc_iqcor_coeff_2,
  output  [ 3:0]  adc_pnseq_sel,
  output  [ 3:0]  adc_data_sel,
  input           adc_pn_err,
  input           adc_pn_oos,
  input           adc_or,
  input   [31:0]  adc_read_data,
  input   [ 7:0]  adc_status_header,
  input           adc_crc_err,
  output  [ 2:0]  adc_softspan,
  output          up_adc_crc_err,
  output          up_adc_pn_err,
  output          up_adc_pn_oos,
  output          up_adc_or,

  // user controls

  output          up_usr_datatype_be,
  output          up_usr_datatype_signed,
  output  [ 7:0]  up_usr_datatype_shift,
  output  [ 7:0]  up_usr_datatype_total_bits,
  output  [ 7:0]  up_usr_datatype_bits,
  output  [15:0]  up_usr_decimation_m,
  output  [15:0]  up_usr_decimation_n,
  input           adc_usr_datatype_be,
  input           adc_usr_datatype_signed,
  input   [ 7:0]  adc_usr_datatype_shift,
  input   [ 7:0]  adc_usr_datatype_total_bits,
  input   [ 7:0]  adc_usr_datatype_bits,
  input   [15:0]  adc_usr_decimation_m,
  input   [15:0]  adc_usr_decimation_n,

  // bus interface

  input           up_rstn,
  input           up_clk,
  input           up_wreq,
  input   [13:0]  up_waddr,
  input   [31:0]  up_wdata,
  output          up_wack,
  input           up_rreq,
  input   [13:0]  up_raddr,
  output  [31:0]  up_rdata,
  output          up_rack
);

  // internal registers

  reg             up_wack_int = 'd0;
  reg             up_adc_lb_enb = 'd0;
  reg             up_adc_pn_sel = 'd0;
  reg             up_adc_iqcor_enb = 'd0;
  reg             up_adc_dcfilt_enb = 'd0;
  reg             up_adc_dfmt_se = 'd0;
  reg             up_adc_dfmt_type = 'd0;
  reg             up_adc_dfmt_enable = 'd0;
  reg             up_adc_pn_type = 'd0;
  reg             up_adc_enable = 'd0;
  reg             up_adc_crc_err_int = 'd0;
  reg             up_adc_pn_err_int = 'd0;
  reg             up_adc_pn_oos_int = 'd0;
  reg             up_adc_or_int = 'd0;
  reg     [15:0]  up_adc_dcfilt_offset = 'd0;
  reg     [15:0]  up_adc_dcfilt_coeff = 'd0;
  reg     [15:0]  up_adc_iqcor_coeff_1 = 'd0;
  reg     [15:0]  up_adc_iqcor_coeff_2 = 'd0;
  reg     [ 3:0]  up_adc_pnseq_sel = 'd0;
  reg     [ 3:0]  up_adc_data_sel = 'd0;
  reg             up_usr_datatype_be_int = 'd0;
  reg             up_usr_datatype_signed_int = 'd0;
  reg     [ 7:0]  up_usr_datatype_shift_int = 'd0;
  reg     [ 7:0]  up_usr_datatype_total_bits_int = 'd0;
  reg     [ 7:0]  up_usr_datatype_bits_int = 'd0;
  reg     [15:0]  up_usr_decimation_m_int = 'd0;
  reg     [15:0]  up_usr_decimation_n_int = 'd0;
  reg             up_rack_int = 'd0;
  reg     [31:0]  up_rdata_int = 'd0;
  reg     [15:0]  up_adc_iqcor_coeff_tc_1 = 'd0;
  reg     [15:0]  up_adc_iqcor_coeff_tc_2 = 'd0;
  reg     [ 3:0]  up_adc_pnseq_sel_m = 'd0;
  reg     [ 3:0]  up_adc_data_sel_m = 'd0;
  reg     [ 2:0]  up_adc_softspan_int = 3'h7;

  // internal signals

  wire            up_wreq_s;
  wire            up_rreq_s;
  wire            up_adc_crc_err_s;
  wire            up_adc_pn_err_s;
  wire            up_adc_pn_oos_s;
  wire            up_adc_or_s;
  wire    [31:0]  up_adc_read_data_s;
  wire    [ 7:0]  up_adc_status_header_s;
  wire    [ 2:0]  up_adc_softspan_s;

  // 2's complement function

  function [15:0] sm2tc;
    input [15:0]  din;
    reg   [15:0]  dp;
    reg   [15:0]  dn;
    reg   [15:0]  dout;
    begin
      dp = {1'b0, din[14:0]};
      dn = ~dp + 1'b1;
      dout = (din[15] == 1'b1) ? dn : dp;
      sm2tc = dout;
    end
  endfunction

  // up control/status
  assign up_adc_crc_err = up_adc_crc_err_int;
  assign up_adc_pn_err = up_adc_pn_err_int;
  assign up_adc_pn_oos = up_adc_pn_oos_int;
  assign up_adc_or = up_adc_or_int;
  assign up_usr_datatype_be = up_usr_datatype_be_int;
  assign up_usr_datatype_signed = up_usr_datatype_signed_int;
  assign up_usr_datatype_shift = up_usr_datatype_shift_int;
  assign up_usr_datatype_total_bits = up_usr_datatype_total_bits_int;
  assign up_usr_datatype_bits = up_usr_datatype_bits_int;
  assign up_usr_decimation_m = up_usr_decimation_m_int;
  assign up_usr_decimation_n = up_usr_decimation_n_int;
  assign up_adc_softspan_s = up_adc_softspan_int;

  // decode block select

  assign up_wreq_s = ((up_waddr[13:8] == COMMON_ID) && (up_waddr[7:4] == CHANNEL_ID)) ? up_wreq : 1'b0;
  assign up_rreq_s = ((up_raddr[13:8] == COMMON_ID) && (up_raddr[7:4] == CHANNEL_ID)) ? up_rreq : 1'b0;

  // processor write interface

  assign up_wack = up_wack_int;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack_int <= 'd0;
      up_adc_lb_enb <= 'd0;
      up_adc_pn_sel <= 'd0;
    end else begin
      up_wack_int <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h0)) begin
        up_adc_lb_enb <= up_wdata[11];
        up_adc_pn_sel <= up_wdata[10];
      end
    end
  end

  generate
  if (IQCORRECTION_DISABLE == 1) begin
  always @(posedge up_clk) begin
    up_adc_iqcor_enb <= 'd0;
  end
  end else begin
  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_iqcor_enb <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h0)) begin
        up_adc_iqcor_enb <= up_wdata[9];
      end
    end
  end
  end
  endgenerate

  generate
  if (DCFILTER_DISABLE == 1) begin
  always @(posedge up_clk) begin
    up_adc_dcfilt_enb <= 'd0;
  end
  end else begin
  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_dcfilt_enb <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h0)) begin
        up_adc_dcfilt_enb <= up_wdata[8];
      end
    end
  end
  end
  endgenerate

  generate
  if (DATAFORMAT_DISABLE == 1) begin
  always @(posedge up_clk) begin
    up_adc_dfmt_se <= 'd0;
    up_adc_dfmt_type <= 'd0;
    up_adc_dfmt_enable <= 'd0;
  end
  end else begin
  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_dfmt_se <= 'd0;
      up_adc_dfmt_type <= 'd0;
      up_adc_dfmt_enable <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h0)) begin
        up_adc_dfmt_se <= up_wdata[6];
        up_adc_dfmt_type <= up_wdata[5];
        up_adc_dfmt_enable <= up_wdata[4];
      end
    end
  end
  end
  endgenerate

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_pn_type <= 'd0;
      up_adc_enable <= 'd0;
      up_adc_crc_err_int <= 'd0;
      up_adc_pn_err_int <= 'd0;
      up_adc_pn_oos_int <= 'd0;
      up_adc_or_int <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h0)) begin
        up_adc_pn_type <= up_wdata[1];
        up_adc_enable <= up_wdata[0];
      end
      if (up_adc_crc_err_s == 1'b1) begin
        up_adc_crc_err_int <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h1)) begin
        up_adc_crc_err_int <= up_adc_crc_err_int & ~up_wdata[12];
      end
      if (up_adc_pn_err_s == 1'b1) begin
        up_adc_pn_err_int <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h1)) begin
        up_adc_pn_err_int <= up_adc_pn_err_int & ~up_wdata[2];
      end
      if (up_adc_pn_oos_s == 1'b1) begin
        up_adc_pn_oos_int <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h1)) begin
        up_adc_pn_oos_int <= up_adc_pn_oos_int & ~up_wdata[1];
      end
      if (up_adc_or_s == 1'b1) begin
        up_adc_or_int <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h1)) begin
        up_adc_or_int <= up_adc_or_int & ~up_wdata[0];
      end
    end
  end

  generate
  if (DCFILTER_DISABLE == 1) begin
  always @(posedge up_clk) begin
    up_adc_dcfilt_offset <= 'd0;
    up_adc_dcfilt_coeff <= 'd0;
  end
  end else begin
  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_dcfilt_offset <= 'd0;
      up_adc_dcfilt_coeff <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h4)) begin
        up_adc_dcfilt_offset <= up_wdata[31:16];
        up_adc_dcfilt_coeff <= up_wdata[15:0];
      end
    end
  end
  end
  endgenerate

  generate
  if (IQCORRECTION_DISABLE == 1) begin
  always @(posedge up_clk) begin
    up_adc_iqcor_coeff_1 <= 'd0;
    up_adc_iqcor_coeff_2 <= 'd0;
  end
  end else begin
  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_iqcor_coeff_1 <= 'd0;
      up_adc_iqcor_coeff_2 <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h5)) begin
        up_adc_iqcor_coeff_1 <= up_wdata[31:16];
        up_adc_iqcor_coeff_2 <= up_wdata[15:0];
      end
    end
  end
  end
  endgenerate

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_pnseq_sel <= 'd0;
      up_adc_data_sel <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h6)) begin
        up_adc_pnseq_sel <= up_wdata[19:16];
        up_adc_data_sel <= up_wdata[3:0];
      end
    end
  end

  generate
  if (USERPORTS_DISABLE == 1) begin
  always @(posedge up_clk) begin
    up_usr_datatype_be_int <= 'd0;
    up_usr_datatype_signed_int <= 'd0;
    up_usr_datatype_shift_int <= 'd0;
    up_usr_datatype_total_bits_int <= 'd0;
    up_usr_datatype_bits_int <= 'd0;
    up_usr_decimation_m_int <= 'd0;
    up_usr_decimation_n_int <= 'd0;
  end
  end else begin
  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_usr_datatype_be_int <= 'd0;
      up_usr_datatype_signed_int <= 'd0;
      up_usr_datatype_shift_int <= 'd0;
      up_usr_datatype_total_bits_int <= 'd0;
      up_usr_datatype_bits_int <= 'd0;
      up_usr_decimation_m_int <= 'd0;
      up_usr_decimation_n_int <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h8)) begin
        up_usr_datatype_be_int <= up_wdata[25];
        up_usr_datatype_signed_int <= up_wdata[24];
        up_usr_datatype_shift_int <= up_wdata[23:16];
        up_usr_datatype_total_bits_int <= up_wdata[15:8];
        up_usr_datatype_bits_int <= up_wdata[7:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h9)) begin
        up_usr_decimation_m_int <= up_wdata[31:16];
        up_usr_decimation_n_int <= up_wdata[15:0];
      end
    end
  end
  end
  endgenerate

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_softspan_int <= 3'd7;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'hA)) begin
        up_adc_softspan_int <= up_wdata[2:0];
      end
    end
  end

  // processor read interface

  assign up_rack = up_rack_int;
  assign up_rdata = up_rdata_int;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack_int <= 'd0;
      up_rdata_int <= 'd0;
    end else begin
      up_rack_int <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr[3:0])
          4'h0: up_rdata_int <= { 20'd0, up_adc_lb_enb, up_adc_pn_sel,
                                  up_adc_iqcor_enb, up_adc_dcfilt_enb,
                                  1'd0, up_adc_dfmt_se, up_adc_dfmt_type, up_adc_dfmt_enable,
                                  2'd0, up_adc_pn_type, up_adc_enable};
          4'h1: up_rdata_int <= { 19'd0, up_adc_crc_err_int, up_adc_status_header_s, 1'd0, up_adc_pn_err_int, up_adc_pn_oos_int, up_adc_or_int};
          4'h2: up_rdata_int <= { up_adc_read_data_s};
          4'h4: up_rdata_int <= { up_adc_dcfilt_offset, up_adc_dcfilt_coeff};
          4'h5: up_rdata_int <= { up_adc_iqcor_coeff_1, up_adc_iqcor_coeff_2};
          4'h6: up_rdata_int <= { 12'd0, up_adc_pnseq_sel, 12'd0, up_adc_data_sel};
          4'h8: up_rdata_int <= { 6'd0, adc_usr_datatype_be, adc_usr_datatype_signed,
                                  adc_usr_datatype_shift, adc_usr_datatype_total_bits,
                                  adc_usr_datatype_bits};
          4'h9: up_rdata_int <= { adc_usr_decimation_m, adc_usr_decimation_n};
          4'hA: up_rdata_int <= { 29'd0, up_adc_softspan_int};
          default: up_rdata_int <= 0;
        endcase
      end else begin
        up_rdata_int <= 32'd0;
      end
    end
  end

  // change coefficients to 2's complements

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_iqcor_coeff_tc_1 <= 16'd0;
      up_adc_iqcor_coeff_tc_2 <= 16'd0;
    end else begin
      up_adc_iqcor_coeff_tc_1 <= sm2tc(up_adc_iqcor_coeff_1);
      up_adc_iqcor_coeff_tc_2 <= sm2tc(up_adc_iqcor_coeff_2);
    end
  end

  // data/pn sources

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_pnseq_sel_m <= 4'd0;
      up_adc_data_sel_m <= 4'd0;
    end else begin
      case ({up_adc_pn_type, up_adc_pn_sel})
        2'b10: up_adc_pnseq_sel_m <= 4'h1;
        2'b01: up_adc_pnseq_sel_m <= 4'h9;
        default: up_adc_pnseq_sel_m <= up_adc_pnseq_sel;
      endcase
      if (up_adc_lb_enb == 1'b1) begin
        up_adc_data_sel_m <= 4'h1;
      end else begin
        up_adc_data_sel_m <= up_adc_data_sel;
      end
    end
  end

  // adc control & status

  up_xfer_cntrl #(
    .DATA_WIDTH(81)
  ) i_xfer_cntrl (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({ up_adc_iqcor_enb,
                      up_adc_dcfilt_enb,
                      up_adc_dfmt_se,
                      up_adc_dfmt_type,
                      up_adc_dfmt_enable,
                      up_adc_enable,
                      up_adc_dcfilt_offset,
                      up_adc_dcfilt_coeff,
                      up_adc_iqcor_coeff_tc_1,
                      up_adc_iqcor_coeff_tc_2,
                      up_adc_pnseq_sel_m,
                      up_adc_data_sel_m,
                      up_adc_softspan_s}),
    .up_xfer_done (),
    .d_rst (adc_rst),
    .d_clk (adc_clk),
    .d_data_cntrl ({  adc_iqcor_enb,
                      adc_dcfilt_enb,
                      adc_dfmt_se,
                      adc_dfmt_type,
                      adc_dfmt_enable,
                      adc_enable,
                      adc_dcfilt_offset,
                      adc_dcfilt_coeff,
                      adc_iqcor_coeff_1,
                      adc_iqcor_coeff_2,
                      adc_pnseq_sel,
                      adc_data_sel,
                      adc_softspan}));

  up_xfer_status #(
    .DATA_WIDTH(44)
  ) i_xfer_status (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_status ({up_adc_status_header_s,
                      up_adc_crc_err_s,
                      up_adc_pn_err_s,
                      up_adc_pn_oos_s,
                      up_adc_or_s,
                      up_adc_read_data_s}),
    .d_rst (adc_rst),
    .d_clk (adc_clk),
    .d_data_status ({ adc_status_header,
                      adc_crc_err,
                      adc_pn_err,
                      adc_pn_oos,
                      adc_or,
                      adc_read_data}));

endmodule
