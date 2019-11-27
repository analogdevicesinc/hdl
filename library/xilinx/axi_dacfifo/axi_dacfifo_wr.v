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

module axi_dacfifo_wr #(

  parameter       AXI_DATA_WIDTH = 512,
  parameter       DMA_DATA_WIDTH = 64,
  parameter       AXI_SIZE = 6,
  parameter       AXI_LENGTH = 15,
  parameter       AXI_ADDRESS = 32'h00000000,
  parameter       AXI_ADDRESS_LIMIT = 32'h00000000,
  parameter       DMA_MEM_ADDRESS_WIDTH = 8) (

  // dma fifo interface

  input                   dma_clk,
  input                   dma_rst,
  input       [(DMA_DATA_WIDTH-1):0]  dma_data,
  input                   dma_ready,
  output  reg             dma_ready_out,
  input                   dma_valid,

  // request and syncronizaiton

  input                   dma_xfer_req,
  input                   dma_xfer_last,
 (* dont_touch = "true" *) output  reg [ 3:0]      dma_last_beats,

  // last address for read side

  output  reg [31:0]      axi_last_addr,
  output  reg [ 7:0]      axi_last_beats,
  output  reg             axi_xfer_out,

  // axi write address, write data and write response channels

  input                   axi_clk,
  input                   axi_resetn,
  output  reg             axi_awvalid,
  output      [ 3:0]      axi_awid,
  output      [ 1:0]      axi_awburst,
  output                  axi_awlock,
  output      [ 3:0]      axi_awcache,
  output      [ 2:0]      axi_awprot,
  output      [ 3:0]      axi_awqos,
  output      [ 7:0]      axi_awlen,
  output      [ 2:0]      axi_awsize,
  output  reg [31:0]      axi_awaddr,
  input                   axi_awready,
  output                  axi_wvalid,
  output      [(AXI_DATA_WIDTH-1):0]      axi_wdata,
  output      [((AXI_DATA_WIDTH/8)-1):0]  axi_wstrb,
  output                  axi_wlast,
  input                   axi_wready,
  input                   axi_bvalid,
  input       [ 3:0]      axi_bid,
  input       [ 1:0]      axi_bresp,
  output                  axi_bready,

  output  reg             axi_werror);

  `define max(a,b) {(a) > (b) ? (a) : (b)}
  `define min(a,b) {(a) < (b) ? (a) : (b)}

  localparam      MIN_WIDTH = `min(AXI_DATA_WIDTH, DMA_DATA_WIDTH);
  localparam      MAX_WIDTH = `max(AXI_DATA_WIDTH, DMA_DATA_WIDTH);
  localparam      MEM_RATIO = MAX_WIDTH/MIN_WIDTH;
  localparam      AXI_BIGGER = (MAX_WIDTH == AXI_DATA_WIDTH) ? 1 : 0;

  localparam      AXI_MEM_ADDRESS_WIDTH = (MEM_RATIO == 1) ?  DMA_MEM_ADDRESS_WIDTH :
                    (MEM_RATIO == 2) ? (DMA_MEM_ADDRESS_WIDTH + ((AXI_BIGGER == 1) ? (-1) : 1)) :
                    (MEM_RATIO == 4) ? (DMA_MEM_ADDRESS_WIDTH + ((AXI_BIGGER == 1) ? (-2) : 2)) :
                    (MEM_RATIO == 8) ? (DMA_MEM_ADDRESS_WIDTH + ((AXI_BIGGER == 1) ? (-3) : 3)) :
                                       (DMA_MEM_ADDRESS_WIDTH + ((AXI_BIGGER == 1) ? (-4) : 4));

  localparam      AXI_BYTE_WIDTH = AXI_DATA_WIDTH/8;
  localparam      AXI_AWINCR = (AXI_LENGTH + 1) * AXI_BYTE_WIDTH;
  localparam      DMA_BUF_THRESHOLD_HI = {(DMA_MEM_ADDRESS_WIDTH){1'b1}} - 4;

  // FSM state definition

  localparam      IDLE               = 9'b000000001;
  localparam      XFER_STAGING       = 9'b000000010;
  localparam      XFER_FULL_BURST    = 9'b000000100;
  localparam      XFER_FB_WLAST      = 9'b000001000;
  localparam      XFER_PARTIAL_BURST = 9'b000010000;
  localparam      XFER_PB_WLAST      = 9'b000100000;
  localparam      XFER_LAST_BURST    = 9'b001000000;
  localparam      XFER_LB_WLAST      = 9'b010000000;
  localparam      XFER_END           = 9'b100000000;

  // registers

  reg     [(DMA_MEM_ADDRESS_WIDTH-1):0]     dma_mem_waddr = 'd0;
  reg     [(DMA_MEM_ADDRESS_WIDTH-1):0]     dma_mem_waddr_g = 'd0;
  reg     [(DMA_MEM_ADDRESS_WIDTH-1):0]     dma_mem_addr_diff = 'd0;
  reg     [(AXI_MEM_ADDRESS_WIDTH-1):0]     dma_mem_raddr_m1 = 'd0;
  reg     [(AXI_MEM_ADDRESS_WIDTH-1):0]     dma_mem_raddr_m2 = 'd0;
  reg     [(AXI_MEM_ADDRESS_WIDTH-1):0]     dma_mem_raddr = 'd0;
  reg     [ 2:0]                            dma_mem_last_read_toggle_m = 3'b0;
  reg     [ 1:0]                            dma_xfer_req_d = 2'b0;

  reg     [(DMA_MEM_ADDRESS_WIDTH-1):0]     axi_mem_waddr_m1 = 'd0;
  reg     [(DMA_MEM_ADDRESS_WIDTH-1):0]     axi_mem_waddr_m2 = 'd0;
  reg     [(DMA_MEM_ADDRESS_WIDTH-1):0]     axi_mem_waddr = 'd0;
  reg                                       axi_mem_rvalid = 1'b0;
  reg                                       axi_mem_rvalid_d = 1'b0;
  reg                                       axi_mem_last = 1'b0;
  reg                                       axi_mem_last_d = 1'b0;
  reg     [(AXI_DATA_WIDTH-1):0]            axi_mem_rdata = 'd0;
  reg     [(AXI_MEM_ADDRESS_WIDTH-1):0]     axi_mem_raddr = 'd0;
  reg     [(AXI_MEM_ADDRESS_WIDTH-1):0]     axi_mem_raddr_g = 'd0;
  reg                                       axi_mem_read_en_d = 1'b0;
  reg     [(AXI_MEM_ADDRESS_WIDTH-1):0]     axi_mem_addr_diff = 'd0;
  reg                                       axi_mem_last_read_toggle = 1'b0;
  reg     [ 2:0]                            axi_xfer_req_m = 3'b0;
  reg                                       axi_xfer_posedge = 1'b0;
  reg     [ 7:0]                            axi_wvalid_counter = 8'b0;
  reg     [ 7:0]                            axi_last_burst_length = 8'b0;
  (* dont_touch = "true" *)reg     [ 8:0]   axi_writer_state = 9'b0;
  reg     [ 3:0]                            axi_dma_last_beats_m1 = 4'b0;
  reg     [ 3:0]                            axi_dma_last_beats_m2 = 4'b0;
  reg                                       axi_xlast;
  reg     [ 3:0]                            axi_xfer_pburst_offset = 4'b1111;

  // internal signals

  wire                                      dma_fifo_reset_s;
  wire    [(DMA_MEM_ADDRESS_WIDTH):0]       dma_mem_addr_diff_s;
  wire    [(DMA_MEM_ADDRESS_WIDTH-1):0]     dma_mem_raddr_s;
  wire                                      dma_mem_last_read_s;
  wire                                      dma_xfer_posedge_s;
  wire                                      dma_mem_wea_s;
  wire    [(DMA_MEM_ADDRESS_WIDTH-1):0]     dma_mem_waddr_b2g_s;
  wire    [(AXI_MEM_ADDRESS_WIDTH-1):0]     dma_mem_raddr_m2_g2b_s;
  wire                                      axi_mem_read_en_s;
  wire    [(AXI_MEM_ADDRESS_WIDTH-1):0]     axi_mem_waddr_s;
  wire    [AXI_MEM_ADDRESS_WIDTH:0]         axi_mem_addr_diff_s;
  wire    [(AXI_DATA_WIDTH-1):0]            axi_mem_rdata_s;
  wire                                      axi_mem_rvalid_s;
  wire                                      axi_mem_last_s;
  wire    [(DMA_MEM_ADDRESS_WIDTH-1):0]     axi_mem_waddr_m2_g2b_s;
  wire    [(AXI_MEM_ADDRESS_WIDTH-1):0]     axi_mem_raddr_b2g_s;
  wire                                      axi_fifo_reset_s;
  wire                                      axi_waddr_ready_s;
  wire                                      axi_wready_s;
  wire                                      axi_partial_burst_s;
  wire                                      axi_xlast_s;
  wire                                      axi_reset_s;

  // Asymmetric memory to transfer data from DMAC interface to AXI Memory Map
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
    .reb (1'b1),
    .addrb (axi_mem_raddr),
    .doutb (axi_mem_rdata_s));

  assign axi_reset_s = ~axi_resetn;
  ad_axis_inf_rx #(.DATA_WIDTH(AXI_DATA_WIDTH)) i_axis_inf (
    .clk (axi_clk),
    .rst (axi_reset_s),
    .valid (axi_mem_rvalid_d),
    .last (axi_mem_last_d),
    .data (axi_mem_rdata),
    .inf_valid (axi_wvalid),
    .inf_last (axi_wlast),
    .inf_data (axi_wdata),
    .inf_ready (axi_wready));

  // reset signals - all the registers reset at the positive edge of
  // dma_xfer_req

  assign dma_xfer_posedge_s = ~dma_xfer_req_d[1] & dma_xfer_req_d[0];
  assign dma_fifo_reset_s = (dma_rst == 1'b1) || (dma_xfer_posedge_s == 1'b1);
  assign axi_fifo_reset_s = (axi_resetn == 1'b0) || (axi_xfer_posedge == 1'b1);

  // DMA beat counter

  always @(posedge dma_clk) begin
    dma_xfer_req_d <= {dma_xfer_req_d[0], dma_xfer_req};
    if (dma_fifo_reset_s == 1'b1) begin
      dma_last_beats <= 4'b0;
    end else begin
      if (dma_mem_wea_s == 1'b1) begin
        dma_last_beats <= (AXI_BIGGER == 1) ? ((dma_last_beats < MEM_RATIO-1) ? dma_last_beats + 4'b1 : 4'b0) : 4'b0;
      end
    end
  end

  // ASYNC MEM write control

  assign dma_mem_addr_diff_s = {1'b1, dma_mem_waddr} - dma_mem_raddr_s;
  assign dma_mem_raddr_s = (MEM_RATIO == 1) ?  dma_mem_raddr :
                           (MEM_RATIO == 2) ? ((AXI_BIGGER == 1) ? {dma_mem_raddr, 1'b0} : dma_mem_raddr[AXI_MEM_ADDRESS_WIDTH-1:1]) :
                           (MEM_RATIO == 4) ? ((AXI_BIGGER == 1) ? {dma_mem_raddr, 2'b0} : dma_mem_raddr[AXI_MEM_ADDRESS_WIDTH-1:2]) :
                           (MEM_RATIO == 8) ? ((AXI_BIGGER == 1) ? {dma_mem_raddr, 3'b0} : dma_mem_raddr[AXI_MEM_ADDRESS_WIDTH-1:3]) :
                                              ((AXI_BIGGER == 1) ? {dma_mem_raddr, 4'b0} : dma_mem_raddr[AXI_MEM_ADDRESS_WIDTH-1:4]);
  assign dma_mem_last_read_s = dma_mem_last_read_toggle_m[2] ^ dma_mem_last_read_toggle_m[1];
  assign dma_mem_wea_s = dma_xfer_req & dma_valid & dma_ready;

  always @(posedge dma_clk) begin
    if (dma_fifo_reset_s == 1'b1) begin
      dma_mem_waddr <= 'h0;
      dma_mem_waddr_g <= 'h0;
      dma_mem_last_read_toggle_m <= 3'b0;
    end else begin
      dma_mem_last_read_toggle_m = {dma_mem_last_read_toggle_m[1:0], axi_mem_last_read_toggle};
      if (dma_mem_wea_s == 1'b1) begin
        dma_mem_waddr <= dma_mem_waddr + 1;
      end
      if (dma_mem_last_read_s == 1'b1) begin
        dma_mem_waddr <= 'h0;
      end
      dma_mem_waddr_g <= dma_mem_waddr_b2g_s;
    end
  end

  ad_b2g # (
    .DATA_WIDTH(DMA_MEM_ADDRESS_WIDTH)
  ) i_dma_mem_waddr_b2g (
    .din (dma_mem_waddr),
    .dout (dma_mem_waddr_b2g_s));

  // The memory module request data until reaches the high threshold

  always @(posedge dma_clk) begin
    if (dma_fifo_reset_s == 1'b1) begin
      dma_mem_addr_diff <= 'b0;
      dma_mem_raddr_m1 <= 'b0;
      dma_mem_raddr_m2 <= 'b0;
      dma_mem_raddr <= 'b0;
      dma_ready_out <= 1'b1;
    end else begin
      dma_mem_raddr_m1 <= axi_mem_raddr_g;
      dma_mem_raddr_m2 <= dma_mem_raddr_m1;
      dma_mem_raddr <= dma_mem_raddr_m2_g2b_s;
      dma_mem_addr_diff <= dma_mem_addr_diff_s[DMA_MEM_ADDRESS_WIDTH-1:0];
      if (dma_mem_addr_diff >= DMA_BUF_THRESHOLD_HI) begin
        dma_ready_out <= 1'b0;
      end else begin
        dma_ready_out <= 1'b1;
      end
    end
  end

  ad_g2b # (
    .DATA_WIDTH(AXI_MEM_ADDRESS_WIDTH)
  ) i_dma_mem_raddr_g2b (
    .din (dma_mem_raddr_m2),
    .dout (dma_mem_raddr_m2_g2b_s));

  assign axi_xlast_s = axi_wready & axi_wvalid & axi_wlast;

  // FSM to generate the necessary AXI Write transactions

  always @(posedge axi_clk) begin
    if (axi_fifo_reset_s == 1'b1) begin
       axi_writer_state <= IDLE;
       axi_xlast <= 1'b0;
    end
    else
      axi_xlast <= axi_xlast_s;
      case (axi_writer_state)
        IDLE : begin
          if (axi_xfer_req_m[2] == 1'b1) begin
            axi_writer_state <= XFER_STAGING;
          end else begin
            axi_writer_state <= IDLE;
          end
        end
        XFER_STAGING : begin
          if (axi_xfer_req_m[2] == 1'b1) begin
            // there are enough data for one transaction
            if (axi_mem_addr_diff >= AXI_LENGTH) begin
              axi_writer_state <= XFER_FULL_BURST;
            end else begin
              axi_writer_state <= XFER_STAGING;
            end
          end else if (axi_xfer_pburst_offset == 4'b0) begin    // DMA transfer was finished
            if ((axi_mem_addr_diff > 0) ||
                (axi_dma_last_beats_m2 > 0)) begin
              axi_writer_state <= XFER_PARTIAL_BURST;
            end else begin
              axi_writer_state <= XFER_END;
            end
          end else begin
            axi_writer_state <= XFER_STAGING;
          end
        end
        // AXI transaction with full burst length
        XFER_FULL_BURST : begin
          if ((axi_wvalid_counter == axi_awlen) && (axi_mem_rvalid_s == 1'b1)) begin
            axi_writer_state <= XFER_FB_WLAST;
          end else begin
            axi_writer_state <= XFER_FULL_BURST;
          end
        end
        // Wait for the end of the transaction
        XFER_FB_WLAST : begin
          if (axi_xlast == 1'b1) begin
            axi_writer_state <= XFER_STAGING;
          end else begin
            axi_writer_state <= XFER_FB_WLAST;
          end
        end
        // AXI transaction with the remaining data, burst length is less than
        // the maximum supported burst length
        XFER_PARTIAL_BURST : begin
          if ((axi_wvalid_counter == axi_awlen) && (axi_mem_rvalid_s == 1'b1)) begin
            axi_writer_state <= XFER_PB_WLAST;
          end else begin
            axi_writer_state <= XFER_PARTIAL_BURST;
          end
        end
        // Wait for the end of the transaction
        XFER_PB_WLAST : begin
          if (axi_xlast == 1'b1) begin
            axi_writer_state <= XFER_END;
          end else begin
            axi_writer_state <= XFER_PB_WLAST;
          end
        end
        XFER_END : begin
          axi_writer_state <= IDLE;
        end
        default : begin
            axi_writer_state <= IDLE;
        end
      endcase
  end

  // FSM outputs

  assign axi_mem_read_en_s = ((axi_writer_state == XFER_FULL_BURST)    ||
                              (axi_writer_state == XFER_PARTIAL_BURST)) ? 1 : 0;
  assign axi_partial_burst_s = ((axi_writer_state == XFER_PARTIAL_BURST) ||
                                (axi_writer_state == XFER_PB_WLAST)) ? 1 : 0;

  // CDC for the memory write address, xfer_req and xfer_last

  always @(posedge axi_clk) begin
    if (axi_resetn == 1'b0) begin
      axi_xfer_req_m <= 3'b0;
      axi_xfer_posedge <= 1'b0;
    end else begin
      axi_xfer_req_m <= {axi_xfer_req_m[1:0], dma_xfer_req};
      axi_xfer_posedge <= ~axi_xfer_req_m[2] & axi_xfer_req_m[1];
    end
  end

  always @(posedge axi_clk) begin
    if (axi_fifo_reset_s == 1'b1) begin
      axi_mem_waddr_m1 <= 'b0;
      axi_mem_waddr_m2 <= 'b0;
      axi_mem_waddr <= 'b0;
      axi_xfer_pburst_offset <= 4'b1111;
    end else begin
      axi_mem_waddr_m1 <= dma_mem_waddr_g;
      axi_mem_waddr_m2 <= axi_mem_waddr_m1;
      axi_mem_waddr <= axi_mem_waddr_m2_g2b_s;
      if ((axi_xfer_req_m[2] == 0) && (axi_xfer_pburst_offset > 0)) begin
        axi_xfer_pburst_offset <= axi_xfer_pburst_offset - 4'b1;
      end
    end
  end

  ad_g2b # (
    .DATA_WIDTH(DMA_MEM_ADDRESS_WIDTH)
  ) i_axi_mem_waddr_g2b (
    .din (axi_mem_waddr_m2),
    .dout (axi_mem_waddr_m2_g2b_s));

  // ASYNC MEM read control

  assign axi_mem_waddr_s = (MEM_RATIO == 1) ? axi_mem_waddr :
                           (MEM_RATIO == 2) ? ((AXI_BIGGER == 1) ? axi_mem_waddr[(DMA_MEM_ADDRESS_WIDTH-1):1] : {axi_mem_waddr, 1'b0}) :
                           (MEM_RATIO == 4) ? ((AXI_BIGGER == 1) ? axi_mem_waddr[(DMA_MEM_ADDRESS_WIDTH-1):2] : {axi_mem_waddr, 2'b0}) :
                           (MEM_RATIO == 8) ? ((AXI_BIGGER == 1) ? axi_mem_waddr[(DMA_MEM_ADDRESS_WIDTH-1):3] : {axi_mem_waddr, 3'b0}) :
                                              ((AXI_BIGGER == 1) ? axi_mem_waddr[(DMA_MEM_ADDRESS_WIDTH-1):4] : {axi_mem_waddr, 4'b0});
  assign axi_mem_addr_diff_s = {1'b1, axi_mem_waddr_s} - axi_mem_raddr;


  always @(posedge axi_clk) begin
    if (axi_fifo_reset_s == 1'b1) begin
      axi_mem_addr_diff <= 'b0;
      axi_mem_read_en_d <= 1'b0;
    end else begin
      axi_mem_addr_diff <= axi_mem_addr_diff_s[(AXI_MEM_ADDRESS_WIDTH-1):0];
      axi_mem_read_en_d <= axi_mem_read_en_s;
    end
  end

  assign axi_wready_s = ~axi_wvalid | axi_wready;
  assign axi_mem_rvalid_s =  axi_mem_read_en_s & axi_wready_s;
  assign axi_mem_last_s = (axi_wvalid_counter == axi_awlen) ? axi_mem_rvalid_s : 1'b0;

  always @(posedge axi_clk) begin
    if (axi_fifo_reset_s == 1'b1) begin
      axi_mem_rvalid <= 1'b0;
      axi_mem_rvalid_d <= 1'b0;
      axi_mem_last <= 1'b0;
      axi_mem_last_d <= 1'b0;
      axi_mem_rdata <= 'b0;
      axi_mem_raddr <= 'b0;
      axi_wvalid_counter <= 8'b0;
      axi_mem_last_read_toggle <= 1'b0;
      axi_mem_raddr_g <= 'b0;
    end else begin
      axi_mem_rvalid <= axi_mem_rvalid_s;
      axi_mem_rvalid_d <= axi_mem_rvalid;
      axi_mem_last <= axi_mem_last_s;
      axi_mem_last_d <= axi_mem_last;
      axi_mem_rdata <= axi_mem_rdata_s;
      if (axi_mem_rvalid_s == 1'b1) begin
        axi_mem_raddr <= axi_mem_raddr + 1;
        axi_wvalid_counter <= (axi_wvalid_counter == axi_awlen) ? 0 : axi_wvalid_counter + 1;
      end
      if (axi_writer_state == XFER_END) begin
        axi_mem_raddr <= 'b0;
        axi_mem_last_read_toggle <= ~axi_mem_last_read_toggle;
      end
      axi_mem_raddr_g <= axi_mem_raddr_b2g_s;
    end
  end

  ad_b2g # (
    .DATA_WIDTH(AXI_MEM_ADDRESS_WIDTH)
  ) i_axi_mem_raddr_b2g (
    .din (axi_mem_raddr),
    .dout (axi_mem_raddr_b2g_s));

  // AXI Memory Map interface write address channel

  assign axi_awid    = 4'b0000;
  assign axi_awburst = 2'b01;             // INCR (Incrementing address burst)
  assign axi_awlock  = 1'b0;              // Normal access
  assign axi_awcache = 4'b0010;           // Cacheable, but not allocate
  assign axi_awprot  = 3'b000;            // Normal, secure, data access
  assign axi_awqos   = 4'b0000;           // Not used
  assign axi_awlen   = (axi_partial_burst_s == 1'b1) ? axi_last_burst_length : AXI_LENGTH;
  assign axi_awsize  = AXI_SIZE;

  assign axi_waddr_ready_s = axi_mem_read_en_s & ~axi_mem_read_en_d;

  always @(posedge axi_clk) begin
    if (axi_fifo_reset_s == 1'b1) begin
      axi_awvalid <= 'd0;
      axi_awaddr <= AXI_ADDRESS;
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
      if ((axi_awvalid == 1'b1) && (axi_awready == 1'b1)) begin
        axi_awaddr <= (axi_writer_state == XFER_FULL_BURST)    ?  (axi_awaddr + AXI_AWINCR) :
                      (axi_writer_state == XFER_PARTIAL_BURST) ?  (axi_awaddr + axi_last_burst_length * AXI_BYTE_WIDTH) :
                                                                  (axi_awaddr + AXI_AWINCR);
      end
      if (axi_writer_state == XFER_END) begin
        axi_xfer_out <= 1'b1;
      end
    end
  end

  // write data channel controls

  assign axi_wstrb = {AXI_BYTE_WIDTH{1'b1}};

  // response channel

  assign axi_bready = 1'b1;

  always @(posedge axi_clk) begin
    if (axi_fifo_reset_s == 1'b1) begin
      axi_werror <= 'd0;
    end else begin
      axi_werror <= axi_bvalid & axi_bresp[1];
    end
  end

  // AXI last address and last burst length

  assign axi_dma_last_beats_active_s = (axi_dma_last_beats_m2 > 0) ? 1'b1 : 1'b0;
  always @(posedge axi_clk) begin
    if (axi_fifo_reset_s == 1'b1) begin
      axi_dma_last_beats_m1 <= 0;
      axi_dma_last_beats_m2 <= 0;
      axi_last_burst_length <= AXI_LENGTH;
    end else begin
      axi_dma_last_beats_m1 <= dma_last_beats;
      axi_dma_last_beats_m2 <= axi_dma_last_beats_m1;
      axi_last_burst_length <= ((axi_partial_burst_s) &&
                                (axi_waddr_ready_s) &&
                                (axi_dma_last_beats_active_s))  ? axi_mem_addr_diff :
                               ((axi_partial_burst_s) &&
                                (axi_waddr_ready_s) &&
                                (~axi_dma_last_beats_active_s)) ? (axi_mem_addr_diff-1) :
                                                                   axi_last_burst_length;
     end
  end

  always @(posedge axi_clk) begin
    if(axi_fifo_reset_s == 1'b1) begin
      axi_last_addr <= AXI_ADDRESS;
      axi_last_beats <= 8'b0;
    end else begin
      if ((axi_awready == 1'b1) && (axi_awvalid == 1'b1)) begin
        axi_last_addr  <= axi_awaddr & (~AXI_AWINCR+1);
        axi_last_beats <= axi_last_burst_length;
      end
    end
  end

endmodule
