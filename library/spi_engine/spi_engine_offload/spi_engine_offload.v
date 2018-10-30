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

module spi_engine_offload #(

  parameter ASYNC_SPI_CLK = 0,
  parameter ASYNC_TRIG = 0,
  parameter CMD_MEM_ADDRESS_WIDTH = 4,
  parameter SDO_MEM_ADDRESS_WIDTH = 4,
  parameter DATA_WIDTH = 8,                   // Valid data widths values are 8/16/24/32
  parameter NUM_OF_SDI = 1 ) (

  input ctrl_clk,

  input ctrl_cmd_wr_en,
  input [15:0] ctrl_cmd_wr_data,

  input ctrl_sdo_wr_en,
  input [(DATA_WIDTH-1):0] ctrl_sdo_wr_data,

  input ctrl_enable,
  output ctrl_enabled,
  input ctrl_mem_reset,

  input spi_clk,
  input spi_resetn,

  input trigger,

  output cmd_valid,
  input cmd_ready,
  output [15:0] cmd,

  output sdo_data_valid,
  input sdo_data_ready,
  output [(DATA_WIDTH-1):0] sdo_data,

  input sdi_data_valid,
  output sdi_data_ready,
  input [(NUM_OF_SDI * DATA_WIDTH-1):0] sdi_data,

  input sync_valid,
  output sync_ready,
  input [7:0] sync_data,

  output offload_sdi_valid,
  input offload_sdi_ready,
  output [(NUM_OF_SDI * DATA_WIDTH-1):0] offload_sdi_data
);

reg spi_active = 1'b0;

reg [CMD_MEM_ADDRESS_WIDTH-1:0] ctrl_cmd_wr_addr = 'h00;
reg [CMD_MEM_ADDRESS_WIDTH-1:0] spi_cmd_rd_addr = 'h00;
reg [SDO_MEM_ADDRESS_WIDTH-1:0] ctrl_sdo_wr_addr = 'h00;
reg [SDO_MEM_ADDRESS_WIDTH-1:0] spi_sdo_rd_addr = 'h00;

reg [15:0] cmd_mem[0:2**CMD_MEM_ADDRESS_WIDTH-1];
reg [(DATA_WIDTH-1):0] sdo_mem[0:2**SDO_MEM_ADDRESS_WIDTH-1];

wire [CMD_MEM_ADDRESS_WIDTH-1:0] spi_cmd_rd_addr_next;
wire spi_enable;

assign cmd_valid = spi_active;
assign sdo_data_valid = spi_active;
assign sync_ready = 1'b1;

assign offload_sdi_valid = sdi_data_valid;

// we don't want to block the SDI interface after disabling the module
// so just assert the SDI_READY if the sink module (DMA) is disabled
assign sdi_data_ready = (spi_enable) ? offload_sdi_ready : 1'b1;

assign offload_sdi_data = sdi_data;

assign cmd = cmd_mem[spi_cmd_rd_addr];
assign sdo_data = sdo_mem[spi_sdo_rd_addr];

generate if (ASYNC_SPI_CLK) begin

/*
 * The synchronization circuit takes care that there are no glitches on the
 * ctrl_enabled signal. ctrl_do_enable is asserted whenever ctrl_enable is
 * asserted, but only deasserted once the signal has been synchronized back from
 * the SPI domain. This makes sure that we can't end up in a state where the
 * enable signal in the SPI domain is asserted, but neither enable nor enabled
 * is asserted in the control domain.
 */

reg ctrl_do_enable = 1'b0;
wire ctrl_is_enabled;
reg spi_enabled = 1'b0;

always @(posedge ctrl_clk) begin
  if (ctrl_enable == 1'b1) begin
    ctrl_do_enable <= 1'b1;
  end else if (ctrl_is_enabled == 1'b1) begin
    ctrl_do_enable <= 1'b0;
  end
end

assign ctrl_enabled = ctrl_is_enabled | ctrl_do_enable;

always @(posedge spi_clk) begin
  spi_enabled <= spi_enable | spi_active;
end

sync_bits # (
    .NUM_OF_BITS(1),
    .ASYNC_CLK(1)
) i_sync_enable (
    .in_bits(ctrl_do_enable),
    .out_clk(spi_clk),
    .out_resetn(1'b1),
    .out_bits(spi_enable)
);

sync_bits # (
    .NUM_OF_BITS(1),
    .ASYNC_CLK(1)
) i_sync_enabled (
    .in_bits(spi_enabled),
    .out_clk(ctrl_clk),
    .out_resetn(1'b1),
    .out_bits(ctrl_is_enabled)
);

end else begin
assign spi_enable = ctrl_enable;
assign ctrl_enabled = spi_enable | spi_active;
end endgenerate

assign spi_cmd_rd_addr_next = spi_cmd_rd_addr + 1;

wire trigger_s;
sync_bits #(
  .NUM_OF_BITS(1),
  .ASYNC_CLK(ASYNC_TRIG)
) i_sync_trigger (
  .in_bits(trigger),
  .out_clk(spi_clk),
  .out_resetn(1'b1),
  .out_bits(trigger_s)
);

always @(posedge spi_clk) begin
  if (spi_resetn == 1'b0) begin
    spi_active <= 1'b0;
  end else begin
    if (spi_active == 1'b0) begin
      if (trigger_s == 1'b1 && spi_enable == 1'b1)
        spi_active <= 1'b1;
    end else if (cmd_ready == 1'b1 && spi_cmd_rd_addr_next == ctrl_cmd_wr_addr) begin
      spi_active <= 1'b0;
    end
  end
end

always @(posedge spi_clk) begin
  if (cmd_valid == 1'b0) begin
    spi_cmd_rd_addr <= 'h00;
  end else if (cmd_ready == 1'b1) begin
    spi_cmd_rd_addr <= spi_cmd_rd_addr_next;
  end
end

always @(posedge spi_clk) begin
  if (spi_active == 1'b0) begin
    spi_sdo_rd_addr <= 'h00;
  end else if (sdo_data_ready == 1'b1) begin
    spi_sdo_rd_addr <= spi_sdo_rd_addr + 1'b1;
  end
end

always @(posedge ctrl_clk) begin
  if (ctrl_mem_reset == 1'b1)
    ctrl_cmd_wr_addr <= 'h00;
  else if (ctrl_cmd_wr_en == 1'b1)
    ctrl_cmd_wr_addr <= ctrl_cmd_wr_addr + 1'b1;
end

always @(posedge ctrl_clk) begin
  if (ctrl_cmd_wr_en == 1'b1)
    cmd_mem[ctrl_cmd_wr_addr] <= ctrl_cmd_wr_data;
end

always @(posedge ctrl_clk) begin
  if (ctrl_mem_reset == 1'b1)
    ctrl_sdo_wr_addr <= 'h00;
  else if (ctrl_sdo_wr_en == 1'b1)
    ctrl_sdo_wr_addr <= ctrl_sdo_wr_addr + 1'b1;
end

always @(posedge ctrl_clk) begin
  if (ctrl_sdo_wr_en == 1'b1)
    sdo_mem[ctrl_sdo_wr_addr] <= ctrl_sdo_wr_data;
end

endmodule
