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

module util_dacfifo #(

  parameter       ADDRESS_WIDTH = 6,
  parameter       DATA_WIDTH = 128) (

  // DMA interface

  input                   dma_clk,
  input                   dma_rst,
  input                   dma_valid,
  input       [(DATA_WIDTH-1):0]  dma_data,
  output  reg             dma_ready,
  input                   dma_xfer_req,
  input                   dma_xfer_last,

  // DAC interface

  input                   dac_clk,
  input                   dac_rst,
  input                   dac_valid,
  output  reg [(DATA_WIDTH-1):0]  dac_data,
  output  reg             dac_dunf,
  output  reg             dac_xfer_out,

  input                   bypass);


  localparam  FIFO_THRESHOLD_HI = {(ADDRESS_WIDTH){1'b1}} - 4;

  // internal registers

  reg                                 dma_init = 1'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dma_waddr = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dma_waddr_g = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dma_lastaddr_g = 'b0;
  reg                                 dma_bypass = 1'b0;
  reg                                 dma_bypass_m1 = 1'b0;
  reg                                 dma_xfer_req_d1 = 1'b0;
  reg                                 dma_xfer_req_d2 = 1'b0;
  reg                                 dma_xfer_out_fifo = 1'b0;

  reg     [(ADDRESS_WIDTH-1):0]       dac_raddr = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dac_waddr = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dac_waddr_m1 = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dac_waddr_m2 = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dac_addr_diff = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dac_lastaddr_m1 = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dac_lastaddr_m2 = 'b0;
  reg     [(ADDRESS_WIDTH-1):0]       dac_lastaddr = 'b0;
  reg                                 dac_mem_ready = 1'b0;
  reg                                 dac_xfer_req_m1 = 1'b0;
  reg                                 dac_xfer_req = 1'b0;
  reg                                 dac_xfer_req_d = 1'b0;
  reg                                 dac_xfer_out_fifo = 1'b0;
  reg                                 dac_xfer_out_fifo_m1 = 1'b0;
  reg                                 dac_xfer_out_fifo_d = 1'b0;
  reg                                 dac_bypass = 1'b0;
  reg                                 dac_bypass_m1 = 1'b0;

  // internal wires

  wire                                dma_rst_int_s;
  wire                                dma_wren_s;
  wire                                dma_xfer_posedge_s;
  wire                                dma_ready_bypass_s;
  wire    [(DATA_WIDTH-1):0]          dac_data_fifo_s;
  wire    [(DATA_WIDTH-1):0]          dac_data_bypass_s;
  wire    [ADDRESS_WIDTH:0]           dac_addr_diff_s;
  wire    [(ADDRESS_WIDTH-1):0]       dma_waddr_b2g_s;
  wire    [(ADDRESS_WIDTH-1):0]       dac_waddr_g2b_s;
  wire    [(ADDRESS_WIDTH-1):0]       dac_lastaddr_g2b_s;
  wire                                dac_mem_ren_s;
  wire                                dac_xfer_posedge_s;
  wire                                dac_rst_int_s;


  // internal reset generation

  always @(posedge dma_clk) begin
    dma_xfer_req_d1 <= dma_xfer_req;
    dma_xfer_req_d2 <= dma_xfer_req_d1;
  end
  assign dma_xfer_posedge_s = ~dma_xfer_req_d2 & dma_xfer_req_d1;

  // status register indicating that the module is in initialization phase

  always @(posedge dma_clk) begin
    if ((dma_rst == 1'b1) || (dma_xfer_last == 1'b1)) begin
      dma_init <= 1'b0;
    end else begin
      if (dma_xfer_posedge_s == 1'b1) begin
        dma_init <= 1'b1;
      end
    end
  end

  // if the module is not in initialization phase, it should go
  // into reset at a positive edge of dma_xfer_req

  assign dma_rst_int_s = dma_rst | (dma_xfer_posedge_s & ~dma_init);

  // DMA / Write interface

  // write address generation

  assign dma_wren_s = dma_valid & dma_ready;

  always @(posedge dma_clk) begin
    if(dma_rst_int_s == 1'b1) begin
      dma_waddr <= 'b0;
      dma_waddr_g <= 'b0;
      dma_xfer_out_fifo <= 1'b0;
    end else begin
      if (dma_wren_s == 1'b1) begin
        dma_waddr <= dma_waddr + 1'b1;
      end
      if (dma_xfer_last == 1'b1) begin
        dma_waddr <= 'b0;
        dma_xfer_out_fifo <= 1'b1;
      end
      dma_waddr_g <= dma_waddr_b2g_s;
    end
  end

  ad_b2g #(
    .DATA_WIDTH (ADDRESS_WIDTH))
  i_dma_waddr_b2g (
    .din (dma_waddr),
    .dout (dma_waddr_b2g_s));

  // save the last write address

  always @(posedge dma_clk) begin
    if (dma_rst_int_s == 1'b1) begin
      dma_lastaddr_g <= 'b0;
    end else begin
      if (dma_bypass == 1'b0) begin
        dma_lastaddr_g <= (dma_xfer_last == 1'b1)? dma_waddr_b2g_s : dma_lastaddr_g;
      end
    end
  end

  // DAC / Read interface

  always @(posedge dac_clk) begin
    dac_xfer_req_m1 <= dma_xfer_req;
    dac_xfer_req <= dac_xfer_req_m1;
    dac_xfer_req_d <= dac_xfer_req;
  end
  assign dac_xfer_posedge_s = ~dac_xfer_req_d & dac_xfer_req;

  // we can reset the DAC side at each positive edge of xfer_req, even if
  // sometimes the reset is redundant
  assign dac_rst_int_s = dac_xfer_req | dac_rst;

  assign dac_addr_diff_s = {1'b1, dac_waddr} - dac_raddr;

  // The memory module is ready if it's not empty
  always @(posedge dac_clk) begin
    if (dac_rst_int_s == 1'b1) begin
      dac_addr_diff <= 'b0;
      dac_waddr_m1 <= 'b0;
      dac_waddr_m2 <= 'b0;
      dac_waddr <= 'b0;
      dac_mem_ready <= 1'b0;
    end else begin
      dac_waddr_m1 <= dma_waddr_g;
      dac_waddr_m2 <= dac_waddr_m1;
      dac_waddr <= dac_waddr_g2b_s;
      dac_addr_diff <= dac_addr_diff_s[ADDRESS_WIDTH-1:0];
      if (dac_addr_diff > 0) begin
        dac_mem_ready <= 1'b1;
      end else begin
        dac_mem_ready <= 1'b0;
      end
    end
  end

  ad_g2b #(
    .DATA_WIDTH (ADDRESS_WIDTH))
  i_dac_waddr_g2b (
    .din (dac_waddr_m2),
    .dout (dac_waddr_g2b_s));

  // sync lastaddr to dac clock domain

  always @(posedge dac_clk) begin
    if (dac_rst_int_s == 1'b1) begin
      dac_lastaddr_m1 <= 1'b0;
      dac_lastaddr_m2 <= 1'b0;
      dac_xfer_out_fifo_m1 <= 1'b0;
      dac_xfer_out_fifo <= 1'b0;
      dac_xfer_out_fifo_d <= 1'b0;
    end else begin
      dac_lastaddr_m1 <= dma_lastaddr_g;
      dac_lastaddr_m2 <= dac_lastaddr_m1;
      dac_lastaddr <= dac_lastaddr_g2b_s;
      dac_xfer_out_fifo_m1 <= dma_xfer_out_fifo;
      dac_xfer_out_fifo <= dac_xfer_out_fifo_m1;
      if (dac_valid)
        dac_xfer_out_fifo_d <= dac_xfer_out_fifo;
    end
  end

  ad_g2b #(
    .DATA_WIDTH (ADDRESS_WIDTH))
  i_dac_lastaddr_g2b (
    .din (dac_lastaddr_m2),
    .dout (dac_lastaddr_g2b_s));

  // generate dac read address

  assign dac_mem_ren_s = (dac_bypass == 1'b1) ? (dac_valid & dac_mem_ready) :
                                                (dac_valid & dac_xfer_out_fifo);

  always @(posedge dac_clk) begin
    if (dac_rst_int_s == 1'b1) begin
      dac_raddr <= 'b0;
    end else begin
      if (dac_mem_ren_s == 1'b1) begin
        if (dac_lastaddr == 'b0 || dac_raddr != dac_lastaddr) begin
          dac_raddr <= dac_raddr + 1'b1;
        end else begin
          dac_raddr <= 'b0;
        end
      end
    end
  end

  // memory instantiation

  ad_mem #(
    .ADDRESS_WIDTH (ADDRESS_WIDTH),
    .DATA_WIDTH (DATA_WIDTH))
  i_mem_fifo (
    .clka (dma_clk),
    .wea (dma_wren_s),
    .addra (dma_waddr),
    .dina (dma_data),
    .clkb (dac_clk),
    .reb (1'b1),
    .addrb (dac_raddr),
    .doutb (dac_data_fifo_s));

  // define underflow
  // underflow make sense just if bypass is enabled

  always @(posedge dac_clk) begin
    if (dac_rst_int_s == 1'b1) begin
      dac_dunf <= 1'b0;
    end else begin
      dac_dunf <= (dac_bypass == 1'b1) ? (dac_valid & dac_xfer_req & ~dac_mem_ren_s) : 1'b0;
    end
  end

  // bypass logic

  util_dacfifo_bypass #(
    .DAC_DATA_WIDTH (DATA_WIDTH),
    .DMA_DATA_WIDTH (DATA_WIDTH)
  ) i_dacfifo_bypass (
    .dma_clk(dma_clk),
    .dma_data(dma_data),
    .dma_ready(dma_ready),
    .dma_ready_out(dma_ready_bypass_s),
    .dma_valid(dma_valid),
    .dma_xfer_req(dma_xfer_req),
    .dac_clk(dac_clk),
    .dac_rst(dac_rst),
    .dac_valid(dac_valid),
    .dac_data(dac_data_bypass_s),
    .dac_dunf(dac_dunf_bypass_s)
  );

  always @(posedge dma_clk) begin
    dma_bypass_m1 <= bypass;
    dma_bypass <= dma_bypass_m1;
  end

  always @(posedge dac_clk) begin
    dac_bypass_m1 <= bypass;
    dac_bypass <= dac_bypass_m1;
  end

  // the util_dacfifo is always ready for the DMA
  always @(posedge dma_clk) begin
    dma_ready <= (dma_bypass == 1'b1) ? dma_ready_bypass_s : 1'b1;
  end

  always @(posedge dac_clk) begin
    if (dac_valid) begin
      dac_data <= (dac_bypass == 1'b1) ? dac_data_bypass_s : dac_data_fifo_s;
    end
    // this signal along with the dac_valid validate the data coming out from the buffer
    dac_xfer_out <= (dac_bypass == 1'b1) ? dac_xfer_req : dac_xfer_out_fifo_d;
  end

endmodule

