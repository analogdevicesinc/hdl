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

module up_delay_cntrl (

  // delay interface

  delay_clk,
  delay_rst,
  delay_sel,
  delay_rwn,
  delay_addr,
  delay_wdata,
  delay_rdata,
  delay_ack_t,
  delay_locked,

  // processor interface

  up_rstn,
  up_clk,
  up_delay_sel,
  up_delay_rwn,
  up_delay_addr,
  up_delay_wdata,
  up_delay_rdata,
  up_delay_status,
  up_delay_locked);

  // delay interface

  input           delay_clk;
  input           delay_rst;
  output          delay_sel;
  output          delay_rwn;
  output  [ 7:0]  delay_addr;
  output  [ 4:0]  delay_wdata;
  input   [ 4:0]  delay_rdata;
  input           delay_ack_t;
  input           delay_locked;

  // processor interface

  input           up_rstn;
  input           up_clk;
  input           up_delay_sel;
  input           up_delay_rwn;
  input   [ 7:0]  up_delay_addr;
  input   [ 4:0]  up_delay_wdata;
  output  [ 4:0]  up_delay_rdata;
  output          up_delay_status;
  output          up_delay_locked;

  // internal registers

  reg             delay_sel_m1 = 'd0;
  reg             delay_sel_m2 = 'd0;
  reg             delay_sel_m3 = 'd0;
  reg             delay_sel = 'd0;
  reg             delay_rwn = 'd0;
  reg     [ 7:0]  delay_addr = 'd0;
  reg     [ 4:0]  delay_wdata = 'd0;
  reg             up_delay_locked_m1 = 'd0;
  reg             up_delay_locked = 'd0;
  reg             up_delay_ack_t_m1 = 'd0;
  reg             up_delay_ack_t_m2 = 'd0;
  reg             up_delay_ack_t_m3 = 'd0;
  reg             up_delay_sel_d = 'd0;
  reg             up_delay_status = 'd0;
  reg     [ 4:0]  up_delay_rdata = 'd0;

  // internal signals

  wire            up_delay_ack_t_s;
  wire            up_delay_sel_s;

  // delay control transfer

  always @(posedge delay_clk) begin
    if (delay_rst == 1'b1) begin
      delay_sel_m1 <= 'd0;
      delay_sel_m2 <= 'd0;
      delay_sel_m3 <= 'd0;
    end else begin
      delay_sel_m1 <= up_delay_sel;
      delay_sel_m2 <= delay_sel_m1;
      delay_sel_m3 <= delay_sel_m2;
    end
  end

  always @(posedge delay_clk) begin
    delay_sel <= delay_sel_m2 & ~delay_sel_m3;
    if ((delay_sel_m2 == 1'b1) && (delay_sel_m3 == 1'b0)) begin
      delay_rwn <= up_delay_rwn;
      delay_addr <= up_delay_addr;
      delay_wdata <= up_delay_wdata;
    end
  end

  // delay status transfer

  assign up_delay_ack_t_s = up_delay_ack_t_m3 ^ up_delay_ack_t_m2;
  assign up_delay_sel_s = up_delay_sel & ~up_delay_sel_d;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_delay_locked_m1 <= 'd0;
      up_delay_locked <= 'd0;
      up_delay_ack_t_m1 <= 'd0;
      up_delay_ack_t_m2 <= 'd0;
      up_delay_ack_t_m3 <= 'd0;
      up_delay_sel_d <= 'd0;
      up_delay_status <= 'd0;
      up_delay_rdata <= 'd0;
    end else begin
      up_delay_locked_m1 <= delay_locked;
      up_delay_locked <= up_delay_locked_m1;
      up_delay_ack_t_m1 <= delay_ack_t;
      up_delay_ack_t_m2 <= up_delay_ack_t_m1;
      up_delay_ack_t_m3 <= up_delay_ack_t_m2;
      up_delay_sel_d <= up_delay_sel;
      if (up_delay_ack_t_s == 1'b1) begin
        up_delay_status <= 1'b0;
      end else if (up_delay_sel_s == 1'b1) begin
        up_delay_status <= 1'b1;
      end
      if (up_delay_ack_t_s == 1'b1) begin
        up_delay_rdata <= delay_rdata;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
