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
// serial data output interface: serdes(x8)

`timescale 1ps/1ps

module ad_serdes_out #(

  parameter   DEVICE_TYPE = 0,
  parameter   DDR_OR_SDR_N = 1,
  parameter   SERDES_FACTOR = 8,
  parameter   DATA_WIDTH = 16) (

  // reset and clocks

  input                       rst,
  input                       clk,
  input                       div_clk,
  input                       loaden,

  // data interface

  input   [(DATA_WIDTH-1):0]  data_s0,
  input   [(DATA_WIDTH-1):0]  data_s1,
  input   [(DATA_WIDTH-1):0]  data_s2,
  input   [(DATA_WIDTH-1):0]  data_s3,
  input   [(DATA_WIDTH-1):0]  data_s4,
  input   [(DATA_WIDTH-1):0]  data_s5,
  input   [(DATA_WIDTH-1):0]  data_s6,
  input   [(DATA_WIDTH-1):0]  data_s7,
  output  [(DATA_WIDTH-1):0]  data_out_se,
  output  [(DATA_WIDTH-1):0]  data_out_p,
  output  [(DATA_WIDTH-1):0]  data_out_n);

  localparam  DEVICE_6SERIES = 1;
  localparam  DEVICE_7SERIES = 0;
  localparam  DR_OQ_DDR = DDR_OR_SDR_N == 1'b1 ? "DDR": "SDR";

  // internal signals

  wire    [(DATA_WIDTH-1):0]  data_out_s;
  wire    [(DATA_WIDTH-1):0]  serdes_shift1_s;
  wire    [(DATA_WIDTH-1):0]  serdes_shift2_s;

  assign data_out_se =  data_out_s;

  // instantiations

  genvar l_inst;
  generate
  for (l_inst = 0; l_inst <= (DATA_WIDTH-1); l_inst = l_inst + 1) begin: g_data

    if (DEVICE_TYPE == DEVICE_7SERIES) begin
      OSERDESE2  #(
        .DATA_RATE_OQ (DR_OQ_DDR),
        .DATA_RATE_TQ ("SDR"),
        .DATA_WIDTH (SERDES_FACTOR),
        .TRISTATE_WIDTH (1),
        .SERDES_MODE ("MASTER"))
      i_serdes (
        .D1 (data_s0[l_inst]),
        .D2 (data_s1[l_inst]),
        .D3 (data_s2[l_inst]),
        .D4 (data_s3[l_inst]),
        .D5 (data_s4[l_inst]),
        .D6 (data_s5[l_inst]),
        .D7 (data_s6[l_inst]),
        .D8 (data_s7[l_inst]),
        .T1 (1'b0),
        .T2 (1'b0),
        .T3 (1'b0),
        .T4 (1'b0),
        .SHIFTIN1 (1'b0),
        .SHIFTIN2 (1'b0),
        .SHIFTOUT1 (),
        .SHIFTOUT2 (),
        .OCE (1'b1),
        .CLK (clk),
        .CLKDIV (div_clk),
        .OQ (data_out_s[l_inst]),
        .TQ (),
        .OFB (),
        .TFB (),
        .TBYTEIN (1'b0),
        .TBYTEOUT (),
        .TCE (1'b0),
        .RST (rst));
    end

    if (DEVICE_TYPE == DEVICE_6SERIES) begin
      OSERDESE1  #(
        .DATA_RATE_OQ (DR_OQ_DDR),
        .DATA_RATE_TQ ("SDR"),
        .DATA_WIDTH (SERDES_FACTOR),
        .INTERFACE_TYPE ("DEFAULT"),
        .TRISTATE_WIDTH (1),
        .SERDES_MODE ("MASTER"))
      i_serdes_m (
        .D1 (data_s0[l_inst]),
        .D2 (data_s1[l_inst]),
        .D3 (data_s2[l_inst]),
        .D4 (data_s3[l_inst]),
        .D5 (data_s4[l_inst]),
        .D6 (data_s5[l_inst]),
        .T1 (1'b0),
        .T2 (1'b0),
        .T3 (1'b0),
        .T4 (1'b0),
        .SHIFTIN1 (serdes_shift1_s[l_inst]),
        .SHIFTIN2 (serdes_shift2_s[l_inst]),
        .SHIFTOUT1 (),
        .SHIFTOUT2 (),
        .OCE (1'b1),
        .CLK (clk),
        .CLKDIV (div_clk),
        .CLKPERF (1'b0),
        .CLKPERFDELAY (1'b0),
        .WC (1'b0),
        .ODV (1'b0),
        .OQ (data_out_s[l_inst]),
        .TQ (),
        .OCBEXTEND (),
        .OFB (),
        .TFB (),
        .TCE (1'b0),
        .RST (rst));

      OSERDESE1  #(
        .DATA_RATE_OQ (DR_OQ_DDR),
        .DATA_RATE_TQ ("SDR"),
        .DATA_WIDTH (SERDES_FACTOR),
        .INTERFACE_TYPE ("DEFAULT"),
        .TRISTATE_WIDTH (1),
        .SERDES_MODE ("SLAVE"))
      i_serdes_s (
        .D1 (1'b0),
        .D2 (1'b0),
        .D3 (data_s6[l_inst]),
        .D4 (data_s7[l_inst]),
        .D5 (1'b0),
        .D6 (1'b0),
        .T1 (1'b0),
        .T2 (1'b0),
        .T3 (1'b0),
        .T4 (1'b0),
        .SHIFTIN1 (1'b0),
        .SHIFTIN2 (1'b0),
        .SHIFTOUT1 (serdes_shift1_s[l_inst]),
        .SHIFTOUT2 (serdes_shift2_s[l_inst]),
        .OCE (1'b1),
        .CLK (clk),
        .CLKDIV (div_clk),
        .CLKPERF (1'b0),
        .CLKPERFDELAY (1'b0),
        .WC (1'b0),
        .ODV (1'b0),
        .OQ (),
        .TQ (),
        .OCBEXTEND (),
        .OFB (),
        .TFB (),
        .TCE (1'b0),
        .RST (rst));
    end

    OBUFDS i_obuf (
      .I (data_out_s[l_inst]),
      .O (data_out_p[l_inst]),
      .OB (data_out_n[l_inst]));

  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************

