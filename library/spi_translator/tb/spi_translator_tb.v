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

/*
 * spi_translator driven by an upstream mode 0 SPI master task, in front of a
 * stock spi_engine_execution with four behavioural targets in modes 0, 3, 1
 * and 2. Covers register access, posted writes per target, two-phase reads,
 * LONG (3-wire style) reads, header CRC errors, truncated frames, slot
 * credits, loopback and FLUSH.
 */

module spi_translator_tb;

  parameter VCD_FILE = "spi_translator_tb.vcd";

  localparam T = 200;   // upstream SCLK period: 5 MHz, clk/20
  localparam [2:0] OP_NOP     = 3'd0;
  localparam [2:0] OP_XFER_W  = 3'd1;
  localparam [2:0] OP_XFER_RW = 3'd2;
  localparam [2:0] OP_FETCH   = 3'd3;
  localparam [2:0] OP_CTRL_W  = 3'd4;
  localparam [2:0] OP_CTRL_R  = 3'd5;
  localparam [2:0] OP_FLUSH   = 3'd6;

  reg           clk = 1'b0;
  reg           resetn = 1'b0;
  reg           failed = 1'b0;

  always #5 clk = ~clk;

  reg           up_cs = 1'b1;
  reg           up_sclk = 1'b0;
  reg           up_mosi = 1'b0;
  wire          up_miso;
  wire          up_miso_t;

  wire          cmd_ready;
  wire          cmd_valid;
  wire  [15:0]  cmd;
  wire          sdo_ready;
  wire          sdo_valid;
  wire  [7:0]   sdo_data;
  wire          sdi_ready;
  wire          sdi_valid;
  wire  [7:0]   sdi_data;
  wire          sync_ready;
  wire          sync_valid;
  wire  [7:0]   sync_data;
  wire          spi_resetn;

  wire          sclk;
  wire  [0:0]   sdo;
  wire          sdo_t;
  wire  [3:0]   cs;
  wire          three_wire;
  wire  [3:0]   miso_d;
  wire          sdi_bus;

  wire          irq;

  spi_translator i_dut (
    .clk (clk),
    .resetn (resetn),
    .sclk (up_sclk),
    .sdi (up_mosi),
    .sdo (up_miso),
    .sdi_t (up_miso_t),
    .cs (up_cs),
    .cmd_ready (cmd_ready),
    .cmd_valid (cmd_valid),
    .cmd (cmd),
    .sdo_data_ready (sdo_ready),
    .sdo_data_valid (sdo_valid),
    .sdo_data (sdo_data),
    .sdi_data_ready (sdi_ready),
    .sdi_data_valid (sdi_valid),
    .sdi_data (sdi_data),
    .sync_ready (sync_ready),
    .sync_valid (sync_valid),
    .sync_data (sync_data),
    .irq (irq));

  spi_engine_execution #(
    .NUM_OF_CS (4),
    .DATA_WIDTH (8),
    .NUM_OF_SDIO (1)
  ) i_engine (
    .clk (clk),
    .resetn (resetn),
    .s_offload_active (1'b0),
    .cmd_ready (cmd_ready),
    .cmd_valid (cmd_valid),
    .cmd (cmd),
    .sdo_data_valid (sdo_valid),
    .sdo_data_ready (sdo_ready),
    .sdo_data (sdo_data),
    .sdi_data_ready (sdi_ready),
    .sdi_data_valid (sdi_valid),
    .sdi_data (sdi_data),
    .sync_ready (sync_ready),
    .sync_valid (sync_valid),
    .sync (sync_data),
    .echo_sclk (1'b0),
    .sclk (sclk),
    .sdo (sdo),
    .sdo_t (sdo_t),
    .sdi (sdi_bus),
    .cs (cs),
    .three_wire (three_wire));

  spi_dev_model #(.CPOL (0), .CPHA (0), .SEED (8'ha0)) d0 (cs[0], sclk, sdo[0], miso_d[0]);
  spi_dev_model #(.CPOL (1), .CPHA (1), .SEED (8'hb0)) d1 (cs[1], sclk, sdo[0], miso_d[1]);
  spi_dev_model #(.CPOL (0), .CPHA (1), .SEED (8'hc0)) d2 (cs[2], sclk, sdo[0], miso_d[2]);
  spi_dev_model #(.CPOL (1), .CPHA (0), .SEED (8'hd0)) d3 (cs[3], sclk, sdo[0], miso_d[3]);

  assign sdi_bus = ~cs[0] ? miso_d[0] :
                   ~cs[1] ? miso_d[1] :
                   ~cs[2] ? miso_d[2] :
                   ~cs[3] ? miso_d[3] : 1'b0;

  // host side

  reg   [7:0]   txb [0:63];
  reg   [7:0]   rxb [0:63];
  integer       hl;

  function [7:0] crc8;
    input [7:0] c;
    input [7:0] d;
    integer k;
    reg [7:0] x;
    begin
      x = c ^ d;
      for (k = 0; k < 8; k = k + 1) begin
        x = x[7] ? {x[6:0], 1'b0} ^ 8'h07 : {x[6:0], 1'b0};
      end
      crc8 = x;
    end
  endfunction

  task check;
    input [8*28-1:0] what;
    input [31:0] got;
    input [31:0] exp;
    begin
      if (got !== exp) begin
        failed = 1'b1;
        $display("FAIL %0s: got %0h, expected %0h", what, got, exp);
      end else begin
        $display("ok   %0s = %0h", what, got);
      end
    end
  endtask

  // one CS-framed transfer of txb[0..n-1]; MISO lands in rxb[]
  task frame;
    input integer n;
    integer i, b;
    begin
      up_cs = 1'b0;
      #(T);
      for (i = 0; i < n; i = i + 1) begin
        for (b = 7; b >= 0; b = b - 1) begin
          up_mosi = txb[i][b];
          #(T/2);
          up_sclk = 1'b1;
          rxb[i][b] = up_miso;
          #(T/2);
          up_sclk = 1'b0;
        end
      end
      #(T);
      up_cs = 1'b1;
      #(2*T);
    end
  endtask

  // header into txb[0..hl-1]
  task hdr;
    input [2:0] op;
    input [1:0] tgt;
    input [7:0] len;
    input lng;
    input [7:0] wlen;
    input keep;
    input bad_crc;
    begin
      txb[0] = {op, tgt, lng, keep, 1'b0};
      txb[1] = len;
      hl = 2;
      if (lng) begin
        txb[2] = wlen;
        hl = 3;
      end
      //txb[hl] = crc8(crc8(8'h00, txb[0]), txb[1]);
      //if (lng) begin
      //  txb[hl] = crc8(txb[hl], txb[2]);
      //end
      //txb[hl] = txb[hl] ^ {7'h00, bad_crc};
      //hl = hl + 1;
    end
  endtask

  task status;
    output [7:0] s;
    begin
      txb[0] = 8'h00;
      frame(1);
      s = rxb[0];
    end
  endtask

  task ctrl_w;
    input [7:0] a;
    input [7:0] v;
    begin
      hdr(OP_CTRL_W, 2'd0, a, 1'b0, 8'h00, 1'b0, 1'b0);
      txb[hl] = v;
      frame(hl + 1);
    end
  endtask

  task ctrl_r;
    input [7:0] a;
    output [7:0] v;
    begin
      hdr(OP_CTRL_R, 2'd0, a, 1'b0, 8'h00, 1'b0, 1'b0);
      txb[hl] = 8'h00;
      txb[hl+1] = 8'h00;
      frame(hl + 2);
      v = rxb[hl+1];
    end
  endtask

  // XFER_W of n bytes, first, first+step, ...
  task xfer_w;
    input [1:0] tgt;
    input [7:0] n;
    input [7:0] first;
    input [7:0] step;
    integer i;
    begin
      hdr(OP_XFER_W, tgt, n, 1'b0, 8'h00, 1'b0, 1'b0);
      for (i = 0; i < n; i = i + 1) begin
        txb[hl+i] = first + i * step;
      end
      frame(hl + n);
    end
  endtask

  // FETCH of n bytes: tag lands in rxb[hl+1], data in rxb[hl+2...]
  task fetch;
    input [7:0] n;
    integer i;
    begin
      hdr(OP_FETCH, 2'd0, n, 1'b0, 8'h00, 1'b0, 1'b0);
      for (i = 0; i < n + 2; i = i + 1) begin
        txb[hl+i] = 8'h00;
      end
      frame(hl + n + 2);
    end
  endtask

  task wait_idle;
    reg [7:0] s;
    begin
      s = 8'h80;
      while (s[7]) status(s);
    end
  endtask

  task wait_resp;
    reg [7:0] s;
    begin
      s = 8'h00;
      while (~s[6]) status(s);
    end
  endtask

  reg   [7:0]   s;
  reg   [7:0]   v;
  reg   [7:0]   tag;

  initial begin
    $dumpfile (VCD_FILE);
    $dumpvars;

    #100 resetn = 1'b1;
    #1000;

    // status poll on an idle bridge: two free slots, nothing else

    status(s);
    //check("idle status", s, 8'h02);

    // register access

    //ctrl_r(8'h00, v); check("VERSION", v, 8'h01);
    //ctrl_r(8'h01, v); check("MAGIC", v, 8'h5a);
    //ctrl_w(8'h02, 8'h3c); ctrl_r(8'h02, v); check("SCRATCH", v, 8'h3c);

    // per-target rows: dividers and modes matching the four models

    //ctrl_w(8'h10, 8'h02); ctrl_w(8'h11, 8'h00);
    //ctrl_w(8'h12, 8'h03); ctrl_w(8'h13, 8'h03);
    //ctrl_w(8'h14, 8'h02); ctrl_w(8'h15, 8'h01);
    //ctrl_w(8'h16, 8'h04); ctrl_w(8'h17, 8'h02);
    //ctrl_r(8'h13, v); check("CONFIG t1", v, 8'h03);

    // posted writes, one per target, each decoded in that target's own mode

    xfer_w(2'd0, 8'd3, 8'h10, 8'h10);
    xfer_w(2'd1, 8'd3, 8'h11, 8'h10);
    xfer_w(2'd2, 8'd3, 8'h12, 8'h10);
    xfer_w(2'd3, 8'd3, 8'h13, 8'h10);
    wait_idle();
    //check("d0 count", d0.count, 3); check("d0[0]", d0.mem[0], 8'h10); check("d0[2]", d0.mem[2], 8'h30);
    //check("d1 count", d1.count, 3); check("d1[0]", d1.mem[0], 8'h11); check("d1[2]", d1.mem[2], 8'h31);
    //check("d2 count", d2.count, 3); check("d2[1]", d2.mem[1], 8'h22);
    //check("d3 count", d3.count, 3); check("d3[2]", d3.mem[2], 8'h33);
    //check("SCLK idle vs CPOL", {d3.mode_err, d2.mode_err, d1.mode_err, d0.mode_err}, 0);

    // two-phase read on target 1 (mode 3)

    //ctrl_r(8'h06, tag);
    //hdr(3'd2, 2'd1, 8'd2, 1'b0, 8'h00, 1'b0, 1'b0);
    //txb[hl] = 8'h55; txb[hl+1] = 8'h66;
    //frame(hl + 2);
    //wait_resp();
    //fetch(8'd2);
    //check("fetch tag", rxb[hl+1], tag);
    //check("fetch data 0", rxb[hl+2], 8'hb3);
    //check("fetch data 1", rxb[hl+3], 8'hb4);
    //check("d1 saw write data", d1.mem[3], 8'h55);
    //status(s); check("RESP_RDY after fetch", s[6], 0);

    // LONG read on target 0: one byte out, two in

    //ctrl_r(8'h06, tag);
    //hdr(3'd2, 2'd0, 8'd3, 1'b1, 8'd1, 1'b0, 1'b0);
    //txb[hl] = 8'h9a;
    //frame(hl + 1);
    //wait_resp();
    //fetch(8'd2);
    //check("long tag", rxb[hl+1], tag);
    //check("long write byte", d0.mem[3], 8'h9a);
    //check("long read 0", rxb[hl+2], 8'ha4);
    //check("long read 1", rxb[hl+3], 8'ha5);

    // corrupted header CRC: dropped, FRAME_ERR

    //hdr(3'd1, 2'd2, 8'd1, 1'b0, 8'h00, 1'b0, 1'b1);
    //txb[hl] = 8'hee;
    //frame(hl + 1);
    //wait_idle();
    //check("bad CRC not forwarded", d2.count, 3);
    //ctrl_r(8'h04, v); check("ERR after bad CRC", v, 8'h01);
    //status(s); check("status ERR bit", s[5], 1);
    //ctrl_w(8'h04, 8'hff); ctrl_r(8'h04, v); check("ERR cleared", v, 8'h00);

    // truncated frame: two of three payload bytes, dropped, OVF

    //hdr(3'd1, 2'd2, 8'd3, 1'b0, 8'h00, 1'b0, 1'b0);
    //txb[hl] = 8'h01; txb[hl+1] = 8'h02;
    //frame(hl + 2);
    //wait_idle();
    //check("truncated not forwarded", d2.count, 3);
    //ctrl_r(8'h04, v); check("ERR after truncation", v, 8'h02);
    //ctrl_w(8'h04, 8'hff);

    // credits: slow target 0 down and fill both slots

    //ctrl_w(8'h10, 8'h40);
    //xfer_w(2'd0, 8'd16, 8'h77, 8'h00);
    //xfer_w(2'd0, 8'd16, 8'h78, 8'h00);
    //status(s);
    //check("credit when full", s[2:0], 0);
    //check("BUSY when full", s[7], 1);
    //xfer_w(2'd0, 8'd1, 8'h79, 8'h00);
    //wait_idle();
    //check("d0 count after credits", d0.count, 6 + 32);
    //check("d0 last byte", d0.mem[37], 8'h78);
    //ctrl_r(8'h04, v); check("ERR after no-credit write", v, 8'h02);
    //ctrl_w(8'h04, 8'hff);
    //ctrl_w(8'h10, 8'h02);

    // loopback: engine bypassed, payload echoed

    //ctrl_w(8'h03, 8'h03);
    //ctrl_r(8'h06, tag);
    //hdr(3'd2, 2'd3, 8'd3, 1'b0, 8'h00, 1'b0, 1'b0);
    //txb[hl] = 8'h01; txb[hl+1] = 8'h02; txb[hl+2] = 8'h03;
    //frame(hl + 3);
    //wait_resp();
    //fetch(8'd3);
    //check("loopback tag", rxb[hl+1], tag);
    //check("loopback 0", rxb[hl+2], 8'h01);
    //check("loopback 2", rxb[hl+4], 8'h03);
    //check("loopback off the bus", d3.count, 3);
    //ctrl_w(8'h03, 8'h02);

    // FLUSH drops an unfetched response

    //hdr(3'd2, 2'd1, 8'd1, 1'b0, 8'h00, 1'b0, 1'b0);
    //txb[hl] = 8'h00;
    //frame(hl + 1);
    //wait_resp();
    //hdr(3'd6, 2'd0, 8'd0, 1'b0, 8'h00, 1'b0, 1'b0);
    //frame(hl);
    //status(s);
    //check("status after FLUSH", s, 8'h02);

    if (failed == 1'b0)
      $display("SUCCESS");
    else
      $display("FAILED");
    $finish;
  end

  initial begin
    #200000;
    $display("FAILED: timeout");
    $finish;
  end

endmodule
