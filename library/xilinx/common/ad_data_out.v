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

`timescale 1ns/100ps

module ad_data_out #(

  parameter   FPGA_TECHNOLOGY = 0,
  parameter   SINGLE_ENDED = 0,
  parameter   IODELAY_ENABLE = 0,
  parameter   IODELAY_CTRL = 0,
  parameter   IODELAY_GROUP = "dev_if_delay_group",
  parameter   REFCLK_FREQUENCY = 200) (

  // data interface

  input               tx_clk,
  input               tx_data_p,
  input               tx_data_n,
  output              tx_data_out_p,
  output              tx_data_out_n,

  // delay-data interface

  input               up_clk,
  input               up_dld,
  input       [ 4:0]  up_dwdata,
  output      [ 4:0]  up_drdata,

  // delay-cntrl interface

  input               delay_clk,
  input               delay_rst,
  output              delay_locked);

  localparam  NONE = -1;
  localparam  SEVEN_SERIES = 1;
  localparam  ULTRASCALE = 2;
  localparam  ULTRASCALE_PLUS = 3;

  localparam  IODELAY_CTRL_ENABLED = (IODELAY_ENABLE == 1) ? IODELAY_CTRL : 0;
  localparam  IODELAY_CTRL_SIM_DEVICE = (FPGA_TECHNOLOGY == ULTRASCALE_PLUS) ? "ULTRASCALE" :
    (FPGA_TECHNOLOGY == ULTRASCALE) ? "ULTRASCALE" : "7SERIES";

  localparam  IODELAY_FPGA_TECHNOLOGY = (IODELAY_ENABLE == 1) ? FPGA_TECHNOLOGY : NONE;
  localparam  IODELAY_SIM_DEVICE = (FPGA_TECHNOLOGY == ULTRASCALE_PLUS) ? "ULTRASCALE_PLUS_ES1" :
    (FPGA_TECHNOLOGY == ULTRASCALE) ? "ULTRASCALE" : "7SERIES";

  // internal signals

  wire                tx_data_oddr_s;
  wire                tx_data_odelay_s;

  // delay controller

  generate
  if (IODELAY_CTRL_ENABLED == 0) begin
  assign delay_locked = 1'b1;
  end else begin
  (* IODELAY_GROUP = IODELAY_GROUP *)
  IDELAYCTRL #(.SIM_DEVICE (IODELAY_CTRL_SIM_DEVICE)) i_delay_ctrl (
    .RST (delay_rst),
    .REFCLK (delay_clk),
    .RDY (delay_locked));
  end
  endgenerate

  // transmit data interface, oddr -> odelay -> obuf

  generate
  if ((FPGA_TECHNOLOGY == ULTRASCALE) || (FPGA_TECHNOLOGY == ULTRASCALE_PLUS)) begin
  ODDRE1 i_tx_data_oddr (
    .SR (1'b0),
    .C (tx_clk),
    .D1 (tx_data_n),
    .D2 (tx_data_p),
    .Q (tx_data_oddr_s));
  end
  endgenerate

  generate
  if (FPGA_TECHNOLOGY == SEVEN_SERIES) begin
  ODDR #(.DDR_CLK_EDGE ("SAME_EDGE")) i_tx_data_oddr (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (tx_clk),
    .D1 (tx_data_n),
    .D2 (tx_data_p),
    .Q (tx_data_oddr_s));
  end
  endgenerate

  // odelay

  generate
  if (IODELAY_FPGA_TECHNOLOGY == SEVEN_SERIES) begin
  (* IODELAY_GROUP = IODELAY_GROUP *)
  ODELAYE2 #(
    .CINVCTRL_SEL ("FALSE"),
    .DELAY_SRC ("ODATAIN"),
    .HIGH_PERFORMANCE_MODE ("FALSE"),
    .ODELAY_TYPE ("VAR_LOAD"),
    .ODELAY_VALUE (0),
    .REFCLK_FREQUENCY (REFCLK_FREQUENCY),
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
  end
  endgenerate

  generate
  if (IODELAY_FPGA_TECHNOLOGY == NONE) begin
  assign up_drdata = 5'd0;
  assign tx_data_odelay_s = tx_data_oddr_s;
  end
  endgenerate

  // obuf

  generate
  if (SINGLE_ENDED == 1) begin
  assign tx_data_out_n = 1'b0;
  OBUF i_tx_data_obuf (
    .I (tx_data_odelay_s),
    .O (tx_data_out_p));
  end else begin
  OBUFDS i_tx_data_obuf (
    .I (tx_data_odelay_s),
    .O (tx_data_out_p),
    .OB (tx_data_out_n));
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
