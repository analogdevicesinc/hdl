// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
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
// This is the dac physical interface (drives samples from the low speed clock to the
// dac clock domain.

`timescale 1ns/100ps

module axi_ad9783_if #(

  parameter   FPGA_TECHNOLOGY = 0
) (

  // dac interface

  input            dac_clk_in_p,
  input            dac_clk_in_n,
  output           dac_clk_out_p,
  output           dac_clk_out_n,
  output  [15:0]   dac_data_out_p,
  output  [15:0]   dac_data_out_n,

  // internal resets and clocks

  input            dac_rst,
  output           dac_div_clk,
  output reg       dac_status,

  // data interface

  input   [15:0]   dac_data_a0,
  input   [15:0]   dac_data_a1,
  input   [15:0]   dac_data_a2,
  input   [15:0]   dac_data_a3,
  input   [15:0]   dac_data_b0,
  input   [15:0]   dac_data_b1,
  input   [15:0]   dac_data_b2,
  input   [15:0]   dac_data_b3
);

  // internal registers

  // internal signals

  wire             dac_clk_in_s;
  wire             dac_div_clk_s;
  wire             dac_clk_s;

  // dac status

  always @(posedge dac_div_clk) begin
    if (dac_rst == 1'b1) begin
      dac_status <= 1'd0;
    end else begin
      dac_status <= 1'd1;
    end
  end

  // dac data output serdes(s) & buffers

  ad_serdes_out #(
    .DDR_OR_SDR_N(1),
    .DATA_WIDTH(16),
    .SERDES_FACTOR(8),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY)
  ) i_serdes_out_data (
    .rst (dac_rst),
    .clk (dac_clk_s),
    .div_clk (dac_div_clk),
    .data_oe (1'b1),
    .data_s0 (dac_data_a0),
    .data_s1 (dac_data_b0),
    .data_s2 (dac_data_a1),
    .data_s3 (dac_data_b1),
    .data_s4 (dac_data_a2),
    .data_s5 (dac_data_b2),
    .data_s6 (dac_data_a3),
    .data_s7 (dac_data_b3),
    .data_out_se (),
    .data_out_p (dac_data_out_p),
    .data_out_n (dac_data_out_n));

  // dac clock output serdes & buffer

  ad_serdes_out #(
    .DDR_OR_SDR_N(1),
    .DATA_WIDTH(1),
    .SERDES_FACTOR(8),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY)
  ) i_serdes_out_clk (
    .rst (dac_rst),
    .clk (dac_clk_s),
    .div_clk (dac_div_clk),
    .data_oe (1'b1),
    .data_s0 (1'b1),
    .data_s1 (1'b0),
    .data_s2 (1'b1),
    .data_s3 (1'b0),
    .data_s4 (1'b1),
    .data_s5 (1'b0),
    .data_s6 (1'b1),
    .data_s7 (1'b0),
    .data_out_se (),
    .data_out_p (dac_clk_out_p),
    .data_out_n (dac_clk_out_n));

  // dac clock input buffers

  IBUFGDS i_dac_clk_in_ibuf (
    .I (dac_clk_in_p),
    .IB (dac_clk_in_n),
    .O (dac_clk_s));

  BUFGCE_DIV #(
    .BUFGCE_DIVIDE (4),
    .IS_CE_INVERTED (1'b0),
    .IS_CLR_INVERTED (1'b0),
    .IS_I_INVERTED (1'b0)
  ) i_dac_div_clk_rbuf (
    .O (dac_div_clk_s),
    .CE (1'b1),
    .CLR (1'b0),
    .I (dac_clk_s));

  BUFG i_dac_div_clk_gbuf (
    .I (dac_div_clk_s),
    .O (dac_div_clk));

endmodule
