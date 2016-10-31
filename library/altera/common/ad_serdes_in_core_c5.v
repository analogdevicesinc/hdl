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

`timescale 1ps/1ps

module ad_serdes_in_core_c5 #(

  parameter       SERDES_FACTOR = 8) (

  input                           clk,
  input                           div_clk,
  input                           enable,
  input                           data_in,
  output  [(SERDES_FACTOR-1):0]   data);

  reg     [(SERDES_FACTOR-1):0]   data_int = 'd0;
  wire    [(SERDES_FACTOR-1):0]   data_s;

  assign data = data_int;

  always @(posedge div_clk) begin
    data_int <= data_s;
  end

  altlvds_rx i_altlvds_rx (
    .rx_enable (enable),
    .rx_in (data_in),
    .rx_inclock (clk),
    .rx_out (data_s),
    .dpa_pll_cal_busy (),
    .dpa_pll_recal (1'b0),
    .pll_areset (1'b0),
    .pll_phasecounterselect (),
    .pll_phasedone (1'b1),
    .pll_phasestep (),
    .pll_phaseupdown (),
    .pll_scanclk (),
    .rx_cda_max (),
    .rx_cda_reset (1'b0),
    .rx_channel_data_align (1'b0),
    .rx_coreclk (1'b1),
    .rx_data_align (1'b0),
    .rx_data_align_reset (1'b0),
    .rx_data_reset (1'b0),
    .rx_deskew (1'b0),
    .rx_divfwdclk (),
    .rx_dpa_lock_reset (1'b0),
    .rx_dpa_locked (),
    .rx_dpaclock (1'b0),
    .rx_dpll_enable (1'b1),
    .rx_dpll_hold (1'b0),
    .rx_dpll_reset (1'b0),
    .rx_fifo_reset (1'b0),
    .rx_locked (),
    .rx_outclock (),
    .rx_pll_enable (1'b1),
    .rx_readclock (1'b0),
    .rx_reset (1'b0),
    .rx_syncclock (1'b0));
  defparam
    i_altlvds_rx.buffer_implementation = "RAM",
    i_altlvds_rx.cds_mode = "UNUSED",
    i_altlvds_rx.common_rx_tx_pll = "OFF",
    i_altlvds_rx.data_align_rollover = 4,
    i_altlvds_rx.data_rate = "800.0 Mbps",
    i_altlvds_rx.deserialization_factor = SERDES_FACTOR,
    i_altlvds_rx.dpa_initial_phase_value = 0,
    i_altlvds_rx.dpll_lock_count = 0,
    i_altlvds_rx.dpll_lock_window = 0,
    i_altlvds_rx.enable_clock_pin_mode = "UNUSED",
    i_altlvds_rx.enable_dpa_align_to_rising_edge_only = "OFF",
    i_altlvds_rx.enable_dpa_calibration = "ON",
    i_altlvds_rx.enable_dpa_fifo = "UNUSED",
    i_altlvds_rx.enable_dpa_initial_phase_selection = "OFF",
    i_altlvds_rx.enable_dpa_mode = "OFF",
    i_altlvds_rx.enable_dpa_pll_calibration = "OFF",
    i_altlvds_rx.enable_soft_cdr_mode = "OFF",
    i_altlvds_rx.implement_in_les = "OFF",
    i_altlvds_rx.inclock_boost = 0,
    i_altlvds_rx.inclock_data_alignment = "EDGE_ALIGNED",
    i_altlvds_rx.inclock_period = 50000,
    i_altlvds_rx.inclock_phase_shift = 0,
    i_altlvds_rx.input_data_rate = 800,
    i_altlvds_rx.intended_device_family = "Cyclone V",
    i_altlvds_rx.lose_lock_on_one_change = "UNUSED",
    i_altlvds_rx.lpm_hint = "CBX_MODULE_PREFIX=ad_serdes_in_core_c5",
    i_altlvds_rx.lpm_type = "altlvds_rx",
    i_altlvds_rx.number_of_channels = 1,
    i_altlvds_rx.outclock_resource = "Dual-Regional clock",
    i_altlvds_rx.pll_operation_mode = "NORMAL",
    i_altlvds_rx.pll_self_reset_on_loss_lock = "UNUSED",
    i_altlvds_rx.port_rx_channel_data_align = "PORT_UNUSED",
    i_altlvds_rx.port_rx_data_align = "PORT_UNUSED",
    i_altlvds_rx.refclk_frequency = "20.000000 MHz",
    i_altlvds_rx.registered_data_align_input = "UNUSED",
    i_altlvds_rx.registered_output = "OFF",
    i_altlvds_rx.reset_fifo_at_first_lock = "UNUSED",
    i_altlvds_rx.rx_align_data_reg = "RISING_EDGE",
    i_altlvds_rx.sim_dpa_is_negative_ppm_drift = "OFF",
    i_altlvds_rx.sim_dpa_net_ppm_variation = 0,
    i_altlvds_rx.sim_dpa_output_clock_phase_shift = 0,
    i_altlvds_rx.use_coreclock_input = "OFF",
    i_altlvds_rx.use_dpll_rawperror = "OFF",
    i_altlvds_rx.use_external_pll = "ON",
    i_altlvds_rx.use_no_phase_shift = "ON",
    i_altlvds_rx.x_on_bitslip = "ON",
    i_altlvds_rx.clk_src_is_pll = "off";

endmodule

// ***************************************************************************
// ***************************************************************************
