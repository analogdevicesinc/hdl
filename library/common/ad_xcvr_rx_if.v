// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
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

module ad_xcvr_rx_if #(
  parameter OCTETS_PER_BEAT = 4,
  parameter DW = OCTETS_PER_BEAT * 8
) (

  // jesd interface

  input rx_clk,
  input [OCTETS_PER_BEAT-1:0] rx_ip_sof,
  input [DW-1:0] rx_ip_data,
  output reg rx_sof,
  output reg [DW-1:0] rx_data
);

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

  localparam HALF_OCTETS_PER_BEAT = OCTETS_PER_BEAT/2;

  // internal registers

  reg     [DW-1:0]               rx_ip_data_d = 'd0;
  reg     [OCTETS_PER_BEAT-1:0]  rx_ip_sof_hold_dly = 'd0;
  reg     [OCTETS_PER_BEAT-1:0]  rx_ip_sof_hold;
  reg     [OCTETS_PER_BEAT-1:0]  rx_ip_sof_d = 'd0;
  reg                            rx_ip_sof_hold_low = 1'b0;
  reg                            rx_ip_sof_hold_high = 1'b0;

  always @(posedge rx_clk) begin
    rx_ip_data_d <= rx_ip_data;
    rx_ip_sof_d <= rx_ip_sof;
    if (|rx_ip_sof_d) begin
      rx_ip_sof_hold_dly <= rx_ip_sof_d;
    end
    rx_sof <= |rx_ip_sof_d;
  end

  // rx_ip_sof_hold will always have a value greater than 1, except for immediately
  // after startup.
  // If rx_ip_sof_d is 0, then rx_ip_sof_hold will keep its older value,
  // stored in the rx_ip_sof_hold_dly register since rx_ip_sof_hold is
  // combinational.
  always @(*) begin
    if (|rx_ip_sof_d) begin
      rx_ip_sof_hold = rx_ip_sof_d;
    end else begin
      rx_ip_sof_hold = rx_ip_sof_hold_dly;
    end
  end

  wire [OCTETS_PER_BEAT*DW-1:0] rx_data_s;
  assign rx_data_s[0 +: DW] = rx_ip_data;
  generate
    genvar i;
    for (i = 1; i < OCTETS_PER_BEAT; i = i + 1) begin : g_rx_data_opt
      assign rx_data_s[i*DW +: DW] = {rx_ip_data[i*8-1 : 0], rx_ip_data_d[DW-1 : i*8]};
    end
  endgenerate

  // The logic to detect the first start-of-frame is split into two parts:
  // this next process is for the lower half of rx_data_s, while the
  // process after it is for the higher part of rx_data_s.
  // This was done to shorten the combinatorial paths going to rx_data_low
  // and rx_data_high.
  reg [DW-1:0] rx_data_low;
  integer j;
  always @(posedge rx_clk) begin
    rx_ip_sof_hold_low <= 1'b0;
    for (j = HALF_OCTETS_PER_BEAT-1; j >= 0; j = j - 1) begin
      if (rx_ip_sof_hold[j] == 1'b1) begin
        rx_data_low <= rx_data_s[j*DW +: DW];
        rx_ip_sof_hold_low <= 1'b1;
      end
    end
  end

  reg [DW-1:0] rx_data_high;
  always @(posedge rx_clk) begin
    rx_ip_sof_hold_high <= 1'b0;
    for (j = OCTETS_PER_BEAT-1; j >= HALF_OCTETS_PER_BEAT; j = j - 1) begin
      if (rx_ip_sof_hold[j] == 1'b1) begin
        rx_data_high <= rx_data_s[j*DW +: DW];
        rx_ip_sof_hold_high <= 1'b1;
      end
    end
  end

  // We then establish the correct data, based on which of the two halves
  // had a start-of-frame. If both had a start-of-frame, the low half has
  // priority, since it has older data.
  always @(*) begin
    if (rx_ip_sof_hold_low == 1'b1) begin
      rx_data = rx_data_low;
    end else begin
      if (rx_ip_sof_hold_high == 1'b1) begin
        rx_data = rx_data_high;
      end else begin
        // We should not ever reach this branch since there should be a
        // start-of-frame at least on one side.
        // But it was added to prevent the creation of latches on rx_data.
        rx_data = rx_data_low;
      end
    end
  end

endmodule
