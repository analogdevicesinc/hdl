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

module axi_ad9144_channel (

  // dac interface

  dac_clk,
  dac_rst,
  dac_enable,
  dac_data,
  dma_data,

  // processor interface

  dac_data_sync,
  dac_dds_format,

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

  parameter CHANNEL_ID = 32'h0;
  parameter DATAPATH_DISABLE = 0;

  // dac interface

  input           dac_clk;
  input           dac_rst;
  output          dac_enable;
  output  [63:0]  dac_data;
  input   [63:0]  dma_data;

  // processor interface

  input           dac_data_sync;
  input           dac_dds_format;

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

  reg             dac_enable = 'd0;
  reg     [63:0]  dac_data = 'd0;
  reg     [63:0]  dac_pn7_data = 'd0;
  reg     [63:0]  dac_pn15_data = 'd0;
  reg     [15:0]  dac_dds_phase_0_0 = 'd0;
  reg     [15:0]  dac_dds_phase_0_1 = 'd0;
  reg     [15:0]  dac_dds_phase_1_0 = 'd0;
  reg     [15:0]  dac_dds_phase_1_1 = 'd0;
  reg     [15:0]  dac_dds_phase_2_0 = 'd0;
  reg     [15:0]  dac_dds_phase_2_1 = 'd0;
  reg     [15:0]  dac_dds_phase_3_0 = 'd0;
  reg     [15:0]  dac_dds_phase_3_1 = 'd0;
  reg     [15:0]  dac_dds_incr_0 = 'd0;
  reg     [15:0]  dac_dds_incr_1 = 'd0;
  reg     [63:0]  dac_dds_data = 'd0;

  // internal signals

  wire    [15:0]  dac_dds_data_0_s;
  wire    [15:0]  dac_dds_data_1_s;
  wire    [15:0]  dac_dds_data_2_s;
  wire    [15:0]  dac_dds_data_3_s;
  wire    [15:0]  dac_dds_scale_1_s;
  wire    [15:0]  dac_dds_init_1_s;
  wire    [15:0]  dac_dds_incr_1_s;
  wire    [15:0]  dac_dds_scale_2_s;
  wire    [15:0]  dac_dds_init_2_s;
  wire    [15:0]  dac_dds_incr_2_s;
  wire    [15:0]  dac_pat_data_1_s;
  wire    [15:0]  dac_pat_data_2_s;
  wire    [ 3:0]  dac_data_sel_s;
  wire    [63:0]  dac_pn7_data_i_s;
  wire    [63:0]  dac_pn15_data_i_s;
  wire    [63:0]  dac_pn7_data_s;
  wire    [63:0]  dac_pn15_data_s;

   // PN7 function

  function [63:0] pn7;
    input [7:0] din;
    reg   [63:0] dout;
    begin
      dout[15] = din[ 6] ^ din[ 5];
      dout[14] = din[ 5] ^ din[ 4];
      dout[13] = din[ 4] ^ din[ 3];
      dout[12] = din[ 3] ^ din[ 2];
      dout[11] = din[ 2] ^ din[ 1];
      dout[10] = din[ 1] ^ din[ 0];
      dout[ 9] = din[ 0] ^ din[ 6] ^ din[ 5];
      dout[ 8] = din[ 6] ^ din[ 4];
      dout[ 7] = din[ 5] ^ din[ 3];
      dout[ 6] = din[ 4] ^ din[ 2];
      dout[ 5] = din[ 3] ^ din[ 1];
      dout[ 4] = din[ 2] ^ din[ 0];
      dout[ 3] = din[ 1] ^ din[ 6] ^ din[ 5];
      dout[ 2] = din[ 0] ^ din[ 5] ^ din[ 4];
      dout[ 1] = din[ 6] ^ din[ 4] ^ din[ 5] ^ din[ 3];
      dout[ 0] = din[ 5] ^ din[ 3] ^ din[ 4] ^ din[ 2];
      dout[31] = din[ 4] ^ din[ 2] ^ din[ 3] ^ din[ 1];
      dout[30] = din[ 3] ^ din[ 1] ^ din[ 2] ^ din[ 0];
      dout[29] = din[ 2] ^ din[ 0] ^ din[ 1] ^ din[ 6] ^ din[ 5];
      dout[28] = din[ 1] ^ din[ 6] ^ din[ 0] ^ din[ 4];
      dout[27] = din[ 0] ^ din[ 6] ^ din[ 3];
      dout[26] = din[ 6] ^ din[ 2];
      dout[25] = din[ 5] ^ din[ 1];
      dout[24] = din[ 4] ^ din[ 0];
      dout[23] = din[ 3] ^ din[ 6] ^ din[ 5];
      dout[22] = din[ 2] ^ din[ 5] ^ din[ 4];
      dout[21] = din[ 1] ^ din[ 4] ^ din[ 3];
      dout[20] = din[ 0] ^ din[ 3] ^ din[ 2];
      dout[19] = din[ 6] ^ din[ 2] ^ din[ 5] ^ din[ 1];
      dout[18] = din[ 5] ^ din[ 1] ^ din[ 4] ^ din[ 0];
      dout[17] = din[ 4] ^ din[ 0] ^ din[ 3] ^ din[ 6] ^ din[ 5];
      dout[16] = din[ 3] ^ din[ 6] ^ din[ 2] ^ din[ 4];
      dout[47] = din[ 2] ^ din[ 5] ^ din[ 1] ^ din[ 3];
      dout[46] = din[ 1] ^ din[ 4] ^ din[ 0] ^ din[ 2];
      dout[45] = din[ 0] ^ din[ 3] ^ din[ 6] ^ din[ 5] ^ din[ 1];
      dout[44] = din[ 6] ^ din[ 2] ^ din[ 4] ^ din[ 0];
      dout[43] = din[ 1] ^ din[ 3] ^ din[ 6];
      dout[42] = din[ 0] ^ din[ 5] ^ din[ 2];
      dout[41] = din[ 6] ^ din[ 4] ^ din[ 5] ^ din[ 1];
      dout[40] = din[ 5] ^ din[ 3] ^ din[ 4] ^ din[ 0];
      dout[39] = din[ 4] ^ din[ 2] ^ din[ 3] ^ din[ 6] ^ din[ 5];
      dout[38] = din[ 3] ^ din[ 5] ^ din[ 1] ^ din[ 2] ^ din[ 4];
      dout[37] = din[ 2] ^ din[ 4] ^ din[ 0] ^ din[ 1] ^ din[ 3];
      dout[36] = din[ 1] ^ din[ 3] ^ din[ 6] ^ din[ 0] ^ din[ 5] ^ din[ 2];
      dout[35] = din[ 0] ^ din[ 2] ^ din[ 6] ^ din[ 4] ^ din[ 1];
      dout[34] = din[ 6] ^ din[ 1] ^ din[ 3] ^ din[ 0];
      dout[33] = din[ 0] ^ din[ 2] ^ din[ 6];
      dout[32] = din[ 6] ^ din[ 1];
      dout[63] = din[ 5] ^ din[ 0];
      dout[62] = din[ 4] ^ din[ 6] ^ din[ 5];
      dout[61] = din[ 3] ^ din[ 5] ^ din[ 4];
      dout[60] = din[ 2] ^ din[ 4] ^ din[ 3];
      dout[59] = din[ 1] ^ din[ 3] ^ din[ 2];
      dout[58] = din[ 0] ^ din[ 2] ^ din[ 1];
      dout[57] = din[ 6] ^ din[ 1] ^ din[ 5] ^ din[ 0];
      dout[56] = din[ 0] ^ din[ 4] ^ din[ 6];
      dout[55] = din[ 6] ^ din[ 3];
      dout[54] = din[ 5] ^ din[ 2];
      dout[53] = din[ 4] ^ din[ 1];
      dout[52] = din[ 3] ^ din[ 0];
      dout[51] = din[ 2] ^ din[ 6] ^ din[ 5];
      dout[50] = din[ 1] ^ din[ 5] ^ din[ 4];
      dout[49] = din[ 0] ^ din[ 4] ^ din[ 3];
      dout[48] = din[ 6] ^ din[ 3] ^ din[ 5] ^ din[ 2];
      pn7 = dout;
    end
  endfunction
  
  // PN15 function

  function [63:0] pn15;
    input [15:0] din;
    reg   [63:0] dout;
    begin
      dout[15] = din[14] ^ din[13];
      dout[14] = din[13] ^ din[12];
      dout[13] = din[12] ^ din[11];
      dout[12] = din[11] ^ din[10];
      dout[11] = din[10] ^ din[ 9];
      dout[10] = din[ 9] ^ din[ 8];
      dout[ 9] = din[ 8] ^ din[ 7];
      dout[ 8] = din[ 7] ^ din[ 6];
      dout[ 7] = din[ 6] ^ din[ 5];
      dout[ 6] = din[ 5] ^ din[ 4];
      dout[ 5] = din[ 4] ^ din[ 3];
      dout[ 4] = din[ 3] ^ din[ 2];
      dout[ 3] = din[ 2] ^ din[ 1];
      dout[ 2] = din[ 1] ^ din[ 0];
      dout[ 1] = din[ 0] ^ din[14] ^ din[13];
      dout[ 0] = din[14] ^ din[12];
      dout[31] = din[13] ^ din[11];
      dout[30] = din[12] ^ din[10];
      dout[29] = din[11] ^ din[ 9];
      dout[28] = din[10] ^ din[ 8];
      dout[27] = din[ 9] ^ din[ 7];
      dout[26] = din[ 8] ^ din[ 6];
      dout[25] = din[ 7] ^ din[ 5];
      dout[24] = din[ 6] ^ din[ 4];
      dout[23] = din[ 5] ^ din[ 3];
      dout[22] = din[ 4] ^ din[ 2];
      dout[21] = din[ 3] ^ din[ 1];
      dout[20] = din[ 2] ^ din[ 0];
      dout[19] = din[ 1] ^ din[14] ^ din[13];
      dout[18] = din[ 0] ^ din[13] ^ din[12];
      dout[17] = din[14] ^ din[12] ^ din[13] ^ din[11];
      dout[16] = din[13] ^ din[11] ^ din[12] ^ din[10];
      dout[47] = din[12] ^ din[10] ^ din[11] ^ din[ 9];
      dout[46] = din[11] ^ din[ 9] ^ din[10] ^ din[ 8];
      dout[45] = din[10] ^ din[ 8] ^ din[ 9] ^ din[ 7];
      dout[44] = din[ 9] ^ din[ 7] ^ din[ 8] ^ din[ 6];
      dout[43] = din[ 8] ^ din[ 6] ^ din[ 7] ^ din[ 5];
      dout[42] = din[ 7] ^ din[ 5] ^ din[ 6] ^ din[ 4];
      dout[41] = din[ 6] ^ din[ 4] ^ din[ 5] ^ din[ 3];
      dout[40] = din[ 5] ^ din[ 3] ^ din[ 4] ^ din[ 2];
      dout[39] = din[ 4] ^ din[ 2] ^ din[ 3] ^ din[ 1];
      dout[38] = din[ 3] ^ din[ 1] ^ din[ 2] ^ din[ 0];
      dout[37] = din[ 2] ^ din[ 0] ^ din[ 1] ^ din[14] ^ din[13];
      dout[36] = din[ 1] ^ din[14] ^ din[ 0] ^ din[12];
      dout[35] = din[ 0] ^ din[14] ^ din[11];
      dout[34] = din[14] ^ din[10];
      dout[33] = din[13] ^ din[ 9];
      dout[32] = din[12] ^ din[ 8];
      dout[63] = din[11] ^ din[ 7];
      dout[62] = din[10] ^ din[ 6];
      dout[61] = din[ 9] ^ din[ 5];
      dout[60] = din[ 8] ^ din[ 4];
      dout[59] = din[ 7] ^ din[ 3];
      dout[58] = din[ 6] ^ din[ 2];
      dout[57] = din[ 5] ^ din[ 1];
      dout[56] = din[ 4] ^ din[ 0];
      dout[55] = din[ 3] ^ din[14] ^ din[13];
      dout[54] = din[ 2] ^ din[13] ^ din[12];
      dout[53] = din[ 1] ^ din[12] ^ din[11];
      dout[52] = din[ 0] ^ din[11] ^ din[10];
      dout[51] = din[14] ^ din[10] ^ din[13] ^ din[ 9];
      dout[50] = din[13] ^ din[ 9] ^ din[12] ^ din[ 8];
      dout[49] = din[12] ^ din[ 8] ^ din[11] ^ din[ 7];
      dout[48] = din[11] ^ din[ 7] ^ din[10] ^ din[ 6];
      pn15 = dout;
    end
  endfunction

  assign dac_pn7_data_i_s  = ~dac_pn7_data;
  assign dac_pn15_data_i_s = ~dac_pn15_data;

  assign dac_pn7_data_s    = dac_pn7_data;
  assign dac_pn15_data_s   = dac_pn15_data;

  // dac data select

  always @(posedge dac_clk) begin
    dac_enable <= (dac_data_sel_s == 4'h2) ? 1'b1 : 1'b0;
    case (dac_data_sel_s)
      4'h7: dac_data <= dac_pn15_data_s;
      4'h6: dac_data <= dac_pn7_data_s;
      4'h5: dac_data <= dac_pn15_data_i_s;
      4'h4: dac_data <= dac_pn7_data_i_s;
      4'h3: dac_data <= 64'd0;
      4'h2: dac_data <= dma_data;
      4'h1: dac_data <= { dac_pat_data_2_s, dac_pat_data_1_s,
                          dac_pat_data_2_s, dac_pat_data_1_s};
      default: dac_data <= dac_dds_data;
    endcase
  end

  // pn registers

  always @(posedge dac_clk) begin
    if (dac_data_sync == 1'b1) begin
      dac_pn7_data <= {64{1'd1}};
      dac_pn15_data <= {64{1'd1}};
    end else begin
      dac_pn7_data <= pn7(dac_pn7_data[55:48]);
      dac_pn15_data <= pn15(dac_pn15_data[63:48]);
    end
  end

  // dds

  always @(posedge dac_clk) begin
    if (dac_data_sync == 1'b1) begin
      dac_dds_phase_0_0 <= dac_dds_init_1_s;
      dac_dds_phase_0_1 <= dac_dds_init_2_s;
      dac_dds_phase_1_0 <= dac_dds_phase_0_0 + dac_dds_incr_1_s;
      dac_dds_phase_1_1 <= dac_dds_phase_0_1 + dac_dds_incr_2_s;
      dac_dds_phase_2_0 <= dac_dds_phase_1_0 + dac_dds_incr_1_s;
      dac_dds_phase_2_1 <= dac_dds_phase_1_1 + dac_dds_incr_2_s;
      dac_dds_phase_3_0 <= dac_dds_phase_2_0 + dac_dds_incr_1_s;
      dac_dds_phase_3_1 <= dac_dds_phase_2_1 + dac_dds_incr_2_s;
      dac_dds_incr_0 <= {dac_dds_incr_1_s[13:0], 2'd0};
      dac_dds_incr_1 <= {dac_dds_incr_2_s[13:0], 2'd0};
      dac_dds_data <= 64'd0;
    end else begin
      dac_dds_phase_0_0 <= dac_dds_phase_0_0 + dac_dds_incr_0;
      dac_dds_phase_0_1 <= dac_dds_phase_0_1 + dac_dds_incr_1;
      dac_dds_phase_1_0 <= dac_dds_phase_1_0 + dac_dds_incr_0;
      dac_dds_phase_1_1 <= dac_dds_phase_1_1 + dac_dds_incr_1;
      dac_dds_phase_2_0 <= dac_dds_phase_2_0 + dac_dds_incr_0;
      dac_dds_phase_2_1 <= dac_dds_phase_2_1 + dac_dds_incr_1;
      dac_dds_phase_3_0 <= dac_dds_phase_3_0 + dac_dds_incr_0;
      dac_dds_phase_3_1 <= dac_dds_phase_3_1 + dac_dds_incr_1;
      dac_dds_incr_0 <= dac_dds_incr_0;
      dac_dds_incr_1 <= dac_dds_incr_1;
      dac_dds_data <= { dac_dds_data_3_s, dac_dds_data_2_s,
                        dac_dds_data_1_s, dac_dds_data_0_s};
    end
  end

  generate
  if (DATAPATH_DISABLE == 1) begin
  assign dac_dds_data_0_s = 16'd0;
  end else begin
  ad_dds i_dds_0 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_0_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_0_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_0_s));
  end
  endgenerate
  
  generate
  if (DATAPATH_DISABLE == 1) begin
  assign dac_dds_data_1_s = 16'd0;
  end else begin
  ad_dds i_dds_1 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_1_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_1_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_1_s));
  end
  endgenerate
  
  generate
  if (DATAPATH_DISABLE == 1) begin
  assign dac_dds_data_2_s = 16'd0;
  end else begin
  ad_dds i_dds_2 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_2_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_2_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_2_s));
  end
  endgenerate
  
  generate
  if (DATAPATH_DISABLE == 1) begin
  assign dac_dds_data_3_s = 16'd0;
  end else begin
  ad_dds i_dds_3 (
    .clk (dac_clk),
    .dds_format (dac_dds_format),
    .dds_phase_0 (dac_dds_phase_3_0),
    .dds_scale_0 (dac_dds_scale_1_s),
    .dds_phase_1 (dac_dds_phase_3_1),
    .dds_scale_1 (dac_dds_scale_2_s),
    .dds_data (dac_dds_data_3_s));
  end
  endgenerate
  
  // single channel processor

  up_dac_channel #(.CHANNEL_ID(CHANNEL_ID)) i_up_dac_channel (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_dds_scale_1 (dac_dds_scale_1_s),
    .dac_dds_init_1 (dac_dds_init_1_s),
    .dac_dds_incr_1 (dac_dds_incr_1_s),
    .dac_dds_scale_2 (dac_dds_scale_2_s),
    .dac_dds_init_2 (dac_dds_init_2_s),
    .dac_dds_incr_2 (dac_dds_incr_2_s),
    .dac_pat_data_1 (dac_pat_data_1_s),
    .dac_pat_data_2 (dac_pat_data_2_s),
    .dac_data_sel (dac_data_sel_s),
    .dac_iq_mode (),
    .dac_iqcor_enb (),
    .dac_iqcor_coeff_1 (),
    .dac_iqcor_coeff_2 (),
    .up_usr_datatype_be (),
    .up_usr_datatype_signed (),
    .up_usr_datatype_shift (),
    .up_usr_datatype_total_bits (),
    .up_usr_datatype_bits (),
    .up_usr_interpolation_m (),
    .up_usr_interpolation_n (),
    .dac_usr_datatype_be (1'b0),
    .dac_usr_datatype_signed (1'b1),
    .dac_usr_datatype_shift (8'd0),
    .dac_usr_datatype_total_bits (8'd16),
    .dac_usr_datatype_bits (8'd16),
    .dac_usr_interpolation_m (16'd1),
    .dac_usr_interpolation_n (16'd1),
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
  
endmodule

// ***************************************************************************
// ***************************************************************************



  
