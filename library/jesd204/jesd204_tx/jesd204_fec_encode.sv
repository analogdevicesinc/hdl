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


`timescale 1ns / 100ps

// JESD204C FEC encoder
module jesd204_fec_encode #(
   parameter DATA_WIDTH = 64
)(
   output logic [25:0]                        fec,
   input  wire                                clk,
   input  wire                                rst,
   input  wire                                shift_en,
   input  wire                                eomb,
   input  wire  [DATA_WIDTH-1:0]              data_in
);

  localparam [$clog2(DATA_WIDTH)-1:0] SHIFT_CNT = DATA_WIDTH-1;

  // 𝑥^26 + 𝑥^21 + 𝑥^17 + 𝑥^9 + 𝑥^4 + 1
  // 100001000100000001000010001
  // Remove the MSb (x^26) term because it represents the loopback from LSb of the LFSR to the MSb
  // 0000 1000 1000 0000 1000 0100 01
  // Reverse the order of the taps because the LSb of the LFSR contains the MSb of the FEC data
  // 10 0010 0001 0000 0001 0001 0000
  localparam [26:1] FEC_POLYNOMIAL = 26'h2210110;

  logic [25:0] fec_reversed;
  genvar ii;

  // Reverse order of FEC bits so that fec[25:0] matches FEC[25:0] from the JESD204 specification
  for(ii = 0; ii < 26; ii = ii + 1) begin : reverse_gen
    assign fec[ii] = fec_reversed[25-ii];
  end

  lfsr_input #(
    .LFSR_WIDTH        (26),
    .RESET_VAL         ('0),
    .LFSR_POLYNOMIAL   (FEC_POLYNOMIAL),
    .MAX_SHIFT_CNT     (DATA_WIDTH)
  ) lfsr_input (
    .data_out          (),
    .shift_reg         (fec_reversed),
    .shift_reg_next    (),
    .clk               (clk),
    .rst               (rst),
    .shift_en          (shift_en),
    .shift_reg_reset   (eomb),
    .shift_cnt         (SHIFT_CNT),
    .data_in           (data_in)
  );

endmodule
