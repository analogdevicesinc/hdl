// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
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

module axi_pulsar_lvds_channel #(
  parameter USERPORTS_DISABLE = 0,
  parameter DATAFORMAT_DISABLE = 0,
  parameter ADC_DATA_WIDTH = 16,
  parameter BITS_PER_SAMPLE = 32
) (

  // adc interface

  input         adc_clk,
  input         adc_rst,
  input         adc_valid_in,
  input  [18:0] adc_data_in,

  // dma interface

  output        adc_enable,
  output        adc_valid,
  output [BITS_PER_SAMPLE-1:0] adc_data,

  // error monitoring

  output        up_adc_pn_err,
  output        up_adc_pn_oos,
  output        up_adc_or,

  // processor interface

  input         up_rstn,
  input         up_clk,
  input         up_wreq,
  input  [13:0] up_waddr,
  input  [31:0] up_wdata,
  output        up_wack,
  input         up_rreq,
  input  [13:0] up_raddr,
  output [31:0] up_rdata,
  output        up_rack
);

  // internal signals

  wire        adc_dfmt_valid_s;
  wire [(ADC_DATA_WIDTH-1):0] adc_dfmt_data_s;
  wire        adc_dcfilter_valid_s;
  wire        adc_iqcor_enb_s;
  wire        adc_dcfilt_enb_s;
  wire        adc_dfmt_se_s;
  wire        adc_dfmt_type_s;
  wire        adc_dfmt_enable_s;
  wire [15:0] adc_dcfilt_offset_s;
  wire [15:0] adc_dcfilt_coeff_s;
  wire [15:0] adc_iqcor_coeff_1_s;
  wire [15:0] adc_iqcor_coeff_2_s;
  wire [ 3:0] adc_pnseq_sel_s;
  wire [ 3:0] adc_data_sel_s;

  ad_datafmt #(
    .DATA_WIDTH (ADC_DATA_WIDTH),
    .BITS_PER_SAMPLE (BITS_PER_SAMPLE),
    .DISABLE (DATAFORMAT_DISABLE)
  ) i_ad_datafmt (
    .clk (adc_clk),
    .valid (adc_valid_in),
    .data (adc_data_in),
    .valid_out (adc_valid),
    .data_out (adc_data),
    .dfmt_enable (adc_dfmt_enable_s),
    .dfmt_type (adc_dfmt_type_s),
    .dfmt_se (adc_dfmt_se_s));

  // adc channel regmap

  up_adc_channel #(
    .CHANNEL_ID (0),
    .USERPORTS_DISABLE (USERPORTS_DISABLE),
    .DATAFORMAT_DISABLE (DATAFORMAT_DISABLE),
    .DCFILTER_DISABLE (1'b1),
    .IQCORRECTION_DISABLE (1'b1)
  ) i_up_adc_channel (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_enable (adc_enable),
    .adc_iqcor_enb (adc_iqcor_enb_s),
    .adc_dcfilt_enb (adc_dcfilt_enb_s),
    .adc_dfmt_se (adc_dfmt_se_s),
    .adc_dfmt_type (adc_dfmt_type_s),
    .adc_dfmt_enable (adc_dfmt_enable_s),
    .adc_dcfilt_offset (adc_dcfilt_offset_s),
    .adc_dcfilt_coeff (adc_dcfilt_coeff_s),
    .adc_iqcor_coeff_1 (adc_iqcor_coeff_1_s),
    .adc_iqcor_coeff_2 (adc_iqcor_coeff_2_s),
    .adc_pnseq_sel (adc_pnseq_sel_s),
    .adc_data_sel (),
    .adc_pn_err (),
    .adc_pn_oos (1'b0),
    .adc_or (1'b0),
    .adc_read_data ('d0),
    .adc_status_header ('d0),
    .adc_crc_err ('d0),
    .adc_softspan (),
    .up_adc_crc_err (),
    .up_adc_pn_err (up_adc_pn_err),
    .up_adc_pn_oos (up_adc_pn_oos),
    .up_adc_or (up_adc_or),
    .up_usr_datatype_be (),
    .up_usr_datatype_signed (),
    .up_usr_datatype_shift (),
    .up_usr_datatype_total_bits (),
    .up_usr_datatype_bits (),
    .up_usr_decimation_m (),
    .up_usr_decimation_n (),
    .adc_usr_datatype_be (1'b0),
    .adc_usr_datatype_signed (1'b1),
    .adc_usr_datatype_shift (8'd0),
    .adc_usr_datatype_total_bits (8'd16),
    .adc_usr_datatype_bits (8'd16),
    .adc_usr_decimation_m (16'd1),
    .adc_usr_decimation_n (16'd1),
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
