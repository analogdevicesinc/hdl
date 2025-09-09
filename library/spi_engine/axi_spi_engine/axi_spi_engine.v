// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2015-2025 Analog Devices, Inc. All rights reserved.
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

module axi_spi_engine #(

  parameter CMD_FIFO_ADDRESS_WIDTH = 4,
  parameter SYNC_FIFO_ADDRESS_WIDTH = 4,
  parameter SDO_FIFO_ADDRESS_WIDTH = 5,
  parameter SDI_FIFO_ADDRESS_WIDTH = 5,
  parameter MM_IF_TYPE = 0,
  parameter ASYNC_SPI_CLK = 0,
  parameter NUM_OFFLOAD = 0,
  parameter OFFLOAD0_CMD_MEM_ADDRESS_WIDTH = 4,
  parameter OFFLOAD0_SDO_MEM_ADDRESS_WIDTH = 4,
  parameter ID = 0,
  parameter [15:0] DATA_WIDTH = 8,
  parameter [ 7:0] NUM_OF_SDI = 1,
  parameter CFG_INFO_0 = 0,
  parameter CFG_INFO_1 = 0,
  parameter CFG_INFO_2 = 0,
  parameter CFG_INFO_3 = 0
) (

  // Slave AXI interface

  input         s_axi_aclk,
  input         s_axi_aresetn,
  input         s_axi_awvalid,
  input  [15:0] s_axi_awaddr,
  output        s_axi_awready,
  input   [2:0] s_axi_awprot,
  input         s_axi_wvalid,
  input  [31:0] s_axi_wdata,
  input  [ 3:0] s_axi_wstrb,
  output        s_axi_wready,
  output        s_axi_bvalid,
  output [ 1:0] s_axi_bresp,
  input         s_axi_bready,
  input         s_axi_arvalid,
  input  [15:0] s_axi_araddr,
  output        s_axi_arready,
  input   [2:0] s_axi_arprot,
  output        s_axi_rvalid,
  input         s_axi_rready,
  output [ 1:0] s_axi_rresp,
  output [31:0] s_axi_rdata,

  // up interface

  input                           up_clk,
  input                           up_rstn,
  input                           up_wreq,
  input  [13:0]                   up_waddr,
  input  [31:0]                   up_wdata,
  output                          up_wack,
  input                           up_rreq,
  input  [13:0]                   up_raddr,
  output [31:0]                   up_rdata,
  output                          up_rack,

  output reg irq,

  // SPI signals

  input spi_clk,

  output spi_resetn,

  input cmd_ready,
  output cmd_valid,
  output [15:0] cmd_data,

  input sdo_data_ready,
  output sdo_data_valid,
  output [(DATA_WIDTH-1):0] sdo_data,

  output sdi_data_ready,
  input sdi_data_valid,
  input [(NUM_OF_SDI * DATA_WIDTH-1):0] sdi_data,

  output sync_ready,
  input sync_valid,
  input [7:0] sync_data,

  // Offload ctrl signals

  output offload0_cmd_wr_en,
  output [15:0] offload0_cmd_wr_data,

  output offload0_sdo_wr_en,
  output [(DATA_WIDTH-1):0] offload0_sdo_wr_data,

  output offload0_mem_reset,
  output offload0_enable,
  input offload0_enabled,

  output offload_sync_ready,
  input offload_sync_valid,
  input [7:0] offload_sync_data
);

  localparam PCORE_VERSION = 'h010503;
  localparam S_AXI = 0;
  localparam UP_FIFO = 1;

  wire clk;
  wire rstn;

  wire [CMD_FIFO_ADDRESS_WIDTH-1:0] cmd_fifo_room;
  wire cmd_fifo_almost_empty;
  wire up_cmd_fifo_almost_empty;

  wire [15:0] cmd_fifo_in_data;
  wire cmd_fifo_in_ready;
  wire cmd_fifo_in_valid;

  wire [SDO_FIFO_ADDRESS_WIDTH-1:0] sdo_fifo_room;
  wire sdo_fifo_almost_empty;
  wire up_sdo_fifo_almost_empty;

  wire [(DATA_WIDTH-1):0] sdo_fifo_in_data;
  wire sdo_fifo_in_ready;
  wire sdo_fifo_in_valid;

  wire sdi_fifo_out_data_msb_s;
  wire [SDI_FIFO_ADDRESS_WIDTH-1:0] sdi_fifo_level;
  wire sdi_fifo_almost_full;
  wire up_sdi_fifo_almost_full;

  wire [(NUM_OF_SDI * DATA_WIDTH-1):0] sdi_fifo_out_data;
  wire sdi_fifo_out_ready;
  wire sdi_fifo_out_valid;

  wire [7:0] sync_fifo_data;
  wire sync_fifo_valid;

  wire [7:0] offload_sync_fifo_data;
  wire offload_sync_fifo_valid;

  reg up_sw_reset = 1'b1;
  wire up_sw_resetn = ~up_sw_reset;

  reg  [31:0]                     up_rdata_ff = 'd0;
  reg                             up_wack_ff = 1'b0;
  reg                             up_rack_ff = 1'b0;
  wire                            up_wreq_s;
  wire                            up_rreq_s;
  wire [31:0]                     up_wdata_s;
  wire [13:0]                     up_waddr_s;
  wire [13:0]                     up_raddr_s;

  // Scratch register
  reg [31:0] up_scratch = 'h00;

  reg  [7:0] sync_id = 'h00;
  reg        sync_id_pending = 1'b0;

  reg  [7:0] offload_sync_id = 'h00;
  reg        offload_sync_id_pending = 1'b0;

  generate if (MM_IF_TYPE == S_AXI) begin

    // assign clock and reset

    assign clk = s_axi_aclk;
    assign rstn = s_axi_aresetn;

    // interface wrapper

    up_axi #(
      .AXI_ADDRESS_WIDTH (16)
    ) i_up_axi (
      .up_rstn(rstn),
      .up_clk(clk),
      .up_axi_awvalid(s_axi_awvalid),
      .up_axi_awaddr(s_axi_awaddr),
      .up_axi_awready(s_axi_awready),
      .up_axi_wvalid(s_axi_wvalid),
      .up_axi_wdata(s_axi_wdata),
      .up_axi_wstrb(s_axi_wstrb),
      .up_axi_wready(s_axi_wready),
      .up_axi_bvalid(s_axi_bvalid),
      .up_axi_bresp(s_axi_bresp),
      .up_axi_bready(s_axi_bready),
      .up_axi_arvalid(s_axi_arvalid),
      .up_axi_araddr(s_axi_araddr),
      .up_axi_arready(s_axi_arready),
      .up_axi_rvalid(s_axi_rvalid),
      .up_axi_rresp(s_axi_rresp),
      .up_axi_rdata(s_axi_rdata),
      .up_axi_rready(s_axi_rready),
      .up_wreq(up_wreq_s),
      .up_waddr(up_waddr_s),
      .up_wdata(up_wdata_s),
      .up_wack(up_wack_ff),
      .up_rreq(up_rreq_s),
      .up_raddr(up_raddr_s),
      .up_rdata(up_rdata_ff),
      .up_rack(up_rack_ff));

    assign up_rdata = 32'b0;
    assign up_rack = 1'b0;
    assign up_wack = 1'b0;

  end
  endgenerate

  generate if (MM_IF_TYPE == UP_FIFO) begin

    // assign clock and reset

    assign clk = up_clk;
    assign rstn = up_rstn;

    assign up_wreq_s = up_wreq;
    assign up_waddr_s = up_waddr;
    assign up_wdata_s = up_wdata;
    assign up_wack = up_wack_ff;
    assign up_rreq_s = up_rreq;
    assign up_raddr_s = up_raddr;
    assign up_rdata = up_rdata_ff;
    assign up_rack = up_rack_ff;

  end
  endgenerate

  // IRQ handling
  reg [4:0] up_irq_mask = 5'h0;
  wire [4:0] up_irq_source;
  wire [4:0] up_irq_pending;

  assign up_irq_source = {
    offload_sync_id_pending,
    sync_id_pending,
    up_sdi_fifo_almost_full,
    up_sdo_fifo_almost_empty,
    up_cmd_fifo_almost_empty
  };

  assign up_irq_pending = up_irq_mask & up_irq_source;

  always @(posedge clk) begin
    if (rstn == 1'b0)
      irq <= 1'b0;
    else
      irq <= |up_irq_pending;
    end

  always @(posedge clk) begin
    if (rstn == 1'b0) begin
      up_wack_ff <= 1'b0;
      up_scratch <= 'h00;
      up_sw_reset <= 1'b1;
    end else begin
      up_wack_ff <= up_wreq_s;
      if (up_wreq_s) begin
        case (up_waddr_s)
          8'h02: up_scratch <= up_wdata_s;
          8'h10: up_sw_reset <= up_wdata_s;
        endcase
      end
    end
  end

  reg offload0_enable_reg;
  reg offload0_mem_reset_reg;
  wire offload0_enabled_s;

  // the software reset should reset all the registers
  always @(posedge clk) begin
    if (up_sw_resetn == 1'b0) begin
      up_irq_mask <= 'h00;
      offload0_enable_reg <= 1'b0;
      offload0_mem_reset_reg <= 1'b0;
    end else begin
      if (up_wreq_s) begin
        case (up_waddr_s)
          8'h20: up_irq_mask <= up_wdata_s;
          8'h40: offload0_enable_reg <= up_wdata_s[0];
          8'h42: offload0_mem_reset_reg <= up_wdata_s[0];
        endcase
      end
    end
  end

  always @(posedge clk) begin
    if (rstn == 1'b0) begin
      up_rack_ff <= 'd0;
    end else begin
      up_rack_ff <= up_rreq_s;
    end
  end

  generate
  if (NUM_OF_SDI > 1) begin
    // Only the first two SDI data can be recovered through AXI regmap
    assign sdi_fifo_out_data_msb_s = sdi_fifo_out_data[DATA_WIDTH+:DATA_WIDTH];
  end else begin
    assign sdi_fifo_out_data_msb_s = sdi_fifo_out_data;
  end
  endgenerate

  reg [7:0] offload_sdo_mem_address_width = OFFLOAD0_SDO_MEM_ADDRESS_WIDTH;
  reg [7:0] offload_cmd_mem_address_width = OFFLOAD0_CMD_MEM_ADDRESS_WIDTH;
  reg [7:0] sdi_fifo_address_width = SDI_FIFO_ADDRESS_WIDTH;
  reg [7:0] sdo_fifo_address_width = SDO_FIFO_ADDRESS_WIDTH;
  reg [7:0] sync_fifo_address_width = SYNC_FIFO_ADDRESS_WIDTH;
  reg [7:0] cmd_fifo_address_width = CMD_FIFO_ADDRESS_WIDTH;
  always @(posedge clk) begin
    case (up_raddr_s)
      8'h00: up_rdata_ff <= PCORE_VERSION;
      8'h01: up_rdata_ff <= ID;
      8'h02: up_rdata_ff <= up_scratch;
      8'h03: up_rdata_ff <= {8'b0, NUM_OF_SDI, DATA_WIDTH};
      8'h04: up_rdata_ff <= {16'b0, offload_sdo_mem_address_width, offload_cmd_mem_address_width};
      8'h05: up_rdata_ff <= {sdi_fifo_address_width, sdo_fifo_address_width, sync_fifo_address_width, cmd_fifo_address_width};
      8'h10: up_rdata_ff <= up_sw_reset;
      8'h20: up_rdata_ff <= up_irq_mask;
      8'h21: up_rdata_ff <= up_irq_pending;
      8'h22: up_rdata_ff <= up_irq_source;
      8'h30: up_rdata_ff <= sync_id;
      8'h31: up_rdata_ff <= offload_sync_id;
      8'h34: up_rdata_ff <= cmd_fifo_room;
      8'h35: up_rdata_ff <= sdo_fifo_room;
      8'h36: up_rdata_ff <= (sdi_fifo_out_valid == 1) ? sdi_fifo_level + 1 : sdi_fifo_level; /* beacuse of first-word-fall-through */
      8'h3a: up_rdata_ff <= sdi_fifo_out_data[DATA_WIDTH-1:0];
      8'h3b: up_rdata_ff <= sdi_fifo_out_data_msb_s; /* store SDI's 32 bits MSB, if exists */
      8'h3c: up_rdata_ff <= sdi_fifo_out_data; /* PEEK register */
      8'h40: up_rdata_ff <= {offload0_enable_reg};
      8'h41: up_rdata_ff <= {offload0_enabled_s};
      8'h80: up_rdata_ff <= CFG_INFO_0;
      8'h81: up_rdata_ff <= CFG_INFO_1;
      8'h82: up_rdata_ff <= CFG_INFO_2;
      8'h83: up_rdata_ff <= CFG_INFO_3;
      default: up_rdata_ff <= 'h00;
    endcase
  end

  always @(posedge clk) begin
    if (up_sw_resetn == 1'b0) begin
      sync_id <= 'h00;
      sync_id_pending <= 1'b0;
    end else begin
      if (sync_fifo_valid == 1'b1) begin
        sync_id <= sync_fifo_data;
        sync_id_pending <= 1'b1;
      end else if (up_wreq_s == 1'b1 && up_waddr_s == 8'h21 && up_wdata_s[3] == 1'b1) begin
        sync_id_pending <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    if (up_sw_resetn == 1'b0) begin
      offload_sync_id <= 'h00;
      offload_sync_id_pending <= 1'b0;
    end else begin
      if (offload_sync_fifo_valid == 1'b1) begin
        offload_sync_id <= offload_sync_fifo_data;
        offload_sync_id_pending <= 1'b1;
      end else if (up_wreq_s == 1'b1 && up_waddr_s == 8'h21 && up_wdata_s[4] == 1'b1) begin
        offload_sync_id_pending <= 1'b0;
      end
    end
  end

  generate if (ASYNC_SPI_CLK) begin

    wire spi_reset;
    ad_rst i_spi_resetn (
      .rst_async(up_sw_reset),
      .clk(spi_clk),
      .rst(spi_reset),
      .rstn());
    assign spi_resetn = ~spi_reset;
  end else begin
    assign spi_resetn = ~up_sw_reset;
  end
  endgenerate

  assign cmd_fifo_in_valid = up_wreq_s == 1'b1 && up_waddr_s == 8'h38;
  assign cmd_fifo_in_data = up_wdata_s[15:0];

  util_axis_fifo #(
    .DATA_WIDTH(16),
    .ADDRESS_WIDTH(CMD_FIFO_ADDRESS_WIDTH),
    .ASYNC_CLK(ASYNC_SPI_CLK),
    .M_AXIS_REGISTERED(0),
    .ALMOST_EMPTY_THRESHOLD(1),
    .ALMOST_FULL_THRESHOLD(1)
  ) i_cmd_fifo (
    .s_axis_aclk(clk),
    .s_axis_aresetn(up_sw_resetn),
    .s_axis_ready(cmd_fifo_in_ready),
    .s_axis_valid(cmd_fifo_in_valid),
    .s_axis_data(cmd_fifo_in_data),
    .s_axis_room(cmd_fifo_room),
    .s_axis_tlast(1'b0),
    .s_axis_full(),
    .s_axis_almost_full(),
    .m_axis_aclk(spi_clk),
    .m_axis_aresetn(spi_resetn),
    .m_axis_ready(cmd_ready),
    .m_axis_valid(cmd_valid),
    .m_axis_data(cmd_data),
    .m_axis_tlast(),
    .m_axis_empty(),
    .m_axis_almost_empty(cmd_fifo_almost_empty),
    .m_axis_level());

  assign sdo_fifo_in_valid = up_wreq_s == 1'b1 && up_waddr_s == 8'h39;
  assign sdo_fifo_in_data = up_wdata_s[(DATA_WIDTH-1):0];

  util_axis_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ASYNC_CLK(ASYNC_SPI_CLK),
    .ADDRESS_WIDTH(SDO_FIFO_ADDRESS_WIDTH),
    .M_AXIS_REGISTERED(0),
    .ALMOST_EMPTY_THRESHOLD(1),
    .ALMOST_FULL_THRESHOLD(1)
  ) i_sdo_fifo (
    .s_axis_aclk(clk),
    .s_axis_aresetn(up_sw_resetn),
    .s_axis_ready(sdo_fifo_in_ready),
    .s_axis_valid(sdo_fifo_in_valid),
    .s_axis_data(sdo_fifo_in_data),
    .s_axis_room(sdo_fifo_room),
    .s_axis_tlast(1'b0),
    .s_axis_full(),
    .s_axis_almost_full(),
    .m_axis_aclk(spi_clk),
    .m_axis_aresetn(spi_resetn),
    .m_axis_ready(sdo_data_ready),
    .m_axis_valid(sdo_data_valid),
    .m_axis_data(sdo_data),
    .m_axis_tlast(),
    .m_axis_level(),
    .m_axis_empty(),
    .m_axis_almost_empty(sdo_fifo_almost_empty));

  assign sdi_fifo_out_ready = up_rreq_s == 1'b1 && up_raddr_s == 8'h3a;

  util_axis_fifo #(
    .DATA_WIDTH(NUM_OF_SDI * DATA_WIDTH),
    .ASYNC_CLK(ASYNC_SPI_CLK),
    .ADDRESS_WIDTH(SDI_FIFO_ADDRESS_WIDTH),
    .M_AXIS_REGISTERED(0),
    .ALMOST_EMPTY_THRESHOLD(1),
    .ALMOST_FULL_THRESHOLD(31)
  ) i_sdi_fifo (
    .s_axis_aclk(spi_clk),
    .s_axis_aresetn(spi_resetn),
    .s_axis_ready(sdi_data_ready),
    .s_axis_valid(sdi_data_valid),
    .s_axis_data(sdi_data),
    .s_axis_room(),
    .s_axis_tlast(),
    .s_axis_full(),
    .s_axis_almost_full(sdi_fifo_almost_full),
    .m_axis_aclk(clk),
    .m_axis_aresetn(up_sw_resetn),
    .m_axis_ready(sdi_fifo_out_ready),
    .m_axis_valid(sdi_fifo_out_valid),
    .m_axis_data(sdi_fifo_out_data),
    .m_axis_tlast(),
    .m_axis_level(sdi_fifo_level),
    .m_axis_empty(),
    .m_axis_almost_empty());

  generate if (ASYNC_SPI_CLK) begin

    // synchronization FIFO for the SYNC interface
    util_axis_fifo #(
      .DATA_WIDTH(8),
      .ASYNC_CLK(ASYNC_SPI_CLK),
      .ADDRESS_WIDTH(SYNC_FIFO_ADDRESS_WIDTH),
      .M_AXIS_REGISTERED(0)
    ) i_sync_fifo (
      .s_axis_aclk(spi_clk),
      .s_axis_aresetn(spi_resetn),
      .s_axis_ready(sync_ready),
      .s_axis_valid(sync_valid),
      .s_axis_data(sync_data),
      .s_axis_room(),
      .s_axis_full(),
      .m_axis_aclk(clk),
      .m_axis_aresetn(up_sw_resetn),
      .m_axis_ready(1'b1),
      .m_axis_valid(sync_fifo_valid),
      .m_axis_data(sync_fifo_data),
      .m_axis_level(),
      .m_axis_empty());

    // synchronization FIFO for the offload command interface
    wire up_offload0_cmd_wr_en_s;
    wire [15:0] up_offload0_cmd_wr_data_s;

    util_axis_fifo #(
      .DATA_WIDTH(16),
      .ASYNC_CLK(ASYNC_SPI_CLK),
      .ADDRESS_WIDTH(SYNC_FIFO_ADDRESS_WIDTH),
      .M_AXIS_REGISTERED(0)
    ) i_offload_cmd_fifo (
      .s_axis_aclk(clk),
      .s_axis_aresetn(up_sw_resetn),
      .s_axis_ready(),
      .s_axis_valid(up_offload0_cmd_wr_en_s),
      .s_axis_data(up_offload0_cmd_wr_data_s),
      .s_axis_room(),
      .s_axis_full(),
      .m_axis_aclk(spi_clk),
      .m_axis_aresetn(spi_resetn),
      .m_axis_ready(1'b1),
      .m_axis_valid(offload0_cmd_wr_en),
      .m_axis_data(offload0_cmd_wr_data),
      .m_axis_level(),
      .m_axis_empty());

    assign up_offload0_cmd_wr_en_s = up_wreq_s == 1'b1 && up_waddr_s == 8'h44;
    assign up_offload0_cmd_wr_data_s = up_wdata_s[15:0];

    // synchronization FIFO for the offload SDO interface
    wire up_offload0_sdo_wr_en_s;
    wire [DATA_WIDTH-1:0] up_offload0_sdo_wr_data_s;

    util_axis_fifo #(
      .DATA_WIDTH(DATA_WIDTH),
      .ASYNC_CLK(ASYNC_SPI_CLK),
      .ADDRESS_WIDTH(SYNC_FIFO_ADDRESS_WIDTH),
      .M_AXIS_REGISTERED(0)
    ) i_offload_sdo_fifo (
      .s_axis_aclk(clk),
      .s_axis_aresetn(up_sw_resetn),
      .s_axis_ready(),
      .s_axis_valid(up_offload0_sdo_wr_en_s),
      .s_axis_data(up_offload0_sdo_wr_data_s),
      .s_axis_room(),
      .s_axis_full(),
      .m_axis_aclk(spi_clk),
      .m_axis_aresetn(spi_resetn),
      .m_axis_ready(1'b1),
      .m_axis_valid(offload0_sdo_wr_en),
      .m_axis_data(offload0_sdo_wr_data),
      .m_axis_level(),
      .m_axis_empty());

    assign up_offload0_sdo_wr_en_s = up_wreq_s == 1'b1 && up_waddr_s == 8'h45;
    assign up_offload0_sdo_wr_data_s = up_wdata_s[DATA_WIDTH-1:0];

    // synchronization FIFO for the Offload SYNC interface
    util_axis_fifo #(
      .DATA_WIDTH(8),
      .ASYNC_CLK(ASYNC_SPI_CLK),
      .ADDRESS_WIDTH(SYNC_FIFO_ADDRESS_WIDTH),
      .M_AXIS_REGISTERED(0)
    ) i_offload_sync_fifo (
      .s_axis_aclk(spi_clk),
      .s_axis_aresetn(spi_resetn),
      .s_axis_ready(offload_sync_ready),
      .s_axis_valid(offload_sync_valid),
      .s_axis_data(offload_sync_data),
      .s_axis_room(),
      .s_axis_full(),
      .m_axis_aclk(clk),
      .m_axis_aresetn(up_sw_resetn),
      .m_axis_ready(1'b1),
      .m_axis_valid(offload_sync_fifo_valid),
      .m_axis_data(offload_sync_fifo_data),
      .m_axis_level(),
      .m_axis_empty());

  end else begin /* ASYNC_SPI_CLK == 0 */

      assign sync_fifo_valid = sync_valid;
      assign sync_fifo_data = sync_data;
      assign sync_ready = 1'b1;

      assign offload0_cmd_wr_en = up_wreq_s == 1'b1 && up_waddr_s == 8'h44;
      assign offload0_cmd_wr_data = up_wdata_s[15:0];

      assign offload0_sdo_wr_en = up_wreq_s == 1'b1 && up_waddr_s == 8'h45;
      assign offload0_sdo_wr_data = up_wdata_s[DATA_WIDTH-1:0];

      assign offload_sync_fifo_valid = offload_sync_valid;
      assign offload_sync_fifo_data = offload_sync_data;
      assign offload_sync_ready = 1'b1;

  end
  endgenerate

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (ASYNC_SPI_CLK)
  ) i_offload_enable_sync (
    .in_bits (offload0_enable_reg),
    .out_resetn (spi_resetn),
    .out_clk (spi_clk),
    .out_bits (offload0_enable));

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (ASYNC_SPI_CLK)
  ) i_offload_enabled_sync (
    .in_bits (offload0_enabled),
    .out_resetn (up_sw_resetn),
    .out_clk (clk),
    .out_bits (offload0_enabled_s));

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (ASYNC_SPI_CLK)
  ) i_offload_mem_reset_sync (
    .in_bits (offload0_mem_reset_reg),
    .out_resetn (spi_resetn),
    .out_clk (spi_clk),
    .out_bits (offload0_mem_reset));

  sync_bits #(
    .NUM_OF_BITS (3),
    .ASYNC_CLK (ASYNC_SPI_CLK)
  ) i_fifo_status (
    .in_bits ({cmd_fifo_almost_empty, sdi_fifo_almost_full, sdo_fifo_almost_empty}),
    .out_resetn (up_sw_resetn),
    .out_clk (clk),
    .out_bits ({up_cmd_fifo_almost_empty, up_sdi_fifo_almost_full, up_sdo_fifo_almost_empty}));

endmodule
