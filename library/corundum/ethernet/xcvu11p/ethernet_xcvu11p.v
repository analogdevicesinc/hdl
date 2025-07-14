// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2023 The Regents of the University of California
 * Copyright (c) 2025 Analog Devices, Inc. All rights reserved
 */
/*
 * This file repackages Corundum MQNIC Core AXI with the sole purpose of
 * providing it as an IP Core.
 * The original file can be refereed at:
 * https://github.com/ucsdsysnet/corundum/blob/master/fpga/common/rtl/mqnic_core_axi.v
 */

`timescale 1ns/100ps

module ethernet_xcvu11p #(
  // Board configuration
  parameter TDMA_BER_ENABLE = 0,

  // Structural configuration
  parameter QSFP_CNT = 1,
  parameter IF_COUNT = 1,
  parameter PORTS_PER_IF = 1,
  parameter SCHED_PER_IF = PORTS_PER_IF,
  parameter PORT_MASK = 0,
  parameter PORT_COUNT = IF_COUNT*PORTS_PER_IF,

  // Interface configuration
  parameter PTP_TS_FMT_TOD = 0,
  parameter PTP_TS_WIDTH = PTP_TS_FMT_TOD ? 96 : 48,
  parameter TX_TAG_WIDTH = 16,

  // Scheduler configuration
  parameter TDMA_INDEX_WIDTH = 6,

  // Interface configuration
  parameter PTP_TS_ENABLE = 1,

  // AXI lite interface configuration (control)
  parameter AXIL_CTRL_DATA_WIDTH = 32,
  parameter AXIL_CTRL_ADDR_WIDTH = 24,
  parameter AXIL_CTRL_STRB_WIDTH = (AXIL_CTRL_DATA_WIDTH/8),

  // AXI lite interface configuration (application control)
  parameter AXIL_IF_CTRL_ADDR_WIDTH = AXIL_CTRL_ADDR_WIDTH-$clog2(IF_COUNT),
  parameter AXIL_CSR_ADDR_WIDTH = AXIL_IF_CTRL_ADDR_WIDTH-5-$clog2((SCHED_PER_IF+4+7)/8),

  // Ethernet interface configuration
  parameter ETH_RX_CLK_FROM_TX = 0,
  parameter ETH_RS_FEC_ENABLE = 1,
  parameter AXIS_DATA_WIDTH = 512,
  parameter AXIS_KEEP_WIDTH = AXIS_DATA_WIDTH/8,
  parameter AXIS_TX_USER_WIDTH = TX_TAG_WIDTH + 1,
  parameter AXIS_RX_USER_WIDTH = (PTP_TS_ENABLE ? PTP_TS_WIDTH : 0) + 1
) (
  /*
  * Clock and reset signals
  */
  input  wire                                     clk,
  input  wire                                     rst,

  input  wire                                     clk_125mhz,
  input  wire                                     rst_125mhz,

  // QSFP DRP
  input  wire [QSFP_CNT-1:0]                      qsfp_drp_clk,
  input  wire [QSFP_CNT-1:0]                      qsfp_drp_rst,

  /*
  * Control registers
  */
  input  wire [AXIL_CSR_ADDR_WIDTH-1:0]           ctrl_reg_wr_addr,
  input  wire [AXIL_CTRL_DATA_WIDTH-1:0]          ctrl_reg_wr_data,
  input  wire [AXIL_CTRL_STRB_WIDTH-1:0]          ctrl_reg_wr_strb,
  input  wire                                     ctrl_reg_wr_en,
  output wire                                     ctrl_reg_wr_wait,
  output wire                                     ctrl_reg_wr_ack,
  input  wire [AXIL_CSR_ADDR_WIDTH-1:0]           ctrl_reg_rd_addr,
  input  wire                                     ctrl_reg_rd_en,
  output wire [AXIL_CTRL_DATA_WIDTH-1:0]          ctrl_reg_rd_data,
  output wire                                     ctrl_reg_rd_wait,
  output wire                                     ctrl_reg_rd_ack,

  /*
  * Ethernet: QSFP28
  */
  output wire [QSFP_CNT*4-1:0]                    qsfp_tx_p,
  output wire [QSFP_CNT*4-1:0]                    qsfp_tx_n,
  input  wire [QSFP_CNT*4-1:0]                    qsfp_rx_p,
  input  wire [QSFP_CNT*4-1:0]                    qsfp_rx_n,

  output wire [QSFP_CNT-1:0]                      qsfp_modsell,
  output wire [QSFP_CNT-1:0]                      qsfp_resetl,
  input  wire [QSFP_CNT-1:0]                      qsfp_modprsl,
  input  wire [QSFP_CNT-1:0]                      qsfp_intl,
  output wire [QSFP_CNT-1:0]                      qsfp_lpmode,
  output wire [QSFP_CNT-1:0]                      qsfp_gtpowergood,

  input  wire [QSFP_CNT-1:0]                      qsfp_mgt_refclk,
  input  wire [QSFP_CNT-1:0]                      qsfp_mgt_refclk_bufg,

  output wire [QSFP_CNT-1:0]                      qsfp_rst,

  /*
  * Ethernet
  */
  output wire [PORT_COUNT-1:0]                    eth_tx_clk,
  output wire [PORT_COUNT-1:0]                    eth_tx_rst,

  output wire [PORT_COUNT-1:0]                    eth_tx_ptp_clk,
  output wire [PORT_COUNT-1:0]                    eth_tx_ptp_rst,
  input  wire [PORT_COUNT*PTP_TS_WIDTH-1:0]       eth_tx_ptp_ts,
  input  wire [PORT_COUNT-1:0]                    eth_tx_ptp_ts_step,

  input  wire [PORT_COUNT*AXIS_DATA_WIDTH-1:0]    axis_eth_tx_tdata,
  input  wire [PORT_COUNT*AXIS_KEEP_WIDTH-1:0]    axis_eth_tx_tkeep,
  input  wire [PORT_COUNT-1:0]                    axis_eth_tx_tvalid,
  output wire [PORT_COUNT-1:0]                    axis_eth_tx_tready,
  input  wire [PORT_COUNT-1:0]                    axis_eth_tx_tlast,
  input  wire [PORT_COUNT*AXIS_TX_USER_WIDTH-1:0] axis_eth_tx_tuser,

  output wire [PORT_COUNT*PTP_TS_WIDTH-1:0]       axis_eth_tx_ptp_ts,
  output wire [PORT_COUNT*TX_TAG_WIDTH-1:0]       axis_eth_tx_ptp_ts_tag,
  output wire [PORT_COUNT-1:0]                    axis_eth_tx_ptp_ts_valid,
  input  wire [PORT_COUNT-1:0]                    axis_eth_tx_ptp_ts_ready,

  input  wire [PORT_COUNT-1:0]                    eth_tx_enable,
  output wire [PORT_COUNT-1:0]                    eth_tx_status,
  input  wire [PORT_COUNT-1:0]                    eth_tx_lfc_en,
  input  wire [PORT_COUNT-1:0]                    eth_tx_lfc_req,
  input  wire [PORT_COUNT*8-1:0]                  eth_tx_pfc_en,
  input  wire [PORT_COUNT*8-1:0]                  eth_tx_pfc_req,

  output wire [PORT_COUNT-1:0]                    eth_rx_clk,
  output wire [PORT_COUNT-1:0]                    eth_rx_rst,

  output wire [PORT_COUNT-1:0]                    eth_rx_ptp_clk,
  output wire [PORT_COUNT-1:0]                    eth_rx_ptp_rst,
  input  wire [PORT_COUNT*PTP_TS_WIDTH-1:0]       eth_rx_ptp_ts,
  input  wire [PORT_COUNT-1:0]                    eth_rx_ptp_ts_step,

  output wire [PORT_COUNT*AXIS_DATA_WIDTH-1:0]    axis_eth_rx_tdata,
  output wire [PORT_COUNT*AXIS_KEEP_WIDTH-1:0]    axis_eth_rx_tkeep,
  output wire [PORT_COUNT-1:0]                    axis_eth_rx_tvalid,
  input  wire [PORT_COUNT-1:0]                    axis_eth_rx_tready,
  output wire [PORT_COUNT-1:0]                    axis_eth_rx_tlast,
  output wire [PORT_COUNT*AXIS_RX_USER_WIDTH-1:0] axis_eth_rx_tuser,

  input  wire [PORT_COUNT-1:0]                    eth_rx_enable,
  output wire [PORT_COUNT-1:0]                    eth_rx_status,
  input  wire [PORT_COUNT-1:0]                    eth_rx_lfc_en,
  output wire [PORT_COUNT-1:0]                    eth_rx_lfc_req,
  input  wire [PORT_COUNT-1:0]                    eth_rx_lfc_ack,
  input  wire [PORT_COUNT*8-1:0]                  eth_rx_pfc_en,
  output wire [PORT_COUNT*8-1:0]                  eth_rx_pfc_req,
  input  wire [PORT_COUNT*8-1:0]                  eth_rx_pfc_ack,

  /*
  * I2C
  */
  input  wire                                     i2c_scl_i,
  output wire                                     i2c_scl_o,
  output wire                                     i2c_scl_t,
  input  wire                                     i2c_sda_i,
  output wire                                     i2c_sda_o,
  output wire                                     i2c_sda_t,

  /*
  * QSPI flash
  */
  output wire                                     fpga_boot,
  output wire                                     qspi_clk,
  input  wire [3:0]                               qspi_0_dq_i,
  output wire [3:0]                               qspi_0_dq_o,
  output wire [3:0]                               qspi_0_dq_oe,
  output wire                                     qspi_0_cs,
  input  wire [3:0]                               qspi_1_dq_i,
  output wire [3:0]                               qspi_1_dq_o,
  output wire [3:0]                               qspi_1_dq_oe,
  output wire                                     qspi_1_cs
);

  genvar n;

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  // FPGA TOP
  ////////////////////////////////////////////////////////////////////////////////////////////////////

  // QSFP DRP
  wire [QSFP_CNT*24-1:0]              qsfp_drp_addr;
  wire [QSFP_CNT*16-1:0]              qsfp_drp_di;
  wire [QSFP_CNT-1:0]                 qsfp_drp_en;
  wire [QSFP_CNT-1:0]                 qsfp_drp_we;
  wire [QSFP_CNT*16-1:0]              qsfp_drp_do;
  wire [QSFP_CNT-1:0]                 qsfp_drp_rdy;

  // Ethernet
  wire [QSFP_CNT-1:0]                 qsfp_tx_clk;
  wire [QSFP_CNT-1:0]                 qsfp_tx_rst;

  wire [QSFP_CNT*AXIS_DATA_WIDTH-1:0] qsfp_tx_axis_tdata;
  wire [QSFP_CNT*AXIS_KEEP_WIDTH-1:0] qsfp_tx_axis_tkeep;
  wire [QSFP_CNT-1:0]                 qsfp_tx_axis_tvalid;
  wire [QSFP_CNT-1:0]                 qsfp_tx_axis_tready;
  wire [QSFP_CNT-1:0]                 qsfp_tx_axis_tlast;
  wire [QSFP_CNT*(16+1)-1:0]          qsfp_tx_axis_tuser;

  wire [QSFP_CNT*80-1:0]              qsfp_tx_ptp_time;
  wire [QSFP_CNT*80-1:0]              qsfp_tx_ptp_ts;
  wire [QSFP_CNT*16-1:0]              qsfp_tx_ptp_ts_tag;
  wire [QSFP_CNT-1:0]                 qsfp_tx_ptp_ts_valid;

  wire [QSFP_CNT-1:0]                 qsfp_tx_enable;
  wire [QSFP_CNT-1:0]                 qsfp_tx_lfc_en;
  wire [QSFP_CNT-1:0]                 qsfp_tx_lfc_req;
  wire [QSFP_CNT*8-1:0]               qsfp_tx_pfc_en;
  wire [QSFP_CNT*8-1:0]               qsfp_tx_pfc_req;

  wire [QSFP_CNT-1:0]                 qsfp_rx_clk;
  wire [QSFP_CNT-1:0]                 qsfp_rx_rst;

  wire [QSFP_CNT*AXIS_DATA_WIDTH-1:0] qsfp_rx_axis_tdata;
  wire [QSFP_CNT*AXIS_KEEP_WIDTH-1:0] qsfp_rx_axis_tkeep;
  wire [QSFP_CNT-1:0]                 qsfp_rx_axis_tvalid;
  wire [QSFP_CNT-1:0]                 qsfp_rx_axis_tlast;
  wire [QSFP_CNT*(80+1)-1:0]          qsfp_rx_axis_tuser;

  wire [QSFP_CNT-1:0]                 qsfp_rx_ptp_clk;
  wire [QSFP_CNT-1:0]                 qsfp_rx_ptp_rst;
  wire [QSFP_CNT*80-1:0]              qsfp_rx_ptp_time;

  wire [QSFP_CNT-1:0]                 qsfp_rx_enable;
  wire [QSFP_CNT-1:0]                 qsfp_rx_status;
  wire [QSFP_CNT-1:0]                 qsfp_rx_lfc_en;
  wire [QSFP_CNT-1:0]                 qsfp_rx_lfc_req;
  wire [QSFP_CNT-1:0]                 qsfp_rx_lfc_ack;
  wire [QSFP_CNT*8-1:0]               qsfp_rx_pfc_en;
  wire [QSFP_CNT*8-1:0]               qsfp_rx_pfc_req;
  wire [QSFP_CNT*8-1:0]               qsfp_rx_pfc_ack;

  generate

    for (n = 0; n < QSFP_CNT; n = n + 1) begin : qsfp

      sync_reset #(
        .N(4)
      ) qsfp_sync_reset_inst (
        .clk(qsfp_mgt_refclk_bufg[n +: 1]),
        .rst(rst_125mhz),
        .out(qsfp_rst[n +: 1]));

      cmac_gty_wrapper #(
        .DRP_CLK_FREQ_HZ(125000000),
        .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
        .AXIS_KEEP_WIDTH(AXIS_KEEP_WIDTH),
        .TX_SERDES_PIPELINE(0),
        .RX_SERDES_PIPELINE(0),
        .RX_CLK_FROM_TX(ETH_RX_CLK_FROM_TX),
        .RS_FEC_ENABLE(ETH_RS_FEC_ENABLE)
      ) qsfp_cmac_inst (
        .xcvr_ctrl_clk(clk_125mhz),
        .xcvr_ctrl_rst(qsfp_rst[n +: 1]),

        /*
        * Common
        */
        .xcvr_gtpowergood_out(qsfp_gtpowergood[n +: 1]),
        .xcvr_ref_clk(qsfp_mgt_refclk[n +: 1]),

        /*
        * DRP
        */
        .drp_clk(qsfp_drp_clk[n +: 1]),
        .drp_rst(qsfp_drp_rst[n +: 1]),
        .drp_addr(qsfp_drp_addr[n*24 +: 24]),
        .drp_di(qsfp_drp_di[n*16 +: 16]),
        .drp_en(qsfp_drp_en[n +: 1]),
        .drp_we(qsfp_drp_we[n +: 1]),
        .drp_do(qsfp_drp_do[n*16 +: 16]),
        .drp_rdy(qsfp_drp_rdy[n +: 1]),

        /*
        * Serial data
        */
        .xcvr_txp(qsfp_tx_p[n*4 +: 4]),
        .xcvr_txn(qsfp_tx_n[n*4 +: 4]),
        .xcvr_rxp(qsfp_rx_p[n*4 +: 4]),
        .xcvr_rxn(qsfp_rx_n[n*4 +: 4]),

        /*
        * CMAC connections
        */
        .tx_clk(qsfp_tx_clk[n +: 1]),
        .tx_rst(qsfp_tx_rst[n +: 1]),

        .tx_axis_tdata(qsfp_tx_axis_tdata[n*AXIS_DATA_WIDTH +: AXIS_DATA_WIDTH]),
        .tx_axis_tkeep(qsfp_tx_axis_tkeep[n*AXIS_KEEP_WIDTH +: AXIS_KEEP_WIDTH]),
        .tx_axis_tvalid(qsfp_tx_axis_tvalid[n +: 1]),
        .tx_axis_tready(qsfp_tx_axis_tready[n +: 1]),
        .tx_axis_tlast(qsfp_tx_axis_tlast[n +: 1]),
        .tx_axis_tuser(qsfp_tx_axis_tuser[n*(16+1) +: (16+1)]),

        .tx_ptp_time(qsfp_tx_ptp_time[n*80 +: 80]),
        .tx_ptp_ts(qsfp_tx_ptp_ts[n*80 +: 80]),
        .tx_ptp_ts_tag(qsfp_tx_ptp_ts_tag[n*16 +: 16]),
        .tx_ptp_ts_valid(qsfp_tx_ptp_ts_valid[n +: 1]),

        .tx_enable(qsfp_tx_enable[n +: 1]),
        .tx_lfc_en(qsfp_tx_lfc_en[n +: 1]),
        .tx_lfc_req(qsfp_tx_lfc_req[n +: 1]),
        .tx_pfc_en(qsfp_tx_pfc_en[n*8 +: 8]),
        .tx_pfc_req(qsfp_tx_pfc_req[n*8 +: 8]),

        .rx_clk(qsfp_rx_clk[n +: 1]),
        .rx_rst(qsfp_rx_rst[n +: 1]),

        .rx_axis_tdata(qsfp_rx_axis_tdata[n*AXIS_DATA_WIDTH +: AXIS_DATA_WIDTH]),
        .rx_axis_tkeep(qsfp_rx_axis_tkeep[n*AXIS_KEEP_WIDTH +: AXIS_KEEP_WIDTH]),
        .rx_axis_tvalid(qsfp_rx_axis_tvalid[n +: 1]),
        .rx_axis_tlast(qsfp_rx_axis_tlast[n +: 1]),
        .rx_axis_tuser(qsfp_rx_axis_tuser[n*(80+1) +: (80+1)]),

        .rx_ptp_clk(qsfp_rx_ptp_clk[n +: 1]),
        .rx_ptp_rst(qsfp_rx_ptp_rst[n +: 1]),
        .rx_ptp_time(qsfp_rx_ptp_time[n*80 +: 80]),

        .rx_enable(qsfp_rx_enable[n +: 1]),
        .rx_status(qsfp_rx_status[n +: 1]),
        .rx_lfc_en(qsfp_rx_lfc_en[n +: 1]),
        .rx_lfc_req(qsfp_rx_lfc_req[n +: 1]),
        .rx_lfc_ack(qsfp_rx_lfc_ack[n +: 1]),
        .rx_pfc_en(qsfp_rx_pfc_en[n*8 +: 8]),
        .rx_pfc_req(qsfp_rx_pfc_req[n*8 +: 8]),
        .rx_pfc_ack(qsfp_rx_pfc_ack[n*8 +: 8]));

      sync_signal #(
        .WIDTH(2),
        .N(2)
      ) sync_signal_inst (
        .clk(clk),
        .in({qsfp_modprsl[n +: 1], qsfp_intl[n +: 1]}),
        .out({qsfp_modprsl_int[n +: 1], qsfp_intl_int[n +: 1]}));

    end

  endgenerate

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  // FPGA CORE IMPLEMENTATION
  ////////////////////////////////////////////////////////////////////////////////////////////////////

  localparam RB_BASE_ADDR = 16'h1000;
  localparam RBB = RB_BASE_ADDR & {AXIL_CTRL_ADDR_WIDTH{1'b1}};

  // VCU118 base
  localparam RB_DRP_QSFP_BASE = RB_BASE_ADDR + 16'h40;

  initial begin
    if (PORT_COUNT > QSFP_CNT) begin
      $error("Error: Max port count exceeded (instance %m)");
      $finish;
    end
  end

  wire [QSFP_CNT-1:0] qsfp_drp_reg_wr_wait;
  wire [QSFP_CNT-1:0] qsfp_drp_reg_wr_ack;
  wire [(AXIL_CTRL_DATA_WIDTH*QSFP_CNT)-1:0] qsfp_drp_reg_rd_data;
  wire [QSFP_CNT-1:0] qsfp_drp_reg_rd_wait;
  wire [QSFP_CNT-1:0] qsfp_drp_reg_rd_ack;

  reg ctrl_reg_wr_ack_reg = 1'b0;
  reg [AXIL_CTRL_DATA_WIDTH-1:0] ctrl_reg_rd_data_reg = {AXIL_CTRL_DATA_WIDTH{1'b0}};
  reg ctrl_reg_rd_ack_reg = 1'b0;

  reg [QSFP_CNT-1:0] qsfp_reset_reg = {QSFP_CNT{1'b0}};
  reg [QSFP_CNT-1:0] qsfp_lpmode_reg = {QSFP_CNT{1'b0}};

  wire [QSFP_CNT-1:0] qsfp_modprsl_int;
  wire [QSFP_CNT-1:0] qsfp_intl_int;

  reg i2c_scl_o_reg = 1'b1;
  reg i2c_sda_o_reg = 1'b1;

  reg fpga_boot_reg = 1'b0;

  reg qspi_clk_reg = 1'b0;
  reg qspi_0_cs_reg = 1'b1;
  reg [3:0] qspi_0_dq_o_reg = 4'd0;
  reg [3:0] qspi_0_dq_oe_reg = 4'd0;

  reg qspi_1_cs_reg = 1'b1;
  reg [3:0] qspi_1_dq_o_reg = 4'd0;
  reg [3:0] qspi_1_dq_oe_reg = 4'd0;

  reg ctrl_reg_wr_wait_cmb;
  reg ctrl_reg_wr_ack_cmb;
  reg [AXIL_CTRL_DATA_WIDTH-1:0] ctrl_reg_rd_data_cmb;
  reg ctrl_reg_rd_wait_cmb;
  reg ctrl_reg_rd_ack_cmb;

  assign ctrl_reg_wr_wait = ctrl_reg_wr_wait_cmb;
  assign ctrl_reg_wr_ack = ctrl_reg_wr_ack_cmb;
  assign ctrl_reg_rd_data = ctrl_reg_rd_data_cmb;
  assign ctrl_reg_rd_wait = ctrl_reg_rd_wait_cmb;
  assign ctrl_reg_rd_ack = ctrl_reg_rd_ack_cmb;

  integer k;

  always @* begin
    ctrl_reg_wr_wait_cmb = 1'b0;
    ctrl_reg_wr_ack_cmb = ctrl_reg_wr_ack_reg;
    ctrl_reg_rd_data_cmb = ctrl_reg_rd_data_reg;
    ctrl_reg_rd_wait_cmb = 1'b0;
    ctrl_reg_rd_ack_cmb = ctrl_reg_rd_ack_reg;

    for (k = 0; k < QSFP_CNT; k = k + 1) begin
      ctrl_reg_wr_wait_cmb = ctrl_reg_wr_wait_cmb | qsfp_drp_reg_wr_wait[k];
      ctrl_reg_wr_ack_cmb = ctrl_reg_wr_ack_cmb | qsfp_drp_reg_wr_ack[k];
      ctrl_reg_rd_data_cmb = ctrl_reg_rd_data_cmb | qsfp_drp_reg_rd_data[k*AXIL_CTRL_DATA_WIDTH +: AXIL_CTRL_DATA_WIDTH];
      ctrl_reg_rd_wait_cmb = ctrl_reg_rd_wait_cmb | qsfp_drp_reg_rd_wait[k];
      ctrl_reg_rd_ack_cmb = ctrl_reg_rd_ack_cmb | qsfp_drp_reg_rd_ack[k];
    end
  end

  assign qsfp_modsell = {QSFP_CNT{1'b0}};
  assign qsfp_resetl = ~qsfp_reset_reg;
  assign qsfp_lpmode = qsfp_lpmode_reg;

  assign i2c_scl_o = i2c_scl_o_reg;
  assign i2c_scl_t = i2c_scl_o_reg;
  assign i2c_sda_o = i2c_sda_o_reg;
  assign i2c_sda_t = i2c_sda_o_reg;

  assign fpga_boot = fpga_boot_reg;

  assign qspi_clk = qspi_clk_reg;
  assign qspi_0_cs = qspi_0_cs_reg;
  assign qspi_0_dq_o = qspi_0_dq_o_reg;
  assign qspi_0_dq_oe = qspi_0_dq_oe_reg;

  assign qspi_1_cs = qspi_1_cs_reg;
  assign qspi_1_dq_o = qspi_1_dq_o_reg;
  assign qspi_1_dq_oe = qspi_1_dq_oe_reg;

  integer i;

  always @(posedge clk) begin
    ctrl_reg_wr_ack_reg <= 1'b0;
    ctrl_reg_rd_data_reg <= {AXIL_CTRL_DATA_WIDTH{1'b0}};
    ctrl_reg_rd_ack_reg <= 1'b0;

    if (ctrl_reg_wr_en && !ctrl_reg_wr_ack_reg) begin
      // write operation
      ctrl_reg_wr_ack_reg <= 1'b0;
      case ({ctrl_reg_wr_addr >> 2, 2'b00})
        // FW ID
        8'h0C: begin
          // FW ID: FPGA JTAG ID
          fpga_boot_reg <= ctrl_reg_wr_data == 32'hFEE1DEAD;
        end
        // I2C 0
        RBB+8'h0C: begin
          // I2C ctrl: control
          if (ctrl_reg_wr_strb[0]) begin
            i2c_scl_o_reg <= ctrl_reg_wr_data[1];
          end
          if (ctrl_reg_wr_strb[1]) begin
            i2c_sda_o_reg <= ctrl_reg_wr_data[9];
          end
        end
        // XCVR GPIO
        RBB+8'h1C: begin
          // XCVR GPIO: control 0123
          if (ctrl_reg_wr_strb[0]) begin
            qsfp_reset_reg[0] <= ctrl_reg_wr_data[4];
            qsfp_lpmode_reg[0] <= ctrl_reg_wr_data[5];
          end
          // if (ctrl_reg_wr_strb[1]) begin
          //   qsfp_reset_reg[1] <= ctrl_reg_wr_data[12];
          //   qsfp_lpmode_reg[1] <= ctrl_reg_wr_data[13];
          // end
        end
        // QSPI flash
        RBB+8'h2C: begin
          // SPI flash ctrl: format
          fpga_boot_reg <= ctrl_reg_wr_data == 32'hFEE1DEAD;
        end
        RBB+8'h30: begin
          // SPI flash ctrl: control 0
          if (ctrl_reg_wr_strb[0]) begin
            qspi_0_dq_o_reg <= ctrl_reg_wr_data[3:0];
          end
          if (ctrl_reg_wr_strb[1]) begin
            qspi_0_dq_oe_reg <= ctrl_reg_wr_data[11:8];
          end
          if (ctrl_reg_wr_strb[2]) begin
            qspi_clk_reg <= ctrl_reg_wr_data[16];
            qspi_0_cs_reg <= ctrl_reg_wr_data[17];
          end
        end
        RBB+8'h34: begin
          // SPI flash ctrl: control 1
          if (ctrl_reg_wr_strb[0]) begin
            qspi_1_dq_o_reg <= ctrl_reg_wr_data[3:0];
          end
          if (ctrl_reg_wr_strb[1]) begin
            qspi_1_dq_oe_reg <= ctrl_reg_wr_data[11:8];
          end
          if (ctrl_reg_wr_strb[2]) begin
            qspi_clk_reg <= ctrl_reg_wr_data[16];
            qspi_1_cs_reg <= ctrl_reg_wr_data[17];
          end
        end
        default: ctrl_reg_wr_ack_reg <= 1'b0;
      endcase
    end

    if (ctrl_reg_rd_en && !ctrl_reg_rd_ack_reg) begin
      // read operation
      ctrl_reg_rd_ack_reg <= 1'b1;
      case ({ctrl_reg_rd_addr >> 2, 2'b00})
        // I2C 0
        RBB+8'h00: ctrl_reg_rd_data_reg <= 32'h0000C110;             // I2C ctrl: Type
        RBB+8'h04: ctrl_reg_rd_data_reg <= 32'h00000100;             // I2C ctrl: Version
        RBB+8'h08: ctrl_reg_rd_data_reg <= RB_BASE_ADDR+8'h10;       // I2C ctrl: Next header
        RBB+8'h0C: begin
          // I2C ctrl: control
          ctrl_reg_rd_data_reg[0] <= i2c_scl_i;
          ctrl_reg_rd_data_reg[1] <= i2c_scl_o_reg;
          ctrl_reg_rd_data_reg[8] <= i2c_sda_i;
          ctrl_reg_rd_data_reg[9] <= i2c_sda_o_reg;
        end
        // XCVR GPIO
        RBB+8'h10: ctrl_reg_rd_data_reg <= 32'h0000C101;             // XCVR GPIO: Type
        RBB+8'h14: ctrl_reg_rd_data_reg <= 32'h00000100;             // XCVR GPIO: Version
        RBB+8'h18: ctrl_reg_rd_data_reg <= RB_BASE_ADDR+8'h20;       // XCVR GPIO: Next header
        RBB+8'h1C: begin
          // XCVR GPIO: control 0123
          ctrl_reg_rd_data_reg[0] <= !qsfp_modprsl_int[0];
          ctrl_reg_rd_data_reg[1] <= !qsfp_intl_int[0];
          ctrl_reg_rd_data_reg[4] <= qsfp_reset_reg[0];
          ctrl_reg_rd_data_reg[5] <= qsfp_lpmode_reg[0];
          // ctrl_reg_rd_data_reg[8] <= !qsfp_modprsl_int[1];
          // ctrl_reg_rd_data_reg[9] <= !qsfp_intl_int[1];
          // ctrl_reg_rd_data_reg[12] <= qsfp_reset_reg[1];
          // ctrl_reg_rd_data_reg[13] <= qsfp_lpmode_reg[1];
        end
        // QSPI flash
        RBB+8'h20: ctrl_reg_rd_data_reg <= 32'h0000C120;             // SPI flash ctrl: Type
        RBB+8'h24: ctrl_reg_rd_data_reg <= 32'h00000200;             // SPI flash ctrl: Version
        RBB+8'h28: ctrl_reg_rd_data_reg <= RB_DRP_QSFP_BASE;        // SPI flash ctrl: Next header
        RBB+8'h2C: begin
          // SPI flash ctrl: format
          ctrl_reg_rd_data_reg[3:0]   <= 2;                   // configuration (two segments)
          ctrl_reg_rd_data_reg[7:4]   <= 1;                   // default segment
          ctrl_reg_rd_data_reg[11:8]  <= 0;                   // fallback segment
          ctrl_reg_rd_data_reg[31:12] <= 32'h00000000 >> 12;  // first segment size (even split)
        end
        RBB+8'h30: begin
          // SPI flash ctrl: control 0
          ctrl_reg_rd_data_reg[3:0] <= qspi_0_dq_i;
          ctrl_reg_rd_data_reg[11:8] <= qspi_0_dq_oe;
          ctrl_reg_rd_data_reg[16] <= qspi_clk;
          ctrl_reg_rd_data_reg[17] <= qspi_0_cs;
        end
        RBB+8'h34: begin
          // SPI flash ctrl: control 1
          ctrl_reg_rd_data_reg[3:0] <= qspi_1_dq_i;
          ctrl_reg_rd_data_reg[11:8] <= qspi_1_dq_oe;
          ctrl_reg_rd_data_reg[16] <= qspi_clk;
          ctrl_reg_rd_data_reg[17] <= qspi_1_cs;
        end
        default: ctrl_reg_rd_ack_reg <= 1'b0;
      endcase
    end

    if (rst) begin
      ctrl_reg_wr_ack_reg <= 1'b0;
      ctrl_reg_rd_ack_reg <= 1'b0;

      qsfp_reset_reg <= {QSFP_CNT{1'b0}};
      qsfp_lpmode_reg <= {QSFP_CNT{1'b0}};

      i2c_scl_o_reg <= 1'b1;
      i2c_sda_o_reg <= 1'b1;

      fpga_boot_reg <= 1'b0;

      qspi_clk_reg <= 1'b0;
      qspi_0_cs_reg <= 1'b1;
      qspi_0_dq_o_reg <= 4'd0;
      qspi_0_dq_oe_reg <= 4'd0;
      qspi_1_cs_reg <= 1'b1;
      qspi_1_dq_o_reg <= 4'd0;
      qspi_1_dq_oe_reg <= 4'd0;
    end
  end

  generate

    for (n = 0; n < QSFP_CNT; n = n + 1) begin : drp

      rb_drp #(
        .DRP_ADDR_WIDTH(24),
        .DRP_DATA_WIDTH(16),
        .DRP_INFO({8'h09, 8'h03, 8'd2, 8'd4}),
        .REG_ADDR_WIDTH(AXIL_CSR_ADDR_WIDTH),
        .REG_DATA_WIDTH(AXIL_CTRL_DATA_WIDTH),
        .REG_STRB_WIDTH(AXIL_CTRL_STRB_WIDTH),
        .RB_BASE_ADDR(RB_DRP_QSFP_BASE + n*16'h20),
        .RB_NEXT_PTR(RB_DRP_QSFP_BASE + (n+1)*16'h20)
      ) qsfp_rb_drp_inst (
        .clk(clk),
        .rst(rst),

        /*
        * Register interface
        */
        .reg_wr_addr(ctrl_reg_wr_addr),
        .reg_wr_data(ctrl_reg_wr_data),
        .reg_wr_strb(ctrl_reg_wr_strb),
        .reg_wr_en(ctrl_reg_wr_en),
        .reg_wr_wait(qsfp_drp_reg_wr_wait[n +: 1]),
        .reg_wr_ack(qsfp_drp_reg_wr_ack[n +: 1]),
        .reg_rd_addr(ctrl_reg_rd_addr),
        .reg_rd_en(ctrl_reg_rd_en),
        .reg_rd_data(qsfp_drp_reg_rd_data[n*AXIL_CTRL_DATA_WIDTH +: AXIL_CTRL_DATA_WIDTH]),
        .reg_rd_wait(qsfp_drp_reg_rd_wait[n +: 1]),
        .reg_rd_ack(qsfp_drp_reg_rd_ack[n +: 1]),

        /*
        * DRP
        */
        .drp_clk(qsfp_drp_clk[n +: 1]),
        .drp_rst(qsfp_drp_rst[n +: 1]),
        .drp_addr(qsfp_drp_addr[n*24 +: 24]),
        .drp_di(qsfp_drp_di[n*16 +: 16]),
        .drp_en(qsfp_drp_en[n +: 1]),
        .drp_we(qsfp_drp_we[n +: 1]),
        .drp_do(qsfp_drp_do[n*16 +: 16]),
        .drp_rdy(qsfp_drp_rdy[n +: 1]));

    end

  endgenerate

  wire [QSFP_CNT*AXIS_TX_USER_WIDTH-1:0]    qsfp_tx_axis_tuser_int;
  wire [QSFP_CNT*PTP_TS_WIDTH-1:0]              qsfp_tx_ptp_time_int;
  wire [QSFP_CNT*PTP_TS_WIDTH-1:0]              qsfp_tx_ptp_ts_int;

  wire [QSFP_CNT*AXIS_RX_USER_WIDTH-1:0]    qsfp_rx_axis_tuser_int;
  wire [QSFP_CNT*PTP_TS_WIDTH-1:0]              qsfp_rx_ptp_time_int;

  generate

  for (n = 0; n < QSFP_CNT; n = n + 1) begin
    assign qsfp_tx_axis_tuser_int[n*AXIS_TX_USER_WIDTH +: AXIS_TX_USER_WIDTH] = qsfp_tx_axis_tuser[n*(16+1) +: 16+1];
    assign qsfp_tx_ptp_time[n*80 +: 80] = qsfp_tx_ptp_time_int[n*PTP_TS_WIDTH +: PTP_TS_WIDTH];
    assign qsfp_tx_ptp_ts_int[n*PTP_TS_WIDTH +: PTP_TS_WIDTH] = qsfp_tx_ptp_ts[n*80 +: PTP_TS_WIDTH];

    assign qsfp_rx_axis_tuser_int[n*AXIS_RX_USER_WIDTH +: AXIS_RX_USER_WIDTH] = qsfp_rx_axis_tuser[n*81 +: AXIS_RX_USER_WIDTH];
    assign qsfp_rx_ptp_time[n*80 +: 80] = qsfp_rx_ptp_time_int[n*PTP_TS_WIDTH +: PTP_TS_WIDTH];
  end

  endgenerate

  mqnic_port_map_mac_axis #(
    .MAC_COUNT(QSFP_CNT),
    .PORT_MASK(PORT_MASK),
    .PORT_GROUP_SIZE(1),

    .IF_COUNT(IF_COUNT),
    .PORTS_PER_IF(PORTS_PER_IF),

    .PORT_COUNT(PORT_COUNT),

    .PTP_TS_WIDTH(PTP_TS_WIDTH),
    .PTP_TAG_WIDTH(TX_TAG_WIDTH),
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
    .AXIS_KEEP_WIDTH(AXIS_KEEP_WIDTH),
    .AXIS_TX_USER_WIDTH(AXIS_TX_USER_WIDTH),
    .AXIS_RX_USER_WIDTH(AXIS_RX_USER_WIDTH)
  ) mqnic_port_map_mac_axis_inst (
    // towards MAC
    .mac_tx_clk(qsfp_tx_clk),
    .mac_tx_rst(qsfp_tx_rst),

    .mac_tx_ptp_clk({QSFP_CNT{1'b0}}),
    .mac_tx_ptp_rst({QSFP_CNT{1'b0}}),
    .mac_tx_ptp_ts_96(qsfp_tx_ptp_time_int),
    .mac_tx_ptp_ts_step(),

    .m_axis_mac_tx_tdata(qsfp_tx_axis_tdata),
    .m_axis_mac_tx_tkeep(qsfp_tx_axis_tkeep),
    .m_axis_mac_tx_tvalid(qsfp_tx_axis_tvalid),
    .m_axis_mac_tx_tready(qsfp_tx_axis_tready),
    .m_axis_mac_tx_tlast(qsfp_tx_axis_tlast),
    .m_axis_mac_tx_tuser(qsfp_tx_axis_tuser),

    .s_axis_mac_tx_ptp_ts(qsfp_tx_ptp_ts_int),
    .s_axis_mac_tx_ptp_ts_tag(qsfp_tx_ptp_ts_tag),
    .s_axis_mac_tx_ptp_ts_valid(qsfp_tx_ptp_ts_valid),
    .s_axis_mac_tx_ptp_ts_ready(),

    .mac_tx_enable(qsfp_tx_enable),
    .mac_tx_status({QSFP_CNT{1'b1}}),
    .mac_tx_lfc_en(qsfp_tx_lfc_en),
    .mac_tx_lfc_req(qsfp_tx_lfc_req),
    .mac_tx_pfc_en(qsfp_tx_pfc_en),
    .mac_tx_pfc_req(qsfp_tx_pfc_req),

    .mac_rx_clk(qsfp_rx_clk),
    .mac_rx_rst(qsfp_rx_rst),

    .mac_rx_ptp_clk(qsfp_rx_ptp_clk),
    .mac_rx_ptp_rst(qsfp_rx_ptp_rst),
    .mac_rx_ptp_ts_96(qsfp_rx_ptp_time_int),
    .mac_rx_ptp_ts_step(),

    .s_axis_mac_rx_tdata(qsfp_rx_axis_tdata),
    .s_axis_mac_rx_tkeep(qsfp_rx_axis_tkeep),
    .s_axis_mac_rx_tvalid(qsfp_rx_axis_tvalid),
    .s_axis_mac_rx_tready(),
    .s_axis_mac_rx_tlast(qsfp_rx_axis_tlast),
    .s_axis_mac_rx_tuser(qsfp_rx_axis_tuser_int),

    .mac_rx_enable(qsfp_rx_enable),
    .mac_rx_status(qsfp_rx_status),
    .mac_rx_lfc_en(qsfp_rx_lfc_en),
    .mac_rx_lfc_req(qsfp_rx_lfc_req),
    .mac_rx_lfc_ack(qsfp_rx_lfc_ack),
    .mac_rx_pfc_en(qsfp_rx_pfc_en),
    .mac_rx_pfc_req(qsfp_rx_pfc_req),
    .mac_rx_pfc_ack(qsfp_rx_pfc_ack),

    // towards datapath
    .tx_clk(eth_tx_clk),
    .tx_rst(eth_tx_rst),

    .tx_ptp_clk(eth_tx_ptp_clk),
    .tx_ptp_rst(eth_tx_ptp_rst),
    .tx_ptp_ts_96(eth_tx_ptp_ts),
    .tx_ptp_ts_step(eth_tx_ptp_ts_step),

    .s_axis_tx_tdata(axis_eth_tx_tdata),
    .s_axis_tx_tkeep(axis_eth_tx_tkeep),
    .s_axis_tx_tvalid(axis_eth_tx_tvalid),
    .s_axis_tx_tready(axis_eth_tx_tready),
    .s_axis_tx_tlast(axis_eth_tx_tlast),
    .s_axis_tx_tuser(axis_eth_tx_tuser),

    .m_axis_tx_ptp_ts(axis_eth_tx_ptp_ts),
    .m_axis_tx_ptp_ts_tag(axis_eth_tx_ptp_ts_tag),
    .m_axis_tx_ptp_ts_valid(axis_eth_tx_ptp_ts_valid),
    .m_axis_tx_ptp_ts_ready(axis_eth_tx_ptp_ts_ready),

    .tx_enable(eth_tx_enable),
    .tx_status(eth_tx_status),
    .tx_lfc_en(eth_tx_lfc_en),
    .tx_lfc_req(eth_tx_lfc_req),
    .tx_pfc_en(eth_tx_pfc_en),
    .tx_pfc_req(eth_tx_pfc_req),

    .rx_clk(eth_rx_clk),
    .rx_rst(eth_rx_rst),

    .rx_ptp_clk(eth_rx_ptp_clk),
    .rx_ptp_rst(eth_rx_ptp_rst),
    .rx_ptp_ts_96(eth_rx_ptp_ts),
    .rx_ptp_ts_step(eth_rx_ptp_ts_step),

    .m_axis_rx_tdata(axis_eth_rx_tdata),
    .m_axis_rx_tkeep(axis_eth_rx_tkeep),
    .m_axis_rx_tvalid(axis_eth_rx_tvalid),
    .m_axis_rx_tready(axis_eth_rx_tready),
    .m_axis_rx_tlast(axis_eth_rx_tlast),
    .m_axis_rx_tuser(axis_eth_rx_tuser),

    .rx_enable(eth_rx_enable),
    .rx_status(eth_rx_status),
    .rx_lfc_en(eth_rx_lfc_en),
    .rx_lfc_req(eth_rx_lfc_req),
    .rx_lfc_ack(eth_rx_lfc_ack),
    .rx_pfc_en(eth_rx_pfc_en),
    .rx_pfc_req(eth_rx_pfc_req),
    .rx_pfc_ack(eth_rx_pfc_ack));

endmodule
