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

/*
 * "4x25G": register block n at n * 0x1000.
 */

`timescale 1ns/100ps

module mrmac_init #(
  parameter MODE = "1x100G",
  parameter PORTS = (MODE == "4x25G") ? 4 : 1,
  parameter RS_FEC_ENABLE = 1,
  parameter POR_CYCLES = 400,
  parameter SETTLE_CYCLES = 400,
  parameter RERESET_CYCLES = 400,
  parameter LOCK_TIMEOUT_CYCLES = 10000000,
  parameter ALIGN_TIMEOUT_CYCLES = 5000000,
  parameter LINK_DOWN_CYCLES = 100000,
  parameter POLL_CYCLES = 1000,
  parameter ENG_TIMEOUT_CYCLES = 4096
) (
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF m_axi:s_axi, ASSOCIATED_RESET resetn:mac_resetn" *)
  input  wire        clk,
  input  wire        resetn,

  input  wire        gtpowergood,
  input  wire [PORTS-1:0] gt_tx_reset_done,
  input  wire [PORTS-1:0] gt_rx_reset_done,
  input  wire [PORTS-1:0] stat_rx_status,
  input  wire [PORTS-1:0] ctl_tx_enable,
  input  wire [PORTS-1:0] ctl_rx_enable,
  input  wire        prbs_hold,

  input  wire [15:0] s_axi_awaddr,
  input  wire [2:0]  s_axi_awprot,
  input  wire        s_axi_awvalid,
  output reg         s_axi_awready = 1'b0,
  input  wire [31:0] s_axi_wdata,
  input  wire [3:0]  s_axi_wstrb,
  input  wire        s_axi_wvalid,
  output reg         s_axi_wready = 1'b0,
  output reg  [1:0]  s_axi_bresp = 2'b00,
  output reg         s_axi_bvalid = 1'b0,
  input  wire        s_axi_bready,
  input  wire [15:0] s_axi_araddr,
  input  wire [2:0]  s_axi_arprot,
  input  wire        s_axi_arvalid,
  output reg         s_axi_arready = 1'b0,
  output reg  [31:0] s_axi_rdata = 32'd0,
  output reg  [1:0]  s_axi_rresp = 2'b00,
  output reg         s_axi_rvalid = 1'b0,
  input  wire        s_axi_rready,

  output reg         gt_rst_all = 1'b1,
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 mac_resetn RST" *)
  (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
  output reg         mac_resetn = 1'b0,
  output reg  [PORTS-1:0] link_ready = {PORTS{1'b0}},
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 gt_rx_datapath_reset RST" *)
  (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
  output reg  [PORTS-1:0] gt_rx_datapath_reset = {PORTS{1'b0}},

  output wire [31:0] m_axi_awaddr,
  output wire [2:0]  m_axi_awprot,
  output reg         m_axi_awvalid = 1'b0,
  input  wire        m_axi_awready,
  output wire [31:0] m_axi_wdata,
  output reg  [3:0]  m_axi_wstrb = 4'hf,
  output reg         m_axi_wvalid = 1'b0,
  input  wire        m_axi_wready,
  input  wire [1:0]  m_axi_bresp,
  input  wire        m_axi_bvalid,
  output reg         m_axi_bready = 1'b0,
  output wire [31:0] m_axi_araddr,
  output wire [2:0]  m_axi_arprot,
  output reg         m_axi_arvalid = 1'b0,
  input  wire        m_axi_arready,
  input  wire [31:0] m_axi_rdata,
  input  wire [1:0]  m_axi_rresp,
  input  wire        m_axi_rvalid,
  output reg         m_axi_rready = 1'b0
);

  localparam [31:0] ADDR_RESET    = 32'h0000_0004;
  localparam [31:0] ADDR_MODE     = 32'h0000_0008;
  localparam [31:0] ADDR_CFG_TX   = 32'h0000_000c;
  localparam [31:0] ADDR_CFG_RX   = 32'h0000_0010;
  localparam [31:0] ADDR_TICK     = 32'h0000_002c;
  localparam [31:0] ADDR_FEC_CFG  = 32'h0000_00d0;
  localparam [31:0] ADDR_TX_FC    = 32'h0000_004c;
  localparam [31:0] ADDR_RX_FC1   = 32'h0000_009c;
  localparam [31:0] ADDR_RX_FC2   = 32'h0000_00a0;
  localparam [31:0] ADDR_RT_STAT  = 32'h0000_074c;
  localparam [31:0] ADDR_FEC_STAT = 32'h0000_0788;

  localparam IS_4X25G = (MODE == "4x25G");
  localparam IS_1X40G = (MODE == "1x40G");
  localparam FEC_EN   = RS_FEC_ENABLE && !IS_1X40G;

  initial begin
    if (MODE != "1x100G" && !IS_4X25G && !IS_1X40G)
      $error("mrmac_init: unsupported MODE %0s", MODE);
  end

  // 1x100GE, CAUI-4 wide serdes, independent non-segmented 384b AXIS;
  // 1x40GE, XLAUI-4 wide serdes, independent non-segmented 256b AXIS;
  // 25GE wide serdes, independent non-segmented 64b AXIS
  localparam [31:0] MODE_VAL      = IS_4X25G ? 32'h4000_0261 :
                                    IS_1X40G ? 32'h4000_0a42 : 32'h4000_0a64;
  // RESET_REG_0[3:0] is rx_serdes_reset of lanes 0..3
  localparam [31:0] RESET_VAL     = IS_4X25G ? 32'h0000_03f1 : 32'h0000_03ff;
  // tx: fcs insert, ipg 12; rx: delete fcs, check sfd/preamble; bit 0 = enable
  localparam [31:0] CFG_TX_VAL    = 32'h0000_0c02;
  localparam [31:0] CFG_RX_VAL    = 32'h0000_0032;
  // 100G: RS(528,514) + tx four lane pmd (CAUI-4); 25G: Clause 108
  // RS(528,514) + Clause 49 transcode.
  localparam [31:0] FEC_VAL       = !FEC_EN ? 32'h0000_0000 :
                                    IS_4X25G ? 32'h0000_0043 : 32'h0000_1008;
  // pause frames: refresh 0x7fff, quanta 0xffff for the
  // global and 8 priority classes; process gcp/pcp/gpp/ppp and check
  // multicast, ethertype and opcode on each.
  localparam [31:0] RX_FC1_VAL    = 32'h0000_000f;
  localparam [31:0] RX_FC2_VAL    = 32'h000c_e739;

  localparam CFG_WRITES = IS_4X25G ? 19 : 22;

  localparam [3:0] ST_POR     = 4'd0;
  localparam [3:0] ST_PWR     = 4'd1;
  localparam [3:0] ST_SETTLE  = 4'd2;
  localparam [3:0] ST_RERESET = 4'd3;
  localparam [3:0] ST_RELOCK  = 4'd4;
  localparam [3:0] ST_SETTLE2 = 4'd5;
  localparam [3:0] ST_CFG     = 4'd6;
  localparam [3:0] ST_ALIGN   = 4'd7;
  localparam [3:0] ST_UP      = 4'd8;
  localparam [3:0] ST_DRAIN   = 4'd9;
  localparam [3:0] ST_RUN     = 4'd10;

  localparam [1:0] P_WAIT     = 2'd0;
  localparam [1:0] P_CFG      = 2'd1;
  localparam [1:0] P_ALIGN    = 2'd2;
  localparam [1:0] P_UP       = 2'd3;

  localparam [2:0] OP_CFG     = 3'd0;
  localparam [2:0] OP_EN      = 3'd1;
  localparam [2:0] OP_STAT    = 3'd2;
  localparam [2:0] OP_FEC     = 3'd3;

  wire [5*PORTS+1:0] status_s;

  sync_bits #(
    .NUM_OF_BITS(5*PORTS+2),
    .ASYNC_CLK(1)
  ) i_sync_status (
    .in_bits({prbs_hold, ctl_rx_enable, ctl_tx_enable, stat_rx_status,
              gt_rx_reset_done, gt_tx_reset_done, gtpowergood}),
    .out_resetn(resetn),
    .out_clk(clk),
    .out_bits(status_s));

  wire             gtpowergood_s = status_s[0];
  wire [PORTS-1:0] port_locked_s = status_s[1+:PORTS] & status_s[1+PORTS+:PORTS];
  wire [PORTS-1:0] rx_status_v   = status_s[1+2*PORTS+:PORTS];
  wire [PORTS-1:0] tx_enable_v   = status_s[1+3*PORTS+:PORTS];
  wire [PORTS-1:0] rx_enable_v   = status_s[1+4*PORTS+:PORTS];
  wire             prbs_hold_s   = status_s[1+5*PORTS];

  wire rx_status_s = rx_status_v[0];
  wire tx_enable_s = tx_enable_v[0];
  wire rx_enable_s = rx_enable_v[0];

  reg  [3:0]  state = ST_POR;
  reg  [31:0] timer = 32'd0;
  reg  [31:0] down_cnt = 32'd0;
  reg  [31:0] poll_cnt = 32'd0;
  reg  [4:0]  cfg_idx = 5'd0;
  reg  [3:0]  drain_to = ST_POR;
  reg  [PORTS-1:0] lock_dropped = {PORTS{1'b0}};
  reg  [PORTS-1:0] tx_en_written = {PORTS{1'b0}};
  reg  [PORTS-1:0] rx_en_written = {PORTS{1'b0}};

  wire gt_locked_s = |(lock_dropped & port_locked_s);

  reg  [1:0]  p_state [0:PORTS-1];
  reg  [31:0] p_timer [0:PORTS-1];
  reg  [PORTS-1:0] poll_due = {PORTS{1'b0}};
  reg  [1:0]  cur = 2'd0;
  reg  [2:0]  seq_op = OP_CFG;
  reg         fec_pend = 1'b0;
  wire [PORTS-1:0] port_up;

  integer n;

  initial
    for (n = 0; n < PORTS; n = n + 1) begin
      p_state[n] = P_WAIT;
      p_timer[n] = 32'd0;
    end

  genvar g;
  generate
    for (g = 0; g < PORTS; g = g + 1) begin : g_port_up
      assign port_up[g] = p_state[g] == P_UP;
    end
  endgenerate

  wire [31:0] port_base = {18'd0, cur, 12'd0};

  reg         axi_busy = 1'b0;
  reg         axi_req = 1'b0;
  reg         axi_read = 1'b0;
  reg  [31:0] axi_addr = 32'd0;
  reg  [31:0] axi_data = 32'd0;
  reg         axi_done = 1'b0;
  reg  [31:0] axi_rdata = 32'd0;

  reg         eng_busy = 1'b0;
  reg         eng_cpu = 1'b0;
  reg         eng_rd = 1'b0;
  reg  [31:0] eng_timer = 32'd0;
  reg  [31:0] eng_addr = 32'd0;
  reg  [31:0] eng_data = 32'd0;

  always @(posedge clk) begin
    gt_rst_all <= (state == ST_POR) || (state == ST_RERESET) ||
                  (state == ST_PWR && !gtpowergood_s);
    mac_resetn <= !((state == ST_POR) || (state == ST_RERESET));
    if (IS_4X25G)
      link_ready <= (state == ST_RUN) ? port_up : {PORTS{1'b0}};
    else
      link_ready <= (state == ST_UP);
  end

  assign m_axi_awaddr = eng_addr;
  assign m_axi_araddr = eng_addr;
  assign m_axi_wdata  = eng_data;
  assign m_axi_awprot = 3'd0;
  assign m_axi_arprot = 3'd0;

  reg [31:0] cfg_addr;
  reg [31:0] cfg_data;
  reg [31:0] step_addr;

  wire [4:0] cfg_step = (IS_4X25G && cfg_idx >= 5'd5) ? cfg_idx + 5'd3 : cfg_idx;
  wire cfg_tx_en = tx_enable_v[cur];
  wire cfg_rx_en = rx_enable_v[cur];

  always @(*) begin
    case (cfg_step)
      5'd0:    begin step_addr = ADDR_RESET;            cfg_data = RESET_VAL; end
      5'd1:    begin step_addr = ADDR_MODE;             cfg_data = MODE_VAL; end
      5'd2:    begin step_addr = ADDR_CFG_RX;           cfg_data = CFG_RX_VAL | cfg_rx_en; end
      5'd3:    begin step_addr = ADDR_CFG_TX;           cfg_data = CFG_TX_VAL | cfg_tx_en; end
      5'd4:    begin step_addr = ADDR_FEC_CFG;          cfg_data = FEC_VAL; end
      5'd5:    begin step_addr = ADDR_FEC_CFG + 'h1000; cfg_data = 32'd0; end
      5'd6:    begin step_addr = ADDR_FEC_CFG + 'h2000; cfg_data = 32'd0; end
      5'd7:    begin step_addr = ADDR_FEC_CFG + 'h3000; cfg_data = 32'd0; end
      // TX refresh timers 0..8 at 0x04c..0x05c, quanta 0..8 at 0x060..0x070
      5'd8, 5'd9, 5'd10, 5'd11:
               begin step_addr = ADDR_TX_FC + (cfg_step - 8) * 4; cfg_data = 32'h7fff_7fff; end
      5'd12:   begin step_addr = ADDR_TX_FC + 'h10;     cfg_data = 32'h0000_7fff; end
      5'd13, 5'd14, 5'd15, 5'd16:
               begin step_addr = ADDR_TX_FC + (cfg_step - 8) * 4; cfg_data = 32'hffff_ffff; end
      5'd17:   begin step_addr = ADDR_TX_FC + 'h24;     cfg_data = 32'h0000_ffff; end
      5'd18:   begin step_addr = ADDR_RX_FC1;           cfg_data = RX_FC1_VAL; end
      5'd19:   begin step_addr = ADDR_RX_FC2;           cfg_data = RX_FC2_VAL; end
      5'd20:   begin step_addr = ADDR_RESET;            cfg_data = 32'd0; end
      default: begin step_addr = ADDR_TICK;             cfg_data = 32'd1; end
    endcase
    cfg_addr = port_base | step_addr;
  end

  task axi_start;
    input        rd;
    input [31:0] addr;
    input [31:0] data;
    begin
      axi_busy <= 1'b1;
      axi_req <= 1'b1;
      axi_read <= rd;
      axi_addr <= addr;
      axi_data <= data;
    end
  endtask

  task eng_start;
    input        cpu;
    input        rd;
    input [31:0] addr;
    input [31:0] data;
    input [3:0]  strb;
    begin
      eng_busy <= 1'b1;
      eng_cpu <= cpu;
      eng_rd <= rd;
      eng_timer <= 32'd0;
      eng_addr <= addr;
      eng_data <= data;
      m_axi_wstrb <= strb;
      if (rd) begin
        m_axi_arvalid <= 1'b1;
        m_axi_rready <= 1'b1;
      end else begin
        m_axi_awvalid <= 1'b1;
        m_axi_wvalid <= 1'b1;
        m_axi_bready <= 1'b1;
      end
    end
  endtask

  wire en_update = !axi_busy && !axi_done &&
                   (tx_enable_s != tx_en_written[0] || rx_enable_s != rx_en_written[0]);

  wire bus_hold = (state == ST_POR) || (state == ST_RERESET) || (state == ST_DRAIN);

  wire reset_due = !prbs_hold_s &&
                   ((state == ST_ALIGN && timer >= ALIGN_TIMEOUT_CYCLES - 1) ||
                    (state == ST_UP && !rx_status_s && down_cnt >= LINK_DOWN_CYCLES - 1));

  task go_reset;
    input [3:0] target;
    begin
      state <= ST_DRAIN;
      drain_to <= target;
    end
  endtask

  always @(posedge clk) begin
    axi_done <= 1'b0;
    s_axi_awready <= 1'b0;
    s_axi_wready <= 1'b0;
    s_axi_arready <= 1'b0;

    if (s_axi_bvalid && s_axi_bready)
      s_axi_bvalid <= 1'b0;
    if (s_axi_rvalid && s_axi_rready)
      s_axi_rvalid <= 1'b0;

    if (m_axi_awvalid && m_axi_awready)
      m_axi_awvalid <= 1'b0;
    if (m_axi_wvalid && m_axi_wready)
      m_axi_wvalid <= 1'b0;
    if (m_axi_bvalid && m_axi_bready) begin
      m_axi_bready <= 1'b0;
      eng_busy <= 1'b0;
      if (eng_cpu) begin
        s_axi_bvalid <= 1'b1;
        s_axi_bresp <= m_axi_bresp;
      end else begin
        axi_busy <= 1'b0;
        axi_done <= 1'b1;
      end
    end
    if (m_axi_arvalid && m_axi_arready)
      m_axi_arvalid <= 1'b0;
    if (m_axi_rvalid && m_axi_rready) begin
      m_axi_rready <= 1'b0;
      eng_busy <= 1'b0;
      if (eng_cpu) begin
        s_axi_rvalid <= 1'b1;
        s_axi_rdata <= m_axi_rdata;
        s_axi_rresp <= m_axi_rresp;
      end else begin
        axi_rdata <= m_axi_rdata;
        axi_busy <= 1'b0;
        axi_done <= 1'b1;
      end
    end

    if (eng_busy) begin
      eng_timer <= eng_timer + 1'b1;
      if (eng_timer >= ENG_TIMEOUT_CYCLES - 1) begin
        m_axi_awvalid <= 1'b0;
        m_axi_wvalid <= 1'b0;
        m_axi_bready <= 1'b0;
        m_axi_arvalid <= 1'b0;
        m_axi_rready <= 1'b0;
        eng_busy <= 1'b0;
        if (eng_cpu) begin
          if (eng_rd) begin
            s_axi_rvalid <= 1'b1;
            s_axi_rdata <= 32'd0;
            s_axi_rresp <= 2'b10;
          end else begin
            s_axi_bvalid <= 1'b1;
            s_axi_bresp <= 2'b10;
          end
        end else begin
          axi_rdata <= 32'd0;
          axi_busy <= 1'b0;
          axi_done <= 1'b1;
        end
      end
    end

    if (!eng_busy) begin
      if (axi_req) begin
        axi_req <= 1'b0;
        eng_start(1'b0, axi_read, axi_addr, axi_data, 4'hf);
      end else if (s_axi_awvalid && s_axi_wvalid && !s_axi_awready && !s_axi_bvalid) begin
        s_axi_awready <= 1'b1;
        s_axi_wready <= 1'b1;
        if (bus_hold) begin
          s_axi_bvalid <= 1'b1;
          s_axi_bresp <= 2'b10;
        end else begin
          eng_start(1'b1, 1'b0, {16'd0, s_axi_awaddr}, s_axi_wdata, s_axi_wstrb);
        end
      end else if (s_axi_arvalid && !s_axi_arready && !s_axi_rvalid) begin
        s_axi_arready <= 1'b1;
        if (bus_hold) begin
          s_axi_rvalid <= 1'b1;
          s_axi_rdata <= 32'd0;
          s_axi_rresp <= 2'b10;
        end else begin
          eng_start(1'b1, 1'b1, {16'd0, s_axi_araddr}, 32'd0, 4'hf);
        end
      end
    end

    if (state == ST_POR || state == ST_PWR || state == ST_RERESET || state == ST_RELOCK ||
        (IS_4X25G && (state == ST_SETTLE2 || state == ST_RUN)))
      lock_dropped <= lock_dropped | ~port_locked_s;
    else
      lock_dropped <= {PORTS{1'b0}};

    timer <= timer + 1'b1;
    poll_cnt <= (poll_cnt == POLL_CYCLES - 1) ? 32'd0 : poll_cnt + 1'b1;

    case (state)
      ST_POR: begin
        if (timer >= POR_CYCLES - 1) begin
          state <= ST_PWR;
          timer <= 32'd0;
        end
      end
      ST_PWR: begin
        if (gtpowergood_s && gt_locked_s) begin
          state <= ST_SETTLE;
          timer <= 32'd0;
        end else if (timer >= LOCK_TIMEOUT_CYCLES - 1) begin
          go_reset(ST_POR);
        end
      end
      ST_SETTLE: begin
        if (timer >= SETTLE_CYCLES - 1)
          go_reset(ST_RERESET);
      end
      ST_RERESET: begin
        if (timer >= RERESET_CYCLES - 1) begin
          state <= ST_RELOCK;
          timer <= 32'd0;
        end
      end
      ST_RELOCK: begin
        if (gt_locked_s) begin
          state <= ST_SETTLE2;
          timer <= 32'd0;
        end else if (timer >= LOCK_TIMEOUT_CYCLES - 1) begin
          go_reset(ST_POR);
        end
      end
      ST_SETTLE2: begin
        if (timer >= SETTLE_CYCLES - 1) begin
          if (IS_4X25G) begin
            state <= ST_RUN;
            timer <= 32'd0;
          end else begin
            state <= ST_CFG;
            cfg_idx <= 5'd0;
          end
        end
      end
      ST_CFG: begin
        if (!axi_busy && !axi_done) begin
          axi_start(1'b0, cfg_addr, cfg_data);
          if (cfg_idx == 5'd2)
            rx_en_written[0] <= rx_enable_s;
          if (cfg_idx == 5'd3)
            tx_en_written[0] <= tx_enable_s;
        end else if (axi_done) begin
          if (cfg_idx == CFG_WRITES - 1) begin
            state <= ST_ALIGN;
            timer <= 32'd0;
          end else begin
            cfg_idx <= cfg_idx + 1'b1;
          end
        end
      end
      ST_ALIGN, ST_UP: begin
        if (en_update && !reset_due) begin
          if (tx_enable_s != tx_en_written[0]) begin
            axi_start(1'b0, ADDR_CFG_TX, CFG_TX_VAL | tx_enable_s);
            tx_en_written[0] <= tx_enable_s;
          end else begin
            axi_start(1'b0, ADDR_CFG_RX, CFG_RX_VAL | rx_enable_s);
            rx_en_written[0] <= rx_enable_s;
          end
        end

        if (state == ST_ALIGN) begin
          if (axi_done && axi_read && axi_rdata[0]) begin
            state <= ST_UP;
            down_cnt <= 32'd0;
          end else if (timer >= ALIGN_TIMEOUT_CYCLES - 1 && !prbs_hold_s) begin
            go_reset(ST_RERESET);
          end else if (!en_update && !axi_busy && !axi_done &&
                       poll_cnt == POLL_CYCLES - 1) begin
            axi_start(1'b1, ADDR_RT_STAT, 32'd0);
          end
          if (prbs_hold_s)
            timer <= 32'd0;
        end else begin
          if (rx_status_s || prbs_hold_s) begin
            down_cnt <= 32'd0;
          end else if (down_cnt >= LINK_DOWN_CYCLES - 1) begin
            go_reset(ST_RERESET);
          end else begin
            down_cnt <= down_cnt + 1'b1;
          end
        end
      end
      ST_RUN: begin
        if (|port_up || prbs_hold_s)
          timer <= 32'd0;
        else if (timer >= ALIGN_TIMEOUT_CYCLES - 1)
          go_reset(ST_RERESET);
      end
      ST_DRAIN: begin
        if (!eng_busy && !axi_req && !axi_busy && !axi_done) begin
          state <= drain_to;
          timer <= 32'd0;
        end
      end
      default: begin
        state <= ST_POR;
        timer <= 32'd0;
      end
    endcase

    if (IS_4X25G) begin
      for (n = 0; n < PORTS; n = n + 1) begin
        if (state != ST_RUN) begin
          p_state[n] <= P_WAIT;
          p_timer[n] <= 32'd0;
          gt_rx_datapath_reset[n] <= 1'b0;
        end else begin
          case (p_state[n])
            P_WAIT: begin
              if (prbs_hold_s) begin
                p_timer[n] <= 32'd0;
                gt_rx_datapath_reset[n] <= 1'b0;
              end else if (p_timer[n] >= ALIGN_TIMEOUT_CYCLES - 1) begin
                p_timer[n] <= 32'd0;
                if (port_locked_s[n])
                  lock_dropped[n] <= 1'b1;
                else
                  gt_rx_datapath_reset[n] <= 1'b1;
              end else begin
                p_timer[n] <= p_timer[n] + 1'b1;
                if (p_timer[n] >= RERESET_CYCLES - 1)
                  gt_rx_datapath_reset[n] <= 1'b0;
              end
            end
            P_ALIGN: begin
              if (prbs_hold_s) begin
                p_timer[n] <= 32'd0;
              end else if (p_timer[n] >= ALIGN_TIMEOUT_CYCLES - 1) begin
                p_state[n] <= P_WAIT;
                p_timer[n] <= 32'd0;
                gt_rx_datapath_reset[n] <= 1'b1;
                lock_dropped[n] <= 1'b0;
              end else begin
                p_timer[n] <= p_timer[n] + 1'b1;
              end
            end
            P_UP: begin
              if (rx_status_v[n] || prbs_hold_s) begin
                p_timer[n] <= 32'd0;
              end else if (p_timer[n] >= LINK_DOWN_CYCLES - 1) begin
                p_state[n] <= P_WAIT;
                p_timer[n] <= 32'd0;
              end else begin
                p_timer[n] <= p_timer[n] + 1'b1;
              end
            end
            default:
              p_timer[n] <= 32'd0;
          endcase
        end
        if (p_state[n] != P_ALIGN)
          poll_due[n] <= 1'b0;
        else if (poll_cnt == POLL_CYCLES - 1)
          poll_due[n] <= 1'b1;
      end

      if (state != ST_RUN) begin
        fec_pend <= 1'b0;
      end else if (axi_done) begin
        case (seq_op)
          OP_CFG: begin
            if (p_state[cur] == P_CFG) begin
              if (cfg_idx == CFG_WRITES - 1) begin
                p_state[cur] <= P_ALIGN;
                p_timer[cur] <= 32'd0;
              end else begin
                cfg_idx <= cfg_idx + 1'b1;
              end
            end
          end
          OP_STAT: begin
            // status and block lock
            if (p_state[cur] == P_ALIGN && axi_rdata[1:0] == 2'b11) begin
              if (FEC_EN) begin
                fec_pend <= 1'b1;
              end else begin
                p_state[cur] <= P_UP;
                p_timer[cur] <= 32'd0;
              end
            end
          end
          OP_FEC: begin
            if (p_state[cur] == P_ALIGN && axi_rdata[0]) begin
              p_state[cur] <= P_UP;
              p_timer[cur] <= 32'd0;
            end
          end
          default: ;
        endcase
      end else if (!axi_busy) begin
        if (p_state[cur] == P_WAIT && lock_dropped[cur] && port_locked_s[cur] &&
            !gt_rx_datapath_reset[cur]) begin
          p_state[cur] <= P_CFG;
          cfg_idx <= 5'd0;
        end else if (p_state[cur] == P_CFG) begin
          axi_start(1'b0, cfg_addr, cfg_data);
          seq_op <= OP_CFG;
          if (cfg_idx == 5'd2)
            rx_en_written[cur] <= cfg_rx_en;
          if (cfg_idx == 5'd3)
            tx_en_written[cur] <= cfg_tx_en;
        end else if (fec_pend) begin
          fec_pend <= 1'b0;
          if (p_state[cur] == P_ALIGN) begin
            axi_start(1'b1, port_base | ADDR_FEC_STAT, 32'd0);
            seq_op <= OP_FEC;
          end
        end else if ((p_state[cur] == P_ALIGN || p_state[cur] == P_UP) &&
                     tx_enable_v[cur] != tx_en_written[cur]) begin
          axi_start(1'b0, port_base | ADDR_CFG_TX, CFG_TX_VAL | tx_enable_v[cur]);
          seq_op <= OP_EN;
          tx_en_written[cur] <= tx_enable_v[cur];
        end else if ((p_state[cur] == P_ALIGN || p_state[cur] == P_UP) &&
                     rx_enable_v[cur] != rx_en_written[cur]) begin
          axi_start(1'b0, port_base | ADDR_CFG_RX, CFG_RX_VAL | rx_enable_v[cur]);
          seq_op <= OP_EN;
          rx_en_written[cur] <= rx_enable_v[cur];
        end else if (p_state[cur] == P_ALIGN && poll_due[cur]) begin
          axi_start(1'b1, port_base | ADDR_RT_STAT, 32'd0);
          seq_op <= OP_STAT;
          poll_due[cur] <= 1'b0;
        end else begin
          cur <= (cur == PORTS - 1) ? 2'd0 : cur + 1'b1;
        end
      end

      if (p_state[cur] != P_ALIGN)
        fec_pend <= 1'b0;
    end

    if (resetn == 1'b0) begin
      state <= ST_POR;
      timer <= 32'd0;
      lock_dropped <= {PORTS{1'b0}};
      cfg_idx <= 5'd0;
      cur <= 2'd0;
      fec_pend <= 1'b0;
      down_cnt <= 32'd0;
      m_axi_awvalid <= 1'b0;
      m_axi_wvalid <= 1'b0;
      m_axi_bready <= 1'b0;
      m_axi_arvalid <= 1'b0;
      m_axi_rready <= 1'b0;
      axi_busy <= 1'b0;
      axi_req <= 1'b0;
      axi_done <= 1'b0;
      eng_busy <= 1'b0;
      s_axi_awready <= 1'b0;
      s_axi_wready <= 1'b0;
      s_axi_arready <= 1'b0;
      s_axi_bvalid <= 1'b0;
      s_axi_rvalid <= 1'b0;
    end
  end

endmodule
