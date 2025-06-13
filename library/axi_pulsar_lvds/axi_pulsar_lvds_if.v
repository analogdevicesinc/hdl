// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
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

module axi_pulsar_lvds_if #(

  parameter FPGA_TECHNOLOGY = 1,
  parameter IO_DELAY_GROUP = "adc_if_delay_group",
  parameter IODELAY_CTRL = 1,
  parameter DELAY_REFCLK_FREQUENCY = 200,
  parameter ADC_DATA_WIDTH = 16
) (

  // delay interface

  input         up_clk,
  input  [ 1:0] up_dld,
  input  [ 9:0] up_dwdata,
  output [ 9:0] up_drdata,
  input         delay_clk,
  input         delay_rst,
  output        delay_locked,

  // adc interface

  input         clk,
  input         clk_gate,
  input         dco_p,
  input         dco_n,
  input         d_p,
  input         d_n,

  output reg                        adc_valid,
  output reg [(ADC_DATA_WIDTH-1):0] adc_data
);

  // internal wires

  wire          d_p_int_s;
  wire          dco;
  wire          dco_s;

  // internal register

  reg [ 1:0]                 clk_gate_d    = 'b0;
  reg [(ADC_DATA_WIDTH-1):0] adc_data_int  = 'b0;

  // adc_valid is 1 for the current sample that is sent

  always @(posedge clk) begin
    adc_valid <= 1'b0;
    clk_gate_d <= {clk_gate_d[0], clk_gate};
    if (clk_gate_d[1] == 1'b1 && clk_gate_d[0] == 1'b0) begin
      adc_data  <= adc_data_int;
      adc_valid <= 1'b1;
    end
  end

  always @(posedge dco) begin
    adc_data_int <= {adc_data_int[(ADC_DATA_WIDTH-2):0], d_p_int_s};
  end

  // data interface - differential to single ended

  ad_data_in #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .IDDR_CLK_EDGE ("OPPOSITE_EDGE"),
    .IODELAY_CTRL (IODELAY_CTRL),
    .IODELAY_GROUP (IO_DELAY_GROUP),
    .REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY),
    .DDR_SDR_N(0)
  ) i_rx_da (
    .rx_clk (dco),
    .rx_data_in_p (d_p),
    .rx_data_in_n (d_n),
    .rx_data_p (d_p_int_s),
    .rx_data_n (),
    .up_clk (up_clk),
    .up_dld (up_dld[0]),
    .up_dwdata (up_dwdata[4:0]),
    .up_drdata (up_drdata[4:0]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked));

  // clock

  IBUFDS i_rx_clk_ibuf (
    .I (dco_p),
    .IB(dco_n),
    .O (dco_s));

  BUFH i_clk_buf (
    .I (dco_s),
    .O (dco));

endmodule
