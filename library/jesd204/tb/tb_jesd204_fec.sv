// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
// Short identifier: ADIJESD204
//
// The ADI JESD204 Core is released under the following license, which is
// different than all other HDL cores in this repository.
//
// Please read this, and understand the freedoms and responsibilities you have by
// using this source code/core.
//
// The JESD204 HDL, is copyright (C) 2016-2026 Analog Devices Inc.
//
// This core is free software, you can use run, copy, study, change, ask questions
// about and improve this core. Distribution of source, or resulting binaries
// (including those inside an FPGA or ASIC) require you to release the source of
// the entire project (excluding the system libraries provide by the
// tools/compiler/FPGA vendor). These are the terms of the GNU General Public
// License version 2 as published by the Free Software Foundation.
//
// This core  is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
// PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License version 2
// along with this source code, and binary. If not, see
// <http://www.gnu.org/licenses/>.
//
// Commercial licenses (with commercial support) of this JESD204 core are also
// available under terms different than the General Public License (e.g. they do
// not require you to accompany any image (FPGA or ASIC) using the JESD204 core
// with any corresponding source code). For these alternate terms you must
// purchase a license from Analog Devices Technology Licensing Office. Users
// interested in such a license should contact jesd204-licensing@analog.com for
// more information. This commercial license is sub-licensable (if you purchase
// chips from Analog Devices, incorporate them into your PCB level product, and
// purchase a JESD204 license, end users of your product will also have a license
// to use this core in a commercial setting without releasing their source code).
//
// In addition, we kindly ask you to acknowledge ADI in any program, application
// or publication in which you use this JESD204 HDL core. (You are not required to
// do so; it is up to your common sense to decide whether you want to comply with
// this request or not.) For general publications, we suggest referencing: "The
// design and implementation of the JESD204 HDL Core used in this project is
// copyright (C) 2016-2026, Analog Devices, Inc."
// ***************************************************************************
// ***************************************************************************

`timescale 1ns / 100ps
`default_nettype none

module tb_jesd204_fec;

  localparam FEC_WIDTH = 26;
  localparam DATA_WIDTH = 64;

  // localparam INPUT_DATA_WIDTH = 64;
  // localparam logic [INPUT_DATA_WIDTH-1:0] DATA_VALUE = 64'h8001020305050423;
  localparam INPUT_DATA_WIDTH = 2048*4;
  localparam logic [INPUT_DATA_WIDTH-1:0] DATA_VALUE = {{2048{1'b1}}, 1'b1, 2047'b0, {2048{1'b1}}, 2047'b0, 1'b1};
  // localparam logic [INPUT_DATA_WIDTH-1:0] DATA_VALUE = {2047'b0, 1'b1};
  // localparam logic [INPUT_DATA_WIDTH-1:0] DATA_VALUE = {1'b1, 63'b0, 1'b1, 1983'b0};
  // localparam logic [INPUT_DATA_WIDTH-1:0] DATA_VALUE = {INPUT_DATA_WIDTH{1'b1}};
  localparam ERROR_CYCLE = 33;    // Cycle of decoder data input to corrupt
  localparam ERROR_BITS =  64'h1FF000; // Bits of decoder input data to corrupt
  localparam FEC_ERROR_BITS = '0; // {1'b1, 25'b0};

  logic [INPUT_DATA_WIDTH-1:0]    DATA_VALUE_REVERSED;
  logic [INPUT_DATA_WIDTH-1:0]    data;

  logic [FEC_WIDTH-1:0]           fec;
  logic [FEC_WIDTH-1:0]           fec_saved;
  logic [FEC_WIDTH-1:0]           decode_fec_in;
  reg                             clk = 1'b0;
  logic                           rst;
  logic                           fec_in_valid;
  logic                           shift_en;
  logic                           data_in_valid;
  logic [DATA_WIDTH-1:0]          data_in;
  logic [DATA_WIDTH-1:0]          decode_data_in;
  logic [DATA_WIDTH-1:0]          data_out;
  logic                           data_out_valid;
  logic                           trapped_error_flag;
  logic                           untrapped_error_flag;
  logic                           eomb;
  logic [27:1]                    eomb_d;

  int                             data_in_cnt;
  int                             decode_cnt;
  int                             cycle_cnt;
  int ii;

  always #5 clk = ~clk;

  initial begin
    // Shift data in MSb-first by reversing the data
    for(ii = 0; ii < INPUT_DATA_WIDTH; ii = ii + 1) begin
      DATA_VALUE_REVERSED[ii] = DATA_VALUE[INPUT_DATA_WIDTH-1-ii];
    end
    rst = 1'b1;
    #100ns;
    rst = 1'b0;
  end

  always_ff @(posedge clk) begin
    if(rst) begin
      shift_en <= 1'b0;
      data <= DATA_VALUE_REVERSED;
      data_in_cnt <= '0;
      data_in_valid <= 1'b0;
    end else begin
      data_in_valid <= 1'b1;
      if(data_in_cnt < INPUT_DATA_WIDTH) begin
        data_in <= data[0+:DATA_WIDTH];
        data <= data >> DATA_WIDTH;
        shift_en <= 1'b1;
        data_in_cnt <= data_in_cnt + DATA_WIDTH;
      end else begin
        shift_en <= 1'b0;
      end
    end
  end

  always_ff @(posedge clk) begin
    if(rst) begin
      cycle_cnt <= '0;
    end else begin
      if(data_in_valid) begin
        if(cycle_cnt == 31) begin
          cycle_cnt <= '0;
        end else begin
          cycle_cnt <= cycle_cnt + 1'b1;
        end
      end
    end
  end

  assign eomb = cycle_cnt == 31;
  // assign eomb = (data_in_cnt == INPUT_DATA_WIDTH) && shift_en;

  always_ff @(posedge clk) begin
    if(rst) begin
      decode_cnt <= '0;
    end else begin
      if(shift_en) begin
        decode_cnt <= decode_cnt + 1;
      end
    end
  end

  assign decode_data_in = (decode_cnt == ERROR_CYCLE) ? (data_in ^ ERROR_BITS) : data_in;
  assign decode_fec_in = fec_saved ^ FEC_ERROR_BITS;

  jesd204_fec_encode #(
    .DATA_WIDTH     (DATA_WIDTH)
  ) jesd204_fec_encode (
    .fec         (fec),
    .clk         (clk),
    .rst         (rst),
    .shift_en    (data_in_valid),
    .eomb        (eomb),
    .data_in     (data_in)
  );

  always_ff @(posedge clk) begin
    if(rst) begin
      eomb_d <= '0;
    end else begin
      eomb_d <= {eomb_d[26:1], eomb};
    end
  end

  always_ff @(posedge clk) begin
    if(eomb_d[1]) begin
      fec_saved <= fec;
    end
  end

  assign fec_in_valid = eomb_d[27];

  jesd204_fec_decode #(
      .DATA_WIDTH     (DATA_WIDTH)
  ) jesd204_fec_decode (
    .data_out              (data_out),
    .data_out_valid        (data_out_valid),
    .trapped_error_flag    (trapped_error_flag),
    .untrapped_error_flag  (untrapped_error_flag),
    .clk                   (clk),
    .rst                   (rst),
    .eomb                  (eomb),
    .fec_in_valid          (fec_in_valid),
    .fec_in                (decode_fec_in),
    .data_in               (decode_data_in)
  );

endmodule

`default_nettype wire
