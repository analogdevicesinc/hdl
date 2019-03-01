// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2018 (c) Analog Devices, Inc. All rights reserved.
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

module axi_dmac_regmap_request #(
  parameter DISABLE_DEBUG_REGISTERS = 0,
  parameter BYTES_PER_BEAT_WIDTH_DEST = 1,
  parameter BYTES_PER_BEAT_WIDTH_SRC = 1,
  parameter BYTES_PER_BURST_WIDTH = 7,
  parameter DMA_AXI_ADDR_WIDTH = 32,
  parameter DMA_LENGTH_WIDTH = 24,
  parameter DMA_LENGTH_ALIGN = 3,
  parameter DMA_CYCLIC = 0,
  parameter HAS_DEST_ADDR = 1,
  parameter HAS_SRC_ADDR = 1,
  parameter DMA_2D_TRANSFER = 0,
  parameter SYNC_TRANSFER_START = 0,
  parameter ENABLE_FRAME_LOCK = 0,
  parameter FRAME_LOCK_MODE = 0,
  parameter MAX_NUM_FRAMES_MSB = 2,
  parameter HAS_AUTORUN = 0,
  parameter DMAC_DEF_FLAGS = 0,
  parameter DMAC_DEF_SRC_ADDR = 0,
  parameter DMAC_DEF_DEST_ADDR = 0,
  parameter DMAC_DEF_X_LENGTH = 0,
  parameter DMAC_DEF_Y_LENGTH = 0,
  parameter DMAC_DEF_SRC_STRIDE = 0,
  parameter DMAC_DEF_DEST_STRIDE = 0,
  parameter DMAC_DEF_FLOCK_CFG = 0,
  parameter DMAC_DEF_FLOCK_STRIDE = 0
) (
  input clk,
  input reset,

  // Interrupts
  output up_sot,
  output up_eot,

  // Register map interface
  input up_wreq,
  input up_rreq,
  input [8:0] up_waddr,
  input [31:0] up_wdata,
  input [8:0] up_raddr,
  output reg [31:0] up_rdata,

  // Control interface
  input ctrl_enable,

  // DMA request interface
  output request_valid,
  input request_ready,
  output [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] request_dest_address,
  output [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC] request_src_address,
  output [DMA_LENGTH_WIDTH-1:0] request_x_length,
  output [DMA_LENGTH_WIDTH-1:0] request_y_length,
  output [DMA_LENGTH_WIDTH-1:0] request_dest_stride,
  output [DMA_LENGTH_WIDTH-1:0] request_src_stride,
  output [MAX_NUM_FRAMES_MSB:0] request_flock_framenum,
  output                        request_flock_mode,
  output                        request_flock_wait_master,
  output [MAX_NUM_FRAMES_MSB:0] request_flock_distance,
  output [DMA_AXI_ADDR_WIDTH-1:0] request_flock_stride,
  output request_flock_en,
  output request_sync_transfer_start,
  output request_last,
  output request_cyclic,

  // DMA response interface
  input response_eot,
  input [BYTES_PER_BURST_WIDTH:0] response_measured_burst_length,
  input response_partial,
  input response_valid,
  output reg response_ready = 1'b1

);

localparam MEASURED_LENGTH_WIDTH = (DMA_2D_TRANSFER == 1) ? 32 : DMA_LENGTH_WIDTH;

localparam DMAC_DEF_SRC_ADDR_LOC = (HAS_AUTORUN == 0) ? 'h00 :
    DMAC_DEF_SRC_ADDR[DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC];
localparam DMAC_DEF_DEST_ADDR_LOC = (HAS_AUTORUN == 0) ? 'h00 :
    DMAC_DEF_DEST_ADDR[DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST];
localparam DMAC_DEF_X_LENGTH_LOC = (HAS_AUTORUN == 0) ? 'h00 :
    DMAC_DEF_X_LENGTH[DMA_LENGTH_WIDTH-1:DMA_LENGTH_ALIGN];

localparam DMAC_DEF_FLAGS_CYCLIC = (HAS_AUTORUN == 0) ? DMA_CYCLIC :
    DMAC_DEF_FLAGS[0];
localparam DMAC_DEF_FLAGS_LAST = (HAS_AUTORUN == 0) ? 1 :
    DMAC_DEF_FLAGS[1];
localparam DMAC_DEF_FLAGS_TLEN = (HAS_AUTORUN == 0) ? 0 :
    DMAC_DEF_FLAGS[2];
localparam DMAC_DEF_FLAGS_FLOCK = (HAS_AUTORUN == 0) ? 0 :
    DMAC_DEF_FLAGS[3];

// DMA transfer signals
reg up_dma_req_valid = HAS_AUTORUN[0];
wire up_dma_req_ready;

reg [1:0] up_transfer_id = 2'b0;
reg [1:0] up_transfer_id_eot = 2'b0;
reg [3:0] up_transfer_done_bitmap = 4'b0;

reg [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] up_dma_dest_address = DMAC_DEF_DEST_ADDR_LOC;
reg [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC]  up_dma_src_address = DMAC_DEF_SRC_ADDR_LOC;
reg [DMA_LENGTH_WIDTH-1:0] up_dma_x_length = {DMAC_DEF_X_LENGTH_LOC,{DMA_LENGTH_ALIGN{1'b1}}};
reg up_dma_cyclic = DMAC_DEF_FLAGS_CYCLIC;
reg up_dma_last = DMAC_DEF_FLAGS_LAST;
reg up_dma_enable_tlen_reporting = DMAC_DEF_FLAGS_TLEN;
reg up_dma_flock_en = DMAC_DEF_FLAGS_FLOCK;

wire up_tlf_s_ready;
reg up_tlf_s_valid = 1'b0;

wire [MEASURED_LENGTH_WIDTH+2-1:0] up_tlf_data;
wire up_tlf_valid;
wire up_tlf_rd;
reg up_partial_length_valid = 1'b0;

reg [MEASURED_LENGTH_WIDTH-1:0] up_measured_transfer_length = 'h0;
reg up_clear_tl = 1'b0;
reg [1:0] up_transfer_id_eot_d = 'h0;
wire up_bl_partial;
wire [BYTES_PER_BURST_WIDTH:0] response_mbl_p1;

assign request_dest_address = up_dma_dest_address;
assign request_src_address = up_dma_src_address;
assign request_x_length = up_dma_x_length;
assign request_sync_transfer_start = SYNC_TRANSFER_START ? 1'b1 : 1'b0;
assign request_last = up_dma_last;
assign request_cyclic = up_dma_cyclic;

always @(posedge clk) begin
  if (reset == 1'b1) begin
    up_dma_src_address <= DMAC_DEF_SRC_ADDR_LOC;
    up_dma_dest_address <= DMAC_DEF_DEST_ADDR_LOC;
    up_dma_x_length[DMA_LENGTH_WIDTH-1:DMA_LENGTH_ALIGN] <= DMAC_DEF_X_LENGTH_LOC;
    up_dma_req_valid <= HAS_AUTORUN[0];
    up_dma_cyclic <= DMAC_DEF_FLAGS_CYCLIC;
    up_dma_last <= DMAC_DEF_FLAGS_LAST;
    up_dma_enable_tlen_reporting <= DMAC_DEF_FLAGS_TLEN;
    up_dma_flock_en <= DMAC_DEF_FLAGS_FLOCK;
  end else begin
    if (ctrl_enable == 1'b1) begin
      if (up_wreq == 1'b1 && up_waddr == 9'h102) begin
        up_dma_req_valid <= up_dma_req_valid | up_wdata[0];
      end else if (up_sot == 1'b1) begin
        up_dma_req_valid <= 1'b0;
      end
    end else begin
      up_dma_req_valid <= 1'b0;
    end

    if (up_wreq == 1'b1) begin
      case (up_waddr)
      9'h103: begin
        if (DMA_CYCLIC) up_dma_cyclic <= up_wdata[0];
        up_dma_last <= up_wdata[1];
        up_dma_enable_tlen_reporting <= up_wdata[2];
        if (ENABLE_FRAME_LOCK) up_dma_flock_en <=  up_wdata[3];
      end
      9'h104: up_dma_dest_address <= up_wdata[DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST];
      9'h105: up_dma_src_address <= up_wdata[DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC];
      9'h106: up_dma_x_length[DMA_LENGTH_WIDTH-1:DMA_LENGTH_ALIGN] <= up_wdata[DMA_LENGTH_WIDTH-1:DMA_LENGTH_ALIGN];
      endcase
    end
  end
end

always @(*) begin
  case (up_raddr)
  9'h101: up_rdata <= up_transfer_id;
  9'h102: up_rdata <= up_dma_req_valid;
  9'h103: up_rdata <= {28'h00, up_dma_flock_en, up_dma_enable_tlen_reporting, up_dma_last, up_dma_cyclic}; // Flags
  9'h104: up_rdata <= HAS_DEST_ADDR ? {up_dma_dest_address,{BYTES_PER_BEAT_WIDTH_DEST{1'b0}}} : 'h00;
  9'h105: up_rdata <= HAS_SRC_ADDR ? {up_dma_src_address,{BYTES_PER_BEAT_WIDTH_SRC{1'b0}}} : 'h00;
  9'h106: up_rdata <= up_dma_x_length;
  9'h107: up_rdata <= request_y_length;
  9'h108: up_rdata <= request_dest_stride;
  9'h109: up_rdata <= request_src_stride;
  9'h10a: up_rdata <= {up_partial_length_valid,27'b0,up_transfer_done_bitmap};
  9'h10b: up_rdata <= up_transfer_id_eot;
  9'h10c: up_rdata <= 32'h0;
  9'h112: up_rdata <= up_measured_transfer_length;
  9'h113: up_rdata <= up_tlf_data[MEASURED_LENGTH_WIDTH-1 : 0];   // Length
  9'h114: up_rdata <= up_tlf_data[MEASURED_LENGTH_WIDTH+: 2];  // ID
  9'h115: begin
            up_rdata <= 'h0;
            up_rdata[MAX_NUM_FRAMES_MSB:0] <= request_flock_framenum;
            up_rdata[8] <= request_flock_mode;
            up_rdata[9] <= request_flock_wait_master;
            up_rdata[16 +:(MAX_NUM_FRAMES_MSB+1)] <= request_flock_distance;
          end
  9'h116: up_rdata <= request_flock_stride;
  default: up_rdata <= 32'h00;
  endcase
end

generate
if (DMA_2D_TRANSFER == 1) begin
  localparam DMAC_DEF_Y_LENGTH_LOC = (HAS_AUTORUN == 0) ? 'h00 :
    DMAC_DEF_Y_LENGTH;
  localparam DMAC_DEF_SRC_STRIDE_LOC = (HAS_AUTORUN == 0) ? 'h00 :
    DMAC_DEF_SRC_STRIDE[DMA_LENGTH_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC];
  localparam DMAC_DEF_DEST_STRIDE_LOC = (HAS_AUTORUN == 0) ? 'h00 :
    DMAC_DEF_DEST_STRIDE[DMA_LENGTH_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST];

  reg [DMA_LENGTH_WIDTH-1:0] up_dma_y_length = DMAC_DEF_Y_LENGTH_LOC;
  reg [DMA_LENGTH_WIDTH-1:0] up_dma_src_stride = DMAC_DEF_SRC_STRIDE_LOC;
  reg [DMA_LENGTH_WIDTH-1:0] up_dma_dest_stride = DMAC_DEF_DEST_STRIDE_LOC;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      up_dma_y_length <= DMAC_DEF_Y_LENGTH_LOC;
      up_dma_dest_stride[DMA_LENGTH_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] <= DMAC_DEF_DEST_STRIDE_LOC;
      up_dma_src_stride[DMA_LENGTH_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC] <= DMAC_DEF_SRC_STRIDE_LOC;
    end else if (up_wreq == 1'b1) begin
      case (up_waddr)
      9'h107: up_dma_y_length <= up_wdata[DMA_LENGTH_WIDTH-1:0];
      9'h108: up_dma_dest_stride[DMA_LENGTH_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] <= up_wdata[DMA_LENGTH_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST];
      9'h109: up_dma_src_stride[DMA_LENGTH_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC] <= up_wdata[DMA_LENGTH_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC];
      endcase
    end
  end
  assign request_y_length = up_dma_y_length;
  assign request_dest_stride = up_dma_dest_stride;
  assign request_src_stride = up_dma_src_stride;
end else begin
  assign request_y_length = 'h0;
  assign request_dest_stride = 'h0;
  assign request_src_stride = 'h0;
end

if (ENABLE_FRAME_LOCK == 1) begin
  localparam DMAC_DEF_FLOCK_CFG_FNUM = (HAS_AUTORUN == 0) ? 'h00 :
    DMAC_DEF_FLOCK_CFG[MAX_NUM_FRAMES_MSB:0];
  localparam DMAC_DEF_FLOCK_CFG_MODE = (HAS_AUTORUN == 0) ? 'h0 :
    DMAC_DEF_FLOCK_CFG[8];
  localparam DMAC_DEF_FLOCK_CFG_WAIT_MASTER = (HAS_AUTORUN == 0) ? 'h0 :
    DMAC_DEF_FLOCK_CFG[9];
  localparam DMAC_DEF_FLOCK_CFG_DIST = (HAS_AUTORUN == 0) ? 'h00 :
    DMAC_DEF_FLOCK_CFG[16 +: (MAX_NUM_FRAMES_MSB+1)];
  localparam DMAC_DEF_FLOCK_STRIDE_LOC = (HAS_AUTORUN == 0) ? 'h00 :
    DMAC_DEF_FLOCK_STRIDE;

  reg [MAX_NUM_FRAMES_MSB:0] up_dma_flock_framenum = DMAC_DEF_FLOCK_CFG_FNUM;
  reg                          up_dma_flock_mode = DMAC_DEF_FLOCK_CFG_MODE;
  reg                          up_dma_flock_wait_master = DMAC_DEF_FLOCK_CFG_WAIT_MASTER;
  reg [MAX_NUM_FRAMES_MSB:0] up_dma_flock_distance = DMAC_DEF_FLOCK_CFG_DIST;
  reg [DMA_AXI_ADDR_WIDTH-1:0] up_dma_flock_stride = DMAC_DEF_FLOCK_STRIDE_LOC;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      up_dma_flock_framenum <= DMAC_DEF_FLOCK_CFG_FNUM;
      up_dma_flock_mode <= DMAC_DEF_FLOCK_CFG_MODE;
      up_dma_flock_wait_master <= DMAC_DEF_FLOCK_CFG_WAIT_MASTER;
      up_dma_flock_distance <= DMAC_DEF_FLOCK_CFG_DIST;
      up_dma_flock_stride <= DMAC_DEF_FLOCK_STRIDE_LOC;
    end else if (up_wreq == 1'b1) begin
      case (up_waddr)
        9'h115: begin
          up_dma_flock_framenum <= up_wdata[MAX_NUM_FRAMES_MSB:0];
          up_dma_flock_mode <= up_wdata[8];
          up_dma_flock_wait_master <= up_wdata[9];
          up_dma_flock_distance <= up_wdata[16 +: (MAX_NUM_FRAMES_MSB+1)];
        end
        9'h116: up_dma_flock_stride <= up_wdata[DMA_AXI_ADDR_WIDTH-1:0];
      endcase
    end
  end

  assign request_flock_framenum = up_dma_flock_framenum;
  assign request_flock_mode = up_dma_flock_mode;
  assign request_flock_wait_master = up_dma_flock_wait_master;
  assign request_flock_distance = up_dma_flock_distance;
  assign request_flock_stride = up_dma_flock_stride;
  assign request_flock_en = up_dma_flock_en;

end else begin
  assign request_flock_framenum = 'h0;
  assign request_flock_mode = 'h0;
  assign request_flock_wait_master = 'h0;
  assign request_flock_distance = 'h0;
  assign request_flock_stride = 'h0;
  assign request_flock_en = 1'b0;
end

endgenerate

// In cyclic mode the same transfer is submitted over and over again
assign up_sot = up_dma_cyclic ? 1'b0 : up_dma_req_valid & up_dma_req_ready;
assign up_eot = up_dma_cyclic ? 1'b0 : response_eot & response_valid & response_ready;

assign request_valid = up_dma_req_valid;
assign up_dma_req_ready = request_ready;

// Request ID and Request done bitmap handling
always @(posedge clk) begin
  if (ctrl_enable == 1'b0) begin
    up_transfer_id <= 2'h0;
    up_transfer_id_eot <= 2'h0;
    up_transfer_done_bitmap <= 4'h0;
  end else begin
    if (up_sot == 1'b1) begin
      up_transfer_id <= up_transfer_id + 1'b1;
      up_transfer_done_bitmap[up_transfer_id] <= 1'b0;
    end

    if (up_eot == 1'b1) begin
      up_transfer_id_eot <= up_transfer_id_eot + 1'b1;
      up_transfer_done_bitmap[up_transfer_id_eot] <= 1'b1;
    end
  end
end

assign up_tlf_rd = up_rreq && up_raddr == 'h114;
assign up_bl_partial = response_valid & response_ready & response_partial & up_dma_enable_tlen_reporting;

always @(posedge clk) begin
  if (ctrl_enable == 1'b0) begin
    up_partial_length_valid <= 1'b0;
  end else begin
    if (up_bl_partial == 1'b1) begin
      up_partial_length_valid <= 1'b1;
    end else if (up_tlf_rd == 1'b1) begin
      up_partial_length_valid <= 1'b0;
    end else if (up_tlf_valid == 1'b1) begin
      up_partial_length_valid <= 1'b1;
    end
  end
end

assign response_mbl_p1 = response_measured_burst_length + 1'b1;

always @(posedge clk) begin
  if (ctrl_enable == 1'b0) begin
    up_measured_transfer_length <= 'h0;
  end else if (response_valid == 1'b1 && response_ready == 1'b1) begin
    up_measured_transfer_length <= up_measured_transfer_length + response_mbl_p1;
  end else if (up_clear_tl == 1'b1) begin
    up_measured_transfer_length <= 'h0;
  end
end

always @(posedge clk) begin
  if (response_valid == 1'b1 && response_ready == 1'b1) begin
    up_transfer_id_eot_d <= up_transfer_id_eot;
  end
end

always @(posedge clk) begin
  if (ctrl_enable == 1'b0) begin
    response_ready <= 1'b1;
  end else if (response_ready == 1'b1) begin
    response_ready <= ~response_valid;
  end else if (up_tlf_s_ready == 1'b1) begin
    response_ready <= 1'b1;
  end
end

always @(posedge clk) begin
  if (response_valid == 1'b1 && response_ready == 1'b1) begin
    up_tlf_s_valid <= up_bl_partial;
    up_clear_tl <= response_eot;
  end else if (up_tlf_s_ready == 1'b1) begin
    up_tlf_s_valid <= 1'b0;
  end
end

// Buffer the length and transfer ID of partial transfers
util_axis_fifo #(
  .DATA_WIDTH(MEASURED_LENGTH_WIDTH + 2),
  .ADDRESS_WIDTH(2),
  .ASYNC_CLK(0)
) i_transfer_lenghts_fifo (
  .s_axis_aclk(clk),
  .s_axis_aresetn(ctrl_enable),
  .s_axis_valid(up_tlf_s_valid),
  .s_axis_ready(up_tlf_s_ready),
  .s_axis_empty(),
  .s_axis_data({up_transfer_id_eot_d, up_measured_transfer_length}),
  .s_axis_room(),

  .m_axis_aclk(clk),
  .m_axis_aresetn(ctrl_enable),
  .m_axis_valid(up_tlf_valid),
  .m_axis_ready(up_tlf_rd & up_tlf_valid),
  .m_axis_data(up_tlf_data),
  .m_axis_level()
);

endmodule
