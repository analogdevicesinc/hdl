// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsabilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
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

