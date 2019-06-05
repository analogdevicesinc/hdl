// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
// based on XILINX xapp692
// specific for MOTCON2 ADI board
// works correctly if the PHY is set with Autonegotiation on

`timescale 1ns/100ps

module util_gmii_to_rgmii #(

  parameter PHY_AD = 5'b10000,
  parameter IODELAY_CTRL = 1'b0,
  parameter IDELAY_VALUE = 18,
  parameter IODELAY_GROUP = "if_delay_group",
  parameter REFCLK_FREQUENCY = 200) (

  input                   clk_20m,
  input                   clk_25m,
  input                   clk_125m,
  input                   idelayctrl_clk,

  input                   reset,

  output      [ 3:0]      rgmii_td,
  output                  rgmii_tx_ctl,
  output                  rgmii_txc,
  input       [ 3:0]      rgmii_rd,
  input                   rgmii_rx_ctl,
  input                   rgmii_rxc,

  input                   mdio_mdc,
  input                   mdio_in_w,
  input                   mdio_in_r,

  input       [ 7:0]      gmii_txd,
  input                   gmii_tx_en,
  input                   gmii_tx_er,
  output                  gmii_tx_clk,
  output  reg             gmii_crs,
  output  reg             gmii_col,
  output  reg [ 7:0]      gmii_rxd,
  output  reg             gmii_rx_dv,
  output  reg             gmii_rx_er,
  output                  gmii_rx_clk);


  // wires
  wire            clk_2_5m;
  wire            clk_100msps;
  wire  [ 3:0]    rgmii_rd_delay;
  wire  [ 7:0]    gmii_rxd_s;
  wire            rgmii_rx_ctl_delay;
  wire            rgmii_rx_ctl_s;

  wire  [ 1:0]    speed_selection; // 1x gigabit, 01 100Mbps, 00 10mbps
  wire            duplex_mode;     // 1 full, 0 half

  // registers
  reg             tx_reset_d1;
  reg             tx_reset_sync;
  reg             rx_reset_d1;
  reg   [ 7:0]    gmii_txd_r;
  reg             gmii_tx_en_r;
  reg             gmii_tx_er_r;
  reg   [ 7:0]    gmii_txd_r_d1;
  reg             gmii_tx_en_r_d1;
  reg             gmii_tx_er_r_d1;

  reg             rgmii_tx_ctl_r;
  reg   [ 3:0]    gmii_txd_low;

  reg             idelayctrl_reset;
  reg [ 3:0]      idelay_reset_cnt;

  assign gigabit        = speed_selection [1];
  assign gmii_tx_clk    = gmii_tx_clk_s;

  always @(posedge gmii_rx_clk)
  begin
    gmii_rxd       = gmii_rxd_s;
    gmii_rx_dv     = gmii_rx_dv_s;
    gmii_rx_er     = gmii_rx_dv_s ^ rgmii_rx_ctl_s;
  end

  always @(posedge gmii_tx_clk_s) begin
    tx_reset_d1    <= reset;
    tx_reset_sync  <= tx_reset_d1;
  end

  always @(posedge gmii_tx_clk_s)
  begin
    rgmii_tx_ctl_r = gmii_tx_en_r ^ gmii_tx_er_r;
    gmii_txd_low   = gigabit ? gmii_txd_r[7:4] :  gmii_txd_r[3:0];
    gmii_col       = duplex_mode ? 1'b0 : (gmii_tx_en_r| gmii_tx_er_r) & ( gmii_rx_dv | gmii_rx_er) ;
    gmii_crs       = duplex_mode ? 1'b0 : (gmii_tx_en_r| gmii_tx_er_r| gmii_rx_dv | gmii_rx_er);
  end

  always @(posedge gmii_tx_clk_s) begin
    if (tx_reset_sync == 1'b1) begin
      gmii_txd_r   <= 8'h0;
      gmii_tx_en_r <= 1'b0;
      gmii_tx_er_r <= 1'b0;
    end
    else
    begin
      gmii_txd_r   <= gmii_txd;
      gmii_tx_en_r <= gmii_tx_en;
      gmii_tx_er_r <= gmii_tx_er;
      gmii_txd_r_d1   <= gmii_txd_r;
      gmii_tx_en_r_d1 <= gmii_tx_en_r;
      gmii_tx_er_r_d1 <= gmii_tx_er_r;
    end
  end

  BUFR #(
    .BUFR_DIVIDE("8"),
    .SIM_DEVICE("7SERIES")
  ) clk_2_5_divide (
    .I(clk_20m),
    .CE(1),
    .CLR(0),
    .O(clk_2_5m));

  BUFGMUX #(
    .CLK_SEL_TYPE ("SYNC")
  ) clk_tx_mux0 (
    .S(speed_selection[0]),
    .I0(clk_2_5m),
    .I1(clk_25m),
    .O(clk_100msps));

  BUFGMUX #(
    .CLK_SEL_TYPE ("SYNC")
  ) clk_tx_mux1 (
    .S(speed_selection[1]),
    .I0(clk_100msps),
    .I1(clk_125m),
    .O(gmii_tx_clk_s));

  ODDR #(
    .DDR_CLK_EDGE("SAME_EDGE")
  ) rgmii_txc_out (
    .Q (rgmii_txc),
    .C (gmii_tx_clk_s),
    .CE(1),
    .D1(1),
    .D2(0),
    .R(tx_reset_sync),
    .S(0));

  generate
  genvar i;
  for (i = 0; i < 4; i = i + 1) begin : gen_tx_data
    ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE")
    ) rgmii_td_out (
      .Q (rgmii_td[i]),
      .C (gmii_tx_clk_s),
      .CE(1),
      .D1(gmii_txd_r_d1[i]),
      .D2(gmii_txd_low[i]),
      .R(tx_reset_sync),
      .S(0));
  end
  endgenerate

  ODDR #(
    .DDR_CLK_EDGE("SAME_EDGE")
  ) rgmii_tx_ctl_out (
    .Q (rgmii_tx_ctl),
    .C (gmii_tx_clk_s),
    .CE(1),
    .D1(gmii_tx_en_r_d1),
    .D2(rgmii_tx_ctl_r),
    .R(tx_reset_sync),
    .S(0));

  BUFG bufmr_rgmii_rxc(
    .I(rgmii_rxc),
    .O(gmii_rx_clk));

  (* IODELAY_GROUP = IODELAY_GROUP *)
  IDELAYE2 #(
    .IDELAY_TYPE("FIXED"),
    .HIGH_PERFORMANCE_MODE("TRUE"),
    .REFCLK_FREQUENCY(REFCLK_FREQUENCY),
    .SIGNAL_PATTERN("DATA"),
    .IDELAY_VALUE (IDELAY_VALUE),
    .DELAY_SRC("IDATAIN")
  ) delay_rgmii_rx_ctl (
    .IDATAIN(rgmii_rx_ctl),
    .DATAOUT(rgmii_rx_ctl_delay),
    .DATAIN(0),
    .C(0),
    .CE(0),
    .INC(0),
    .CINVCTRL(0),
    .CNTVALUEOUT(),
    .LD(0),
    .LDPIPEEN(0),
    .CNTVALUEIN(0),
    .REGRST(0));

  generate
  for (i = 0; i < 4; i = i + 1) begin
  (* IODELAY_GROUP = IODELAY_GROUP *)
    IDELAYE2 #(
      .IDELAY_TYPE("FIXED"),
      .HIGH_PERFORMANCE_MODE("TRUE"),
      .REFCLK_FREQUENCY(REFCLK_FREQUENCY),
      .SIGNAL_PATTERN("DATA"),
      .IDELAY_VALUE (IDELAY_VALUE),
      .DELAY_SRC("IDATAIN")
    ) delay_rgmii_rd (
      .IDATAIN(rgmii_rd[i]),
      .DATAOUT(rgmii_rd_delay[i]),
      .DATAIN(0),
      .C(0),
      .CE(0),
      .INC(0),
      .CINVCTRL(0),
      .CNTVALUEOUT(),
      .LD(0),
      .LDPIPEEN(0),
      .CNTVALUEIN(0),
      .REGRST(0));

    IDDR #(
      .DDR_CLK_EDGE("SAME_EDGE_PIPELINED")
    ) rgmii_rx_iddr (
      .Q1(gmii_rxd_s[i]),
      .Q2(gmii_rxd_s[i+4]),
      .C(gmii_rx_clk),
      .CE(1),
      .D(rgmii_rd_delay[i]),
      .R(0),
      .S(0));
  end
  endgenerate

  IDDR #(
    .DDR_CLK_EDGE("SAME_EDGE_PIPELINED")
  ) rgmii_rx_ctl_iddr (
    .Q1(gmii_rx_dv_s),
    .Q2(rgmii_rx_ctl_s),
    .C(gmii_rx_clk),
    .CE(1),
    .D(rgmii_rx_ctl_delay),
    .R(0),
    .S(0));

  mdc_mdio  #(
    .PHY_AD(PHY_AD)
  ) mdc_mdio_in(
      .mdio_mdc(mdio_mdc),
      .mdio_in_w(mdio_in_w),
      .mdio_in_r(mdio_in_r),
      .speed_select(speed_selection),
      .duplex_mode(duplex_mode));

  // DELAY CONTROLLER
  generate
  if (IODELAY_CTRL == 1'b1) begin
    always @(posedge idelayctrl_clk) begin
      if (reset == 1'b1) begin
        idelay_reset_cnt <= 4'h0;
        idelayctrl_reset <= 1'b1;
      end else begin
        idelayctrl_reset <= 1'b1;
        case (idelay_reset_cnt)
          4'h0: idelay_reset_cnt <= 4'h1;
          4'h1: idelay_reset_cnt <= 4'h2;
          4'h2: idelay_reset_cnt <= 4'h3;
          4'h3: idelay_reset_cnt <= 4'h4;
          4'h4: idelay_reset_cnt <= 4'h5;
          4'h5: idelay_reset_cnt <= 4'h6;
          4'h6: idelay_reset_cnt <= 4'h7;
          4'h7: idelay_reset_cnt <= 4'h8;
          4'h8: idelay_reset_cnt <= 4'h9;
          4'h9: idelay_reset_cnt <= 4'ha;
          4'ha: idelay_reset_cnt <= 4'hb;
          4'hb: idelay_reset_cnt <= 4'hc;
          4'hc: idelay_reset_cnt <= 4'hd;
          4'hd: idelay_reset_cnt <= 4'he;
          default: begin
            idelay_reset_cnt <= 4'he;
            idelayctrl_reset <= 1'b0;
          end
        endcase
      end
    end

    (* IODELAY_GROUP = IODELAY_GROUP *)
    IDELAYCTRL dlyctrl (
      .RDY(),
      .REFCLK(idelayctrl_clk),
      .RST(idelayctrl_reset));
  end
  endgenerate

endmodule
