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

module adrv9001_tx #(
  parameter CMOS_LVDS_N = 0,
  parameter NUM_LANES = 4,
  parameter FPGA_TECHNOLOGY = 0,
  parameter USE_BUFG = 0,
  parameter USE_RX_CLK_FOR_TX = 0
) (
  input                   ref_clk,
  input                   up_clk,

  input                   mssi_sync,
  input                   tx_output_enable,

  // physical interface (transmit)
  output                  tx_dclk_out_n_NC,
  output                  tx_dclk_out_p_dclk_out,
  input                   tx_dclk_in_n_NC,
  input                   tx_dclk_in_p_dclk_in,
  output                  tx_idata_out_n_idata0,
  output                  tx_idata_out_p_idata1,
  output                  tx_qdata_out_n_qdata2,
  output                  tx_qdata_out_p_qdata3,
  output                  tx_strobe_out_n_NC,
  output                  tx_strobe_out_p_strobe_out,

  input                   rx_clk_div,
  input                   rx_clk,
  input                   rx_ssi_rst,

  // internal resets and clocks
  output     [31:0]       dac_clk_ratio,

  input                   dac_rst,
  output                  dac_clk_div,

  input       [7:0]       dac_data_0,
  input       [7:0]       dac_data_1,
  input       [7:0]       dac_data_2,
  input       [7:0]       dac_data_3,
  input       [7:0]       dac_data_strb,
  input       [7:0]       dac_data_clk,
  input                   dac_data_valid
);

  localparam  SEVEN_SERIES  = 1;
  localparam  ULTRASCALE  = 2;
  localparam  ULTRASCALE_PLUS  = 3;

  // internal wire
  wire                 tx_dclk_in_s;
  wire                 dac_fast_clk;
  wire [NUM_LANES-1:0] serdes_out_p;
  wire [NUM_LANES-1:0] serdes_out_n;
  wire [NUM_LANES-1:0] data_s0;
  wire [NUM_LANES-1:0] data_s1;
  wire [NUM_LANES-1:0] data_s2;
  wire [NUM_LANES-1:0] data_s3;
  wire [NUM_LANES-1:0] data_s4;
  wire [NUM_LANES-1:0] data_s5;
  wire [NUM_LANES-1:0] data_s6;
  wire [NUM_LANES-1:0] data_s7;
  wire                 ssi_rst;

  ad_serdes_out #(
    .CMOS_LVDS_N (CMOS_LVDS_N),
    .DDR_OR_SDR_N(1),
    .DATA_WIDTH(NUM_LANES),
    .SERDES_FACTOR(8),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY)
  ) i_serdes (
    .rst (dac_rst|ssi_rst),
    .clk (dac_fast_clk),
    .div_clk (dac_clk_div),
    .data_oe (tx_output_enable),
    .data_s0 (data_s0),
    .data_s1 (data_s1),
    .data_s2 (data_s2),
    .data_s3 (data_s3),
    .data_s4 (data_s4),
    .data_s5 (data_s5),
    .data_s6 (data_s6),
    .data_s7 (data_s7),
    .data_out_se (),
    .data_out_p (serdes_out_p),
    .data_out_n (serdes_out_n));

  generate
  if (CMOS_LVDS_N == 0) begin

    IBUFGDS i_dac_clk_in_ibuf (
      .I (tx_dclk_in_p_dclk_in),
      .IB (tx_dclk_in_n_NC),
      .O (tx_dclk_in_s));

    assign data_s0 = {dac_data_clk[7],dac_data_strb[7],dac_data_1[7],dac_data_0[7]};
    assign data_s1 = {dac_data_clk[6],dac_data_strb[6],dac_data_1[6],dac_data_0[6]};
    assign data_s2 = {dac_data_clk[5],dac_data_strb[5],dac_data_1[5],dac_data_0[5]};
    assign data_s3 = {dac_data_clk[4],dac_data_strb[4],dac_data_1[4],dac_data_0[4]};
    assign data_s4 = {dac_data_clk[3],dac_data_strb[3],dac_data_1[3],dac_data_0[3]};
    assign data_s5 = {dac_data_clk[2],dac_data_strb[2],dac_data_1[2],dac_data_0[2]};
    assign data_s6 = {dac_data_clk[1],dac_data_strb[1],dac_data_1[1],dac_data_0[1]};
    assign data_s7 = {dac_data_clk[0],dac_data_strb[0],dac_data_1[0],dac_data_0[0]};

    assign {tx_dclk_out_p_dclk_out,
            tx_strobe_out_p_strobe_out,
            tx_qdata_out_p_qdata3,
            tx_idata_out_p_idata1} = serdes_out_p;

    assign {tx_dclk_out_n_NC,
            tx_strobe_out_n_NC,
            tx_qdata_out_n_qdata2,
            tx_idata_out_n_idata0} = serdes_out_n;
  end else begin

    IBUF i_dac_clk_in_ibuf (
      .I (tx_dclk_in_p_dclk_in),
      .O (tx_dclk_in_s));

    assign data_s0 = {dac_data_clk[7],dac_data_strb[7],dac_data_3[7],dac_data_2[7],dac_data_1[7],dac_data_0[7]};
    assign data_s1 = {dac_data_clk[6],dac_data_strb[6],dac_data_3[6],dac_data_2[6],dac_data_1[6],dac_data_0[6]};
    assign data_s2 = {dac_data_clk[5],dac_data_strb[5],dac_data_3[5],dac_data_2[5],dac_data_1[5],dac_data_0[5]};
    assign data_s3 = {dac_data_clk[4],dac_data_strb[4],dac_data_3[4],dac_data_2[4],dac_data_1[4],dac_data_0[4]};
    assign data_s4 = {dac_data_clk[3],dac_data_strb[3],dac_data_3[3],dac_data_2[3],dac_data_1[3],dac_data_0[3]};
    assign data_s5 = {dac_data_clk[2],dac_data_strb[2],dac_data_3[2],dac_data_2[2],dac_data_1[2],dac_data_0[2]};
    assign data_s6 = {dac_data_clk[1],dac_data_strb[1],dac_data_3[1],dac_data_2[1],dac_data_1[1],dac_data_0[1]};
    assign data_s7 = {dac_data_clk[0],dac_data_strb[0],dac_data_3[0],dac_data_2[0],dac_data_1[0],dac_data_0[0]};

    assign {tx_dclk_out_p_dclk_out,
            tx_strobe_out_p_strobe_out,
            tx_qdata_out_p_qdata3,
            tx_qdata_out_n_qdata2,
            tx_idata_out_p_idata1,
            tx_idata_out_n_idata0} = serdes_out_p;

    assign {tx_dclk_out_n_NC,
            tx_strobe_out_n_NC} = 2'b0;
  end

  if (USE_RX_CLK_FOR_TX == 0) begin

    if (FPGA_TECHNOLOGY == SEVEN_SERIES) begin

      // SERDES fast clock
      BUFIO i_dac_clk_in_gbuf (
        .I (tx_dclk_in_s),
        .O (dac_fast_clk));

      // SERDES slow clock
      BUFR #(
        .BUFR_DIVIDE("4")
      ) i_dac_div_clk_rbuf (
        .CLR (mssi_sync),
        .CE (1'b1),
        .I (tx_dclk_in_s),
        .O (dac_clk_div_s));

      if (USE_BUFG == 1) begin
        BUFG I_bufg (
          .I (dac_clk_div_s),
          .O (dac_clk_div));
      end else begin
        assign dac_clk_div = dac_clk_div_s;
      end

      xpm_cdc_async_rst #(
        .DEST_SYNC_FF    (10), // DECIMAL; range: 2-10
        .INIT_SYNC_FF    ( 0), // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .RST_ACTIVE_HIGH ( 1)  // DECIMAL; 0=active low reset, 1=active high reset
      ) rst_syncro (
        .src_arst (mssi_sync),
        .dest_clk (dac_clk_div),
        .dest_arst(ssi_rst));

    end else begin

      reg mssi_sync_d = 1'b0;
      reg mssi_sync_2d = 1'b0;
      always @(posedge dac_fast_clk) begin
        mssi_sync_d <= mssi_sync;
        mssi_sync_2d <= mssi_sync_d;
      end

      BUFGCE #(
        .CE_TYPE ("SYNC"),
        .IS_CE_INVERTED (1'b0),
        .IS_I_INVERTED (1'b0)
      ) i_dac_clk_in_gbuf (
        .O (dac_fast_clk),
        .CE (1'b1),
        .I (tx_dclk_in_s));

      BUFGCE_DIV #(
        .BUFGCE_DIVIDE (4),
        .IS_CE_INVERTED (1'b0),
        .IS_CLR_INVERTED (1'b0),
        .IS_I_INVERTED (1'b0)
      ) i_dac_div_clk_rbuf (
        .O (dac_clk_div),
        .CE (1'b1),
        .CLR (mssi_sync_2d),
        .I (tx_dclk_in_s));

      assign ssi_rst = mssi_sync_2d;

    end

  end else begin

    assign dac_fast_clk = rx_clk;
    assign dac_clk_div = rx_clk_div;
    assign ssi_rst = rx_ssi_rst;

  end

  endgenerate

  assign dac_clk_ratio = 4;

endmodule
