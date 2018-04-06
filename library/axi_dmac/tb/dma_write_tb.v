// ***************************************************************************
// ***************************************************************************
// Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
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

module dmac_dma_write_tb;
  parameter VCD_FILE = {`__FILE__,"cd"};

  `include "tb_base.v"

  reg req_valid = 1'b1;
  wire req_ready;
  reg [23:0] req_length = 'h03;
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

  reg [31:0] fifo_wr_din = 'b0;
  reg fifo_wr_rq = 'b0;
  wire fifo_wr_xfer_req;

  wire bready;
  wire bvalid;
  wire [1:0] bresp;

  always @(posedge clk) begin
    if (reset != 1'b1 && req_ready == 1'b1) begin
      req_valid <= 1'b1;
      req_length <= req_length + 'h4;
    end
  end

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
    .bresp(bresp)
  );

  dmac_request_arb #(
    .DMA_DATA_WIDTH_SRC(32),
    .DMA_DATA_WIDTH_DEST(32)
  ) request_arb (
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

    .req_aclk(clk),
    .req_aresetn(resetn),

    .enable(1'b1),
    .pause(1'b0),

    .eot(eot),

    .req_valid(req_valid),
    .req_ready(req_ready),
    .req_dest_address(30'h7e09000),
    .req_length(req_length),
    .req_sync_transfer_start(1'b0),

    .fifo_wr_clk(clk),
    .fifo_wr_en(fifo_wr_en),
    .fifo_wr_din(fifo_wr_din),
    .fifo_wr_overflow(fifo_wr_overflow),
    .fifo_wr_sync(1'b1),
    .fifo_wr_xfer_req(fifo_wr_xfer_req)
  );

  always @(posedge clk) begin
    if (reset) begin
      fifo_wr_din <= 'b0;
      fifo_wr_rq <= 'b0;
    end else begin
      if (fifo_wr_en) begin
        fifo_wr_din <= fifo_wr_din + 'h4;
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
