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

module axi_ad9361_alt_lvds_rx (

  // physical interface (receive)

  rx_clk_in_p,
  rx_clk_in_n,
  rx_frame_in_p,
  rx_frame_in_n,
  rx_data_in_p,
  rx_data_in_n,

  // data interface

  clk,
  rx_frame,
  rx_data_0,
  rx_data_1,
  rx_data_2,
  rx_data_3,
  rx_locked);

  // physical interface (receive)

  input           rx_clk_in_p;
  input           rx_clk_in_n;
  input           rx_frame_in_p;
  input           rx_frame_in_n;
  input   [ 5:0]  rx_data_in_p;
  input   [ 5:0]  rx_data_in_n;

  // data interface

  output          clk;
  output  [ 3:0]  rx_frame;
  output  [ 5:0]  rx_data_0;
  output  [ 5:0]  rx_data_1;
  output  [ 5:0]  rx_data_2;
  output  [ 5:0]  rx_data_3;
  output          rx_locked;

  // internal signals

  wire    [27:0]  rx_data_s;
 
  // instantiations

  assign rx_frame[3] = rx_data_s[24];
  assign rx_frame[2] = rx_data_s[25];
  assign rx_frame[1] = rx_data_s[26];
  assign rx_frame[0] = rx_data_s[27];
  assign rx_data_3[5] = rx_data_s[20];
  assign rx_data_3[4] = rx_data_s[16];
  assign rx_data_3[3] = rx_data_s[12];
  assign rx_data_3[2] = rx_data_s[ 8];
  assign rx_data_3[1] = rx_data_s[ 4];
  assign rx_data_3[0] = rx_data_s[ 0];
  assign rx_data_2[5] = rx_data_s[21];
  assign rx_data_2[4] = rx_data_s[17];
  assign rx_data_2[3] = rx_data_s[13];
  assign rx_data_2[2] = rx_data_s[ 9];
  assign rx_data_2[1] = rx_data_s[ 5];
  assign rx_data_2[0] = rx_data_s[ 1];
  assign rx_data_1[5] = rx_data_s[22];
  assign rx_data_1[4] = rx_data_s[18];
  assign rx_data_1[3] = rx_data_s[14];
  assign rx_data_1[2] = rx_data_s[10];
  assign rx_data_1[1] = rx_data_s[ 6];
  assign rx_data_1[0] = rx_data_s[ 2];
  assign rx_data_0[5] = rx_data_s[23];
  assign rx_data_0[4] = rx_data_s[19];
  assign rx_data_0[3] = rx_data_s[15];
  assign rx_data_0[2] = rx_data_s[11];
  assign rx_data_0[1] = rx_data_s[ 7];
  assign rx_data_0[0] = rx_data_s[ 3];

  altlvds_rx #(
    .buffer_implementation ("RAM"),
    .cds_mode ("UNUSED"),
    .common_rx_tx_pll ("ON"),
    .data_align_rollover (4),
    .data_rate ("500.0 Mbps"),
    .deserialization_factor (4),
    .dpa_initial_phase_value (0),
    .dpll_lock_count (0),
    .dpll_lock_window (0),
    .enable_clock_pin_mode ("UNUSED"),
    .enable_dpa_align_to_rising_edge_only ("OFF"),
    .enable_dpa_calibration ("ON"),
    .enable_dpa_fifo ("UNUSED"),
    .enable_dpa_initial_phase_selection ("OFF"),
    .enable_dpa_mode ("OFF"),
    .enable_dpa_pll_calibration ("OFF"),
    .enable_soft_cdr_mode ("OFF"),
    .implement_in_les ("OFF"),
    .inclock_boost (0),
    .inclock_data_alignment ("EDGE_ALIGNED"),
    .inclock_period (4000),
    .inclock_phase_shift (0),
    .input_data_rate (500),
    .intended_device_family ("Cyclone V"),
    .lose_lock_on_one_change ("UNUSED"),
    .lpm_hint ("CBX_MODULE_PREFIX=axi_ad9361_alt_lvds_rx"),
    .lpm_type ("altlvds_rx"),
    .number_of_channels (7),
    .outclock_resource ("Regional clock"),
    .pll_operation_mode ("NORMAL"),
    .pll_self_reset_on_loss_lock ("UNUSED"),
    .port_rx_channel_data_align ("PORT_UNUSED"),
    .port_rx_data_align ("PORT_UNUSED"),
    .refclk_frequency ("250.000000 MHz"),
    .registered_data_align_input ("UNUSED"),
    .registered_output ("ON"),
    .reset_fifo_at_first_lock ("UNUSED"),
    .rx_align_data_reg ("RISING_EDGE"),
    .sim_dpa_is_negative_ppm_drift ("OFF"),
    .sim_dpa_net_ppm_variation (0),
    .sim_dpa_output_clock_phase_shift (0),
    .use_coreclock_input ("OFF"),
    .use_dpll_rawperror ("OFF"),
    .use_external_pll ("OFF"),
    .use_no_phase_shift ("ON"),
    .x_on_bitslip ("ON"),
    .clk_src_is_pll ("off"))
  i_altlvds_rx (
    .rx_inclock (rx_clk_in_p),
    .rx_in ({rx_frame_in_p, rx_data_in_p}),
    .rx_outclock (clk),
    .rx_out (rx_data_s),
    .rx_locked (rx_locked),
    .dpa_pll_cal_busy (),
    .dpa_pll_recal (1'b0),
    .pll_areset (1'b0),
    .pll_phasecounterselect (),
    .pll_phasedone (1'b1),
    .pll_phasestep (),
    .pll_phaseupdown (),
    .pll_scanclk (),
    .rx_cda_max (),
    .rx_cda_reset ({7{1'b0}}),
    .rx_channel_data_align ({7{1'b0}}),
    .rx_coreclk ({7{1'b1}}),
    .rx_data_align (1'b0),
    .rx_data_align_reset (1'b0),
    .rx_data_reset (1'b0),
    .rx_deskew (1'b0),
    .rx_divfwdclk (),
    .rx_dpa_lock_reset ({7{1'b0}}),
    .rx_dpa_locked (),
    .rx_dpaclock (1'b0),
    .rx_dpll_enable ({7{1'b1}}),
    .rx_dpll_hold ({7{1'b0}}),
    .rx_dpll_reset ({7{1'b0}}),
    .rx_enable (1'b1),
    .rx_fifo_reset ({7{1'b0}}),
    .rx_pll_enable (1'b1),
    .rx_readclock (1'b0),
    .rx_reset ({7{1'b0}}),
    .rx_syncclock (1'b0));

endmodule

// ***************************************************************************
// ***************************************************************************
