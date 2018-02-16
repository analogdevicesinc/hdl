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

  // Range = 14, 16, 18 and 20
  parameter   CORDIC_DW = 16,
  // Range = N/A
  parameter   DELAY_DW  = 1) (

  // interface

  input                        clk,
  input      [CORDIC_DW-1:0]   angle,
  output reg [CORDIC_DW-1:0]   sine,
  output reg [CORDIC_DW-1:0]   cosine,
  input      [ DELAY_DW-1:0]   ddata_in,
  output reg [ DELAY_DW-1:0]   ddata_out);

  // Local Parameters

  // 1.647 = gain of the system
  localparam [19:0] X_VALUE_20 = 318327; // ((2^20)/2)/1.647
  localparam [17:0] X_VALUE_18 =  79582; // ((2^18)/2)/1.647
  localparam [15:0] X_VALUE_16 =  19891; // ((2^16)/2)/1.647
  localparam [13:0] X_VALUE_14 =   4972; // ((2^14)/2)/1.647

  // Registers Declarations

  reg  [CORDIC_DW-1:0] x0  = 'd0;
  reg  [CORDIC_DW-1:0] y0  = 'd0;
  reg  [CORDIC_DW-1:0] z0  = 'd0;

  // Wires Declarations

  wire [CORDIC_DW-1:0] x_value;
  wire [CORDIC_DW-1:0] x_s       [0:CORDIC_DW-1];
  wire [CORDIC_DW-1:0] y_s       [0:CORDIC_DW-1];
  wire [CORDIC_DW-1:0] z_s       [0:CORDIC_DW-1];
  wire [ DELAY_DW-1:0] data_in_d [0:CORDIC_DW-1];
  wire [CORDIC_DW-1:0] atan_table[0:CORDIC_DW-2];
  wire [          1:0] quadrant;

  // arc tangent LUT

  generate
    if (CORDIC_DW == 20) begin
      assign x_value = X_VALUE_20;
      assign atan_table[ 0] = 20'b00100000000000000000; // 45
      assign atan_table[ 1] = 20'b00010010111001000000; // 26.56505118
      assign atan_table[ 2] = 20'b00001001111110110100; // 14.03624347
      assign atan_table[ 3] = 20'b00000101000100010001; // 7.125016349
      assign atan_table[ 4] = 20'b00000010100010110001; // 3.576334375
      assign atan_table[ 5] = 20'b00000001010001011101; // 1.789910608
      assign atan_table[ 6] = 20'b00000000101000101111; // 0.895173710
      assign atan_table[ 7] = 20'b00000000010100011000; // 0.447614171
      assign atan_table[ 8] = 20'b00000000001010001100; // 0.223810500
      assign atan_table[ 9] = 20'b00000000000101000110; // 0.111905677
      assign atan_table[10] = 20'b00000000000010100011; // 0.055952892
      assign atan_table[11] = 20'b00000000000001010001; // 0.027976453
      assign atan_table[12] = 20'b00000000000000101001; // 0.013988227
      assign atan_table[13] = 20'b00000000000000010100; // 0.006994114
      assign atan_table[14] = 20'b00000000000000001010; // 0.003497057
      assign atan_table[15] = 20'b00000000000000000101; // 0.001748528
      assign atan_table[16] = 20'b00000000000000000011; // 0.000874264
      assign atan_table[17] = 20'b00000000000000000001; // 0.000437132
      assign atan_table[18] = 20'b00000000000000000001; // 0.000218566
    end else if (CORDIC_DW == 18) begin
      assign x_value = X_VALUE_18;
      assign atan_table[ 0] = 18'b001000000000000000; // 45
      assign atan_table[ 1] = 18'b000100101110010000; // 26.56505118
      assign atan_table[ 2] = 18'b000010011111101101; // 14.03624347
      assign atan_table[ 3] = 18'b000001010001000100; // 7.125016349
      assign atan_table[ 4] = 18'b000000101000101100; // 3.576334375
      assign atan_table[ 5] = 18'b000000010100010111; // 1.789910608
      assign atan_table[ 6] = 18'b000000001010001100; // 0.895173710
      assign atan_table[ 7] = 18'b000000000101000110; // 0.447614171
      assign atan_table[ 8] = 18'b000000000010100011; // 0.223810500
      assign atan_table[ 9] = 18'b000000000001010001; // 0.111905677
      assign atan_table[10] = 18'b000000000000101001; // 0.055952892
      assign atan_table[11] = 18'b000000000000010100; // 0.027976453
      assign atan_table[12] = 18'b000000000000001010; // 0.013988227
      assign atan_table[13] = 18'b000000000000000101; // 0.006994114
      assign atan_table[14] = 18'b000000000000000011; // 0.003497057
      assign atan_table[15] = 18'b000000000000000001; // 0.001748528
      assign atan_table[16] = 18'b000000000000000001; // 0.000874264
    end else if (CORDIC_DW == 16) begin
      assign x_value = X_VALUE_16;
      assign atan_table[ 0] = 15'b0010000000000000; // 45
      assign atan_table[ 1] = 15'b0001001011100100; // 26.56505118
      assign atan_table[ 2] = 15'b0000100111111011; // 14.03624347
      assign atan_table[ 3] = 15'b0000010100010001; // 7.125016349
      assign atan_table[ 4] = 15'b0000001010001011; // 3.576334375
      assign atan_table[ 5] = 15'b0000000101000110; // 1.789910608
      assign atan_table[ 6] = 15'b0000000010100011; // 0.895173710
      assign atan_table[ 7] = 15'b0000000001010001; // 0.447614171
      assign atan_table[ 8] = 15'b0000000000101001; // 0.223810500
      assign atan_table[ 9] = 15'b0000000000010100; // 0.111905677
      assign atan_table[10] = 15'b0000000000001010; // 0.055952892
      assign atan_table[11] = 15'b0000000000000101; // 0.027976453
      assign atan_table[12] = 15'b0000000000000011; // 0.013988227
      assign atan_table[13] = 15'b0000000000000001; // 0.006994114
      assign atan_table[14] = 15'b0000000000000001; // 0.003497057
    end else if (CORDIC_DW == 14) begin
      assign x_value = X_VALUE_14;
      assign atan_table[ 0] = 13'b00100000000000; // 45
      assign atan_table[ 1] = 13'b00010010111001; // 26.56505118
      assign atan_table[ 2] = 13'b00001001111111; // 14.03624347
      assign atan_table[ 3] = 13'b00000101000100; // 7.125016349
      assign atan_table[ 4] = 13'b00000010100011; // 3.576334375
      assign atan_table[ 5] = 13'b00000001010001; // 1.789910608
      assign atan_table[ 6] = 13'b00000000101001; // 0.895173710
      assign atan_table[ 7] = 13'b00000000010100; // 0.447614171
      assign atan_table[ 8] = 13'b00000000001010; // 0.223810500
      assign atan_table[ 9] = 13'b00000000000101; // 0.111905677
      assign atan_table[10] = 13'b00000000000011; // 0.055952892
      assign atan_table[11] = 13'b00000000000001; // 0.027976453
      assign atan_table[12] = 13'b00000000000001; // 0.013988227
    end
  endgenerate

  // pre-rotating

  // first two bits represent the quadrant in the unit circle
  assign   quadrant = angle[CORDIC_DW-1:CORDIC_DW-2];

  always @(posedge clk) begin
    case (quadrant)
      2'b00,
      2'b11: begin
         x0 <= x_value;
         y0 <= 0;
         z0 <= angle;
      end

      2'b01: begin
         x0 <= 0;
         y0 <= x_value;
         z0 <= {2'b00, angle[CORDIC_DW-3:0]};
      end

      2'b10: begin
         x0 <= 0;
         y0 <= -x_value;
         z0 <= {2'b11, angle[CORDIC_DW-3:0]};
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
  for (i=0; i < CORDIC_DW-1; i=i+1) begin: rotation
      ad_dds_cordic_pipe #(
        .DW (CORDIC_DW),
        .DELAY_DW (DELAY_DW),
        .SHIFT(i))
      pipe (
        .clk (clk),
        .dataa_x (x_s[i]),
        .dataa_y (y_s[i]),
        .dataa_z (z_s[i]),
        .datab_z (atan_table[i]),
        .dir (z_s[i][CORDIC_DW-1]),
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
    ddata_out <= data_in_d[CORDIC_DW-1];
    sine <= y_s[CORDIC_DW-1];
    cosine <= x_s[CORDIC_DW-1];
  end

endmodule

// ***************************************************************************
// ***************************************************************************
