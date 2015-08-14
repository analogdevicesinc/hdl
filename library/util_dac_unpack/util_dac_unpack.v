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

module util_dac_unpack (

  clk,

  dac_enable_00,
  dac_valid_00,
  dac_data_00,

  dac_enable_01,
  dac_valid_01,
  dac_data_01,

  dac_enable_02,
  dac_valid_02,
  dac_data_02,

  dac_enable_03,
  dac_valid_03,
  dac_data_03,

  dac_enable_04,
  dac_valid_04,
  dac_data_04,

  dac_enable_05,
  dac_valid_05,
  dac_data_05,

  dac_enable_06,
  dac_valid_06,
  dac_data_06,

  dac_enable_07,
  dac_valid_07,
  dac_data_07,

  fifo_valid,
  dma_rd,
  dma_data);

  parameter CHANNELS = 8; // valid values are 4 and 8
  parameter DATA_WIDTH = 16;

  input                   clk;

  input                    dac_enable_00;
  input                    dac_valid_00;
  output  [DATA_WIDTH-1:0] dac_data_00;

  input                    dac_enable_01;
  input                    dac_valid_01;
  output  [DATA_WIDTH-1:0] dac_data_01;

  input                    dac_enable_02;
  input                    dac_valid_02;
  output  [DATA_WIDTH-1:0] dac_data_02;

  input                    dac_enable_03;
  input                    dac_valid_03;
  output  [DATA_WIDTH-1:0] dac_data_03;

  input                    dac_enable_04;
  input                    dac_valid_04;
  output  [DATA_WIDTH-1:0] dac_data_04;

  input                    dac_enable_05;
  input                    dac_valid_05;
  output  [DATA_WIDTH-1:0] dac_data_05;

  input                    dac_enable_06;
  input                    dac_valid_06;
  output  [DATA_WIDTH-1:0] dac_data_06;

  input                    dac_enable_07;
  input                    dac_valid_07;
  output  [DATA_WIDTH-1:0] dac_data_07;

  input                             fifo_valid;
  output                            dma_rd;
  input   [CHANNELS*DATA_WIDTH-1:0] dma_data;


  localparam DMA_WIDTH = CHANNELS*DATA_WIDTH;

  wire [CHANNELS-1:0]            dac_enable;
  wire [CHANNELS-1:0]            dac_valid;

  wire [DATA_WIDTH-1:0]          data_array[0:CHANNELS-1];

  wire [$clog2(CHANNELS)-1:0]    offset [0:CHANNELS-1];
  wire                           dac_chan_valid;

  reg [DATA_WIDTH*CHANNELS-1:0]  dac_data = 'h00;
  reg [DMA_WIDTH-1:0]            buffer = 'h00;
  reg                            dma_rd = 1'b0;
  reg [$clog2(CHANNELS)-1:0]     rd_counter = 'h00;
  reg [$clog2(CHANNELS)-1:0]     req_counter = 'h00;
  reg [CHANNELS-1:0]             dac_enable_d1 = 'h00;

  assign dac_enable[0] = dac_enable_00;
  assign dac_enable[1] = dac_enable_01;
  assign dac_enable[2] = dac_enable_02;
  assign dac_enable[3] = dac_enable_03;
  assign dac_valid[0] = dac_valid_00;
  assign dac_valid[1] = dac_valid_01;
  assign dac_valid[2] = dac_valid_02;
  assign dac_valid[3] = dac_valid_03;
  assign dac_data_00 = dac_data[DATA_WIDTH*1-1:DATA_WIDTH*0];
  assign dac_data_01 = dac_data[DATA_WIDTH*2-1:DATA_WIDTH*1];
  assign dac_data_02 = dac_data[DATA_WIDTH*3-1:DATA_WIDTH*2];
  assign dac_data_03 = dac_data[DATA_WIDTH*4-1:DATA_WIDTH*3];

  generate
    if (CHANNELS >= 8) begin
      assign dac_enable[4] = dac_enable_04;
      assign dac_enable[5] = dac_enable_05;
      assign dac_enable[6] = dac_enable_06;
      assign dac_enable[7] = dac_enable_07;
      assign dac_valid[4] = dac_valid_04;
      assign dac_valid[5] = dac_valid_05;
      assign dac_valid[6] = dac_valid_06;
      assign dac_valid[7] = dac_valid_07;
      assign dac_data_04 = dac_data[DATA_WIDTH*5-1:DATA_WIDTH*4];
      assign dac_data_05 = dac_data[DATA_WIDTH*6-1:DATA_WIDTH*5];
      assign dac_data_06 = dac_data[DATA_WIDTH*7-1:DATA_WIDTH*6];
      assign dac_data_07 = dac_data[DATA_WIDTH*8-1:DATA_WIDTH*7];
    end else begin
      assign dac_data_04 = 'h0;
      assign dac_data_05 = 'h0;
      assign dac_data_06 = 'h0;
      assign dac_data_07 = 'h0;
    end
  endgenerate

  function integer enable_reduce;
    input n;
    integer n;
    integer i;
    begin
      enable_reduce = 0;
      for (i = 0; i < n; i = i + 1)
        enable_reduce = enable_reduce + dac_enable[i];
    end
  endfunction

  assign dac_chan_valid = |dac_valid;

  always @(posedge clk) begin
    if (fifo_valid == 1'b1) begin
      buffer <= dma_data;
      rd_counter <= 'h0;
    end else if (dac_chan_valid == 1'b1) begin
      rd_counter <= rd_counter + enable_reduce(CHANNELS);
    end
  end

  always @(posedge clk) begin
     dma_rd <= 1'b0;
     if (dac_enable != dac_enable_d1) begin
       req_counter <= 'h00;
     end else if (dac_chan_valid == 1'b1) begin
       req_counter <= req_counter + enable_reduce(CHANNELS);
       if (req_counter == 'h00) begin
         dma_rd <= 1'b1;
       end
     end
     dac_enable_d1 <= dac_enable;
  end

  generate
    genvar i;
    for (i = 0; i < CHANNELS; i = i + 1) begin : gen_data_array
      assign data_array[i] = buffer[DATA_WIDTH+i*DATA_WIDTH-1:i*DATA_WIDTH];
    end
  endgenerate

  generate
    genvar j;
    for (j = 0; j < CHANNELS; j = j + 1) begin : gen_dac_data
      assign offset[j] = rd_counter + enable_reduce(j);
      always @(posedge clk) begin
        if (dac_chan_valid) begin
          if (dac_enable[j])
            dac_data[DATA_WIDTH+j*DATA_WIDTH-1:j*DATA_WIDTH] <= data_array[offset[j]];
          else
            dac_data[DATA_WIDTH+j*DATA_WIDTH-1:j*DATA_WIDTH] <= 'h0000;
        end
      end
    end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
