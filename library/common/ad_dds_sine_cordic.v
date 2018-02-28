// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsabilities that he or she has by using this source/core.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad_dds_sine_cordic #(

  // Range = 8-24
  parameter   PHASE_DW = 16,
  // Range = 8-24
  parameter   CORDIC_DW = 16,
  // Range = N/A
  parameter   DELAY_DW  = 1) (

  // interface

  input                        clk,
  input      [ PHASE_DW-1:0]   angle,
  output reg [CORDIC_DW-1:0]   sine,
  output reg [CORDIC_DW-1:0]   cosine,
  input      [ DELAY_DW-1:0]   ddata_in,
  output reg [ DELAY_DW-1:0]   ddata_out);

  // Local Parameters

  // angle rotation values
  localparam LUT_FSCALE = 1 << (PHASE_DW);
  localparam ANGLE_ROT_VAL_0  = 45.000000000000000;
  localparam ANGLE_ROT_VAL_1  = 26.565051177078000;
  localparam ANGLE_ROT_VAL_2  = 14.036243467926500;
  localparam ANGLE_ROT_VAL_3  = 7.1250163489018000;
  localparam ANGLE_ROT_VAL_4  = 3.5763343749973500;
  localparam ANGLE_ROT_VAL_5  = 1.7899106082460700;
  localparam ANGLE_ROT_VAL_6  = 0.8951737102110740;
  localparam ANGLE_ROT_VAL_7  = 0.4476141708605530;
  localparam ANGLE_ROT_VAL_8  = 0.2238105003685380;
  localparam ANGLE_ROT_VAL_9  = 0.1119056770662070;
  localparam ANGLE_ROT_VAL_10 = 0.0559528918938037;
  localparam ANGLE_ROT_VAL_11 = 0.0279764526170037;
  localparam ANGLE_ROT_VAL_12 = 0.0139882271422650;
  localparam ANGLE_ROT_VAL_13 = 0.0069941136753529;
  localparam ANGLE_ROT_VAL_14 = 0.0034970568507040;
  localparam ANGLE_ROT_VAL_15 = 0.0017485284269805;
  localparam ANGLE_ROT_VAL_16 = 0.0008742642136938;
  localparam ANGLE_ROT_VAL_17 = 0.0004371321068723;
  localparam ANGLE_ROT_VAL_18 = 0.0002185660534393;
  localparam ANGLE_ROT_VAL_19 = 0.0001092830267201;
  localparam ANGLE_ROT_VAL_20 = 0.0000546415133601;
  localparam ANGLE_ROT_VAL_21 = 0.0000273207566800;
  localparam ANGLE_ROT_VAL_22 = 0.0000136603783400;
  localparam ANGLE_ROT_VAL_23 = 0.0000068301891700;

  // 1.64676025812 = system gain

  localparam X_FSCALE = 1 << (CORDIC_DW);
  localparam [CORDIC_DW-1:0] X_VALUE = ((X_FSCALE/2)/1.64676025812)-3; // ((2^N)/2)/1.647...

  // Registers Declarations

  reg  [CORDIC_DW-1:0] x0  = 'd0;
  reg  [CORDIC_DW-1:0] y0  = 'd0;
  reg  [ PHASE_DW-1:0] z0  = 'd0;

  // Wires Declarations

  wire [CORDIC_DW-1:0] x_s       [0:CORDIC_DW-1];
  wire [CORDIC_DW-1:0] y_s       [0:CORDIC_DW-1];
  wire [ PHASE_DW-1:0] z_s       [0:CORDIC_DW-1];
  wire [ DELAY_DW-1:0] data_in_d [0:CORDIC_DW-1];
  wire [ PHASE_DW-1:0] atan_table[0:CORDIC_DW-2];
  wire [          1:0] quadrant;

  // arc tangent LUT
  generate
      assign atan_table[0 ] = (LUT_FSCALE * ANGLE_ROT_VAL_0 )/360;
      assign atan_table[1 ] = (LUT_FSCALE * ANGLE_ROT_VAL_1 )/360;
      assign atan_table[2 ] = (LUT_FSCALE * ANGLE_ROT_VAL_2 )/360;
      assign atan_table[3 ] = (LUT_FSCALE * ANGLE_ROT_VAL_3 )/360;
      assign atan_table[4 ] = (LUT_FSCALE * ANGLE_ROT_VAL_4 )/360;
      assign atan_table[5 ] = (LUT_FSCALE * ANGLE_ROT_VAL_5 )/360;
      assign atan_table[6 ] = (LUT_FSCALE * ANGLE_ROT_VAL_6 )/360;
      assign atan_table[7 ] = (LUT_FSCALE * ANGLE_ROT_VAL_7 )/360;
    if (PHASE_DW >= 9) begin
      assign atan_table[8 ] = (LUT_FSCALE * ANGLE_ROT_VAL_8 )/360;
    end
    if (PHASE_DW >= 10) begin
      assign atan_table[9 ] = (LUT_FSCALE * ANGLE_ROT_VAL_9 )/360;
    end
    if (PHASE_DW >= 11) begin
      assign atan_table[10] = (LUT_FSCALE * ANGLE_ROT_VAL_10)/360;
    end
    if (PHASE_DW >= 12) begin
      assign atan_table[11] = (LUT_FSCALE * ANGLE_ROT_VAL_11)/360;
    end
    if (PHASE_DW >= 13) begin
      assign atan_table[12] = (LUT_FSCALE * ANGLE_ROT_VAL_12)/360;
    end
    if (PHASE_DW >= 14) begin
      assign atan_table[13] = (LUT_FSCALE * ANGLE_ROT_VAL_13)/360;
    end
    if (PHASE_DW >= 15) begin
      assign atan_table[14] = (LUT_FSCALE * ANGLE_ROT_VAL_14)/360;
    end
    if (PHASE_DW >= 16) begin
      assign atan_table[15] = (LUT_FSCALE * ANGLE_ROT_VAL_15)/360;
    end
    if (PHASE_DW >= 17) begin
      assign atan_table[16] = (LUT_FSCALE * ANGLE_ROT_VAL_16)/360;
    end
    if (PHASE_DW >= 18) begin
      assign atan_table[17] = (LUT_FSCALE * ANGLE_ROT_VAL_17)/360;
    end
    if (PHASE_DW >= 19) begin
      assign atan_table[18] = (LUT_FSCALE * ANGLE_ROT_VAL_18)/360;
    end
    if (PHASE_DW >= 20) begin
      assign atan_table[19] = (LUT_FSCALE * ANGLE_ROT_VAL_19)/360;
    end
    if (PHASE_DW >= 21) begin
      assign atan_table[20] = (LUT_FSCALE * ANGLE_ROT_VAL_20)/360;
    end
    if (PHASE_DW >= 22) begin
      assign atan_table[21] = (LUT_FSCALE * ANGLE_ROT_VAL_21)/360;
    end
    if (PHASE_DW >= 23) begin
      assign atan_table[22] = (LUT_FSCALE * ANGLE_ROT_VAL_22)/360;
    end
    if (PHASE_DW == 24) begin
      assign atan_table[23] = (LUT_FSCALE * ANGLE_ROT_VAL_23)/360;
    end
  endgenerate

  // pre-rotating

  // first two bits represent the quadrant in the unit circle
  assign   quadrant = angle[PHASE_DW-1:PHASE_DW-2];

  always @(posedge clk) begin
    case (quadrant)
      2'b00,
      2'b11: begin
         x0 <= X_VALUE;
         y0 <= 0;
         z0 <= angle;
      end

      2'b01: begin
         x0 <= 0;
         y0 <= X_VALUE;
         z0 <= {2'b00, angle[PHASE_DW-3:0]};
      end

      2'b10: begin
         x0 <= 0;
         y0 <= -X_VALUE;
         z0 <= {2'b11, angle[PHASE_DW-3:0]};
      end
    endcase
  end

  assign x_s[0] = x0;
  assign y_s[0] = y0;
  assign z_s[0] = z0;
  assign data_in_d[0] = ddata_in;

  // cordic pipeline

  genvar i;

  generate
  for (i=0; i < PHASE_DW-1; i=i+1) begin: rotation
      ad_dds_cordic_pipe #(
        .P_DW (PHASE_DW),
        .D_DW (CORDIC_DW),
        .DELAY_DW (DELAY_DW),
        .SHIFT(i))
      pipe (
        .clk (clk),
        .dataa_x (x_s[i]),
        .dataa_y (y_s[i]),
        .dataa_z (z_s[i]),
        .datab_z (atan_table[i]),
        .dir (z_s[i][PHASE_DW-1]),
        .result_x (x_s[i+1]),
        .result_y (y_s[i+1]),
        .result_z (z_s[i+1]),
        .data_delay_in (data_in_d[i]),
        .data_delay_out (data_in_d[i+1])
      );
    end
  endgenerate

  // x and y are cos(angle) and sin(angle)

  always @(posedge clk) begin
    ddata_out <= data_in_d[PHASE_DW-1];
    sine <= y_s[PHASE_DW-1];
    cosine <= x_s[PHASE_DW-1];
  end

endmodule

// ***************************************************************************
// ***************************************************************************
