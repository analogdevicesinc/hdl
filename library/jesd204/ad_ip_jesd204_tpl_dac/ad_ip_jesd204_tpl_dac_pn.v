// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2018-2023 Analog Devices, Inc. All rights reserved.
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

module ad_ip_jesd204_tpl_dac_pn #(
  parameter DATA_PATH_WIDTH = 4,
  parameter CONVERTER_RESOLUTION = 16
) (
  input clk,
  input reset,

  output [DATA_PATH_WIDTH*CONVERTER_RESOLUTION-1:0] pn7_data,
  output [DATA_PATH_WIDTH*CONVERTER_RESOLUTION-1:0] pn15_data
);

  localparam CR = CONVERTER_RESOLUTION;
  localparam DW = DATA_PATH_WIDTH * CR - 1;

  /* We need at least enough bits to store the PN state */
  localparam PN7_W = DW > 6 ? DW : 6;
  localparam PN15_W = DW > 14 ? DW : 14;

  reg [PN7_W:0] pn7_state = {PN7_W+1{1'b1}};
  reg [PN15_W:0] pn15_state = {PN15_W+1{1'b1}};

  wire [DW:0] pn7;
  wire [DW+7:0] pn7_full_state;
  wire [PN7_W:0] pn7_reset;

  wire [DW:0] pn15;
  wire [DW+15:0] pn15_full_state;
  wire [PN15_W:0] pn15_reset;

  /* PN7 x^7 + x^6 + 1 */
  assign pn7 = pn7_full_state[7+:DW+1] ^ pn7_full_state[6+:DW+1];
  assign pn7_full_state = {pn7_state[6:0],pn7};

  /* PN15 x^15 + x^14 + 1 */
  assign pn15 = pn15_full_state[15+:DW+1] ^ pn15_full_state[14+:DW+1];
  assign pn15_full_state = {pn15_state[14:0],pn15};

  assign pn7_reset[PN7_W-:7] = {7{1'b1}};
  assign pn15_reset[PN15_W-:15] = {15{1'b1}};

  generate
    if (PN7_W >= 7) begin
      assign pn7_reset[PN7_W-7:0] = pn7_reset[PN7_W:7] ^ pn7_reset[PN7_W-1:6];
    end

    if (PN15_W >= 15) begin
      assign pn15_reset[PN15_W-15:0] = pn15_reset[PN15_W:15] ^ pn15_reset[PN15_W-1:14];
    end
  endgenerate

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      pn7_state <= pn7_reset;
      pn15_state <= pn15_reset;
    end else begin
      pn7_state <= pn7_full_state[PN7_W:0];
      pn15_state <= pn15_full_state[PN15_W:0];
    end
  end

  generate
     /*
     * The first sample contains the first MSB of the PN sequence, but the first
     * sample is also in the LSB of the output data. So extract data at the MSB
     * sample of the PN state and put it into the LSB sample of the output data.
     */
    genvar i;
    for (i = 0; i <= DW; i = i + CR) begin: g_pn_swizzle
      assign pn7_data[i+:CR] = pn7_state[PN7_W-i-:CR];
      assign pn15_data[i+:CR] = pn15_state[PN15_W-i-:CR];
    end
  endgenerate

endmodule
