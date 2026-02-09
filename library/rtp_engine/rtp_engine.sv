// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
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

module rtp_engine #(
  parameter         S_TDATA_WIDTH = 64,
  parameter         S_TDEST_WIDTH = 4,
  parameter         S_TUSER_WIDTH = 2,
  parameter         M_TDATA_WIDTH = 64,
  parameter         M_TDEST_WIDTH = 4,
  parameter         M_TUSER_WIDTH = 1,
  parameter         M_TKEEP_WIDTH = M_TDATA_WIDTH/8,
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

  localparam SSRC_ID = 0;
  localparam INTERV_FRAME = 30;
  localparam RTP_CLK = 90000;
  localparam RTP_INCREASE = RTP_CLK/INTERV_FRAME;

  import rtp_engine_package::*;
  eth_frame_header eth_header;
  ip_pckt_header ip_header; // instance of ip header struct packed
  udp_datagram_header udp_header; // instance of udp header struct packed
  rtp_pckt_header rtp_header; // instance of RTP header struct packed
  rtp_payload_header rtp_pd_header; // instance of RTP Payload header struct packed

  // AXIS S/M related regs
  reg  [(M_TDATA_WIDTH-1):0] m_axis_tdata_r = 'h0;
  reg  [(M_TKEEP_WIDTH-1):0] m_axis_tkeep_r = 'h0;
  wire [(M_TDATA_WIDTH-1):0] m_axis_cam_tdata;
  wire [(M_TDATA_WIDTH-1):0] m_axis_cam_tdata_final_form;
  wire                       m_axis_cam_tdest;
  wire                       m_axis_cam_tlast;
  wire                       m_axis_cam_tready;
  wire                       m_axis_cam_tvalid;
  reg                        m_axis_cam_tvalid_r = 1'b0;
  wire [(S_TUSER_WIDTH-1):0] m_axis_cam_tuser;
  wire                       m_axis_tlast_cams;
  reg                        last_sample = 1'b0;
  reg                        penultimate_sample = 1'b0;
  reg  [(M_TDATA_WIDTH-1):0] save_data = 'h0;

  // ETH/IPv4/UDP/RTP-related logic regs and wires

  wire [15:0]                bend_length_l1;
  reg  [2:0]                 counter_data_transm = 'h0;
  reg  [2:0]                 counter_eth_hdr_transm = 'h0;
  reg  [2:0]                 counter_ip_hdr_transm = 'h0;
  reg  [15:0]                counter_lines = 'h0;
  reg  [2:0]                 counter_rtp_hdr_transm = 'h0;
  reg                        dropped_pkt_r = 1'b0;
  reg                        end_of_frame = 1'b0;
  reg                        end_of_frame_r = 1'b0;
  wire                       end_of_eth_hdr;
  wire                       end_of_ip_hdr;
  wire                       end_of_rtp_hdr;
  wire                       end_of_payload_tr;
  wire                       end_of_udp_hdr;
  reg  [15:0]                ext_seq_num_r = 'h0;
  wire                       init_tready_post_header;
  wire                       negedge_eof;
  wire [11:0]                num_lines;
  wire [11:0]                num_px_p_line;
  reg  [31:0]                rtp_header_timestamp_r = 'h0;
  wire                       can_start_to_m_axis; // start of transfer indicator

  // fields-related regs and wires 

  wire      [31:0]           dest_addr_hb;
  wire      [15:0]           dest_addr_lb;
  wire      [31:0]           source_addr_hb;
  wire      [15:0]           source_addr_lb;
  wire      [47:0]           dest_addr;
  wire      [47:0]           source_addr;
  wire      [31:0]           src_ip_addr;
  wire      [31:0]           dest_ip_addr;
  wire      [7:0]            ip_qos;
  reg       [31:0]           ip_hdr_sum_r = 'h0;
  wire      [15:0]           udp_src_port;
  wire      [15:0]           udp_dest_port;

  state_udp_ip_transm        udp_ip_transm_state;
  state_udp_ip_transm        udp_ip_transm_state_next;

  assign eth_header.frame_type = 'h0800;
  
  assign ip_header.version = 'h4;
  assign ip_header.ihl = 'h5;
  //assign ip_header.tos = // 3 bits for precende
  // 000 - normal priority - 111 - control packet
  // 3 bits - delay, throughput, reliability
  // 2 bits - ecn
  //assign ip_header.total_length = // total length at l3 - data and header bytes
  assign ip_header.total_length = udp_header.length + 'd20;
  assign ip_header.identification = 'h0; // 0 if fragmentation is not made
  assign ip_header.pause = 0; // 0 bit that is reserved from flags for fragmentation
  assign ip_header.df = 1; // don't fragment
  assign ip_header.mf = 0; // more fragments of the datagram
  assign ip_header.fragment_offset = 'h0; // fragment offset of the datagram
  assign ip_header.ttl = 'hFF; // number of hops or 0 if the packet is dropped
  assign ip_header.protocol = 'd17; // UDP - 17
  // assign ip_header.hdr_checksum - header checksum with 1 complement to the header
  // the sum would not go over the max number on 32 bits - multiple zeros in calculus

  // assign ip_header.source_address = // source IP address
  // assign ip_header.dest_address = // destination IP address
  
  assign rtp_header.version = 'h2; //rtp version 2 for rfc3550 - used as is in rfc 4175 for uncrompressed video
  assign rtp_header.padding = 'h0; //no padding at the end of packets
  assign rtp_header.extension = 'h0; //no extensions to the header
  assign rtp_header.csrc_count = 'h1; //1 source from 8 cameras in the system
  // assign rtp_header.marker =  for last packet in frame in this case of
  // progressive scan video
  assign rtp_header.payload_type = 'd96; //uncrompressed video

  assign rtp_header.timestamp = rtp_header_timestamp_r;
  assign rtp_header.ssrc_field = SSRC_ID;
  assign rtp_header.csrc_field1 = 'h0;
 
  // assign rtp_pd_header.length = / num B data in scan line - nbo
  assign bend_length_l1 = num_px_p_line << 1; // number of bytes - 1920 x 2 - 2 bytes per pixel -  multiple of pgroup 4
  assign rtp_pd_header.length_l1 = bend_length_l1; // nbo of number of bytes in the packet from analyzed scan line
  assign rtp_pd_header.field_identif_l1 = 'h0; // 0 for progressive video - field identification
  assign rtp_pd_header.offset_l1 = 'h0; // offset 0 - only one line transmitted, no multiple lines divided in mutilple
  assign rtp_pd_header.continuation_l1 = 'h0; // continuation is 0, no other header extension for another line will follow the first one - one line/packet
  assign rtp_pd_header.line_num_l1 = counter_lines;//{counter_lines[7:0],counter_lines[15:8]};

  //assign udp_datagram_header.source_port = // source UDP port
  //assign udp_datagram_header.dest_port = // dest UDP port
  //assign udp_header.source_port = source_port;
  //assign udp_header.dest_port = dest_port;
  //assign udp_header.length = // UDP datagram length - header + data
  //assign udp_header.checksum = // checksum calculated using header + data + pseudo-header IPv4 (zero in this case to skip additional delay to processing)

  always @(posedge aclk) begin
    if (!aresetn) begin
      udp_ip_transm_state <= IDLE_TRANSM;
    end else begin
      udp_ip_transm_state <= udp_ip_transm_state_next;
    end
  end
  
  assign rtp_header.marker = (counter_lines == (num_lines-1)) ? 1'b1 : 1'b0;

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

  // processing on the frame - count the number of lines and output the end_of_frame signal

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

  assign m_axis_cam_tdata_final_form = {m_axis_cam_tdata[15:0],m_axis_cam_tdata[31:16],m_axis_cam_tdata[47:32],m_axis_cam_tdata[63:48]};

  always @(posedge aclk) begin
    if (!aresetn) begin
      m_axis_tdata_r <= 'h0;
      m_axis_tkeep_r <= 'h0;
      counter_eth_hdr_transm <= 'h0;
      counter_ip_hdr_transm <= 'h0;
      save_data <= 'h0;
    end else begin
      if (udp_ip_transm_state == ETH_HDR) begin
        if (counter_eth_hdr_transm == 0 && m_axis_tready) begin
          m_axis_tdata_r <= {eth_header.dest_addr,eth_header.source_addr[47:32]};
          counter_eth_hdr_transm <= counter_eth_hdr_transm + 1;
          m_axis_tkeep_r <= 'hFF;
        end else if (counter_eth_hdr_transm == 1 && m_axis_tready) begin
          m_axis_tdata_r <= {eth_header.source_addr[31:0],eth_header.frame_type,ip_header.version,ip_header.ihl,ip_header.tos};
          counter_eth_hdr_transm <= 0;
          m_axis_tkeep_r <= 'hFF;
        end
      end else if (udp_ip_transm_state == IP_HDR) begin
        if (counter_ip_hdr_transm == 0 && m_axis_tready) begin
          m_axis_tdata_r <= {ip_header.total_length,ip_header.identification,ip_header.pause,ip_header.df,ip_header.mf,ip_header.fragment_offset,ip_header.ttl,ip_header.protocol};
          counter_ip_hdr_transm <= counter_ip_hdr_transm + 1;
          m_axis_tkeep_r <= 'hFF;
        end else if (counter_ip_hdr_transm == 1 && m_axis_tready) begin
          m_axis_tdata_r <= {ip_header.hdr_checksum,ip_header.source_address,ip_header.dest_address[31:16]};
          counter_ip_hdr_transm <= counter_ip_hdr_transm + 1;
          m_axis_tkeep_r <= 'hFF;
        end else if (counter_ip_hdr_transm == 2 && m_axis_tready) begin
          m_axis_tdata_r <= {ip_header.dest_address[15:0],udp_header.source_port,udp_header.dest_port,udp_header.length};
          counter_ip_hdr_transm <= 'h0;
          m_axis_tkeep_r <= 'hFF;
        end
        
      end else if (udp_ip_transm_state == UDP_HDR) begin
          m_axis_tdata_r <= {udp_header.checksum,rtp_header.version,rtp_header.padding,rtp_header.extension,rtp_header.csrc_count,rtp_header.marker,rtp_header.payload_type,rtp_header.sequence_nr,rtp_header.timestamp[31:16]};
          m_axis_tkeep_r <= 'hFF;
      end else if (udp_ip_transm_state == RTP_HDR) begin
        if (counter_rtp_hdr_transm == 0 && m_axis_tready) begin
          m_axis_tdata_r <= {rtp_header.timestamp[15:0],rtp_header.ssrc_field,rtp_header.csrc_field1[31:16]};
          m_axis_tkeep_r <= 'hFF;
          counter_rtp_hdr_transm <= counter_rtp_hdr_transm + 1;
        end else if (counter_rtp_hdr_transm == 1 && m_axis_tready) begin
          m_axis_tdata_r <= {rtp_header.csrc_field1[15:0],rtp_pd_header.ext_seq_num,rtp_pd_header.length_l1,rtp_pd_header.field_identif_l1,rtp_pd_header.line_num_l1};
          m_axis_tkeep_r <= 'hFF;
          counter_rtp_hdr_transm <= 'h0;
        end
      end else if (udp_ip_transm_state == PAYLOAD_TRANSM) begin
        if (counter_data_transm == 0 && last_sample != 1 && m_axis_tready) begin
	  m_axis_tdata_r <= {rtp_pd_header.continuation_l1,rtp_pd_header.offset_l1,m_axis_cam_tdata_final_form[63:16]};
          counter_data_transm <= counter_data_transm + 1;
          save_data <= m_axis_cam_tdata_final_form;
          m_axis_tkeep_r <= 'hFF;
        end
        if (counter_data_transm == 1 && m_axis_tready) begin
          save_data <= m_axis_cam_tdata_final_form;
          if (penultimate_sample == 0) begin
            m_axis_tdata_r <= {save_data[15:0],m_axis_cam_tdata_final_form[63:16]};
            counter_data_transm <= counter_data_transm;
            m_axis_tkeep_r <= 'hFF;
          end else if (penultimate_sample == 1) begin
            m_axis_tdata_r <= {save_data[15:0], 48'h0};
	          counter_data_transm <= 'h0;
            m_axis_tkeep_r <= 'h03;
          end
        end
      end else begin
          m_axis_tdata_r <= m_axis_tdata_r;
          m_axis_tkeep_r <= 'hFF;
      end
    end
  end


  always @(posedge aclk) begin
    if (!aresetn) begin
      counter_lines <= 'h0;
    end else begin
      if (m_axis_cam_tuser[0]) begin
        counter_lines <= 'h0;
      end else begin
        if (udp_ip_transm_state == PAYLOAD_TRANSM && m_axis_cam_tvalid_r && m_axis_tready) begin
          if (counter_lines != num_lines) begin
            if (penultimate_sample) begin 
              counter_lines <= counter_lines + 1;
            end else begin
              counter_lines <= counter_lines;
            end
          end
        end else if (udp_ip_transm_state == IDLE_TRANSM) begin
          if (counter_lines == num_lines) begin
            counter_lines <= 'h0;
          end else begin
            counter_lines <= counter_lines;
          end
        end
      end
    end
  end

  always @(posedge aclk) begin
    if (!aresetn) begin
      m_axis_cam_tvalid_r <= 1'b0;
    end else begin 
      if (udp_ip_transm_state == ETH_HDR || udp_ip_transm_state == IP_HDR || udp_ip_transm_state == UDP_HDR || udp_ip_transm_state == RTP_HDR) begin
        m_axis_cam_tvalid_r <= 1'b1;
      end else if (udp_ip_transm_state == PAYLOAD_TRANSM) begin
        m_axis_cam_tvalid_r <= m_axis_cam_tvalid;
      end else begin
        m_axis_cam_tvalid_r <= 1'b0;
      end
    end
  end


  always @(posedge aclk) begin
    if (!aresetn) begin
      penultimate_sample <= 1'b0;
      last_sample <= 1'b0;
    end else begin
      penultimate_sample <= m_axis_tlast_cams;
      last_sample <= penultimate_sample;
    end
  end

  assign m_axis_tlast_cams = (m_axis_cam_tlast & m_axis_cam_tvalid & m_axis_tready) ? 1'b1 : 1'b0;
  
  assign init_tready_post_header = (udp_ip_transm_state == PAYLOAD_TRANSM) ? 1'b1 : 1'b0;
  assign m_axis_cam_tready = (m_axis_tready & init_tready_post_header) ? 1'b1 : 1'b0;
  assign m_axis_tvalid = m_axis_cam_tvalid_r | last_sample;
  assign m_axis_tlast = last_sample;
  
  assign m_axis_tkeep = m_axis_tkeep_r;
  assign m_axis_tdata = {m_axis_tdata_r[7:0],m_axis_tdata_r[15:8],m_axis_tdata_r[23:16],m_axis_tdata_r[31:24],m_axis_tdata_r[39:32],m_axis_tdata_r[47:40],m_axis_tdata_r[55:48],m_axis_tdata_r[63:56]};
  
  assign can_start_to_m_axis = (m_axis_cam_tvalid && m_axis_tready) ? 1'b1 : 1'b0;

  assign end_of_ip_hdr = (counter_ip_hdr_transm == 2 && m_axis_tready) ? 1'b1 : 1'b0;
  assign end_of_udp_hdr = (udp_ip_transm_state == UDP_HDR && m_axis_tready) ? 1'b1 : 1'b0;
  assign end_of_eth_hdr = (counter_eth_hdr_transm == 1 && m_axis_tready) ? 1'b1 : 1'b0;
  assign end_of_rtp_hdr = (counter_rtp_hdr_transm == 1 && m_axis_tready) ? 1'b1 : 1'b0;
  assign end_of_payload_tr = last_sample;

  always @(posedge aclk) begin
    if (!aresetn) begin
      eth_header.dest_addr <= 'h0;
      eth_header.source_addr <= 'h0;
      ip_header.tos <= 'h0;
      ip_header.source_address <= 'h0;
      ip_header.dest_address <= 'h0;
      udp_header.source_port <= 'h0;
      udp_header.dest_port <= 'h0;
      udp_header.length <= 'h0;
    end else begin
      if (can_start_to_m_axis) begin
        eth_header.dest_addr <= {dest_addr_hb,dest_addr_lb};
        eth_header.source_addr <= {source_addr_hb,source_addr_lb};
        ip_header.tos <= ip_qos;
        ip_header.source_address <= src_ip_addr;
        ip_header.dest_address <= dest_ip_addr;
        udp_header.source_port <= udp_src_port;
        udp_header.dest_port <= udp_dest_port;
	      // the UDP-level datagram has a length of - data pixels + RTP header
	      // (16 bytes with 1 CSRC) + RTP payload header (8 bytes for 1 line)
	      // + UDP header (8 bytes)
        udp_header.length <= bend_length_l1 + 'd16 + 'd8 + 'd8;
		  end
    end
  end

  always @(posedge aclk) begin
    if (!aresetn) begin
      ip_hdr_sum_r <= 'h0;
      ip_header.hdr_checksum <= 'h0;
    end else begin
      if (udp_ip_transm_state == ETH_HDR) begin
        if (counter_eth_hdr_transm == 0) begin
          ip_hdr_sum_r <= {ip_header.version,ip_header.ihl,ip_header.tos} + ip_header.total_length + ip_header.identification + {ip_header.pause,
                        ip_header.df,ip_header.mf,ip_header.fragment_offset} + {ip_header.ttl,ip_header.protocol} + ip_header.source_address[31:16] +
                        ip_header.source_address[15:0] + ip_header.dest_address[31:16] + ip_header.dest_address[15:0];
          ip_header.hdr_checksum <= ip_header.hdr_checksum;
        end else begin
          ip_hdr_sum_r <= ip_hdr_sum_r;
          ip_header.hdr_checksum <= ~(ip_hdr_sum_r[31:16] + ip_hdr_sum_r[15:0]);
        end
      end
    end
  end

  always @(*) begin
    case (udp_ip_transm_state)
      IDLE_TRANSM: begin
        udp_ip_transm_state_next <= (can_start_to_m_axis) ? ETH_HDR : IDLE_TRANSM;
      end
      ETH_HDR: begin
        udp_ip_transm_state_next <= (end_of_eth_hdr) ? IP_HDR : ETH_HDR;
      end
      IP_HDR: begin
        udp_ip_transm_state_next <= (end_of_ip_hdr) ? UDP_HDR : IP_HDR;
      end
      UDP_HDR: begin
        udp_ip_transm_state_next <= (end_of_udp_hdr) ? RTP_HDR : UDP_HDR;
      end
      RTP_HDR: begin
        udp_ip_transm_state_next <= (end_of_rtp_hdr) ? PAYLOAD_TRANSM : RTP_HDR;
      end
      PAYLOAD_TRANSM: begin
        udp_ip_transm_state_next <= (end_of_payload_tr) ? IDLE_TRANSM : PAYLOAD_TRANSM;
      end
      default: begin
        udp_ip_transm_state_next <= IDLE_TRANSM; 
      end
    endcase
  end

  rtp_engine_regmap #(
    .VERSION (VERSION)
  ) i_regmap (
    .dest_addr_hb (dest_addr_hb),
    .dest_addr_lb (dest_addr_lb),
    .source_addr_hb (source_addr_hb),
    .source_addr_lb (source_addr_lb),
    .src_ip_addr (src_ip_addr),
    .dest_ip_addr (dest_ip_addr),
    .ip_qos (ip_qos),
    .udp_src_port (udp_src_port),
    .udp_dest_port (udp_dest_port),
    .num_lines (num_lines),
    .num_px_p_line (num_px_p_line),
    .custom_timestamp (custom_timestamp),
    .custom_timestamp_96b (custom_timestamp_96b),
    .timestamp_s_eof (timestamp_s_eof),
    .timestamp_network_pwm_genval (timestamp_network_pwm_genval),
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
      .DEPTH (32768),
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
