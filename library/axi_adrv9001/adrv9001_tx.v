// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2025 Analog Devices, Inc. All rights reserved.
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
  input                   up_clk,

  input                   mssi_sync,
  input                   tx_output_enable,
  input                   dac_data_valid,

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

  // internal resets and clocks
  output     [31:0]       dac_clk_ratio,

  input                   dac_rst,
  output                  dac_clk_div,
  output                  dac_if_rst,

  input       [7:0]       dac_data_0,
  input       [7:0]       dac_data_1,
  input       [7:0]       dac_data_2,
  input       [7:0]       dac_data_3,
  input       [7:0]       dac_data_strb,
  input       [7:0]       dac_data_clk
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
  wire                 dac_clk_div_s;

  // internal registers

  reg        mssi_sync_d1;
  reg        mssi_sync_d2;
  reg        reset_m2;
  reg        reset_m1;
  reg        reset;
  reg        bufdiv_clr = 1'b0;
  reg [2:0]  state_cnt = 7;
  reg [2:0]  bufdiv_clr_state = 3;
  reg        bufdiv_ce = 1'b1;
  reg [7:0]  serdes_min_reset_cycle = 8'hff;
  reg        serdes_reset = 1'b0;
  reg        serdes_next_reset = 1'b0;

  ad_serdes_out #(
    .CMOS_LVDS_N (CMOS_LVDS_N),
    .DDR_OR_SDR_N(1),
    .DATA_WIDTH(NUM_LANES),
    .SERDES_FACTOR(8),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY)
  ) i_serdes (
    .rst (serdes_reset),
    .clk (dac_fast_clk),
    .div_clk (dac_clk_div),
    .data_oe (tx_output_enable & dac_data_valid),
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

    IBUFDS i_dac_clk_in_ibuf (
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

  // reset logic

  always @(posedge dac_fast_clk) begin
    mssi_sync_d1 <= mssi_sync;
    mssi_sync_d2 <= mssi_sync_d1;
  end

  always @(posedge dac_fast_clk, posedge mssi_sync_d2) begin
    if (mssi_sync_d2 == 1'b1) begin
      bufdiv_ce <= 1'b0;
      bufdiv_clr <= 1'b0;
      bufdiv_clr_state <= 3'd0;
      state_cnt <= 3'd7;
    end else begin
      if (bufdiv_ce == 1'b0) begin
        if (state_cnt == 3'd0) begin
          bufdiv_clr_state <= bufdiv_clr_state + 1;
        end else begin
          state_cnt <= state_cnt - 3'd1;
        end
      end

      case (bufdiv_clr_state)
        3'd0 : begin
          bufdiv_ce <= 1'b0;
          bufdiv_clr <= 1'b0;
        end
        3'd1 : begin
          bufdiv_ce <= 1'b0;
          bufdiv_clr <= 1'b1;
        end
        3'd2 : begin
          bufdiv_ce <= 1'b0;
          bufdiv_clr <= 1'b0;
        end
        default: begin
          bufdiv_ce <= 1'b1;
          bufdiv_clr <= 1'b0;
        end
      endcase
    end
  end

  always @(posedge dac_clk_div, posedge bufdiv_clr) begin
    if (bufdiv_clr == 1'b1) begin
      reset_m2 <= 1'b1;
      reset_m1 <= 1'b1;
      reset <= 1'b1;
    end else begin
      reset_m2 <= 1'b0;
      reset_m1 <= reset_m2;
      reset <= reset_m1;
    end
  end

  assign dac_if_rst = dac_rst | reset;

  always @(posedge dac_clk_div) begin
    if (dac_if_rst) begin
      serdes_reset <= 1'b1;
      serdes_next_reset <= 1'b1;
      serdes_min_reset_cycle <= 8'hff;
    end else begin
      if (serdes_next_reset == 1'b1) begin
        serdes_reset <= 1'b1;
        if (serdes_min_reset_cycle == 8'd0) begin
          serdes_next_reset <= 1'b0;
        end else begin
          serdes_min_reset_cycle <= serdes_min_reset_cycle >> 1;
        end
      end else begin
        serdes_reset <= 1'b0;
        serdes_next_reset <= 1'b0;
        serdes_min_reset_cycle <= 8'd0;
      end
    end
  end

  if (USE_RX_CLK_FOR_TX == 0) begin

    if (FPGA_TECHNOLOGY == SEVEN_SERIES) begin
      // SERDES fast clock
      BUFG i_dac_clk_in_gbuf (
        .I (tx_dclk_in_s),
        .O (dac_fast_clk));

      // SERDES slow clock
      BUFR #(
        .BUFR_DIVIDE("4")
      ) i_dac_div_clk_rbuf (
        .CE (bufdiv_ce),
        .CLR (bufdiv_clr),
        .I (tx_dclk_in_s),
        .O (dac_clk_div_s));

      if (USE_BUFG == 1) begin
        BUFG I_bufg (
          .I (dac_clk_div_s),
          .O (dac_clk_div));
      end else begin
        assign dac_clk_div = dac_clk_div_s;
      end

    end else begin

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
        .CLR (bufdiv_clr),
        .I (tx_dclk_in_s));

    end

  end else begin

    assign dac_fast_clk = rx_clk;
    assign dac_clk_div = rx_clk_div;

  end

  endgenerate

  assign dac_clk_ratio = 4;

endmodule
