// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsabilities that he or she has by using this source/core.
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

module axi_dmac_framelock #(
  parameter DMA_AXI_ADDR_WIDTH = 32,
  parameter BYTES_PER_BEAT_WIDTH_DEST = 3,
  parameter BYTES_PER_BEAT_WIDTH_SRC = 3,
  parameter FRAMELOCK_MODE =  0, // 0 - MM writer ; 1 - MM reader
  parameter MAX_NUM_FRAMES_WIDTH = 3
) (
  input req_aclk,
  input req_aresetn,

  // Interface to UP
  input req_valid,
  output reg req_ready,
  input [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] req_dest_address,
  input [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC] req_src_address,

  input [MAX_NUM_FRAMES_WIDTH-1:0] req_flock_framenum,
  input                            req_flock_mode,  // 0 - Dynamic. 1 - Simple
  input                            req_flock_wait_writer,
  input [MAX_NUM_FRAMES_WIDTH-1:0] req_flock_distance,
  input [DMA_AXI_ADDR_WIDTH-1:0] req_flock_stride,
  input req_flock_en,
  input req_cyclic,

  // Interface to 2D
  output out_req_valid,
  input  out_req_ready,
  output [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] out_req_dest_address,
  output [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC] out_req_src_address,

  input out_eot,
  input out_response_valid,
  input out_response_ready,

  // Frame lock interface
  // Writer mode
  input  [MAX_NUM_FRAMES_WIDTH-1:0] m_frame_in,
  input                             m_frame_in_valid,
  output [MAX_NUM_FRAMES_WIDTH-1:0] m_frame_out,
  output                            m_frame_out_valid,
  // Reader mode
  input  [MAX_NUM_FRAMES_WIDTH-1:0] s_frame_in,
  input                             s_frame_in_valid,
  output [MAX_NUM_FRAMES_WIDTH-1:0] s_frame_out,
  output                            s_frame_out_valid
);

  localparam BYTES_PER_BEAT_WIDTH = FRAMELOCK_MODE ?
                                    BYTES_PER_BEAT_WIDTH_SRC :
                                    BYTES_PER_BEAT_WIDTH_DEST;
  localparam MAX_NUM_FRAMES = 2**MAX_NUM_FRAMES_WIDTH;

  reg [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH] req_address = 'h0;
  reg [MAX_NUM_FRAMES_WIDTH-1:0] transfer_id = 'h0;
  reg [MAX_NUM_FRAMES_WIDTH-1:0] cur_frame_id = 'h0;
  reg prev_buf_done;

  wire [MAX_NUM_FRAMES_WIDTH:0] transfer_id_p1;
  wire [MAX_NUM_FRAMES_WIDTH:0] req_flock_framenum_p1;

  wire resp_eot;
  wire calc_enable;
  wire calc_done;
  wire enable_out_req;

  // Calculate new buffer only after the current one completed
  always @(posedge req_aclk) begin
    if (req_aresetn == 1'b0) begin
      prev_buf_done <= 1'b1;
    end else if (out_req_valid && out_req_ready) begin
      prev_buf_done <= 1'b0;
    end else if (resp_eot) begin
      prev_buf_done <= 1'b1;
    end
  end

  // if Flock disabled
  //  Go to the next buffer whenever new descriptor can be pushed to downstream
  //  logic for optimal streaming.
  // if Flock enabled
  //  Go to the next buffer when all data from current buffer is transferred,
  //  this is signalized by the end of transfer signal (resp_eot)
  assign calc_enable = ~req_ready & out_req_ready & enable_out_req &
                      (prev_buf_done | ~req_flock_en);
  assign req_flock_framenum_p1 = req_flock_framenum + 1'b1;
  assign transfer_id_p1 = transfer_id + 1'b1;

  always @(posedge req_aclk) begin
    if (req_aresetn == 1'b0) begin
      transfer_id <= 'h0;
      req_address <= 'h0;
    end else if (req_valid && req_ready) begin
      transfer_id <= 'h0;
      req_address <= FRAMELOCK_MODE ? req_src_address : req_dest_address;
    end else if (calc_enable) begin
      if (transfer_id == req_flock_framenum) begin
        transfer_id <= 'h0;
        req_address <= FRAMELOCK_MODE ? req_src_address : req_dest_address;
      end else begin
        transfer_id <= transfer_id_p1[MAX_NUM_FRAMES_WIDTH-1:0];
        req_address <= req_address + req_flock_stride[DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH];
      end
    end
  end

  // Latch the transfer IDs so it can be passed to the reader
  // once it is completed
  always @(posedge req_aclk) begin
    if (out_req_valid && out_req_ready) begin
      cur_frame_id <= transfer_id;
    end
  end

  always @(posedge req_aclk) begin
    if (req_aresetn == 1'b0) begin
      req_ready <= 1'b1;
    end else if (req_ready == 1'b1) begin
      req_ready <= ~req_valid;
    end else if (out_req_valid && out_req_ready) begin
      req_ready <= ~req_cyclic;
    end
  end

  generate if (FRAMELOCK_MODE == 0) begin

    // Writer mode logic

    reg reader_started;

    wire [MAX_NUM_FRAMES_WIDTH-1:0] s_frame_id;
    wire s_frame_id_vld;

    // The writer will iterate over the buffers one by one in a cyclic way
    // In dynamic mode will look at reader current buffer keeping that untouched.
    // In simple mode will not look at the reader.

    always @(posedge req_aclk) begin
      if (req_aresetn == 1'b0) begin
        reader_started <= 1'b0;
      end else if (req_valid && req_ready) begin
        reader_started <= 1'b0;
      end else if (~req_ready) begin
        if (s_frame_id_vld) begin
          reader_started <= 1'b1;
        end
      end
    end

    assign enable_out_req = 1'b1;

    assign m_frame_out = cur_frame_id;
    assign m_frame_out_valid = resp_eot;
    assign s_frame_id = m_frame_in;
    assign s_frame_id_vld = m_frame_in_valid;

    assign calc_done = (s_frame_id != transfer_id) | ~reader_started | req_flock_mode;
  end else begin

    // Reader mode logic

    reg frame_id_vld = 1'b0;
    reg wait_distance = 1'b0;
    reg m_frame_ready = 1'b0;

    wire [MAX_NUM_FRAMES_WIDTH-1:0] target_id;
    wire [MAX_NUM_FRAMES_WIDTH-1:0] m_frame_id;
    wire m_frame_id_vld;

    // The reader will stay behind and try to keep up with the writer at a distance.
    // This will be done either by repeating or skipping buffers depending on the
    // frame rate relationship of source and sink.

    assign s_frame_out = cur_frame_id;
    assign s_frame_out_valid = frame_id_vld;
    assign m_frame_id = s_frame_in;
    assign m_frame_id_vld = s_frame_in_valid;

    assign calc_done = target_id == transfer_id;

    always @(posedge req_aclk) begin
      frame_id_vld <= calc_enable & calc_done;
    end
    // If 'wait for writer' is enabled the reader will start to operate only
    // after the writer starts to write the frame at the programmed distance.
    always @(posedge req_aclk) begin
      if (req_aresetn == 1'b0) begin
        wait_distance <= 1'b1;
      end else if (req_valid && req_ready) begin
        wait_distance <= req_cyclic & req_flock_en;
      end else if (~req_ready) begin
        if (({1'b0, m_frame_id} == req_flock_distance) && m_frame_id_vld) begin
          wait_distance <= 1'b0;
        end
      end
    end

`ifdef XILINX_SRL16
    // Keep a log of frame ids the writer wrote
    // This may be an better approach for Xilinx where SRL16E blocks are
    // inferred
    genvar k;
    for (k = 0; k < MAX_NUM_FRAMES_WIDTH; k = k + 1) begin : frame_id_log
      reg [MAX_NUM_FRAMES-1:0] s_frame_id_log;
      always @(posedge req_aclk) begin
        if (m_frame_id_vld) begin
          s_frame_id_log <= {s_frame_id_log[MAX_NUM_FRAMES-2 : 0], m_frame_id[k]};
        end
      end
      assign target_id[k] = wait_distance ? req_flock_framenum[k] : s_frame_id_log[req_flock_distance];
    end
`else

    reg [MAX_NUM_FRAMES_WIDTH-1:0] s_frame_id_log = 'h0;
    reg s_frame_id_log_vld = 1'b0;

    wire [MAX_NUM_FRAMES_WIDTH:0] id_at_distance;
    wire [MAX_NUM_FRAMES_WIDTH:0] s_frame_id_log_qualified;
    wire [MAX_NUM_FRAMES_WIDTH:0] sum_distance_framenum;

    always @(posedge req_aclk) begin
      if (req_aresetn == 1'b0) begin
        s_frame_id_log_vld <= 1'b0;
      end else if (m_frame_id_vld) begin
        s_frame_id_log <= m_frame_id;
        s_frame_id_log_vld <= 1'b1;
      end
    end

    assign s_frame_id_log_qualified = s_frame_id_log_vld ? {1'b0, s_frame_id_log} : req_flock_framenum;

    assign id_at_distance = s_frame_id_log_qualified - req_flock_distance;
    assign sum_distance_framenum = id_at_distance + req_flock_framenum_p1;
    assign target_id = id_at_distance[MAX_NUM_FRAMES_WIDTH] ? sum_distance_framenum[MAX_NUM_FRAMES_WIDTH-1:0]
                                                            : id_at_distance[MAX_NUM_FRAMES_WIDTH-1:0];
`endif

    always @(posedge req_aclk) begin
      if (req_aresetn == 1'b0) begin
        m_frame_ready <= 1'b0;
      end else if (m_frame_id_vld) begin
        m_frame_ready <= 1'b1;
      end else if (out_req_valid) begin
        m_frame_ready <= 1'b0;
      end
    end

    // If 'wait for writer' is disabled, enable the generation of new request
    // right away.
    // In Simple Flock when 'wait for writer' is enabled, the reader must wait
    // until the writer completes a buffer. In Dynamic Flock just wait until
    // the required number of buffers are filled, then enable the request
    // generation regardless of the writer.
    assign enable_out_req = ~req_flock_wait_writer | ((m_frame_ready | ~req_flock_mode) & ~wait_distance);

  end
  endgenerate

  assign resp_eot = out_response_valid & out_response_ready & out_eot;
  assign out_req_src_address = ~FRAMELOCK_MODE ? 'h0 : req_address;
  assign out_req_dest_address = FRAMELOCK_MODE ? 'h0 : req_address;
  assign out_req_valid = calc_enable & (calc_done | ~req_flock_en);

endmodule
