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

`ifndef TIMEOUT
`define TIMEOUT 2000000
`endif

module mrmac_gt_regs_tb;

  parameter VCD_FILE = "mrmac_gt_regs_tb.vcd";

  `include "tb_base.v"

  localparam TIMEOUT_CYCLES = 1024;
  localparam N_ARB = 64;
  localparam [17:0] ARB_APU_BASE = 18'h2_0000;
  localparam [15:0] ARB_DRP_BASE = 16'h1000;

  integer cyc = 0;
  always @(posedge clk) cyc <= cyc + 1;

  reg  force_rst = 1'b0;
  wire resetn = !reset && !force_rst;

  reg  [3:0] rx_run = 4'hf;
  reg        tx_run = 1'b1;
  reg  rx_clk_0 = 1'b0, rx_clk_1 = 1'b0, rx_clk_2 = 1'b0, rx_clk_3 = 1'b0;
  reg  tx_clk = 1'b0;
  always #3.1 if (rx_run[0]) rx_clk_0 = ~rx_clk_0;
  always #3.3 if (rx_run[1]) rx_clk_1 = ~rx_clk_1;
  always #3.5 if (rx_run[2]) rx_clk_2 = ~rx_clk_2;
  always #3.7 if (rx_run[3]) rx_clk_3 = ~rx_clk_3;
  always #2.9 if (tx_run) tx_clk = ~tx_clk;

  reg  [23:0] drp_addr = 24'd0;
  reg  [31:0] drp_di = 32'd0;
  reg         drp_en = 1'b0;
  reg         drp_we = 1'b0;
  wire [31:0] drp_do;
  wire        drp_rdy;

  reg  [17:0] a_awaddr = 18'd0, a_araddr = 18'd0;
  reg  [31:0] a_wdata = 32'd0;
  reg  [3:0]  a_wstrb = 4'hf;
  reg         a_awvalid = 1'b0, a_wvalid = 1'b0, a_bready = 1'b0;
  reg         a_arvalid = 1'b0, a_rready = 1'b0;
  wire        a_awready, a_wready, a_bvalid, a_arready, a_rvalid;
  wire [1:0]  a_bresp, a_rresp;
  wire [31:0] a_rdata;

  wire [17:0] m_awaddr, m_araddr;
  wire [2:0]  m_awprot, m_arprot;
  wire [31:0] m_wdata, m_rdata;
  wire [3:0]  m_wstrb;
  wire        m_awvalid, m_wvalid, m_bready, m_arvalid, m_rready;
  wire        m_awready, m_wready, m_bvalid, m_arready, m_rvalid;
  wire [1:0]  m_bresp, m_rresp;

  wire [15:0] tx_sel, rx_sel;
  wire [3:0]  cntrst;
  wire        prbs_active;
  reg  [3:0]  rx_locked = 4'd0;
  reg  [3:0]  rx_err = 4'd0;

  mrmac_gt_regs #(
    .TIMEOUT_CYCLES(TIMEOUT_CYCLES)
  ) dut (
    .clk(clk),
    .resetn(resetn),
    .drp_addr(drp_addr),
    .drp_di(drp_di),
    .drp_en(drp_en),
    .drp_we(drp_we),
    .drp_do(drp_do),
    .drp_rdy(drp_rdy),
    .s_axi_awaddr(a_awaddr),
    .s_axi_awprot(3'd0),
    .s_axi_awvalid(a_awvalid),
    .s_axi_awready(a_awready),
    .s_axi_wdata(a_wdata),
    .s_axi_wstrb(a_wstrb),
    .s_axi_wvalid(a_wvalid),
    .s_axi_wready(a_wready),
    .s_axi_bresp(a_bresp),
    .s_axi_bvalid(a_bvalid),
    .s_axi_bready(a_bready),
    .s_axi_araddr(a_araddr),
    .s_axi_arprot(3'd0),
    .s_axi_arvalid(a_arvalid),
    .s_axi_arready(a_arready),
    .s_axi_rdata(a_rdata),
    .s_axi_rresp(a_rresp),
    .s_axi_rvalid(a_rvalid),
    .s_axi_rready(a_rready),
    .m_axi_awaddr(m_awaddr),
    .m_axi_awprot(m_awprot),
    .m_axi_awvalid(m_awvalid),
    .m_axi_awready(m_awready),
    .m_axi_wdata(m_wdata),
    .m_axi_wstrb(m_wstrb),
    .m_axi_wvalid(m_wvalid),
    .m_axi_wready(m_wready),
    .m_axi_bresp(m_bresp),
    .m_axi_bvalid(m_bvalid),
    .m_axi_bready(m_bready),
    .m_axi_araddr(m_araddr),
    .m_axi_arprot(m_arprot),
    .m_axi_arvalid(m_arvalid),
    .m_axi_arready(m_arready),
    .m_axi_rdata(m_rdata),
    .m_axi_rresp(m_rresp),
    .m_axi_rvalid(m_rvalid),
    .m_axi_rready(m_rready),
    .tx_prbs_clk(tx_clk),
    .rx_prbs_clk_0(rx_clk_0),
    .rx_prbs_clk_1(rx_clk_1),
    .rx_prbs_clk_2(rx_clk_2),
    .rx_prbs_clk_3(rx_clk_3),
    .tx_prbssel_0(tx_sel[3:0]),
    .tx_prbssel_1(tx_sel[7:4]),
    .tx_prbssel_2(tx_sel[11:8]),
    .tx_prbssel_3(tx_sel[15:12]),
    .rx_prbssel_0(rx_sel[3:0]),
    .rx_prbssel_1(rx_sel[7:4]),
    .rx_prbssel_2(rx_sel[11:8]),
    .rx_prbssel_3(rx_sel[15:12]),
    .rx_prbscntreset_0(cntrst[0]),
    .rx_prbscntreset_1(cntrst[1]),
    .rx_prbscntreset_2(cntrst[2]),
    .rx_prbscntreset_3(cntrst[3]),
    .rx_prbslocked_0(rx_locked[0]),
    .rx_prbslocked_1(rx_locked[1]),
    .rx_prbslocked_2(rx_locked[2]),
    .rx_prbslocked_3(rx_locked[3]),
    .rx_prbserr_0(rx_err[0]),
    .rx_prbserr_1(rx_err[1]),
    .rx_prbserr_2(rx_err[2]),
    .rx_prbserr_3(rx_err[3]),
    .prbs_active(prbs_active));

  reg        slv_hold = 1'b0;
  reg        slv_dead = 1'b0;
  reg        slv_err = 1'b0;
  reg [15:0] slv_lat_r = 16'd5;
  reg [15:0] slv_lat_b = 16'd5;
  reg [15:0] slv_w_delay = 16'd0;

  axil_mem_slave slv (
    .clk(clk),
    .rstn(resetn),
    .hold(slv_hold),
    .dead(slv_dead),
    .err(slv_err),
    .lat_r(slv_lat_r),
    .lat_b(slv_lat_b),
    .aw_delay(16'd0),
    .w_delay(slv_w_delay),
    .awaddr(m_awaddr), .awvalid(m_awvalid), .awready(m_awready),
    .wdata(m_wdata), .wstrb(m_wstrb), .wvalid(m_wvalid), .wready(m_wready),
    .bresp(m_bresp), .bvalid(m_bvalid), .bready(m_bready),
    .araddr(m_araddr), .arvalid(m_arvalid), .arready(m_arready),
    .rdata(m_rdata), .rresp(m_rresp), .rvalid(m_rvalid), .rready(m_rready));

  reg        log_wr   [0:511];
  reg [17:0] log_addr [0:511];
  reg [31:0] log_data [0:511];
  reg [3:0]  log_strb [0:511];
  integer    log_cyc  [0:511];
  integer    log_n = 0;

  always @(posedge clk) begin
    if (m_awvalid && m_awready) begin
      log_wr[log_n] = 1'b1;
      log_addr[log_n] = m_awaddr;
      log_data[log_n] = m_wdata;
      log_strb[log_n] = m_wstrb;
      log_cyc[log_n] = cyc;
      log_n = log_n + 1;
    end
    if (m_arvalid && m_arready) begin
      log_wr[log_n] = 1'b0;
      log_addr[log_n] = m_araddr;
      log_data[log_n] = slv.mem[m_araddr[17:2]];
      log_strb[log_n] = 4'h0;
      log_cyc[log_n] = cyc;
      log_n = log_n + 1;
    end
  end

  integer out_n = 0;
  integer overlap_n = 0;
  reg     m_arvalid_d = 1'b0, m_awvalid_d = 1'b0, m_wvalid_d = 1'b0;

  always @(posedge clk) begin
    if (((m_arvalid && !m_arvalid_d) || (m_awvalid && !m_awvalid_d) ||
         (m_wvalid && !m_wvalid_d)) && out_n > 0) begin
      $display("%t m_axi access issued with %0d outstanding", $time, out_n);
      overlap_n = overlap_n + 1;
    end
    out_n = out_n + (m_arvalid && m_arready) + (m_awvalid && m_awready) -
      (m_rvalid && m_rready) - (m_bvalid && m_bready);
    if (!resetn)
      out_n = 0;
    m_arvalid_d <= m_arvalid;
    m_awvalid_d <= m_awvalid;
    m_wvalid_d <= m_wvalid;
  end

  integer rdy_pulses = 0;
  integer rdy_cycles = 0;
  reg     drp_rdy_d = 1'b0;

  always @(posedge clk) begin
    drp_rdy_d <= drp_rdy;
    if (drp_rdy)
      rdy_cycles = rdy_cycles + 1;
    if (drp_rdy && !drp_rdy_d)
      rdy_pulses = rdy_pulses + 1;
  end

  integer    mv_cycles = 0;
  integer    err_at_clk = 0;
  realtime   clk_t = 0.0;

  always @(posedge clk) begin
    clk_t = $realtime;
    if (m_awvalid || m_wvalid || m_arvalid)
      mv_cycles = mv_cycles + 1;
    if (rx_err[0])
      err_at_clk = err_at_clk + 1;
  end

  reg        mon_en = 1'b0;
  reg        mon_tx = 1'b0;
  integer    mon_lane = 0;
  reg [3:0]  mon_a = 4'd0, mon_b = 4'd0;
  integer    mon_bad = 0;
  wire [3:0] mon_pin = mon_tx ? tx_sel[4*mon_lane +: 4] : rx_sel[4*mon_lane +: 4];

  always @(mon_pin) begin
    if (mon_en && mon_pin !== mon_a && mon_pin !== mon_b) begin
      $display("%t %0s lane %0d select pin %b", $time, mon_tx ? "TX" : "RX",
        mon_lane, mon_pin);
      mon_bad = mon_bad + 1;
    end
  end

  initial begin
    #1;
    $display("%t select pins before the first GT clock edge: tx %h rx %h",
      $time, tx_sel, rx_sel);
  end

  reg [31:0] r_data [0:255];
  reg [1:0]  r_resp [0:255];
  integer    r_n = 0;

  always @(posedge clk) begin
    if (a_rvalid && a_rready) begin
      r_data[r_n] = a_rdata;
      r_resp[r_n] = a_rresp;
      r_n = r_n + 1;
    end
  end

  task check;
    input [8*40-1:0] name;
    input cond;
    begin
      if (cond)
        $display("PASS  %0s", name);
      else begin
        $display("FAIL  %0s", name);
        failed <= 1'b1;
      end
    end
  endtask

  task drp_xfer;
    input         we;
    input  [23:0] addr;
    input  [31:0] di;
    output [31:0] dout;
    output integer cycles;
    integer t0;
    begin
      @(negedge clk);
      drp_addr = addr;
      drp_di = di;
      drp_we = we;
      drp_en = 1'b1;
      t0 = cyc;
      @(negedge clk);
      drp_en = 1'b0;
      while (!drp_rdy && cyc - t0 < 4 * TIMEOUT_CYCLES)
        @(negedge clk);
      dout = drp_rdy ? drp_do : 32'hxxxx_xxxx;
      cycles = cyc - t0;
    end
  endtask

  task wait_sel;
    input  [15:0] tx_exp;
    input  [15:0] rx_exp;
    output        hit;
    integer t;
    begin
      t = cyc;
      while ((tx_sel !== tx_exp || rx_sel !== rx_exp) && cyc - t < 64)
        @(posedge clk);
      hit = (tx_sel === tx_exp && rx_sel === rx_exp);
    end
  endtask

  task apu_write;
    input  [17:0] addr;
    input  [31:0] data;
    input  [3:0]  strb;
    output [1:0]  resp;
    reg aw_done, w_done;
    begin
      a_awaddr <= addr;
      a_wdata <= data;
      a_wstrb <= strb;
      a_awvalid <= 1'b1;
      a_wvalid <= 1'b1;
      a_bready <= 1'b1;
      aw_done = 1'b0;
      w_done = 1'b0;
      while (!(aw_done && w_done)) begin
        @(posedge clk);
        if (a_awvalid && a_awready) begin aw_done = 1'b1; a_awvalid <= 1'b0; end
        if (a_wvalid && a_wready) begin w_done = 1'b1; a_wvalid <= 1'b0; end
      end
      @(posedge clk);
      while (!a_bvalid) @(posedge clk);
      resp = a_bresp;
      a_bready <= 1'b0;
    end
  endtask

  task apu_read;
    input  [17:0] addr;
    output [31:0] data;
    output [1:0]  resp;
    begin
      a_araddr <= addr;
      a_arvalid <= 1'b1;
      a_rready <= 1'b1;
      @(posedge clk);
      while (!a_arready) @(posedge clk);
      a_arvalid <= 1'b0;
      while (!a_rvalid) @(posedge clk);
      data = a_rdata;
      resp = a_rresp;
      a_rready <= 1'b0;
    end
  endtask

  integer    i, j, k, n0, r0, p0, c0, dcyc, run, max_run, apu_seen, drp_seen;
  integer    t0, t1, t_to, lat, hit, m0;
  reg [31:0] rd, rd2, rd3, exp;
  reg [1:0]  resp, resp2, resp3;
  reg [31:0] drp_res [0:N_ARB-1];
  reg        ok, ok2, last_apu;
  reg        all_done = 1'b0;

  initial begin
    #(`TIMEOUT - 1);
    if (!all_done) begin
      $display("FAIL  tests did not complete before TIMEOUT");
      failed <= 1'b1;
    end
  end

  initial begin
    @(negedge reset);
    repeat (10) @(posedge clk);

    // channel n register: APB3 address + n*0x100, all byte lanes
    n0 = log_n;
    drp_xfer(1'b1, 24'h000C68 | (2 << 17), 32'h0002_0000, rd, dcyc);
    check("test_ch_offset", log_n == n0 + 1 && log_wr[n0] == 1'b1 &&
      log_addr[n0] == (18'h0E68 << 2) && log_data[n0] == 32'h0002_0000 &&
      log_strb[n0] == 4'hf);

    // [19]=1: raw quad address
    n0 = log_n;
    drp_xfer(1'b0, 24'h080D12, 32'd0, rd, dcyc);
    check("test_quad_raw", log_n == n0 + 1 && log_wr[n0] == 1'b0 &&
      log_addr[n0] == (18'h0D12 << 2) && rd == slv.mem[16'h0D12] && rd != 32'd0);

    repeat (2) @(posedge clk);
    n0 = log_n;
    p0 = rdy_pulses;
    c0 = rdy_cycles;
    drp_xfer(1'b0, 24'h00000C, 32'd0, rd, dcyc);
    repeat (2) @(posedge clk);
    ok = (rd === 32'd0 && rdy_pulses == p0 + 1);
    drp_xfer(1'b1, 24'h000000, 32'hffff_ffff, rd, dcyc);
    repeat (5) @(posedge clk);
    check("test_low_apb_guard", ok && rd === 32'd0 && log_n == n0 &&
      rdy_pulses == p0 + 2 && rdy_cycles == c0 + 2);

    drp_xfer(1'b0, 24'h080D12, 32'd0, rd2, dcyc);
    n0 = log_n;
    drp_xfer(1'b0, 24'h010040, 32'd0, rd, dcyc);
    ok = (rd === 32'd0 && rd2 != 32'd0);
    drp_xfer(1'b0, 24'h090040, 32'd0, rd, dcyc);
    check("test_ctrl_space_local", ok && rd === 32'd0 && log_n == n0);

    n0 = log_n;
    apu_write(18'h3_1A4, 32'h1234_5678, 4'h3, resp);
    apu_read(18'h2_0010, rd, resp2);
    ok = (log_n == n0 + 2 && log_wr[n0] == 1'b1 && log_addr[n0] == 18'h3_1A4 &&
      log_data[n0] == 32'h1234_5678 && log_strb[n0] == 4'h3 && resp == 2'b00 &&
      log_wr[n0 + 1] == 1'b0 && log_addr[n0 + 1] == 18'h2_0010 &&
      rd == slv.mem[16'h8004] && resp2 == 2'b00);
    slv_err = 1'b1;
    apu_read(18'h2_0014, rd, resp2);
    apu_write(18'h2_0018, 32'h0, 4'hf, resp3);
    slv_err = 1'b0;
    check("test_apu_passthrough", ok && resp2 == 2'b10 && resp3 == 2'b10 &&
      log_n == n0 + 4);

    r0 = r_n;
    a_araddr <= 18'h2_0100;
    a_arvalid <= 1'b1;
    a_rready <= 1'b0;
    @(posedge clk);
    while (!a_arready) @(posedge clk);
    a_araddr <= 18'h2_0104;
    while (!a_rvalid) @(posedge clk);
    rd = a_rdata;
    ok = 1'b1;
    fork
      drp_xfer(1'b0, 24'h080D40, 32'd0, rd2, dcyc);
      repeat (40) begin
        @(posedge clk);
        if (!a_rvalid || a_rdata !== rd || a_rresp !== 2'b00 || a_arready)
          ok = 1'b0;
      end
    join
    a_rready <= 1'b1;
    @(posedge clk);
    while (!a_arready) @(posedge clk);
    a_arvalid <= 1'b0;
    while (r_n < r0 + 2 && cyc < 200000) @(posedge clk);
    a_rready <= 1'b0;
    check("test_apu_rready_hold", ok && rd == slv.mem[16'h8040] &&
      rd2 == slv.mem[16'h0D40] && r_n == r0 + 2 && r_data[r0] == rd &&
      r_data[r0 + 1] == slv.mem[16'h8041] && r_resp[r0 + 1] == 2'b00);

    n0 = log_n;
    r0 = r_n;
    @(posedge clk);
    fork
      begin : apu_stream
        a_rready <= 1'b1;
        for (k = 0; k < N_ARB; k = k + 1) begin
          a_araddr <= ARB_APU_BASE + k * 4;
          a_arvalid <= 1'b1;
          @(posedge clk);
          while (!a_arready) @(posedge clk);
        end
        a_arvalid <= 1'b0;
        while (r_n < r0 + N_ARB && cyc < 40000) @(posedge clk);
        a_rready <= 1'b0;
      end
      begin : drp_stream
        @(negedge clk);
        for (j = 0; j < N_ARB; j = j + 1) begin
          drp_addr = {8'h08, ARB_DRP_BASE + j[15:0]};
          drp_we = 1'b0;
          drp_en = 1'b1;
          @(negedge clk);
          drp_en = 1'b0;
          while (!drp_rdy && cyc < 40000) @(negedge clk);
          drp_res[j] = drp_do;
        end
      end
    join

    ok = (r_n == r0 + N_ARB && log_n == n0 + 2 * N_ARB);
    for (i = 0; i < N_ARB; i = i + 1) begin
      if (r_data[r0 + i] !== slv.mem[(ARB_APU_BASE >> 2) + i] || r_resp[r0 + i] !== 2'b00) begin
        $display("  apu read %0d: %h, expected %h", i, r_data[r0 + i],
          slv.mem[(ARB_APU_BASE >> 2) + i]);
        ok = 1'b0;
      end
      if (drp_res[i] !== slv.mem[ARB_DRP_BASE + i]) begin
        $display("  drp read %0d: %h, expected %h", i, drp_res[i],
          slv.mem[ARB_DRP_BASE + i]);
        ok = 1'b0;
      end
    end
    max_run = 0;
    run = 0;
    apu_seen = 0;
    drp_seen = 0;
    last_apu = 1'b0;
    for (i = n0; i < log_n; i = i + 1) begin
      if (apu_seen < N_ARB && drp_seen < N_ARB) begin
        if (i == n0 || (log_addr[i] >= ARB_APU_BASE) != last_apu)
          run = 1;
        else
          run = run + 1;
        if (run > max_run)
          max_run = run;
      end
      last_apu = (log_addr[i] >= ARB_APU_BASE);
      if (last_apu)
        apu_seen = apu_seen + 1;
      else
        drp_seen = drp_seen + 1;
    end
    $display("arb: %0d APU, %0d DRP, longest run %0d", apu_seen, drp_seen, max_run);
    check("test_arb_concurrent", ok && apu_seen == N_ARB && drp_seen == N_ARB &&
      max_run <= 2);

    slv_hold = 1'b1;
    n0 = log_n;
    t0 = cyc;
    apu_write(18'h0_3600, 32'hcafe_0d80, 4'hf, resp);
    t1 = cyc - t0;
    ok = (resp == 2'b10 && t1 >= TIMEOUT_CYCLES && t1 <= TIMEOUT_CYCLES + 64);
    drp_xfer(1'b0, 24'h080D20, 32'd0, rd, dcyc);
    ok = ok && rd === 32'd0 && dcyc >= TIMEOUT_CYCLES && dcyc <= TIMEOUT_CYCLES + 64;
    t0 = cyc;
    apu_read(18'h0_3484, rd2, resp2);
    t0 = cyc - t0;
    ok = ok && rd2 === 32'd0 && resp2 == 2'b10 && t0 <= TIMEOUT_CYCLES + 64 &&
      log_n == n0 + 1;
    $display("timeout: APU write %0d, DRP read %0d, APU read %0d cycles", t1, dcyc, t0);
    slv_hold = 1'b0;
    repeat (20) @(posedge clk);
    ok = ok && slv.mem[16'h0D80] == 32'hcafe_0d80;
    slv_dead = 1'b1;
    n0 = log_n;
    drp_xfer(1'b0, 24'h080D24, 32'd0, rd, dcyc);
    ok = ok && rd === 32'd0 && dcyc >= TIMEOUT_CYCLES && dcyc <= TIMEOUT_CYCLES + 64 &&
      m_arvalid === 1'b1 && log_n == n0;
    slv_dead = 1'b0;
    repeat (20) @(posedge clk);
    ok = ok && log_n == n0 + 1 && log_addr[n0] == (18'h0D24 << 2);
    drp_xfer(1'b0, 24'h080D28, 32'd0, rd, dcyc);
    apu_read(18'h0_34B0, rd2, resp2);
    check("test_gt_timeout", ok && rd == slv.mem[16'h0D28] && dcyc < 64 &&
      rd2 == slv.mem[16'h0D2C] && resp2 == 2'b00 && overlap_n == 0);

    slv_lat_r = TIMEOUT_CYCLES + 500;
    n0 = log_n;
    drp_xfer(1'b0, 24'h080D50, 32'd0, rd, dcyc);
    t_to = dcyc;
    ok = (rd === 32'd0 && dcyc >= TIMEOUT_CYCLES && dcyc <= TIMEOUT_CYCLES + 64);
    slv_lat_r = 16'd5;
    drp_xfer(1'b0, 24'h080D54, 32'd0, rd2, dcyc);
    apu_read(18'h0_3558, rd3, resp);
    check("test_gt_late_response", ok && rd2 == slv.mem[16'h0D54] &&
      rd3 == slv.mem[16'h0D56] && resp == 2'b00 && log_n == n0 + 3 &&
      log_cyc[n0 + 1] - log_cyc[n0] > TIMEOUT_CYCLES + 500 && overlap_n == 0);

    ok = 1'b1;
    hit = 0;
    for (lat = TIMEOUT_CYCLES - 8; lat <= TIMEOUT_CYCLES + 2; lat = lat + 1) begin
      slv_lat_r = lat;
      drp_xfer(1'b0, 24'h080E00 + lat - TIMEOUT_CYCLES + 8, 32'd0, rd, dcyc);
      exp = slv.mem[16'h0E00 + lat - TIMEOUT_CYCLES + 8];
      if (rd == exp && dcyc == t_to)
        hit = 1;
      if (dcyc > t_to || (rd !== exp && !(rd === 32'd0 && dcyc == t_to)))
        ok = 1'b0;
      while (m_arvalid || m_rready) @(posedge clk);
      repeat (5) @(posedge clk);
    end
    slv_lat_r = 16'd5;
    drp_xfer(1'b0, 24'h080E40, 32'd0, rd, dcyc);
    check("test_timeout_vs_response", ok && hit == 1 && rd == slv.mem[16'h0E40] &&
      overlap_n == 0);

    slv_w_delay = TIMEOUT_CYCLES + 300;
    drp_xfer(1'b1, 24'h080D60, 32'h1111_0d60, rd, dcyc);
    ok = (dcyc >= TIMEOUT_CYCLES && dcyc <= TIMEOUT_CYCLES + 64);
    fork
      drp_xfer(1'b1, 24'h080D64, 32'h2222_0d64, rd, dcyc);
      begin
        while (!(m_wvalid && m_wready) && cyc < 200000) @(posedge clk);
        slv_w_delay = 16'd0;
      end
    join
    repeat (10) @(posedge clk);
    check("test_gt_late_write", ok && dcyc < TIMEOUT_CYCLES &&
      slv.mem[16'h0D60] == 32'h1111_0d60 && slv.mem[16'h0D64] == 32'h2222_0d64 &&
      overlap_n == 0);

    n0 = log_n;
    m0 = mv_cycles;

    drp_xfer(1'b1, 24'h010040 | (1 << 17), 32'd5, rd, dcyc);
    wait_sel(16'h0050, 16'h0, ok);
    ok = ok && cntrst === 4'h0;
    drp_xfer(1'b0, 24'h010040 | (1 << 17), 32'd0, rd, dcyc);
    drp_xfer(1'b0, 24'h010040, 32'd0, rd2, dcyc);
    drp_xfer(1'b1, 24'h010040 | (1 << 17), 32'd0, rd3, dcyc);
    wait_sel(16'h0, 16'h0, ok2);
    check("test_tx_sel", ok && ok2 && rd === 32'd5 && rd2 === 32'd0);

    drp_xfer(1'b1, 24'h011040 | (3 << 17), 32'd5, rd, dcyc);
    wait_sel(16'h0, 16'h5000, ok);
    ok = ok && cntrst === 4'h0;
    drp_xfer(1'b0, 24'h011040 | (3 << 17), 32'd0, rd, dcyc);
    drp_xfer(1'b0, 24'h011040, 32'd0, rd2, dcyc);
    drp_xfer(1'b1, 24'h011040 | (3 << 17), 32'd0, rd3, dcyc);
    wait_sel(16'h0, 16'h0, ok2);
    check("test_rx_sel", ok && ok2 && rd === 32'd5 && rd2 === 32'd0);

    ok = 1'b1;
    for (i = 0; i < 4; i = i + 1) begin
      drp_xfer(1'b1, 24'h011040 | (i << 17), 32'h5, rd, dcyc);
      wait_sel(16'h0, 16'h5 << (4 * i), ok2);
      ok = ok && ok2;
      rx_run[i] = 1'b0;
      repeat (2) @(posedge clk);
      mon_tx = 1'b0;
      mon_lane = i;
      mon_a = 4'h5;
      mon_b = 4'ha;
      mon_bad = 0;
      mon_en = 1'b1;
      drp_xfer(1'b1, 24'h011040 | (i << 17), 32'ha, rd, dcyc);
      repeat (64) @(posedge clk);
      drp_xfer(1'b0, 24'h011040 | (i << 17), 32'd0, rd, dcyc);
      if (rx_sel !== (16'h5 << (4 * i)) || rd !== 32'ha) begin
        $display("  lane %0d clock stopped: rx pins %h, readback %h", i, rx_sel, rd);
        ok = 1'b0;
      end
      rx_run[i] = 1'b1;
      wait_sel(16'h0, 16'ha << (4 * i), ok2);
      mon_en = 1'b0;
      ok = ok && ok2 && mon_bad == 0;
      drp_xfer(1'b1, 24'h011040 | (i << 17), 32'd0, rd, dcyc);
      wait_sel(16'h0, 16'h0, ok2);
      ok = ok && ok2;
    end
    check("test_rx_sel_cdc", ok);

    ok = 1'b1;
    drp_xfer(1'b1, 24'h010040 | (2 << 17), 32'h5, rd, dcyc);
    wait_sel(16'h0500, 16'h0, ok2);
    ok = ok && ok2;
    tx_run = 1'b0;
    repeat (2) @(posedge clk);
    mon_tx = 1'b1;
    mon_lane = 2;
    mon_a = 4'h5;
    mon_b = 4'ha;
    mon_bad = 0;
    mon_en = 1'b1;
    drp_xfer(1'b1, 24'h010040 | (2 << 17), 32'ha, rd, dcyc);
    repeat (64) @(posedge clk);
    drp_xfer(1'b0, 24'h010040 | (2 << 17), 32'd0, rd, dcyc);
    if (tx_sel !== 16'h0500 || rd !== 32'ha) begin
      $display("  TX clock stopped: tx pins %h, readback %h", tx_sel, rd);
      ok = 1'b0;
    end
    tx_run = 1'b1;
    wait_sel(16'h0a00, 16'h0, ok2);
    mon_en = 1'b0;
    ok = ok && ok2 && mon_bad == 0;
    drp_xfer(1'b1, 24'h010040 | (2 << 17), 32'd0, rd, dcyc);
    wait_sel(16'h0, 16'h0, ok2);
    check("test_tx_sel_cdc", ok && ok2);

    // write 1 flips the counter reset, write 0 leaves it
    drp_xfer(1'b1, 24'h011041, 32'd1, rd, dcyc);
    @(posedge clk);
    ok = (cntrst === 4'b0001);
    drp_xfer(1'b0, 24'h011041, 32'd0, rd, dcyc);
    drp_xfer(1'b1, 24'h011041, 32'd0, rd2, dcyc);
    @(posedge clk);
    ok = ok && rd[0] === 1'b1 && cntrst === 4'b0001;
    drp_xfer(1'b1, 24'h011041, 32'd1, rd2, dcyc);
    @(posedge clk);
    ok = ok && cntrst === 4'b0000;
    drp_xfer(1'b0, 24'h011041, 32'd0, rd2, dcyc);
    check("test_cntreset_toggle", ok && rd2[0] === 1'b0 && tx_sel === 16'h0 &&
      rx_sel === 16'h0);

    drp_xfer(1'b0, 24'h011041 | (2 << 17), 32'd0, rd, dcyc);
    @(negedge clk);
    rx_locked[2] = 1'b1;
    repeat (6) @(negedge clk);
    drp_xfer(1'b0, 24'h011041 | (2 << 17), 32'd0, rd2, dcyc);
    drp_xfer(1'b0, 24'h011041, 32'd0, rd3, dcyc);
    ok = (rd[8] === 1'b0 && rd2[8] === 1'b1 && rd3[8] === 1'b0);
    rx_locked[2] = 1'b0;
    repeat (6) @(negedge clk);
    drp_xfer(1'b0, 24'h011041 | (2 << 17), 32'd0, rd, dcyc);
    check("test_locked_sync", ok && rd[8] === 1'b0);

    drp_xfer(1'b0, 24'h011041, 32'd0, rd, dcyc);
    ok = (rd[9] === 1'b0);
    t0 = err_at_clk;
    @(posedge rx_clk_0);
    while ($realtime - clk_t < 1.0 || $realtime - clk_t > 12.0)
      @(posedge rx_clk_0);
    rx_err[0] <= 1'b1;
    @(posedge rx_clk_0);
    rx_err[0] <= 1'b0;
    repeat (20) @(posedge clk);
    drp_xfer(1'b0, 24'h011041, 32'd0, rd, dcyc);
    drp_xfer(1'b0, 24'h011041, 32'd0, rd2, dcyc);
    drp_xfer(1'b0, 24'h011041 | (1 << 17), 32'd0, rd3, dcyc);
    check("test_err_sticky", ok && err_at_clk == t0 && rd[9] === 1'b1 &&
      rd2[9] === 1'b0 && rd3[9] === 1'b0);

    drp_xfer(1'b1, 24'h010042, 32'hffff_ffff, rd, dcyc);
    drp_xfer(1'b1, 24'h010042 | (1 << 17), 32'hffff_ffff, rd, dcyc);
    drp_xfer(1'b0, 24'h010042, 32'd0, rd, dcyc);
    drp_xfer(1'b0, 24'h010042 | (1 << 17), 32'd0, rd2, dcyc);
    check("test_no_scratch", rd === 32'd0 && rd2 === 32'd0 &&
      tx_sel === 16'h0 && rx_sel === 16'h0 && cntrst === 4'h0);

    ok = 1'b1;
    drp_xfer(1'b1, 24'h010041, 32'hffff_ffff, rd, dcyc);
    drp_xfer(1'b0, 24'h010041, 32'd0, rd, dcyc);
    ok = ok && rd === 32'd0;
    drp_xfer(1'b1, 24'h011002, 32'hffff_ffff, rd, dcyc);
    drp_xfer(1'b0, 24'h011002, 32'd0, rd, dcyc);
    ok = ok && rd === 32'd0;
    drp_xfer(1'b1, 24'h090040, 32'd5, rd, dcyc);
    drp_xfer(1'b1, 24'h091040, 32'd5, rd, dcyc);
    drp_xfer(1'b1, 24'h091041, 32'd1, rd, dcyc);
    drp_xfer(1'b1, 24'h090042, 32'h0, rd, dcyc);
    drp_xfer(1'b0, 24'h090042, 32'd0, rd, dcyc);
    ok = ok && rd === 32'd0;
    drp_xfer(1'b0, 24'h010040, 32'd0, rd, dcyc);
    drp_xfer(1'b0, 24'h011040, 32'd0, rd2, dcyc);
    drp_xfer(1'b0, 24'h010042, 32'd0, rd3, dcyc);
    check("test_unlisted_ctrl", ok && rd === 32'd0 && rd2 === 32'd0 &&
      rd3 === 32'd0 && tx_sel === 16'h0 && rx_sel === 16'h0 &&
      cntrst === 4'h0 && prbs_active === 1'b0);

    ok = (prbs_active === 1'b0);
    for (i = 0; i < 8; i = i + 1) begin
      drp_xfer(1'b1, (i < 4 ? 24'h010040 : 24'h011040) | ((i % 4) << 17), 32'd1,
        rd, dcyc);
      repeat (2) @(posedge clk);
      if (prbs_active !== 1'b1) begin
        $display("  select %0d: prbs_active %b", i, prbs_active);
        ok = 1'b0;
      end
      exp = 32'd1 << (4 * i);
      wait_sel(exp[15:0], exp[31:16], ok2);
      ok = ok && ok2;
      drp_xfer(1'b1, (i < 4 ? 24'h010040 : 24'h011040) | ((i % 4) << 17), 32'd0,
        rd, dcyc);
      repeat (2) @(posedge clk);
      if (prbs_active !== 1'b0)
        ok = 1'b0;
      wait_sel(16'h0, 16'h0, ok2);
      ok = ok && ok2;
    end
    check("test_prbs_active_any", ok && log_n == n0 && mv_cycles == m0);

    drp_xfer(1'b1, 24'h010040 | (2 << 17), 32'd3, rd, dcyc);
    drp_xfer(1'b1, 24'h011040 | (1 << 17), 32'd2, rd, dcyc);
    drp_xfer(1'b1, 24'h011041 | (3 << 17), 32'd1, rd, dcyc);
    @(posedge rx_clk_1);
    rx_err[1] <= 1'b1;
    @(posedge rx_clk_1);
    rx_err[1] <= 1'b0;
    repeat (20) @(posedge clk);
    slv_lat_r = 16'd50;
    repeat (2) @(posedge clk);
    p0 = rdy_pulses;
    @(negedge clk);
    drp_addr = 24'h080D30;
    drp_we = 1'b0;
    drp_en = 1'b1;
    @(negedge clk);
    drp_en = 1'b0;
    repeat (10) @(negedge clk);
    ok = (m_rready === 1'b1);
    force_rst = 1'b1;
    repeat (3) @(negedge clk);
    ok = ok && {m_awvalid, m_wvalid, m_bready, m_arvalid, m_rready} === 5'd0;
    force_rst = 1'b0;
    @(negedge clk);
    ok = ok && {m_awvalid, m_wvalid, m_bready, m_arvalid, m_rready} === 5'd0;
    repeat (80) @(negedge clk);
    ok = ok && rdy_pulses == p0;
    ok = ok && tx_sel === 16'h0 && rx_sel === 16'h0 && cntrst === 4'h0 &&
      prbs_active === 1'b0;
    drp_xfer(1'b0, 24'h010040 | (2 << 17), 32'd0, rd, dcyc);
    drp_xfer(1'b0, 24'h011040 | (1 << 17), 32'd0, rd2, dcyc);
    drp_xfer(1'b0, 24'h010042, 32'd0, rd3, dcyc);
    ok = ok && rd === 32'd0 && rd2 === 32'd0 && rd3 === 32'd0;
    drp_xfer(1'b0, 24'h011041 | (1 << 17), 32'd0, rd, dcyc);
    drp_xfer(1'b0, 24'h011041 | (3 << 17), 32'd0, rd2, dcyc);
    ok = ok && rd === 32'd0 && rd2 === 32'd0;
    repeat (2) @(posedge clk);
    p0 = rdy_pulses;
    slv_lat_r = 16'd5;
    drp_xfer(1'b0, 24'h080D34, 32'd0, rd, dcyc);
    repeat (2) @(posedge clk);
    check("test_reset_idle", ok && rd == slv.mem[16'h0D34] && dcyc < 64 &&
      rdy_pulses == p0 + 1);

    all_done = 1'b1;
  end

endmodule

module axil_mem_slave (
  input  wire        clk,
  input  wire        rstn,
  input  wire        hold,
  input  wire        dead,
  input  wire        err,
  input  wire [15:0] lat_r,
  input  wire [15:0] lat_b,
  input  wire [15:0] aw_delay,
  input  wire [15:0] w_delay,
  input  wire [17:0] awaddr,
  input  wire        awvalid,
  output reg         awready = 1'b0,
  input  wire [31:0] wdata,
  input  wire [3:0]  wstrb,
  input  wire        wvalid,
  output reg         wready = 1'b0,
  output reg  [1:0]  bresp = 2'b00,
  output reg         bvalid = 1'b0,
  input  wire        bready,
  input  wire [17:0] araddr,
  input  wire        arvalid,
  output reg         arready = 1'b0,
  output reg  [31:0] rdata = 32'd0,
  output reg  [1:0]  rresp = 2'b00,
  output reg         rvalid = 1'b0,
  input  wire        rready
);

  reg [31:0] mem [0:65535];
  integer    i;

  initial begin
    for (i = 0; i < 65536; i = i + 1)
      mem[i] = {i[15:0] ^ 16'h5a5a, i[15:0]};
  end

  integer    aw_wait = 0;
  integer    w_wait = 0;
  integer    b_cnt = -1;
  integer    r_cnt = -1;
  integer    n;
  reg        aw_got = 1'b0;
  reg        w_got = 1'b0;
  reg [15:0] aw_q = 16'd0;
  reg [31:0] w_q = 32'd0;
  reg [3:0]  s_q = 4'd0;
  reg [15:0] r_addr = 16'd0;

  always @(posedge clk) begin
    awready <= 1'b0;
    wready <= 1'b0;
    arready <= 1'b0;

    if (awvalid && !awready && !aw_got && !dead) begin
      if (aw_wait >= aw_delay) begin
        awready <= 1'b1;
        aw_got <= 1'b1;
        aw_q <= awaddr[17:2];
        aw_wait <= 0;
      end else begin
        aw_wait <= aw_wait + 1;
      end
    end
    if (wvalid && !wready && !w_got && !dead) begin
      if (w_wait >= w_delay) begin
        wready <= 1'b1;
        w_got <= 1'b1;
        w_q <= wdata;
        s_q <= wstrb;
        w_wait <= 0;
      end else begin
        w_wait <= w_wait + 1;
      end
    end

    if (aw_got && w_got && b_cnt < 0 && !bvalid) begin
      for (n = 0; n < 4; n = n + 1)
        if (s_q[n])
          mem[aw_q][8*n +: 8] <= w_q[8*n +: 8];
      aw_got <= 1'b0;
      w_got <= 1'b0;
      b_cnt <= lat_b;
    end else if (b_cnt > 0 && !dead) begin
      b_cnt <= b_cnt - 1;
    end else if (b_cnt == 0 && !dead && !hold) begin
      bvalid <= 1'b1;
      bresp <= err ? 2'b10 : 2'b00;
      b_cnt <= -1;
    end else if (bvalid && bready) begin
      bvalid <= 1'b0;
    end

    if (arvalid && !arready && !rvalid && r_cnt < 0 && !dead) begin
      arready <= 1'b1;
      r_cnt <= lat_r;
      r_addr <= araddr[17:2];
    end else if (r_cnt > 0 && !dead) begin
      r_cnt <= r_cnt - 1;
    end else if (r_cnt == 0 && !dead && !hold) begin
      rvalid <= 1'b1;
      rdata <= mem[r_addr];
      rresp <= err ? 2'b10 : 2'b00;
      r_cnt <= -1;
    end else if (rvalid && rready) begin
      rvalid <= 1'b0;
    end

    if (!rstn) begin
      awready <= 1'b0;
      wready <= 1'b0;
      arready <= 1'b0;
      bvalid <= 1'b0;
      rvalid <= 1'b0;
      aw_got <= 1'b0;
      w_got <= 1'b0;
      aw_wait <= 0;
      w_wait <= 0;
      b_cnt <= -1;
      r_cnt <= -1;
    end
  end

endmodule
