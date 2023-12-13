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

module regmap_tb;
  parameter VCD_FILE = {`__FILE__,"cd"};

  `define TIMEOUT 1000000
  `include "tb_base.v"

  localparam DMA_LENGTH_WIDTH = 24;
  localparam BYTES_PER_BEAT = 1;
  localparam DMA_AXI_ADDR_WIDTH = 32;

  localparam LENGTH_ALIGN = 2;
  localparam LENGTH_MASK = {DMA_LENGTH_WIDTH{1'b1}};
  localparam LENGTH_ALIGN_MASK = {LENGTH_ALIGN{1'b1}};
  localparam STRIDE_MASK = {{DMA_LENGTH_WIDTH-BYTES_PER_BEAT{1'b1}},{BYTES_PER_BEAT{1'b0}}};
  localparam ADDR_MASK = {{DMA_AXI_ADDR_WIDTH-BYTES_PER_BEAT{1'b1}},{BYTES_PER_BEAT{1'b0}}};

  localparam VAL_DBG_SRC_ADDR = 32'h76543210;
  localparam VAL_DBG_DEST_ADDR = 32'hfedcba98;
  localparam VAL_DBG_STATUS = 12'ha5;
  localparam VAL_DBG_IDS0 = 32'h01234567;
  localparam VAL_DBG_IDS1 = 32'h89abcdef;

  localparam AW = 11;
  localparam NUM_REGS = 'h200;

  wire s_axi_aclk = clk;
  wire s_axi_aresetn = ~reset;

  reg s_axi_awvalid = 1'b0;
  reg s_axi_wvalid = 1'b0;
  reg [AW-1:0] s_axi_awaddr = 'h00;
  reg [31:0] s_axi_wdata = 'h00;
  wire [1:0] s_axi_bresp;
  wire s_axi_awready;
  wire s_axi_wready;
  wire s_axi_bready = 1'b1;
  wire [3:0] s_axi_wstrb = 4'b1111;
  wire [2:0] s_axi_awprot = 3'b000;
  wire [2:0] s_axi_arprot = 3'b000;
  wire [1:0] s_axi_rresp;
  wire [31:0] s_axi_rdata;

  task write_reg;
  input [31:0] addr;
  input [31:0] value;
  begin
    @(posedge s_axi_aclk)
    s_axi_awvalid <= 1'b1;
    s_axi_wvalid <= 1'b1;
    s_axi_awaddr <= addr;
    s_axi_wdata <= value;
    @(posedge s_axi_aclk)
    while (s_axi_awvalid || s_axi_wvalid) begin
      @(posedge s_axi_aclk)
      if (s_axi_awready)
        s_axi_awvalid <= 1'b0;
      if (s_axi_wready)
        s_axi_wvalid <= 1'b0;
    end
  end
  endtask

  reg [31:0] expected_reg_mem[0:NUM_REGS-1];

  reg [AW-1:0] s_axi_araddr = 'h0;
  reg s_axi_arvalid = 'h0;
  reg s_axi_rready = 'h0;
  wire s_axi_arready;
  wire s_axi_rvalid;

  task read_reg;
  input [31:0] addr;
  output [31:0] value;
  begin
    s_axi_arvalid <= 1'b1;
    s_axi_araddr <= addr;
    s_axi_rready <= 1'b1;
    @(posedge s_axi_aclk) #0;
    while (s_axi_arvalid) begin
      if (s_axi_arready == 1'b1) begin
        s_axi_arvalid <= 1'b0;
      end
      @(posedge s_axi_aclk) #0;
    end

    while (s_axi_rready) begin
      if (s_axi_rvalid == 1'b1) begin
        value <= s_axi_rdata;
        s_axi_rready <= 1'b0;
      end
      @(posedge s_axi_aclk) #0;
    end
  end
  endtask

  task read_reg_check;
  input [31:0] addr;
  output match;
  reg [31:0] value;
  reg [31:0] expected;
  input [255:0] message;
  begin
    read_reg(addr, value);
    expected = expected_reg_mem[addr[11:2]];
    match <= value === expected;
    if (value !== expected) begin
      $display("%0s: Register mismatch for %x. Expected %x, got %x",
        message, addr, expected, value);
    end
  end
  endtask

  reg read_match = 1'b1;

  always @(posedge clk) begin
    if (read_match == 1'b0) begin
      failed <= 1'b1;
    end
  end

  task set_reset_reg_value;
  input [31:0] addr;
  input [31:0] value;
  begin
    expected_reg_mem[addr[AW-1:2]] <= value;
  end
  endtask

  task initialize_expected_reg_mem;
  integer i;
  begin
    for (i = 0; i < NUM_REGS; i = i + 1)
      expected_reg_mem[i] <= 'h00;
    /* Non zero power-on-reset values */
    set_reset_reg_value('h00, 32'h00040361); /* PCORE version register */
    set_reset_reg_value('h0c, 32'h444d4143); /* PCORE magic register */
    set_reset_reg_value('h10, 32'h00002101); /* Interface Description*/
    set_reset_reg_value('h80, 'h3); /* IRQ mask */

    set_reset_reg_value('h40c, 'h3); /* Flags */
    set_reset_reg_value('h418, LENGTH_ALIGN_MASK); /* Length alignment */

    set_reset_reg_value('h434, VAL_DBG_DEST_ADDR);
    set_reset_reg_value('h438, VAL_DBG_SRC_ADDR);
    set_reset_reg_value('h43c, VAL_DBG_STATUS);
    set_reset_reg_value('h440, VAL_DBG_IDS0);
    set_reset_reg_value('h444, VAL_DBG_IDS1);
  end
  endtask

  task check_all_registers;
  input [255:0] message;
  integer i;
  begin
    for (i = 0; i < NUM_REGS*4; i = i + 4) begin
      read_reg_check(i, read_match, message);
    end
  end
  endtask

  task write_reg_and_update;
  input [31:0] addr;
  input [31:0] value;
  integer i;
  begin
    write_reg(addr, value);
    expected_reg_mem[addr[AW-1:2]] <= value;
  end
  endtask

  task invert_register;
  input [31:0] addr;
  reg [31:0] value;
  begin
    read_reg(addr, value);
    write_reg(addr, ~value);
  end
  endtask

  task invert_all_registers;
  integer i;
  begin
    for (i = 0; i < NUM_REGS*4; i = i + 4) begin
      invert_register(i);
    end
  end
  endtask

  reg request_ready = 1'b0;
  wire [31:BYTES_PER_BEAT] request_dest_address;
  wire [31:BYTES_PER_BEAT] request_src_address;
  wire [DMA_LENGTH_WIDTH-1:0] request_x_length;
  wire [DMA_LENGTH_WIDTH-1:0] request_y_length;
  wire [DMA_LENGTH_WIDTH-1:0] request_dest_stride;
  wire [DMA_LENGTH_WIDTH-1:0] request_src_stride;
  wire request_last;

  reg response_eot = 1'b0;

  wire [6:0] response_measured_burst_length = 'hff;
  wire ctrl_enable;
  wire ctrl_pause;
  wire request_valid;
  wire request_sync_transfer_start;
  wire response_partial = 1'b1;

  reg  response_valid = 1'b0;
  wire response_ready;

  always @(posedge clk)  begin
    if (request_valid & request_ready) begin
        response_valid <= 1'b1;
    end else if (response_ready) begin
        response_valid <= 1'b0;
    end
  end

  integer i;
  initial begin
    initialize_expected_reg_mem();
    @(posedge s_axi_aresetn)
    set_reset_reg_value('h44c, 32'hxxxxxxxx);
    set_reset_reg_value('h450, 2'bX);
    check_all_registers("Initial");

    /* Check scratch */
    write_reg_and_update('h08, 32'h12345678);
    check_all_registers("Scratch");

    /* Check IRQ mask */
    write_reg_and_update('h80, 32'h0);
    check_all_registers("IRQ mask");

    /* Check transfer registers */
    write_reg_and_update('h40c, 'h7);
    write_reg_and_update('h410, ADDR_MASK);
    write_reg_and_update('h414, ADDR_MASK);
    write_reg_and_update('h418, LENGTH_MASK);
    write_reg_and_update('h41c, LENGTH_MASK);
    write_reg_and_update('h420, STRIDE_MASK);
    write_reg_and_update('h424, STRIDE_MASK);

    check_all_registers("Transfer setup 1");

    /* Check transfer registers */
    write_reg_and_update('h40c, {$random} & 'h7);
    write_reg_and_update('h410, {$random} & ADDR_MASK);
    write_reg_and_update('h414, {$random} & ADDR_MASK);
    write_reg_and_update('h418, {$random} & LENGTH_MASK | LENGTH_ALIGN_MASK);
    write_reg_and_update('h41c, {$random} & LENGTH_MASK);
    write_reg_and_update('h420, {$random} & STRIDE_MASK);
    write_reg_and_update('h424, {$random} & STRIDE_MASK);

    check_all_registers("Transfer setup 2");

    /* Start transfer */
    write_reg_and_update('h400, 'h01);
    write_reg_and_update('h408, 'h01);
    set_reset_reg_value('h428, 32'h00000000);
    set_reset_reg_value('h448, 24'h000000);
    set_reset_reg_value('h44c, 32'hxxxxxxxx);
    set_reset_reg_value('h450, 2'bX);

    check_all_registers("Transfer submitted");

    @(posedge clk) request_ready <= 1'b1;

    /* Interrupt pending */
    set_reset_reg_value('h84, 'h01);
    set_reset_reg_value('h88, 'h01);

    /* Transfer ID */
    set_reset_reg_value('h404, 'h01);

    /* Tansfer pending */
    set_reset_reg_value('h408, 'h00);
    set_reset_reg_value('h428, 32'h80000000);
    set_reset_reg_value('h448, 24'h000080);
    set_reset_reg_value('h44c, 32'h00000080);
    set_reset_reg_value('h450, 'h0);
    check_all_registers("Transfer accepted");

    @(posedge clk) response_eot <= 1'b1;
    @(posedge clk) response_eot <= 1'b0;

    /* Interrupt registers */
    set_reset_reg_value('h84, 'h01);
    set_reset_reg_value('h88, 'h01);

    set_reset_reg_value('h428, 'h00);
    set_reset_reg_value('h42c, 'h00);
    set_reset_reg_value('h44c, 32'h00000080);
    set_reset_reg_value('h450, 'h0);
    set_reset_reg_value('h448, 24'h000080);

    check_all_registers("Transfer completed");

    /* Clear interrupts */
    write_reg('h84, 'h01);
    set_reset_reg_value('h84, 'h00);
    set_reset_reg_value('h88, 'h00);

    check_all_registers("Clear interrupts 1");

    write_reg('h84, 'h02);
    set_reset_reg_value('h84, 'h00);
    set_reset_reg_value('h88, 'h00);

    check_all_registers("Clear interrupts 2");

    /* Check that reset works for all registers */
    do_trigger_reset();
    initialize_expected_reg_mem();
    write_reg_and_update('h40c, 'h00);
    set_reset_reg_value('h44c, 32'h00000080);
    check_all_registers("Reset 1");
    invert_all_registers();
    do_trigger_reset();
    write_reg_and_update('h40c, 'h00);
    set_reset_reg_value('h44c, 32'h00000080);
    check_all_registers("Reset 2");
  end

  axi_dmac_regmap #(
    .ID(0),
    .DISABLE_DEBUG_REGISTERS(0),
    .BYTES_PER_BEAT_WIDTH_DEST(BYTES_PER_BEAT),
    .BYTES_PER_BEAT_WIDTH_SRC(BYTES_PER_BEAT),
    .DMA_AXI_ADDR_WIDTH(DMA_AXI_ADDR_WIDTH),
    .DMA_LENGTH_WIDTH(DMA_LENGTH_WIDTH),
    .DMA_LENGTH_ALIGN(LENGTH_ALIGN),
    .DMA_CYCLIC(1),
    .BYTES_PER_BURST_WIDTH(7),
    .HAS_DEST_ADDR(1),
    .HAS_SRC_ADDR(1),
    .DMA_2D_TRANSFER(1),
    .SYNC_TRANSFER_START(0)
  ) i_axi (
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

    .ctrl_enable(ctrl_enable),
    .ctrl_pause(ctrl_pause),

    .request_valid(request_valid),
    .request_ready(request_ready),
    .request_dest_address(request_dest_address),
    .request_src_address(request_src_address),
    .request_x_length(request_x_length),
    .request_y_length(request_y_length),
    .request_dest_stride(request_dest_stride),
    .request_src_stride(request_src_stride),
    .request_last(request_last),
    .request_sync_transfer_start(request_sync_transfer_start),

    .irq(irq),

    .response_eot(response_eot),
    .response_measured_burst_length(response_measured_burst_length),
    .response_partial(response_partial),
    .response_valid(response_valid),
    .response_ready(response_ready),

    .dbg_src_addr(VAL_DBG_SRC_ADDR),
    .dbg_dest_addr(VAL_DBG_DEST_ADDR),
    .dbg_status(VAL_DBG_STATUS),
    .dbg_ids0(VAL_DBG_IDS0),
    .dbg_ids1(VAL_DBG_IDS1));

endmodule
