// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
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

`include "macro_definitions.vh"

module ip_header_mask (

  // IPv4 header
  input  wire           ip_version,
  input  wire           ip_header_length,
  input  wire           ip_type_of_service,
  input  wire           ip_total_length,
  input  wire           ip_identification,
  input  wire           ip_flags,
  input  wire           ip_fragment_offset,
  input  wire           ip_time_to_live,
  input  wire           ip_protocol,
  input  wire           ip_header_checksum,
  input  wire           ip_source_IP_address,
  input  wire           ip_destination_IP_address,

  // Output
  output wire [160-1:0] header_mask
);

  `HTOND(16)
  `HTOND(32)

  assign header_mask = {
    htond_32({32{ip_destination_IP_address}}),
    htond_32({32{ip_source_IP_address}}),
    htond_16({16{ip_header_checksum}}),
    htond_16({{8{ip_time_to_live}}, {8{ip_protocol}}}),
    htond_16({{3{ip_flags}}, {13{ip_fragment_offset}}}),
    htond_16({16{ip_identification}}),
    htond_16({16{ip_total_length}}),
    htond_16({{4{ip_version}}, {4{ip_header_length}}, {16{ip_type_of_service}}})};

endmodule
