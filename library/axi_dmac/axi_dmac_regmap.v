// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
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

module axi_dmac_regmap #(
  parameter ID = 0,
  parameter DISABLE_DEBUG_REGISTERS = 0,
  parameter BYTES_PER_BEAT_WIDTH_DEST = 1,
  parameter BYTES_PER_BEAT_WIDTH_SRC = 1,
  parameter BYTES_PER_BEAT_WIDTH_SG = 1,
  parameter BYTES_PER_BURST_WIDTH = 7,
  parameter DMA_TYPE_DEST = 0,
  parameter DMA_TYPE_SRC = 2,
  parameter DMA_AXI_ADDR_WIDTH = 32,
  parameter DMA_LENGTH_WIDTH = 24,
  parameter DMA_LENGTH_ALIGN = 3,
  parameter DMA_CYCLIC = 0,
  parameter HAS_DEST_ADDR = 1,
  parameter HAS_SRC_ADDR = 1,
  parameter DMA_2D_TRANSFER = 0,
  parameter DMA_SG_TRANSFER = 0,
  parameter SYNC_TRANSFER_START = 0,
  parameter CACHE_COHERENT = 0,
  parameter [3:0] AXI_AXCACHE = 4'b0011,
  parameter [2:0] AXI_AXPROT = 3'b000,
  parameter FRAMELOCK = 0,
  parameter DMA_2D_TLAST_MODE = 0,
  parameter MAX_NUM_FRAMES_WIDTH = 3,
  parameter USE_EXT_SYNC = 0,
  parameter AUTORUN = 0,
  parameter AUTORUN_FLAGS = 0,
  parameter AUTORUN_SRC_ADDR = 0,
  parameter AUTORUN_DEST_ADDR = 0,
  parameter AUTORUN_X_LENGTH = 0,
  parameter AUTORUN_Y_LENGTH = 0,
  parameter AUTORUN_SRC_STRIDE = 0,
  parameter AUTORUN_DEST_STRIDE = 0,
  parameter AUTORUN_SG_ADDRESS = 0,
  parameter AUTORUN_FRAMELOCK_CONFIG = 0,
  parameter AUTORUN_FRAMELOCK_STRIDE = 0,
  parameter AUTORUN_CONTROL_HWDESC = AUTORUN ? AUTORUN_FLAGS[3] : 0,
  parameter AUTORUN_CONTROL_FLOCK  = AUTORUN ? AUTORUN_FLAGS[4] : 0
) (

  // Slave AXI interface
  input s_axi_aclk,
  input s_axi_aresetn,

  input s_axi_awvalid,
  output s_axi_awready,
  input [10:0] s_axi_awaddr,
  input [2:0] s_axi_awprot,

  input s_axi_wvalid,
  output s_axi_wready,
  input [31:0] s_axi_wdata,
  input [3:0] s_axi_wstrb,

  output s_axi_bvalid,
  input s_axi_bready,
  output [1:0] s_axi_bresp,

  input s_axi_arvalid,
  output s_axi_arready,
  input [10:0] s_axi_araddr,
  input [2:0] s_axi_arprot,

  output s_axi_rvalid,
  input s_axi_rready,
  output [1:0] s_axi_rresp,
  output [31:0] s_axi_rdata,

  // Interrupt
  output reg irq,

  // Control interface
  output reg ctrl_enable = AUTORUN == 1,
  output reg ctrl_pause = 1'b0,
  output reg ctrl_hwdesc = AUTORUN_CONTROL_HWDESC,
  output reg ctrl_flock = AUTORUN_CONTROL_FLOCK,

  // DMA request interface
  output request_valid,
  input request_ready,
  output [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] request_dest_address,
  output [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC] request_src_address,
  output [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SG] request_sg_address,
  output [DMA_LENGTH_WIDTH-1:0] request_x_length,
  output [DMA_LENGTH_WIDTH-1:0] request_y_length,
  output [DMA_LENGTH_WIDTH-1:0] request_dest_stride,
  output [DMA_LENGTH_WIDTH-1:0] request_src_stride,
  output [MAX_NUM_FRAMES_WIDTH-1:0] request_flock_framenum,
  output                            request_flock_mode,
  output                            request_flock_wait_writer,
  output [MAX_NUM_FRAMES_WIDTH-1:0] request_flock_distance,
  output [DMA_AXI_ADDR_WIDTH-1:0] request_flock_stride,
  output request_sync_transfer_start,
  output request_last,
  output request_cyclic,

  // DMA response interface
  input response_eot,
  input [31:0] response_sg_desc_id,
  input [BYTES_PER_BURST_WIDTH-1:0] response_measured_burst_length,
  input response_partial,
  input response_valid,
  output response_ready,

  // Debug interface
  input [DMA_AXI_ADDR_WIDTH-1:0] dbg_src_addr,
  input [DMA_AXI_ADDR_WIDTH-1:0] dbg_dest_addr,
  input [11:0] dbg_status,
  input [31:0] dbg_ids0,
  input [31:0] dbg_ids1
);

  localparam PCORE_VERSION = 'h00040564;
  localparam HAS_ADDR_HIGH = DMA_AXI_ADDR_WIDTH > 32;
  localparam ADDR_LOW_MSB = HAS_ADDR_HIGH ? 31 : DMA_AXI_ADDR_WIDTH-1;

  localparam MAX_NUM_FRAMES = 2**MAX_NUM_FRAMES_WIDTH;

  // Register interface signals
  reg [31:0] up_rdata = 32'h00;
  reg up_wack = 1'b0;
  reg up_rack = 1'b0;

  wire up_wreq;
  wire up_rreq;
  wire [31:0] up_wdata;
  wire [8:0] up_waddr;
  wire [8:0] up_raddr;
  wire [31:0] up_rdata_request;

  // Scratch register
  reg [31:0] up_scratch = 32'h00;

  // Start and end of transfer
  wire up_eot; // Asserted for one cycle when a transfer has been completed
  wire up_sot; // Asserted for one cycle when a transfer has been queued

  // Interupt handling
  reg [1:0] up_irq_mask = 2'h3;
  reg [1:0] up_irq_source = 2'h0;

  wire [1:0] up_irq_pending;
  wire [1:0] up_irq_trigger;
  wire [1:0] up_irq_source_clear;

  // IRQ handling
  assign up_irq_pending = ~up_irq_mask & up_irq_source;
  assign up_irq_trigger  = {up_eot, up_sot};
  assign up_irq_source_clear = (up_wreq == 1'b1 && up_waddr == 9'h021) ? up_wdata[1:0] : 2'b00;

  always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 1'b0) begin
      irq <= 1'b0;
    end else begin
      irq <= |up_irq_pending;
    end
  end

  always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 1'b0) begin
      up_irq_source <= 2'b00;
    end else begin
      up_irq_source <= up_irq_trigger | (up_irq_source & ~up_irq_source_clear);
    end
  end

  // Register Interface

  always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 1'b0) begin
      ctrl_enable <= AUTORUN == 1;
      ctrl_pause <= 1'b0;
      ctrl_flock <= AUTORUN_CONTROL_FLOCK;
      ctrl_hwdesc <= AUTORUN_CONTROL_HWDESC;
      up_irq_mask <= 2'b11;
      up_scratch <= 32'h00;
      up_wack <= 1'b0;
    end else begin
      up_wack <= up_wreq;

      if (up_wreq == 1'b1) begin
        case (up_waddr)
        9'h002: begin
          up_scratch <= up_wdata;
          end
        9'h020: begin
          up_irq_mask <= up_wdata[1:0];
          end
        9'h100: begin
          ctrl_flock <= up_wdata[3] & FRAMELOCK;
          ctrl_hwdesc <= up_wdata[2] & DMA_SG_TRANSFER;
          ctrl_pause <= up_wdata[1];
          ctrl_enable <= up_wdata[0];
          end
        endcase
      end
    end
  end

  always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 1'b0) begin
      up_rack <= 'd0;
    end else begin
      up_rack <= up_rreq;
    end
  end

  always @(posedge s_axi_aclk) begin
    if (up_rreq == 1'b1) begin
      case (up_raddr)
      9'h000: up_rdata <= PCORE_VERSION;
      9'h001: up_rdata <= ID;
      9'h002: up_rdata <= up_scratch;
      9'h003: up_rdata <= 32'h444d4143; // "DMAC"
      9'h004: up_rdata <= {MAX_NUM_FRAMES[4:0]-1, DMA_2D_TLAST_MODE[0], USE_EXT_SYNC[0], AUTORUN[0],
                           4'b0,BYTES_PER_BURST_WIDTH[3:0],
                           2'b0,DMA_TYPE_SRC[1:0],BYTES_PER_BEAT_WIDTH_SRC[3:0],
                           2'b0,DMA_TYPE_DEST[1:0],BYTES_PER_BEAT_WIDTH_DEST[3:0]};
      9'h005: up_rdata <= {20'b0,
                           1'b0,AXI_AXPROT,
                           AXI_AXCACHE,
                           3'b0,CACHE_COHERENT};
      9'h020: up_rdata <= up_irq_mask;
      9'h021: up_rdata <= up_irq_pending;
      9'h022: up_rdata <= up_irq_source;
      9'h100: up_rdata <= {28'b0, ctrl_flock, ctrl_hwdesc, ctrl_pause, ctrl_enable};
      9'h10d: up_rdata <= DISABLE_DEBUG_REGISTERS ? 32'h00 : dbg_dest_addr[ADDR_LOW_MSB:0];
      9'h10e: up_rdata <= DISABLE_DEBUG_REGISTERS ? 32'h00 : dbg_src_addr[ADDR_LOW_MSB:0];
      9'h10f: up_rdata <= DISABLE_DEBUG_REGISTERS ? 32'h00 : dbg_status;
      9'h110: up_rdata <= DISABLE_DEBUG_REGISTERS ? 32'h00 : dbg_ids0;
      9'h111: up_rdata <= DISABLE_DEBUG_REGISTERS ? 32'h00 : dbg_ids1;
      9'h126: up_rdata <= (HAS_ADDR_HIGH && !DISABLE_DEBUG_REGISTERS) ? dbg_dest_addr[DMA_AXI_ADDR_WIDTH-1:32] : 32'h00;
      9'h127: up_rdata <= (HAS_ADDR_HIGH && !DISABLE_DEBUG_REGISTERS) ? dbg_src_addr[DMA_AXI_ADDR_WIDTH-1:32] : 32'h00;
      default: up_rdata <= up_rdata_request;
      endcase
    end
  end

  axi_dmac_regmap_request #(
    .DISABLE_DEBUG_REGISTERS(DISABLE_DEBUG_REGISTERS),
    .BYTES_PER_BEAT_WIDTH_DEST(BYTES_PER_BEAT_WIDTH_DEST),
    .BYTES_PER_BEAT_WIDTH_SRC(BYTES_PER_BEAT_WIDTH_SRC),
    .BYTES_PER_BEAT_WIDTH_SG(BYTES_PER_BEAT_WIDTH_SG),
    .BYTES_PER_BURST_WIDTH(BYTES_PER_BURST_WIDTH),
    .DMA_AXI_ADDR_WIDTH(DMA_AXI_ADDR_WIDTH),
    .DMA_LENGTH_WIDTH(DMA_LENGTH_WIDTH),
    .DMA_LENGTH_ALIGN(DMA_LENGTH_ALIGN),
    .DMA_CYCLIC(DMA_CYCLIC),
    .HAS_DEST_ADDR(HAS_DEST_ADDR),
    .HAS_SRC_ADDR(HAS_SRC_ADDR),
    .DMA_2D_TRANSFER(DMA_2D_TRANSFER),
    .DMA_SG_TRANSFER(DMA_SG_TRANSFER),
    .SYNC_TRANSFER_START(SYNC_TRANSFER_START),
    .FRAMELOCK(FRAMELOCK),
    .MAX_NUM_FRAMES_WIDTH(MAX_NUM_FRAMES_WIDTH),
    .AUTORUN(AUTORUN),
    .AUTORUN_FLAGS(AUTORUN_FLAGS),
    .AUTORUN_SRC_ADDR(AUTORUN_SRC_ADDR),
    .AUTORUN_DEST_ADDR(AUTORUN_DEST_ADDR),
    .AUTORUN_X_LENGTH(AUTORUN_X_LENGTH),
    .AUTORUN_Y_LENGTH(AUTORUN_Y_LENGTH),
    .AUTORUN_SRC_STRIDE(AUTORUN_SRC_STRIDE),
    .AUTORUN_DEST_STRIDE(AUTORUN_DEST_STRIDE),
    .AUTORUN_SG_ADDRESS(AUTORUN_SG_ADDRESS),
    .AUTORUN_FRAMELOCK_CONFIG(AUTORUN_FRAMELOCK_CONFIG),
    .AUTORUN_FRAMELOCK_STRIDE(AUTORUN_FRAMELOCK_STRIDE)
  ) i_regmap_request (
    .clk(s_axi_aclk),
    .reset(~s_axi_aresetn),

    .up_sot(up_sot),
    .up_eot(up_eot),

    .up_wreq(up_wreq),
    .up_rreq(up_rreq),
    .up_waddr(up_waddr),
    .up_wdata(up_wdata),
    .up_raddr(up_raddr),
    .up_rdata(up_rdata_request),

    .ctrl_enable(ctrl_enable),
    .ctrl_hwdesc(ctrl_hwdesc),

    .request_valid(request_valid),
    .request_ready(request_ready),
    .request_dest_address(request_dest_address),
    .request_src_address(request_src_address),
    .request_sg_address(request_sg_address),
    .request_x_length(request_x_length),
    .request_y_length(request_y_length),
    .request_dest_stride(request_dest_stride),
    .request_src_stride(request_src_stride),
    .request_flock_framenum(request_flock_framenum),
    .request_flock_mode(request_flock_mode),
    .request_flock_wait_writer(request_flock_wait_writer),
    .request_flock_distance(request_flock_distance),
    .request_flock_stride(request_flock_stride),
    .request_sync_transfer_start(request_sync_transfer_start),
    .request_last(request_last),
    .request_cyclic(request_cyclic),

    .response_eot(response_eot),
    .response_sg_desc_id(response_sg_desc_id),
    .response_measured_burst_length(response_measured_burst_length),
    .response_partial(response_partial),
    .response_valid(response_valid),
    .response_ready(response_ready));

  up_axi #(
    .AXI_ADDRESS_WIDTH (11)
  ) i_up_axi (
    .up_rstn(s_axi_aresetn),
    .up_clk(s_axi_aclk),
    .up_axi_awvalid(s_axi_awvalid),
    .up_axi_awaddr(s_axi_awaddr),
    .up_axi_awready(s_axi_awready),
    .up_axi_wvalid(s_axi_wvalid),
    .up_axi_wdata(s_axi_wdata),
    .up_axi_wstrb(s_axi_wstrb),
    .up_axi_wready(s_axi_wready),
    .up_axi_bvalid(s_axi_bvalid),
    .up_axi_bresp(s_axi_bresp),
    .up_axi_bready(s_axi_bready),
    .up_axi_arvalid(s_axi_arvalid),
    .up_axi_araddr(s_axi_araddr),
    .up_axi_arready(s_axi_arready),
    .up_axi_rvalid(s_axi_rvalid),
    .up_axi_rresp(s_axi_rresp),
    .up_axi_rdata(s_axi_rdata),
    .up_axi_rready(s_axi_rready),
    .up_wreq(up_wreq),
    .up_waddr(up_waddr),
    .up_wdata(up_wdata),
    .up_wack(up_wack),
    .up_rreq(up_rreq),
    .up_raddr(up_raddr),
    .up_rdata(up_rdata),
    .up_rack(up_rack));

endmodule
