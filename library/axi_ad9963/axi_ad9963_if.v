// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
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

module axi_ad9963_if #(

  // this parameter controls the buffer type based on the target device.

  parameter   FPGA_TECHNOLOGY = 0,
  parameter   ADC_IODELAY_ENABLE = 0,
  parameter   IO_DELAY_GROUP = "dev_if_delay_group",
  parameter   DELAY_REFCLK_FREQUENCY = 200
) (

  // physical interface (receive)

  input               trx_clk,
  input               trx_iq,
  input       [11:0]  trx_data,

  // physical interface (transmit)

  input               tx_clk,
  output              tx_iq,
  output      [11:0]  tx_data,

  // clock (common to both receive and transmit)

  input               adc_rst,
  input               dac_rst,
  output              adc_clk,
  output              dac_clk,

  // receive data path interface

  output reg          adc_valid,
  output reg  [23:0]  adc_data,
  output reg          adc_status,
  input               up_adc_ce,

  // transmit data path interface

  input       [23:0]  dac_data,
  input               up_dac_ce,

  // delay interface

  input               up_clk,
  input       [12:0]  up_adc_dld,
  input       [64:0]  up_adc_dwdata,
  output      [64:0]  up_adc_drdata,
  input               delay_clk,
  input               delay_rst,
  output              delay_locked
);

  // internal registers

  reg     [11:0]  rx_data_p = 0;

  // internal signals

  wire    [11:0]  rx_data_p_s;
  wire    [11:0]  rx_data_n_s;
  wire            rx_iq_p_s;
  wire            rx_iq_n_s;
  wire    [11:0]  tx_data_p;
  wire    [11:0]  tx_data_n;

  wire            div_clk;

  genvar          l_inst;

  always @(posedge adc_clk) begin
    if( rx_iq_p_s == 1'b1) begin
      adc_data  <= {rx_data_n_s, rx_data_p_s} ;  // data[11:00] I
      adc_valid <= 1'b1;                        // data[23:12] Q
    end else begin
      rx_data_p <= rx_data_p_s;               // if this happens it means that risedge data is sampled on falledge
      adc_data  <= {rx_data_p, rx_data_n_s};  // so we take current N data with previous P data
      adc_valid <= 1'b1;                      // in order to have data sampled at the same instance sent to the DMA
    end
  end

  assign tx_data_p = dac_data[11: 0];
  assign tx_data_n = dac_data[23:12];

  always @(posedge adc_clk) begin
    if (adc_rst == 1'b1) begin
      adc_status <= 1'b0;
    end else begin
      adc_status <= 1'b1;
    end
  end

  // device clock interface (receive clock)

  BUFGCTRL #(
    .INIT_OUT(0),
    .PRESELECT_I0("FALSE"),
    .PRESELECT_I1("FALSE")
  ) bufgctrl_adc (
    .O(adc_clk),
    .CE0(1'b1),
    .CE1(1'b0),
    .I0(trx_clk),
    .I1(1'b0),
    .IGNORE0(1'b0),
    .IGNORE1(1'b0),
    .S0(up_adc_ce),
    .S1(1'b0));

  // receive data interface, ibuf -> idelay -> iddr

  generate
  for (l_inst = 0; l_inst <= 11; l_inst = l_inst + 1) begin: g_rx_data
  ad_data_in #(
    .SINGLE_ENDED (1),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .IODELAY_ENABLE (ADC_IODELAY_ENABLE),
    .IODELAY_CTRL (0),
    .IODELAY_GROUP (IO_DELAY_GROUP),
    .REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY)
  ) i_rx_data (
    .rx_clk (adc_clk),
    .rx_data_in_p (trx_data[l_inst]),
    .rx_data_in_n (1'b0),
    .rx_data_p (rx_data_p_s[l_inst]),
    .rx_data_n (rx_data_n_s[l_inst]),
    .up_clk (up_clk),
    .up_dld (up_adc_dld[l_inst]),
    .up_dwdata (up_adc_dwdata[((l_inst*5)+4):(l_inst*5)]),
    .up_drdata (up_adc_drdata[((l_inst*5)+4):(l_inst*5)]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked ());
  end
  endgenerate

  // receive iq interface, ibuf -> idelay -> iddr

  ad_data_in #(
    .SINGLE_ENDED (1),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .IODELAY_ENABLE (ADC_IODELAY_ENABLE),
    .IODELAY_CTRL (1),
    .IODELAY_GROUP (IO_DELAY_GROUP)
  ) i_rx_iq (
    .rx_clk (adc_clk),
    .rx_data_in_p (trx_iq),
    .rx_data_in_n (1'b0),
    .rx_data_p (rx_iq_p_s),
    .rx_data_n (rx_iq_n_s),
    .up_clk (up_clk),
    .up_dld (up_adc_dld[12]),
    .up_dwdata (up_adc_dwdata[64:60]),
    .up_drdata (up_adc_drdata[64:60]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked));

  // transmit data interface

  BUFR #(
    .BUFR_DIVIDE(2)
  ) i_div_clk_buf (
    .CLR (1'b0),
    .CE (1'b1),
    .I (tx_clk),
    .O (div_clk));

  BUFGCTRL #(
    .INIT_OUT(0),
    .PRESELECT_I0("FALSE"),
    .PRESELECT_I1("FALSE")
  ) bufgctrl_dac (
    .O(dac_clk),
    .CE0(1'b1),
    .CE1(1'b0),
    .I0(div_clk),
    .I1(1'b0),
    .IGNORE0(1'b0),
    .IGNORE1(1'b0),
    .S0(up_dac_ce),
    .S1(1'b0));

  generate
  for (l_inst = 0; l_inst <= 11; l_inst = l_inst + 1) begin: g_tx_data
  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE"),
    .INIT (1'b0),
    .SRTYPE ("SYNC")
  ) i_tx_data_oddr (
    .CE (1'b1),
    .R (dac_rst),
    .S (1'b0),
    .C (dac_clk),
    .D1 (tx_data_n[l_inst]),
    .D2 (tx_data_p[l_inst]),
    .Q (tx_data[l_inst]));
    end
  endgenerate

  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE"),
    .INIT (1'b0),
    .SRTYPE ("SYNC")
  ) i_tx_data_oddr (
    .CE (1'b1),
    .R (dac_rst),
    .S (1'b0),
    .C (dac_clk),
    .D1 (1'b0),
    .D2 (1'b1),
    .Q (tx_iq));

endmodule
