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


module axi_adc_decimate_filter #(

  parameter CORRECTION_DISABLE = 1) (

  input                 adc_clk,
  input                 adc_rst,

  input       [31:0]    decimation_ratio,
  input       [ 2:0]    filter_mask,

  input                 adc_correction_enable_a,
  input                 adc_correction_enable_b,
  input       [15:0]    adc_correction_coefficient_a,
  input       [15:0]    adc_correction_coefficient_b,

  input                 adc_valid_a,
  input                 adc_valid_b,
  input       [11:0]    adc_data_a,
  input       [11:0]    adc_data_b,

  output      [15:0]    adc_dec_data_a,
  output      [15:0]    adc_dec_data_b,
  output                adc_dec_valid_a,
  output                adc_dec_valid_b
);

  // internal signals

  reg     [31:0]    decimation_counter;

  reg               adc_dec_valid_a_filter;
  reg               adc_dec_valid_b_filter;

  reg     [4:0]     filter_enable = 5'h00;

  reg     [15:0]    adc_dec_data_a_r;
  reg     [15:0]    adc_dec_data_b_r;
  reg               adc_dec_valid_a_r;
  reg               adc_dec_valid_b_r;

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

  ad_iqcor #(.Q_OR_I_N (0),
    .DISABLE(CORRECTION_DISABLE),
    .SCALE_ONLY(1)
  ) i_scale_correction_a (
    .clk (adc_clk),
    .valid (adc_dec_valid_a_r),
    .data_in (adc_dec_data_a_r),
    .data_iq (16'h0),
    .valid_out (adc_dec_valid_a),
    .data_out (adc_dec_data_a),
    .iqcor_enable (adc_correction_enable_a),
    .iqcor_coeff_1 (adc_correction_coefficient_a),
    .iqcor_coeff_2 (16'h0));

  ad_iqcor #(.Q_OR_I_N (0),
    .DISABLE(CORRECTION_DISABLE),
    .SCALE_ONLY(1)
  ) i_scale_correction_b (
    .clk (adc_clk),
    .valid (adc_dec_valid_b_r),
    .data_in (adc_dec_data_b_r),
    .data_iq (16'h0),
    .valid_out (adc_dec_valid_b),
    .data_out (adc_dec_data_b),
    .iqcor_enable (adc_correction_enable_b),
    .iqcor_coeff_1 (adc_correction_coefficient_b),
    .iqcor_coeff_2 (16'h0));

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
      1'b0: adc_dec_data_a_r = {{4{adc_data_a[11]}},adc_data_a};
      default: adc_dec_data_a_r = {adc_fir_data_a[25], adc_fir_data_a[25:11]};
    endcase

    case (filter_enable[0])
      1'b0: adc_dec_valid_a_filter = adc_valid_a;
      default: adc_dec_valid_a_filter = adc_fir_valid_a;
    endcase

     case (filter_enable[0])
      1'b0: adc_dec_data_b_r = {{4{adc_data_b[11]}},adc_data_b};
      default adc_dec_data_b_r = {adc_fir_data_b[25], adc_fir_data_b[25:11]};
    endcase

    case (filter_enable[0])
      1'b0: adc_dec_valid_b_filter = adc_valid_b;
      default: adc_dec_valid_b_filter = adc_fir_valid_b;
    endcase
  end

  always @(posedge adc_clk) begin
    if (adc_rst == 1'b1) begin
      decimation_counter <= 32'b0;
      adc_dec_valid_a_r <= 1'b0;
      adc_dec_valid_b_r <= 1'b0;
    end else begin
      if (adc_dec_valid_a_filter == 1'b1) begin
        if (decimation_counter < decimation_ratio) begin
          decimation_counter <= decimation_counter + 1;
          adc_dec_valid_a_r <= 1'b0;
          adc_dec_valid_b_r <= 1'b0;
        end else begin
          decimation_counter <= 0;
          adc_dec_valid_a_r <= 1'b1;
          adc_dec_valid_b_r <= 1'b1;
        end
      end else begin
          adc_dec_valid_a_r <= 1'b0;
          adc_dec_valid_b_r <= 1'b0;
      end
    end
  end

endmodule
