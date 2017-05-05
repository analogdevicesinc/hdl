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

module ad_ip_jesd204_tpl_adc_pnmon #(
  parameter CHANNEL_WIDTH = 16,
  parameter DATA_PATH_WIDTH = 1,
  parameter TWOS_COMPLEMENT = 1
) (
  input clk,

  // data interface
  input [CHANNEL_WIDTH*DATA_PATH_WIDTH-1:0] data,

  // pn out of sync and error
  output pn_oos,
  output pn_err,

  // processor interface PN9 (0x0), PN23 (0x1)
  input [3:0] pn_seq_sel
);

  localparam DW = DATA_PATH_WIDTH*CHANNEL_WIDTH-1;

  // internal registers
  reg [DW:0] pn_data_pn = 'd0;

  // internal signals
  wire [DW:0] pn_data_pn_s;
  wire [DW:0] pn_data_in_s;

  wire [DW:0] pn23;
  wire [DW+23:0] full_state_pn23;
  wire [DW:0] pn9;
  wire [DW+9:0] full_state_pn9;

  // pn sequence select

  assign pn_data_pn_s = (pn_oos == 1'b1) ? pn_data_in_s : pn_data_pn;

  wire tc = TWOS_COMPLEMENT ? 1'b1 : 1'b0;

  generate
  genvar i;
  for (i = 0; i < DATA_PATH_WIDTH; i = i + 1) begin: g_pn_swizzle
    localparam src_lsb = i * CHANNEL_WIDTH;
    localparam src_msb = src_lsb + CHANNEL_WIDTH - 1;
    localparam dst_lsb = (DATA_PATH_WIDTH - i - 1) * CHANNEL_WIDTH;
    localparam dst_msb = dst_lsb + CHANNEL_WIDTH - 1;

    assign pn_data_in_s[dst_msb] = tc ^ data[src_msb];
    assign pn_data_in_s[dst_msb-1:dst_lsb] = data[src_msb-1:src_lsb];
  end
  endgenerate

  // PN23 x^23 + x^18 + 1
  assign pn23 = full_state_pn23[23+:DW+1] ^ full_state_pn23[18+:DW+1];
  assign full_state_pn23 = {pn_data_pn_s[22:0],pn23};

  // PN9 x^9 + x^5 + 1
  assign pn9 = full_state_pn9[9+:DW+1] ^ full_state_pn9[5+:DW+1];
  assign full_state_pn9 = {pn_data_pn_s[8:0],pn9};

  always @(posedge clk) begin
    if (pn_seq_sel == 4'd0) begin
      pn_data_pn <= pn9;
    end else begin
      pn_data_pn <= pn23;
    end
  end

  // pn oos & pn err

  ad_pnmon #(
    .DATA_WIDTH (DW+1)
  ) i_pnmon (
    .adc_clk (clk),
    .adc_valid_in (1'b1),
    .adc_data_in (pn_data_in_s),
    .adc_data_pn (pn_data_pn),
    .adc_pn_oos (pn_oos),
    .adc_pn_err (pn_err)
  );

endmodule
