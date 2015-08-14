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

  dma_dac_en,
  dma_dac_dvalid,
  dma_dac_ddata,
  dma_dac_dunf,

  core_dac_en,
  core_dac_dvalid,
  core_dac_ddata,
  core_dac_dunf,

  // rx side

  core_adc_dwr,
  core_adc_dsync,
  core_adc_ddata,
  core_adc_ovf,

  dma_adc_dwr,
  dma_adc_dsync,
  dma_adc_ddata,
  dma_adc_ovf);

  input                             clk;

  // gpio

  input   [31:0]                    adc_gpio_input;
  output  [31:0]                    adc_gpio_output;
  input   [31:0]                    dac_gpio_input;
  output  [31:0]                    dac_gpio_output;

  // tx side

  output                            dma_dac_en;
  input                             dma_dac_dvalid;
  input   [63:0]                    dma_dac_ddata;
  input                             dma_dac_dunf;

  input                             core_dac_en;
  output                            core_dac_dvalid;
  output  [63:0]                    core_dac_ddata;
  output                            core_dac_dunf;

  // rx side

  input                             core_adc_dwr;
  input                             core_adc_dsync;
  input   [63:0]                    core_adc_ddata;
  output                            core_adc_ovf;

  output                            dma_adc_dwr;
  output                            dma_adc_dsync;
  output  [63:0]                    dma_adc_ddata;
  input                             dma_adc_ovf;

  // fmcomms2 configuration

  localparam NUM_OF_CHANNELS  = 2;
  localparam ADC_ENABLE       = 1;
  localparam DAC_ENABLE       = 1;

  // default top

  prcfg_top # (
    .NUM_CHANNEL (NUM_OF_CHANNELS),
    .ADC_EN (ADC_ENABLE),
    .DAC_EN (DAC_ENABLE))
  i_prcfg_top  (
    .clk (clk),
    .adc_gpio_input (adc_gpio_input),
    .adc_gpio_output (adc_gpio_output),
    .dac_gpio_input (dac_gpio_input),
    .dac_gpio_output (dac_gpio_output),
    .dma_dac_en (dma_dac_en),
    .dma_dac_dunf (dma_dac_dunf),
    .dma_dac_ddata (dma_dac_ddata),
    .dma_dac_dvalid (dma_dac_dvalid),
    .core_dac_en (core_dac_en),
    .core_dac_dunf (core_dac_dunf),
    .core_dac_ddata (core_dac_ddata),
    .core_dac_dvalid (core_dac_dvalid),
    .core_adc_dwr (core_adc_dwr),
    .core_adc_dsync (core_adc_dsync),
    .core_adc_ddata (core_adc_ddata),
    .core_adc_ovf (core_adc_ovf),
    .dma_adc_dwr (dma_adc_dwr),
    .dma_adc_dsync (dma_adc_dsync),
    .dma_adc_ddata (dma_adc_ddata),
    .dma_adc_ovf (dma_adc_ovf));

endmodule

// ***************************************************************************
// ***************************************************************************
