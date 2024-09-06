// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2018-2024 Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module dma_write_tb;
  parameter VCD_FILE = {"dma_write_tb.vcd"};
  parameter WIDTH_DEST = 32;
  parameter WIDTH_SRC = 32;
  parameter REQ_LEN_INC = 4;
  parameter REQ_LEN_INIT = 4;

  `include "tb_base.v"

  localparam TRANSFER_ADDR = 32'h80000000;

  reg req_valid = 1'b1;
  wire req_ready;
  reg [23:0] req_length = REQ_LEN_INIT - 1;
  wire awvalid;
  wire awready;
  wire [31:0] awaddr;
  wire [7:0] awlen;
  wire [2:0] awsize;
  wire [1:0] awburst;
  wire [2:0] awprot;
  wire [3:0] awcache;

  wire wlast;
  wire wvalid;
  wire wready;
  wire [WIDTH_DEST/8-1:0] wstrb;
  wire [WIDTH_DEST-1:0] wdata;

  reg [WIDTH_SRC-1:0] fifo_wr_din = 'b0;
  reg fifo_wr_rq = 'b0;
  wire fifo_wr_xfer_req;

  wire bready;
  wire bvalid;
  wire [1:0] bresp;

  always @(posedge clk) begin
    if (reset != 1'b1 && req_ready == 1'b1) begin
      req_valid <= 1'b1;
      req_length <= req_length + REQ_LEN_INC;
    end
  end

  axi_write_slave #(
    .DATA_WIDTH(WIDTH_DEST)
  ) i_write_slave (
    .clk(clk),
    .reset(reset),

    .awvalid(awvalid),
    .awready(awready),
    .awaddr(awaddr),
    .awlen(awlen),
    .awsize(awsize),
    .awburst(awburst),
    .awprot(awprot),
    .awcache(awcache),

    .wready(wready),
    .wvalid(wvalid),
    .wdata(wdata),
    .wstrb(wstrb),
    .wlast(wlast),

    .bvalid(bvalid),
    .bready(bready),
    .bresp(bresp));

  axi_dmac_transfer #(
    .DMA_DATA_WIDTH_SRC(WIDTH_SRC),
    .DMA_DATA_WIDTH_DEST(WIDTH_DEST),
    .DMA_LENGTH_ALIGN($clog2(WIDTH_SRC/8))
  ) i_transfer (
    .m_dest_axi_aclk (clk),
    .m_dest_axi_aresetn(resetn),

    .m_axi_awvalid(awvalid),
    .m_axi_awready(awready),
    .m_axi_awaddr(awaddr),
    .m_axi_awlen(awlen),
    .m_axi_awsize(awsize),
    .m_axi_awburst(awburst),
    .m_axi_awprot(awprot),
    .m_axi_awcache(awcache),

    .m_axi_wready(wready),
    .m_axi_wvalid(wvalid),
    .m_axi_wdata(wdata),
    .m_axi_wstrb(wstrb),
    .m_axi_wlast(wlast),

    .m_axi_bvalid(bvalid),
    .m_axi_bready(bready),
    .m_axi_bresp(bresp),

    .ctrl_clk(clk),
    .ctrl_resetn(resetn),

    .ctrl_enable(1'b1),
    .ctrl_pause(1'b0),

    .req_eot(eot),
    .req_response_ready(1'b1),

    .req_valid(req_valid),
    .req_ready(req_ready),
    .req_dest_address(TRANSFER_ADDR[31:$clog2(WIDTH_DEST/8)]),
    .req_src_address(TRANSFER_ADDR[31:$clog2(WIDTH_SRC/8)]),
    .req_x_length(req_length),
    .req_y_length(24'h00),
    .req_dest_stride(24'h00),
    .req_src_stride(24'h00),
    .req_sync_transfer_start(1'b0),
    .req_sync(1'b1),

    .fifo_wr_clk(clk),
    .fifo_wr_en(fifo_wr_en),
    .fifo_wr_din(fifo_wr_din),
    .fifo_wr_overflow(fifo_wr_overflow),
    .fifo_wr_xfer_req(fifo_wr_xfer_req));

  always @(posedge clk) begin: fifo_wr
    integer i;

    if (reset == 1'b1) begin
      for (i = 0; i < WIDTH_SRC; i = i + 8) begin
        fifo_wr_din[i+:8] <= i / 8;
      end
      fifo_wr_rq <= 'b0;
    end else begin
      if (fifo_wr_en == 1'b1) begin
        for (i = 0; i < WIDTH_SRC; i = i + 8) begin
          fifo_wr_din[i+:8] <= fifo_wr_din[i+:8] + WIDTH_SRC / 8;
        end
      end
      fifo_wr_rq <= (($random % 4) == 0);
    end
  end

  assign fifo_wr_en = fifo_wr_rq & fifo_wr_xfer_req;

  always @(posedge clk) begin
    if (reset) begin
      failed <= 'b0;
    end else begin
      failed <= failed |
                i_write_slave.failed |
                fifo_wr_overflow;
    end
  end

endmodule
