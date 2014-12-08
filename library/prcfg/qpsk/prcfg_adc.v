
// ***************************************************************************
// ***************************************************************************
// Copyright 2013(c) Analog Devices, Inc.
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
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/1ns

module prcfg_adc (
  clk,

  // control ports
  control,
  status,

  // FIFO interface
  src_adc_dwr,
  src_adc_dsync,
  src_adc_ddata,
  src_adc_dovf,

  dst_adc_dwr,
  dst_adc_dsync,
  dst_adc_ddata,
  dst_adc_dovf
);

  parameter   CHANNEL_ID    = 0;
  parameter   DATA_WIDTH    = 32;

  localparam  SYMBOL_WIDTH = 2;
  localparam  RP_ID         = 8'hA2;

  input                               clk;

  input   [31:0]                      control;
  output  [31:0]                      status;

  input                               src_adc_dwr;
  input                               src_adc_dsync;
  input   [(DATA_WIDTH-1):0]          src_adc_ddata;
  output                              src_adc_dovf;

  output                              dst_adc_dwr;
  output                              dst_adc_dsync;
  output  [(DATA_WIDTH-1):0]          dst_adc_ddata;
  input                               dst_adc_dovf;

  reg                                 src_adc_dovf    = 'h0;
  reg                                 dst_adc_dwr     = 'h0;
  reg                                 dst_adc_dsync   = 'h0;
  reg     [(DATA_WIDTH-1):0]          dst_adc_ddata   = 'h0;

  reg     [ 7:0]                      adc_pn_data     = 'hF1;
  reg     [31:0]                      status          = 'h0;
  reg     [ 3:0]                      mode            = 'h0;
  reg     [ 3:0]                      channel_sel     = 'h0;

  wire                                adc_dvalid;
  wire    [(SYMBOL_WIDTH-1):0]        adc_ddata_s;
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

  assign adc_dvalid  = src_adc_dwr & src_adc_dsync;

  assign adc_pn_data_s = (adc_pn_oos_s == 1'b1) ? {adc_pn_data[7:2], adc_ddata_s} : adc_pn_data;

  ad_pnmon #(
    .DATA_WIDTH(8)
  ) i_pn_mon (
    .adc_clk(clk),
    .adc_valid_in(adc_dvalid),
    .adc_data_in({adc_pn_data[7:2], adc_ddata_s}),
    .adc_data_pn(adc_pn_data_s),
    .adc_pn_oos(adc_pn_oos_s),
    .adc_pn_err(adc_pn_err_s));

  // prbs generation
  always @(posedge clk) begin
    if(adc_dvalid == 1'b1) begin
      adc_pn_data <= pn(adc_pn_data);
    end
  end

  // qpsk demodulator
  qpsk_demod i_qpsk_demod1 (
    .clk(clk),
    .data_qpsk_i(src_adc_ddata[15: 0]),
    .data_qpsk_q(src_adc_ddata[31:16]),
    .data_valid(adc_dvalid),
    .data_output(adc_ddata_s)
  );

  // output logic for data ans status
  always @(posedge clk) begin

    dst_adc_dsync  <= src_adc_dsync;
    dst_adc_dwr    <= src_adc_dwr;

    case(mode)

      4'h0 : begin
        dst_adc_ddata <= src_adc_ddata;
        src_adc_dovf   <= dst_adc_dovf;
      end
      4'h1 : begin
        dst_adc_ddata <= 32'h0;
        src_adc_dovf  <= 1'b0;
      end
      4'h2 : begin
        dst_adc_ddata <= {30'h0, adc_ddata_s};
        src_adc_dovf   <= dst_adc_dovf;
      end
      default : begin
        dst_adc_ddata <= src_adc_ddata;
        src_adc_dovf   <= dst_adc_dovf;
      end
    endcase

    if((mode == 3'd2) && (channel_sel == CHANNEL_ID)) begin
      status <= {22'h0, adc_pn_err_s, adc_pn_oos_s, RP_ID};
    end else begin
      status <= {24'h0, RP_ID};
    end
  end

endmodule

