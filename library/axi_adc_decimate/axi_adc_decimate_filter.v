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


module axi_adc_decimate_filter (
  input                 adc_clk,
  input                 adc_rst,

  input       [31:0]    decimation_ratio,
  input       [ 2:0]    filter_mask,

  input                 adc_valid_a,
  input                 adc_valid_b,
  input       [11:0]    adc_data_a,
  input       [11:0]    adc_data_b,

  output reg  [15:0]    adc_dec_data_a,
  output reg  [15:0]    adc_dec_data_b,
  output reg            adc_dec_valid_a,
  output reg            adc_dec_valid_b
);

  // internal signals

  reg     [31:0]    decimation_counter;

  reg               adc_dec_valid_a_filter;
  reg               adc_dec_valid_b_filter;

  reg     [4:0]     filter_enable = 5'h00;

  wire    [25:0]    adc_fir_data_a;
  wire              adc_fir_valid_a;
  wire    [25:0]    adc_fir_data_b;
  wire              adc_fir_valid_b;

  wire    [11:0]    adc_cic_data_a;
  wire              adc_cic_valid_a;
  wire    [11:0]    adc_cic_data_b;
  wire              adc_cic_valid_b;

  cic_decim cic_decimation_a (
    .clk(adc_clk),
    .clk_enable(adc_valid_a),
    .filter_enable(filter_enable),
    .reset(adc_rst),
    .filter_in(adc_data_a[11:0]),
    .rate_sel(filter_mask),
    .filter_out(adc_cic_data_a),
    .ce_out(adc_cic_valid_a));

  cic_decim cic_decimation_b (
    .clk(adc_clk),
    .clk_enable(adc_valid_b),
    .filter_enable(filter_enable),
    .reset(adc_rst),
    .filter_in(adc_data_b[11:0]),
    .rate_sel(filter_mask),
    .filter_out(adc_cic_data_b),
    .ce_out(adc_cic_valid_b));

  fir_decim fir_decimation_a (
    .clk(adc_clk),
    .clk_enable(adc_cic_valid_a),
    .reset(adc_rst),
    .filter_in(adc_cic_data_a),
    .filter_out(adc_fir_data_a),
    .ce_out(adc_fir_valid_a));

  fir_decim fir_decimation_b (
    .clk(adc_clk),
    .clk_enable(adc_cic_valid_b),
    .reset(adc_rst),
    .filter_in(adc_cic_data_b),
    .filter_out(adc_fir_data_b),
    .ce_out(adc_fir_valid_b));

  always @(posedge adc_clk) begin
    case (filter_mask)
      3'h1: filter_enable <= 5'b00001;
      3'h2: filter_enable <= 5'b00011;
      3'h3: filter_enable <= 5'b00111;
      3'h6: filter_enable <= 5'b01111;
      3'h7: filter_enable <= 5'b11111;
      default: filter_enable <= 5'b00000;
    endcase
  end

  always @(*) begin
    case (filter_enable[0])
      1'b0: adc_dec_data_a = {{4{adc_data_a[11]}},adc_data_a};
      default: adc_dec_data_a = {adc_fir_data_a[25], adc_fir_data_a[25:11]};
    endcase

    case (filter_enable[0])
      1'b0: adc_dec_valid_a_filter = adc_valid_a;
      default: adc_dec_valid_a_filter = adc_fir_valid_a;
    endcase

     case (filter_enable[0])
      1'b0: adc_dec_data_b = {{4{adc_data_b[11]}},adc_data_b};
      default adc_dec_data_b = {adc_fir_data_b[25], adc_fir_data_b[25:11]};
    endcase

    case (filter_enable[0])
      1'b0: adc_dec_valid_b_filter = adc_valid_b;
      default: adc_dec_valid_b_filter = adc_fir_valid_b;
    endcase
  end

  always @(posedge adc_clk) begin
    if (adc_rst == 1'b1) begin
      decimation_counter <= 32'b0;
      adc_dec_valid_a <= 1'b0;
      adc_dec_valid_b <= 1'b0;
    end else begin
      if (adc_dec_valid_a_filter == 1'b1) begin
        if (decimation_counter < decimation_ratio) begin
          decimation_counter <= decimation_counter + 1;
          adc_dec_valid_a <= 1'b0;
          adc_dec_valid_b <= 1'b0;
        end else begin
          decimation_counter <= 0;
          adc_dec_valid_a <= 1'b1;
          adc_dec_valid_b <= 1'b1;
        end
      end else begin
          adc_dec_valid_a <= 1'b0;
          adc_dec_valid_b <= 1'b0;
      end
    end
  end


endmodule
