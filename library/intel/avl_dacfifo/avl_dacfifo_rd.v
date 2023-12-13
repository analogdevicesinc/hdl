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

module avl_dacfifo_rd #(

  parameter     AVL_DATA_WIDTH = 512,
  parameter     DAC_DATA_WIDTH = 64,
  parameter     AVL_BURST_LENGTH = 127,
  parameter     AVL_DDR_BASE_ADDRESS = 0,
  parameter     AVL_DDR_ADDRESS_LIMIT = 33554432,
  parameter     DAC_MEM_ADDRESS_WIDTH = 8
) (
  input                                     dac_clk,
  input                                     dac_reset,
  input                                     dac_valid,
  output  reg [(DAC_DATA_WIDTH-1):0]        dac_data,
  output  reg                               dac_xfer_req,
  output  reg                               dac_dunf,

  input                                     avl_clk,
  input                                     avl_reset,
  output  reg [24:0]                        avl_address,
  output  reg [ 6:0]                        avl_burstcount,
  output      [63:0]                        avl_byteenable,
  input                                     avl_waitrequest,
  input                                     avl_readdatavalid,
  output  reg                               avl_read,
  input       [AVL_DATA_WIDTH-1:0]          avl_data,

  input       [24:0]                        avl_last_address,
  input       [ 6:0]                        avl_last_burstcount,
  input       [ 7:0]                        dma_last_beats,
  input                                     avl_xfer_req_in,
  output  reg                               avl_xfer_req_out
);

  // Max supported MEM_RATIO is 16
  localparam  MEM_RATIO = AVL_DATA_WIDTH/DAC_DATA_WIDTH;
  localparam  AVL_MEM_ADDRESS_WIDTH = (MEM_RATIO ==  1) ?  DAC_MEM_ADDRESS_WIDTH :
                                      (MEM_RATIO ==  2) ? (DAC_MEM_ADDRESS_WIDTH - 1) :
                                      (MEM_RATIO ==  4) ? (DAC_MEM_ADDRESS_WIDTH - 2) :
                                      (MEM_RATIO ==  8) ? (DAC_MEM_ADDRESS_WIDTH - 3) :
                                      (MEM_RATIO == 16) ? (DAC_MEM_ADDRESS_WIDTH - 4) :
                                                          (DAC_MEM_ADDRESS_WIDTH - 5);
  localparam  AVL_MEM_THRESHOLD_LO = AVL_BURST_LENGTH;
  localparam  AVL_MEM_THRESHOLD_HI = {(AVL_MEM_ADDRESS_WIDTH){1'b1}} - AVL_BURST_LENGTH;
  localparam  DAC_MEM_THRESHOLD = 2 * (AVL_BURST_LENGTH * MEM_RATIO);

  localparam  MEM_WIDTH_DIFF = (MEM_RATIO > 16) ? 5 :
                               (MEM_RATIO >  8) ? 4 :
                               (MEM_RATIO >  4) ? 3 :
                               (MEM_RATIO >  2) ? 2 :
                               (MEM_RATIO >  1) ? 1 : 1;

  // FSM state definition

  localparam      IDLE               = 5'b00001;
  localparam      XFER_STAGING       = 5'b00010;
  localparam      XFER_FULL_BURST    = 5'b00100;
  localparam      XFER_PARTIAL_BURST = 5'b01000;
  localparam      XFER_END           = 5'b10000;

  // internal register

  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_waddr;
  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_laddr;
  reg                                       avl_mem_laddr_toggle;
  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_waddr_g;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   avl_mem_raddr;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   avl_mem_raddr_m1;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   avl_mem_raddr_m2;
  reg                                       avl_mem_request_data;
  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_addr_diff;
  reg         [ 4:0]                        avl_read_state;
  reg         [ 7:0]                        avl_burstcounter;
  reg                                       avl_inread;

  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   dac_mem_waddr;
  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   dac_mem_waddr_m1;
  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   dac_mem_waddr_m2;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   dac_mem_laddr;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   dac_mem_raddr;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   dac_mem_raddr_g;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   dac_mem_addr_diff;
  reg         [ 7:0]                        dac_mem_laddr_waddr;
  reg         [ 7:0]                        dac_mem_laddr_raddr;
  reg                                       dac_mem_laddr_valid;

  reg                                       dac_avl_xfer_req;
  reg                                       dac_avl_xfer_req_m1;
  reg                                       dac_avl_xfer_req_m2;

  reg         [ 7:0]                        dac_dma_last_beats_m1;
  reg         [ 7:0]                        dac_dma_last_beats_m2;
  reg         [ 7:0]                        dac_dma_last_beats;
  reg         [ 3:0]                        dac_mem_laddr_toggle_m;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   dac_mem_laddr_b;
  reg                                       dac_mem_renable;
  reg                                       dac_mem_valid;
  reg                                       dac_xfer_req_d;

  // internal signals

  wire                                      avl_fifo_reset_s;
  wire        [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_raddr_s;
  wire        [AVL_MEM_ADDRESS_WIDTH:0]     avl_mem_addr_diff_s;
  wire        [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_waddr_b2g_s;
  wire        [DAC_MEM_ADDRESS_WIDTH-1:0]   avl_mem_raddr_g2b_s;
  wire        [DAC_MEM_ADDRESS_WIDTH-1:0]   avl_mem_laddr_s;
  wire                                      avl_read_int_s;
  wire                                      avl_end_of_burst_s;

  wire                                      dac_fifo_reset_s;
  wire        [DAC_MEM_ADDRESS_WIDTH:0]     dac_mem_addr_diff_s;
  wire        [DAC_MEM_ADDRESS_WIDTH-1:0]   dac_mem_waddr_s;
  wire        [AVL_MEM_ADDRESS_WIDTH-1:0]   dac_mem_waddr_g2b_s;
  wire        [DAC_MEM_ADDRESS_WIDTH-1:0]   dac_mem_raddr_b2g_s;
  wire        [DAC_DATA_WIDTH-1:0]          dac_mem_data_s;
  wire                                      dac_mem_laddr_wea_s;
  wire                                      dac_mem_laddr_rea_s;
  wire                                      dac_mem_laddr_unf_s;
  wire        [DAC_MEM_ADDRESS_WIDTH-1:0]   dac_mem_laddr_s;
  wire                                      dac_mem_dunf_s;

  // An asymmetric memory to transfer data from Avalon interface to DAC
  // interface

  ad_mem_asym_rd i_mem_asym (
    .mem_i_wrclock_clk (avl_clk),
    .mem_i_wren_wren (avl_readdatavalid),
    .mem_i_wraddress_wraddress (avl_mem_waddr),
    .mem_i_datain_datain (avl_data),
    .mem_i_rdclock_clk (dac_clk),
    .mem_i_rdaddress_rdaddress (dac_mem_raddr),
    .mem_o_dataout_dataout (dac_mem_data_s));

  // the fifo reset is the dma_xfer_req

  assign avl_fifo_reset_s = avl_reset || ~avl_xfer_req_out;
  assign dac_fifo_reset_s = dac_reset || ~dac_avl_xfer_req;

  // loop back the avl_xfer_req to the WRITE module -- this way we can make
  // sure, that in case of a new DMA transfer, the last avalon read burst is
  // finished, so the upcomming avalon writes will not block the interface

  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_xfer_req_out <= 1'b0;
    end else begin
      if ((avl_read_state == IDLE) ||
          (avl_read_state == XFER_STAGING) ||
          (avl_read_state == XFER_END)) begin
        avl_xfer_req_out <= avl_xfer_req_in;
      end
    end
  end

  // FSM to generate the necessary Avalon Write transactions

  always @(posedge avl_clk) begin
    if (avl_fifo_reset_s == 1'b1) begin
      avl_read_state <= IDLE;
      avl_burstcount <= AVL_BURST_LENGTH;
    end else begin
      case (avl_read_state)
        IDLE : begin
          if (avl_xfer_req_in == 1'b1) begin
            avl_read_state <= XFER_STAGING;
          end else begin
            avl_read_state <= IDLE;
          end
        end
        XFER_STAGING : begin
          if (avl_xfer_req_in == 1'b1) begin
            if (avl_mem_request_data == 1'b1) begin
              if (avl_address + AVL_BURST_LENGTH <= avl_last_address) begin
                avl_read_state <= XFER_FULL_BURST;
                avl_burstcount <= AVL_BURST_LENGTH;
              end else begin
                avl_read_state <= XFER_PARTIAL_BURST;
                avl_burstcount <= avl_last_burstcount;
              end
            end
          end else begin
            avl_read_state <= IDLE;
          end
        end
        // Avalon transaction with full burst length
        XFER_FULL_BURST : begin
          if (avl_burstcounter < avl_burstcount) begin
            avl_read_state <= XFER_FULL_BURST;
          end else begin
            avl_read_state <= XFER_STAGING;
          end
        end
        // Avalon transaction with the remaining data, burst length is less than
        // the maximum supported burst length
        XFER_PARTIAL_BURST : begin
          if (avl_burstcounter < avl_burstcount) begin
            avl_read_state <= XFER_PARTIAL_BURST;
          end else begin
            avl_read_state <= XFER_END;
          end
        end
        XFER_END : begin
          avl_read_state <= IDLE;
        end
        default : begin
            avl_read_state <= IDLE;
        end
      endcase
    end
  end

  // FSM outputs

  assign avl_read_int_s = ((avl_read_state == XFER_FULL_BURST)    ||
                           (avl_read_state == XFER_PARTIAL_BURST)) ? 1 : 0;
  assign avl_end_of_burst_s = (avl_burstcount == avl_burstcounter) ? 1 : 0;

  // Avalon address generation and read control signaling

  always @(posedge avl_clk) begin
    if (avl_fifo_reset_s == 1'b1) begin
      avl_address <= AVL_DDR_BASE_ADDRESS;
    end else begin
      if (avl_end_of_burst_s == 1'b1) begin
        avl_address <= (avl_address < avl_last_address) ? avl_address + avl_burstcount : AVL_DDR_BASE_ADDRESS;
      end
    end
  end

  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_read <= 1'b0;
      avl_inread <= 1'b0;
    end else begin
      if (avl_read == 1'b0) begin
        if ((avl_waitrequest == 1'b0) && (avl_read_int_s == 1'b1) && (avl_inread == 1'b0)) begin
          avl_read <= 1'b1;
          avl_inread <= 1'b1;
        end
      end else if ((avl_read == 1'b1) && (avl_waitrequest == 1'b0)) begin
        avl_read <= 1'b0;
      end
      if (avl_end_of_burst_s == 1'b1) begin
        avl_inread <= 1'b0;
      end
    end
  end

  // Avalon burstcounter

  always @(posedge avl_clk) begin
    if (avl_fifo_reset_s == 1'b1) begin
      avl_burstcounter <= 8'b0;
    end else begin
      if ((avl_read_int_s == 1'b1) && (avl_readdatavalid == 1'b1)) begin
        avl_burstcounter <= (avl_burstcounter < avl_burstcount) ? avl_burstcounter + 1'b1 : 1'b0;
      end else if (avl_end_of_burst_s == 1'b1) begin
        avl_burstcounter <= 8'b0;
      end
    end
  end

  assign avl_byteenable = {64{1'b1}};

  // write data from Avalon interface into the async FIFO

  always @(posedge avl_clk) begin
    if (avl_fifo_reset_s == 1'b1) begin
        avl_mem_waddr <= 'b0;
        avl_mem_waddr_g <= 'b0;
        avl_mem_laddr <= 'b0;
        avl_mem_laddr_toggle <= 1'b0;
    end else begin
      if (avl_readdatavalid == 1'b1) begin
        avl_mem_waddr <= avl_mem_waddr + 1'b1;
      end
      if (avl_read_state == XFER_END) begin
        avl_mem_laddr <= avl_mem_waddr - 1'b1;
        avl_mem_laddr_toggle <= ~avl_mem_laddr_toggle;
      end
      avl_mem_waddr_g <= avl_mem_waddr_b2g_s;
    end
  end

  ad_b2g #(
    .DATA_WIDTH(AVL_MEM_ADDRESS_WIDTH)
  ) i_avl_mem_wr_addr_b2g (
    .din (avl_mem_waddr),
    .dout (avl_mem_waddr_b2g_s));

  // control the FIFO to prevent overflow, underflow is monitored

  assign avl_mem_raddr_s = (MEM_RATIO ==  1) ? avl_mem_raddr :
                           (MEM_RATIO ==  2) ? avl_mem_raddr[(DAC_MEM_ADDRESS_WIDTH-1):1] :
                           (MEM_RATIO ==  4) ? avl_mem_raddr[(DAC_MEM_ADDRESS_WIDTH-1):2] :
                           (MEM_RATIO ==  8) ? avl_mem_raddr[(DAC_MEM_ADDRESS_WIDTH-1):3] :
                           (MEM_RATIO == 16) ? avl_mem_raddr[(DAC_MEM_ADDRESS_WIDTH-1):4] :
                                               avl_mem_raddr[(DAC_MEM_ADDRESS_WIDTH-1):5];

  assign avl_mem_laddr_s = (MEM_RATIO ==  1) ? avl_mem_laddr :
                           (MEM_RATIO ==  2) ? {avl_mem_laddr, 1'b0} :
                           (MEM_RATIO ==  4) ? {avl_mem_laddr, 2'b0} :
                           (MEM_RATIO ==  8) ? {avl_mem_laddr, 3'b0} :
                           (MEM_RATIO == 16) ? {avl_mem_laddr, 4'b0} :
                                               {avl_mem_laddr, 5'b0};

  assign avl_mem_addr_diff_s = {1'b1, avl_mem_waddr} - avl_mem_raddr_s;

  always @(posedge avl_clk) begin
    if (avl_fifo_reset_s == 1'b1) begin
      avl_mem_addr_diff <= 'd0;
      avl_mem_raddr <= 'd0;
      avl_mem_raddr_m1 <= 'd0;
      avl_mem_raddr_m2 <= 'd0;
      avl_mem_request_data <= 'd0;
    end else begin
      avl_mem_raddr_m1 <= dac_mem_raddr_g;
      avl_mem_raddr_m2 <= avl_mem_raddr_m1;
      avl_mem_raddr <= avl_mem_raddr_g2b_s;
      avl_mem_addr_diff <= avl_mem_addr_diff_s[AVL_MEM_ADDRESS_WIDTH-1:0];
      if (avl_xfer_req_out == 1'b0) begin
        avl_mem_request_data <= 1'b0;
      end else if (avl_mem_addr_diff >= AVL_MEM_THRESHOLD_HI) begin
        avl_mem_request_data <= 1'b0;
      end else if (avl_mem_addr_diff <= AVL_MEM_THRESHOLD_LO) begin
        avl_mem_request_data <= 1'b1;
      end
    end
  end

  ad_g2b #(
    .DATA_WIDTH(DAC_MEM_ADDRESS_WIDTH)
  ) i_avl_mem_rd_addr_g2b (
    .din (avl_mem_raddr_m2),
    .dout (avl_mem_raddr_g2b_s));

  // Push data from the async FIFO to the DAC
  // Data flow is controlled by the DAC, no back-pressure. If FIFO is not
  // ready, data will be dropped

  assign dac_mem_waddr_s = (MEM_RATIO ==  1) ?  dac_mem_waddr :
                           (MEM_RATIO ==  2) ? {dac_mem_waddr, 1'b0} :
                           (MEM_RATIO ==  4) ? {dac_mem_waddr, 2'b0} :
                           (MEM_RATIO ==  8) ? {dac_mem_waddr, 3'b0} :
                           (MEM_RATIO == 16) ? {dac_mem_waddr, 4'b0} :
                                               {dac_mem_waddr, 5'b0};

  assign dac_mem_addr_diff_s = {1'b1, dac_mem_waddr_s} - dac_mem_raddr;

  always @(posedge dac_clk) begin
    if (dac_fifo_reset_s == 1'b1) begin
      dac_mem_waddr_m2 <= 0;
      dac_mem_waddr_m1 <= 0;
      dac_mem_waddr <= 0;
      dac_mem_laddr <= 0;
      dac_mem_laddr_toggle_m <= 4'b0;
    end else begin
      dac_mem_waddr_m1 <= avl_mem_waddr_g;
      dac_mem_waddr_m2 <= dac_mem_waddr_m1;
      dac_mem_waddr <= dac_mem_waddr_g2b_s;
      dac_mem_laddr_toggle_m <= {dac_mem_laddr_toggle_m[2:0], avl_mem_laddr_toggle};
      dac_mem_laddr <= (dac_mem_laddr_toggle_m[2] ^ dac_mem_laddr_toggle_m[1]) ?
                        avl_mem_laddr_s :
                        dac_mem_laddr;
    end
  end

  // A buffer for storing the dac_mem_laddr (the address of the last avalon
  // beat inside the CDC fifo)
  // If the stored data sequence is smaller, it can happen that multiple
  // dac_mem_laddr values exist in the same time. This buffers stores this
  // values and make sure that they are feeded to the read logic in order.

  assign dac_mem_laddr_wea_s = dac_mem_laddr_toggle_m[3] ^ dac_mem_laddr_toggle_m[2];
  assign dac_mem_laddr_rea_s = ((dac_mem_raddr == dac_mem_laddr_b) &&
                                (dac_mem_laddr_unf_s == 1'b0)) ? 1'b1 :1'b0;

  always @(posedge dac_clk) begin
    if (dac_fifo_reset_s == 1'b1) begin
      dac_mem_laddr_waddr <= 0;
      dac_mem_laddr_raddr <= 0;
    end else begin
      dac_mem_laddr_waddr <= (dac_mem_laddr_wea_s == 1'b1) ? dac_mem_laddr_waddr + 1 : dac_mem_laddr_waddr;
      dac_mem_laddr_raddr <= (dac_mem_laddr_rea_s == 1'b1) ? dac_mem_laddr_raddr + 1 : dac_mem_laddr_raddr;
    end
  end
  assign dac_mem_laddr_unf_s = (dac_mem_laddr_waddr == dac_mem_laddr_raddr) ? 1'b1 : 1'b0;

  always @(posedge dac_clk) begin
    if (dac_fifo_reset_s == 1'b1) begin
      dac_mem_laddr_valid <= 1'b0;
    end else begin
      if (dac_mem_laddr_wea_s == 1'b1)
        dac_mem_laddr_valid <= 1'b1;
    end
  end
  ad_mem #(
    .DATA_WIDTH (DAC_MEM_ADDRESS_WIDTH),
    .ADDRESS_WIDTH (8)
  ) i_mem (
    .clka (dac_clk),
    .wea (dac_mem_laddr_wea_s),
    .addra (dac_mem_laddr_waddr),
    .dina (dac_mem_laddr),
    .clkb (dac_clk),
    .reb (1'b1),
    .addrb (dac_mem_laddr_raddr),
    .doutb (dac_mem_laddr_s));

  ad_g2b #(
    .DATA_WIDTH(AVL_MEM_ADDRESS_WIDTH)
  ) i_dac_mem_wr_addr_g2b (
    .din (dac_mem_waddr_m2),
    .dout (dac_mem_waddr_g2b_s));

  always @(posedge dac_clk) begin
    if (dac_reset == 1'b1) begin
      dac_avl_xfer_req_m2 <= 0;
      dac_avl_xfer_req_m1 <= 0;
      dac_avl_xfer_req <= 0;
    end else begin
      dac_avl_xfer_req_m1 <= avl_xfer_req_out;
      dac_avl_xfer_req_m2 <= dac_avl_xfer_req_m1;
      dac_avl_xfer_req <= dac_avl_xfer_req_m2;
    end
  end

  always @(posedge dac_clk) begin
    if (dac_reset == 1'b1) begin
      dac_dma_last_beats_m2 <= 0;
      dac_dma_last_beats_m1 <= 0;
      dac_dma_last_beats <= 0;
    end else begin
      dac_dma_last_beats_m1 <= dma_last_beats;
      dac_dma_last_beats_m2 <= dac_dma_last_beats_m1;
      dac_dma_last_beats <= dac_dma_last_beats_m2;
    end
  end

  always @(posedge dac_clk) begin
    if (dac_fifo_reset_s == 1'b1) begin
        dac_mem_renable <= 1'b0;
        dac_mem_valid <= 1'b0;
    end else begin
      if (dac_mem_dunf_s == 1'b1) begin
        dac_mem_renable <= 1'b0;
      end else if (dac_mem_addr_diff >= DAC_MEM_THRESHOLD) begin
        dac_mem_renable <= 1'b1;
      end
      dac_mem_valid <= (dac_mem_renable) ? dac_valid : 1'b0;
    end
  end

  assign dac_mem_dunf_s = (dac_mem_addr_diff_s[DAC_MEM_ADDRESS_WIDTH-1:0] == {DAC_MEM_ADDRESS_WIDTH{1'b0}}) ? 1'b1 : 1'b0;
  always @(posedge dac_clk) begin
    if (dac_fifo_reset_s == 1'b1) begin
      dac_mem_raddr <= 0;
      dac_mem_raddr_g <= 0;
      dac_mem_addr_diff <= 0;
      dac_mem_laddr_b <= 0;
    end else begin
      dac_mem_laddr_b <= (!dac_mem_laddr_unf_s) ? dac_mem_laddr_s : dac_mem_laddr_b;
      dac_mem_addr_diff <= dac_mem_addr_diff_s[DAC_MEM_ADDRESS_WIDTH-1:0];
      if (dac_mem_valid) begin
        if ((dac_dma_last_beats != {MEM_WIDTH_DIFF{1'b1}}) &&
            (dac_mem_raddr == (dac_mem_laddr_b + dac_dma_last_beats)) &&
            (dac_mem_laddr_valid == 1'b1)) begin
          dac_mem_raddr <= dac_mem_raddr + (MEM_RATIO - dac_dma_last_beats);
        end else begin
          dac_mem_raddr <= dac_mem_raddr + 1'b1;
        end
      end
      dac_mem_raddr_g <= dac_mem_raddr_b2g_s;
    end
  end

  ad_b2g #(
    .DATA_WIDTH(DAC_MEM_ADDRESS_WIDTH)
  ) i_dac_mem_rd_addr_b2g (
    .din (dac_mem_raddr),
    .dout (dac_mem_raddr_b2g_s));

  always @(posedge dac_clk) begin
    if (dac_fifo_reset_s == 1'b1) begin
      dac_xfer_req <= 1'b0;
      dac_xfer_req_d <= 1'b0;
      dac_data <= {DAC_DATA_WIDTH{1'b0}};
    end else begin
      dac_xfer_req_d <= dac_mem_renable;
      dac_xfer_req <= dac_xfer_req_d;
      dac_data <= (dac_xfer_req_d == 1'b1) ? dac_mem_data_s : {DAC_DATA_WIDTH{1'b0}};
    end
  end

  always @(posedge dac_clk) begin
    if (dac_fifo_reset_s == 1'b1) begin
      dac_dunf <= 1'b0;
    end else begin
      dac_dunf <= (dac_mem_addr_diff == 0) ? 1'b1 : 1'b0;
    end
  end

endmodule
