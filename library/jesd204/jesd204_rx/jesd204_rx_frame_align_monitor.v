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

module jesd204_rx_frame_align_monitor #(
  parameter DATA_PATH_WIDTH = 4
) (
  input                             clk,
  input                             reset,
  input [7:0]                       cfg_beats_per_multiframe,
  input [7:0]                       cfg_octets_per_frame,
  input                             cfg_disable_scrambler,
  input [DATA_PATH_WIDTH-1:0]       charisk28,
  input [DATA_PATH_WIDTH*8-1:0]     data,

  output reg [7:0]                  align_err_cnt
);

// Reset alignment error count on good multiframe alignment,
// or on good frame or multiframe alignment
// If disabled, misalignments could me masked if
// due to cfg_beats_per_multiframe mismatch or due to
// a slip of a multiple of cfg_octets_per_frame octets
localparam RESET_COUNT_ON_MF_ONLY = 1'b1;

localparam DPW_LOG2 = DATA_PATH_WIDTH == 8 ? 3 :
  DATA_PATH_WIDTH == 4 ? 2 : 1;

function automatic [DPW_LOG2*2-1:0] count_ones(input [DATA_PATH_WIDTH*2-1:0] val);
  reg [DPW_LOG2*2-1:0] ii;
  begin
    count_ones = 0;
    for(ii = 0; ii != (DATA_PATH_WIDTH*2-1); ii=ii+1) begin
      count_ones = count_ones + val[ii];
    end
  end
endfunction

reg  [DATA_PATH_WIDTH-1:0]        char_is_a;
reg  [DATA_PATH_WIDTH-1:0]        char_is_f;
wire [DATA_PATH_WIDTH-1:0]        eof;
wire [DATA_PATH_WIDTH-1:0]        eomf;
reg  [DATA_PATH_WIDTH-1:0]        eof_err;
reg  [DATA_PATH_WIDTH-1:0]        eof_good;
reg  [DATA_PATH_WIDTH-1:0]        eomf_err;
reg  [DATA_PATH_WIDTH-1:0]        eomf_good;
reg                               align_good;
reg                               align_err;
reg  [DPW_LOG2*2-1:0]             cur_align_err_cnt;
wire [8:0]                        align_err_cnt_next;


jesd204_rx_frame_mark #(
  .DATA_PATH_WIDTH          (DATA_PATH_WIDTH)
) frame_mark (
  .clk                      (clk),
  .reset                    (reset),
  .cfg_beats_per_multiframe (cfg_beats_per_multiframe),
  .cfg_octets_per_frame     (cfg_octets_per_frame),
  .charisk28                (charisk28),
  .data                     (data),
  .sof                      (),
  .eof                      (eof),
  .somf                     (),
  .eomf                     (eomf)
);

genvar ii;
generate
for (ii = 0; ii < DATA_PATH_WIDTH; ii = ii + 1) begin: gen_k_char
  always @(*) begin
    char_is_a[ii] = 1'b0;
    char_is_f[ii] = 1'b0;

    if(charisk28[ii]) begin
      if(data[ii*8+7:ii*8+5] == 3'd3) begin
        char_is_a[ii] = 1'b1;
      end
      if(data[ii*8+7:ii*8+5] == 3'd7) begin
        char_is_f[ii] = 1'b1;
      end
    end
  end

  // TODO: support cfg_disable_scrambler

  always @(posedge clk) begin
    if(reset) begin
      eomf_err[ii] <= 1'b0;
      eomf_good[ii] <= 1'b0;
      eof_err[ii] <= 1'b0;
      eof_good[ii] <= 1'b0;
    end else begin
      eomf_err[ii]  <= !cfg_disable_scrambler && (char_is_a[ii] && !eomf[ii]);
      eomf_good[ii] <= !cfg_disable_scrambler && (char_is_a[ii] && eomf[ii]);
      eof_err[ii]   <= !cfg_disable_scrambler && (char_is_f[ii] && !eof[ii]);
      eof_good[ii]  <= !cfg_disable_scrambler && (char_is_f[ii] && eof[ii]);
    end
  end
end
endgenerate

always @(posedge clk) begin
  if(reset) begin
    align_good <= 1'b0;
    align_err <= 1'b0;
  end else begin
    if(RESET_COUNT_ON_MF_ONLY) begin
      align_good <= |eomf_good;
    end else begin
      align_good <= |({eomf_good, eof_good});
    end

    align_err <= |({eomf_err, eof_err});
  end
end

assign align_err_cnt_next = {1'b0, align_err_cnt} + cur_align_err_cnt;

// Alignment error counter
// Resets upon good alignment
always @(posedge clk) begin
  if(reset) begin
    align_err_cnt <= 8'd0;
    cur_align_err_cnt <= 'd0;
  end else begin
    cur_align_err_cnt <= count_ones({eomf_err, eof_err});

    if(align_good && !align_err) begin
      align_err_cnt <= 8'd0;
    end else if(align_err_cnt_next[8]) begin
      align_err_cnt <= 8'hFF;
    end else begin
      align_err_cnt <= align_err_cnt_next[7:0];
    end
  end
end

endmodule
