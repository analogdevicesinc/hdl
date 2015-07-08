// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// based on XILINX xapp692
// specific for MOTCON2 ADI board
// works correctly if the PHY is set with Autonegotiation on

module util_gmii_to_rgmii (

  clk_20m,
  clk_25m,
  clk_125m,
  idelayctrl_clk,

  reset,

  rgmii_td,
  rgmii_tx_ctl,
  rgmii_txc,
  rgmii_rd,
  rgmii_rx_ctl,
  rgmii_rxc,

  mdio_mdc,
  mdio_in_w,
  mdio_in_r,

  gmii_txd,
  gmii_tx_en,
  gmii_tx_er,
  gmii_tx_clk,
  gmii_crs,
  gmii_col,
  gmii_rxd,
  gmii_rx_dv,
  gmii_rx_er,
  gmii_rx_clk);

  parameter PHY_AD = 5'b10000;
  parameter IODELAY_CTRL = 1'b0;
  parameter IDELAY_VALUE = 18;
  parameter IODELAY_GROUP = "if_delay_group";

  input           clk_20m;
  input           clk_25m;
  input           clk_125m;
  input           idelayctrl_clk;

  input           reset;

  output  [ 3:0]  rgmii_td;
  output          rgmii_tx_ctl;
  output          rgmii_txc;
  input   [ 3:0]  rgmii_rd;
  input           rgmii_rx_ctl;
  input           rgmii_rxc;

  input           mdio_mdc;
  input           mdio_in_w;
  input           mdio_in_r;

  input   [ 7:0]  gmii_txd;
  input           gmii_tx_en;
  input           gmii_tx_er;
  output          gmii_tx_clk;
  output          gmii_crs;
  output          gmii_col;
  output  [ 7:0]  gmii_rxd;
  output          gmii_rx_dv;
  output          gmii_rx_er;
  output          gmii_rx_clk;

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
  reg             gmii_col;
  reg             gmii_crs;

  reg  [ 7:0]     gmii_rxd;
  reg             gmii_rx_dv;
  reg             gmii_rx_er;

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
    .REFCLK_FREQUENCY(200.0),
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
      .REFCLK_FREQUENCY(200.0),
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
