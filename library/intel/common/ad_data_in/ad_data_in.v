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

module ad_data_in #(

  // parameters

  parameter   SINGLE_ENDED = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   IODELAY_ENABLE = 1,
  parameter   IODELAY_CTRL = 0,
  parameter   IODELAY_GROUP = "dev_if_delay_group",
  parameter   REFCLK_FREQUENCY = 200) (

  // data interface

  input               rx_clk,
  input               rx_data_in_p,
  input               rx_data_in_n,
  output              rx_data_p,
  output              rx_data_n,

  // delay-data interface

  input               up_clk,
  input               up_dld,
  input       [ 4:0]  up_dwdata,
  output      [ 4:0]  up_drdata,

  // delay-cntrl interface

  input               delay_clk,
  input               delay_rst,
  output              delay_locked);

  // internal parameters

  localparam  NONE = -1;
  localparam  SEVEN_SERIES = 1;
  localparam  ULTRASCALE = 2;
  localparam  ULTRASCALE_PLUS = 3;

  localparam  IODELAY_CTRL_ENABLED = (IODELAY_ENABLE == 1) ? IODELAY_CTRL : 0;
  localparam  IODELAY_CTRL_SIM_DEVICE = (FPGA_TECHNOLOGY == ULTRASCALE_PLUS) ? "ULTRASCALE" :
    (FPGA_TECHNOLOGY == ULTRASCALE) ? "ULTRASCALE" : "7SERIES";

  localparam  IODELAY_FPGA_TECHNOLOGY = (IODELAY_ENABLE == 1) ? FPGA_TECHNOLOGY : NONE;
  localparam  IODELAY_SIM_DEVICE = (FPGA_TECHNOLOGY == ULTRASCALE_PLUS) ? "ULTRASCALE_PLUS" :
    (FPGA_TECHNOLOGY == ULTRASCALE) ? "ULTRASCALE" : "7SERIES";

  // internal signals

  wire                rx_data_ibuf_s;
  wire                rx_data_idelay_s;
  wire        [ 8:0]  up_drdata_s;

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

  // receive data interface, ibuf -> idelay -> iddr

  generate
  if (SINGLE_ENDED == 1) begin
  IBUF i_rx_data_ibuf (
    .I (rx_data_in_p),
    .O (rx_data_ibuf_s));
  end else begin
  IBUFDS i_rx_data_ibuf (
    .I (rx_data_in_p),
    .IB (rx_data_in_n),
    .O (rx_data_ibuf_s));
  end
  endgenerate

  // idelay

  generate
  if (IODELAY_FPGA_TECHNOLOGY == SEVEN_SERIES) begin
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

  generate
  if ((IODELAY_FPGA_TECHNOLOGY == ULTRASCALE) || (IODELAY_FPGA_TECHNOLOGY == ULTRASCALE_PLUS)) begin
  assign up_drdata = up_drdata_s[8:4];
  (* IODELAY_GROUP = IODELAY_GROUP *)
  IDELAYE3 #(
    .SIM_DEVICE (IODELAY_SIM_DEVICE),
    .DELAY_SRC ("IDATAIN"),
    .DELAY_TYPE ("VAR_LOAD"),
    .REFCLK_FREQUENCY (REFCLK_FREQUENCY),
    .DELAY_FORMAT ("COUNT"))
  i_rx_data_idelay (
    .CASC_RETURN (1'b0),
    .CASC_IN (1'b0),
    .CASC_OUT (),
    .CE (1'b0),
    .CLK (up_clk),
    .INC (1'b0),
    .LOAD (up_dld),
    .CNTVALUEIN ({up_dwdata, 4'd0}),
    .CNTVALUEOUT (up_drdata_s),
    .DATAIN (1'b0),
    .IDATAIN (rx_data_ibuf_s),
    .DATAOUT (rx_data_idelay_s),
    .RST (1'b0),
    .EN_VTC (~up_dld));
  end
  endgenerate

  generate
  if (IODELAY_FPGA_TECHNOLOGY == NONE) begin
  assign rx_data_idelay_s = rx_data_ibuf_s;
	assign up_drdata = 5'd0;
  end
  endgenerate

  // iddr

  generate
  if ((FPGA_TECHNOLOGY == ULTRASCALE) || (FPGA_TECHNOLOGY == ULTRASCALE_PLUS)) begin
  IDDRE1 #(.DDR_CLK_EDGE ("SAME_EDGE")) i_rx_data_iddr (
    .R (1'b0),
    .C (rx_clk),
    .CB (~rx_clk),
    .D (rx_data_idelay_s),
    .Q1 (rx_data_p),
    .Q2 (rx_data_n));
  end
  endgenerate

  generate
  if (FPGA_TECHNOLOGY == SEVEN_SERIES) begin
  IDDR #(.DDR_CLK_EDGE ("SAME_EDGE")) i_rx_data_iddr (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (rx_clk),
    .D (rx_data_idelay_s),
    .Q1 (rx_data_p),
    .Q2 (rx_data_n));
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
