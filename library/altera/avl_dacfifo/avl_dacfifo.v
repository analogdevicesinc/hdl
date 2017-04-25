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

module avl_dacfifo #(

  parameter   DAC_DATA_WIDTH = 64,
  parameter   DMA_DATA_WIDTH = 64,
  parameter   AVL_DATA_WIDTH = 512,
  parameter   AVL_BASE_ADDRESS = 32'h00000000,
  parameter   AVL_ADDRESS_LIMIT = 32'h1fffffff) (

  // dma interface

  input                               dma_clk,
  input                               dma_rst,
  input                               dma_valid,
  input       [(DMA_DATA_WIDTH-1):0]  dma_data,
  output  reg                         dma_ready,
  input                               dma_xfer_req,
  input                               dma_xfer_last,

  // dac interface

  input                               dac_clk,
  input                               dac_rst,
  input                               dac_valid,
  output  reg [(DAC_DATA_WIDTH-1):0]  dac_data,
  output  reg                         dac_dunf,
  output  reg                         dac_xfer_out,

  input                               bypass,

  // avalon interface

  input                               avl_clk,
  input                               avl_reset,

  output  reg [ 24:0]                 avl_address,
  output  reg [  6:0]                 avl_burstcount,
  output  reg [ 63:0]                 avl_byteenable,
  output  reg                         avl_read,
  input       [511:0]                 avl_readdata,
  input                               avl_readdata_valid,
  input                               avl_ready,
  output  reg                         avl_write,
  output  reg [511:0]                 avl_writedata);

  localparam  FIFO_BYPASS = (DAC_DATA_WIDTH == DMA_DATA_WIDTH) ? 1 : 0;

  // internal register

  reg                                 dma_bypass_m1 = 1'b0;
  reg                                 dma_bypass = 1'b0;
  reg                                 dac_bypass_m1 = 1'b0;
  reg                                 dac_bypass = 1'b0;
  reg                                 dac_xfer_out_m1 = 1'b0;
  reg                                 dac_xfer_out_bypass = 1'b0;
  reg                                 avl_xfer_req_m1 = 1'b0;
  reg                                 avl_xfer_req = 1'b0;

  // internal signals

  wire                                dma_ready_wr_s;
  wire                                avl_read_s;
  wire                                avl_write_s;
  wire                                avl_writedata_s;
  wire        [ 24:0]                 avl_wr_address_s;
  wire        [ 24:0]                 avl_rd_address_s;
  wire        [ 24:0]                 avl_last_address_s;
  wire        [  5:0]                 avl_wr_burstcount_s;
  wire        [  5:0]                 avl_rd_burstcount_s;
  wire        [ 63:0]                 avl_wr_byteenable_s;
  wire        [ 63:0]                 avl_rd_byteenable_s;
  wire                                avl_xfer_out_s;
  wire    [(DAC_DATA_WIDTH-1):0]      dac_data_fifo_s;
  wire    [(DAC_DATA_WIDTH-1):0]      dac_data_bypass_s;
  wire                                dac_xfer_fifo_out_s;
  wire                                dac_dunf_fifo_s;

  avl_dacfifo_wr #(
    .AVL_DATA_WIDTH (AVL_DATA_WIDTH),
    .DMA_DATA_WIDTH (DMA_DATA_WIDTH),
    .AVL_DDR_BASE_ADDRESS (AVL_BASE_ADDRESS),
    .DMA_MEM_ADDRESS_WIDTH(8)
  ) i_wr (
    .dma_clk (dma_clk),
    .dma_data (dma_data),
    .dma_ready (dma_ready),
    .dma_ready_out (dma_ready_wr_s),
    .dma_valid (dma_valid),
    .dma_xfer_req (dma_xfer_req),
    .dma_xfer_last (dma_xfer_last),
    .dma_last_beat (),
    .avl_last_address (avl_last_address_s),
    .avl_last_byteenable (),
    .avl_clk (avl_clk),
    .avl_reset (avl_reset),
    .avl_address (avl_wr_address_s),
    .avl_burstcount (avl_wr_burstcount_s),
    .avl_byteenable (avl_wr_byteenable_s),
    .avl_ready (avl_ready),
    .avl_write (avl_write_s),
    .avl_data (avl_writedata_s),
    .avl_xfer_req (avl_xfer_out_s)
    );

  avl_dacfifo_rd #(
    .AVL_DATA_WIDTH(AVL_DATA_WIDTH),
    .DAC_DATA_WIDTH(DAC_DATA_WIDTH),
    .AVL_DDR_BASE_ADDRESS(AVL_BASE_ADDRESS),
    .AVL_DDR_ADDRESS_LIMIT(AVL_ADDRESS_LIMIT),
    .DAC_MEM_ADDRESS_WIDTH(8)
  ) i_rd (
    .dac_clk(dac_clk),
    .dac_reset(dac_rst),
    .dac_valid(dac_valid),
    .dac_data(dac_data_fifo_s),
    .dac_xfer_req(dac_xfer_fifo_out_s),
    .dac_dunf(dac_dunf_fifo_s),
    .avl_clk(avl_clk),
    .avl_reset(avl_reset),
    .avl_address(avl_rd_address_s),
    .avl_burstcount(avl_rd_burstcount_s),
    .avl_byteenable(avl_rd_byteenable_s),
    .avl_ready(avl_ready),
    .avl_readdatavalid(avl_readdata_valid),
    .avl_read(avl_read_s),
    .avl_data(avl_readdata),
    .avl_last_address(avl_last_address_s),
    .avl_last_byteenable(),
    .avl_xfer_req(avl_xfer_out_s));

  // avalon address multiplexer and output registers

  always @(posedge avl_clk) begin
    avl_xfer_req_m1 <= dma_xfer_req;
    avl_xfer_req <= avl_xfer_req_m1;
  end

  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_address <= 0;
      avl_burstcount <= 0;
      avl_byteenable <= 0;
      avl_read <= 0;
      avl_write <= 0;
      avl_writedata <= 0;
    end else begin
      avl_address <= (avl_xfer_req == 1'b1) ? avl_wr_address_s : avl_rd_address_s;
      avl_burstcount <= (avl_xfer_req == 1'b1) ? avl_wr_burstcount_s : avl_rd_burstcount_s;
      avl_byteenable <= (avl_xfer_req == 1'b1) ? avl_wr_byteenable_s : avl_rd_byteenable_s;
      avl_read <= avl_read_s;
      avl_write <= avl_write_s;
      avl_writedata <= avl_writedata_s;
    end
  end

  // bypass logic -- supported if DAC_DATA_WIDTH == DMA_DATA_WIDTH

  generate
  if (FIFO_BYPASS) begin

    util_dacfifo_bypass #(
      .DAC_DATA_WIDTH (DAC_DATA_WIDTH),
      .DMA_DATA_WIDTH (DMA_DATA_WIDTH)
    ) i_dacfifo_bypass (
      .dma_clk(dma_clk),
      .dma_data(dma_data),
      .dma_ready(dma_ready),
      .dma_ready_out(dma_ready_bypass_s),
      .dma_valid(dma_valid),
      .dma_xfer_req(dma_xfer_req),
      .dac_clk(dac_clk),
      .dac_rst(dac_rst),
      .dac_valid(dac_valid),
      .dac_data(dac_data_bypass_s),
      .dac_dunf(dac_dunf_bypass_s)
    );

    always @(posedge dma_clk) begin
      dma_bypass_m1 <= bypass;
      dma_bypass <= dma_bypass_m1;
    end

    always @(posedge dac_clk) begin
      dac_bypass_m1 <= bypass;
      dac_bypass <= dac_bypass_m1;
      dac_xfer_out_m1 <= dma_xfer_req;
      dac_xfer_out_bypass <= dac_xfer_out_m1;
    end

    // mux for the dma_ready

    always @(posedge dma_clk) begin
      dma_ready <= (dma_bypass) ? dma_ready_wr_s : dma_ready_bypass_s;
    end

    // mux for dac data

    always @(posedge dac_clk) begin
      if (dac_valid) begin
        dac_data <= (dac_bypass) ? dac_data_bypass_s : dac_data_fifo_s;
      end
      dac_xfer_out <= (dac_bypass) ? dac_xfer_out_bypass : dac_xfer_fifo_out_s;
      dac_dunf <= (dac_bypass) ? dac_dunf_bypass_s : dac_dunf_fifo_s;
    end

  end else begin /* if (~FIFO_BYPASS) */

    always @(posedge dma_clk) begin
      dma_ready <= dma_ready_wr_s;
    end
    always @(posedge dac_clk) begin
      if (dac_valid) begin
        dac_data <= dac_data_fifo_s;
      end
      dac_xfer_out <= dac_xfer_fifo_out_s;
      dac_dunf <= dac_dunf_fifo_s;
    end

  end
  endgenerate


endmodule

