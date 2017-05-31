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
// freedoms and responsabilities that he or she has by using this source/core.
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

`timescale 1ns/1ns

module prcfg_top#(

  parameter   NUM_CHANNEL = 4,
  parameter   ADC_EN      = 1,
  parameter   DAC_EN      = 1) (

  input                   clk,

  // gpio
  input       [31:0]      dac_gpio_input,
  output      [31:0]      dac_gpio_output,
  input       [31:0]      adc_gpio_input,
  output      [31:0]      adc_gpio_output,

  // TX side
  input                   dma_dac_0_enable,
  output      [(DBUS_WIDTH-1):0]  dma_dac_0_data,
  input                   dma_dac_0_valid,
  input                   dma_dac_1_enable,
  output      [(DBUS_WIDTH-1):0]  dma_dac_1_data,
  input                   dma_dac_1_valid,
  input                   dma_dac_2_enable,
  output      [(DBUS_WIDTH-1):0]  dma_dac_2_data,
  input                   dma_dac_2_valid,
  input                   dma_dac_3_enable,
  output      [(DBUS_WIDTH-1):0]  dma_dac_3_data,
  input                   dma_dac_3_valid,

  output                  core_dac_0_enable,
  input       [(DBUS_WIDTH-1):0]  core_dac_0_data,
  output                  core_dac_0_valid,
  output                  core_dac_1_enable,
  input       [(DBUS_WIDTH-1):0]  core_dac_1_data,
  output                  core_dac_1_valid,
  output                  core_dac_2_enable,
  input       [(DBUS_WIDTH-1):0]  core_dac_2_data,
  output                  core_dac_2_valid,
  output                  core_dac_3_enable,
  input       [(DBUS_WIDTH-1):0]  core_dac_3_data,
  output                  core_dac_3_valid,

  // RX side
  input                   dma_adc_0_enable,
  input       [(DBUS_WIDTH-1):0]  dma_adc_0_data,
  input                   dma_adc_0_valid,
  input                   dma_adc_1_enable,
  input       [(DBUS_WIDTH-1):0]  dma_adc_1_data,
  input                   dma_adc_1_valid,
  input                   dma_adc_2_enable,
  input       [(DBUS_WIDTH-1):0]  dma_adc_2_data,
  input                   dma_adc_2_valid,
  input                   dma_adc_3_enable,
  input       [(DBUS_WIDTH-1):0]  dma_adc_3_data,
  input                   dma_adc_3_valid,

  output                  core_adc_0_enable,
  output      [(DBUS_WIDTH-1):0]  core_adc_0_data,
  output                  core_adc_0_valid,
  output                  core_adc_1_enable,
  output      [(DBUS_WIDTH-1):0]  core_adc_1_data,
  output                  core_adc_1_valid,
  output                  core_adc_2_enable,
  output      [(DBUS_WIDTH-1):0]  core_adc_2_data,
  output                  core_adc_2_valid,
  output                  core_adc_3_enable,
  output      [(DBUS_WIDTH-1):0]  core_adc_3_data,
  output                  core_adc_3_valid);

  localparam  ENABELED    = 1;
  localparam  DATA_WIDTH  = 16;


  localparam  DBUS_WIDTH  = DATA_WIDTH * NUM_CHANNEL;

  wire    [31:0]                    adc_gpio_out_s[(NUM_CHANNEL - 1):0];
  wire    [(NUM_CHANNEL - 1):0]     adc_gpio_out_s_inv[31:0];

  wire    [31:0]                    dac_gpio_out_s[(NUM_CHANNEL - 1):0];
  wire    [(NUM_CHANNEL - 1):0]     dac_gpio_out_s_inv[31:0];

  wire    [(NUM_CHANNEL - 1):0]     core_adc_enable_s;
  wire    [(NUM_CHANNEL - 1):0]     core_adc_valid_s;
  wire    [(NUM_CHANNEL - 1):0]     core_adc_data_s[15:0];
  wire    [(NUM_CHANNEL - 1):0]     dma_adc_enable_s;
  wire    [(NUM_CHANNEL - 1):0]     dma_adc_valid_s;
  wire    [(NUM_CHANNEL - 1):0]     dma_adc_data_s[15:0];
  wire    [(NUM_CHANNEL - 1):0]     core_dac_enable_s;
  wire    [(NUM_CHANNEL - 1):0]     core_dac_valid_s;
  wire    [(NUM_CHANNEL - 1):0]     core_dac_data_s[15:0];
  wire    [(NUM_CHANNEL - 1):0]     dma_dac_enable_s;
  wire    [(NUM_CHANNEL - 1):0]     dma_dac_valid_s;
  wire    [(NUM_CHANNEL - 1):0]     dma_dac_data_s[15:0];

  genvar l_inst;

  generate
    for(l_inst = 0; l_inst < NUM_CHANNEL; l_inst = l_inst + 1) begin: tx_rx_data_path
      if(ADC_EN == ENABELED) begin
          prcfg_adc #(
            .CHANNEL_ID(l_inst)
          ) i_prcfg_adc_i (
            .clk(clk),
            .control(adc_gpio_input),
            .status(adc_gpio_out_s[l_inst]),
            .src_adc_enable(core_adc_enable_s[l_inst]),
            .src_adc_valid(core_adc_valid_s[l_inst]),
            .src_adc_data(core_adc_data_s[l_inst]),
            .dst_adc_enable(dma_adc_enable_s[l_inst]),
            .dst_adc_valid(dma_adc_valid_s[l_inst]),
            .dst_adc_data(dma_adc_data_s[l_inst])
          );
      end
      if(DAC_EN == ENABELED) begin
        prcfg_dac #(
          .CHANNEL_ID(l_inst)
        ) i_prcfg_dac_i (
          .clk(clk),
          .control(dac_gpio_input),
          .status(dac_gpio_out_s[l_inst]),
          .src_dac_enable(dma_dac_enable_s[l_inst]),
          .src_dac_data(dma_dac_data_s[l_inst]),
          .src_dac_valid(dma_dac_valid_s[l_inst]),
          .dst_dac_enable(core_dac_enable_s[l_inst]),
          .dst_dac_data(core_dac_data_s[l_inst]),
          .dst_dac_valid(core_dac_valid_s[l_inst])
        );
      end
    end
  endgenerate

  genvar i;
  genvar j;

  generate
  for(i = 0; i < 32; i = i + 1) begin
    for(j = 0; j < NUM_CHANNEL; j = j + 1) begin
      assign adc_gpio_out_s_inv[i][j] = adc_gpio_out_s[j][i];
      assign dac_gpio_out_s_inv[i][j] = dac_gpio_out_s[j][i];
    end
  end
  endgenerate

  // generate gpio_outputs
  generate
  for(i = 0; i < 32; i = i + 1) begin
    assign adc_gpio_output[i] = |adc_gpio_out_s_inv[i];
    assign dac_gpio_output[i] = |dac_gpio_out_s_inv[i];
  end
  endgenerate

  // port connections

  assign core_dac_0_enable = core_dac_enable_s[0];
  assign core_dac_0_valid = core_dac_valid_s[0];
  assign core_dac_data_s[0] = core_dac_0_data;
  assign core_dac_1_enable = core_dac_enable_s[1];
  assign core_dac_1_valid = core_dac_valid_s[1];
  assign core_dac_data_s[1] = core_dac_1_data;
  assign core_dac_2_enable = core_dac_enable_s[2];
  assign core_dac_2_valid = core_dac_valid_s[2];
  assign core_dac_data_s[2] = core_dac_2_data;
  assign core_dac_3_enable = core_dac_enable_s[3];
  assign core_dac_3_valid = core_dac_valid_s[3];
  assign core_dac_data_s[3] = core_dac_3_data;

  assign dma_dac_enable_s[0] = dma_dac_0_enable;
  assign dma_dac_valid_s[0] = dma_dac_0_valid;
  assign dma_dac_0_data = dma_dac_data_s[0];
  assign dma_dac_enable_s[1] = dma_dac_1_enable;
  assign dma_dac_valid_s[1] = dma_dac_1_valid;
  assign dma_dac_1_data = dma_dac_data_s[1];
  assign dma_dac_enable_s[2] = dma_dac_2_enable;
  assign dma_dac_valid_s[2] = dma_dac_2_valid;
  assign dma_dac_2_data = dma_dac_data_s[2];
  assign dma_dac_enable_s[3] = dma_dac_3_enable;
  assign dma_dac_valid_s[3] = dma_dac_3_valid;
  assign dma_dac_3_data = dma_dac_data_s[3];

  assign core_adc_0_enable = core_adc_enable_s[0];
  assign core_adc_0_valid = core_adc_valid_s[0];
  assign core_adc_0_data = core_adc_data_s[0];
  assign core_adc_1_enable = core_adc_enable_s[1];
  assign core_adc_1_valid = core_adc_valid_s[1];
  assign core_adc_1_data = core_adc_data_s[1];
  assign core_adc_2_enable = core_adc_enable_s[2];
  assign core_adc_2_valid = core_adc_valid_s[2];
  assign core_adc_2_data = core_adc_data_s[2];
  assign core_adc_3_enable = core_adc_enable_s[3];
  assign core_adc_3_valid = core_adc_valid_s[3];
  assign core_adc_3_data = core_adc_data_s[3];

  assign dma_adc_enable_s[0] = dma_adc_0_enable;
  assign dma_adc_valid_s[0] = dma_adc_0_valid;
  assign dma_adc_data_s[0] = dma_adc_0_data;
  assign dma_adc_enable_s[1] = dma_adc_1_enable;
  assign dma_adc_valid_s[1] = dma_adc_1_valid;
  assign dma_adc_data_s[1] = dma_adc_1_data;
  assign dma_adc_enable_s[2] = dma_adc_2_enable;
  assign dma_adc_valid_s[2] = dma_adc_2_valid;
  assign dma_adc_data_s[2] = dma_adc_2_data;
  assign dma_adc_enable_s[3] = dma_adc_3_enable;
  assign dma_adc_valid_s[3] = dma_adc_3_valid;
  assign dma_adc_data_s[3] = dma_adc_3_data;

endmodule

