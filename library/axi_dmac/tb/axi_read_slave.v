// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2018-2023 Analog Devices, Inc. All rights reserved.
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

module axi_read_slave #(
  parameter DATA_WIDTH = 32,
  parameter READ_ACCEPTANCE = 4,
  parameter MIN_LATENCY = 48,
  parameter MAX_LATENCY = 48
) (
  input clk,
  input reset,

  input arvalid,
  output arready,
  input [31:0] araddr,
  input [7:0] arlen,
  input [2:0] arsize,
  input [1:0] arburst,
  input [2:0] arprot,
  input [3:0] arcache,

  output rvalid,
  input rready,
  output [DATA_WIDTH-1:0] rdata,
  output [1:0] rresp,
  output rlast
);

  reg [DATA_WIDTH-1:0] data = 'h00;

  wire [31:0] beat_addr;

  assign rresp = 2'b00;
  assign rdata = data;

  always @(*) begin: gen_data
    integer i;
    for (i = 0; i < DATA_WIDTH; i = i + 8) begin
      data[i+:8] <= beat_addr[7:0] + i / 8;
    end
  end

  axi_slave #(
    .DATA_WIDTH(DATA_WIDTH),
    .ACCEPTANCE(READ_ACCEPTANCE),
    .MIN_LATENCY(MIN_LATENCY),
    .MAX_LATENCY(MAX_LATENCY)
  ) i_axi_slave (
    .clk(clk),
    .reset(reset),

    .valid(arvalid),
    .ready(arready),
    .addr(araddr),
    .len(arlen),
    .size(arsize),
    .burst(arburst),
    .prot(arprot),
    .cache(arcache),

    .beat_stb(rvalid),
    .beat_ack(rvalid & rready),
    .beat_last(rlast),
    .beat_addr(beat_addr));

endmodule
