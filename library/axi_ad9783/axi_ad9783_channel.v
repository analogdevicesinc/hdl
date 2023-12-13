// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad9783_channel #(

  parameter CHANNEL_ID = 32'h0,
  parameter DAC_DDS_TYPE = 1,
  parameter DAC_DDS_CORDIC_DW = 16,
  parameter DAC_DDS_CORDIC_PHASE_DW = 16,
  parameter DATAPATH_DISABLE = 0
) (

  // dac interface

  input                   dac_div_clk,
  input                   dac_rst,
  output reg              dac_enable,
  output reg   [15:0]     dac_data0,
  output reg   [15:0]     dac_data1,
  output reg   [15:0]     dac_data2,
  output reg   [15:0]     dac_data3,
  input        [63:0]     dma_data,

  // processor interface

  input                   dac_data_sync,
  input                   dac_dds_format,

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

  wire    [63:0]   dac_dds_data_s;
  wire    [15:0]   dac_dds_scale_1_s;
  wire    [15:0]   dac_dds_init_1_s;
  wire    [15:0]   dac_dds_incr_1_s;
  wire    [15:0]   dac_dds_scale_2_s;
  wire    [15:0]   dac_dds_init_2_s;
  wire    [15:0]   dac_dds_incr_2_s;
  wire    [15:0]   dac_pat_data_1_s;
  wire    [15:0]   dac_pat_data_2_s;
  wire    [ 3:0]   dac_data_sel_s;

  reg     [23:0]   dac_prbs_data = 'd0;
  reg     [15:0]   dac_prbs_counter = 'd0;

  // pn23 function
  function [23:0] pn23;
    input [23:0] din;
    reg   [23:0] dout;
    begin
      dout = {din[22:0], din[22] ^ din[17]};
      pn23 = dout;
    end
  endfunction

  // dac data select

  always @(posedge dac_div_clk) begin
    dac_enable <= (dac_data_sel_s == 4'h2) ? 1'b1 : 1'b0;
    case (dac_data_sel_s)
      4'h2: begin
        dac_data0 <= dma_data[15: 0];
        dac_data1 <= dma_data[31:16];
        dac_data2 <= dma_data[47:32];
        dac_data3 <= dma_data[63:48];
      end
      4'h3: begin
        dac_data0 <= 16'h0;
        dac_data1 <= 16'h0;
        dac_data2 <= 16'h0;
        dac_data3 <= 16'h0;
      end
      4'h9: begin
        dac_data0 <= dac_prbs_data[15:0];
        dac_data1 <= dac_prbs_data[23:8];
        dac_data2 <= dac_prbs_data[15:0];
        dac_data3 <= dac_prbs_data[23:8];
      end
      default: begin
        dac_data0 <= dac_dds_data_s[15: 0];
        dac_data1 <= dac_dds_data_s[31:16];
        dac_data2 <= dac_dds_data_s[47:32];
        dac_data3 <= dac_dds_data_s[63:48];
      end
    endcase
  end

  always @(posedge dac_div_clk) begin
    if(dac_data_sel_s != 9) begin
      dac_prbs_data <= 24'hffffff;
      dac_prbs_counter <= 16'h0;
    end else begin
      if (dac_prbs_counter == 4096) begin
        dac_prbs_data <= 24'h0;
      end else begin
        dac_prbs_data <= pn23(dac_prbs_data);
        dac_prbs_counter <= dac_prbs_counter + 1;
      end
    end
  end

  // dds

  ad_dds #(
    .DISABLE (DATAPATH_DISABLE),
    .DDS_DW (16),
    .PHASE_DW (16),
    .DDS_TYPE (DAC_DDS_TYPE),
    .CORDIC_DW (DAC_DDS_CORDIC_DW),
    .CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW),
    .CLK_RATIO (4)
  ) i_dds (
    .clk (dac_div_clk),
    .dac_dds_format (dac_dds_format),
    .dac_data_sync (dac_data_sync),
    .dac_valid (1'b1),
    .tone_1_scale (dac_dds_scale_1_s),
    .tone_2_scale (dac_dds_scale_2_s),
    .tone_1_init_offset (dac_dds_init_1_s),
    .tone_2_init_offset (dac_dds_init_2_s),
    .tone_1_freq_word (dac_dds_incr_1_s),
    .tone_2_freq_word (dac_dds_incr_2_s),
    .dac_dds_data (dac_dds_data_s));

  // single channel processor

  up_dac_channel #(
    .CHANNEL_ID(CHANNEL_ID)
  ) i_up_dac_channel (
    .dac_clk (dac_div_clk),
    .dac_rst (dac_rst),
    .dac_dds_scale_1 (dac_dds_scale_1_s),
    .dac_dds_init_1 (dac_dds_init_1_s),
    .dac_dds_incr_1 (dac_dds_incr_1_s),
    .dac_dds_scale_2 (dac_dds_scale_2_s),
    .dac_dds_init_2 (dac_dds_init_2_s),
    .dac_dds_incr_2 (dac_dds_incr_2_s),
    .dac_pat_data_1 (dac_pat_data_1_s),
    .dac_pat_data_2 (dac_pat_data_2_s),
    .dac_data_sel (dac_data_sel_s),
    .dac_iq_mode (),
    .dac_iqcor_enb (),
    .dac_iqcor_coeff_1 (),
    .dac_iqcor_coeff_2 (),
    .up_usr_datatype_be (),
    .up_usr_datatype_signed (),
    .up_usr_datatype_shift (),
    .up_usr_datatype_total_bits (),
    .up_usr_datatype_bits (),
    .up_usr_interpolation_m (),
    .up_usr_interpolation_n (),
    .dac_usr_datatype_be (1'b0),
    .dac_usr_datatype_signed (1'b1),
    .dac_usr_datatype_shift (8'd0),
    .dac_usr_datatype_total_bits (8'd16),
    .dac_usr_datatype_bits (8'd16),
    .dac_usr_interpolation_m (16'd1),
    .dac_usr_interpolation_n (16'd1),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule
