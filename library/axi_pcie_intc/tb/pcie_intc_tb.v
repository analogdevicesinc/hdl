// ***************************************************************************
// The PG195 request contract, which is the whole reason this core exists:
// usr_irq_req[v] must survive usr_irq_ack, drop only once the host has acked
// every source it was handed, and then re-assert if the level is still there.
// A regression in any of those three is a lost or duplicated interrupt on
// hardware, so each is checked explicitly rather than inferred from a
// throughput test.
//
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIBSD
// ***************************************************************************

`timescale 1ns/100ps

module pcie_intc_tb;
  parameter VCD_FILE = {"pcie_intc_tb.vcd"};

  localparam NUM_A = 11;               // the instance config: one source/vector
  localparam NUM_B = 4;                // grouped, to cover SRC_PER_VEC > 1
  localparam SPV_B = 8;

  localparam VERSION = 32'h00010000;
  localparam MAGIC   = 32'h50494e54;

  // register map
  localparam R_VERSION   = 16'h000;
  localparam R_ID        = 16'h004;
  localparam R_SCRATCH   = 16'h008;
  localparam R_MAGIC     = 16'h00c;
  localparam R_CONFIG    = 16'h010;
  localparam R_CONTROL   = 16'h014;
  localparam R_DELIVERED = 16'h018;
  localparam R_VEC       = 16'h200;
  localparam R_VEC_SIZE  = 16'h020;
  localparam R_ENABLE    = 16'h000;
  localparam R_PENDING   = 16'h004;   // w1c at the address it reads back from
  localparam R_RAW       = 16'h00c;
  localparam R_STATUS    = 16'h010;

  reg clk = 1'b0;
  reg resetn = 1'b0;
  reg failed = 1'b0;
  integer checks = 0;

  always #5 clk = ~clk;

  initial begin
    $dumpfile(VCD_FILE);
    $dumpvars;
    #200000;
    $display("ERROR: timeout");
    failed = 1'b1;
    report;
    $finish;
  end

  // AXI-Lite master

  reg         awvalid = 1'b0;
  reg  [15:0] awaddr = 16'h0;
  wire        awready;
  reg         wvalid = 1'b0;
  reg  [31:0] wdata = 32'h0;
  reg  [ 3:0] wstrb = 4'h0;
  wire        wready;
  wire        bvalid;
  reg         bready = 1'b0;
  reg         arvalid = 1'b0;
  reg  [15:0] araddr = 16'h0;
  wire        arready;
  wire        rvalid;
  wire [31:0] rdata;
  reg         rready = 1'b0;

  // A second, independent bus for the grouped instance.
  reg         b_awvalid = 1'b0;
  reg  [15:0] b_awaddr = 16'h0;
  wire        b_awready;
  reg         b_wvalid = 1'b0;
  reg  [31:0] b_wdata = 32'h0;
  wire        b_wready;
  wire        b_bvalid;
  reg         b_bready = 1'b0;
  reg         b_arvalid = 1'b0;
  reg  [15:0] b_araddr = 16'h0;
  wire        b_arready;
  wire        b_rvalid;
  wire [31:0] b_rdata;
  reg         b_rready = 1'b0;

  reg  [NUM_A-1:0]       intr_a = 'h0;
  wire [NUM_A-1:0]       req_a;
  wire [NUM_A-1:0]       ack_a;

  reg  [NUM_B*SPV_B-1:0] intr_b = 'h0;
  wire [NUM_B-1:0]       req_b;
  wire [NUM_B-1:0]       ack_b;

  // Model the endpoint on instance A: exactly one usr_irq_ack pulse per req
  // assertion, a few cycles after the message is handed over. Nothing here
  // drops req -- that is the core's job and the point of the test.
  //
  // Instance B has usr_irq_ack tied off instead, so its tests double as proof
  // that the control path never waits on the endpoint: a masked MSI-X vector
  // or MSI-X not yet enabled must not wedge a vector.
  reg [NUM_A-1:0] req_a_d1 = 'h0, req_a_d2 = 'h0, req_a_d3 = 'h0;

  always @(posedge clk) begin
    req_a_d1 <= req_a; req_a_d2 <= req_a_d1; req_a_d3 <= req_a_d2;
  end

  assign ack_a = req_a_d2 & ~req_a_d3;
  assign ack_b = {NUM_B{1'b0}};

  task expect_eq(input [255:0] name, input [31:0] got, input [31:0] exp);
    begin
      checks = checks + 1;
      if (got !== exp) begin
        $display("ERROR: %0s = 0x%08h, expected 0x%08h (t=%0t)", name, got, exp,
                 $time);
        failed = 1'b1;
      end
    end
  endtask

  task report;
    begin
      $display("%0d checks", checks);
      if (failed == 1'b0) $display("SUCCESS"); else $display("FAILED");
    end
  endtask

  task wait_clk(input integer n);
    integer i;
    begin
      for (i = 0; i < n; i = i + 1) @(posedge clk);
    end
  endtask

  task axi_write(input [15:0] addr, input [31:0] data);
    begin
      @(posedge clk);
      awaddr  = addr;
      awvalid = 1'b1;
      wdata   = data;
      wstrb   = 4'hf;
      wvalid  = 1'b1;
      bready  = 1'b1;
      @(posedge clk);
      while (awvalid || wvalid) begin
        if (awready) awvalid = 1'b0;
        if (wready)  wvalid  = 1'b0;
        @(posedge clk);
      end
      while (!bvalid) @(posedge clk);
      @(posedge clk);
      bready = 1'b0;
    end
  endtask

  task axi_read(input [15:0] addr, output [31:0] data);
    begin
      @(posedge clk);
      araddr  = addr;
      arvalid = 1'b1;
      rready  = 1'b1;
      @(posedge clk);
      while (!arready) @(posedge clk);
      arvalid = 1'b0;
      while (!rvalid) @(posedge clk);
      data = rdata;
      @(posedge clk);
      rready = 1'b0;
    end
  endtask

  task b_write(input [15:0] addr, input [31:0] data);
    begin
      @(posedge clk);
      b_awaddr  = addr;
      b_awvalid = 1'b1;
      b_wdata   = data;
      b_wvalid  = 1'b1;
      b_bready  = 1'b1;
      @(posedge clk);
      while (b_awvalid || b_wvalid) begin
        if (b_awready) b_awvalid = 1'b0;
        if (b_wready)  b_wvalid  = 1'b0;
        @(posedge clk);
      end
      while (!b_bvalid) @(posedge clk);
      @(posedge clk);
      b_bready = 1'b0;
    end
  endtask

  task b_read(input [15:0] addr, output [31:0] data);
    begin
      @(posedge clk);
      b_araddr  = addr;
      b_arvalid = 1'b1;
      b_rready  = 1'b1;
      @(posedge clk);
      while (!b_arready) @(posedge clk);
      b_arvalid = 1'b0;
      while (!b_rvalid) @(posedge clk);
      data = b_rdata;
      @(posedge clk);
      b_rready = 1'b0;
    end
  endtask

  function [15:0] vreg(input integer v, input [15:0] r);
    begin
      vreg = R_VEC + v * R_VEC_SIZE + r;
    end
  endfunction

  // Wait for req[v], bounded so a wedge reports rather than hanging to the
  // global timeout with no context.
  task wait_req_a(input integer v, input expected, input [255:0] name);
    integer n;
    begin
      n = 0;
      while (req_a[v] !== expected && n < 200) begin
        @(posedge clk);
        n = n + 1;
      end
      checks = checks + 1;
      if (req_a[v] !== expected) begin
        $display("ERROR: %0s: req_a[%0d] stuck at %b after %0d clks (t=%0t)",
                 name, v, req_a[v], n, $time);
        failed = 1'b1;
      end
    end
  endtask

  reg [31:0] d;

  initial begin
    wait_clk(10);
    resetn = 1'b1;
    wait_clk(10);

    // ---- identification and geometry ----
    axi_read(R_VERSION, d); expect_eq("VERSION", d, VERSION);
    axi_read(R_MAGIC,   d); expect_eq("MAGIC",   d, MAGIC);
    axi_read(R_CONFIG,  d); expect_eq("CONFIG",  d, (1 << 8) | NUM_A);
    axi_write(R_SCRATCH, 32'hdeadbeef);
    axi_read(R_SCRATCH, d); expect_eq("SCRATCH", d, 32'hdeadbeef);

    // ---- a masked source raises nothing ----
    intr_a[3] = 1'b1;
    wait_clk(20);
    expect_eq("masked req", {31'h0, req_a[3]}, 32'h0);
    axi_read(vreg(3, R_RAW), d);
    expect_eq("RAW sees masked source", d, 32'h1);

    // ---- enabling an asserted source raises it ----
    axi_write(vreg(3, R_ENABLE), 32'h1);
    wait_req_a(3, 1'b1, "enable raises req");

    // ---- req survives usr_irq_ack: the PG195 property ----
    wait_clk(20);                       // the ack pulse has long since passed
    expect_eq("req held after ack", {31'h0, req_a[3]}, 32'h1);
    axi_read(R_DELIVERED, d);
    expect_eq("DELIVERED after ack", d, 32'h8);
    axi_read(vreg(3, R_PENDING), d);
    expect_eq("PENDING", d, 32'h1);

    // ---- neighbours are untouched ----
    expect_eq("neighbours idle", {21'h0, req_a} & ~32'h8, 32'h0);

    // ---- host ack drops req, and the still-asserted level re-raises it ----
    axi_write(vreg(3, R_PENDING), 32'h1);
    wait_req_a(3, 1'b0, "host ack drops req");
    wait_req_a(3, 1'b1, "level re-raises req");

    // ---- source cleared before the ack: req drops and stays down ----
    intr_a[3] = 1'b0;
    wait_clk(20);
    axi_write(vreg(3, R_PENDING), 32'h1);
    wait_req_a(3, 1'b0, "cleared source drops req");
    wait_clk(50);
    expect_eq("stays down", {31'h0, req_a[3]}, 32'h0);
    axi_read(vreg(3, R_STATUS), d);
    expect_eq("STATUS idle", d & 32'h3, 32'h0);    // req==0, not rearming

    // ---- the top vector works too, i.e. the decode is not aliased ----
    intr_a[NUM_A-1] = 1'b1;
    axi_write(vreg(NUM_A-1, R_ENABLE), 32'h1);
    wait_req_a(NUM_A-1, 1'b1, "top vector raises");
    axi_read(vreg(NUM_A-1, R_PENDING), d);
    expect_eq("top vector PENDING", d, 32'h1);
    expect_eq("vector 3 unaffected", {31'h0, req_a[3]}, 32'h0);
    intr_a[NUM_A-1] = 1'b0;
    axi_write(vreg(NUM_A-1, R_PENDING), 32'h1);
    wait_req_a(NUM_A-1, 1'b0, "top vector drops");

    grouped_tests;

    report;
    $finish;
  end

  // SRC_PER_VEC > 1: partial acks must stall rather than lose sources, and
  // PENDING must stay a snapshot so it can always reach zero.
  task grouped_tests;
    integer n;
    begin
      b_write(vreg(0, R_ENABLE), 32'hff);

      // two sources at once -> one message, both in PENDING
      intr_b[0] = 1'b1;
      intr_b[1] = 1'b1;
      n = 0;
      while (req_b[0] !== 1'b1 && n < 200) begin @(posedge clk); n = n + 1; end
      expect_eq("grouped req", {31'h0, req_b[0]}, 32'h1);
      wait_clk(20);
      b_read(vreg(0, R_PENDING), d);
      expect_eq("grouped PENDING", d, 32'h3);

      // a third source arriving mid-flight must NOT join the snapshot -- if it
      // did, PENDING could never reach zero under load and req would wedge
      intr_b[2] = 1'b1;
      wait_clk(20);
      b_read(vreg(0, R_PENDING), d);
      expect_eq("PENDING is a snapshot", d, 32'h3);
      b_read(vreg(0, R_RAW), d);
      expect_eq("RAW is live", d, 32'h7);

      // a partial ack stalls the vector, by design. Each ack follows the
      // handler clearing its peripheral's condition, as a driver would.
      intr_b[0] = 1'b0;
      b_write(vreg(0, R_PENDING), 32'h1);
      wait_clk(20);
      expect_eq("partial ack stalls", {31'h0, req_b[0]}, 32'h1);
      b_read(vreg(0, R_PENDING), d);
      expect_eq("PENDING after partial ack", d, 32'h2);

      // completing the ack drops req, and the late source raises a new message
      intr_b[1] = 1'b0;
      b_write(vreg(0, R_PENDING), 32'h2);
      n = 0;
      while (req_b[0] !== 1'b0 && n < 200) begin @(posedge clk); n = n + 1; end
      expect_eq("full ack drops req", {31'h0, req_b[0]}, 32'h0);
      n = 0;
      while (req_b[0] !== 1'b1 && n < 200) begin @(posedge clk); n = n + 1; end
      expect_eq("late source re-raises", {31'h0, req_b[0]}, 32'h1);
      wait_clk(20);
      b_read(vreg(0, R_PENDING), d);
      expect_eq("late source in new snapshot", d, 32'h4);

      // other vectors of the same instance were never disturbed
      expect_eq("grouped neighbours idle", {28'h0, req_b} & ~32'h1, 32'h0);

      // ...and every one of the above ran with usr_irq_ack tied off, so the
      // endpoint handshake is genuinely out of the control path
      b_read(R_DELIVERED, d);
      expect_eq("DELIVERED without ack", d, 32'h0);
    end
  endtask

  axi_pcie_intc #(
    .NUM_VECTORS(NUM_A),
    .SRC_PER_VEC(1),
    .ASYNC_INTR(0)
  ) i_a (
    .s_axi_aclk(clk),
    .s_axi_aresetn(resetn),
    .s_axi_awvalid(awvalid),
    .s_axi_awaddr(awaddr),
    .s_axi_awprot(3'h0),
    .s_axi_awready(awready),
    .s_axi_wvalid(wvalid),
    .s_axi_wdata(wdata),
    .s_axi_wstrb(wstrb),
    .s_axi_wready(wready),
    .s_axi_bvalid(bvalid),
    .s_axi_bresp(),
    .s_axi_bready(bready),
    .s_axi_arvalid(arvalid),
    .s_axi_araddr(araddr),
    .s_axi_arprot(3'h0),
    .s_axi_arready(arready),
    .s_axi_rvalid(rvalid),
    .s_axi_rresp(),
    .s_axi_rdata(rdata),
    .s_axi_rready(rready),
    // NUM_A = 11 vectors of one source each. The five ports above NUM_VECTORS
    // are tied rather than left off the map, to keep the "unread port" claim
    // visible here.
    .intr_0(intr_a[0]),
    .intr_1(intr_a[1]),
    .intr_2(intr_a[2]),
    .intr_3(intr_a[3]),
    .intr_4(intr_a[4]),
    .intr_5(intr_a[5]),
    .intr_6(intr_a[6]),
    .intr_7(intr_a[7]),
    .intr_8(intr_a[8]),
    .intr_9(intr_a[9]),
    .intr_10(intr_a[10]),
    .intr_11(1'b0),
    .intr_12(1'b0),
    .intr_13(1'b0),
    .intr_14(1'b0),
    .intr_15(1'b0),
    .usr_irq_req(req_a),
    .usr_irq_ack(ack_a));

  axi_pcie_intc #(
    .NUM_VECTORS(NUM_B),
    .SRC_PER_VEC(SPV_B),
    .ASYNC_INTR(0)
  ) i_b (
    .s_axi_aclk(clk),
    .s_axi_aresetn(resetn),
    .s_axi_awvalid(b_awvalid),
    .s_axi_awaddr(b_awaddr),
    .s_axi_awprot(3'h0),
    .s_axi_awready(b_awready),
    .s_axi_wvalid(b_wvalid),
    .s_axi_wdata(b_wdata),
    .s_axi_wstrb(4'hf),
    .s_axi_wready(b_wready),
    .s_axi_bvalid(b_bvalid),
    .s_axi_bresp(),
    .s_axi_bready(b_bready),
    .s_axi_arvalid(b_arvalid),
    .s_axi_araddr(b_araddr),
    .s_axi_arprot(3'h0),
    .s_axi_arready(b_arready),
    .s_axi_rvalid(b_rvalid),
    .s_axi_rresp(),
    .s_axi_rdata(b_rdata),
    .s_axi_rready(b_rready),
    // NUM_B = 4 vectors of SPV_B = 8 sources: intr_b keeps its flat layout, so
    // source k still lands on port k/SPV_B bit k%SPV_B.
    .intr_0(intr_b[ 0*SPV_B +: SPV_B]),
    .intr_1(intr_b[ 1*SPV_B +: SPV_B]),
    .intr_2(intr_b[ 2*SPV_B +: SPV_B]),
    .intr_3(intr_b[ 3*SPV_B +: SPV_B]),
    .intr_4({SPV_B{1'b0}}),
    .intr_5({SPV_B{1'b0}}),
    .intr_6({SPV_B{1'b0}}),
    .intr_7({SPV_B{1'b0}}),
    .intr_8({SPV_B{1'b0}}),
    .intr_9({SPV_B{1'b0}}),
    .intr_10({SPV_B{1'b0}}),
    .intr_11({SPV_B{1'b0}}),
    .intr_12({SPV_B{1'b0}}),
    .intr_13({SPV_B{1'b0}}),
    .intr_14({SPV_B{1'b0}}),
    .intr_15({SPV_B{1'b0}}),
    .usr_irq_req(req_b),
    .usr_irq_ack(ack_b));

endmodule
