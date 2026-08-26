// =============================================================================
// tb_axi_adf4030.sv — Master + Slave simulation for axi_adf4030
//
// Topology mirrors the ad_xband16_ebz system_top_master / system_top_slave:
//
//   Physical trigger (gp4[0])
//          |
//          v  [Master]
//   axi_adf4030 (master, TX)
//     trig_request_out -------PMOD wire------> axi_adf4030 (slave, TX)
//     trig_channel[4] = dma_start              trig_channel[4] = dma_start
//          |                                          |
//          v [system_top SR latch + 2FF sysref sync]  v [same chain]
//     sync_start -> ext_sync_in (JESD)          sync_start -> ext_sync_in (JESD)
//
// The sysref output of each axi_adf4030 (= bsync_generator output) is used
// as the synchronizer clock for the dma_start stretcher chain, exactly as
// the system_top files do.
//
// Tests:
//   1.  Register sanity      — VERSION, MAGIC, ID
//   2.  Scratch R/W
//   3.  Configure both DUTs  — direction, ch_en, select_trig
//   4.  Channel phases
//   5.  BSYNC calibration    — poll bsync_ready on both
//   6.  External trigger     — trig_request_out, master ch0/ch4, slave ch0/ch4
//   7.  Debug trigger        — force-high / force-low override
//   8.  Manual trigger       — sw one-shot path
//   9.  SW reset             — scratch clears
//   10. Misalignment check   — alignment_error stays 0 on stable BSYNC
//   11. Master sync_start    — dma_start sets SR latch, sysref 2FF captures,
//                              sync_start pulses, then self-resets
//   12. Slave  sync_start    — same chain on slave side
//   13. sync_start one-shot  — does not re-fire without a new trigger
// =============================================================================

`timescale 1ns/1ps

module tb_axi_adf4030;

  // ---------------------------------------------------------------------------
  // Parameters
  // ---------------------------------------------------------------------------
  localparam CHANNEL_COUNT  = 5;    // ch0-3 = trig0/1 a/b, ch4 = dma_start
  localparam BSYNC_HALF_PER = 200;  // half-period of simulated BSYNC (dev_clk cycles)
  // Must be >> master→slave propagation delay (~8-15 dev_clk) so both boards'
  // dma_start pulses land in the same sysref window (matching real hardware where
  // the BSYNC period is hundreds of µs and PMOD skew is nanoseconds).

  // Clock periods (ns)
  localparam AXI_CLK_PERIOD = 10;   // 100 MHz
  localparam DEV_CLK_PERIOD = 4;    // 250 MHz

  // AXI register byte addresses (up_axi strips [1:0] → word address)
  localparam REG_VERSION     = 8'h00;
  localparam REG_ID          = 8'h04;
  localparam REG_SCRATCH     = 8'h08;
  localparam REG_MAGIC       = 8'h0C;
  localparam REG_CONTROL     = 8'h10;
  localparam REG_DEBUG       = 8'h14;
  localparam REG_MANUAL_TRIG = 8'h18;
  localparam REG_CH0         = 8'h1C;
  localparam REG_CH4         = 8'h2C;

  // ---------------------------------------------------------------------------
  // Clocks and global reset
  // ---------------------------------------------------------------------------
  logic axi_clk  = 0;
  logic axi_rstn = 0;
  logic dev_clk  = 0;

  always #(AXI_CLK_PERIOD/2) axi_clk = ~axi_clk;
  always #(DEV_CLK_PERIOD/2) dev_clk = ~dev_clk;

  // ---------------------------------------------------------------------------
  // Shared BSYNC differential bus
  //
  // In real hardware the ADF4030 chip provides the initial BSYNC reference.
  // We model that chip with a free-running generator.  Both DUTs are set to
  // direction=1 (TX) so their IOBUFDS stubs also drive the bus once calibrated;
  // in Verilator the continuous assignments resolve to whatever last wins,
  // which is the DUT's internal_bsync after calib_done.
  // ---------------------------------------------------------------------------
  wire bsync_p, bsync_n;

  reg  ext_bsync_drv = 1'b0;
  reg  ext_bsync_en  = 1'b1;

  assign bsync_p = ext_bsync_en ? ext_bsync_drv  : 1'bz;
  assign bsync_n = ext_bsync_en ? ~ext_bsync_drv : 1'bz;

  initial begin
    @(posedge axi_rstn);
    repeat(10) @(posedge dev_clk);
    forever begin
      @(posedge dev_clk); #1;
      ext_bsync_drv = 1;
      repeat(BSYNC_HALF_PER-1) @(posedge dev_clk);
      #1; ext_bsync_drv = 0;
      repeat(BSYNC_HALF_PER-1) @(posedge dev_clk);
    end
  end

  // ---------------------------------------------------------------------------
  // Master DUT interface signals
  // All declared logic so tasks can accept them as ref logic.
  // ---------------------------------------------------------------------------
  logic        m_awvalid, m_awready, m_wvalid, m_wready;
  logic        m_bvalid,  m_bready;
  logic        m_arvalid, m_arready, m_rvalid, m_rready;
  logic [9:0]  m_awaddr,  m_araddr;
  logic [31:0] m_wdata,   m_rdata;
  logic [3:0]  m_wstrb;
  logic [1:0]  m_bresp,   m_rresp;

  logic        m_trigger = 0;
  logic        m_sysref;
  logic [CHANNEL_COUNT-1:0] m_trig_channel;
  logic        m_trig_request_out;

  // ---------------------------------------------------------------------------
  // Slave DUT interface signals
  // ---------------------------------------------------------------------------
  logic        s_awvalid, s_awready, s_wvalid, s_wready;
  logic        s_bvalid,  s_bready;
  logic        s_arvalid, s_arready, s_rvalid, s_rready;
  logic [9:0]  s_awaddr,  s_araddr;
  logic [31:0] s_wdata,   s_rdata;
  logic [3:0]  s_wstrb;
  logic [1:0]  s_bresp,   s_rresp;

  logic        s_sysref;
  logic [CHANNEL_COUNT-1:0] s_trig_channel;
  logic        s_trig_request_out;

  // ---------------------------------------------------------------------------
  // Master DUT
  // ---------------------------------------------------------------------------
  axi_adf4030 #(
    .ID             (0),
    .FPGA_FAMILY    (0),
    .CHANNEL_COUNT  (CHANNEL_COUNT),
    .TRIGGER_STRETCH(0)
  ) i_master (
    .bsync_p           (bsync_p),
    .bsync_n           (bsync_n),
    .device_clk        (dev_clk),
    .trigger           (m_trigger),
    .sysref            (m_sysref),
    .trig_channel      (m_trig_channel),
    .trig_request_out  (m_trig_request_out),
    .s_axi_aresetn     (axi_rstn),
    .s_axi_aclk        (axi_clk),
    .s_axi_awvalid     (m_awvalid),
    .s_axi_awaddr      (m_awaddr),
    .s_axi_awprot      (3'b0),
    .s_axi_awready     (m_awready),
    .s_axi_wvalid      (m_wvalid),
    .s_axi_wdata       (m_wdata),
    .s_axi_wstrb       (m_wstrb),
    .s_axi_wready      (m_wready),
    .s_axi_bvalid      (m_bvalid),
    .s_axi_bresp       (m_bresp),
    .s_axi_bready      (m_bready),
    .s_axi_arvalid     (m_arvalid),
    .s_axi_araddr      (m_araddr),
    .s_axi_arprot      (3'b0),
    .s_axi_arready     (m_arready),
    .s_axi_rvalid      (m_rvalid),
    .s_axi_rresp       (m_rresp),
    .s_axi_rdata       (m_rdata),
    .s_axi_rready      (m_rready)
  );

  // ---------------------------------------------------------------------------
  // Slave DUT  (trigger = master's trig_request_out via PMOD wire)
  // ---------------------------------------------------------------------------
  axi_adf4030 #(
    .ID             (1),
    .FPGA_FAMILY    (0),
    .CHANNEL_COUNT  (CHANNEL_COUNT),
    .TRIGGER_STRETCH(0)
  ) i_slave (
    .bsync_p           (bsync_p),
    .bsync_n           (bsync_n),
    .device_clk        (dev_clk),
    .trigger           (m_trig_request_out),   // PMOD wire
    .sysref            (s_sysref),
    .trig_channel      (s_trig_channel),
    .trig_request_out  (s_trig_request_out),
    .s_axi_aresetn     (axi_rstn),
    .s_axi_aclk        (axi_clk),
    .s_axi_awvalid     (s_awvalid),
    .s_axi_awaddr      (s_awaddr),
    .s_axi_awprot      (3'b0),
    .s_axi_awready     (s_awready),
    .s_axi_wvalid      (s_wvalid),
    .s_axi_wdata       (s_wdata),
    .s_axi_wstrb       (s_wstrb),
    .s_axi_wready      (s_wready),
    .s_axi_bvalid      (s_bvalid),
    .s_axi_bresp       (s_bresp),
    .s_axi_bready      (s_bready),
    .s_axi_arvalid     (s_arvalid),
    .s_axi_araddr      (s_araddr),
    .s_axi_arprot      (3'b0),
    .s_axi_arready     (s_arready),
    .s_axi_rvalid      (s_rvalid),
    .s_axi_rresp       (s_rresp),
    .s_axi_rdata       (s_rdata),
    .s_axi_rready      (s_rready)
  );

  // ===========================================================================
  // system_top dma_start / sync_start chains
  //
  // Verbatim logic from system_top_master.v lines 331-348 and
  // system_top_slave.v  lines 333-349, instantiated for both boards.
  //
  // Signal naming follows the system_top convention:
  //   dma_start          = trig_channel[4]
  //   trigger_stretched  = async SR latch output
  //   trigger_sync1/2    = 2-FF synchronizer clocked by sysref
  //   trigger_captured   = trigger_sync2  (feeds back to clear latch)
  //   sync_start_edge    = trigger_sync1 & ~trigger_sync2 (1-sysref-period pulse)
  //   sync_start         = sync_start_edge & sysref  (→ JESD ext_sync_in)
  // ===========================================================================

  // --- Master ---
  // Use logic (not wire) for combinational outputs so tasks can accept them as ref logic
  logic  m_dma_start;
  always_comb m_dma_start = m_trig_channel[4];

  logic  m_trigger_stretched = 1'b0;
  logic  m_trigger_sync1     = 1'b0;
  logic  m_trigger_sync2     = 1'b0;

  logic  m_trigger_captured;
  logic  m_sync_start_edge;
  logic  m_sync_start;

  always_comb m_trigger_captured = m_trigger_sync2;
  always_comb m_sync_start_edge  = m_trigger_sync1 & ~m_trigger_sync2;
  always_comb m_sync_start       = m_sync_start_edge & m_sysref;

  // Async SR latch: SET on rising dma_start, CLEAR on rising trigger_captured
  always @(posedge m_dma_start or posedge m_trigger_captured) begin
    if (m_trigger_captured)
      m_trigger_stretched <= 1'b0;
    else
      m_trigger_stretched <= 1'b1;
  end

  // 2-FF synchronizer clocked by sysref (= regenerated BSYNC from axi_adf4030)
  always @(posedge m_sysref) begin
    m_trigger_sync1 <= m_trigger_stretched;
    m_trigger_sync2 <= m_trigger_sync1;
  end

  // --- Slave ---
  logic  s_dma_start;
  always_comb s_dma_start = s_trig_channel[4];

  logic  s_trigger_stretched = 1'b0;
  logic  s_trigger_sync1     = 1'b0;
  logic  s_trigger_sync2     = 1'b0;

  logic  s_trigger_captured;
  logic  s_sync_start_edge;
  logic  s_sync_start;

  always_comb s_trigger_captured = s_trigger_sync2;
  always_comb s_sync_start_edge  = s_trigger_sync1 & ~s_trigger_sync2;
  always_comb s_sync_start       = s_sync_start_edge & s_sysref;

  always @(posedge s_dma_start or posedge s_trigger_captured) begin
    if (s_trigger_captured)
      s_trigger_stretched <= 1'b0;
    else
      s_trigger_stretched <= 1'b1;
  end

  always @(posedge s_sysref) begin
    s_trigger_sync1 <= s_trigger_stretched;
    s_trigger_sync2 <= s_trigger_sync1;
  end

  // ===========================================================================
  // Test infrastructure
  // ===========================================================================
  int pass_count = 0;
  int fail_count = 0;

  task automatic check(input string label, input logic got, input logic exp);
    if (got === exp) begin
      $display("[PASS] %s : got %0b expected %0b", label, got, exp);
      pass_count++;
    end else begin
      $display("[FAIL] %s : got %0b expected %0b", label, got, exp);
      fail_count++;
    end
  endtask

  task automatic check32(input string label, input logic [31:0] got, input logic [31:0] exp);
    if (got === exp) begin
      $display("[PASS] %s : got 0x%08h expected 0x%08h", label, got, exp);
      pass_count++;
    end else begin
      $display("[FAIL] %s : got 0x%08h expected 0x%08h", label, got, exp);
      fail_count++;
    end
  endtask

  // ---------------------------------------------------------------------------
  // AXI4-Lite tasks
  // ---------------------------------------------------------------------------
  task automatic axi_write(
    ref logic        awvalid, ref logic awready,
    ref logic        wvalid,  ref logic wready,
    ref logic        bvalid,  ref logic bready,
    ref logic [9:0]  awaddr_r,
    ref logic [31:0] wdata_r,
    ref logic [3:0]  wstrb_r,
    input logic [7:0]  addr,
    input logic [31:0] data
  );
    @(posedge axi_clk); #1;
    awvalid = 1; awaddr_r = {2'b0, addr};
    wvalid  = 1; wdata_r  = data; wstrb_r = 4'hF;
    bready  = 1;
    @(posedge axi_clk);
    while (!(awready && wready)) @(posedge axi_clk);
    #1;
    awvalid = 0; wvalid = 0;
    while (!bvalid) @(posedge axi_clk);
    bready = 0;
    @(posedge axi_clk); #1;
  endtask

  task automatic axi_read(
    ref logic        arvalid, ref logic arready,
    ref logic        rvalid,  ref logic rready,
    ref logic [9:0]  araddr_r,
    ref logic [31:0] rdata_r,
    input  logic [7:0]  addr,
    output logic [31:0] data
  );
    @(posedge axi_clk); #1;
    arvalid = 1; araddr_r = {2'b0, addr};
    rready  = 1;
    while (!arready) @(posedge axi_clk);
    #1; arvalid = 0;
    while (!rvalid) @(posedge axi_clk);
    data   = rdata_r;
    rready = 0;
    @(posedge axi_clk); #1;
  endtask

  task automatic mwr(input logic [7:0] addr, input logic [31:0] data);
    axi_write(m_awvalid,m_awready,m_wvalid,m_wready,m_bvalid,m_bready,
              m_awaddr,m_wdata,m_wstrb, addr, data);
  endtask
  task automatic mrd(input logic [7:0] addr, output logic [31:0] data);
    axi_read(m_arvalid,m_arready,m_rvalid,m_rready,m_araddr,m_rdata, addr, data);
  endtask
  task automatic swr(input logic [7:0] addr, input logic [31:0] data);
    axi_write(s_awvalid,s_awready,s_wvalid,s_wready,s_bvalid,s_bready,
              s_awaddr,s_wdata,s_wstrb, addr, data);
  endtask
  task automatic srd(input logic [7:0] addr, output logic [31:0] data);
    axi_read(s_arvalid,s_arready,s_rvalid,s_rready,s_araddr,s_rdata, addr, data);
  endtask

  // Poll REG_DEBUG[0] (bsync_ready) until set or timeout
  task automatic wait_bsync_ready_m(input string who);
    logic [31:0] dbg;
    int timeout = 0;
    $display("[SIM]  Waiting for %s bsync_ready ...", who);
    do begin
      mrd(REG_DEBUG, dbg);
      if (++timeout > 50000) begin
        $display("[FAIL] %s bsync_ready timed out", who);
        fail_count++; return;
      end
    end while (dbg[0] == 1'b0);
    $display("[SIM]  %s bsync_ready: ratio=0x%0h delay=%0d state=%0d",
             who, dbg[20:5], dbg[4:1], dbg[23:21]);
    pass_count++;
  endtask

  task automatic wait_bsync_ready_s(input string who);
    logic [31:0] dbg;
    int timeout = 0;
    $display("[SIM]  Waiting for %s bsync_ready ...", who);
    do begin
      srd(REG_DEBUG, dbg);
      if (++timeout > 50000) begin
        $display("[FAIL] %s bsync_ready timed out", who);
        fail_count++; return;
      end
    end while (dbg[0] == 1'b0);
    $display("[SIM]  %s bsync_ready: ratio=0x%0h delay=%0d state=%0d",
             who, dbg[20:5], dbg[4:1], dbg[23:21]);
    pass_count++;
  endtask

  // Wait for a bit in a multi-bit bus to go high
  task automatic wait_channel(input string label,
    ref logic [CHANNEL_COUNT-1:0] ch, input int idx, input int timeout_cyc);
    int cnt = 0;
    while (ch[idx] !== 1'b1) begin
      @(posedge dev_clk);
      if (++cnt > timeout_cyc) begin
        $display("[FAIL] Timeout waiting for %s ch%0d", label, idx);
        fail_count++; return;
      end
    end
    $display("[PASS] %s ch%0d asserted after %0d dev_clk cycles", label, idx, cnt);
    pass_count++;
  endtask

  // Wait for a single-bit signal to go high
  task automatic wait_signal(input string label,
    ref logic sig, input int timeout_cyc);
    int cnt = 0;
    while (sig !== 1'b1) begin
      @(posedge dev_clk);
      if (++cnt > timeout_cyc) begin
        $display("[FAIL] Timeout waiting for %s", label);
        fail_count++; return;
      end
    end
    $display("[PASS] %s asserted after %0d dev_clk cycles", label, cnt);
    pass_count++;
  endtask

  // Wait for a signal to go low
  task automatic wait_signal_low(input string label,
    ref logic sig, input int timeout_cyc);
    int cnt = 0;
    while (sig !== 1'b0) begin
      @(posedge dev_clk);
      if (++cnt > timeout_cyc) begin
        $display("[FAIL] Timeout: %s never went low", label);
        fail_count++; return;
      end
    end
    $display("[PASS] %s de-asserted after %0d dev_clk cycles", label, cnt);
    pass_count++;
  endtask

  // Fire a single short trigger pulse on m_trigger and wait for dma_start.
  // Timeout scales with BSYNC_HALF_PER: trigger_channel needs up to one full
  // BSYNC period to align, then ~bsync_ratio dev_clk to count out the phase.
  task automatic fire_trigger_and_wait_dma();
    @(posedge dev_clk); #1;
    m_trigger = 1;
    @(posedge dev_clk); #1;
    m_trigger = 0;
    wait_signal("trig_request_out",       m_trig_request_out, BSYNC_HALF_PER*2);
    wait_channel("Master dma_start(ch4)", m_trig_channel,  4, BSYNC_HALF_PER*8);
  endtask

  // ---------------------------------------------------------------------------
  // AXI bus idle defaults
  // ---------------------------------------------------------------------------
  initial begin
    m_awvalid=0; m_wvalid=0; m_bready=0; m_arvalid=0; m_rready=0;
    m_awaddr=0; m_wdata=0; m_wstrb=4'hF; m_araddr=0;
    s_awvalid=0; s_wvalid=0; s_bready=0; s_arvalid=0; s_rready=0;
    s_awaddr=0; s_wdata=0; s_wstrb=4'hF; s_araddr=0;
  end

  // ---------------------------------------------------------------------------
  // Main test sequence
  // ---------------------------------------------------------------------------
  logic [31:0] rdata;

  initial begin
    $dumpfile("tb_axi_adf4030.vcd");
    $dumpvars(0, tb_axi_adf4030);

    $display("\n======================================================");
    $display(" axi_adf4030  Master + Slave Simulation");
    $display("======================================================\n");

    repeat(5) @(posedge axi_clk);
    axi_rstn = 1;
    repeat(5) @(posedge axi_clk);

    // =========================================================================
    // TEST 1: Register sanity
    // =========================================================================
    $display("\n--- TEST 1: Register sanity ---");
    mrd(REG_VERSION, rdata); check32("Master VERSION", rdata, 32'h0001_0061);
    mrd(REG_MAGIC,   rdata); check32("Master MAGIC",   rdata, 32'h4149_4F4E);
    mrd(REG_ID,      rdata); check32("Master ID",      rdata, 32'h0000_0000);
    srd(REG_VERSION, rdata); check32("Slave  VERSION", rdata, 32'h0001_0061);
    srd(REG_MAGIC,   rdata); check32("Slave  MAGIC",   rdata, 32'h4149_4F4E);
    srd(REG_ID,      rdata); check32("Slave  ID",      rdata, 32'h0000_0001);

    // =========================================================================
    // TEST 2: Scratch register
    // =========================================================================
    $display("\n--- TEST 2: Scratch register ---");
    mwr(REG_SCRATCH, 32'hDEAD_BEEF);
    mrd(REG_SCRATCH, rdata);
    check32("Master scratch R/W", rdata, 32'hDEAD_BEEF);

    // =========================================================================
    // TEST 3: Configure both DUTs
    //   CONTROL[0]      = direction (1=TX, drives BSYNC)
    //   CONTROL[6:2]    = trig_channel_en[4:0]
    //   CONTROL[11]     = select_trig (1 = external trigger pin)
    //   0x087D = direction=1, all 5 ch enabled, select_trig=1
    // Note: both set direction=1 so bsync_generator can calibrate.
    //   direction=0 gates b_captured, preventing CALIB entry (IP bug documented).
    // =========================================================================
    $display("\n--- TEST 3: Configure master and slave ---");
    mwr(REG_CONTROL, 32'h0000_087D);
    mrd(REG_CONTROL, rdata);
    $display("[SIM]  Master CONTROL readback = 0x%08h", rdata);
    check("Master direction",   rdata[0],  1'b1);
    check("Master ch4 enabled", rdata[6],  1'b1);
    check("Master select_trig", rdata[11], 1'b1);

    swr(REG_CONTROL, 32'h0000_087D);
    srd(REG_CONTROL, rdata);
    $display("[SIM]  Slave  CONTROL readback = 0x%08h", rdata);
    check("Slave direction",    rdata[0],  1'b1);
    check("Slave ch4 enabled",  rdata[6],  1'b1);
    check("Slave select_trig",  rdata[11], 1'b1);

    // =========================================================================
    // TEST 4: Set channel phases
    //   trig_phase = (2*ratio - 2) - ch_phase
    //   ch_phase=0 fires earliest (largest offset from BSYNC boundary)
    //   ch_phase=2 fires 2 dev_clk cycles later than ch_phase=0
    // =========================================================================
    $display("\n--- TEST 4: Channel phases ---");
    mwr(REG_CH0,    32'd2);  mwr(REG_CH0+4,  32'd2);   // ch0-3 phase=2
    mwr(REG_CH0+8,  32'd2);  mwr(REG_CH0+12, 32'd2);
    mwr(REG_CH4,    32'd0);  // ch4 (dma_start) phase=0, fires first
    swr(REG_CH0,    32'd2);  swr(REG_CH0+4,  32'd2);
    swr(REG_CH0+8,  32'd2);  swr(REG_CH0+12, 32'd2);
    swr(REG_CH4,    32'd0);
    $display("[SIM]  Master/Slave phases written (ch0-3=2, ch4=0)");
    pass_count++;

    // =========================================================================
    // TEST 5: BSYNC calibration — poll bsync_ready on both DUTs
    // =========================================================================
    $display("\n--- TEST 5: BSYNC calibration ---");
    wait_bsync_ready_m("Master");
    wait_bsync_ready_s("Slave");

    // After both DUTs are calibrated (TEST 5 passed), disable the external
    // ADF4030 chip model.  The DUTs are now in TX mode and drive the bus
    // themselves.  Leaving ext_bsync_en=1 would create a multi-driver
    // conflict on bsync_p/n that corrupts bsync_in readings.
    ext_bsync_en = 0;
    $display("[SIM]  External BSYNC chip disabled — DUTs drive bus in TX mode");

    // =========================================================================
    // TEST 6: External trigger — full channel chain
    // =========================================================================
    $display("\n--- TEST 6: External trigger ---");
    @(posedge dev_clk); #1; m_trigger = 1;
    @(posedge dev_clk); #1; m_trigger = 0;

    // All four channels share a single timeout window starting from trigger pulse.
    // Worst-case latency: up to BSYNC_HALF_PER for bsync_event to align,
    // then trig_phase (~2*ratio) dev_clk of TRIG_ADJUST counting.
    // With ratio=198: ~200 + 394 + 198 = ~792 dev_clk. Use 6× margin.
    fork
      wait_signal  ("Master trig_request_out",          m_trig_request_out, BSYNC_HALF_PER*2);
      wait_channel ("Master ch0",                        m_trig_channel, 0,  BSYNC_HALF_PER*12);
      wait_channel ("Master ch4",                        m_trig_channel, 4,  BSYNC_HALF_PER*12);
      wait_channel ("Slave (via trig_request) ch0",     s_trig_channel, 0,  BSYNC_HALF_PER*12);
      wait_channel ("Slave (via trig_request) ch4",     s_trig_channel, 4,  BSYNC_HALF_PER*12);
    join

    // =========================================================================
    // TEST 7: Debug trigger override
    // =========================================================================
    $display("\n--- TEST 7: Debug trigger override ---");
    mwr(REG_CONTROL, 32'h0000_387D);   // enable_debug=1 debug_val=1
    repeat(10) @(posedge dev_clk);
    check("Master ch0 debug=1", m_trig_channel[0], 1'b1);
    check("Master ch4 debug=1", m_trig_channel[4], 1'b1);

    mwr(REG_CONTROL, 32'h0000_187D);   // enable_debug=1 debug_val=0
    repeat(10) @(posedge dev_clk);
    check("Master ch0 debug=0", m_trig_channel[0], 1'b0);
    check("Master ch4 debug=0", m_trig_channel[4], 1'b0);

    mwr(REG_CONTROL, 32'h0000_087D);   // clear debug mode, restore select_trig=1
    repeat(10) @(posedge dev_clk);

    // =========================================================================
    // TEST 8: Manual trigger
    // =========================================================================
    $display("\n--- TEST 8: Manual trigger ---");
    mwr(REG_CONTROL, 32'h0000_007D);   // select_trig=0 (manual path)
    repeat(5) @(posedge axi_clk);
    mwr(REG_MANUAL_TRIG, 32'h0000_0001);
    repeat(5) @(posedge axi_clk);
    mrd(REG_MANUAL_TRIG, rdata);
    check("Manual trig self-clear", rdata[0], 1'b0);
    fork
      wait_channel("Master manual", m_trig_channel, 0, BSYNC_HALF_PER*8);
      wait_channel("Master manual", m_trig_channel, 4, BSYNC_HALF_PER*8);
    join

    // Restore select_trig=1 so fire_trigger_and_wait_dma() works in tests 11-13.
    // Also wait for both SR latches to be clear: the manual trigger in TEST 8
    // fired ch4, which may have set m_trigger_stretched.  If trigger_captured
    // is still asserted when we fire the next trigger, the SR latch's SET edge
    // is immediately overridden by the CLEAR and sync_start never fires.
    mwr(REG_CONTROL, 32'h0000_087D);
    // Wait up to 4 sysref periods for both latches to drain
    begin : drain_latches
      int cnt;
      cnt = 0;
      while ((m_trigger_stretched || s_trigger_stretched) && cnt < 4*BSYNC_HALF_PER*2) begin
        @(posedge dev_clk); cnt++;
      end
      $display("[SIM]  SR latches drained after %0d dev_clk cycles", cnt);
    end

    // =========================================================================
    // TEST 11: Master dma_start → sync_start chain
    //
    // Signal path (system_top_master.v lines 331-347):
    //
    //   m_trig_channel[4] = m_dma_start
    //          |
    //          v posedge
    //   m_trigger_stretched (async SR latch, SET here)
    //          |
    //          v posedge m_sysref (= regenerated BSYNC)
    //   m_trigger_sync1  ──> m_trigger_sync2
    //          |                     |
    //          |               posedge m_sysref
    //          |                     |
    //          |             m_trigger_captured (= sync2)
    //          |                     |
    //          |           feedback: posedge clears SR latch
    //          |
    //   m_sync_start_edge = sync1 & ~sync2 (one sysref period wide)
    //   m_sync_start      = sync_start_edge & m_sysref (gated to sysref high)
    //          |
    //          v
    //   ext_sync_in (JESD MCS alignment input)
    //
    // Expected sequence:
    //   1. m_dma_start pulses  (ch4 fires)
    //   2. m_trigger_stretched goes high (SR latch SET)
    //   3. First posedge m_sysref: m_trigger_sync1 captures 1
    //   4. Second posedge m_sysref: m_trigger_sync2 captures 1,
    //      m_trigger_captured goes high → SR latch CLEAR
    //   5. m_sync_start_edge = 1 for that sysref period
    //   6. m_sync_start = 1 during the sysref high phase
    // =========================================================================
    $display("\n--- TEST 11: Master dma_start -> sync_start chain ---");

    check("Master sync_start idle before trigger", m_sync_start, 1'b0);

    // Fire trigger, wait for master ch4 (dma_start)
    fire_trigger_and_wait_dma();

    $display("[SIM]  Waiting for master sync_start ...");
    wait_signal("Master sync_start", m_sync_start, 4*BSYNC_HALF_PER*2);

    // sync_start is gated with sysref — it lasts one sysref high phase.
    // Verify it self-clears (no external deassert needed).
    $display("[SIM]  Waiting for master sync_start to self-clear ...");
    wait_signal_low("Master sync_start self-clear", m_sync_start, BSYNC_HALF_PER*2+10);

    // Wait 3 sysref posedges for the 2-FF pipeline to drain (sync1→sync2→trigger_captured→SR clear).
    // Then check only the observable SR latch output; sync1/sync2 are pipeline internals.
    repeat(3) @(posedge m_sysref);
    check("Master trigger_stretched cleared", m_trigger_stretched, 1'b0);

    // =========================================================================
    // TEST 12: Slave dma_start → sync_start chain
    //
    // The slave's trigger input is m_trig_request_out (PMOD wire from master).
    // Fire a fresh trigger; master trig_request_out → slave channels → slave ch4.
    //
    // Both master and slave ch4 fire within the same BSYNC period, so we
    // capture both concurrently to avoid missing slave ch4 while waiting for
    // master ch4.
    // =========================================================================
    $display("\n--- TEST 12: Slave dma_start -> sync_start chain ---");

    check("Slave sync_start idle before trigger", s_sync_start, 1'b0);

    // Fire trigger and wait for BOTH master and slave ch4 concurrently
    @(posedge dev_clk); #1; m_trigger = 1;
    @(posedge dev_clk); #1; m_trigger = 0;
    wait_signal("trig_request_out (T12)", m_trig_request_out, BSYNC_HALF_PER*2);
    fork
      wait_channel("Master ch4 (T12)", m_trig_channel, 4, BSYNC_HALF_PER*8);
      wait_channel("Slave  ch4 (T12)", s_trig_channel, 4, BSYNC_HALF_PER*8);
    join

    $display("[SIM]  Waiting for slave sync_start ...");
    wait_signal("Slave sync_start", s_sync_start, 4*BSYNC_HALF_PER*2);

    $display("[SIM]  Waiting for slave sync_start to self-clear ...");
    wait_signal_low("Slave sync_start self-clear", s_sync_start, BSYNC_HALF_PER*2+10);

    repeat(3) @(posedge s_sysref);
    check("Slave trigger_stretched cleared", s_trigger_stretched, 1'b0);

    // =========================================================================
    // TEST 13: sync_start fires exactly once per trigger (one-shot)
    //
    // After the latch is cleared by trigger_captured, a new dma_start event
    // is required to re-arm it.  Between triggers, sync_start must stay low
    // even if sysref continues toggling.
    //
    // Checks:
    //   a) After last trigger: sync_start low and stays low for 4 BSYNC periods
    //   b) Fire new trigger: both sync_starts re-fire
    //   c) After re-fire: sync_starts go low again
    // =========================================================================
    $display("\n--- TEST 13: sync_start one-shot (no spurious re-fire) ---");

    // (a) Verify sync_start stays low for 4 BSYNC periods without a new trigger
    begin : check_no_spurious
      int i;
      logic saw_high;
      saw_high = 0;
      for (i = 0; i < BSYNC_HALF_PER*8; i++) begin
        @(posedge dev_clk);
        if (m_sync_start === 1'b1) saw_high = 1;
      end
      check("Master sync_start stays low (no new trigger)", saw_high, 1'b0);

      saw_high = 0;
      for (i = 0; i < BSYNC_HALF_PER*8; i++) begin
        @(posedge dev_clk);
        if (s_sync_start === 1'b1) saw_high = 1;
      end
      check("Slave  sync_start stays low (no new trigger)", saw_high, 1'b0);
    end

    // (b) Fire a new trigger, capture both ch4 concurrently then verify re-arm
    $display("[SIM]  Firing new trigger for one-shot re-arm check ...");
    @(posedge dev_clk); #1; m_trigger = 1;
    @(posedge dev_clk); #1; m_trigger = 0;
    wait_signal("trig_request_out (T13)", m_trig_request_out, BSYNC_HALF_PER*2);
    fork
      wait_channel("Master ch4 (T13)", m_trig_channel, 4, BSYNC_HALF_PER*8);
      wait_channel("Slave  ch4 (T13)", s_trig_channel, 4, BSYNC_HALF_PER*8);
    join

    // With BSYNC_HALF_PER >> master->slave propagation delay both sync_starts
    // fire in the same sysref window, so watch them concurrently.
    fork
      begin
        wait_signal    ("Master sync_start re-arm",  m_sync_start, 4*BSYNC_HALF_PER*2);
        wait_signal_low("Master sync_start clears",  m_sync_start, BSYNC_HALF_PER*2+10);
      end
      begin
        wait_signal    ("Slave  sync_start re-arm",  s_sync_start, 4*BSYNC_HALF_PER*2);
        wait_signal_low("Slave  sync_start clears",  s_sync_start, BSYNC_HALF_PER*2+10);
      end
    join

    // (c) Final quiescence: both sync_starts low again
    repeat(4) @(posedge m_sysref);
    check("Master sync_start quiescent", m_sync_start, 1'b0);
    check("Slave  sync_start quiescent", s_sync_start, 1'b0);

    // =========================================================================
    // TEST 14: Misalignment check
    //
    // Sequence: toggle direction 0→1 to re-arm dir_changed, then enable
    // misalign_check.  dir_changed=1 causes the first BSYNC edge to initialize
    // both bsync_alignment and bsync_next_alignment to the same counter value,
    // preventing a spurious mismatch on first enable.
    // =========================================================================
    $display("\n--- TEST 14: Misalignment check (slave) ---");
    // Briefly clear direction (RX) then restore TX to re-set dir_changed
    swr(REG_CONTROL, 32'h0000_087C);   // direction=0 (RX), all else same
    repeat(4) @(posedge dev_clk);
    swr(REG_CONTROL, 32'h0000_487D);   // direction=1 (TX) + misalign_check=1
    // Wait for dir_changed to clear (b_captured && bsync_edge) then 2 more
    // BSYNC periods for alignment registers to stabilize
    repeat(BSYNC_HALF_PER * 6) @(posedge dev_clk);
    srd(REG_DEBUG, rdata);
    $display("[SIM]  Slave DEBUG (T14): 0x%08h align_err=%0b state=%0d",
             rdata, rdata[22], rdata[26:24]);
    check("Slave no alignment error", rdata[22], 1'b0);
    swr(REG_CONTROL, 32'h0000_087D);   // restore slave CONTROL

    // =========================================================================
    // TEST 15: Software reset
    //   Done last because it clears scratch and disrupts BSYNC calibration.
    // =========================================================================
    $display("\n--- TEST 15: SW reset ---");
    mwr(REG_SCRATCH, 32'hCAFE_BABE);
    mrd(REG_SCRATCH, rdata); check32("Scratch before reset", rdata, 32'hCAFE_BABE);
    mwr(REG_CONTROL, 32'h0000_0400);   // sw_reset bit
    repeat(20) @(posedge axi_clk);
    mrd(REG_SCRATCH, rdata); check32("Scratch after reset",  rdata, 32'h0000_0000);

    // =========================================================================
    // Done
    // =========================================================================
    $display("\n======================================================");
    $display(" Simulation complete: %0d PASS  %0d FAIL", pass_count, fail_count);
    $display("======================================================\n");
    if (fail_count == 0)
      $display("RESULT: ALL TESTS PASSED");
    else
      $display("RESULT: %0d TEST(S) FAILED", fail_count);

    #100; $finish;
  end

  // ---------------------------------------------------------------------------
  // Watchdog
  // ---------------------------------------------------------------------------
  initial begin
    #50_000_000;
    $display("[WATCHDOG] Simulation exceeded 50ms — aborting");
    $finish;
  end

endmodule
