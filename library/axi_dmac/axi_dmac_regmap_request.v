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

module axi_dmac_regmap_request #(
  parameter DISABLE_DEBUG_REGISTERS = 0,
  parameter BYTES_PER_BEAT_WIDTH_DEST = 1,
  parameter BYTES_PER_BEAT_WIDTH_SRC = 1,
  parameter DMA_AXI_ADDR_WIDTH = 32,
  parameter DMA_LENGTH_WIDTH = 24,
  parameter DMA_LENGTH_ALIGN = 3,
  parameter DMA_CYCLIC = 0,
  parameter HAS_DEST_ADDR = 1,
  parameter HAS_SRC_ADDR = 1,
  parameter DMA_2D_TRANSFER = 0,
  parameter SYNC_TRANSFER_START = 0
) (
  input clk,
  input reset,

  // Interrupts
  output up_sot,
  output up_eot,

  // Register map interface
  input up_wreq,
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
  output request_sync_transfer_start,
  output request_last,

  // DMA response interface
  input response_eot
);

// DMA transfer signals
reg up_dma_req_valid = 1'b0;
wire up_dma_req_ready;

reg [1:0] up_transfer_id = 2'b0;
reg [1:0] up_transfer_id_eot = 2'b0;
reg [3:0] up_transfer_done_bitmap = 4'b0;

reg [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] up_dma_dest_address = 'h00;
reg [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC]  up_dma_src_address = 'h00;
reg [DMA_LENGTH_WIDTH-1:0] up_dma_x_length = {DMA_LENGTH_ALIGN{1'b1}};
reg up_dma_cyclic = DMA_CYCLIC ? 1'b1 : 1'b0;
reg up_dma_last = 1'b1;

assign request_dest_address = up_dma_dest_address;
assign request_src_address = up_dma_src_address;
assign request_x_length = up_dma_x_length;
assign request_sync_transfer_start = SYNC_TRANSFER_START ? 1'b1 : 1'b0;
assign request_last = up_dma_last;

always @(posedge clk) begin
  if (reset == 1'b1) begin
    up_dma_src_address <= 'h00;
    up_dma_dest_address <= 'h00;
    up_dma_x_length[DMA_LENGTH_WIDTH-1:DMA_LENGTH_ALIGN] <= 'h00;
    up_dma_req_valid <= 1'b0;
    up_dma_cyclic <= DMA_CYCLIC ? 1'b1 : 1'b0;
    up_dma_last <= 1'b1;
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
  9'h103: up_rdata <= {30'h00, up_dma_last, up_dma_cyclic}; // Flags
  9'h104: up_rdata <= HAS_DEST_ADDR ? {up_dma_dest_address,{BYTES_PER_BEAT_WIDTH_DEST{1'b0}}} : 'h00;
  9'h105: up_rdata <= HAS_SRC_ADDR ? {up_dma_src_address,{BYTES_PER_BEAT_WIDTH_SRC{1'b0}}} : 'h00;
  9'h106: up_rdata <= up_dma_x_length;
  9'h107: up_rdata <= request_y_length;
  9'h108: up_rdata <= request_dest_stride;
  9'h109: up_rdata <= request_src_stride;
  9'h10a: up_rdata <= up_transfer_done_bitmap;
  9'h10b: up_rdata <= up_transfer_id_eot;
  default: up_rdata <= 32'h00;
  endcase
end

generate
if (DMA_2D_TRANSFER == 1) begin
  reg [DMA_LENGTH_WIDTH-1:0] up_dma_y_length = 'h00;
  reg [DMA_LENGTH_WIDTH-1:0] up_dma_src_stride = 'h00;
  reg [DMA_LENGTH_WIDTH-1:0] up_dma_dest_stride = 'h00;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      up_dma_y_length <= 'h00;
      up_dma_dest_stride[DMA_LENGTH_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] <= 'h00;
      up_dma_src_stride[DMA_LENGTH_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC] <= 'h00;
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
endgenerate

// In cyclic mode the same transfer is submitted over and over again
assign up_sot = up_dma_cyclic ? 1'b0 : up_dma_req_valid & up_dma_req_ready;
assign up_eot = up_dma_cyclic ? 1'b0 : response_eot;

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

endmodule
