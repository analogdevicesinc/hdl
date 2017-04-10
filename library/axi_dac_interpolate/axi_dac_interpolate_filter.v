// ***************************************************************************
// ***************************************************************************
// Copyright 2017(c) Analog Devices, Inc.
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

`timescale 1ns/100ps


module axi_dac_interpolate_filter (
  input                 dac_clk,
  input                 dac_rst,

  input       [15:0]    dac_data,
  input                 dac_valid,

  output  reg [15:0]    dac_int_data,
  output  reg           dac_int_valid,

  input       [ 2:0]    filter_mask,
  input       [31:0]    interpolation_ratio,
  input                 dma_transfer_suspend
);

  // internal signals

  reg               dac_filt_int_valid;
  reg     [15:0]    interp_rate_cic;
  reg     [ 2:0]    filter_mask_d1;
  reg               cic_change_rate;
  reg     [31:0]    interpolation_counter;

  reg               filter_enable = 1'b0;

  wire              dac_fir_valid;
  wire    [35:0]    dac_fir_data;

  wire              dac_cic_valid;
  wire    [109:0]   dac_cic_data;
 
  fir_interp fir_interpolation (
    .clk (dac_clk),
    .clk_enable (dac_cic_valid),
    .reset (dac_rst | dma_transfer_suspend),
    .filter_in (dac_data),
    .filter_out (dac_fir_data),
    .ce_out (dac_fir_valid));

  cic_interp cic_interpolation (
    .clk (dac_clk),
    .clk_enable (dac_valid),
    .reset (dac_rst | cic_change_rate | dma_transfer_suspend),
    .rate (interp_rate_cic),
    .load_rate (1'b0),
    .filter_in (dac_fir_data[30:0]),
    .filter_out (dac_cic_data),
    .ce_out (dac_cic_valid));

  always @(posedge dac_clk) begin
    filter_mask_d1 <= filter_mask;
    if (filter_mask_d1 != filter_mask) begin
      cic_change_rate <= 1'b1;
    end else begin
      cic_change_rate <= 1'b0;
    end
  end

  always @(posedge dac_clk) begin
    if (interpolation_ratio == 0 || interpolation_ratio == 1) begin
      dac_int_valid <= dac_filt_int_valid;
    end else begin
      if (dac_filt_int_valid == 1'b1) begin
        if (interpolation_counter  < interpolation_ratio) begin
          interpolation_counter <= interpolation_counter + 1;
          dac_int_valid <= 1'b0;
        end else begin
          interpolation_counter <= 0;
          dac_int_valid <= 1'b1;
        end
      end else begin
        dac_int_valid <= 1'b0;
      end
    end
  end

  always @(posedge dac_clk) begin
    case (filter_mask)
      3'b000: filter_enable <= 1'b0;
      default: filter_enable <= 1'b1;
    endcase
  end

  always @(*) begin
    case (filter_enable)
      1'b0: dac_int_data = dac_data;
      default: dac_int_data = dac_cic_data[31:16];
    endcase

    case (filter_mask)
      1'b0: dac_filt_int_valid = dac_valid & !dma_transfer_suspend;
      default: dac_filt_int_valid = dac_fir_valid;
    endcase

    case (filter_mask)
      16'h1: interp_rate_cic = 16'd5;
      16'h2: interp_rate_cic = 16'd50;
      16'h3: interp_rate_cic = 16'd500;
      16'h6: interp_rate_cic = 16'd5000;
      16'h7: interp_rate_cic = 16'd50000;
      default: interp_rate_cic = 16'd1;
    endcase

  end

endmodule
