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

module axi_fifo2s (

  // fifo interface

  m_rst,
  m_clk,
  m_wr,
  m_wdata,
  m_wovf,

  axi_mwr,
  axi_mwdata,
  axi_mwovf,
  axi_mwpfull,

  // axi interface

  axi_clk,
  axi_resetn,
  axi_awvalid,
  axi_awid,
  axi_awburst,
  axi_awlock,
  axi_awcache,
  axi_awprot,
  axi_awqos,
  axi_awuser,
  axi_awlen,
  axi_awsize,
  axi_awaddr,
  axi_awready,
  axi_wvalid,
  axi_wdata,
  axi_wstrb,
  axi_wlast,
  axi_wuser,
  axi_wready,
  axi_bvalid,
  axi_bid,
  axi_bresp,
  axi_buser,
  axi_bready,
  axi_arvalid,
  axi_arid,
  axi_arburst,
  axi_arlock,
  axi_arcache,
  axi_arprot,
  axi_arqos,
  axi_aruser,
  axi_arlen,
  axi_arsize,
  axi_araddr,
  axi_arready,
  axi_rvalid,
  axi_rid,
  axi_ruser,
  axi_rresp,
  axi_rlast,
  axi_rdata,
  axi_rready,

  // transfer request

  axi_xfer_req,
  axi_xfer_status);

  // parameters

  parameter   DATA_WIDTH = 32;
  parameter   AXI_SIZE = 2;
  parameter   AXI_LENGTH = 16;
  parameter   AXI_ADDRESS = 32'h00000000;
  parameter   AXI_ADDRLIMIT = 32'h00000000;

  // fifo interface

  input                           m_rst;
  input                           m_clk;
  input                           m_wr;
  input   [DATA_WIDTH-1:0]        m_wdata;
  output                          m_wovf;

  output                          axi_mwr;
  output  [DATA_WIDTH-1:0]        axi_mwdata;
  input                           axi_mwovf;
  input                           axi_mwpfull;

  // axi interface

  input                           axi_clk;
  input                           axi_resetn;
  output                          axi_awvalid;
  output  [  3:0]                 axi_awid;
  output  [  1:0]                 axi_awburst;
  output                          axi_awlock;
  output  [  3:0]                 axi_awcache;
  output  [  2:0]                 axi_awprot;
  output  [  3:0]                 axi_awqos;
  output  [  3:0]                 axi_awuser;
  output  [  7:0]                 axi_awlen;
  output  [  2:0]                 axi_awsize;
  output  [ 31:0]                 axi_awaddr;
  input                           axi_awready;
  output                          axi_wvalid;
  output  [DATA_WIDTH-1:0]        axi_wdata;
  output  [(DATA_WIDTH/8)-1:0]    axi_wstrb;
  output                          axi_wlast;
  output  [  3:0]                 axi_wuser;
  input                           axi_wready;
  input                           axi_bvalid;
  input   [  3:0]                 axi_bid;
  input   [  1:0]                 axi_bresp;
  input   [  3:0]                 axi_buser;
  output                          axi_bready;
  output                          axi_arvalid;
  output  [  3:0]                 axi_arid;
  output  [  1:0]                 axi_arburst;
  output                          axi_arlock;
  output  [  3:0]                 axi_arcache;
  output  [  2:0]                 axi_arprot;
  output  [  3:0]                 axi_arqos;
  output  [  3:0]                 axi_aruser;
  output  [  7:0]                 axi_arlen;
  output  [  2:0]                 axi_arsize;
  output  [ 31:0]                 axi_araddr;
  input                           axi_arready;
  input                           axi_rvalid;
  input   [  3:0]                 axi_rid;
  input   [  3:0]                 axi_ruser;
  input   [  1:0]                 axi_rresp;
  input                           axi_rlast;
  input   [DATA_WIDTH-1:0]        axi_rdata;
  output                          axi_rready;

  // transfer request & status

  input                           axi_xfer_req;
  output  [  4:0]                 axi_xfer_status;

  // internal registers

  reg     [  4:0]                 axi_xfer_status = 'd0;
  reg     [  4:0]                 axi_status_cnt = 'd0;
  reg                             m_wovf_m = 'd0;
  reg                             m_wovf = 'd0;

  // internal signals

  wire                            axi_rd_req_s;
  wire    [ 31:0]                 axi_rd_addr_s;
  wire                            axi_dwovf_s;
  wire                            axi_dwunf_s;
  wire                            axi_werror_s;
  wire                            axi_rerror_s;

  // status signals

  always @(posedge axi_clk) begin
    if (axi_resetn == 1'b0) begin
      axi_xfer_status <= 'd0;
      axi_status_cnt <= 'd0;
    end else begin
      axi_xfer_status[4] <= axi_rerror_s;
      axi_xfer_status[3] <= axi_werror_s;
      axi_xfer_status[2] <= axi_dwunf_s;
      axi_xfer_status[1] <= axi_dwovf_s;
      axi_xfer_status[0] <= axi_mwovf;
      if (axi_xfer_status == 0) begin
        if (axi_status_cnt[4] == 1'b1) begin
          axi_status_cnt <= axi_status_cnt + 1'b1;
        end
      end else begin
        axi_status_cnt <= 5'd10;
      end
    end
  end

  always @(posedge m_clk) begin
    if (m_rst == 1'b1) begin
      m_wovf_m <= 'd0;
      m_wovf <= 'd0;
    end else begin
      m_wovf_m <= axi_status_cnt[4];
      m_wovf <= m_wovf_m;
    end
  end

  // instantiations

  axi_fifo2s_wr #(
    .DATA_WIDTH (DATA_WIDTH),
    .AXI_SIZE (AXI_SIZE),
    .AXI_LENGTH (AXI_LENGTH),
    .AXI_ADDRESS (AXI_ADDRESS),
    .AXI_ADDRLIMIT (AXI_ADDRLIMIT))
  i_wr (
    .axi_xfer_req (axi_xfer_req),
    .axi_rd_req (axi_rd_req_s),
    .axi_rd_addr (axi_rd_addr_s),
    .m_rst (m_rst),
    .m_clk (m_clk),
    .m_wr (m_wr),
    .m_wdata (m_wdata),
    .axi_clk (axi_clk),
    .axi_resetn (axi_resetn),
    .axi_awvalid (axi_awvalid),
    .axi_awid (axi_awid),
    .axi_awburst (axi_awburst),
    .axi_awlock (axi_awlock),
    .axi_awcache (axi_awcache),
    .axi_awprot (axi_awprot),
    .axi_awqos (axi_awqos),
    .axi_awuser (axi_awuser),
    .axi_awlen (axi_awlen),
    .axi_awsize (axi_awsize),
    .axi_awaddr (axi_awaddr),
    .axi_awready (axi_awready),
    .axi_wvalid (axi_wvalid),
    .axi_wdata (axi_wdata),
    .axi_wstrb (axi_wstrb),
    .axi_wlast (axi_wlast),
    .axi_wuser (axi_wuser),
    .axi_wready (axi_wready),
    .axi_bvalid (axi_bvalid),
    .axi_bid (axi_bid),
    .axi_bresp (axi_bresp),
    .axi_buser (axi_buser),
    .axi_bready (axi_bready),
    .axi_dwovf (axi_dwovf_s),
    .axi_dwunf (axi_dwunf_s),
    .axi_werror (axi_werror_s));

  axi_fifo2s_rd #(
    .DATA_WIDTH (DATA_WIDTH),
    .AXI_SIZE (AXI_SIZE),
    .AXI_LENGTH (AXI_LENGTH),
    .AXI_ADDRESS (AXI_ADDRESS),
    .AXI_ADDRLIMIT (AXI_ADDRLIMIT))
  i_rd (
    .axi_xfer_req (axi_xfer_req),
    .axi_rd_req (axi_rd_req_s),
    .axi_rd_addr (axi_rd_addr_s),
    .axi_clk (axi_clk),
    .axi_resetn (axi_resetn),
    .axi_arvalid (axi_arvalid),
    .axi_arid (axi_arid),
    .axi_arburst (axi_arburst),
    .axi_arlock (axi_arlock),
    .axi_arcache (axi_arcache),
    .axi_arprot (axi_arprot),
    .axi_arqos (axi_arqos),
    .axi_aruser (axi_aruser),
    .axi_arlen (axi_arlen),
    .axi_arsize (axi_arsize),
    .axi_araddr (axi_araddr),
    .axi_arready (axi_arready),
    .axi_rvalid (axi_rvalid),
    .axi_rid (axi_rid),
    .axi_ruser (axi_ruser),
    .axi_rresp (axi_rresp),
    .axi_rlast (axi_rlast),
    .axi_rdata (axi_rdata),
    .axi_rready (axi_rready),
    .axi_rerror (axi_rerror_s),
    .axi_mwr (axi_mwr),
    .axi_mwdata (axi_mwdata),
    .axi_mwpfull (axi_mwpfull));

endmodule

// ***************************************************************************
// ***************************************************************************
