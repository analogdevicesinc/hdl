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

module dma_write_shutdown_tb;
  parameter VCD_FILE = {"dma_write_shutdown_tb.vcd"};

  `include "tb_base.v"

  localparam TRANSFER_ADDR = 32'h80000000;
  localparam TRANSFER_LEN = 24'h2ff;

  reg fifo_clk = 1'b0;

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
  wire [3:0] wstrb;
  wire [31:0] wdata;

  wire bready;
  wire bvalid;
  wire [1:0] bresp;

  wire [11:0] dbg_status;

  /* Twice as fast as the AXI clk so the FIFO fills up */
  always @(*) #5 fifo_clk <= ~fifo_clk;

  axi_write_slave #(
    .DATA_WIDTH(32)
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

  reg ctrl_enable = 1'b0;

  initial begin
    #1000
    @(posedge clk) ctrl_enable <= 1'b1;
    #3000
    @(posedge clk) ctrl_enable <= 1'b0;
  end

  always @(posedge clk) begin
    failed <= ctrl_enable == 1'b0 && (
        dbg_status !== 12'h701 ||
        i_write_slave.i_axi_slave.req_fifo_level !== 'h00);
  end

  axi_dmac_transfer #(
    .DMA_DATA_WIDTH_SRC(32),
    .DMA_DATA_WIDTH_DEST(32),
    .FIFO_SIZE(8),
    .DMA_LENGTH_ALIGN(2)
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

    .ctrl_enable(ctrl_enable),
    .ctrl_pause(1'b0),

    .req_eot(),
    .req_response_ready(1'b1),

    .req_valid(1'b1),
    .req_ready(),
    .req_dest_address(TRANSFER_ADDR[31:2]),
    .req_src_address(TRANSFER_ADDR[31:2]),
    .req_x_length(TRANSFER_LEN),
    .req_y_length(24'h00),
    .req_dest_stride(24'h00),
    .req_src_stride(24'h00),
    .req_sync_transfer_start(1'b0),
    .req_sync(1'b1),
    .req_last(1'b0),

    .fifo_wr_clk(fifo_clk),
    .fifo_wr_en(1'b1),
    .fifo_wr_din(32'h00),
    .fifo_wr_xfer_req(),

    .dbg_status(dbg_status));

endmodule
