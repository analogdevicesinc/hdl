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
// ***************************************************************************
// ***************************************************************************
// ADC channel-need to work on dual mode for pn sequence

`timescale 1ns/100ps

module axi_ad9361_rx (

  // adc interface

  adc_rst,
  adc_clk,
  adc_valid,
  adc_data,
  adc_status,
  adc_r1_mode,
  adc_ddr_edgesel,
  dac_data,

  // delay interface

  up_dld,
  up_dwdata,
  up_drdata,
  delay_clk,
  delay_rst,
  delay_locked,

  // dma interface

  adc_enable_i0,
  adc_valid_i0,
  adc_data_i0,
  adc_enable_q0,
  adc_valid_q0,
  adc_data_q0,
  adc_enable_i1,
  adc_valid_i1,
  adc_data_i1,
  adc_enable_q1,
  adc_valid_q1,
  adc_data_q1,
  adc_dovf,
  adc_dunf,

  // gpio

  up_adc_gpio_in,
  up_adc_gpio_out,

  // processor interface

  up_rstn,
  up_clk,
  up_wreq,
  up_waddr,
  up_wdata,
  up_wack,
  up_rreq,
  up_raddr,
  up_rdata,
  up_rack);

  // parameters

  parameter   DATAPATH_DISABLE = 0;
  parameter   ID = 0;

  // adc interface

  output          adc_rst;
  input           adc_clk;
  input           adc_valid;
  input   [47:0]  adc_data;
  input           adc_status;
  output          adc_r1_mode;
  output          adc_ddr_edgesel;
  input   [47:0]  dac_data;

  // delay interface

  output  [ 6:0]  up_dld;
  output  [34:0]  up_dwdata;
  input   [34:0]  up_drdata;
  input           delay_clk;
  output          delay_rst;
  input           delay_locked;

  // dma interface

  output          adc_enable_i0;
  output          adc_valid_i0;
  output  [15:0]  adc_data_i0;
  output          adc_enable_q0;
  output          adc_valid_q0;
  output  [15:0]  adc_data_q0;
  output          adc_enable_i1;
  output          adc_valid_i1;
  output  [15:0]  adc_data_i1;
  output          adc_enable_q1;
  output          adc_valid_q1;
  output  [15:0]  adc_data_q1;
  input           adc_dovf;
  input           adc_dunf;

  // gpio

  input   [31:0]  up_adc_gpio_in;
  output  [31:0]  up_adc_gpio_out;

  // processor interface

  input           up_rstn;
  input           up_clk;
  input           up_wreq;
  input   [13:0]  up_waddr;
  input   [31:0]  up_wdata;
  output          up_wack;
  input           up_rreq;
  input   [13:0]  up_raddr;
  output  [31:0]  up_rdata;
  output          up_rack;

  // internal registers

  reg             up_status_pn_err = 'd0;
  reg             up_status_pn_oos = 'd0;
  reg             up_status_or = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg             up_rack = 'd0;
  reg             up_wack = 'd0;

  // internal signals

  wire    [15:0]  adc_dcfilter_data_out_0_s;
  wire    [15:0]  adc_dcfilter_data_out_1_s;
  wire    [15:0]  adc_dcfilter_data_out_2_s;
  wire    [15:0]  adc_dcfilter_data_out_3_s;
  wire    [ 3:0]  up_adc_pn_err_s;
  wire    [ 3:0]  up_adc_pn_oos_s;
  wire    [ 3:0]  up_adc_or_s;
  wire    [31:0]  up_rdata_s[0:5];
  wire            up_rack_s[0:5];
  wire            up_wack_s[0:5];

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_status_pn_err <= 'd0;
      up_status_pn_oos <= 'd0;
      up_status_or <= 'd0;
      up_rdata <= 'd0;
      up_rack <= 'd0;
      up_wack <= 'd0;
    end else begin
      up_status_pn_err <= | up_adc_pn_err_s;
      up_status_pn_oos <= | up_adc_pn_oos_s;
      up_status_or <= | up_adc_or_s;
      up_rdata <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2] |
                  up_rdata_s[3] | up_rdata_s[4] | up_rdata_s[5];
      up_rack <=  up_rack_s[0]  | up_rack_s[1]  | up_rack_s[2]  |
                  up_rack_s[3]  | up_rack_s[4]  | up_rack_s[5];
      up_wack <=  up_wack_s[0]  | up_wack_s[1]  | up_wack_s[2]  |
                  up_wack_s[3]  | up_wack_s[4]  | up_wack_s[5];
    end
  end

  // channel 0 (i)

  axi_ad9361_rx_channel #(
    .Q_OR_I_N(0),
    .CHANNEL_ID(0),
    .DATAPATH_DISABLE (DATAPATH_DISABLE))
  i_rx_channel_0 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid),
    .adc_data (adc_data[11:0]),
    .adc_data_q (adc_data[23:12]),
    .adc_or (1'b0),
    .dac_data (dac_data[11:0]),
    .adc_dcfilter_data_out (adc_dcfilter_data_out_0_s),
    .adc_dcfilter_data_in (adc_dcfilter_data_out_1_s),
    .adc_iqcor_valid (adc_valid_i0),
    .adc_iqcor_data (adc_data_i0),
    .adc_enable (adc_enable_i0),
    .up_adc_pn_err (up_adc_pn_err_s[0]),
    .up_adc_pn_oos (up_adc_pn_oos_s[0]),
    .up_adc_or (up_adc_or_s[0]),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[0]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[0]),
    .up_rack (up_rack_s[0]));

  // channel 1 (q)

  axi_ad9361_rx_channel #(
    .Q_OR_I_N(1),
    .CHANNEL_ID(1),
    .DATAPATH_DISABLE (DATAPATH_DISABLE))
  i_rx_channel_1 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid),
    .adc_data (adc_data[23:12]),
    .adc_data_q (adc_data[11:0]),
    .adc_or (1'b0),
    .dac_data (dac_data[23:12]),
    .adc_dcfilter_data_out (adc_dcfilter_data_out_1_s),
    .adc_dcfilter_data_in (adc_dcfilter_data_out_0_s),
    .adc_iqcor_valid (adc_valid_q0),
    .adc_iqcor_data (adc_data_q0),
    .adc_enable (adc_enable_q0),
    .up_adc_pn_err (up_adc_pn_err_s[1]),
    .up_adc_pn_oos (up_adc_pn_oos_s[1]),
    .up_adc_or (up_adc_or_s[1]),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[1]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[1]),
    .up_rack (up_rack_s[1]));

  // channel 2 (i)

  axi_ad9361_rx_channel #(
    .Q_OR_I_N(0),
    .CHANNEL_ID(2),
    .DATAPATH_DISABLE (DATAPATH_DISABLE))
  i_rx_channel_2 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid),
    .adc_data (adc_data[35:24]),
    .adc_data_q (adc_data[47:36]),
    .adc_or (1'b0),
    .dac_data (dac_data[35:24]),
    .adc_dcfilter_data_out (adc_dcfilter_data_out_2_s),
    .adc_dcfilter_data_in (adc_dcfilter_data_out_3_s),
    .adc_iqcor_valid (adc_valid_i1),
    .adc_iqcor_data (adc_data_i1),
    .adc_enable (adc_enable_i1),
    .up_adc_pn_err (up_adc_pn_err_s[2]),
    .up_adc_pn_oos (up_adc_pn_oos_s[2]),
    .up_adc_or (up_adc_or_s[2]),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[2]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[2]),
    .up_rack (up_rack_s[2]));

  // channel 3 (q)

  axi_ad9361_rx_channel #(
    .Q_OR_I_N(1),
    .CHANNEL_ID(3),
    .DATAPATH_DISABLE (DATAPATH_DISABLE))
  i_rx_channel_3 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid),
    .adc_data (adc_data[47:36]),
    .adc_data_q (adc_data[35:24]),
    .adc_or (1'b0),
    .dac_data (dac_data[47:36]),
    .adc_dcfilter_data_out (adc_dcfilter_data_out_3_s),
    .adc_dcfilter_data_in (adc_dcfilter_data_out_2_s),
    .adc_iqcor_valid (adc_valid_q1),
    .adc_iqcor_data (adc_data_q1),
    .adc_enable (adc_enable_q1),
    .up_adc_pn_err (up_adc_pn_err_s[3]),
    .up_adc_pn_oos (up_adc_pn_oos_s[3]),
    .up_adc_or (up_adc_or_s[3]),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[3]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[3]),
    .up_rack (up_rack_s[3]));

  // common processor control

  up_adc_common #(.ID (ID)) i_up_adc_common (
    .mmcm_rst (),
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_r1_mode (adc_r1_mode),
    .adc_ddr_edgesel (adc_ddr_edgesel),
    .adc_pin_mode (),
    .adc_status (adc_status),
    .adc_sync_status (1'd0),
    .adc_status_ovf (adc_dovf),
    .adc_status_unf (adc_dunf),
    .adc_clk_ratio (32'd1),
    .adc_start_code (),
    .adc_sync (),
    .up_status_pn_err (up_status_pn_err),
    .up_status_pn_oos (up_status_pn_oos),
    .up_status_or (up_status_or),
    .up_drp_sel (),
    .up_drp_wr (),
    .up_drp_addr (),
    .up_drp_wdata (),
    .up_drp_rdata (16'd0),
    .up_drp_ready (1'd0),
    .up_drp_locked (1'd1),
    .up_usr_chanmax (),
    .adc_usr_chanmax (8'd3),
    .up_adc_gpio_in (up_adc_gpio_in),
    .up_adc_gpio_out (up_adc_gpio_out),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[4]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[4]),
    .up_rack (up_rack_s[4]));

  // adc delay control

  up_delay_cntrl #(.DATA_WIDTH(7), .BASE_ADDRESS(6'h02)) i_delay_cntrl (
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked),
    .up_dld (up_dld),
    .up_dwdata (up_dwdata),
    .up_drdata (up_drdata),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[5]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[5]),
    .up_rack (up_rack_s[5]));

endmodule

// ***************************************************************************
// ***************************************************************************

