// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2018 (c) Analog Devices, Inc. All rights reserved.
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

module dmac_dma_read_shutdown_tb;
  parameter VCD_FILE = {`__FILE__,"cd"};

  `include "tb_base.v"

  localparam TRANSFER_ADDR = 32'h80000000;
  localparam TRANSFER_LEN = 24'h2ff;

  reg fifo_clk = 1'b0;

  wire awvalid;
  wire awready;
  wire [31:0] araddr;
  wire [7:0] arlen;
  wire [2:0] arsize;
  wire [1:0] arburst;
  wire [2:0] arprot;
  wire [3:0] arcache;

  wire rlast;
  wire rvalid;
  wire rready;
  wire [1:0] rresp;
  wire [31:0] rdata;

  /* Twice as fast as the AXI clk so we have lots of read requests */
  always @(*) #5 fifo_clk <= ~fifo_clk;

  axi_read_slave #(
    .DATA_WIDTH(32)
  ) i_read_slave (
    .clk(clk),
    .reset(reset),

    .arvalid(arvalid),
    .arready(arready),
    .araddr(araddr),
    .arlen(arlen),
    .arsize(arsize),
    .arburst(arburst),
    .arprot(arprot),
    .arcache(arcache),

    .rready(rready),
    .rvalid(rvalid),
    .rdata(rdata),
    .rresp(rresp),
    .rlast(rlast)
  );

  wire [11:0] dbg_status;

  reg ctrl_enable = 1'b0;

  initial begin
    #1000
    @(posedge clk) ctrl_enable <= 1'b1;
    #3000
    @(posedge clk) ctrl_enable <= 1'b0;
  end

  always @(posedge clk) begin
    /*
     * When disabled the DMA should eventually end up in an idle state and all
     * requests that were sent out need to be accepted
     */
    failed <= ctrl_enable == 1'b0 && (
      dbg_status !== 12'h701 ||
      i_read_slave.i_axi_slave.req_fifo_level !== 'h00);
  end

  axi_dmac_transfer #(
    .DMA_TYPE_SRC(0),
    .DMA_TYPE_DEST(2),
    .DMA_DATA_WIDTH_SRC(32),
    .DMA_DATA_WIDTH_DEST(32),
    .FIFO_SIZE(8),
    .DMA_LENGTH_ALIGN(2)
  ) i_transfer (
    .m_src_axi_aclk (clk),
    .m_src_axi_aresetn(resetn),

    .m_axi_arvalid(arvalid),
    .m_axi_arready(arready),
    .m_axi_araddr(araddr),
    .m_axi_arlen(arlen),
    .m_axi_arsize(arsize),
    .m_axi_arburst(arburst),
    .m_axi_arprot(arprot),
    .m_axi_arcache(arcache),

    .m_axi_rready(rready),
    .m_axi_rvalid(rvalid),
    .m_axi_rdata(rdata),
    .m_axi_rlast(rlast),
    .m_axi_rresp(rresp),

    .ctrl_clk(clk),
    .ctrl_resetn(resetn),

    .ctrl_enable(ctrl_enable),
    .ctrl_pause(1'b0),

    .req_eot(),

    .req_valid(1'b1),
    .req_ready(),
    .req_dest_address(TRANSFER_ADDR[31:2]),
    .req_src_address(TRANSFER_ADDR[31:2]),
    .req_x_length(TRANSFER_LEN),
    .req_y_length(24'h00),
    .req_dest_stride(24'h00),
    .req_src_stride(24'h00),
    .req_sync_transfer_start(1'b0),
    .req_last(1'b0),

    .fifo_rd_clk(fifo_clk),
    .fifo_rd_en(1'b1),
    .fifo_rd_valid(),
    .fifo_rd_underflow(),
    .fifo_rd_dout(),

    .dbg_status(dbg_status)
  );

endmodule
