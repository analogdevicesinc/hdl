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

  input                       dac_clk,
  output [13:0]               dac_data_out,

  // data interface

  input  [14*CLK_RATIO-1:0]   dac_data_in,
  input  [ 3:0]               dac_data_sel,
  input                       dac_dfmt_type
);

  localparam ZERO_BITS = 14 - DAC_RESOLUTION;

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

  wire [14*CLK_RATIO-1:0] dac_data_fmt;

  genvar n;
  generate
    for (n = 0; n < CLK_RATIO; n = n + 1) begin : gen_fmt
      assign dac_data_fmt[n*14+13] = dac_dfmt_type ? ~dac_data_in[n*14+13] : dac_data_in[n*14+13];
      assign dac_data_fmt[n*14 +: 13] = dac_data_in[n*14 +: 13];
    end
  endgenerate

  // DDR data: d1 = rising edge (first sample), d2 = falling edge (second sample)
  wire [13:0] dac_data_d1;
  wire [13:0] dac_data_d2;

  assign dac_data_d1 = dac_data_fmt[13:0];
  assign dac_data_d2 = (CLK_RATIO == 2) ? dac_data_fmt[27:14] : dac_data_fmt[13:0];

  // ODDR primitives for DAC data output (DDR on 105 MHz = 210 MSPS)
  genvar i;
  generate
    for (i = 0; i < 14; i = i + 1) begin : gen_oddr
      if (i >= ZERO_BITS) begin : gen_oddr_data
        ODDR #(
          .DDR_CLK_EDGE ("SAME_EDGE"),
          .INIT         (1'b0),
          .SRTYPE       ("ASYNC")
        ) i_oddr (
          .Q  (dac_data_out[i]),
          .C  (dac_clk),
          .CE (1'b1),
          .D1 (dac_data_d1[i]),
          .D2 (dac_data_d2[i]),
          .R  (1'b0),
          .S  (1'b0));
      end else begin : gen_oddr_zero
        ODDR #(
          .DDR_CLK_EDGE ("SAME_EDGE"),
          .INIT         (1'b0),
          .SRTYPE       ("ASYNC")
        ) i_oddr (
          .Q  (dac_data_out[i]),
          .C  (dac_clk),
          .CE (1'b1),
          .D1 (1'b0),
          .D2 (1'b0),
          .R  (1'b0),
          .S  (1'b0));
      end
    end
  endgenerate

endmodule
