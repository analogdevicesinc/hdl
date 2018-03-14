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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1 ns / 1 ns

module fir_decim #(
  parameter USE_DSP48E = 1
) (
  input clk,
  input clk_enable,
  input reset,
  input signed [11:0] filter_in,
  output reg signed [25:0] filter_out,
  output reg ce_out
);

  localparam signed [11:0] coeffphase1_1 = 12'b000011010101; //sfix12_En11
  localparam signed [11:0] coeffphase1_2 = 12'b011011110010; //sfix12_En11
  localparam signed [11:0] coeffphase1_3 = 12'b110000111110; //sfix12_En11

  // We know that clk_enable is asserted at most every 5th clock cycle and the
  // output is decimated by two. So we have 10 clock cycles to compute the
  // result. That's plenty of time considering that there are only 6
  // coefficients.

  reg active = 1'b0;
  reg active_d1 = 1'b0;
  reg active_d2 = 1'b0;

  reg [1:0] count = 2'b00;
  reg phase = 1'b1;
  reg ready = 1'b0;

  reg [3:0] storage0[0:11];
  reg [3:0] storage1[0:11];

  reg signed [11:0] data0;
  reg signed [11:0] data1;

  reg signed [11:0] coeff;

  wire signed [25:0] sum;

  integer j;

  initial begin
    for (j = 0; j < 12; j = j + 1) begin
      storage0[j] <= 'h00;
      storage1[j] <= 'h00;
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      phase <= 1'b1;
    end else begin
      if (clk_enable == 1'b1) begin
        phase <= phase + 1'b1;
      end
    end
  end

  always @(posedge clk) begin
    if (clk_enable == 1'b1 && phase == 1'b1) begin
      active <= 1'b1;
    end else if (count == 'h2) begin
      active <= 1'b0;
    end
    active_d1 <= active;
    active_d2 <= active_d1;
  end

  always @(posedge clk) begin
    if (active == 1'b1) begin
      case (count)
      'h2: count <= 'h0;
      default: count <= count + 1'b1;
      endcase
    end
  end

  always @(posedge clk) begin
    if (active_d1 == 1'b0 && active_d2 == 1'b1) begin
      ready <= 1'b1;
    end else begin
      ready <= 1'b0;
    end
  end

  generate
  genvar i;
  for (i = 0; i < 12; i = i + 1) begin
    always @(posedge clk) begin
      if (clk_enable == 1'b1) begin
        if (phase == 1'b0) begin
          storage0[i] <= {storage0[i][2:0],filter_in[i]};
        end
        if (phase == 1'b1) begin
          storage1[i] <= {storage1[i][2:0],filter_in[i]};
        end
      end
    end

    always @(*) begin
      data0[i] <= storage0[i][2-count];
      data1[i] <= storage1[i][count];
    end
  end
  endgenerate

  always @(*) begin
    case (count)
    'h0: coeff <= coeffphase1_1;
    'h1: coeff <= coeffphase1_2;
    'h2: coeff <= coeffphase1_3;
    default: coeff <= 'h00;
    endcase
  end

  generate if (USE_DSP48E) begin
    wire [47:0] _sum;
    wire [6:0] opmode = {1'b0,active_d2,5'b00101};

    // Can't exceed 26 bit.
    assign sum = _sum[43:18];

    // MAC with pre-adder
    DSP48E1 #(
      .ACASCREG (0),
      .ADREG (1),
      .ALUMODEREG (0),
      .AREG (0),
      .AUTORESET_PATDET ("NO_RESET"),
      .A_INPUT ("DIRECT"),
      .BCASCREG (1),
      .BREG (1),
      .B_INPUT ("DIRECT"),
      .CARRYINREG (0),
      .CARRYINSELREG (0),
      .CREG (0),
      .DREG (0),
      .INMODEREG (0),
      .MASK (48'h3fffffffffff),
      .MREG (1),
      .OPMODEREG (1),
      .PATTERN (48'h000000000000),
      .PREG (1),
      .SEL_MASK ("MASK"),
      .SEL_PATTERN ("PATTERN"),
      .USE_DPORT ("TRUE"),
      .USE_MULT ("MULTIPLY"),
      .USE_PATTERN_DETECT ("NO_PATDET"),
      .USE_SIMD ("ONE48"))
  i_dsp_mac (
    .CLK (clk),
    .A ({5'h0,data0[11],data0,12'h0}), // MSB aligned to 24-bit, 25th bit signed extended
    .B ({coeff,6'b0}),
    .C (48'h00),
    .D ({data1[11],data1,12'h0}),
    .MULTSIGNIN (1'b0),
    .CARRYIN (1'b0),
    .CARRYCASCIN (1'b0),
    .ACIN (30'h0),
    .BCIN (18'h0),
    .PCIN (48'h0),
    .P (_sum),
    .MULTSIGNOUT (),
    .CARRYOUT (),
    .CARRYCASCOUT (),
    .ACOUT (),
    .BCOUT (),
    .PCOUT (),
    .ALUMODE (4'b0000),
    .CARRYINSEL (3'h0),
    .INMODE (5'b00100),
    .OPMODE (opmode),
    .PATTERNBDETECT (),
    .PATTERNDETECT (),
    .OVERFLOW (),
    .UNDERFLOW (),
    .CEA1 (1'b0),
    .CEA2 (1'b0),
    .CEAD (active),
    .CEALUMODE (1'b0),
    .CEB1 (1'b0),
    .CEB2 (active),
    .CEC (1'b0),
    .CECARRYIN (1'b0),
    .CECTRL (active),
    .CED (1'b0),
    .CEINMODE (1'b0),
    .CEM (active_d1),
    .CEP (active_d2),
    .RSTA (1'b0),
    .RSTALLCARRYIN (1'b0),
    .RSTALUMODE (1'b0),
    .RSTB (1'b0),
    .RSTC (1'b0),
    .RSTCTRL (1'b0),
    .RSTD (1'b0),
    .RSTINMODE (1'b0),
    .RSTM (1'b0),
    .RSTP (1'b0)
  );

  end else begin
    reg signed [25:0] _sum = 'h00;
    reg signed [12:0] pre_adder;
    reg signed [11:0] coeff_d1;
    reg signed [23:0] product = 'h00;

    assign sum = _sum;

    always @(posedge clk) begin
      if (active == 1'b1) begin
        pre_adder <= data0 + data1;
        coeff_d1 <= coeff;
      end

      if (active_d1 == 1'b1) begin
        product <= coeff_d1 * pre_adder;
      end

      if (reset == 1'b1 || ready == 1'b1) begin
        _sum <= 'h00;
      end else if (active_d2 == 1'b1) begin
        _sum <= _sum + product;
      end
    end
  end
  endgenerate

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      ce_out <= 1'b0;
    end else begin
      ce_out <= ready;
    end
  end

  always @(posedge clk) begin
    if (ready == 1'b1) begin
      filter_out <= sum;
    end
  end

endmodule
