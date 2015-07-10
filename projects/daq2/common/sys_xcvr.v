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
// This may be done inside QSYS, but it does a bad job of connecting the same signal
// to multiple inputs, concatenation, bus splits and numerous connections
// in-between. Also signal tap doesn't behave nicely within the system.

`timescale 1ns/100ps

module sys_xcvr (

  // io

  up_clk,
  up_rstn,

  rx_ref_clk,
  rx_d,
  tx_ref_clk,
  tx_d,

  rst,

  rx_clk,
  rx_rstn,
  rx_sysref,
  rx_ip_sync,
  rx_ip_sof,
  rx_ip_data,
  rx_ready,
  rx_int,

  tx_clk,
  tx_rstn,
  tx_sysref,
  tx_ip_sync,
  tx_ip_data,
  tx_ready,
  tx_int,

  stp_clk,
  stp_data,
  stp_trigger);

  // parameters are not used--

  parameter   PCORE_NUM_OF_TX_LANES = 4;
  parameter   PCORE_NUM_OF_RX_LANES = 4;
  parameter   PCORE_ST_DATA_WIDTH = 32;
  parameter   PCORE_ST_TRIGGER_WIDTH = 4;

  // io

  input             up_clk;
  input             up_rstn;

  input             rx_ref_clk;
  input   [  3:0]   rx_d;
  input             tx_ref_clk;
  output  [  3:0]   tx_d;

  input             rst;

  output            rx_clk;
  input             rx_rstn;
  input             rx_sysref;
  output            rx_ip_sync;
  output  [  3:0]   rx_ip_sof;
  output  [127:0]   rx_ip_data;
  output  [  3:0]   rx_ready;
  output            rx_int;

  output            tx_clk;
  input             tx_rstn;
  input             tx_sysref;
  input             tx_ip_sync;
  input   [127:0]   tx_ip_data;
  output  [  3:0]   tx_ready;
  output            tx_int;

  output            stp_clk;
  output  [ 31:0]   stp_data;
  output  [  3:0]   stp_trigger;
                                                             
  // internal signals

  wire    [  3:0]   rx_analogreset;
  wire    [  3:0]   rx_cal_busy;
  wire              rx_bit_reversal;
  wire              rx_byte_reversal;
  wire    [  3:0]   rx_lane_polarity;
  wire    [  3:0]   rx_lane_powerdown;
  wire    [  3:0]   rx_digitalreset;
  wire    [  3:0]   rx_islockedtodata;
  wire    [  3:0]   rx_patternalign_en;
  wire              rx_dev_lane_aligned;
  wire    [  3:0]   rx_pcfifo_empty;
  wire    [  3:0]   rx_pcfifo_full;
  wire    [  3:0]   rx_pcs_valid;
  wire    [ 15:0]   rx_pcs_disperr;
  wire    [ 15:0]   rx_pcs_errdetect;
  wire    [ 15:0]   rx_pcs_kchar;
  wire    [127:0]   rx_pcs_data;
  wire    [  0:0]   tx_xcvr_clk;
  wire    [  3:0]   tx_pll_locked;
  wire              tx_pll_powerdown;
  wire    [  3:0]   tx_analogreset;
  wire    [  3:0]   tx_cal_busy;
  wire              tx_bit_reversal;
  wire              tx_byte_reversal;
  wire    [  3:0]   tx_lane_polarity;
  wire    [  3:0]   tx_lane_powerdown;
  wire    [  3:0]   tx_digitalreset;
  wire    [  3:0]   tx_elecidle;
  wire              tx_dev_syncn;
  wire    [  3:0]   tx_pcfifo_empty;
  wire    [  3:0]   tx_pcfifo_full;
  wire    [ 15:0]   tx_pcs_kchar;
  wire    [127:0]   tx_pcs_data;

  // instantiations

  sys_xcvr_rx_pll i_rx_pll (
    .locked (),
    .outclk_0 (rx_clk),
    .refclk (rx_ref_clk),
    .rst (rst));

  sys_xcvr_tx_pll i_tx_pll (
    .locked (),
    .outclk_0 (tx_clk),
    .refclk (tx_ref_clk),
    .rst (rst));

  sys_xcvr_tx_lane_pll i_tx_lane_pll (
    .pll_cal_busy (),
    .pll_locked (tx_pll_locked),
    .pll_powerdown (tx_pll_powerdown),
    .pll_refclk0 (tx_ref_clk),
    .tx_serial_clk (tx_xcvr_clk));

  sys_xcvr_rstcntrl i_rstcntrl (
    .clock (up_clk),
    .pll_locked (tx_pll_locked),
    .pll_powerdown (tx_pll_powerdown),
    .pll_select (1'd0),
    .reset (rst),
    .rx_analogreset (rx_analogreset),
    .rx_cal_busy (rx_cal_busy),
    .rx_digitalreset (rx_digitalreset),
    .rx_is_lockedtodata (rx_islockedtodata),
    .rx_ready (rx_ready),
    .tx_analogreset (tx_analogreset),
    .tx_cal_busy (tx_cal_busy),
    .tx_digitalreset (tx_digitalreset),
    .tx_ready (tx_ready));

  sys_xcvr_core i_core (
    .jesd204_rx_pcs_data (rx_pcs_data),
    .jesd204_rx_pcs_data_valid (rx_pcs_valid),
    .jesd204_rx_pcs_disperr (rx_pcs_disperr),
    .jesd204_rx_pcs_errdetect (rx_pcs_errdetect),
    .jesd204_rx_pcs_kchar_data (rx_pcs_kchar),
    .jesd204_tx_pcs_data (tx_pcs_data),
    .jesd204_tx_pcs_kchar_data (tx_pcs_kchar),
    .patternalign_en (rx_patternalign_en),
    .phy_csr_rx_pcfifo_empty (rx_pcfifo_empty),
    .phy_csr_rx_pcfifo_full (rx_pcfifo_full),
    .phy_csr_tx_pcfifo_empty (tx_pcfifo_empty),
    .phy_csr_tx_pcfifo_full (tx_pcfifo_full),
    .phy_tx_elecidle (tx_elecidle),
    .rx_analogreset (rx_analogreset),
    .rx_cal_busy (rx_cal_busy),
    .rx_csr_bit_reversal (rx_bit_reversal),
    .rx_csr_byte_reversal (rx_byte_reversal),
    .rx_csr_lane_polarity (rx_lane_polarity),
    .rx_csr_lane_powerdown (rx_lane_powerdown),
    .rx_digitalreset (rx_digitalreset),
    .rx_islockedtodata (rx_islockedtodata),
    .rx_pll_ref_clk (rx_ref_clk),
    .rx_serial_data (rx_d),
    .rx_seriallpbken (4'd0),
    .rxlink_clk (rx_clk),
    .rxlink_rst_n_reset_n (rx_rstn),
    .rxphy_clk (),
    .tx_analogreset (tx_analogreset),
    .tx_cal_busy (tx_cal_busy),
    .tx_csr_bit_reversal (tx_bit_reversal),
    .tx_csr_byte_reversal (tx_byte_reversal),
    .tx_csr_lane_polarity (tx_lane_polarity),
    .tx_csr_lane_powerdown (tx_lane_powerdown),
    .tx_digitalreset (tx_digitalreset),
    .tx_serial_clk0_ch0 (tx_xcvr_clk),
    .tx_serial_clk0_ch1 (tx_xcvr_clk),
    .tx_serial_clk0_ch2 (tx_xcvr_clk),
    .tx_serial_clk0_ch3 (tx_xcvr_clk),
    .tx_serial_data (tx_d),
    .txlink_clk (tx_clk),
    .txlink_rst_n_reset_n (tx_rstn),
    .txphy_clk ());

  sys_xcvr_rx_ip i_rx_ip (
    .alldev_lane_aligned (rx_dev_lane_aligned),
    .csr_bit_reversal (rx_bit_reversal),
    .csr_byte_reversal (rx_byte_reversal),
    .csr_cf (),
    .csr_cs (),
    .csr_f (),
    .csr_hd (),
    .csr_k (),
    .csr_l (),
    .csr_lane_polarity (rx_lane_polarity),
    .csr_lane_powerdown (rx_lane_powerdown),
    .csr_m (),
    .csr_n (),
    .csr_np (),
    .csr_rx_testmode (),
    .csr_s (),
    .dev_lane_aligned (rx_dev_lane_aligned),
    .dev_sync_n (rx_ip_sync),
    .jesd204_rx_avs_chipselect (1'd0),
    .jesd204_rx_avs_address (8'd0),
    .jesd204_rx_avs_read (1'd0),
    .jesd204_rx_avs_readdata (),
    .jesd204_rx_avs_waitrequest (),
    .jesd204_rx_avs_write (1'd0),
    .jesd204_rx_avs_writedata (32'd0),
    .jesd204_rx_avs_clk (up_clk),
    .jesd204_rx_avs_rst_n (up_rstn),
    .jesd204_rx_dlb_data (128'd0),
    .jesd204_rx_dlb_data_valid (4'd0),
    .jesd204_rx_dlb_disperr (16'd0),
    .jesd204_rx_dlb_errdetect (16'd0),
    .jesd204_rx_dlb_kchar_data (16'd0),
    .jesd204_rx_frame_error (1'd0),
    .jesd204_rx_int (rx_int),
    .jesd204_rx_link_data (rx_ip_data),
    .jesd204_rx_link_valid (),
    .jesd204_rx_link_ready (1'd0),
    .jesd204_rx_pcs_data (rx_pcs_data),
    .jesd204_rx_pcs_data_valid (rx_pcs_valid),
    .jesd204_rx_pcs_disperr (rx_pcs_disperr),
    .jesd204_rx_pcs_errdetect (rx_pcs_errdetect),
    .jesd204_rx_pcs_kchar_data (rx_pcs_kchar),
    .patternalign_en (rx_patternalign_en),
    .phy_csr_rx_pcfifo_empty (rx_pcfifo_empty),
    .phy_csr_rx_pcfifo_full (rx_pcfifo_full),
    .rx_cal_busy (rx_cal_busy),
    .rx_islockedtodata (rx_islockedtodata),
    .rxlink_clk (rx_clk),
    .rxlink_rst_n_reset_n (rx_rstn),
    .sof (rx_ip_sof),
    .somf (),
    .sysref (rx_sysref));

  sys_xcvr_tx_ip i_tx_ip (
    .csr_bit_reversal (tx_bit_reversal),
    .csr_byte_reversal (tx_byte_reversal),
    .csr_cf (),
    .csr_cs (),
    .csr_f (),
    .csr_hd (),
    .csr_k (),
    .csr_l (),
    .csr_lane_polarity (),
    .csr_lane_powerdown (),
    .csr_m (),
    .csr_n (),
    .csr_np (),
    .csr_s (),
    .csr_tx_testmode (),
    .csr_tx_testpattern_a (),
    .csr_tx_testpattern_b (),
    .csr_tx_testpattern_c (),
    .csr_tx_testpattern_d (),
    .dev_sync_n (tx_dev_syncn),
    .jesd204_tx_avs_chipselect (1'd0),
    .jesd204_tx_avs_address (8'd0),
    .jesd204_tx_avs_read (1'd0),
    .jesd204_tx_avs_readdata (),
    .jesd204_tx_avs_waitrequest (),
    .jesd204_tx_avs_write (1'd0),
    .jesd204_tx_avs_writedata (32'd0),
    .jesd204_tx_avs_clk (up_clk),
    .jesd204_tx_avs_rst_n (up_rstn),
    .jesd204_tx_frame_error (1'd0),
    .jesd204_tx_frame_ready (),
    .jesd204_tx_int (tx_int),
    .jesd204_tx_link_data (tx_ip_data),
    .jesd204_tx_link_valid (1'b1),
    .jesd204_tx_link_ready (),
    .jesd204_tx_pcs_data (tx_pcs_data),
    .jesd204_tx_pcs_kchar_data (tx_pcs_kchar),
    .mdev_sync_n (tx_dev_syncn),
    .phy_csr_tx_pcfifo_empty (tx_pcfifo_empty),
    .phy_csr_tx_pcfifo_full (tx_pcfifo_full),
    .phy_tx_elecidle (tx_elecidle),
    .pll_locked (tx_pll_locked),
    .sync_n (tx_ip_sync),
    .sysref (tx_sysref),
    .tx_cal_busy (tx_cal_busy),
    .txlink_clk (tx_clk),
    .txlink_rst_n_reset_n (tx_rstn));

endmodule

// ***************************************************************************
// ***************************************************************************
