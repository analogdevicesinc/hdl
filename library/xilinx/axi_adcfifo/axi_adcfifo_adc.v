// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
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

`timescale 1ns/100ps

module axi_adcfifo_adc (

  // fifo interface

  adc_rst,
  adc_clk,
  adc_wr,
  adc_wdata,
  adc_wovf,
  adc_dwr,
  adc_ddata,

  // axi interface

  axi_drst,
  axi_clk,
  axi_xfer_status);

  // parameters

  parameter   ADC_DATA_WIDTH = 128;
  parameter   AXI_DATA_WIDTH = 512;
  localparam  ADC_MEM_RATIO = AXI_DATA_WIDTH/ADC_DATA_WIDTH;

  // adc interface

  input                           adc_rst;
  input                           adc_clk;
  input                           adc_wr;
  input   [ADC_DATA_WIDTH-1:0]    adc_wdata;
  output                          adc_wovf;
  output                          adc_dwr;
  output  [AXI_DATA_WIDTH-1:0]    adc_ddata;

  // axi interface

  input                           axi_clk;
  input                           axi_drst;
  input   [  3:0]                 axi_xfer_status;

  // internal registers

  reg                             adc_wovf      = 'd0;
  reg     [  2:0]                 adc_wcnt_int  = 'd0;
  reg                             adc_dwr       = 'd0;
  reg     [AXI_DATA_WIDTH-1:0]    adc_ddata     = 'd0;

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
