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
`timescale 1ns/1ps

module util_tdd_sync (
  clk,
  rstn,

  sync_en,
  sync_type,

  sync_in,
  sync_out
);

  input         clk;
  input         rstn;

  input         sync_en;
  input         sync_type;

  input         sync_in;
  output        sync_out;

  parameter TDD_SYNC_PERIOD     = 100000000;

  reg           sync_en_d1  = 1'b0;
  reg           sync_en_d2  = 1'b0;
  reg           sync_type_d1 = 1'b0;
  reg           sync_type_d2 = 1'b0;
  reg           sync_out = 1'b0;

  wire          sync_gen;

  // pulse generator

  ad_tdd_sync #(
    .TDD_SYNC_PERIOD(TDD_SYNC_PERIOD)
  )
    i_tdd_sync (
    .clk (clk),
    .rstn (rstn),
    .sync (sync_gen)
  );

  // synchronization logic

  always @(posedge clk) begin
    if(rstn == 1'b0) begin
      sync_en_d1 <= 1'b0;
      sync_en_d2 <= 1'b0;
      sync_type_d1 <= 1'b0;
      sync_type_d2 <= 1'b0;
    end else begin
      sync_en_d1 <= sync_en;
      sync_en_d2 <= sync_en_d1;
      sync_type_d1 <= sync_type;
      sync_type_d2 <= sync_type_d1;
    end
  end

  // output logic

  always @(posedge clk) begin
    if(rstn == 1'b0) begin
      sync_out <= 1'b0;
    end else begin
      if(sync_en_d2 == 1'b1) begin
        sync_out <= (sync_type_d2 == 1'b0) ? sync_gen : sync_in;
      end else begin
        sync_out <= 1'b0;
      end
    end
  end

endmodule

