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

module axi_ad9361_tx (

  // dac interface

  dac_clk,
  dac_valid,
  dac_lb_enb_i1,
  dac_pn_enb_i1,
  dac_data_i1,
  dac_lb_enb_q1,
  dac_pn_enb_q1,
  dac_data_q1,
  dac_lb_enb_i2,
  dac_pn_enb_i2,
  dac_data_i2,
  dac_lb_enb_q2,
  dac_pn_enb_q2,
  dac_data_q2,
  dac_r1_mode,
  
  // transmit master/slave
  dac_enable_in,
  dac_enable_out,

  // dma interface

  dac_drd,
  dac_ddata,
  dac_dovf,
  dac_dunf,

  // processor interface

  up_rstn,
  up_clk,
  up_sel,
  up_wr,
  up_addr,
  up_wdata,
  up_rdata,
  up_ack);

  // parameters

  parameter   DP_DISABLE = 0;
  parameter   PCORE_ID = 0;

  // dac interface

  input           dac_clk;
  output          dac_valid;
  output          dac_lb_enb_i1;
  output          dac_pn_enb_i1;
  output  [11:0]  dac_data_i1;
  output          dac_lb_enb_q1;
  output          dac_pn_enb_q1;
  output  [11:0]  dac_data_q1;
  output          dac_lb_enb_i2;
  output          dac_pn_enb_i2;
  output  [11:0]  dac_data_i2;
  output          dac_lb_enb_q2;
  output          dac_pn_enb_q2;
  output  [11:0]  dac_data_q2;
  output          dac_r1_mode;
  
  // transmit master/slave
  input           dac_enable_in;
  output          dac_enable_out;

  // dma interface

  output          dac_drd;
  input   [63:0]  dac_ddata;
  input           dac_dovf;
  input           dac_dunf;

  // processor interface

  input           up_rstn;
  input           up_clk;
  input           up_sel;
  input           up_wr;
  input   [13:0]  up_addr;
  input   [31:0]  up_wdata;
  output  [31:0]  up_rdata;
  output          up_ack;

  // internal registers

  reg             dac_enable = 'd0;
  reg     [ 7:0]  dac_rate_cnt = 'd0;
  reg             dac_dds_enable = 'd0;
  reg             dac_dds_data_enable = 'd0;
  reg             dac_dds_data_enable_toggle = 'd0;
  reg             dac_drd = 'd0;
  reg     [63:0]  dac_dma_data = 'd0;
  reg     [15:0]  dac_dma_data_0 = 'd0;
  reg     [15:0]  dac_dma_data_1 = 'd0;
  reg     [15:0]  dac_dma_data_2 = 'd0;
  reg     [15:0]  dac_dma_data_3 = 'd0;
  reg             dac_valid = 'd0;
  reg     [11:0]  dac_data_i1 = 'd0;
  reg     [11:0]  dac_data_q1 = 'd0;
  reg     [11:0]  dac_data_i2 = 'd0;
  reg     [11:0]  dac_data_q2 = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg             up_ack = 'd0;

  // internal clock and resets

  wire            dac_rst;

  // internal signals

  wire            dac_enable_s;
  wire            dac_datafmt_s;
  wire    [ 3:0]  dac_datasel_s;
  wire    [ 7:0]  dac_datarate_s;
  wire    [15:0]  dac_dds_data_0_s;
  wire    [15:0]  dac_dds_data_1_s;
  wire    [15:0]  dac_dds_data_2_s;
  wire    [15:0]  dac_dds_data_3_s;
  wire    [31:0]  up_rdata_0_s;
  wire            up_ack_0_s;
  wire    [31:0]  up_rdata_1_s;
  wire            up_ack_1_s;
  wire    [31:0]  up_rdata_2_s;
  wire            up_ack_2_s;
  wire    [31:0]  up_rdata_3_s;
  wire            up_ack_3_s;
  wire    [31:0]  up_rdata_s;
  wire            up_ack_s;

  // master/slave
  assign dac_enable_s = (PCORE_ID == 0) ? dac_enable_out : dac_enable_in;
  
  always @(posedge dac_clk) begin
    dac_enable <= dac_enable_s;
  end
  
  // dds rate counters, dds phases are updated using data enables

  always @(posedge dac_clk) begin
    if ((dac_enable_s == 1'b0) || (dac_rate_cnt == 8'd0)) begin
      dac_rate_cnt <= dac_datarate_s;
    end else begin
      dac_rate_cnt <= dac_rate_cnt - 1'b1;
    end
    dac_dds_enable <= dac_enable_s;
    if (dac_rate_cnt == 8'd0) begin
      dac_dds_data_enable <= 1'b1;
    end else begin
      dac_dds_data_enable <= 1'b0;
    end
  end

  // dma interface

  always @(posedge dac_clk) begin
    if (dac_dds_data_enable == 1'b1) begin
      dac_dds_data_enable_toggle <= ~dac_dds_data_enable_toggle;
    end
    if (dac_r1_mode == 1'b1) begin
      dac_drd <= dac_dds_data_enable & dac_dds_data_enable_toggle & dac_enable;
    end else begin
      dac_drd <= dac_dds_data_enable & dac_enable;
    end
    if (dac_drd == 1'b1) begin
      dac_dma_data <= dac_ddata;
    end
    if (dac_dds_data_enable == 1'b1) begin
      if (dac_r1_mode == 1'b0) begin
        dac_dma_data_0 <= dac_dma_data[15: 0];
        dac_dma_data_1 <= dac_dma_data[31:16];
        dac_dma_data_2 <= dac_dma_data[47:32];
        dac_dma_data_3 <= dac_dma_data[63:48];
      end else if (dac_dds_data_enable_toggle == 1'b1) begin
        dac_dma_data_0 <= dac_dma_data[47:32];
        dac_dma_data_1 <= dac_dma_data[63:48];
        dac_dma_data_2 <= 16'd0;
        dac_dma_data_3 <= 16'd0;
      end else begin
        dac_dma_data_0 <= dac_dma_data[15: 0];
        dac_dma_data_1 <= dac_dma_data[31:16];
        dac_dma_data_2 <= 16'd0;
        dac_dma_data_3 <= 16'd0;
      end
    end
  end

  // dac outputs

  always @(posedge dac_clk) begin
    dac_valid <= dac_dds_data_enable;
    if (dac_datasel_s[3:1] == 3'd1) begin
      dac_data_i1 <= dac_dma_data_0[15:4];
      dac_data_q1 <= dac_dma_data_1[15:4];
      dac_data_i2 <= dac_dma_data_2[15:4];
      dac_data_q2 <= dac_dma_data_3[15:4];
    end else begin
      dac_data_i1 <= dac_dds_data_0_s[15:4];
      dac_data_q1 <= dac_dds_data_1_s[15:4];
      dac_data_i2 <= dac_dds_data_2_s[15:4];
      dac_data_q2 <= dac_dds_data_3_s[15:4];
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rdata <= 'd0;
      up_ack <= 'd0;
    end else begin
      up_rdata <= up_rdata_s |
        up_rdata_0_s |
        up_rdata_1_s |
        up_rdata_2_s |
        up_rdata_3_s;
      up_ack <= up_ack_s |
        up_ack_0_s | 
        up_ack_1_s | 
        up_ack_2_s | 
        up_ack_3_s;
    end
  end

  // dac channel
  
  axi_ad9361_tx_channel #(
    .CHID(0),
    .DP_DISABLE (DP_DISABLE))
  i_tx_channel_0 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_dds_data (dac_dds_data_0_s),
    .dac_dds_enable (dac_dds_enable),
    .dac_dds_data_enable (dac_dds_data_enable),
    .dac_dds_format (dac_datafmt_s),
    .dac_dds_pattenb (dac_datasel_s[0]),
    .dac_lb_enb (dac_lb_enb_i1),
    .dac_pn_enb (dac_pn_enb_i1),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel),
    .up_wr (up_wr),
    .up_addr (up_addr),
    .up_wdata (up_wdata),
    .up_rdata (up_rdata_0_s),
    .up_ack (up_ack_0_s));

  // dac channel
  
  axi_ad9361_tx_channel #(
    .CHID(1),
    .DP_DISABLE (DP_DISABLE))
  i_tx_channel_1 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_dds_data (dac_dds_data_1_s),
    .dac_dds_enable (dac_dds_enable),
    .dac_dds_data_enable (dac_dds_data_enable),
    .dac_dds_format (dac_datafmt_s),
    .dac_dds_pattenb (dac_datasel_s[0]),
    .dac_lb_enb (dac_lb_enb_q1),
    .dac_pn_enb (dac_pn_enb_q1),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel),
    .up_wr (up_wr),
    .up_addr (up_addr),
    .up_wdata (up_wdata),
    .up_rdata (up_rdata_1_s),
    .up_ack (up_ack_1_s));

  // dac channel
  
  axi_ad9361_tx_channel #(
    .CHID(2),
    .DP_DISABLE (DP_DISABLE))
  i_tx_channel_2 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_dds_data (dac_dds_data_2_s),
    .dac_dds_enable (dac_dds_enable),
    .dac_dds_data_enable (dac_dds_data_enable),
    .dac_dds_format (dac_datafmt_s),
    .dac_dds_pattenb (dac_datasel_s[0]),
    .dac_lb_enb (dac_lb_enb_i2),
    .dac_pn_enb (dac_pn_enb_i2),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel),
    .up_wr (up_wr),
    .up_addr (up_addr),
    .up_wdata (up_wdata),
    .up_rdata (up_rdata_2_s),
    .up_ack (up_ack_2_s));

  // dac channel
  
  axi_ad9361_tx_channel #(
    .CHID(3),
    .DP_DISABLE (DP_DISABLE))
  i_tx_channel_3 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_dds_data (dac_dds_data_3_s),
    .dac_dds_enable (dac_dds_enable),
    .dac_dds_data_enable (dac_dds_data_enable),
    .dac_dds_format (dac_datafmt_s),
    .dac_dds_pattenb (dac_datasel_s[0]),
    .dac_lb_enb (dac_lb_enb_q2),
    .dac_pn_enb (dac_pn_enb_q2),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel),
    .up_wr (up_wr),
    .up_addr (up_addr),
    .up_wdata (up_wdata),
    .up_rdata (up_rdata_3_s),
    .up_ack (up_ack_3_s));

  // dac common processor interface

  up_dac_common #(.PCORE_ID (PCORE_ID)) i_up_dac_common (
    .mmcm_rst (),
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_enable (dac_enable_out),
    .dac_frame (),
    .dac_par_type (),
    .dac_par_enb (),
    .dac_r1_mode (dac_r1_mode),
    .dac_datafmt (dac_datafmt_s),
    .dac_datasel (dac_datasel_s),
    .dac_datarate (dac_datarate_s),
    .dac_status (1'b1),
    .dac_status_ovf (dac_dovf),
    .dac_status_unf (dac_dunf),
    .dac_clk_ratio (32'd1),
    .drp_clk (1'b0),
    .drp_rst (),
    .drp_sel (),
    .drp_wr (),
    .drp_addr (),
    .drp_wdata (),
    .drp_rdata (16'd0),
    .drp_ready (1'd0),
    .drp_locked (1'd1),
    .up_usr_chanmax (),
    .dac_usr_chanmax (8'd3),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel),
    .up_wr (up_wr),
    .up_addr (up_addr),
    .up_wdata (up_wdata),
    .up_rdata (up_rdata_s),
    .up_ack (up_ack_s));
  
endmodule

// ***************************************************************************
// ***************************************************************************
