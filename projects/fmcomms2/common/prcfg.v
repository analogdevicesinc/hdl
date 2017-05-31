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

module prcfg  (

  input                   clk,

  // gpio

  input       [31:0]      dac_gpio_input,
  output      [31:0]      dac_gpio_output,
  input       [31:0]      adc_gpio_input,
  output      [31:0]      adc_gpio_output,

  // tx side

  input                   dma_dac_i0_enable,
  output      [15:0]      dma_dac_i0_data,
  input                   dma_dac_i0_valid,
  input                   dma_dac_q0_enable,
  output      [15:0]      dma_dac_q0_data,
  input                   dma_dac_q0_valid,
  input                   dma_dac_i1_enable,
  output      [15:0]      dma_dac_i1_data,
  input                   dma_dac_i1_valid,
  input                   dma_dac_q1_enable,
  output      [15:0]      dma_dac_q1_data,
  input                   dma_dac_q1_valid,

  output                  core_dac_i0_enable,
  input       [15:0]      core_dac_i0_data,
  output                  core_dac_i0_valid,
  output                  core_dac_q0_enable,
  input       [15:0]      core_dac_q0_data,
  output                  core_dac_q0_valid,
  output                  core_dac_i1_enable,
  input       [15:0]      core_dac_i1_data,
  output                  core_dac_i1_valid,
  output                  core_dac_q1_enable,
  input       [15:0]      core_dac_q1_data,
  output                  core_dac_q1_valid,

  // rx side

  input                   dma_adc_i0_enable,
  input       [15:0]      dma_adc_i0_data,
  input                   dma_adc_i0_valid,
  input                   dma_adc_q0_enable,
  input       [15:0]      dma_adc_q0_data,
  input                   dma_adc_q0_valid,
  input                   dma_adc_i1_enable,
  input       [15:0]      dma_adc_i1_data,
  input                   dma_adc_i1_valid,
  input                   dma_adc_q1_enable,
  input       [15:0]      dma_adc_q1_data,
  input                   dma_adc_q1_valid,

  output                  core_adc_i0_enable,
  output      [15:0]      core_adc_i0_data,
  output                  core_adc_i0_valid,
  output                  core_adc_q0_enable,
  output      [15:0]      core_adc_q0_data,
  output                  core_adc_q0_valid,
  output                  core_adc_i1_enable,
  output      [15:0]      core_adc_i1_data,
  output                  core_adc_i1_valid,
  output                  core_adc_q1_enable,
  output      [15:0]      core_adc_q1_data,
  output                  core_adc_q1_valid);

  // fmcomms2 configuration

  localparam NUM_OF_CHANNELS  = 4;
  localparam ADC_ENABLE       = 1;
  localparam DAC_ENABLE       = 1;

  // default top

  prcfg_top # (
    .NUM_CHANNEL (NUM_OF_CHANNELS),
    .ADC_EN (ADC_ENABLE),
    .DAC_EN (DAC_ENABLE))
  i_prcfg_top  (
    .clk (clk),
    .dac_gpio_input (dac_gpio_input),
    .dac_gpio_output (dac_gpio_output),
    .adc_gpio_input (adc_gpio_input),
    .adc_gpio_output (adc_gpio_output),
    .dma_dac_0_enable (dma_dac_i0_enable),
    .dma_dac_0_data (dma_dac_i0_data),
    .dma_dac_0_valid (dma_dac_i0_valid),
    .dma_dac_1_enable (dma_dac_q0_enable),
    .dma_dac_1_data (dma_dac_q0_data),
    .dma_dac_1_valid (dma_dac_q0_valid),
    .dma_dac_2_enable (dma_dac_i1_enable),
    .dma_dac_2_data (dma_dac_i1_data),
    .dma_dac_2_valid (dma_dac_i1_valid),
    .dma_dac_3_enable (dma_dac_q1_enable),
    .dma_dac_3_data (dma_dac_q1_data),
    .dma_dac_3_valid (dma_dac_q1_valid),
    .core_dac_0_enable (core_dac_i0_enable),
    .core_dac_0_data (core_dac_i0_data),
    .core_dac_0_valid (core_dac_i0_valid),
    .core_dac_1_enable (core_dac_q0_enable),
    .core_dac_1_data (core_dac_q0_data),
    .core_dac_1_valid (core_dac_q0_valid),
    .core_dac_2_enable (core_dac_i1_enable),
    .core_dac_2_data (core_dac_i1_data),
    .core_dac_2_valid (core_dac_i1_valid),
    .core_dac_3_enable (core_dac_q1_enable),
    .core_dac_3_data (core_dac_q1_data),
    .core_dac_3_valid (core_dac_q1_valid),
    .dma_adc_0_enable (dma_adc_i0_enable),
    .dma_adc_0_data (dma_adc_i0_data),
    .dma_adc_0_valid (dma_adc_i0_valid),
    .dma_adc_1_enable (dma_adc_q0_enable),
    .dma_adc_1_data (dma_adc_q0_data),
    .dma_adc_1_valid (dma_adc_q0_valid),
    .dma_adc_2_enable (dma_adc_i1_enable),
    .dma_adc_2_data (dma_adc_i1_data),
    .dma_adc_2_valid (dma_adc_i1_valid),
    .dma_adc_3_enable (dma_adc_q1_enable),
    .dma_adc_3_data (dma_adc_q1_data),
    .dma_adc_3_valid (dma_adc_q1_valid),
    .core_adc_0_enable (core_adc_i0_enable),
    .core_adc_0_data (core_adc_i0_data),
    .core_adc_0_valid (core_adc_i0_valid),
    .core_adc_1_enable (core_adc_q0_enable),
    .core_adc_1_data (core_adc_q0_data),
    .core_adc_1_valid (core_adc_q0_valid),
    .core_adc_2_enable (core_adc_i1_enable),
    .core_adc_2_data (core_adc_i1_data),
    .core_adc_2_valid (core_adc_i1_valid),
    .core_adc_3_enable (core_adc_q1_enable),
    .core_adc_3_data (core_adc_q1_data),
    .core_adc_3_valid (core_adc_q1_valid));

endmodule

// ***************************************************************************
// ***************************************************************************
