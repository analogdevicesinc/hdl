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

module up_dac_channel (

  // dac interface

  dac_clk,
  dac_rst,
  dac_dds_scale_1,
  dac_dds_init_1,
  dac_dds_incr_1,
  dac_dds_scale_2,
  dac_dds_init_2,
  dac_dds_incr_2,
  dac_pat_data_1,
  dac_pat_data_2,
  dac_data_sel,
  dac_iqcor_enb,
  dac_iqcor_coeff_1,
  dac_iqcor_coeff_2,

  // user controls

  up_usr_datatype_be,
  up_usr_datatype_signed,
  up_usr_datatype_shift,
  up_usr_datatype_total_bits,
  up_usr_datatype_bits,
  up_usr_interpolation_m,
  up_usr_interpolation_n,
  dac_usr_datatype_be,
  dac_usr_datatype_signed,
  dac_usr_datatype_shift,
  dac_usr_datatype_total_bits,
  dac_usr_datatype_bits,
  dac_usr_interpolation_m,
  dac_usr_interpolation_n,

  // bus interface

  up_rstn,
  up_clk,
  up_wreq,
  up_waddr,
  up_wdata,
  up_wack,
  up_rreq,
  up_raddr,
  up_rdata,
  up_rack);

  // parameters

  parameter PCORE_DAC_CHID = 4'h0;

  // dac interface

  input           dac_clk;
  input           dac_rst;
  output  [15:0]  dac_dds_scale_1;
  output  [15:0]  dac_dds_init_1;
  output  [15:0]  dac_dds_incr_1;
  output  [15:0]  dac_dds_scale_2;
  output  [15:0]  dac_dds_init_2;
  output  [15:0]  dac_dds_incr_2;
  output  [15:0]  dac_pat_data_1;
  output  [15:0]  dac_pat_data_2;
  output  [ 3:0]  dac_data_sel;
  output          dac_iqcor_enb;
  output  [15:0]  dac_iqcor_coeff_1;
  output  [15:0]  dac_iqcor_coeff_2;

  // user controls

  output          up_usr_datatype_be;
  output          up_usr_datatype_signed;
  output  [ 7:0]  up_usr_datatype_shift;
  output  [ 7:0]  up_usr_datatype_total_bits;
  output  [ 7:0]  up_usr_datatype_bits;
  output  [15:0]  up_usr_interpolation_m;
  output  [15:0]  up_usr_interpolation_n;
  input           dac_usr_datatype_be;
  input           dac_usr_datatype_signed;
  input   [ 7:0]  dac_usr_datatype_shift;
  input   [ 7:0]  dac_usr_datatype_total_bits;
  input   [ 7:0]  dac_usr_datatype_bits;
  input   [15:0]  dac_usr_interpolation_m;
  input   [15:0]  dac_usr_interpolation_n;

  // bus interface

  input           up_rstn;
  input           up_clk;
  input           up_wreq;
  input   [13:0]  up_waddr;
  input   [31:0]  up_wdata;
  output          up_wack;
  input           up_rreq;
  input   [13:0]  up_raddr;
  output  [31:0]  up_rdata;
  output          up_rack;

  // internal registers

  reg             up_wack = 'd0;
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
  reg             up_usr_datatype_be = 'd0;
  reg             up_usr_datatype_signed = 'd0;
  reg     [ 7:0]  up_usr_datatype_shift = 'd0;
  reg     [ 7:0]  up_usr_datatype_total_bits = 'd0;
  reg     [ 7:0]  up_usr_datatype_bits = 'd0;
  reg     [15:0]  up_usr_interpolation_m = 'd0;
  reg     [15:0]  up_usr_interpolation_n = 'd0;
  reg             up_rack = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg     [15:0]  up_dac_dds_scale_tc_1 = 'd0;
  reg     [15:0]  up_dac_dds_scale_tc_2 = 'd0;
  reg     [15:0]  up_dac_iqcor_coeff_tc_1 = 'd0;
  reg     [15:0]  up_dac_iqcor_coeff_tc_2 = 'd0;
  reg     [ 3:0]  up_dac_data_sel_m = 'd0;

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

  assign up_wreq_s = ((up_waddr[13:8] == 6'h11) && (up_waddr[7:4] == PCORE_DAC_CHID)) ? up_wreq : 1'b0;
  assign up_rreq_s = ((up_raddr[13:8] == 6'h11) && (up_raddr[7:4] == PCORE_DAC_CHID)) ? up_rreq : 1'b0;

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_dac_dds_scale_1 <= 'd0;
      up_dac_dds_init_1 <= 'd0;
      up_dac_dds_incr_1 <= 'd0;
      up_dac_dds_scale_2 <= 'd0;
      up_dac_dds_init_2 <= 'd0;
      up_dac_dds_incr_2 <= 'd0;
      up_dac_pat_data_2 <= 'd0;
      up_dac_pat_data_1 <= 'd0;
      up_dac_iqcor_enb <= 'd0;
      up_dac_lb_enb <= 'd0;
      up_dac_pn_enb <= 'd0;
      up_dac_data_sel <= 'd0;
      up_dac_iqcor_coeff_1 <= 'd0;
      up_dac_iqcor_coeff_2 <= 'd0;
      up_usr_datatype_be <= 'd0;
      up_usr_datatype_signed <= 'd0;
      up_usr_datatype_shift <= 'd0;
      up_usr_datatype_total_bits <= 'd0;
      up_usr_datatype_bits <= 'd0;
      up_usr_interpolation_m <= 'd0;
      up_usr_interpolation_n <= 'd0;
    end else begin
      up_wack <= up_wreq_s;
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
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h4)) begin
        up_dac_pat_data_2 <= up_wdata[31:16];
        up_dac_pat_data_1 <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h5)) begin
        up_dac_iqcor_enb <= up_wdata[2];
        up_dac_lb_enb <= up_wdata[1];
        up_dac_pn_enb <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h6)) begin
        up_dac_data_sel <= up_wdata[3:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h7)) begin
        up_dac_iqcor_coeff_1 <= up_wdata[31:16];
        up_dac_iqcor_coeff_2 <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h8)) begin
        up_usr_datatype_be <= up_wdata[25];
        up_usr_datatype_signed <= up_wdata[24];
        up_usr_datatype_shift <= up_wdata[23:16];
        up_usr_datatype_total_bits <= up_wdata[15:8];
        up_usr_datatype_bits <= up_wdata[7:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h9)) begin
        up_usr_interpolation_m <= up_wdata[31:16];
        up_usr_interpolation_n <= up_wdata[15:0];
      end
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr[3:0])
          4'h0: up_rdata <= {16'd0, up_dac_dds_scale_1};
          4'h1: up_rdata <= {up_dac_dds_init_1, up_dac_dds_incr_1};
          4'h2: up_rdata <= {16'd0, up_dac_dds_scale_2};
          4'h3: up_rdata <= {up_dac_dds_init_2, up_dac_dds_incr_2};
          4'h4: up_rdata <= {up_dac_pat_data_2, up_dac_pat_data_1};
          4'h5: up_rdata <= {29'd0, up_dac_iqcor_enb, up_dac_lb_enb, up_dac_pn_enb};
          4'h6: up_rdata <= {28'd0, up_dac_data_sel_m};
          4'h7: up_rdata <= {up_dac_iqcor_coeff_1, up_dac_iqcor_coeff_2};
          4'h8: up_rdata <= {6'd0, dac_usr_datatype_be, dac_usr_datatype_signed,
                              dac_usr_datatype_shift, dac_usr_datatype_total_bits,
                              dac_usr_datatype_bits};
          4'h9: up_rdata <= {dac_usr_interpolation_m, dac_usr_interpolation_n};
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
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

  up_xfer_cntrl #(.DATA_WIDTH(165)) i_dac_xfer_cntrl (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({ up_dac_iqcor_enb,
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
                      up_dac_data_sel_m}),
    .up_xfer_done (),
    .d_rst (dac_rst),
    .d_clk (dac_clk),
    .d_data_cntrl ({  dac_iqcor_enb,
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
                      dac_data_sel}));

endmodule

// ***************************************************************************
// ***************************************************************************
