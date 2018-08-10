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

module axi_dmac_response_manager #(
  parameter DMA_DATA_WIDTH_SRC = 64,
  parameter DMA_DATA_WIDTH_DEST = 64,
  parameter DMA_LENGTH_WIDTH = 24,
  parameter BYTES_PER_BURST_WIDTH = 7,
  parameter BYTES_PER_BEAT_WIDTH_SRC = $clog2(DMA_DATA_WIDTH_SRC/8),
  parameter ASYNC_CLK_DEST_REQ = 1
)(
  // Interface to destination side
  input dest_clk,
  input dest_resetn,

  input dest_response_valid,
  output dest_response_ready,
  input [1:0] dest_response_resp,
  input dest_response_partial,
  input dest_response_resp_eot,
  input [BYTES_PER_BURST_WIDTH-1:0] dest_response_data_burst_length,

  // Interface to processor
  input req_clk,
  input req_resetn,

  output response_eot,
  output reg [BYTES_PER_BURST_WIDTH-1:0] measured_burst_length = 'h0,
  output response_partial,
  output reg response_valid = 1'b0,
  input response_ready

  // Interface to requester side
);

localparam STATE_IDLE         = 2'h0;
localparam STATE_ACC          = 2'h1;
localparam STATE_WRITE_RESPR  = 2'h2;

reg [1:0] state = STATE_IDLE;
reg [1:0] nx_state;

localparam DEST_SRC_RATIO = DMA_DATA_WIDTH_DEST/DMA_DATA_WIDTH_SRC;

localparam DEST_SRC_RATIO_WIDTH = DEST_SRC_RATIO > 64 ? 7 :
  DEST_SRC_RATIO > 32 ? 6 :
  DEST_SRC_RATIO > 16 ? 5 :
  DEST_SRC_RATIO > 8 ? 4 :
  DEST_SRC_RATIO > 4 ? 3 :
  DEST_SRC_RATIO > 2 ? 2 :
  DEST_SRC_RATIO > 1 ? 1 : 0;

localparam BYTES_PER_BEAT_WIDTH = DEST_SRC_RATIO_WIDTH + BYTES_PER_BEAT_WIDTH_SRC;
localparam BURST_LEN_WIDTH = BYTES_PER_BURST_WIDTH - BYTES_PER_BEAT_WIDTH;

wire do_acc_st;
reg req_eot = 1'b0;
reg req_response_partial = 1'b0;
reg [BYTES_PER_BURST_WIDTH-1:0] req_response_dest_data_burst_length = 'h0;

wire response_dest_valid;
reg response_dest_ready = 1'b1;
wire [1:0] response_dest_resp;
wire response_dest_resp_eot;
wire [BYTES_PER_BURST_WIDTH-1:0] response_dest_data_burst_length;

wire [BURST_LEN_WIDTH-1:0] burst_lenght;
reg [BURST_LEN_WIDTH-1:0] burst_pointer_end;

util_axis_fifo #(
  .DATA_WIDTH(BYTES_PER_BURST_WIDTH+1+1),
  .ADDRESS_WIDTH(0),
  .ASYNC_CLK(ASYNC_CLK_DEST_REQ)
) i_dest_response_fifo (
  .s_axis_aclk(dest_clk),
  .s_axis_aresetn(dest_resetn),
  .s_axis_valid(dest_response_valid),
  .s_axis_ready(dest_response_ready),
  .s_axis_empty(),
  .s_axis_data({dest_response_data_burst_length,
                dest_response_partial,
                dest_response_resp_eot}),
  .s_axis_room(),

  .m_axis_aclk(req_clk),
  .m_axis_aresetn(req_resetn),
  .m_axis_valid(response_dest_valid),
  .m_axis_ready(response_dest_ready),
  .m_axis_data({response_dest_data_burst_length,
                response_dest_partial,
                response_dest_resp_eot}),
  .m_axis_level()
);

always @(posedge req_clk)
begin
  if (response_dest_valid & response_dest_ready) begin
    req_eot <= response_dest_resp_eot;
    req_response_partial <= response_dest_partial;
    req_response_dest_data_burst_length <= response_dest_data_burst_length;
  end
end

always @(posedge req_clk)
begin
  if (req_resetn == 1'b0) begin
    response_dest_ready <= 1'b1;
  end else begin
    response_dest_ready <= (nx_state == STATE_IDLE);
  end
end

assign response_eot = (state == STATE_WRITE_RESPR) ? req_eot : 1'b1;
assign response_partial = (state == STATE_WRITE_RESPR) ? req_response_partial : 1'b0;

always @(posedge req_clk)
begin
  if (req_resetn == 1'b0) begin
    response_valid <= 1'b0;
  end else begin
    if (nx_state == STATE_WRITE_RESPR) begin
      response_valid <= 1'b1;
    end else if (response_ready == 1'b1) begin
      response_valid <= 1'b0;
    end
  end
end

// transform the free running pointer from burst memory into burst length
assign burst_lenght = req_response_dest_data_burst_length[BYTES_PER_BURST_WIDTH-1 -: BURST_LEN_WIDTH] -
                      burst_pointer_end - 1'b1;

always @(posedge req_clk)
begin
  if (req_resetn == 1'b0) begin
    burst_pointer_end <= {BURST_LEN_WIDTH{1'b1}};
  end else if (state == STATE_ACC) begin
    burst_pointer_end <= req_response_dest_data_burst_length[BYTES_PER_BURST_WIDTH-1 -: BURST_LEN_WIDTH];
  end
end

always @(posedge req_clk)
begin
  if (state == STATE_ZERO_COMPL) begin
    measured_burst_length <= {BYTES_PER_BURST_WIDTH{1'b1}};
  end else if (state == STATE_ACC) begin
    measured_burst_length[BYTES_PER_BURST_WIDTH-1 -: BURST_LEN_WIDTH] <= burst_lenght;
    measured_burst_length[BYTES_PER_BEAT_WIDTH-1 : 0] <=
      req_response_dest_data_burst_length[BYTES_PER_BEAT_WIDTH-1: 0];
  end
end

always @(*) begin
  nx_state = state;
  case (state)
    STATE_IDLE: begin
      if (response_dest_valid == 1'b1) begin
        nx_state = STATE_ACC;
      end
    end
    STATE_ACC: begin
      nx_state = STATE_WRITE_RESPR;
    end
    STATE_WRITE_RESPR: begin
      if (response_ready == 1'b1) begin
        nx_state = STATE_IDLE;
      end
    end
    default: begin
      nx_state = STATE_IDLE;
    end
  endcase
end

always @(posedge req_clk) begin
  if (req_resetn == 1'b0) begin
    state <= STATE_IDLE;
  end else begin
    state <= nx_state;
  end
end

endmodule
