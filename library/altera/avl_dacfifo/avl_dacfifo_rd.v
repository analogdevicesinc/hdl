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

module avl_dacfifo_rd #(

  parameter     AVL_DATA_WIDTH = 512,
  parameter     DAC_DATA_WIDTH = 64,
  parameter     AVL_DDR_BASE_ADDRESS = 0,
  parameter     AVL_DDR_ADDRESS_LIMIT = 1048576,
  parameter     DAC_MEM_ADDRESS_WIDTH = 8)(

  input                                     dac_clk,
  input                                     dac_reset,
  input                                     dac_valid,
  output  reg [(DAC_DATA_WIDTH-1):0]        dac_data,
  output  reg                               dac_xfer_req,
  output  reg                               dac_dunf,

  input                                     avl_clk,
  input                                     avl_reset,
  output  reg [24:0]                        avl_address,
  output  reg [ 5:0]                        avl_burstcount,
  output  reg [63:0]                        avl_byteenable,
  input                                     avl_ready,
  input                                     avl_readdatavalid,
  output  reg                               avl_read,
  input       [AVL_DATA_WIDTH-1:0]          avl_data,

  input       [24:0]                        avl_last_address,
  input       [63:0]                        avl_last_byteenable,
  input                                     avl_xfer_req);

  // Max supported MEM_RATIO is 16
  localparam  MEM_RATIO = AVL_DATA_WIDTH/DAC_DATA_WIDTH;
  localparam  AVL_MEM_ADDRESS_WIDTH = (MEM_RATIO ==  1) ?  DAC_MEM_ADDRESS_WIDTH :
                                      (MEM_RATIO ==  2) ? (DAC_MEM_ADDRESS_WIDTH - 1) :
                                      (MEM_RATIO ==  4) ? (DAC_MEM_ADDRESS_WIDTH - 2) :
                                      (MEM_RATIO ==  8) ? (DAC_MEM_ADDRESS_WIDTH - 3) :
                                      (MEM_RATIO == 16) ? (DAC_MEM_ADDRESS_WIDTH - 4) :
                                                          (DAC_MEM_ADDRESS_WIDTH - 5);
  localparam  AVL_MEM_THRESHOLD_LO = 8;
  localparam  AVL_MEM_THRESHOLD_HI = {(AVL_MEM_ADDRESS_WIDTH){1'b1}} - 7;

  // internal register

  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_wr_address;
  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_wr_address_g;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   avl_mem_rd_address;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   avl_mem_rd_address_m1;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   avl_mem_rd_address_m2;
  reg                                       avl_mem_wr_enable;
  reg                                       avl_mem_request_data;
  reg         [AVL_DATA_WIDTH-1:0]          avl_mem_data;
  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_address_diff;
  reg                                       avl_xfer_req_d;
  reg                                       avl_xfer_req_dd;
  reg                                       avl_read_inprogress;

  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   dac_mem_wr_address;
  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   dac_mem_wr_address_m2;
  reg         [AVL_MEM_ADDRESS_WIDTH-1:0]   dac_mem_wr_address_m1;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   dac_mem_rd_address;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   dac_mem_rd_address_g;
  reg         [DAC_MEM_ADDRESS_WIDTH-1:0]   dac_mem_address_diff;

  reg                                       dac_avl_xfer_req;
  reg                                       dac_avl_xfer_req_m1;
  reg                                       dac_avl_xfer_req_m2;

  // internal signals

  wire        [AVL_MEM_ADDRESS_WIDTH-1:0]   avl_mem_rd_address_s;
  wire        [AVL_MEM_ADDRESS_WIDTH:0]     avl_mem_address_diff_s;
  wire        [DAC_MEM_ADDRESS_WIDTH:0]     dac_mem_address_diff_s;
  wire                                      avl_xfer_req_init_s;

  wire        [DAC_MEM_ADDRESS_WIDTH:0]     dac_mem_wr_address_s;
  wire                                      dac_mem_rd_enable_s;
  wire        [DAC_DATA_WIDTH-1:0]          dac_mem_data_s;

  // ==========================================================================
  // binary to grey conversion and grey to binary conversion for CDC circuitry
  // ==========================================================================

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

  // ==========================================================================
  // An asymmetric memory to transfer data from Avalon interface to DAC
  // interface
  // ==========================================================================

  ad_mem_asym #(
    .A_ADDRESS_WIDTH (AVL_MEM_ADDRESS_WIDTH),
    .A_DATA_WIDTH (AVL_DATA_WIDTH),
    .B_ADDRESS_WIDTH (DAC_MEM_ADDRESS_WIDTH),
    .B_DATA_WIDTH (DAC_DATA_WIDTH))
  i_mem_asym (
    .clka (avl_clk),
    .wea (avl_mem_wr_enable),
    .addra (avl_mem_wr_address),
    .dina (avl_mem_data),
    .clkb (dac_clk),
    .addrb (dac_mem_rd_address),
    .doutb (dac_mem_data_s));

  // ==========================================================================
  // Avalon Memory Mapped interface access
  // ==========================================================================

  // Avalon address generation and read control signaling

  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_address <= AVL_DDR_BASE_ADDRESS;
    end else begin
      if (avl_readdatavalid == 1'b1) begin
        avl_address <= (avl_address < avl_last_address) ? avl_address + 1 : 0;
      end
    end
  end

  assign avl_read_en_s = avl_xfer_req & avl_mem_request_data;

  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_read <= 1'b0;
      avl_read_inprogress <= 1'b0;
    end else begin
      if ((avl_read_inprogress == 1'b0) && (avl_read_en_s == 1'b1)) begin
        avl_read <= 1'b1;
        avl_read_inprogress <= 1'b1;
      end else if (avl_read_inprogress == 1'b1) begin
        avl_read <= 1'b0;
        if (avl_readdatavalid == 1'b1) begin
          avl_read_inprogress <= 1'b0;
        end
      end
    end
  end

  always @(posedge avl_clk) begin
    avl_burstcount <= 1'b1;
    avl_byteenable <= {64{1'b1}};
  end

  // write data from Avalon interface into the async FIFO

  assign avl_mem_wr_enable_s = avl_readdatavalid & avl_ready;
  always @(posedge avl_clk) begin
    if (avl_reset == 1'b1) begin
      avl_mem_data <= 0;
      avl_mem_wr_enable <= 0;
    end else begin
      avl_mem_wr_enable <= avl_mem_wr_enable_s;
      if (avl_mem_wr_enable_s == 1'b1) begin
        avl_mem_data <= avl_data;
      end
    end
  end

  always @(posedge avl_clk) begin
      avl_xfer_req_d <= avl_xfer_req;
      avl_xfer_req_dd <= avl_xfer_req_d;
  end
  assign avl_xfer_req_init_s = avl_xfer_req_d & ~avl_xfer_req_dd;

  always @(posedge avl_clk) begin
    if ((avl_reset == 1'b1) || (avl_xfer_req_init_s == 1'b1)) begin
      avl_mem_wr_address <= 0;
      avl_mem_wr_address_g <= 0;
    end else begin
      if (avl_mem_wr_enable == 1'b1) begin
        avl_mem_wr_address <= avl_mem_wr_address + 1;
      end
      avl_mem_wr_address_g <= b2g(avl_mem_wr_address);
    end
  end

  // ==========================================================================
  // control the FIFO to prevent overflow, underfloq is monitored
  // ==========================================================================

  assign avl_mem_rd_address_s = (MEM_RATIO ==  1) ? avl_mem_rd_address :
                                (MEM_RATIO ==  2) ? avl_mem_rd_address[(DAC_MEM_ADDRESS_WIDTH-1):1] :
                                (MEM_RATIO ==  4) ? avl_mem_rd_address[(DAC_MEM_ADDRESS_WIDTH-1):2] :
                                (MEM_RATIO ==  8) ? avl_mem_rd_address[(DAC_MEM_ADDRESS_WIDTH-1):3] :
                                (MEM_RATIO == 16) ? avl_mem_rd_address[(DAC_MEM_ADDRESS_WIDTH-1):4] :
                                                    avl_mem_rd_address[(DAC_MEM_ADDRESS_WIDTH-1):5];

  assign avl_mem_address_diff_s = {1'b1, avl_mem_wr_address} - avl_mem_rd_address_s;

  always @(posedge avl_clk) begin
    if (avl_xfer_req == 1'b0) begin
      avl_mem_address_diff <= 'd0;
      avl_mem_rd_address <= 'd0;
      avl_mem_rd_address_m1 <= 'd0;
      avl_mem_rd_address_m2 <= 'd0;
      avl_mem_request_data <= 'd0;
    end else begin
      avl_mem_rd_address_m1 <= dac_mem_rd_address_g;
      avl_mem_rd_address_m2 <= avl_mem_rd_address_m1;
      avl_mem_rd_address <= g2b(avl_mem_rd_address_m2);
      avl_mem_address_diff <= avl_mem_address_diff_s[AVL_MEM_ADDRESS_WIDTH-1:0];
      if (avl_mem_address_diff >= AVL_MEM_THRESHOLD_HI) begin
        avl_mem_request_data <= 1'b0;
      end else if (avl_mem_address_diff <= AVL_MEM_THRESHOLD_LO) begin
        avl_mem_request_data <= 1'b1;
      end
    end
  end

  // ==========================================================================
  // Push data from the async FIFO to the DAC
  // Data flow is controlled by the DAC, no back-pressure. If FIFO is not
  // ready, data will be dropped
  // ==========================================================================

  assign dac_mem_wr_address_s = (MEM_RATIO ==  1) ?  dac_mem_wr_address :
                                (MEM_RATIO ==  2) ? {dac_mem_wr_address, 1'b0} :
                                (MEM_RATIO ==  4) ? {dac_mem_wr_address, 2'b0} :
                                (MEM_RATIO ==  8) ? {dac_mem_wr_address, 3'b0} :
                                (MEM_RATIO == 16) ? {dac_mem_wr_address, 4'b0} :
                                                    {dac_mem_wr_address, 5'b0};

  assign dac_mem_address_diff_s = {1'b1, dac_mem_wr_address_s} - dac_mem_rd_address;

  always @(posedge dac_clk) begin
    if (dac_reset == 1'b1) begin
      dac_mem_wr_address_m2 <= 0;
      dac_mem_wr_address_m1 <= 0;
      dac_mem_wr_address <= 0;
    end else begin
      dac_mem_wr_address_m1 <= avl_mem_wr_address_g;
      dac_mem_wr_address_m2 <= dac_mem_wr_address_m1;
      dac_mem_wr_address <= g2b(dac_mem_wr_address_m2);
    end
  end

  always @(posedge dac_clk) begin
    if (dac_reset == 1'b1) begin
      dac_avl_xfer_req_m2 <= 0;
      dac_avl_xfer_req_m1 <= 0;
      dac_avl_xfer_req <= 0;
    end else begin
      dac_avl_xfer_req_m1 <= avl_xfer_req;
      dac_avl_xfer_req_m2 <= dac_avl_xfer_req_m1;
      dac_avl_xfer_req <= dac_avl_xfer_req_m1;
    end
  end

  assign dac_mem_rd_enable_s = (dac_xfer_req == 1'b1) ? dac_valid : 0;
  always @(posedge dac_clk) begin
    if ((dac_reset == 1'b1) || ((dac_avl_xfer_req == 1'b0) && (dac_xfer_req == 1'b0))) begin
      dac_mem_rd_address <= 0;
      dac_mem_rd_address_g <= 0;
      dac_mem_address_diff <= 0;
    end else begin
      dac_mem_address_diff <= dac_mem_address_diff_s[DAC_MEM_ADDRESS_WIDTH-1:0];
      if (dac_mem_rd_enable_s == 1'b1) begin
        dac_mem_rd_address <= dac_mem_rd_address + 1;
      end
      dac_mem_rd_address_g <= b2g(dac_mem_rd_address);
    end
  end

  always @(posedge dac_clk) begin
    if (dac_reset == 1'b1) begin
      dac_xfer_req <= 0;
    end else begin
      if ((dac_avl_xfer_req == 1'b1) && (dac_mem_address_diff > 0)) begin
        dac_xfer_req <= 1'b1;
      end else if ((dac_avl_xfer_req == 1'b0) && (dac_mem_address_diff_s[DAC_MEM_ADDRESS_WIDTH-1:0] == 0)) begin
        dac_xfer_req <= 1'b0;
      end
    end
  end

  always @(posedge dac_clk) begin
    if ((dac_reset == 1'b1) || (dac_xfer_req == 1'b0)) begin
      dac_data <= 0;
    end else begin
      dac_data <= dac_mem_data_s;
    end
  end

  always @(posedge dac_clk) begin
    if ((dac_reset == 1'b1) || (dac_xfer_req == 1'b0)) begin
      dac_dunf <= 1'b0;
    end else begin
      dac_dunf <= (dac_mem_address_diff == 0) ? 1'b1 : 1'b0;
    end
  end

endmodule

