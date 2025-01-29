// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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

module axi_hmcad15xx_if #(
  parameter          NUM_CHANNELS = 4,
  parameter          FPGA_TECHNOLOGY = 0,
  parameter          IO_DELAY_GROUP = "adc_if_delay_group",
  parameter          DELAY_REFCLK_FREQUENCY = 200
) (

  // device-interface

  input                  clk_in_p,
  input                  clk_in_n,
  input                  fclk_p,
  input                  fclk_n,
  input   [ 7:0]         data_in_p,
  input   [ 7:0]         data_in_n,

  // data path interface

  output                 adc_clk,
  output                 adc_valid,
  output reg  [7:0]      adc_data_0,
  output reg  [7:0]      adc_data_1,
  output reg  [7:0]      adc_data_2,
  output reg  [7:0]      adc_data_3,

  // delay control signals
  input                   up_clk,
  input       [29:0]      up_dld,
  input       [149:0]     up_dwdata,
  output      [149:0]     up_drdata,
  input                   delay_clk,
  input                   delay_rst,
  output                  delay_locked

);
wire fclk;

 ad_data_clk i_adc_clk (
    .rst (1'b0),
    .locked (),
    .clk_in_p (clk_in_p),
    .clk_in_n (clk_in_n),
    .clk (adc_clk));

ad_data_clk i_adc_fclk (
   .rst (1'b0),
   .locked (),
   .clk_in_p (fclk_p),
   .clk_in_n (fclk_n),
   .clk (fclk));

localparam NUM_LANES = 8;

wire [7:0] rx_data_p;
wire [7:0] rx_data_n;

 generate
   genvar i;
   for (i = 0; i < NUM_LANES; i=i+1) begin : hmcad15xx_lanes
     ad_data_in # (
      .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
      .IODELAY_CTRL (0),
      .IODELAY_GROUP (IO_DELAY_GROUP),
      .REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY),
      .IDDR_CLK_EDGE("OPPOSITE_EDGE")
      ) ad_data_in_inst (
        .rx_clk(adc_clk),
        .rx_data_in_p(data_in_p[i]),
        .rx_data_in_n(data_in_n[i]),
        .rx_data_p(rx_data_p[i]),
        .rx_data_n(rx_data_n[i]),
        .up_clk(up_clk),
        .up_dld(up_dld[i]),
        .up_dwdata(up_dwdata[((i*5)+4):(i*5)]),
        .up_drdata(up_drdata[((i*5)+4):(i*5)]),
        .delay_clk(delay_clk),
        .delay_rst(delay_rst),
        .delay_locked(delay_locked));
  end
endgenerate


  always @(posedge adc_clk) begin
    adc_data_0 <= {rx_data_p[0], rx_data_n[0],rx_data_p[4], rx_data_n[4] };
    adc_data_1 <= {rx_data_p[1], rx_data_n[1],rx_data_p[5], rx_data_n[5] };
    adc_data_2 <= {rx_data_p[2], rx_data_n[2],rx_data_p[6], rx_data_n[6] };
    adc_data_3 <= {rx_data_p[3], rx_data_n[3],rx_data_p[7], rx_data_n[7] };
  end


endmodule
