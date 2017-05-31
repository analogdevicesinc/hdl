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
// freedoms and responsabilities that he or she has by using this source/core.
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

`timescale 1ns/1ns

module prcfg_adc #(

  parameter   CHANNEL_ID    = 0,
  parameter   DATA_WIDTH    = 32) (
  input                   clk,

  // control ports
  input       [31:0]      control,
  output  reg [31:0]      status,

  // FIFO interface
  input                   src_adc_valid,
  input       [(DATA_WIDTH-1):0]  src_adc_data,
  input                   src_adc_enable,

  output  reg             dst_adc_valid,
  output  reg [(DATA_WIDTH-1):0]  dst_adc_data,
  output  reg             dst_adc_enable);


  localparam  SYMBOL_WIDTH  = 2;
  localparam  RP_ID         = 8'hA2;

  reg     [ 7:0]                      adc_pn_data     = 'hF1;
  reg     [ 3:0]                      mode            = 'h0;
  reg     [ 3:0]                      channel_sel     = 'h0;

  wire                                adc_valid;
  wire    [(SYMBOL_WIDTH-1):0]        adc_data_s;
  wire    [ 7:0]                      adc_pn_data_s;
  wire                                adc_pn_err_s;
  wire                                adc_pn_oos_s;

  // prbs function
  function [ 7:0] pn;
    input [ 7:0] din;
    reg   [ 7:0] dout;
    begin
      dout[7] = din[6];
      dout[6] = din[5];
      dout[5] = din[4];
      dout[4] = din[3];
      dout[3] = din[2];
      dout[2] = din[1];
      dout[1] = din[7] ^ din[4];
      dout[0] = din[6] ^ din[3];
      pn = dout;
    end
  endfunction

  // update control and status registers
  always @(posedge clk) begin
    channel_sel <= control[ 3:0];
    mode        <= control[ 7:4];
  end

  assign adc_valid  = src_adc_valid & src_adc_enable;

  assign adc_pn_data_s = (adc_pn_oos_s == 1'b1) ? {adc_pn_data[7:2], adc_data_s} : adc_pn_data;

  ad_pnmon #(
    .DATA_WIDTH(8)
  ) i_pn_mon (
    .adc_clk(clk),
    .adc_valid_in(adc_valid),
    .adc_data_in({adc_pn_data[7:2], adc_data_s}),
    .adc_data_pn(adc_pn_data_s),
    .adc_pn_oos(adc_pn_oos_s),
    .adc_pn_err(adc_pn_err_s));

  // prbs generation
  always @(posedge clk) begin
    if(adc_valid == 1'b1) begin
      adc_pn_data <= pn(adc_pn_data);
    end
  end

  // qpsk demodulator
  qpsk_demod i_qpsk_demod1 (
    .clk(clk),
    .data_qpsk_i(src_adc_data[15: 0]),
    .data_qpsk_q(src_adc_data[31:16]),
    .data_valid(adc_valid),
    .data_output(adc_data_s)
  );

  // output logic for data ans status
  always @(posedge clk) begin

    dst_adc_valid <= src_adc_valid;
    dst_adc_enable <= src_adc_enable;

    case(mode)

      4'h0 : begin
        dst_adc_data <= src_adc_data;
      end
      4'h1 : begin
        dst_adc_data <= 32'h0;
      end
      4'h2 : begin
        dst_adc_data <= {30'h0, adc_data_s};
      end
      default : begin
        dst_adc_data <= src_adc_data;
      end
    endcase

    if((mode == 3'd2) && (channel_sel == CHANNEL_ID)) begin
      status <= {22'h0, adc_pn_err_s, adc_pn_oos_s, RP_ID};
    end else begin
      status <= {24'h0, RP_ID};
    end
  end

endmodule

