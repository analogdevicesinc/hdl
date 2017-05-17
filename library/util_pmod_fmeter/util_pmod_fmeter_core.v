// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// Each core or library found in this collection may have its own licensing terms. 
// The user should keep this in in mind while exploring these cores. 
//
// Redistribution and use in source and binary forms,
// with or without modification of this file, are permitted under the terms of either
//  (at the option of the user):
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory, or at:
// https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
//
// OR
//
//   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
// https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
//
// ***************************************************************************
// ***************************************************************************

module util_pmod_fmeter_core (
  input                   ref_clk,
  input                   reset,
  input                   square_signal,
  output  reg [31:0]      signal_freq);

  // registers

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

