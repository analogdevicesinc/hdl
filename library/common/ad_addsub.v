// ***************************************************************************
// ***************************************************************************
// Copyright 2015(c) Analog Devices, Inc.
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

// A simple adder/substracter width preconfigured input ports width and turn-around value
// Output = A - B_constant or A + B_constant
// Constraints: Awidth >= Bwidth

`timescale 1ns/1ps

module ad_addsub (
  clk,
  A,
  Amax,
  out,
  CE
);

  // parameters

  parameter   A_WIDTH = 32;
  parameter   CONST_VALUE = 32'h1;
  parameter   ADD_SUB = 0;

  localparam  ADDER = 0;
  localparam  SUBSTRACTER = 1;

  // I/O definitions

  input                     clk;
  input   [(A_WIDTH-1):0]   A;
  input   [(A_WIDTH-1):0]   Amax;
  output  [(A_WIDTH-1):0]   out;
  input                     CE;

  // registers

  reg     [(A_WIDTH-1):0]   out = 'b0;
  reg     [A_WIDTH:0]       out_d = 'b0;
  reg     [A_WIDTH:0]       out_d2 = 'b0;
  reg     [(A_WIDTH-1):0]   A_d = 'b0;
  reg     [(A_WIDTH-1):0]   A_d2 = 'b0;
  reg     [(A_WIDTH-1):0]   Amax_d = 'b0;
  reg     [(A_WIDTH-1):0]   Amax_d2 = 'b0;

  // constant regs

  reg     [(A_WIDTH-1):0]   B_reg = CONST_VALUE;

  // latch the inputs

  always @(posedge clk) begin
      A_d <= A;
      A_d2 <= A_d;
      Amax_d <= Amax;
      Amax_d2 <= Amax_d;
  end

  // ADDER/SUBSTRACTER

  always @(posedge clk) begin
    if ( ADD_SUB == ADDER ) begin
      out_d <= A_d + B_reg;
    end else begin
      out_d <= A_d - B_reg;
    end
  end

  // Resolve

  always @(posedge clk) begin
    if ( ADD_SUB == ADDER ) begin
      if ( out_d > Amax_d2 ) begin
        out_d2 <= out_d - Amax_d2;
      end else begin
        out_d2 <= out_d;
      end
    end else begin // SUBSTRACTER
      if ( out_d[A_WIDTH] == 1'b1 ) begin
        out_d2 <= Amax_d2 + out_d;
      end else begin
        out_d2 <= out_d;
      end
    end
  end

  // output logic

  always @(posedge clk) begin
    if ( CE ) begin
      out <= out_d2;
    end else begin
      out <= 'b0;
    end
  end

endmodule
