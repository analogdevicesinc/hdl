// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2019-2023 The Regents of the University of California
 * Copyright (c) 2021-2023 MissingLinkElectronics Inc.
 */

// Language: Verilog 2001

`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * FPGA top-level module
 */
module nic_phy #(
  parameter DUMMY_PARAM =0
)(
    /*
     * Clock: 125MHz LVDS
     */
    input  wire         ctrl_clk,
    input  wire         ctrl_rst,
    output wire         ptp_mgt_refclk,

//    output wire         sfp_gtpowergood,
//    input  wire         clk_125mhz_p,
//    input  wire         clk_125mhz_n,
//    input  wire         clk_user_si570_p,
//    input  wire         clk_user_si570_n,

    /*
     * Ethernet: SFP+
     */
    input  wire         sfp0_rx_p,
    input  wire         sfp0_rx_n,
    output wire         sfp0_tx_p,
    output wire         sfp0_tx_n,
    input  wire         sfp1_rx_p,
    input  wire         sfp1_rx_n,
    output wire         sfp1_tx_p,
    output wire         sfp1_tx_n,
    input  wire         sfp2_rx_p,
    input  wire         sfp2_rx_n,
    output wire         sfp2_tx_p,
    output wire         sfp2_tx_n,
    input  wire         sfp3_rx_p,
    input  wire         sfp3_rx_n,
    output wire         sfp3_tx_p,
    output wire         sfp3_tx_n,

    output wire         sfp0_tx_clk,
    output wire         sfp0_tx_rst,
    input  wire [63:0]  sfp0_txd,
    input  wire [7:0]   sfp0_txc,
    input  wire         sfp0_tx_prbs31_enable,
    output wire         sfp0_rx_clk,
    output wire         sfp0_rx_rst,
    output wire [63:0]  sfp0_rxd,
    output wire [7:0]   sfp0_rxc,
    input  wire         sfp0_rx_prbs31_enable,
    output wire [6:0]   sfp0_rx_error_count,
    output wire         sfp0_rx_status,

    output wire         sfp1_tx_clk,
    output wire         sfp1_tx_rst,
    input  wire [63:0]  sfp1_txd,
    input  wire [7:0]   sfp1_txc,
    input  wire         sfp1_tx_prbs31_enable,
    output wire         sfp1_rx_clk,
    output wire         sfp1_rx_rst,
    output wire [63:0]  sfp1_rxd,
    output wire [7:0]   sfp1_rxc,
    input  wire         sfp1_rx_prbs31_enable,
    output wire [6:0]   sfp1_rx_error_count,
    output wire         sfp1_rx_status,

    output wire         sfp2_tx_clk,
    output wire         sfp2_tx_rst,
    input  wire [63:0]  sfp2_txd,
    input  wire [7:0]   sfp2_txc,
    input  wire         sfp2_tx_prbs31_enable,
    output wire         sfp2_rx_clk,
    output wire         sfp2_rx_rst,
    output wire [63:0]  sfp2_rxd,
    output wire [7:0]   sfp2_rxc,
    input  wire         sfp2_rx_prbs31_enable,
    output wire [6:0]   sfp2_rx_error_count,
    output wire         sfp2_rx_status,

    output wire         sfp3_tx_clk,
    output wire         sfp3_tx_rst,
    input  wire [63:0]  sfp3_txd,
    input  wire [7:0]   sfp3_txc,
    input  wire         sfp3_tx_prbs31_enable,
    output wire         sfp3_rx_clk,
    output wire         sfp3_rx_rst,
    output wire [63:0]  sfp3_rxd,
    output wire [7:0]   sfp3_rxc,
    input  wire         sfp3_rx_prbs31_enable,
    output wire [6:0]   sfp3_rx_error_count,
    output wire         sfp3_rx_status,

    input  wire         sfp_mgt_refclk_0_p,
    input  wire         sfp_mgt_refclk_0_n,

    input  wire         sfp_drp_clk,
    input  wire         sfp_drp_rst, //mmcm locked
    input  wire [23:0]  sfp_drp_addr,
    input  wire [15:0]  sfp_drp_di,
    input  wire         sfp_drp_en,
    input  wire         sfp_drp_we,
    output wire [15:0]  sfp_drp_do,
    output wire         sfp_drp_rdy

);

// PTP configuration
localparam PTP_CLK_PERIOD_NS_NUM = 32;
localparam PTP_CLK_PERIOD_NS_DENOM = 5;
localparam PTP_TS_WIDTH = 96;
localparam PTP_USE_SAMPLE_CLOCK = 1;
localparam IF_PTP_PERIOD_NS = 6'h6;
localparam IF_PTP_PERIOD_FNS = 16'h6666;

// Interface configuration
localparam TX_TAG_WIDTH = 16;

// RAM configuration
//localparam AXI_DDR_STRB_WIDTH = (AXI_DDR_DATA_WIDTH/8);

// Ethernet interface configuration
localparam XGMII_DATA_WIDTH = 64;
localparam XGMII_CTRL_WIDTH = XGMII_DATA_WIDTH/8;
localparam AXIS_ETH_DATA_WIDTH = XGMII_DATA_WIDTH;
localparam AXIS_ETH_KEEP_WIDTH = AXIS_ETH_DATA_WIDTH/8;
localparam AXIS_ETH_SYNC_DATA_WIDTH = AXIS_ETH_DATA_WIDTH;
localparam AXIS_ETH_TX_USER_WIDTH = TX_TAG_WIDTH + 1;
//localparam AXIS_ETH_RX_USER_WIDTH = (PTP_TS_ENABLE ? PTP_TS_WIDTH : 0) + 1;

// Clock and reset

//wire clk_125mhz_ibufg;
//wire clk_125mhz_bufg;
//wire clk_125mhz_mmcm_out;

// Internal 125 MHz clock
//wire clk_125mhz_int;
//wire rst_125mhz_int;

//wire mmcm_rst;// = core_rst;
//wire mmcm_locked;
//wire mmcm_clkfb;

//IBUFGDS #(
//   .DIFF_TERM("FALSE"),
//   .IBUF_LOW_PWR("FALSE")
//)
//clk_125mhz_ibufg_inst (
//   .O   (clk_125mhz_ibufg),
//   .I   (clk_125mhz_p),
//  .IB  (clk_125mhz_n)
//);

//BUFG
//clk_125mhz_bufg_in_inst (
//    .I(clk_125mhz_ibufg),
//    .O(clk_125mhz_bufg)
//);

// MMCM instance
// 125 MHz in, 125 MHz out
// PFD range: 10 MHz to 500 MHz
// VCO range: 800 MHz to 1600 MHz
// M = 8, D = 1 sets Fvco = 1000 MHz
// Divide by 8 to get output frequency of 125 MHz
//MMCME4_BASE #(
//    .BANDWIDTH("OPTIMIZED"),
//    .CLKOUT0_DIVIDE_F(8),
//    .CLKOUT0_DUTY_CYCLE(0.5),
//    .CLKOUT0_PHASE(0),
//    .CLKOUT1_DIVIDE(1),
//    .CLKOUT1_DUTY_CYCLE(0.5),
//    .CLKOUT1_PHASE(0),
//    .CLKOUT2_DIVIDE(1),
//    .CLKOUT2_DUTY_CYCLE(0.5),
//    .CLKOUT2_PHASE(0),
//    .CLKOUT3_DIVIDE(1),
//    .CLKOUT3_DUTY_CYCLE(0.5),
//    .CLKOUT3_PHASE(0),
//    .CLKOUT4_DIVIDE(1),
//    .CLKOUT4_DUTY_CYCLE(0.5),
//    .CLKOUT4_PHASE(0),
//    .CLKOUT5_DIVIDE(1),
//    .CLKOUT5_DUTY_CYCLE(0.5),
//    .CLKOUT5_PHASE(0),
//    .CLKOUT6_DIVIDE(1),
//    .CLKOUT6_DUTY_CYCLE(0.5),
//    .CLKOUT6_PHASE(0),
//    .CLKFBOUT_MULT_F(8),
//    .CLKFBOUT_PHASE(0),
//    .DIVCLK_DIVIDE(1),
//    .REF_JITTER1(0.010),
//    .CLKIN1_PERIOD(8.0),
//    .STARTUP_WAIT("FALSE"),
//    .CLKOUT4_CASCADE("FALSE")
//)
//clk_mmcm_inst (
//    .CLKIN1(clk_125mhz_bufg),
//    .CLKFBIN(mmcm_clkfb),
//    .RST(mmcm_rst),
//    .PWRDWN(1'b0),
//    .CLKOUT0(clk_125mhz_mmcm_out), clk_125mhz
//    .CLKOUT0B(),
//    .CLKOUT1(),
//    .CLKOUT1B(),
//    .CLKOUT2(),
//    .CLKOUT2B(),
//    .CLKOUT3(),
//    .CLKOUT3B(),
//    .CLKOUT4(),
//    .CLKOUT5(),
//    .CLKOUT6(),
//    .CLKFBOUT(mmcm_clkfb),
//    .CLKFBOUTB(),
//    .LOCKED(mmcm_locked)
//);


// MOVE TO BD
//BUFG
//clk_125mhz_bufg_inst (
//    .I(clk_125mhz_mmcm_out),
//    .O(clk_125mhz_int)
//);

//sync_reset #(
//    .N(4)
//)
//sync_reset_125mhz_inst (
//    .clk(clk_125mhz_int),
//    .rst(~mmcm_locked),
//    .out(rst_125mhz_int)
//);

// Zynq AXI MM
//wire [IRQ_COUNT-1:0]                 irq;

//reg [(IRQ_COUNT*IRQ_STRETCH)-1:0] irq_stretch = {(IRQ_COUNT*IRQ_STRETCH){1'b0}};
//always @(posedge core_clk) begin
//    if (core_rst) begin
//        irq_stretch <= {(IRQ_COUNT*IRQ_STRETCH){1'b0}};
//    end else begin
//        /* IRQ shift vector */
//        irq_stretch <= {irq_stretch[0 +: (IRQ_COUNT*IRQ_STRETCH)-IRQ_COUNT], irq};
//    end
//end

//reg [IRQ_COUNT-1:0] zynq_irq;
//integer i, k;
//always @* begin
//    for (k = 0; k < IRQ_COUNT; k = k + 1) begin
//        zynq_irq[k] = 1'b0;
//        for (i = 0; i < (IRQ_COUNT*IRQ_STRETCH); i = i + IRQ_COUNT) begin
//            zynq_irq[k] = zynq_irq[k] | irq_stretch[k + i];
//        end
//    end
//end

//assign core_irq_7 = zynq_irq[7];
//assign core_irq_6 = zynq_irq[6];
//assign core_irq_5 = zynq_irq[5];
//assign core_irq_4 = zynq_irq[4];
//assign core_irq_3 = zynq_irq[3];
//assign core_irq_2 = zynq_irq[2];
//assign core_irq_1 = zynq_irq[1];
//assign core_irq_0 = zynq_irq[0];


// XGMII 10G PHY
wire                         sfp0_tx_clk_int;
wire                         sfp0_tx_rst_int;
wire [XGMII_DATA_WIDTH-1:0]  sfp0_txd_int;
wire [XGMII_CTRL_WIDTH-1:0]  sfp0_txc_int;
wire                         sfp0_tx_prbs31_enable_int;
wire                         sfp0_rx_clk_int;
wire                         sfp0_rx_rst_int;
wire [XGMII_DATA_WIDTH-1:0]  sfp0_rxd_int;
wire [XGMII_CTRL_WIDTH-1:0]  sfp0_rxc_int;
wire                         sfp0_rx_prbs31_enable_int;
wire [6:0]                   sfp0_rx_error_count_int;

wire                         sfp1_tx_clk_int;
wire                         sfp1_tx_rst_int;
wire [XGMII_DATA_WIDTH-1:0]  sfp1_txd_int;
wire [XGMII_CTRL_WIDTH-1:0]  sfp1_txc_int;
wire                         sfp1_tx_prbs31_enable_int;
wire                         sfp1_rx_clk_int;
wire                         sfp1_rx_rst_int;
wire [XGMII_DATA_WIDTH-1:0]  sfp1_rxd_int;
wire [XGMII_CTRL_WIDTH-1:0]  sfp1_rxc_int;
wire                         sfp1_rx_prbs31_enable_int;
wire [6:0]                   sfp1_rx_error_count_int;

wire                         sfp2_tx_clk_int;
wire                         sfp2_tx_rst_int;
wire [XGMII_DATA_WIDTH-1:0]  sfp2_txd_int;
wire [XGMII_CTRL_WIDTH-1:0]  sfp2_txc_int;
wire                         sfp2_tx_prbs31_enable_int;
wire                         sfp2_rx_clk_int;
wire                         sfp2_rx_rst_int;
wire [XGMII_DATA_WIDTH-1:0]  sfp2_rxd_int;
wire [XGMII_CTRL_WIDTH-1:0]  sfp2_rxc_int;
wire                         sfp2_rx_prbs31_enable_int;
wire [6:0]                   sfp2_rx_error_count_int;

wire                         sfp3_tx_clk_int;
wire                         sfp3_tx_rst_int;
wire [XGMII_DATA_WIDTH-1:0]  sfp3_txd_int;
wire [XGMII_CTRL_WIDTH-1:0]  sfp3_txc_int;
wire                         sfp3_tx_prbs31_enable_int;
wire                         sfp3_rx_clk_int;
wire                         sfp3_rx_rst_int;
wire [XGMII_DATA_WIDTH-1:0]  sfp3_rxd_int;
wire [XGMII_CTRL_WIDTH-1:0]  sfp3_rxc_int;
wire                         sfp3_rx_prbs31_enable_int;
wire [6:0]                   sfp3_rx_error_count_int;

//wire        sfp_drp_clk = clk_125mhz_int;
//wire        sfp_drp_rst = rst_125mhz_int;
//wire [23:0] sfp_drp_addr;
//wire [15:0] sfp_drp_di;
//wire        sfp_drp_en;
//wire        sfp_drp_we;
//wire [15:0] sfp_drp_do;
//wire        sfp_drp_rdy;

//wire sfp0_rx_block_lock;
//wire sfp0_rx_status;
//wire sfp1_rx_block_lock;
//wire sfp1_rx_status;
//wire sfp2_rx_block_lock;
//wire sfp2_rx_status;
//wire sfp3_rx_block_lock;
//wire sfp3_rx_status;

wire sfp_gtpowergood;

wire sfp_mgt_refclk_0;
wire sfp_mgt_refclk_0_int;
wire sfp_mgt_refclk_0_bufg;

assign ptp_mgt_refclk = sfp_mgt_refclk_0_bufg;

IBUFDS_GTE4 ibufds_gte4_sfp_mgt_refclk_0_inst (
    .I     (sfp_mgt_refclk_0_p),
    .IB    (sfp_mgt_refclk_0_n),
    .CEB   (1'b0),
    .O     (sfp_mgt_refclk_0),
    .ODIV2 (sfp_mgt_refclk_0_int)
);

BUFG_GT bufg_gt_sfp_mgt_refclk_0_inst (
    .CE      (sfp_gtpowergood),
    .CEMASK  (1'b1),
    .CLR     (1'b0),
    .CLRMASK (1'b1),
    .DIV     (3'd0),
    .I       (sfp_mgt_refclk_0_int),
    .O       (sfp_mgt_refclk_0_bufg)
);

//wire sfp_rst;  now ctrl_rst

//sync_reset #(
//    .N(4)
//)
//sfp_sync_reset_inst (
//    .clk(sfp_mgt_refclk_0_bufg),
//    .rst(rst_125mhz_int),
//    .out(sfp_rst)
//);


eth_xcvr_phy_10g_gty_quad_wrapper #(
    .GT_GTH(1),
    .PRBS31_ENABLE(1)
)
sfp_phy_quad_inst (
    .xcvr_ctrl_clk(ctrl_clk), //clk_125mhz
    .xcvr_ctrl_rst(ctrl_rst),

    /*
     * Common
     */
    .xcvr_gtpowergood_out(sfp_gtpowergood), //output
    .xcvr_ref_clk(sfp_mgt_refclk_0), //input

    /*
     * DRP - CORE
     */
    .drp_clk(sfp_drp_clk),
    .drp_rst(sfp_drp_rst),
    .drp_addr(sfp_drp_addr),
    .drp_di(sfp_drp_di),
    .drp_en(sfp_drp_en),
    .drp_we(sfp_drp_we),
    .drp_do(sfp_drp_do),
    .drp_rdy(sfp_drp_rdy),

    /*
     * Serial data
     */
    .xcvr_txp({sfp3_tx_p, sfp2_tx_p, sfp1_tx_p, sfp0_tx_p}),
    .xcvr_txn({sfp3_tx_n, sfp2_tx_n, sfp1_tx_n, sfp0_tx_n}),
    .xcvr_rxp({sfp3_rx_p, sfp2_rx_p, sfp1_rx_p, sfp0_rx_p}),
    .xcvr_rxn({sfp3_rx_n, sfp2_rx_n, sfp1_rx_n, sfp0_rx_n}),

    /*
     * PHY connections
     */
    .phy_1_tx_clk(sfp0_tx_clk),
    .phy_1_tx_rst(sfp0_tx_rst),
    .phy_1_xgmii_txd(sfp0_txd),
    .phy_1_xgmii_txc(sfp0_txc),
    .phy_1_rx_clk(sfp0_rx_clk),
    .phy_1_rx_rst(sfp0_rx_rst),
    .phy_1_xgmii_rxd(sfp0_rxd),
    .phy_1_xgmii_rxc(sfp0_rxc),
    .phy_1_tx_bad_block(),
    .phy_1_rx_error_count(sfp0_rx_error_count),
    .phy_1_rx_bad_block(),
    .phy_1_rx_sequence_error(),
    .phy_1_rx_block_lock(),
    .phy_1_rx_high_ber(),
    .phy_1_rx_status(sfp0_rx_status),
    .phy_1_tx_prbs31_enable(sfp0_tx_prbs31_enable),
    .phy_1_rx_prbs31_enable(sfp0_rx_prbs31_enable),

    .phy_2_tx_clk(sfp1_tx_clk),
    .phy_2_tx_rst(sfp1_tx_rst),
    .phy_2_xgmii_txd(sfp1_txd),
    .phy_2_xgmii_txc(sfp1_txc),
    .phy_2_rx_clk(sfp1_rx_clk),
    .phy_2_rx_rst(sfp1_rx_rst),
    .phy_2_xgmii_rxd(sfp1_rxd),
    .phy_2_xgmii_rxc(sfp1_rxc),
    .phy_2_tx_bad_block(),
    .phy_2_rx_error_count(sfp1_rx_error_count),
    .phy_2_rx_bad_block(),
    .phy_2_rx_sequence_error(),
    .phy_2_rx_block_lock(),
    .phy_2_rx_high_ber(),
    .phy_2_rx_status(sfp1_rx_status),
    .phy_2_tx_prbs31_enable(sfp1_tx_prbs31_enable),
    .phy_2_rx_prbs31_enable(sfp1_rx_prbs31_enable),

    .phy_3_tx_clk(sfp2_tx_clk),
    .phy_3_tx_rst(sfp2_tx_rst),
    .phy_3_xgmii_txd(sfp2_txd),
    .phy_3_xgmii_txc(sfp2_txc),
    .phy_3_rx_clk(sfp2_rx_clk),
    .phy_3_rx_rst(sfp2_rx_rst),
    .phy_3_xgmii_rxd(sfp2_rxd),
    .phy_3_xgmii_rxc(sfp2_rxc),
    .phy_3_tx_bad_block(),
    .phy_3_rx_error_count(sfp2_rx_error_count),
    .phy_3_rx_bad_block(),
    .phy_3_rx_sequence_error(),
    .phy_3_rx_block_lock(),
    .phy_3_rx_high_ber(),
    .phy_3_rx_status(sfp2_rx_status),
    .phy_3_tx_prbs31_enable(sfp2_tx_prbs31_enable),
    .phy_3_rx_prbs31_enable(sfp2_rx_prbs31_enable),

    .phy_4_tx_clk(sfp3_tx_clk),
    .phy_4_tx_rst(sfp3_tx_rst),
    .phy_4_xgmii_txd(sfp3_txd),
    .phy_4_xgmii_txc(sfp3_txc),
    .phy_4_rx_clk(sfp3_rx_clk),
    .phy_4_rx_rst(sfp3_rx_rst),
    .phy_4_xgmii_rxd(sfp3_rxd),
    .phy_4_xgmii_rxc(sfp3_rxc),
    .phy_4_tx_bad_block(),
    .phy_4_rx_error_count(sfp3_rx_error_count),
    .phy_4_rx_bad_block(),
    .phy_4_rx_sequence_error(),
    .phy_4_rx_block_lock(),
    .phy_4_rx_high_ber(),
    .phy_4_rx_status(sfp3_rx_status),
    .phy_4_tx_prbs31_enable(sfp3_tx_prbs31_enable),
    .phy_4_rx_prbs31_enable(sfp3_rx_prbs31_enable)
);

endmodule

`resetall
