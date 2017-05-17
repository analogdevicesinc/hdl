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
      counter <= (counter < SYSREF_HALFPERIOD) ? counter + 1 : 0;
    end else begin
      counter <= 0;
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
