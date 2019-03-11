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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

module axi_dmac_framelock #(
  parameter DMA_AXI_ADDR_WIDTH = 32,
  parameter DMA_LENGTH_WIDTH = 24,
  parameter BYTES_PER_BURST_WIDTH = 7,
  parameter BYTES_PER_BEAT_WIDTH_SRC = 3,
  parameter BYTES_PER_BEAT_WIDTH_DEST = 3,
  parameter ENABLE_FRAME_LOCK = 0,
  parameter FRAME_LOCK_MODE = 0, // 0 - Master (MM writer) ; 1 - Slave (MM reader)
  parameter MAX_NUM_FRAMES = 4,
  parameter MAX_NUM_FRAMES_MSB = 2

) (
  input req_aclk,
  input req_aresetn,

  // Interface to UP
  input req_valid,
  output reg req_ready,
  input [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] req_dest_address,
  input [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC] req_src_address,
  input [DMA_LENGTH_WIDTH-1:0] req_x_length,
  input [DMA_LENGTH_WIDTH-1:0] req_y_length,
  input [DMA_LENGTH_WIDTH-1:0] req_dest_stride,
  input [DMA_LENGTH_WIDTH-1:0] req_src_stride,
  input [MAX_NUM_FRAMES_MSB:0] req_flock_framenum,
  input                        req_flock_mode,  // 0 - Dynamic. 1 - Simple
  input                        req_flock_wait_master,
  input [MAX_NUM_FRAMES_MSB:0] req_flock_distance,
  input [DMA_AXI_ADDR_WIDTH-1:0] req_flock_stride,
  input req_flock_en,
  input req_sync_transfer_start,
  input req_last,
  input req_cyclic,

  output req_eot,
  output [BYTES_PER_BURST_WIDTH-1:0] req_measured_burst_length,
  output req_response_partial,
  output req_response_valid,
  input req_response_ready,

  // Interface to 2D
  output reg out_req_valid,
  input out_req_ready,
  output [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_DEST] out_req_dest_address,
  output [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH_SRC] out_req_src_address,
  output [DMA_LENGTH_WIDTH-1:0] out_req_x_length,
  output [DMA_LENGTH_WIDTH-1:0] out_req_y_length,
  output [DMA_LENGTH_WIDTH-1:0] out_req_dest_stride,
  output [DMA_LENGTH_WIDTH-1:0] out_req_src_stride,
  output out_req_sync_transfer_start,
  output out_req_last,

  input out_eot,
  input [BYTES_PER_BURST_WIDTH-1:0] out_measured_burst_length,
  input out_response_partial,
  input out_response_valid,
  output out_response_ready,

  // Frame lock interface
  // Master mode
  input  [MAX_NUM_FRAMES_MSB:0] m_frame_in,
  output [MAX_NUM_FRAMES_MSB:0] m_frame_out,
  // Slave mode
  input  [MAX_NUM_FRAMES_MSB:0] s_frame_in,
  output [MAX_NUM_FRAMES_MSB:0] s_frame_out

);

// Pass through the whole response interface
//
assign req_eot = out_eot;
assign req_measured_burst_length = out_measured_burst_length;
assign req_response_partial = out_response_partial;
assign req_response_valid = out_response_valid;
assign out_response_ready = req_response_ready;

// Pass through part of the request interface
//
assign out_req_x_length = req_x_length;
assign out_req_y_length = req_y_length;
assign out_req_dest_stride = req_dest_stride;
assign out_req_src_stride = req_src_stride;
assign out_req_sync_transfer_start = req_sync_transfer_start;
assign out_req_last = req_last;


generate if (ENABLE_FRAME_LOCK == 1) begin

  localparam BYTES_PER_BEAT_WIDTH = FRAME_LOCK_MODE ?
                                      BYTES_PER_BEAT_WIDTH_SRC :
                                      BYTES_PER_BEAT_WIDTH_DEST;

  reg [MAX_NUM_FRAMES_MSB-1:0] transfer_id = 'h0;
  reg [MAX_NUM_FRAMES_MSB-1:0] cur_frame_id;
  wire resp_eot;

  reg [DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH] req_address = 'h0;

  wire [MAX_NUM_FRAMES_MSB:0] transfer_id_p1;

  reg wait_distance = 1'b0;
  wire calc_enable;
  wire calc_done;
  wire enable_out_req;

  reg prev_buf_done;

  // Calculate new buffer only after the current one completed
  always @(posedge req_aclk) begin
    if (req_aresetn == 1'b0) begin
      prev_buf_done <= 1'b1;
    end else if (out_req_valid & out_req_ready) begin
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
  assign transfer_id_p1 = transfer_id + 1'b1;

  always @(posedge req_aclk) begin
    if (req_aresetn == 1'b0) begin
      transfer_id <= 'h0;
      req_address <= 'h0;
    end else if (req_valid & req_ready) begin
      transfer_id <= 'h0;
      req_address <= FRAME_LOCK_MODE ? req_src_address : req_dest_address;
    end else if (calc_enable) begin
      if (transfer_id_p1 == req_flock_framenum) begin
        transfer_id <= 'h0;
        req_address <= FRAME_LOCK_MODE ? req_src_address : req_dest_address;
      end else begin
        transfer_id <= transfer_id_p1[MAX_NUM_FRAMES_MSB-1:0];
        req_address <= req_address + req_flock_stride[DMA_AXI_ADDR_WIDTH-1:BYTES_PER_BEAT_WIDTH];
      end
    end
  end

  // Latch the transfer IDs so it can be passed to the slave
  // once it is completed
  always @(posedge req_aclk) begin
    if (out_req_valid & out_req_ready) begin
      cur_frame_id <= transfer_id;
    end
  end


  assign resp_eot = out_response_valid & out_response_ready & out_eot;


  always @(posedge req_aclk) begin
    if (req_aresetn == 1'b0) begin
      req_ready <= 1'b1;
    end else if (req_ready == 1'b1) begin
      req_ready <= ~req_valid;
    end else if (out_req_valid & out_req_ready) begin
      req_ready <= ~req_cyclic;
    end
  end

  always @(*) begin
    out_req_valid = calc_enable & (calc_done || ~req_flock_en);
  end

  assign out_req_src_address = ~FRAME_LOCK_MODE ? 'h0 : req_address;
  assign out_req_dest_address = FRAME_LOCK_MODE ? 'h0 : req_address;

  reg frame_id_vld = 1'b0;
  always @(posedge req_aclk) begin
    frame_id_vld <= calc_enable & calc_done;
  end

  if (FRAME_LOCK_MODE == 0) begin
    // Master mode logic
    reg slave_started;

    wire [MAX_NUM_FRAMES_MSB-1:0] s_frame_id;
    wire s_frame_id_vld;

    // The master will iterate over the buffers one by one in a cyclic way
    // In dynamic mode will look at slave current buffer keeping that untouched.
    // In simple mode will not look at the slave.

    assign m_frame_out = {resp_eot, cur_frame_id};
    assign s_frame_id = m_frame_in[MAX_NUM_FRAMES_MSB-1:0];
    assign s_frame_id_vld = m_frame_in[MAX_NUM_FRAMES_MSB];

    assign calc_done = s_frame_id != transfer_id ||
                       slave_started == 1'b0 ||
                       req_flock_mode == 1'b1;

    always @(posedge req_aclk) begin
      if (req_aresetn == 1'b0) begin
        slave_started <= 1'b0;
      end else if (req_valid & req_ready) begin
        slave_started <= 1'b0;
      end else if (~req_ready) begin
        if (s_frame_id_vld) begin
          slave_started <= 1'b1;
        end
      end
    end

    assign enable_out_req = 1'b1;

  end else begin
    // Slave mode logic

    wire [MAX_NUM_FRAMES_MSB-1:0] target_id;
    wire [MAX_NUM_FRAMES_MSB-1:0] m_frame_id;
    wire m_frame_id_vld;

    // The slave will stay behind and try to keep up with the master at a distance.
    // This will be done either by repeating or skipping buffers depending on the
    // frame rate relationship of source and sink.
    //

    assign s_frame_out = {frame_id_vld, cur_frame_id};
    assign m_frame_id = s_frame_in[MAX_NUM_FRAMES_MSB-1:0];
    assign m_frame_id_vld = s_frame_in[MAX_NUM_FRAMES_MSB];


    assign calc_done = target_id == transfer_id;

    // If 'wait for master' is enabled the slave will start to operate only
    // after the master starts to write the frame at the programmed distance.
    //
    always @(posedge req_aclk) begin
      if (req_aresetn == 1'b0) begin
        wait_distance <= 1'b1;
      end else if (req_valid & req_ready) begin
        wait_distance <= req_cyclic && req_flock_en;
      end else if (~req_ready) begin
        if ((m_frame_id == req_flock_distance) && m_frame_id_vld) begin
          wait_distance <= 1'b0;
        end
      end
    end

`ifdef XILINX_SRL16
    // Keep a log of frame ids the master wrote
    // This may be an better approach for Xilinx where SRL16E blocks are
    // inferred
    //
    wire [MAX_NUM_FRAMES_MSB:0] req_flock_framenum_m1;
    assign  req_flock_framenum_m1 = req_flock_framenum - 1;
    genvar k;
    for (k=0;k<MAX_NUM_FRAMES_MSB;k=k+1) begin : frame_id_log
      reg [MAX_NUM_FRAMES-1 : 0] s_frame_id_log;
      always @(posedge req_aclk) begin
        if (m_frame_id_vld) begin
          s_frame_id_log <= {s_frame_id_log[MAX_NUM_FRAMES-2 : 0], m_frame_id[k]};
        end
      end
      assign target_id[k] = wait_distance ? req_flock_framenum_m1[k] : s_frame_id_log[req_flock_distance];
    end

`else

    reg [MAX_NUM_FRAMES_MSB-1:0] s_frame_id_log = 'h0;
    always @(posedge req_aclk) begin
      if (m_frame_id_vld) begin
        s_frame_id_log <= m_frame_id;
      end
    end

    wire [MAX_NUM_FRAMES_MSB:0] id_at_distance;

    assign id_at_distance = s_frame_id_log - req_flock_distance;
    assign target_id = id_at_distance[MAX_NUM_FRAMES_MSB] ? id_at_distance + req_flock_framenum
                                                          : id_at_distance;
`endif

    reg m_frame_ready = 1'b0;
    always @(posedge req_aclk) begin
      if (req_aresetn == 1'b0) begin
        m_frame_ready <= 1'b0;
      end else if (m_frame_id_vld) begin
        m_frame_ready <= 1'b1;
      end else if (out_req_valid) begin
        m_frame_ready <= 1'b0;
      end
    end

    // If 'wait for master' is disabled, enable the generation of new request
    // right away.
    // In Simple Flock when 'wait for master' is enabled, the slave must wait
    // until the master completes a buffer. In Dynamic Flock just wait until
    // the required number of buffers are filled, then enable the request
    // generation regardless of the master.
    assign enable_out_req = req_flock_wait_master == 1'b0 ||
                            ((m_frame_ready | ~req_flock_mode) & ~wait_distance);

  end


end else begin
  always @(*) begin
    out_req_valid = req_valid;
    req_ready = out_req_ready;
  end

  assign out_req_dest_address = req_dest_address;
  assign out_req_src_address = req_src_address;

  assign m_frame_out = 'h0;
  assign s_frame_out = 'h0;

end
endgenerate

endmodule
