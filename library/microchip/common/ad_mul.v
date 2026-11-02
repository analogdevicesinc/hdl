// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

`timescale 1ps/1ps

module ad_mul #(

  parameter   A_DATA_WIDTH = 17,
  parameter   B_DATA_WIDTH = 17,
  parameter   DELAY_DATA_WIDTH = 16
) (

  input                                     clk,
  input   [               A_DATA_WIDTH-1:0] data_a,
  input   [               B_DATA_WIDTH-1:0] data_b,
  output  reg [A_DATA_WIDTH + B_DATA_WIDTH-1:0] data_p = 'd0,

  input       [(DELAY_DATA_WIDTH-1):0]  ddata_in,
  output  reg [(DELAY_DATA_WIDTH-1):0]  ddata_out = 'd0
);

  reg signed [A_DATA_WIDTH-1:0] a_d = 'd0;
  reg signed [B_DATA_WIDTH-1:0] b_d = 'd0;
  reg signed [A_DATA_WIDTH + B_DATA_WIDTH-1:0] p_d = 'd0;
  reg [(DELAY_DATA_WIDTH-1):0] p1_ddata = 'd0;
  reg [(DELAY_DATA_WIDTH-1):0] p2_ddata = 'd0;

  // latency 3 (input, multiplier and output registers), as the Xilinx
  // (MULT_MACRO LATENCY 3) and Intel (lpm_pipeline 3) ones: ddata_out is
  // aligned with data_p

  always @(posedge clk) begin
    a_d <= $signed(data_a);
    b_d <= $signed(data_b);
    p_d <= a_d * b_d;
    data_p <= p_d;

    p1_ddata <= ddata_in;
    p2_ddata <= p1_ddata;
    ddata_out <= p2_ddata;
  end

endmodule
