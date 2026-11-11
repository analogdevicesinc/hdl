// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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
/*
 * SEG_COUNT 64b words, 6 for 1x100GE and 1 for one 25GE port.
 */

`timescale 1ns/100ps

module mrmac_axis_loopback #(
  parameter SEG_COUNT = 6,
  parameter FIFO_WORDS = (SEG_COUNT == 1) ? 2048 : 1024
) (
  input  wire          clk,

  input  wire          resetn,
  input  wire          loopback_en,
  input  wire          mac_swap,

  input  wire [SEG_COUNT*64-1:0]  mrmac_rx_axis_tdata,
  input  wire [SEG_COUNT*11-1:0]  mrmac_rx_axis_tkeep_user,
  input  wire          mrmac_rx_axis_tvalid,
  input  wire          mrmac_rx_axis_tlast,

  output wire [SEG_COUNT*64-1:0]  shim_rx_axis_tdata,
  output wire [SEG_COUNT*11-1:0]  shim_rx_axis_tkeep_user,
  output wire          shim_rx_axis_tvalid,
  output wire          shim_rx_axis_tlast,

  input  wire [SEG_COUNT*64-1:0]  shim_tx_axis_tdata,
  input  wire [SEG_COUNT*11-1:0]  shim_tx_axis_tkeep_user,
  input  wire          shim_tx_axis_tvalid,
  input  wire          shim_tx_axis_tlast,
  output wire          shim_tx_axis_tready,
  input  wire [15:0]   shim_tx_ptp_tag_field,

  output wire [SEG_COUNT*64-1:0]  mrmac_tx_axis_tdata,
  output wire [SEG_COUNT*11-1:0]  mrmac_tx_axis_tkeep_user,
  output wire          mrmac_tx_axis_tvalid,
  output wire          mrmac_tx_axis_tlast,
  input  wire          mrmac_tx_axis_tready,
  output wire [15:0]   mrmac_tx_ptp_tag_field,

  output reg  [31:0]   lb_frames = 32'd0,
  output reg  [31:0]   lb_drops = 32'd0
);

  localparam DW = SEG_COUNT*64;
  localparam KW = SEG_COUNT*11;
  localparam BW = SEG_COUNT*8;

  (* ASYNC_REG = "TRUE" *) reg [1:0] rst_sync = 2'b11;
  (* ASYNC_REG = "TRUE" *) reg [1:0] en_sync = 2'b00;
  (* ASYNC_REG = "TRUE" *) reg [1:0] swap_sync = 2'b00;

  always @(posedge clk) begin
    rst_sync  <= {rst_sync[0], !resetn};
    en_sync   <= {en_sync[0], loopback_en};
    swap_sync <= {swap_sync[0], mac_swap};
  end

  wire rst = rst_sync[1];

  wire en_s   = en_sync[1];
  wire swap_s = swap_sync[1];

  reg rx_in_pkt = 1'b0;
  reg rx_cap_reg = 1'b0;
  wire rx_cap = rx_in_pkt ? rx_cap_reg : en_s;

  always @(posedge clk) begin
    if (rst) begin
      rx_in_pkt <= 1'b0;
      rx_cap_reg <= 1'b0;
    end else if (mrmac_rx_axis_tvalid) begin
      rx_in_pkt <= !mrmac_rx_axis_tlast;
      rx_cap_reg <= rx_cap;
    end
  end

  assign shim_rx_axis_tdata      = mrmac_rx_axis_tdata;
  assign shim_rx_axis_tkeep_user = mrmac_rx_axis_tkeep_user;
  assign shim_rx_axis_tvalid     = mrmac_rx_axis_tvalid && !rx_cap;
  assign shim_rx_axis_tlast      = mrmac_rx_axis_tlast;

  // [8] of word 0 is the frame error
  wire [BW-1:0] rx_keep;

  genvar w;
  generate
    for (w = 0; w < SEG_COUNT; w = w + 1) begin : g_rx_keep
      assign rx_keep[w*8 +: 8] = mrmac_rx_axis_tlast ?
                                 mrmac_rx_axis_tkeep_user[w*11 +: 8] : 8'hff;
    end
  endgenerate

  reg  [DW-1:0] cap_tdata = {DW{1'b0}};
  reg  [BW-1:0] cap_tkeep = {BW{1'b0}};
  reg          cap_tvalid = 1'b0;
  reg          cap_tlast = 1'b0;
  reg          cap_tuser = 1'b0;

  always @(posedge clk) begin
    cap_tdata  <= mrmac_rx_axis_tdata;
    cap_tkeep  <= rx_keep;
    cap_tvalid <= mrmac_rx_axis_tvalid && rx_cap && !rst;
    cap_tlast  <= mrmac_rx_axis_tlast;
    cap_tuser  <= mrmac_rx_axis_tkeep_user[8];
  end

  // With one 64b word the 12 address bytes span the first two beats
  wire [DW-1:0] in_tdata;
  wire [BW-1:0] in_tkeep;
  wire          in_tvalid;
  wire          in_tlast;
  wire          in_tuser;

  generate
    if (SEG_COUNT == 1) begin : g_swap_in
      // frame beat position of the capture register: 0 first, 1 second, 2 later
      reg [1:0]    cap_pos = 2'd0;
      reg          cap_sw = 1'b0;

      reg [DW-1:0] s2_tdata = {DW{1'b0}};
      reg [BW-1:0] s2_tkeep = {BW{1'b0}};
      reg          s2_tvalid = 1'b0;
      reg          s2_tlast = 1'b0;
      reg          s2_tuser = 1'b0;
      reg [1:0]    s2_pos = 2'd0;
      reg          s2_sw = 1'b0;
      reg [DW-1:0] s2_prev = {DW{1'b0}};

      reg [DW-1:0] s3_tdata = {DW{1'b0}};
      reg [BW-1:0] s3_tkeep = {BW{1'b0}};
      reg          s3_tvalid = 1'b0;
      reg          s3_tlast = 1'b0;
      reg          s3_tuser = 1'b0;

      wire s2_pend = s2_tvalid && s2_pos == 2'd0 && !s2_tlast;

      always @(posedge clk) begin
        if (rst) begin
          cap_pos <= 2'd0;
        end else if (cap_tvalid) begin
          cap_pos <= cap_tlast ? 2'd0 : (cap_pos == 2'd0 ? 2'd1 : 2'd2);
        end
        if (cap_tvalid && cap_pos == 2'd0)
          cap_sw <= swap_s;

        if (s2_pend && !cap_tvalid) begin
          s3_tvalid <= 1'b0;
        end else begin
          s2_tdata  <= cap_tdata;
          s2_tkeep  <= cap_tkeep;
          s2_tvalid <= cap_tvalid;
          s2_tlast  <= cap_tlast;
          s2_tuser  <= cap_tuser;
          s2_pos    <= cap_pos;
          s2_sw     <= (cap_tvalid && cap_pos == 2'd0) ? swap_s : cap_sw;
          s2_prev   <= s2_tdata;

          s3_tdata  <= s2_tdata;
          s3_tkeep  <= s2_tkeep;
          s3_tvalid <= s2_tvalid;
          s3_tlast  <= s2_tlast;
          s3_tuser  <= s2_tuser;
          if (s2_pend && s2_sw)
            s3_tdata <= {s2_tdata[15:0], cap_tdata[31:0], s2_tdata[63:48]};
          else if (s2_tvalid && s2_sw && s2_pos == 2'd1)
            s3_tdata <= {s2_tdata[63:32], s2_prev[47:16]};
        end

        if (rst) begin
          s2_tvalid <= 1'b0;
          s3_tvalid <= 1'b0;
        end
      end

      assign in_tdata  = s3_tdata;
      assign in_tkeep  = s3_tkeep;
      assign in_tvalid = s3_tvalid;
      assign in_tlast  = s3_tlast;
      assign in_tuser  = s3_tuser;
    end else begin : g_no_swap_in
      assign in_tdata  = cap_tdata;
      assign in_tkeep  = cap_tkeep;
      assign in_tvalid = cap_tvalid;
      assign in_tlast  = cap_tlast;
      assign in_tuser  = cap_tuser;
    end
  endgenerate

  wire [DW-1:0] fifo_tdata;
  wire [BW-1:0] fifo_tkeep;
  wire         fifo_tvalid;
  wire         fifo_tready;
  wire         fifo_tlast;
  wire         fifo_overflow;
  wire         fifo_bad_frame;
  wire         fifo_good_frame;

  axis_fifo #(
    .DEPTH(FIFO_WORDS*BW),
    .DATA_WIDTH(DW),
    .KEEP_ENABLE(1),
    .KEEP_WIDTH(BW),
    .LAST_ENABLE(1),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(1),
    .RAM_PIPELINE(2),
    .OUTPUT_FIFO_ENABLE(0),
    .FRAME_FIFO(1),
    .USER_BAD_FRAME_VALUE(1'b1),
    .USER_BAD_FRAME_MASK(1'b1),
    .DROP_OVERSIZE_FRAME(1),
    .DROP_BAD_FRAME(1),
    .DROP_WHEN_FULL(1)
  ) i_fifo (
    .clk(clk),
    .rst(rst),
    .s_axis_tdata(in_tdata),
    .s_axis_tkeep(in_tkeep),
    .s_axis_tvalid(in_tvalid),
    .s_axis_tready(),
    .s_axis_tlast(in_tlast),
    .s_axis_tid(8'd0),
    .s_axis_tdest(8'd0),
    .s_axis_tuser(in_tuser),
    .m_axis_tdata(fifo_tdata),
    .m_axis_tkeep(fifo_tkeep),
    .m_axis_tvalid(fifo_tvalid),
    .m_axis_tready(fifo_tready),
    .m_axis_tlast(fifo_tlast),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(),
    .pause_req(1'b0),
    .pause_ack(),
    .status_depth(),
    .status_depth_commit(),
    .status_overflow(fifo_overflow),
    .status_bad_frame(fifo_bad_frame),
    .status_good_frame(fifo_good_frame)
  );

  always @(posedge clk) begin
    if (rst) begin
      lb_frames <= 32'd0;
      lb_drops <= 32'd0;
    end else begin
      lb_frames <= lb_frames + fifo_good_frame;
      lb_drops <= lb_drops + (fifo_overflow | fifo_bad_frame);
    end
  end

  reg lb_sel = 1'b0;
  reg shim_in_pkt = 1'b0;
  reg fifo_in_pkt = 1'b0;
  reg fifo_first = 1'b1;

  wire pending = lb_sel != en_s;
  wire shim_block = pending && !shim_in_pkt;
  wire fifo_block = pending && !fifo_in_pkt;

  wire shim_go = shim_tx_axis_tvalid && !shim_block;
  wire fifo_go = fifo_tvalid && !fifo_block;

  wire mux_tready;

  assign shim_tx_axis_tready = !shim_block && (lb_sel ? 1'b1 : mux_tready);
  assign fifo_tready         = !fifo_block && (lb_sel ? mux_tready : 1'b1);

  wire [DW-1:0] fifo_tdata_swap;

  generate
    if (SEG_COUNT > 1) begin : g_swap_out
      assign fifo_tdata_swap = (swap_s && fifo_first) ?
        {fifo_tdata[DW-1:96], fifo_tdata[47:0], fifo_tdata[95:48]} : fifo_tdata;
    end else begin : g_no_swap_out
      assign fifo_tdata_swap = fifo_tdata;
    end
  endgenerate

  wire [KW-1:0] fifo_tkeep_user;

  generate
    for (w = 0; w < SEG_COUNT; w = w + 1) begin : g_tx_kuser
      assign fifo_tkeep_user[w*11 +: 11] = {3'b000, fifo_tkeep[w*8 +: 8]};
    end
  endgenerate

  wire [DW-1:0] mux_tdata      = lb_sel ? fifo_tdata_swap : shim_tx_axis_tdata;
  wire [KW-1:0] mux_tkeep_user = lb_sel ? fifo_tkeep_user : shim_tx_axis_tkeep_user;
  wire [15:0]  mux_tag        = lb_sel ? 16'd0 : shim_tx_ptp_tag_field;
  wire         mux_tvalid     = lb_sel ? fifo_go : shim_go;
  wire         mux_tlast      = lb_sel ? fifo_tlast : shim_tx_axis_tlast;

  axis_register #(
    .DATA_WIDTH(DW),
    .KEEP_ENABLE(0),
    .LAST_ENABLE(1),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(16+KW),
    .REG_TYPE(2)
  ) i_tx_reg (
    .clk(clk),
    .rst(rst),
    .s_axis_tdata(mux_tdata),
    .s_axis_tkeep({BW{1'b1}}),
    .s_axis_tvalid(mux_tvalid),
    .s_axis_tready(mux_tready),
    .s_axis_tlast(mux_tlast),
    .s_axis_tid(8'd0),
    .s_axis_tdest(8'd0),
    .s_axis_tuser({mux_tag, mux_tkeep_user}),
    .m_axis_tdata(mrmac_tx_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tvalid(mrmac_tx_axis_tvalid),
    .m_axis_tready(mrmac_tx_axis_tready),
    .m_axis_tlast(mrmac_tx_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser({mrmac_tx_ptp_tag_field, mrmac_tx_axis_tkeep_user})
  );

  always @(posedge clk) begin
    if (rst) begin
      lb_sel <= 1'b0;
      shim_in_pkt <= 1'b0;
      fifo_in_pkt <= 1'b0;
      fifo_first <= 1'b1;
    end else begin
      if (shim_tx_axis_tvalid && shim_tx_axis_tready)
        shim_in_pkt <= !shim_tx_axis_tlast;
      if (fifo_tvalid && fifo_tready) begin
        fifo_in_pkt <= !fifo_tlast;
        fifo_first <= fifo_tlast;
      end
      if (pending && !shim_in_pkt && !fifo_in_pkt)
        lb_sel <= en_s;
    end
  end

endmodule
