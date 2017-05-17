// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// Each core or library found in this collection may have its own licensing terms. 
// The user should keep this in in mind while exploring these cores. 
//
// Redistribution and use in source and binary forms,
// with or without modification of this file, are permitted under the terms of either
//  (at the option of the user):
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory, or at:
// https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
//
// OR
//
//   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
// https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
//
// ***************************************************************************
// ***************************************************************************
`timescale 1ns/1ns

module qpsk_demod (
  input                   clk,
  input       [15:0]      data_qpsk_i,
  input       [15:0]      data_qpsk_q,
  input                   data_valid,
  output      [ 1:0]      data_output);

  wire    [15:0]    filtered_data_i;
  wire    [15:0]    filtered_data_q;
  wire    [ 7:0]    demodulated_data;

  // output logic
  assign data_output = demodulated_data[1:0];

  // instantiation
  Raised_Cosine_Receive_Filter i_rx_filter (
    .clk(clk),
    .reset(1'b0),
    .enb_1_1_1(data_valid),
    .In1_re(data_qpsk_i),
    .In1_im(data_qpsk_q),
    .Out1_re(filtered_data_i),
    .Out1_im(filtered_data_q)
  );

  QPSK_Demodulator_Baseband i_qpsk_demod(
    .in0_re(filtered_data_i),
    .in0_im(filtered_data_q),
    .out0(demodulated_data)
  );

endmodule
