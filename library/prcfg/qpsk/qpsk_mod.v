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
