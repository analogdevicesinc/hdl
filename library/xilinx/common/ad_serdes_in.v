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

`timescale 1ps/1ps

module ad_serdes_in #(

  parameter   FPGA_TECHNOLOGY = 0,
  parameter   DDR_OR_SDR_N = 0,
  parameter   SERDES_FACTOR = 8,
  parameter   DATA_WIDTH = 16,
  parameter   IODELAY_CTRL = 0,
  parameter   IODELAY_GROUP = "dev_if_delay_group",
  parameter   REFCLK_FREQUENCY = 200) (

  // reset and clocks

  input                           rst,
  input                           clk,
  input                           div_clk,
  input                           loaden,
  input   [ 7:0]                  phase,
  input                           locked,

  // data interface

  output  [(DATA_WIDTH-1):0]      data_s0,
  output  [(DATA_WIDTH-1):0]      data_s1,
  output  [(DATA_WIDTH-1):0]      data_s2,
  output  [(DATA_WIDTH-1):0]      data_s3,
  output  [(DATA_WIDTH-1):0]      data_s4,
  output  [(DATA_WIDTH-1):0]      data_s5,
  output  [(DATA_WIDTH-1):0]      data_s6,
  output  [(DATA_WIDTH-1):0]      data_s7,
  input   [(DATA_WIDTH-1):0]      data_in_p,
  input   [(DATA_WIDTH-1):0]      data_in_n,

  // delay-data interface

  input                           up_clk,
  input   [(DATA_WIDTH-1):0]      up_dld,
  input   [((DATA_WIDTH*5)-1):0]  up_dwdata,
  output  [((DATA_WIDTH*5)-1):0]  up_drdata,

  // delay-control interface

  input                           delay_clk,
  input                           delay_rst,
  output                          delay_locked);

  localparam  SEVEN_SERIES  = 1;
  localparam  ULTRASCALE  = 2;
  localparam  ULTRASCALE_PLUS  = 3;
  localparam  DATA_RATE = (DDR_OR_SDR_N) ? "DDR" : "SDR";

  // internal signals

  wire    [(DATA_WIDTH-1):0]      data_in_ibuf_s;
  wire    [(DATA_WIDTH-1):0]      data_in_idelay_s;
  wire    [(DATA_WIDTH-1):0]      data_shift1_s;
  wire    [(DATA_WIDTH-1):0]      data_shift2_s;

  // delay controller

  generate
  if (IODELAY_CTRL == 1) begin
  (* IODELAY_GROUP = IODELAY_GROUP *)
  IDELAYCTRL i_delay_ctrl (
    .RST (delay_rst),
    .REFCLK (delay_clk),
    .RDY (delay_locked));
  end else begin
  assign delay_locked = 1'b1;
  end
  endgenerate

  // received data interface: ibuf -> idelay -> iserdes

  genvar l_inst;
  generate if (FPGA_TECHNOLOGY == SEVEN_SERIES) begin
    for (l_inst = 0; l_inst <= (DATA_WIDTH-1); l_inst = l_inst + 1) begin: g_data

      IBUFDS i_ibuf (
        .I (data_in_p[l_inst]),
        .IB (data_in_n[l_inst]),
        .O (data_in_ibuf_s[l_inst]));

      (* IODELAY_GROUP = IODELAY_GROUP *)
      IDELAYE2 #(
        .CINVCTRL_SEL ("FALSE"),
        .DELAY_SRC ("IDATAIN"),
        .HIGH_PERFORMANCE_MODE ("FALSE"),
        .IDELAY_TYPE ("VAR_LOAD"),
        .IDELAY_VALUE (0),
        .REFCLK_FREQUENCY (REFCLK_FREQUENCY),
        .PIPE_SEL ("FALSE"),
        .SIGNAL_PATTERN ("DATA"))
      i_idelay (
        .CE (1'b0),
        .INC (1'b0),
        .DATAIN (1'b0),
        .LDPIPEEN (1'b0),
        .CINVCTRL (1'b0),
        .REGRST (1'b0),
        .C (up_clk),
        .IDATAIN (data_in_ibuf_s[l_inst]),
        .DATAOUT (data_in_idelay_s[l_inst]),
        .LD (up_dld[l_inst]),
        .CNTVALUEIN (up_dwdata[((5*l_inst)+4):(5*l_inst)]),
        .CNTVALUEOUT (up_drdata[((5*l_inst)+4):(5*l_inst)]));

      ISERDESE2  #(
        .DATA_RATE (DATA_RATE),
        .DATA_WIDTH (SERDES_FACTOR),
        .DYN_CLKDIV_INV_EN ("FALSE"),
        .DYN_CLK_INV_EN ("FALSE"),
        .INIT_Q1 (1'b0),
        .INIT_Q2 (1'b0),
        .INIT_Q3 (1'b0),
        .INIT_Q4 (1'b0),
        .INTERFACE_TYPE ("NETWORKING"),
        .IOBDELAY ("IFD"),
        .NUM_CE (2),
        .OFB_USED ("FALSE"),
        .SERDES_MODE ("MASTER"),
        .SRVAL_Q1 (1'b0),
        .SRVAL_Q2 (1'b0),
        .SRVAL_Q3 (1'b0),
        .SRVAL_Q4 (1'b0))
      i_iserdes (
        .O (),
        .Q1 (data_s0[l_inst]),
        .Q2 (data_s1[l_inst]),
        .Q3 (data_s2[l_inst]),
        .Q4 (data_s3[l_inst]),
        .Q5 (data_s4[l_inst]),
        .Q6 (data_s5[l_inst]),
        .Q7 (data_s6[l_inst]),
        .Q8 (data_s7[l_inst]),
        .SHIFTOUT1 (),
        .SHIFTOUT2 (),
        .BITSLIP (1'b0),
        .CE1 (1'b1),
        .CE2 (1'b1),
        .CLKDIVP (1'b0),
        .CLK (clk),
        .CLKB (~clk),
        .CLKDIV (div_clk),
        .OCLK (1'b0),
        .DYNCLKDIVSEL (1'b0),
        .DYNCLKSEL (1'b0),
        .D (1'b0),
        .DDLY (data_in_idelay_s[l_inst]),
        .OFB (1'b0),
        .OCLKB (1'b0),
        .RST (rst),
        .SHIFTIN1 (1'b0),
        .SHIFTIN2 (1'b0));
      end /* g_data */

    end
  endgenerate


endmodule

// ***************************************************************************
// ***************************************************************************
