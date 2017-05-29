// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// This core  is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory of
//      the repository (LICENSE_GPL2), and at: <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license as noted in the top level directory, or on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad_cmos_in #(

  parameter   DEVICE_TYPE = 0,
  parameter   IODELAY_CTRL = 0,
  parameter   IODELAY_GROUP = "dev_if_delay_group") (

  // data interface

  input                   rx_clk,
  input                   rx_data_in,
  output                  rx_data_p,
  output  reg             rx_data_n,

  // delay-data interface

  input                   up_clk,
  input                   up_dld,
  input       [ 4:0]      up_dwdata,
  output      [ 4:0]      up_drdata,

  // delay-cntrl interface

  input                   delay_clk,
  input                   delay_rst,
  output                  delay_locked);

  localparam  SERIES7 = 0;
  localparam  VIRTEX6 = 1;

  // internal registers

  // internal signals

  wire                rx_data_n_s;
  wire                rx_data_ibuf_s;
  wire                rx_data_idelay_s;

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

  // receive data interface, ibuf -> idelay -> iddr

  IBUF i_rx_data_ibuf (
    .I (rx_data_in),
    .O (rx_data_ibuf_s));

  generate
  if (DEVICE_TYPE == VIRTEX6) begin
  (* IODELAY_GROUP = IODELAY_GROUP *)
  IODELAYE1 #(
    .CINVCTRL_SEL ("FALSE"),
    .DELAY_SRC ("I"),
    .HIGH_PERFORMANCE_MODE ("TRUE"),
    .IDELAY_TYPE ("VAR_LOADABLE"),
    .IDELAY_VALUE (0),
    .ODELAY_TYPE ("FIXED"),
    .ODELAY_VALUE (0),
    .REFCLK_FREQUENCY (200.0),
    .SIGNAL_PATTERN ("DATA"))
  i_rx_data_idelay (
    .T (1'b1),
    .CE (1'b0),
    .INC (1'b0),
    .CLKIN (1'b0),
    .DATAIN (1'b0),
    .ODATAIN (1'b0),
    .CINVCTRL (1'b0),
    .C (up_clk),
    .IDATAIN (rx_data_ibuf_s),
    .DATAOUT (rx_data_idelay_s),
    .RST (up_dld),
    .CNTVALUEIN (up_dwdata),
    .CNTVALUEOUT (up_drdata));
  end else begin
  (* IODELAY_GROUP = IODELAY_GROUP *)
  IDELAYE2 #(
    .CINVCTRL_SEL ("FALSE"),
    .DELAY_SRC ("IDATAIN"),
    .HIGH_PERFORMANCE_MODE ("FALSE"),
    .IDELAY_TYPE ("VAR_LOAD"),
    .IDELAY_VALUE (0),
    .REFCLK_FREQUENCY (200.0),
    .PIPE_SEL ("FALSE"),
    .SIGNAL_PATTERN ("DATA"))
  i_rx_data_idelay (
    .CE (1'b0),
    .INC (1'b0),
    .DATAIN (1'b0),
    .LDPIPEEN (1'b0),
    .CINVCTRL (1'b0),
    .REGRST (1'b0),
    .C (up_clk),
    .IDATAIN (rx_data_ibuf_s),
    .DATAOUT (rx_data_idelay_s),
    .LD (up_dld),
    .CNTVALUEIN (up_dwdata),
    .CNTVALUEOUT (up_drdata));
  end
  endgenerate

  IDDR #(
    .DDR_CLK_EDGE ("SAME_EDGE_PIPELINED"),
    .INIT_Q1 (1'b0),
    .INIT_Q2 (1'b0),
    .SRTYPE ("ASYNC"))
  i_rx_data_iddr (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (rx_clk),
    .D (rx_data_idelay_s),
    .Q1 (rx_data_p),
    .Q2 (rx_data_n_s));

  always @(posedge rx_clk) begin
    rx_data_n <= rx_data_n_s;
  end

endmodule

// ***************************************************************************
// ***************************************************************************
