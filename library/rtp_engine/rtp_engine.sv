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
`timescale 1ns/100ps

module rtp_engine #(
  parameter         S_TDATA_WIDTH = 64,
  parameter         M_TDATA_WIDTH = 64,
  parameter         M_TKEEP_WIDTH = M_TDATA_WIDTH/8,
  parameter         SSRC_ID = 0
) (

  input                           aclk,
  input                           aresetn,

  /* AXI stream slave interface */

  input                           s_axis_tvalid,
  input  [(S_TDATA_WIDTH-1):0]    s_axis_tdata,
  input                           s_axis_tlast,
  output                          s_axis_tready,

  /* AXI stream master interface */

  output                          m_axis_tvalid,
  output  [(M_TDATA_WIDTH-1):0]   m_axis_tdata,
  output                          m_axis_tlast,
  input                           m_axis_tready,
  output  [(M_TKEEP_WIDTH-1):0]   m_axis_tkeep,

  /* AXI4 control interface */

  input                          s_axi_aclk,
  input                          s_axi_aresetn,
  input                          s_axi_awvalid,
  input   [15:0]                 s_axi_awaddr,
  input   [ 2:0]                 s_axi_awprot,
  output                         s_axi_awready,
  input                          s_axi_wvalid,
  input   [31:0]                 s_axi_wdata,
  input   [ 3:0]                 s_axi_wstrb,
  output                         s_axi_wready,
  output                         s_axi_bvalid,
  output  [ 1:0]                 s_axi_bresp,
  input                          s_axi_bready,
  input                          s_axi_arvalid,
  input   [15:0]                 s_axi_araddr,
  input   [ 2:0]                 s_axi_arprot,
  output                         s_axi_arready,
  output                         s_axi_rvalid,
  output  [ 1:0]                 s_axi_rresp,
  output  [31:0]                 s_axi_rdata,
  input                          s_axi_rready
);

  /* internal AXI4-lite signals */
  wire                       up_clk;
  wire                       up_rstn;
  wire                       up_rreq_s;
  wire                       up_wack_s;
  wire                       up_rack_s;
  wire [13:0]                up_raddr_s;
  wire [31:0]                up_rdata_s;
  wire                       up_wreq_s;
  wire [13:0]                up_waddr_s;
  wire [31:0]                up_wdata_s;

  wire                       areset;

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;
  assign areset = ~aresetn;

  localparam INTERV_FRAME = 30;
  localparam RTP_CLK = 90000;
  localparam RTP_INCREASE = RTP_CLK/INTERV_FRAME;

  import rtp_engine_package::*;
  eth_frame_header eth_header; // instance of the Ethernet header
  ip_pckt_header ip_header; // instance of IPv4 header
  udp_datagram_header udp_header; // instance of UDP header
  rtp_pckt_header rtp_header; // instance of RTP header
  rtp_payload_header rtp_pd_header; // instance of RTP payload header

  // AXIS Slave/Master-related regs/wires
  reg                        s_axis_tready_r = 1'b0;
  reg  [(M_TDATA_WIDTH-1):0] m_axis_tdata_r = 'h0;
  reg                        m_axis_tready_r = 'h0;
  reg  [(M_TKEEP_WIDTH-1):0] m_axis_tkeep_r = 'h0;

  reg                        m_axis_cam_tvalid_r = 1'b0;
  wire                       m_axis_cam_tvalid;
  wire [(M_TDATA_WIDTH-1):0] m_axis_cam_tdata;
  wire [(M_TDATA_WIDTH-1):0] m_axis_tdata_fin;
  reg                        penultimate_sample = 1'b0;
  reg                        last_sample = 1'b0;
  wire                       m_axis_cam_tlast;
  wire                       m_axis_tlast_cam;
  wire                       m_axis_cam_tready;
  reg  [(M_TDATA_WIDTH-1):0] save_data = 'h0;

  // IPv4 header checksum-related reg
  reg  [31:0]                ip_hdr_sum_r = 'h0;

  // RTP header timestamp-related reg
  reg  [31:0]                rtp_header_timestamp_r;

  // line and frame-related regs
  reg  [15:0]                counter_lines = 'h0;
  reg                        end_of_frame = 1'b0;
  reg                        end_of_frame_r = 1'b0;

  // RTP payload header extended sequence number
  reg  [15:0]                ext_seq_num_r = 'h0;

  // rtp_pd_header configurable length field
  wire [15:0]                length_l;

  // state machine controls
  reg  [1:0]                 counter_ip_hdr_transm = 'h0;
  reg                        counter_eth_hdr_transm = 1'b0;
  reg                        counter_rtp_hdr_transm = 'h0;
  reg                        counter_data_transm = 'h0;
  wire                       can_start_to_m_axis; // start of transfer indicator
  wire                       init_tready_post_header;
  wire                       end_of_eth_hdr;
  wire                       end_of_ip_hdr;
  wire                       end_of_udp_hdr;
  wire                       end_of_rtp_hdr;
  wire                       end_of_payload_tr;

  // configurable fields-related wires
  wire [15:0]                dest_addr_hb;
  wire [31:0]                dest_addr_lb;
  wire [15:0]                source_addr_hb;
  wire [31:0]                source_addr_lb;
  wire [47:0]                dest_addr;
  wire [47:0]                source_addr;
  wire [31:0]                src_ip_addr;
  wire [31:0]                dest_ip_addr;
  wire [7:0]                 ip_qos;
  wire [11:0]                num_lines;
  wire [11:0]                num_px_p_line;
  wire [15:0]                udp_src_port;
  wire [15:0]                udp_dest_port;

  // configurable format handling
  wire                       convert_uyvy_to_yuyv;

  state_rtp_transm           rtp_transm_state;
  state_rtp_transm           rtp_transm_state_next;

  assign eth_header.frame_type = 'h0800;
  assign ip_header.version = 'h4;
  assign ip_header.ihl = 'h5;
  //assign ip_header.tos = // 3 bits for type of service
  //assign ip_header.total_length = // total length at l3 - data and header bytes
  assign ip_header.total_length = udp_header.length + 'd20;
  assign ip_header.identification = 'h0; // 0 if fragmentation is not made
  assign ip_header.pause = 0; // 0 bit that is reserved from flags for fragmentation
  assign ip_header.df = 1; // don't fragment
  assign ip_header.mf = 0; // more fragments of the datagram
  assign ip_header.fragment_offset = 'h0; // fragment offset of the datagram
  assign ip_header.ttl = 'hFF; // number of hops or 0 if the packet is dropped
  assign ip_header.protocol = 'd17; // UDP - 17
  // assign ip_header.hdr_checksum = header checksum with 1 complement to the header
  // assign ip_header.source_address = // source IP address
  // assign ip_header.dest_address = // destination IP address

  assign rtp_header.version = 'h2; //rtp version 2 for rfc3550 - used as is in rfc 4175 for uncrompressed video
  assign rtp_header.padding = 'h0; //no padding at the end of packets
  assign rtp_header.extension = 'h0; //no extensions to the header
  assign rtp_header.csrc_count = 'h1; //1 source from 8 cameras in the system
  assign rtp_header.csrc_field1 = 'h0;
  /* assign rtp_header.marker =  for last packet in frame in this case of
   * progressive scan video
   */
  assign rtp_header.payload_type = 'd96; //uncrompressed video

  assign rtp_header.timestamp =  rtp_header_timestamp_r;
  assign rtp_header.ssrc_field = SSRC_ID;

  assign length_l = num_px_p_line << 1;
  assign rtp_pd_header.length_l1 = num_px_p_line << 1; // number of bytes from the scanned line (1 line/packed design) - number of pixels * 2 for this YUV422 format
  assign rtp_pd_header.field_identif_l1 = 'h0; // 0 for progressive video - field identification
  assign rtp_pd_header.offset_l1 = 'h0; // offset 0 - only 1 line/packet
  assign rtp_pd_header.continuation_l1 = 'h0; // continuation is 0 - only 1 line/packet
  assign rtp_pd_header.line_num_l1 = counter_lines; // number of scanned line in the current frame

  // assign udp_header.source_port = // source UDP port
  // assign udp_header.dest_port = // dest UDP port
  // assign udp_header.source_port = source_port;
  // assign udp_header.dest_port = dest_port;
  // assign udp_header.length = // UDP datagram length - header + data
  // assign udp_header.length = data_len + 'd8;
  assign udp_header.checksum = 0; // checksum calculated using header + data + pseudo-header IPv4 - 0 in this design as it is an optional field

  always @(posedge aclk) begin
    if (!aresetn) begin
      rtp_transm_state <= IDLE_TRANSM;
    end else begin
      rtp_transm_state <= rtp_transm_state_next;
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
      if (end_of_payload_tr) begin
        ext_seq_num_r <= ext_seq_num_r + 1;
      end else if (ext_seq_num_r == 'hFFFF) begin
        ext_seq_num_r <= 'h0;
      end else begin
        ext_seq_num_r <= ext_seq_num_r;
      end
    end
  end

  assign rtp_pd_header.ext_seq_num = {ext_seq_num_r[7:0],ext_seq_num_r[15:8]};

  always @(posedge aclk) begin
    if (!aresetn) begin
      end_of_frame <= 1'b0;
      end_of_frame_r <= 1'b0;
    end else begin
      if (counter_lines == (num_lines-1)) begin
        end_of_frame <= 1'b1;
      end
      end_of_frame_r <= end_of_frame;
    end
  end

  always @(posedge aclk) begin
    if (!aresetn) begin
      m_axis_tdata_r <= 'h0;
      m_axis_tkeep_r <= 'h0;
      counter_eth_hdr_transm <= 'h0;
      counter_ip_hdr_transm <= 'h0;
      save_data <= 'h0;
    end else begin
      if (rtp_transm_state == ETH_HDR) begin
        if (counter_eth_hdr_transm == 0 && m_axis_tready) begin
          m_axis_tdata_r <= {eth_header.dest_addr,eth_header.source_addr[47:32]};
          counter_eth_hdr_transm <= counter_eth_hdr_transm + 1;
          m_axis_tkeep_r <= 'hFF;
        end else if (counter_eth_hdr_transm == 1 && m_axis_tready) begin
          m_axis_tdata_r <= {eth_header.source_addr[31:0],eth_header.frame_type,ip_header.version,ip_header.ihl,ip_header.tos};
          counter_eth_hdr_transm <= 0;
          m_axis_tkeep_r <= 'hFF;
        end
      end else if (rtp_transm_state == IP_HDR) begin
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
      end else if (rtp_transm_state == UDP_HDR) begin
          m_axis_tdata_r <= {udp_header.checksum,rtp_header.version,rtp_header.padding,rtp_header.extension,rtp_header.csrc_count,rtp_header.marker,rtp_header.payload_type,rtp_header.sequence_nr,rtp_header.timestamp[31:16]};
          m_axis_tkeep_r <= 'hFF;
      end else if (rtp_transm_state == RTP_HDR) begin
        if (counter_rtp_hdr_transm == 0 && m_axis_tready) begin
          m_axis_tdata_r <= {rtp_header.timestamp[15:0],rtp_header.ssrc_field,rtp_header.csrc_field1[31:16]};
          counter_rtp_hdr_transm <= counter_rtp_hdr_transm + 1;
          m_axis_tkeep_r <= 'hFF;
        end else if (counter_rtp_hdr_transm == 1 && m_axis_tready) begin
          m_axis_tdata_r <= {rtp_header.csrc_field1[15:0],rtp_pd_header.ext_seq_num,rtp_pd_header.length_l1,rtp_pd_header.field_identif_l1,rtp_pd_header.line_num_l1};
          counter_rtp_hdr_transm <= 'h0;
          m_axis_tkeep_r <= 'hFF;
        end
      end else if (rtp_transm_state == PAYLOAD_TRANSM) begin
        if (counter_data_transm == 0 && !last_sample && m_axis_tready) begin
          m_axis_tdata_r <= {rtp_pd_header.continuation_l1,rtp_pd_header.offset_l1,m_axis_tdata_fin[63:16]};
          counter_data_transm <= counter_data_transm + 1;
          save_data <= m_axis_tdata_fin;
          m_axis_tkeep_r <= 'hFF;
        end
        if (counter_data_transm == 1 && m_axis_tready) begin
          save_data <= m_axis_tdata_fin;
          if (!penultimate_sample) begin
            m_axis_tdata_r <= {save_data[15:0],m_axis_tdata_fin[63:16]};
            m_axis_tkeep_r <= 'hFF;
          end else begin
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
      if (rtp_transm_state == PAYLOAD_TRANSM && m_axis_cam_tvalid_r && m_axis_tready) begin
        if (counter_lines != num_lines) begin
          if (penultimate_sample) begin
            counter_lines <= counter_lines + 1;
          end
        end
      end else if (rtp_transm_state == IDLE_TRANSM) begin
        if (counter_lines == num_lines) begin
          counter_lines <= 'h0;
        end
      end
    end
  end

  always @(posedge aclk) begin
    if (!aresetn) begin
      m_axis_cam_tvalid_r <= 1'b0;
    end else begin
      if (rtp_transm_state == ETH_HDR || rtp_transm_state == IP_HDR || rtp_transm_state == UDP_HDR || rtp_transm_state == RTP_HDR) begin
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
      penultimate_sample <= 1'b0;
      last_sample <= 1'b0;
    end else begin
      penultimate_sample <= m_axis_tlast_cam;
      last_sample <= penultimate_sample;
    end
  end

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
        udp_header.length <= length_l + 'd16 + 'd8 + 'd8;
      end
    end
  end

  always @(posedge aclk) begin
    if (!aresetn) begin
      ip_hdr_sum_r <= 'h0;
      ip_header.hdr_checksum <= 'h0;
    end else begin
      if (rtp_transm_state == ETH_HDR) begin
        if (counter_eth_hdr_transm == 0) begin
          ip_hdr_sum_r <= {ip_header.version,ip_header.ihl,ip_header.tos} + ip_header.total_length + ip_header.identification + {ip_header.pause,
                        ip_header.df,ip_header.mf,ip_header.fragment_offset} + {ip_header.ttl,ip_header.protocol} + ip_header.source_address[31:16] +
                        ip_header.source_address[15:0] + ip_header.dest_address[31:16] + ip_header.dest_address[15:0];
        end else begin
          ip_header.hdr_checksum <= ~(ip_hdr_sum_r[31:16] + ip_hdr_sum_r[15:0]);
        end
      end
    end
  end

  assign negedge_eof = ~end_of_frame & end_of_frame_r;
  assign m_axis_tdata_fin = (convert_uyvy_to_yuyv) ? {m_axis_cam_tdata[7:0],m_axis_cam_tdata[15:8],m_axis_cam_tdata[23:16],m_axis_cam_tdata[31:24],m_axis_cam_tdata[39:32],m_axis_cam_tdata[47:40],m_axis_cam_tdata[55:48],m_axis_cam_tdata[63:56]} : {m_axis_cam_tdata[15:0],m_axis_cam_tdata[31:16],m_axis_cam_tdata[47:32],m_axis_cam_tdata[63:48]};
  assign m_axis_tlast_cam = (m_axis_cam_tlast & m_axis_cam_tvalid & m_axis_tready) ? 1'b1 : 1'b0;

  assign init_tready_post_header = (rtp_transm_state == PAYLOAD_TRANSM) ? 1'b1 : 1'b0;
  assign m_axis_cam_tready = (m_axis_tready & init_tready_post_header) ? 1'b1 : 1'b0;
  assign m_axis_tvalid = m_axis_cam_tvalid_r | last_sample;
  assign m_axis_tlast = last_sample;

  assign m_axis_tkeep = m_axis_tkeep_r;
  assign m_axis_tdata = {m_axis_tdata_r[7:0],m_axis_tdata_r[15:8],m_axis_tdata_r[23:16],m_axis_tdata_r[31:24],m_axis_tdata_r[39:32],m_axis_tdata_r[47:40],m_axis_tdata_r[55:48],m_axis_tdata_r[63:56]};

  assign can_start_to_m_axis = (m_axis_cam_tvalid && m_axis_tready) ? 1'b1 : 1'b0;

  assign end_of_eth_hdr = (counter_eth_hdr_transm == 1 && m_axis_tready) ? 1'b1 : 1'b0;
  assign end_of_ip_hdr = (counter_ip_hdr_transm == 2 && m_axis_tready) ? 1'b1 : 1'b0;
  assign end_of_udp_hdr = (rtp_transm_state == UDP_HDR && m_axis_tready) ? 1'b1 : 1'b0;
  assign end_of_rtp_hdr = (counter_rtp_hdr_transm == 1 && m_axis_tready) ? 1'b1 : 1'b0;
  assign end_of_payload_tr = last_sample;

  always @(*) begin
    case (rtp_transm_state)
      IDLE_TRANSM: begin
        rtp_transm_state_next <= (can_start_to_m_axis) ? ETH_HDR : IDLE_TRANSM;
      end
      ETH_HDR: begin
        rtp_transm_state_next <= (end_of_eth_hdr) ? IP_HDR : ETH_HDR;
      end
      IP_HDR: begin
        rtp_transm_state_next <= (end_of_ip_hdr) ? UDP_HDR : IP_HDR;
      end
      UDP_HDR: begin
        rtp_transm_state_next <= (end_of_udp_hdr) ? RTP_HDR : UDP_HDR;
      end
      RTP_HDR: begin
        rtp_transm_state_next <= (end_of_rtp_hdr) ? PAYLOAD_TRANSM : RTP_HDR;
      end
      PAYLOAD_TRANSM: begin
        rtp_transm_state_next <= (end_of_payload_tr) ? IDLE_TRANSM : PAYLOAD_TRANSM;
      end
      default: begin
        rtp_transm_state_next <= IDLE_TRANSM;
      end
    endcase
  end

  rtp_engine_regmap i_regmap (
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
    .convert_uyvy_to_yuyv (convert_uyvy_to_yuyv),
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
    .DEST_ENABLE (0),
    .USER_ENABLE (0),
    .FRAME_FIFO (1))
  storage_cam_data (
    .clk (aclk),
    .rst (areset),
    .s_axis_tdata (s_axis_tdata),
    .s_axis_tvalid (s_axis_tvalid),
    .s_axis_tready (s_axis_tready),
    .s_axis_tlast (s_axis_tlast),
    .m_axis_tdata (m_axis_cam_tdata),
    .m_axis_tvalid (m_axis_cam_tvalid),
    .m_axis_tready (m_axis_cam_tready),
    .m_axis_tlast (m_axis_cam_tlast));

endmodule
