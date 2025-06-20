// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
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

module i3c_controller_host_interface #(
  parameter CMD_FIFO_ADDRESS_WIDTH = 4,
  parameter CMDR_FIFO_ADDRESS_WIDTH = 4,
  parameter SDO_FIFO_ADDRESS_WIDTH = 5,
  parameter SDI_FIFO_ADDRESS_WIDTH = 5,
  parameter IBI_FIFO_ADDRESS_WIDTH = 4,
  parameter ID = 0,
  parameter DA = 7'h31,
  parameter ASYNC_CLK = 0,
  parameter OFFLOAD = 1,
  parameter PID_MANUF_ID = 15'b0,
  parameter PID_TYPE_SELECTOR = 1'b1,
  parameter PID_PART_ID = 16'b0,
  parameter PID_INSTANCE_ID = 4'b0,
  parameter PID_EXTRA_ID = 12'b0
) (
  input  clk,
  output reset_n,

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

  output irq,
  input  offload_trigger,

  // Command parsed

  input         cmdp_ready,
  output        cmdp_valid,
  output [30:0] cmdp,
  input  [2:0]  cmdp_error,
  input         cmdp_nop,
  input         cmdp_daa_trigger,

  // Byte stream

  input  sdo_ready,
  output sdo_valid,
  output [7:0] sdo,

  output sdi_ready,
  input  sdi_valid,
  input  sdi_last,
  input  [7:0] sdi,

  output ibi_ready,
  input  ibi_valid,
  input  [14:0] ibi,

  input  offload_sdi_ready,
  output offload_sdi_valid,
  output [31:0] offload_sdi,

  // uP accessible info

  output [1:0] rmap_ibi_config,
  output [1:0] rmap_pp_sg,
  input  [6:0] rmap_dev_char_addr,
  output [3:0] rmap_dev_char_data
);

  wire rd_bytes_stop;
  wire [11:0] rd_bytes_lvl;
  wire [11:0] wr_bytes_lvl;

  wire cmd_ready;
  wire cmd_valid;
  wire [31:0] cmd;

  wire cmdr_ready;
  wire cmdr_valid;
  wire [31:0] cmdr;

  wire sdo_ready_w;
  wire sdo_valid_w;
  wire [31:0] sdo_w;

  wire sdi_ready_w;
  wire sdi_valid_w;
  wire [31:0] sdi_w;

  wire ibi_ready_w;
  wire ibi_valid_w;
  wire [31:0] ibi_w;

  wire clk_w;

  generate if (ASYNC_CLK) begin
    assign clk_w = clk;
  end else begin
    assign clk_w = s_axi_aclk;
  end
  endgenerate

  i3c_controller_regmap #(
    .CMD_FIFO_ADDRESS_WIDTH(CMD_FIFO_ADDRESS_WIDTH),
    .CMDR_FIFO_ADDRESS_WIDTH(CMDR_FIFO_ADDRESS_WIDTH),
    .SDO_FIFO_ADDRESS_WIDTH(SDO_FIFO_ADDRESS_WIDTH),
    .SDI_FIFO_ADDRESS_WIDTH(SDI_FIFO_ADDRESS_WIDTH),
    .IBI_FIFO_ADDRESS_WIDTH(IBI_FIFO_ADDRESS_WIDTH),
    .ID(ID),
    .DA(DA),
    .ASYNC_CLK(ASYNC_CLK),
    .OFFLOAD(OFFLOAD),
    .PID_MANUF_ID(PID_MANUF_ID),
    .PID_TYPE_SELECTOR(PID_TYPE_SELECTOR),
    .PID_PART_ID(PID_PART_ID),
    .PID_INSTANCE_ID(PID_INSTANCE_ID),
    .PID_EXTRA_ID(PID_EXTRA_ID)
  ) i_i3c_controller_regmap (
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awready(s_axi_awready),
    .s_axi_awprot(s_axi_awprot),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wready(s_axi_wready),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bready(s_axi_bready),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arready(s_axi_arready),
    .s_axi_arprot(s_axi_arprot),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready),
    .s_axi_rresp(s_axi_rresp),
    .s_axi_rdata(s_axi_rdata),
    .irq(irq),
    .clk(clk),
    .a_reset_n(reset_n),
    .cmd_nop(cmdp_nop),
    .cmd_ready(cmd_ready),
    .cmd_valid(cmd_valid),
    .cmd(cmd),
    .cmdr_ready(cmdr_ready),
    .cmdr_valid(cmdr_valid),
    .cmdr(cmdr),
    .sdo_ready(sdo_ready_w),
    .sdo_valid(sdo_valid_w),
    .sdo(sdo_w),
    .sdi_ready(sdi_ready_w),
    .sdi_valid(sdi_valid_w),
    .sdi(sdi_w),
    .offload_sdi_ready(offload_sdi_ready),
    .offload_sdi_valid(offload_sdi_valid),
    .offload_sdi(offload_sdi),
    .ibi_ready(ibi_ready_w),
    .ibi_valid(ibi_valid_w),
    .ibi(ibi_w),
    .daa_trigger(cmdp_daa_trigger),
    .offload_trigger(offload_trigger),
    .rmap_ibi_config(rmap_ibi_config),
    .rmap_pp_sg(rmap_pp_sg),
    .rmap_dev_char_addr(rmap_dev_char_addr),
    .rmap_dev_char_data(rmap_dev_char_data));

  i3c_controller_unpack
  i_i3c_controller_unpack (
    .clk(clk_w),
    .reset_n(reset_n),
    .stop(rd_bytes_stop),
    .u32_ready(sdo_ready_w),
    .u32_valid(sdo_valid_w),
    .u32(sdo_w),
    .u8_lvl(rd_bytes_lvl),
    .u8_ready(sdo_ready),
    .u8_valid(sdo_valid),
    .u8(sdo));

  i3c_controller_pack
  i_i3c_controller_pack (
    .clk(clk_w),
    .reset_n(reset_n),
    .u32_ready(sdi_ready_w),
    .u32_valid(sdi_valid_w),
    .u32(sdi_w),
    .u8_lvl(wr_bytes_lvl),
    .u8_ready(sdi_ready),
    .u8_valid(sdi_valid),
    .u8_last(sdi_last),
    .u8(sdi));

  i3c_controller_write_ibi
  i_i3c_controller_write_ibi (
    .clk(clk_w),
    .reset_n(reset_n),
    .out_ready(ibi_ready_w),
    .out_valid(ibi_valid_w),
    .out(ibi_w),
    .in_ready(ibi_ready),
    .in_valid(ibi_valid),
    .in(ibi));

  i3c_controller_cmd_parser
  i_i3c_controller_cmd_parser (
    .clk(clk_w),
    .reset_n(reset_n),
    .cmd_ready(cmd_ready),
    .cmd_valid(cmd_valid),
    .cmd(cmd),
    .cmdr_ready(cmdr_ready),
    .cmdr_valid(cmdr_valid),
    .cmdr(cmdr),
    .cmdp_valid(cmdp_valid),
    .cmdp_ready(cmdp_ready),
    .cmdp(cmdp),
    .cmdp_error(cmdp_error),
    .rd_bytes_stop(rd_bytes_stop),
    .rd_bytes_lvl(rd_bytes_lvl),
    .wr_bytes_stop(sdi_last),
    .wr_bytes_lvl(wr_bytes_lvl));

endmodule
