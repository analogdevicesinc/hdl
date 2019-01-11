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

module util_adcfifo #(

  parameter   FPGA_TECHNOLOGY = 0,
  parameter   ADC_DATA_WIDTH = 256,
  parameter   DMA_DATA_WIDTH =  64,
  parameter   DMA_READY_ENABLE = 1,
  parameter   DMA_ADDRESS_WIDTH =  10) (

  // fifo interface

  input                                 adc_rst,
  input                                 adc_clk,
  input                                 adc_wr,
  input       [ADC_DATA_WIDTH-1:0]      adc_wdata,
  output                                adc_wovf,

  // dma interface

  input                                 dma_clk,
  output                                dma_wr,
  output      [DMA_DATA_WIDTH-1:0]      dma_wdata,
  input                                 dma_wready,
  input                                 dma_xfer_req,
  output      [ 3:0]                    dma_xfer_status);


  localparam  DMA_MEM_RATIO = ADC_DATA_WIDTH/DMA_DATA_WIDTH;
  localparam  ADDRESS_PADDING_WIDTH = (DMA_MEM_RATIO == 1) ? 0 :
                                      (DMA_MEM_RATIO == 2) ? 1 :
                                      (DMA_MEM_RATIO == 4) ? 2 : 3;
  localparam  ADC_ADDRESS_WIDTH = DMA_ADDRESS_WIDTH - ADDRESS_PADDING_WIDTH;
  localparam  ADC_ADDR_LIMIT = (2**ADC_ADDRESS_WIDTH)-1;
  localparam  DMA_ADDR_LIMIT = (2**DMA_ADDRESS_WIDTH)-1;

  // internal registers

  reg         [ 2:0]                    adc_xfer_req_m = 'd0;
  reg                                   adc_xfer_init = 'd0;
  reg                                   adc_xfer_enable = 'd0;
  reg                                   adc_wr_int = 'd0;
  reg         [ADC_DATA_WIDTH-1:0]      adc_wdata_int = 'd0;
  reg         [ADC_ADDRESS_WIDTH-1:0]   adc_waddr_int = 'd0;
  reg                                   adc_waddr_rel_t = 'd0;
  reg         [ADC_ADDRESS_WIDTH-1:0]   adc_waddr_rel = 'd0;
  reg                                   dma_rst = 'd0;
  reg         [ 2:0]                    dma_waddr_rel_t_m = 'd0;
  reg         [ADC_ADDRESS_WIDTH-1:0]   dma_waddr_rel = 'd0;
  reg                                   dma_rd = 'd0;
  reg                                   dma_rd_d = 'd0;
  reg         [DMA_DATA_WIDTH-1:0]      dma_rdata_d = 'd0;
  reg         [DMA_ADDRESS_WIDTH-1:0]   dma_raddr = 'd0;

  // internal signals

  wire                                  adc_rst_s;
  wire                                  dma_waddr_rel_t_s;
  wire        [DMA_ADDRESS_WIDTH-1:0]   dma_waddr_rel_s;
  wire                                  dma_wready_s;
  wire                                  dma_rd_s;
  wire        [DMA_DATA_WIDTH-1:0]      dma_rdata_s;

  // write interface

  assign adc_wovf = 1'd0;

  // synchronize the adc_rst to the adc_clk clock domain
  ad_rst i_adc_rst_sync (
    .rst_async (adc_rst),
    .clk (adc_clk),
    .rstn (),
    .rst (adc_rst_s));

  always @(posedge adc_clk) begin
    if (adc_rst_s == 1'b1) begin
      adc_xfer_req_m <= 'd0;
      adc_xfer_init <= 'd0;
      adc_xfer_enable <= 'd0;
    end else begin
      adc_xfer_req_m <= {adc_xfer_req_m[1:0], dma_xfer_req};
      adc_xfer_init <= adc_xfer_req_m[1] & ~adc_xfer_req_m[2];
      if (adc_xfer_init == 1'b1) begin
        adc_xfer_enable <= 1'b1;
      end else if ((adc_waddr_int >= ADC_ADDR_LIMIT - 1) ||
        (adc_xfer_req_m[2] == 1'b0)) begin
        adc_xfer_enable <= 1'b0;
      end
    end
  end

  always @(posedge adc_clk) begin
    if (adc_rst_s == 1'b1) begin
      adc_wr_int <= 'd0;
      adc_wdata_int <= 'd0;
      adc_waddr_int <= 'd0;
    end else begin
      if (adc_xfer_init == 1'b1) begin
        adc_wr_int <= 'd0;
        adc_wdata_int <= 'd0;
        adc_waddr_int <= 'd0;
      end else begin
        adc_wr_int <= adc_wr & adc_xfer_enable;
        adc_wdata_int <= adc_wdata;
        if (adc_wr_int == 1'b1) begin
          adc_waddr_int <= adc_waddr_int + 1'b1;
        end
      end
    end
  end

  always @(posedge adc_clk) begin
    if (adc_rst_s == 1'b1) begin
      adc_waddr_rel_t <= 'd0;
      adc_waddr_rel <= 'd0;
    end else begin
      if ((adc_wr_int == 1'b1) && (adc_waddr_int[2:0] == 3'h7)) begin
        adc_waddr_rel_t <= ~adc_waddr_rel_t;
        adc_waddr_rel <= adc_waddr_int;
      end
    end
  end

  // read interface

  assign dma_xfer_status = 4'd0;
  assign dma_waddr_rel_t_s = dma_waddr_rel_t_m[2] ^ dma_waddr_rel_t_m[1];
  assign dma_waddr_rel_s =  {dma_waddr_rel,{ADDRESS_PADDING_WIDTH{1'b0}}};

  always @(posedge dma_clk) begin
    dma_waddr_rel_t_m <= {dma_waddr_rel_t_m[1:0], adc_waddr_rel_t};
  end

  always @(posedge dma_clk) begin
    if (dma_xfer_req == 1'b0) begin
      dma_rst <= 1'b1;
      dma_waddr_rel <= 'd0;
    end else begin
      dma_rst <= 1'b0;
      if (dma_waddr_rel_t_s == 1'b1) begin
        dma_waddr_rel <= adc_waddr_rel;
      end
    end
  end

  assign dma_wready_s = (DMA_READY_ENABLE == 0) ? 1'b1 : dma_wready;
  assign dma_rd_s = (dma_raddr < dma_waddr_rel_s) ? dma_wready_s : 1'b0;

  always @(posedge dma_clk) begin
    if (dma_xfer_req == 1'b0) begin
      dma_rd <= 'd0;
      dma_rd_d <= 'd0;
      dma_rdata_d <= 'd0;
      dma_raddr <= 'd0;
    end else begin
      dma_rd <= dma_rd_s;
      dma_rd_d <= dma_rd;
      dma_rdata_d <= dma_rdata_s;
      if (dma_rd_s == 1'b1) begin
        dma_raddr <= dma_raddr + 1'b1;
      end
    end
  end

  // instantiations

  generate
  if (FPGA_TECHNOLOGY == 1) begin
  alt_mem_asym i_mem_asym (
    .mem_i_wrclock (adc_clk),
    .mem_i_wren (adc_wr_int),
    .mem_i_wraddress (adc_waddr_int),
    .mem_i_datain (adc_wdata_int),
    .mem_i_rdclock (dma_clk),
    .mem_i_rdaddress (dma_raddr),
    .mem_o_dataout (dma_rdata_s));
  end else begin
  ad_mem_asym #(
    .A_ADDRESS_WIDTH (ADC_ADDRESS_WIDTH),
    .A_DATA_WIDTH (ADC_DATA_WIDTH),
    .B_ADDRESS_WIDTH (DMA_ADDRESS_WIDTH),
    .B_DATA_WIDTH (DMA_DATA_WIDTH))
  i_mem_asym (
    .clka (adc_clk),
    .wea (adc_wr_int),
    .addra (adc_waddr_int),
    .dina (adc_wdata_int),
    .clkb (dma_clk),
    .reb (1'b1),
    .addrb (dma_raddr),
    .doutb (dma_rdata_s));
  end
  endgenerate

 ad_axis_inf_rx #(.DATA_WIDTH(DMA_DATA_WIDTH)) i_axis_inf (
    .clk (dma_clk),
    .rst (dma_rst),
    .valid (dma_rd_d),
    .last (1'd0),
    .data (dma_rdata_d),
    .inf_valid (dma_wr),
    .inf_last (),
    .inf_data (dma_wdata),
    .inf_ready (dma_wready));

endmodule

// ***************************************************************************
// ***************************************************************************
