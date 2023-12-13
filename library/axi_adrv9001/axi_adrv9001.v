// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

module axi_adrv9001 #(
  parameter ID = 0,
  parameter CMOS_LVDS_N = 0,
  parameter TDD_DISABLE = 0,
  parameter DDS_DISABLE = 0,
  parameter INDEPENDENT_1R1T_SUPPORT = 1,
  parameter COMMON_2R2T_SUPPORT = 1,
  parameter DISABLE_RX2_SSI = 0,
  parameter DISABLE_TX2_SSI = 0,
  parameter RX_USE_BUFG = 0,
  parameter TX_USE_BUFG = 0,
  parameter IODELAY_CTRL = 1,
  parameter IODELAY_ENABLE = 1,
  parameter IO_DELAY_GROUP = "dev_if_delay_group",
  parameter FPGA_TECHNOLOGY = 0,
  parameter FPGA_FAMILY = 0,
  parameter SPEED_GRADE = 0,
  parameter DEV_PACKAGE = 0,
  parameter EXT_SYNC = 0,
  parameter USE_RX_CLK_FOR_TX = 0
) (
  input                   ref_clk,
  input                   mssi_sync,
  input                   tx_output_enable,

  // external synchronization signals
  input                   adc_sync_in,
  input                   dac_sync_in,

  // physical interface
  input                   rx1_dclk_in_n_NC,
  input                   rx1_dclk_in_p_dclk_in,
  input                   rx1_idata_in_n_idata0,
  input                   rx1_idata_in_p_idata1,
  input                   rx1_qdata_in_n_qdata2,
  input                   rx1_qdata_in_p_qdata3,
  input                   rx1_strobe_in_n_NC,
  input                   rx1_strobe_in_p_strobe_in,

  input                   rx2_dclk_in_n_NC,
  input                   rx2_dclk_in_p_dclk_in,
  input                   rx2_idata_in_n_idata0,
  input                   rx2_idata_in_p_idata1,
  input                   rx2_qdata_in_n_qdata2,
  input                   rx2_qdata_in_p_qdata3,
  input                   rx2_strobe_in_n_NC,
  input                   rx2_strobe_in_p_strobe_in,

  output                  tx1_dclk_out_n_NC,
  output                  tx1_dclk_out_p_dclk_out,
  input                   tx1_dclk_in_n_NC,
  input                   tx1_dclk_in_p_dclk_in,
  output                  tx1_idata_out_n_idata0,
  output                  tx1_idata_out_p_idata1,
  output                  tx1_qdata_out_n_qdata2,
  output                  tx1_qdata_out_p_qdata3,
  output                  tx1_strobe_out_n_NC,
  output                  tx1_strobe_out_p_strobe_out,

  output                  tx2_dclk_out_n_NC,
  output                  tx2_dclk_out_p_dclk_out,
  input                   tx2_dclk_in_n_NC,
  input                   tx2_dclk_in_p_dclk_in,
  output                  tx2_idata_out_n_idata0,
  output                  tx2_idata_out_p_idata1,
  output                  tx2_qdata_out_n_qdata2,
  output                  tx2_qdata_out_p_qdata3,
  output                  tx2_strobe_out_n_NC,
  output                  tx2_strobe_out_p_strobe_out,

  output                  rx1_enable,
  output                  rx2_enable,
  output                  tx1_enable,
  output                  tx2_enable,

  input                   delay_clk,

  // user interface

  output                  adc_1_clk,
  output                  adc_1_rst,

  output                  adc_1_valid_i0,
  output                  adc_1_enable_i0,
  output      [15:0]      adc_1_data_i0,
  output                  adc_1_valid_q0,
  output                  adc_1_enable_q0,
  output      [15:0]      adc_1_data_q0,
  output                  adc_1_valid_i1,
  output                  adc_1_enable_i1,
  output      [15:0]      adc_1_data_i1,
  output                  adc_1_valid_q1,
  output                  adc_1_enable_q1,
  output      [15:0]      adc_1_data_q1,
  input                   adc_1_dovf,

  output                  adc_2_clk,
  output                  adc_2_rst,
  output                  adc_2_valid_i0,
  output                  adc_2_enable_i0,
  output      [15:0]      adc_2_data_i0,
  output                  adc_2_valid_q0,
  output                  adc_2_enable_q0,
  output      [15:0]      adc_2_data_q0,
  input                   adc_2_dovf,

  output                  dac_1_clk,
  output                  dac_1_rst,
  output                  dac_1_valid_i0,
  output                  dac_1_enable_i0,
  input       [15:0]      dac_1_data_i0,
  output                  dac_1_valid_q0,
  output                  dac_1_enable_q0,
  input       [15:0]      dac_1_data_q0,
  output                  dac_1_valid_i1,
  output                  dac_1_enable_i1,
  input       [15:0]      dac_1_data_i1,
  output                  dac_1_valid_q1,
  output                  dac_1_enable_q1,
  input       [15:0]      dac_1_data_q1,
  input                   dac_1_dunf,

  output                  dac_2_clk,
  output                  dac_2_rst,
  output                  dac_2_valid_i0,
  output                  dac_2_enable_i0,
  input       [15:0]      dac_2_data_i0,
  output                  dac_2_valid_q0,
  output                  dac_2_enable_q0,
  input       [15:0]      dac_2_data_q0,
  input                   dac_2_dunf,

  // TDD interface
  input                   tdd_sync,
  output                  tdd_sync_cntr,

  input                   gpio_rx1_enable_in,
  input                   gpio_rx2_enable_in,
  input                   gpio_tx1_enable_in,
  input                   gpio_tx2_enable_in,

  // axi interface
  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input       [15:0]      s_axi_awaddr,
  output                  s_axi_awready,
  input                   s_axi_wvalid,
  input       [31:0]      s_axi_wdata,
  input       [ 3:0]      s_axi_wstrb,
  output                  s_axi_wready,
  output                  s_axi_bvalid,
  output      [ 1:0]      s_axi_bresp,
  input                   s_axi_bready,
  input                   s_axi_arvalid,
  input       [15:0]      s_axi_araddr,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [ 1:0]      s_axi_rresp,
  output      [31:0]      s_axi_rdata,
  input                   s_axi_rready,
  input       [ 2:0]      s_axi_awprot,
  input       [ 2:0]      s_axi_arprot
);

  localparam  SEVEN_SERIES  = 1;
  localparam  ULTRASCALE  = 2;
  localparam  ULTRASCALE_PLUS  = 3;

  localparam DRP_WIDTH = FPGA_TECHNOLOGY == ULTRASCALE      ? 9 :
                         FPGA_TECHNOLOGY == ULTRASCALE_PLUS ? 9 : 5;

  localparam NUM_LANES = CMOS_LVDS_N ? 5 : 3;

  // internal signals
  wire            up_wreq_s;
  wire            up_rreq_s;
  wire    [13:0]  up_waddr_s;
  wire    [13:0]  up_raddr_s;
  wire    [31:0]  up_wdata_s;
  wire    [31:0]  up_rdata_s;
  wire            up_wack_s;
  wire            up_rack_s;

  wire    [15:0]  rx1_data_i;
  wire    [15:0]  rx1_data_q;
  wire            rx1_data_valid;
  wire            rx1_single_lane;
  wire            rx1_sdr_ddr_n;
  wire            rx1_symb_op;
  wire            rx1_symb_8_16b;
  wire    [15:0]  rx2_data_i;
  wire    [15:0]  rx2_data_q;
  wire            rx2_data_valid;
  wire            rx2_single_lane;
  wire            rx2_sdr_ddr_n;
  wire            rx2_symb_op;
  wire            rx2_symb_8_16b;

  wire    [15:0]  tx1_data_i;
  wire    [15:0]  tx1_data_q;
  wire            tx1_data_valid;
  wire            tx1_single_lane;
  wire            tx1_sdr_ddr_n;
  wire            tx1_symb_op;
  wire            tx1_symb_8_16b;
  wire    [15:0]  tx2_data_i;
  wire    [15:0]  tx2_data_q;
  wire            tx2_data_valid;
  wire            tx2_single_lane;
  wire            tx2_sdr_ddr_n;
  wire            tx2_symb_op;
  wire            tx2_symb_8_16b;

  wire            adc_1_valid;
  wire            adc_2_valid;
  wire            dac_1_valid;
  wire            dac_2_valid;

  // internal clocks & resets
  wire            up_rstn;
  wire            up_clk;

  // clock/reset assignments
  assign up_clk  = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  wire    [NUM_LANES-1:0]           up_rx1_dld;
  wire    [DRP_WIDTH*NUM_LANES-1:0] up_rx1_dwdata;
  wire    [DRP_WIDTH*NUM_LANES-1:0] up_rx1_drdata;
  wire    [NUM_LANES-1:0]           up_rx2_dld;
  wire    [DRP_WIDTH*NUM_LANES-1:0] up_rx2_dwdata;
  wire    [DRP_WIDTH*NUM_LANES-1:0] up_rx2_drdata;
  wire                              delay_rx1_rst;
  wire                              delay_rx2_rst;
  wire                              delay_rx1_locked;
  wire                              delay_rx2_locked;
  wire                       [31:0] adc_clk_ratio;
  wire                       [31:0] dac_clk_ratio;

  axi_adrv9001_if #(
    .CMOS_LVDS_N (CMOS_LVDS_N),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .NUM_LANES (NUM_LANES),
    .DRP_WIDTH (DRP_WIDTH),
    .RX_USE_BUFG (RX_USE_BUFG),
    .TX_USE_BUFG (TX_USE_BUFG),
    .IODELAY_CTRL (IODELAY_CTRL),
    .IODELAY_ENABLE (IODELAY_ENABLE),
    .IO_DELAY_GROUP (IO_DELAY_GROUP),
    .DISABLE_RX2_SSI (DISABLE_RX2_SSI),
    .DISABLE_TX2_SSI (DISABLE_TX2_SSI),
    .USE_RX_CLK_FOR_TX (USE_RX_CLK_FOR_TX)
  ) i_if (

    //
    // Physical interface
    //
    .ref_clk (ref_clk),
    .mssi_sync (mssi_sync),
    .tx_output_enable (tx_output_enable),

    .rx1_dclk_in_n_NC (rx1_dclk_in_n_NC),
    .rx1_dclk_in_p_dclk_in (rx1_dclk_in_p_dclk_in),
    .rx1_idata_in_n_idata0 (rx1_idata_in_n_idata0),
    .rx1_idata_in_p_idata1 (rx1_idata_in_p_idata1),
    .rx1_qdata_in_n_qdata2 (rx1_qdata_in_n_qdata2),
    .rx1_qdata_in_p_qdata3 (rx1_qdata_in_p_qdata3),
    .rx1_strobe_in_n_NC (rx1_strobe_in_n_NC),
    .rx1_strobe_in_p_strobe_in (rx1_strobe_in_p_strobe_in),

    .rx2_dclk_in_n_NC (rx2_dclk_in_n_NC),
    .rx2_dclk_in_p_dclk_in (rx2_dclk_in_p_dclk_in),
    .rx2_idata_in_n_idata0 (rx2_idata_in_n_idata0),
    .rx2_idata_in_p_idata1 (rx2_idata_in_p_idata1),
    .rx2_qdata_in_n_qdata2 (rx2_qdata_in_n_qdata2),
    .rx2_qdata_in_p_qdata3 (rx2_qdata_in_p_qdata3),
    .rx2_strobe_in_n_NC (rx2_strobe_in_n_NC),
    .rx2_strobe_in_p_strobe_in (rx2_strobe_in_p_strobe_in),

    .tx1_dclk_out_n_NC (tx1_dclk_out_n_NC),
    .tx1_dclk_out_p_dclk_out (tx1_dclk_out_p_dclk_out),
    .tx1_dclk_in_n_NC (tx1_dclk_in_n_NC),
    .tx1_dclk_in_p_dclk_in (tx1_dclk_in_p_dclk_in),
    .tx1_idata_out_n_idata0 (tx1_idata_out_n_idata0),
    .tx1_idata_out_p_idata1 (tx1_idata_out_p_idata1),
    .tx1_qdata_out_n_qdata2 (tx1_qdata_out_n_qdata2),
    .tx1_qdata_out_p_qdata3 (tx1_qdata_out_p_qdata3),
    .tx1_strobe_out_n_NC (tx1_strobe_out_n_NC),
    .tx1_strobe_out_p_strobe_out (tx1_strobe_out_p_strobe_out),

    .tx2_dclk_out_n_NC (tx2_dclk_out_n_NC),
    .tx2_dclk_out_p_dclk_out (tx2_dclk_out_p_dclk_out),
    .tx2_dclk_in_n_NC (tx2_dclk_in_n_NC),
    .tx2_dclk_in_p_dclk_in (tx2_dclk_in_p_dclk_in),
    .tx2_idata_out_n_idata0 (tx2_idata_out_n_idata0),
    .tx2_idata_out_p_idata1 (tx2_idata_out_p_idata1),
    .tx2_qdata_out_n_qdata2 (tx2_qdata_out_n_qdata2),
    .tx2_qdata_out_p_qdata3 (tx2_qdata_out_p_qdata3),
    .tx2_strobe_out_n_NC (tx2_strobe_out_n_NC),
    .tx2_strobe_out_p_strobe_out (tx2_strobe_out_p_strobe_out),

    //
    // Control interface
    //

    // delay interface (for IDELAY macros)
    .delay_clk (delay_clk),
    .delay_rx1_rst (delay_rx1_rst),
    .delay_rx2_rst (delay_rx2_rst),
    .delay_rx1_locked (delay_rx1_locked),
    .delay_rx2_locked (delay_rx2_locked),
    .up_clk (up_clk),
    .up_rx1_dld (up_rx1_dld),
    .up_rx1_dwdata (up_rx1_dwdata),
    .up_rx1_drdata (up_rx1_drdata),

    .up_rx2_dld (up_rx2_dld),
    .up_rx2_dwdata (up_rx2_dwdata),
    .up_rx2_drdata (up_rx2_drdata),

    //
    // Transport layer interface
    //

    // ADC interface
    .adc_clk_ratio (adc_clk_ratio),
    .rx1_clk (adc_1_clk),
    .rx1_rst (adc_1_rst),
    .rx1_data_valid (rx1_data_valid),
    .rx1_data_i (rx1_data_i),
    .rx1_data_q (rx1_data_q),

    .rx1_single_lane (rx1_single_lane),
    .rx1_sdr_ddr_n (rx1_sdr_ddr_n),
    .rx1_symb_op (rx1_symb_op),
    .rx1_symb_8_16b (rx1_symb_8_16b),

    .rx2_clk (adc_2_clk),
    .rx2_rst (adc_2_rst),
    .rx2_data_valid (rx2_data_valid),
    .rx2_data_i (rx2_data_i),
    .rx2_data_q (rx2_data_q),

    .rx2_single_lane (rx2_single_lane),
    .rx2_sdr_ddr_n (rx2_sdr_ddr_n),
    .rx2_symb_op (rx2_symb_op),
    .rx2_symb_8_16b (rx2_symb_8_16b),

    // DAC interface
    .dac_clk_ratio (dac_clk_ratio),
    .tx1_clk (dac_1_clk),
    .tx1_rst (dac_1_rst),
    .tx1_data_valid (tx1_data_valid),
    .tx1_data_i (tx1_data_i),
    .tx1_data_q (tx1_data_q),

    .tx1_single_lane (tx1_single_lane),
    .tx1_sdr_ddr_n (tx1_sdr_ddr_n),
    .tx1_symb_op (tx1_symb_op),
    .tx1_symb_8_16b (tx1_symb_8_16b),

    .tx2_clk (dac_2_clk),
    .tx2_rst (dac_2_rst),
    .tx2_data_valid (tx2_data_valid),
    .tx2_data_i (tx2_data_i),
    .tx2_data_q (tx2_data_q),

    .tx2_single_lane (tx2_single_lane),
    .tx2_sdr_ddr_n (tx2_sdr_ddr_n),
    .tx2_symb_op (tx2_symb_op),
    .tx2_symb_8_16b (tx2_symb_8_16b));

  // common processor control
  axi_adrv9001_core #(
    .ID (ID),
    .NUM_LANES (NUM_LANES),
    .CMOS_LVDS_N (CMOS_LVDS_N),
    .USE_RX_CLK_FOR_TX (USE_RX_CLK_FOR_TX),
    .DRP_WIDTH (DRP_WIDTH),
    .TDD_DISABLE (TDD_DISABLE),
    .DDS_DISABLE (DDS_DISABLE),
    .INDEPENDENT_1R1T_SUPPORT (INDEPENDENT_1R1T_SUPPORT),
    .COMMON_2R2T_SUPPORT (COMMON_2R2T_SUPPORT),
    .DISABLE_RX2_SSI (DISABLE_RX2_SSI),
    .DISABLE_TX2_SSI (DISABLE_TX2_SSI),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .EXT_SYNC (EXT_SYNC)
  ) i_core (
    // ADC interface
    .rx1_clk (adc_1_clk),
    .rx1_rst (adc_1_rst),
    .rx1_data_valid (rx1_data_valid),
    .rx1_data_i (rx1_data_i),
    .rx1_data_q (rx1_data_q),

    .rx1_single_lane (rx1_single_lane),
    .rx1_sdr_ddr_n (rx1_sdr_ddr_n),
    .rx1_symb_op (rx1_symb_op),
    .rx1_symb_8_16b (rx1_symb_8_16b),

    .rx2_clk (adc_2_clk),
    .rx2_rst (adc_2_rst),
    .rx2_data_valid (rx2_data_valid),
    .rx2_data_i (rx2_data_i),
    .rx2_data_q (rx2_data_q),

    .rx2_single_lane (rx2_single_lane),
    .rx2_sdr_ddr_n (rx2_sdr_ddr_n),
    .rx2_symb_op (rx2_symb_op),
    .rx2_symb_8_16b (rx2_symb_8_16b),

    .adc_clk_ratio (adc_clk_ratio),

    //DAC interface
    .tx1_clk (dac_1_clk),
    .tx1_rst (dac_1_rst),
    .tx1_data_valid (tx1_data_valid),
    .tx1_data_i (tx1_data_i),
    .tx1_data_q (tx1_data_q),

    .tx1_single_lane (tx1_single_lane),
    .tx1_sdr_ddr_n (tx1_sdr_ddr_n),
    .tx1_symb_op (tx1_symb_op),
    .tx1_symb_8_16b (tx1_symb_8_16b),

    .tx2_clk (dac_2_clk),
    .tx2_rst (dac_2_rst),
    .tx2_data_valid (tx2_data_valid),
    .tx2_data_i (tx2_data_i),
    .tx2_data_q (tx2_data_q),

    .tx2_single_lane (tx2_single_lane),
    .tx2_sdr_ddr_n (tx2_sdr_ddr_n),
    .tx2_symb_op (tx2_symb_op),
    .tx2_symb_8_16b (tx2_symb_8_16b),

    .dac_clk_ratio (dac_clk_ratio),
    //
    // User layer interface
    //
    .adc_1_valid (adc_1_valid),
    .adc_1_enable_i0 (adc_1_enable_i0),
    .adc_1_data_i0 (adc_1_data_i0),
    .adc_1_enable_q0 (adc_1_enable_q0),
    .adc_1_data_q0 (adc_1_data_q0),
    .adc_1_enable_i1 (adc_1_enable_i1),
    .adc_1_data_i1 (adc_1_data_i1),
    .adc_1_enable_q1 (adc_1_enable_q1),
    .adc_1_data_q1 (adc_1_data_q1),
    .adc_1_dovf (adc_1_dovf),

    .adc_2_valid (adc_2_valid),
    .adc_2_enable_i (adc_2_enable_i0),
    .adc_2_data_i (adc_2_data_i0),
    .adc_2_enable_q (adc_2_enable_q0),
    .adc_2_data_q (adc_2_data_q0),
    .adc_2_dovf (adc_2_dovf),

    .dac_1_valid (dac_1_valid),
    .dac_1_enable_i0 (dac_1_enable_i0),
    .dac_1_data_i0 (dac_1_data_i0),
    .dac_1_enable_q0 (dac_1_enable_q0),
    .dac_1_data_q0 (dac_1_data_q0),
    .dac_1_enable_i1 (dac_1_enable_i1),
    .dac_1_data_i1 (dac_1_data_i1),
    .dac_1_enable_q1 (dac_1_enable_q1),
    .dac_1_data_q1 (dac_1_data_q1),
    .dac_1_dunf (dac_1_dunf),

    .dac_2_valid (dac_2_valid),
    .dac_2_enable_i0 (dac_2_enable_i0),
    .dac_2_data_i0 (dac_2_data_i0),
    .dac_2_enable_q0 (dac_2_enable_q0),
    .dac_2_data_q0 (dac_2_data_q0),
    .dac_2_dunf (dac_2_dunf),

    .delay_clk (delay_clk),

    .up_rx1_dld (up_rx1_dld),
    .up_rx1_dwdata (up_rx1_dwdata),
    .up_rx1_drdata (up_rx1_drdata),
    .delay_rx1_rst (delay_rx1_rst),
    .delay_rx1_locked (delay_rx1_locked),

    .up_rx2_dld (up_rx2_dld),
    .up_rx2_dwdata (up_rx2_dwdata),
    .up_rx2_drdata (up_rx2_drdata),
    .delay_rx2_rst (delay_rx2_rst),
    .delay_rx2_locked (delay_rx2_locked),

    // TDD interface
    .tdd_sync (tdd_sync),
    .tdd_sync_cntr (tdd_sync_cntr),
    .tdd_rx1_rf_en (tdd_rx1_rf_en),
    .tdd_tx1_rf_en (tdd_tx1_rf_en),
    .tdd_if1_mode (tdd_if1_mode),
    .tdd_rx2_rf_en (tdd_rx2_rf_en),
    .tdd_tx2_rf_en (tdd_tx2_rf_en),
    .tdd_if2_mode (tdd_if2_mode),

    .ref_clk (ref_clk),
    .adc_sync_in (adc_sync_in),
    .dac_sync_in (dac_sync_in),

    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

  assign adc_1_valid_i0 = adc_1_valid;
  assign adc_1_valid_q0 = adc_1_valid;
  assign adc_1_valid_i1 = adc_1_valid;
  assign adc_1_valid_q1 = adc_1_valid;
  assign adc_2_valid_i0 = adc_2_valid;
  assign adc_2_valid_q0 = adc_2_valid;

  assign dac_1_valid_i0 = dac_1_valid;
  assign dac_1_valid_q0 = dac_1_valid;
  assign dac_1_valid_i1 = dac_1_valid;
  assign dac_1_valid_q1 = dac_1_valid;
  assign dac_2_valid_i0 = dac_2_valid;
  assign dac_2_valid_q0 = dac_2_valid;

  assign rx1_enable = tdd_if1_mode ? tdd_rx1_rf_en : gpio_rx1_enable_in;
  assign rx2_enable = tdd_if2_mode ? tdd_rx2_rf_en : gpio_rx2_enable_in;
  assign tx1_enable = tdd_if1_mode ? tdd_tx1_rf_en : gpio_tx1_enable_in;
  assign tx2_enable = tdd_if2_mode ? tdd_tx2_rf_en : gpio_tx2_enable_in;

  // up bus interface
  up_axi #(
    .AXI_ADDRESS_WIDTH(15)
  ) i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr[14:0]),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr[14:0]),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s[12:0]),
    .up_wdata (up_wdata_s),
    .up_rdata (up_rdata_s),
    .up_wack (up_wack_s),
    .up_raddr (up_raddr_s[12:0]),
    .up_rreq (up_rreq_s),
    .up_rack (up_rack_s));

  // Alias Rx/Tx peripherals @ 0x8000
  assign up_raddr_s[13] = 1'b0;
  assign up_waddr_s[13] = 1'b0;

endmodule
