// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// Each core or library found in this collection may have its own licensing terms. 
// The user should keep this in in mind while exploring these cores. 
//
// Redistribution and use in source and binary forms,
// with or without modification of this file, are permitted under the terms of either
//  (at the option of the user):
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory, or at:
// https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
//
// OR
//
//   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
// https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module avl_dacfifo_wr #(

  parameter     AVL_DATA_WIDTH = 512,
  parameter     DMA_DATA_WIDTH = 64,
  parameter     AVL_DDR_BASE_ADDRESS = 0,
  parameter     AVL_DDR_ADDRESS_LIMIT = 1048576,
  parameter     DMA_MEM_ADDRESS_WIDTH = 8)(

  input                                 dma_clk,
  input       [DMA_DATA_WIDTH-1:0]      dma_data,
  input                                 dma_ready,
  output  reg                           dma_ready_out,
  input                                 dma_valid,
  input                                 dma_xfer_req,
  input                                 dma_xfer_last,
  output  reg [ 3:0]                    dma_last_beat,

  input                                 avl_clk,
  input                                 avl_reset,
  output  reg [24:0]                    avl_address,
  output      [ 5:0]                    avl_burstcount,
  output  reg [63:0]                    avl_byteenable,
  input                                 avl_ready,
  output  reg                           avl_write,
  output  reg [AVL_DATA_WIDTH-1:0]      avl_data,

  output  reg [24:0]                    avl_last_address,
  output  reg [63:0]                    avl_last_byteenable,
  output  reg                           avl_xfer_req);

  localparam  MEM_RATIO = AVL_DATA_WIDTH/DMA_DATA_WIDTH;  // Max supported MEM_RATIO is 16
  localparam  AVL_MEM_ADDRESS_WIDTH = (MEM_RATIO == 1) ?  DMA_MEM_ADDRESS_WIDTH :
                                      (MEM_RATIO == 2) ? (DMA_MEM_ADDRESS_WIDTH - 1) :
                                      (MEM_RATIO == 4) ? (DMA_MEM_ADDRESS_WIDTH - 2) :
                                      (MEM_RATIO == 8) ? (DMA_MEM_ADDRESS_WIDTH - 3) :
                                                         (DMA_MEM_ADDRESS_WIDTH - 4);
  localparam  MEM_WIDTH_DIFF = (MEM_RATIO > 8) ? 4 :
                               (MEM_RATIO > 4) ? 3 :
                               (MEM_RATIO > 2) ? 2 :
                               (MEM_RATIO > 1) ? 1 : 1;

  localparam  DMA_BUF_THRESHOLD_HI = {(DMA_MEM_ADDRESS_WIDTH){1'b1}} - 4;
  localparam  DMA_BYTE_DATA_WIDTH = DMA_DATA_WIDTH/8;
  localparam  AVL_BYTE_DATA_WIDTH = AVL_DATA_WIDTH/8;

  wire                                  dma_resetn;
  wire                                  dma_mem_wea_s;
  wire    [DMA_MEM_ADDRESS_WIDTH  :0]   dma_mem_address_diff_s;
  wire    [DMA_MEM_ADDRESS_WIDTH-1:0]   dma_mem_rd_address_s;

  wire    [AVL_DATA_WIDTH-1:0]          avl_mem_rdata_s;
  wire                                  avl_mem_fetch_wr_address_s;
  wire                                  avl_mem_readen_s;
  wire    [AVL_MEM_ADDRESS_WIDTH :0]    avl_mem_address_diff_s;
  wire                                  avl_write_transfer_s;
  wire                                  avl_last_transfer_req_s;
  wire                                  avl_xfer_req_init_s;
  wire                                  avl_write_transfer_done_s;

  reg     [DMA_MEM_ADDRESS_WIDTH-1:0]   dma_mem_wr_address;
  reg     [AVL_MEM_ADDRESS_WIDTH-1:0]   dma_mem_wr_address_d;
  reg     [AVL_MEM_ADDRESS_WIDTH-1:0]   dma_mem_rd_address_m1;
  reg     [AVL_MEM_ADDRESS_WIDTH-1:0]   dma_mem_rd_address_m2;
  reg     [AVL_MEM_ADDRESS_WIDTH-1:0]   dma_mem_rd_address;
  reg                                   dma_mem_read_control;
  reg     [DMA_MEM_ADDRESS_WIDTH-1:0]   dma_mem_address_diff;
  reg                                   dma_last_beat_ack;
  reg     [MEM_WIDTH_DIFF-1:0]          dma_mem_last_beats;
  reg                                   dma_avl_xfer_req_m1;
  reg                                   dma_avl_xfer_req;

  reg     [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_rd_address;
  reg     [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_rd_address_g;
  reg     [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_wr_address;
  reg                                   avl_mem_fetch_wr_address;
  reg                                   avl_mem_fetch_wr_address_m1;
  reg                                   avl_mem_fetch_wr_address_m2;
  reg                                   avl_write_d;
  reg                                   avl_mem_readen;
  reg                                   avl_write_transfer;
  reg                                   avl_last_beat_req_m1;
  reg                                   avl_last_beat_req_m2;
  reg                                   avl_last_beat_req;
  reg                                   avl_dma_xfer_req;
  reg                                   avl_dma_xfer_req_m1;
  reg                                   avl_dma_xfer_req_m2;
  reg     [MEM_WIDTH_DIFF-1:0]          avl_last_beats;
  reg     [MEM_WIDTH_DIFF-1:0]          avl_last_beats_m1;
  reg     [MEM_WIDTH_DIFF-1:0]          avl_last_beats_m2;
  reg                                   avl_write_xfer_req;
  reg                                   avl_write_xfer_req_d;

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

  // An asymmetric memory to transfer data from DMAC interface to AXI Memory Map
  // interface

  ad_mem_asym #(
    .A_ADDRESS_WIDTH (DMA_MEM_ADDRESS_WIDTH),
    .A_DATA_WIDTH (DMA_DATA_WIDTH),
    .B_ADDRESS_WIDTH (AVL_MEM_ADDRESS_WIDTH),
    .B_DATA_WIDTH (AVL_DATA_WIDTH))
  i_mem_asym (
    .clka (dma_clk),
    .wea (dma_mem_wea_s),
    .addra (dma_mem_wr_address),
    .dina (dma_data),
    .clkb (avl_clk),
    .addrb (avl_mem_rd_address),
    .doutb (avl_mem_rdata_s));

  // the fifo reset is the dma_xfer_req

  assign dma_resetn = dma_xfer_req;

  // write address generation

  assign dma_mem_address_diff_s = {1'b1, dma_mem_wr_address} - dma_mem_rd_address_s;
  assign dma_mem_rd_address_s = (MEM_RATIO == 1) ?  dma_mem_rd_address :
                           (MEM_RATIO == 2) ? {dma_mem_rd_address, 1'b0} :
                           (MEM_RATIO == 4) ? {dma_mem_rd_address, 2'b0} :
                           (MEM_RATIO == 8) ? {dma_mem_rd_address, 3'b0} :
                                              {dma_mem_rd_address, 4'b0};
  assign dma_mem_wea_s = dma_ready & dma_valid & dma_xfer_req;

  always @(posedge dma_clk) begin
    if (dma_resetn == 1'b0) begin
      dma_mem_wr_address <= 0;
      dma_mem_read_control <= 1'b0;
      dma_mem_last_beats <= 0;
    end else begin
      if (dma_mem_wea_s == 1'b1) begin
        dma_mem_wr_address <= dma_mem_wr_address + 1;
      end
      if (dma_mem_wr_address[MEM_WIDTH_DIFF-1:0] == {MEM_WIDTH_DIFF{1'b1}}) begin
        dma_mem_read_control <= ~dma_mem_read_control;
        dma_mem_wr_address_d <= dma_mem_wr_address[DMA_MEM_ADDRESS_WIDTH-1:MEM_WIDTH_DIFF];
      end
    end
    if ((dma_xfer_last == 1'b1) && (dma_mem_wea_s)) begin
      dma_mem_last_beats <= dma_mem_wr_address[MEM_WIDTH_DIFF-1:0];
    end
  end

  // The memory module request data until reaches the high threshold.

  always @(posedge dma_clk) begin
    if (dma_resetn == 1'b0) begin
      dma_mem_address_diff <= 'b0;
      dma_mem_rd_address_m1 <= 'b0;
      dma_mem_rd_address_m2 <= 'b0;
      dma_mem_rd_address <= 'b0;
      dma_ready_out <= 1'b0;
    end else begin
      dma_mem_rd_address_m1 <= avl_mem_rd_address_g;
      dma_mem_rd_address_m2 <= dma_mem_rd_address_m1;
      dma_mem_rd_address <= g2b(dma_mem_rd_address_m2);
      dma_mem_address_diff <= dma_mem_address_diff_s[DMA_MEM_ADDRESS_WIDTH-1:0];
      if (dma_mem_address_diff >= DMA_BUF_THRESHOLD_HI) begin
        dma_ready_out <= 1'b0;
      end else begin
        dma_ready_out <= 1'b1;
      end
    end
  end

  // last DMA beat

  always @(posedge dma_clk) begin
    dma_avl_xfer_req_m1 <= avl_write_xfer_req;
    dma_avl_xfer_req <= dma_avl_xfer_req_m1;
  end

  always @(posedge dma_clk) begin
    if (dma_avl_xfer_req == 1'b0) begin
      dma_last_beat_ack <= 1'b0;
    end else begin
      if ((dma_xfer_req == 1'b1) && (dma_xfer_last == 1'b1)) begin
        dma_last_beat_ack <= 1'b1;
      end
    end
  end

  // transfer the mem_write address to the avalons clock domain

  assign avl_mem_fetch_wr_address_s = avl_mem_fetch_wr_address ^ avl_mem_fetch_wr_address_m1;

  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_mem_fetch_wr_address_m1 <= 0;
      avl_mem_fetch_wr_address_m2 <= 0;
      avl_mem_fetch_wr_address <= 0;
      avl_mem_wr_address <= 0;
    end else begin
      avl_mem_fetch_wr_address_m1 <= dma_mem_read_control;
      avl_mem_fetch_wr_address_m2 <= avl_mem_fetch_wr_address_m1;
      avl_mem_fetch_wr_address <= avl_mem_fetch_wr_address_m2;
      if (avl_mem_fetch_wr_address_s == 1'b1) begin
        avl_mem_wr_address <= dma_mem_wr_address_d;
      end
    end
  end

  // Avalon write address and fifo read address generation

  assign avl_mem_address_diff_s = {1'b1, avl_mem_wr_address} - avl_mem_rd_address;
  assign avl_mem_readen_s = (avl_mem_address_diff_s[AVL_MEM_ADDRESS_WIDTH-1:0] == 0) ? 0 : (avl_write_xfer_req & avl_ready);
  assign avl_write_transfer_s = avl_write & avl_ready;
  assign avl_write_transfer_done_s = avl_write_transfer & ~avl_write_transfer_s;

  always @(posedge avl_clk) begin
    if ((avl_reset == 1'b1) || (avl_write_xfer_req == 1'b0)) begin
      avl_address <= AVL_DDR_BASE_ADDRESS;
      avl_data <= 0;
      avl_write_transfer <= 1'b0;
      avl_mem_readen <= 0;
      avl_mem_rd_address <= 0;
      avl_mem_rd_address_g <= 0;
    end else begin
      if (avl_write_transfer_done_s == 1'b1) begin
          avl_address <= (avl_address < AVL_DDR_ADDRESS_LIMIT) ? avl_address + 1 : 0;
      end
      if (avl_write_transfer_s == 1'b1) begin
        avl_mem_rd_address <= avl_mem_rd_address + 1;
      end
      avl_data <= avl_mem_rdata_s;
      avl_mem_rd_address_g <= b2g(avl_mem_rd_address);
      avl_write_transfer <= avl_write_transfer_s;
      avl_mem_readen <= avl_mem_readen_s;
    end
  end

  // avalon write signaling

  assign avl_last_transfer_req_s = avl_last_beat_req & ~avl_mem_readen;

  always @(negedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_write <= 1'b0;
      avl_write_d <= 1'b0;
    end else begin
      if ((((avl_mem_readen == 1'b1) && (avl_write_xfer_req == 1'b1)) ||
          ((avl_last_transfer_req_s == 1'b1) && (avl_write_xfer_req == 1'b1)))   &&
           (avl_write == 1'b0) && (avl_write_d == 1'b0)) begin
        avl_write <= 1'b1;
      end else if (avl_write_transfer == 1'b1) begin
        avl_write <= 1'b0;
      end
      avl_write_d <= avl_write;
    end
  end

  assign avl_xfer_req_init_s = ~avl_dma_xfer_req & avl_dma_xfer_req_m2;

  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_last_beat_req_m1 <= 1'b0;
      avl_last_beat_req_m2 <= 1'b0;
      avl_last_beat_req <= 1'b0;
      avl_write_xfer_req <= 1'b0;
      avl_write_xfer_req_d <= 1'b0;
      avl_dma_xfer_req_m1 <= 1'b0;
      avl_dma_xfer_req_m2 <= 1'b0;
      avl_dma_xfer_req <= 1'b0;
    end else begin
      avl_last_beat_req_m1 <= dma_last_beat_ack;
      avl_last_beat_req_m2 <= avl_last_beat_req_m1;
      avl_last_beat_req <= avl_last_beat_req_m2;
      avl_dma_xfer_req_m1 <= dma_xfer_req;
      avl_dma_xfer_req_m2 <= avl_dma_xfer_req_m1;
      avl_dma_xfer_req <= avl_dma_xfer_req_m2;
      if (avl_xfer_req_init_s == 1'b1) begin
        avl_write_xfer_req <= 1'b1;
      end else if ((avl_last_transfer_req_s == 1'b1) &&
                  (avl_write_transfer == 1'b1)) begin
        avl_write_xfer_req <= 1'b0;
      end
      avl_write_xfer_req_d <= avl_write_xfer_req;
    end
  end

  // generate avl_byteenable signal

  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_last_beats_m1 <= 1'b0;
      avl_last_beats_m2 <= 1'b0;
      avl_last_beats <= 1'b0;
    end else begin
      avl_last_beats_m1 <= dma_mem_last_beats;
      avl_last_beats_m2 <= avl_last_beats_m1;
      avl_last_beats <= (avl_last_beat_req == 1'b1) ? avl_last_beats_m2 : avl_last_beats;
    end
  end

  always @(posedge avl_clk) begin
    if (avl_last_transfer_req_s == 1'b1) begin
      case (avl_last_beats)
        0 : begin
          case (MEM_RATIO)
            2 : avl_byteenable <= {32'b0, {32{1'b1}}};
            4 : avl_byteenable <= {48'b0, {16{1'b1}}};
            8 : avl_byteenable <= {56'b0, {8{1'b1}}};
            16 : avl_byteenable <= {60'b0, {4{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        1 : begin
          case (MEM_RATIO)
            4 : avl_byteenable <= {32'b0, {32{1'b1}}};
            8 : avl_byteenable <= {48'b0, {16{1'b1}}};
            16 : avl_byteenable <= {56'b0, {8{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        2 : begin
          case (MEM_RATIO)
            4 : avl_byteenable <= {16'b0, {48{1'b1}}};
            8 : avl_byteenable <= {40'b0, {24{1'b1}}};
            16 : avl_byteenable <= {52'b0, {12{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        3 : begin
          case (MEM_RATIO)
            8 : avl_byteenable <= {32'b0, {32{1'b1}}};
            16 : avl_byteenable <= {48'b0, {16{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        4 : begin
          case (MEM_RATIO)
            8 : avl_byteenable <= {24'b0, {40{1'b1}}};
            16 : avl_byteenable <= {44'b0, {20{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        5 : begin
          case (MEM_RATIO)
            8 : avl_byteenable <= {16'b0, {48{1'b1}}};
            16 : avl_byteenable <= {40'b0, {24{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        6 : begin
          case (MEM_RATIO)
            8 : avl_byteenable <= {8'b0, {56{1'b1}}};
            16 : avl_byteenable <= {36'b0, {28{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        7 : begin
          case (MEM_RATIO)
            16 : avl_byteenable <= {32'b0, {32{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        8 : begin
          case (MEM_RATIO)
            16 : avl_byteenable <= {28'b0, {36{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        9 : begin
          case (MEM_RATIO)
            16 : avl_byteenable <= {24'b0, {40{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        10 : begin
          case (MEM_RATIO)
            16 : avl_byteenable <= {20'b0, {44{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        11 : begin
          case (MEM_RATIO)
            16 : avl_byteenable <= {16'b0, {48{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        12 : begin
          case (MEM_RATIO)
            16 : avl_byteenable <= {12'b0, {52{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        13 : begin
          case (MEM_RATIO)
            16 : avl_byteenable <= {8'b0, {56{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        14 : begin
          case (MEM_RATIO)
            16 : avl_byteenable <= {4'b0, {60{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        15 : begin
          avl_byteenable <= {64{1'b1}};
        end
        default : avl_byteenable <= {64{1'b1}};
      endcase
    end else begin
      avl_byteenable <= {64{1'b1}};
    end
  end

  assign avl_burstcount = 6'b1;

  // save the last address and byteenable

  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_last_address <= 0;
      avl_last_byteenable <= 0;
    end else begin
      if ((avl_write == 1'b1) && (avl_last_transfer_req_s == 1'b1)) begin
        avl_last_address <= avl_address;
        avl_last_byteenable <= avl_byteenable;
      end
    end
  end

  // avl_xfer_req generation for synchronize the access of the external
  // memory

  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_xfer_req <= 1'b0;
    end else begin
      if ((avl_last_transfer_req_s == 1'b1) &&
         (avl_write_transfer == 1'b1)) begin
        avl_xfer_req <= 1'b1;
      end else if ((avl_xfer_req == 1'b1) && (avl_dma_xfer_req == 1'b1)) begin
        avl_xfer_req <= 1'b0;
      end
    end
  end

endmodule
