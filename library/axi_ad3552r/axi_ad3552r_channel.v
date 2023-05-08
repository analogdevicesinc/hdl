// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2023 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modificat
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad3552r_channel #(

  parameter CHANNEL_ID = 32'h0
) (

  // dac interface

  input                   dac_clk,
  input                   dac_rst,
  output                  dac_data_valid,
  output       [15:0]     dac_data,

  // input sources

  input        [15:0]     dma_data,
  input        [15:0]     adc_data,
  input                   valid_in_adc,
  input                   valid_in_dma,
  input                   dac_data_ready,

  // processor interface

  input                   dac_data_sync,
  input                   dac_dfmt_type,

  // bus interface

  input                   up_rstn,
  input                   up_clk,
  input                   up_wreq,
  input        [13:0]     up_waddr,
  input        [31:0]     up_wdata,
  output                  up_wack,
  input                   up_rreq,
  input        [13:0]     up_raddr,
  output       [31:0]     up_rdata,
  output                  up_rack
);

  // internal signals

  wire    [15:0]   formatted_dma_data;
  wire    [15:0]   formatted_adc_data;
  wire    [ 3:0]   dac_data_sel_s;
  wire             dac_data_valid_int;
  wire    [15:0]   dac_data_int;

  reg     [15:0]   ramp_pattern = 16'h0000;
  reg              ramp_valid   = 1'b0;

  assign dac_data       = dac_data_int;
  assign dac_data_valid = dac_data_valid_int;

  assign formatted_dma_data [15]   = dac_dfmt_type ^ dma_data[15];
  assign formatted_dma_data [14:0] = dma_data[14:0];
  assign formatted_adc_data [15]   = dac_dfmt_type ^ adc_data[15];
  assign formatted_adc_data [14:0] = adc_data[14:0];

  assign dac_data_int = (dac_data_sel_s == 4'hb) ? ramp_pattern :
                        ((dac_data_sel_s == 4'h3) ? 16'b0 : ((dac_data_sel_s == 4'h8) ? formatted_adc_data : formatted_dma_data));
  assign dac_data_valid_int = (dac_data_sel_s == 4'hb) ? ramp_valid :
                              ((dac_data_sel_s == 4'h3) ? 1'b1 : ((dac_data_sel_s == 4'h8) ? valid_in_adc : valid_in_dma));

  // ramp generator

  always @(posedge dac_clk) begin
    ramp_valid <= 1'b1;
    if(dac_data_ready == 1'b1) begin
        ramp_pattern <= ramp_pattern + 1'b1;
    end else begin
      ramp_pattern <= ramp_pattern;
    end
    if(ramp_pattern == 16'hffff || dac_rst == 1'b1) begin
      ramp_pattern <= 16'h0;
    end
  end

  // single channel processor

  up_dac_channel #(
    .CHANNEL_ID(CHANNEL_ID)
  ) dac_channel (
    .dac_clk(dac_clk),
    .dac_rst(dac_rst),
    .dac_dds_scale_1(),
    .dac_dds_init_1(),
    .dac_dds_incr_1(),
    .dac_dds_scale_2(),
    .dac_dds_init_2(),
    .dac_dds_incr_2(),
    .dac_pat_data_1(),
    .dac_pat_data_2(),
    .dac_data_sel(dac_data_sel_s),
    .dac_mask_enable(),
    .dac_iq_mode(),
    .dac_iqcor_enb(),
    .dac_iqcor_coeff_1(),
    .dac_iqcor_coeff_2(),
    .dac_src_chan_sel(),
    .up_usr_datatype_be(),
    .up_usr_datatype_signed(),
    .up_usr_datatype_shift(),
    .up_usr_datatype_total_bits(),
    .up_usr_datatype_bits(),
    .up_usr_interpolation_m(),
    .up_usr_interpolation_n(),
    .dac_usr_datatype_be(1'd0),
    .dac_usr_datatype_signed(1'd1),
    .dac_usr_datatype_shift(8'd0),
    .dac_usr_datatype_total_bits(8'd16),
    .dac_usr_datatype_bits(8'd16),
    .dac_usr_interpolation_m(16'd1),
    .dac_usr_interpolation_n(16'd1),
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_wreq(up_wreq),
    .up_waddr(up_waddr),
    .up_wdata(up_wdata),
    .up_wack(up_wack),
    .up_rreq(up_rreq),
    .up_raddr(up_raddr),
    .up_rdata(up_rdata),
    .up_rack(up_rack));
endmodule
