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
  endof_frame,

  enable_in,            // tdd enable signal asserted by software
  enable_out,           // synchronized tdd_enable

  // sync interface

  sync_o,               // sync output
  sync_i,               // sync input
  sync_t,               // sync 3-state

  resync                // resync pulse for slave device

);

  input           clk;
  input           rst;

  input           sync_en;
  input           device_type;
  input   [ 7:0]  sync_period;
  input           endof_frame;

  input           enable_in;
  output          enable_out;

  output          sync_o;
  input           sync_i;
  output          sync_t;

  output          resync;

  // internal registers

  reg             enable_in_d = 1'b0;
  reg             enable_out = 1'b0;
  reg             enable_synced = 1'b0;
  reg             sync_i_d = 1'b0;
  reg             sync_o = 1'b0;
  reg             resync = 1'b0;
  reg     [ 7:0]  frame_counter = 32'h0;
  reg     [ 2:0]  pulse_counter = 3'h7;
  reg             pulse_en = 1'h0;

  // the sync module can be bypassed

  always @(posedge clk) begin
    if (rst == 1) begin
      enable_out <= 1'b0;
    end else begin
      enable_out <= (sync_en) ? enable_synced : enable_in;
    end
  end

  // sync pulse is generated at every posedge of enable_in
  // OR after [sync_period] number of endof_frame

  always @(posedge clk) begin
    if (rst == 1) begin
      enable_in_d <= 1'b0;
      frame_counter <= 0;
      pulse_en <= 0;
    end else begin
      enable_in_d <= enable_in;
      if(endof_frame == 1) begin
        frame_counter <= frame_counter + 1;
      end
      if((frame_counter == sync_period) || (~enable_in_d & enable_in == 1)) begin
        frame_counter <= 1'b0;
        pulse_en <= 1'b1;
      end else begin
        pulse_en <= 1'b0;
      end
    end
  end

  // generate pulse with a specified width

  always @(posedge clk) begin
    if (rst == 1) begin
      pulse_counter <= 0;
      sync_o <= 0;
    end else begin
      if(pulse_en == 1'b1) begin
        sync_o <= 1'b1;
      end else if(pulse_counter == 3'h7) begin
        sync_o <= 1'b0;
      end
      pulse_counter <= (sync_o == 1'b1) ? pulse_counter + 1 : 3'h0;
    end
  end

  assign sync_t = ~device_type;

  // syncronize enalbe_in and generate resync for slave

  always @(posedge clk) begin
    sync_i_d <= sync_i;
    if(device_type == 1'b1) begin
      enable_synced <= enable_in;
      resync <= 1'b0;
    end else begin
      if (~sync_i_d & sync_i) begin
        enable_synced <= enable_in;
        resync <= 1'b1;
      end else begin
        resync <= 1'b0;
      end
    end
  end

endmodule
