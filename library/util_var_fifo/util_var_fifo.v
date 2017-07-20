// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
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

module util_var_fifo (

  clk,
  rst,

  depth,

  data_in,
  data_in_valid,

  data_out,
  data_out_valid

);

  parameter       DATA_WIDTH = 32;
  parameter       ADDRESS_WIDTH =  13;

  localparam      MAX_DEPTH = (2 ** ADDRESS_WIDTH) - 1;

  input             clk;
  input             rst;

  input   [31:0]    depth;

  input   [DATA_WIDTH -1:0]    data_in;
  input             data_in_valid;

  output  [DATA_WIDTH-1:0]    data_out;
  output            data_out_valid;

  // internal registers

  reg     [ADDRESS_WIDTH-1:0]    addra = 'd0;
  reg     [ADDRESS_WIDTH-1:0]    addrb = 'd0;

  reg     [31:0]    depth_d1 = 'd0;
  reg     [31:0]    data_in_d1 = 'd0;
  reg     [31:0]    data_in_d2 = 'd0;
  reg               data_active = 'd0;

  // internal signals

  wire                    reset;
  wire  [31:0]            depth;
  wire  [DATA_WIDTH-1:0]  data_out_s;
  wire                    data_out_valid_s;

  assign reset = ((rst == 1'b1) || (depth != depth_d1)) ? 1 : 0;

  assign data_out = (depth == 0) ? data_in_d2 : data_out_s;
  assign data_out_valid_s = data_active & data_in_valid;
  assign data_out_valid = (depth == 0) ? data_in_valid : data_out_valid_s;

  always @(posedge clk) begin
    depth_d1 <= depth;
    data_in_d1 <= data_in;
    data_in_d2 <= data_in_d1;
  end

  always @(posedge clk) begin
    if(reset == 1'b1) begin
      addra <= 0;
      addrb <= 0;
      data_active <= 1'b0;
    end else begin
      if (data_in_valid == 1'b1) begin
        addra <= addra + 1;
        if (data_active == 1'b1) begin
          addrb <= addrb + 1;
        end
      end
      if (addra >= depth || addra > MAX_DEPTH - 2) begin
        data_active <= 1'b1;
      end
    end
  end

  ad_mem #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDRESS_WIDTH(ADDRESS_WIDTH)
  ) data_fifo (
    .clka(clk),
    .wea(data_in_valid),
    .addra(addra),
    .dina(data_in),

    .clkb(clk),
    .addrb(addrb),
    .doutb(data_out_s));

endmodule

// ***************************************************************************
// ***************************************************************************
