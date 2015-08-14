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
// This is the dac physical interface (drives samples from the low speed clock to the
// dac clock domain.

`timescale 1ns/100ps

module axi_ad9122_if (

  // dac interface

  dac_clk_in_p,
  dac_clk_in_n,
  dac_clk_out_p,
  dac_clk_out_n,
  dac_frame_out_p,
  dac_frame_out_n,
  dac_data_out_p,
  dac_data_out_n,

  // internal resets and clocks

  dac_rst,
  dac_clk,
  dac_div_clk,
  dac_status,

  // data interface

  dac_frame_i0,
  dac_data_i0,
  dac_frame_i1,
  dac_data_i1,
  dac_frame_i2,
  dac_data_i2,
  dac_frame_i3,
  dac_data_i3,

  dac_frame_q0,
  dac_data_q0,
  dac_frame_q1,
  dac_data_q1,
  dac_frame_q2,
  dac_data_q2,
  dac_frame_q3,
  dac_data_q3,

  // mmcm reset

  mmcm_rst,

  // drp interface

  up_clk,
  up_rstn,
  up_drp_sel,
  up_drp_wr,
  up_drp_addr,
  up_drp_wdata,
  up_drp_rdata,
  up_drp_ready,
  up_drp_locked);

  // parameters

  parameter   PCORE_DEVICE_TYPE = 0;
  parameter   PCORE_SERDES_DDR_N = 1;
  parameter   PCORE_MMCM_BUFIO_N = 1;
  parameter   PCORE_IODELAY_GROUP = "dac_if_delay_group";

  // dac interface

  input           dac_clk_in_p;
  input           dac_clk_in_n;
  output          dac_clk_out_p;
  output          dac_clk_out_n;
  output          dac_frame_out_p;
  output          dac_frame_out_n;
  output  [15:0]  dac_data_out_p;
  output  [15:0]  dac_data_out_n;

  // internal resets and clocks

  input           dac_rst;
  output          dac_clk;
  output          dac_div_clk;
  output          dac_status;

  // data interface

  input           dac_frame_i0;
  input   [15:0]  dac_data_i0;
  input           dac_frame_i1;
  input   [15:0]  dac_data_i1;
  input           dac_frame_i2;
  input   [15:0]  dac_data_i2;
  input           dac_frame_i3;
  input   [15:0]  dac_data_i3;

  input           dac_frame_q0;
  input   [15:0]  dac_data_q0;
  input           dac_frame_q1;
  input   [15:0]  dac_data_q1;
  input           dac_frame_q2;
  input   [15:0]  dac_data_q2;
  input           dac_frame_q3;
  input   [15:0]  dac_data_q3;

  // mmcm reset

  input           mmcm_rst;

  // drp interface

  input           up_clk;
  input           up_rstn;
  input           up_drp_sel;
  input           up_drp_wr;
  input   [11:0]  up_drp_addr;
  input   [15:0]  up_drp_wdata;
  output  [15:0]  up_drp_rdata;
  output          up_drp_ready;
  output          up_drp_locked;

  // internal registers

  reg             dac_status_m1 = 'd0;
  reg             dac_status = 'd0;

  // dac status

  always @(posedge dac_div_clk) begin
    if (dac_rst == 1'b1) begin
      dac_status_m1 <= 1'd0;
      dac_status <= 1'd0;
    end else begin
      dac_status_m1 <= up_drp_locked;
      dac_status <= dac_status_m1;
    end
  end

  // dac data output serdes(s) & buffers

  ad_serdes_out #(
    .DEVICE_TYPE (PCORE_DEVICE_TYPE),
    .SERDES(PCORE_SERDES_DDR_N),
    .DATA_WIDTH(16))
  i_serdes_out_data (
    .rst (dac_rst),
    .clk (dac_clk),
    .div_clk (dac_div_clk),
    .data_s0 (dac_data_i0),
    .data_s1 (dac_data_q0),
    .data_s2 (dac_data_i1),
    .data_s3 (dac_data_q1),
    .data_s4 (dac_data_i2),
    .data_s5 (dac_data_q2),
    .data_s6 (dac_data_i3),
    .data_s7 (dac_data_q3),
    .data_out_p (dac_data_out_p),
    .data_out_n (dac_data_out_n));

  // dac frame output serdes & buffer
  
  ad_serdes_out #(
    .DEVICE_TYPE (PCORE_DEVICE_TYPE),
    .SERDES(PCORE_SERDES_DDR_N),
    .DATA_WIDTH(1))
  i_serdes_out_frame (
    .rst (dac_rst),
    .clk (dac_clk),
    .div_clk (dac_div_clk),
    .data_s0 (dac_frame_i0),
    .data_s1 (dac_frame_q0),
    .data_s2 (dac_frame_i1),
    .data_s3 (dac_frame_q1),
    .data_s4 (dac_frame_i2),
    .data_s5 (dac_frame_q2),
    .data_s6 (dac_frame_i3),
    .data_s7 (dac_frame_q3),
    .data_out_p (dac_frame_out_p),
    .data_out_n (dac_frame_out_n));

  // dac clock output serdes & buffer
  
  ad_serdes_out #(
    .DEVICE_TYPE (PCORE_DEVICE_TYPE),
    .SERDES(PCORE_SERDES_DDR_N),
    .DATA_WIDTH(1))
  i_serdes_out_clk (
    .rst (dac_rst),
    .clk (dac_clk),
    .div_clk (dac_div_clk),
    .data_s0 (1'b1),
    .data_s1 (1'b0),
    .data_s2 (1'b1),
    .data_s3 (1'b0),
    .data_s4 (1'b1),
    .data_s5 (1'b0),
    .data_s6 (1'b1),
    .data_s7 (1'b0),
    .data_out_p (dac_clk_out_p),
    .data_out_n (dac_clk_out_n));

  // dac clock input buffers

  ad_serdes_clk #(
    .SERDES (PCORE_SERDES_DDR_N),
    .MMCM (PCORE_MMCM_BUFIO_N),
    .MMCM_DEVICE_TYPE (PCORE_DEVICE_TYPE),
    .MMCM_CLKIN_PERIOD (1.667),
    .MMCM_VCO_DIV (6),
    .MMCM_VCO_MUL (12),
    .MMCM_CLK0_DIV (2),
    .MMCM_CLK1_DIV (8))
  i_serdes_clk (
    .mmcm_rst (mmcm_rst),
    .clk_in_p (dac_clk_in_p),
    .clk_in_n (dac_clk_in_n),
    .clk (dac_clk),
    .div_clk (dac_div_clk),
    .up_clk (up_clk),
    .up_rstn (up_rstn),
    .up_drp_sel (up_drp_sel),
    .up_drp_wr (up_drp_wr),
    .up_drp_addr (up_drp_addr),
    .up_drp_wdata (up_drp_wdata),
    .up_drp_rdata (up_drp_rdata),
    .up_drp_ready (up_drp_ready),
    .up_drp_locked (up_drp_locked));

endmodule

// ***************************************************************************
// ***************************************************************************
