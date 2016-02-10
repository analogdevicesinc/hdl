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

module axi_usb_fx3_if (

  dma_rdy,
  dma_wmk,

  fifo_rdy,

  pclk,          //output clk 100 Mhz and 180 phase shift

  data,
  addr,          //output fifo address

  slcs_n,        //output chip select
  slrd_n,        //output read select
  sloe_n,        //output output enable select
  slwr_n,        //output write select
  pktend_n,      //output pkt end
  epswitch_n,    //output pkt end

  fifo_num,
  trig,
  fifo_ready,

  test_mode_tpm,

  fx32dma_valid,
  fx32dma_ready,
  fx32dma_data,
  fx32dma_sop,
  fx32dma_eop,

  dma2fx3_ready,
  dma2fx3_valid,
  dma2fx3_data,
  dma2fx3_eop);

  input           dma_rdy;
  input           dma_wmk;

  input  [10:0]   fifo_rdy;

  input           pclk;

  output  [31:0]  data;
  output  [4:0]   addr;

  output          slcs_n;
  output          slrd_n;
  output          sloe_n;
  output          slwr_n;
  output          pktend_n;
  output          epswitch_n;

  output  [10:0]  fifo_ready;

  input   [ 2:0]  test_mode_tpm;

  input   [4:0]   fifo_num;
  input           trig;

  output          fx32dma_valid;
  input           fx32dma_ready;
  output  [31:0]  fx32dma_data;
  output          fx32dma_sop;
  output          fx32dma_eop;

  input           dma2fx3_valid;
  output          dma2fx3_ready;
  input   [31:0]  dma2fx3_data;
  input           dma2fx3_eop;

  // internal wires

  wire          fx32dma_sop;

  // internal registers

  wire          fx32dma_valid;

  reg   [10:0]  fifo_ready;

  reg           internal_trig = 0;
  reg           trig_d = 0;
  reg   [31:0]  internal_counter = 0;
  reg   [ 2:0]  packet_number = 0;
  reg   [31:0]  data_size = 0;
  reg   [31:0]  fx32dma_data = 0;
  reg   [31:0]  generated_data = 0;
  reg           fx32dma_eop;

  reg           transaction_in_progress = 0;

  assign fx32dma_sop   = internal_trig ;
  assign fx32dma_valid = transaction_in_progress;
 function [31:0] pn23;
    input [31:0] din;
    reg   [31:0] dout;
    begin
      dout[31] = din[22] ^ din[17];
      dout[30] = din[21] ^ din[16];
      dout[29] = din[20] ^ din[15];
      dout[28] = din[19] ^ din[14];
      dout[27] = din[18] ^ din[13];
      dout[26] = din[17] ^ din[12];
      dout[25] = din[16] ^ din[11];
      dout[24] = din[15] ^ din[10];
      dout[23] = din[14] ^ din[ 9];
      dout[22] = din[13] ^ din[ 8];
      dout[21] = din[12] ^ din[ 7];
      dout[20] = din[11] ^ din[ 6];
      dout[19] = din[10] ^ din[ 5];
      dout[18] = din[ 9] ^ din[ 4];
      dout[17] = din[ 8] ^ din[ 3];
      dout[16] = din[ 7] ^ din[ 2];
      dout[15] = din[ 6] ^ din[ 1];
      dout[14] = din[ 5] ^ din[ 0];
      dout[13] = din[ 4] ^ din[22] ^ din[17];
      dout[12] = din[ 3] ^ din[21] ^ din[16];
      dout[11] = din[ 2] ^ din[20] ^ din[15];
      dout[10] = din[ 1] ^ din[19] ^ din[14];
      dout[ 9] = din[ 0] ^ din[18] ^ din[13];
      dout[ 8] = din[22] ^ din[12];
      dout[ 7] = din[21] ^ din[11];
      dout[ 6] = din[20] ^ din[10];
      dout[ 5] = din[19] ^ din[ 9];
      dout[ 4] = din[18] ^ din[ 8];
      dout[ 3] = din[17] ^ din[ 7];
      dout[ 2] = din[16] ^ din[ 6];
      dout[ 1] = din[15] ^ din[ 5];
      dout[ 0] = din[14] ^ din[ 4];
      pn23 = dout;
    end
  endfunction

  function [31:0] pn9;
    input [31:0] din;
    reg   [31:0] dout;
    begin
      dout[31] = din[ 8] ^ din[ 4];
      dout[30] = din[ 7] ^ din[ 3];
      dout[29] = din[ 6] ^ din[ 2];
      dout[28] = din[ 5] ^ din[ 1];
      dout[27] = din[ 4] ^ din[ 0];
      dout[26] = din[ 3] ^ din[ 8] ^ din[ 4];
      dout[25] = din[ 2] ^ din[ 7] ^ din[ 3];
      dout[24] = din[ 1] ^ din[ 6] ^ din[ 2];
      dout[23] = din[ 0] ^ din[ 5] ^ din[ 1];
      dout[22] = din[ 8] ^ din[ 0];
      dout[21] = din[ 7] ^ din[ 8] ^ din[ 4];
      dout[20] = din[ 6] ^ din[ 7] ^ din[ 3];
      dout[19] = din[ 5] ^ din[ 6] ^ din[ 2];
      dout[18] = din[ 4] ^ din[ 5] ^ din[ 1];
      dout[17] = din[ 3] ^ din[ 4] ^ din[ 0];
      dout[16] = din[ 2] ^ din[ 3] ^ din[ 8] ^ din[ 4];
      dout[15] = din[ 1] ^ din[ 2] ^ din[ 7] ^ din[ 3];
      dout[14] = din[ 0] ^ din[ 1] ^ din[ 6] ^ din[ 2];
      dout[13] = din[ 8] ^ din[ 0] ^ din[ 4] ^ din[ 5] ^ din[ 1];
      dout[12] = din[ 7] ^ din[ 8] ^ din[ 3] ^ din[ 0];
      dout[11] = din[ 6] ^ din[ 7] ^ din[ 2] ^ din[ 8] ^ din[ 4];
      dout[10] = din[ 5] ^ din[ 6] ^ din[ 1] ^ din[ 7] ^ din[ 3];
      dout[ 9] = din[ 4] ^ din[ 5] ^ din[ 0] ^ din[ 6] ^ din[ 2];
      dout[ 8] = din[ 3] ^ din[ 8] ^ din[ 5] ^ din[ 1];
      dout[ 7] = din[ 2] ^ din[ 4] ^ din[ 7] ^ din[ 0];
      dout[ 6] = din[ 1] ^ din[ 3] ^ din[ 6] ^ din[ 8] ^ din[ 4];
      dout[ 5] = din[ 0] ^ din[ 2] ^ din[ 5] ^ din[ 7] ^ din[ 3];
      dout[ 4] = din[ 8] ^ din[ 1] ^ din[ 6] ^ din[ 2];
      dout[ 3] = din[ 7] ^ din[ 0] ^ din[ 5] ^ din[ 1];
      dout[ 2] = din[ 6] ^ din[ 8] ^ din[ 0];
      dout[ 1] = din[5] ^ din[7] ^ din[8] ^ din[4];
      dout[ 0] = din[4] ^ din[6] ^ din[7] ^ din[3];
      pn9 = dout;
    end
  endfunction

  always @(posedge pclk) begin
    trig_d <= trig;
    fx32dma_eop <= 1'b0;
    internal_trig <= trig & ~trig_d;
    if (transaction_in_progress == 1'b0) begin
      transaction_in_progress <= trig & ~trig_d;
    end else begin
      if (internal_counter >= data_size + 12) begin
        transaction_in_progress = 1'b0;
        fx32dma_eop <= 1'b1;
      end
    end
  end

  always @(posedge pclk) begin
    if (internal_trig == 1'b1 )begin
      internal_counter <= 4;
      packet_number <= packet_number + 1;
    end else if (transaction_in_progress == 1'b1) begin
      internal_counter <= internal_counter + 4;
    end else begin
      internal_counter <= 0;
    end
  end

  always @(packet_number) begin
    case (packet_number)
      0: data_size = 1;
      1: data_size = 2;
      2: data_size = 3;
      3: data_size = 4;
      4: data_size = 512;
      5: data_size = 1024;
      6: data_size = 32767;
      7: data_size = 32768;
      default: data_size = 16;
    endcase
  end

  always@(internal_counter, data_size, internal_counter, generated_data) begin
    case (internal_counter)
      5'h0: fx32dma_data <= 32'hf00ff00f;
      5'h4: fx32dma_data <= data_size;
      5'h8: fx32dma_data <= 0;
      5'hc: fx32dma_data <= 32'hffffffff;
      default: fx32dma_data <= generated_data;
    endcase
  end

  always @(posedge pclk) begin
    if (fx32dma_sop == 1'b1) begin
      if (test_mode_tpm == 3'h1) begin
        generated_data <= 32'haaaaaaaa;
      end else begin
        generated_data <= 32'hffffffff;
      end
    end else begin
      case(test_mode_tpm)
        4'h0: generated_data <= generated_data + 32'h10;
        4'h1: generated_data <= ~generated_data;
        4'h2: generated_data <= ~generated_data;
        4'h3: generated_data <= pn9(generated_data);
        4'h4: generated_data <= pn23(generated_data);
        4'h7: generated_data <= generated_data + 1;
        default: generated_data <= generated_data + 32'h10;
      endcase
    end
  end
  // dma2fx3

  assign dma2fx3_ready = 1'b1;
  assign data = dma2fx3_data;
  assign pktend_n = ~dma2fx3_eop;
  assign slwr_n = ~dma2fx3_valid;

endmodule

// ***************************************************************************
// ***************************************************************************
