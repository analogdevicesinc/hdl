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

module axi_ad9361_alt_lvds_tx (

  // physical interface (transmit)

  tx_clk_out_p,
  tx_clk_out_n,
  tx_frame_out_p,
  tx_frame_out_n,
  tx_data_out_p,
  tx_data_out_n,

  // data interface

  tx_clk,
  clk,
  tx_frame,
  tx_data_0,
  tx_data_1,
  tx_data_2,
  tx_data_3,
  tx_locked);

  // physical interface (transmit)

  output          tx_clk_out_p;
  output          tx_clk_out_n;
  output          tx_frame_out_p;
  output          tx_frame_out_n;
  output  [ 5:0]  tx_data_out_p;
  output  [ 5:0]  tx_data_out_n;

  // data interface

  input           tx_clk;
  input           clk;
  input   [ 3:0]  tx_frame;
  input   [ 5:0]  tx_data_0;
  input   [ 5:0]  tx_data_1;
  input   [ 5:0]  tx_data_2;
  input   [ 5:0]  tx_data_3;
  output          tx_locked;

  // internal registers

  reg     [27:0]  tx_data_n = 'd0;
  reg     [27:0]  tx_data_p = 'd0;

  // internal signals

  wire            core_clk;
  wire    [27:0]  tx_data_s;
 
  // instantiations

  assign tx_clk_out_n = 1'd0;
  assign tx_frame_out_n = 1'd0;
  assign tx_data_out_n = 6'd0;

  assign tx_data_s[24] = tx_frame[3];
  assign tx_data_s[25] = tx_frame[2];
  assign tx_data_s[26] = tx_frame[1];
  assign tx_data_s[27] = tx_frame[0];
  assign tx_data_s[20] = tx_data_3[5];
  assign tx_data_s[16] = tx_data_3[4];
  assign tx_data_s[12] = tx_data_3[3];
  assign tx_data_s[ 8] = tx_data_3[2];
  assign tx_data_s[ 4] = tx_data_3[1];
  assign tx_data_s[ 0] = tx_data_3[0];
  assign tx_data_s[21] = tx_data_2[5];
  assign tx_data_s[17] = tx_data_2[4];
  assign tx_data_s[13] = tx_data_2[3];
  assign tx_data_s[ 9] = tx_data_2[2];
  assign tx_data_s[ 5] = tx_data_2[1];
  assign tx_data_s[ 1] = tx_data_2[0];
  assign tx_data_s[22] = tx_data_1[5];
  assign tx_data_s[18] = tx_data_1[4];
  assign tx_data_s[14] = tx_data_1[3];
  assign tx_data_s[10] = tx_data_1[2];
  assign tx_data_s[ 6] = tx_data_1[1];
  assign tx_data_s[ 2] = tx_data_1[0];
  assign tx_data_s[23] = tx_data_0[5];
  assign tx_data_s[19] = tx_data_0[4];
  assign tx_data_s[15] = tx_data_0[3];
  assign tx_data_s[11] = tx_data_0[2];
  assign tx_data_s[ 7] = tx_data_0[1];
  assign tx_data_s[ 3] = tx_data_0[0];

  always @(negedge clk) begin
    tx_data_n <= tx_data_s;
  end

  always @(posedge core_clk) begin
    tx_data_p <= tx_data_n;
  end

  altlvds_tx #(
    .center_align_msb ("UNUSED"),
    .common_rx_tx_pll ("ON"),
    .coreclock_divide_by (1),
    .data_rate ("500.0 Mbps"),
    .deserialization_factor (4),
    .differential_drive (0),
    .enable_clock_pin_mode ("UNUSED"),
    .implement_in_les ("OFF"),
    .inclock_boost (0),
    .inclock_data_alignment ("EDGE_ALIGNED"),
    .inclock_period (4000),
    .inclock_phase_shift (0),
    .intended_device_family ("Cyclone V"),
    .lpm_hint ("CBX_MODULE_PREFIX=axi_ad9361_alt_lvds_tx"),
    .lpm_type ("altlvds_tx"),
    .multi_clock ("OFF"),
    .number_of_channels (7),
    .outclock_alignment ("EDGE_ALIGNED"),
    .outclock_divide_by (2),
    .outclock_duty_cycle (50),
    .outclock_multiply_by (1),
    .outclock_phase_shift (0),
    .outclock_resource ("Regional clock"),
    .output_data_rate (500),
    .pll_compensation_mode ("AUTO"),
    .pll_self_reset_on_loss_lock ("OFF"),
    .preemphasis_setting (0),
    .refclk_frequency ("250.000000 MHz"),
    .registered_input ("TX_CORECLK"),
    .use_external_pll ("OFF"),
    .use_no_phase_shift ("ON"),
    .vod_setting (0),
    .clk_src_is_pll ("off"))
  i_altlvds_tx (
    .tx_inclock (tx_clk),
    .tx_coreclock (core_clk),
    .tx_in (tx_data_p),
    .tx_outclock (tx_clk_out_p),
    .tx_out ({tx_frame_out_p, tx_data_out_p}),
    .tx_locked (tx_locked),
    .pll_areset (1'b0),
    .sync_inclock (1'b0),
    .tx_data_reset (1'b0),
    .tx_enable (1'b1),
    .tx_pll_enable (1'b1),
    .tx_syncclock (1'b0));

endmodule

// ***************************************************************************
// ***************************************************************************
