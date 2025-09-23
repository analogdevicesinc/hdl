// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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
// Redistribution and use of source or resulting binaries, with or without modificat
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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad9740_channel #(

  parameter   CHANNEL_ID = 32'h0,
  parameter   DAC_RESOLUTION = 14,
  parameter   DDS_DISABLE = 0,
  parameter   DDS_TYPE = 1,
  parameter   DDS_CORDIC_DW = 14,
  parameter   DDS_CORDIC_PHASE_DW = 14
) (

  // dac interface

  input                   dac_clk,
  input                   dac_rst,
  output reg   [13:0]     dac_data,
  output       [ 3:0]     dac_data_sel,

  // input sources

  input        [15:0]     dma_data,
  input                   dma_valid,
  output reg              dma_ready,

  // processor interface

  input                   dac_data_sync,
  input                   dac_dfmt_type,

  // bus interface

  input                   up_rstn,
  input                   up_clk,
  input                   up_wreq,
  input        [13:0]     up_waddr,
  input        [31:0]     up_wdata,
  output                  up_wack,
  input                   up_rreq,
  input        [13:0]     up_raddr,
  output       [31:0]     up_rdata,
  output                  up_rack
);

  // internal signals

  wire    [ 3:0]   dac_data_sel_s;
  wire    [DAC_RESOLUTION-1:0]   dac_dds_data_s;
  wire    [15:0]   dac_dds_scale_1_s;
  wire    [15:0]   dac_dds_init_1_s;
  wire    [15:0]   dac_dds_incr_1_s;
  wire    [15:0]   dac_dds_scale_2_s;
  wire    [15:0]   dac_dds_init_2_s;
  wire    [15:0]   dac_dds_incr_2_s;
  wire    [15:0]   dac_pat_data_1_s;
  wire    [15:0]   dac_pat_data_2_s;

  reg     [15:0]   dma_pattern;
  reg     [DAC_RESOLUTION-1:0]   ramp_pattern;

  always @(posedge dac_clk) begin
    dma_ready <= (dac_data_sel_s == 4'h2) ? 1'b1 : 1'b0;

    case(dac_data_sel_s)
      4'h0 :
      begin
        if (DAC_RESOLUTION == 14) begin
          dac_data = dac_dds_data_s;
        end else begin
          // Scale up to 14 bits for output interface - MSB aligned
          dac_data = {dac_dds_data_s, {(14-DAC_RESOLUTION){1'b0}}};
        end
      end
      4'h2 :
      begin
        // DMA data - truncate or pad as needed
        if (DAC_RESOLUTION >= 14) begin
          dac_data = dma_pattern[13:0];
        end else begin
          // Take MSBs from DMA and scale up to 14 bits - MSB aligned
          // For 10-bit: takes DMA[15:6] and puts in Internal[13:4]
          // For 12-bit: takes DMA[15:4] and puts in Internal[13:2]
          // For 8-bit:  takes DMA[15:8] and puts in Internal[13:6]
          dac_data = {dma_pattern[15:16-DAC_RESOLUTION], {(14-DAC_RESOLUTION){1'b0}}};
        end
      end
      4'h3 :
      begin
        dac_data       = 'b0;
      end
      4'hb :
      begin
        // Ramp data - scale up to 14 bits - MSB aligned
        if (DAC_RESOLUTION == 14) begin
          dac_data = ramp_pattern;
        end else begin
          // Ramp pattern is DAC_RESOLUTION bits, put in upper bits of 14-bit bus
          dac_data = {ramp_pattern, {(14-DAC_RESOLUTION){1'b0}}};
        end
      end
      default :
      begin
        dac_data       = 'b0;
      end
    endcase
  end

  // dma data

  always @(posedge dac_clk) begin
    if (dma_valid == 1'b0 || dac_rst == 1'b1) begin
      dma_pattern <= 'h0;
    end else begin
      dma_pattern <= dma_data;
    end
  end

  // ramp data generator

  always @(posedge dac_clk) begin
    if(ramp_pattern == {DAC_RESOLUTION{1'b1}} || dac_rst == 1'b1) begin
        ramp_pattern <= {DAC_RESOLUTION{1'b0}};
    end else begin
      ramp_pattern <= ramp_pattern + 1'b1;
    end
  end

  // DDS generator

  ad_dds #(
    .DISABLE (DDS_DISABLE),
    .DDS_DW (DAC_RESOLUTION),
    .PHASE_DW (16),
    .DDS_TYPE (DDS_TYPE),
    .CORDIC_DW (DDS_CORDIC_DW),
    .CORDIC_PHASE_DW (DDS_CORDIC_PHASE_DW),
    .CLK_RATIO (1)
  ) i_dds (
    .clk (dac_clk),
    .dac_dds_format (1'b0),  // DDS outputs signed (CORDIC native), conversion handled by axi_ad9740_if
    .dac_data_sync (dac_data_sync),
    .dac_valid (~|dac_data_sel_s),
    .tone_1_scale (dac_dds_scale_1_s),
    .tone_2_scale (dac_dds_scale_2_s),
    .tone_1_init_offset (dac_dds_init_1_s),
    .tone_2_init_offset (dac_dds_init_2_s),
    .tone_1_freq_word (dac_dds_incr_1_s),
    .tone_2_freq_word (dac_dds_incr_2_s),
    .dac_dds_data (dac_dds_data_s));

  // single channel processor

  up_dac_channel #(
    .CHANNEL_ID(CHANNEL_ID),
    .COMMON_ID(6'h01)
  ) dac_channel (
    .dac_clk(dac_clk),
    .dac_rst(dac_rst),
    .dac_dds_scale_1(dac_dds_scale_1_s),
    .dac_dds_init_1(dac_dds_init_1_s),
    .dac_dds_incr_1(dac_dds_incr_1_s),
    .dac_dds_scale_2(dac_dds_scale_2_s),
    .dac_dds_init_2(dac_dds_init_2_s),
    .dac_dds_incr_2(dac_dds_incr_2_s),
    .dac_pat_data_1(dac_pat_data_1_s),
    .dac_pat_data_2(dac_pat_data_2_s),
    .dac_data_sel(dac_data_sel_s),
    .dac_mask_enable(),
    .dac_iq_mode(),
    .dac_iqcor_enb(),
    .dac_iqcor_coeff_1(),
    .dac_iqcor_coeff_2(),
    .dac_src_chan_sel(),
    .up_usr_datatype_be(),
    .up_usr_datatype_signed(),
    .up_usr_datatype_shift(),
    .up_usr_datatype_total_bits(),
    .up_usr_datatype_bits(),
    .up_usr_interpolation_m(),
    .up_usr_interpolation_n(),
    .dac_usr_datatype_be(1'd0),
    .dac_usr_datatype_signed(1'd1),
    .dac_usr_datatype_shift(8'd0),
    .dac_usr_datatype_total_bits(8'd16),
    .dac_usr_datatype_bits(8'd16),
    .dac_usr_interpolation_m(16'd1),
    .dac_usr_interpolation_n(16'd1),
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_wreq(up_wreq),
    .up_waddr(up_waddr),
    .up_wdata(up_wdata),
    .up_wack(up_wack),
    .up_rreq(up_rreq),
    .up_raddr(up_raddr),
    .up_rdata(up_rdata),
    .up_rack(up_rack));
endmodule
