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

module ad_ip_jesd204_tpl_adc_channel #(
  parameter CONVERTER_RESOLUTION = 14,
  parameter DATA_PATH_WIDTH = 2,
  parameter TWOS_COMPLEMENT = 1,
  parameter BITS_PER_SAMPLE = 16,
  parameter PN7_ENABLE = 1,
  parameter PN15_ENABLE = 1
) (
  input clk,

  input [CONVERTER_RESOLUTION*DATA_PATH_WIDTH-1:0] raw_data,

  output [BITS_PER_SAMPLE*DATA_PATH_WIDTH-1:0] fmt_data,

  // Configuration and status
  input dfmt_enable,
  input dfmt_type,
  input dfmt_sign_extend,

  input [3:0] pn_seq_sel,
  output pn_oos,
  output pn_err
);

  // instantiations

  ad_ip_jesd204_tpl_adc_pnmon #(
    .CONVERTER_RESOLUTION (CONVERTER_RESOLUTION),
    .DATA_PATH_WIDTH (DATA_PATH_WIDTH),
    .TWOS_COMPLEMENT (TWOS_COMPLEMENT),
    .PN7_ENABLE (PN7_ENABLE),
    .PN15_ENABLE(PN15_ENABLE)
  ) i_pnmon (
    .clk (clk),
    .data (raw_data),

    .pn_seq_sel (pn_seq_sel),
    .pn_oos (pn_oos),
    .pn_err (pn_err));

  generate
  genvar n;
  for (n = 0; n < DATA_PATH_WIDTH; n = n + 1) begin: g_datafmt
    ad_datafmt #(
      .DATA_WIDTH (CONVERTER_RESOLUTION),
      .BITS_PER_SAMPLE (BITS_PER_SAMPLE)
    ) i_ad_datafmt (
      .clk (clk),

      .valid (1'b1),
      .data (raw_data[n*CONVERTER_RESOLUTION+:CONVERTER_RESOLUTION]),
      .valid_out (),
      .data_out (fmt_data[n*BITS_PER_SAMPLE+:BITS_PER_SAMPLE]),

      .dfmt_enable (dfmt_enable),
      .dfmt_type (dfmt_type),
      .dfmt_se (dfmt_sign_extend));
  end
  endgenerate

endmodule
