//
// The ADI JESD204 Core is released under the following license, which is
// different than all other HDL cores in this repository.
//
// Please read this, and understand the freedoms and responsibilities you have
// by using this source code/core.
//
// The JESD204 HDL, is copyright © 2016-2017 Analog Devices Inc.
//
// This core is free software, you can use run, copy, study, change, ask
// questions about and improve this core. Distribution of source, or resulting
// binaries (including those inside an FPGA or ASIC) require you to release the
// source of the entire project (excluding the system libraries provide by the
// tools/compiler/FPGA vendor). These are the terms of the GNU General Public
// License version 2 as published by the Free Software Foundation.
//
// This core  is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License version 2
// along with this source code, and binary.  If not, see
// <http://www.gnu.org/licenses/>.
//
// Commercial licenses (with commercial support) of this JESD204 core are also
// available under terms different than the General Public License. (e.g. they
// do not require you to accompany any image (FPGA or ASIC) using the JESD204
// core with any corresponding source code.) For these alternate terms you must
// purchase a license from Analog Devices Technology Licensing Office. Users
// interested in such a license should contact jesd204-licensing@analog.com for
// more information. This commercial license is sub-licensable (if you purchase
// chips from Analog Devices, incorporate them into your PCB level product, and
// purchase a JESD204 license, end users of your product will also have a
// license to use this core in a commercial setting without releasing their
// source code).
//
// In addition, we kindly ask you to acknowledge ADI in any program, application
// or publication in which you use this JESD204 HDL core. (You are not required
// to do so; it is up to your common sense to decide whether you want to comply
// with this request or not.) For general publications, we suggest referencing :
// “The design and implementation of the JESD204 HDL Core used in this project
// is copyright © 2016-2017, Analog Devices, Inc.”
//

`timescale 1ns/100ps

module jesd204_pattern_align #(
  parameter DATA_PATH_WIDTH = 4
) (
  input clk,
  input reset,

  input patternalign_en,

  input [DATA_PATH_WIDTH*10-1:0] in_data,
  output [DATA_PATH_WIDTH*10-1:0] out_data
);

localparam [9:0] PATTERN_P = 10'b1010000011;
localparam [9:0] PATTERN_N = 10'b0101111100;

reg [1:0] match_counter = 2'h0;
reg pattern_sync = 1'b0;
reg pattern_match = 1'b0;

reg [3:0] align = 4'h0;
reg [1:0] cooldown = 2'h3;

reg [8:0] data_d1 = 9'h00;
reg [DATA_PATH_WIDTH*10+2:0] aligned_data_stage1;
reg [DATA_PATH_WIDTH*10-1:0] aligned_data_stage2;
wire [(DATA_PATH_WIDTH+1)*10-2:0] full_data;

assign full_data = {in_data,data_d1};
assign out_data = aligned_data_stage2;

/* 2-stage cascade of 3:1 and 4:1 muxes */

integer i;

always @(*) begin
  for (i = 0; i < DATA_PATH_WIDTH*10+3; i = i + 1) begin
    if (i < DATA_PATH_WIDTH*10+1) begin
      case (align[3:2])
      2'b00: aligned_data_stage1[i] <= full_data[i];
      2'b01: aligned_data_stage1[i] <= full_data[i+4];
      2'b10: aligned_data_stage1[i] <= full_data[i+8];
      default: aligned_data_stage1[i] <= 1'b0;
      endcase
    end else begin
      case (align[2])
      1'b0: aligned_data_stage1[i] <= full_data[i];
      default: aligned_data_stage1[i] <= full_data[i+4];
      endcase
    end
  end

  aligned_data_stage2 <= aligned_data_stage1[align[1:0]+:DATA_PATH_WIDTH*10];
end

always @(posedge clk) begin
  data_d1 <= in_data[DATA_PATH_WIDTH*10-9+:9];
end

always @(posedge clk) begin
  if (out_data[9:0] == PATTERN_P || out_data[9:0] == PATTERN_N) begin
    pattern_match <= 1'b1;
  end else begin
    pattern_match <= 1'b0;
  end
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    cooldown <= 2'h3;
    align <= 4'h0;
  end else begin
    if (cooldown != 2'h0) begin
      cooldown <= cooldown - 1'b1;
    end else if (patternalign_en == 1'b1 && pattern_sync == 1'b0 &&
                 pattern_match == 1'b0) begin
      cooldown <= 2'h3;
      if (align == 'h9) begin
        align <= 4'h0;
      end else begin
        align <= align + 1'b1;
      end
    end
  end
end

always @(posedge clk) begin
  if (reset == 1'b1) begin
    pattern_sync <= 1'b0;
    match_counter <= 2'h0;
  end else begin
    if (match_counter == 2'h0) begin
      pattern_sync <= 1'b0;
    end else if (match_counter == 2'h3) begin
      pattern_sync <= 1'b1;
    end

    if (pattern_match == 1'b1) begin
      if (match_counter != 2'h3) begin
        match_counter <= match_counter + 1'b1;
      end
    end else begin
      if (match_counter != 2'h0) begin
        match_counter <= match_counter - 1'b1;
      end
    end
  end
end

endmodule
