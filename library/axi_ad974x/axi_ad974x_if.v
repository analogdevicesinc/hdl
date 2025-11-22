// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

module axi_ad974x_if #(
  parameter DAC_RESOLUTION = 14
) (

  // dac interface

  output [13:0]   dac_data_out,

  // data interface

  input  [13:0]   dac_data_in
);

  // The AD974x DACs expect offset binary format
  // DDS outputs 2's complement, so we need to convert
  // by inverting the MSB for the actual DAC resolution

  generate
    if (DAC_RESOLUTION == 14) begin
      // For 14-bit DAC (AD9744), invert MSB to convert from 2's complement to offset binary
      assign dac_data_out[13] = ~dac_data_in[13];
      assign dac_data_out[12:0] = dac_data_in[12:0];
    end else if (DAC_RESOLUTION == 12) begin
      // For 12-bit DAC (AD9742), data is in upper 12 bits
      // Invert MSB of the 12-bit data
      assign dac_data_out[13] = ~dac_data_in[13];
      assign dac_data_out[12:0] = dac_data_in[12:0];
    end else if (DAC_RESOLUTION == 10) begin
      // For 10-bit DAC (AD9740), data is in upper 10 bits
      // Invert MSB of the 10-bit data
      assign dac_data_out[13] = ~dac_data_in[13];
      assign dac_data_out[12:0] = dac_data_in[12:0];
    end else if (DAC_RESOLUTION == 8) begin
      // For 8-bit DAC (AD9748), data is in upper 8 bits
      // Invert MSB of the 8-bit data
      assign dac_data_out[13] = ~dac_data_in[13];
      assign dac_data_out[12:0] = dac_data_in[12:0];
    end else begin
      // Default: pass through with MSB inverted
      assign dac_data_out[13] = ~dac_data_in[13];
      assign dac_data_out[12:0] = dac_data_in[12:0];
    end
  endgenerate

endmodule
