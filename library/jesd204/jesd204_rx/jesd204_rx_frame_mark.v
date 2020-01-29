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

// Limitations:
//   DATA_PATH_WIDTH = 4
//   F*K=4, multiples of DATA_PATH_WIDTH
//   F=1,2,3,4,6, and multiples of DATA_PATH_WIDTH

`timescale 1ns/100ps

module jesd204_rx_frame_mark #(
  parameter DATA_PATH_WIDTH = 4
) (
  input                             clk,
  input                             reset,
  input [7:0]                       cfg_beats_per_multiframe,
  input [7:0]                       cfg_octets_per_frame,
  input [DATA_PATH_WIDTH-1:0]       charisk28,
  input [DATA_PATH_WIDTH*8-1:0]     data,

  output reg [DATA_PATH_WIDTH-1:0]  sof,
  output reg [DATA_PATH_WIDTH-1:0]  eof,
  output reg [DATA_PATH_WIDTH-1:0]  somf,
  output reg [DATA_PATH_WIDTH-1:0]  eomf
);

localparam MAX_OCTETS_PER_FRAME = 16;
localparam DPW_LOG2 = DATA_PATH_WIDTH == 8 ? 3 : DATA_PATH_WIDTH == 4 ? 2 : 1;
localparam CW = MAX_OCTETS_PER_FRAME > 128 ? 8 :
  MAX_OCTETS_PER_FRAME > 64 ? 7 :
  MAX_OCTETS_PER_FRAME > 32 ? 6 :
  MAX_OCTETS_PER_FRAME > 16 ? 5 :
  MAX_OCTETS_PER_FRAME > 8 ? 4 :
  MAX_OCTETS_PER_FRAME > 4 ? 3 :
  MAX_OCTETS_PER_FRAME > 2 ? 2 : 1;
localparam BEATS_PER_FRAME_WIDTH = CW-DPW_LOG2;

reg [1:0]                         beat_cnt_mod_3;
reg [BEATS_PER_FRAME_WIDTH-1:0]   beat_cnt_frame;
wire                              cur_sof;
wire                              cur_eof;
reg [7:0]                         beat_cnt_mf;
wire                              cur_somf;
wire                              cur_eomf;

wire [BEATS_PER_FRAME_WIDTH-1:0]  cfg_beats_per_frame = cfg_octets_per_frame[CW-1:DPW_LOG2];
reg [DATA_PATH_WIDTH-1:0] sof_f_3[2:0];
reg [DATA_PATH_WIDTH-1:0] eof_f_3[2:0];
reg [DATA_PATH_WIDTH-1:0] sof_f_6[2:0];
reg [DATA_PATH_WIDTH-1:0] eof_f_6[2:0];

initial begin
  sof_f_3[0] = {4'b1001};
  sof_f_3[1] = {4'b0100};
  sof_f_3[2] = {4'b0010};
  eof_f_3[0] = {4'b0100};
  eof_f_3[1] = {4'b0010};
  eof_f_3[2] = {4'b1001};
  sof_f_6[0] = {4'b0001};
  sof_f_6[1] = {4'b0100};
  sof_f_6[2] = {4'b0000};
  eof_f_6[0] = {4'b0000};
  eof_f_6[1] = {4'b0010};
  eof_f_6[2] = {4'b1000};
end

// Beat count % 3, to support F=3,6
always @(posedge clk) begin
  if(reset) begin
    beat_cnt_mod_3 <= 2'd0;
  end else begin
    if(beat_cnt_mod_3 == 2'd2) begin
      beat_cnt_mod_3 <= 2'd0;
    end else begin
      beat_cnt_mod_3 <= beat_cnt_mod_3 + 1'b1;
    end
  end
end

// Beat count per frame
always @(posedge clk) begin
  if(reset) begin
    beat_cnt_frame <= {BEATS_PER_FRAME_WIDTH{1'b0}};
  end else begin
    if(beat_cnt_frame == cfg_beats_per_frame) begin
      beat_cnt_frame <= {BEATS_PER_FRAME_WIDTH{1'b0}};
    end else begin
      beat_cnt_frame <= beat_cnt_frame + 1'b1;
    end
  end
end

assign cur_sof = beat_cnt_frame == 0;
assign cur_eof = beat_cnt_frame == cfg_beats_per_frame;

// cfg_octets_per_frame must be a multiple of DATA_PATH_WIDTH'
// except for the following supported special cases
always @(*) begin
  case(cfg_octets_per_frame)
    8'd0:
      begin
        sof = {DATA_PATH_WIDTH{1'b1}};
        eof = {DATA_PATH_WIDTH{1'b1}};
      end
    8'd1:
      begin
        sof = {DATA_PATH_WIDTH/2{2'b01}};
        eof = {DATA_PATH_WIDTH/2{2'b10}};
      end
    8'd2:
      begin
        sof = sof_f_3[beat_cnt_mod_3];
        eof = eof_f_3[beat_cnt_mod_3];
      end
    8'd5:
      begin
        sof = sof_f_6[beat_cnt_mod_3];
        eof = eof_f_6[beat_cnt_mod_3];
      end
    default:
      begin
        sof = {{DATA_PATH_WIDTH-1{1'b0}}, cur_sof};
        eof = {cur_eof, {DATA_PATH_WIDTH-1{1'b0}}};
      end
  endcase
end


// Beat count per multiframe
always @(posedge clk) begin
  if(reset) begin
    beat_cnt_mf <= 8'b0;
  end else begin
    if(beat_cnt_mf == cfg_beats_per_multiframe) begin
      beat_cnt_mf <= 8'b0;
    end else begin
      beat_cnt_mf <= beat_cnt_mf + 1'b1;
    end
  end
end

assign cur_somf = beat_cnt_mf == 0;
assign cur_eomf = beat_cnt_mf == cfg_beats_per_multiframe;

// Only support F*K equals a multipe of DATA_PATH_WIDTH,
always @(*) begin
  somf = {{DATA_PATH_WIDTH-1{1'b0}}, cur_somf};
  eomf = {cur_eomf, {DATA_PATH_WIDTH-1{1'b0}}};
end

endmodule

