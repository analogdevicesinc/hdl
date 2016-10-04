// ***************************************************************************
// ***************************************************************************
// Copyright 2013(c) Analog Devices, Inc.
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

// A simple edge detector circuit

`timescale 1ns/100ps

module ad_edge_detect (

  clk,
  rst,

  in,
  out
);

  parameter   EDGE = 0;

  localparam  POS_EDGE = 0;
  localparam  NEG_EDGE = 1;
  localparam  ANY_EDGE = 2;

  input       clk;
  input       rst;

  input       in;
  output      out;

  reg         ff_m1 = 0;
  reg         ff_m2 = 0;

  reg         out = 0;

  always @(posedge clk) begin
    if (rst == 1) begin
      ff_m1 <= 0;
      ff_m2 <= 0;
    end else begin
      ff_m1 <= in;
      ff_m2 <= ff_m1;
    end
  end

  always @(posedge clk) begin
    if (rst == 1) begin
      out <= 1'b0;
    end else begin
      if (EDGE == POS_EDGE) begin
        out <= ff_m1 & ~ff_m2;
      end else if (EDGE == NEG_EDGE) begin
        out <= ~ff_m1 & ff_m2;
      end else begin
        out <= ff_m1 ^ ff_m2;
      end
    end
  end

endmodule

