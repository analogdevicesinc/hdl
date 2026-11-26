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
 * DRP address map, n = drp_addr[18:17]:
 *   [19]=0 [16]=0  channel n GT register, APB3 address [15:0] + n*0x100
 *   [19]=1 [16]=0  quad APB3 address [15:0]
 *   [19]=0 [16]=1  channel n control registers, below
 *   [19]=1 [16]=1  reserved, reads 0, writes ignored
 * The AXI byte address is {apb, 2'b00}. APB3 addresses below 0x0D are
 * answered locally (read 0, write dropped).
 *
 * Control registers, reset to 0:
 *   0x0040  [3:0] TX PRBS select (txprbssel)
 *   0x1040  [3:0] RX PRBS select (rxprbssel)
 *   0x1041  write [0]=1 flips rxprbscntreset; read [0] rxprbscntreset,
 *           [8] rxprbslocked, [9] rxprbserr seen since the last read
 * Other offsets read 0 and ignore writes.
 */

`timescale 1ns/100ps

module mrmac_gt_regs #(
  parameter TIMEOUT_CYCLES = 65536
) (
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF m_axi:s_axi, ASSOCIATED_RESET resetn" *)
  input  wire        clk,
  input  wire        resetn,

  (* X_INTERFACE_IGNORE = "true" *)
  input  wire [23:0] drp_addr,
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire [31:0] drp_di,
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire        drp_en,
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire        drp_we,
  (* X_INTERFACE_IGNORE = "true" *)
  output reg  [31:0] drp_do = 32'd0,
  (* X_INTERFACE_IGNORE = "true" *)
  output reg         drp_rdy = 1'b0,

  input  wire [17:0] s_axi_awaddr,
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
  input  wire [17:0] s_axi_araddr,
  input  wire [2:0]  s_axi_arprot,
  input  wire        s_axi_arvalid,
  output reg         s_axi_arready = 1'b0,
  output reg  [31:0] s_axi_rdata = 32'd0,
  output reg  [1:0]  s_axi_rresp = 2'b00,
  output reg         s_axi_rvalid = 1'b0,
  input  wire        s_axi_rready,

  output wire [17:0] m_axi_awaddr,
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
  output wire [17:0] m_axi_araddr,
  output wire [2:0]  m_axi_arprot,
  output reg         m_axi_arvalid = 1'b0,
  input  wire        m_axi_arready,
  input  wire [31:0] m_axi_rdata,
  input  wire [1:0]  m_axi_rresp,
  input  wire        m_axi_rvalid,
  output reg         m_axi_rready = 1'b0,

  (* X_INTERFACE_IGNORE = "true" *)
  input  wire        tx_prbs_clk,
  input  wire        rx_prbs_clk_0,
  input  wire        rx_prbs_clk_1,
  input  wire        rx_prbs_clk_2,
  input  wire        rx_prbs_clk_3,
  output wire [3:0]  tx_prbssel_0,
  output wire [3:0]  tx_prbssel_1,
  output wire [3:0]  tx_prbssel_2,
  output wire [3:0]  tx_prbssel_3,
  output wire [3:0]  rx_prbssel_0,
  output wire [3:0]  rx_prbssel_1,
  output wire [3:0]  rx_prbssel_2,
  output wire [3:0]  rx_prbssel_3,
  output wire        rx_prbscntreset_0,
  output wire        rx_prbscntreset_1,
  output wire        rx_prbscntreset_2,
  output wire        rx_prbscntreset_3,
  input  wire        rx_prbslocked_0,
  input  wire        rx_prbslocked_1,
  input  wire        rx_prbslocked_2,
  input  wire        rx_prbslocked_3,
  input  wire        rx_prbserr_0,
  input  wire        rx_prbserr_1,
  input  wire        rx_prbserr_2,
  input  wire        rx_prbserr_3,
  output reg         prbs_active = 1'b0
);

  localparam [15:0] APB_MIN = 16'h000d;
  localparam [15:0] CTRL_TX_SEL = 16'h0040;
  localparam [15:0] CTRL_RX_SEL = 16'h1040;
  localparam [15:0] CTRL_RX_STAT = 16'h1041;

  reg         acc_busy = 1'b0;
  reg         acc_issued = 1'b0;
  reg         acc_drp = 1'b0;
  reg         acc_rd = 1'b0;
  reg  [31:0] acc_timer = 32'd0;
  reg  [17:0] acc_addr = 18'd0;
  reg  [31:0] acc_data = 32'd0;
  reg  [3:0]  acc_strb = 4'hf;

  reg         bus_busy = 1'b0;
  reg         bus_rd = 1'b0;
  reg  [17:0] bus_addr = 18'd0;
  reg  [31:0] bus_data = 32'd0;

  reg         drp_pend = 1'b0;
  reg  [23:0] drp_pend_addr = 24'd0;
  reg  [31:0] drp_pend_di = 32'd0;
  reg         drp_pend_we = 1'b0;
  reg         drp_last = 1'b0;

  // channel control registers, 4 bits per channel
  reg  [15:0] tx_sel = 16'd0;
  reg  [15:0] rx_sel = 16'd0;
  reg  [3:0]  rx_cntrst = 4'd0;
  reg  [3:0]  rx_err_seen = 4'd0;

  wire [3:0]  rx_prbs_clk = {rx_prbs_clk_3, rx_prbs_clk_2, rx_prbs_clk_1, rx_prbs_clk_0};
  wire [3:0]  rx_prbserr = {rx_prbserr_3, rx_prbserr_2, rx_prbserr_1, rx_prbserr_0};
  wire [3:0]  rx_locked_s;
  wire [3:0]  rx_err_s;
  wire [15:0] tx_sel_s;
  wire [15:0] rx_sel_s;

  assign m_axi_awaddr = bus_addr;
  assign m_axi_araddr = bus_addr;
  assign m_axi_wdata  = bus_data;
  assign m_axi_awprot = 3'd0;
  assign m_axi_arprot = 3'd0;

  assign tx_prbssel_0 = tx_sel_s[3:0];
  assign tx_prbssel_1 = tx_sel_s[7:4];
  assign tx_prbssel_2 = tx_sel_s[11:8];
  assign tx_prbssel_3 = tx_sel_s[15:12];
  assign rx_prbssel_0 = rx_sel_s[3:0];
  assign rx_prbssel_1 = rx_sel_s[7:4];
  assign rx_prbssel_2 = rx_sel_s[11:8];
  assign rx_prbssel_3 = rx_sel_s[15:12];
  assign rx_prbscntreset_0 = rx_cntrst[0];
  assign rx_prbscntreset_1 = rx_cntrst[1];
  assign rx_prbscntreset_2 = rx_cntrst[2];
  assign rx_prbscntreset_3 = rx_cntrst[3];

  sync_bits #(
    .NUM_OF_BITS(4),
    .ASYNC_CLK(1)
  ) i_sync_locked (
    .in_bits({rx_prbslocked_3, rx_prbslocked_2, rx_prbslocked_1, rx_prbslocked_0}),
    .out_resetn(resetn),
    .out_clk(clk),
    .out_bits(rx_locked_s));

  sync_data #(
    .NUM_OF_BITS(16),
    .ASYNC_CLK(1)
  ) i_sync_tx_sel (
    .in_clk(clk),
    .in_data(tx_sel),
    .out_clk(tx_prbs_clk),
    .out_data(tx_sel_s));

  genvar n;
  generate
  for (n = 0; n < 4; n = n + 1) begin : g_lane
    sync_event #(
      .NUM_OF_EVENTS(1),
      .ASYNC_CLK(1)
    ) i_sync_err (
      .in_clk(rx_prbs_clk[n]),
      .in_event(rx_prbserr[n]),
      .out_clk(clk),
      .out_event(rx_err_s[n]));

    sync_data #(
      .NUM_OF_BITS(4),
      .ASYNC_CLK(1)
    ) i_sync_rx_sel (
      .in_clk(clk),
      .in_data(rx_sel[4*n +: 4]),
      .out_clk(rx_prbs_clk[n]),
      .out_data(rx_sel_s[4*n +: 4]));
  end
  endgenerate

  wire [23:0] dq_addr = drp_en ? drp_addr : drp_pend_addr;
  wire [31:0] dq_di   = drp_en ? drp_di : drp_pend_di;
  wire        dq_we   = drp_en ? drp_we : drp_pend_we;
  wire [15:0] dq_apb  = dq_addr[19] ? dq_addr[15:0] :
                        dq_addr[15:0] + {6'd0, dq_addr[18:17], 8'd0};
  wire        dq_local;
  wire        dq_ctrl = dq_addr[16] && !dq_addr[19];
  wire [1:0]  dq_ch = dq_addr[18:17];
  wire [31:0] dq_ctrl_rdata;

  assign dq_local = dq_addr[16] || dq_apb < APB_MIN;
  assign dq_ctrl_rdata =
    !dq_ctrl ? 32'd0 :
    dq_addr[15:0] == CTRL_TX_SEL ? {28'd0, tx_sel[4*dq_ch +: 4]} :
    dq_addr[15:0] == CTRL_RX_SEL ? {28'd0, rx_sel[4*dq_ch +: 4]} :
    dq_addr[15:0] == CTRL_RX_STAT ? {22'd0, rx_err_seen[dq_ch], rx_locked_s[dq_ch],
                                     7'd0, rx_cntrst[dq_ch]} : 32'd0;

  wire drp_req = drp_en || drp_pend;
  wire apu_wr = s_axi_awvalid && s_axi_wvalid && !s_axi_awready &&
                (!s_axi_bvalid || s_axi_bready);
  wire apu_rd = s_axi_arvalid && !s_axi_arready &&
                (!s_axi_rvalid || s_axi_rready);

  wire pick_drp = drp_req && (!(apu_wr || apu_rd) || !drp_last);

  wire bus_b = m_axi_bvalid && m_axi_bready;
  wire bus_r = m_axi_rvalid && m_axi_rready;
  wire acc_done = acc_issued && (bus_b || bus_r);

  task bus_start;
    input        rd;
    input [17:0] addr;
    input [31:0] data;
    input [3:0]  strb;
    begin
      bus_busy <= 1'b1;
      bus_rd <= rd;
      bus_addr <= addr;
      bus_data <= data;
      m_axi_wstrb <= strb;
      if (rd) begin
        m_axi_arvalid <= 1'b1;
      end else begin
        m_axi_awvalid <= 1'b1;
        m_axi_wvalid <= 1'b1;
      end
    end
  endtask

  task acc_start;
    input        drp;
    input        rd;
    input [17:0] addr;
    input [31:0] data;
    input [3:0]  strb;
    begin
      acc_busy <= 1'b1;
      acc_issued <= !bus_busy;
      acc_drp <= drp;
      acc_rd <= rd;
      acc_timer <= 32'd0;
      acc_addr <= addr;
      acc_data <= data;
      acc_strb <= strb;
      if (!bus_busy)
        bus_start(rd, addr, data, strb);
    end
  endtask

  task acc_finish;
    input [31:0] rdata;
    input [1:0]  resp;
    begin
      acc_busy <= 1'b0;
      acc_issued <= 1'b0;
      if (acc_drp) begin
        drp_rdy <= 1'b1;
        drp_do <= acc_rd ? rdata : 32'd0;
      end else if (acc_rd) begin
        s_axi_rvalid <= 1'b1;
        s_axi_rdata <= rdata;
        s_axi_rresp <= resp;
      end else begin
        s_axi_bvalid <= 1'b1;
        s_axi_bresp <= resp;
      end
    end
  endtask

  always @(posedge clk) begin
    drp_rdy <= 1'b0;
    s_axi_awready <= 1'b0;
    s_axi_wready <= 1'b0;
    s_axi_arready <= 1'b0;

    if (s_axi_bvalid && s_axi_bready)
      s_axi_bvalid <= 1'b0;
    if (s_axi_rvalid && s_axi_rready)
      s_axi_rvalid <= 1'b0;

    prbs_active <= |{tx_sel, rx_sel};
    rx_err_seen <= rx_err_seen | rx_err_s;

    if (drp_en) begin
      drp_pend <= 1'b1;
      drp_pend_addr <= drp_addr;
      drp_pend_di <= drp_di;
      drp_pend_we <= drp_we;
    end

    if (m_axi_awvalid && m_axi_awready)
      m_axi_awvalid <= 1'b0;
    if (m_axi_wvalid && m_axi_wready)
      m_axi_wvalid <= 1'b0;
    if (bus_busy && !bus_rd && !m_axi_bready &&
        (!m_axi_awvalid || m_axi_awready) && (!m_axi_wvalid || m_axi_wready))
      m_axi_bready <= 1'b1;
    if (m_axi_arvalid && m_axi_arready) begin
      m_axi_arvalid <= 1'b0;
      m_axi_rready <= 1'b1;
    end
    if (bus_b)
      m_axi_bready <= 1'b0;
    if (bus_r)
      m_axi_rready <= 1'b0;
    if (bus_b || bus_r)
      bus_busy <= 1'b0;

    if (acc_done) begin
      acc_finish(m_axi_rdata, bus_r ? m_axi_rresp : m_axi_bresp);
    end else if (acc_busy) begin
      acc_timer <= acc_timer + 1'b1;
      if (acc_timer >= TIMEOUT_CYCLES - 1) begin
        acc_finish(32'd0, 2'b10);
      end else if (!acc_issued && !bus_busy) begin
        acc_issued <= 1'b1;
        bus_start(acc_rd, acc_addr, acc_data, acc_strb);
      end
    end else if (pick_drp) begin
      drp_pend <= 1'b0;
      drp_last <= 1'b1;
      if (dq_local) begin
        drp_rdy <= 1'b1;
        drp_do <= dq_we ? 32'd0 : dq_ctrl_rdata;
        if (dq_ctrl && dq_we) begin
          case (dq_addr[15:0])
            CTRL_TX_SEL: tx_sel[4*dq_ch +: 4] <= dq_di[3:0];
            CTRL_RX_SEL: rx_sel[4*dq_ch +: 4] <= dq_di[3:0];
            CTRL_RX_STAT: rx_cntrst[dq_ch] <= rx_cntrst[dq_ch] ^ dq_di[0];
            default: ;
          endcase
        end else if (dq_ctrl && dq_addr[15:0] == CTRL_RX_STAT) begin
          rx_err_seen[dq_ch] <= rx_err_s[dq_ch];
        end
      end else begin
        acc_start(1'b1, !dq_we, {dq_apb, 2'b00}, dq_di, 4'hf);
      end
    end else if (apu_wr) begin
      drp_last <= 1'b0;
      s_axi_awready <= 1'b1;
      s_axi_wready <= 1'b1;
      acc_start(1'b0, 1'b0, s_axi_awaddr, s_axi_wdata, s_axi_wstrb);
    end else if (apu_rd) begin
      drp_last <= 1'b0;
      s_axi_arready <= 1'b1;
      acc_start(1'b0, 1'b1, s_axi_araddr, 32'd0, 4'hf);
    end

    if (resetn == 1'b0) begin
      drp_rdy <= 1'b0;
      drp_pend <= 1'b0;
      drp_last <= 1'b0;
      acc_busy <= 1'b0;
      acc_issued <= 1'b0;
      bus_busy <= 1'b0;
      m_axi_awvalid <= 1'b0;
      m_axi_wvalid <= 1'b0;
      m_axi_bready <= 1'b0;
      m_axi_arvalid <= 1'b0;
      m_axi_rready <= 1'b0;
      s_axi_awready <= 1'b0;
      s_axi_wready <= 1'b0;
      s_axi_arready <= 1'b0;
      s_axi_bvalid <= 1'b0;
      s_axi_rvalid <= 1'b0;
      tx_sel <= 16'd0;
      rx_sel <= 16'd0;
      rx_cntrst <= 4'd0;
      rx_err_seen <= 4'd0;
      prbs_active <= 1'b0;
    end
  end

endmodule
