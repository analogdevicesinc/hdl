
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
  src_adc_enable,
  src_adc_valid,
  src_adc_data,

  dst_adc_enable,
  dst_adc_valid,
  dst_adc_data
);

  localparam  RP_ID       = 8'hA1;
  parameter   CHANNEL_ID  = 0;

  input             clk;

  input   [31:0]    control;
  output  [31:0]    status;

  input             src_adc_enable;
  input             src_adc_valid;
  input   [15:0]    src_adc_data;

  output            dst_adc_enable;
  output            dst_adc_valid;
  output  [15:0]    dst_adc_data;

  reg               dst_adc_enable;
  reg               dst_adc_valid;
  reg     [15:0]    dst_adc_data;

  reg     [31:0]    status            = 0;
  reg     [15:0]    adc_pn_data       = 0;

  reg     [ 3:0]    mode;
  reg     [ 3:0]    channel_sel;

  wire              adc_dvalid;
  wire    [15:0]    adc_pn_data_s;
  wire              adc_pn_oos_s;
  wire              adc_pn_err_s;


  // prbs function

  function [15:0] pn;
    input [15:0] din;
    reg   [15:0] dout;
    begin
      dout[15] = din[14] ^ din[15];
      dout[14] = din[13] ^ din[14];
      dout[13] = din[12] ^ din[13];
      dout[12] = din[11] ^ din[12];
      dout[11] = din[10] ^ din[11];
      dout[10] = din[ 9] ^ din[10];
      dout[ 9] = din[ 8] ^ din[ 9];
      dout[ 8] = din[ 7] ^ din[ 8];
      dout[ 7] = din[ 6] ^ din[ 7];
      dout[ 6] = din[ 5] ^ din[ 6];
      dout[ 5] = din[ 4] ^ din[ 5];
      dout[ 4] = din[ 3] ^ din[ 4];
      dout[ 3] = din[ 2] ^ din[ 3];
      dout[ 2] = din[ 1] ^ din[ 2];
      dout[ 1] = din[ 0] ^ din[ 1];
      dout[ 0] = din[14] ^ din[15] ^ din[ 0];
      pn = dout;
    end
  endfunction

  assign adc_dvalid = src_adc_enable & src_adc_valid;

  always @(posedge clk) begin
    channel_sel  <= control[3:0];
    mode         <= control[7:4];
  end

  // prbs generation
  always @(posedge clk) begin
    if(adc_dvalid == 1'b1) begin
      adc_pn_data <= pn(adc_pn_data_s);
    end
  end

  assign adc_pn_data_s = (adc_pn_oos_s == 1'b1) ? src_adc_ddata : adc_pn_data;

  ad_pnmon #(
    .DATA_WIDTH(32)
  ) i_pn_mon (
    .adc_clk(clk),
    .adc_valid_in(adc_dvalid),
    .adc_data_in(src_adc_ddata),
    .adc_data_pn(adc_pn_data),
    .adc_pn_oos(adc_pn_oos_s),
    .adc_pn_err(adc_pn_err_s));

  // rx path are passed through on test mode
  always @(posedge clk) begin
    dst_adc_enable <= src_adc_enable;
    dst_adc_data   <= src_adc_data;
    dst_adc_valid  <= src_adc_valid;
  end

  // setup status bits for gpio_out
  always @(posedge clk) begin
    if((mode == 3'd2) && (channel_sel == CHANNEL_ID)) begin
      status <= {22'h0, adc_pn_err_s, adc_pn_oos_s, RP_ID};
    end else begin
      status <= {24'h0, RP_ID};
    end
  end

endmodule
