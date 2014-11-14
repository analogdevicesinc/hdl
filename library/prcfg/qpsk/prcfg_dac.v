
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

  parameter   CHANNEL_ID    = 0;
  parameter   DATA_WIDTH    = 32;

  localparam  SYMBOL_WIDTH  = 2;
  localparam  RP_ID         = 8'hA2;

  input                               clk;

  input   [31:0]                      control;
  output  [31:0]                      status;

  output                              src_dac_en;
  input   [(DATA_WIDTH-1):0]          src_dac_ddata;
  input                               src_dac_dunf;
  input                               src_dac_dvalid;

  input                               dst_dac_en;
  output  [(DATA_WIDTH-1):0]          dst_dac_ddata;
  output                              dst_dac_dunf;
  output                              dst_dac_dvalid;

  // output register to improve timing
  reg                                 dst_dac_dunf   = 'h0;
  reg     [(DATA_WIDTH-1):0]          dst_dac_ddata  = 'h0;
  reg                                 dst_dac_dvalid = 'h0;
  reg                                 src_dac_en     = 'h0;

  // internal registers
  reg     [ 7:0]                      pn_data        = 'hF2;
  reg     [31:0]                      status         = 'h0;
  reg     [ 3:0]                      mode           = 'h0;

  // internal wires
  wire    [(SYMBOL_WIDTH-1):0]        mod_data;
  wire    [15:0]                      dac_data_fltr_i;
  wire    [15:0]                      dac_data_fltr_q;

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
    status <= { 24'h0, RP_ID };
    mode   <= control[ 7:4];
  end

  // prbs generation
  always @(posedge clk) begin
    if(dst_dac_en == 1) begin
      pn_data <= pn(pn_data);
    end
  end

  // data for the modulator (prbs or dma)
  assign mod_data = (mode == 1) ? pn_data[ 1:0] : src_dac_ddata[ 1:0];

  // qpsk modulator
  qpsk_mod i_qpsk_mod (
    .clk(clk),
    .data_input(mod_data),
    .data_valid(dst_dac_en),
    .data_qpsk_i(dac_data_fltr_i),
    .data_qpsk_q(dac_data_fltr_q)
  );

  // output logic
  always @(posedge clk) begin

    src_dac_en     <= dst_dac_en;
    dst_dac_dvalid <= src_dac_dvalid;

    case(mode)
      4'h0 : begin
        dst_dac_ddata <= src_dac_ddata;
        dst_dac_dunf  <= src_dac_dunf;
      end
      4'h1 : begin
        dst_dac_ddata <= { dac_data_fltr_q, dac_data_fltr_i };
        dst_dac_dunf  <= 1'h0;
      end
      4'h2 : begin
        dst_dac_ddata <= { dac_data_fltr_q, dac_data_fltr_i };
        dst_dac_dunf  <= src_dac_dunf;
      end
      default : begin
      end
    endcase

  end
endmodule

