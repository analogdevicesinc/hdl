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
// dc filter- y(n) = c*x(n) + (1-c)*y(n-1)

`timescale 1ps/1ps

module ad_dcfilter #(

  // data path disable

  parameter   DISABLE = 0
) (

  // data interface

  input           clk,
  input           valid,
  input   [15:0]  data,
  output          valid_out,
  output  [15:0]  data_out,

  // control interface

  input           dcfilt_enb,
  input   [15:0]  dcfilt_coeff,
  input   [15:0]  dcfilt_offset
);

  // internal registers

  reg     [15:0]  dcfilt_coeff_d = 'd0;
  reg     [47:0]  dc_offset = 'd0;
  reg     [47:0]  dc_offset_d = 'd0;
  reg             valid_d = 'd0;
  reg     [15:0]  data_d = 'd0;
  reg             valid_2d = 'd0;
  reg     [15:0]  data_2d = 'd0;
  reg     [15:0]  data_dcfilt = 'd0;
  reg             valid_int = 'd0;
  reg     [15:0]  data_int = 'd0;

  // internal signals

  wire    [47:0]  dc_offset_s;

  // data-path disable

  generate
  if (DISABLE == 1) begin
  assign valid_out = valid;
  assign data_out = data;
  end else begin
  assign valid_out = valid_int;
  assign data_out = data_int;
  end
  endgenerate

  // dcfilt_coeff is flopped so to remove warnings from vivado

  always @(posedge clk) begin
    dcfilt_coeff_d <= dcfilt_coeff;
  end

  // removing dc offset

  always @(posedge clk) begin
    dc_offset   <= dc_offset_s;
    dc_offset_d <= dc_offset;
    valid_d <= valid;
    if (valid == 1'b1) begin
      data_d <= data + dcfilt_offset;
    end
    valid_2d <= valid_d;
    data_2d  <= data_d;
    data_dcfilt <= data_d - dc_offset[32:17];
    if (dcfilt_enb == 1'b1) begin
      valid_int <= valid_2d;
      data_int  <= data_dcfilt;
    end else begin
      valid_int <= valid_2d;
      data_int  <= data_2d;
    end
  end

  // dsp slice instance ((D-A)*B)+C

  DSP48E1 #(
    .ACASCREG (1),
    .ADREG (1),
    .ALUMODEREG (0),
    .AREG (1),
    .AUTORESET_PATDET ("NO_RESET"),
    .A_INPUT ("DIRECT"),
    .BCASCREG (1),
    .BREG (1),
    .B_INPUT ("DIRECT"),
    .CARRYINREG (0),
    .CARRYINSELREG (0),
    .CREG (1),
    .DREG (0),
    .INMODEREG (0),
    .MASK (48'h3fffffffffff),
    .MREG (1),
    .OPMODEREG (0),
    .PATTERN (48'h000000000000),
    .PREG (1),
    .SEL_MASK ("MASK"),
    .SEL_PATTERN ("PATTERN"),
    .USE_DPORT ("TRUE"),
    .USE_MULT ("MULTIPLY"),
    .USE_PATTERN_DETECT ("NO_PATDET"),
    .USE_SIMD ("ONE48")
  ) i_dsp48e1 (
    .CLK (clk),
    .A ({{14{dc_offset_s[32]}}, dc_offset_s[32:17]}),
    .B ({{2{dcfilt_coeff_d[15]}}, dcfilt_coeff_d}),
    .C (dc_offset_d),
    .D ({{9{data_d[15]}}, data_d}),
    .MULTSIGNIN (1'd0),
    .CARRYIN (1'd0),
    .CARRYCASCIN (1'd0),
    .ACIN (30'd0),
    .BCIN (18'd0),
    .PCIN (48'd0),
    .P (dc_offset_s),
    .MULTSIGNOUT (),
    .CARRYOUT (),
    .CARRYCASCOUT (),
    .ACOUT (),
    .BCOUT (),
    .PCOUT (),
    .ALUMODE (4'd0),
    .CARRYINSEL (3'd0),
    .INMODE (5'b01100),
    .OPMODE (7'b0110101),
    .PATTERNBDETECT (),
    .PATTERNDETECT (),
    .OVERFLOW (),
    .UNDERFLOW (),
    .CEA1 (1'd0),
    .CEA2 (1'd1),
    .CEAD (1'd1),
    .CEALUMODE (1'd0),
    .CEB1 (1'd0),
    .CEB2 (1'd1),
    .CEC (1'd1),
    .CECARRYIN (1'd0),
    .CECTRL (1'd0),
    .CED (1'd1),
    .CEINMODE (1'd0),
    .CEM (1'd1),
    .CEP (1'd0),
    .RSTA (1'd0),
    .RSTALLCARRYIN (1'd0),
    .RSTALUMODE (1'd0),
    .RSTB (1'd0),
    .RSTC (1'd0),
    .RSTCTRL (1'd0),
    .RSTD (1'd0),
    .RSTINMODE (1'd0),
    .RSTM (1'd0),
    .RSTP (1'd0));

endmodule
