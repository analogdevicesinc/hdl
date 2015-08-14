// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//    
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// dc filter- y(n) = c*x(n) + (1-c)*y(n-1)

`timescale 1ps/1ps

module DSP48E1 (

  ACOUT,
  BCOUT,
  CARRYCASCOUT,
  CARRYOUT,
  MULTSIGNOUT,
  OVERFLOW,
  P,
  PATTERNBDETECT,
  PATTERNDETECT,
  PCOUT,
  UNDERFLOW,
  A,
  ACIN,
  ALUMODE,
  B,
  BCIN,
  C,
  CARRYCASCIN,
  CARRYIN,
  CARRYINSEL,
  CEA1,
  CEA2,
  CEAD,
  CEALUMODE,
  CEB1,
  CEB2,
  CEC,
  CECARRYIN,
  CECTRL,
  CED,
  CEINMODE,
  CEM,
  CEP,
  CLK,
  D,
  INMODE,
  MULTSIGNIN,
  OPMODE,
  PCIN,
  RSTA,
  RSTALLCARRYIN,
  RSTALUMODE,
  RSTB,
  RSTC,
  RSTCTRL,
  RSTD,
  RSTINMODE,
  RSTM,
  RSTP);

  parameter ACASCREG = 1;
  parameter ADREG = 1;
  parameter ALUMODEREG = 1;
  parameter AREG = 1;
  parameter AUTORESET_PATDET = "NO_RESET";
  parameter A_INPUT = "DIRECT";
  parameter BCASCREG = 1;
  parameter BREG = 1;
  parameter B_INPUT = "DIRECT";
  parameter CARRYINREG = 1;
  parameter CARRYINSELREG = 1;
  parameter CREG = 1;
  parameter DREG = 1;
  parameter INMODEREG = 1;
  parameter MASK = 'h3fffffffffff;
  parameter MREG = 1;
  parameter OPMODEREG = 1;
  parameter PATTERN = 0;
  parameter PREG = 1;
  parameter SEL_MASK = "MASK";
  parameter SEL_PATTERN = "PATTERN";
  parameter USE_DPORT = 0;
  parameter USE_MULT = "MULTIPLY";
  parameter USE_PATTERN_DETECT = "NO_PATDET";
  parameter USE_SIMD = "ONE48";

  output  [29:0]  ACOUT;
  output  [17:0]  BCOUT;
  output          CARRYCASCOUT;
  output  [ 3:0]  CARRYOUT;
  output          MULTSIGNOUT;
  output          OVERFLOW;
  output  [47:0]  P;
  output          PATTERNBDETECT;
  output          PATTERNDETECT;
  output  [47:0]  PCOUT;
  output          UNDERFLOW;
  input   [29:0]  A;
  input   [29:0]  ACIN;
  input   [ 3:0]  ALUMODE;
  input   [17:0]  B;
  input   [17:0]  BCIN;
  input   [47:0]  C;
  input           CARRYCASCIN;
  input           CARRYIN;
  input   [ 2:0]  CARRYINSEL;
  input           CEA1;
  input           CEA2;
  input           CEAD;
  input           CEALUMODE;
  input           CEB1;
  input           CEB2;
  input           CEC;
  input           CECARRYIN;
  input           CECTRL;
  input           CED;
  input           CEINMODE;
  input           CEM;
  input           CEP;
  input           CLK;
  input   [24:0]  D;
  input   [ 4:0]  INMODE;
  input           MULTSIGNIN;
  input   [ 6:0]  OPMODE;
  input   [47:0]  PCIN;
  input           RSTA;
  input           RSTALLCARRYIN;
  input           RSTALUMODE;
  input           RSTB;
  input           RSTC;
  input           RSTCTRL;
  input           RSTD;
  input           RSTINMODE;
  input           RSTM;
  input           RSTP;

  assign  ACOUT = 30'd0;
  assign  BCOUT = 18'd0;
  assign  CARRYCASCOUT = 1'd0;
  assign  CARRYOUT = 4'd0;
  assign  MULTSIGNOUT = 1'd0;
  assign  OVERFLOW = 1'd0;
  assign  P = 48'd0;
  assign  PATTERNBDETECT = 1'd0;
  assign  PATTERNDETECT = 1'd0;
  assign  PCOUT = 48'd0;
  assign  UNDERFLOW = 1'd0;

endmodule

// ***************************************************************************
// ***************************************************************************
