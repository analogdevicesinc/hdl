
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

module prcfg_dac(

  clk,

  // control ports
  control,
  status,

  // FIFO interface
  src_dac_drd,
  src_dac_ddata,
  src_dac_dunf,

  dst_dac_drd,
  dst_dac_ddata,
  dst_dac_dunf
);

  localparam  RP_ID       = 8'hA2;
  parameter   CHANNEL_ID  = 0;

  input             clk;

  input   [31:0]    control;
  output  [31:0]    status;

  output            src_dac_drd;
  input   [31:0]    src_dac_ddata;
  input             src_dac_dunf;

  input             dst_dac_drd;
  output  [31:0]    dst_dac_ddata;
  output            dst_dac_dunf;

  reg               dst_dac_dunf   = 0;
  reg     [31:0]    dst_dac_ddata  = 0;
  reg               dst_dac_dvalid = 0;
  reg               src_dac_drd    = 0;
  reg     [ 1:0]    pn_data        = 0;

  wire    [ 1:0]    dac_data;
  wire    [15:0]    dac_data_fltr_i;
  wire    [15:0]    dac_data_fltr_q;

  wire    [ 3:0]    mode;

  wire    [31:0]    dac_data_mode0;
  wire    [31:0]    dac_data_mode1_2;

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
      dout[1] = din[8] ^ din[4];
      dout[0] = din[7] ^ din[3];
      pn = dout;
    end
  endfunction

  assign status = { 24'h0, RP_ID };
  assign mode   = control[ 7:4];

  // pass through mode
  assign dac_data_mode0 = src_dac_ddata;

  // prbs geenration
  always @(posedge clk) begin
    if(dst_dac_drd == 1) begin
      pn_data = pn(pn_data);
    end
  end

  // data source for the modulator
  assign dac_data = (mode == 1) ? pn_data : src_dac_ddata[ 1: 0];

  // modulated data
  assign dac_data_mode1_2 = { dac_data_fltr_q, dac_data_fltr_i };

  // qpsk modulator
  qpsk_mod i_qpsk_mod (
    .clk(clk),
    .data_input(dac_data),
    .data_valid(dst_dac_drd),
    .data_qpsk_i(dac_data_fltr_i),
    .data_qpsk_q(dac_data_fltr_q)
  );

  // output logic for tx side
  always @(posedge clk) begin
    src_dac_drd   <= (mode == 1) ? 1'b0 : dst_dac_drd;
    dst_dac_dunf  <= (mode == 1) ? 1'b0 : src_dac_dunf;
    dst_dac_ddata <= (mode == 0) ? dac_data_mode0 : dac_data_mode1_2;
  end

endmodule
