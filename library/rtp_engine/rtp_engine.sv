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

  /*
  * Master interface of the CSI-2 RX susbystem
  * out- video_out_tvalid - data valid
  * in- video_out_tready - slave ready to accept data
  * out- video_out_tuser - bits - 96 possible:
	  * 95-80 CRC
	  * 79-72 ECC
	  * 71-70 Reserved
	  * 69-64 Data type
	  * 63-48 Word count
	  * 47-32 Line number
	  * 31-16 Frame number
	  * 15-2 Reserved
	  * 1 Packet error
	  * 0 Start of frame
  * out- video_out_tlast - end of line
  * out- video_out_tdata - data
  * out- video_out_tdest -
	  * 9-4 Data
	  * 3-0 Virtual channel identifier (VC)
  * */

  localparam RTP_CLK = 90000;
  localparam RTP_INCREASE = RTP_CLK/INTERV_FRAME;
  localparam NUM_LINES = 1280;
  localparam NUM_CYCLES_TR = 480;

  /* 1 length field = lenght of 1080p line */
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
  reg                        valid_reg = 1'b0;

  wire [(M_TDATA_WIDTH-1):0] m_axis_cam_tdata;
  wire                       m_axis_cam_tvalid;
  wire                       m_axis_cam_tready;
  wire                       m_axis_cam_tlast;
  wire                       m_axis_cam_tdest;
  wire [(S_TUSER_WIDTH-1):0] m_axis_cam_tuser;

  // line and frame-related regs - wires
  reg  [8:0]                 counter_cycles_ppc = 'h0;
  reg  [15:0]                counter_lines = 'h0;
  reg                        end_of_frame = 1'b0;
  reg                        end_of_frame_r = 1'b0;
  reg                        end_of_line = 1'b0;

  wire                       negedge_eof;

  // RTP header/PD header related regs - wires
  reg  [15:0]                ext_seq_num_r = 'h0;
  wire [15:0]                bend_length_l1;

  reg  [(M_TDATA_WIDTH-1):0] s_axis_tdata_r = 'h0;
  reg  [(M_TDATA_WIDTH-1):0] s_axis_tdata_r1 = 'h0;
  reg  [(M_TDATA_WIDTH-1):0] s_axis_tdata_r2 = 'h0;

  //states related regs - wires 
  wire                       can_start_to_m_axis; // start of transfer indicator
  wire                       logic_in;
  wire                       end_of_header_p1_tr;
  wire                       end_of_header_p2_tr;
  wire                       end_of_pd_header_tr;
  wire                       end_of_payload_tr;
  wire                       int_tready_post_header;
  wire                       stop_transfer; // NOTE - not used in this version - stop of transmission at end_of_packet when login_in set to 0, in system with cameras can be a reset when an one is issued 

  state_rtp_transm           rtp_transm_state;
  state_rtp_transm           rtp_transm_state_next;


  assign int_tready_post_header = (end_of_pd_header_tr || rtp_transm_state == PAYLOAD_TRANSM) ? 1'b1 : 1'b0;
  assign m_axis_cam_tready = (m_axis_tready & int_tready_post_header) ? 1'b1 : 1'b0;

  assign rtp_header.version = 'h2; //rtp version 2 for rfc3550 - used as is in rfc 4175 for uncrompressed video
  assign rtp_header.padding = 'h0; //no padding at the end of packets
  assign rtp_header.extension = 'h0; //no extensions to the header
  assign rtp_header.csrc_count = 'h0; //1 source from 8 cameras in the system
  // assign rtp_header.marker =  for last packet in frame in this case of
  // progressive scan video
  assign rtp_header.payload_type = 'd96; //uncrompressed video
  // assign rtp_header.sequence_number = low-order bits of RTP sequence number
  // + 16 bits in payload header
  // assign rtp_header.timestamp = progressive video - same timestamp for
  // packets related to same frame
  //
  // will be assigned per rtp engine instance
  assign rtp_header.ssrc_field = SSRC_ID;

 
  // assign rtp_pd_header.ext_seq_num = / extended sequence number in nbo
  // assign rtp_pd_header.length = / num B data in scan line - nbo
  assign bend_length_l1 = 'd3840; // number of bytes - 1920 x 2 - 2 bytes per pixel -  multiple of pgroup 4
  assign rtp_pd_header.length_l1 = bend_length_l1; // nbo of number of bytes in the packet from analyzed scan line
  assign rtp_pd_header.field_identif_l1 = 'h0; // 0 for progressive video - field identification
  assign rtp_pd_header.offset_l1 = 'h0; // offset 0 - only one line transmitted, no multiple lines divided in mutilple
  assign rtp_pd_header.continuation_l1 = 'h0; // continuation is 0, no other header extension for another line will follow the first one - one line/packet
  assign rtp_pd_header.line_num_l1 = counter_lines;//{counter_lines[7:0],counter_lines[15:8]};
  // assign rtp_pd_header.line_num = line number in nbo - multiple of pgroup
  // - pgroup is 4 in this case 4 bytes per pgroup 
  // assign rtp_pd_header.c = continuation if a new scan line header follows
	 // the current one
  // assign rtp_pd_header.offset = offset to the first pixel in scan line - in
  // nbo
  //
  // formula for different transmission using specific MTU
  // example with 1920x1080 - sampling 4:2:2 8-bit frame-rate - 30 fps
  // udp payload = 1460 (from 1500 max) - UDP :8 - RTP :12 - Payload:14 = 1426
  // bytes
  // 1426/4 = 356.5 down to 356
  // 356 pgroups x 2pix/pgroup  - 721 pix/packet
  // 1920 x 1080 = 2073600 pix/frame
  // 2073600/721 = 2876.0055 - up to 2877 pkt/frame
  // 2 lines with 9000 mtu
  // udp paylod = 8926
  // 8926/4 = 2231
  // 2231 x 2pix/pgroup - 4462 - 2.324 lines of data for 1080p resolution
  // 2073600/4462 = 464.72 - 465 packets per frame
  //

  always @(posedge aclk) begin
    if (!aresetn) begin
      rtp_header.timestamp <= 'h0;
    end else begin
      if (negedge_eof) begin
        rtp_header.timestamp <= rtp_header.timestamp + RTP_INCREASE;
      end else if (rtp_header.timestamp == 'hFFFFFFFF) begin
        rtp_header.timestamp <= 'h0;
      end else begin
        rtp_header.timestamp <= rtp_header.timestamp;
      end
    end
  end

  assign rtp_header.marker = (counter_lines == (NUM_LINES-2)) ? 1'b1 : 1'b0;

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

  assign rtp_pd_header.ext_seq_num = {ext_seq_num_r[7:0],ext_seq_num_r[15:8]}; //ext seq number in nbo - big endian of 16b

  always @(posedge aclk) begin
    if (!aresetn) begin
      rtp_transm_state <= IDLE_TRANSM;
    end else begin
      rtp_transm_state <= rtp_transm_state_next;
    end
  end
  
  always @(posedge aclk) begin
    if (!aresetn) begin
      valid_reg <= 'h0;
    end else begin
      if (rtp_transm_state == HEADER_TRANSM_P1 || rtp_transm_state == HEADER_TRANSM_P2 || rtp_transm_state == PD_HEADER_TRANSM) begin
        valid_reg <= 'h1;
      end else if (rtp_transm_state == PAYLOAD_TRANSM) begin
        if (!(m_axis_cam_tlast & m_axis_cam_tvalid)) begin
          valid_reg <= 'h1;
        end else begin
          valid_reg <= 'h0;
        end
      end else begin
        valid_reg <= 'h0;
      end
    end
  end
  
  assign m_axis_tvalid = valid_reg;

  always @(posedge aclk) begin
    if (!aresetn) begin
      m_axis_tdata_r <= 'h0;
      m_axis_tkeep_r <= 'hFF;
    end else begin
      if (rtp_transm_state == HEADER_TRANSM_P1) begin // HEADER_TRANSM_P1 active for 2 cycles
        if (!end_of_header_p1_tr) begin
          m_axis_tdata_r <= {rtp_header.version,rtp_header.padding,rtp_header.extension,rtp_header.csrc_count,rtp_header.marker,rtp_header.payload_type,rtp_header.sequence_nr,rtp_header.timestamp};
          m_axis_tkeep_r <= 'hFF;
        end else begin 
          m_axis_tdata_r <= {rtp_header.ssrc_field,32'h00000000};
          m_axis_tkeep_r <= 'h0F;
        end
      end else begin
        m_axis_tkeep_r <= 'hFF;
        if (end_of_header_p2_tr) begin
          m_axis_tdata_r <= rtp_pd_header;
	end else if (end_of_pd_header_tr || rtp_transm_state == PAYLOAD_TRANSM) begin
	  m_axis_tdata_r <= m_axis_cam_tdata;
        end
      end
    end
  end

  assign m_axis_tkeep = m_axis_tkeep_r;
  
  always @(posedge aclk) begin
    if (!aresetn) begin
      counter_cycles_ppc <= 'h0;
    end else begin
      if (rtp_transm_state == PAYLOAD_TRANSM && valid_reg) begin
        if (counter_cycles_ppc != (NUM_CYCLES_TR)) begin
          counter_cycles_ppc <= counter_cycles_ppc + 1;
        end else begin
          counter_cycles_ppc <= 0;
        end
      end
    end
  end
  
  always @(posedge aclk) begin
    if (!aresetn) begin
      end_of_line <= 'h0;
    end else begin
      if (counter_cycles_ppc == (NUM_CYCLES_TR-1)) begin
        end_of_line <= 1'b1;
      end else begin
        end_of_line <= 1'b0;
      end
    end
  end
  
  always @(posedge aclk) begin
    if (!aresetn) begin
      end_of_frame <= 'h0;
    end else begin
      if (counter_lines == (NUM_LINES-1)) begin
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
      counter_lines <= 'h0;
    end else begin
      if (rtp_transm_state == PAYLOAD_TRANSM && valid_reg) begin
        if (counter_lines != (NUM_LINES)) begin
          if (m_axis_cam_tlast & m_axis_cam_tvalid) begin
            counter_lines <= counter_lines + 1;
          end else begin
            counter_lines <= counter_lines;
          end
        end
      end else if (rtp_transm_state == IDLE_TRANSM) begin
        if (counter_lines == (NUM_LINES)) begin
          counter_lines <= 'h0;
        end else begin
          counter_lines <= counter_lines;
        end
      end
    end
  end
 
  assign end_of_header_p1_tr = (rtp_transm_state == HEADER_TRANSM_P1 && valid_reg) ? 1'b1 : 1'b0;
  assign end_of_header_p2_tr = (rtp_transm_state == HEADER_TRANSM_P2 && valid_reg) ? 1'b1 : 1'b0;

  assign end_of_pd_header_tr = (rtp_transm_state == PD_HEADER_TRANSM && valid_reg) ? 1'b1 : 1'b0;
  
  assign can_start_to_m_axis = (m_axis_cam_tvalid & m_axis_tready) ? 1'b1 : 1'b0; // m_axis_cam_tvalid indicating only valid data from internal stack that is composed of data capture from csi-2 rx subsystem
  // tvalid    --------
  // tready    ___-----
  // can_start ___-----
  assign end_of_payload_tr = (m_axis_cam_tlast & m_axis_cam_tvalid) ? 1'b1 : 1'b0; // end of payload-based transmission indicated by tlast from axis-fifo (longer than a cycle - entire last beat + pause period)
  // tlast     ___----------
  // tvalid    ----________
  // end_of_payload + increment - requirement of only one 1'b1 cycle - to do
  assign m_axis_tlast = (m_axis_cam_tlast & m_axis_cam_tvalid) ? 1'b1 : 1'b0; //end_of_line state when tvalid from fifo at the same time - tlast can be maintained after in pause_state
  assign m_axis_tdata = m_axis_tdata_r;
  assign f_32b_tdata = m_axis_tdata[63:32];
  assign l_32b_tdata = m_axis_tdata[31:0];
  
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
    .start_transfer (logic_in),
    .stop_transfer (stop_transfer),
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
    .DEPTH (4096),
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
    .m_axis_tuser (m_axis_cam_tuser));

endmodule
