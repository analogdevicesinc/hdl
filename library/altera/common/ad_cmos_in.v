// ***************************************************************************
// ***************************************************************************
// Copyright 2014(c) Analog Devices, Inc.
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

`timescale 1ns/100ps

module ad_cmos_in (

  // data interface

  rx_clk,
  rx_data_in,
  rx_data_p,
  rx_data_n,

  // delay-data interface

  up_clk,
  up_dld,
  up_dwdata,
  up_drdata,

  // delay-cntrl interface

  delay_clk,
  delay_rst,
  delay_locked);

  // parameters

  parameter   SINGLE_ENDED = 0;
  parameter   DEVICE_TYPE = 0;
  parameter   IODELAY_CTRL = 0;
  parameter   IODELAY_GROUP = "dev_if_delay_group";

  // data interface

  input               rx_clk;
  input               rx_data_in;
  output              rx_data_p;
  output              rx_data_n;

  // delay-data interface

  input               up_clk;
  input               up_dld;
  input       [ 4:0]  up_dwdata;
  output      [ 4:0]  up_drdata;

  // delay-cntrl interface

  input               delay_clk;
  input               delay_rst;
  output              delay_locked;

  // internal registers

  reg                 rx_data_p = 'd0;
  reg                 rx_data_n = 'd0;

  // internal signals

  wire                rx_data_p_s;
  wire                rx_data_n_s;

  // defaults

  assign up_drdata = 5'd0;
  assign delay_locked = 1'b1;

  // instantiations

  generate
  if (DEVICE_TYPE == 0) begin
  alt_ddio_in i_rx_data_iddr (
    .ck (rx_clk),
    .pad_in (rx_data_in),
    .dout ({rx_data_p_s, rx_data_n_s}));
  end
  endgenerate

  generate
  if (DEVICE_TYPE == 1) begin
  altddio_in #(.width (1), .lpm_hint("UNUSED")) i_rx_data_iddr (
    .inclock (rx_clk),
    .datain (rx_data_in),
    .dataout_h (rx_data_p_s),
    .dataout_l (rx_data_n_s),
    .inclocken (1'b1),
    .aclr (1'b0),
    .aset (1'b0),
    .sclr (1'b0),
    .sset (1'b0));
  end
  endgenerate

  always @(posedge rx_clk) begin
    rx_data_p <= rx_data_p_s;
    rx_data_n <= rx_data_n_s;
  end

endmodule

// ***************************************************************************
// ***************************************************************************
