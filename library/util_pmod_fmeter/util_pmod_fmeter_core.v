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

module util_pmod_fmeter_core (
  ref_clk,
  reset,
  square_signal,
  signal_freq);

  input           ref_clk;
  input           reset;
  input           square_signal;
  output  [31:0]  signal_freq;

  // registers

  reg     [31:0]  signal_freq         = 'h0;
  reg     [31:0]  signal_freq_counter = 'h0;
  reg     [ 2:0]  square_signal_buf   = 'h0;

  wire            signal_freq_en;

  assign signal_freq_en = ~square_signal_buf[2] & square_signal_buf[1];

  // internal signals

  always @(posedge ref_clk) begin
    square_signal_buf[0]    <= square_signal;
    square_signal_buf[2:1]  <= square_signal_buf[1:0];
  end

  always @(posedge ref_clk) begin
    if (reset == 1'b1) begin
      signal_freq <= 32'b0;
      signal_freq_counter <= 32'b0;
    end else begin
      if(signal_freq_en == 1'b1) begin
        signal_freq <= signal_freq_counter;
        signal_freq_counter <= 32'h0;
      end else begin
        signal_freq_counter <= signal_freq_counter + 32'h1;
      end
    end
  end

endmodule

