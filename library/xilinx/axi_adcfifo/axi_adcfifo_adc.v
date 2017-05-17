// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// Each core or library found in this collection may have its own licensing terms. 
// The user should keep this in in mind while exploring these cores. 
//
// Redistribution and use in source and binary forms,
// with or without modification of this file, are permitted under the terms of either
//  (at the option of the user):
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory, or at:
// https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
//
// OR
//
//   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
// https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_adcfifo_adc #(

  parameter   ADC_DATA_WIDTH = 128,
  parameter   AXI_DATA_WIDTH = 512) (

  // fifo interface

  input                   adc_rst,
  input                   adc_clk,
  input                   adc_wr,
  input       [ADC_DATA_WIDTH-1:0]  adc_wdata,
  output  reg             adc_wovf,
  output  reg             adc_dwr,
  output  reg [AXI_DATA_WIDTH-1:0]  adc_ddata,

  // axi interface

  input                   axi_drst,
  input                   axi_clk,
  input       [ 3:0]      axi_xfer_status);

  localparam  ADC_MEM_RATIO = AXI_DATA_WIDTH/ADC_DATA_WIDTH;

  // internal registers

  reg     [  2:0]                 adc_wcnt_int  = 'd0;

  // internal signals

  wire    [  3:0]                 adc_xfer_status_s;

  // write interface: supports only 64, 128, 256 and 512 against 512

  always @(posedge adc_clk) begin
    if (adc_rst == 1'b1) begin
      adc_wovf <= 'd0;
      adc_wcnt_int <= 'd0;
      adc_dwr <= 'd0;
      adc_ddata <= 'd0;
    end else begin
      adc_wovf <= | adc_xfer_status_s;
      adc_dwr <= (ADC_MEM_RATIO == 8) ? adc_wr & adc_wcnt_int[0] & adc_wcnt_int[1] & adc_wcnt_int[2] :
                 (ADC_MEM_RATIO == 4) ? adc_wr & adc_wcnt_int[0] & adc_wcnt_int[1] :
                 (ADC_MEM_RATIO == 2) ? adc_wr & adc_wcnt_int[0] :
                 (ADC_MEM_RATIO == 1) ? adc_wr : 'd0;
      if (adc_wr == 1'b1) begin
        adc_wcnt_int <= adc_wcnt_int + 1'b1;
        case (ADC_MEM_RATIO)
          8: begin
            adc_ddata[((ADC_DATA_WIDTH*8)-1):(ADC_DATA_WIDTH*7)] <= adc_wdata;
            adc_ddata[((ADC_DATA_WIDTH*7)-1):(ADC_DATA_WIDTH*0)] <=
              adc_ddata[((ADC_DATA_WIDTH*8)-1):(ADC_DATA_WIDTH*1)];
          end
          4: begin
            adc_ddata[((ADC_DATA_WIDTH*4)-1):(ADC_DATA_WIDTH*3)] <= adc_wdata;
            adc_ddata[((ADC_DATA_WIDTH*3)-1):(ADC_DATA_WIDTH*0)] <=
              adc_ddata[((ADC_DATA_WIDTH*4)-1):(ADC_DATA_WIDTH*1)];
          end
          2: begin
            adc_ddata[((ADC_DATA_WIDTH*2)-1):(ADC_DATA_WIDTH*1)] <= adc_wdata;
            adc_ddata[((ADC_DATA_WIDTH*1)-1):(ADC_DATA_WIDTH*0)] <=
              adc_ddata[((ADC_DATA_WIDTH*2)-1):(ADC_DATA_WIDTH*1)];
          end
          1: begin
            adc_ddata <= adc_wdata;
          end
          default: begin
            adc_ddata <= 'd0;
          end
        endcase
      end
    end
  end

  // instantiations

  up_xfer_status #(.DATA_WIDTH(4)) i_xfer_status (
    .up_rstn (~adc_rst),
    .up_clk (adc_clk),
    .up_data_status (adc_xfer_status_s),
    .d_rst (axi_drst),
    .d_clk (axi_clk),
    .d_data_status (axi_xfer_status));

endmodule

// ***************************************************************************
// ***************************************************************************
