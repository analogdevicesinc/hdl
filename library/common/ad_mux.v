// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

// Constraints :  CH_CNT must be power of 2
//  Build a large mux from smaller ones defined by the MUX_SZ parameter
//  Use EN_REG to add a register at the output of the small muxes to  help
//  timing closure.

module ad_mux #(
  parameter CH_W = 16,   // Width of input channel
  parameter CH_CNT = 64,  // Number of input channels
  parameter REQ_MUX_SZ = 8,  // Size of mux which acts as a building block
  parameter EN_REG = 1,  // Enable register at output of each mux
  parameter DW = CH_W*CH_CNT
) (
  input clk,
  input [DW-1:0] data_in,
  input [$clog2(CH_CNT)-1:0] ch_sel,
  output [CH_W-1:0] data_out
);

  `define MIN(A,B) (A<B?A:B)

  localparam MUX_SZ = CH_CNT < REQ_MUX_SZ ? CH_CNT : REQ_MUX_SZ;
  localparam CLOG2_CH_CNT = $clog2(CH_CNT);
  localparam CLOG2_MUX_SZ = $clog2(MUX_SZ);
  localparam NUM_STAGES = ($clog2(CH_CNT) / $clog2(MUX_SZ)) + // divide and round up
                         |($clog2(CH_CNT) % $clog2(MUX_SZ));

  wire [NUM_STAGES*DW+CH_W-1:0] mux_in;
  wire [NUM_STAGES*CLOG2_CH_CNT-1:0] ch_sel_pln;

  assign mux_in[DW-1:0] = data_in;
  assign ch_sel_pln[CLOG2_CH_CNT-1:0] = ch_sel;

  genvar i;
  genvar j;

  generate

    for (i = 0; i < NUM_STAGES; i = i + 1) begin: g_stage

      wire [CLOG2_CH_CNT-1:0] ch_sel_cur;
      assign ch_sel_cur = ch_sel_pln[i*CLOG2_CH_CNT+:CLOG2_CH_CNT];

      wire [CLOG2_MUX_SZ-1:0] ch_sel_w;
      assign ch_sel_w = ch_sel_cur >> i*CLOG2_MUX_SZ;

      if (EN_REG) begin
        reg [CLOG2_CH_CNT-1:0] ch_sel_d;
        always @(posedge clk) begin
          ch_sel_d <= ch_sel_cur;
        end
        if (i<NUM_STAGES-1) begin
          assign ch_sel_pln[(i+1)*CLOG2_CH_CNT+:CLOG2_CH_CNT] = ch_sel_d;
        end
      end else begin
        if (i<NUM_STAGES-1) begin
          assign ch_sel_pln[(i+1)*CLOG2_CH_CNT+:CLOG2_CH_CNT] = ch_sel_cur;
        end
      end

      localparam MAX_RANGE_PER_STAGE=MUX_SZ**(NUM_STAGES-i);

      for (j = 0; j < `MIN(MAX_RANGE_PER_STAGE,CH_CNT); j = j + MUX_SZ) begin: g_mux

        ad_mux_core #(
          .CH_W (CH_W),
          .CH_CNT (MUX_SZ),
          .EN_REG (EN_REG)
        ) i_mux (
          .clk (clk),
          .data_in (mux_in[i*DW+j*CH_W+:MUX_SZ*CH_W]),
          .ch_sel (ch_sel_w),
          .data_out (mux_in[(i+1)*DW+(j/MUX_SZ)*CH_W+:CH_W]));
      end
    end

  endgenerate

  assign data_out = mux_in[NUM_STAGES*DW+:CH_W];

endmodule
