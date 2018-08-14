// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module avl_dacfifo_wr #(

  parameter     AVL_DATA_WIDTH = 512,
  parameter     DMA_DATA_WIDTH = 64,
  parameter     AVL_BURST_LENGTH = 128,
  parameter     AVL_DDR_BASE_ADDRESS = 0,
  parameter     AVL_DDR_ADDRESS_LIMIT = 33554432,
  parameter     DMA_MEM_ADDRESS_WIDTH = 10)(

  input                                 dma_clk,
  input       [DMA_DATA_WIDTH-1:0]      dma_data,
  input                                 dma_ready,
  output  reg                           dma_ready_out,
  input                                 dma_valid,
  input                                 dma_xfer_req,
  input                                 dma_xfer_last,

  output  reg [ 7:0]                    dma_last_beats,

  input                                 avl_clk,
  input                                 avl_reset,
  output  reg [24:0]                    avl_address,
  output  reg [ 6:0]                    avl_burstcount,
  output      [63:0]                    avl_byteenable,
  input                                 avl_waitrequest,
  output  reg                           avl_write,
  output  reg [AVL_DATA_WIDTH-1:0]      avl_data,

  output  reg [24:0]                    avl_last_address,
  output  reg [ 6:0]                    avl_last_burstcount,
  output  reg                           avl_xfer_req_out,
  input                                 avl_xfer_req_in);

  localparam  MEM_RATIO = AVL_DATA_WIDTH/DMA_DATA_WIDTH;  // Max supported MEM_RATIO is 16
  localparam  AVL_MEM_ADDRESS_WIDTH = (MEM_RATIO ==  1) ?  DMA_MEM_ADDRESS_WIDTH :
                                      (MEM_RATIO ==  2) ? (DMA_MEM_ADDRESS_WIDTH - 1) :
                                      (MEM_RATIO ==  4) ? (DMA_MEM_ADDRESS_WIDTH - 2) :
                                      (MEM_RATIO ==  8) ? (DMA_MEM_ADDRESS_WIDTH - 3) :
                                      (MEM_RATIO == 16) ? (DMA_MEM_ADDRESS_WIDTH - 4) :
                                                          (DMA_MEM_ADDRESS_WIDTH - 5);
  localparam  MEM_WIDTH_DIFF = (MEM_RATIO > 16) ? 5 :
                               (MEM_RATIO >  8) ? 4 :
                               (MEM_RATIO >  4) ? 3 :
                               (MEM_RATIO >  2) ? 2 :
                               (MEM_RATIO >  1) ? 1 : 1;

  localparam  DMA_BUF_THRESHOLD_HI = {(DMA_MEM_ADDRESS_WIDTH){1'b1}} - AVL_BURST_LENGTH;

  // FSM state definition

  localparam      IDLE               = 5'b00001;
  localparam      XFER_STAGING       = 5'b00010;
  localparam      XFER_FULL_BURST    = 5'b00100;
  localparam      XFER_PARTIAL_BURST = 5'b01000;
  localparam      XFER_END           = 5'b10000;

  wire                                  dma_reset;
  wire                                  dma_fifo_reset_s;
  wire                                  dma_mem_wea_s;
  wire    [DMA_MEM_ADDRESS_WIDTH  :0]   dma_mem_addr_diff_s;
  wire    [DMA_MEM_ADDRESS_WIDTH-1:0]   dma_mem_raddr_s;
  wire    [DMA_MEM_ADDRESS_WIDTH-1:0]   dma_mem_waddr_b2g_s;
  wire    [AVL_MEM_ADDRESS_WIDTH-1:0]   dma_mem_raddr_g2b_s;

  wire                                  avl_fifo_reset_s;
  wire                                  avl_write_int_s;
  wire    [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_raddr_b2g_s;
  wire    [DMA_MEM_ADDRESS_WIDTH-1:0]   avl_mem_waddr_m2_g2b_s;
  wire    [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_addr_diff_s;
  wire    [AVL_MEM_ADDRESS_WIDTH:0]     avl_mem_waddr_s;
  wire    [AVL_DATA_WIDTH-1:0]          avl_data_s;
  wire                                  avl_xfer_req_lp_s;

  reg     [DMA_MEM_ADDRESS_WIDTH-1:0]   dma_mem_waddr;
  reg     [DMA_MEM_ADDRESS_WIDTH-1:0]   dma_mem_waddr_g;
  reg     [AVL_MEM_ADDRESS_WIDTH-1:0]   dma_mem_raddr_m1;
  reg     [AVL_MEM_ADDRESS_WIDTH-1:0]   dma_mem_raddr_m2;
  reg     [AVL_MEM_ADDRESS_WIDTH-1:0]   dma_mem_raddr;
  reg     [DMA_MEM_ADDRESS_WIDTH-1:0]   dma_mem_addr_diff;
  reg                                   dma_xfer_req_d;
  reg                                   dma_xfer_req_lp_m1;
  reg                                   dma_xfer_req_lp_m2;
  reg                                   dma_xfer_req_lp;
  reg                                   dma_avl_xfer_req_out_m1;
  reg                                   dma_avl_xfer_req_out_m2;
  reg                                   dma_avl_xfer_req_out;

  reg     [ 4:0]                        avl_write_state;
  reg                                   avl_write_d;
  reg     [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_raddr;
  reg     [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_raddr_g;
  reg     [DMA_MEM_ADDRESS_WIDTH-1:0]   avl_mem_waddr;
  reg     [DMA_MEM_ADDRESS_WIDTH-1:0]   avl_mem_waddr_m1;
  reg     [DMA_MEM_ADDRESS_WIDTH-1:0]   avl_mem_waddr_m2;
  reg     [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_addr_diff;
  reg                                   avl_dma_xfer_req;
  reg                                   avl_dma_xfer_req_m1;
  reg                                   avl_dma_xfer_req_m2;
  reg     [ 7:0]                        avl_dma_last_beats;
  reg     [ 7:0]                        avl_dma_last_beats_m1;
  reg     [ 7:0]                        avl_dma_last_beats_m2;
  reg     [ 3:0]                        avl_xfer_pburst_offset;
  reg     [ 7:0]                        avl_burst_counter;
  reg                                   avl_last_burst;
  reg                                   avl_init_burst;
  reg                                   avl_endof_burst;
  reg     [ 1:0]                        avl_mem_rvalid;
  reg                                   avl_xfer_req_lp;

  // An asymmetric memory to transfer data from DMAC interface to Avalon Memory Map
  // interface

  ad_mem_asym_wr i_mem_asym (
    .mem_i_wrclock (dma_clk),
    .mem_i_wren (dma_mem_wea_s),
    .mem_i_wraddress (dma_mem_waddr),
    .mem_i_datain (dma_data),
    .mem_i_rdclock (avl_clk),
    .mem_i_rdaddress (avl_mem_raddr),
    .mem_o_dataout (avl_data_s));

  // the fifo reset is the dma_xfer_req

  assign dma_reset = ~dma_xfer_req_d & dma_xfer_req;
  assign dma_fifo_reset_s = (~dma_xfer_req_lp & dma_xfer_req_lp_m2);
  assign avl_fifo_reset_s = (avl_reset == 1'b1) ||
                            (avl_dma_xfer_req_m2 & ~avl_dma_xfer_req);

  always @(posedge dma_clk) begin
    dma_xfer_req_d <= dma_xfer_req;
  end

  always @(posedge dma_clk) begin
    if (dma_reset) begin
      dma_xfer_req_lp_m1 <= 1'b0;
      dma_xfer_req_lp_m2 <= 1'b0;
      dma_xfer_req_lp <= 1'b0;
      dma_avl_xfer_req_out_m1 <= 1'b0;
      dma_avl_xfer_req_out_m2 <= 1'b0;
      dma_avl_xfer_req_out <= 1'b0;
    end else begin
      dma_xfer_req_lp_m1 <= avl_xfer_req_lp;
      dma_xfer_req_lp_m2 <= dma_xfer_req_lp_m1;
      dma_xfer_req_lp <= dma_xfer_req_lp_m2;
      dma_avl_xfer_req_out_m1 <= avl_xfer_req_out;
      dma_avl_xfer_req_out_m2 <= dma_avl_xfer_req_out_m1;
      dma_avl_xfer_req_out <= dma_avl_xfer_req_out_m2;
    end
  end

  // write address generation

  assign dma_mem_wea_s = dma_ready & dma_valid;

  always @(posedge dma_clk) begin
    if ((dma_fifo_reset_s == 1'b1) || (dma_avl_xfer_req_out == 1'b1)) begin
      dma_mem_waddr <= 0;
      dma_mem_waddr_g <= 0;
    end else begin
      if (dma_mem_wea_s == 1'b1) begin
        dma_mem_waddr <= dma_mem_waddr + 1'b1;
      end
    end
    dma_mem_waddr_g <= dma_mem_waddr_b2g_s;
  end

  always @(posedge dma_clk) begin
    if (dma_fifo_reset_s == 1'b1) begin
      dma_last_beats <= 0;
    end else begin
      if ((dma_xfer_last == 1'b1) && (dma_mem_wea_s == 1'b1)) begin
        dma_last_beats <= dma_mem_waddr[MEM_WIDTH_DIFF-1:0];
      end
    end
  end

  ad_b2g # (
    .DATA_WIDTH(DMA_MEM_ADDRESS_WIDTH)
  ) i_dma_mem_waddr_b2g (
    .din (dma_mem_waddr),
    .dout (dma_mem_waddr_b2g_s));

  // The memory module request data until reaches the high threshold.

  assign dma_mem_addr_diff_s = {1'b1, dma_mem_waddr} - dma_mem_raddr_s;
  assign dma_mem_raddr_s = (MEM_RATIO ==  1) ? {dma_mem_raddr, {0{1'b0}}} :
                           (MEM_RATIO ==  2) ? {dma_mem_raddr, {1{1'b0}}} :
                           (MEM_RATIO ==  4) ? {dma_mem_raddr, {2{1'b0}}} :
                           (MEM_RATIO ==  8) ? {dma_mem_raddr, {3{1'b0}}} :
                           (MEM_RATIO == 16) ? {dma_mem_raddr, {4{1'b0}}} :
                                               {dma_mem_raddr, {5{1'b0}}};

  always @(posedge dma_clk) begin
    if (dma_fifo_reset_s == 1'b1) begin
      dma_mem_addr_diff <= 'b0;
      dma_mem_raddr_m1 <= 'b0;
      dma_mem_raddr_m2 <= 'b0;
      dma_mem_raddr <= 'b0;
      dma_ready_out <= 1'b0;
    end else begin
      dma_mem_raddr_m1 <= avl_mem_raddr_g;
      dma_mem_raddr_m2 <= dma_mem_raddr_m1;
      dma_mem_raddr <= dma_mem_raddr_g2b_s;
      dma_mem_addr_diff <= dma_mem_addr_diff_s[DMA_MEM_ADDRESS_WIDTH-1:0];
      if (dma_xfer_req_lp == 1'b1) begin
        dma_ready_out <= (dma_mem_addr_diff >= DMA_BUF_THRESHOLD_HI) ? 1'b0 : 1'b1;
      end else begin
        dma_ready_out <= 1'b0;
      end
    end
  end

  ad_g2b #(
    .DATA_WIDTH(AVL_MEM_ADDRESS_WIDTH)
  ) i_dma_mem_rd_address_g2b (
    .din (dma_mem_raddr_m2),
    .dout (dma_mem_raddr_g2b_s));

  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_dma_xfer_req_m1 <= 'b0;
      avl_dma_xfer_req_m2 <= 'b0;
      avl_dma_xfer_req <= 'b0;
    end else begin
      avl_dma_xfer_req_m1 <= dma_xfer_req;
      avl_dma_xfer_req_m2 <= avl_dma_xfer_req_m1;
      avl_dma_xfer_req <= avl_dma_xfer_req_m2;
    end
  end

  assign avl_xfer_req_lp_s = avl_dma_xfer_req & ~avl_xfer_req_in;
  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_xfer_req_lp <= 1'b0;
    end else begin
      avl_xfer_req_lp <= avl_xfer_req_lp_s;
    end
  end

  // FSM to generate the necessary Avalon Write transactions

  always @(posedge avl_clk) begin
    if (avl_fifo_reset_s == 1'b1) begin
       avl_write_state <= IDLE;
       avl_last_burst <= 1'b0;
       avl_init_burst <= 1'b0;
       avl_endof_burst <= 1'b0;
    end else begin
      case (avl_write_state)
        IDLE : begin
          if (avl_dma_xfer_req == 1'b1) begin
            avl_write_state <= XFER_STAGING;
          end else begin
            avl_write_state <= IDLE;
          end
        end
        XFER_STAGING : begin
          avl_endof_burst <= 1'b0;
          if (avl_xfer_req_lp == 1'b1) begin
            // there are enough data for one transaction
            if (avl_mem_addr_diff >= AVL_BURST_LENGTH) begin
              avl_write_state <= XFER_FULL_BURST;
              avl_init_burst <= 1'b1;
            end else begin
              avl_write_state <= XFER_STAGING;
            end
          end else if ((avl_dma_xfer_req == 1'b0) && (avl_xfer_pburst_offset == 4'b0)) begin    // DMA transfer was finished
            if (avl_mem_addr_diff >= AVL_BURST_LENGTH) begin
              avl_write_state <= XFER_FULL_BURST;
              avl_init_burst <= 1'b1;
            end else if ((avl_mem_addr_diff > 0) ||
                (avl_dma_last_beats[MEM_WIDTH_DIFF-1:0] != {MEM_WIDTH_DIFF{1'b1}})) begin
              avl_write_state <= XFER_PARTIAL_BURST;
              avl_last_burst <= 1'b1;
            end else begin
              avl_write_state <= XFER_END;
            end
          end else begin
            avl_write_state <= XFER_STAGING;
          end
        end
        // Avalon transaction with full burst length
        XFER_FULL_BURST : begin
          avl_init_burst <= 1'b0;
          if ((avl_burst_counter < avl_burstcount) || ((avl_waitrequest) || (avl_write))) begin
            avl_write_state <= XFER_FULL_BURST;
          end else begin
            avl_write_state <= XFER_STAGING;
            avl_endof_burst <= 1'b1;
          end
        end
        // Avalon transaction with the remaining data, burst length is less than
        // the maximum supported burst length
        XFER_PARTIAL_BURST : begin
          avl_last_burst <= 1'b0;
          if ((avl_burst_counter < avl_burstcount) || ((avl_waitrequest) || (avl_write))) begin
            avl_write_state <= XFER_PARTIAL_BURST;
          end else begin
            avl_write_state <= XFER_END;
          end
        end
        XFER_END : begin
            avl_write_state <= IDLE;
        end
        default : begin
            avl_write_state <= IDLE;
        end
      endcase
    end
  end

  // FSM outputs

  assign avl_write_int_s = ((avl_write_state == XFER_FULL_BURST)    ||
                            (avl_write_state == XFER_PARTIAL_BURST)) ? 1'b1 : 1'b0;

  always @(posedge avl_clk) begin
    if (avl_fifo_reset_s == 1'b1) begin
      avl_mem_waddr_m1 <= 'b0;
      avl_mem_waddr_m2 <= 'b0;
      avl_mem_waddr <= 'b0;
      avl_xfer_pburst_offset <= 4'b1111;
    end else begin
      avl_mem_waddr_m1 <= dma_mem_waddr_g;
      avl_mem_waddr_m2 <= avl_mem_waddr_m1;
      avl_mem_waddr <= avl_mem_waddr_m2_g2b_s;
      if ((avl_dma_xfer_req == 0) && (avl_xfer_pburst_offset > 0)) begin
        avl_xfer_pburst_offset <= avl_xfer_pburst_offset - 4'b1;
      end
    end
  end

  ad_g2b # (
    .DATA_WIDTH(DMA_MEM_ADDRESS_WIDTH)
  ) i_avl_mem_waddr_g2b (
    .din (avl_mem_waddr_m2),
    .dout (avl_mem_waddr_m2_g2b_s));

  // ASYNC MEM read control

  assign avl_mem_waddr_s = (MEM_RATIO == 1) ? {avl_mem_waddr[(DMA_MEM_ADDRESS_WIDTH-1):0]} :
                           (MEM_RATIO == 2) ? {avl_mem_waddr[(DMA_MEM_ADDRESS_WIDTH-1):1]} :
                           (MEM_RATIO == 4) ? {avl_mem_waddr[(DMA_MEM_ADDRESS_WIDTH-1):2]} :
                           (MEM_RATIO == 8) ? {avl_mem_waddr[(DMA_MEM_ADDRESS_WIDTH-1):3]} :
                                              {avl_mem_waddr[(DMA_MEM_ADDRESS_WIDTH-1):4]};
  assign avl_mem_addr_diff_s = {1'b1, avl_mem_waddr_s} - avl_mem_raddr;

  always @(posedge avl_clk) begin
    if (avl_fifo_reset_s == 1'b1) begin
      avl_mem_addr_diff <= 'b0;
    end else begin
      avl_mem_addr_diff <= avl_mem_addr_diff_s[(AVL_MEM_ADDRESS_WIDTH-1):0];
    end
  end

  always @(posedge avl_clk) begin
    if (avl_fifo_reset_s == 1'b1) begin
      avl_mem_rvalid <= 2'b0;
      avl_mem_raddr <= 'b0;
      avl_mem_raddr_g <= 'b0;
    end else begin
      if (~avl_waitrequest && avl_write) begin
        avl_mem_rvalid[0] <= 1'b1;
        avl_mem_rvalid[1] <= avl_mem_rvalid[0];
      end else begin
        avl_mem_rvalid <= {avl_mem_rvalid[0], 1'b0};
      end
      if (~avl_waitrequest && avl_write) begin
        avl_mem_raddr <= avl_mem_raddr + 1'b1;
      end
      if (avl_write_state == XFER_END) begin
        avl_mem_raddr <= 'b0;
      end
      avl_mem_raddr_g <= avl_mem_raddr_b2g_s;
    end
  end

  ad_b2g #(
    .DATA_WIDTH(AVL_MEM_ADDRESS_WIDTH)
  ) i_avl_mem_rd_address_b2g (
    .din (avl_mem_raddr),
    .dout (avl_mem_raddr_b2g_s));

  // Avalon write address

  always @(posedge avl_clk) begin
    if (avl_fifo_reset_s == 1'b1) begin
      avl_address <= AVL_DDR_BASE_ADDRESS;
    end else begin
      if (avl_endof_burst == 1'b1) begin
          avl_address <= (avl_address < AVL_DDR_ADDRESS_LIMIT) ? avl_address + AVL_BURST_LENGTH : AVL_DDR_BASE_ADDRESS;
      end
    end
  end

  // Avalon write

  always @(posedge avl_clk) begin
    if ((avl_fifo_reset_s == 1'b1) || (avl_write_state == XFER_END)) begin
      avl_write <= 1'b0;
      avl_write_d <= 1'b0;
      avl_data <= 'b0;
    end else begin
      if (~avl_waitrequest) begin
        avl_write_d <= (avl_init_burst || avl_last_burst) ||
                       (avl_write_int_s & avl_mem_rvalid[1]);
        avl_write <= avl_write_d;
        avl_data <= avl_data_s;
      end
    end
  end

  // Avalon burstcount & counter

  always @(posedge avl_clk) begin
    if (avl_reset) begin
      avl_burstcount <= 'b1;
      avl_burst_counter <= 'b0;
    end else begin
      if (avl_last_burst) begin
        if (avl_dma_last_beats[MEM_WIDTH_DIFF-1:0] != {MEM_WIDTH_DIFF{1'b1}}) begin
          avl_burstcount <= avl_mem_addr_diff + 1;
        end else begin
          avl_burstcount <= avl_mem_addr_diff;
        end
      end else if (avl_write_state != XFER_PARTIAL_BURST) begin
        avl_burstcount <= AVL_BURST_LENGTH;
      end
      if (avl_write_state == XFER_STAGING) begin
        avl_burst_counter <= 'b0;
      end else if (avl_write_d && ~avl_waitrequest) begin
        avl_burst_counter <= avl_burst_counter + 1'b1;
      end
    end
  end

  // generate avl_byteenable signal

  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_dma_last_beats_m1 <= 8'b0;
      avl_dma_last_beats_m2 <= 8'b0;
      avl_dma_last_beats <= 8'b0;
    end else begin
      avl_dma_last_beats_m1 <= dma_last_beats;
      avl_dma_last_beats_m2 <= avl_dma_last_beats_m1;
      avl_dma_last_beats <= avl_dma_last_beats_m2;
    end
  end

  assign avl_byteenable = {64{1'b1}};

  // save the last address and byteenable

  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_last_address <= 0;
      avl_last_burstcount <= 'b0;
    end else begin
      if (avl_write && ~avl_waitrequest) begin
        avl_last_address <= avl_address;
        avl_last_burstcount <= avl_burstcount;
      end
    end
  end

  // avl_xfer_req generation for synchronize the access of the external
  // memory

  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_xfer_req_out <= 1'b0;
    end else begin
      if (avl_write_state == XFER_END) begin
        avl_xfer_req_out <= 1'b1;
      end else if (avl_write_state == XFER_STAGING) begin
        avl_xfer_req_out <= 1'b0;
      end
    end
  end

endmodule
