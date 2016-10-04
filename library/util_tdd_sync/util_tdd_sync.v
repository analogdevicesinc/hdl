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
//
// Simple pulse generator for TDD control
// The module has two modes. In function of the state of sync_mode,
// the syncronization signal (sync_out) can get its value from an external
// source or from its internal generator.
//

`timescale 1ns/1ps

module util_tdd_sync (
  clk,
  rstn,

  sync_mode,

  sync_in,
  sync_out
);

  input         clk;
  input         rstn;

  input         sync_mode;

  input         sync_in;
  output        sync_out;

  parameter     TDD_SYNC_PERIOD = 100000000;

  reg           sync_mode_d1 = 1'b0;
  reg           sync_mode_d2 = 1'b0;
  reg           sync_out = 1'b0;

  wire          sync_internal;
  wire          sync_external;

  // pulse generator

  util_pulse_gen #(
    .PULSE_PERIOD(TDD_SYNC_PERIOD)
  )
    i_tdd_sync (
    .clk (clk),
    .rstn (rstn),
    .pulse (sync_internal)
  );

  // synchronization logic

  always @(posedge clk) begin
    if(rstn == 1'b0) begin
      sync_mode_d1 <= 1'b0;
      sync_mode_d2 <= 1'b0;
    end else begin
      sync_mode_d1 <= sync_mode;
      sync_mode_d2 <= sync_mode_d1;
    end
  end

  // output logic

  assign sync_external = sync_in;
  always @(posedge clk) begin
    if(rstn == 1'b0) begin
      sync_out <= 1'b0;
    end else begin
      sync_out <= (sync_mode_d2 == 1'b0) ? sync_internal : sync_external;
    end
  end

endmodule

