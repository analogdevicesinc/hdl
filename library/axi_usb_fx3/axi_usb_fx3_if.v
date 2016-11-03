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
  reset_n,

  data,
  addr,          //output fifo address

  slcs_n,        //output chip select
  slrd_n,        //output read select
  sloe_n,        //output output enable select
  slwr_n,        //output write select
  pktend_n,      //output pkt end
  epswitch_n,    //output pkt end

  fifo_num,
  fifo_direction,
  trig,
  fifo_ready,

  fx32dma_valid,
  fx32dma_ready,
  fx32dma_data,
  fx32dma_sop,
  fx32dma_eop,
  eot_fx32dma,

  dma2fx3_ready,
  dma2fx3_valid,
  dma2fx3_data,
  dma2fx3_eop);

  input           pclk;
  input           reset_n;

  input           dma_rdy;
  input           dma_wmk;

  input   [ 3:0]  fifo_rdy;

  inout   [31:0]  data;
  output  [ 1:0]  addr;

  output          slcs_n;
  output          slrd_n;
  output          sloe_n;
  output          slwr_n;
  output          pktend_n;
  output          epswitch_n;

  output  [10:0]  fifo_ready;

  input   [ 4:0]  fifo_num;
  input   [10:0]  fifo_direction;
  input           trig;

  output          fx32dma_valid;
  input           fx32dma_ready;
  output  [31:0]  fx32dma_data;
  output          fx32dma_sop;
  input           fx32dma_eop;
  input           eot_fx32dma;

  input           dma2fx3_valid;
  output          dma2fx3_ready;
  input   [31:0]  dma2fx3_data;
  input           dma2fx3_eop;

  // internal registers

  reg [10:0]  fifo_ready = 0;

  reg [31:0]  fx32dma_data = 0;

  reg [ 3:0]  state_gpif_ii = 4'h0;
  reg [ 3:0]  next_state_gpif_ii = 4'h0;

  reg         current_direction = 0;
  reg         current_fifo = 0;
  reg         slcs_n = 0;
  reg         slcs_n_d1 = 0;
  reg         slcs_n_d2 = 0;
  reg         slcs_n_d3 = 0;
  reg         slcs_n_d4 = 0;
  reg         slrd_n = 0;
  reg         slrd_n_d1 = 0;
  reg         slrd_n_d2 = 0;
  reg         slrd_n_d3 = 0;
  reg         sloe_n = 0;
  reg [ 1:0]  addr = 0;
  reg         sloe_n_d1 = 0;
  reg         slwr_n = 0;
  reg         fx32dma_valid = 0;
  reg         dma2fx3_ready = 0;
  reg         fx32dma_sop = 0;
  reg         pktend_n = 0;
  reg         pip = 0;

  localparam IDLE         = 4'b0001;
  localparam READ_START   = 4'b0010;
  localparam READ_DATA    = 4'b0100;
  localparam WRITE_DATA   = 4'b1000;

  assign data = (state_gpif_ii == WRITE_DATA && dma2fx3_valid && current_fifo) ? dma2fx3_data  : 32'hz;
  assign epswitch_n = 1'b1;

  always @(fifo_num, fifo_rdy, fifo_direction) begin
    case(fifo_num)
      5'h0: begin
        current_direction = fifo_direction[0];
        current_fifo      = fifo_rdy[0];
      end
      5'h1: begin
        current_direction = fifo_direction[1];
        current_fifo      = fifo_rdy[1];
      end
      5'h2: begin
        current_direction = fifo_direction[2];
        current_fifo      = fifo_rdy[2];
      end
      5'h3: begin
        current_direction = fifo_direction[3];
        current_fifo      = fifo_rdy[3];
      end
      5'h4: begin
        current_direction = fifo_direction[4];
        current_fifo      = fifo_rdy[0];
      end
      5'h5: begin
        current_direction = fifo_direction[5];
        current_fifo      = fifo_rdy[0];
      end
      5'h6: begin
        current_direction = fifo_direction[6];
        current_fifo      = fifo_rdy[0];
      end
      5'h7: begin
        current_direction = fifo_direction[7];
        current_fifo      = fifo_rdy[0];
      end
      5'h8: begin
        current_direction = fifo_direction[8];
        current_fifo      = fifo_rdy[0];
      end
      5'h9: begin
        current_direction = fifo_direction[9];
        current_fifo      = fifo_rdy[0];
      end
      default: begin
        current_direction = 0;
        current_fifo      = fifo_rdy[0];
      end
    endcase
  end

  // STATE MACHINE GPIF II
  always @(posedge pclk) begin
    if (reset_n == 1'b0 || trig == 1'b0 ) begin
      state_gpif_ii <= IDLE;
    end else begin
      state_gpif_ii <= next_state_gpif_ii;
    end
  end

  always @(*) begin
    case(state_gpif_ii)
      IDLE:
        if(trig == 1'b1 && current_fifo == 1'b1) begin
          if (current_direction == 0) begin
            next_state_gpif_ii = READ_START;
          end else begin
            next_state_gpif_ii = WRITE_DATA;
          end
        end else begin
          next_state_gpif_ii = IDLE;
        end
      READ_START:
          next_state_gpif_ii = READ_DATA;
      READ_DATA:
        if (eot_fx32dma == 1'b1) begin
          next_state_gpif_ii = IDLE;
        end else begin
          next_state_gpif_ii = READ_DATA;
        end
      WRITE_DATA:
        if(dma2fx3_eop == 1'b1) begin
          next_state_gpif_ii = IDLE;
        end else begin
          next_state_gpif_ii = WRITE_DATA;
        end
      default: next_state_gpif_ii = IDLE;
    endcase
  end

  always @(*) begin
    case(state_gpif_ii)
      IDLE: begin
        slcs_n        = 1'b1;
        sloe_n        = 1'b1;
        slrd_n        = 1'b1;
        fx32dma_valid = 1'b0;
        fx32dma_sop   = 1'b0;
        fx32dma_data  = 32'h0;
        slwr_n        = 1'b1;
        pktend_n      = 1'b1;
        dma2fx3_ready = 1'b0;
      end
      READ_START: begin
        slcs_n        = 1'b0;
        sloe_n        = 1'b0;
        slrd_n        = 1'b1;
        fx32dma_valid = 1'b0;
        fx32dma_sop   = 1'b0;
        fx32dma_data  = 32'h0;
        slwr_n        = 1'b1;
        pktend_n      = 1'b1;
        dma2fx3_ready = 1'b0;
      end
      READ_DATA: begin
        slcs_n        = 1'b0;
        sloe_n        = 1'b0;
        slrd_n        = !fx32dma_ready | fx32dma_eop;
        fx32dma_valid = !slcs_n_d4 & !slrd_n_d3;
        fx32dma_sop   = !slcs_n_d4 & !slrd_n_d3 & pip;
        fx32dma_data  = data;
        slwr_n        = 1'b1;
        pktend_n      = 1'b1;
        dma2fx3_ready = 1'b0;
      end
      WRITE_DATA: begin
        slcs_n        = 1'b0;
        sloe_n        = 1'b1;
        slrd_n        = 1'b1;
        fx32dma_valid = 1'b0;
        fx32dma_sop   = 1'b0;
        fx32dma_data  = 32'h0;
        slwr_n        = !dma2fx3_valid | !current_fifo;
        dma2fx3_ready = current_fifo;
        pktend_n      = !dma2fx3_eop;
      end
      default: begin
        slcs_n        = 1'b1;
        sloe_n        = 1'b1;
        slrd_n        = 1'b1;
        fx32dma_valid = 1'b0;
        fx32dma_sop   = 1'b0;
        fx32dma_data  = 32'h0;
        slwr_n        = 1'b1;
        pktend_n      = 1'b1;
        dma2fx3_ready = 1'b0;
      end
    endcase
  end

  always @(posedge pclk) begin
    fifo_ready <= {7'h0,fifo_rdy};
    slrd_n_d1     <= slrd_n;
    slrd_n_d2     <= slrd_n_d1;
    slrd_n_d3     <= slrd_n_d2;
    slcs_n_d1     <= slcs_n;
    slcs_n_d2     <= slcs_n_d1;
    slcs_n_d3     <= slcs_n_d2;
    slcs_n_d4     <= slcs_n_d3;
    addr          <= fifo_num[1:0];
    if (state_gpif_ii == IDLE) begin
      pip <= 1'b1;
    end else begin
      if (fx32dma_sop == 1'b1) begin
        pip <= 1'b0;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
