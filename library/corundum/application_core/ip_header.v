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

module ip_header (

  input  wire                         clk,
  input  wire                         rstn,

  // IPv4 header
  input  wire [4-1:0]                 ip_version,
  input  wire [4-1:0]                 ip_header_length,
  input  wire [8-1:0]                 ip_type_of_service,
  output reg  [16-1:0]                ip_total_length,
  input  wire [16-1:0]                ip_identification,
  input  wire [3-1:0]                 ip_flags,
  input  wire [13-1:0]                ip_fragment_offset,
  input  wire [8-1:0]                 ip_time_to_live,
  input  wire [8-1:0]                 ip_protocol,
  output reg  [16-1:0]                ip_header_checksum,
  input  wire [32-1:0]                ip_source_IP_address,
  input  wire [32-1:0]                ip_destination_IP_address,

  input  wire [16-1:0]                payload_length,

  // Output
  output wire [160-1:0]               header
);

  `HTOND(16)
  `HTOND(32)

  reg [32-1:0]                 header_checksum_reg0;
  reg [32-1:0]                 header_checksum_reg1;

  // ip total length calculation
  always @(posedge clk)
  begin
    if (!rstn) begin
      ip_total_length <= 16'h0;
    end else begin
      ip_total_length <= 4*ip_header_length + payload_length;
    end
  end

  // ip header checksum calculation
  always @(posedge clk)
  begin
    if (!rstn) begin
      header_checksum_reg0 <= 'd0;
      header_checksum_reg1 <= 'd0;
      ip_header_checksum <= 'd0;
    end else begin
      header_checksum_reg0 <=
        {16'h0000, {ip_version, ip_header_length, ip_type_of_service}} +
        {16'h0000, ip_total_length} +
        {16'h0000, ip_identification} +
        {16'h0000, {ip_flags, ip_fragment_offset}} +
        {16'h0000, {ip_time_to_live, ip_protocol}} +
        {16'h0000, ip_source_IP_address[31:16]} +
        {16'h0000, ip_source_IP_address[15:0]} +
        {16'h0000, ip_destination_IP_address[31:16]} +
        {16'h0000, ip_destination_IP_address[15:0]};

      header_checksum_reg1 <= header_checksum_reg0[31:16] + header_checksum_reg0[15:0];

      ip_header_checksum <= ~header_checksum_reg1;
    end
  end

  // header concatenation
  assign header = {
    htond_32(ip_destination_IP_address),
    htond_32(ip_source_IP_address),
    htond_16(ip_header_checksum),
    htond_16({ip_time_to_live, ip_protocol}),
    htond_16({ip_flags, ip_fragment_offset}),
    htond_16(ip_identification),
    htond_16(ip_total_length),
    htond_16({ip_version, ip_header_length, ip_type_of_service})};

endmodule
