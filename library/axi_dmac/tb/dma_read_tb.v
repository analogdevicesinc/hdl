// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2018-2023 Analog Devices, Inc. All rights reserved.
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

module dma_read_tb;
  parameter VCD_FILE = {"dma_read_tb.vcd"};
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
  wire [WIDTH_SRC-1:0] rdata;

  always @(posedge clk) begin
    if (reset != 1'b1 && req_ready == 1'b1) begin
      req_valid <= 1'b1;
      req_length <= req_length + REQ_LEN_INC;
    end
  end

  axi_read_slave #(
    .DATA_WIDTH(WIDTH_SRC)
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
    .rlast(rlast));

  wire fifo_rd_en = 1'b1;
  wire fifo_rd_valid;
  wire fifo_rd_underflow;
  wire [WIDTH_DEST-1:0] fifo_rd_dout;
  reg [WIDTH_DEST-1:0] fifo_rd_dout_cmp = 'h00;
  reg fifo_rd_dout_mismatch = 1'b0;
  reg [23:0] fifo_rd_req_length = REQ_LEN_INIT;
  reg [23:0] fifo_rd_beat_counter = 'h00;

  axi_dmac_transfer #(
    .DMA_TYPE_SRC(0),
    .DMA_TYPE_DEST(2),
    .DMA_DATA_WIDTH_SRC(WIDTH_SRC),
    .DMA_DATA_WIDTH_DEST(WIDTH_DEST),
    .DMA_LENGTH_ALIGN($clog2(WIDTH_DEST/8)),
    .FIFO_SIZE(8)
  ) transfer (
    .m_src_axi_aclk(clk),
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

    .ctrl_enable(1'b1),
    .ctrl_pause(1'b0),

    .req_eot(eot),

    .req_valid(req_valid),
    .req_ready(req_ready),
    .req_dest_address(TRANSFER_ADDR[31:$clog2(WIDTH_DEST/8)]),
    .req_src_address(TRANSFER_ADDR[31:$clog2(WIDTH_SRC/8)]),
    .req_x_length(req_length),
    .req_y_length(24'h00),
    .req_dest_stride(24'h00),
    .req_src_stride(24'h00),
    .req_sync_transfer_start(1'b0),

    .fifo_rd_clk(clk),
    .fifo_rd_en(fifo_rd_en),
    .fifo_rd_valid(fifo_rd_valid),
    .fifo_rd_underflow(fifo_rd_underflow),
    .fifo_rd_dout(fifo_rd_dout));

  always @(posedge clk) begin: dout
    integer i;

    if (reset == 1'b1) begin
      for (i = 0; i < WIDTH_DEST; i = i + 8) begin
        fifo_rd_dout_cmp[i+:8] <= TRANSFER_ADDR[7:0] + i / 8;
      end
      fifo_rd_dout_mismatch <= 1'b0;
      fifo_rd_req_length <= REQ_LEN_INIT;
      fifo_rd_beat_counter <= 'h00;
    end else begin
      fifo_rd_dout_mismatch <= 1'b0;

      if (fifo_rd_valid == 1'b1) begin
        if (fifo_rd_beat_counter + WIDTH_DEST / 8 < fifo_rd_req_length) begin
          for (i = 0; i < WIDTH_DEST; i = i + 8) begin
            fifo_rd_dout_cmp[i+:8] <= fifo_rd_dout_cmp[i+:8] + WIDTH_DEST / 8;
          end
          fifo_rd_beat_counter <= fifo_rd_beat_counter + WIDTH_DEST / 8;
        end else begin
          for (i = 0; i < WIDTH_DEST; i = i + 8) begin
            fifo_rd_dout_cmp[i+:8] <= TRANSFER_ADDR[7:0] + i / 8;
          end
          fifo_rd_beat_counter <= 'h00;
          fifo_rd_req_length <= fifo_rd_req_length + REQ_LEN_INC;
        end
        if (fifo_rd_dout_cmp != fifo_rd_dout) begin
          fifo_rd_dout_mismatch <= 1'b1;
        end
      end
    end
  end

  always @(posedge clk) begin
    failed <= failed | fifo_rd_dout_mismatch;
  end

endmodule
