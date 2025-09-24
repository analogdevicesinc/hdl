// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2025 Analog Devices, Inc. All rights reserved.
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
// This is the LVDS/DDR interface, note that overrange is independent of data path,
// software will not be able to relate overrange to a specific sample!

`timescale 1ns/100ps

module axi_ltc2387_if #(

  parameter FPGA_TECHNOLOGY = 1,
  parameter IO_DELAY_GROUP = "adc_if_delay_group",
  parameter IODELAY_CTRL = 1,
  parameter DELAY_REFCLK_FREQUENCY = 200,
  parameter TWOLANES = 1,    // 0 for one-lane, 1 for two lanes
  parameter ADC_RES = 18  // 16 or 18 bits
) (

  // delay interface

  input             up_clk,
  input    [ 1:0]   up_dld,
  input    [ 9:0]   up_dwdata,
  output   [ 9:0]   up_drdata,
  input             delay_clk,
  input             delay_rst,
  output            delay_locked,

  // adc interface

  input             clk,
  input             clk_gate,
  input             dco_p,
  input             dco_n,
  input             da_p,
  input             da_n,
  input             db_p,
  input             db_n,

  output reg               adc_valid,
  output reg [ADC_RES-1:0] adc_data
);

  localparam ONE_L_WIDTH = (ADC_RES == 18) ? 9 : 8;
  localparam TWO_L_WIDTH = (ADC_RES == 18) ? 5 : 4;
  localparam WIDTH = (TWOLANES == 0) ? ONE_L_WIDTH : TWO_L_WIDTH;

  // internal wires

  wire            da_p_int_s;
  wire            da_n_int_s;
  wire            db_p_int_s;
  wire            db_n_int_s;
  wire            dco;
  wire            dco_s;
  wire   [17:0]   adc_data_int;

  // internal registers

  reg  [WIDTH:0]  adc_data_da_p = 'b0;
  reg  [WIDTH:0]  adc_data_da_n = 'b0;
  reg  [WIDTH:0]  adc_data_db_p = 'b0;
  reg  [WIDTH:0]  adc_data_db_n = 'b0;
  reg      [2:0]  clk_gate_d = 'b0;

  // assignments

  always @(posedge clk) begin
    adc_valid <= 1'b0;
    clk_gate_d <= {clk_gate_d[1:0], clk_gate};
    if (clk_gate_d[1] == 1'b1 && clk_gate_d[0] == 1'b0) begin
      if (ADC_RES == 18) begin
        adc_data <= adc_data_int;
        adc_valid <= 1'b1;
      end else begin
        adc_data <= adc_data_int[15:0];
        adc_valid <= 1'b1;
      end
    end
  end

  always @(posedge dco) begin
    adc_data_da_p <= {adc_data_da_p[WIDTH-1:0], da_p_int_s};
    adc_data_da_n <= {adc_data_da_n[WIDTH-1:0], da_n_int_s};
    if (TWOLANES) begin
      adc_data_db_p <= {adc_data_db_p[WIDTH-1:0], db_p_int_s};
      adc_data_db_n <= {adc_data_db_n[WIDTH-1:0], db_n_int_s};
    end else begin
      adc_data_db_p <= 'd0;
      adc_data_db_n <= 'd0;
    end
  end

  // bits rearrangement

  if (!TWOLANES) begin
    assign adc_data_int[17] = adc_data_da_p[7];
    assign adc_data_int[16] = adc_data_da_n[7];
    assign adc_data_int[15] = adc_data_da_p[6];
    assign adc_data_int[14] = adc_data_da_n[6];
    assign adc_data_int[13] = adc_data_da_p[5];
    assign adc_data_int[12] = adc_data_da_n[5];
    assign adc_data_int[11] = adc_data_da_p[4];
    assign adc_data_int[10] = adc_data_da_n[4];
    assign adc_data_int[9] = adc_data_da_p[3];
    assign adc_data_int[8] = adc_data_da_n[3];
    assign adc_data_int[7] = adc_data_da_p[2];
    assign adc_data_int[6] = adc_data_da_n[2];
    assign adc_data_int[5] = adc_data_da_p[1];
    assign adc_data_int[4] = adc_data_da_n[1];
    assign adc_data_int[3] = adc_data_da_p[0];
    assign adc_data_int[2] = adc_data_da_n[0];
    assign adc_data_int[1] = da_p_int_s;
    assign adc_data_int[0] = da_n_int_s;
  end else begin
    if (ADC_RES == 18) begin
      assign adc_data_int[17] = adc_data_da_p[3];
      assign adc_data_int[16] = adc_data_db_p[3];
      assign adc_data_int[15] = adc_data_da_n[3];
      assign adc_data_int[14] = adc_data_db_n[3];
      assign adc_data_int[13] = adc_data_da_p[2];
      assign adc_data_int[12] = adc_data_db_p[2];
      assign adc_data_int[11] = adc_data_da_n[2];
      assign adc_data_int[10] = adc_data_db_n[2];
      assign adc_data_int[9] = adc_data_da_p[1];
      assign adc_data_int[8] = adc_data_db_p[1];
      assign adc_data_int[7] = adc_data_da_n[1];
      assign adc_data_int[6] = adc_data_db_n[1];
      assign adc_data_int[5] = adc_data_da_p[0];
      assign adc_data_int[4] = adc_data_db_p[0];
      assign adc_data_int[3] = adc_data_da_n[0];
      assign adc_data_int[2] = adc_data_db_n[0];
      assign adc_data_int[1] = da_p_int_s;
      assign adc_data_int[0] = db_p_int_s;
    end else begin
      assign adc_data_int[15] = adc_data_da_p[2];
      assign adc_data_int[14] = adc_data_db_p[2];
      assign adc_data_int[13] = adc_data_da_n[2];
      assign adc_data_int[12] = adc_data_db_n[2];
      assign adc_data_int[11] = adc_data_da_p[1];
      assign adc_data_int[10] = adc_data_db_p[1];
      assign adc_data_int[9] = adc_data_da_n[1];
      assign adc_data_int[8] = adc_data_db_n[1];
      assign adc_data_int[7] = adc_data_da_p[0];
      assign adc_data_int[6] = adc_data_db_p[0];
      assign adc_data_int[5] = adc_data_da_n[0];
      assign adc_data_int[4] = adc_data_db_n[0];
      assign adc_data_int[3] = da_p_int_s;
      assign adc_data_int[2] = db_p_int_s;
      assign adc_data_int[1] = da_n_int_s;
      assign adc_data_int[0] = db_n_int_s;
    end
  end

  // data interface - differential to single ended

  ad_data_in #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .IDDR_CLK_EDGE ("OPPOSITE_EDGE"),
    .IODELAY_CTRL (IODELAY_CTRL),
    .IODELAY_GROUP (IO_DELAY_GROUP),
    .REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY)
  ) i_rx_da (
    .rx_clk (dco),
    .rx_data_in_p (da_p),
    .rx_data_in_n (da_n),
    .rx_data_p (da_p_int_s),
    .rx_data_n (da_n_int_s),
    .up_clk (up_clk),
    .up_dld (up_dld[0]),
    .up_dwdata (up_dwdata[4:0]),
    .up_drdata (up_drdata[4:0]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked));

  // instantiate only if TWOLANES
  if (TWOLANES) begin
    ad_data_in #(
      .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
      .IDDR_CLK_EDGE ("OPPOSITE_EDGE"),
      .IODELAY_CTRL (0),
      .IODELAY_GROUP (IO_DELAY_GROUP),
      .REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY)
    ) i_rx_db (
      .rx_clk (dco),
      .rx_data_in_p (db_p),
      .rx_data_in_n (db_n),
      .rx_data_p (db_p_int_s),
      .rx_data_n (db_n_int_s),
      .up_clk (up_clk),
      .up_dld (up_dld[1]),
      .up_dwdata (up_dwdata[9:5]),
      .up_drdata (up_drdata[9:5]),
      .delay_clk (delay_clk),
      .delay_rst (delay_rst),
      .delay_locked ());
  end else begin
    // when in one-lane mode, tie them to 0,
    // otherwise the input pin of input buffer
    // will have an illegal connection to logic constant value
    assign db_p_int_s = 1'b0;
    assign db_n_int_s = 1'b0;
  end

  // clock

  IBUFGDS i_rx_clk_ibuf (
    .I (dco_p),
    .IB (dco_n),
    .O (dco_s));

  BUFR i_clk_gbuf (
    .CLR (1'b0),
    .CE (1'b1),
    .I (dco_s),
    .O (dco));

endmodule
