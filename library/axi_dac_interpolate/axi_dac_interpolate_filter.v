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


module axi_dac_interpolate_filter #(

  parameter CORRECTION_DISABLE = 1) (

  input                 dac_clk,
  input                 dac_rst,

  input       [15:0]    dac_data,
  input                 dac_valid,

  input                 dac_enable,
  output  reg [15:0]    dac_int_data,
  output                dma_ready,
  output                underflow,

  input       [ 2:0]    filter_mask,
  input       [31:0]    interpolation_ratio,
  input       [15:0]    dac_correction_coefficient,
  input                 dac_correction_enable,
  input                 dma_transfer_suspend,
  input                 start_sync_channels,
  input                 trigger,
  input                 trigger_active,
  input                 dma_valid,
  input                 dma_valid_adjacent
);

  // internal signals

  reg               dac_int_ready;
  reg               dac_filt_int_valid;
  reg     [15:0]    interp_rate_cic;
  reg     [ 2:0]    filter_mask_d1;
  reg               cic_change_rate;
  reg     [31:0]    interpolation_counter;

  reg               transmit_ready = 1'b0;
  reg               dma_data_valid = 1'b0;
  reg               dma_data_valid_adjacent = 1'b0;

  reg               filter_enable = 1'b0;
  reg               transfer = 1'b0;

  wire              dac_valid_corrected;
  wire    [15:0]    dac_data_corrected;
  wire              dac_fir_valid;
  wire    [35:0]    dac_fir_data;

  wire              dac_cic_valid;
  wire    [109:0]   dac_cic_data;

  ad_iqcor #(.Q_OR_I_N (0),
    .DISABLE(CORRECTION_DISABLE),
    .SCALE_ONLY(1))
  i_ad_iqcor (
    .clk (dac_clk),
    .valid (dac_valid),
    .data_in (dac_data),
    .data_iq (16'h0),
    .valid_out (dac_valid_corrected),
    .data_out (dac_data_corrected),
    .iqcor_enable (dac_correction_enable),
    .iqcor_coeff_1 (dac_correction_coefficient),
    .iqcor_coeff_2 (16'h0));

  fir_interp fir_interpolation (
    .clk (dac_clk),
    .clk_enable (dac_cic_valid),
    .reset (dac_rst | dma_transfer_suspend),
    .filter_in (dac_data_corrected),
    .filter_out (dac_fir_data),
    .ce_out (dac_fir_valid));

  cic_interp cic_interpolation (
    .clk (dac_clk),
    .clk_enable (dac_valid_corrected),
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

  // - for start synchronized, wait until the DMA has valid data on both channels
  // - for non synchronized channels the start of transmission gets the 2 data
  // paths randomly ready, only when using data buffers

  always @(posedge dac_clk) begin
    if (interpolation_ratio == 0 || interpolation_ratio == 1) begin
      dac_int_ready <= dac_filt_int_valid;
    end else begin
      if (dac_filt_int_valid &
          (!start_sync_channels & dma_valid |
          (dma_valid & dma_valid_adjacent))) begin
        if (interpolation_counter < interpolation_ratio) begin
          interpolation_counter <= interpolation_counter + 1;
          dac_int_ready <= 1'b0;
        end else begin
          interpolation_counter <= 0;
          dac_int_ready <= 1'b1;
        end
      end else begin
        dac_int_ready <= 1'b0;
        interpolation_counter <= 0;
      end
    end
  end

  always @(posedge dac_clk) begin
    if (dma_transfer_suspend == 1'b0) begin
      transfer <= trigger ? 1'b1 : transfer | !trigger_active;
    end else begin
      transfer <= 1'b0;
    end
    if (start_sync_channels == 1'b0) begin
      transmit_ready <= dma_valid & transfer;
    end else begin
      transmit_ready <= dma_valid & dma_valid_adjacent & transfer;
    end
  end

  assign dma_ready = transmit_ready ? dac_int_ready : 1'b0;
  assign underflow = dac_enable & dma_ready & ~dma_valid;

  always @(posedge dac_clk) begin
    case (filter_mask)
      3'b000: filter_enable <= 1'b0;
      default: filter_enable <= 1'b1;
    endcase
  end

  always @(*) begin
    case (filter_enable)
      1'b0: dac_int_data = dac_data_corrected;
      default: dac_int_data = dac_cic_data[31:16];
    endcase

    case (filter_mask)
      1'b0: dac_filt_int_valid = dac_valid_corrected & !dma_transfer_suspend;
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
