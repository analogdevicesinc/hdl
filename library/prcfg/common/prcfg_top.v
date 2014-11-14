
// ***************************************************************************
// ***************************************************************************
// Copyright 2013(c) Analog Devices, Inc.
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
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/1ns

module prcfg_top(

  clk,

  // gpio
  dac_gpio_input,
  dac_gpio_output,
  adc_gpio_input,
  adc_gpio_output,

  // TX side
  dma_dac_en,
  dma_dac_dunf,
  dma_dac_ddata,
  dma_dac_dvalid,

  core_dac_en,
  core_dac_dunf,
  core_dac_ddata,
  core_dac_dvalid,

  // RX side
  core_adc_dwr,
  core_adc_dsync,
  core_adc_ddata,
  core_adc_ovf,

  dma_adc_dwr,
  dma_adc_dsync,
  dma_adc_ddata,
  dma_adc_ovf
);

  localparam  ENABELED    = 1;
  localparam  DATA_WIDTH  = 32;

  parameter   NUM_CHANNEL = 2;
  parameter   ADC_EN      = 1;
  parameter   DAC_EN      = 1;

  localparam  DBUS_WIDTH  = DATA_WIDTH * NUM_CHANNEL;

  input                             clk;

  input   [31:0]                    dac_gpio_input;
  output  [31:0]                    dac_gpio_output;
  input   [31:0]                    adc_gpio_input;
  output  [31:0]                    adc_gpio_output;

  output                            dma_dac_en;
  input                             dma_dac_dunf;
  input   [(DBUS_WIDTH - 1):0]      dma_dac_ddata;
  input                             dma_dac_dvalid;

  input                             core_dac_en;
  output                            core_dac_dunf;
  output  [(DBUS_WIDTH - 1):0]      core_dac_ddata;
  output                            core_dac_dvalid;

  input                             core_adc_dwr;
  input                             core_adc_dsync;
  input   [(DBUS_WIDTH - 1):0]      core_adc_ddata;
  output                            core_adc_ovf;

  output                            dma_adc_dwr;
  output                            dma_adc_dsync;
  output  [(DBUS_WIDTH - 1):0]      dma_adc_ddata;
  input                             dma_adc_ovf;

  wire    [31:0]                    adc_gpio_out_s[(NUM_CHANNEL - 1):0];
  wire    [(NUM_CHANNEL - 1):0]     adc_gpio_out_s_inv[31:0];

  wire    [31:0]                    dac_gpio_out_s[(NUM_CHANNEL - 1):0];
  wire    [(NUM_CHANNEL - 1):0]     dac_gpio_out_s_inv[31:0];

  genvar l_inst;

  generate
    for(l_inst = 0; l_inst < NUM_CHANNEL; l_inst = l_inst + 1) begin: tx_rx_data_path
      if(ADC_EN == ENABELED) begin
        if(l_inst == 0) begin
          prcfg_adc #(
            .CHANNEL_ID(l_inst)
          ) i_prcfg_adc_1 (
            .clk(clk),
            .control(adc_gpio_input),
            .status(adc_gpio_out_s[l_inst]),
            .src_adc_dwr(core_adc_dwr),
            .src_adc_dsync(core_adc_dsync),
            .src_adc_ddata(core_adc_ddata[(DATA_WIDTH - 1):0]),
            .src_adc_dovf(core_adc_ovf),
            .dst_adc_dwr(dma_adc_dwr),
            .dst_adc_dsync(dma_adc_dsync),
            .dst_adc_ddata(dma_adc_ddata[(DATA_WIDTH - 1):0]),
            .dst_adc_dovf(dma_adc_ovf)
          );
        end else begin
           prcfg_adc #(
            .CHANNEL_ID(l_inst)
          ) i_prcfg_adc_i (
            .clk(clk),
            .control(adc_gpio_input),
            .status(adc_gpio_out_s[l_inst]),
            .src_adc_dwr(core_adc_dwr),
            .src_adc_dsync(core_adc_dsync),
            .src_adc_ddata(core_adc_ddata[((DATA_WIDTH * (l_inst + 1)) - 1):(DATA_WIDTH * l_inst)]),
            .src_adc_dovf(),
            .dst_adc_dwr(),
            .dst_adc_dsync(),
            .dst_adc_ddata(dma_adc_ddata[((DATA_WIDTH * (l_inst + 1)) - 1):(DATA_WIDTH * l_inst)]),
            .dst_adc_dovf(dma_adc_ovf)
          );
        end
      end
      if(DAC_EN == ENABELED) begin
        if(l_inst == 0) begin
          prcfg_dac #(
            .CHANNEL_ID(l_inst)
          ) i_prcfg_dac_1 (
            .clk(clk),
            .control(dac_gpio_input),
            .status(dac_gpio_out_s[l_inst]),
            .src_dac_en(dma_dac_en),
            .src_dac_ddata(dma_dac_ddata[(DATA_WIDTH - 1):0]),
            .src_dac_dunf(dma_dac_dunf),
            .src_dac_dvalid(dma_dac_dvalid),
            .dst_dac_en(core_dac_en),
            .dst_dac_ddata(core_dac_ddata[(DATA_WIDTH - 1):0]),
            .dst_dac_dunf(core_dac_dunf),
            .dst_dac_dvalid(core_dac_dvalid)
          );
        end else begin
          prcfg_dac #(
            .CHANNEL_ID(l_inst)
          ) i_prcfg_dac_i (
            .clk(clk),
            .control(dac_gpio_input),
            .status(dac_gpio_out_s[l_inst]),
            .src_dac_en(),
            .src_dac_ddata(dma_dac_ddata[((DATA_WIDTH * (l_inst + 1)) - 1):(DATA_WIDTH * l_inst)]),
            .src_dac_dunf(dma_dac_dunf),
            .src_dac_dvalid(dma_dac_dvalid),
            .dst_dac_en(core_dac_en),
            .dst_dac_ddata(core_dac_ddata[((DATA_WIDTH * (l_inst + 1)) - 1):(DATA_WIDTH * l_inst)]),
            .dst_dac_dunf(),
            .dst_dac_dvalid()
          );
        end
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

endmodule
