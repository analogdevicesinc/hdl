// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
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

// Uses Ficonacci style LFSR

`timescale 1ns/100ps

module ber_tester_tx #(

  // Structural configuration
  parameter IF_COUNT = 1,
  parameter PORTS_PER_IF = 1,

  parameter AXIS_DATA_WIDTH = 512,
  parameter AXIS_KEEP_WIDTH = AXIS_DATA_WIDTH/8
) (

  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          clk,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          rstn,

  input  wire                                                      ber_test,
  input  wire                                                      insert_bit_error,

  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]          m_axis_output_tdata,
  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]          m_axis_output_tkeep,
  output reg  [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_output_tvalid,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_output_tready
);

  localparam DATA_WIDTH = IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH;
  localparam KEEP_WIDTH = IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH;

  // PRBS instances
  localparam PRBS_DATA_WIDTH = 64;
  localparam PRBS_POLYNOMIAL_WIDTH = 48;
  localparam PRBS_INST = DATA_WIDTH/PRBS_DATA_WIDTH;

  wire prbs_ready;
  wire [DATA_WIDTH-1:0] prbs_data;
  wire [PRBS_INST-1:0]  prbs_valid;

  assign prbs_ready = m_axis_output_tready;

  genvar i;

  generate

    for (i = 0; i < PRBS_INST; i = i + 1) begin

      prbs_gen #(
        .DATA_WIDTH(PRBS_DATA_WIDTH),
        .POLYNOMIAL_WIDTH(PRBS_POLYNOMIAL_WIDTH)
      ) prbs_gen_inst (
        .clk(clk),
        .rstn(rstn),
        .init(~ber_test),
        .input_ready(prbs_ready),
        .output_data(prbs_data[i*PRBS_DATA_WIDTH +: PRBS_DATA_WIDTH]),
        .output_valid(prbs_valid[i]),
        .polynomial(48'hC00000000000),
        .inverted(1'b0),
        .initial_value(64'h36A59A15F76E2D29)
      );

    end

  endgenerate

  reg insert_bit_error_old;
  reg insert_bit_error_valid;

  always @(posedge clk)
  begin
    if (!rstn) begin
      insert_bit_error_old <= 1'b0;
      insert_bit_error_valid <= 1'b0;
    end else begin
      insert_bit_error_old <= insert_bit_error;
      if (!insert_bit_error_old && insert_bit_error) begin
        insert_bit_error_valid <= 1'b1;
      end else begin
        if (prbs_ready && prbs_valid[0]) begin
          insert_bit_error_valid <= 1'b0;
        end
      end
    end
  end

  // insertion place randomization
  wire [$clog2(DATA_WIDTH)-1:0] insertion_place;

  wire [DATA_WIDTH-1:0] prbs_data_post;

  prbs_gen #(
    .DATA_WIDTH($clog2(DATA_WIDTH)),
    .POLYNOMIAL_WIDTH(15)
  ) insertion_place_prbs_inst (
    .clk(clk),
    .rstn(rstn),
    .init(~ber_test),
    .input_ready(insert_bit_error_valid),
    .output_data(insertion_place),
    .output_valid(),
    .polynomial(15'h6000),
    .inverted(1'b0),
    .initial_value(15'h657A)
  );

  assign prbs_data_post = (insert_bit_error_valid) ? prbs_data^(1'b1 << insertion_place) : prbs_data;

  always @(*)
  begin
    m_axis_output_tdata = prbs_data_post;
    m_axis_output_tkeep = {KEEP_WIDTH{1'b1}};
    m_axis_output_tvalid = prbs_valid[0];
  end

endmodule
