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

module ad_tdd_sync (

  // clock & reset

  clk,
  rst,

  // control signals

  sync_en,              // synchronization enabled
  device_type,          // master or slave
  sync_period,          // periodicity of the sync pulse,

  enable_in,            // tdd enable signal asserted by software
  enable_out,           // synchronized tdd_enable

  // sync interface

  sync_out,             // sync output for slave
  sync_in,              // sync input

  resync                // resync pulse for slave device

);

  input           clk;
  input           rst;

  input           sync_en;
  input           device_type;
  input   [31:0]  sync_period;

  input           enable_in;
  output          enable_out;

  output          sync_out;
  input           sync_in;

  output          resync;

  // internal registers

  reg             enable_out = 1'b0;
  reg             enable_synced = 1'b0;
  reg             sync_in_d = 1'b0;

  reg             sync_out = 1'b0;
  reg             resync = 1'b0;

  reg     [ 2:0]  pulse_width = 3'h7;

  reg     [31:0]  pulse_counter = 32'h0;

  // the sync module can be bypassed

  always @(posedge clk) begin
    if (rst == 1) begin
      enable_out <= 1'b0;
    end else begin
      enable_out <= (sync_en) ? enable_synced : enable_in;
    end
  end

  // generate sync pulse

  always @(posedge clk) begin
    if(rst == 1) begin
      pulse_counter <= 0;
      pulse_width <= 3'h7;
      sync_out <= 1'h0;
    end else begin
      if (device_type == 1) begin
        pulse_counter <= (pulse_counter < sync_period) ? pulse_counter + 1 : 32'h0;
        if(pulse_counter == sync_period) begin
          sync_out <= enable_in;
          pulse_width <= 3'h0;
        end else begin
          pulse_width <= (pulse_width < 3'h7) ? pulse_width + 1 : pulse_width;
          sync_out <= (pulse_width == 3'h7) ? 0 : enable_in;
        end
      end
    end
  end

  // syncronize enalbe_in and generate resync for slave

  always @(posedge clk) begin
    sync_in_d <= sync_in;
    if(device_type == 1'b1) begin
      enable_synced <= enable_in;
      resync <= 1'b0;
    end else begin
      if (~sync_in_d & sync_in) begin
        enable_synced <= enable_in;
        resync <= 1'b1;
      end else begin
        resync <= 1'b0;
      end
    end
  end

endmodule
