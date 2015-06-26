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
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad_lvds_in (

  // data interface

  rx_clk,
  rx_data_in_p,
  rx_data_in_n,
  rx_data_p,
  rx_data_n,

  // delay interface

  delay_clk,
  delay_rst,
  delay_ld,
  delay_wdata,
  delay_rdata,
  delay_locked);

  // parameters

  parameter   BUFTYPE = 0;
  parameter   IODELAY_CTRL = 0;
  parameter   IODELAY_GROUP = "dev_if_delay_group";
  localparam  SERIES7 = 0;
  localparam  VIRTEX6 = 1;

  // data interface

  input               rx_clk;
  input               rx_data_in_p;
  input               rx_data_in_n;
  output              rx_data_p;
  output              rx_data_n;

  // delay interface

  input               delay_clk;
  input               delay_rst;
  input               delay_ld;
  input       [ 4:0]  delay_wdata;
  output      [ 4:0]  delay_rdata;
  output              delay_locked;

  // defaults

  assign delay_rdata = 5'd0;
  assign delay_locked = 1'b1;

  // instantiations

  altddio_in #(
    .invert_input_clocks("OFF"),
    .lpm_hint("UNUSED"),
    .lpm_type("altddio_in"),
    .power_up_high("OFF"),
    .width(1))
  i_rx_data_iddr (
    .aclr (1'b0),
    .aset (1'b0),
    .sclr (1'b0),
    .sset (1'b0),
    .inclocken (1'b1),
    .inclock (rx_clk),
    .datain (rx_data_in_p),
    .dataout_h (rx_data_p),
    .dataout_l (rx_data_n));

endmodule

// ***************************************************************************
// ***************************************************************************
