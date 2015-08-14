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

`timescale 1ns/100ps

module axi_jesd_gt (

  // physical interface

  ref_clk_q,
  ref_clk_c,

  rx_data_p,
  rx_data_n,
  rx_sync,
  rx_sysref,
  rx_ext_sysref,

  tx_data_p,
  tx_data_n,
  tx_sync,
  tx_sysref,
  tx_ext_sysref,

  // core interface

  rx_rst,
  rx_jesd_rst,
  rx_clk_g,
  rx_clk,
  rx_data,
  rx_sof,
  rx_gt_charisk,
  rx_gt_disperr,
  rx_gt_notintable,
  rx_gt_data,
  rx_rst_done,
  rx_ip_comma_align,
  rx_ip_sync,
  rx_ip_sof,
  rx_ip_data,

  tx_rst,
  tx_jesd_rst,
  tx_clk_g,
  tx_clk,
  tx_data,
  tx_gt_charisk,
  tx_gt_data,
  tx_rst_done,
  tx_ip_sync,
  tx_ip_sof,
  tx_ip_data,

  // axi - clock & reset

  axi_aclk,
  axi_aresetn,

  // axi-lite (slave)

  s_axi_awvalid,
  s_axi_awaddr,
  s_axi_awready,
  s_axi_wvalid,
  s_axi_wdata,
  s_axi_wstrb,
  s_axi_wready,
  s_axi_bvalid,
  s_axi_bresp,
  s_axi_bready,
  s_axi_arvalid,
  s_axi_araddr,
  s_axi_arready,
  s_axi_rvalid,
  s_axi_rdata,
  s_axi_rresp,
  s_axi_rready,

  // axi (master)

  m_axi_awvalid,
  m_axi_awaddr,
  m_axi_awprot,
  m_axi_awready,
  m_axi_wvalid,
  m_axi_wdata,
  m_axi_wstrb,
  m_axi_wready,
  m_axi_bvalid,
  m_axi_bresp,
  m_axi_bready,
  m_axi_arvalid,
  m_axi_araddr,
  m_axi_arprot,
  m_axi_arready,
  m_axi_rvalid,
  m_axi_rdata,
  m_axi_rresp,
  m_axi_rready);

  parameter   PCORE_ID = 0;
  parameter   PCORE_DEVICE_TYPE = 0;
  parameter   PCORE_NUM_OF_TX_LANES = 4;
  parameter   PCORE_NUM_OF_RX_LANES = 4;
  parameter   PCORE_QPLL_REFCLK_DIV = 1;
  parameter   PCORE_QPLL_CFG = 27'h0680181;
  parameter   PCORE_QPLL_FBDIV_RATIO = 1'b1;
  parameter   PCORE_QPLL_FBDIV = 10'b0000110000;
  parameter   PCORE_CPLL_FBDIV  = 2;
  parameter   PCORE_RX_OUT_DIV  = 1;
  parameter   PCORE_TX_OUT_DIV  = 1;
  parameter   PCORE_RX_CLK25_DIV  = 20;
  parameter   PCORE_TX_CLK25_DIV  = 20;
  parameter   PCORE_PMA_RSV  = 32'h001E7080;
  parameter   PCORE_RX_CDR_CFG  = 72'h0b000023ff10400020;
  parameter   PCORE_TX_LANE_SEL_0 = 0;
  parameter   PCORE_TX_LANE_SEL_1 = 1;
  parameter   PCORE_TX_LANE_SEL_2 = 2;
  parameter   PCORE_TX_LANE_SEL_3 = 3;
  parameter   PCORE_TX_LANE_SEL_4 = 4;
  parameter   PCORE_TX_LANE_SEL_5 = 5;
  parameter   PCORE_TX_LANE_SEL_6 = 6;
  parameter   PCORE_TX_LANE_SEL_7 = 7;
  parameter   PCORE_TX_LANE_SEL_8 = 8;

  localparam  PCORE_NUM_OF_LANES = (PCORE_NUM_OF_TX_LANES > PCORE_NUM_OF_RX_LANES) ?
                                    PCORE_NUM_OF_TX_LANES : PCORE_NUM_OF_RX_LANES;

  // physical interface

  input                                         ref_clk_q;
  input                                         ref_clk_c;

  input   [((PCORE_NUM_OF_RX_LANES* 1)-1):0]    rx_data_p;
  input   [((PCORE_NUM_OF_RX_LANES* 1)-1):0]    rx_data_n;
  output                                        rx_sync;
  output                                        rx_sysref;
  input                                         rx_ext_sysref;

  output  [((PCORE_NUM_OF_TX_LANES* 1)-1):0]    tx_data_p;
  output  [((PCORE_NUM_OF_TX_LANES* 1)-1):0]    tx_data_n;
  input                                         tx_sync;
  output                                        tx_sysref;
  input                                         tx_ext_sysref;

  // core interface

  output                                        rx_rst;
  output                                        rx_jesd_rst;
  output                                        rx_clk_g;
  input                                         rx_clk;
  output  [((PCORE_NUM_OF_RX_LANES*32)-1):0]    rx_data;
  output  [((PCORE_NUM_OF_RX_LANES* 1)-1):0]    rx_sof;
  output  [((PCORE_NUM_OF_RX_LANES* 4)-1):0]    rx_gt_charisk;
  output  [((PCORE_NUM_OF_RX_LANES* 4)-1):0]    rx_gt_disperr;
  output  [((PCORE_NUM_OF_RX_LANES* 4)-1):0]    rx_gt_notintable;
  output  [((PCORE_NUM_OF_RX_LANES*32)-1):0]    rx_gt_data;
  output                                        rx_rst_done;
  input                                         rx_ip_comma_align;
  input                                         rx_ip_sync;
  input   [  3:0]                               rx_ip_sof;
  input   [((PCORE_NUM_OF_RX_LANES*32)-1):0]    rx_ip_data;

  output                                        tx_rst;
  output                                        tx_jesd_rst;
  output                                        tx_clk_g;
  input                                         tx_clk;
  input   [((PCORE_NUM_OF_TX_LANES*32)-1):0]    tx_data;
  input   [((PCORE_NUM_OF_TX_LANES* 4)-1):0]    tx_gt_charisk;
  input   [((PCORE_NUM_OF_TX_LANES*32)-1):0]    tx_gt_data;
  output                                        tx_rst_done;
  output                                        tx_ip_sync;
  input   [  3:0]                               tx_ip_sof;
  output  [((PCORE_NUM_OF_TX_LANES*32)-1):0]    tx_ip_data;

  input                                         axi_aclk;
  input                                         axi_aresetn;

  // axi interface

  input                                         s_axi_awvalid;
  input   [ 31:0]                               s_axi_awaddr;
  output                                        s_axi_awready;
  input                                         s_axi_wvalid;
  input   [ 31:0]                               s_axi_wdata;
  input   [  3:0]                               s_axi_wstrb;
  output                                        s_axi_wready;
  output                                        s_axi_bvalid;
  output  [  1:0]                               s_axi_bresp;
  input                                         s_axi_bready;
  input                                         s_axi_arvalid;
  input   [ 31:0]                               s_axi_araddr;
  output                                        s_axi_arready;
  output                                        s_axi_rvalid;
  output  [ 31:0]                               s_axi_rdata;
  output  [  1:0]                               s_axi_rresp;
  input                                         s_axi_rready;

  // master interface

  output                                        m_axi_awvalid;
  output  [ 31:0]                               m_axi_awaddr;
  output  [  2:0]                               m_axi_awprot;
  input                                         m_axi_awready;
  output                                        m_axi_wvalid;
  output  [ 31:0]                               m_axi_wdata;
  output  [  3:0]                               m_axi_wstrb;
  input                                         m_axi_wready;
  input                                         m_axi_bvalid;
  input   [  1:0]                               m_axi_bresp;
  output                                        m_axi_bready;
  output                                        m_axi_arvalid;
  output  [ 31:0]                               m_axi_araddr;
  output  [  2:0]                               m_axi_arprot;
  input                                         m_axi_arready;
  input                                         m_axi_rvalid;
  input   [ 31:0]                               m_axi_rdata;
  input   [  1:0]                               m_axi_rresp;
  output                                        m_axi_rready;

  // reset and clocks

  wire                                          gt_pll_rst;
  wire                                          gt_rx_rst;
  wire                                          gt_tx_rst;
  wire                                          qpll_clk_0;
  wire                                          qpll_ref_clk_0;
  wire                                          qpll_clk_1;
  wire                                          qpll_ref_clk_1;
  wire    [  7:0]                               qpll_clk;
  wire    [  7:0]                               qpll_ref_clk;
  wire    [((PCORE_NUM_OF_LANES* 1)-1):0]       rx_out_clk;
  wire    [((PCORE_NUM_OF_LANES* 1)-1):0]       tx_out_clk;
  wire                                          up_rstn;
  wire                                          up_clk;
  wire                                          up_drp_rst;

  // internal signals

  wire    [  8:0]                               up_status_extn_s;
  wire    [  8:0]                               rx_rst_done_extn_s;
  wire    [  8:0]                               rx_pll_locked_extn_s;
  wire    [  8:0]                               tx_rst_done_extn_s;
  wire    [  8:0]                               tx_pll_locked_extn_s;
  wire    [((PCORE_NUM_OF_LANES* 1)-1):0]       rx_mon_trigger_s;
  wire    [((PCORE_NUM_OF_LANES*50)-1):0]       rx_mon_data_s;
  wire    [ 15:0]                               up_drp_rdata_gt_s[15:0];
  wire                                          up_drp_ready_gt_s[15:0];
  wire    [  7:0]                               up_drp_rxrate_gt_s[15:0];
  wire    [((PCORE_NUM_OF_LANES* 1)-1):0]       rx_data_p_s;
  wire    [((PCORE_NUM_OF_LANES* 1)-1):0]       rx_data_n_s;
  wire    [((PCORE_NUM_OF_LANES*32)-1):0]       rx_data_s;
  wire    [((PCORE_NUM_OF_LANES* 1)-1):0]       rx_sof_s;
  wire    [((PCORE_NUM_OF_LANES* 4)-1):0]       rx_gt_charisk_s;
  wire    [((PCORE_NUM_OF_LANES* 4)-1):0]       rx_gt_disperr_s;
  wire    [((PCORE_NUM_OF_LANES* 4)-1):0]       rx_gt_notintable_s;
  wire    [((PCORE_NUM_OF_LANES*32)-1):0]       rx_gt_data_s;
  wire    [((PCORE_NUM_OF_LANES* 4)-1):0]       rx_ilas_f_s;
  wire    [((PCORE_NUM_OF_LANES* 4)-1):0]       rx_ilas_q_s;
  wire    [((PCORE_NUM_OF_LANES* 4)-1):0]       rx_ilas_a_s;
  wire    [((PCORE_NUM_OF_LANES* 4)-1):0]       rx_ilas_r_s;
  wire    [((PCORE_NUM_OF_LANES* 4)-1):0]       rx_cgs_k_s;
  wire    [((PCORE_NUM_OF_LANES*32)-1):0]       rx_ip_data_s;
  wire    [((PCORE_NUM_OF_LANES* 1)-1):0]       tx_data_p_s;
  wire    [((PCORE_NUM_OF_LANES* 1)-1):0]       tx_data_n_s;
  wire    [((PCORE_NUM_OF_LANES* 4)-1):0]       tx_gt_charisk_s;
  wire    [((PCORE_NUM_OF_LANES*32)-1):0]       tx_gt_data_s;
  wire    [287:0]                               tx_gt_data_extn_zero_s;
  wire    [ 35:0]                               tx_gt_charisk_extn_zero_s;
  wire    [287:0]                               tx_gt_data_extn_s;
  wire    [ 35:0]                               tx_gt_charisk_extn_s;
  wire    [287:0]                               tx_gt_data_mux_s;
  wire    [ 35:0]                               tx_gt_charisk_mux_s;
  wire                                          qpll_locked_0_s;
  wire                                          qpll_locked_1_s;
  wire    [  7:0]                               qpll_locked_s;
  wire    [((PCORE_NUM_OF_LANES* 1)-1):0]       rx_rst_done_s;
  wire    [((PCORE_NUM_OF_LANES* 1)-1):0]       rx_pll_locked_s;
  wire    [((PCORE_NUM_OF_LANES* 1)-1):0]       tx_rst_done_s;
  wire    [((PCORE_NUM_OF_LANES* 1)-1):0]       tx_pll_locked_s;
  wire                                          up_lpm_dfe_n_s;
  wire                                          up_cpll_pd_s;
  wire    [  1:0]                               up_rx_sys_clk_sel_s;
  wire    [  2:0]                               up_rx_out_clk_sel_s;
  wire    [  1:0]                               up_tx_sys_clk_sel_s;
  wire    [  2:0]                               up_tx_out_clk_sel_s;
  wire                                          up_drp_sel_s;
  wire                                          up_drp_wr_s;
  wire    [ 11:0]                               up_drp_addr_s;
  wire    [ 15:0]                               up_drp_wdata_s;
  wire    [ 15:0]                               up_drp_rdata_s;
  wire                                          up_drp_ready_s;
  wire    [  7:0]                               up_drp_lanesel_s;
  wire    [  7:0]                               up_drp_rxrate_s;
  wire                                          up_es_drp_sel_s;
  wire                                          up_es_drp_wr_s;
  wire    [ 11:0]                               up_es_drp_addr_s;
  wire    [ 15:0]                               up_es_drp_wdata_s;
  wire    [ 15:0]                               up_es_drp_rdata_s;
  wire                                          up_es_drp_ready_s;
  wire                                          up_es_start_s;
  wire                                          up_es_stop_s;
  wire                                          up_es_init_s;
  wire                                          up_es_lpm_dfe_n_s;
  wire    [ 15:0]                               up_es_sdata0_s;
  wire    [ 15:0]                               up_es_sdata1_s;
  wire    [ 15:0]                               up_es_sdata2_s;
  wire    [ 15:0]                               up_es_sdata3_s;
  wire    [ 15:0]                               up_es_sdata4_s;
  wire    [ 15:0]                               up_es_qdata0_s;
  wire    [ 15:0]                               up_es_qdata1_s;
  wire    [ 15:0]                               up_es_qdata2_s;
  wire    [ 15:0]                               up_es_qdata3_s;
  wire    [ 15:0]                               up_es_qdata4_s;
  wire    [  4:0]                               up_es_prescale_s;
  wire    [ 11:0]                               up_es_hoffset_min_s;
  wire    [ 11:0]                               up_es_hoffset_max_s;
  wire    [ 11:0]                               up_es_hoffset_step_s;
  wire    [  7:0]                               up_es_voffset_min_s;
  wire    [  7:0]                               up_es_voffset_max_s;
  wire    [  7:0]                               up_es_voffset_step_s;
  wire    [  1:0]                               up_es_voffset_range_s;
  wire    [ 31:0]                               up_es_start_addr_s;
  wire                                          up_es_dmaerr_s;
  wire                                          up_es_status_s;
  wire                                          up_wreq_s;
  wire    [ 13:0]                               up_waddr_s;
  wire    [ 31:0]                               up_wdata_s;
  wire                                          up_wack_s;
  wire                                          up_rreq_s;
  wire    [ 13:0]                               up_raddr_s;
  wire    [ 31:0]                               up_rdata_s;
  wire                                          up_rack_s;

  // debug interface

  assign rx_mon_data = {rx_sync, rx_sysref, rx_ip_sof, rx_ip_data, rx_mon_data_s[((PCORE_NUM_OF_RX_LANES*50)-1):0]};
  assign rx_mon_trigger = {rx_sync, rx_sysref, rx_mon_trigger_s[((PCORE_NUM_OF_RX_LANES* 1)-1):0]};

  assign tx_mon_data = {tx_sync, tx_sysref, tx_ip_sof, tx_gt_charisk, tx_gt_data};
  assign tx_mon_trigger = {tx_sync, tx_sysref, tx_ip_sof};

  // signal name changes

  assign up_rstn = axi_aresetn;
  assign up_clk = axi_aclk;

  // drp is simply over-defined to avoid errors with singluar entries

  assign up_status_extn_s = 9'hff;
  assign rx_rst_done_extn_s = {up_status_extn_s[8:PCORE_NUM_OF_LANES], rx_rst_done_s};
  assign rx_pll_locked_extn_s = {up_status_extn_s[8:PCORE_NUM_OF_LANES], rx_pll_locked_s};
  assign tx_rst_done_extn_s = {up_status_extn_s[8:PCORE_NUM_OF_LANES], tx_rst_done_s};
  assign tx_pll_locked_extn_s = {up_status_extn_s[8:PCORE_NUM_OF_LANES], tx_pll_locked_s};

  assign up_drp_rdata_s =   up_drp_rdata_gt_s[15] | up_drp_rdata_gt_s[14] |
                            up_drp_rdata_gt_s[13] | up_drp_rdata_gt_s[12] |
                            up_drp_rdata_gt_s[11] | up_drp_rdata_gt_s[10] |
                            up_drp_rdata_gt_s[ 9] | up_drp_rdata_gt_s[ 8] |
                            up_drp_rdata_gt_s[ 7] | up_drp_rdata_gt_s[ 6] |
                            up_drp_rdata_gt_s[ 5] | up_drp_rdata_gt_s[ 4] |
                            up_drp_rdata_gt_s[ 3] | up_drp_rdata_gt_s[ 2] |
                            up_drp_rdata_gt_s[ 1] | up_drp_rdata_gt_s[ 0];

  assign up_drp_ready_s =   up_drp_ready_gt_s[15] | up_drp_ready_gt_s[14] |
                            up_drp_ready_gt_s[13] | up_drp_ready_gt_s[12] |
                            up_drp_ready_gt_s[11] | up_drp_ready_gt_s[10] |
                            up_drp_ready_gt_s[ 9] | up_drp_ready_gt_s[ 8] |
                            up_drp_ready_gt_s[ 7] | up_drp_ready_gt_s[ 6] |
                            up_drp_ready_gt_s[ 5] | up_drp_ready_gt_s[ 4] |
                            up_drp_ready_gt_s[ 3] | up_drp_ready_gt_s[ 2] |
                            up_drp_ready_gt_s[ 1] | up_drp_ready_gt_s[ 0];

  assign up_drp_rxrate_s =  up_drp_rxrate_gt_s[15] | up_drp_rxrate_gt_s[14] |
                            up_drp_rxrate_gt_s[13] | up_drp_rxrate_gt_s[12] |
                            up_drp_rxrate_gt_s[11] | up_drp_rxrate_gt_s[10] |
                            up_drp_rxrate_gt_s[ 9] | up_drp_rxrate_gt_s[ 8] |
                            up_drp_rxrate_gt_s[ 7] | up_drp_rxrate_gt_s[ 6] |
                            up_drp_rxrate_gt_s[ 5] | up_drp_rxrate_gt_s[ 4] |
                            up_drp_rxrate_gt_s[ 3] | up_drp_rxrate_gt_s[ 2] |
                            up_drp_rxrate_gt_s[ 1] | up_drp_rxrate_gt_s[ 0];


  // asymmetric widths -- receive

  assign rx_data = rx_data_s[((PCORE_NUM_OF_RX_LANES*32)-1):0];
  assign rx_sof = rx_sof_s[((PCORE_NUM_OF_RX_LANES* 1)-1):0];
  assign rx_gt_charisk = rx_gt_charisk_s[((PCORE_NUM_OF_RX_LANES* 4)-1):0];
  assign rx_gt_disperr = rx_gt_disperr_s[((PCORE_NUM_OF_RX_LANES* 4)-1):0];
  assign rx_gt_notintable = rx_gt_notintable_s[((PCORE_NUM_OF_RX_LANES* 4)-1):0];
  assign rx_gt_data = rx_gt_data_s[((PCORE_NUM_OF_RX_LANES*32)-1):0];

  generate
  if (PCORE_NUM_OF_LANES == PCORE_NUM_OF_RX_LANES) begin
  assign rx_data_p_s = rx_data_p;
  assign rx_data_n_s = rx_data_n;
  assign rx_ip_data_s = rx_ip_data;
  end else begin
  assign rx_data_p_s[((PCORE_NUM_OF_LANES* 1)-1):(PCORE_NUM_OF_RX_LANES* 1)] = 'd0;
  assign rx_data_n_s[((PCORE_NUM_OF_LANES* 1)-1):(PCORE_NUM_OF_RX_LANES* 1)] = 'd0;
  assign rx_ip_data_s[((PCORE_NUM_OF_LANES*32)-1):(PCORE_NUM_OF_RX_LANES*32)] = 'd0;
  assign rx_data_p_s[((PCORE_NUM_OF_RX_LANES* 1)-1):0] = rx_data_p;
  assign rx_data_n_s[((PCORE_NUM_OF_RX_LANES* 1)-1):0] = rx_data_n;
  assign rx_ip_data_s[((PCORE_NUM_OF_RX_LANES*32)-1):0] = rx_ip_data;
  end
  endgenerate

  // asymmetric widths -- transmit

  assign tx_data_p = tx_data_p_s[((PCORE_NUM_OF_TX_LANES* 1)-1):0];
  assign tx_data_n = tx_data_n_s[((PCORE_NUM_OF_TX_LANES* 1)-1):0];

  generate
  if (PCORE_NUM_OF_LANES == PCORE_NUM_OF_TX_LANES) begin
  assign tx_gt_charisk_s = tx_gt_charisk;
  assign tx_gt_data_s = tx_gt_data;
  end else begin
  assign tx_gt_charisk_s[((PCORE_NUM_OF_LANES* 4)-1):(PCORE_NUM_OF_TX_LANES* 4)] = 'd0;
  assign tx_gt_data_s[((PCORE_NUM_OF_LANES*32)-1):(PCORE_NUM_OF_TX_LANES*32)] = 'd0;
  assign tx_gt_charisk_s[((PCORE_NUM_OF_TX_LANES* 4)-1):0] = tx_gt_charisk;
  assign tx_gt_data_s[((PCORE_NUM_OF_TX_LANES*32)-1):0] = tx_gt_data;
  end
  endgenerate

  // transmit data interleave -- since transceivers are shared, lane assignments may not match pin assignments

  assign tx_ip_data = tx_data;

  assign tx_gt_data_extn_zero_s = 288'd0;
  assign tx_gt_charisk_extn_zero_s = 36'd0;
  assign tx_gt_data_extn_s = {tx_gt_data_extn_zero_s[(((9-PCORE_NUM_OF_LANES)*32)-1):0], tx_gt_data_s};
  assign tx_gt_charisk_extn_s = {tx_gt_charisk_extn_zero_s[(((9-PCORE_NUM_OF_LANES)*4)-1):0], tx_gt_charisk_s};

  assign tx_gt_data_mux_s[((8*32)+31):(8*32)] = tx_gt_data_extn_s[((PCORE_TX_LANE_SEL_8*32)+31):(PCORE_TX_LANE_SEL_8*32)];
  assign tx_gt_data_mux_s[((7*32)+31):(7*32)] = tx_gt_data_extn_s[((PCORE_TX_LANE_SEL_7*32)+31):(PCORE_TX_LANE_SEL_7*32)];
  assign tx_gt_data_mux_s[((6*32)+31):(6*32)] = tx_gt_data_extn_s[((PCORE_TX_LANE_SEL_6*32)+31):(PCORE_TX_LANE_SEL_6*32)];
  assign tx_gt_data_mux_s[((5*32)+31):(5*32)] = tx_gt_data_extn_s[((PCORE_TX_LANE_SEL_5*32)+31):(PCORE_TX_LANE_SEL_5*32)];
  assign tx_gt_data_mux_s[((4*32)+31):(4*32)] = tx_gt_data_extn_s[((PCORE_TX_LANE_SEL_4*32)+31):(PCORE_TX_LANE_SEL_4*32)];
  assign tx_gt_data_mux_s[((3*32)+31):(3*32)] = tx_gt_data_extn_s[((PCORE_TX_LANE_SEL_3*32)+31):(PCORE_TX_LANE_SEL_3*32)];
  assign tx_gt_data_mux_s[((2*32)+31):(2*32)] = tx_gt_data_extn_s[((PCORE_TX_LANE_SEL_2*32)+31):(PCORE_TX_LANE_SEL_2*32)];
  assign tx_gt_data_mux_s[((1*32)+31):(1*32)] = tx_gt_data_extn_s[((PCORE_TX_LANE_SEL_1*32)+31):(PCORE_TX_LANE_SEL_1*32)];
  assign tx_gt_data_mux_s[((0*32)+31):(0*32)] = tx_gt_data_extn_s[((PCORE_TX_LANE_SEL_0*32)+31):(PCORE_TX_LANE_SEL_0*32)];
  assign tx_gt_charisk_mux_s[((8*4)+3):(8*4)] = tx_gt_charisk_extn_s[((PCORE_TX_LANE_SEL_8*4)+3):(PCORE_TX_LANE_SEL_8*4)];
  assign tx_gt_charisk_mux_s[((7*4)+3):(7*4)] = tx_gt_charisk_extn_s[((PCORE_TX_LANE_SEL_7*4)+3):(PCORE_TX_LANE_SEL_7*4)];
  assign tx_gt_charisk_mux_s[((6*4)+3):(6*4)] = tx_gt_charisk_extn_s[((PCORE_TX_LANE_SEL_6*4)+3):(PCORE_TX_LANE_SEL_6*4)];
  assign tx_gt_charisk_mux_s[((5*4)+3):(5*4)] = tx_gt_charisk_extn_s[((PCORE_TX_LANE_SEL_5*4)+3):(PCORE_TX_LANE_SEL_5*4)];
  assign tx_gt_charisk_mux_s[((4*4)+3):(4*4)] = tx_gt_charisk_extn_s[((PCORE_TX_LANE_SEL_4*4)+3):(PCORE_TX_LANE_SEL_4*4)];
  assign tx_gt_charisk_mux_s[((3*4)+3):(3*4)] = tx_gt_charisk_extn_s[((PCORE_TX_LANE_SEL_3*4)+3):(PCORE_TX_LANE_SEL_3*4)];
  assign tx_gt_charisk_mux_s[((2*4)+3):(2*4)] = tx_gt_charisk_extn_s[((PCORE_TX_LANE_SEL_2*4)+3):(PCORE_TX_LANE_SEL_2*4)];
  assign tx_gt_charisk_mux_s[((1*4)+3):(1*4)] = tx_gt_charisk_extn_s[((PCORE_TX_LANE_SEL_1*4)+3):(PCORE_TX_LANE_SEL_1*4)];
  assign tx_gt_charisk_mux_s[((0*4)+3):(0*4)] = tx_gt_charisk_extn_s[((PCORE_TX_LANE_SEL_0*4)+3):(PCORE_TX_LANE_SEL_0*4)];

  // clock buffers

  generate
  if (PCORE_DEVICE_TYPE == 0) begin
  BUFG i_bufg_rx_clk (
    .I (rx_out_clk[0]),
    .O (rx_clk_g));
  end

  if (PCORE_DEVICE_TYPE == 0) begin
  BUFG i_bufg_tx_clk (
    .I (tx_out_clk[0]),
    .O (tx_clk_g));
  end

  if (PCORE_DEVICE_TYPE == 1) begin
  BUFG_GT i_bufg_rx_clk (
    .I (rx_out_clk[0]),
    .O (rx_clk_g));
  end

  if (PCORE_DEVICE_TYPE == 1) begin
  BUFG_GT i_bufg_tx_clk (
    .I (tx_out_clk[0]),
    .O (tx_clk_g));
  end
  endgenerate

  // transceivers

  assign qpll_clk = {{4{qpll_clk_1}}, {4{qpll_clk_0}}};
  assign qpll_ref_clk = {{4{qpll_ref_clk_1}}, {4{qpll_ref_clk_0}}};
  assign qpll_locked_s = {{4{qpll_locked_1_s}}, {4{qpll_locked_0_s}}};

  ad_gt_common_1 #(
    .DRP_ID (14),
    .GTH_GTX_N (PCORE_DEVICE_TYPE),
    .QPLL_REFCLK_DIV (PCORE_QPLL_REFCLK_DIV),
    .QPLL_CFG (PCORE_QPLL_CFG),
    .QPLL_FBDIV_RATIO (PCORE_QPLL_FBDIV_RATIO),
    .QPLL_FBDIV (PCORE_QPLL_FBDIV))
  i_gt_common_1 (
    .rst (gt_pll_rst),
    .ref_clk (ref_clk_q),
    .qpll_clk (qpll_clk_0),
    .qpll_ref_clk (qpll_ref_clk_0),
    .qpll_locked (qpll_locked_0_s),
    .up_clk (up_clk),
    .up_drp_sel (up_drp_sel_s),
    .up_drp_addr (up_drp_addr_s),
    .up_drp_wr (up_drp_wr_s),
    .up_drp_wdata (up_drp_wdata_s),
    .up_drp_rdata (up_drp_rdata_gt_s[14]),
    .up_drp_ready (up_drp_ready_gt_s[14]),
    .up_drp_lanesel (up_drp_lanesel_s),
    .up_drp_rxrate (up_drp_rxrate_gt_s[14]));

  ad_gt_common_1 #(
    .DRP_ID (15),
    .GTH_GTX_N (PCORE_DEVICE_TYPE),
    .QPLL_REFCLK_DIV (PCORE_QPLL_REFCLK_DIV),
    .QPLL_CFG (PCORE_QPLL_CFG),
    .QPLL_FBDIV_RATIO (PCORE_QPLL_FBDIV_RATIO),
    .QPLL_FBDIV (PCORE_QPLL_FBDIV))
  i_gt_common_2 (
    .rst (gt_pll_rst),
    .ref_clk (ref_clk_q),
    .qpll_clk (qpll_clk_1),
    .qpll_ref_clk (qpll_ref_clk_1),
    .qpll_locked (qpll_locked_1_s),
    .up_clk (up_clk),
    .up_drp_sel (up_drp_sel_s),
    .up_drp_addr (up_drp_addr_s),
    .up_drp_wr (up_drp_wr_s),
    .up_drp_wdata (up_drp_wdata_s),
    .up_drp_rdata (up_drp_rdata_gt_s[15]),
    .up_drp_ready (up_drp_ready_gt_s[15]),
    .up_drp_lanesel (up_drp_lanesel_s),
    .up_drp_rxrate (up_drp_rxrate_gt_s[15]));

  genvar n;
  generate

  for (n = PCORE_NUM_OF_LANES; n < 14; n = n + 1) begin: g_unused_1
  assign up_drp_rdata_gt_s[n] = 'd0;
  assign up_drp_ready_gt_s[n] = 'd0;
  assign up_drp_rxrate_gt_s[n] = 'd0;
  end

  for (n = 0; n < PCORE_NUM_OF_LANES; n = n + 1) begin: g_lane_1

  ad_jesd_align i_jesd_align (
    .rx_clk (rx_clk),
    .rx_ip_sof (rx_ip_sof),
    .rx_ip_data (rx_ip_data_s[n*32+31:n*32]),
    .rx_sof (rx_sof_s[n]),
    .rx_data (rx_data_s[n*32+31:n*32]));

  ad_gt_channel_1 #(
    .DRP_ID (n),
    .GTH_GTX_N (PCORE_DEVICE_TYPE),
    .CPLL_FBDIV (PCORE_CPLL_FBDIV),
    .RX_OUT_DIV (PCORE_RX_OUT_DIV),
    .TX_OUT_DIV (PCORE_TX_OUT_DIV),
    .RX_CLK25_DIV (PCORE_RX_CLK25_DIV),
    .TX_CLK25_DIV (PCORE_TX_CLK25_DIV),
    .PMA_RSV (PCORE_PMA_RSV),
    .RX_CDR_CFG (PCORE_RX_CDR_CFG))
  i_gt_channel_1 (
    .ref_clk (ref_clk_c),
    .lpm_dfe_n (up_lpm_dfe_n_s),
    .cpll_pd (up_cpll_pd_s),
    .cpll_rst (gt_pll_rst),
    .qpll_clk (qpll_clk[n]),
    .qpll_ref_clk (qpll_ref_clk[n]),
    .qpll_locked (qpll_locked_s[n]),
    .rx_rst (gt_rx_rst),
    .rx_p (rx_data_p_s[n]),
    .rx_n (rx_data_n_s[n]),
    .rx_sys_clk_sel (up_rx_sys_clk_sel_s),
    .rx_out_clk_sel (up_rx_out_clk_sel_s),
    .rx_out_clk (rx_out_clk[n]),
    .rx_rst_done (rx_rst_done_s[n]),
    .rx_pll_locked (rx_pll_locked_s[n]),
    .rx_clk (rx_clk),
    .rx_charisk (rx_gt_charisk_s[n*4+3:n*4]),
    .rx_disperr (rx_gt_disperr_s[n*4+3:n*4]),
    .rx_notintable (rx_gt_notintable_s[n*4+3:n*4]),
    .rx_data (rx_gt_data_s[n*32+31:n*32]),
    .rx_comma_align_enb (rx_ip_comma_align),
    .rx_ilas_f (rx_ilas_f_s[n*4+3:n*4]),
    .rx_ilas_q (rx_ilas_q_s[n*4+3:n*4]),
    .rx_ilas_a (rx_ilas_a_s[n*4+3:n*4]),
    .rx_ilas_r (rx_ilas_r_s[n*4+3:n*4]),
    .rx_cgs_k (rx_cgs_k_s[n*4+3:n*4]),
    .tx_rst (gt_tx_rst),
    .tx_p (tx_data_p_s[n]),
    .tx_n (tx_data_n_s[n]),
    .tx_sys_clk_sel (up_tx_sys_clk_sel_s),
    .tx_out_clk_sel (up_tx_out_clk_sel_s),
    .tx_out_clk (tx_out_clk[n]),
    .tx_rst_done (tx_rst_done_s[n]),
    .tx_pll_locked (tx_pll_locked_s[n]),
    .tx_clk (tx_clk),
    .tx_charisk (tx_gt_charisk_mux_s[n*4+3:n*4]),
    .tx_data (tx_gt_data_mux_s[n*32+31:n*32]),
    .up_clk (up_clk),
    .up_drp_sel (up_drp_sel_s),
    .up_drp_addr (up_drp_addr_s),
    .up_drp_wr (up_drp_wr_s),
    .up_drp_wdata (up_drp_wdata_s),
    .up_drp_rdata (up_drp_rdata_gt_s[n]),
    .up_drp_ready (up_drp_ready_gt_s[n]),
    .up_drp_lanesel (up_drp_lanesel_s),
    .up_drp_rxrate (up_drp_rxrate_gt_s[n]));
  end
  endgenerate

  // eye scan

  ad_gt_es #(.GTH_GTX_N(PCORE_DEVICE_TYPE)) i_gt_es (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_es_drp_sel (up_es_drp_sel_s),
    .up_es_drp_wr (up_es_drp_wr_s),
    .up_es_drp_addr (up_es_drp_addr_s),
    .up_es_drp_wdata (up_es_drp_wdata_s),
    .up_es_drp_rdata (up_es_drp_rdata_s),
    .up_es_drp_ready (up_es_drp_ready_s),
    .axi_awvalid (m_axi_awvalid),
    .axi_awaddr (m_axi_awaddr),
    .axi_awprot (m_axi_awprot),
    .axi_awready (m_axi_awready),
    .axi_wvalid (m_axi_wvalid),
    .axi_wdata (m_axi_wdata),
    .axi_wstrb (m_axi_wstrb),
    .axi_wready (m_axi_wready),
    .axi_bvalid (m_axi_bvalid),
    .axi_bresp (m_axi_bresp),
    .axi_bready (m_axi_bready),
    .axi_arvalid (m_axi_arvalid),
    .axi_araddr (m_axi_araddr),
    .axi_arprot (m_axi_arprot),
    .axi_arready (m_axi_arready),
    .axi_rvalid (m_axi_rvalid),
    .axi_rdata (m_axi_rdata),
    .axi_rresp (m_axi_rresp),
    .axi_rready (m_axi_rready),
    .up_lpm_dfe_n (up_lpm_dfe_n_s),
    .up_es_start (up_es_start_s),
    .up_es_stop (up_es_stop_s),
    .up_es_init (up_es_init_s),
    .up_es_sdata0 (up_es_sdata0_s),
    .up_es_sdata1 (up_es_sdata1_s),
    .up_es_sdata2 (up_es_sdata2_s),
    .up_es_sdata3 (up_es_sdata3_s),
    .up_es_sdata4 (up_es_sdata4_s),
    .up_es_qdata0 (up_es_qdata0_s),
    .up_es_qdata1 (up_es_qdata1_s),
    .up_es_qdata2 (up_es_qdata2_s),
    .up_es_qdata3 (up_es_qdata3_s),
    .up_es_qdata4 (up_es_qdata4_s),
    .up_es_prescale (up_es_prescale_s),
    .up_es_hoffset_min (up_es_hoffset_min_s),
    .up_es_hoffset_max (up_es_hoffset_max_s),
    .up_es_hoffset_step (up_es_hoffset_step_s),
    .up_es_voffset_min (up_es_voffset_min_s),
    .up_es_voffset_max (up_es_voffset_max_s),
    .up_es_voffset_step (up_es_voffset_step_s),
    .up_es_voffset_range (up_es_voffset_range_s),
    .up_es_start_addr (up_es_start_addr_s),
    .up_es_dmaerr (up_es_dmaerr_s),
    .up_es_status (up_es_status_s));

  // processor
    
  up_gt #(.PCORE_ID(PCORE_ID), .PCORE_DEVICE_TYPE(PCORE_DEVICE_TYPE)) i_up_gt (
    .gt_pll_rst (gt_pll_rst),
    .gt_rx_rst (gt_rx_rst),
    .gt_tx_rst (gt_tx_rst),
    .up_lpm_dfe_n (up_lpm_dfe_n_s),
    .up_cpll_pd (up_cpll_pd_s),
    .up_rx_sys_clk_sel (up_rx_sys_clk_sel_s),
    .up_rx_out_clk_sel (up_rx_out_clk_sel_s),
    .up_tx_sys_clk_sel (up_tx_sys_clk_sel_s),
    .up_tx_out_clk_sel (up_tx_out_clk_sel_s),
    .rx_clk (rx_clk),
    .rx_rst (rx_rst),
    .rx_jesd_rst (rx_jesd_rst),
    .rx_ext_sysref (rx_ext_sysref),
    .rx_sysref (rx_sysref),
    .rx_ip_sync (rx_ip_sync),
    .rx_sync (rx_sync),
    .rx_rst_done (rx_rst_done_extn_s[7:0]),
    .rx_pll_locked (rx_pll_locked_extn_s[7:0]),
    .rx_error (1'd0),
    .rx_rst_done_up (rx_rst_done),
    .tx_clk (tx_clk),
    .tx_rst (tx_rst),
    .tx_jesd_rst (tx_jesd_rst),
    .tx_ext_sysref (tx_ext_sysref),
    .tx_sysref (tx_sysref),
    .tx_sync (tx_sync),
    .tx_ip_sync (tx_ip_sync),
    .tx_rst_done (tx_rst_done_extn_s[7:0]),
    .tx_pll_locked (tx_pll_locked_extn_s[7:0]),
    .tx_error (1'd0),
    .tx_rst_done_up (tx_rst_done),
    .up_drp_sel (up_drp_sel_s),
    .up_drp_wr (up_drp_wr_s),
    .up_drp_addr (up_drp_addr_s),
    .up_drp_wdata (up_drp_wdata_s),
    .up_drp_rdata (up_drp_rdata_s),
    .up_drp_ready (up_drp_ready_s),
    .up_drp_lanesel (up_drp_lanesel_s),
    .up_drp_rxrate (up_drp_rxrate_s),
    .up_es_drp_sel (up_es_drp_sel_s),
    .up_es_drp_wr (up_es_drp_wr_s),
    .up_es_drp_addr (up_es_drp_addr_s),
    .up_es_drp_wdata (up_es_drp_wdata_s),
    .up_es_drp_rdata (up_es_drp_rdata_s),
    .up_es_drp_ready (up_es_drp_ready_s),
    .up_es_start (up_es_start_s),
    .up_es_stop (up_es_stop_s),
    .up_es_init (up_es_init_s),
    .up_es_prescale (up_es_prescale_s),
    .up_es_voffset_range (up_es_voffset_range_s),
    .up_es_voffset_step (up_es_voffset_step_s),
    .up_es_voffset_max (up_es_voffset_max_s),
    .up_es_voffset_min (up_es_voffset_min_s),
    .up_es_hoffset_max (up_es_hoffset_max_s),
    .up_es_hoffset_min (up_es_hoffset_min_s),
    .up_es_hoffset_step (up_es_hoffset_step_s),
    .up_es_start_addr (up_es_start_addr_s),
    .up_es_sdata0 (up_es_sdata0_s),
    .up_es_sdata1 (up_es_sdata1_s),
    .up_es_sdata2 (up_es_sdata2_s),
    .up_es_sdata3 (up_es_sdata3_s),
    .up_es_sdata4 (up_es_sdata4_s),
    .up_es_qdata0 (up_es_qdata0_s),
    .up_es_qdata1 (up_es_qdata1_s),
    .up_es_qdata2 (up_es_qdata2_s),
    .up_es_qdata3 (up_es_qdata3_s),
    .up_es_qdata4 (up_es_qdata4_s),
    .up_es_dmaerr (up_es_dmaerr_s),
    .up_es_status (up_es_status_s),
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

  // axi interface

  up_axi i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

endmodule

// ***************************************************************************
// ***************************************************************************
