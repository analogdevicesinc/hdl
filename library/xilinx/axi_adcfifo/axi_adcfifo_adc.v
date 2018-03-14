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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
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
