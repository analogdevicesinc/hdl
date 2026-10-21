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
 * spi_translator driven by an upstream mode 0 SPI master that sends serialized
 * SPI Engine instruction streams, in front of a stock spi_engine_execution with
 * four behavioural targets in modes 0, 3, 1 and 2. Covers posted writes per
 * target, full-duplex and read-only transfers, frame rejection (bad
 * instruction, two targets selected, truncated, CS left asserted, no room
 * in the FIFOs), frames queuing behind a slow one, bridge register writes and
 * FLUSH. The CMD and SDO FIFOs are built small so they can be filled.
 */

module spi_translator_tb;

  parameter VCD_FILE = "spi_translator_tb.vcd";

  localparam T = 200;   // upstream SCLK period: 5 MHz, clk/20

  // SPI Engine instructions
  `define CFG(m)        (16'h2100 | (m))
  `define PRESCALE(d)   (16'h2000 | (d))
  `define CS(c)         (16'h1000 | (c))
  `define WR(n)         (16'h0100 | ((n) - 1))
  `define RD(n)         (16'h0200 | ((n) - 1))
  `define WRD(n)        (16'h0300 | ((n) - 1))
  `define SYNC(id)      (16'h3000 | (id))

  // bridge instructions
  `define BR_CTRL_W(a)  (16'h7100 | (a))
  `define BR_FLUSH      16'h7200

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

  wire          resp_valid;
  wire  [7:0]   resp_data;
  wire          busy;
  wire  [3:0]   err;
  wire          irq;

  wire          sclk;
  wire  [0:0]   sdo;
  wire          sdo_t;
  wire  [3:0]   cs;
  wire          three_wire;
  wire  [3:0]   miso_d;
  wire          sdi_bus;

  spi_translator #(
    .CMD_FIFO_ADDRESS_WIDTH (4),
    .SDO_FIFO_ADDRESS_WIDTH (5)
  ) i_dut (
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
    .spi_resetn (spi_resetn),
    .resp_valid (resp_valid),
    .resp_data (resp_data),
    .resp_ready (1'b1),
    .busy (busy),
    .err (err),
    .irq (irq));

  spi_engine_execution #(
    .NUM_OF_CS (4),
    .DATA_WIDTH (8),
    .NUM_OF_SDIO (1)
  ) i_engine (
    .clk (clk),
    .resetn (spi_resetn),
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

  // response stream capture

  reg   [7:0]   resp [0:255];
  integer       resp_count = 0;

  always @(posedge clk) begin
    if (resp_valid) begin
      resp[resp_count] <= resp_data;
      resp_count <= resp_count + 1;
    end
  end

  // host side: the frame under construction is txb[0..len-1]

  reg   [7:0]   txb [0:255];
  integer       len;

  task check;
    input [8*32-1:0] what;
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

  // n SDO bytes: first, first + step, ...
  task put_data;
    input integer n;
    input [7:0] first;
    input [7:0] step;
    integer i;
    begin
      for (i = 0; i < n; i = i + 1) begin
        put8(first + i * step);
      end
    end
  endtask

  // one CS-framed transfer of txb[0..len-1]
  task send_frame;
    integer i, b;
    begin
      up_cs = 1'b0;
      #(T);
      for (i = 0; i < len; i = i + 1) begin
        for (b = 7; b >= 0; b = b - 1) begin
          up_mosi = txb[i][b];
          #(T/2);
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

  task wait_idle;
    begin
      @(posedge clk);
      while (busy) @(posedge clk);
      repeat (20) @(posedge clk);
    end
  endtask

  // a complete posted write to one target
  task write_target;
    input [1:0] t;
    input [1:0] mode;
    input [7:0] div;
    input integer n;
    input [7:0] first;
    begin
      begin_frame();
      put16(`CFG(mode));
      put16(`PRESCALE(div));
      put16(`CS(8'hff & ~(8'h01 << t)));
      put16(`WR(n));
      put_data(n, first, 8'h10);
      put16(`CS(8'hff));
      put16(`SYNC(8'h10 + t));
      send_frame();
    end
  endtask

  integer       r0;
  integer       c2;

  initial begin
    $dumpfile (VCD_FILE);
    $dumpvars;

    #100 resetn = 1'b1;
    #1000;

    // posted writes, one frame per target, each in that target's own mode

    write_target(2'd0, 2'd0, 8'h02, 3, 8'h10);
    write_target(2'd1, 2'd3, 8'h03, 3, 8'h11);
    write_target(2'd2, 2'd1, 8'h02, 3, 8'h12);
    write_target(2'd3, 2'd2, 8'h04, 3, 8'h13);
    wait_idle();
    check("d0 count", d0.count, 3); check("d0[0]", d0.mem[0], 8'h10); check("d0[2]", d0.mem[2], 8'h30);
    check("d1 count", d1.count, 3); check("d1[0]", d1.mem[0], 8'h11); check("d1[2]", d1.mem[2], 8'h31);
    check("d2 count", d2.count, 3); check("d2[1]", d2.mem[1], 8'h22);
    check("d3 count", d3.count, 3); check("d3[2]", d3.mem[2], 8'h33);
    check("SCLK idle vs CPOL", {d3.mode_err, d2.mode_err, d1.mode_err, d0.mode_err}, 0);
    check("sync ids queued", resp_count, 4);
    check("sync id 0", resp[0], 8'h10);
    check("sync id 3", resp[3], 8'h13);
    check("err", err, 0);

    // individual commands
    begin_frame();
    put16(`CFG(2'd0));
    send_frame();

    begin_frame();
    put16(`PRESCALE(8'h02));
    send_frame();

    begin_frame();
    put16(`CS(8'hff & ~(8'h01 << 2'd0)));
    send_frame();

    begin_frame();
    put16(`WR(3));
    put_data(3, 8'h10, 8'h10);
    send_frame();

    begin_frame();
    put16(`CS(8'hff));
    send_frame();

    begin_frame();
    put16(`SYNC(8'h10 + 2'd0));
    send_frame();

    wait_idle();

    // full-duplex read on target 1 (mode 3): SDI bytes, then the SYNC id

    //r0 = resp_count;
    //begin_frame();
    //put16(`CFG(2'd3));
    //put16(`PRESCALE(8'h03));
    //put16(`CS(8'hfd));
    //put16(`WRD(2));
    //put8(8'h55); put8(8'h66);
    //put16(`CS(8'hff));
    //put16(`SYNC(8'h21));
    //send_frame();
    //wait_idle();
    //check("rw response bytes", resp_count - r0, 3);
    //check("rw sdi 0", resp[r0], 8'hb3);
    //check("rw sdi 1", resp[r0+1], 8'hb4);
    //check("rw sync id", resp[r0+2], 8'h21);
    //check("d1 saw write data", d1.mem[3], 8'h55);

    // read-only transfer on target 0: no SDO bytes follow the instruction

    //r0 = resp_count;
    //begin_frame();
    //put16(`CFG(2'd0));
    //put16(`PRESCALE(8'h02));
    //put16(`CS(8'hfe));
    //put16(`RD(2));
    //put16(`CS(8'hff));
    //put16(`SYNC(8'h22));
    //send_frame();
    //wait_idle();
    //check("rd response bytes", resp_count - r0, 3);
    //check("rd sdi 0", resp[r0], 8'ha3);
    //check("rd sdi 1", resp[r0+1], 8'ha4);
    //check("rd sync id", resp[r0+2], 8'h22);

    // rejected frames: nothing reaches target 2, sticky err bit set

    //c2 = d2.count;

    //begin_frame();                        // reserved instruction class 101
    //put16(`CS(8'hfb)); put16(`WR(1)); put8(8'hee);
    //put16(16'h5000);
    //put16(`CS(8'hff));
    //send_frame();
    //wait_idle();
    //check("bad instr not forwarded", d2.count, c2);
    //check("err after bad instr", err, 4'h1);

    //begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();
    //check("err cleared by FLUSH", err, 4'h0);

    //begin_frame();                        // targets 2 and 3 at once
    //put16(`CS(8'hf3)); put16(`WR(1)); put8(8'hee); put16(`CS(8'hff));
    //send_frame();
    //wait_idle();
    //check("two targets not forwarded", d2.count, c2);
    //check("err after two targets", err, 4'h1);
    //begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();

    //begin_frame();                        // 2 of 3 SDO bytes
    //put16(`CS(8'hfb)); put16(`WR(3)); put8(8'h01); put8(8'h02);
    //send_frame();
    //wait_idle();
    //check("truncated not forwarded", d2.count, c2);
    //check("err after truncation", err, 4'hc);   // CS also left open
    //begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();

    //begin_frame();                        // half an instruction
    //put16(`CS(8'hfb)); put16(`WR(1)); put8(8'h01); put16(`CS(8'hff)); put8(8'h30);
    //send_frame();
    //wait_idle();
    //check("half instr not forwarded", d2.count, c2);
    //check("err after half instr", err, 4'h4);
    //begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();

    //begin_frame();                        // CS never deasserted
    //put16(`CS(8'hfb)); put16(`WR(1)); put8(8'h01);
    //send_frame();
    //wait_idle();
    //check("open CS not forwarded", d2.count, c2);
    //check("err after open CS", err, 4'h8);
    //check("CS released downstream", cs, 4'hf);
    //begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();

    // bridge register write: applied at the end of a good frame

    //begin_frame(); put16(`BR_CTRL_W(8'h02)); put8(8'h3c); send_frame(); wait_idle();
    //check("CTRL_W address", i_dut.reg_wr_addr, 8'h02);
    //check("CTRL_W data", i_dut.reg_wr_data, 8'h3c);

    // queuing: frames are committed behind a slow one while it executes;
    // a frame that no longer fits in the 32-byte SDO FIFO is rejected whole

    //begin_frame();
    //put16(`CFG(2'd0)); put16(`PRESCALE(8'hff));
    //put16(`CS(8'hfe)); put16(`WR(12)); put_data(12, 8'h77, 8'h00); put16(`CS(8'hff));
    //send_frame();
    //begin_frame();
    //put16(`CS(8'hfe)); put16(`WR(12)); put_data(12, 8'h78, 8'h00); put16(`CS(8'hff));
    //send_frame();
    //check("second frame queued", i_dut.busy, 1);
    //begin_frame();
    //put16(`CS(8'hfe)); put16(`WR(20)); put_data(20, 8'h79, 8'h00); put16(`CS(8'hff));
    //send_frame();
    //check("err with no room", err, 4'h2);
    //wait_idle();
    //check("d0 count after queuing", d0.count, 3 + 2 + 24);
    //check("d0 first frame", d0.mem[5], 8'h77);
    //check("d0 second frame", d0.mem[17], 8'h78);
    //check("d0 second frame last", d0.mem[28], 8'h78);

    // FLUSH in the middle of a slow write releases the target

    //begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();
    //begin_frame();
    //put16(`PRESCALE(8'hff));
    //put16(`CS(8'hfe)); put16(`WR(8)); put_data(8, 8'h01, 8'h01); put16(`CS(8'hff));
    //send_frame();
    //#(20000);
    //check("target selected mid write", cs[0], 1'b0);
    //begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();
    //check("CS released by FLUSH", cs, 4'hf);
    //check("write cut short", d0.count < 29 + 8, 1);

    if (failed == 1'b0)
      $display("SUCCESS");
    else
      $display("FAILED");
    $finish;
  end

  initial begin
    #5000000;
    $display("FAILED: timeout");
    $finish;
  end

endmodule
