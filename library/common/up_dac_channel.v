// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module up_dac_channel #(

  // parameters

  parameter   COMMON_ID = 6'h11,
  parameter   CHANNEL_ID = 4'h0,
  parameter   CHANNEL_NUMBER = 8'b0,
  parameter   DDS_DISABLE = 0,
  parameter   USERPORTS_DISABLE = 0,
  parameter   IQCORRECTION_DISABLE = 0,
  parameter   XBAR_ENABLE = 0
) (

  // dac interface

  input           dac_clk,
  input           dac_rst,
  output  [15:0]  dac_dds_scale_1,
  output  [15:0]  dac_dds_init_1,
  output  [15:0]  dac_dds_incr_1,
  output  [15:0]  dac_dds_scale_2,
  output  [15:0]  dac_dds_init_2,
  output  [15:0]  dac_dds_incr_2,
  output  [15:0]  dac_pat_data_1,
  output  [15:0]  dac_pat_data_2,
  output  [ 3:0]  dac_data_sel,
  output          dac_mask_enable,
  output  [ 1:0]  dac_iq_mode,
  output          dac_iqcor_enb,
  output  [15:0]  dac_iqcor_coeff_1,
  output  [15:0]  dac_iqcor_coeff_2,
  output  [7:0]   dac_src_chan_sel,

  // user controls

  output          up_usr_datatype_be,
  output          up_usr_datatype_signed,
  output  [ 7:0]  up_usr_datatype_shift,
  output  [ 7:0]  up_usr_datatype_total_bits,
  output  [ 7:0]  up_usr_datatype_bits,
  output  [15:0]  up_usr_interpolation_m,
  output  [15:0]  up_usr_interpolation_n,
  input           dac_usr_datatype_be,
  input           dac_usr_datatype_signed,
  input   [ 7:0]  dac_usr_datatype_shift,
  input   [ 7:0]  dac_usr_datatype_total_bits,
  input   [ 7:0]  dac_usr_datatype_bits,
  input   [15:0]  dac_usr_interpolation_m,
  input   [15:0]  dac_usr_interpolation_n,

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
  output          up_rack);

  // internal registers

  reg             up_wack_int = 'd0;
  reg     [15:0]  up_dac_dds_scale_1 = 'd0;
  reg     [15:0]  up_dac_dds_init_1 = 'd0;
  reg     [15:0]  up_dac_dds_incr_1 = 'd0;
  reg     [15:0]  up_dac_dds_scale_2 = 'd0;
  reg     [15:0]  up_dac_dds_init_2 = 'd0;
  reg     [15:0]  up_dac_dds_incr_2 = 'd0;
  reg     [15:0]  up_dac_pat_data_2 = 'd0;
  reg     [15:0]  up_dac_pat_data_1 = 'd0;
  reg             up_dac_iqcor_enb = 'd0;
  reg             up_dac_lb_enb = 'd0;
  reg             up_dac_pn_enb = 'd0;
  reg     [ 3:0]  up_dac_data_sel = 'd0;
  reg     [15:0]  up_dac_iqcor_coeff_1 = 'd0;
  reg     [15:0]  up_dac_iqcor_coeff_2 = 'd0;
  reg             up_usr_datatype_be_int = 'd0;
  reg             up_usr_datatype_signed_int = 'd0;
  reg     [ 7:0]  up_usr_datatype_shift_int = 'd0;
  reg     [ 7:0]  up_usr_datatype_total_bits_int = 'd0;
  reg     [ 7:0]  up_usr_datatype_bits_int = 'd0;
  reg     [15:0]  up_usr_interpolation_m_int = 'd0;
  reg     [15:0]  up_usr_interpolation_n_int = 'd0;
  reg     [ 1:0]  up_dac_iq_mode = 'd0;
  reg             up_rack_int = 'd0;
  reg     [31:0]  up_rdata_int = 'd0;
  reg     [15:0]  up_dac_dds_scale_tc_1 = 'd0;
  reg     [15:0]  up_dac_dds_scale_tc_2 = 'd0;
  reg     [15:0]  up_dac_iqcor_coeff_tc_1 = 'd0;
  reg     [15:0]  up_dac_iqcor_coeff_tc_2 = 'd0;
  reg     [ 3:0]  up_dac_data_sel_m = 'd0;
  reg     [ 7:0]  up_dac_src_chan_sel = XBAR_ENABLE ? CHANNEL_NUMBER[7:0] : 8'h0;
  reg             up_dac_mask_enable = 1'b0;

  // internal signals

  wire            up_wreq_s;
  wire            up_rreq_s;

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

  // decode block select

  assign up_wreq_s = ((up_waddr[13:8] == COMMON_ID) && (up_waddr[7:4] == CHANNEL_ID)) ? up_wreq : 1'b0;
  assign up_rreq_s = ((up_raddr[13:8] == COMMON_ID) && (up_raddr[7:4] == CHANNEL_ID)) ? up_rreq : 1'b0;

  // processor write interface

  assign up_wack = up_wack_int;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack_int <= 'd0;
    end else begin
      up_wack_int <= up_wreq_s;
    end
  end

  generate
  if (DDS_DISABLE == 1) begin
  always @(posedge up_clk) begin
    up_dac_dds_scale_1 <= 'd0;
    up_dac_dds_init_1 <= 'd0;
    up_dac_dds_incr_1 <= 'd0;
    up_dac_dds_scale_2 <= 'd0;
    up_dac_dds_init_2 <= 'd0;
    up_dac_dds_incr_2 <= 'd0;
  end
  end else begin
  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_dac_dds_scale_1 <= 'd0;
      up_dac_dds_init_1 <= 'd0;
      up_dac_dds_incr_1 <= 'd0;
      up_dac_dds_scale_2 <= 'd0;
      up_dac_dds_init_2 <= 'd0;
      up_dac_dds_incr_2 <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h0)) begin
        up_dac_dds_scale_1 <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h1)) begin
        up_dac_dds_init_1 <= up_wdata[31:16];
        up_dac_dds_incr_1 <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h2)) begin
        up_dac_dds_scale_2 <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h3)) begin
        up_dac_dds_init_2 <= up_wdata[31:16];
        up_dac_dds_incr_2 <= up_wdata[15:0];
      end
    end
  end
  end
  endgenerate

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_dac_pat_data_2 <= 'd0;
      up_dac_pat_data_1 <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h4)) begin
        up_dac_pat_data_2 <= up_wdata[31:16];
        up_dac_pat_data_1 <= up_wdata[15:0];
      end
    end
  end

  generate
  if (IQCORRECTION_DISABLE == 1) begin
  always @(posedge up_clk) begin
    up_dac_iqcor_enb <= 'd0;
  end
  end else begin
  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_dac_iqcor_enb <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h5)) begin
        up_dac_iqcor_enb <= up_wdata[2];
      end
    end
  end
  end
  endgenerate

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_dac_lb_enb <= 'd0;
      up_dac_pn_enb <= 'd0;
      up_dac_data_sel <= 'd0;
      up_dac_src_chan_sel <= XBAR_ENABLE ? CHANNEL_NUMBER[7:0] : 8'h0;
      up_dac_mask_enable <= 1'b0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h5)) begin
        up_dac_lb_enb <= up_wdata[1];
        up_dac_pn_enb <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h6)) begin
        up_dac_data_sel <= up_wdata[3:0];
        up_dac_mask_enable <= XBAR_ENABLE ? up_wdata[16] : 1'b0;
        up_dac_src_chan_sel <=  XBAR_ENABLE ? up_wdata[15:8] : 8'h0;
       end
    end
  end

  generate
  if (IQCORRECTION_DISABLE == 1) begin
  always @(posedge up_clk) begin
    up_dac_iqcor_coeff_1 <= 'd0;
    up_dac_iqcor_coeff_2 <= 'd0;
  end
  end else begin
  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_dac_iqcor_coeff_1 <= 'd0;
      up_dac_iqcor_coeff_2 <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h7)) begin
        up_dac_iqcor_coeff_1 <= up_wdata[31:16];
        up_dac_iqcor_coeff_2 <= up_wdata[15:0];
      end
    end
  end
  end
  endgenerate

  assign up_usr_datatype_be = up_usr_datatype_be_int;
  assign up_usr_datatype_signed = up_usr_datatype_signed_int;
  assign up_usr_datatype_shift = up_usr_datatype_shift_int;
  assign up_usr_datatype_total_bits = up_usr_datatype_total_bits_int;
  assign up_usr_datatype_bits = up_usr_datatype_bits_int;
  assign up_usr_interpolation_m = up_usr_interpolation_m_int;
  assign up_usr_interpolation_n = up_usr_interpolation_n_int;

  generate
  if (USERPORTS_DISABLE == 1) begin
  always @(posedge up_clk) begin
    up_usr_datatype_be_int <= 'd0;
    up_usr_datatype_signed_int <= 'd0;
    up_usr_datatype_shift_int <= 'd0;
    up_usr_datatype_total_bits_int <= 'd0;
    up_usr_datatype_bits_int <= 'd0;
    up_usr_interpolation_m_int <= 'd0;
    up_usr_interpolation_n_int <= 'd0;
  end
  end else begin
  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_usr_datatype_be_int <= 'd0;
      up_usr_datatype_signed_int <= 'd0;
      up_usr_datatype_shift_int <= 'd0;
      up_usr_datatype_total_bits_int <= 'd0;
      up_usr_datatype_bits_int <= 'd0;
      up_usr_interpolation_m_int <= 'd0;
      up_usr_interpolation_n_int <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h8)) begin
        up_usr_datatype_be_int <= up_wdata[25];
        up_usr_datatype_signed_int <= up_wdata[24];
        up_usr_datatype_shift_int <= up_wdata[23:16];
        up_usr_datatype_total_bits_int <= up_wdata[15:8];
        up_usr_datatype_bits_int <= up_wdata[7:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h9)) begin
        up_usr_interpolation_m_int <= up_wdata[31:16];
        up_usr_interpolation_n_int <= up_wdata[15:0];
      end
    end
  end
  end
  endgenerate

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_dac_iq_mode <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'ha)) begin
        up_dac_iq_mode <= up_wdata[1:0];
      end
    end
  end

  // processor read interface

  assign up_rack = up_rack_int;
  assign up_rdata = up_rdata_int;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack_int <= 'd0;
      up_rdata_int <= 'd0;
    end else begin
      up_rack_int <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr[3:0])
          4'h0: up_rdata_int <= { 16'd0, up_dac_dds_scale_1};
          4'h1: up_rdata_int <= { up_dac_dds_init_1, up_dac_dds_incr_1};
          4'h2: up_rdata_int <= { 16'd0, up_dac_dds_scale_2};
          4'h3: up_rdata_int <= { up_dac_dds_init_2, up_dac_dds_incr_2};
          4'h4: up_rdata_int <= { up_dac_pat_data_2, up_dac_pat_data_1};
          4'h5: up_rdata_int <= { 29'd0, up_dac_iqcor_enb, up_dac_lb_enb, up_dac_pn_enb};
          4'h6: up_rdata_int <= { 15'b0, up_dac_mask_enable, up_dac_src_chan_sel, 4'b0, up_dac_data_sel_m};
          4'h7: up_rdata_int <= { up_dac_iqcor_coeff_1, up_dac_iqcor_coeff_2};
          4'h8: up_rdata_int <= { 6'd0, dac_usr_datatype_be, dac_usr_datatype_signed,
                                  dac_usr_datatype_shift, dac_usr_datatype_total_bits,
                                  dac_usr_datatype_bits};
          4'h9: up_rdata_int <= { dac_usr_interpolation_m, dac_usr_interpolation_n};
          4'ha: up_rdata_int <= { 30'd0, up_dac_iq_mode};
          default: up_rdata_int <= 0;
        endcase
      end else begin
        up_rdata_int <= 32'd0;
      end
    end
  end

  // change coefficients to 2's complements

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_dac_dds_scale_tc_1 <= 16'd0;
      up_dac_dds_scale_tc_2 <= 16'd0;
      up_dac_iqcor_coeff_tc_1 <= 16'd0;
      up_dac_iqcor_coeff_tc_2 <= 16'd0;
    end else begin
      up_dac_dds_scale_tc_1 <= sm2tc(up_dac_dds_scale_1);
      up_dac_dds_scale_tc_2 <= sm2tc(up_dac_dds_scale_2);
      up_dac_iqcor_coeff_tc_1 <= sm2tc(up_dac_iqcor_coeff_1);
      up_dac_iqcor_coeff_tc_2 <= sm2tc(up_dac_iqcor_coeff_2);
    end
  end

  // backward compatibility

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_dac_data_sel_m <= 4'd0;
    end else begin
      case ({up_dac_lb_enb, up_dac_pn_enb})
        2'b10: up_dac_data_sel_m <= 4'h8;
        2'b01: up_dac_data_sel_m <= 4'h9;
        default: up_dac_data_sel_m <= up_dac_data_sel;
      endcase
    end
  end

  // dac control & status

  up_xfer_cntrl #(.DATA_WIDTH(177)) i_xfer_cntrl (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({ up_dac_iq_mode,
                      up_dac_iqcor_enb,
                      up_dac_iqcor_coeff_tc_1,
                      up_dac_iqcor_coeff_tc_2,
                      up_dac_dds_scale_tc_1,
                      up_dac_dds_init_1,
                      up_dac_dds_incr_1,
                      up_dac_dds_scale_tc_2,
                      up_dac_dds_init_2,
                      up_dac_dds_incr_2,
                      up_dac_pat_data_1,
                      up_dac_pat_data_2,
                      up_dac_data_sel_m,
                      up_dac_mask_enable,
                      up_dac_src_chan_sel}),
    .up_xfer_done (),
    .d_rst (dac_rst),
    .d_clk (dac_clk),
    .d_data_cntrl ({  dac_iq_mode,
                      dac_iqcor_enb,
                      dac_iqcor_coeff_1,
                      dac_iqcor_coeff_2,
                      dac_dds_scale_1,
                      dac_dds_init_1,
                      dac_dds_incr_1,
                      dac_dds_scale_2,
                      dac_dds_init_2,
                      dac_dds_incr_2,
                      dac_pat_data_1,
                      dac_pat_data_2,
                      dac_data_sel,
                      dac_mask_enable,
                      dac_src_chan_sel}));

endmodule

// ***************************************************************************
// ***************************************************************************
