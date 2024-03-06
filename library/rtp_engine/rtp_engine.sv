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
  parameter         S_TDATA_WIDTH = 32, // 32 or 64 - 2ppc or 4ppc
  parameter         S_TDEST_WIDTH = 4,
  parameter         S_TUSER_WIDTH = 1,
  parameter         M_TDATA_WIDTH = 64,
  parameter         M_TDEST_WIDTH = 4,
  parameter         M_TUSER_WIDTH = 1,
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
  output  logic                         n_bytes_tr,

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

  wire   [15:0]   seq_number_h;
  wire   [15:0]   seq_number_l;

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

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
  localparam NUM_LINES = 1080;
  localparam NUM_PIX_PER_PCKT = 960;//2231 * 2 pix/pgroup = 4462 pixels // 1920 pixels per packet - one complete line / 2 => 960 pixels as pgroup

// 1 line transmission - 1920 pixels + blanking - 2200 pixels and 1125 pixels rows

  /* 1 length field = lenght of 1080p line */
  /* 1 line per packet -> 1 line number field */
  /* 1 field identification field*/
  /* 1 continuation field */
  /* 1 offset field */

  import rtp_engine_package::*;

  rtp_pckt_header rtp_header;
  rtp_payload_header rtp_pd_header;

  reg [31:0]   data_video_r = 1'b0;
  reg          s_axis_tready_r = 1'b0;
  reg [8:0]    count_packets = 'h0;
  reg          l_pckt_frame = 1'b0;
  reg          rtp_pckt_sent = 1'b0;
  reg          end_of_packet = 1'b0;
  reg          m_axis_tuser_r = 1'b0;
  reg [(M_TDATA_WIDTH-1):0] m_axis_tdata_r = 'h0;
  reg          counter_tr_header = 'h0;
  reg          counter_tr_header_r = 'h0;   
  reg [8:0]    counter_cycles_ppc = 'h0;
  reg [10:0]   counter_lines = 'h0;
  reg          end_of_frame = 1'b0;
  reg          end_of_line = 1'b0;
  reg          eol_r = 'h0;
  reg [10:0]   counter_pause_period = 'h0;
  reg          m_axis_tvalid_r = 1'b0;
  reg          diff_tr_length = 1'b0;

  
  wire         can_start_to_m_axis;
  wire [63:0]  predef_pattern = 'hfa2babbcd271abcd;
  reg [15:0]   ext_seq_num_r = 'h0;
  reg          logic_in_r = 1'b0;

  state_vid_fr transfer_state;
  state_rtp_pckt rtp_pckt_state;
  state_vid_fr transfer_state_next;
  state_rtp_pckt rtp_pckt_state_next;
  state_rtp_transm rtp_transm_state;
  state_rtp_transm rtp_transm_state_next;

  reg  [10:0]  line_counter = 'h0;
  reg  [11:0]  pix_counter = 'h0;
  reg          pause_pckt = 'h0;
  reg          s_axis_tlast_r = 'h0;
  reg          start_transfer_r = 1'b0;
  wire         start_transfer_s;
  wire         start_pckt;
  wire         end_of_rtp_pckt;
  wire [15:0]  bend_length_l1;
  wire         posedge_tlast;
  wire         start_transfer_regmap;
  wire         stop_transfer;
  wire         end_of_header_tr;
  wire         end_of_header_tr_sig;
  wire         end_of_pd_header_tr;
  wire         end_of_payload_tr;
  wire         posedge_eol;

  wire [31:0]  f_32b_rtp_h;
  wire [31:0]  m_32b_rtp_h;
  wire [31:0]  l_32b_rtp_h;
  wire [31:0]  f_32b_rtpp_h;
  wire [31:0]  l_32b_rtpp_h;
  wire [31:0]  f_32b_tdata;
  wire [31:0]  l_32b_tdata;

  // tready of the slave is off when the module is in reset - whole system is
  // in reset
  always @(posedge aclk) begin
    if (!aresetn) begin
      s_axis_tready_r <= 1'b0;
    end else begin
      s_axis_tready_r <= 1'b1;
    end
  end

  always @(posedge aclk) begin
    if (!aresetn) begin
      data_video_r <= 'h0;
    end else begin
      if (s_axis_tready & s_axis_tvalid) begin
        data_video_r <= s_axis_tdata; //2/4 pixels received in one clock cycle 
      end
    end
  end

  assign s_axis_tready = s_axis_tready_r;

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
  assign bend_length_l1 = 'h44c; // number of bytes - 2200/2 - 1100 dec -> 44c hex, multiple of pgroup 4
  assign rtp_pd_header.length_l1 = {{bend_length_l1[7:0]},{bend_length_l1[15:8]}}; // nbo of number of bytes in the packet from analyzed scan line
  assign rtp_pd_header.field_identif_l1 = 'h0; // 0 for progressive video - field identification
  assign rtp_pd_header.offset_l1 = 'h0; // offset 0 - only one line transmitted, no multiple lines divided in mutilple
  assign rtp_pd_header.continuation_l1 = 'h0; // continuation is 0, no other header extension for another line will follow the first one - one line/packet
  assign rtp_pd_header.line_num_l1 = counter_lines;
//  assign rtp_pd_header.field_identif_l2 = 'h0; // 0 for progressive video - field identification
//  assign rtp_pd_header.field_identif_l3 = 'h0; // 0 for progressive video - field identification
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

  assign f_32b_rtp_h = {rtp_header.version,rtp_header.padding,rtp_header.extension,rtp_header.csrc_count,rtp_header.marker,rtp_header.payload_type,rtp_header.sequence_nr};
  assign m_32b_rtp_h = rtp_header.timestamp;
  assign l_32b_rtp_h = rtp_header.ssrc_field;

  assign f_32b_rtpp_h = {rtp_pd_header.ext_seq_num, rtp_pd_header.length_l1};
  assign l_32b_rtpp_h = {rtp_pd_header.field_identif_l1,rtp_pd_header.line_num_l1,rtp_pd_header.continuation_l1,rtp_pd_header.offset_l1};

  always @(posedge aclk) begin
    if (!aresetn) begin
      rtp_header.timestamp <= 'h0;
    end else begin
      if (end_of_frame) begin
        rtp_header.timestamp <= rtp_header.timestamp + RTP_INCREASE;
      end
    end
  end
  
  always @(posedge aclk) begin
    if (!aresetn) begin
      rtp_header.marker <= 1'b0;
    end else begin
      if (end_of_frame) begin
        rtp_header.marker <= 1'b1;
      end else begin
        rtp_header.marker <= 1'b0;
      end
    end
  end
  
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
      ext_seq_num_r <= seq_number_h;
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

  assign rtp_pd_header.ext_seq_num = {{ext_seq_num_r[7:0]},{ext_seq_num_r[15:8]}}; //ext seq number in nbo - big endian of 16b

  always @(posedge aclk) begin
    if (!aresetn) begin
      transfer_state <= IDLE;
    end else begin
      transfer_state <= transfer_state_next;
    end
  end

  always @(posedge aclk) begin
    if (!aresetn) begin
      rtp_pckt_state <= IDLE_RTP;
    end else begin
      rtp_pckt_state <= rtp_pckt_state_next;
    end
  end

  always @(posedge aclk) begin
    if (!aresetn) begin
      rtp_transm_state <= IDLE_TRANSM;
    end else begin
      rtp_transm_state <= rtp_transm_state_next;
    end
  end

  reg valid_reg = 1'b0;
  
  always @(posedge aclk) begin
    if (!aresetn) begin
      valid_reg <= 'h0;
    end else begin
      if (rtp_transm_state == HEADER_TRANSM_P1 || rtp_transm_state == HEADER_TRANSM_P2) begin
        valid_reg <= 'h1;
      end else if (rtp_transm_state == PD_HEADER_TRANSM) begin
        valid_reg <= 'h1;
      end else if (rtp_transm_state == PAYLOAD_TRANSM) begin
        if (!posedge_eol) begin
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
      diff_tr_length <= 'h0;
    end else begin
      if (rtp_transm_state == HEADER_TRANSM_P1/* && counter_tr_header == 'h0*/) begin // HEADER_TRANSM_P1 active for 2 cycles
        if (!end_of_header_p1_tr) begin
          m_axis_tdata_r <= {rtp_header.version,rtp_header.padding,rtp_header.extension,rtp_header.csrc_count,rtp_header.marker,rtp_header.payload_type,rtp_header.sequence_nr,rtp_header.timestamp};
          diff_tr_length <= 'h0;
        end else begin 
          m_axis_tdata_r <= {rtp_header.ssrc_field,32'h00000000};
          diff_tr_length <= 'h1;
        end
      end else begin
        if (end_of_header_p2_tr) begin
          m_axis_tdata_r <= rtp_pd_header;
          diff_tr_length <= 'h0;
        end else if (end_of_pd_header_tr) begin
          m_axis_tdata_r <= predef_pattern;
          diff_tr_length <= 'h0;
        end
      end
    end
  end

  assign n_bytes_tr = diff_tr_length;
  
  always @(posedge aclk) begin
    if (!aresetn) begin
      counter_cycles_ppc <= 'h0;
    end else begin
      if (rtp_transm_state == PAYLOAD_TRANSM && valid_reg) begin
        if (counter_cycles_ppc != 480) begin
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
      if (counter_cycles_ppc == 479) begin
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
      if (counter_lines == 1079) begin
        end_of_frame <= 1'b1;
      end else begin
        end_of_frame <= 1'b0;
      end
    end
  end
  
  always @(posedge aclk) begin
    if (!aresetn) begin
      counter_lines <= 'h0;
    end else begin
      if (rtp_transm_state == PAYLOAD_TRANSM && valid_reg) begin
        if (counter_lines != 1080) begin
          if (end_of_line) begin
            counter_lines <= counter_lines + 1;
          end else begin
            counter_lines <= counter_lines;
          end
        end else begin
          counter_lines <= 'h0;
        end
      end
    end
  end
  
  always @(posedge aclk) begin
    if (!aresetn) begin
      counter_tr_header_r <= 'h0;
    end else begin
      counter_tr_header_r <= counter_tr_header;
    end
  end
  
  always @(posedge aclk) begin
    if (!aresetn) begin
      eol_r <= 'h0;
    end else begin
      eol_r <= end_of_line;
    end
  end
  
  assign end_of_header_p1_tr = (rtp_transm_state == HEADER_TRANSM_P1 && valid_reg) ? 1'b1 : 1'b0;
  assign end_of_header_p2_tr = (rtp_transm_state == HEADER_TRANSM_P2 && valid_reg) ? 1'b1 : 1'b0;

  assign end_of_pd_header_tr = (rtp_transm_state == PD_HEADER_TRANSM && valid_reg) ? 1'b1 : 1'b0;
  assign posedge_eol = end_of_line & ~eol_r;
  
  always @(posedge aclk) begin
    if (!aresetn) begin
      s_axis_tlast_r <= 1'b0;
    end else begin
      s_axis_tlast_r <= s_axis_tlast;
    end
  end

  assign posedge_tlast = s_axis_tlast & ~s_axis_tlast_r;
  
  always @(*) begin
    case (transfer_state)
      IDLE: begin
        transfer_state_next <= (start_transfer_s) ? F_COUNT : IDLE; // start of frame state
      end
      F_COUNT : begin
        transfer_state_next <= (line_counter == (NUM_LINES-1) ) ? IDLE : F_COUNT;
      end
      default : begin
        transfer_state_next <= IDLE;
      end
    endcase
  end

  always @(*) begin
    case (rtp_pckt_state)
      IDLE_RTP: begin
        rtp_pckt_state_next <= (start_pckt) ? PIX_COUNT : IDLE_RTP;
      end
      PIX_COUNT: begin
        rtp_pckt_state_next <= (pix_counter == (NUM_PIX_PER_PCKT - 1)) ? IDLE_RTP : PIX_COUNT;
      end
      default: begin
        rtp_pckt_state_next <= IDLE_RTP;
      end
    endcase
  end
  
  //states for the definition of the transmission process
  
  // start transfer using set bit in regmap
  always @(posedge aclk) begin
    if (!aresetn) begin
      logic_in_r <= 1'b0;
    end else begin
      logic_in_r <= logic_in;
    end
  end

  always @(posedge aclk) begin
    if (!aresetn) begin
      counter_pause_period <= 'h0;
    end else begin
      if (rtp_transm_state == PAUSE_TRANSM) begin
        if (counter_pause_period != 'd1800) begin
          counter_pause_period <= counter_pause_period + 1;
        end else begin
          counter_pause_period <= 0;
        end
      end else begin
        counter_pause_period <= 0;
      end
    end
  end
  
  assign can_start_to_m_axis = logic_in & ~logic_in_r;
  assign end_of_payload_tr = end_of_line;
  assign m_axis_tlast = end_of_line;
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
        rtp_transm_state_next <= (end_of_payload_tr) ?  /*((stop_tr) ? IDLE_TRANSM : HEADER_TRANSM_P1)*/ PAUSE_TRANSM : PAYLOAD_TRANSM;
      end
      PAUSE_TRANSM: begin
        rtp_transm_state_next <= (counter_pause_period == 'd1800) ? IDLE_TRANSM : PAUSE_TRANSM;
      end 
      default: begin
        rtp_transm_state_next <= IDLE_TRANSM;
      end
    endcase
  end      

  rtp_engine_regmap #(
    .VERSION (VERSION)
  ) i_regmap (
    .seq_number_h (seq_number_h),
    .seq_number_l (seq_number_l),
    .start_transfer (logic_in),
    .stop_transfer (stop_transfer),
    .f_32b_rtp_h (f_32b_rtp_h),
    .m_32b_rtp_h (m_32b_rtp_h),
    .l_32b_rtp_h (l_32b_rtp_h),
    .f_32b_rtpp_h (f_32b_rtpp_h),
    .l_32b_rtpp_h (l_32b_rtpp_h),
    .f_32b_tdata (f_32b_tdata),
    .l_32b_tdata (l_32b_tdata),
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

endmodule
