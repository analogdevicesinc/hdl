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

module jesd204_eof_generator #(
  parameter DATA_PATH_WIDTH = 4,
  parameter MAX_OCTETS_PER_FRAME = 256
) (
  input clk,
  input reset,

  input lmfc_edge,

  input [7:0] cfg_octets_per_frame,
  input cfg_generate_eomf,

  output reg [DATA_PATH_WIDTH-1:0] sof,
  output reg [DATA_PATH_WIDTH-1:0] eof,
  output reg eomf
);

localparam CW = MAX_OCTETS_PER_FRAME > 128 ? 8 :
  MAX_OCTETS_PER_FRAME > 64 ? 7 :
  MAX_OCTETS_PER_FRAME > 32 ? 6 :
  MAX_OCTETS_PER_FRAME > 16 ? 5 :
  MAX_OCTETS_PER_FRAME > 8 ? 4 :
  MAX_OCTETS_PER_FRAME > 4 ? 3 :
  MAX_OCTETS_PER_FRAME > 2 ? 2 : 1;
localparam DPW_LOG2 = DATA_PATH_WIDTH == 8 ? 3 :
  DATA_PATH_WIDTH == 4 ? 2 : 1;

reg lmfc_edge_d1 = 1'b0;

wire beat_counter_sof;
wire beat_counter_eof;
wire small_octets_per_frame;

always @(posedge clk) begin
  if (cfg_generate_eomf == 1'b1) begin
    lmfc_edge_d1 <= lmfc_edge;
  end else begin
    lmfc_edge_d1 <= 1'b0;
  end
  eomf <= lmfc_edge_d1;
end

generate
if (CW > DPW_LOG2) begin
  reg [CW-DPW_LOG2-1:0] beat_counter = 'h00;
  wire [CW-DPW_LOG2-1:0] cfg_beats_per_frame = cfg_octets_per_frame[CW-1:DPW_LOG2];

  assign beat_counter_sof = beat_counter == 'h00;
  assign beat_counter_eof = beat_counter == cfg_beats_per_frame;
  assign small_octets_per_frame = cfg_beats_per_frame == 'h00;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      beat_counter <= 'h00;
    end else if (beat_counter_eof == 1'b1) begin
      beat_counter <= 'h00;
    end else begin
      beat_counter <= beat_counter + 1'b1;
    end
  end

end else begin
  assign beat_counter_sof = 1'b1;
  assign beat_counter_eof = 1'b1;
  assign small_octets_per_frame = 1'b1;
end
endgenerate

function [1:0] ffs;
input [2:0] x;
begin
  case (x)
  1: ffs = 0;
  2: ffs = 1;
  3: ffs = 0;
  4: ffs = 2;
  5: ffs = 0;
  6: ffs = 1;
  7: ffs = 0;
  default: ffs = 0;
  endcase
end
endfunction

integer i;

/* Only 1, 2 and multiples of 4 are supported atm */
always @(posedge clk) begin
  if (reset == 1'b1) begin
    sof <= {DATA_PATH_WIDTH{1'b0}};
    eof <= {DATA_PATH_WIDTH{1'b0}};
  end else begin
    sof <= {{DATA_PATH_WIDTH-1{1'b0}},beat_counter_sof};
    eof <= {beat_counter_eof,{DATA_PATH_WIDTH-1{1'b0}}};

    if (small_octets_per_frame == 1'b1) begin
      for (i = 1; i < DATA_PATH_WIDTH; i = i + 1) begin
        if (cfg_octets_per_frame[ffs(i)] != 1'b1) begin
          sof[i] <= 1'b1;
          eof[DATA_PATH_WIDTH-1-i] <= 1'b1;
        end
      end
    end else begin
    end
  end
end

endmodule
