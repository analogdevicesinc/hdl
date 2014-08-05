
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
  src_dac_en,
  src_dac_ddata,
  src_dac_dunf,
  src_dac_dvalid,

  dst_dac_en,
  dst_dac_ddata,
  dst_dac_dunf,
  dst_dac_dvalid
);

  localparam  RP_ID       = 8'hA0;
  parameter   CHANNEL_ID  = 0;

  input             clk;

  input   [31:0]    control;
  output  [31:0]    status;

  output            src_dac_en;
  input   [31:0]    src_dac_ddata;
  input             src_dac_dunf;
  input             src_dac_dvalid;

  input             dst_dac_en;
  output  [31:0]    dst_dac_ddata;
  output            dst_dac_dunf;
  output            dst_dac_dvalid;

  reg               src_dac_en;
  reg     [31:0]    dst_dac_ddata;
  reg               dst_dac_dunf;
  reg               dst_dac_dvalid;

  assign status = {24'h0, RP_ID};

  always @(posedge clk) begin
    src_dac_en     <= dst_dac_en;
    dst_dac_ddata  <= src_dac_ddata;
    dst_dac_dunf   <= src_dac_dunf;
    dst_dac_dvalid <= src_dac_dvalid;
  end
endmodule
