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
// serial data output interface: serdes(x8)

`timescale 1ps/1ps

module ad_serdes_out #(

  parameter   DEVICE_TYPE = 0,
  parameter   SERDES_FACTOR = 8,
  parameter   DATA_WIDTH = 16) (

  // reset and clocks

  input                       rst,
  input                       clk,
  input                       div_clk,
  input                       loaden,

  // data interface

  input   [(DATA_WIDTH-1):0]  data_s0,
  input   [(DATA_WIDTH-1):0]  data_s1,
  input   [(DATA_WIDTH-1):0]  data_s2,
  input   [(DATA_WIDTH-1):0]  data_s3,
  input   [(DATA_WIDTH-1):0]  data_s4,
  input   [(DATA_WIDTH-1):0]  data_s5,
  input   [(DATA_WIDTH-1):0]  data_s6,
  input   [(DATA_WIDTH-1):0]  data_s7,
  output  [(DATA_WIDTH-1):0]  data_out_p,
  output  [(DATA_WIDTH-1):0]  data_out_n);

  // local parameter

  localparam C5SOC = 1;

  // internal signals

  wire    [(DATA_WIDTH-1):0]  data_in_s[ 7:0];
  wire    [(DATA_WIDTH-1):0]  data_in_s2[ 7:0];

  // defaults

  assign data_out_n = 'd0;

  // instantiations

    assign data_in_s[0] = data_s0;
    assign data_in_s[1] = data_s1;
    assign data_in_s[2] = data_s2;
    assign data_in_s[3] = data_s3;
    assign data_in_s[4] = data_s4;
    assign data_in_s[5] = data_s5;
    assign data_in_s[6] = data_s6;
    assign data_in_s[7] = data_s7;

  genvar l_order;
  generate
    for (l_order = 0; l_order < 8; l_order = l_order + 1) begin: g_order
      assign data_in_s2[l_order] = (l_order < 8-SERDES_FACTOR) ? 1'b0 : data_in_s[l_order -8 + SERDES_FACTOR];
    end
  endgenerate

  genvar l_inst;
  generate
  for (l_inst = 0; l_inst < DATA_WIDTH; l_inst = l_inst + 1) begin: g_data
    if (DEVICE_TYPE == C5SOC) begin
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
        .lpm_hint ("CBX_MODULE_PREFIX=ad_serdes_out"),
        .lpm_type ("altlvds_tx"),
        .multi_clock ("OFF"),
        .number_of_channels (DATA_WIDTH),
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
        .use_external_pll ("ON"),
        .use_no_phase_shift ("ON"),
        .vod_setting (0),
        .clk_src_is_pll ("off"))
      i_altlvds_tx (
        .tx_inclock (clk),
        .tx_coreclock (div_clk),
        .tx_in ({data_in_s2[0][l_inst],
                 data_in_s2[1][l_inst],
                 data_in_s2[2][l_inst],
                 data_in_s2[3][l_inst],
                 data_in_s2[4][l_inst],
                 data_in_s2[5][l_inst],
                 data_in_s2[6][l_inst],
                 data_in_s2[7][l_inst]}),
        .tx_outclock (),
        .tx_out (data_out_p[l_inst]),
        .tx_locked (),
        .pll_areset (1'b0),
        .sync_inclock (1'b0),
        .tx_data_reset (1'b0),
        .tx_enable (loaden),
        .tx_pll_enable (1'b1),
        .tx_syncclock (1'b0));

    end else begin
      alt_serdes_out_core i_core (
        .clk_export (clk),
        .div_clk_export (div_clk),
        .loaden_export (loaden),
        .data_out_export (data_out_p[l_inst]),
        .data_s_export ({data_in_s2[0][l_inst],
                         data_in_s2[1][l_inst],
                         data_in_s2[2][l_inst],
                         data_in_s2[3][l_inst],
                         data_in_s2[4][l_inst],
                         data_in_s2[5][l_inst],
                         data_in_s2[6][l_inst],
                         data_in_s2[7][l_inst]}));
    end
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************

