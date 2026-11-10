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
`define TIMEOUT 8000000
`endif

module mrmac_init_tb;

  parameter VCD_FILE = "mrmac_init_tb.vcd";

  `include "tb_base.v"

  localparam POR_CYCLES = 400;
  localparam SETTLE_CYCLES = 400;
  localparam RERESET_CYCLES = 400;
  localparam LINK_DOWN_CYCLES = 2000;
  localparam ALIGN_TIMEOUT_CYCLES = 20000;
  localparam POLL_CYCLES = 100;

`ifdef MODE_4X25G
  localparam MODE = "4x25G";
  localparam PORTS = 4;
`elsif MODE_1X40G
  localparam MODE = "1x40G";
  localparam PORTS = 1;
`else
  localparam MODE = "1x100G";
  localparam PORTS = 1;
`endif

  integer cyc = 0;
  always @(posedge clk) cyc <= cyc + 1;

  reg [PORTS-1:0] link = {PORTS{1'b0}};
`ifdef MODE_1X40G
  reg [PORTS-1:0] fec_aligned = {PORTS{1'b0}};
`else
  reg [PORTS-1:0] fec_aligned = {PORTS{1'b1}};
`endif
  reg             prbs_hold = 1'b0;
  reg [PORTS-1:0] tx_en = {PORTS{1'b1}};
  reg [PORTS-1:0] rx_en = {PORTS{1'b1}};

  wire    gt_rst_all;
  reg     gtpowergood = 1'b0;
  reg     gt_tx_done = 1'b0;
  reg     gt_rx_done = 1'b0;
  integer gt_cnt = 0;
  integer drop_delay = 0;
  integer drop_cnt = 0;
  reg     drop_pend = 1'b0;
  reg     drop_now = 1'b0;
  reg     gt_rst_d = 1'b0;

  always @(posedge clk) begin
    gt_rst_d <= gt_rst_all;
    drop_now <= 1'b0;
    if (cyc == 200)
      gtpowergood <= 1'b1;
    if (gt_rst_all && !gt_rst_d && drop_delay > 0) begin
      drop_pend <= 1'b1;
      drop_cnt <= drop_delay;
    end else if (drop_pend) begin
      drop_cnt <= drop_cnt - 1;
      if (drop_cnt == 1) begin
        drop_pend <= 1'b0;
        drop_now <= 1'b1;
      end
    end
    if (!gtpowergood || drop_now || (gt_rst_all && drop_delay == 0)) begin
      gt_cnt <= 0;
      gt_tx_done <= 1'b0;
      gt_rx_done <= 1'b0;
    end else if (!drop_pend) begin
      gt_cnt <= gt_cnt + 1;
      if (gt_cnt == 300)
        gt_tx_done <= 1'b1;
      if (gt_cnt == 350)
        gt_rx_done <= 1'b1;
    end
  end

  wire [PORTS-1:0] gt_rx_dp_reset;
  reg  [PORTS-1:0] rx_stuck = {PORTS{1'b0}};
  reg  [PORTS-1:0] rx_low = {PORTS{1'b0}};
  reg  [PORTS-1:0] rx_need_dp = {PORTS{1'b0}};
  reg  [PORTS-1:0] dp_m = {PORTS{1'b0}};
  integer dp_cnt [0:PORTS-1];
  integer dp_rises [0:PORTS-1];
  integer dp_rise_cyc [0:PORTS-1];

  wire [PORTS-1:0] gt_rx_done_p = {PORTS{gt_rx_done}} & ~rx_low;

  initial begin : dp_init
    integer k;
    for (k = 0; k < PORTS; k = k + 1) begin
      dp_cnt[k] = 0;
      dp_rises[k] = 0;
      dp_rise_cyc[k] = 0;
    end
  end

  always @(posedge clk) begin : gt_rx_dp
    integer k;
    dp_m <= gt_rx_dp_reset;
    for (k = 0; k < PORTS; k = k + 1) begin
      if (gt_rx_dp_reset[k] && !dp_m[k]) begin
        dp_rises[k] = dp_rises[k] + 1;
        dp_rise_cyc[k] = cyc;
      end
      if (rx_stuck[k]) begin
        rx_low[k] <= 1'b1;
        rx_need_dp[k] <= 1'b1;
      end else if (gt_rx_dp_reset[k]) begin
        rx_low[k] <= 1'b1;
        rx_need_dp[k] <= 1'b0;
        dp_cnt[k] = 0;
      end else if (rx_low[k] && !rx_need_dp[k]) begin
        dp_cnt[k] = dp_cnt[k] + 1;
        if (dp_cnt[k] == 50)
          rx_low[k] <= 1'b0;
      end
    end
  end

  wire             mac_resetn;
  wire [PORTS-1:0] link_ready;

  wire [31:0] awaddr, wdata, araddr;
  wire [3:0]  wstrb;
  wire [2:0]  awprot, arprot;
  wire        awvalid, wvalid, bready, arvalid, rready;
  wire        awready, wready, bvalid, arready, rvalid;
  wire [1:0]  bresp, rresp;
  wire [31:0] rdata;

  reg  [15:0] c_awaddr = 0, c_araddr = 0;
  reg  [31:0] c_wdata = 0;
  reg         c_awvalid = 1'b0, c_wvalid = 1'b0, c_bready = 1'b0;
  reg         c_arvalid = 1'b0, c_rready = 1'b0;
  wire        c_awready, c_wready, c_bvalid, c_arready, c_rvalid;
  wire [1:0]  c_bresp, c_rresp;
  wire [31:0] c_rdata;

  mrmac_init #(
    .MODE(MODE),
    .RS_FEC_ENABLE(1),
    .POR_CYCLES(POR_CYCLES),
    .SETTLE_CYCLES(SETTLE_CYCLES),
    .RERESET_CYCLES(RERESET_CYCLES),
    .LINK_DOWN_CYCLES(LINK_DOWN_CYCLES),
    .ALIGN_TIMEOUT_CYCLES(ALIGN_TIMEOUT_CYCLES),
    .POLL_CYCLES(POLL_CYCLES)
  ) dut (
    .clk(clk),
    .resetn(~reset),
    .gtpowergood(gtpowergood),
    .gt_tx_reset_done({PORTS{gt_tx_done}}),
    .gt_rx_reset_done(gt_rx_done_p),
    .stat_rx_status(link),
    .ctl_tx_enable(tx_en),
    .ctl_rx_enable(rx_en),
    .prbs_hold(prbs_hold),
    .s_axi_awaddr(c_awaddr),
    .s_axi_awprot(3'd0),
    .s_axi_awvalid(c_awvalid),
    .s_axi_awready(c_awready),
    .s_axi_wdata(c_wdata),
    .s_axi_wstrb(4'hf),
    .s_axi_wvalid(c_wvalid),
    .s_axi_wready(c_wready),
    .s_axi_bresp(c_bresp),
    .s_axi_bvalid(c_bvalid),
    .s_axi_bready(c_bready),
    .s_axi_araddr(c_araddr),
    .s_axi_arprot(3'd0),
    .s_axi_arvalid(c_arvalid),
    .s_axi_arready(c_arready),
    .s_axi_rdata(c_rdata),
    .s_axi_rresp(c_rresp),
    .s_axi_rvalid(c_rvalid),
    .s_axi_rready(c_rready),
    .gt_rst_all(gt_rst_all),
    .mac_resetn(mac_resetn),
    .link_ready(link_ready),
    .gt_rx_datapath_reset(gt_rx_dp_reset),
    .m_axi_awaddr(awaddr),
    .m_axi_awprot(awprot),
    .m_axi_awvalid(awvalid),
    .m_axi_awready(awready),
    .m_axi_wdata(wdata),
    .m_axi_wstrb(wstrb),
    .m_axi_wvalid(wvalid),
    .m_axi_wready(wready),
    .m_axi_bresp(bresp),
    .m_axi_bvalid(bvalid),
    .m_axi_bready(bready),
    .m_axi_araddr(araddr),
    .m_axi_arprot(arprot),
    .m_axi_arvalid(arvalid),
    .m_axi_arready(arready),
    .m_axi_rdata(rdata),
    .m_axi_rresp(rresp),
    .m_axi_rvalid(rvalid),
    .m_axi_rready(rready));

  wire        nofec_gt_rst_all;
  wire [PORTS-1:0] nf_link_ready;
  wire [31:0] nf_awaddr, nf_wdata, nf_araddr;
  wire        nf_awvalid, nf_wvalid, nf_bready, nf_arvalid, nf_rready;
  wire        nf_awready, nf_wready, nf_bvalid, nf_arready, nf_rvalid;
  wire [31:0] nf_rdata;

  mrmac_init #(
    .MODE(MODE),
    .RS_FEC_ENABLE(0),
    .POR_CYCLES(POR_CYCLES),
    .SETTLE_CYCLES(SETTLE_CYCLES),
    .RERESET_CYCLES(RERESET_CYCLES),
    .LINK_DOWN_CYCLES(LINK_DOWN_CYCLES),
    .ALIGN_TIMEOUT_CYCLES(ALIGN_TIMEOUT_CYCLES),
    .POLL_CYCLES(POLL_CYCLES)
  ) dut_nofec (
    .clk(clk),
    .resetn(~reset),
    .gtpowergood(gtpowergood),
    .gt_tx_reset_done({PORTS{gt_tx_done}}),
    .gt_rx_reset_done({PORTS{gt_rx_done}}),
    .stat_rx_status(link),
    .ctl_tx_enable({PORTS{1'b1}}),
    .ctl_rx_enable({PORTS{1'b1}}),
    .prbs_hold(1'b0),
    .s_axi_awaddr(16'd0),
    .s_axi_awprot(3'd0),
    .s_axi_awvalid(1'b0),
    .s_axi_awready(),
    .s_axi_wdata(32'd0),
    .s_axi_wstrb(4'h0),
    .s_axi_wvalid(1'b0),
    .s_axi_wready(),
    .s_axi_bresp(),
    .s_axi_bvalid(),
    .s_axi_bready(1'b1),
    .s_axi_araddr(16'd0),
    .s_axi_arprot(3'd0),
    .s_axi_arvalid(1'b0),
    .s_axi_arready(),
    .s_axi_rdata(),
    .s_axi_rresp(),
    .s_axi_rvalid(),
    .s_axi_rready(1'b1),
    .gt_rst_all(nofec_gt_rst_all),
    .mac_resetn(),
    .link_ready(nf_link_ready),
    .gt_rx_datapath_reset(),
    .m_axi_awaddr(nf_awaddr),
    .m_axi_awprot(),
    .m_axi_awvalid(nf_awvalid),
    .m_axi_awready(nf_awready),
    .m_axi_wdata(nf_wdata),
    .m_axi_wstrb(),
    .m_axi_wvalid(nf_wvalid),
    .m_axi_wready(nf_wready),
    .m_axi_bresp(2'b00),
    .m_axi_bvalid(nf_bvalid),
    .m_axi_bready(nf_bready),
    .m_axi_araddr(nf_araddr),
    .m_axi_arprot(),
    .m_axi_arvalid(nf_arvalid),
    .m_axi_arready(nf_arready),
    .m_axi_rdata(nf_rdata),
    .m_axi_rresp(2'b00),
    .m_axi_rvalid(nf_rvalid),
    .m_axi_rready(nf_rready));

  // 0x74C = link status

  reg        slv_mute = 1'b0;

  reg [31:0] wlog_addr [0:1023];
  reg [31:0] wlog_data [0:1023];
  integer    wlog_cyc  [0:1023];
  integer    wlog_n = 0;

  axil_log_slave #(
    .PORTS(PORTS),
    .LATENCY(20)
  ) log_slave (
    .clk(clk),
    .rstn(mac_resetn),
    .mute(slv_mute),
    .link(link),
    .fec_aligned(fec_aligned),
    .awaddr(awaddr), .awvalid(awvalid), .awready(awready),
    .wdata(wdata), .wvalid(wvalid), .wready(wready),
    .bresp(bresp), .bvalid(bvalid), .bready(bready),
    .araddr(araddr), .arvalid(arvalid), .arready(arready),
    .rdata(rdata), .rresp(rresp), .rvalid(rvalid), .rready(rready));

  always @(posedge clk) begin
    if (awvalid && awready && wvalid && wready) begin
      wlog_addr[wlog_n] = awaddr;
      wlog_data[wlog_n] = wdata;
      wlog_cyc[wlog_n] = cyc;
      wlog_n = wlog_n + 1;
    end
  end

  reg [31:0] nf_fec_data [0:3];
  integer    nf_writes = 0;

  initial begin : nf_fec_init
    integer k;
    for (k = 0; k < 4; k = k + 1)
      nf_fec_data[k] = 32'hdeadbeef;
  end

  axil_log_slave #(
    .PORTS(PORTS)
  ) nofec_slave (
    .clk(clk),
    .rstn(1'b1),
    .mute(1'b0),
    .link(link),
    .fec_aligned({PORTS{1'b0}}),
    .awaddr(nf_awaddr), .awvalid(nf_awvalid), .awready(nf_awready),
    .wdata(nf_wdata), .wvalid(nf_wvalid), .wready(nf_wready),
    .bresp(), .bvalid(nf_bvalid), .bready(nf_bready),
    .araddr(nf_araddr), .arvalid(nf_arvalid), .arready(nf_arready),
    .rdata(nf_rdata), .rresp(), .rvalid(nf_rvalid), .rready(nf_rready));

  always @(posedge clk) begin
    if (nf_awvalid && nf_awready && nf_wvalid && nf_wready) begin
      if (nf_awaddr[11:0] == 12'h0d0)
        nf_fec_data[nf_awaddr[13:12]] = nf_wdata;
      nf_writes = nf_writes + 1;
    end
  end

  reg     mac_resetn_d = 1'b0;
  reg     gt_done_d = 1'b0;
  integer gt_done_rise_cyc = 0;
  integer gt_done_fall_cyc = 0;
  integer pulse_start = 0;
  integer pulses_after_lock = 0;
  integer last_pulse_len = 0;
  integer last_pulse_end = 0;
  reg     first_lock = 1'b0;
  integer link_ready_rises = 0;
  integer link_ready_falls = 0;
  reg     link_ready_d = 1'b0;

  always @(posedge clk) begin
    mac_resetn_d <= mac_resetn;
    link_ready_d <= link_ready;
    gt_done_d <= gt_tx_done && gt_rx_done;
    if (!gt_done_d && gt_tx_done && gt_rx_done)
      gt_done_rise_cyc = cyc;
    if (gt_done_d && !(gt_tx_done && gt_rx_done))
      gt_done_fall_cyc = cyc;

    if (gt_tx_done && gt_rx_done)
      first_lock <= 1'b1;
    if (mac_resetn_d && !mac_resetn)
      pulse_start = cyc;
    if (!mac_resetn_d && mac_resetn && first_lock) begin
      pulses_after_lock = pulses_after_lock + 1;
      last_pulse_len = cyc - pulse_start;
      last_pulse_end = cyc;
    end
    if (!link_ready_d && link_ready)
      link_ready_rises = link_ready_rises + 1;
    if (link_ready_d && !link_ready)
      link_ready_falls = link_ready_falls + 1;
  end

`ifndef MODE_4X25G
  localparam N_CFG = 22;
`ifdef MODE_1X40G
  localparam [31:0] EXP_MODE = 32'h4000_0a42;
  localparam [31:0] EXP_FEC  = 32'h0000_0000;
`else
  localparam [31:0] EXP_MODE = 32'h4000_0a64;
  localparam [31:0] EXP_FEC  = 32'h0000_1008;
`endif

  reg [31:0] exp_addr [0:N_CFG-1];
  reg [31:0] exp_data [0:N_CFG-1];

  initial begin
    exp_addr[0]  = 32'h004;  exp_data[0]  = 32'h0000_03ff;
    exp_addr[1]  = 32'h008;  exp_data[1]  = EXP_MODE;
    exp_addr[2]  = 32'h010;  exp_data[2]  = 32'h0000_0033;
    exp_addr[3]  = 32'h00c;  exp_data[3]  = 32'h0000_0c03;
    exp_addr[4]  = 32'h0d0;  exp_data[4]  = EXP_FEC;
    exp_addr[5]  = 32'h10d0; exp_data[5]  = 32'h0000_0000;
    exp_addr[6]  = 32'h20d0; exp_data[6]  = 32'h0000_0000;
    exp_addr[7]  = 32'h30d0; exp_data[7]  = 32'h0000_0000;
    // TX pause refresh timers 0..8 (0x7fff) and quanta 0..8 (0xffff)
    exp_addr[8]  = 32'h04c;  exp_data[8]  = 32'h7fff_7fff;
    exp_addr[9]  = 32'h050;  exp_data[9]  = 32'h7fff_7fff;
    exp_addr[10] = 32'h054;  exp_data[10] = 32'h7fff_7fff;
    exp_addr[11] = 32'h058;  exp_data[11] = 32'h7fff_7fff;
    exp_addr[12] = 32'h05c;  exp_data[12] = 32'h0000_7fff;
    exp_addr[13] = 32'h060;  exp_data[13] = 32'hffff_ffff;
    exp_addr[14] = 32'h064;  exp_data[14] = 32'hffff_ffff;
    exp_addr[15] = 32'h068;  exp_data[15] = 32'hffff_ffff;
    exp_addr[16] = 32'h06c;  exp_data[16] = 32'hffff_ffff;
    exp_addr[17] = 32'h070;  exp_data[17] = 32'h0000_ffff;
    // RX: gcp/pcp/gpp/ppp processing; mcast + etype + opcode checks per type
    exp_addr[18] = 32'h09c;  exp_data[18] = 32'h0000_000f;
    exp_addr[19] = 32'h0a0;  exp_data[19] = 32'h000c_e739;
    exp_addr[20] = 32'h004;  exp_data[20] = 32'h0000_0000;
    exp_addr[21] = 32'h02c;  exp_data[21] = 32'h0000_0001;
  end
`endif

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

  task wait_cycles_or;
    input integer max_cycles;
    input integer target_writes;
    integer start;
    begin
      start = cyc;
      while (wlog_n < target_writes && cyc - start < max_cycles)
        @(posedge clk);
    end
  endtask

  task cpu_write;
    input [15:0] addr;
    input [31:0] data;
    reg aw_done, w_done;
    begin
      c_awaddr <= addr;
      c_wdata <= data;
      c_awvalid <= 1'b1;
      c_wvalid <= 1'b1;
      c_bready <= 1'b1;
      aw_done = 1'b0;
      w_done = 1'b0;
      while (!(aw_done && w_done)) begin
        @(posedge clk);
        if (c_awvalid && c_awready) begin aw_done = 1'b1; c_awvalid <= 1'b0; end
        if (c_wvalid && c_wready) begin w_done = 1'b1; c_wvalid <= 1'b0; end
      end
      @(posedge clk);
      while (!c_bvalid) @(posedge clk);
      c_bready <= 1'b0;
    end
  endtask

  task cpu_read;
    input  [15:0] addr;
    output [31:0] data;
    begin
      c_araddr <= addr;
      c_arvalid <= 1'b1;
      c_rready <= 1'b1;
      @(posedge clk);
      while (!c_arready) @(posedge clk);
      c_arvalid <= 1'b0;
      while (!c_rvalid) @(posedge clk);
      data = c_rdata;
      c_rready <= 1'b0;
    end
  endtask

`ifndef MODE_4X25G
  function seq_ok;
    input integer base;
    input integer n;
    integer j;
    begin
      seq_ok = 1'b1;
      for (j = 0; j < n; j = j + 1)
        if (wlog_addr[base + j] !== exp_addr[j] || wlog_data[base + j] !== exp_data[j]) begin
          $display("  write %0d: %h <- %h, expected %h <- %h", base + j,
            wlog_addr[base + j], wlog_data[base + j], exp_addr[j], exp_data[j]);
          seq_ok = 1'b0;
        end
    end
  endfunction
`endif

`ifndef MODE_4X25G
  reg     storm = 1'b0;
  reg     storm_busy = 1'b0;
  reg     storm_hung = 1'b0;
  integer storm_reads = 0, storm_slverr = 0, storm_max_cyc = 0;

  initial begin : cpu_storm
    integer t0;
    forever begin
      @(posedge clk);
      if (storm && !storm_hung) begin
        storm_busy = 1'b1;
        t0 = cyc;
        c_araddr <= 16'h0000;
        c_arvalid <= 1'b1;
        c_rready <= 1'b1;
        @(posedge clk);
        while (!c_arready && cyc - t0 < 20000) @(posedge clk);
        c_arvalid <= 1'b0;
        while (!c_rvalid && cyc - t0 < 20000) @(posedge clk);
        if (!c_rvalid) begin
          $display("%t cpu storm: read issued at cycle %0d never completed", $time, t0);
          storm_hung = 1'b1;
        end else begin
          storm_reads = storm_reads + 1;
          if (c_rresp == 2'b10)
            storm_slverr = storm_slverr + 1;
          if (cyc - t0 > storm_max_cyc)
            storm_max_cyc = cyc - t0;
        end
        c_rready <= 1'b0;
        storm_busy = 1'b0;
      end
    end
  end

`ifdef MODE_1X40G
  reg     gt_rst_q = 1'b0;
  integer gt_rst_pulses = 0;
  always @(posedge clk) begin
    gt_rst_q <= gt_rst_all;
    if (gt_rst_all && !gt_rst_q)
      gt_rst_pulses = gt_rst_pulses + 1;
  end
`endif

  integer i, n0, p0, ready_rise0, t0, t1, g0;
  reg [31:0] rd2;
  reg [31:0] rd;
  reg     all_done = 1'b0;

  initial begin
    #(`TIMEOUT - 1);
    if (!all_done) begin
      $display("FAIL  tests did not complete before TIMEOUT");
      failed <= 1'b1;
    end
  end

  initial begin
    @(negedge reset);

    wait_cycles_or(100000, N_CFG);
    check("test_sequence", wlog_n >= N_CFG && seq_ok(0, N_CFG));
    check("test_double_reset", pulses_after_lock == 1 && last_pulse_len >= RERESET_CYCLES &&
      last_pulse_end < wlog_cyc[0]);
    check("test_no_link_ready_before_align", link_ready === 1'b0);

    repeat (500) @(posedge clk);
    link = 1'b1;
    repeat (5 * POLL_CYCLES) @(posedge clk);
    check("test_link_ready", link_ready === 1'b1 && wlog_n == N_CFG);

    n0 = wlog_n;
    tx_en = 1'b0;
    repeat (200) @(posedge clk);
    check("test_enable_follow (tx off)", wlog_n == n0 + 1 &&
      wlog_addr[n0] == 32'h00c && wlog_data[n0] == 32'h0000_0c02);
    rx_en = 1'b0;
    repeat (200) @(posedge clk);
    check("test_enable_follow (rx off)", wlog_n == n0 + 2 &&
      wlog_addr[n0 + 1] == 32'h010 && wlog_data[n0 + 1] == 32'h0000_0032);
    tx_en = 1'b1;
    rx_en = 1'b1;
    repeat (400) @(posedge clk);
    check("test_enable_follow (both on)", wlog_n == n0 + 4);

    n0 = wlog_n;
    cpu_write(16'h0820, 32'h1234_5678);
    cpu_read(16'h074c, rd);
    check("test_cpu_passthrough", wlog_n == n0 + 1 && wlog_addr[n0] == 32'h0820 &&
      wlog_data[n0] == 32'h1234_5678 && rd == 32'h1 && c_bresp == 2'b00);

    slv_mute = 1'b1;
    t0 = cyc;
    cpu_read(16'h0000, rd);
    t1 = cyc - t0;
    slv_mute = 1'b0;
    repeat (50) @(posedge clk);
    cpu_read(16'h0000, rd2);
    check("test_eng_timeout", c_rresp == 2'b00 && rd2 == 32'h1 && t1 >= 4096 && t1 < 4300 &&
      rd == 32'h0);

    n0 = wlog_n;
    ready_rise0 = link_ready_rises;
    link = 1'b0;
    storm = 1'b1;
    wait_cycles_or(LINK_DOWN_CYCLES + 100000, n0 + N_CFG);
    storm = 1'b0;
    while (storm_busy) @(posedge clk);
    $display("cpu storm: %0d reads, %0d SLVERR, longest %0d cycles", storm_reads,
      storm_slverr, storm_max_cyc);
    check("test_cpu_across_reset", storm_reads > 20 && storm_slverr > 0 && !storm_hung);
    check("test_relink (sequence replayed)", wlog_n >= n0 + N_CFG && seq_ok(n0, N_CFG) &&
      pulses_after_lock == 2 && link_ready_falls >= 1);
    repeat (500) @(posedge clk);
    link = 1'b1;
    repeat (5 * POLL_CYCLES) @(posedge clk);
    check("test_relink (link_ready back)", link_ready === 1'b1 && link_ready_rises == ready_rise0 + 1 &&
      wlog_n == n0 + N_CFG);

    n0 = wlog_n;
    ready_rise0 = link_ready_rises;
    drop_delay = RERESET_CYCLES + 200;
    link = 1'b0;
    wait_cycles_or(LINK_DOWN_CYCLES + 100000, n0 + N_CFG);
    drop_delay = 0;
    check("test_relock_stale_done", wlog_n >= n0 + N_CFG && seq_ok(n0, N_CFG) &&
      gt_done_fall_cyc > wlog_cyc[n0 - 1] && wlog_cyc[n0] > gt_done_rise_cyc &&
      gt_done_rise_cyc > gt_done_fall_cyc);
    repeat (500) @(posedge clk);
    link = 1'b1;
    repeat (5 * POLL_CYCLES) @(posedge clk);
    check("test_relock_stale_done (link_ready back)", link_ready === 1'b1 &&
      link_ready_rises == ready_rise0 + 1);

    n0 = wlog_n;
    link = 1'b0;
    repeat (LINK_DOWN_CYCLES / 4) @(posedge clk);
    link = 1'b1;
    repeat (LINK_DOWN_CYCLES * 2) @(posedge clk);
    check("test_short_glitch", wlog_n == n0 && link_ready === 1'b1);

    n0 = wlog_n;
    p0 = pulses_after_lock;
    link = 1'b0;
    wait_cycles_or(LINK_DOWN_CYCLES + 2 * ALIGN_TIMEOUT_CYCLES + 40000, n0 + 2 * N_CFG);
    check("test_align_timeout", wlog_n >= n0 + 2 * N_CFG && pulses_after_lock >= p0 + 2 &&
      link_ready === 1'b0);
    link = 1'b1;
    t0 = cyc;
    while (!link_ready && cyc - t0 < ALIGN_TIMEOUT_CYCLES + 40000) @(posedge clk);

    n0 = wlog_n;
    p0 = pulses_after_lock;
    prbs_hold = 1'b1;
    link = 1'b0;
    repeat (3 * LINK_DOWN_CYCLES) @(posedge clk);
    check("test_prbs_hold_up", link_ready === 1'b1 && wlog_n == n0 &&
      pulses_after_lock == p0);

    t0 = cyc;
    prbs_hold = 1'b0;
    while (!gt_rst_all && cyc - t0 < LINK_DOWN_CYCLES + 10000) @(posedge clk);
    check("test_prbs_hold_release", gt_rst_all === 1'b1 && cyc >= t0 + LINK_DOWN_CYCLES);

    wait_cycles_or(100000, n0 + N_CFG);
    repeat (50) @(posedge clk);
    n0 = wlog_n;
    p0 = pulses_after_lock;
    prbs_hold = 1'b1;
    repeat (2 * ALIGN_TIMEOUT_CYCLES) @(posedge clk);
    t1 = pulses_after_lock;
    prbs_hold = 1'b0;
    link = 1'b1;
    repeat (5 * POLL_CYCLES) @(posedge clk);
    check("test_prbs_hold_align", t1 == p0 && wlog_n == n0 && pulses_after_lock == p0 &&
      link_ready === 1'b1);

    check("test_fec_off", nf_fec_data[0] == 32'h0000_0000 && nf_writes >= N_CFG);

`ifdef MODE_1X40G
    repeat (500) @(posedge clk);
    n0 = wlog_n;
    g0 = gt_rst_pulses;
    link = 1'b0;
    wait_cycles_or(LINK_DOWN_CYCLES + 100000, n0 + N_CFG);
    check("test_relink_40g (GT reset+cfg)", gt_rst_pulses == g0 + 1 &&
      wlog_n >= n0 + N_CFG && seq_ok(n0, N_CFG));
    link = 1'b1;
    repeat (5 * POLL_CYCLES) @(posedge clk);
    check("test_relink_40g (link back)", link_ready === 1'b1);
`endif

    all_done = 1'b1;
  end
`else
  // 4x25G: register block n at n * 0x1000

  localparam N_CFG = 19;
  localparam [31:0] CPU_WADDR = 32'h0000_00ec;

  reg [31:0] exp_addr [0:N_CFG-1];
  reg [31:0] exp_data [0:N_CFG-1];

  initial begin
    // bits [3:1] of RESET_REG_0 are rx_serdes_reset of lanes 1..3
    exp_addr[0]  = 32'h004;  exp_data[0]  = 32'h0000_03f1;
    exp_addr[1]  = 32'h008;  exp_data[1]  = 32'h4000_0261;
    exp_addr[2]  = 32'h010;  exp_data[2]  = 32'h0000_0033;
    exp_addr[3]  = 32'h00c;  exp_data[3]  = 32'h0000_0c03;
    // Clause 108 RS(528,514) + Clause 49 transcode
    exp_addr[4]  = 32'h0d0;  exp_data[4]  = 32'h0000_0043;
    exp_addr[5]  = 32'h04c;  exp_data[5]  = 32'h7fff_7fff;
    exp_addr[6]  = 32'h050;  exp_data[6]  = 32'h7fff_7fff;
    exp_addr[7]  = 32'h054;  exp_data[7]  = 32'h7fff_7fff;
    exp_addr[8]  = 32'h058;  exp_data[8]  = 32'h7fff_7fff;
    exp_addr[9]  = 32'h05c;  exp_data[9]  = 32'h0000_7fff;
    exp_addr[10] = 32'h060;  exp_data[10] = 32'hffff_ffff;
    exp_addr[11] = 32'h064;  exp_data[11] = 32'hffff_ffff;
    exp_addr[12] = 32'h068;  exp_data[12] = 32'hffff_ffff;
    exp_addr[13] = 32'h06c;  exp_data[13] = 32'hffff_ffff;
    exp_addr[14] = 32'h070;  exp_data[14] = 32'h0000_ffff;
    exp_addr[15] = 32'h09c;  exp_data[15] = 32'h0000_000f;
    exp_addr[16] = 32'h0a0;  exp_data[16] = 32'h000c_e739;
    exp_addr[17] = 32'h004;  exp_data[17] = 32'h0000_0000;
    exp_addr[18] = 32'h02c;  exp_data[18] = 32'h0000_0001;
  end

  function is_port_write;
    input integer k;
    input integer p;
    begin
      is_port_write = wlog_addr[k][31:12] == p && wlog_addr[k] != CPU_WADDR;
    end
  endfunction

  function port_seq_ok;
    input integer p;
    input integer base;
    integer j, k;
    begin
      port_seq_ok = 1'b1;
      j = 0;
      for (k = base; k < wlog_n && j < N_CFG; k = k + 1)
        if (is_port_write(k, p)) begin
          if (wlog_addr[k] !== (exp_addr[j] | (p << 12)) || wlog_data[k] !== exp_data[j]) begin
            $display("  port %0d write %0d: %h <- %h, expected %h <- %h", p, k,
              wlog_addr[k], wlog_data[k], exp_addr[j] | (p << 12), exp_data[j]);
            port_seq_ok = 1'b0;
          end
          j = j + 1;
        end
      if (j < N_CFG) begin
        $display("  port %0d: %0d of %0d program writes", p, j, N_CFG);
        port_seq_ok = 1'b0;
      end
    end
  endfunction

  // off = -1 counts any
  function integer port_writes;
    input integer p;
    input integer off;
    input integer base;
    integer k;
    begin
      port_writes = 0;
      for (k = base; k < wlog_n; k = k + 1)
        if (is_port_write(k, p) && (off < 0 || wlog_addr[k][11:0] == off))
          port_writes = port_writes + 1;
    end
  endfunction

  function integer all_writes;
    input integer base;
    begin
      all_writes = port_writes(0, -1, base) + port_writes(1, -1, base) +
                   port_writes(2, -1, base) + port_writes(3, -1, base);
    end
  endfunction

  function has_write;
    input [31:0]  addr;
    input [31:0]  data;
    input integer base;
    integer k;
    begin
      has_write = 1'b0;
      for (k = base; k < wlog_n; k = k + 1)
        if (wlog_addr[k] == addr && wlog_data[k] == data)
          has_write = 1'b1;
    end
  endfunction

  integer cpu_wlog = 0;

  always @(posedge clk)
    if (awvalid && awready && wvalid && wready && awaddr == CPU_WADDR)
      cpu_wlog = cpu_wlog + 1;

  reg nf_all_up = 1'b0;

  always @(posedge clk)
    if (nf_link_ready === 4'b1111)
      nf_all_up <= 1'b1;

  integer gt_rst_rises = 0;
  integer mac_rst_falls = 0;
  integer lr_rises [0:3];
  integer lr_falls [0:3];
  reg     gt_rst_m = 1'b0;
  reg     mac_rst_m = 1'b0;
  reg [3:0] lr_m = 4'd0;

  initial begin : lr_init
    integer k;
    for (k = 0; k < 4; k = k + 1) begin
      lr_rises[k] = 0;
      lr_falls[k] = 0;
    end
  end

  always @(posedge clk) begin : port_mon
    integer k;
    gt_rst_m <= gt_rst_all;
    mac_rst_m <= mac_resetn;
    lr_m <= link_ready;
    if (gt_rst_all && !gt_rst_m)
      gt_rst_rises = gt_rst_rises + 1;
    if (mac_rst_m && !mac_resetn)
      mac_rst_falls = mac_rst_falls + 1;
    for (k = 0; k < 4; k = k + 1) begin
      if (link_ready[k] && !lr_m[k])
        lr_rises[k] = lr_rises[k] + 1;
      if (!link_ready[k] && lr_m[k])
        lr_falls[k] = lr_falls[k] + 1;
    end
  end

  reg     storm2 = 1'b0;
  reg     storm2_busy = 1'b0;
  reg     storm2_hung = 1'b0;
  integer storm2_ops = 0, storm2_slverr = 0, storm2_wr_ok = 0, storm2_max_cyc = 0;

  initial begin : cpu_storm2
    integer t;
    reg     wr;
    wr = 1'b0;
    forever begin
      @(posedge clk);
      if (storm2 && !storm2_hung) begin
        storm2_busy = 1'b1;
        t = cyc;
        wr = !wr;
        if (wr) begin
          c_awaddr <= CPU_WADDR[15:0];
          c_wdata <= storm2_ops;
          c_awvalid <= 1'b1;
          c_wvalid <= 1'b1;
          c_bready <= 1'b1;
          @(posedge clk);
          while (!c_awready && cyc - t < 20000) @(posedge clk);
          c_awvalid <= 1'b0;
          c_wvalid <= 1'b0;
          while (!c_bvalid && cyc - t < 20000) @(posedge clk);
          if (!c_bvalid) begin
            $display("%t cpu storm: write issued at cycle %0d never completed", $time, t);
            storm2_hung = 1'b1;
          end else if (c_bresp == 2'b10) begin
            storm2_slverr = storm2_slverr + 1;
          end else begin
            storm2_wr_ok = storm2_wr_ok + 1;
          end
          c_bready <= 1'b0;
        end else begin
          c_araddr <= 16'h274c;
          c_arvalid <= 1'b1;
          c_rready <= 1'b1;
          @(posedge clk);
          while (!c_arready && cyc - t < 20000) @(posedge clk);
          c_arvalid <= 1'b0;
          while (!c_rvalid && cyc - t < 20000) @(posedge clk);
          if (!c_rvalid) begin
            $display("%t cpu storm: read issued at cycle %0d never completed", $time, t);
            storm2_hung = 1'b1;
          end else if (c_rresp == 2'b10) begin
            storm2_slverr = storm2_slverr + 1;
          end
          c_rready <= 1'b0;
        end
        if (!storm2_hung) begin
          storm2_ops = storm2_ops + 1;
          if (cyc - t > storm2_max_cyc)
            storm2_max_cyc = cyc - t;
        end
        storm2_busy = 1'b0;
      end
    end
  end

  task wait_ready;
    input [3:0]   mask;
    input integer max_cycles;
    integer start;
    begin
      start = cyc;
      while ((link_ready & mask) != mask && cyc - start < max_cycles)
        @(posedge clk);
    end
  endtask

  integer i, k0, n0, n1, g0, m0, t0, t1, t2, lock1;
  integer f0 [0:3];
  integer d0 [0:3];
  reg     ok;
  reg     all_done = 1'b0;

  initial begin
    #(`TIMEOUT - 1);
    if (!all_done) begin
      $display("FAIL  tests did not complete before TIMEOUT");
      failed <= 1'b1;
    end
  end

  initial begin
    @(negedge reset);

    wait_cycles_or(100000, 4 * N_CFG);
    repeat (200) @(posedge clk);
    ok = wlog_n == 4 * N_CFG;
    for (i = 0; i < 4; i = i + 1)
      ok = ok & port_seq_ok(i, 0);
    check("test_program_all_ports", ok && gt_rst_rises == 2 && pulses_after_lock == 1 &&
      last_pulse_end < wlog_cyc[0] && link_ready === 4'b0000);

    n0 = wlog_n;
    tx_en[2] = 1'b0;
    repeat (200) @(posedge clk);
    check("test_enable_mirror (port 2 tx off)", wlog_n == n0 + 1 &&
      wlog_addr[n0] == 32'h200c && wlog_data[n0] == 32'h0000_0c02);
    rx_en[1] = 1'b0;
    repeat (200) @(posedge clk);
    check("test_enable_mirror (port 1 rx off)", wlog_n == n0 + 2 &&
      wlog_addr[n0 + 1] == 32'h1010 && wlog_data[n0 + 1] == 32'h0000_0032);
    tx_en = 4'b0110;
    rx_en = 4'b1001;
    repeat (600) @(posedge clk);
    check("test_enable_mirror (several ports)", wlog_n == n0 + 6 &&
      has_write(32'h000c, 32'h0c02, n0 + 2) && has_write(32'h200c, 32'h0c03, n0 + 2) &&
      has_write(32'h300c, 32'h0c02, n0 + 2) && has_write(32'h2010, 32'h0032, n0 + 2));
    tx_en = 4'b1111;
    rx_en = 4'b1111;
    repeat (600) @(posedge clk);
    check("test_enable_mirror (all on)", wlog_n == n0 + 10 &&
      has_write(32'h000c, 32'h0c03, n0 + 6) && has_write(32'h300c, 32'h0c03, n0 + 6) &&
      has_write(32'h1010, 32'h0033, n0 + 6) && has_write(32'h2010, 32'h0033, n0 + 6));

    n0 = wlog_n;
    g0 = gt_rst_rises;
    m0 = mac_rst_falls;
    for (i = 0; i < 4; i = i + 1)
      d0[i] = dp_rises[i];
    link = 4'b0011;
    wait_ready(4'b0011, 10 * POLL_CYCLES);
    t0 = cyc;
    repeat (2 * ALIGN_TIMEOUT_CYCLES + 10000) @(posedge clk);
    check("test_port_down_isolated (0,1 up)", link_ready === 4'b0011 &&
      lr_falls[0] == 0 && lr_falls[1] == 0 &&
      port_writes(0, -1, n0) == 0 && port_writes(1, -1, n0) == 0);
    check("test_port_down_isolated (no GT reset)", gt_rst_rises == 2 && g0 == 2 &&
      mac_rst_falls == m0 && mac_resetn === 1'b1);
    check("test_port_down_isolated (2,3 retry)", port_seq_ok(2, n0) && port_seq_ok(3, n0) &&
      port_writes(2, 12'h004, n0) >= 4 && port_writes(3, 12'h004, n0) >= 4 &&
      all_writes(n0) == wlog_n - n0);
    check("test_port_down_isolated (2,3 rx reset)", dp_rises[0] == d0[0] &&
      dp_rises[1] == d0[1] && dp_rises[2] >= d0[2] + 1 && dp_rises[3] >= d0[3] + 1);

    link = 4'b1111;
    wait_ready(4'b1111, ALIGN_TIMEOUT_CYCLES + 10000);
    repeat (200) @(posedge clk);
    n0 = wlog_n;
    g0 = gt_rst_rises;
    m0 = mac_rst_falls;
    for (i = 0; i < 4; i = i + 1)
      f0[i] = lr_falls[i];
    link[1] = 1'b0;
    t0 = cyc;
    while (port_writes(1, -1, n0) < N_CFG && cyc - t0 < LINK_DOWN_CYCLES + 10000)
      @(posedge clk);
    repeat (500) @(posedge clk);
    check("test_port_relink", port_seq_ok(1, n0) && port_writes(1, -1, n0) == N_CFG &&
      port_writes(0, -1, n0) == 0 && port_writes(2, -1, n0) == 0 &&
      port_writes(3, -1, n0) == 0 && link_ready === 4'b1101 && lr_falls[1] == f0[1] + 1 &&
      lr_falls[0] == f0[0] && lr_falls[2] == f0[2] && lr_falls[3] == f0[3] &&
      gt_rst_rises == g0 && mac_rst_falls == m0);

    fec_aligned[1] = 1'b0;
    link[1] = 1'b1;
    repeat (10 * POLL_CYCLES) @(posedge clk);
    t1 = link_ready[1];
    fec_aligned[1] = 1'b1;
    wait_ready(4'b0010, 10 * POLL_CYCLES);
    check("test_fec_align_gate", t1 == 0 && link_ready === 4'b1111 &&
      wlog_n == n0 + N_CFG);

    repeat (200) @(posedge clk);
    n0 = wlog_n;
    n1 = cpu_wlog;
    g0 = gt_rst_rises;
    m0 = mac_rst_falls;
    for (i = 0; i < 4; i = i + 1)
      f0[i] = lr_falls[i];
    storm2 = 1'b1;
    link[2] = 1'b0;
    t0 = cyc;
    while (port_writes(2, -1, n0) < N_CFG && cyc - t0 < LINK_DOWN_CYCLES + 20000)
      @(posedge clk);
    repeat (200) @(posedge clk);
    storm2 = 1'b0;
    while (storm2_busy) @(posedge clk);
    repeat (50) @(posedge clk);
    $display("cpu storm: %0d ops, %0d SLVERR, %0d writes OKAY, %0d logged, longest %0d cycles",
      storm2_ops, storm2_slverr, storm2_wr_ok, cpu_wlog - n1, storm2_max_cyc);
    check("test_cpu_access_during_port_relink", !storm2_hung && storm2_ops > 40 &&
      cpu_wlog - n1 == storm2_wr_ok && storm2_slverr == 0 && port_seq_ok(2, n0) &&
      port_writes(0, -1, n0) == 0 && port_writes(1, -1, n0) == 0 &&
      port_writes(3, -1, n0) == 0 && lr_falls[0] == f0[0] && lr_falls[1] == f0[1] &&
      lr_falls[3] == f0[3] && gt_rst_rises == g0 && mac_rst_falls == m0);
    link[2] = 1'b1;
    wait_ready(4'b1111, 20 * POLL_CYCLES);

    n0 = wlog_n;
    g0 = gt_rst_rises;
    prbs_hold = 1'b1;
    link = 4'b0000;
    repeat (ALIGN_TIMEOUT_CYCLES + 3 * LINK_DOWN_CYCLES) @(posedge clk);
    check("test_prbs_hold_ports", link_ready === 4'b1111 && wlog_n == n0 &&
      gt_rst_rises == g0);
    link = 4'b1111;
    repeat (50) @(posedge clk);
    prbs_hold = 1'b0;
    repeat (3 * LINK_DOWN_CYCLES) @(posedge clk);
    check("test_prbs_hold_ports (release)", link_ready === 4'b1111 && wlog_n == n0);

    g0 = gt_rst_rises;
    m0 = mac_rst_falls;
    link = 4'b0000;
    t0 = cyc;
    while (gt_rst_rises == g0 && cyc - t0 < LINK_DOWN_CYCLES + ALIGN_TIMEOUT_CYCLES + 10000)
      @(posedge clk);
    t1 = cyc;
    n1 = wlog_n;
    while (gt_rst_rises == g0 + 1 && cyc - t1 < 2 * ALIGN_TIMEOUT_CYCLES + 10000)
      @(posedge clk);
    t2 = cyc;
    lock1 = gt_done_rise_cyc;
    ok = 1'b1;
    for (i = 0; i < 4; i = i + 1)
      ok = ok & port_seq_ok(i, n1);
    check("test_all_down_gt_reset", gt_rst_rises == g0 + 2 && mac_rst_falls == m0 + 2 &&
      t1 - t0 >= LINK_DOWN_CYCLES + ALIGN_TIMEOUT_CYCLES &&
      lock1 > t1 && t2 - lock1 >= ALIGN_TIMEOUT_CYCLES &&
      t2 - lock1 < ALIGN_TIMEOUT_CYCLES + SETTLE_CYCLES + 1000 && ok);
    n1 = wlog_n;
    wait_cycles_or(100000, n1 + 4 * N_CFG);
    link = 4'b1111;
    wait_ready(4'b1111, 20 * POLL_CYCLES);
    repeat (ALIGN_TIMEOUT_CYCLES + 1000) @(posedge clk);
    ok = 1'b1;
    for (i = 0; i < 4; i = i + 1)
      ok = ok & port_seq_ok(i, n1);
    check("test_all_down_gt_reset (ports back)", link_ready === 4'b1111 && ok &&
      gt_rst_rises == g0 + 2 && wlog_n == n1 + 4 * N_CFG);

    n0 = wlog_n;
    g0 = gt_rst_rises;
    m0 = mac_rst_falls;
    for (i = 0; i < 4; i = i + 1) begin
      f0[i] = lr_falls[i];
      d0[i] = dp_rises[i];
    end
    rx_stuck = 4'b1100;
    link = 4'b0011;
    repeat (LINK_DOWN_CYCLES + 2 * ALIGN_TIMEOUT_CYCLES + 2000) @(posedge clk);
    check("test_port_late_rx_done (2,3 held)", link_ready === 4'b0011 &&
      gt_rx_done_p === 4'b0011 && port_writes(2, -1, n0) == 0 &&
      port_writes(3, -1, n0) == 0 && dp_rises[2] >= d0[2] + 2 && dp_rises[3] >= d0[3] + 2);
    t0 = cyc;
    rx_stuck = 4'b0000;
    link = 4'b1111;
    wait_ready(4'b1100, ALIGN_TIMEOUT_CYCLES + 10000);
    repeat (200) @(posedge clk);
    ok = port_seq_ok(2, n0) && port_seq_ok(3, n0);
    for (k0 = n0; k0 < wlog_n; k0 = k0 + 1)
      if (wlog_cyc[k0] < dp_rise_cyc[wlog_addr[k0][13:12]])
        ok = 1'b0;
    check("test_port_late_rx_done (2,3 up)", ok && link_ready === 4'b1111 &&
      port_writes(2, -1, n0) == N_CFG && port_writes(3, -1, n0) == N_CFG &&
      dp_rise_cyc[2] > t0 && dp_rise_cyc[3] > t0);
    check("test_port_late_rx_done (0,1 untouched)", port_writes(0, -1, n0) == 0 &&
      port_writes(1, -1, n0) == 0 && lr_falls[0] == f0[0] && lr_falls[1] == f0[1] &&
      dp_rises[0] == d0[0] && dp_rises[1] == d0[1] && gt_rst_rises == g0 &&
      mac_rst_falls == m0);

    check("test_fec_off", nf_fec_data[0] == 32'h0 && nf_fec_data[1] == 32'h0 &&
      nf_fec_data[2] == 32'h0 && nf_fec_data[3] == 32'h0 && nf_writes >= 4 * N_CFG &&
      nf_all_up);

    all_done = 1'b1;
  end
`endif

endmodule

module axil_log_slave #(
  parameter PORTS = 1,
  parameter LATENCY = 1
) (
  input  wire        clk,
  input  wire        rstn,
  input  wire        mute,
  input  wire [PORTS-1:0] link,
  input  wire [PORTS-1:0] fec_aligned,
  input  wire [31:0] awaddr,
  input  wire        awvalid,
  output reg         awready = 1'b0,
  input  wire [31:0] wdata,
  input  wire        wvalid,
  output reg         wready = 1'b0,
  output wire [1:0]  bresp,
  output reg         bvalid = 1'b0,
  input  wire        bready,
  input  wire [31:0] araddr,
  input  wire        arvalid,
  output reg         arready = 1'b0,
  output reg  [31:0] rdata = 0,
  output wire [1:0]  rresp,
  output reg         rvalid = 1'b0,
  input  wire        rready
);

  assign bresp = 2'b00;
  assign rresp = 2'b00;

  integer b_cnt = -1;
  integer r_cnt = -1;
  reg [31:0] r_val = 0;

  always @(posedge clk) begin
    awready <= 1'b0;
    wready <= 1'b0;
    arready <= 1'b0;

    if (awvalid && wvalid && !awready && !bvalid && b_cnt < 0 && rstn) begin
      awready <= 1'b1;
      wready <= 1'b1;
      b_cnt <= LATENCY - 1;
    end else if (b_cnt > 0) begin
      b_cnt <= b_cnt - 1;
    end else if (b_cnt == 0) begin
      bvalid <= 1'b1;
      b_cnt <= -1;
    end else if (bvalid && bready) begin
      bvalid <= 1'b0;
    end

    if (arvalid && !arready && !rvalid && r_cnt < 0 && rstn) begin
      arready <= 1'b1;
      r_cnt <= LATENCY - 1;
      if (PORTS == 1)
        r_val <= (araddr == 32'h74c) ? {31'd0, link} :
                 (araddr == 32'h000) ? 32'h0000_0001 : 32'h0;
      else
        // per port: RT status bit 0 status, bit 1 block lock; FEC RT bit 0 aligned
        r_val <= (araddr[11:0] == 12'h74c) ? {30'd0, {2{link[araddr[13:12]]}}} :
                 (araddr[11:0] == 12'h788) ? {31'd0, fec_aligned[araddr[13:12]]} :
                 (araddr == 32'h000) ? 32'h0000_0001 : 32'h0;
    end else if (r_cnt > 0) begin
      r_cnt <= r_cnt - 1;
    end else if (r_cnt == 0 && !mute) begin
      rvalid <= 1'b1;
      rdata <= r_val;
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
      b_cnt <= -1;
      r_cnt <= -1;
    end
  end

endmodule
