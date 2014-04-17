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

`timescale 1ns/1ps

module ad_gt_channel_1 (

  // rst and clocks

  ref_clk,
  cpll_pd,
  cpll_rst,
  qpll_clk,
  qpll_ref_clk,
  qpll_locked,

  // receive

  rx_rst,
  rx_p,
  rx_n,

  rx_sys_clk_sel,
  rx_out_clk_sel,
  rx_out_clk,
  rx_rst_done,
  rx_pll_locked,

  rx_clk,
  rx_charisk,
  rx_disperr,
  rx_notintable,
  rx_data,
  rx_comma_align_enb,

  // transmit

  tx_rst,
  tx_p,
  tx_n,

  tx_sys_clk_sel,
  tx_out_clk_sel,
  tx_out_clk,
  tx_rst_done,
  tx_pll_locked,

  tx_clk,
  tx_charisk,
  tx_data,

  // drp interface

  drp_clk,
  drp_sel,
  drp_addr,
  drp_wr,
  drp_wdata,
  drp_rdata,
  drp_ready,
  drp_lanesel,
  drp_rx_rate,

  // monitor signals

  rx_mon_trigger,
  rx_mon_data);

  // parameters

  parameter   DRP_ID = 0;
  parameter   CPLL_FBDIV = 2;
  parameter   RX_OUT_DIV = 1;
  parameter   TX_OUT_DIV = 1;
  parameter   RX_CLK25_DIV = 10;
  parameter   TX_CLK25_DIV = 10;
  parameter   PMA_RSV = 32'h00018480;
  parameter   RX_CDR_CFG = 72'h03000023ff20400020;

  // rst and clocks

  input           ref_clk;
  input           cpll_pd;
  input           cpll_rst;
  input           qpll_clk;
  input           qpll_ref_clk;
  input           qpll_locked;

  // receive

  input           rx_rst;
  input           rx_p;
  input           rx_n;

  input   [ 1:0]  rx_sys_clk_sel;
  input   [ 2:0]  rx_out_clk_sel;
  output          rx_out_clk;
  output          rx_rst_done;
  output          rx_pll_locked;

  input           rx_clk;
  output  [ 3:0]  rx_charisk;
  output  [ 3:0]  rx_disperr;
  output  [ 3:0]  rx_notintable;
  output  [31:0]  rx_data;
  input           rx_comma_align_enb;

  // transmit

  input           tx_rst;
  output          tx_p;
  output          tx_n;

  input   [ 1:0]  tx_sys_clk_sel;
  input   [ 2:0]  tx_out_clk_sel;
  output          tx_out_clk;
  output          tx_rst_done;
  output          tx_pll_locked;

  input           tx_clk;
  input   [ 3:0]  tx_charisk;
  input   [31:0]  tx_data;

  // drp interface

  input           drp_clk;
  input           drp_sel;
  input   [11:0]  drp_addr;
  input           drp_wr;
  input   [15:0]  drp_wdata;
  output  [15:0]  drp_rdata;
  output          drp_ready;
  input   [ 7:0]  drp_lanesel;
  output  [ 7:0]  drp_rx_rate;

  // monitor signals

  output          rx_mon_trigger;
  output  [49:0]  rx_mon_data;

  // internal registers

  reg     [ 3:0]  rx_user_ready = 'd0;
  reg     [ 3:0]  tx_user_ready = 'd0;
  reg             drp_sel_int = 'd0;
  reg     [11:0]  drp_addr_int = 'd0;
  reg             drp_wr_int = 'd0;
  reg     [15:0]  drp_wdata_int = 'd0;
  reg     [15:0]  drp_rdata = 'd0;
  reg             drp_ready = 'd0;
  reg     [ 7:0]  drp_rx_rate = 'd0;

  // internal signals

  wire            rx_ilas_f_s;
  wire            rx_ilas_q_s;
  wire            rx_ilas_a_s;
  wire            rx_ilas_r_s;
  wire            rx_cgs_k_s;
  wire    [ 3:0]  rx_valid_k_s;
  wire            rx_valid_k_1_s;
  wire    [ 2:0]  rx_rate_p_s;
  wire    [ 7:0]  rx_rate_s;
  wire    [ 3:0]  rx_charisk_open_s;
  wire    [ 3:0]  rx_disperr_open_s;
  wire    [ 3:0]  rx_notintable_open_s;
  wire    [31:0]  rx_data_open_s;
  wire            cpll_locked_s;
  wire    [15:0]  drp_rdata_s;
  wire            drp_ready_s;

  // monitor interface

  assign rx_mon_data[31: 0] = rx_data;
  assign rx_mon_data[35:32] = rx_notintable;
  assign rx_mon_data[39:36] = rx_disperr;
  assign rx_mon_data[43:40] = rx_charisk;
  assign rx_mon_data[44:44] = rx_valid_k_1_s;
  assign rx_mon_data[45:45] = rx_cgs_k_s;
  assign rx_mon_data[46:46] = rx_ilas_r_s;
  assign rx_mon_data[47:47] = rx_ilas_a_s;
  assign rx_mon_data[48:48] = rx_ilas_q_s;
  assign rx_mon_data[49:49] = rx_ilas_f_s;

  assign rx_mon_trigger = rx_valid_k_1_s;

  // ilas frame characters

  assign rx_ilas_f_s = 
    (((rx_data[31:24] == 8'hfc) && (rx_valid_k_s[ 3] == 1'b1)) ||
     ((rx_data[23:16] == 8'hfc) && (rx_valid_k_s[ 2] == 1'b1)) ||
     ((rx_data[15: 8] == 8'hfc) && (rx_valid_k_s[ 1] == 1'b1)) ||
     ((rx_data[ 7: 0] == 8'hfc) && (rx_valid_k_s[ 0] == 1'b1))) ? 1'b1 : 1'b0;

  assign rx_ilas_q_s = 
    (((rx_data[31:24] == 8'h9c) && (rx_valid_k_s[ 3] == 1'b1)) ||
     ((rx_data[23:16] == 8'h9c) && (rx_valid_k_s[ 2] == 1'b1)) ||
     ((rx_data[15: 8] == 8'h9c) && (rx_valid_k_s[ 1] == 1'b1)) ||
     ((rx_data[ 7: 0] == 8'h9c) && (rx_valid_k_s[ 0] == 1'b1))) ? 1'b1 : 1'b0;

  assign rx_ilas_a_s = 
    (((rx_data[31:24] == 8'h7c) && (rx_valid_k_s[ 3] == 1'b1)) ||
     ((rx_data[23:16] == 8'h7c) && (rx_valid_k_s[ 2] == 1'b1)) ||
     ((rx_data[15: 8] == 8'h7c) && (rx_valid_k_s[ 1] == 1'b1)) ||
     ((rx_data[ 7: 0] == 8'h7c) && (rx_valid_k_s[ 0] == 1'b1))) ? 1'b1 : 1'b0;

  assign rx_ilas_r_s = 
    (((rx_data[31:24] == 8'h1c) && (rx_valid_k_s[ 3] == 1'b1)) ||
     ((rx_data[23:16] == 8'h1c) && (rx_valid_k_s[ 2] == 1'b1)) ||
     ((rx_data[15: 8] == 8'h1c) && (rx_valid_k_s[ 1] == 1'b1)) ||
     ((rx_data[ 7: 0] == 8'h1c) && (rx_valid_k_s[ 0] == 1'b1))) ? 1'b1 : 1'b0;

  assign rx_cgs_k_s = 
    (((rx_data[31:24] == 8'hbc) && (rx_valid_k_s[ 3] == 1'b1)) &&
     ((rx_data[23:16] == 8'hbc) && (rx_valid_k_s[ 2] == 1'b1)) &&
     ((rx_data[15: 8] == 8'hbc) && (rx_valid_k_s[ 1] == 1'b1)) &&
     ((rx_data[ 7: 0] == 8'hbc) && (rx_valid_k_s[ 0] == 1'b1))) ? 1'b1 : 1'b0;

  // validate all characters

  assign rx_valid_k_s = rx_charisk & (~rx_disperr) & (~rx_notintable);
  assign rx_valid_k_1_s = (rx_valid_k_s == 4'd0) ? 1'b0 : 1'b1;

  // rate 

  assign rx_rate_p_s = 0;
  assign rx_rate_s =  (rx_rate_p_s == 3'd0) ? RX_OUT_DIV :
                      (rx_rate_p_s == 3'd1) ? 8'h01 :
                      (rx_rate_p_s == 3'd2) ? 8'h02 :
                      (rx_rate_p_s == 3'd3) ? 8'h04 :
                      (rx_rate_p_s == 3'd4) ? 8'h08 :
                      (rx_rate_p_s == 3'd5) ? 8'h10 : 8'h00;

  // pll locked

  assign rx_pll_locked = (rx_sys_clk_sel[0] == 1'b1) ? qpll_locked : cpll_locked_s;
  assign tx_pll_locked = (tx_sys_clk_sel[0] == 1'b1) ? qpll_locked : cpll_locked_s;

  // user ready

  always @(posedge drp_clk) begin
    if ((rx_rst == 1'b1) || (rx_pll_locked == 1'b0)) begin
      rx_user_ready <= 4'd0;
    end else begin
      rx_user_ready <= {rx_user_ready[2:0], 1'b1};
    end
  end

  always @(posedge drp_clk) begin
    if ((tx_rst == 1'b1) || (tx_pll_locked == 1'b0)) begin
      tx_user_ready <= 4'd0;
    end else begin
      tx_user_ready <= {tx_user_ready[2:0], 1'b1};
    end
  end

  // drp control

  always @(posedge drp_clk) begin
    if (drp_lanesel == DRP_ID) begin
      drp_sel_int <= drp_sel;
      drp_addr_int <= drp_addr;
      drp_wr_int <= drp_wr;
      drp_wdata_int <= drp_wdata;
      drp_rdata <= drp_rdata_s;
      drp_ready <= drp_ready_s;
      drp_rx_rate <= rx_rate_s;
    end else begin
      drp_sel_int <= 1'd0;
      drp_addr_int <= 12'd0;
      drp_wr_int <= 1'd0;
      drp_wdata_int <= 16'd0;
      drp_rdata <= 16'd0;
      drp_ready <= 1'd0;
      drp_rx_rate <= 8'd0;
    end
  end

  // instantiations

  GTXE2_CHANNEL #(
    .SIM_RECEIVER_DETECT_PASS ("TRUE"),
    .SIM_TX_EIDLE_DRIVE_LEVEL ("X"), 
    .SIM_RESET_SPEEDUP ("TRUE"),
    .SIM_CPLLREFCLK_SEL (3'b001),
    .SIM_VERSION ("3.0"),
    .ALIGN_COMMA_DOUBLE ("FALSE"),
    .ALIGN_COMMA_ENABLE (10'b1111111111),
    .ALIGN_COMMA_WORD (1),
    .ALIGN_MCOMMA_DET ("TRUE"),
    .ALIGN_MCOMMA_VALUE (10'b1010000011),
    .ALIGN_PCOMMA_DET ("TRUE"),
    .ALIGN_PCOMMA_VALUE (10'b0101111100),
    .SHOW_REALIGN_COMMA ("TRUE"),
    .RXSLIDE_AUTO_WAIT (7),
    .RXSLIDE_MODE ("OFF"),
    .RX_SIG_VALID_DLY (10),
    .RX_DISPERR_SEQ_MATCH ("TRUE"),
    .DEC_MCOMMA_DETECT ("TRUE"),
    .DEC_PCOMMA_DETECT ("TRUE"),
    .DEC_VALID_COMMA_ONLY ("FALSE"),
    .CBCC_DATA_SOURCE_SEL ("DECODED"),
    .CLK_COR_SEQ_2_USE ("FALSE"),
    .CLK_COR_KEEP_IDLE ("FALSE"),
    .CLK_COR_MAX_LAT (35),
    .CLK_COR_MIN_LAT (31),
    .CLK_COR_PRECEDENCE ("TRUE"),
    .CLK_COR_REPEAT_WAIT (0),
    .CLK_COR_SEQ_LEN (1),
    .CLK_COR_SEQ_1_ENABLE (4'b1111),
    .CLK_COR_SEQ_1_1 (10'b0000000000),
    .CLK_COR_SEQ_1_2 (10'b0000000000),
    .CLK_COR_SEQ_1_3 (10'b0000000000),
    .CLK_COR_SEQ_1_4 (10'b0000000000),
    .CLK_CORRECT_USE ("FALSE"),
    .CLK_COR_SEQ_2_ENABLE (4'b1111),
    .CLK_COR_SEQ_2_1 (10'b0000000000),
    .CLK_COR_SEQ_2_2 (10'b0000000000),
    .CLK_COR_SEQ_2_3 (10'b0000000000),
    .CLK_COR_SEQ_2_4 (10'b0000000000),
    .CHAN_BOND_KEEP_ALIGN ("FALSE"),
    .CHAN_BOND_MAX_SKEW (7),
    .CHAN_BOND_SEQ_LEN (1),
    .CHAN_BOND_SEQ_1_1 (10'b0000000000),
    .CHAN_BOND_SEQ_1_2 (10'b0000000000),
    .CHAN_BOND_SEQ_1_3 (10'b0000000000),
    .CHAN_BOND_SEQ_1_4 (10'b0000000000),
    .CHAN_BOND_SEQ_1_ENABLE (4'b1111),
    .CHAN_BOND_SEQ_2_1 (10'b0000000000),
    .CHAN_BOND_SEQ_2_2 (10'b0000000000),
    .CHAN_BOND_SEQ_2_3 (10'b0000000000),
    .CHAN_BOND_SEQ_2_4 (10'b0000000000),
    .CHAN_BOND_SEQ_2_ENABLE (4'b1111),
    .CHAN_BOND_SEQ_2_USE ("FALSE"),
    .FTS_DESKEW_SEQ_ENABLE (4'b1111),
    .FTS_LANE_DESKEW_CFG (4'b1111),
    .FTS_LANE_DESKEW_EN ("FALSE"),
    .ES_CONTROL (6'b000000),
    .ES_ERRDET_EN ("TRUE"),
    .ES_EYE_SCAN_EN ("TRUE"),
    .ES_HORZ_OFFSET (12'h000),
    .ES_PMA_CFG (10'b0000000000),
    .ES_PRESCALE (5'b00000),
    .ES_QUALIFIER (80'h00000000000000000000),
    .ES_QUAL_MASK (80'h00000000000000000000),
    .ES_SDATA_MASK (80'h00000000000000000000),
    .ES_VERT_OFFSET (9'b000000000),
    .RX_DATA_WIDTH (40),
    .OUTREFCLK_SEL_INV (2'b11),
    .PMA_RSV (PMA_RSV),
    .PMA_RSV2 (16'h2070),
    .PMA_RSV3 (2'b00),
    .PMA_RSV4 (32'h00000000),
    .RX_BIAS_CFG (12'b000000000100),
    .DMONITOR_CFG (24'h000A00),
    .RX_CM_SEL (2'b11),
    .RX_CM_TRIM (3'b010),
    .RX_DEBUG_CFG (12'b000000000000),
    .RX_OS_CFG (13'b0000010000000),
    .TERM_RCAL_CFG (5'b10000),
    .TERM_RCAL_OVRD (1'b0),
    .TST_RSV (32'h00000000),
    .RX_CLK25_DIV (RX_CLK25_DIV),
    .TX_CLK25_DIV (TX_CLK25_DIV),
    .UCODEER_CLR (1'b0),
    .PCS_PCIE_EN ("FALSE"),
    .PCS_RSVD_ATTR (48'h000000000000),
    .RXBUF_ADDR_MODE ("FULL"),
    .RXBUF_EIDLE_HI_CNT (4'b1000),
    .RXBUF_EIDLE_LO_CNT (4'b0000),
    .RXBUF_EN ("TRUE"),
    .RX_BUFFER_CFG (6'b000000),
    .RXBUF_RESET_ON_CB_CHANGE ("TRUE"),
    .RXBUF_RESET_ON_COMMAALIGN ("FALSE"),
    .RXBUF_RESET_ON_EIDLE ("FALSE"),
    .RXBUF_RESET_ON_RATE_CHANGE ("TRUE"),
    .RXBUFRESET_TIME (5'b00001),
    .RXBUF_THRESH_OVFLW (61),
    .RXBUF_THRESH_OVRD ("FALSE"),
    .RXBUF_THRESH_UNDFLW (4),
    .RXDLY_CFG (16'h001F),
    .RXDLY_LCFG (9'h030),
    .RXDLY_TAP_CFG (16'h0000),
    .RXPH_CFG (24'h000000),
    .RXPHDLY_CFG (24'h084020),
    .RXPH_MONITOR_SEL (5'b00000),
    .RX_XCLK_SEL ("RXREC"),
    .RX_DDI_SEL (6'b000000),
    .RX_DEFER_RESET_BUF_EN ("TRUE"),
    .RXCDR_CFG (RX_CDR_CFG),
    .RXCDR_FR_RESET_ON_EIDLE (1'b0),
    .RXCDR_HOLD_DURING_EIDLE (1'b0),
    .RXCDR_PH_RESET_ON_EIDLE (1'b0),
    .RXCDR_LOCK_CFG (6'b010101),
    .RXCDRFREQRESET_TIME (5'b00001),
    .RXCDRPHRESET_TIME (5'b00001),
    .RXISCANRESET_TIME (5'b00001),
    .RXPCSRESET_TIME (5'b00001),
    .RXPMARESET_TIME (5'b00011),
    .RXOOB_CFG (7'b0000110),
    .RXGEARBOX_EN ("FALSE"),
    .GEARBOX_MODE (3'b000),
    .RXPRBS_ERR_LOOPBACK (1'b0),
    .PD_TRANS_TIME_FROM_P2 (12'h03c),
    .PD_TRANS_TIME_NONE_P2 (8'h3c),
    .PD_TRANS_TIME_TO_P2 (8'h64),
    .SAS_MAX_COM (64),
    .SAS_MIN_COM (36),
    .SATA_BURST_SEQ_LEN (4'b1111),
    .SATA_BURST_VAL (3'b100),
    .SATA_EIDLE_VAL (3'b100),
    .SATA_MAX_BURST (8),
    .SATA_MAX_INIT (21),
    .SATA_MAX_WAKE (7),
    .SATA_MIN_BURST (4),
    .SATA_MIN_INIT (12),
    .SATA_MIN_WAKE (4),
    .TRANS_TIME_RATE (8'h0E),
    .TXBUF_EN ("TRUE"),
    .TXBUF_RESET_ON_RATE_CHANGE ("TRUE"),
    .TXDLY_CFG (16'h001F),
    .TXDLY_LCFG (9'h030),
    .TXDLY_TAP_CFG (16'h0000),
    .TXPH_CFG (16'h0780),
    .TXPHDLY_CFG (24'h084020),
    .TXPH_MONITOR_SEL (5'b00000),
    .TX_XCLK_SEL ("TXOUT"),
    .TX_DATA_WIDTH (40),
    .TX_DEEMPH0 (5'b00000),
    .TX_DEEMPH1 (5'b00000),
    .TX_EIDLE_ASSERT_DELAY (3'b110),
    .TX_EIDLE_DEASSERT_DELAY (3'b100),
    .TX_LOOPBACK_DRIVE_HIZ ("FALSE"),
    .TX_MAINCURSOR_SEL (1'b0),
    .TX_DRIVE_MODE ("DIRECT"),
    .TX_MARGIN_FULL_0 (7'b1001110),
    .TX_MARGIN_FULL_1 (7'b1001001),
    .TX_MARGIN_FULL_2 (7'b1000101),
    .TX_MARGIN_FULL_3 (7'b1000010),
    .TX_MARGIN_FULL_4 (7'b1000000),
    .TX_MARGIN_LOW_0 (7'b1000110),
    .TX_MARGIN_LOW_1 (7'b1000100),
    .TX_MARGIN_LOW_2 (7'b1000010),
    .TX_MARGIN_LOW_3 (7'b1000000),
    .TX_MARGIN_LOW_4 (7'b1000000),
    .TXGEARBOX_EN ("FALSE"),
    .TXPCSRESET_TIME (5'b00001),
    .TXPMARESET_TIME (5'b00001),
    .TX_RXDETECT_CFG (14'h1832),
    .TX_RXDETECT_REF (3'b100),
    .CPLL_CFG (24'hBC07DC),
    .CPLL_FBDIV (CPLL_FBDIV),
    .CPLL_FBDIV_45 (5),
    .CPLL_INIT_CFG (24'h00001E),
    .CPLL_LOCK_CFG (16'h01E8),
    .CPLL_REFCLK_DIV (1),
    .RXOUT_DIV (RX_OUT_DIV),
    .TXOUT_DIV (TX_OUT_DIV),
    .SATA_CPLL_CFG ("VCO_3000MHZ"),
    .RXDFELPMRESET_TIME (7'b0001111),
    .RXLPM_HF_CFG (14'b00000011110000),
    .RXLPM_LF_CFG (14'b00000011110000),
    .RX_DFE_GAIN_CFG (23'h020FEA),
    .RX_DFE_H2_CFG (12'b000000000000),
    .RX_DFE_H3_CFG (12'b000001000000),
    .RX_DFE_H4_CFG (11'b00011110000),
    .RX_DFE_H5_CFG (11'b00011100000),
    .RX_DFE_KL_CFG (13'b0000011111110),
    .RX_DFE_LPM_CFG (16'h0954),
    .RX_DFE_LPM_HOLD_DURING_EIDLE (1'b0),
    .RX_DFE_UT_CFG (17'b10001111000000000),
    .RX_DFE_VP_CFG (17'b00011111100000011),
    .RX_CLKMUX_PD (1'b1),
    .TX_CLKMUX_PD (1'b1),
    .RX_INT_DATAWIDTH (1),
    .TX_INT_DATAWIDTH (1),
    .TX_QPI_STATUS_EN (1'b0),
    .RX_DFE_KL_CFG2 (32'h3010D90C),
    .RX_DFE_XYD_CFG (13'b0001100010000),
    .TX_PREDRIVER_MODE (1'b0))
  i_gtxe2_channel (
    .CPLLFBCLKLOST (),
    .CPLLLOCK (cpll_locked_s),
    .CPLLLOCKDETCLK (drp_clk),
    .CPLLLOCKEN (1'd1),
    .CPLLPD (cpll_pd),
    .CPLLREFCLKLOST (),
    .CPLLREFCLKSEL (3'b001),
    .CPLLRESET (cpll_rst),
    .GTRSVD (16'b0000000000000000),
    .PCSRSVDIN (16'b0000000000000000),
    .PCSRSVDIN2 (5'b00000),
    .PMARSVDIN (5'b00000),
    .PMARSVDIN2 (5'b00000),
    .TSTIN (20'b11111111111111111111),
    .TSTOUT (),
    .CLKRSVD (4'b0000),
    .GTGREFCLK (1'd0),
    .GTNORTHREFCLK0 (1'd0),
    .GTNORTHREFCLK1 (1'd0),
    .GTREFCLK0 (ref_clk),
    .GTREFCLK1 (1'd0),
    .GTSOUTHREFCLK0 (1'd0),
    .GTSOUTHREFCLK1 (1'd0),
    .DRPADDR (drp_addr_int[8:0]),
    .DRPCLK (drp_clk),
    .DRPDI (drp_wdata_int),
    .DRPDO (drp_rdata_s),
    .DRPEN (drp_sel_int),
    .DRPRDY (drp_ready_s),
    .DRPWE (drp_wr_int),
    .GTREFCLKMONITOR (),
    .QPLLCLK (qpll_clk),
    .QPLLREFCLK (qpll_ref_clk),
    .RXSYSCLKSEL (rx_sys_clk_sel),
    .TXSYSCLKSEL (tx_sys_clk_sel),
    .DMONITOROUT (),
    .TX8B10BEN (1'd1),
    .LOOPBACK (3'd0),
    .PHYSTATUS (),
    .RXRATE (rx_rate_p_s),
    .RXVALID (),
    .RXPD (2'b00),
    .TXPD (2'b00),
    .SETERRSTATUS (1'd0),
    .EYESCANRESET (1'd0),
    .RXUSERRDY (rx_user_ready[3]),
    .EYESCANDATAERROR (),
    .EYESCANMODE (1'd0),
    .EYESCANTRIGGER (1'd0),
    .RXCDRFREQRESET (1'd0),
    .RXCDRHOLD (1'd0),
    .RXCDRLOCK (),
    .RXCDROVRDEN (1'd0),
    .RXCDRRESET (1'd0),
    .RXCDRRESETRSV (1'd0),
    .RXCLKCORCNT (),
    .RX8B10BEN (1'd1),
    .RXUSRCLK (rx_clk),
    .RXUSRCLK2 (rx_clk),
    .RXDATA ({rx_data_open_s, rx_data}),
    .RXPRBSERR (),
    .RXPRBSSEL (3'd0),
    .RXPRBSCNTRESET (1'd0),
    .RXDFEXYDEN (1'd0),
    .RXDFEXYDHOLD (1'd0),
    .RXDFEXYDOVRDEN (1'd0),
    .RXDISPERR ({rx_disperr_open_s, rx_disperr}),
    .RXNOTINTABLE ({rx_notintable_open_s, rx_notintable}),
    .GTXRXP (rx_p),
    .GTXRXN (rx_n),
    .RXBUFRESET (1'd0),
    .RXBUFSTATUS (),
    .RXDDIEN (1'd0),
    .RXDLYBYPASS (1'd1),
    .RXDLYEN (1'd0),
    .RXDLYOVRDEN (1'd0),
    .RXDLYSRESET (1'd0),
    .RXDLYSRESETDONE (),
    .RXPHALIGN (1'd0),
    .RXPHALIGNDONE (),
    .RXPHALIGNEN (1'd0),
    .RXPHDLYPD (1'd0),
    .RXPHDLYRESET (1'd0),
    .RXPHMONITOR (),
    .RXPHOVRDEN (1'd0),
    .RXPHSLIPMONITOR (),
    .RXSTATUS (),
    .RXBYTEISALIGNED (),
    .RXBYTEREALIGN (),
    .RXCOMMADET (),
    .RXCOMMADETEN (1'd1),
    .RXMCOMMAALIGNEN (rx_comma_align_enb),
    .RXPCOMMAALIGNEN (rx_comma_align_enb),
    .RXCHANBONDSEQ (),
    .RXCHBONDEN (1'd0),
    .RXCHBONDLEVEL (3'd0),
    .RXCHBONDMASTER (1'd1),
    .RXCHBONDO (),
    .RXCHBONDSLAVE (1'd0),
    .RXCHANISALIGNED (),
    .RXCHANREALIGN (),
    .RXDFEAGCHOLD (1'd0),
    .RXDFEAGCOVRDEN (1'd0),
    .RXDFECM1EN (1'd0),
    .RXDFELFHOLD (1'd0),
    .RXDFELFOVRDEN (1'd1),
    .RXDFELPMRESET (1'd0),
    .RXDFETAP2HOLD (1'd0),
    .RXDFETAP2OVRDEN (1'd0),
    .RXDFETAP3HOLD (1'd0),
    .RXDFETAP3OVRDEN (1'd0),
    .RXDFETAP4HOLD (1'd0),
    .RXDFETAP4OVRDEN (1'd0),
    .RXDFETAP5HOLD (1'd0),
    .RXDFETAP5OVRDEN (1'd0),
    .RXDFEUTHOLD (1'd0),
    .RXDFEUTOVRDEN (1'd0),
    .RXDFEVPHOLD (1'd0),
    .RXDFEVPOVRDEN (1'd0),
    .RXDFEVSEN (1'd0),
    .RXLPMLFKLOVRDEN (1'd0),
    .RXMONITOROUT (),
    .RXMONITORSEL (2'd0),
    .RXOSHOLD (1'd0),
    .RXOSOVRDEN (1'd0),
    .RXLPMHFHOLD (1'd0),
    .RXLPMHFOVRDEN (1'd0),
    .RXLPMLFHOLD (1'd0),
    .RXRATEDONE (),
    .RXOUTCLK (rx_out_clk),
    .RXOUTCLKFABRIC (),
    .RXOUTCLKPCS (),
    .RXOUTCLKSEL (rx_out_clk_sel),
    .RXDATAVALID (),
    .RXHEADER (),
    .RXHEADERVALID (),
    .RXSTARTOFSEQ (),
    .RXGEARBOXSLIP (1'd0),
    .GTRXRESET (rx_rst),
    .RXOOBRESET (1'd0),
    .RXPCSRESET (1'd0),
    .RXPMARESET (1'd0),
    .RXLPMEN (1'd0),
    .RXCOMSASDET (),
    .RXCOMWAKEDET (),
    .RXCOMINITDET (),
    .RXELECIDLE (),
    .RXELECIDLEMODE (2'b10),
    .RXPOLARITY (1'd0),
    .RXSLIDE (1'd0),
    .RXCHARISCOMMA (),
    .RXCHARISK ({rx_charisk_open_s, rx_charisk}),
    .RXCHBONDI (5'd0),
    .RXRESETDONE (rx_rst_done),
    .RXQPIEN (1'd0),
    .RXQPISENN (),
    .RXQPISENP (),
    .TXPHDLYTSTCLK (1'd0),
    .TXPOSTCURSOR (5'd0),
    .TXPOSTCURSORINV (1'd0),
    .TXPRECURSOR (5'd0),
    .TXPRECURSORINV (1'd0),
    .TXQPIBIASEN (1'd0),
    .TXQPISTRONGPDOWN (1'd0),
    .TXQPIWEAKPUP (1'd0),
    .CFGRESET (1'd0),
    .GTTXRESET (tx_rst),
    .PCSRSVDOUT (),
    .TXUSERRDY (tx_user_ready[3]),
    .GTRESETSEL (1'd0),
    .RESETOVRD (1'd0),
    .TXCHARDISPMODE (8'd0),
    .TXCHARDISPVAL (8'd0),
    .TXUSRCLK (tx_clk),
    .TXUSRCLK2 (tx_clk),
    .TXELECIDLE (1'd0),
    .TXMARGIN (3'd0),
    .TXRATE (3'd0),
    .TXSWING (1'd0),
    .TXPRBSFORCEERR (1'd0),
    .TXDLYBYPASS (1'd1),
    .TXDLYEN (1'd0),
    .TXDLYHOLD (1'd0),
    .TXDLYOVRDEN (1'd0),
    .TXDLYSRESET (1'd0),
    .TXDLYSRESETDONE (),
    .TXDLYUPDOWN (1'd0),
    .TXPHALIGN (1'd0),
    .TXPHALIGNDONE (),
    .TXPHALIGNEN (1'd0),
    .TXPHDLYPD (1'd0),
    .TXPHDLYRESET (1'd0),
    .TXPHINIT (1'd0),
    .TXPHINITDONE (),
    .TXPHOVRDEN (1'd0),
    .TXBUFSTATUS (),
    .TXBUFDIFFCTRL (3'b100),
    .TXDEEMPH (1'd0),
    .TXDIFFCTRL (4'b1000),
    .TXDIFFPD (1'd0),
    .TXINHIBIT (1'd0),
    .TXMAINCURSOR (7'b0000000),
    .TXPISOPD (1'd0),
    .TXDATA ({32'd0, tx_data}),
    .GTXTXP (tx_p),
    .GTXTXN (tx_n),
    .TXOUTCLK (tx_out_clk),
    .TXOUTCLKFABRIC (),
    .TXOUTCLKPCS (),
    .TXOUTCLKSEL (tx_out_clk_sel),
    .TXRATEDONE (),
    .TXCHARISK ({4'd0, tx_charisk}),
    .TXGEARBOXREADY (),
    .TXHEADER (3'd0),
    .TXSEQUENCE (7'd0),
    .TXSTARTSEQ (1'd0),
    .TXPCSRESET (1'd0),
    .TXPMARESET (1'd0),
    .TXRESETDONE (tx_rst_done),
    .TXCOMFINISH (),
    .TXCOMINIT (1'd0),
    .TXCOMSAS (1'd0),
    .TXCOMWAKE (1'd0),
    .TXPDELECIDLEMODE (1'd0),
    .TXPOLARITY (1'd0),
    .TXDETECTRX (1'd0),
    .TX8B10BBYPASS (8'd0),
    .TXPRBSSEL (3'd0),
    .TXQPISENP (),
    .TXQPISENN ());
     
endmodule     

// ***************************************************************************
// ***************************************************************************

