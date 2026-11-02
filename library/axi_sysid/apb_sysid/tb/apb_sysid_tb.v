// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

// apb_sysid: the register map of axi_sysid over APB. The core version, the
// magic, ROM_ADDR_BITS, the scratch register and the whole system and PR ROMs
// (a ROM with a read latency of 1, as sysid_rom) read back, also with
// back-to-back transfers (no idle cycle between them).

module apb_sysid_tb;

  localparam ROM_ADDR_BITS = 9;
  localparam ROM_DEPTH = 1 << ROM_ADDR_BITS;

  reg         clk = 1'b0;
  reg         resetn = 1'b0;
  reg  [15:0] paddr = 16'd0;
  reg         psel = 1'b0;
  reg         penable = 1'b0;
  reg         pwrite = 1'b0;
  reg  [31:0] pwdata = 32'd0;
  wire [31:0] prdata;
  wire        pready;
  wire        pslverr;

  wire [ROM_ADDR_BITS-1:0] rom_addr;
  reg  [31:0] sys_rom_data = 32'd0;
  reg  [31:0] pr_rom_data = 32'd0;

  reg  [31:0] rdata;
  integer     i;
  integer     errors = 0;

  always #5 clk = ~clk;

  apb_sysid #(
    .ROM_WIDTH (32),
    .ROM_ADDR_BITS (ROM_ADDR_BITS)
  ) dut (
    .s_axi_aclk (clk),
    .s_axi_aresetn (resetn),
    .s_apb_paddr (paddr),
    .s_apb_penable (penable),
    .s_apb_prdata (prdata),
    .s_apb_pready (pready),
    .s_apb_psel (psel),
    .s_apb_pslverr (pslverr),
    .s_apb_pwdata (pwdata),
    .s_apb_pwrite (pwrite),
    .sys_rom_data (sys_rom_data),
    .pr_rom_data (pr_rom_data),
    .rom_addr (rom_addr));

  // ROM contents, a read latency of 1 clock cycle as sysid_rom
  function [31:0] sys_rom;
    input [ROM_ADDR_BITS-1:0] a;
    sys_rom = {16'h5a5a, 7'd0, a};
  endfunction

  function [31:0] pr_rom;
    input [ROM_ADDR_BITS-1:0] a;
    pr_rom = {16'hc3c3, ~a, 7'h7f};
  endfunction

  always @(posedge clk) begin
    sys_rom_data <= sys_rom(rom_addr);
    pr_rom_data <= pr_rom(rom_addr);
  end

  // APB transfer: setup phase, access phase until pready; with last = 0 the
  // next transfer starts right after it (psel stays high)
  task apb;
    input        write;
    input [15:0] addr;
    input [31:0] data;
    input        last;
    begin
      psel <= 1'b1;
      penable <= 1'b0;
      pwrite <= write;
      paddr <= addr;
      pwdata <= data;
      @(posedge clk);
      penable <= 1'b1;
      @(posedge clk);
      while (pready !== 1'b1)
        @(posedge clk);
      rdata = prdata;
      if (pslverr !== 1'b0) begin
        $display("ERROR: pslverr at 0x%h", addr);
        errors = errors + 1;
      end
      penable <= 1'b0;
      if (last)
        psel <= 1'b0;
    end
  endtask

  task check_read;
    input [15:0] addr;
    input [31:0] expected;
    input        last;
    begin
      apb(1'b0, addr, 32'd0, last);
      if (rdata !== expected) begin
        $display("ERROR: read 0x%h: 0x%h, expected 0x%h", addr, rdata, expected);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    repeat (4) @(posedge clk);
    resetn <= 1'b1;
    repeat (4) @(posedge clk);

    // registers
    check_read(16'h0000, 32'h00010161, 1);
    check_read(16'h0004, 32'h00000000, 1);
    check_read(16'h000c, 32'h53594944, 1);
    check_read(16'h0040, ROM_ADDR_BITS, 1);
    check_read(16'h0008, 32'h00000000, 1);
    apb(1'b1, 16'h0008, 32'hdeadbeef, 1);
    check_read(16'h0008, 32'hdeadbeef, 1);

    // back to back: write, read, write, read of the scratch register, then
    // the registers and both ROMs without idle cycles
    apb(1'b1, 16'h0008, 32'h12345678, 0);
    check_read(16'h0008, 32'h12345678, 0);
    apb(1'b1, 16'h0008, 32'h87654321, 0);
    check_read(16'h0008, 32'h87654321, 0);
    check_read(16'h0000, 32'h00010161, 0);
    check_read(16'h000c, 32'h53594944, 0);
    for (i = 0; i < ROM_DEPTH; i = i + 1)
      check_read((16'h0200 + i) << 2, sys_rom(i), 0);
    for (i = 0; i < ROM_DEPTH; i = i + 1)
      check_read((16'h0400 + i) << 2, pr_rom(i), 0);
    // address bits 10:9 = 3: neither ROM
    check_read(16'h0600 << 2, 32'h00000000, 1);

    // the ROMs again with idle cycles between the transfers
    for (i = 0; i < ROM_DEPTH; i = i + 37)
      check_read((16'h0200 + i) << 2, sys_rom(i), 1);
    for (i = 0; i < ROM_DEPTH; i = i + 37)
      check_read((16'h0400 + i) << 2, pr_rom(i), 1);

    if (errors == 0)
      $display("SUCCESS: apb_sysid, registers and %0d ROM words", 2 * ROM_DEPTH);
    else
      $display("FAILED: apb_sysid, %0d errors", errors);
    $finish;
  end

endmodule
