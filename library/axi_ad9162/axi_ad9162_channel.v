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

`timescale 1ns / 1ps

module axi_ad9162_channel(

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
    output  [255:0]  dac_data;
    input   [255:0]  dma_data;
    
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
    
    reg              dac_enable = 'd0;
    reg     [255:0]  dac_data = 'd0;
    reg     [15: 0]  dac_dds_phase_0_0 = 'd0;
    reg     [15: 0]  dac_dds_phase_0_1 = 'd0;
    reg     [15: 0]  dac_dds_phase_1_0 = 'd0;
    reg     [15: 0]  dac_dds_phase_1_1 = 'd0;
    reg     [15: 0]  dac_dds_phase_2_0 = 'd0;
    reg     [15: 0]  dac_dds_phase_2_1 = 'd0;
    reg     [15: 0]  dac_dds_phase_3_0 = 'd0;
    reg     [15: 0]  dac_dds_phase_3_1 = 'd0;
    reg     [15: 0]  dac_dds_phase_4_0 = 'd0;
    reg     [15: 0]  dac_dds_phase_4_1 = 'd0;
    reg     [15: 0]  dac_dds_phase_5_0 = 'd0;
    reg     [15: 0]  dac_dds_phase_5_1 = 'd0;
    reg     [15: 0]  dac_dds_phase_6_0 = 'd0;
    reg     [15: 0]  dac_dds_phase_6_1 = 'd0;
    reg     [15: 0]  dac_dds_phase_7_0 = 'd0;
    reg     [15: 0]  dac_dds_phase_7_1 = 'd0;
    reg     [15: 0]  dac_dds_phase_8_0 = 'd0;
    reg     [15: 0]  dac_dds_phase_8_1 = 'd0;
    reg     [15: 0]  dac_dds_phase_9_0 = 'd0;
    reg     [15: 0]  dac_dds_phase_9_1 = 'd0;
    reg     [15: 0]  dac_dds_phase_10_0 = 'd0;
    reg     [15: 0]  dac_dds_phase_10_1 = 'd0;
    reg     [15: 0]  dac_dds_phase_11_0 = 'd0;
    reg     [15: 0]  dac_dds_phase_11_1 = 'd0;
    reg     [15: 0]  dac_dds_phase_12_0 = 'd0;
    reg     [15: 0]  dac_dds_phase_12_1 = 'd0;
    reg     [15: 0]  dac_dds_phase_13_0 = 'd0;
    reg     [15: 0]  dac_dds_phase_13_1 = 'd0;
    reg     [15: 0]  dac_dds_phase_14_0 = 'd0;
    reg     [15: 0]  dac_dds_phase_14_1 = 'd0;
    reg     [15: 0]  dac_dds_phase_15_0 = 'd0;
    reg     [15: 0]  dac_dds_phase_15_1 = 'd0;
    reg     [15: 0]  dac_dds_incr_0 = 'd0;
    reg     [15: 0]  dac_dds_incr_1 = 'd0;
    reg     [255:0]  dac_dds_data = 'd0;
    reg     [255:0]  dac_pn7_data = 'd0;
    reg     [255:0]  dac_pn15_data = 'd0;
    
    // internal signals
    
    wire    [15: 0]  dac_dds_data_0_s;
    wire    [15: 0]  dac_dds_data_1_s;
    wire    [15: 0]  dac_dds_data_2_s;
    wire    [15: 0]  dac_dds_data_3_s;
    wire    [15: 0]  dac_dds_data_4_s;
    wire    [15: 0]  dac_dds_data_5_s;
    wire    [15: 0]  dac_dds_data_6_s;
    wire    [15: 0]  dac_dds_data_7_s;
    wire    [15: 0]  dac_dds_data_8_s;
    wire    [15: 0]  dac_dds_data_9_s;
    wire    [15: 0]  dac_dds_data_10_s;
    wire    [15: 0]  dac_dds_data_11_s;
    wire    [15: 0]  dac_dds_data_12_s;
    wire    [15: 0]  dac_dds_data_13_s;
    wire    [15: 0]  dac_dds_data_14_s;
    wire    [15: 0]  dac_dds_data_15_s;
    wire    [15: 0]  dac_dds_scale_1_s;
    wire    [15: 0]  dac_dds_init_1_s;
    wire    [15: 0]  dac_dds_incr_1_s;
    wire    [15: 0]  dac_dds_scale_2_s;
    wire    [15: 0]  dac_dds_init_2_s;
    wire    [15: 0]  dac_dds_incr_2_s;
    wire    [15: 0]  dac_pat_data_1_s;
    wire    [15: 0]  dac_pat_data_2_s;
    wire    [ 3: 0]  dac_data_sel_s;
    wire    [255:0] dac_pn7_data_i_s;
    wire    [255:0] dac_pn15_data_i_s;
    wire    [255:0] dac_pn7_data_s;
    wire    [255:0] dac_pn15_data_s;
    
     
    // PN7 function
    
    function [255:0] pn7;
         input [7:0] din;
         reg   [255:0] dout;
         reg   [15:0] dout16;
         reg   [7:0] din_reg;
         integer i;
         integer j;
         begin
         din_reg = din;
           for ( j=0 ; j<16 ; j=j+1)begin
             for ( i=0 ; i<16 ; i= i+1)begin
                 din_reg = {din_reg,din_reg[6]^din_reg[5]};
                 dout16[15-i] = din_reg[0];
              end
              dout = {dout16,dout[255:16]};
           end         
           pn7 = dout;
         end
    endfunction
    
    // PN15 function
    
    function [255:0] pn15;
         input [15:0] din;
         reg   [255:0] dout;
         reg   [15:0] dout16;
         reg   [15:0] din_reg;
         integer i;
         integer j;
         begin
         din_reg = din;
           for (j=0 ; j<16 ; j=j+1)begin
             for (i=0 ; i<16 ; i= i+1)begin
                 din_reg = {din_reg,din_reg[14]^din_reg[13]};
                 dout16[15-i] = din_reg[0];
              end
              dout = {dout16,dout[255:16]};
           end         
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
        4'h3: dac_data <= 256'd0;
        4'h2: dac_data <= dma_data;
        4'h1: dac_data <= { dac_pat_data_2_s, dac_pat_data_1_s,
                            dac_pat_data_2_s, dac_pat_data_1_s,
                            dac_pat_data_2_s, dac_pat_data_1_s,
                            dac_pat_data_2_s, dac_pat_data_1_s,
                            dac_pat_data_2_s, dac_pat_data_1_s,
                            dac_pat_data_2_s, dac_pat_data_1_s,
                            dac_pat_data_2_s, dac_pat_data_1_s,
                            dac_pat_data_2_s, dac_pat_data_1_s};
        default: dac_data <= dac_dds_data;
      endcase
    end
    
    // pn registers
    
    always @(posedge dac_clk) begin
      if (dac_data_sync == 1'b1) begin
        dac_pn7_data <= {255{1'd1}};
        dac_pn15_data <= {255{1'd1}};
      end else begin
        dac_pn7_data <= pn7(dac_pn7_data[247:240]);
        dac_pn15_data <= pn15(dac_pn15_data[255:240]);
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
        dac_dds_phase_4_0 <= dac_dds_phase_3_0 + dac_dds_incr_1_s;
        dac_dds_phase_4_1 <= dac_dds_phase_3_1 + dac_dds_incr_2_s;
        dac_dds_phase_5_0 <= dac_dds_phase_4_0 + dac_dds_incr_1_s;
        dac_dds_phase_5_1 <= dac_dds_phase_4_1 + dac_dds_incr_2_s;
        dac_dds_phase_6_0 <= dac_dds_phase_5_0 + dac_dds_incr_1_s;
        dac_dds_phase_6_1 <= dac_dds_phase_5_1 + dac_dds_incr_2_s;
        dac_dds_phase_7_0 <= dac_dds_phase_6_0 + dac_dds_incr_1_s;
        dac_dds_phase_7_1 <= dac_dds_phase_6_1 + dac_dds_incr_2_s;
        dac_dds_phase_8_0 <= dac_dds_phase_7_0 + dac_dds_incr_1_s;
        dac_dds_phase_8_1 <= dac_dds_phase_7_1 + dac_dds_incr_2_s;
        dac_dds_phase_9_0 <= dac_dds_phase_8_0 + dac_dds_incr_1_s;
        dac_dds_phase_9_1 <= dac_dds_phase_8_1 + dac_dds_incr_2_s;
        dac_dds_phase_10_0 <= dac_dds_phase_9_0 + dac_dds_incr_1_s;
        dac_dds_phase_10_1 <= dac_dds_phase_9_1 + dac_dds_incr_2_s;
        dac_dds_phase_11_0 <= dac_dds_phase_10_0 + dac_dds_incr_1_s;
        dac_dds_phase_11_1 <= dac_dds_phase_10_1 + dac_dds_incr_2_s;
        dac_dds_phase_12_0 <= dac_dds_phase_11_0 + dac_dds_incr_1_s;
        dac_dds_phase_12_1 <= dac_dds_phase_11_1 + dac_dds_incr_2_s;
        dac_dds_phase_13_0 <= dac_dds_phase_12_0 + dac_dds_incr_1_s;
        dac_dds_phase_13_1 <= dac_dds_phase_12_1 + dac_dds_incr_2_s;
        dac_dds_phase_14_0 <= dac_dds_phase_13_0 + dac_dds_incr_1_s;
        dac_dds_phase_14_1 <= dac_dds_phase_13_1 + dac_dds_incr_2_s;
        dac_dds_phase_15_0 <= dac_dds_phase_14_0 + dac_dds_incr_1_s;
        dac_dds_phase_15_1 <= dac_dds_phase_14_1 + dac_dds_incr_2_s;
        dac_dds_incr_0 <= {dac_dds_incr_1_s[11:0], 4'd0};
        dac_dds_incr_1 <= {dac_dds_incr_2_s[11:0], 4'd0};
        dac_dds_data <= 256'd0;
      end else begin
        dac_dds_phase_0_0 <= dac_dds_phase_0_0 + dac_dds_incr_0;
        dac_dds_phase_0_1 <= dac_dds_phase_0_1 + dac_dds_incr_1;
        dac_dds_phase_1_0 <= dac_dds_phase_1_0 + dac_dds_incr_0;
        dac_dds_phase_1_1 <= dac_dds_phase_1_1 + dac_dds_incr_1;
        dac_dds_phase_2_0 <= dac_dds_phase_2_0 + dac_dds_incr_0;
        dac_dds_phase_2_1 <= dac_dds_phase_2_1 + dac_dds_incr_1;
        dac_dds_phase_3_0 <= dac_dds_phase_3_0 + dac_dds_incr_0;
        dac_dds_phase_3_1 <= dac_dds_phase_3_1 + dac_dds_incr_1;
        dac_dds_phase_4_0 <= dac_dds_phase_4_0 + dac_dds_incr_1_s;
        dac_dds_phase_4_1 <= dac_dds_phase_4_1 + dac_dds_incr_2_s;
        dac_dds_phase_5_0 <= dac_dds_phase_5_0 + dac_dds_incr_1_s;
        dac_dds_phase_5_1 <= dac_dds_phase_5_1 + dac_dds_incr_2_s;
        dac_dds_phase_6_0 <= dac_dds_phase_6_0 + dac_dds_incr_1_s;
        dac_dds_phase_6_1 <= dac_dds_phase_6_1 + dac_dds_incr_2_s;
        dac_dds_phase_7_0 <= dac_dds_phase_7_0 + dac_dds_incr_1_s;
        dac_dds_phase_7_1 <= dac_dds_phase_7_1 + dac_dds_incr_2_s;
        dac_dds_phase_8_0 <= dac_dds_phase_8_0 + dac_dds_incr_1_s;
        dac_dds_phase_8_1 <= dac_dds_phase_8_1 + dac_dds_incr_2_s;
        dac_dds_phase_9_0 <= dac_dds_phase_9_0 + dac_dds_incr_1_s;
        dac_dds_phase_9_1 <= dac_dds_phase_9_1 + dac_dds_incr_2_s;
        dac_dds_phase_10_0 <= dac_dds_phase_10_0 + dac_dds_incr_1_s;
        dac_dds_phase_10_1 <= dac_dds_phase_10_1 + dac_dds_incr_2_s;
        dac_dds_phase_11_0 <= dac_dds_phase_11_0 + dac_dds_incr_1_s;
        dac_dds_phase_11_1 <= dac_dds_phase_11_1 + dac_dds_incr_2_s;
        dac_dds_phase_12_0 <= dac_dds_phase_12_0 + dac_dds_incr_1_s;
        dac_dds_phase_12_1 <= dac_dds_phase_12_1 + dac_dds_incr_2_s;
        dac_dds_phase_13_0 <= dac_dds_phase_13_0 + dac_dds_incr_1_s;
        dac_dds_phase_13_1 <= dac_dds_phase_13_1 + dac_dds_incr_2_s;
        dac_dds_phase_14_0 <= dac_dds_phase_14_0 + dac_dds_incr_1_s;
        dac_dds_phase_14_1 <= dac_dds_phase_14_1 + dac_dds_incr_2_s;
        dac_dds_phase_15_0 <= dac_dds_phase_15_0 + dac_dds_incr_1_s;
        dac_dds_phase_15_1 <= dac_dds_phase_15_1 + dac_dds_incr_2_s;
        dac_dds_incr_0 <= dac_dds_incr_0;
        dac_dds_incr_1 <= dac_dds_incr_1;
        dac_dds_data <= { dac_dds_data_15_s, dac_dds_data_14_s,
                          dac_dds_data_13_s, dac_dds_data_12_s,
                          dac_dds_data_11_s, dac_dds_data_10_s,
                          dac_dds_data_9_s, dac_dds_data_8_s,
                          dac_dds_data_7_s, dac_dds_data_6_s,
                          dac_dds_data_5_s, dac_dds_data_4_s,
                          dac_dds_data_3_s, dac_dds_data_2_s,
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
    
    generate
    if (DATAPATH_DISABLE == 1) begin
    assign dac_dds_data_4_s = 16'd0;
    end else begin
    ad_dds i_dds_4 (
      .clk (dac_clk),
      .dds_format (dac_dds_format),
      .dds_phase_0 (dac_dds_phase_4_0),
      .dds_scale_0 (dac_dds_scale_1_s),
      .dds_phase_1 (dac_dds_phase_4_1),
      .dds_scale_1 (dac_dds_scale_2_s),
      .dds_data (dac_dds_data_4_s));
    end
    endgenerate
    
    generate
    if (DATAPATH_DISABLE == 1) begin
    assign dac_dds_data_5_s = 16'd0;
    end else begin
    ad_dds i_dds_5 (
      .clk (dac_clk),
      .dds_format (dac_dds_format),
      .dds_phase_0 (dac_dds_phase_5_0),
      .dds_scale_0 (dac_dds_scale_1_s),
      .dds_phase_1 (dac_dds_phase_5_1),
      .dds_scale_1 (dac_dds_scale_2_s),
      .dds_data (dac_dds_data_5_s));
    end
    endgenerate
    
    generate
    if (DATAPATH_DISABLE == 1) begin
    assign dac_dds_data_6_s = 16'd0;
    end else begin
    ad_dds i_dds_6 (
      .clk (dac_clk),
      .dds_format (dac_dds_format),
      .dds_phase_0 (dac_dds_phase_6_0),
      .dds_scale_0 (dac_dds_scale_1_s),
      .dds_phase_1 (dac_dds_phase_6_1),
      .dds_scale_1 (dac_dds_scale_2_s),
      .dds_data (dac_dds_data_6_s));
    end
    endgenerate
    
    generate
    if (DATAPATH_DISABLE == 1) begin
    assign dac_dds_data_7_s = 16'd0;
    end else begin
    ad_dds i_dds_7 (
      .clk (dac_clk),
      .dds_format (dac_dds_format),
      .dds_phase_0 (dac_dds_phase_7_0),
      .dds_scale_0 (dac_dds_scale_1_s),
      .dds_phase_1 (dac_dds_phase_7_1),
      .dds_scale_1 (dac_dds_scale_2_s),
      .dds_data (dac_dds_data_7_s));
    end
    endgenerate
    
    generate
    if (DATAPATH_DISABLE == 1) begin
    assign dac_dds_data_8_s = 16'd0;
    end else begin
    ad_dds i_dds_8 (
      .clk (dac_clk),
      .dds_format (dac_dds_format),
      .dds_phase_0 (dac_dds_phase_8_0),
      .dds_scale_0 (dac_dds_scale_1_s),
      .dds_phase_1 (dac_dds_phase_8_1),
      .dds_scale_1 (dac_dds_scale_2_s),
      .dds_data (dac_dds_data_8_s));
    end
    endgenerate
    
    generate
    if (DATAPATH_DISABLE == 1) begin
    assign dac_dds_data_9_s = 16'd0;
    end else begin
    ad_dds i_dds_9 (
      .clk (dac_clk),
      .dds_format (dac_dds_format),
      .dds_phase_0 (dac_dds_phase_9_0),
      .dds_scale_0 (dac_dds_scale_1_s),
      .dds_phase_1 (dac_dds_phase_9_1),
      .dds_scale_1 (dac_dds_scale_2_s),
      .dds_data (dac_dds_data_9_s));
    end
    endgenerate
    
    generate
    if (DATAPATH_DISABLE == 1) begin
    assign dac_dds_data_10_s = 16'd0;
    end else begin
    ad_dds i_dds_10 (
      .clk (dac_clk),
      .dds_format (dac_dds_format),
      .dds_phase_0 (dac_dds_phase_10_0),
      .dds_scale_0 (dac_dds_scale_1_s),
      .dds_phase_1 (dac_dds_phase_10_1),
      .dds_scale_1 (dac_dds_scale_2_s),
      .dds_data (dac_dds_data_10_s));
    end
    endgenerate
    
    generate
    if (DATAPATH_DISABLE == 1) begin
    assign dac_dds_data_11_s = 16'd0;
    end else begin
    ad_dds i_dds_11 (
      .clk (dac_clk),
      .dds_format (dac_dds_format),
      .dds_phase_0 (dac_dds_phase_11_0),
      .dds_scale_0 (dac_dds_scale_1_s),
      .dds_phase_1 (dac_dds_phase_11_1),
      .dds_scale_1 (dac_dds_scale_2_s),
      .dds_data (dac_dds_data_11_s));
    end
    endgenerate
    
    generate
    if (DATAPATH_DISABLE == 1) begin
    assign dac_dds_data_12_s = 16'd0;
    end else begin
    ad_dds i_dds_12 (
      .clk (dac_clk),
      .dds_format (dac_dds_format),
      .dds_phase_0 (dac_dds_phase_12_0),
      .dds_scale_0 (dac_dds_scale_1_s),
      .dds_phase_1 (dac_dds_phase_12_1),
      .dds_scale_1 (dac_dds_scale_2_s),
      .dds_data (dac_dds_data_12_s));
    end
    endgenerate
    
    generate
    if (DATAPATH_DISABLE == 1) begin
    assign dac_dds_data_13_s = 16'd0;
    end else begin
    ad_dds i_dds_13 (
      .clk (dac_clk),
      .dds_format (dac_dds_format),
      .dds_phase_0 (dac_dds_phase_13_0),
      .dds_scale_0 (dac_dds_scale_1_s),
      .dds_phase_1 (dac_dds_phase_13_1),
      .dds_scale_1 (dac_dds_scale_2_s),
      .dds_data (dac_dds_data_13_s));
    end
    endgenerate
    
    generate
    if (DATAPATH_DISABLE == 1) begin
    assign dac_dds_data_14_s = 16'd0;
    end else begin
    ad_dds i_dds_14 (
      .clk (dac_clk),
      .dds_format (dac_dds_format),
      .dds_phase_0 (dac_dds_phase_14_0),
      .dds_scale_0 (dac_dds_scale_1_s),
      .dds_phase_1 (dac_dds_phase_14_1),
      .dds_scale_1 (dac_dds_scale_2_s),
      .dds_data (dac_dds_data_14_s));
    end
    endgenerate
    
    generate
    if (DATAPATH_DISABLE == 1) begin
    assign dac_dds_data_15_s = 16'd0;
    end else begin
    ad_dds i_dds_15 (
      .clk (dac_clk),
      .dds_format (dac_dds_format),
      .dds_phase_0 (dac_dds_phase_15_0),
      .dds_scale_0 (dac_dds_scale_1_s),
      .dds_phase_1 (dac_dds_phase_15_1),
      .dds_scale_1 (dac_dds_scale_2_s),
      .dds_data (dac_dds_data_15_s));
    end
    endgenerate
    
    // single channel processor
    
    up_dac_channel #(.DAC_CHANNEL_ID(CHANNEL_ID)) i_up_dac_channel (
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

