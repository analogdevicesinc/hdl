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

module prbs_gen #(

  parameter DATA_WIDTH = 32,
  parameter POLYNOMIAL_WIDTH = 32
) (

  input  wire                        clk,
  input  wire                        rstn,

  input  wire                        init,

  input  wire                        input_ready,
  output wire [DATA_WIDTH-1:0]       output_data,
  output reg                         output_valid,

  input  wire [POLYNOMIAL_WIDTH-1:0] polynomial,
  input  wire                        inverted,

  input  wire [DATA_WIDTH-1:0]       initial_value
);

  /* Common polynomials:
   * 7'h60 // PRBS7
   * 9'h110 // PRBS9
   * 11'h500 // PRBS11
   * 13'h1B00 // PRBS13
   * 15'h6000 // PRBS15
   * 20'h80004 // PRBS20
   * 23'h420000 // PRBS23
   * 31'h48000000 // PRBS31
   * 48'hC00000000000 // PRBS48
   */

  localparam MAX_WIDTH = (DATA_WIDTH > POLYNOMIAL_WIDTH) ? DATA_WIDTH : POLYNOMIAL_WIDTH;

  reg  [DATA_WIDTH-1:0]       internal_data;
  wire [DATA_WIDTH-1:0]       calculated_prbs_data;

  reg  [POLYNOMIAL_WIDTH-1:0] internal_state;
  wire [POLYNOMIAL_WIDTH-1:0] polynomial_state;

  prbs #(
    .DATA_WIDTH(DATA_WIDTH),
    .POLYNOMIAL_WIDTH(POLYNOMIAL_WIDTH)
  ) prbs_inst (
    .input_data(internal_state),
    .polynomial(polynomial),
    .inverted(inverted),
    .state(polynomial_state),
    .output_data(calculated_prbs_data)
  );

  always @(posedge clk)
  begin
    if (!rstn) begin
      internal_data <= initial_value;
      internal_state <= {{MAX_WIDTH-DATA_WIDTH{1'b0}}, initial_value};
      output_valid <= 1'b0;
    end else begin
      if (init) begin
        internal_data <= initial_value;
        internal_state <= {{MAX_WIDTH-DATA_WIDTH{1'b0}}, initial_value};
        output_valid <= 1'b0;
      end else begin
        if (input_ready) begin
          internal_data <= calculated_prbs_data;
          internal_state <= polynomial_state;
          output_valid <= 1'b1;
        end
      end
    end
  end

  assign output_data = internal_data;

endmodule
