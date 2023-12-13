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
  input [DATA_WIDTH_MEM/8-1:0] mem_data_strb,

  output dest_data_valid,
  input dest_data_ready,
  output [DATA_WIDTH_DEST-1:0] dest_data,
  output dest_data_last,
  output [DATA_WIDTH_DEST/8-1:0] dest_data_strb
);

  /*
   * Resize the data width between the burst memory and the destination interface
   * if necessary.
   */

  generate if (DATA_WIDTH_DEST == DATA_WIDTH_MEM)  begin
    assign dest_data_valid = mem_data_valid;
    assign dest_data = mem_data;
    assign dest_data_last = mem_data_last;
    assign dest_data_strb = mem_data_strb;
    assign mem_data_ready = dest_data_ready;
  end else begin

    localparam RATIO = DATA_WIDTH_MEM / DATA_WIDTH_DEST;

    reg [$clog2(RATIO)-1:0] count = 'h0;
    reg valid = 1'b0;
    reg [RATIO-1:0] last = 'h0;
    reg [DATA_WIDTH_MEM-1:0] data = 'h0;
    reg [DATA_WIDTH_MEM/8-1:0] strb = {DATA_WIDTH_MEM/8{1'b1}};

    wire last_beat;

    assign last_beat = (count == RATIO - 1) | last[0];

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
        if (last_beat == 1'b1) begin
          count <= 'h0;
        end else begin
          count <= count + 1;
        end
      end
    end

    assign mem_data_ready = ~valid | (dest_data_ready & last_beat);

    integer i;
    always @(posedge clk) begin
      if (mem_data_ready == 1'b1) begin
        data <= mem_data;

        /*
         * Skip those words where strb would be completely zero for the output
         * word. We assume that strb is thermometer encoded (i.e. a certain number
         * of LSBs are 1'b1 followed by all 1'b0 in the MSBs) and by extension
         * that if the first strb bit for a word is zero that means that all strb
         * bits for a word will be zero.
         */
        for (i = 0; i < RATIO-1; i = i + 1) begin
          last[i] <= mem_data_last & ~mem_data_strb[(i+1)*(DATA_WIDTH_MEM/8/RATIO)];
        end
        last[RATIO-1] <= mem_data_last;
        strb <= mem_data_strb;
      end else if (dest_data_ready == 1'b1) begin
        data[DATA_WIDTH_MEM-DATA_WIDTH_DEST-1:0] <= data[DATA_WIDTH_MEM-1:DATA_WIDTH_DEST];
        strb[(DATA_WIDTH_MEM-DATA_WIDTH_DEST)/8-1:0] <= strb[DATA_WIDTH_MEM/8-1:DATA_WIDTH_DEST/8];
        last[RATIO-2:0] <= last[RATIO-1:1];
      end
    end

    assign dest_data_valid = valid;
    assign dest_data = data[DATA_WIDTH_DEST-1:0];
    assign dest_data_strb = strb[DATA_WIDTH_DEST/8-1:0];
    assign dest_data_last = last[0];

  end endgenerate

endmodule
