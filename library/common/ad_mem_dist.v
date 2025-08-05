// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

module ad_mem_dist #(
  parameter RAM_WIDTH = 32,
  parameter RAM_ADDR_BITS = 4,
  parameter REGISTERED_OUTPUT = 1
)(
  output wire  [RAM_WIDTH-1:0]      rd_data,
  input  wire                       clk,
  input  wire                       wr_en,
  input  wire  [RAM_ADDR_BITS-1:0]  wr_addr,
  input  wire  [RAM_WIDTH-1:0]      wr_data,
  input  wire  [RAM_ADDR_BITS-1:0]  rd_addr
);

  (* ram_style="distributed" *)
  reg [RAM_WIDTH-1:0] ram [(2**RAM_ADDR_BITS)-1:0];

  reg [RAM_WIDTH-1:0] rd_data_s;

  always @(posedge clk)
    if (wr_en)
      ram[wr_addr] <= wr_data;

  generate if (REGISTERED_OUTPUT) begin
    always @(posedge clk) begin
      rd_data_s <= ram[rd_addr];
    end
  end else begin
    always @(*) begin
      rd_data_s = ram[rd_addr];
    end
  end
  endgenerate

  assign rd_data = rd_data_s;

endmodule
