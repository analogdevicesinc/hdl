// ***************************************************************************
// ***************************************************************************
// Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
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

module ad_ip_jesd204_tpl_adc_channel #(
  parameter CONVERTER_RESOLUTION = 14,
  parameter DATA_PATH_WIDTH = 2,
  parameter TWOS_COMPLEMENT = 1,
  parameter BITS_PER_SAMPLE = 16
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

  localparam OCTETS_PER_SAMPLE = BITS_PER_SAMPLE / 8;

  // instantiations

  ad_ip_jesd204_tpl_adc_pnmon #(
    .CONVERTER_RESOLUTION (CONVERTER_RESOLUTION),
    .DATA_PATH_WIDTH (DATA_PATH_WIDTH),
    .TWOS_COMPLEMENT (TWOS_COMPLEMENT)
  ) i_pnmon (
    .clk (clk),
    .data (raw_data),

    .pn_seq_sel (pn_seq_sel),
    .pn_oos (pn_oos),
    .pn_err (pn_err)
  );

  generate
  genvar n;
  for (n = 0; n < DATA_PATH_WIDTH; n = n + 1) begin: g_datafmt
    ad_datafmt #(
      .DATA_WIDTH (CONVERTER_RESOLUTION),
      .OCTETS_PER_SAMPLE (OCTETS_PER_SAMPLE)
    ) i_ad_datafmt (
      .clk (clk),

      .valid (1'b1),
      .data (raw_data[n*CONVERTER_RESOLUTION+:CONVERTER_RESOLUTION]),
      .valid_out (),
      .data_out (fmt_data[n*BITS_PER_SAMPLE+:BITS_PER_SAMPLE]),

      .dfmt_enable (dfmt_enable),
      .dfmt_type (dfmt_type),
      .dfmt_se (dfmt_sign_extend)
    );
  end
  endgenerate

endmodule
