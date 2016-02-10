// ***************************************************************************
// ***************************************************************************
// Copyright 2013 (c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES  (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/1ns

module prcfg  (

  clk,

  // gpio

  dac_gpio_input,
  dac_gpio_output,
  adc_gpio_input,
  adc_gpio_output,

  // tx side

  dma_dac_i0_enable,
  dma_dac_i0_data,
  dma_dac_i0_valid,
  dma_dac_q0_enable,
  dma_dac_q0_data,
  dma_dac_q0_valid,
  dma_dac_i1_enable,
  dma_dac_i1_data,
  dma_dac_i1_valid,
  dma_dac_q1_enable,
  dma_dac_q1_data,
  dma_dac_q1_valid,

  core_dac_i0_enable,
  core_dac_i0_data,
  core_dac_i0_valid,
  core_dac_q0_enable,
  core_dac_q0_data,
  core_dac_q0_valid,
  core_dac_i1_enable,
  core_dac_i1_data,
  core_dac_i1_valid,
  core_dac_q1_enable,
  core_dac_q1_data,
  core_dac_q1_valid,

  // rx side

  dma_adc_i0_enable,
  dma_adc_i0_data,
  dma_adc_i0_valid,
  dma_adc_q0_enable,
  dma_adc_q0_data,
  dma_adc_q0_valid,
  dma_adc_i1_enable,
  dma_adc_i1_data,
  dma_adc_i1_valid,
  dma_adc_q1_enable,
  dma_adc_q1_data,
  dma_adc_q1_valid,

  core_adc_i0_enable,
  core_adc_i0_data,
  core_adc_i0_valid,
  core_adc_q0_enable,
  core_adc_q0_data,
  core_adc_q0_valid,
  core_adc_i1_enable,
  core_adc_i1_data,
  core_adc_i1_valid,
  core_adc_q1_enable,
  core_adc_q1_data,
  core_adc_q1_valid);

  input                  clk;

  // gpio

  input   [31:0]         adc_gpio_input;
  output  [31:0]         adc_gpio_output;
  input   [31:0]         dac_gpio_input;
  output  [31:0]         dac_gpio_output;

  // tx side

  input                  dma_dac_i0_enable;
  output  [15:0]         dma_dac_i0_data;
  input                  dma_dac_i0_valid;
  input                  dma_dac_q0_enable;
  output  [15:0]         dma_dac_q0_data;
  input                  dma_dac_q0_valid;
  input                  dma_dac_i1_enable;
  output  [15:0]         dma_dac_i1_data;
  input                  dma_dac_i1_valid;
  input                  dma_dac_q1_enable;
  output  [15:0]         dma_dac_q1_data;
  input                  dma_dac_q1_valid;

  output                 core_dac_i0_enable;
  input   [15:0]         core_dac_i0_data;
  output                 core_dac_i0_valid;
  output                 core_dac_q0_enable;
  input   [15:0]         core_dac_q0_data;
  output                 core_dac_q0_valid;
  output                 core_dac_i1_enable;
  input   [15:0]         core_dac_i1_data;
  output                 core_dac_i1_valid;
  output                 core_dac_q1_enable;
  input   [15:0]         core_dac_q1_data;
  output                 core_dac_q1_valid;

  // rx side

  input                  dma_adc_i0_enable;
  input   [15:0]         dma_adc_i0_data;
  input                  dma_adc_i0_valid;
  input                  dma_adc_q0_enable;
  input   [15:0]         dma_adc_q0_data;
  input                  dma_adc_q0_valid;
  input                  dma_adc_i1_enable;
  input   [15:0]         dma_adc_i1_data;
  input                  dma_adc_i1_valid;
  input                  dma_adc_q1_enable;
  input   [15:0]         dma_adc_q1_data;
  input                  dma_adc_q1_valid;

  output                 core_adc_i0_enable;
  output  [15:0]         core_adc_i0_data;
  output                 core_adc_i0_valid;
  output                 core_adc_q0_enable;
  output  [15:0]         core_adc_q0_data;
  output                 core_adc_q0_valid;
  output                 core_adc_i1_enable;
  output  [15:0]         core_adc_i1_data;
  output                 core_adc_i1_valid;
  output                 core_adc_q1_enable;
  output  [15:0]         core_adc_q1_data;
  output                 core_adc_q1_valid;

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
