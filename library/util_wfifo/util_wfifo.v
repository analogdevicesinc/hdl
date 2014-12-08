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

module util_wfifo (

  rstn,

  m_clk,
  m_wr,
  m_wdata,
  m_wovf,
  s_clk,
  s_wr,
  s_wdata,
  s_wready,
  s_wovf,

  fifo_rst,
  fifo_wr,
  fifo_wdata,
  fifo_wfull,
  fifo_wovf,
  fifo_rd,
  fifo_rdata,
  fifo_rempty);

  // parameters (read (S) bus width must be greater than write (M))

  parameter M_DATA_WIDTH = 32;
  parameter S_DATA_WIDTH = 64;
  parameter S_READY_ENABLE = 0;
 
  // common clock

  input                           rstn;

  // master/slave write 

  input                           m_clk;
  input                           m_wr;
  input   [M_DATA_WIDTH-1:0]      m_wdata;
  output                          m_wovf;
  input                           s_clk;
  output                          s_wr;
  output  [S_DATA_WIDTH-1:0]      s_wdata;
  input                           s_wready;
  input                           s_wovf;

  // fifo interface

  output                          fifo_rst;
  output                          fifo_wr;
  output  [M_DATA_WIDTH-1:0]      fifo_wdata;
  input                           fifo_wfull;
  input                           fifo_wovf;
  output                          fifo_rd;
  input   [S_DATA_WIDTH-1:0]      fifo_rdata;
  input                           fifo_rempty;

  // internal registers

  reg                             m_wovf_m1 = 'd0;
  reg                             m_wovf_m2 = 'd0;
  reg                             m_wovf = 'd0;
  reg                             s_wr_int = 'd0;

  // internal signals

  wire                            m_wovf_s;
  wire    [S_DATA_WIDTH-1:0]      s_wdata_s;
  wire                            s_wready_s;

  // defaults

  assign fifo_rst = ~rstn;

  // write is pass through

  assign fifo_wr = m_wr;
  assign m_wovf_s = s_wovf | fifo_wovf;

  genvar m;
  generate
  for (m = 0; m < M_DATA_WIDTH; m = m + 1) begin: g_wdata
  assign fifo_wdata[m] = m_wdata[(M_DATA_WIDTH-1)-m];
  end
  endgenerate

  always @(posedge m_clk) begin
    if (rstn == 1'b0) begin
      m_wovf_m1 <= 1'b0;
      m_wovf_m2 <= 1'b0;
    end else begin
      m_wovf_m1 <= m_wovf_s;
      m_wovf_m2 <= m_wovf_m1;
      m_wovf    <= m_wovf_m2;
    end
  end

  // read is non-destructive

  assign s_wready_s = (S_READY_ENABLE == 0) ? 1'b1 : s_wready;
  assign fifo_rd = ~fifo_rempty & s_wready_s;

  always @(posedge s_clk) begin
    s_wr_int <= fifo_rd;
  end
  
  genvar s;
  generate
  for (s = 0; s < S_DATA_WIDTH; s = s + 1) begin: g_rdata
  assign s_wdata_s[s] = fifo_rdata[(S_DATA_WIDTH-1)-s];
  end
  endgenerate

  ad_axis_inf_rx #(.DATA_WIDTH(S_DATA_WIDTH)) i_axis_inf (
    .clk (s_clk),
    .rst (fifo_rst),
    .valid (s_wr_int),
    .last (1'd0),
    .data (s_wdata_s),
    .inf_valid (s_wr),
    .inf_last (),
    .inf_data (s_wdata),
    .inf_ready (s_wready_s));

endmodule

// ***************************************************************************
// ***************************************************************************
