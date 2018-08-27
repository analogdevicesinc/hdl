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

/*
 * Resize the data width between the source interface and the burst memory
 * if necessary.
 */

`timescale 1ns/100ps

module axi_dmac_resize_src #(
  parameter DATA_WIDTH_SRC = 64,
  parameter DATA_WIDTH_MEM = 64
) (
  input clk,
  input reset,

  input src_data_valid,
  input [DATA_WIDTH_SRC-1:0] src_data,
  input src_data_last,

  output mem_data_valid,
  output [DATA_WIDTH_MEM-1:0] mem_data,
  output mem_data_last
);

generate if (DATA_WIDTH_SRC == DATA_WIDTH_MEM)  begin
  assign mem_data_valid = src_data_valid;
  assign mem_data = src_data;
  assign mem_data_last = src_data_last;
end else begin

  localparam RATIO = DATA_WIDTH_MEM / DATA_WIDTH_SRC;

  reg [RATIO-1:0] mask = 'h1;
  reg valid = 1'b0;
  reg last = 1'b0;
  reg [DATA_WIDTH_MEM-1:0] data = 'h0;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      valid <= 1'b0;
      mask <= 'h1;
    end else if (src_data_valid == 1'b1) begin
      valid <= mask[RATIO-1] || src_data_last;
      if (src_data_last) begin
        mask <= 'h1;
      end else begin
        mask <= {mask[RATIO-2:0],mask[RATIO-1]};
      end
    end else begin
      valid <= 1'b0;
    end
  end

  integer i;

  always @(posedge clk) begin
    for (i = 0; i < RATIO; i = i+1) begin
      if (mask[i] == 1'b1) begin
        data[i*DATA_WIDTH_SRC+:DATA_WIDTH_SRC] <= src_data;
      end
    end
    last <= src_data_last;
  end

  assign mem_data_valid = valid;
  assign mem_data = data;
  assign mem_data_last = last;

end endgenerate

endmodule
