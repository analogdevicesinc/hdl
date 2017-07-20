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

`timescale 1ns/100ps

module util_extract (

  clk,

  data_in,
  data_in_trigger,
  data_valid,

  data_out,
  trigger_out

);

  parameter   CHANNELS = 2;

  parameter  DW = CHANNELS * 16;
  input             clk;
  input   [DW-1:0]  data_in;
  input   [DW-1:0]  data_in_trigger;
  input             data_valid;

  output  [DW-1:0]  data_out;
  output            trigger_out;

   // loop variables

  genvar  n;

  reg trigger_out;
  reg trigger_d1;

  wire [15:0] trigger; // 16 maximum channels

  generate
  for (n = 0; n < CHANNELS; n = n + 1) begin: g_data_out
    assign data_out[(n+1)*16-1:n*16] = {data_in[(n*16)+14],data_in[(n*16)+14:n*16]};
    assign trigger[n] = data_in_trigger[(16*n)+15];
  end
  for (n = CHANNELS; n < 16; n = n + 1) begin: g_trigger_out
    assign trigger[n] = 1'b0;
  end
  endgenerate

  // compensate delay in the FIFO
  always @(posedge clk) begin
    if (data_valid == 1'b1) begin
      trigger_d1  <= |trigger;
      trigger_out <= trigger_d1;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
