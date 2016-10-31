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

module ad_serdes_out_core_c5 #(

  parameter       SERDES_FACTOR = 8) (

  input                           clk,
  input                           div_clk,
  input                           enable,
  output                          data_out,
  input   [(SERDES_FACTOR-1):0]   data);

  reg     [(SERDES_FACTOR-1):0]   data_int = 'd0;

  always @(posedge div_clk) begin
    data_int <= data;
  end

  altlvds_tx  i_altlvds_tx (
    .tx_enable (enable),
    .tx_in (data),
    .tx_inclock (clk),
    .tx_out (data_out),
    .pll_areset (1'b0),
    .sync_inclock (1'b0),
    .tx_coreclock (),
    .tx_data_reset (1'b0),
    .tx_locked (),
    .tx_outclock (),
    .tx_pll_enable (1'b1),
    .tx_syncclock (1'b0));
  defparam
    i_altlvds_tx.center_align_msb = "UNUSED",
    i_altlvds_tx.common_rx_tx_pll = "OFF",
    i_altlvds_tx.coreclock_divide_by = 1,
    i_altlvds_tx.data_rate = "800.0 Mbps",
    i_altlvds_tx.deserialization_factor = SERDES_FACTOR,
    i_altlvds_tx.differential_drive = 0,
    i_altlvds_tx.enable_clock_pin_mode = "UNUSED",
    i_altlvds_tx.implement_in_les = "OFF",
    i_altlvds_tx.inclock_boost = 0,
    i_altlvds_tx.inclock_data_alignment = "EDGE_ALIGNED",
    i_altlvds_tx.inclock_period = 50000,
    i_altlvds_tx.inclock_phase_shift = 0,
    i_altlvds_tx.intended_device_family = "Cyclone V",
    i_altlvds_tx.lpm_hint = "CBX_MODULE_PREFIX=ad_serdes_out_core_c5",
    i_altlvds_tx.lpm_type = "altlvds_tx",
    i_altlvds_tx.multi_clock = "OFF",
    i_altlvds_tx.number_of_channels = 1,
    i_altlvds_tx.outclock_alignment = "EDGE_ALIGNED",
    i_altlvds_tx.outclock_divide_by = 1,
    i_altlvds_tx.outclock_duty_cycle = 50,
    i_altlvds_tx.outclock_multiply_by = 1,
    i_altlvds_tx.outclock_phase_shift = 0,
    i_altlvds_tx.outclock_resource = "Dual-Regional clock",
    i_altlvds_tx.output_data_rate = 800,
    i_altlvds_tx.pll_compensation_mode = "AUTO",
    i_altlvds_tx.pll_self_reset_on_loss_lock = "OFF",
    i_altlvds_tx.preemphasis_setting = 0,
    i_altlvds_tx.refclk_frequency = "20.000000 MHz",
    i_altlvds_tx.registered_input = "OFF",
    i_altlvds_tx.use_external_pll = "ON",
    i_altlvds_tx.use_no_phase_shift = "ON",
    i_altlvds_tx.vod_setting = 0,
    i_altlvds_tx.clk_src_is_pll = "off";

endmodule

// ***************************************************************************
// ***************************************************************************
