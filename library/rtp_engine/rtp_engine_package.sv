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

package rtp_engine_package;

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
  } rtp_pckt_header;

  typedef struct packed {
    logic [15:0]  ext_seq_num;
    logic [15:0]  length_l1; // 48 bits for line in the payload header + 16b - 64b - 8 bytes
    logic         field_identif_l1;
    logic [14:0]  line_num_l1;
    logic         continuation_l1;
    logic [14:0]  offset_l1;
  } rtp_payload_header;

  // total - 12B(RTP_H)+8B(RTP_P_H)+8B(UDP_H)+20B(IPv4 - without options _H) + 14B eth header
  // - 48B header

  typedef enum logic [2:0] {
    IDLE_TRANSM = 'h0,
    HEADER_TRANSM_P1 = 'h1,
    HEADER_TRANSM_P2 = 'h2,
    PD_HEADER_TRANSM = 'h3,
    PAYLOAD_TRANSM = 'h4,
    PAUSE_TRANSM = 'h5} state_rtp_transm;
    
endpackage
