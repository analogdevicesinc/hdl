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

// JESD204C RX FEC DECODER LFSR
module jesd204_rx_fec_lfsr #(
   localparam LFSR_WIDTH = 26,
   parameter MAX_SHIFT_CNT = 64
)(
   // One cycle after shift_en = 1,
   //   data_out[shift_cnt:0] contains the next shift_cnt + 1 output bits
   //   data_out[MAX_SHIFT_CNT-1:shift_cnt+1] is undefined
   output logic [MAX_SHIFT_CNT-1:0]               data_out,
   // Value of the shift register updated one cycle after shift_en is asserted
   output logic [LFSR_WIDTH:1]                    shift_reg,
   // Value of the shift register if shift_en is asserted for each value of shift_cnt from 1 to MAX_SHIFT_CNT
   output logic [LFSR_WIDTH:1]                    shift_reg_next[MAX_SHIFT_CNT-1:0],
   input  wire                                    clk,
   input  wire                                    rst,
   input  wire                                    load_en,
   input  wire  [LFSR_WIDTH:1]                    load_data,
   input  wire                                    shift_en,
   // Number of bits to shift - 1
   input  wire  [$clog2(MAX_SHIFT_CNT)-1:0]       shift_cnt,
   input  wire  [MAX_SHIFT_CNT-1:0]               data_in
);

  localparam [LFSR_WIDTH:1] RESET_VAL = {LFSR_WIDTH{1'b0}};

  // 𝑥^26 + 𝑥^21 + 𝑥^17 + 𝑥^9 + 𝑥^4 + 1
  // 100001000100000001000010001
  // Remove the MSb (x^26) term because it corresponds to one shift past the end of the LFSR,
  // and represents feedback from the x^26 term to the other taps
  // 0000 1000 1000 0000 1000 0100 01
  // Reverse the order of the taps because the LSb of the LFSR contains the MSb of the FEC data
  // 10 0010 0001 0000 0001 0001 0000
  localparam [LFSR_WIDTH:1] FEC_POLYNOMIAL_1 = 26'h2210110;

  // 𝑥^24 + 𝑥^21 + 𝑥^19 + 𝑥^18 + 𝑥^17 + 𝑥^9 + 𝑥^7 + 𝑥^4 + 𝑥^2 + 𝑥 + 1
  // 001001011100000001010010111
  // Remove the MSb (x^26) term because it corresponds to one shift past the end of the LFSR
  // 0100 1011 1000 0000 1010 0101 11
  // Reverse the order of the taps because the LSb of the LFSR contains the MSb of the FEC data
  // 11 1010 0101 0000 0001 1101 0010
  localparam [LFSR_WIDTH:1] FEC_POLYNOMIAL_2 = 26'h3A501D2;

  function automatic [LFSR_WIDTH:1] fec_decode_galois_next(input [LFSR_WIDTH:1] cur, input next_data_in);
    int ii;
    reg x_26 = cur[1];
    fec_decode_galois_next[LFSR_WIDTH] = next_data_in ^ x_26;
    for(ii = LFSR_WIDTH-1; ii > 0; ii=ii-1) begin : shift_reg_gen
      fec_decode_galois_next[ii] = cur[ii+1] ^ (x_26 & FEC_POLYNOMIAL_1[ii]) ^ (next_data_in & FEC_POLYNOMIAL_2[ii]);
    end
  endfunction

  logic [MAX_SHIFT_CNT-1:0]                 data_out_next;
  logic [LFSR_WIDTH:1]                      shift_reg_in_start;
  logic [LFSR_WIDTH:1]                      shift_reg_in_next[MAX_SHIFT_CNT-1:0];
  genvar jj;

  // Generate shift register values for each number of shifts
  for(jj = 0; jj < MAX_SHIFT_CNT; jj = jj + 1) begin : shift_gen
    if(jj == 0) begin : zero_gen
      assign shift_reg_in_next[jj] = shift_reg_in_start;
    end else begin : non_zero_gen
      assign shift_reg_in_next[jj] = shift_reg_next[jj-1];
    end

    // Output bit is the LSb of the shift register
    assign data_out_next[jj] = shift_reg_in_next[jj][1];

    assign shift_reg_next[jj] = fec_decode_galois_next(shift_reg_in_next[jj], data_in[jj]);
  end

  // Shift register input is output of previous shift register value,
  // or load value if load enabled
  always @(posedge clk) begin 
    if(rst) begin
      shift_reg_in_start <= RESET_VAL;
    end else begin  
      if(load_en) begin
        shift_reg_in_start <= load_data;
      end else if(shift_en) begin
        shift_reg_in_start <= shift_reg_next[shift_cnt];
      end
    end
  end

  always @(posedge clk) begin
    if(rst) begin
      shift_reg <= RESET_VAL;
    end else begin
      if(shift_en) begin
        shift_reg <= shift_reg_next[shift_cnt];
        data_out <= data_out_next;
      end else if(load_en) begin
        shift_reg <= load_data;
      end
    end
  end

endmodule
