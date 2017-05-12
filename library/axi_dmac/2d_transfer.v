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

module dmac_2d_transfer #(

  parameter DMA_LENGTH_WIDTH = 24,
  parameter BYTES_PER_BEAT_WIDTH_SRC = 3,
  parameter BYTES_PER_BEAT_WIDTH_DEST = 3)(

  input req_aclk,
  input req_aresetn,

  input req_valid,
  output reg req_ready,

  input [31:BYTES_PER_BEAT_WIDTH_DEST] req_dest_address,
  input [31:BYTES_PER_BEAT_WIDTH_SRC] req_src_address,
  input [DMA_LENGTH_WIDTH-1:0] req_x_length,
  input [DMA_LENGTH_WIDTH-1:0] req_y_length,
  input [DMA_LENGTH_WIDTH-1:0] req_dest_stride,
  input [DMA_LENGTH_WIDTH-1:0] req_src_stride,
  input req_sync_transfer_start,
  output reg req_eot,

  output reg out_req_valid,
  input out_req_ready,
  output [31:BYTES_PER_BEAT_WIDTH_DEST] out_req_dest_address,
  output [31:BYTES_PER_BEAT_WIDTH_SRC] out_req_src_address,
  output [DMA_LENGTH_WIDTH-1:0] out_req_length,
  output reg out_req_sync_transfer_start,
  input out_eot
);

reg [31:BYTES_PER_BEAT_WIDTH_DEST] dest_address = 'h00;
reg [31:BYTES_PER_BEAT_WIDTH_SRC] src_address = 'h00;
reg [DMA_LENGTH_WIDTH-1:0] x_length = 'h00;
reg [DMA_LENGTH_WIDTH-1:0] y_length = 'h00;
reg [DMA_LENGTH_WIDTH-1:0] dest_stride = 'h0;
reg [DMA_LENGTH_WIDTH-1:0] src_stride = 'h00;

reg [1:0] req_id = 'h00;
reg [1:0] eot_id = 'h00;
reg [3:0] last_req = 'h00;

wire out_last;

assign out_req_dest_address = dest_address;
assign out_req_src_address = src_address;
assign out_req_length = x_length;
assign out_last = y_length == 'h00;

always @(posedge req_aclk) begin
  if (req_aresetn == 1'b0) begin
    req_id <= 2'b0;
    eot_id <= 2'b0;
    req_eot <= 1'b0;
  end else begin
    if (out_req_valid == 1'b1 && out_req_ready == 1'b1) begin
      req_id <= req_id + 1'b1;
    end

    if (out_eot == 1'b1) begin
      eot_id <= eot_id + 1'b1;
      req_eot <= last_req[eot_id];
    end else begin
      req_eot <= 1'b0;
    end
  end
end

always @(posedge req_aclk) begin
  if (out_req_valid == 1'b1 && out_req_ready == 1'b1) begin
    last_req[req_id] <= out_last;
  end
end

always @(posedge req_aclk) begin
  if (req_ready == 1'b1 && req_valid == 1'b1) begin
    dest_address <= req_dest_address;
    src_address <= req_src_address;
    x_length <= req_x_length;
    y_length <= req_y_length;
    dest_stride <= req_dest_stride;
    src_stride <= req_src_stride;
    out_req_sync_transfer_start <= req_sync_transfer_start;
  end else if (out_req_valid == 1'b1 && out_req_ready == 1'b1) begin
    dest_address <= dest_address + dest_stride[DMA_LENGTH_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST];
    src_address <= src_address + src_stride[DMA_LENGTH_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC];
    y_length <= y_length - 1'b1;
    out_req_sync_transfer_start <= 1'b0;
  end
end

always @(posedge req_aclk) begin
  if (req_aresetn == 1'b0) begin
    req_ready <= 1'b1;
    out_req_valid <= 1'b0;
  end else begin
    if (req_ready == 1'b1 && req_valid == 1'b1) begin
      req_ready <= 1'b0;
      out_req_valid <= 1'b1;
    end else if (out_req_valid == 1'b1 && out_req_ready == 1'b1 &&
                 out_last == 1'b1) begin
      out_req_valid <= 1'b0;
      req_ready <= 1'b1;
    end
  end
end

endmodule
