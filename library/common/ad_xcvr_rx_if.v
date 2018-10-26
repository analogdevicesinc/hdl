// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

module ad_xcvr_rx_if #(
  parameter OCTETS_PER_BEAT = 4,
  parameter DW = OCTETS_PER_BEAT * 8
)(

  // jesd interface

  input rx_clk,
  input [OCTETS_PER_BEAT-1:0] rx_ip_sof,
  input [DW-1:0] rx_ip_data,
  output reg rx_sof,
  output reg [DW-1:0] rx_data);

  // rx_ip_sof:
  // The input beat may contain more than one frame per clock, a sof bit is set for
  // each frame.
  // Every bit that corresponds to a octet that is at the beginning of a frame
  // the bit is set. E.g for OCTETS_PER_BEAT = 4
  //   if F=1 all bits are set,
  //      F=2 sof=4'b0101,
  //      F=4 sof=4'b0001

  //
  // rx_ip_data:
  // The temporal ordering of the octets is from LSB to MSB,
  // this means the octet placed in the lowest 8 bits was received first,
  // the octet placed in the highest 8 bits was received last.

  // internal registers

  reg     [DW-1:0]  rx_ip_data_d = 'd0;
  reg     [OCTETS_PER_BEAT-1:0]  rx_ip_sof_hold = 'd0;
  reg     [OCTETS_PER_BEAT-1:0]  rx_ip_sof_d = 'd0;

  always @(posedge rx_clk) begin
    rx_ip_data_d <= rx_ip_data;
    rx_ip_sof_d <= rx_ip_sof;
    if (|rx_ip_sof) begin
      rx_ip_sof_hold <= rx_ip_sof;
    end
    rx_sof <= |rx_ip_sof_d;
  end

  wire [OCTETS_PER_BEAT*DW-1:0] rx_data_s;
  assign rx_data_s[0 +: DW] = rx_ip_data;
  generate
    genvar i;
    for (i = 1; i < OCTETS_PER_BEAT; i = i + 1) begin : g_rx_data_opt
      assign rx_data_s[i*DW +: DW] = {rx_ip_data[i*8-1 : 0], rx_ip_data_d[DW-1 : i*8]};
    end
  endgenerate

  integer j;
  always @(posedge rx_clk) begin
    for (j = OCTETS_PER_BEAT-1; j >= 0; j = j - 1) begin
      if (rx_ip_sof_hold[j] == 1'b1) begin
        rx_data <= rx_data_s[j*DW +: DW];
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
