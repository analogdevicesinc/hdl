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

module ad_cmos_out #(

  parameter   DEVICE_TYPE = 0,
  parameter   IODELAY_ENABLE = 0,
  parameter   IODELAY_CTRL = 0,
  parameter   IODELAY_GROUP = "dev_if_delay_group") (

  // data interface

  input                   tx_clk,
  input                   tx_data_p,
  input                   tx_data_n,
  output                  tx_data_out,

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

  // internal signals

  wire                tx_data_oddr_s;
  wire                tx_data_odelay_s;

  // delay controller

  generate
  if ((IODELAY_ENABLE == 1) && (DEVICE_TYPE == SERIES7) && (IODELAY_CTRL == 1)) begin
  (* IODELAY_GROUP = IODELAY_GROUP *)
  IDELAYCTRL i_delay_ctrl (
    .RST (delay_rst),
    .REFCLK (delay_clk),
    .RDY (delay_locked));
  end else begin
  assign delay_locked = 1'b1;
  end
  endgenerate

  // transmit data interface, oddr -> odelay -> obuf

  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE"),
    .INIT (1'b0),
    .SRTYPE ("ASYNC"))
  i_tx_data_oddr (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (tx_clk),
    .D1 (tx_data_p),
    .D2 (tx_data_n),
    .Q (tx_data_oddr_s));

  generate
  if ((IODELAY_ENABLE == 1) && (DEVICE_TYPE == SERIES7)) begin
  (* IODELAY_GROUP = IODELAY_GROUP *)
  ODELAYE2 #(
    .CINVCTRL_SEL ("FALSE"),
    .DELAY_SRC ("ODATAIN"),
    .HIGH_PERFORMANCE_MODE ("FALSE"),
    .ODELAY_TYPE ("VAR_LOAD"),
    .ODELAY_VALUE (0),
    .REFCLK_FREQUENCY (200.0),
    .PIPE_SEL ("FALSE"),
    .SIGNAL_PATTERN ("DATA"))
  i_tx_data_odelay (
    .CE (1'b0),
    .CLKIN (1'b0),
    .INC (1'b0),
    .LDPIPEEN (1'b0),
    .CINVCTRL (1'b0),
    .REGRST (1'b0),
    .C (up_clk),
    .ODATAIN (tx_data_oddr_s),
    .DATAOUT (tx_data_odelay_s),
    .LD (up_dld),
    .CNTVALUEIN (up_dwdata),
    .CNTVALUEOUT (up_drdata));
  end else begin
  assign up_drdata = 5'd0;
  assign tx_data_odelay_s = tx_data_oddr_s;
  end
  endgenerate

  OBUF i_tx_data_obuf (
    .I (tx_data_odelay_s),
    .O (tx_data_out));

endmodule

// ***************************************************************************
// ***************************************************************************
