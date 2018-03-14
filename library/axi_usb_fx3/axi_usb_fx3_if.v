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
// freedoms and responsibilities that he or she has by using this source/core.
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

`timescale 1ns/100ps

module axi_usb_fx3_if (

  input                   dma_rdy,
  input                   dma_wmk,

  input       [ 3:0]      fifo_rdy,

  input                   pclk,
  input                   reset_n,

  inout       [31:0]      data,
  output  reg [ 1:0]      addr,

  output  reg             slcs_n,
  output  reg             slrd_n,
  output  reg             sloe_n,
  output  reg             slwr_n,
  output  reg             pktend_n,
  output                  epswitch_n,

  input       [ 4:0]      fifo_num,
  input       [10:0]      fifo_direction,
  input                   trig,
  output  reg [10:0]      fifo_ready,

  output  reg             fx32dma_valid,
  input                   fx32dma_ready,
  output  reg [31:0]      fx32dma_data,
  output  reg             fx32dma_sop,
  input                   fx32dma_eop,
  input                   eot_fx32dma,

  output  reg             dma2fx3_ready,
  input                   dma2fx3_valid,
  input       [31:0]      dma2fx3_data,
  input                   dma2fx3_eop);

  // internal registers

  reg [ 3:0]  state_gpif_ii = 4'h0;
  reg [ 3:0]  next_state_gpif_ii = 4'h0;

  reg         current_direction = 0;
  reg         current_fifo = 0;
  reg         slcs_n_d1 = 0;
  reg         slcs_n_d2 = 0;
  reg         slcs_n_d3 = 0;
  reg         slcs_n_d4 = 0;
  reg         slrd_n_d1 = 0;
  reg         slrd_n_d2 = 0;
  reg         slrd_n_d3 = 0;
  reg         sloe_n_d1 = 0;
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
