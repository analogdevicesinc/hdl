// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
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

module axi_selmap #(
  parameter DATA_WIDTH = 8,
  parameter CLK_DIV = 91,
  parameter FIFO_DEPTH = (CLK_DIV <= 2) ? 4 : 2 ** $clog2(CLK_DIV)
) (

  // select map interface
  output  [DATA_WIDTH-1:0] data,
  output                   cclk,
  output                   program_b,
  output                   rdwr_b,
  output                   csi_b,
  input                    init_b,
  input                    done,

  // axi interface
  input                    s_axi_aclk,
  input                    s_axi_aresetn,
  input                    s_axi_awvalid,
  input   [15:0]           s_axi_awaddr,
  input   [ 2:0]           s_axi_awprot,
  output                   s_axi_awready,
  input                    s_axi_wvalid,
  input   [31:0]           s_axi_wdata,
  input   [ 3:0]           s_axi_wstrb,
  output                   s_axi_wready,
  output                   s_axi_bvalid,
  output  [ 1:0]           s_axi_bresp,
  input                    s_axi_bready,
  input                    s_axi_arvalid,
  input   [15:0]           s_axi_araddr,
  input   [ 2:0]           s_axi_arprot,
  output                   s_axi_arready,
  output                   s_axi_rvalid,
  output  [ 1:0]           s_axi_rresp,
  output  [31:0]           s_axi_rdata,
  input                    s_axi_rready
);

  // internal signals
  wire           up_clk;
  wire           up_rstn;
  wire           up_rreq_s;
  wire           up_wack_s;
  wire           up_rack_s;
  wire   [13:0]  up_raddr_s;
  wire   [31:0]  up_rdata_s;
  wire           up_wreq_s;
  wire   [13:0]  up_waddr_s;
  wire   [31:0]  up_wdata_s;

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  wire                    up_reset;
  wire   [DATA_WIDTH-1:0] up_data;
  wire                    up_data_written;
  wire                    up_csi_b;
  wire                    up_program_b;
  wire   [DATA_WIDTH-1:0] up_data_swapped;
  wire                    up_fifo_full;
  reg                     up_init_b;
  reg                     up_device_ready;
  reg                     up_done;
  reg                     prev_init_b;

  always @(posedge up_clk) begin
    if (!up_rstn || !up_reset) begin
      up_done <= 1'b0;
      prev_init_b <= 1'b1;
      up_init_b <= 1'b1;
      up_device_ready <= 1'b0;
    end else begin
      up_done <= done;
      up_init_b <= init_b;
      prev_init_b <= up_init_b;
    end

    if (prev_init_b && !up_init_b) begin
      up_device_ready <= 1'b1;
    end
  end

  axi_selmap_regmap #(
    .DATA_WIDTH (DATA_WIDTH)
  ) i_regmap (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s),
    .device_ready (up_device_ready),
    .done (up_done),
    .fifo_full (up_fifo_full),
    .reset (up_reset),
    .data (up_data),
    .data_written (up_data_written),
    .csi_b (up_csi_b),
    .program_b (up_program_b));

  // A write to the data register is held off while the FIFO is full, so a
  // processor writing back to back cannot overflow it. The FIFO frees a slot
  // every CCLK period, which bounds the stall.

  wire up_data_stall = up_fifo_full & (s_axi_awaddr[15:2] == 14'h6);

  up_axi  #(
    .AXI_ADDRESS_WIDTH (16)
  ) i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid & ~up_data_stall),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid & ~up_data_stall),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

  assign rdwr_b    = 1'b0;
  assign csi_b     = up_csi_b;
  assign program_b = up_program_b;

  /* Selmap bit mapping */
  genvar i;
  generate if (DATA_WIDTH >= 8) begin
    for (i = 0; i < 8; i = i + 1) begin
      assign up_data_swapped[7-i] = up_data[i];
    end
  end
  endgenerate
  generate if (DATA_WIDTH >= 16) begin
    for (i = 0; i < 8; i = i + 1) begin
      assign up_data_swapped[15-i] = up_data[8+i];
    end
  end
  endgenerate
  generate if (DATA_WIDTH == 32) begin
    for (i = 0; i < 8; i = i + 1) begin
      assign up_data_swapped[23-i] = up_data[16+i];
      assign up_data_swapped[31-i] = up_data[24+i];
    end
  end
  endgenerate

  /* Divided CCLK: the written bytes are buffered and sent one per CCLK period */
  generate if (CLK_DIV > 1) begin: g_cclk_div

    localparam COUNT_WIDTH = $clog2(CLK_DIV);

    reg  [COUNT_WIDTH-1:0] period_count = 'd0;
    reg                    period_has_byte = 1'b0;
    reg                    cclk_div = 1'b0;
    reg  [DATA_WIDTH-1:0]  cclk_data = 'd0;
    reg                    byte_popped = 1'b0;

    wire                   cclk_resetn;
    wire [COUNT_WIDTH-1:0] period_count_next;
    wire                   period_end;
    wire                   period_has_byte_next;
    wire                   fifo_valid;
    wire [DATA_WIDTH-1:0]  fifo_data;

    // A soft reset also drops the bytes that are still buffered

    assign cclk_resetn = up_rstn & up_reset;

    util_axis_fifo #(
      .DATA_WIDTH (DATA_WIDTH),
      .ADDRESS_WIDTH ($clog2(FIFO_DEPTH)),
      .ASYNC_CLK (0),
      .M_AXIS_REGISTERED (1),
      .ALMOST_EMPTY_THRESHOLD (0),
      .ALMOST_FULL_THRESHOLD (0)
    ) i_fifo (
      .m_axis_aclk (up_clk),
      .m_axis_aresetn (cclk_resetn),
      .m_axis_ready (period_end),
      .m_axis_valid (fifo_valid),
      .m_axis_data (fifo_data),
      .m_axis_tkeep (),
      .m_axis_tlast (),
      .m_axis_level (),
      .m_axis_empty (),
      .m_axis_almost_empty (),
      .s_axis_aclk (up_clk),
      .s_axis_aresetn (cclk_resetn),
      .s_axis_ready (),
      .s_axis_valid (up_data_written),
      .s_axis_data (up_data_swapped),
      .s_axis_tkeep ({DATA_WIDTH/8{1'b1}}),
      .s_axis_tlast (1'b0),
      .s_axis_room (),
      .s_axis_full (up_fifo_full),
      .s_axis_almost_full ());

    assign period_end = (period_count == CLK_DIV - 1);
    assign period_count_next = period_end ? 'd0 : period_count + 1'b1;

    always @(posedge up_clk) begin
      period_count <= period_count_next;
    end

    always @(posedge up_clk) begin
      if (!cclk_resetn) begin
        byte_popped <= 1'b0;
      end else begin
        byte_popped <= period_end & fifo_valid;
      end
      if (period_end & fifo_valid) begin
        cclk_data <= fifo_data;
      end
    end

    assign period_has_byte_next = byte_popped | (period_has_byte & ~period_end);

    always @(posedge up_clk) begin
      if (!cclk_resetn) begin
        period_has_byte <= 1'b0;
      end else begin
        period_has_byte <= period_has_byte_next;
      end
    end

    // CCLK is high in the second half of a period that has a byte, so the byte
    // is stable for half a period before and after the CCLK rising edge

    always @(posedge up_clk) begin
      if (!cclk_resetn) begin
        cclk_div <= 1'b0;
      end else begin
        cclk_div <= (period_count_next >= CLK_DIV / 2) & period_has_byte_next;
      end
    end

    assign data = cclk_data;
    assign cclk = cclk_div;

  end else begin: g_cclk_direct

    assign data = up_data_swapped;
    assign cclk = up_clk & up_data_written;
    assign up_fifo_full = 1'b0;

  end
  endgenerate
endmodule
