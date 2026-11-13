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
 * spi_translator_slave with NUM_OF_CS = 12 behind spi_translator_interconnect: engine
 * 0 with 8 chip selects, engine 1 with the remaining 4 and SDI_DELAY = 1, so
 * its last SDI word arrives after it goes idle. Two targets on each engine.
 * Covers the default engine, SELECT routing, reads from both engines returned
 * in stream order, SYNC_ID never ahead of the SDI bytes, SELECT rejected for a
 * missing engine or while a chip select is held, CHIPSELECT of a chip select
 * the engine does not have, FLUSH returning to engine 0, and a rejected frame
 * leaving the selection unchanged.
 */

module spi_translator_me_tb;

  parameter VCD_FILE = "spi_translator_me_tb.vcd";

  localparam T = 200;   // upstream SCLK period: 5 MHz, clk/20

  `define CFG(m)        (16'h2100 | (m))
  `define PRESCALE(d)   (16'h2000 | (d))
  `define CS(c)         (16'h1000 | (c))
  `define WR(n)         (16'h0100 | ((n) - 1))
  `define RD(n)         (16'h0200 | ((n) - 1))
  `define SYNC(id)      (16'h3000 | (id))

  `define BR_NOP          16'h8000
  `define BR_CTRL_R(a)    (16'hA000 | (((a) & 16'h000f) << 8))
  `define BR_SELECT(e)    (16'hC000 | ((e) & 16'h00ff))
  `define BR_FETCH(n)     (16'hD000 | ((n) - 1))
  `define BR_FLUSH        16'hE000
  `define BR_W1C(b)       (16'h9500 | (b))

  reg           clk = 1'b0;
  reg           resetn = 1'b0;
  reg           failed = 1'b0;

  always #5 clk = ~clk;

  reg           up_cs = 1'b1;
  reg           up_sclk = 1'b0;
  reg           up_mosi = 1'b0;
  wire          up_miso;
  wire          up_miso_t;

  // translator side of the interconnect
  wire          t_cmd_ready;
  wire          t_cmd_valid;
  wire  [15:0]  t_cmd;
  wire          t_sdo_ready;
  wire          t_sdo_valid;
  wire  [7:0]   t_sdo_data;
  wire          t_sdi_ready;
  wire          t_sdi_valid;
  wire  [7:0]   t_sdi_data;
  wire          t_sync_ready;
  wire          t_sync_valid;
  wire  [7:0]   t_sync_data;
  wire          spi_resetn;

  // engine side, per engine
  wire  [1:0]   cmd_ready;
  wire  [1:0]   cmd_valid;
  wire  [15:0]  cmd_0;
  wire  [15:0]  cmd_1;
  wire  [1:0]   sdo_ready;
  wire  [1:0]   sdo_valid;
  wire  [7:0]   sdo_data_0;
  wire  [7:0]   sdo_data_1;
  wire  [1:0]   sdi_ready;
  wire  [1:0]   sdi_valid;
  wire  [7:0]   sdi_data_0;
  wire  [7:0]   sdi_data_1;
  wire  [1:0]   sync_ready;
  wire  [1:0]   sync_valid;
  wire  [7:0]   sync_data_0;
  wire  [7:0]   sync_data_1;

  wire  [1:0]   sclk;
  wire  [0:0]   sdo_0;
  wire  [0:0]   sdo_1;
  wire  [7:0]   cs_0;
  wire  [3:0]   cs_1;
  wire  [1:0]   sdi_bus;

  wire          busy = i_dut.i_exec.busy;
  wire  [2:0]   err = i_dut.err;
  wire  [3:0]   eng = i_dut.i_decoder.eng;

  // frames carry no CHECK here, the CRC is covered by spi_translator_crc_tb
  spi_translator_slave #(
    .CRC_EN (0),
    .NUM_OF_CS (12),
    .NUM_OF_GPIO (0),
    .CMD_FIFO_ADDRESS_WIDTH (5),
    .SDO_FIFO_ADDRESS_WIDTH (5)
  ) i_dut (
    .clk (clk),
    .resetn (resetn),
    .sclk (up_sclk),
    .sdi (up_mosi),
    .sdo (up_miso),
    .sdi_t (up_miso_t),
    .cs (up_cs),
    .cmd_ready (t_cmd_ready),
    .cmd_valid (t_cmd_valid),
    .cmd (t_cmd),
    .sdo_data_ready (t_sdo_ready),
    .sdo_data_valid (t_sdo_valid),
    .sdo_data (t_sdo_data),
    .sdi_data_ready (t_sdi_ready),
    .sdi_data_valid (t_sdi_valid),
    .sdi_data (t_sdi_data),
    .sync_ready (t_sync_ready),
    .sync_valid (t_sync_valid),
    .sync_data (t_sync_data),
    .spi_resetn (spi_resetn),
    .gpio_i (1'b0),
    .gpio_o (),
    .gpio_t ());

  spi_translator_interconnect #(
    .NUM_OF_ENGINES (2)
  ) i_interconnect (
    .clk (clk),
    .resetn (spi_resetn),
    .s_cmd_ready (t_cmd_ready),
    .s_cmd_valid (t_cmd_valid),
    .s_cmd_data (t_cmd),
    .s_sdo_ready (t_sdo_ready),
    .s_sdo_valid (t_sdo_valid),
    .s_sdo_data (t_sdo_data),
    .s_sdi_ready (t_sdi_ready),
    .s_sdi_valid (t_sdi_valid),
    .s_sdi_data (t_sdi_data),
    .s_sync_ready (t_sync_ready),
    .s_sync_valid (t_sync_valid),
    .s_sync_data (t_sync_data),
    .m0_cmd_ready (cmd_ready[0]),
    .m0_cmd_valid (cmd_valid[0]),
    .m0_cmd_data (cmd_0),
    .m0_sdo_ready (sdo_ready[0]),
    .m0_sdo_valid (sdo_valid[0]),
    .m0_sdo_data (sdo_data_0),
    .m0_sdi_ready (sdi_ready[0]),
    .m0_sdi_valid (sdi_valid[0]),
    .m0_sdi_data (sdi_data_0),
    .m0_sync_ready (sync_ready[0]),
    .m0_sync_valid (sync_valid[0]),
    .m0_sync_data (sync_data_0),
    .m1_cmd_ready (cmd_ready[1]),
    .m1_cmd_valid (cmd_valid[1]),
    .m1_cmd_data (cmd_1),
    .m1_sdo_ready (sdo_ready[1]),
    .m1_sdo_valid (sdo_valid[1]),
    .m1_sdo_data (sdo_data_1),
    .m1_sdi_ready (sdi_ready[1]),
    .m1_sdi_valid (sdi_valid[1]),
    .m1_sdi_data (sdi_data_1),
    .m1_sync_ready (sync_ready[1]),
    .m1_sync_valid (sync_valid[1]),
    .m1_sync_data (sync_data_1));

  spi_engine_execution #(
    .NUM_OF_CS (8),
    .DATA_WIDTH (8),
    .NUM_OF_SDIO (1)
  ) i_engine_0 (
    .clk (clk),
    .resetn (spi_resetn),
    .s_offload_active (1'b0),
    .cmd_ready (cmd_ready[0]),
    .cmd_valid (cmd_valid[0]),
    .cmd (cmd_0),
    .sdo_data_valid (sdo_valid[0]),
    .sdo_data_ready (sdo_ready[0]),
    .sdo_data (sdo_data_0),
    .sdi_data_ready (sdi_ready[0]),
    .sdi_data_valid (sdi_valid[0]),
    .sdi_data (sdi_data_0),
    .sync_ready (sync_ready[0]),
    .sync_valid (sync_valid[0]),
    .sync (sync_data_0),
    .echo_sclk (1'b0),
    .sclk (sclk[0]),
    .sdo (sdo_0),
    .sdo_t (),
    .sdi (sdi_bus[0]),
    .cs (cs_0),
    .three_wire ());

  spi_engine_execution #(
    .NUM_OF_CS (4),
    .DATA_WIDTH (8),
    .NUM_OF_SDIO (1),
    .SDI_DELAY (2'b01)
  ) i_engine_1 (
    .clk (clk),
    .resetn (spi_resetn),
    .s_offload_active (1'b0),
    .cmd_ready (cmd_ready[1]),
    .cmd_valid (cmd_valid[1]),
    .cmd (cmd_1),
    .sdo_data_valid (sdo_valid[1]),
    .sdo_data_ready (sdo_ready[1]),
    .sdo_data (sdo_data_1),
    .sdi_data_ready (sdi_ready[1]),
    .sdi_data_valid (sdi_valid[1]),
    .sdi_data (sdi_data_1),
    .sync_ready (sync_ready[1]),
    .sync_valid (sync_valid[1]),
    .sync (sync_data_1),
    .echo_sclk (1'b0),
    .sclk (sclk[1]),
    .sdo (sdo_1),
    .sdo_t (),
    .sdi (sdi_bus[1]),
    .cs (cs_1),
    .three_wire ());

  // slaves 0 and 7 on engine 0, slaves 8 and 11 on engine 1
  wire  [3:0]   miso_d;

  spi_dev_model #(.CPOL (0), .CPHA (0), .SEED (8'h10)) s0  (cs_0[0], sclk[0], sdo_0[0], miso_d[0]);
  spi_dev_model #(.CPOL (1), .CPHA (1), .SEED (8'h70)) s7  (cs_0[7], sclk[0], sdo_0[0], miso_d[1]);
  spi_dev_model #(.CPOL (0), .CPHA (0), .SEED (8'h80)) s8  (cs_1[0], sclk[1], sdo_1[0], miso_d[2]);
  spi_dev_model #(.CPOL (0), .CPHA (1), .SEED (8'hb0)) s11 (cs_1[3], sclk[1], sdo_1[0], miso_d[3]);

  assign sdi_bus[0] = ~cs_0[0] ? miso_d[0] : ~cs_0[7] ? miso_d[1] : 1'b0;
  assign sdi_bus[1] = ~cs_1[0] ? miso_d[2] : ~cs_1[3] ? miso_d[3] : 1'b0;

  // at most one slave selected at any time, over both engines
  integer       overlap = 0;

  always @(cs_0 or cs_1) begin
    if (cs_0 != 8'hff && cs_1 != 4'hf) begin
      overlap = overlap + 1;
    end
  end

  // SDI bytes queued when each SYNC id reaches the translator
  reg   [8:0]   sync_level = 9'h000;

  always @(posedge clk) begin
    if (t_sync_valid && t_sync_ready) begin
      sync_level <= i_dut.resp_level + (t_sdi_valid && t_sdi_ready);
    end
  end

  // host side

  reg   [7:0]   txb [0:511];
  reg   [7:0]   rxb [0:511];
  reg   [7:0]   rep [0:255];
  integer       len;

  task check;
    input [8*40-1:0] what;
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

  task begin_frame;
    begin
      len = 0;
    end
  endtask

  task put8;
    input [7:0] b;
    begin
      txb[len] = b;
      len = len + 1;
    end
  endtask

  task put16;
    input [15:0] w;
    begin
      put8(w[15:8]);
      put8(w[7:0]);
    end
  endtask

  task send_frame;
    integer i, b;
    begin
      up_cs = 1'b0;
      #(T);
      for (i = 0; i < len; i = i + 1) begin
        for (b = 7; b >= 0; b = b - 1) begin
          up_mosi = txb[i][b];
          #(T/2);
          rxb[i][b] = up_miso;
          up_sclk = 1'b1;
          #(T/2);
          up_sclk = 1'b0;
        end
      end
      #(T);
      up_cs = 1'b1;
      #(2*T);
    end
  endtask

  task ctrl_r;
    input [7:0] a;
    output [7:0] v;
    begin
      begin_frame(); put16(`BR_CTRL_R(a)); put16(`BR_NOP); send_frame();
      v = rxb[2];
    end
  endtask

  task fetch;
    input integer n;
    integer i;
    begin
      begin_frame(); put16(`BR_FETCH(n));
      for (i = 0; i < n + 1; i = i + 1) put8(8'h00);
      send_frame();
      for (i = 0; i < n; i = i + 1) begin
        rep[i] = rxb[3+i];
      end
    end
  endtask

  task wait_sync;
    input [7:0] id;
    reg [7:0] last;
    begin
      last = ~id;
      while (last != id) ctrl_r(8'h06, last);
    end
  endtask

  task wait_idle;
    begin
      @(posedge clk);
      while (busy) @(posedge clk);
      repeat (20) @(posedge clk);
    end
  endtask

  task flush;
    begin
      begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();
    end
  endtask

  // one byte to chip select c of the selected engine
  task put_write;
    input [2:0] c;
    input [7:0] d;
    begin
      put16(`CS(8'hff & ~(8'h01 << c))); put16(`WR(1)); put8(d); put16(`CS(8'hff));
    end
  endtask

  integer       n0;
  integer       n7;
  integer       n8;
  integer       n11;
  reg   [7:0]   v;
  reg   [7:0]   s;

  initial begin
    $dumpfile (VCD_FILE);
    $dumpvars;

    #100 resetn = 1'b1;
    #1000;

    ctrl_r(8'h0f, v); check("CS_NUM", v, 8'd12);

    // engine 0 is selected after reset

    begin_frame();
    put16(`CFG(2'd3)); put16(`PRESCALE(8'h02));
    put16(`CS(8'h7f)); put16(`WR(2)); put8(8'h71); put8(8'h72); put16(`CS(8'hff));
    put16(`SYNC(8'h01));
    send_frame();
    wait_sync(8'h01);
    check("default engine 0: slave 7", s7.count, 2);
    check("slave 7 data", s7.mem[1], 8'h72);
    check("engine 1 untouched", s8.count + s11.count, 0);

    // SELECT 1 routes the rest of the frame to engine 1

    begin_frame();
    put16(`BR_SELECT(1));
    put16(`CFG(2'd1)); put16(`PRESCALE(8'h04));
    put16(`CS(8'hf7)); put16(`WR(2)); put8(8'hb1); put8(8'hb2); put16(`CS(8'hff));
    put16(`SYNC(8'h02));
    send_frame();
    wait_sync(8'h02);
    check("SELECT 1: slave 11", s11.count, 2);
    check("slave 11 data", s11.mem[0], 8'hb1);
    check("engine 0 not used", s0.count + s7.count, 2);
    check("selected engine tracked", eng, 4'd1);
    check("SDO mode of engine 1", s11.mode_err, 1'b0);

    // reads from both engines in one frame come back in stream order; the
    // switch follows engine 1's delayed last SDI word

    begin_frame();
    put16(`CFG(2'd0)); put16(`PRESCALE(8'h04));
    put16(`CS(8'hfe)); put16(`RD(2)); put16(`CS(8'hff));
    put16(`BR_SELECT(0));
    put16(`CFG(2'd0)); put16(`PRESCALE(8'h02));
    put16(`CS(8'hfe)); put16(`RD(2)); put16(`CS(8'hff));
    put16(`SYNC(8'h03));
    send_frame();
    wait_sync(8'h03);
    check("SYNC_ID after all SDI bytes", sync_level, 9'd4);
    ctrl_r(8'h0b, v); check("SDI_LEVEL", v, 8'd4);
    ctrl_r(8'h05, s); check("RESP_RDY", s[6], 1'b1);
    fetch(4);
    check("engine 1 sdi 0", rep[0], 8'h80);
    check("engine 1 sdi 1", rep[1], 8'h81);
    check("engine 0 sdi 0", rep[2], 8'h10);
    check("engine 0 sdi 1", rep[3], 8'h11);

    // a read on engine 1 alone: SYNC_ID only shows once its SDI bytes, the
    // last one delayed, are queued

    begin_frame();
    put16(`BR_SELECT(1));
    put16(`CFG(2'd0)); put16(`PRESCALE(8'h04));
    put16(`CS(8'hfe)); put16(`RD(1)); put16(`CS(8'hff));
    put16(`SYNC(8'h04));
    send_frame();
    wait_sync(8'h04);
    check("SYNC_ID after delayed SDI", sync_level, 9'd1);
    fetch(1);
    check("engine 1 sdi 2", rep[0], 8'h82);
    check("err so far", err, 3'h0);

    // SELECT of another engine while a chip select is held is rejected, the
    // same engine is fine, and after the release the switch is accepted

    n0 = s0.count;
    n8 = s8.count;
    begin_frame();                        // engine 0, slave 0 left selected
    put16(`BR_SELECT(0));
    put16(`CS(8'hfe)); put16(`WR(1)); put8(8'h01);
    send_frame();
    wait_idle();
    check("split first part", err, 3'h0);
    check("slave 0 held", cs_0[0], 1'b0);

    begin_frame();                        // switch while held: rejected whole
    put16(`BR_SELECT(1)); put_write(3'd0, 8'h99);
    send_frame();
    wait_idle();
    check("SELECT while CS held rejected", err, 3'h1);
    check("rejected frame not forwarded", s8.count, n8);
    check("slave 0 still held", cs_0[0], 1'b0);

    begin_frame();                        // resume; same engine: accepted, releases
    put16(`BR_W1C(8'h08));
    put16(`BR_SELECT(0)); put16(`WR(1)); put8(8'h02); put16(`CS(8'hff));
    send_frame();
    wait_idle();
    check("same-engine SELECT accepted", s0.count, n0 + 2);
    check("slave 0 released", cs_0[0], 1'b1);

    begin_frame();                        // released: the switch goes through
    put16(`BR_SELECT(1)); put_write(3'd0, 8'h98);
    send_frame();
    wait_idle();
    check("SELECT after release", s8.count, n8 + 1);
    flush();

    // a missing engine, and a chip select engine 1 does not have

    begin_frame(); put16(`BR_SELECT(2)); send_frame(); wait_idle();
    check("SELECT missing engine", err, 3'h1);
    flush();

    begin_frame(); put16(`BR_SELECT(1)); put16(`CS(8'hef)); send_frame(); wait_idle();
    check("CS 4 of engine 1 rejected", err, 3'h1);
    flush();

    n0 = s0.count;
    begin_frame(); put16(`CS(8'hef)); put16(`CS(8'hff)); send_frame(); wait_idle();
    check("CS 4 of engine 0 accepted", err, 3'h0);

    // FLUSH returns to engine 0 and releases the held chip select

    n0 = s0.count;
    n8 = s8.count;
    begin_frame();
    put16(`BR_SELECT(1));
    put16(`CFG(2'd0)); put16(`PRESCALE(8'h04));
    put16(`CS(8'hfe)); put16(`WR(1)); put8(8'h55);
    send_frame();
    wait_idle();
    check("slave 8 held", cs_1[0], 1'b0);
    flush();
    check("FLUSH releases slave 8", cs_1[0], 1'b1);
    check("FLUSH back to engine 0", eng, 4'd0);
    begin_frame();
    put16(`CFG(2'd0)); put16(`PRESCALE(8'h02)); put_write(3'd0, 8'h66);
    send_frame();
    wait_idle();
    check("after FLUSH: engine 0", s0.count, n0 + 1);
    check("after FLUSH: not engine 1", s8.count, n8 + 1);
    begin_frame(); put16(`BR_SELECT(1)); send_frame(); wait_idle();
    check("SELECT after FLUSH accepted", err, 3'h0);
    flush();

    // a rejected frame leaves the selection as it was

    n0 = s0.count;
    n8 = s8.count;
    begin_frame();
    put16(`BR_SELECT(1)); put8(8'h00);    // ends inside an instruction
    send_frame();
    wait_idle();
    check("truncated SELECT frame", err, 3'h4);
    check("selection restored", eng, 4'd0);
    begin_frame();                        // resume, then engine 0 as before
    put16(`BR_W1C(8'h20));
    put16(`CFG(2'd0)); put16(`PRESCALE(8'h02)); put_write(3'd0, 8'h67);
    send_frame();
    wait_idle();
    check("still engine 0", s0.count, n0 + 1);
    check("engine 1 untouched", s8.count, n8);
    flush();

    check("one slave at a time", overlap, 0);
    check("SCLK idle vs CPOL",
          {s11.mode_err, s8.mode_err, s7.mode_err, s0.mode_err}, 4'h0);

    if (failed == 1'b0)
      $display("SUCCESS");
    else
      $display("FAILED");
    $finish;
  end

  initial begin
    #10000000;
    $display("FAILED: timeout");
    $finish;
  end

endmodule
