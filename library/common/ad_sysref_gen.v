// ***************************************************************************
// ***************************************************************************
// Copyright 2016(c) Analog Devices, Inc.
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
