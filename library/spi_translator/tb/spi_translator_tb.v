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
 * spi_translator_slave driven by an upstream mode 0 SPI master that sends
 * serialized SPI Engine instruction streams, in front of
 * spi_translator_interconnect and one stock spi_engine_execution with four
 * behavioural targets in modes 0, 3, 1 and 2. Covers posted writes per target,
 * full-duplex and read-only transfers, a transfer split over two frames with
 * the target held selected, frame rejection (bad instruction, two targets
 * selected, truncated, no room in the FIFOs), frames queuing behind a slow
 * one, register reads and writes, bridge writes acting at the commit, FLUSH,
 * the frame header, go-back-N with its resume, and FETCH acknowledge and
 * retry. The CMD and SDO FIFOs are built small so they can be filled.
 *
 * With CRC_EN, send_frame ends every frame with a CHECK and verifies the MISO
 * CRC; a block of CRC tests sends damaged frames on purpose. Every frame's
 * header (MISO bytes 0 and 1) is checked against the decoder's STATUS
 * snapshot and SYNC_ID.
 */

module spi_translator_tb;

  parameter VCD_FILE = "spi_translator_tb.vcd";

  // upstream MISO timing: 0 = standard (drive edge), 1 = early launch; the
  // master samples MISO just before each sample edge, so both must pass
  parameter EARLY_LAUNCH = 0;

  // CRC-16 frame check
  parameter CRC_EN = 0;

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
  // bridge side: 0 NOP, 1 CTRL_W, 2 CTRL_R, 3 GPIO
  // engine side: 4 SELECT, 5 FETCH, 6 FLUSH, 7 CHECK
  `define BR_NOP          16'h8000
  `define BR_CTRL_W(a, d) (16'h9000 | (((a) & 16'h000f) << 8) | (d))
  `define BR_CTRL_R(a)    (16'hA000 | (((a) & 16'h000f) << 8))
  `define BR_GPIO_W(s, v, i) (16'hB000 | ((s) << 10) | ((v) << 9) | (i))
  `define BR_GPIO_R(i)    (16'hB800 | (i))
  `define BR_SELECT(e)    (16'hC000 | ((e) & 16'h00ff))
  `define BR_FETCH(n)     (16'hD000 | ((n) - 1))
  `define BR_RETRY(n)     (16'hD200 | ((n) - 1))
  `define BR_ACK          16'hD100
  `define BR_W1C(b)       `BR_CTRL_W(8'h05, (b))
  `define BR_FLUSH        16'hE000
  `define BR_CHECK        16'hF000

  reg           clk = 1'b0;
  reg           resetn = 1'b0;
  reg           failed = 1'b0;

  integer       test_count = 0;

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

  // GPIO pins: driven by the bridge when an output, by gpio_ext otherwise
  localparam    NG = 12;
  reg   [NG-1:0] gpio_ext = 12'ha5c;
  wire  [NG-1:0] gpio_o;
  wire  [NG-1:0] gpio_t;
  wire  [NG-1:0] gpio_pin = (gpio_t & gpio_ext) | (~gpio_t & gpio_o);

  // internal state, observed without a STATUS read
  wire          busy = i_dut.i_exec.busy;
  wire  [2:0]   err = i_dut.err;

  wire          sclk;
  wire  [0:0]   sdo;
  wire          sdo_t;
  wire  [3:0]   cs;
  wire          three_wire;
  wire  [3:0]   miso_d;
  wire          sdi_bus;

  // reset state like regulator controls: pin 1 an active-low enable held off
  // (high), pin 11 a power-good input, all others enables driven low (off)
  spi_translator_slave #(
    .UP_EARLY_LAUNCH (EARLY_LAUNCH),
    .CRC_EN (CRC_EN),
    .NUM_OF_GPIO (NG),
    .GPIO_DEFAULT_DIR (12'h800),
    .GPIO_DEFAULT_OUT (12'h002),
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
    .gpio_i (gpio_pin),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t));

  spi_translator_interconnect #(
    .NUM_OF_ENGINES (1)
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
    .m0_cmd_ready (cmd_ready),
    .m0_cmd_valid (cmd_valid),
    .m0_cmd_data (cmd),
    .m0_sdo_ready (sdo_ready),
    .m0_sdo_valid (sdo_valid),
    .m0_sdo_data (sdo_data),
    .m0_sdi_ready (sdi_ready),
    .m0_sdi_valid (sdi_valid),
    .m0_sdi_data (sdi_data),
    .m0_sync_ready (sync_ready),
    .m0_sync_valid (sync_valid),
    .m0_sync_data (sync_data));

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

  // downstream CS releases of target 3, to check that a transfer split over
  // two frames stays one CS-held transaction
  integer       cs3_releases = 0;

  always @(posedge cs[3]) begin
    cs3_releases = cs3_releases + 1;
  end

  // host side: the frame under construction is txb[0..len-1]; MISO of the
  // last frame lands in rxb[], the data of the last reply in rep[]

  reg   [7:0]   txb [0:511];
  reg   [7:0]   rxb [0:511];
  reg   [7:0]   rep [0:255];
  integer       len;

  // raw_frame: send txb as it is, no CHECK appended and no MISO CRC check;
  // hdr_status: MISO byte 0 of the last frame
  reg           raw_frame = 1'b0;

  // malformed: the frame is cut short or misaligned on purpose, so its CHECK
  // is not recognized and returns no MISO CRC; cleared after the frame
  reg           malformed = 1'b0;
  reg   [7:0]   hdr_status;

  // CRC-16/CCITT-FALSE, as the host computes it
  function [15:0] crc16_byte;
    input [15:0] c;
    input [7:0]  d;
    integer i;
    reg [15:0] r;
    begin
      r = c;
      for (i = 7; i >= 0; i = i - 1) begin
        r = (r[15] ^ d[i]) ? {r[14:0], 1'b0} ^ 16'h1021 : {r[14:0], 1'b0};
      end
      crc16_byte = r;
    end
  endfunction

  task wait_idle;
    begin
      @(posedge clk);
      while (busy) @(posedge clk);
      repeat (20) @(posedge clk);
    end
  endtask

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

  // silent on success
  task check_q;
    input [8*32-1:0] what;
    input [31:0] got;
    input [31:0] exp;
    begin
      if (got !== exp) begin
        failed = 1'b1;
        $display("FAIL %0s: got %0h, expected %0h", what, got, exp);
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

  // CHECK over txb[0..len-1], its CRC XORed with corrupt
  task put_check;
    input [15:0] corrupt;
    integer i;
    reg [15:0] c;
    begin
      put16(`BR_CHECK);
      c = 16'hffff;
      for (i = 0; i < len; i = i + 1) begin
        c = crc16_byte(c, txb[i]);
      end
      put16(c ^ corrupt);
    end
  endtask

  // one CS-framed transfer of txb[0..len-1], with a CHECK appended when
  // CRC_EN; MISO is sampled just before each rising (sample) edge. The header
  // and the MISO CRC are checked against the decoder.
  task send_frame;
    integer i, b, n0;
    reg [15:0] c;
    reg [7:0] exp_first;
    reg [7:0] exp_sync;
    begin
      n0 = len;
      if (CRC_EN != 0 && ~raw_frame) begin
        put_check(16'h0000);
      end
      up_cs = 1'b0;
      exp_first = i_dut.i_decoder.tx_first;
      #(T/2);
      exp_sync = i_dut.last_sync;
      #(T/2);
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
      hdr_status = rxb[0];
      check_q("header STATUS", rxb[0], exp_first);
      check_q("header SYNC_ID", rxb[1], exp_sync);
      if (CRC_EN != 0 && ~raw_frame && ~malformed) begin
        c = 16'hffff;
        for (i = 0; i <= n0 + 1; i = i + 1) begin
          c = crc16_byte(c, rxb[i]);
        end
        check_q("MISO CRC", {rxb[n0+2], rxb[n0+3]}, c);
      end
      malformed = 1'b0;
      #(2*T);
    end
  endtask

  // a frame that only clears err, lifting the go-back-N block
  task resume;
    begin
      begin_frame(); put16(`BR_W1C(8'h38)); send_frame(); wait_idle();
    end
  endtask

  // the reply goes out during the first byte of the next instruction, here a
  // NOP, at rxb[2]
  task ctrl_r;
    input [7:0] a;
    output [7:0] v;
    begin
      begin_frame(); put16(`BR_CTRL_R(a)); put16(`BR_NOP); send_frame();
      v = rxb[2];
    end
  endtask

  task ctrl_w;
    input [7:0] a;
    input [7:0] v;
    begin
      begin_frame(); put16(`BR_CTRL_W(a, v)); send_frame();
    end
  endtask

  // FETCH n bytes into rep[]; with reject set, a stray byte after the request
  // leaves the frame ending inside an instruction, so it is rejected and the
  // bytes stay queued
  task fetch;
    input integer n;
    input reject;
    integer i;
    begin
      begin_frame(); put16(`BR_FETCH(n)); put_data(n + 1, 8'h00, 8'h00);
      if (reject) begin
        put8(8'h00);
        malformed = 1'b1;
      end
      send_frame();
      for (i = 0; i < n; i = i + 1) begin
        rep[i] = rxb[3+i];
      end
    end
  endtask

  // poll SYNC_ID until the engine has executed SYNC(id)
  task wait_sync;
    input [7:0] id;
    reg [7:0] last;
    begin
      last = ~id;
      while (last != id) ctrl_r(8'h06, last);
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

  integer       c2;
  integer       c3;
  reg   [7:0]   s;
  reg   [7:0]   v;

  initial begin
    $dumpfile (VCD_FILE);
    $dumpvars;

    #100 resetn = 1'b1;
    #1000;

    // posted writes, one frame per target, each in that target's own mode

    test_count = 1;
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
    check("err", err, 0);

    // posted writes leave only their SYNC id, nothing to FETCH

    test_count = 2;
    ctrl_r(8'h06, v); check("SYNC_ID after writes", v, 8'h13);
    ctrl_r(8'h0b, v); check("SDI_LEVEL after writes", v, 8'h00);
    ctrl_r(8'h05, s); check("no RESP_RDY without SDI data", s[6], 1'b0);

    // register reads

    test_count = 3;
    ctrl_r(8'h05, s);
    check("idle status", s, 8'h07);       // all FIFOs empty: credit 7
    ctrl_r(8'h00, v); check("VERSION_MAJOR", v, 8'h01);
    ctrl_r(8'h01, v); check("VERSION_MINOR", v, 8'h00);
    ctrl_r(8'h02, v); check("VERSION_PATCH", v, 8'h00);
    ctrl_r(8'h03, v); check("PERIPHERAL_ID", v, 8'h00);
    ctrl_r(8'h0f, v); check("CS_NUM", v, 8'd4);
    ctrl_w(8'h04, 8'h3c);
    ctrl_r(8'h04, v); check("SCRATCH", v, 8'h3c);
    ctrl_w(8'h02, 8'hc3);                 // read-only, must not reach SCRATCH
    ctrl_r(8'h04, v); check("SCRATCH after RO write", v, 8'h3c);
    ctrl_r(8'h09, v); check("SDO_ROOM_L", v, 8'd32);

    test_count = 4;
    begin_frame();                        // chained reads, one per 2 bytes
    put16(`BR_CTRL_R(8'h00)); put16(`BR_CTRL_R(8'h04)); put16(`BR_CTRL_R(8'h0e));
    put16(`BR_NOP);
    send_frame();
    check("chained VERSION_MAJOR", rxb[2], 8'h01);
    check("chained SCRATCH", rxb[4], 8'h3c);
    check("chained unused address", rxb[6], 8'h00);

    test_count = 5;
    c3 = d3.count;
    begin_frame();                        // an error shows in the status
    put16(`CS(8'hf7)); put16(`WR(2)); put8(8'haa); malformed = 1'b1;
    send_frame();
    ctrl_r(8'h05, s); check("status ERR truncated", s[5:3], 3'b100);
    check("truncated not forwarded", d3.count, c3);
    begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();
    ctrl_r(8'h05, s); check("status ERR cleared by FLUSH", s[5:3], 3'b000);
    check("CS released by FLUSH", cs, 4'hf);

    // a transfer split over two frames: the first ends with target 3 still
    // selected, the second continues and releases it

    test_count = 6;
    c3 = d3.count;
    cs3_releases = 0;
    begin_frame();
    put16(`CFG(2'd2)); put16(`PRESCALE(8'h04));
    put16(`CS(8'hf7)); put16(`WR(2)); put8(8'h61); put8(8'h62);
    send_frame();
    wait_idle();
    check("first part accepted", err, 3'h0);
    check("target held between frames", cs[3], 1'b0);
    check("first part sent", d3.count, c3 + 2);
    begin_frame();
    put16(`WR(2)); put8(8'h63); put8(8'h64); put16(`CS(8'hff));
    send_frame();
    wait_idle();
    check("target released", cs[3], 1'b1);
    check("one CS-held transaction", cs3_releases, 1);
    check("whole transfer sent", d3.count, c3 + 4);
    check("last byte", d3.mem[c3+3], 8'h64);

    // CTRL_W acts at the commit: a CTRL_R in the same frame still reads the
    // old value (reply at rxb[4]), the next frame the last one written

    test_count = 7;
    begin_frame();
    put16(`BR_CTRL_W(8'h04, 8'h11)); put16(`BR_CTRL_R(8'h04));
    put16(`BR_CTRL_W(8'h04, 8'h22)); put16(`BR_NOP);
    send_frame();
    check("same-frame read sees old value", rxb[4], 8'h3c);
    check("two CTRL_W accepted", err, 3'h0);
    ctrl_r(8'h04, v); check("last CTRL_W applied", v, 8'h22);

    // a rejected frame applies none of its bridge writes

    test_count = 8;
    c3 = d3.count;
    begin_frame();
    put16(`BR_CTRL_W(8'h04, 8'h77));
    put16(`CS(8'hf7)); put16(`WR(2)); put8(8'haa); malformed = 1'b1;
    send_frame();
    check("truncated after CTRL_W", err, 3'h4);
    check("truncated write not sent", d3.count, c3);
    ctrl_r(8'h04, v); check("CTRL_W not applied", v, 8'h22);

    // FLUSH only as the first instruction: there it drops what earlier frames
    // queued, keeps the rest of its frame, clears err and lifts the block
    // left by test 8; the engine restarts from its reset settings

    test_count = 9;
    c3 = d3.count;
    cs3_releases = 0;
    begin_frame();
    put16(`BR_FLUSH);
    put16(`CFG(2'd2)); put16(`PRESCALE(8'h04));
    put16(`CS(8'hf7)); put16(`WR(1)); put8(8'h5a); put16(`CS(8'hff));
    send_frame();
    wait_idle();
    check("err cleared by FLUSH", err, 3'h0);
    check("frame after FLUSH sent", d3.count, c3 + 1);
    check("byte after FLUSH", d3.mem[c3], 8'h5a);
    check("one transaction after FLUSH", cs3_releases, 1);
    check("SCLK idle vs CPOL after FLUSH", d3.mode_err, 1'b0);
    begin_frame();
    put16(`CS(8'hf7)); put16(`WR(1)); put8(8'hee); put16(`BR_FLUSH);
    send_frame();
    wait_idle();
    check("FLUSH not first rejected", err, 3'h1);
    check("frame with late FLUSH not sent", d3.count, c3 + 1);
    begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();

    // GPIOs, one pin per instruction; a GPIO read reply lands two bytes after
    // its index byte, in the low byte of the next instruction

    // DIR: 0 = output, 1 = input; replies are {DIR, OUT, IN}

    test_count = 10;
    check("reset gpio_t from GPIO_DEFAULT_DIR", gpio_t, 12'h800);
    check("reset gpio_o from GPIO_DEFAULT_OUT", gpio_o, 12'h002);
    ctrl_r(8'h0d, v); check("GPIO_NUM_L", v, NG);
    ctrl_r(8'h0e, v); check("GPIO_NUM_H", v, 8'h00);
    begin_frame();
    put16(`BR_GPIO_R(8'd11)); put16(`BR_GPIO_R(8'd1)); put16(`BR_GPIO_R(8'd2));
    put16(`BR_NOP);
    send_frame();
    check("GPIO 11 power-good input", rxb[3], 8'h05);   // ext bit 11 is 1
    check("GPIO 1 enable held high", rxb[5], 8'h03);
    check("GPIO 2 enable held low", rxb[7], 8'h00);

    test_count = 11;
    begin_frame();                        // GPIO 2 to input, 0 high, 1 low
    put16(`BR_GPIO_W(1, 1, 8'd2)); put16(`BR_GPIO_W(0, 1, 8'd0));
    put16(`BR_GPIO_W(0, 0, 8'd1));
    send_frame();
    check("gpio_t", gpio_t, 12'h804);
    check("gpio_o", gpio_o, 12'h001);
    check("GPIO writes accepted", err, 3'h0);

    test_count = 12;
    begin_frame();                        // chained reads: 0, 11, 2
    put16(`BR_GPIO_R(8'd0)); put16(`BR_GPIO_R(8'd11)); put16(`BR_GPIO_R(8'd2));
    put16(`BR_NOP);
    send_frame();
    check("GPIO 0 {DIR, OUT, IN}", rxb[3], 8'h03);
    check("GPIO 11 {DIR, OUT, IN}", rxb[5], 8'h05);
    check("GPIO 2 {DIR, OUT, IN}", rxb[7], 8'h05);    // now input, ext bit 2 is 1

    test_count = 13;
    begin_frame();                        // beyond NUM_OF_GPIO: ignored, reads 0
    put16(`BR_GPIO_W(1, 1, 8'd20)); put16(`BR_GPIO_R(8'd20)); put16(`BR_NOP);
    send_frame();
    check("out of range reads 0", rxb[5], 8'h00);
    check("out of range write ignored", gpio_t, 12'h804);

    test_count = 14;
    begin_frame();                        // reserved GPIO write bit: bad instruction
    put16(16'hB301);                      // would set GPIO 1 high
    send_frame();
    check("reserved GPIO write bit", err, 3'h1);
    check("rejected GPIO write not applied", gpio_o, 12'h001);
    begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();

    test_count = 15;
    begin_frame();                        // reserved GPIO read bits: bad instruction
    put16(16'hB901); put16(`BR_NOP);
    send_frame();
    check("reserved GPIO read bits", err, 3'h1);
    begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();

    // one engine: SELECT 0 is accepted and changes nothing, SELECT 1 names a
    // missing engine; CHECK is a bad instruction without CRC_EN

    test_count = 16;
    begin_frame(); put16(`BR_SELECT(0)); send_frame(); wait_idle();
    check("SELECT 0 accepted", err, 3'h0);
    begin_frame(); put16(`BR_SELECT(1)); send_frame();
    check("SELECT missing engine rejected", err, 3'h1);
    begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();
    begin_frame(); put16(16'hC100); send_frame();
    check("SELECT reserved high nibble", err, 3'h1);
    begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();
    if (CRC_EN == 0) begin
      begin_frame(); put16(`BR_CHECK); send_frame();
      check("CHECK rejected", err, 3'h1);
      begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();
    end

    // FETCH: a rejected FETCH frame returns the data but leaves it queued;
    // the block it leaves is lifted before the FETCH is sent again

    test_count = 17;
    c3 = d3.count;
    begin_frame();
    put16(`CFG(2'd2)); put16(`PRESCALE(8'h04));   // engine reset by the FLUSH above
    put16(`CS(8'hf7)); put16(`RD(1)); put16(`CS(8'hff)); put16(`SYNC(8'h31));
    send_frame();
    wait_idle();
    wait_sync(8'h31);
    ctrl_r(8'h0b, v); check("SDI_LEVEL after read", v, 8'd1);
    fetch(1, 1'b1);
    check("rejected FETCH data", rep[0], 8'hd0 + c3);
    check("err after rejected FETCH", err, 3'h4);
    ctrl_r(8'h0b, v); check("SDI_LEVEL kept", v, 8'd1);
    resume();
    fetch(1, 1'b0);
    check("retried FETCH data", rep[0], 8'hd0 + c3);
    ctrl_r(8'h0b, v); check("SDI_LEVEL released", v, 8'd0);
    begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();

    test_count = 18;
    fetch(2, 1'b0);                       // empty FIFO pads with zeros
    check("empty FETCH", {rep[0], rep[1]}, 16'h0000);

    // full-duplex read on target 1 (mode 3): wait for the SYNC id, then FETCH

    test_count = 19;
    begin_frame();
    put16(`CFG(2'd3));
    put16(`PRESCALE(8'h03));
    put16(`CS(8'hfd));
    put16(`WRD(2));
    put8(8'h55); put8(8'h66);
    put16(`CS(8'hff));
    put16(`SYNC(8'h21));
    send_frame();
    wait_sync(8'h21);
    fetch(2, 1'b0);
    check("rw sdi 0", rep[0], 8'hb3);
    check("rw sdi 1", rep[1], 8'hb4);
    check("d1 saw write data", d1.mem[3], 8'h55);

    // read-only transfer on target 0: no SDO bytes follow the instruction

    test_count = 20;
    begin_frame();
    put16(`CFG(2'd0));
    put16(`PRESCALE(8'h02));
    put16(`CS(8'hfe));
    put16(`RD(2));
    put16(`CS(8'hff));
    put16(`SYNC(8'h22));
    send_frame();
    wait_sync(8'h22);
    ctrl_r(8'h0b, v); check("SDI_LEVEL after read", v, 8'd2);
    ctrl_r(8'h05, s); check("RESP_RDY after read", s[6], 1'b1);
    fetch(2, 1'b0);
    check("rd sdi 0", rep[0], 8'ha3);
    check("rd sdi 1", rep[1], 8'ha4);
    ctrl_r(8'h0b, v); check("SDI_LEVEL after FETCH", v, 8'd0);
    ctrl_r(8'h05, s); check("RESP_RDY after FETCH", s[6], 1'b0);

    // rejected frames: nothing reaches target 2, sticky err bit set

    test_count = 21;
    c2 = d2.count;

    begin_frame();                        // reserved instruction class 101
    put16(`CS(8'hfb)); put16(`WR(1)); put8(8'hee);
    put16(16'h5000);
    put16(`CS(8'hff));
    send_frame();
    wait_idle();
    check("bad instr not forwarded", d2.count, c2);
    check("err after bad instr", err, 3'h1);

    begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();
    check("err cleared by FLUSH", err, 3'h0);

    begin_frame();                        // targets 2 and 3 at once
    put16(`CS(8'hf3)); put16(`WR(1)); put8(8'hee); put16(`CS(8'hff));
    send_frame();
    wait_idle();
    check("two targets not forwarded", d2.count, c2);
    check("err after two targets", err, 3'h1);
    begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();

    begin_frame();                        // target 4: the engine has 4 CS
    put16(`CS(8'hef)); put16(`WR(1)); put8(8'hee); put16(`CS(8'hff));
    send_frame();
    wait_idle();
    check("missing target rejected", err, 3'h1);
    begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();

    begin_frame();                        // 2 of 3 SDO bytes
    put16(`CS(8'hfb)); put16(`WR(3)); put8(8'h01); put8(8'h02); malformed = 1'b1;
    send_frame();
    wait_idle();
    check("truncated not forwarded", d2.count, c2);
    check("err after truncation", err, 3'h4);
    begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();

    begin_frame();                        // half an instruction
    put16(`CS(8'hfb)); put16(`WR(1)); put8(8'h01); put16(`CS(8'hff)); put8(8'h30);
    malformed = 1'b1;
    send_frame();
    wait_idle();
    check("half instr not forwarded", d2.count, c2);
    check("err after half instr", err, 3'h4);
    begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();

    // queuing: frames are committed behind a slow one while it executes;
    // a frame that no longer fits in the 32-byte SDO FIFO is rejected whole

    test_count = 22;
    begin_frame();
    put16(`CFG(2'd0)); put16(`PRESCALE(8'hff));
    put16(`CS(8'hfe)); put16(`WR(12)); put_data(12, 8'h77, 8'h00); put16(`CS(8'hff));
    send_frame();
    begin_frame();
    put16(`CS(8'hfe)); put16(`WR(12)); put_data(12, 8'h78, 8'h00); put16(`CS(8'hff));
    send_frame();
    check("second frame queued", i_dut.i_exec.busy, 1);
    begin_frame();
    put16(`CS(8'hfe)); put16(`WR(20)); put_data(20, 8'h79, 8'h00); put16(`CS(8'hff));
    send_frame();
    check("err with no room", err, 3'h2);
    wait_idle();
    check("d0 count after queuing", d0.count, 3 + 2 + 24);
    check("d0 first frame", d0.mem[5], 8'h77);
    check("d0 second frame", d0.mem[17], 8'h78);
    check("d0 second frame last", d0.mem[28], 8'h78);

    // FLUSH in the middle of a slow write releases the target

    test_count = 23;
    begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();
    begin_frame();
    put16(`PRESCALE(8'hff));
    put16(`CS(8'hfe)); put16(`WR(8)); put_data(8, 8'h01, 8'h01); put16(`CS(8'hff));
    send_frame();
    #(20000);
    check("target selected mid write", cs[0], 1'b0);
    begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();
    check("CS released by FLUSH", cs, 4'hf);
    check("write cut short", d0.count < 29 + 8, 1);

    // header: byte 0 is STATUS after the previous frame, byte 1 SYNC_ID

    test_count = 24;
    begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();
    begin_frame();
    put16(`CFG(2'd0)); put16(`PRESCALE(8'h02));
    put16(`CS(8'hfe)); put16(`WR(1)); put8(8'h42); put16(`CS(8'hff));
    put16(`SYNC(8'h41));
    send_frame();
    wait_idle();
    begin_frame(); put16(`BR_NOP); send_frame();
    check("header SYNC_ID", rxb[1], 8'h41);
    check("header ERR after a good frame", hdr_status[5:3], 3'b000);

    // go-back-N: after a rejected frame, frames are rejected until one starts
    // with a resume; the header shows err meanwhile

    test_count = 25;
    c2 = d0.count;
    begin_frame(); put16(16'h5000); send_frame(); wait_idle();
    check("bad instruction", err, 3'h1);
    begin_frame();                        // good, but blocked
    put16(`CS(8'hfe)); put16(`WR(1)); put8(8'h43); put16(`CS(8'hff));
    send_frame();
    wait_idle();
    check("header shows err", hdr_status[5:3], 3'b001);
    check("blocked frame not sent", d0.count, c2);
    check("blocked frame adds no err", err, 3'h1);
    begin_frame();                        // clears the wrong bit: still blocked
    put16(`BR_W1C(8'h10));
    put16(`CS(8'hfe)); put16(`WR(1)); put8(8'h44); put16(`CS(8'hff));
    send_frame();
    wait_idle();
    check("partial clear stays blocked", d0.count, c2);
    check("err kept", err, 3'h1);
    begin_frame();                        // clears it: resumes, frame runs
    put16(`BR_W1C(8'h08));
    put16(`CS(8'hfe)); put16(`WR(1)); put8(8'h45); put16(`CS(8'hff));
    send_frame();
    wait_idle();
    check("resumed frame sent", d0.count, c2 + 1);
    check("resumed frame data", d0.mem[c2], 8'h45);
    check("err cleared by W1C", err, 3'h0);

    // a transfer split over frames survives a rejected piece: the host
    // resumes and resends from the rejected frame on

    test_count = 26;
    c3 = d3.count;
    cs3_releases = 0;
    begin_frame();
    put16(`CFG(2'd2)); put16(`PRESCALE(8'h04));
    put16(`CS(8'hf7)); put16(`WR(2)); put8(8'h71); put8(8'h72);
    send_frame();
    wait_idle();
    begin_frame();                        // second piece cut short
    put16(`WR(2)); put8(8'h73); malformed = 1'b1;
    send_frame();
    wait_idle();
    check("second piece rejected", err, 3'h4);
    begin_frame();                        // sent before the host noticed
    put16(`WR(1)); put8(8'h75); put16(`CS(8'hff));
    send_frame();
    wait_idle();
    check("frame after it blocked", d3.count, c3 + 2);
    check("target still held", cs[3], 1'b0);
    begin_frame();                        // resume and resend from the second piece
    put16(`BR_W1C(8'h20));
    put16(`WR(2)); put8(8'h73); put8(8'h74);
    put16(`WR(1)); put8(8'h75); put16(`CS(8'hff));
    send_frame();
    wait_idle();
    check("whole transfer after resume", d3.count, c3 + 5);
    check("resent bytes in order", {d3.mem[c3+2], d3.mem[c3+3], d3.mem[c3+4]}, 24'h737475);
    check("one CS-held transaction", cs3_releases, 1);
    check("err cleared", err, 3'h0);

    // FETCH acknowledge and retry: a fetched batch keeps its room until a
    // later FETCH or an acknowledge, and a retry reads it again

    test_count = 27;
    begin_frame();
    put16(`CFG(2'd0)); put16(`PRESCALE(8'h02));
    put16(`CS(8'hfe)); put16(`RD(2)); put16(`CS(8'hff)); put16(`SYNC(8'h51));
    send_frame();
    wait_sync(8'h51);
    c2 = d0.count;
    fetch(2, 1'b0);
    ctrl_r(8'h0b, v); check("SDI_LEVEL after FETCH", v, 8'd0);
    check("batch keeps its room", i_dut.i_exec.resp_s_room, 254);
    v = rep[0]; s = rep[1];
    begin_frame(); put16(`BR_RETRY(2)); put_data(3, 8'h00, 8'h00); send_frame();
    check("retry first byte", rxb[3], v);
    check("retry second byte", rxb[4], s);
    check("retry accepted", err, 3'h0);
    begin_frame(); put16(`BR_RETRY(2)); put_data(3, 8'h00, 8'h00); put8(8'h00);
    malformed = 1'b1;
    send_frame();                         // rejected retry changes nothing
    check("rejected retry", err, 3'h4);
    resume();
    begin_frame(); put16(`BR_RETRY(2)); put_data(3, 8'h00, 8'h00); send_frame();
    check("batch intact after rejected retry", {rxb[3], rxb[4]}, {v, s});
    check("still unacknowledged", i_dut.i_exec.resp_s_room, 254);
    begin_frame(); put16(`BR_ACK); send_frame();
    check("acknowledge accepted", err, 3'h0);
    check("acknowledge frees the room", i_dut.i_exec.resp_s_room, 256);
    begin_frame(); put16(16'hD300); send_frame();
    check("retry with ack only rejected", err, 3'h1);
    begin_frame(); put16(`BR_FLUSH); send_frame(); wait_idle();

    // CRC: damaged frames are rejected as a whole with ERR[2] only

    if (CRC_EN != 0) begin
      test_count = 28;
      c2 = 16'hffff;
      for (c3 = 0; c3 < 9; c3 = c3 + 1) begin
        c2 = crc16_byte(c2, "1" + c3);
      end
      check("CRC check value", c2, 16'h29b1);

      begin_frame();                      // reply of a final CTRL_R during CHECK
      put16(`BR_CTRL_R(8'h00));
      send_frame();
      check("CTRL_R before CHECK", rxb[2], 8'h01);

      c2 = d0.count;
      raw_frame = 1'b1;
      begin_frame();                      // wrong CRC
      put16(`BR_CTRL_W(8'h04, 8'h99)); put16(`BR_GPIO_W(0, 0, 8'd0));
      put16(`CS(8'hfe)); put16(`WR(1)); put8(8'h46); put16(`CS(8'hff));
      put_check(16'h0001);
      send_frame();
      wait_idle();
      check("bad CRC", err, 3'h4);
      check("bad CRC not sent", d0.count, c2);
      check("bad CRC GPIO not applied", gpio_o[0], 1'b1);
      raw_frame = 1'b0; resume();
      ctrl_r(8'h04, v); check("bad CRC CTRL_W not applied", v, 8'h22);
      raw_frame = 1'b1;

      begin_frame();                      // no CHECK
      put16(`CS(8'hfe)); put16(`WR(1)); put8(8'h47); put16(`CS(8'hff));
      send_frame();
      wait_idle();
      check("missing CHECK", err, 3'h4);
      raw_frame = 1'b0; resume(); raw_frame = 1'b1;

      begin_frame();                      // bytes after CHECK
      put16(`CS(8'hfe)); put16(`WR(1)); put8(8'h48); put16(`CS(8'hff));
      put_check(16'h0000); put16(`BR_NOP);
      send_frame();
      wait_idle();
      check("bytes after CHECK", err, 3'h4);
      raw_frame = 1'b0; resume(); raw_frame = 1'b1;

      begin_frame();                      // bad instruction and bad CRC
      put16(16'h5000); put_check(16'h8000);
      send_frame();
      wait_idle();
      check("integrity hides bad instruction", err, 3'h4);
      raw_frame = 1'b0; resume();
      check("none of them sent", d0.count, c2);
    end

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
