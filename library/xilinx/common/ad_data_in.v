// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

module ad_data_in #(
  parameter   SINGLE_ENDED = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   DDR_SDR_N = 1,
  parameter   IDDR_CLK_EDGE ="SAME_EDGE",
  // for 7 series devices
  parameter   IDELAY_TYPE = "VAR_LOAD",
  // for ultrascale devices
  parameter   DELAY_FORMAT = "COUNT",
  parameter   US_DELAY_TYPE = "VAR_LOAD",
  // for all
  parameter   IODELAY_ENABLE = 1,
  parameter   IODELAY_CTRL = 0,
  parameter   IODELAY_GROUP = "dev_if_delay_group",
  parameter   REFCLK_FREQUENCY = 200
) (

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
  output              delay_locked
);

  // internal parameters

  localparam  NONE = -1;
  localparam  SEVEN_SERIES = 1;
  localparam  ULTRASCALE = 2;
  localparam  ULTRASCALE_PLUS = 3;

  // do not instantiate an IDELAYCTRL if no IDELAY is instantiated
  localparam  IODELAY_CTRL_ENABLED = (IODELAY_ENABLE & IODELAY_CTRL);
  localparam  IODELAY_CTRL_SIM_DEVICE = (FPGA_TECHNOLOGY == ULTRASCALE_PLUS) ? "ULTRASCALE" :
    (FPGA_TECHNOLOGY == ULTRASCALE) ? "ULTRASCALE" : "7SERIES";

  localparam  IODELAY_SIM_DEVICE = (FPGA_TECHNOLOGY == ULTRASCALE_PLUS) ? "ULTRASCALE_PLUS" :
    (FPGA_TECHNOLOGY == ULTRASCALE) ? "ULTRASCALE" : "7SERIES";

/*
* For 7 series, IDELAYCTRL is enabled ALWAYS, meaning in the following situations:
  * when IDELAY_TYPE = FIXED
  * when IDELAY_TYPE = VARIABLE
  * when IDELAY_TYPE = VAR_LOAD
**/

/*
 * For UltraScale/UltraScale+:
   * when DELAY_FORMAT = TIME:
     * IDELAYCTRL must be used
     * REFCLK_FREQUENCY must reflect the clock frequency of REF_CLK applied to
      the IDELAYCTRL component
     * DELAY_VALUE attribute represents an amount in ps
     * The total delay through the IDELAYE3 is the align delay + DELAY_VALUE
     * EN_VTC depends on DELAY_TYPE attribute:
       * when FIXED mode: EN_VTC = 1
       * It must be actively manipulated when the delay line is used in
        VARIABLE or VAR_LOAD mode
        (this section is NOT IMPLEMENTED! More details in UG571, DELAY_TYPE = VAR_LOAD mode and VARIABLE mode)

   * when DELAY_FORMAT = COUNT:
     * DO NOT use an IDELAYCTRL
     * REFCLK_FREQUENCY must be set to default frequency (300MHz)
     * Delay line represents an amount of taps (512 taps available)
     * CNTVALUEIN/OUT[8:0] values represent the amount of taps the delay line
      is set to
     * EN_VTC = 0
   **/

  // internal signals

  wire                rx_data_ibuf_s;
  wire                rx_data_idelay_s;
  wire        [ 8:0]  up_drdata_s;

  // internal registers

  reg           en_vtc;

  // determine EN_VTC (VAR_LOAD and VARIABLE modes not implemented as in UG571)

  always @(posedge rx_clk) begin
    if (DELAY_FORMAT == "TIME") begin
      if (US_DELAY_TYPE == "FIXED") begin
        en_vtc <= 1'b1;
      end else begin // "VAR_LOAD", "VARIABLE"
        en_vtc <= ~up_dld;
      end
    end else begin // "COUNT"
      en_vtc <= 1'b0;
    end
  end

  // delay controller

  generate
  if (IODELAY_CTRL_ENABLED == 0) begin
    assign delay_locked = 1'b1;
  end else begin
    (* IODELAY_GROUP = IODELAY_GROUP *)
    IDELAYCTRL #(
      .SIM_DEVICE (IODELAY_CTRL_SIM_DEVICE)
    ) i_delay_ctrl (
      .RST (delay_rst),
      .REFCLK (delay_clk),
      .RDY (delay_locked));
  end
  endgenerate

  // receive data interface, ibuf -> idelay -> iddr(if enabled)

  // ibuf

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

  // bypass IDELAY

  generate
  if (IODELAY_ENABLE == 0) begin
    assign rx_data_idelay_s = rx_data_ibuf_s;
    assign up_drdata = 5'd0;
  end
  endgenerate

  // idelay

  generate
  if (FPGA_TECHNOLOGY == SEVEN_SERIES && IODELAY_ENABLE == 1) begin
    (* IODELAY_GROUP = IODELAY_GROUP *)
    IDELAYE2 #(
      .CINVCTRL_SEL ("FALSE"),
      .DELAY_SRC ("IDATAIN"),
      .HIGH_PERFORMANCE_MODE ("FALSE"),
      .IDELAY_TYPE (IDELAY_TYPE),
      .IDELAY_VALUE (0),
      .REFCLK_FREQUENCY (REFCLK_FREQUENCY),
      .PIPE_SEL ("FALSE"),
      .SIGNAL_PATTERN ("DATA")
    ) i_rx_data_idelay (
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
  if ((FPGA_TECHNOLOGY == ULTRASCALE || FPGA_TECHNOLOGY == ULTRASCALE_PLUS)
    && (IODELAY_ENABLE == 1)) begin

    assign up_drdata = up_drdata_s[8:4];
    (* IODELAY_GROUP = IODELAY_GROUP *)
    IDELAYE3 #(
      .SIM_DEVICE (IODELAY_SIM_DEVICE),
      .DELAY_SRC ("IDATAIN"),
      .DELAY_TYPE (US_DELAY_TYPE),
      .REFCLK_FREQUENCY (REFCLK_FREQUENCY),
      .DELAY_FORMAT (DELAY_FORMAT)
    ) i_rx_data_idelay (
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
      .EN_VTC (en_vtc));
  end
  endgenerate

  // DDR or SDR

  generate
    if (DDR_SDR_N == 1'b1) begin
      // iddr
      if (FPGA_TECHNOLOGY == ULTRASCALE || FPGA_TECHNOLOGY == ULTRASCALE_PLUS) begin
        IDDRE1 #(
          .DDR_CLK_EDGE (IDDR_CLK_EDGE)
        ) i_rx_data_iddr (
          .R (1'b0),
          .C (rx_clk),
          .CB (~rx_clk),
          .D (rx_data_idelay_s),
          .Q1 (rx_data_p),
          .Q2 (rx_data_n));
      end

      if (FPGA_TECHNOLOGY == SEVEN_SERIES) begin
        IDDR #(
          .DDR_CLK_EDGE (IDDR_CLK_EDGE)
        ) i_rx_data_iddr (
          .CE (1'b1),
          .R (1'b0),
          .S (1'b0),
          .C (rx_clk),
          .D (rx_data_idelay_s),
          .Q1 (rx_data_p),
          .Q2 (rx_data_n));
      end
    // sdr
    end else begin
      assign rx_data_p = rx_data_idelay_s;
      assign rx_data_n = 1'b0;
    end
  endgenerate

endmodule
