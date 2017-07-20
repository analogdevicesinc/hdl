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

module axi_dacfifo_dac (

  axi_clk,
  axi_dvalid,
  axi_ddata,
  axi_dready,
  axi_dlast,
  axi_xfer_req,

  dma_last_beats,

  dac_clk,
  dac_rst,
  dac_valid,
  dac_data,
  dac_xfer_out,
  dac_dunf
);

  // parameters

  parameter   AXI_DATA_WIDTH = 512;
  parameter   AXI_LENGTH = 15;
  parameter   DAC_DATA_WIDTH = 64;

  localparam  MEM_RATIO = AXI_DATA_WIDTH/DAC_DATA_WIDTH;
  localparam  DAC_ADDRESS_WIDTH = 10;
  localparam  AXI_ADDRESS_WIDTH = (MEM_RATIO == 1) ? DAC_ADDRESS_WIDTH :
                                  (MEM_RATIO == 2) ? (DAC_ADDRESS_WIDTH - 1) :
                                  (MEM_RATIO == 4) ? (DAC_ADDRESS_WIDTH - 2) :
                                                     (DAC_ADDRESS_WIDTH - 3);

  // BUF_THRESHOLD_LO will make sure that there are always at least two burst in the memmory

  localparam  AXI_BUF_THRESHOLD_LO = 3 * (AXI_LENGTH+1);
  localparam  AXI_BUF_THRESHOLD_HI = {(AXI_ADDRESS_WIDTH){1'b1}} - (AXI_LENGTH+1);
  localparam  DAC_BUF_THRESHOLD_LO = 3 * (AXI_LENGTH+1) * MEM_RATIO;
  localparam  DAC_BUF_THRESHOLD_HI = {(DAC_ADDRESS_WIDTH){1'b1}} - (AXI_LENGTH+1) * MEM_RATIO;
  localparam  DAC_ARINCR = (AXI_LENGTH+1) * MEM_RATIO;

  // dma write

  input                               axi_clk;
  input                               axi_dvalid;
  input   [(AXI_DATA_WIDTH-1):0]      axi_ddata;
  output                              axi_dready;
  input                               axi_dlast;
  input                               axi_xfer_req;

  input   [ 3:0]                      dma_last_beats;

  // dac read

  input                               dac_clk;
  input                               dac_rst;
  input                               dac_valid;
  output  [(DAC_DATA_WIDTH-1):0]      dac_data;
  output                              dac_xfer_out;
  output                              dac_dunf;

  // internal registers

  reg     [(AXI_ADDRESS_WIDTH-1):0]   axi_mem_waddr = 'd0;
  reg     [(AXI_ADDRESS_WIDTH-1):0]   axi_mem_laddr = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   axi_mem_waddr_g = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   axi_mem_laddr_g = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   axi_mem_raddr = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   axi_mem_raddr_m1 = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   axi_mem_raddr_m2 = 'd0;
  reg     [(AXI_ADDRESS_WIDTH-1):0]   axi_mem_addr_diff = 'd0;
  reg                                 axi_dready = 'd0;

  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_mem_raddr = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_mem_raddr_g = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_mem_waddr = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_mem_waddr_m1 = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_mem_waddr_m2 = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_mem_laddr = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_mem_laddr_m1 = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_mem_laddr_m2 = 'd0;
  reg     [(DAC_ADDRESS_WIDTH-1):0]   dac_mem_addr_diff = 'd0;
  reg                                 dac_mem_init = 1'b0;
  reg                                 dac_mem_init_d = 1'b0;
  reg                                 dac_mem_enable = 1'b0;

  reg     [ 2:0]                      dac_xfer_req_m = 3'b0;
  reg                                 dac_xfer_init = 1'b0;

  reg     [ 3:0]                      dac_last_beats = 4'b0;
  reg     [ 3:0]                      dac_last_beats_m = 4'b0;
  reg                                 dac_dunf = 1'b0;
  reg     [ 3:0]                      dac_beat_cnt = 4'b0;
  reg                                 dac_dlast = 1'b0;
  reg                                 dac_dlast_m1 = 1'b0;
  reg                                 dac_dlast_m2 = 1'b0;
  reg                                 dac_dlast_inmem = 1'b0;
  reg                                 dac_mem_valid = 1'b0;

  // internal signals

  wire    [AXI_ADDRESS_WIDTH:0]       axi_mem_addr_diff_s;
  wire    [(AXI_ADDRESS_WIDTH-1):0]   axi_mem_raddr_s;
  wire    [(DAC_ADDRESS_WIDTH-1):0]   axi_mem_waddr_s;
  wire    [(DAC_ADDRESS_WIDTH-1):0]   axi_mem_laddr_s;

  wire    [DAC_ADDRESS_WIDTH:0]       dac_mem_addr_diff_s;
  wire                                dac_xfer_init_s;
  wire                                dac_last_axi_beats_s;

  // binary to grey conversion

  function [9:0] b2g;
    input [9:0] b;
    reg   [9:0] g;
    begin
      g[9] = b[9];
      g[8] = b[9] ^ b[8];
      g[7] = b[8] ^ b[7];
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

  function [9:0] g2b;
    input [9:0] g;
    reg   [9:0] b;
    begin
      b[9] = g[9];
      b[8] = b[9] ^ g[8];
      b[7] = b[8] ^ g[7];
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

  // write interface

  always @(posedge axi_clk) begin
    if (axi_xfer_req == 1'b0) begin
      axi_mem_waddr <= 'd0;
      axi_mem_waddr_g <= 'd0;
      axi_mem_laddr <= {AXI_ADDRESS_WIDTH{1'b1}};
    end else begin
      if (axi_dvalid == 1'b1) begin
        axi_mem_waddr <= axi_mem_waddr + 1'b1;
        axi_mem_laddr <= (axi_dlast == 1'b1) ? axi_mem_waddr : axi_mem_laddr;
      end
      axi_mem_waddr_g <= b2g(axi_mem_waddr_s);
      axi_mem_laddr_g <= b2g(axi_mem_laddr_s);
    end
  end

  // scale the axi_mem_* addresses

  assign axi_mem_raddr_s = (MEM_RATIO == 1) ? axi_mem_raddr :
                           (MEM_RATIO == 2) ? axi_mem_raddr[(DAC_ADDRESS_WIDTH-1):1] :
                           (MEM_RATIO == 4) ? axi_mem_raddr[(DAC_ADDRESS_WIDTH-1):2] :
                                              axi_mem_raddr[(DAC_ADDRESS_WIDTH-1):3];
  assign axi_mem_waddr_s = (MEM_RATIO == 1) ? axi_mem_waddr :
                           (MEM_RATIO == 2) ? {axi_mem_waddr, 1'b0} :
                           (MEM_RATIO == 4) ? {axi_mem_waddr, 2'b0} :
                                              {axi_mem_waddr, 3'b0};
   assign axi_mem_laddr_s = (MEM_RATIO == 1) ? axi_mem_laddr :
                            (MEM_RATIO == 2) ? {axi_mem_laddr, 1'b0} :
                            (MEM_RATIO == 4) ? {axi_mem_laddr, 2'b0} :
                                               {axi_mem_laddr, 3'b0};

  // incomming data flow control

  assign axi_mem_addr_diff_s = {1'b1, axi_mem_waddr} - axi_mem_raddr_s;

  always @(posedge axi_clk) begin
    if (axi_xfer_req == 1'b0) begin
      axi_mem_addr_diff <= 'd0;
      axi_mem_raddr <= 'd0;
      axi_mem_raddr_m1 <= 'd0;
      axi_mem_raddr_m2 <= 'd0;
      axi_dready <= 'd0;
    end else begin
      axi_mem_raddr_m1 <= dac_mem_raddr_g;
      axi_mem_raddr_m2 <= axi_mem_raddr_m1;
      axi_mem_raddr <= g2b(axi_mem_raddr_m2);
      axi_mem_addr_diff <= axi_mem_addr_diff_s[AXI_ADDRESS_WIDTH-1:0];
      if (axi_mem_addr_diff >= AXI_BUF_THRESHOLD_HI) begin
        axi_dready <= 1'b0;
      end else if (axi_mem_addr_diff <= AXI_BUF_THRESHOLD_LO) begin
        axi_dready <= 1'b1;
      end
    end
  end

  // CDC for xfer_req signal

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      dac_xfer_req_m <= 3'b0;
    end else begin
      dac_xfer_req_m <= {dac_xfer_req_m[1:0], axi_xfer_req};
    end
  end

  assign dac_xfer_out = dac_xfer_req_m[2];
  assign dac_xfer_init_s = ~dac_xfer_req_m[2] & dac_xfer_req_m[1];

  // read interface

  always @(posedge dac_clk) begin
    if (dac_xfer_out == 1'b0) begin
      dac_mem_init <= 1'b0;
      dac_mem_init_d <= 1'b0;
      dac_mem_enable <= 1'b0;
    end else begin
      if (dac_xfer_init == 1'b1) begin
        dac_mem_init <= 1'b1;
      end
      if ((dac_mem_init == 1'b1) && (dac_mem_addr_diff > DAC_BUF_THRESHOLD_LO)) begin
        dac_mem_init <= 1'b0;
      end
      dac_mem_init_d <= dac_mem_init;
      // memory is ready when the initial fill up is done
      dac_mem_enable <= (dac_mem_init_d & ~dac_mem_init) ? 1'b1 : dac_mem_enable;
    end
    dac_xfer_init <= dac_xfer_init_s;
  end

  always @(posedge dac_clk) begin
    if (dac_xfer_out == 1'b0) begin
      dac_mem_waddr <= 'b0;
      dac_mem_waddr_m1 <= 'b0;
      dac_mem_waddr_m2 <= 'b0;
      dac_mem_laddr <= 'b0;
      dac_mem_laddr_m1 <= 'b0;
      dac_mem_laddr_m2 <= 'b0;
      dac_dlast <= 1'b0;
      dac_dlast_m1 <= 1'b0;
      dac_dlast_m2 <= 1'b0;
    end else begin
      dac_mem_waddr_m1 <= axi_mem_waddr_g;
      dac_mem_waddr_m2 <= dac_mem_waddr_m1;
      dac_mem_waddr <= g2b(dac_mem_waddr_m2);
      dac_mem_laddr_m1 <= axi_mem_laddr_g;
      dac_mem_laddr_m2 <= dac_mem_laddr_m1;
      dac_mem_laddr <= g2b(dac_mem_laddr_m2);
      dac_dlast_m1 <= axi_dlast;
      dac_dlast_m2 <= dac_dlast_m1;
      dac_dlast <= dac_dlast_m2;
    end
  end

  assign dac_mem_addr_diff_s = {1'b1, dac_mem_waddr} - dac_mem_raddr;
  always @(posedge dac_clk) begin
    dac_mem_valid <= (dac_mem_enable) ? dac_valid : 1'b0;
  end

  // CDC for the dma_last_beats

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      dac_last_beats <= 32'b0;
      dac_last_beats_m <= 32'b0;
    end else begin
      dac_last_beats_m <= dma_last_beats;
      dac_last_beats <= dac_last_beats_m;
    end
  end

  // If the MEM_RATIO is grater than one, it can happen that not all the DAC beats from
  // an AXI beat are valid. In this case the invalid data is dropped.
  // The axi_dlast indicates the last AXI beat. The valid number of DAC beats on the last AXI beat
  // commes from the AXI write module. (axi_dacfifo_wr.v)

  assign dac_last_axi_beats_s = ((dac_dlast_inmem == 1'b1) && (dac_mem_raddr >= dac_mem_laddr) && (dac_mem_raddr < dac_mem_laddr + MEM_RATIO)) ? 1'b1 : 1'b0;

  always @(posedge dac_clk) begin
    if (dac_xfer_out == 1'b0) begin
      dac_mem_raddr <= 'd0;
      dac_beat_cnt <= 'd0;
      dac_dlast_inmem <= 1'b0;
    end else begin
      if (dac_dlast == 1'b1) begin
        dac_dlast_inmem <= 1'b1;
      end else if (dac_mem_raddr == dac_mem_laddr + MEM_RATIO) begin
        dac_dlast_inmem <= 1'b0;
      end
      if (dac_mem_valid == 1'b1) begin
        dac_beat_cnt <= ((dac_beat_cnt >= MEM_RATIO-1) ||
                         ((dac_last_beats > 1'b1) && (dac_last_axi_beats_s > 1'b0) && (dac_beat_cnt == dac_last_beats-1))) ? 0 : dac_beat_cnt + 1;
        dac_mem_raddr <= ((dac_last_axi_beats_s) && (dac_beat_cnt == dac_last_beats-1)) ? (dac_mem_laddr + MEM_RATIO) : dac_mem_raddr + 1'b1;
      end
      dac_mem_raddr_g <= b2g(dac_mem_raddr);
    end
  end

  // underflow generation, there is no overflow

  always @(posedge dac_clk) begin
    if(dac_xfer_out == 1'b0) begin
      dac_mem_addr_diff <= 'b0;
      dac_dunf <= 1'b0;
    end else begin
      dac_mem_addr_diff <= dac_mem_addr_diff_s[DAC_ADDRESS_WIDTH-1:0];
      dac_dunf <= (dac_mem_addr_diff == 1'b0) ? 1'b1 : 1'b0;
    end
  end

  // instantiations

  ad_mem_asym #(
    .A_ADDRESS_WIDTH (AXI_ADDRESS_WIDTH),
    .A_DATA_WIDTH (AXI_DATA_WIDTH),
    .B_ADDRESS_WIDTH (DAC_ADDRESS_WIDTH),
    .B_DATA_WIDTH (DAC_DATA_WIDTH))
  i_mem_asym (
    .clka (axi_clk),
    .wea (axi_dvalid),
    .addra (axi_mem_waddr),
    .dina (axi_ddata),
    .clkb (dac_clk),
    .addrb (dac_mem_raddr),
    .doutb (dac_data));

endmodule

// ***************************************************************************
// ***************************************************************************

