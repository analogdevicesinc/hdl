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

module qpsk_mod (
  input                   clk,
  input       [ 1:0]      data_input,
  input                   data_valid,
  output      [15:0]      data_qpsk_i,
  output      [15:0]      data_qpsk_q);

  wire    [15:0]    modulated_data_i;
  wire    [15:0]    modulated_data_q;
  wire    [15:0]    filtered_data_i;
  wire    [15:0]    filtered_data_q;

  // output logic
  assign data_qpsk_i = filtered_data_i;
  assign data_qpsk_q = filtered_data_q;

  // instantiations
  QPSK_Modulator_Baseband i_qpsk_mod (
    .in0({6'b0, data_input}),
    .out0_re(modulated_data_i),
    .out0_im(modulated_data_q)
  );

  Raised_Cosine_Transmit_Filter i_tx_filter (
    .clk(clk),
    .reset(),
    .enb_1_1_1(data_valid),
    .In1_re(modulated_data_i),
    .In1_im(modulated_data_q),
    .Out1_re(filtered_data_i),
    .Out1_im(filtered_data_q)
  );

endmodule
