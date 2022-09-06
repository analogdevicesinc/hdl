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
  parameter SDO_MEM_OS = 0,
  parameter CMD_MEM_ADDRESS_WIDTH = 4,
  parameter SDO_MEM_ADDRESS_WIDTH = 4,
  parameter DATA_WIDTH = 8,                   // Valid data widths values are 8/16/24/32
  parameter NUM_OF_SDI = 1 ) (

  input ctrl_clk,

 (* mark_debug = "true" *) input ctrl_cmd_wr_en,
 (* mark_debug = "true" *) input [15:0] ctrl_cmd_wr_data,

 (* mark_debug = "true" *) input ctrl_sdo_wr_en,
 (* mark_debug = "true" *) input [(DATA_WIDTH-1):0] ctrl_sdo_wr_data,

 (* mark_debug = "true" *) input ctrl_enable,
 (* mark_debug = "true" *) input ctrl_axis_sw,
 (* mark_debug = "true" *) output ctrl_enabled,
 (* mark_debug = "true" *) input ctrl_mem_reset,

 (* mark_debug = "true" *) output status_sync_valid,
 (* mark_debug = "true" *) input status_sync_ready,
 (* mark_debug = "true" *) output [7:0] status_sync_data,

  input spi_clk,
 (* mark_debug = "true" *) input spi_resetn,

 (* mark_debug = "true" *) input trigger,

 (* mark_debug = "true" *) output cmd_valid,
 (* mark_debug = "true" *) input cmd_ready,
 (* mark_debug = "true" *) output [15:0] cmd,

 (* mark_debug = "true" *) output sdo_data_valid,
 (* mark_debug = "true" *) input sdo_data_ready,
 (* mark_debug = "true" *) output [(DATA_WIDTH-1):0] sdo_data,

  input sdi_data_valid,
  output sdi_data_ready,
  input [(NUM_OF_SDI * DATA_WIDTH-1):0] sdi_data,

  input sync_valid,
  output sync_ready,
  input [7:0] sync_data,

  output offload_sdi_valid,
  input offload_sdi_ready,
  output [(NUM_OF_SDI * DATA_WIDTH-1):0] offload_sdi_data,

 (* mark_debug = "true" *) input offload_sdo_valid_0,
 (* mark_debug = "true" *) output offload_sdo_ready_0,
 (* mark_debug = "true" *) input [(DATA_WIDTH-1):0] offload_sdo_data_0,

 (* mark_debug = "true" *) input offload_sdo_valid_1,
 (* mark_debug = "true" *) output offload_sdo_ready_1,
 (* mark_debug = "true" *) input [(DATA_WIDTH-1):0] offload_sdo_data_1
);

 (* mark_debug = "true" *) reg spi_active = 1'b0;
 (* mark_debug = "true" *) reg ctrl_enable_d = 1'b0;
 (* mark_debug = "true" *) reg spi_active_d = 1'b0;
 (* mark_debug = "true" *) wire ctrl_enable_ed;
 (* mark_debug = "true" *) wire spi_active_ed;

 (* mark_debug = "true" *) reg [CMD_MEM_ADDRESS_WIDTH-1:0] ctrl_cmd_wr_addr = 'h00;
 (* mark_debug = "true" *) reg [CMD_MEM_ADDRESS_WIDTH-1:0] ctrl_cmd_os_wr_addr = 'h00;
 (* mark_debug = "true" *) reg [CMD_MEM_ADDRESS_WIDTH-1:0] spi_cmd_rd_addr = 'h00;
 (* mark_debug = "true" *) reg [CMD_MEM_ADDRESS_WIDTH-1:0] spi_cmd_os_rd_addr = 'h00;
reg [SDO_MEM_ADDRESS_WIDTH-1:0] ctrl_sdo_wr_addr = 'h00;
reg [SDO_MEM_ADDRESS_WIDTH-1:0] ctrl_sdo_wr_addr_1 = 'h00;
reg [SDO_MEM_ADDRESS_WIDTH-1:0] spi_sdo_rd_addr = 'h00;

reg [15:0] cmd_mem[0:2**CMD_MEM_ADDRESS_WIDTH-1];
reg [15:0] cmd_mem_os[0:2**CMD_MEM_ADDRESS_WIDTH-1];
reg [(DATA_WIDTH-1):0] sdo_mem[0:2**SDO_MEM_ADDRESS_WIDTH-1];

 (* mark_debug = "true" *) reg cmd_valid_s = 1'h0;

 (* mark_debug = "true" *) wire [15:0] cmd_int_s;
 (* mark_debug = "true" *) wire [CMD_MEM_ADDRESS_WIDTH-1:0] spi_cmd_rd_addr_next;
 (* mark_debug = "true" *) wire [CMD_MEM_ADDRESS_WIDTH-1:0] spi_cmd_os_rd_addr_next;
 (* mark_debug = "true" *) wire spi_enable;
 (* mark_debug = "true" *) wire mem_empty;
wire offload_sdo_valid;
wire offload_sdo_ready;
wire cmd_mem_os_s;
wire [(DATA_WIDTH-1):0] offload_sdo_data;

assign cmd_mem_os_s = ctrl_cmd_wr_data [15];


assign offload_sdo_ready_0 = (ctrl_axis_sw ? 0 : offload_sdo_ready);
assign offload_sdo_ready_1 = (ctrl_axis_sw ? offload_sdo_ready : 0);

assign offload_sdo_valid = (ctrl_axis_sw ? offload_sdo_valid_1 : offload_sdo_valid_0);
assign offload_sdo_data = (ctrl_axis_sw ? offload_sdo_data_1 : offload_sdo_data_0);

assign mem_empty = (ctrl_sdo_wr_addr_1 == 'h0 ? 1 : 0);
assign cmd_valid = spi_active | cmd_valid_s;
assign sdo_data_valid = mem_empty == 1 ? offload_sdo_valid : 1'b1;
assign offload_sdi_valid = sdi_data_valid;

// we don't want to block the SDI interface after disabling the module
// so just assert the SDI_READY if the sink module (DMA) is disabled
assign sdi_data_ready = (spi_enable) ? offload_sdi_ready : 1'b1;

assign offload_sdi_data = sdi_data;

  assign cmd_int_s = cmd_sdo_en_os ? cmd_mem_os[spi_cmd_os_rd_addr] : cmd_mem[spi_cmd_rd_addr];

assign offload_sdo_ready = sdo_data_ready & mem_empty;
assign sdo_data = (mem_empty == 1 ? offload_sdo_data : sdo_mem[ctrl_sdo_wr_addr_1 - 1'h1]);

/* SYNC ID counter. The offload module increments the sync_id on each
 * transaction. The initial value of the sync_id is the value of the last
 * sync_id command loaded into the command buffer.
 */

reg [ 7:0] ctrl_sync_id_init = 8'b0;
reg        ctrl_sync_id_load = 1'b0;
reg [ 7:0] spi_sync_id_counter = 8'b0;

wire [ 7:0] spi_sync_id_init_s;

always @(posedge ctrl_clk) begin
  if (ctrl_mem_reset == 1'b1) begin
    ctrl_sync_id_init <= 8'b0;
    ctrl_sync_id_load <= 1'b0;
  end else begin
    if (ctrl_cmd_wr_en && (ctrl_cmd_wr_data[15:8] == 8'h30)) begin
      ctrl_sync_id_init <= ctrl_cmd_wr_data;
      ctrl_sync_id_load <= 1'b1;
    end else begin
      ctrl_sync_id_load <= 1'b0;
    end
  end
end

wire spi_sync_id_load_s;

sync_event # (
    .NUM_OF_EVENTS(1),
    .ASYNC_CLK(1)
) i_sync_sync_id_load (
    .in_clk (ctrl_clk),
    .in_event(ctrl_sync_id_load),
    .out_clk(spi_clk),
    .out_event(spi_sync_id_load_s)
);

sync_bits # (
    .NUM_OF_BITS(8),
    .ASYNC_CLK(1)
) i_sync_sync_id (
    .in_bits(ctrl_sync_id_init),
    .out_clk(spi_clk),
    .out_resetn(1'b1),
    .out_bits(spi_sync_id_init_s)
);

always @(posedge spi_clk) begin
  if (spi_resetn == 1'b0) begin
    spi_sync_id_counter <= 8'b0;
  end else begin
    if (spi_sync_id_load_s) begin
      spi_sync_id_counter <= spi_sync_id_init_s;
    end else if(cmd_valid && cmd_ready && (cmd[15:8] == 8'h30)) begin
      spi_sync_id_counter <= spi_sync_id_counter + 1'b1;
    end
  end
end

// when offload is disabled pull up all CS signals
assign cmd = (cmd_valid_s) ? 16'h10ff : (cmd_int_s[15:8] == 8'h30) ?
                                        {cmd_int_s[15:8], spi_sync_id_counter} : cmd_int_s;

/*
 * Forwarded SYNC interface, this can be used to monitor the state of the
 * offload command sequence through SPI Engine regmap
 */

assign status_sync_data = sync_data;
assign status_sync_valid = sync_valid;
assign sync_ready = status_sync_ready;

wire ctrl_enable_ned;

assign ctrl_enable_ed = ~ctrl_enable_d & ctrl_enable;
assign ctrl_enable_ned = ctrl_enable_d & ~ctrl_enable;
assign spi_active_ed = spi_active_d & ~spi_active;

reg cmd_sdo_en_os = 1'h0;

always @(posedge spi_clk) begin
  ctrl_enable_d <= ctrl_enable; //check for clock domain
  spi_active_d <= spi_active;
  if (ctrl_enable_ed) begin
    cmd_sdo_en_os <= 1'h1;
  end else if (spi_active_ed) begin
    cmd_sdo_en_os <= 1'h0;
  end
  if (ctrl_enable_ned) begin // when offload is disable pull up all CS signals
    cmd_valid_s <= 1'h1;
  end else if (cmd_ready) begin
    cmd_valid_s <= 1'h0;
  end
end

generate if (ASYNC_SPI_CLK) begin

/*
 * The synchronization circuit takes care that there are no glitches on the
 * ctrl_enabled signal. ctrl_do_enable is asserted whenever ctrl_enable is
 * asserted, but only deasserted once the signal has been synchronized back from
 * the SPI domain. This makes sure that we can't end up in a state where the
 * enable signal in the SPI domain is asserted, but neither enable nor enabled
 * is asserted in the control domain.
 */

 (* mark_debug = "true" *) reg ctrl_do_enable = 1'b0;
 (* mark_debug = "true" *) wire ctrl_is_enabled;
 (* mark_debug = "true" *) reg spi_enabled = 1'b0;

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

//OS cmd switch
assign spi_cmd_rd_addr_next = spi_cmd_rd_addr + 1;
assign spi_cmd_os_rd_addr_next = spi_cmd_os_rd_addr + 1;

wire trigger_s = trigger_i & ~spi_active;
wire trigger_i;


sync_bits #(
  .NUM_OF_BITS(1),
  .ASYNC_CLK(ASYNC_TRIG)
) i_sync_trigger (
  .in_bits(trigger),
  .out_clk(spi_clk),
  .out_resetn(1'b1),
  .out_bits(trigger_i)
);

always @(posedge spi_clk) begin
  if (spi_resetn == 1'b0) begin
    spi_active <= 1'b0;
  end else begin
    if (spi_active == 1'b0) begin
      // start offload when we have a valid trigger, offload is enabled and
      // the DMA is enabled
      if (trigger_s == 1'b1 && spi_enable == 1'b1 && offload_sdi_ready == 1'b1) begin
        spi_active <= 1'b1;
      end
    end else if (cmd_ready == 1'b1 && ((spi_cmd_rd_addr_next == ctrl_cmd_wr_addr) || (spi_cmd_os_rd_addr_next == ctrl_cmd_os_wr_addr))) begin
      spi_active <= 1'b0;
    end
  end
end

always @(posedge spi_clk) begin
  if (cmd_valid == 1'b0) begin
    spi_cmd_rd_addr <= 'h0;
    spi_cmd_os_rd_addr <= 'h0;
  end else if (cmd_ready == 1'b1) begin
    if (cmd_sdo_en_os) begin
      spi_cmd_os_rd_addr <= spi_cmd_os_rd_addr_next;
    end else begin
      spi_cmd_rd_addr <= spi_cmd_rd_addr_next;
    end
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
  if (ctrl_mem_reset == 1'b1) begin
    ctrl_cmd_wr_addr <= 'h00;
    ctrl_cmd_os_wr_addr <= 'h00;
  end else if (ctrl_cmd_wr_en == 1'b1) begin
    if (cmd_mem_os_s) begin
      ctrl_cmd_os_wr_addr <= ctrl_cmd_os_wr_addr + 1'b1;
    end else begin
      ctrl_cmd_wr_addr <= ctrl_cmd_wr_addr + 1'b1;
    end
  end
end

always @(posedge ctrl_clk) begin
  if (ctrl_cmd_wr_en == 1'b1) begin
    if (cmd_mem_os_s) begin
      cmd_mem_os[ctrl_cmd_os_wr_addr] <= {1'h0, ctrl_cmd_wr_data[14:0]};
    end else begin
      cmd_mem[ctrl_cmd_wr_addr] <= {1'h0, ctrl_cmd_wr_data[14:0]};
    end
  end
end

always @(posedge ctrl_clk) begin
  if (ctrl_mem_reset == 1'b1)
    ctrl_sdo_wr_addr <= 'h00;
  else if (ctrl_sdo_wr_en == 1'b1)
    ctrl_sdo_wr_addr <= ctrl_sdo_wr_addr + 1'b1;
end

//make memory one-shot optional. if param is kept spi engine script needs update
generate if (SDO_MEM_OS) begin
  always @(posedge ctrl_clk) begin
    if (ctrl_mem_reset == 1'b1) begin
      ctrl_sdo_wr_addr_1 <= 'h0;
    end else if (trigger_s == 1'b1 && cmd_sdo_en_os == 1'b1) begin
      ctrl_sdo_wr_addr_1 <= ctrl_sdo_wr_addr;
    end else if (sdo_data_ready == 1'b1 && mem_empty == 0) begin
      ctrl_sdo_wr_addr_1 <= ctrl_sdo_wr_addr_1 - 1'b1;
    end
  end
end else begin
  always @(posedge ctrl_clk) begin
    if (ctrl_mem_reset == 1'b1) begin
      ctrl_sdo_wr_addr_1 <= 'h0;
    end else if (trigger_s == 1'b1) begin
      ctrl_sdo_wr_addr_1 <= ctrl_sdo_wr_addr;
    end else if (sdo_data_ready == 1'b1 && mem_empty == 0) begin
      ctrl_sdo_wr_addr_1 <= ctrl_sdo_wr_addr_1 - 1'b1;
    end
  end
end
endgenerate

always @(posedge ctrl_clk) begin
  if (ctrl_sdo_wr_en == 1'b1)
    sdo_mem[ctrl_sdo_wr_addr] <= ctrl_sdo_wr_data;
end

endmodule
