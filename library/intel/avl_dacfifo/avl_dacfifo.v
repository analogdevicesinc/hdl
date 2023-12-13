// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module avl_dacfifo #(

  parameter   DAC_DATA_WIDTH = 64,
  parameter   DAC_MEM_ADDRESS_WIDTH = 8,
  parameter   DMA_DATA_WIDTH = 64,
  parameter   DMA_MEM_ADDRESS_WIDTH = 10,
  parameter   AVL_DATA_WIDTH = 512,
  parameter   AVL_ADDRESS_WIDTH = 25,
  parameter   AVL_BURST_LENGTH = 127,
  parameter   AVL_BASE_ADDRESS = 32'h00000000,
  parameter   AVL_ADDRESS_LIMIT = 32'h1fffffff
) (

  // dma interface

  input                                 dma_clk,
  input                                 dma_rst,
  input                                 dma_valid,
  input       [(DMA_DATA_WIDTH-1):0]    dma_data,
  output  reg                           dma_ready,
  input                                 dma_xfer_req,
  input                                 dma_xfer_last,

  // dac interface

  input                                 dac_clk,
  input                                 dac_rst,
  input                                 dac_valid,
  output  reg [(DAC_DATA_WIDTH-1):0]    dac_data,
  output  reg                           dac_dunf,
  output  reg                           dac_xfer_out,

  input                                 bypass,

  // avalon interface

  input                                 avl_clk,
  input                                 avl_reset,

  output  reg [(AVL_ADDRESS_WIDTH-1):0] avl_address,
  output  reg [  6:0]                   avl_burstcount,
  output  reg [ 63:0]                   avl_byteenable,
  output                                avl_read,
  input       [(AVL_DATA_WIDTH-1):0]    avl_readdata,
  input                                 avl_readdata_valid,
  input                                 avl_ready,
  output                                avl_write,
  output      [(AVL_DATA_WIDTH-1):0]    avl_writedata
);

  localparam  FIFO_BYPASS = (DAC_DATA_WIDTH == DMA_DATA_WIDTH) ? 1 : 0;

  // internal register

  reg                                   dma_bypass_m1 = 1'b0;
  reg                                   dma_bypass = 1'b0;
  reg                                   dac_bypass_m1 = 1'b0;
  reg                                   dac_bypass = 1'b0;
  reg                                   dac_xfer_out_m1 = 1'b0;
  reg                                   dac_xfer_out_bypass = 1'b0;

  // internal signals

  wire                                  dma_ready_wr_s;
  wire                                  dma_ready_bypass_s;
  wire                                  avl_read_s;
  wire                                  avl_write_s;
  wire        [ 24:0]                   avl_wr_address_s;
  wire        [ 24:0]                   avl_rd_address_s;
  wire        [ 24:0]                   avl_last_address_s;
  wire        [  6:0]                   avl_last_burstcount_s;
  wire        [  7:0]                   dma_last_beats_s;
  wire        [  6:0]                   avl_wr_burstcount_s;
  wire        [  6:0]                   avl_rd_burstcount_s;
  wire        [ 63:0]                   avl_wr_byteenable_s;
  wire        [ 63:0]                   avl_rd_byteenable_s;
  wire                                  avl_xfer_wren_s;
  wire                                  avl_xfer_out_s;
  wire                                  avl_xfer_in_s;
  wire    [(DAC_DATA_WIDTH-1):0]        dac_data_fifo_s;
  wire    [(DAC_DATA_WIDTH-1):0]        dac_data_bypass_s;
  wire                                  dac_xfer_fifo_out_s;
  wire                                  dac_dunf_fifo_s;
  wire                                  dac_dunf_bypass_s;

  avl_dacfifo_wr #(
    .AVL_DATA_WIDTH (AVL_DATA_WIDTH),
    .DMA_DATA_WIDTH (DMA_DATA_WIDTH),
    .AVL_DDR_BASE_ADDRESS (AVL_BASE_ADDRESS),
    .DMA_MEM_ADDRESS_WIDTH(DMA_MEM_ADDRESS_WIDTH),
    .AVL_BURST_LENGTH (AVL_BURST_LENGTH)
  ) i_wr (
    .dma_clk (dma_clk),
    .dma_data (dma_data),
    .dma_ready (dma_ready),
    .dma_ready_out (dma_ready_wr_s),
    .dma_valid (dma_valid),
    .dma_xfer_req (dma_xfer_req),
    .dma_xfer_last (dma_xfer_last),
    .dma_last_beats (dma_last_beats_s),
    .avl_last_address (avl_last_address_s),
    .avl_last_burstcount (avl_last_burstcount_s),
    .avl_clk (avl_clk),
    .avl_reset (avl_reset),
    .avl_address (avl_wr_address_s),
    .avl_burstcount (avl_wr_burstcount_s),
    .avl_byteenable (avl_wr_byteenable_s),
    .avl_waitrequest (~avl_ready),
    .avl_write (avl_write),
    .avl_data (avl_writedata),
    .avl_xfer_req_out (avl_xfer_out_s),
    .avl_xfer_req_in (avl_xfer_in_s));

  avl_dacfifo_rd #(
    .AVL_DATA_WIDTH(AVL_DATA_WIDTH),
    .DAC_DATA_WIDTH(DAC_DATA_WIDTH),
    .AVL_DDR_BASE_ADDRESS(AVL_BASE_ADDRESS),
    .AVL_DDR_ADDRESS_LIMIT(AVL_ADDRESS_LIMIT),
    .DAC_MEM_ADDRESS_WIDTH(DAC_MEM_ADDRESS_WIDTH),
    .AVL_BURST_LENGTH (AVL_BURST_LENGTH)
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
    .avl_waitrequest(~avl_ready),
    .avl_readdatavalid(avl_readdata_valid),
    .avl_read(avl_read),
    .avl_data(avl_readdata),
    .avl_last_address(avl_last_address_s),
    .avl_last_burstcount(avl_last_burstcount_s),
    .dma_last_beats(dma_last_beats_s),
    .avl_xfer_req_in(avl_xfer_out_s),
    .avl_xfer_req_out(avl_xfer_in_s));

  // avalon address multiplexer and output registers

  assign avl_xfer_wren_s = ~avl_xfer_in_s;

  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_address <= 0;
      avl_burstcount <= 0;
      avl_byteenable <= 0;
    end else if (avl_ready) begin
      avl_address <= (avl_xfer_wren_s == 1'b1) ? avl_wr_address_s : avl_rd_address_s;
      avl_burstcount <= (avl_xfer_wren_s == 1'b1) ? avl_wr_burstcount_s : avl_rd_burstcount_s;
      avl_byteenable <= (avl_xfer_wren_s == 1'b1) ? avl_wr_byteenable_s : avl_rd_byteenable_s;
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
      .dac_dunf(dac_dunf_bypass_s));

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
      dma_ready <= (dma_bypass) ? dma_ready_bypass_s : dma_ready_wr_s;
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
