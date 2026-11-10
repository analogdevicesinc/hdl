// SPDX-License-Identifier: BSD-1-Clause
// Copyright (c) 2026 Analog Devices, Inc. All rights reserved

`timescale 1ns/100ps

`define TIMEOUT 200000

module ethernet_vck190_tb;

  parameter VCD_FILE = "ethernet_vck190_tb.vcd";

  `include "tb_base.v"

  localparam PORT_COUNT = 4;
  localparam DW = 64;
  localparam KW = 8;
  localparam PTP_W = 48;
  localparam TAG_W = 16;
  localparam CSR_AW = 19;
  localparam RB_DRP_BASE = 16'h1040;
  localparam TEST_PORT = 2;
  localparam FRM_LEN = 64;

  reg  [CSR_AW-1:0] ctrl_rd_addr = 0;
  reg               ctrl_rd_en = 1'b0;
  wire [31:0]       ctrl_rd_data;
  wire              ctrl_rd_ack, ctrl_rd_wait;
  wire              ctrl_wr_ack, ctrl_wr_wait;

  reg  [PORT_COUNT*DW-1:0]  tx_tdata = 0;
  reg  [PORT_COUNT*KW-1:0]  tx_tkeep = 0;
  reg  [PORT_COUNT-1:0]     tx_tvalid = 0;
  wire [PORT_COUNT-1:0]     tx_tready;
  reg  [PORT_COUNT-1:0]     tx_tlast = 0;
  reg  [PORT_COUNT*(TAG_W+1)-1:0] tx_tuser = 0;

  wire [PORT_COUNT*64-1:0]  m_tdata;
  wire [PORT_COUNT*11-1:0]  m_tkeep_user;
  wire [PORT_COUNT-1:0]     m_tvalid;
  wire [PORT_COUNT-1:0]     m_tlast;

  wire [24-1:0] drp_addr;
  wire [31:0]   drp_di;
  wire          drp_en, drp_we;

  ethernet_vck190 #(
    .MODE("4x25G"),
    .IF_COUNT(1),
    .PORTS_PER_IF(PORT_COUNT),
    .PORT_COUNT(PORT_COUNT),
    .AXIS_DATA_WIDTH(DW),
    .AXIS_KEEP_WIDTH(KW),
    .PTP_TS_ENABLE(1),
    .PTP_TS_FMT_TOD(0),
    .PTP_TS_WIDTH(PTP_W),
    .TX_TAG_WIDTH(TAG_W)
  ) dut (
    .clk(clk),
    .rst(reset),

    .ctrl_reg_wr_addr({CSR_AW{1'b0}}),
    .ctrl_reg_wr_data(32'd0),
    .ctrl_reg_wr_strb(4'd0),
    .ctrl_reg_wr_en(1'b0),
    .ctrl_reg_wr_wait(ctrl_wr_wait),
    .ctrl_reg_wr_ack(ctrl_wr_ack),
    .ctrl_reg_rd_addr(ctrl_rd_addr),
    .ctrl_reg_rd_en(ctrl_rd_en),
    .ctrl_reg_rd_data(ctrl_rd_data),
    .ctrl_reg_rd_wait(ctrl_rd_wait),
    .ctrl_reg_rd_ack(ctrl_rd_ack),

    .eth_tx_clk(),
    .eth_tx_rst(),
    .eth_tx_ptp_clk(),
    .eth_tx_ptp_rst(),
    .eth_tx_ptp_ts({PORT_COUNT*PTP_W{1'b0}}),
    .eth_tx_ptp_ts_step({PORT_COUNT{1'b0}}),
    .axis_eth_tx_tdata(tx_tdata),
    .axis_eth_tx_tkeep(tx_tkeep),
    .axis_eth_tx_tvalid(tx_tvalid),
    .axis_eth_tx_tready(tx_tready),
    .axis_eth_tx_tlast(tx_tlast),
    .axis_eth_tx_tuser(tx_tuser),
    .axis_eth_tx_ptp_ts(),
    .axis_eth_tx_ptp_ts_tag(),
    .axis_eth_tx_ptp_ts_valid(),
    .axis_eth_tx_ptp_ts_ready({PORT_COUNT{1'b1}}),
    .eth_tx_enable({PORT_COUNT{1'b1}}),
    .eth_tx_status(),
    .eth_tx_lfc_en({PORT_COUNT{1'b0}}),
    .eth_tx_lfc_req({PORT_COUNT{1'b0}}),
    .eth_tx_pfc_en({PORT_COUNT*8{1'b0}}),
    .eth_tx_pfc_req({PORT_COUNT*8{1'b0}}),

    .eth_rx_clk(),
    .eth_rx_rst(),
    .eth_rx_ptp_clk(),
    .eth_rx_ptp_rst(),
    .eth_rx_ptp_ts({PORT_COUNT*PTP_W{1'b0}}),
    .eth_rx_ptp_ts_step({PORT_COUNT{1'b0}}),
    .axis_eth_rx_tdata(),
    .axis_eth_rx_tkeep(),
    .axis_eth_rx_tvalid(),
    .axis_eth_rx_tready({PORT_COUNT{1'b1}}),
    .axis_eth_rx_tlast(),
    .axis_eth_rx_tuser(),
    .eth_rx_enable({PORT_COUNT{1'b1}}),
    .eth_rx_status(),
    .eth_rx_lfc_en({PORT_COUNT{1'b0}}),
    .eth_rx_lfc_req(),
    .eth_rx_lfc_ack({PORT_COUNT{1'b0}}),
    .eth_rx_pfc_en({PORT_COUNT*8{1'b0}}),
    .eth_rx_pfc_req(),
    .eth_rx_pfc_ack({PORT_COUNT*8{1'b0}}),

    .gt_drp_clk(clk),
    .gt_drp_rst(reset),
    .gt_drp_addr(drp_addr),
    .gt_drp_di(drp_di),
    .gt_drp_en(drp_en),
    .gt_drp_we(drp_we),
    .gt_drp_do(32'd0),
    .gt_drp_rdy(1'b0),

    .mrmac_tx_axi_clk({PORT_COUNT{clk}}),
    .mrmac_rx_axi_clk({PORT_COUNT{clk}}),
    .mrmac_tx_reset_in({PORT_COUNT{reset}}),
    .mrmac_rx_reset_in({PORT_COUNT{reset}}),

    .mrmac_tx_axis_tdata(m_tdata),
    .mrmac_tx_axis_tkeep_user(m_tkeep_user),
    .mrmac_tx_axis_tvalid(m_tvalid),
    .mrmac_tx_axis_tready({PORT_COUNT{1'b1}}),
    .mrmac_tx_axis_tlast(m_tlast),

    .mrmac_rx_axis_tdata({PORT_COUNT*64{1'b0}}),
    .mrmac_rx_axis_tkeep_user({PORT_COUNT*11{1'b0}}),
    .mrmac_rx_axis_tvalid({PORT_COUNT{1'b0}}),
    .mrmac_rx_axis_tlast({PORT_COUNT{1'b0}}),

    .mrmac_stat_rx_status({PORT_COUNT{1'b1}}),
    .mrmac_ctl_tx_enable(),
    .mrmac_ctl_rx_enable(),
    .mrmac_rx_fifo_overflow(),
    .mrmac_ctl_tx_pause_enable(),
    .mrmac_ctl_tx_pause_req(),
    .mrmac_ctl_rx_pause_enable(),
    .mrmac_ctl_rx_pause_ack(),
    .mrmac_stat_rx_pause_req({PORT_COUNT*9{1'b0}}),
    .mrmac_rx_ptp_tstamp({PORT_COUNT*55{1'b0}}),
    .mrmac_tx_ptp_1588op(),
    .mrmac_tx_ptp_tag_field(),
    .mrmac_tx_ptp_tstamp({PORT_COUNT*55{1'b0}}),
    .mrmac_tx_ptp_tstamp_tag({PORT_COUNT*16{1'b0}}),
    .mrmac_tx_ptp_tstamp_valid({PORT_COUNT{1'b0}}),
    .mrmac_tx_ptp_systemtimer(),
    .mrmac_tx_ptp_st_sync(),
    .mrmac_tx_ptp_st_overwrite(),
    .mrmac_rx_ptp_systemtimer(),
    .mrmac_rx_ptp_st_sync(),
    .mrmac_rx_ptp_st_overwrite()
  );

  function [7:0] pat;
    input integer b;
    begin
      pat = (b * 7 + 8'h31) & 8'hff;
    end
  endfunction

  integer off = 0;
  integer bb;
  reg     sent = 1'b0;
  reg     started = 1'b0;

  always @(posedge clk) begin
    if (reset) begin
      tx_tvalid <= 0;
    end else if (!sent) begin
      if (!started) begin
        if ($time > 2000) started <= 1'b1;
      end else if (!tx_tvalid[TEST_PORT] || tx_tready[TEST_PORT]) begin
        if (tx_tvalid[TEST_PORT] && tx_tready[TEST_PORT]) begin
          off = off + KW;
        end
        if (off < FRM_LEN) begin
          for (bb = 0; bb < KW; bb = bb + 1)
            tx_tdata[TEST_PORT*DW + bb*8 +: 8] <= pat(off + bb);
          tx_tkeep[TEST_PORT*KW +: KW] <= {KW{1'b1}};
          tx_tlast[TEST_PORT] <= (off + KW >= FRM_LEN);
          tx_tvalid[TEST_PORT] <= 1'b1;
        end else begin
          tx_tvalid[TEST_PORT] <= 1'b0;
          tx_tlast[TEST_PORT] <= 1'b0;
          sent <= 1'b1;
        end
      end
    end
  end

  integer p;
  integer rx_off [0:PORT_COUNT-1];
  integer frames [0:PORT_COUNT-1];
  integer beats  [0:PORT_COUNT-1];
  integer errors = 0;
  initial for (p = 0; p < PORT_COUNT; p = p + 1) begin
    rx_off[p] = 0; frames[p] = 0; beats[p] = 0;
  end

  always @(posedge clk) begin
    for (p = 0; p < PORT_COUNT; p = p + 1) begin
      if (m_tvalid[p]) begin
        beats[p] = beats[p] + 1;
        if (p == TEST_PORT) begin
          for (bb = 0; bb < 8; bb = bb + 1)
            if (m_tdata[p*64 + bb*8 +: 8] !== pat(rx_off[p] + bb)) begin
              $display("%t port %0d byte %0d: got %02x exp %02x", $time, p,
                       rx_off[p] + bb, m_tdata[p*64 + bb*8 +: 8], pat(rx_off[p] + bb));
              errors = errors + 1;
            end
          rx_off[p] = rx_off[p] + 8;
        end
        if (m_tlast[p]) begin
          frames[p] = frames[p] + 1;
          if (p == TEST_PORT && rx_off[p] != FRM_LEN) begin
            $display("%t port %0d: frame length %0d, expected %0d", $time, p, rx_off[p], FRM_LEN);
            errors = errors + 1;
          end
          rx_off[p] = 0;
        end
      end
    end
  end

  reg [31:0] rd_val;
  reg        rd_got;
  integer    t;

  task ctrl_rd;
    input [CSR_AW-1:0] addr;
    begin
      rd_got = 1'b0;
      rd_val = 32'd0;
      @(posedge clk);
      ctrl_rd_addr <= addr;
      ctrl_rd_en <= 1'b1;
      @(posedge clk);
      ctrl_rd_en <= 1'b0;
      for (t = 0; t < 20 && !rd_got; t = t + 1) begin
        @(posedge clk);
        if (ctrl_rd_ack) begin
          rd_got = 1'b1;
          rd_val = ctrl_rd_data;
        end
      end
    end
  endtask

  integer i;
  initial begin
    @(negedge reset);
    repeat (50) @(posedge clk);

    ctrl_rd(RB_DRP_BASE + 16'h00);
    if (!rd_got || rd_val !== 32'h0000C150) begin
      $display("RB_DRP type: ack=%0d val=%08x", rd_got, rd_val);
      errors = errors + 1;
    end
    ctrl_rd(RB_DRP_BASE + 16'h08);
    if (!rd_got || rd_val !== 32'd0) begin
      $display("RB_DRP next ptr: ack=%0d val=%08x (expected 0)", rd_got, rd_val);
      errors = errors + 1;
    end
    ctrl_rd(RB_DRP_BASE + 16'h20);
    if (rd_got) begin
      $display("a second block answers at RB_DRP_BASE+0x20: val=%08x", rd_val);
      errors = errors + 1;
    end

    wait (sent);
    repeat (300) @(posedge clk);

    if (frames[TEST_PORT] != 1) begin
      $display("port %0d: %0d frames, expected 1", TEST_PORT, frames[TEST_PORT]);
      errors = errors + 1;
    end
    for (i = 0; i < PORT_COUNT; i = i + 1)
      if (i != TEST_PORT && (beats[i] != 0 || frames[i] != 0)) begin
        $display("port %0d saw traffic: %0d beats, %0d frames", i, beats[i], frames[i]);
        errors = errors + 1;
      end

    if (errors != 0) begin
      $display("%0d errors", errors);
      failed = 1'b1;
    end
  end

endmodule
