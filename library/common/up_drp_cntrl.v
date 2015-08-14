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

module up_drp_cntrl (

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

  // processor interface

  up_rstn,
  up_clk,
  up_drp_sel_t,
  up_drp_rwn,
  up_drp_addr,
  up_drp_wdata,
  up_drp_rdata,
  up_drp_status,
  up_drp_locked);

  // drp interface

  input           drp_clk;
  input           drp_rst;
  output          drp_sel;
  output          drp_wr;
  output  [11:0]  drp_addr;
  output  [15:0]  drp_wdata;
  input   [15:0]  drp_rdata;
  input           drp_ready;
  input           drp_locked;

  // processor interface

  input           up_rstn;
  input           up_clk;
  input           up_drp_sel_t;
  input           up_drp_rwn;
  input   [11:0]  up_drp_addr;
  input   [15:0]  up_drp_wdata;
  output  [15:0]  up_drp_rdata;
  output          up_drp_status;
  output          up_drp_locked;

  // internal registers

  reg             drp_sel_t_m1 = 'd0;
  reg             drp_sel_t_m2 = 'd0;
  reg             drp_sel_t_m3 = 'd0;
  reg             drp_sel = 'd0;
  reg             drp_wr = 'd0;
  reg     [11:0]  drp_addr = 'd0;
  reg     [15:0]  drp_wdata = 'd0;
  reg             drp_ready_int = 'd0;
  reg     [15:0]  drp_rdata_int = 'd0;
  reg             drp_ack_t = 'd0;
  reg             up_drp_locked_m1 = 'd0;
  reg             up_drp_locked = 'd0;
  reg             up_drp_ack_t_m1 = 'd0;
  reg             up_drp_ack_t_m2 = 'd0;
  reg             up_drp_ack_t_m3 = 'd0;
  reg             up_drp_sel_t_d = 'd0;
  reg             up_drp_status = 'd0;
  reg     [15:0]  up_drp_rdata = 'd0;

  // internal signals

  wire            drp_sel_t_s;
  wire            up_drp_ack_t_s;
  wire            up_drp_sel_t_s;

  // drp control and status

  assign drp_sel_t_s = drp_sel_t_m2 ^ drp_sel_t_m3;

  always @(posedge drp_clk) begin
    if (drp_rst == 1'b1) begin
      drp_sel_t_m1 <= 'd0;
      drp_sel_t_m2 <= 'd0;
      drp_sel_t_m3 <= 'd0;
    end else begin
      drp_sel_t_m1 <= up_drp_sel_t;
      drp_sel_t_m2 <= drp_sel_t_m1;
      drp_sel_t_m3 <= drp_sel_t_m2;
    end
  end

  always @(posedge drp_clk) begin
    if (drp_sel_t_s == 1'b1) begin
      drp_sel <= 1'b1;
      drp_wr <= ~up_drp_rwn;
      drp_addr <= up_drp_addr;
      drp_wdata <= up_drp_wdata;
    end else begin
      drp_sel <= 1'b0;
      drp_wr <= 1'b0;
      drp_addr <= 12'd0;
      drp_wdata <= 16'd0;
    end
  end

  always @(posedge drp_clk) begin
    drp_ready_int <= drp_ready;
    if ((drp_ready_int == 1'b0) && (drp_ready == 1'b1)) begin
      drp_rdata_int <= drp_rdata;
      drp_ack_t <= ~drp_ack_t;
    end
  end


  // drp status transfer

  assign up_drp_ack_t_s = up_drp_ack_t_m3 ^ up_drp_ack_t_m2;
  assign up_drp_sel_t_s = up_drp_sel_t ^ up_drp_sel_t_d;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_drp_locked_m1 <= 'd0;
      up_drp_locked <= 'd0;
      up_drp_ack_t_m1 <= 'd0;
      up_drp_ack_t_m2 <= 'd0;
      up_drp_ack_t_m3 <= 'd0;
      up_drp_sel_t_d <= 'd0;
      up_drp_status <= 'd0;
      up_drp_rdata <= 'd0;
    end else begin
      up_drp_locked_m1 <= drp_locked;
      up_drp_locked <= up_drp_locked_m1;
      up_drp_ack_t_m1 <= drp_ack_t;
      up_drp_ack_t_m2 <= up_drp_ack_t_m1;
      up_drp_ack_t_m3 <= up_drp_ack_t_m2;
      up_drp_sel_t_d <= up_drp_sel_t;
      if (up_drp_ack_t_s == 1'b1) begin
        up_drp_status <= 1'b0;
      end else if (up_drp_sel_t_s == 1'b1) begin
        up_drp_status <= 1'b1;
      end
      if (up_drp_ack_t_s == 1'b1) begin
        up_drp_rdata <= drp_rdata_int;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
