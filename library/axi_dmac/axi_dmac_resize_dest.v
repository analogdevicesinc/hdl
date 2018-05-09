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

module axi_dmac_resize_dest #(
  parameter DATA_WIDTH_DEST = 64,
  parameter DATA_WIDTH_MEM = 64
) (
  input clk,
  input reset,

  input mem_data_valid,
  output mem_data_ready,
  input [DATA_WIDTH_MEM-1:0] mem_data,
  input mem_data_last,

  output dest_data_valid,
  input dest_data_ready,
  output [DATA_WIDTH_DEST-1:0] dest_data,
  output dest_data_last
);

/*
 * Resize the data width between the burst memory and the destination interface
 * if necessary.
 */

generate if (DATA_WIDTH_DEST == DATA_WIDTH_MEM)  begin
  assign dest_data_valid = mem_data_valid;
  assign dest_data = mem_data;
  assign dest_data_last = mem_data_last;
  assign mem_data_ready = dest_data_ready;
end else begin

  localparam RATIO = DATA_WIDTH_MEM / DATA_WIDTH_DEST;

  reg [$clog2(RATIO)-1:0] count = 'h0;
  reg valid = 1'b0;
  reg [RATIO-1:0] last = 'h0;
  reg [DATA_WIDTH_MEM-1:0] data = 'h0;

  wire last_beat;

  assign last_beat = count == RATIO - 1;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      valid <= 1'b0;
    end else if (mem_data_valid == 1'b1) begin
      valid <= 1'b1;
    end else if (last_beat == 1'b1 && dest_data_ready == 1'b1) begin
      valid <= 1'b0;
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      count <= 'h0;
    end else if (dest_data_ready == 1'b1 && dest_data_valid == 1'b1) begin
      count <= count + 1;
    end
  end

  assign mem_data_ready = ~valid | (dest_data_ready & last_beat);

  always @(posedge clk) begin
    if (mem_data_ready == 1'b1) begin
      data <= mem_data;
      last <= {mem_data_last,{RATIO-1{1'b0}}};
    end else if (dest_data_ready == 1'b1) begin
      data[DATA_WIDTH_MEM-DATA_WIDTH_DEST-1:0] <= data[DATA_WIDTH_MEM-1:DATA_WIDTH_DEST];
      last[RATIO-2:0] <= last[RATIO-1:1];
    end
  end

  assign dest_data_valid = valid;
  assign dest_data = data[DATA_WIDTH_DEST-1:0];
  assign dest_data_last = last[0];

end endgenerate

endmodule
