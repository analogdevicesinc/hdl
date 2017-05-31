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

module prcfg_dac#(

  parameter   CHANNEL_ID    = 0,
  parameter   DATA_WIDTH    = 16) (

  input                   clk,

  // control ports
  input       [31:0]      control,
  output  reg [31:0]      status,

  // FIFO interface
  output  reg             src_dac_enable,
  input       [(DATA_WIDTH-1):0]  src_dac_data,
  output  reg             src_dac_valid,

  input                   dst_dac_enable,
  output  reg [(DATA_WIDTH-1):0]  dst_dac_data,
  input                   dst_dac_valid);


  localparam  SYMBOL_WIDTH  = 2;
  localparam  RP_ID         = 8'hA2;

  // output register to improve timing

  // internal registers
  reg     [ 7:0]                      pn_data        = 'hF2;
  reg     [ 3:0]                      mode           = 'h0;

  // internal wires
  wire    [(SYMBOL_WIDTH-1):0]        mod_data;
  wire    [15:0]                      dac_data_fltr_i;
  wire    [15:0]                      dac_data_fltr_q;

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
    status <= { 24'h0, RP_ID };
    mode   <= control[ 7:4];
  end

  // prbs generation
  always @(posedge clk) begin
    if((dst_dac_en == 1) && (dst_dac_enable == 1)) begin
      pn_data <= pn(pn_data);
    end
  end

  // data for the modulator (prbs or dma)
  assign mod_data = (mode == 1) ? pn_data[ 1:0] : src_dac_data[ 1:0];

  // qpsk modulator
  qpsk_mod i_qpsk_mod (
    .clk(clk),
    .data_input(mod_data),
    .data_valid(dst_dac_en),
    .data_qpsk_i(dac_data_fltr_i),
    .data_qpsk_q(dac_data_fltr_q)
  );

  // output logic
  always @(posedge clk) begin

    src_dac_enable <= dst_dac_en;
    src_dac_valid  <= dst_dac_valid;

    case(mode)
      4'h0 : begin
        dst_dac_data <= src_dac_data;
      end
      4'h1 : begin
        dst_dac_data <= { dac_data_fltr_q, dac_data_fltr_i };
      end
      4'h2 : begin
        dst_dac_data <= { dac_data_fltr_q, dac_data_fltr_i };
      end
      default : begin
      end
    endcase

  end
endmodule

