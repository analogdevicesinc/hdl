// ***************************************************************************
// ***************************************************************************
// Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
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

module axi_write_slave #(
  parameter DATA_WIDTH = 32,
  parameter WRITE_ACCEPTANCE = 3
) (
  input clk,
  input reset,

  input awvalid,
  output awready,
  input [31:0] awaddr,
  input [7:0] awlen,
  input [2:0] awsize,
  input [1:0] awburst,
  input [2:0] awprot,
  input [3:0] awcache,

  input wvalid,
  output wready,
  input [DATA_WIDTH-1:0] wdata,
  input [DATA_WIDTH/8-1:0] wstrb,
  input wlast,

  output reg bvalid,
  input bready,
  output [1:0] bresp
);

wire beat_last;

axi_slave #(
  .ACCEPTANCE(WRITE_ACCEPTANCE)
) i_axi_slave (
  .clk(clk),
  .reset(reset),

  .valid(awvalid),
  .ready(awready),
  .addr(awaddr),
  .len(awlen),
  .size(awsize),
  .burst(awburst),
  .prot(awprot),
  .cache(awcache),

  .beat_stb(wready),
  .beat_ack(wvalid & wready),
  .beat_last(beat_last)
);

reg [4:0] resp_count = 'h00;
wire [4:0] resp_count_next;
reg [DATA_WIDTH-1:0] data_cmp = 'h00;
reg failed = 'b0;

assign bresp = 2'b00;

wire resp_count_dec = bvalid & bready;
wire resp_count_inc = wvalid & wready & beat_last;
assign resp_count_next = resp_count - resp_count_dec + resp_count_inc;

always @(posedge clk) begin
  if (reset == 1'b1) begin
    resp_count <= 'h00;
  end else begin
    resp_count <= resp_count - resp_count_dec + resp_count_inc;
  end
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    bvalid <= 1'b0;
  end else if (bvalid == 1'b0 || bready == 1'b1) begin
    if (resp_count_next != 'h00) begin
      bvalid <= {$random} % 4 == 0;
    end else begin
      bvalid <= 1'b0;
    end
  end
end

always @(posedge clk) begin
  if (reset) begin
    data_cmp <= 'h00;
    failed <= 'b0;
  end else if (wvalid & wready) begin
    if (data_cmp !== wdata) begin
      failed <= 1'b1;
    end
    data_cmp <= data_cmp + 'h4;
  end
end

endmodule
