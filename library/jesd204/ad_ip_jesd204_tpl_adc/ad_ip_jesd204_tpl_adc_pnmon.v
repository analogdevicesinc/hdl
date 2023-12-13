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

module ad_ip_jesd204_tpl_adc_pnmon #(
  parameter CONVERTER_RESOLUTION = 16,
  parameter DATA_PATH_WIDTH = 1,
  parameter TWOS_COMPLEMENT = 1,
  parameter PN7_ENABLE = 1,
  parameter PN15_ENABLE = 1
) (
  input clk,

  // data interface
  input [CONVERTER_RESOLUTION*DATA_PATH_WIDTH-1:0] data,

  // pn out of sync and error
  output pn_oos,
  output pn_err,

  // processor interface PN9 (0x0), PN23 (0x1), PN7 (0x4), PN15 (0x5)
  input [3:0] pn_seq_sel
);

  localparam DW = DATA_PATH_WIDTH*CONVERTER_RESOLUTION-1;

  // Max width of largest PN and data width
  localparam PN_W = DW > 22 ? DW : 22;

  // internal registers
  reg [PN_W:0] pn_data_pn = 'd0;

  // internal signals
  wire [PN_W:0] pn_data_pn_s;
  wire [DW:0] pn_data_in_s;
  wire [PN_W:0] pn_data_init;

  wire [DW:0] pn23;
  wire [DW+23:0] full_state_pn23;
  wire [DW:0] pn9;
  wire [DW+9:0] full_state_pn9;
  wire [DW:0] pn7;
  wire [DW+7:0] full_state_pn7;
  wire [DW:0] pn15;
  wire [DW+15:0] full_state_pn15;

  // pn sequence select
  generate if (PN_W > DW) begin
    reg [PN_W-DW-1:0] pn_data_in_d = 'd0;
    always @(posedge clk) begin
      pn_data_in_d <= pn_data_in_s[PN_W-DW-1:0];
    end
    assign pn_data_init = {pn_data_in_d, pn_data_in_s};
  end else begin
    assign pn_data_init = pn_data_in_s;
  end
  endgenerate

  assign pn_data_pn_s = (pn_oos == 1'b1) ? pn_data_init : pn_data_pn;

  wire tc = TWOS_COMPLEMENT ? 1'b1 : 1'b0;

  generate
  genvar i;
  for (i = 0; i < DATA_PATH_WIDTH; i = i + 1) begin: g_pn_swizzle
    localparam src_lsb = i * CONVERTER_RESOLUTION;
    localparam src_msb = src_lsb + CONVERTER_RESOLUTION - 1;
    localparam dst_lsb = (DATA_PATH_WIDTH - i - 1) * CONVERTER_RESOLUTION;
    localparam dst_msb = dst_lsb + CONVERTER_RESOLUTION - 1;

    assign pn_data_in_s[dst_msb] = (~tc) ^ data[src_msb];
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
      pn_data_pn <= PN_W > DW ? {pn_data_pn[PN_W-DW-1:0],pn9}  : pn9;
    end else if (pn_seq_sel == 4'd1) begin
      pn_data_pn <= PN_W > DW ? {pn_data_pn[PN_W-DW-1:0],pn23} : pn23;
    end else if (pn_seq_sel == 4'd4) begin
      pn_data_pn <= PN_W > DW ? {pn_data_pn[PN_W-DW-1:0],pn7}  : pn7;
    end else if (pn_seq_sel == 4'd5) begin
      pn_data_pn <= PN_W > DW ? {pn_data_pn[PN_W-DW-1:0],pn15} : pn15;
    end
  end

 // specific PN sequences

  generate
    if(PN7_ENABLE == 'b1) begin
     // PN7  x^7 + x^6 + 1
     assign pn7 = full_state_pn7[7+:DW+1] ^ full_state_pn7[6+:DW+1];
     assign full_state_pn7 = {pn_data_pn_s[6:0],pn7};
    end else begin
     assign pn7 = 'd0;
     assign full_state_pn7 = 'd0;
    end
    if(PN15_ENABLE == 'b1)  begin
     // PN15 x^15 + x^14 + 1
     assign pn15 = full_state_pn15[15+:DW+1] ^ full_state_pn15[14+:DW+1];
     assign full_state_pn15 = {pn_data_pn_s[14:0],pn15};
    end else begin
     assign pn15 = 'd0;
     assign full_state_pn15 = 'd0;
    end
  endgenerate

  // pn oos & pn err

  ad_pnmon #(
    .DATA_WIDTH (DW+1)
  ) i_pnmon (
    .adc_clk (clk),
    .adc_valid_in (1'b1),
    .adc_data_in (pn_data_in_s),
    .adc_data_pn (pn_data_pn[DW:0]),
    .adc_pn_oos (pn_oos),
    .adc_pn_err (pn_err));

endmodule
