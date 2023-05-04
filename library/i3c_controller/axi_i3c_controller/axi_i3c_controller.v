// ***************************************************************************
// Copyright 2023 (c) Analog Devices, Inc. All rights reserved.
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
`default_nettype none

module axi_i3c_controller #(
  parameter ID = 0,
  parameter MM_IF_TYPE = 0,
  parameter ASYNC_I3C_CLK = 0,
  parameter ADDRESS_WIDTH = 8, // Const
  parameter DATA_WIDTH = 32 // Const
) (

  // Slave AXI interface

  input  wire        s_axi_aclk,
  input  wire        s_axi_aresetn,
  input  wire        s_axi_awvalid,
  input  wire [15:0] s_axi_awaddr,
  output wire        s_axi_awready,
  input  wire  [2:0] s_axi_awprot,
  input  wire        s_axi_wvalid,
  input  wire [31:0] s_axi_wdata,
  input  wire [ 3:0] s_axi_wstrb,
  output wire        s_axi_wready,
  output wire        s_axi_bvalid,
  output wire [ 1:0] s_axi_bresp,
  input  wire        s_axi_bready,
  input  wire        s_axi_arvalid,
  input  wire [15:0] s_axi_araddr,
  output wire        s_axi_arready,
  input  wire  [2:0] s_axi_arprot,
  output wire        s_axi_rvalid,
  input  wire        s_axi_rready,
  output wire [ 1:0] s_axi_rresp,
  output wire [31:0] s_axi_rdata,

  // up interface

  input  wire        up_clk,
  input  wire        up_rstn,
  input  wire        up_wreq,
  input  wire [13:0] up_waddr,
  input  wire [31:0] up_wdata,
  output wire        up_wack,
  input  wire        up_rreq,
  input  wire [13:0] up_raddr,
  output wire [31:0] up_rdata,
  output wire        up_rack,

  output reg irq,

  // I3C basic signals

  input  wire i3c_clk,
  output wire i3c_reset_n,

  // I3C control signals

  input  wire cmd_ready,
  output wire cmd_valid,
  output wire [DATA_WIDTH-1:0] cmd,

  output wire cmdr_ready,
  input  wire cmdr_valid,
  input  wire [DATA_WIDTH-1:0] cmdr,

  input  wire sdo_ready,
  output wire sdo_valid,
  output wire [DATA_WIDTH-1:0] sdo,

  output wire sdi_ready,
  input  wire sdi_valid,
  input  wire [DATA_WIDTH-1:0] sdi,

  output wire ibi_ready,
  input  wire ibi_valid,
  input  wire [DATA_WIDTH-1:0] ibi
);

  localparam PCORE_VERSION = 'h12345678;
  localparam S_AXI = 0;
  localparam UP_FIFO = 1;

  wire clk;
  wire rstn;

  // CMD FIFO
  wire [ADDRESS_WIDTH-1:0] cmd_fifo_room;
  wire cmd_fifo_almost_empty;
  wire up_cmd_fifo_almost_empty;

  wire [DATA_WIDTH-1:0] cmd_fifo_in_data;
  wire cmd_fifo_in_ready;
  wire cmd_fifo_in_valid;
  // CMDR FIFO
  wire cmdr_fifo_out_data_msb_s;
  wire [ADDRESS_WIDTH-1:0] cmdr_fifo_level;
  wire cmdr_fifo_almost_full;
  wire up_cmdr_fifo_almost_full;

  wire [DATA_WIDTH-1:0] cmdr_fifo_out_data;
  wire cmdr_fifo_out_ready;
  wire cmdr_fifo_out_valid;
  // SDO FIFO
  wire [ADDRESS_WIDTH-1:0] sdo_fifo_room;
  wire sdo_fifo_almost_empty;
  wire up_sdo_fifo_almost_empty;

  wire [DATA_WIDTH-1:0] sdo_fifo_in_data;
  wire sdo_fifo_in_ready;
  wire sdo_fifo_in_valid;
  // SDI FIFO
  wire sdi_fifo_out_data_msb_s;
  wire [ADDRESS_WIDTH-1:0] sdi_fifo_level;
  wire sdi_fifo_almost_full;
  wire up_sdi_fifo_almost_full;

  wire [DATA_WIDTH-1:0] sdi_fifo_out_data;
  wire sdi_fifo_out_ready;
  wire sdi_fifo_out_valid;
  // IBI FIFO
  wire ibi_fifo_out_data_msb_s;
  wire [ADDRESS_WIDTH-1:0] ibi_fifo_level;
  wire ibi_fifo_almost_full;
  wire up_ibi_fifo_almost_full;

  wire [DATA_WIDTH-1:0] ibi_fifo_out_data;
  wire ibi_fifo_out_ready;
  wire ibi_fifo_out_valid;

  reg up_sw_reset = 1'b1;
  wire up_sw_resetn = ~up_sw_reset;

  reg  [31:0] up_rdata_ff = 'd0;
  reg         up_wack_ff = 1'b0;
  reg         up_rack_ff = 1'b0;
  wire        up_wreq_s;
  wire        up_rreq_s;
  wire [31:0] up_wdata_s;
  wire [13:0] up_waddr_s;
  wire [13:0] up_raddr_s;

  // Scratch register
  reg [31:0] up_scratch = 'h00;

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

  assign up_irq_source = {5{1'b0}};

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
          14'h02: up_scratch <= up_wdata_s;
          14'h10: up_sw_reset <= up_wdata_s[0];
        endcase
      end
    end
  end

  // the software reset should reset all the registers
  always @(posedge clk) begin
    if (!up_sw_resetn) begin
      up_irq_mask <= 'h00;
    end else begin
      if (up_wreq_s) begin
        case (up_waddr_s)
          14'h20: up_irq_mask <= up_wdata_s[4:0];
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


  always @(posedge clk) begin
    case (up_raddr_s)
      14'h00: up_rdata_ff <= PCORE_VERSION;
      14'h01: up_rdata_ff <= ID;
      14'h02: up_rdata_ff <= up_scratch;
      default: up_rdata_ff <= 'h00;
    endcase
  end

  generate if (ASYNC_I3C_CLK) begin
    wire i3c_reset;
    ad_rst i_spi_resetn (
      .rst_async(up_sw_reset),
      .clk(i3c_clk),
      .rst(i3c_reset),
      .rstn());
    assign i3c_reset_n = ~i3c_reset;
  end else begin /* ASYNC_I3C_CLK == 0 */
    assign i3c_reset_n = ~up_sw_reset;
  end
  endgenerate

  assign cmd_fifo_in_valid = up_wreq_s == 1'b1 && up_waddr_s == 8'h35;
  assign cmd_fifo_in_data = up_wdata_s[15:0];

  util_axis_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDRESS_WIDTH(ADDRESS_WIDTH),
    .ASYNC_CLK(ASYNC_I3C_CLK),
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
    .m_axis_aclk(i3c_clk),
    .m_axis_aresetn(i3c_reset_n),
    .m_axis_ready(cmd_ready),
    .m_axis_valid(cmd_valid),
    .m_axis_data(cmd),
    .m_axis_tlast(),
    .m_axis_empty(),
    .m_axis_almost_empty(cmd_fifo_almost_empty),
    .m_axis_level());

  assign cmdr_fifo_out_ready = up_rreq_s == 1'b1 && up_raddr_s == 8'h36;

  util_axis_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ASYNC_CLK(ASYNC_I3C_CLK),
    .ADDRESS_WIDTH(ADDRESS_WIDTH),
    .M_AXIS_REGISTERED(0),
    .ALMOST_EMPTY_THRESHOLD(1),
    .ALMOST_FULL_THRESHOLD(31)
  ) i_cmdr_fifo (
    .s_axis_aclk(i3c_clk),
    .s_axis_aresetn(i3c_reset_n),
    .s_axis_ready(cmdr_ready),
    .s_axis_valid(cmdr_valid),
    .s_axis_data(cmdr),
    .s_axis_room(),
    .s_axis_tlast(),
    .s_axis_full(),
    .s_axis_almost_full(cmdr_fifo_almost_full),
    .m_axis_aclk(clk),
    .m_axis_aresetn(up_sw_resetn),
    .m_axis_ready(cmdr_fifo_out_ready),
    .m_axis_valid(cmdr_fifo_out_valid),
    .m_axis_data(cmdr_fifo_out_data),
    .m_axis_tlast(),
    .m_axis_level(cmdr_fifo_level),
    .m_axis_empty(),
    .m_axis_almost_empty());

  assign sdo_fifo_in_valid = up_wreq_s == 1'b1 && up_waddr_s == 8'h37;
  assign sdo_fifo_in_data = up_wdata_s[31:0];

  util_axis_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ASYNC_CLK(ASYNC_I3C_CLK),
    .ADDRESS_WIDTH(ADDRESS_WIDTH),
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
    .m_axis_aclk(i3c_clk),
    .m_axis_aresetn(i3c_reset_n),
    .m_axis_ready(sdo_ready),
    .m_axis_valid(sdo_valid),
    .m_axis_data(sdo),
    .m_axis_tlast(),
    .m_axis_level(),
    .m_axis_empty(),
    .m_axis_almost_empty(sdo_fifo_almost_empty));

  assign sdi_fifo_out_ready = up_rreq_s == 1'b1 && up_raddr_s == 8'h38;

  util_axis_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ASYNC_CLK(ASYNC_I3C_CLK),
    .ADDRESS_WIDTH(ADDRESS_WIDTH),
    .M_AXIS_REGISTERED(0),
    .ALMOST_EMPTY_THRESHOLD(1),
    .ALMOST_FULL_THRESHOLD(31)
  ) i_sdi_fifo (
    .s_axis_aclk(i3c_clk),
    .s_axis_aresetn(i3c_reset_n),
    .s_axis_ready(sdi_ready),
    .s_axis_valid(sdi_valid),
    .s_axis_data(sdi),
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

  assign ibi_fifo_out_ready = up_rreq_s == 1'b1 && up_raddr_s == 8'h39;

  util_axis_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ASYNC_CLK(ASYNC_I3C_CLK),
    .ADDRESS_WIDTH(ADDRESS_WIDTH),
    .M_AXIS_REGISTERED(0),
    .ALMOST_EMPTY_THRESHOLD(1),
    .ALMOST_FULL_THRESHOLD(31)
  ) i_ibi_fifo (
    .s_axis_aclk(i3c_clk),
    .s_axis_aresetn(i3c_reset_n),
    .s_axis_ready(ibi_ready),
    .s_axis_valid(ibi_valid),
    .s_axis_data(ibi),
    .s_axis_room(),
    .s_axis_tlast(),
    .s_axis_full(),
    .s_axis_almost_full(ibi_fifo_almost_full),
    .m_axis_aclk(clk),
    .m_axis_aresetn(up_sw_resetn),
    .m_axis_ready(ibi_fifo_out_ready),
    .m_axis_valid(ibi_fifo_out_valid),
    .m_axis_data(ibi_fifo_out_data),
    .m_axis_tlast(),
    .m_axis_level(ibi_fifo_level),
    .m_axis_empty(),
    .m_axis_almost_empty());

endmodule
