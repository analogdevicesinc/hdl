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

module jesd204_frame_align_replace_tb;

  parameter VCD_FILE = "jesd204_frame_align_replace_tb.vcd";
  `define TIMEOUT 1000000
  `include "tb_base.v"

  localparam DATA_PATH_WIDTH = 8;
  localparam IS_RX = 1'b1;

  wire [7:0]                    cfg_octets_per_frame = 5;
  wire                          cfg_disable_char_replacement = 1'b0;
  wire                          cfg_disable_scrambler = 1'b1;
  reg [DATA_PATH_WIDTH*8-1:0]   data;
  reg [DATA_PATH_WIDTH-1:0]     eof;
  reg [DATA_PATH_WIDTH-1:0]     eomf;
  reg [DATA_PATH_WIDTH-1:0]     char_is_a;
  reg [DATA_PATH_WIDTH-1:0]     char_is_f;
  wire [DATA_PATH_WIDTH*8-1:0]  data_out;
  wire [DATA_PATH_WIDTH-1:0]    charisk_out;
  reg [31:00] ii;

  initial begin
    forever begin
      for(ii = 0; ii < DATA_PATH_WIDTH; ii = ii + 1) begin
        eof[ii] = $urandom_range(cfg_octets_per_frame) == 0;
        eomf[ii] = $urandom_range(cfg_octets_per_frame*4) == 0;
        char_is_a[ii] = $urandom_range(cfg_octets_per_frame*2) == 0;
        char_is_f[ii] = $urandom_range(cfg_octets_per_frame*2) == 0;
      end
      data = {$urandom, $urandom};
      @(negedge clk);
    end
  end

  jesd204_frame_align_replace #(
    .DATA_PATH_WIDTH              (DATA_PATH_WIDTH),
    .IS_RX                        (IS_RX)
  ) frame_align_replace (
    .clk                          (clk),
    .reset                        (reset),
    .cfg_octets_per_frame         (cfg_octets_per_frame),
    .cfg_disable_char_replacement (cfg_disable_char_replacement),
    .cfg_disable_scrambler        (cfg_disable_scrambler),
    .data                         (data),
    .eof                          (eof),
    .rx_char_is_a                 (char_is_a),
    .rx_char_is_f                 (char_is_f),
    .tx_eomf                      (eomf),
    .data_out                     (data_out),
    .charisk_out                  (charisk_out));

endmodule
