// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
// serial data output interface: serdes(x8)

`timescale 1ps/1ps

module ad_serdes_out #(

  parameter   FPGA_TECHNOLOGY = 0,
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

  localparam  SEVEN_SERIES  = 1;
  localparam  ULTRASCALE  = 2;
  localparam  ULTRASCALE_PLUS  = 3;
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

    if (FPGA_TECHNOLOGY == SEVEN_SERIES) begin
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

    OBUFDS i_obuf (
      .I (data_out_s[l_inst]),
      .O (data_out_p[l_inst]),
      .OB (data_out_n[l_inst]));

  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************

