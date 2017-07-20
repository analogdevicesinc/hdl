// ***************************************************************************
// ***************************************************************************
// Copyright 2016(c) Analog Devices, Inc.
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

module axi_dacfifo_wr (

  // dma fifo interface

  dma_clk,
  dma_data,
  dma_ready,
  dma_ready_out,
  dma_valid,

  // request and syncronizaiton

  dma_xfer_req,
  dma_xfer_last,
  dma_last_beats,

  // syncronization for the read side

  axi_last_addr,
  axi_last_beats,
  axi_xfer_out,

  // axi write address, write data and write response channels

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

  axi_werror);

  // parameters

  parameter       AXI_DATA_WIDTH = 512;
  parameter       DMA_DATA_WIDTH = 64;
  parameter       AXI_SIZE = 6;                     // axi_awsize format
  parameter       AXI_LENGTH = 15;                  // axi_awlength format
  parameter       AXI_ADDRESS = 32'h00000000;
  parameter       AXI_ADDRESS_LIMIT = 32'h00000000;
  parameter       DMA_MEM_ADDRESS_WIDTH = 8;

  // for the syncronization buffer

  localparam      MEM_RATIO = AXI_DATA_WIDTH/DMA_DATA_WIDTH;  // Max supported MEM_RATIO is 16
  localparam      AXI_MEM_ADDRESS_WIDTH = (MEM_RATIO == 1) ?  DMA_MEM_ADDRESS_WIDTH :
                                          (MEM_RATIO == 2) ? (DMA_MEM_ADDRESS_WIDTH - 1) :
                                          (MEM_RATIO == 4) ? (DMA_MEM_ADDRESS_WIDTH - 2) :
                                          (MEM_RATIO == 8) ? (DMA_MEM_ADDRESS_WIDTH - 3) :
                                                             (DMA_MEM_ADDRESS_WIDTH - 4);

  // for the AXI interface

  localparam      AXI_BYTE_WIDTH = AXI_DATA_WIDTH/8;
  localparam      DMA_BYTE_WIDTH = DMA_DATA_WIDTH/8;
  localparam      AXI_AWINCR = (AXI_LENGTH + 1) * AXI_BYTE_WIDTH;
  localparam      DMA_BUF_THRESHOLD_HI = {(DMA_MEM_ADDRESS_WIDTH){1'b1}} - 4;

  // dma fifo interface

  input                                     dma_clk;
  input   [(DMA_DATA_WIDTH-1):0]            dma_data;
  input                                     dma_ready;
  output                                    dma_ready_out;
  input                                     dma_valid;

  input                                     dma_xfer_req;
  input                                     dma_xfer_last;
  output  [ 3:0]                            dma_last_beats;

  output  [31:0]                            axi_last_addr;
  output  [ 3:0]                            axi_last_beats;
  output                                    axi_xfer_out;

  // axi interface

  input                                     axi_clk;
  input                                     axi_resetn;
  output                                    axi_awvalid;
  output  [ 3:0]                            axi_awid;
  output  [ 1:0]                            axi_awburst;
  output                                    axi_awlock;
  output  [ 3:0]                            axi_awcache;
  output  [ 2:0]                            axi_awprot;
  output  [ 3:0]                            axi_awqos;
  output  [ 3:0]                            axi_awuser;
  output  [ 7:0]                            axi_awlen;
  output  [ 2:0]                            axi_awsize;
  output  [31:0]                            axi_awaddr;
  input                                     axi_awready;
  output                                    axi_wvalid;
  output  [(AXI_DATA_WIDTH-1):0]            axi_wdata;
  output  [(AXI_BYTE_WIDTH-1):0]            axi_wstrb;
  output                                    axi_wlast;
  output  [ 3:0]                            axi_wuser;
  input                                     axi_wready;
  input                                     axi_bvalid;
  input   [ 3:0]                            axi_bid;
  input   [ 1:0]                            axi_bresp;
  input   [ 3:0]                            axi_buser;
  output                                    axi_bready;

  output                                    axi_werror;

  // registers

  reg     [(DMA_MEM_ADDRESS_WIDTH-1):0]     dma_mem_waddr = 'd0;
  reg     [(DMA_MEM_ADDRESS_WIDTH-1):0]     dma_mem_waddr_g = 'd0;
  reg     [(DMA_MEM_ADDRESS_WIDTH-1):0]     dma_mem_addr_diff = 'd0;
  reg     [(AXI_MEM_ADDRESS_WIDTH-1):0]     dma_mem_raddr_m1 = 'd0;
  reg     [(AXI_MEM_ADDRESS_WIDTH-1):0]     dma_mem_raddr_m2 = 'd0;
  reg     [(AXI_MEM_ADDRESS_WIDTH-1):0]     dma_mem_raddr = 'd0;
  reg                                       dma_ready_out = 1'b0;
  reg                                       dma_rst_m1 = 1'b0;
  reg                                       dma_rst_m2 = 1'b0;
  reg     [ 2:0]                            dma_mem_last_read_toggle_m = 3'b0;
  reg                                       dma_xfer_req_d = 1'b0;
  reg     [ 3:0]                            dma_last_beats = 4'b0;

  reg     [ 4:0]                            axi_xfer_req_m = 3'b0;
  reg     [ 4:0]                            axi_xfer_last_m = 3'b0;

  reg     [(DMA_MEM_ADDRESS_WIDTH-1):0]     axi_mem_waddr_m1 = 'b0;
  reg     [(DMA_MEM_ADDRESS_WIDTH-1):0]     axi_mem_waddr_m2 = 'b0;
  reg     [(DMA_MEM_ADDRESS_WIDTH-1):0]     axi_mem_waddr = 'b0;
  reg                                       axi_mem_rvalid = 1'b0;
  reg                                       axi_mem_rvalid_d = 1'b0;
  reg                                       axi_mem_last = 1'b0;
  reg                                       axi_mem_last_d = 1'b0;
  reg     [(AXI_DATA_WIDTH-1):0]            axi_mem_rdata = 'b0;
  reg     [(AXI_MEM_ADDRESS_WIDTH-1):0]     axi_mem_raddr = 'd0;
  reg     [(AXI_MEM_ADDRESS_WIDTH-1):0]     axi_mem_raddr_g = 'd0;
  reg                                       axi_mem_read_en = 1'b0;
  reg                                       axi_mem_read_en_d = 1'b0;
  reg                                       axi_mem_read_en_delay = 1'b0;
  reg     [(AXI_MEM_ADDRESS_WIDTH-1):0]     axi_mem_addr_diff = 'b0;
  reg                                       axi_mem_last_read_toggle = 1'b0;

  reg                                       axi_reset = 1'b0;
  reg                                       axi_xfer_out = 1'b0;
  reg     [31:0]                            axi_last_addr = 32'b0;
  reg     [ 3:0]                            axi_last_beats = 4'b0;
  reg                                       axi_awvalid = 1'b0;
  reg     [31:0]                            axi_awaddr = 32'b0;
  reg                                       axi_xfer_init = 1'b0;
  reg                                       axi_werror = 1'b0;
  reg     [ 3:0]                            axi_wvalid_counter = 4'b0;

  reg                                       axi_endof_transaction = 1'b0;
  reg                                       axi_endof_transaction_d = 1'b0;

  // internal signals

  wire    [(DMA_MEM_ADDRESS_WIDTH):0]       dma_mem_addr_diff_s;
  wire    [(DMA_MEM_ADDRESS_WIDTH-1):0]     dma_mem_raddr_s;
  wire                                      dma_mem_last_read_s;
  wire                                      dma_xfer_init;
  wire                                      dma_mem_wea_s;
  wire                                      dma_rst_s;

  wire    [(AXI_MEM_ADDRESS_WIDTH-1):0]     axi_mem_waddr_s;
  wire    [AXI_MEM_ADDRESS_WIDTH:0]         axi_mem_addr_diff_s;
  wire    [(AXI_DATA_WIDTH-1):0]            axi_mem_rdata_s;
  wire                                      axi_mem_rvalid_s;
  wire                                      axi_mem_last_s;

  wire                                      axi_waddr_ready_s;
  wire                                      axi_wready_s;

  // binary to grey conversion

  function [7:0] b2g;
    input [7:0] b;
    reg   [7:0] g;
    begin
      g[7] = b[7];
      g[6] = b[7] ^ b[6];
      g[5] = b[6] ^ b[5];
      g[4] = b[5] ^ b[4];
      g[3] = b[4] ^ b[3];
      g[2] = b[3] ^ b[2];
      g[1] = b[2] ^ b[1];
      g[0] = b[1] ^ b[0];
      b2g = g;
    end
  endfunction

  // grey to binary conversion

  function [7:0] g2b;
    input [7:0] g;
    reg   [7:0] b;
    begin
      b[7] = g[7];
      b[6] = b[7] ^ g[6];
      b[5] = b[6] ^ g[5];
      b[4] = b[5] ^ g[4];
      b[3] = b[4] ^ g[3];
      b[2] = b[3] ^ g[2];
      b[1] = b[2] ^ g[1];
      b[0] = b[1] ^ g[0];
      g2b = b;
    end
  endfunction

  // Instantiations

  // An asymmetric memory to transfer data from DMAC interface to AXI Memory Map
  // interface

  ad_mem_asym #(
    .A_ADDRESS_WIDTH (DMA_MEM_ADDRESS_WIDTH),
    .A_DATA_WIDTH (DMA_DATA_WIDTH),
    .B_ADDRESS_WIDTH (AXI_MEM_ADDRESS_WIDTH),
    .B_DATA_WIDTH (AXI_DATA_WIDTH))
  i_mem_asym (
    .clka (dma_clk),
    .wea (dma_mem_wea_s),
    .addra (dma_mem_waddr),
    .dina (dma_data),
    .clkb (axi_clk),
    .addrb (axi_mem_raddr),
    .doutb (axi_mem_rdata_s));

  ad_axis_inf_rx #(.DATA_WIDTH(AXI_DATA_WIDTH)) i_axis_inf (
    .clk (axi_clk),
    .rst (axi_reset),
    .valid (axi_mem_rvalid_d),
    .last (axi_mem_last_d),
    .data (axi_mem_rdata),
    .inf_valid (axi_wvalid),
    .inf_last (axi_wlast),
    .inf_data (axi_wdata),
    .inf_ready (axi_wready));

  // fifo needs a reset

  always @(posedge axi_clk) begin
    if (axi_resetn == 1'b0) begin
      axi_reset <= 1'b1;
    end else begin
      axi_reset <= 1'b0;
    end
  end

  always @(posedge dma_clk) begin
    dma_rst_m1 <= ~axi_resetn;
    dma_rst_m2 <= dma_rst_m1;
  end
  assign dma_rst_s = dma_rst_m2;

  // DMA beat counter

  assign dma_xfer_init = dma_xfer_req & ~dma_xfer_req_d;
  always @(posedge dma_clk) begin
    dma_xfer_req_d <= dma_xfer_req;
    if ((dma_rst_s == 1'b1) || (dma_xfer_init == 1'b1)) begin
      dma_last_beats <= 4'b0;
    end else begin
      if ((dma_ready == 1'b1) && (dma_valid == 1'b1)) begin
        dma_last_beats <= (dma_last_beats < MEM_RATIO-1) ? dma_last_beats + 4'b1 : 4'b0;
      end
    end
  end

  // Write address generation for the asymmetric memory

  assign dma_mem_addr_diff_s = {1'b1, dma_mem_waddr} - dma_mem_raddr_s;
  assign dma_mem_raddr_s = (MEM_RATIO == 1) ?  dma_mem_raddr :
                           (MEM_RATIO == 2) ? {dma_mem_raddr, 1'b0} :
                           (MEM_RATIO == 4) ? {dma_mem_raddr, 2'b0} :
                           (MEM_RATIO == 8) ? {dma_mem_raddr, 3'b0} :
                                              {dma_mem_raddr, 4'b0};
  assign dma_mem_last_read_s = dma_mem_last_read_toggle_m[2] ^ dma_mem_last_read_toggle_m[1];
  assign dma_mem_wea_s = dma_xfer_req & dma_valid & dma_ready;

  always @(posedge dma_clk) begin
    if (dma_rst_s == 1'b1) begin
      dma_mem_waddr <= 'h0;
      dma_mem_waddr_g <= 'h0;
      dma_mem_last_read_toggle_m <= 3'b0;
    end else begin
      dma_mem_last_read_toggle_m = {dma_mem_last_read_toggle_m[1:0], axi_mem_last_read_toggle};
      if (dma_mem_wea_s == 1'b1) begin
        dma_mem_waddr <= dma_mem_waddr + 1;
        if (dma_xfer_last == 1'b1) begin
          if (dma_last_beats != (MEM_RATIO - 1)) begin
            dma_mem_waddr <= dma_mem_waddr + (MEM_RATIO - dma_last_beats);
          end
        end
      end
      if (dma_mem_last_read_s == 1'b1) begin
        dma_mem_waddr <= 'h0;
      end
      dma_mem_waddr_g <= b2g(dma_mem_waddr);
    end
  end

  // The memory module request data until reaches the high threshold.

  always @(posedge dma_clk) begin
    if (dma_rst_s == 1'b1) begin
      dma_mem_addr_diff <= 'b0;
      dma_mem_raddr_m1 <= 'b0;
      dma_mem_raddr_m2 <= 'b0;
      dma_mem_raddr <= 'b0;
      dma_ready_out <= 1'b0;
    end else begin
      dma_mem_raddr_m1 <= axi_mem_raddr_g;
      dma_mem_raddr_m2 <= dma_mem_raddr_m1;
      dma_mem_raddr <= g2b(dma_mem_raddr_m2);
      dma_mem_addr_diff <= dma_mem_addr_diff_s[DMA_MEM_ADDRESS_WIDTH-1:0];
      if (dma_mem_addr_diff >= DMA_BUF_THRESHOLD_HI) begin
        dma_ready_out <= 1'b0;
      end else begin
        dma_ready_out <= 1'b1;
      end
    end
  end

  // Read address generation for the asymmetric memory

  // CDC for the memory write address, xfer_req and xfer_last

  always @(posedge axi_clk) begin
    if (axi_resetn == 1'b0) begin
      axi_xfer_req_m <= 4'b0;
      axi_xfer_last_m <= 5'b0;
      axi_xfer_init <= 1'b0;
      axi_mem_waddr_m1 <= 'b0;
      axi_mem_waddr_m2 <= 'b0;
      axi_mem_waddr <= 'b0;
    end else begin
      axi_xfer_req_m <= {axi_xfer_req_m[3:0], dma_xfer_req};
      axi_xfer_last_m <= {axi_xfer_last_m[3:0], dma_xfer_last};
      axi_xfer_init = ~axi_xfer_req_m[2] & axi_xfer_req_m[1];
      axi_mem_waddr_m1 <= dma_mem_waddr_g;
      axi_mem_waddr_m2 <= axi_mem_waddr_m1;
      axi_mem_waddr <= g2b(axi_mem_waddr_m2);
    end
  end

  // check if the AXI write channel is ready

  assign axi_wready_s = ~axi_wvalid | axi_wready;

  // check if there is enough data in the asymmetric memory

  assign axi_mem_waddr_s = (MEM_RATIO == 1) ? axi_mem_waddr :
                           (MEM_RATIO == 2) ? axi_mem_waddr[(DMA_MEM_ADDRESS_WIDTH-1):1] :
                           (MEM_RATIO == 4) ? axi_mem_waddr[(DMA_MEM_ADDRESS_WIDTH-1):2] :
                           (MEM_RATIO == 8) ? axi_mem_waddr[(DMA_MEM_ADDRESS_WIDTH-1):3] :
                                              axi_mem_waddr[(DMA_MEM_ADDRESS_WIDTH-1):4];

  assign axi_mem_addr_diff_s = {1'b1, axi_mem_waddr_s} - axi_mem_raddr;

  always @(posedge axi_clk) begin
    if (axi_resetn == 1'b0) begin
      axi_endof_transaction <= 1'b0;
      axi_endof_transaction_d <= 1'b0;
    end else begin
     axi_endof_transaction_d <= axi_endof_transaction;
     if ((axi_xfer_req_m[4] == 1'b1) && (axi_xfer_last_m[4] == 1'b1) && (axi_xfer_last_m[3] == 1'b0)) begin
        axi_endof_transaction <= 1'b1;
      end else if((axi_endof_transaction == 1'b1) && (axi_wlast == 1'b1) && ((axi_mem_addr_diff == 0) || (axi_mem_addr_diff > AXI_LENGTH))) begin
        axi_endof_transaction <= 1'b0;
      end
    end
  end

  // The asymmetric memory have to have enough data for at least one AXI burst,
  // before the controller start an AXI write transaction.

  always @(posedge axi_clk) begin
    if (axi_resetn == 1'b0) begin
      axi_mem_read_en <= 1'b0;
      axi_mem_read_en_d <= 1'b0;
      axi_mem_read_en_delay <= 1'b0;
      axi_mem_addr_diff <= 'b0;
    end else begin
      axi_mem_addr_diff <= axi_mem_addr_diff_s[(AXI_MEM_ADDRESS_WIDTH-1):0];
      if ((axi_mem_read_en == 1'b0) && (axi_mem_read_en_delay == 1'b0)) begin
        if (((axi_xfer_req_m[2] == 1'b1) && (axi_mem_addr_diff > AXI_LENGTH)) ||
            ((axi_endof_transaction == 1'b1) && (axi_mem_addr_diff > AXI_LENGTH)) ||
            ((axi_endof_transaction == 1'b1) && (axi_mem_addr_diff > 0))) begin
          axi_mem_read_en <= 1'b1;
        end
      end else if (axi_mem_last_s == 1'b1) begin
        axi_mem_read_en <= 1'b0;
        axi_mem_read_en_delay <= 1;
      end
      if (axi_wlast == 1'b1) begin
        axi_mem_read_en_delay <= 0;
      end
      axi_mem_read_en_d <= axi_mem_read_en;
    end
  end

  assign axi_mem_rvalid_s =  axi_mem_read_en & axi_wready_s;
  assign axi_mem_last_s = (axi_wvalid_counter == axi_awlen) ? axi_mem_rvalid_s : 1'b0;

  always @(posedge axi_clk) begin
    if (axi_resetn == 1'b0) begin
      axi_mem_rvalid <= 1'b0;
      axi_mem_rvalid_d <= 1'b0;
      axi_mem_last <= 1'b0;
      axi_mem_last_d <= 1'b0;
      axi_mem_rdata <= 'b0;
      axi_mem_raddr <= 'b0;
      axi_wvalid_counter <= 4'b0;
      axi_mem_last_read_toggle <= 1'b1;
      axi_mem_raddr_g <= 'b0;
    end else begin
      axi_mem_rvalid <= axi_mem_rvalid_s;
      axi_mem_rvalid_d <= axi_mem_rvalid;
      axi_mem_last <= axi_mem_last_s;
      axi_mem_last_d <= axi_mem_last;
      axi_mem_rdata <= axi_mem_rdata_s;
      if (axi_mem_rvalid_s == 1'b1) begin
        axi_mem_raddr <= axi_mem_raddr + 1;
        axi_wvalid_counter <= ((axi_wvalid_counter == axi_awlen) || (axi_xfer_init == 1'b1)) ? 4'b0 : axi_wvalid_counter + 4'b1;
      end
      if ((axi_endof_transaction == 1'b0) && (axi_endof_transaction_d == 1'b1)) begin
        axi_mem_raddr <= 'b0;
        axi_mem_last_read_toggle <= ~axi_mem_last_read_toggle;
      end
      axi_mem_raddr_g <= b2g(axi_mem_raddr);
    end
  end

  // AXI Memory Map interface write address channel

  assign axi_awid = 4'b0000;
  assign axi_awburst = 2'b01;
  assign axi_awlock = 1'b0;
  assign axi_awcache = 4'b0010;
  assign axi_awprot = 3'b000;
  assign axi_awqos = 4'b0000;
  assign axi_awuser = 4'b0001;
  assign axi_awlen = AXI_LENGTH;
  assign axi_awsize = AXI_SIZE;

  assign axi_waddr_ready_s = axi_mem_read_en & ~axi_mem_read_en_d;

  always @(posedge axi_clk) begin
    if (axi_resetn == 1'b0) begin
      axi_awvalid <= 'd0;
      axi_awaddr <= AXI_ADDRESS;
      axi_last_addr <= AXI_ADDRESS;
      axi_xfer_out <= 1'b0;
    end else begin
      if (axi_awvalid == 1'b1) begin
        if (axi_awready == 1'b1) begin
          axi_awvalid <= 1'b0;
        end
      end else begin
        if (axi_waddr_ready_s == 1'b1) begin
          axi_awvalid <= 1'b1;
        end
      end
      if (axi_xfer_init == 1'b1) begin
        axi_awaddr <= (axi_xfer_out == 1'b1) ? AXI_ADDRESS : axi_last_addr;
        axi_xfer_out <= 1'b0;
      end else if ((axi_awvalid == 1'b1) && (axi_awready == 1'b1)) begin
        axi_awaddr <= axi_awaddr +  AXI_AWINCR;
      end
      if (axi_xfer_last_m[2] == 1'b1) begin
        axi_xfer_out <= 1'b1;
      end
      if ((axi_awvalid == 1'b1) && (axi_endof_transaction == 1'b1)) begin
        axi_last_addr <= axi_awaddr;
      end
    end
  end

  // write data channel controls

  assign axi_wstrb = {AXI_BYTE_WIDTH{1'b1}};
  assign axi_wuser = 4'b0000;

  // response channel

  assign axi_bready = 1'b1;

  always @(posedge axi_clk) begin
    if (axi_resetn == 1'b0) begin
      axi_werror <= 'd0;
    end else begin
      axi_werror <= axi_bvalid & axi_bresp[1];
    end
  end

  // AXI beat counter

  always @(posedge axi_clk) begin
    if(axi_resetn == 1'b0) begin
      axi_last_beats <= 4'b0;
    end else begin
      if ((axi_endof_transaction == 1'b1) && (axi_awready == 1'b1) && (axi_awvalid == 1'b1)) begin
        axi_last_beats <= axi_mem_addr_diff;
      end else begin
        axi_last_beats <= axi_last_beats;
      end
    end
  end

endmodule
