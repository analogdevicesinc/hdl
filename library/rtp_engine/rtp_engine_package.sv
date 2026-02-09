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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

package rtp_engine_package;

  typedef struct packed {
    logic [47:0]  dest_addr;
    logic [47:0]  source_addr;
    logic [15:0]  frame_type;
  } eth_frame_header;

  typedef struct packed {
    logic [ 3:0]  version;
    logic [ 3:0]  ihl;
    logic [ 7:0]  tos;
    logic [15:0]  total_length;
    logic [15:0]  identification;
    logic         pause;
    logic         df;
    logic         mf;
    logic [12:0]  fragment_offset;
    logic [ 7:0]  ttl;
    logic [ 7:0]  protocol;
    logic [15:0]  hdr_checksum;
    logic [31:0]  source_address;
    logic [31:0]  dest_address;
  } ip_pckt_header;

  typedef struct packed {
    logic [15:0]  source_port;
    logic [15:0]  dest_port;
    logic [15:0]  length;
    logic [15:0]  checksum;
  } udp_datagram_header;

  typedef struct packed {
    logic [ 1:0]  version;
    logic         padding;
    logic         extension;
    logic [ 3:0]  csrc_count;
    logic         marker;
    logic [ 6:0]  payload_type;
    logic [15:0]  sequence_nr;
    logic [31:0]  timestamp;
    logic [31:0]  ssrc_field; //12 bytes - without csrc sources identifiers
    logic [31:0]  csrc_field1;
  } rtp_pckt_header;

  typedef struct packed {
    logic [15:0]  ext_seq_num;
    logic [15:0]  length_l1; // 48 bits for line in the payload header + 16b - 64b - 8 bytes
    logic         field_identif_l1;
    logic [14:0]  line_num_l1;
    logic         continuation_l1;
    logic [14:0]  offset_l1;
  } rtp_payload_header;

  // total - 14 - eth header
  // 20 ip_hdr
  // 8 udp_hdr
  // 12 or 16 rtp_hdr - 58
  // current design will hardcode the 16 byte-based RTP header that contains an additional CSRC field
  // 8 rtp_pd_hdr - 3848 -> 3906
  // RTP header state include bytes from both RTP header and RTP payload header

  typedef enum logic [2:0] {
    IDLE_TRANSM = 'h0,
    ETH_HDR = 'h1,
    IP_HDR = 'h2,
    UDP_HDR = 'h3,
    PAYLOAD_TRANSM = 'h4,
    RTP_HDR = 'h5} state_udp_ip_transm;
    
endpackage
