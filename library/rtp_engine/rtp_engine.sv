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

module rtp_engine #(
  parameter         S_TDATA_WIDTH = 64,
  parameter         S_TDEST_WIDTH = 4,
  parameter         S_TUSER_WIDTH = 48,
  parameter         M_TDATA_WIDTH = 64,
  parameter         M_TDEST_WIDTH = 4,
  parameter         M_TUSER_WIDTH = 1,
  parameter         M_TKEEP_WIDTH = ((M_TDATA_WIDTH+7)/8),
  parameter         SSRC_ID = 0,
  parameter         INTERV_FRAME = 30,
  parameter         VERSION = 1
  ) (

  input  logic                          aclk,
  input  logic                          aresetn,

  /* input axi stream slave interface */

  input  logic                          s_axis_tvalid,
  input  logic [(S_TDATA_WIDTH-1):0]    s_axis_tdata,
  input  logic                          s_axis_tlast,
  input  logic [(S_TDEST_WIDTH-1):0]    s_axis_tdest,
  input  logic [(S_TUSER_WIDTH-1):0]    s_axis_tuser,
  output logic                          s_axis_tready,

  /* output axi stream master interface */

  output  logic                         m_axis_tvalid,
  output  logic [(M_TDATA_WIDTH-1):0]   m_axis_tdata,
  output  logic                         m_axis_tlast,
  input   logic                         m_axis_tready,
  output  logic [(M_TKEEP_WIDTH-1):0]   m_axis_tkeep,

  input   logic                         dropped_pkt,
  input   logic [95:0]                  ptp_ts_96,

  // axi interface

  input   logic                        s_axi_aclk,
  input   logic                        s_axi_aresetn,
  input   logic                        s_axi_awvalid,
  input   logic [15:0]                 s_axi_awaddr,
  input   logic [ 2:0]                 s_axi_awprot,
  output  logic                        s_axi_awready,
  input   logic                        s_axi_wvalid,
  input   logic [31:0]                 s_axi_wdata,
  input   logic [ 3:0]                 s_axi_wstrb,
  output  logic                        s_axi_wready,
  output  logic                        s_axi_bvalid,
  output  logic [ 1:0]                 s_axi_bresp,
  input   logic                        s_axi_bready,
  input   logic                        s_axi_arvalid,
  input   logic [15:0]                 s_axi_araddr,
  input   logic [ 2:0]                 s_axi_arprot,
  output  logic                        s_axi_arready,
  output  logic                        s_axi_rvalid,
  output  logic [ 1:0]                 s_axi_rresp,
  output  logic [31:0]                 s_axi_rdata,
  input   logic                        s_axi_rready

);

  /* internal axi4-lite signals */
  wire            up_clk;
  wire            up_rstn;
  wire            up_rreq_s;
  wire            up_wack_s;
  wire            up_rack_s;
  wire   [13:0]   up_raddr_s;
  wire   [31:0]   up_rdata_s;
  wire            up_wreq_s;
  wire   [13:0]   up_waddr_s;
  wire   [31:0]   up_wdata_s;

  wire            areset;

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;
  assign areset = ~aresetn;

  localparam RTP_CLK = 90000;
  localparam RTP_INCREASE = RTP_CLK/INTERV_FRAME;
  localparam NUM_CYCLES_TR = 480;

  /* 1 length field = num bytes per line */
  /* 1 line per packet -> 1 line number field */
  /* 1 field identification field*/
  /* 1 continuation field */
  /* 1 offset field - in payload header */

  import rtp_engine_package::*;

  rtp_pckt_header rtp_header; // instance of RTP header struct packed
  rtp_payload_header rtp_pd_header; // instance of RTP Payload header struct packed

  // AXIS S/M related regs
  reg                        s_axis_tready_r = 1'b0;
  reg  [(M_TDATA_WIDTH-1):0] m_axis_tdata_r = 'h0;
  reg  [(M_TKEEP_WIDTH-1):0] m_axis_tkeep_r = 'h0;
  reg                        m_axis_tready_r = 'h0;

  wire [(M_TDATA_WIDTH-1):0] m_axis_cam_tdata;
  wire [(M_TDATA_WIDTH-1):0] m_axis_tdata_fin;
  wire                       m_axis_cam_tvalid;
  wire                       m_axis_cam_tready;
  wire                       m_axis_cam_tlast;
  wire                       m_axis_cam_tdest;
  wire [(S_TUSER_WIDTH-1):0] m_axis_cam_tuser;
  wire                       m_axis_tlast_cams;

  reg                        m_axis_cam_tvalid_r = 1'b0;
  reg                        m_axis_tlast_cams_r = 1'b0;

  //line and frame-related wires
  wire                       dropped_pkt_out;
  wire                       negedge_eof;
  wire [11:0]                num_lines;
  wire [11:0]                num_px_p_line;
  wire                       posedge_dropped_pkt;

  // line and frame-related regs
  reg  [15:0]                counter_lines = 'h0;
  reg                        dropped_pkt_r = 1'b0;
  reg                        end_of_frame = 1'b0;
  reg                        end_of_frame_r = 1'b0;
  reg                        wait_eof_r = 1'b0;

  // rtp header configurable fields - regs
  reg  [31:0]                rtp_header_c_timestamp_r = 'h0;
  reg  [31:0]                rtp_header_ssrc_r = 'h0;
  reg  [31:0]                rtp_header_timestamp_r = 'h0;

  // rtp header configurable fields - wires
  wire [31:0]                rtp_header_csrc_field1;
  wire [(M_TKEEP_WIDTH-1):0] rtp_header_csrc_tkeep;

  // timestamp-related wires
  wire                       custom_timestamp;
  wire                       custom_timestamp_96b;
  wire                       timestamp_s_eof;

  // rtp_pd header ext_seq_num
  reg  [15:0]                ext_seq_num_r = 'h0;

  // rtp_pd_header configurable length field
  wire [15:0]                bend_length_l1;

  //states related regs - wires 
  wire                       can_start_to_m_axis; // start of transfer indicator
  wire                       end_of_header_p1_tr;
  wire                       end_of_header_p2_tr;
  wire                       end_of_pd_header_tr;
  wire                       end_of_payload_tr;
  wire                       int_tready_post_header;

  state_rtp_transm           rtp_transm_state;
  state_rtp_transm           rtp_transm_state_next;

  assign rtp_header.version = 'h2; //rtp version 2 for rfc3550 - used as is in rfc 4175 for uncrompressed video
  assign rtp_header.padding = 'h0; //no padding at the end of packets
  assign rtp_header.extension = 'h0; //no extensions to the header
  assign rtp_header.csrc_count = (custom_timestamp_96b) ? 'h1 : 'h0; //1 source from 8 cameras in the system
  // assign rtp_header.marker =  for last packet in frame in this case of
  // progressive scan video
  assign rtp_header.payload_type = 'd96; //uncrompressed video

  assign rtp_header.timestamp = (custom_timestamp) ? rtp_header_c_timestamp_r : rtp_header_timestamp_r;
  assign rtp_header.ssrc_field = (custom_timestamp) ? rtp_header_ssrc_r : SSRC_ID;
  assign rtp_header_csrc_field1 = (custom_timestamp_96b) ? rtp_header.csrc_field1 : 'h0;
  assign rtp_header_csrc_tkeep = (custom_timestamp_96b) ? 'hFF : 'h0F;
 
  // assign rtp_pd_header.length = / num B data in scan line - nbo
  assign bend_length_l1 = (num_px_p_line == 'd1920) ? 'd3840 : ((num_px_p_line == 'd2880) ? 'd5760 : 'd0); // number of bytes - 1920 x 2 - 2 bytes per pixel -  multiple of pgroup 4
  assign rtp_pd_header.length_l1 = bend_length_l1; // nbo of number of bytes in the packet from analyzed scan line
  assign rtp_pd_header.field_identif_l1 = 'h0; // 0 for progressive video - field identification
  assign rtp_pd_header.offset_l1 = 'h0; // offset 0 - only one line transmitted, no multiple lines divided in mutilple
  assign rtp_pd_header.continuation_l1 = 'h0; // continuation is 0, no other header extension for another line will follow the first one - one line/packet
  assign rtp_pd_header.line_num_l1 = counter_lines;//{counter_lines[7:0],counter_lines[15:8]};


  always @(posedge aclk) begin
    if (!aresetn) begin
      rtp_header_timestamp_r <= 'h0;
    end else begin
      if (negedge_eof) begin
        rtp_header_timestamp_r <= rtp_header_timestamp_r + RTP_INCREASE;
      end else if (rtp_header_timestamp_r == 'hFFFFFFFF) begin
        rtp_header_timestamp_r <= 'h0;
      end else begin
        rtp_header_timestamp_r <= rtp_header_timestamp_r;
      end
    end
  end

  always @(posedge aclk) begin
    if (!aresetn) begin
      rtp_header_c_timestamp_r <= 'h0;
      rtp_header_ssrc_r <= 'h0;
      rtp_header.csrc_field1 <= 'h0;
    end else begin
      if (timestamp_s_eof) begin
        if (m_axis_cam_tuser[0] && m_axis_cam_tvalid) begin
          rtp_header_c_timestamp_r <= ptp_ts_96[95:64];
          rtp_header_ssrc_r <= ptp_ts_96[63:32];
          rtp_header.csrc_field1 <= ptp_ts_96[31:0];
        end else begin
          rtp_header_c_timestamp_r <= rtp_header_c_timestamp_r;
          rtp_header_ssrc_r <= rtp_header_ssrc_r;
          rtp_header.csrc_field1 <= rtp_header.csrc_field1;
        end
      end else begin
        if (m_axis_cam_tlast && m_axis_cam_tvalid) begin
          rtp_header_c_timestamp_r <= ptp_ts_96[95:64];
          rtp_header_ssrc_r <= ptp_ts_96[63:32];
          rtp_header.csrc_field1 <= ptp_ts_96[31:0];
        end else begin
          rtp_header_c_timestamp_r <= rtp_header_c_timestamp_r;
          rtp_header_ssrc_r <= rtp_header_ssrc_r;
          rtp_header.csrc_field1 <= rtp_header.csrc_field1;
        end
      end
    end
  end

  assign rtp_header.marker = (counter_lines == (num_lines-1)) ? 1'b1 : 1'b0;

  always @(posedge aclk) begin
    if (!aresetn) begin
      rtp_header.sequence_nr <= 'h0;
    end else begin
      if (end_of_payload_tr) begin
        rtp_header.sequence_nr <= rtp_header.sequence_nr + 1;
      end else if (rtp_header.sequence_nr == 'hFFFF) begin
        rtp_header.sequence_nr <= 'h0;
      end else begin
        rtp_header.sequence_nr <= rtp_header.sequence_nr;
      end
    end
  end

  always @(posedge aclk) begin
    if (!aresetn) begin
      ext_seq_num_r <= 'h0;
    end else begin
      if (end_of_payload_tr) begin // end of payload corresponds to end of packet in 1 line based transmission
        ext_seq_num_r <= ext_seq_num_r + 1;
      end else if (ext_seq_num_r == 'hFFFF) begin // if the high part is max, reset to 0
        ext_seq_num_r <= 'h0;
      end else begin
        ext_seq_num_r <= ext_seq_num_r;
      end
    end
  end

  assign rtp_pd_header.ext_seq_num = {ext_seq_num_r[7:0],ext_seq_num_r[15:8]};

  always @(posedge aclk) begin
    if (!aresetn) begin
      rtp_transm_state <= IDLE_TRANSM;
    end else begin
      rtp_transm_state <= rtp_transm_state_next;
    end
  end
  
  always @(posedge aclk) begin
    if (!aresetn) begin
      m_axis_cam_tvalid_r <= 1'b0;
    end else begin 
      if (rtp_transm_state == HEADER_TRANSM_P1 || rtp_transm_state == HEADER_TRANSM_P2 || rtp_transm_state == PD_HEADER_TRANSM) begin
        m_axis_cam_tvalid_r <= 'h1;
      end else if (rtp_transm_state == PAYLOAD_TRANSM) begin      
        m_axis_cam_tvalid_r <= m_axis_cam_tvalid;
      end else begin
        m_axis_cam_tvalid_r <= 1'b0;  
      end
    end  
  end
 
  always @(posedge aclk) begin
    if (!aresetn) begin
      m_axis_tdata_r <= 'h0;
      m_axis_tkeep_r <= 'hFF;
    end else begin
      if (end_of_pd_header_tr || (rtp_transm_state == PAYLOAD_TRANSM)) begin
         m_axis_tdata_r <= m_axis_cam_tdata;
         m_axis_tkeep_r <= 'hFF;
      end else begin
         m_axis_tdata_r <= m_axis_tdata_r;
         m_axis_tkeep_r <= 'hFF;
      end
    end
  end
  
  always @(posedge aclk) begin
    if (!aresetn) begin
      m_axis_tready_r <= 1'b0;
    end else begin
      m_axis_tready_r <= m_axis_tready;
    end
  end

  always @(posedge aclk) begin
    if (!aresetn) begin
      end_of_frame <= 'h0;
    end else begin
      if (counter_lines == (num_lines-1)) begin
        end_of_frame <= 1'b1;
      end else begin
        end_of_frame <= 1'b0;
      end
    end
  end

  always @(posedge aclk) begin
    if (!aresetn) begin
      end_of_frame_r <= 'h0;
    end else begin
      end_of_frame_r <= end_of_frame;
    end
  end

  assign negedge_eof = ~end_of_frame & end_of_frame_r;

  always @(posedge aclk) begin
    if (!aresetn) begin
      dropped_pkt_r <= 1'b0;
    end else begin
      dropped_pkt_r <= dropped_pkt;
    end
  end

  assign posedge_dropped_pkt = dropped_pkt & ~dropped_pkt_r;

  always @(posedge aclk) begin
    if (!aresetn) begin
      counter_lines <= 'h0;
      wait_eof_r <= 1'b0;
    end else begin
      if (m_axis_cam_tuser[0]) begin
        wait_eof_r <= 1'b0;
        counter_lines <= 'h0;
      end else if (posedge_dropped_pkt) begin
        if (counter_lines != num_lines) begin
          counter_lines <= counter_lines + 1; // increment when not = NUM_LINES
          wait_eof_r <= 1'b1; // 1 when a dropped is present - cleared at end_of_frame
        end else begin
          counter_lines <= 'h0; // 0 when is NUM_LINES
          wait_eof_r <= 1'b0; // 0 when is NUM_LINES
        end
      end else begin
        if (rtp_transm_state == PAYLOAD_TRANSM && m_axis_cam_tvalid_r && m_axis_tready) begin
          if (counter_lines != num_lines) begin
            if (m_axis_tlast_cams_r) begin 
              counter_lines <= counter_lines + 1;
            end else begin
              counter_lines <= counter_lines;
            end
          wait_eof_r <= wait_eof_r;
          end
        end else if (rtp_transm_state == IDLE_TRANSM) begin
          if (counter_lines == num_lines) begin
            counter_lines <= 'h0;
            wait_eof_r <= 1'b0; // clear wait - a new transfer can be issued
          end else begin
            counter_lines <= counter_lines;
            wait_eof_r <= wait_eof_r;
          end
        end
      end
    end
  end

  always @(posedge aclk) begin
    if (!aresetn) begin
      m_axis_tlast_cams_r <= 1'b0;
    end else begin
      m_axis_tlast_cams_r <= m_axis_tlast_cams;
    end
  end

  assign m_axis_tlast_cams = (m_axis_cam_tlast & m_axis_cam_tvalid & m_axis_tready) ? 1'b1 : 1'b0;
  
  assign int_tready_post_header = (end_of_pd_header_tr || rtp_transm_state == PAYLOAD_TRANSM) ? 1'b1 : 1'b0;
  assign m_axis_cam_tready = (m_axis_tready & int_tready_post_header) ? 1'b1 : 1'b0;
  
  assign m_axis_tlast =  m_axis_tlast_cams_r;
  assign m_axis_tkeep = (end_of_header_p1_tr) ? 'hFF : (end_of_header_p2_tr ? rtp_header_csrc_tkeep : (end_of_pd_header_tr ? 'hFF : m_axis_tkeep_r));
  assign m_axis_tdata_fin = {m_axis_tdata_r[15:0],m_axis_tdata_r[31:16],m_axis_tdata_r[47:32],m_axis_tdata_r[63:48]};
  assign m_axis_tdata = (end_of_header_p1_tr) ? {rtp_header.version,rtp_header.padding,rtp_header.extension,rtp_header.csrc_count,rtp_header.marker,rtp_header.payload_type,rtp_header.sequence_nr,rtp_header.timestamp} :
   (end_of_header_p2_tr ? {rtp_header.ssrc_field,rtp_header_csrc_field1} : ((end_of_pd_header_tr) ? rtp_pd_header : m_axis_tdata_fin));
  assign m_axis_tvalid = m_axis_cam_tvalid_r;

  assign can_start_to_m_axis = (m_axis_cam_tvalid && m_axis_tready && ~dropped_pkt && ~wait_eof_r) ? 1'b1 : 1'b0;
  assign end_of_header_p1_tr = (rtp_transm_state == HEADER_TRANSM_P1 && m_axis_tvalid && m_axis_tready) ? 1'b1 : 1'b0;
  assign end_of_header_p2_tr = (rtp_transm_state == HEADER_TRANSM_P2 && m_axis_tvalid && m_axis_tready) ? 1'b1 : 1'b0;
  assign end_of_pd_header_tr = (rtp_transm_state == PD_HEADER_TRANSM && m_axis_tvalid && m_axis_tready) ? 1'b1 : 1'b0;
  assign end_of_payload_tr   = m_axis_tlast_cams_r;

  always @(*) begin
    case (rtp_transm_state)
      IDLE_TRANSM: begin
        rtp_transm_state_next <= (can_start_to_m_axis) ? HEADER_TRANSM_P1 : IDLE_TRANSM;
      end
      HEADER_TRANSM_P1: begin
        rtp_transm_state_next <= (end_of_header_p1_tr) ? HEADER_TRANSM_P2 : HEADER_TRANSM_P1;
      end
      HEADER_TRANSM_P2: begin
        rtp_transm_state_next <= (end_of_header_p2_tr) ? PD_HEADER_TRANSM : HEADER_TRANSM_P2;
      end
      PD_HEADER_TRANSM: begin
        rtp_transm_state_next <= (end_of_pd_header_tr) ? PAYLOAD_TRANSM : PD_HEADER_TRANSM;
      end
      PAYLOAD_TRANSM: begin
        rtp_transm_state_next <= (end_of_payload_tr) ? IDLE_TRANSM : PAYLOAD_TRANSM;
      end
      default: begin
        rtp_transm_state_next <= IDLE_TRANSM;
      end
    endcase
  end      

  rtp_engine_regmap #(
    .VERSION (VERSION)
  ) i_regmap (
    .num_lines (num_lines),
    .num_px_p_line (num_px_p_line),
    .custom_timestamp (custom_timestamp),
    .custom_timestamp_96b (custom_timestamp_96b),
    .timestamp_s_eof (timestamp_s_eof),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

  up_axi #(
    .AXI_ADDRESS_WIDTH(16)
  ) i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

  axis_fifo #(
    .DEPTH (16384),
    .DATA_WIDTH (S_TDATA_WIDTH),
    .DEST_ENABLE (1),
    .DEST_WIDTH (1),
    .USER_WIDTH (S_TUSER_WIDTH),
    .FRAME_FIFO (1),
    .DROP_WHEN_FULL (1))
  storage_cam_data (
    .clk (aclk),
    .rst (areset),
    .s_axis_tdata (s_axis_tdata),
    .s_axis_tkeep (s_axis_tkeep),
    .s_axis_tvalid (s_axis_tvalid),
    .s_axis_tready (s_axis_tready),
    .s_axis_tlast (s_axis_tlast),
    .s_axis_tid (s_axis_tid),
    .s_axis_tdest (s_axis_tdest),
    .s_axis_tuser (s_axis_tuser),
    .m_axis_tdata (m_axis_cam_tdata),
    .m_axis_tvalid (m_axis_cam_tvalid),
    .m_axis_tready (m_axis_cam_tready),
    .m_axis_tlast (m_axis_cam_tlast),
    .m_axis_tdest (m_axis_cam_tdest),
    .m_axis_tuser (m_axis_cam_tuser),
    .dropped_pkt (dropped_pkt_out));

endmodule
