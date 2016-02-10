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

module up_delay_cntrl (

  // delay interface

  delay_clk,
  delay_rst,
  delay_locked,

  // io interface

  up_dld,
  up_dwdata,
  up_drdata,

  // processor interface

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

  parameter   DATA_WIDTH = 8;
  parameter   BASE_ADDRESS = 6'h02;

  // delay interface

  input                           delay_clk;
  output                          delay_rst;
  input                           delay_locked;

  // io interface

  output  [(DATA_WIDTH-1):0]      up_dld;
  output  [((DATA_WIDTH*5)-1):0]  up_dwdata;
  input   [((DATA_WIDTH*5)-1):0]  up_drdata;

  // processor interface

  input                           up_rstn;
  input                           up_clk;
  input                           up_wreq;
  input   [13:0]                  up_waddr;
  input   [31:0]                  up_wdata;
  output                          up_wack;
  input                           up_rreq;
  input   [13:0]                  up_raddr;
  output  [31:0]                  up_rdata;
  output                          up_rack;

  // internal registers
  
  reg                             up_preset = 'd0;
  reg                             up_wack = 'd0;
  reg                             up_rack = 'd0;
  reg     [31:0]                  up_rdata = 'd0;
  reg                             up_dlocked_m1 = 'd0;
  reg                             up_dlocked = 'd0;
  reg     [(DATA_WIDTH-1):0]      up_dld = 'd0;
  reg     [((DATA_WIDTH*5)-1):0]  up_dwdata = 'd0;

  // internal signals

  wire                            up_wreq_s;
  wire                            up_rreq_s;
  wire    [ 4:0]                  up_rdata_s;
  wire    [(DATA_WIDTH-1):0]      up_drdata4_s;
  wire    [(DATA_WIDTH-1):0]      up_drdata3_s;
  wire    [(DATA_WIDTH-1):0]      up_drdata2_s;
  wire    [(DATA_WIDTH-1):0]      up_drdata1_s;
  wire    [(DATA_WIDTH-1):0]      up_drdata0_s;

  // variables

  genvar                          n;

  // decode block select

  assign up_wreq_s = (up_waddr[13:8] == BASE_ADDRESS) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[13:8] == BASE_ADDRESS) ? up_rreq : 1'b0;
  assign up_rdata_s[4] = | up_drdata4_s;
  assign up_rdata_s[3] = | up_drdata3_s;
  assign up_rdata_s[2] = | up_drdata2_s;
  assign up_rdata_s[1] = | up_drdata1_s;
  assign up_rdata_s[0] = | up_drdata0_s;

  generate
  for (n = 0; n < DATA_WIDTH; n = n + 1) begin: g_drd
  assign up_drdata4_s[n] = (up_raddr[7:0] == n) ? up_drdata[((n*5)+4)] : 1'd0;
  assign up_drdata3_s[n] = (up_raddr[7:0] == n) ? up_drdata[((n*5)+3)] : 1'd0;
  assign up_drdata2_s[n] = (up_raddr[7:0] == n) ? up_drdata[((n*5)+2)] : 1'd0;
  assign up_drdata1_s[n] = (up_raddr[7:0] == n) ? up_drdata[((n*5)+1)] : 1'd0;
  assign up_drdata0_s[n] = (up_raddr[7:0] == n) ? up_drdata[((n*5)+0)] : 1'd0;
  end
  endgenerate

  // processor interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_preset <= 1'd1;
      up_wack <= 'd0;
      up_rack <= 'd0;
      up_rdata <= 'd0;
      up_dlocked_m1 <= 'd0;
      up_dlocked <= 'd0;
    end else begin
      up_preset <= 1'd0;
      up_wack <= up_wreq_s;
      up_rack <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        if (up_dlocked == 1'b0) begin
          up_rdata <= 32'hffffffff;
        end else begin
          up_rdata <= {27'd0, up_rdata_s};
        end
      end else begin
        up_rdata <= 32'd0;
      end
      up_dlocked_m1 <= delay_locked;
      up_dlocked <= up_dlocked_m1;
    end
  end

  // write does not hold- read back what goes into effect. 

  generate
  for (n = 0; n < DATA_WIDTH; n = n + 1) begin: g_dwr
  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_dld[n] <= 'd0;
      up_dwdata[((n*5)+4):(n*5)] <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == n)) begin
        up_dld[n] <= 1'd1;
        up_dwdata[((n*5)+4):(n*5)] <= up_wdata[4:0];
      end else begin
        up_dld[n] <= 1'd0;
        up_dwdata[((n*5)+4):(n*5)] <= up_dwdata[((n*5)+4):(n*5)];
      end
    end
  end
  end
  endgenerate

  // resets

  ad_rst i_delay_rst_reg (
    .preset (up_preset),
    .clk (delay_clk),
    .rst (delay_rst));

endmodule

// ***************************************************************************
// ***************************************************************************
