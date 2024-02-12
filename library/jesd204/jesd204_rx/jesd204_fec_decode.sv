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

// JESD204C FEC decoder
module jesd204_fec_decode #(
   parameter DATA_WIDTH = 64
)(
   output logic [DATA_WIDTH-1:0]              data_out,
   output logic                               data_out_valid,
   output logic                               trapped_error_flag,
   output logic                               untrapped_error_flag,
   input  wire                                clk,
   input  wire                                rst,
   input  wire                                eomb,
   input  wire                                fec_in_valid,
   input  wire  [25:0]                        fec_in,
   input  wire  [DATA_WIDTH-1:0]              data_in
);

  localparam DATA_WIDTH_WIDTH=$clog2(DATA_WIDTH);
  localparam FEC_WIDTH = 26;
  localparam FEC_WIDTH_WIDTH = $clog2(FEC_WIDTH);
  localparam [FEC_WIDTH:1] RESET_VAL = {FEC_WIDTH{1'b0}};
  localparam BLOCK_LENGTH = 2048;
  localparam MAX_BURST_LEN = 9; // Max correctable error burst length
  localparam BUFFER_NUM_BLOCKS = 2;
  localparam BLOCK_CYCLE_CNT = BLOCK_LENGTH/DATA_WIDTH;
  localparam BUFFER_DEPTH = BLOCK_CYCLE_CNT*BUFFER_NUM_BLOCKS;
  localparam BUFFER_ADDR_WIDTH = $clog2(BUFFER_DEPTH);
  localparam NUM_BLOCKS_WIDTH = $clog2(BUFFER_NUM_BLOCKS);
  localparam CYCLE_WIDTH = $clog2(BLOCK_CYCLE_CNT);

  logic [FEC_WIDTH-1:0]                       fec_in_reversed;
  logic [FEC_WIDTH:1]                         data_in_syndrome;
  logic [FEC_WIDTH:1]                         data_in_syndrome_saved;
  logic [FEC_WIDTH:1]                         codeword_syndrome;
  logic [FEC_WIDTH:1]                         error_syndrome_next[DATA_WIDTH-1:0];
  logic [FEC_WIDTH:1]                         error_syndrome_next_d[DATA_WIDTH-1:0];
  logic [DATA_WIDTH+MAX_BURST_LEN-1:0]        error_syndrome_next_shifted[DATA_WIDTH-1:0];
  logic [DATA_WIDTH+MAX_BURST_LEN-1:0]        error_bits;
  logic [MAX_BURST_LEN-1:0]                   error_bits_prev;
  logic [NUM_BLOCKS_WIDTH-1:0]                buf_wr_block;
  logic [NUM_BLOCKS_WIDTH-1:0]                buf_rd_block;
  logic [CYCLE_WIDTH-1:0]                     buf_wr_cycle;
  logic [CYCLE_WIDTH-1:0]                     buf_rd_cycle;
  logic                                       buf_wr_en;
  logic [BUFFER_ADDR_WIDTH-1:0]               buf_wr_addr;
  logic [BUFFER_ADDR_WIDTH-1:0]               buf_rd_addr;
  logic [DATA_WIDTH-1:0]                      buf_wr_data;
  logic [DATA_WIDTH-1:0]                      buf_rd_data;
  logic [DATA_WIDTH-1:0]                      buf_rd_data_d;
  logic [3:1]                                 eomb_d;
  logic                                       data_in_en;
  logic                                       fec_in_en;
  logic                                       data_out_en;
  logic [2:1]                                 data_out_en_d;
  logic                                       data_in_syndrome_avail;
  logic [DATA_WIDTH-1:0]                      error_trapped;
  logic [DATA_WIDTH-1:0]                      error;
  logic                                       any_error_trapped;
  logic                                       any_error;
  logic                                       trapped_error_sticky;
  logic                                       error_sticky;
  logic                                       trapped_error_sticky_comb;
  logic                                       error_sticky_comb;
  int jj;
  genvar ii;

  // Reverse order of FEC bits so that bit 25 is shifted in first
  for(ii = 0; ii < 26; ii = ii + 1) begin : fec_reverse_gen
    assign fec_in_reversed[ii] = fec_in[25-ii];
  end

  // Data input enabled after first EoMB
  // FEC input enabled after next EoMB
  // Data output enabled after next EoMB
  always @(posedge clk) begin
    if(rst) begin
      data_in_en <= 1'b0;
      fec_in_en <= 1'b0;
      data_out_en <= 1'b0;
    end else begin
      if(eomb) begin
        data_in_en <= 1'b1;
        fec_in_en <= data_in_en;
        data_out_en <= fec_in_en;
      end
    end
  end

  // Data buffer
  ad_mem_dist #(
    .RAM_WIDTH        (DATA_WIDTH),
    .RAM_ADDR_BITS    (BUFFER_ADDR_WIDTH)
  ) data_buffer (
    .rd_data          (buf_rd_data),
    .clk              (clk),
    .wr_en            (buf_wr_en),
    .wr_addr          (buf_wr_addr),
    .wr_data          (buf_wr_data),
    .rd_addr          (buf_rd_addr)
  );

  assign buf_wr_en = data_in_en;
  assign buf_wr_data = data_in;
  assign buf_wr_addr = {buf_wr_block, buf_wr_cycle};
  assign buf_rd_addr = {buf_rd_block, buf_rd_cycle};

  // Keep track of read and write block counts and block cycle counts
  // in case link goes down then up, causing partial blocks
  always @(posedge clk) begin
    if(rst) begin
      buf_wr_block <= '0;
      buf_wr_cycle <= '0;
    end else begin
      if(data_in_en) begin
        if(eomb) begin
          if(buf_wr_block == (BUFFER_NUM_BLOCKS-1)) begin
            buf_wr_block <= '0;
          end else begin
            buf_wr_block <= buf_wr_block + 1'b1;
          end

          buf_wr_cycle <= '0;
        end else begin
          buf_wr_cycle <= buf_wr_cycle + 1'b1;
        end
      end
    end
  end

  always @(posedge clk) begin
    if(rst) begin
      buf_rd_block <= '0;
      buf_rd_cycle <= '0;
    end else begin
      if(data_out_en) begin
        if(eomb) begin
          if(buf_rd_block == (BUFFER_NUM_BLOCKS-1)) begin
            buf_rd_block <= '0;
          end else begin
            buf_rd_block <= buf_rd_block + 1'b1;
          end

          buf_rd_cycle <= '0;
        end else begin
          buf_rd_cycle <= buf_rd_cycle + 1'b1;
        end
      end
    end
  end

  // Input data syndrome computation
  jesd204_rx_fec_lfsr #(
    .MAX_SHIFT_CNT      (DATA_WIDTH)
  ) data_in_lfsr (
    .data_out           (),
    .shift_reg          (data_in_syndrome),
    .shift_reg_next     (),
    .clk                (clk),
    .rst                (rst),
    .load_en            (eomb),
    .load_data          ('0),
    .shift_en           (data_in_en),
    .shift_cnt          (DATA_WIDTH_WIDTH'(DATA_WIDTH-1)),
    .data_in            (data_in)
  );

  // Save codeword_lfsr after the input data syndrome is computed
  always @(posedge clk) begin
    if(rst) begin
      data_in_syndrome_avail <= 1'b0;
    end else begin
      data_in_syndrome_avail <= data_in_en && eomb_d[1];
    end
  end

  always @(posedge clk) begin
    if(eomb_d[1]) begin
      data_in_syndrome_saved <= data_in_syndrome;
    end
  end

  // Codeword syndrome computation using received FEC
  jesd204_rx_fec_lfsr #(
    .MAX_SHIFT_CNT      (FEC_WIDTH)
  ) codeword_lfsr (
    .data_out           (),
    .shift_reg          (codeword_syndrome),
    .shift_reg_next     (),
    .clk                (clk),
    .rst                (rst),
    .load_en            (data_in_syndrome_avail),
    .load_data          (data_in_syndrome_saved),
    .shift_en           (fec_in_valid),
    .shift_cnt          (FEC_WIDTH_WIDTH'(FEC_WIDTH-1)),
    .data_in            (fec_in_reversed)
  );

  // Error syndrome computation
  jesd204_rx_fec_lfsr #(
    .MAX_SHIFT_CNT      (DATA_WIDTH)
  ) error_lfsr (
    .data_out           (),
    .shift_reg          (),
    .shift_reg_next     (error_syndrome_next),
    .clk                (clk),
    .rst                (rst),
    .load_en            (eomb),
    .load_data          (codeword_syndrome),
    .shift_en           (data_out_en),
    .shift_cnt          (DATA_WIDTH_WIDTH'(DATA_WIDTH-1)),
    .data_in            ({DATA_WIDTH{1'b0}})
  );

  always_ff @(posedge clk) begin
    error_syndrome_next_d <= error_syndrome_next;
    buf_rd_data_d <= buf_rd_data;
  end

  // Error is trapped if the MSb of the syndrome is 1 and bits 16:0 of the syndrome are 0
  // MSb (bit S25) of the syndrome is in the rightmost bit of error_syndrome_next_d[ii]
  for(ii = 0; ii < DATA_WIDTH; ii = ii + 1) begin : error_trap_gen
    assign error_trapped[ii] = error_syndrome_next_d[ii][1] && ~|(error_syndrome_next_d[ii][26:10]);
    assign error[ii] = error_syndrome_next_d[ii][1];
  end

  always @(posedge clk) begin
    any_error_trapped <= |error_trapped;
    any_error <= |error;
  end

  // Shift syndromes to align with data
  for(ii = 0; ii < DATA_WIDTH; ii = ii + 1) begin : syndrome_shift_gen
    assign error_syndrome_next_shifted[ii] = {error_syndrome_next_d[ii][MAX_BURST_LEN:1], {(ii+1){1'b0}}};
  end

  // Determine error bits by checking for trapped error
  always @(*) begin
    error_bits = '0;
    for(jj = 0; jj < DATA_WIDTH; jj = jj + 1'b1) begin : correct_gen
      if(error_trapped[jj]) begin
        error_bits = error_bits ^ error_syndrome_next_shifted[jj];
      end
    end
  end

  // Save remaining error bits to use next cycle
  always @(posedge clk) begin
    if(eomb_d[1]) begin
      error_bits_prev <= '0;
    end else begin
      error_bits_prev <= error_bits[DATA_WIDTH+:MAX_BURST_LEN];
    end
  end

  // Correct data by XORing with FEC syndrome
  // Output corrected data
  always_ff @(posedge clk) begin
    data_out <= buf_rd_data_d ^ error_bits[DATA_WIDTH-1:0] ^ error_bits_prev;
    data_out_valid <= data_out_en_d[1];
  end

  // Flag trapped and untrapped errors, once per-block
  assign trapped_error_sticky_comb = (eomb_d[3] ? 1'b0 : trapped_error_sticky) || any_error_trapped;
  assign error_sticky_comb = (eomb_d[3] ? 1'b0 : error_sticky) || any_error;

  always @(posedge clk) begin
    if(rst) begin
      trapped_error_flag <= 1'b0;
      untrapped_error_flag <= 1'b0;
      trapped_error_sticky <= 1'b0;
      error_sticky <= 1'b0;
    end else begin
      trapped_error_flag <= 1'b0;
      untrapped_error_flag <= 1'b0;

      if(data_out_en_d[2]) begin
        trapped_error_sticky <= trapped_error_sticky_comb;
        error_sticky <= error_sticky_comb;
        if(eomb_d[2]) begin
          trapped_error_flag <= trapped_error_sticky_comb;
          untrapped_error_flag <= !trapped_error_sticky_comb && error_sticky_comb;
        end
      end else begin
        trapped_error_sticky <= 1'b0;
        error_sticky <= 1'b0;
      end
    end
  end

  // Delay registers
  always @(posedge clk) begin
    if(rst) begin
      eomb_d <= 3'b0;
      data_out_en_d <= 2'b0;
    end else begin
      eomb_d <= {eomb_d[2:1], eomb};
      data_out_en_d <= {data_out_en_d[1], data_out_en};
    end
  end

endmodule
