// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad_sysref_gen (
  input       core_clk,

  input       sysref_en,
  output reg  sysref_out
);

  // SYSREF period is multiple of core_clk, and has a duty cycle of 50%
  // NOTE: if SYSREF always on (this is a JESD204 IP configuration),
  // the period must be a correct multiple of the multiframe period
  parameter    SYSREF_PERIOD = 128;

  localparam   SYSREF_HALFPERIOD = SYSREF_PERIOD/2 - 1;

  reg  [ 7:0]   counter;
  reg           sysref_en_m1;
  reg           sysref_en_m2;
  reg           sysref_en_int;

  // bring the enable signal to JESD core clock domain
  always @(posedge core_clk) begin
    sysref_en_m1 <= sysref_en;
    sysref_en_m2 <= sysref_en_m1;
    sysref_en_int <= sysref_en_m2;
  end

  // free running counter for periodic SYSREF generation
  always @(posedge core_clk) begin
    if (sysref_en_int) begin
      counter <= (counter < SYSREF_HALFPERIOD) ? counter + 1'b1 : 8'h0;
    end else begin
      counter <= 8'h0;
    end
  end

  // generate SYSREF
  always @(posedge core_clk) begin
    if (sysref_en_int) begin
      if (counter == SYSREF_HALFPERIOD) begin
        sysref_out <= ~sysref_out;
      end
    end else begin
      sysref_out <= 1'b0;
    end
  end

endmodule
