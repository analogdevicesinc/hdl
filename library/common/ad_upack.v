// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

// Unpacker:
//   - unpack O_W number of data units from I_W number of data units
//   - data unit defined in bits by UNIT_W e.g 8 is a byte
//
// Constraints:
//   - O_W < I_W
//   - LATENCY 1
//   - no backpressure
//
// Data format:
//  idata  [U(I_W-1) .... U(0)]
//  odata  [U(O_W-1) .... U(0)]
//
// e.g
//  I_W = 6
//  O_W = 4
//  UNIT_W = 8
//
//  idata : [B5,B4,B3,B2,B1,B0],[B11,B10,B9,B8,B7,B6]
//  odata :                     [B3,B2,B1,B0],[B7,B6,B5,B4],[B11,B10,B9,B8]
//

module ad_upack #(
  parameter I_W = 4,
  parameter O_W = 3,
  parameter UNIT_W = 8,
  parameter O_REG = 1
) (
  input                   clk,
  input                   reset,
  input [I_W*UNIT_W-1:0]  idata,
  input                   ivalid,
  output                  iready,

  output reg [O_W*UNIT_W-1:0] odata = 'h0,
  output reg                  ovalid = 'b0
);

  // The Width of the shift reg is an integer multiple of output data width
  localparam SH_W = ((I_W/O_W) + ((I_W%O_W) > 0) + ((O_W % (I_W - ((I_W/O_W)*O_W) + ((I_W%O_W) == 0))) > 0))*O_W;
  // The Step of the algorithm is the greatest common divisor of I_W and O_W
  localparam STEP = gcd(I_W, O_W);

  localparam LATENCY = 1; // Minimum input latency from iready to ivalid

  integer i;

  reg [SH_W*UNIT_W-1:0] idata_sh;
  reg [SH_W*UNIT_W-1:0] idata_d = 'h0;
  reg [SH_W*UNIT_W-1:0] idata_d_nx;
  reg [SH_W-1:0] in_use = 'h0;
  reg [SH_W-1:0] inmask;

  wire [SH_W-1:0] out_mask = {O_W{1'b1}};
  wire [SH_W-1:0] in_use_nx;
  wire [SH_W-1:0] unit_valid;
  wire [O_W*UNIT_W-1:0] odata_s;
  wire                  ovalid_s;

  function [31:0] gcd;
    input [31:0]  a;
    input [31:0]  b;
    begin
      while (a != b) begin
        if (a > b) begin
          a = a-b;
        end else begin
          b = b-a;
        end
      end
      gcd = a;
    end
  endfunction

  assign unit_valid = (in_use | inmask);
  assign in_use_nx = unit_valid >> O_W;

  always @(posedge clk) begin
    if (reset) begin
      in_use <= 'h0;
    end else if (ovalid_s) begin
      in_use <= in_use_nx;
    end
  end

  always @(*) begin
    inmask = {I_W{ivalid}};
    for (i = STEP; i < O_W; i=i+STEP) begin
      if (in_use[i-1]) begin
        inmask = {I_W{ivalid}} << i;
      end
    end
  end

  always @(*) begin
    idata_d_nx = idata_d;
    if (ivalid) begin
      idata_d_nx = {{(SH_W-I_W)*UNIT_W{1'b0}},idata};
      for (i = STEP; i < O_W; i=i+STEP) begin
        if (in_use[i-1]) begin
          idata_d_nx = (idata << UNIT_W*i) | idata_d;
        end
      end
    end
  end

  always @(posedge clk) begin
    if (ovalid_s) begin
      idata_d <= idata_d_nx >> O_W*UNIT_W;
    end
  end

  assign iready = ~unit_valid[LATENCY*O_W + O_W -1];

  assign odata_s = idata_d_nx[O_W*UNIT_W-1:0];
  assign ovalid_s = unit_valid[O_W-1];

  generate
    if (O_REG) begin : o_reg

      always @(posedge clk) begin
        if (reset) begin
          ovalid <= 1'b0;
        end else begin
          ovalid <= ovalid_s;
        end
      end

      always @(posedge clk) begin
        odata <= odata_s;
      end

    end else begin

      always @(*) begin
        odata = odata_s;
        ovalid = ovalid_s;
      end

    end
  endgenerate

endmodule
