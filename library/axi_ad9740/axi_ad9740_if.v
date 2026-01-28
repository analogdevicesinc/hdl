// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

module axi_ad9740_if #(
  parameter DAC_RESOLUTION = 14,
  parameter CLK_RATIO = 2
) (

  // dac interface

  output [14*CLK_RATIO-1:0]   dac_data_out,

  // data interface

  input  [14*CLK_RATIO-1:0]   dac_data_in,
  input  [ 3:0]               dac_data_sel,
  input                       dac_dfmt_type
);

  // The AD974x DACs expect offset binary format
  // Data format conversion based on dac_dfmt_type register:
  // - dac_dfmt_type = 0: Data is offset binary (unsigned) - pass through
  // - dac_dfmt_type = 1: Data is two's complement (signed) - invert MSB
  //
  // This applies to ALL data sources (DDS, DMA, Ramp):
  // - DDS can be configured for signed or unsigned output
  // - DMA data format depends on what software sends
  // - Ramp is always unsigned (offset binary)
  //
  // For all DAC resolutions, data is MSB-aligned in the 14-bit bus

  // MSB inversion for two's complement to offset binary conversion
  // Note: dac_dfmt_type=1 means signed (two's complement) data
  // Apply to each sample in the CLK_RATIO group

  genvar n;
  generate
    for (n = 0; n < CLK_RATIO; n = n + 1) begin : gen_fmt
      assign dac_data_out[n*14+13] = dac_dfmt_type ? ~dac_data_in[n*14+13] : dac_data_in[n*14+13];
      assign dac_data_out[n*14 +: 13] = dac_data_in[n*14 +: 13];
    end
  endgenerate

endmodule
