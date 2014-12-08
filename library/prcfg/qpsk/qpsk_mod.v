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

module qpsk_mod (
  clk,
  data_input,
  data_valid,
  data_qpsk_i,
  data_qpsk_q
);

  input             clk;
  input   [ 1:0]    data_input;
  input             data_valid;
  output  [15:0]    data_qpsk_i;
  output  [15:0]    data_qpsk_q;

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
