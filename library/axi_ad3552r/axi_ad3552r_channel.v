// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2022 (c) Analog Devices, Inc. All rights reserved.
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

  parameter CHANNEL_ID = 32'h0,
  parameter RAMP_TYPE = 1'b0
) (

  // dac interface

  input                   dac_clk,
  input                   dac_rst,
  output                  dac_data_valid,
  output       [15:0]     dac_data,
  output       [ 3:0]     dac_source_sel,
  // input sources

  input        [15:0]     dma_data,
  input        [ 3:0]     control_data,
  input        [15:0]     adc_data,
  input                   valid_in_adc,
  input                   valid_in_ctrl,
  input                   valid_in_dma,
  input                   dac_data_ready,

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

 wire    [ 3:0]   dac_data_sel_s;

 (* mark_debug = "true" *) reg     [15:0]   ramp_pattern = 16'h0000;
 (* mark_debug = "true" *) reg              ramp_valid = 1'b0;

  assign dac_source_sel = dac_data_sel_s;
  assign dac_data       =  (dac_data_sel_s == 4'h2 ) ? dma_data :
                                              ((dac_data_sel_s == 4'h3) ? {12'b0,control_data} :  ((dac_data_sel_s == 4'h8) ? adc_data : ramp_pattern ));
  assign dac_data_valid =  (dac_data_sel_s == 4'h2 ) ? valid_in_dma :
                                              ((dac_data_sel_s == 4'h3) ? valid_in_ctrl :  ((dac_data_sel_s == 4'h8) ? valid_in_adc : ramp_valid ));

  //always @(posedge dac_clk) begin
  //
  //  case(dac_data_sel_s)
  //    4'h2: begin       // input from DMA
  //      dac_data <= dma_data;
  //      dac_data_valid <= valid_in_dma;
  //    end
  //    4'h3: begin       // input from regmap for control
  //      dac_data <= {12'b0,control_data};
  //      dac_data_valid <= valid_in_ctrl;
  //    end
  //    4'h8: begin      // input from ADC
  //      dac_data <= adc_data;
  //      dac_data_valid <= valid_in_adc;
  //    end
  //    4'hb: begin     // ramp input
  //      dac_data <= ramp_pattern;
  //      dac_data_valid <= ramp_valid;
  //    end
  //    default: begin
  //      dac_data <= ramp_pattern;
  //      dac_data_valid <= ramp_valid;
  //    end
  //  endcase
  //end
//
  // ramp generator
  wire [15:0] max_ramp_value;   
  wire [15:0] min_ramp_value; 
  assign  max_ramp_value = (RAMP_TYPE == 1'b0 ) ? 16'hffff : 16'h0000;
  assign  min_ramp_value = (RAMP_TYPE == 1'b0 ) ? 16'h0000 : 16'hffff;

  always @(posedge dac_clk) begin
    if(dac_data_ready == 1'b1) begin
      if(RAMP_TYPE == 1'b0) begin 
        ramp_pattern <= ramp_pattern + 1'b1;
      end else begin 
        ramp_pattern <= ramp_pattern - 1'b1;
      end
      ramp_valid <= 1'b1;
    end else begin
      ramp_pattern <= ramp_pattern;
      ramp_valid <= 1'b0;
    end
    if(ramp_pattern == max_ramp_value || dac_rst == 1'b1) begin
      ramp_pattern <= min_ramp_value;
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
