// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
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

module axi_ad485x_16b_channel #(

  parameter CHANNEL_ID = 0,
  parameter ACTIVE_LANE = 8'b11111111, // for cmos if
  parameter USERPORTS_DISABLE = 0,
  parameter DATAFORMAT_DISABLE = 0
) (

  // adc interface

  input                  adc_clk,
  input                  adc_rst,
  input                  adc_ch_valid_in,
  input          [31:0]  adc_ch_data_in,
  input                  if_crc_err,

  // dma interface

  output                 adc_enable,
  output                 adc_valid,
  output          [15:0] adc_data,

  // error monitoring

  output reg [ 6:0]      adc_status_header,
  output                 up_adc_pn_err,
  output                 up_adc_pn_oos,
  output                 up_adc_or,

  // format

  input      [ 1:0]      packet_format,
  input                  oversampling_en,

  // processor interface

  input                  up_rstn,
  input                  up_clk,
  input                  up_wreq,
  input      [13:0]      up_waddr,
  input      [31:0]      up_wdata,
  output                 up_wack,
  input                  up_rreq,
  input      [13:0]      up_raddr,
  output     [31:0]      up_rdata,
  output                 up_rack
);

  // internal registers

  reg                    adc_pn_err;
  reg                    adc_valid_f1;
  reg        [23:0]      adc_data_f1;
  reg        [31:0]      adc_raw_data;
  reg        [31:0]      read_channel_data;
  reg                    adc_or;
  (* keep = "true" *)  reg [31:0] pattern;
  (* keep = "true" *)  reg [31:0] expected_package_pattern;

  // internal signals

  wire                   to_be_checked;

  wire                   adc_dfmt_se_s;
  wire                   adc_dfmt_type_s;
  wire                   adc_dfmt_enable_s;
  wire                   adc_pn_err_s;

  wire                   adc_valid_f2;
  wire        [31:0]     adc_data_f2;
  wire                   adc_valid_f2_ovs;
  wire        [31:0]     adc_data_f2_ovs;

  wire        [31:0]     expected_pattern;
  wire        [31:0]     expected_package_pattern_s;

  // expected pattern

  assign expected_pattern = {CHANNEL_ID[3:0], 28'hace3c2a};
  assign expected_package_pattern_s = packet_format == 2'd0 ? expected_pattern >> 16:
                                                              expected_pattern >> 8;

  // the pattern check result is masked out for unused lanes(cmos)
  assign to_be_checked = ACTIVE_LANE[CHANNEL_ID[3:0]] ? 1'b1 : 1'b0;

  always @(posedge adc_clk) begin
    expected_package_pattern <= expected_package_pattern_s;
    if (expected_package_pattern == pattern) begin
      adc_pn_err <= 1'b0;
    end else begin
      adc_pn_err <= to_be_checked;
    end
  end

  always @(posedge adc_clk) begin
    adc_valid_f1 <= adc_ch_valid_in;
    case (packet_format)
      3'h0: begin // packet format 16 - oversampling on or off
        adc_raw_data <= {16'd0,adc_ch_data_in[15:0]};
        adc_or <= 1'b0;
        adc_status_header <= 7'd0;
        pattern <= {16'd0, adc_ch_data_in[15:0]};
      end
      3'h1: begin // packet format 24 - oversampling off
        adc_raw_data <= {16'd0,adc_ch_data_in[23:8]};
        adc_or <= adc_ch_data_in[7];
        adc_status_header <= adc_ch_data_in[6:0];
        pattern <= {8'd0, adc_ch_data_in[23:0]};
      end
    endcase
  end

  ad_datafmt #(
    .DATA_WIDTH (16),
    .BITS_PER_SAMPLE (16),
    .DISABLE (DATAFORMAT_DISABLE)
  ) i_ad_datafmt (
    .clk (adc_clk),
    .valid (adc_valid_f1),
    .data (adc_raw_data[15:0]),
    .valid_out (adc_valid),
    .data_out (adc_data),
    .dfmt_enable (adc_dfmt_enable_s),
    .dfmt_type (adc_dfmt_type_s),
    .dfmt_se (adc_dfmt_se_s));

  always @(posedge adc_clk) begin
    if (adc_valid_f1) begin
      read_channel_data <= adc_raw_data;
    end else begin
      read_channel_data <= read_channel_data;
    end
  end

  // adc channel regmap

  up_adc_channel #(
    .CHANNEL_ID (CHANNEL_ID),
    .USERPORTS_DISABLE (USERPORTS_DISABLE),
    .DATAFORMAT_DISABLE (DATAFORMAT_DISABLE),
    .DCFILTER_DISABLE (1'b1),
    .IQCORRECTION_DISABLE (1'b1)
  ) i_up_adc_channel (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_enable (adc_enable),
    .adc_iqcor_enb (),
    .adc_dcfilt_enb (),
    .adc_dfmt_se (adc_dfmt_se_s),
    .adc_dfmt_type (adc_dfmt_type_s),
    .adc_dfmt_enable (adc_dfmt_enable_s),
    .adc_dcfilt_offset (),
    .adc_dcfilt_coeff (),
    .adc_iqcor_coeff_1 (),
    .adc_iqcor_coeff_2 (),
    .adc_pnseq_sel (),
    .adc_data_sel (),
    .adc_softspan (),
    .adc_pn_err (adc_pn_err),
    .adc_pn_oos (1'b0),
    .adc_or (adc_or),
    .adc_read_data (read_channel_data),
    .adc_status_header ({1'b1, adc_status_header}),
    .adc_crc_err (if_crc_err),
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
    .adc_usr_datatype_total_bits (8'd32),
    .adc_usr_datatype_bits (8'd20),
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
