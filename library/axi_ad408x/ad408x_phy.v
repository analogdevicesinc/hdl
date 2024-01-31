// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2024 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL(Verilog or VHDL) components. The individual modules are
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
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository(LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository(LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad408x_phy #(
  parameter FPGA_TECHNOLOGY = 0,
  parameter DRP_WIDTH = 5,
  parameter NUM_LANES = 2,
  parameter IODELAY_CTRL = 1,
  parameter DELAY_REFCLK_FREQUENCY = 200,
  parameter IO_DELAY_GROUP = "dev_if_delay_group"
) (

  // device interface

  input                             dclk_in_n,
  input                             dclk_in_p,
  input                             data_a_in_n,
  input                             data_a_in_p,
  input                             data_b_in_n,
  input                             data_b_in_p,

  input                             cnv_in_p,
  input                             cnv_in_n,

  // reset signal 

  input                              sync_n,

  // Assumption:
  //  control bits are static after sync_n de-assertion

  input        [4:0]                num_lanes,
  input                             self_sync,
  input                             bitslip_enable,
  input                             filter_enable,
  input                             filter_data_ready_n,

  // delay interface(for IDELAY macros)

  input                             up_clk,
  input   [          NUM_LANES-1:0] up_adc_dld,
  input   [DRP_WIDTH*NUM_LANES-1:0] up_adc_dwdata,
  output  [DRP_WIDTH*NUM_LANES-1:0] up_adc_drdata,
  input                             delay_clk,
  input                             delay_rst,
  output                            delay_locked,

  // internal reset and clocks

  input                             adc_rst,
  output                            adc_clk,

  // Output data 

  output        [31:0]             adc_data,
  output                           adc_valid,

  // Synchronization signals used when CNV signal is not present 

  output                            sync_status
);
  wire           adc_cnt_enable_s;
  wire           serdes_reset_s;
  wire   [ 5:0]  shift_cnt_value;
  wire   [ 1:0]  delay_locked_s;
  wire   [19:0]  pattern_value;
  wire   [ 8:0]  adc_cnt_value;
  wire           rx_data_b_p;
  wire           rx_data_b_n;
  wire           rx_data_a_p;
  wire           rx_data_a_n;
  wire           single_lane;
  wire           cnv_in_io_s;
  wire           cnv_in_io;
  wire           self_sync;
  wire           adc_clk;
  wire           dclk_s;

  reg    [ 5:0]  serdes_reset       = 'b000110;
  reg            adc_cnt_enable_s_d = 'b0;
  reg            sync_status_int    = 'b0;
  reg    [19:0]  adc_data_p         = 'b0;
  reg    [19:0]  adc_data_d         = 'd0;
  reg    [ 8:0]  adc_cnt_p          = 'b0;
  reg    [ 5:0]  shift_cnt          = 'd0;
  reg    [ 4:0]  cnv_in_io_d        = 'b0;
  reg            single_lane_dd     = 'b0;
  reg            single_lane_d      = 'b0;
  reg            adc_valid_p        = 'd0;
  reg            shift_cnt_en       = 'b0;
  reg            slip_d             = 'b0;
  reg            slip_dd            = 'b0;
 
 
 
  assign adc_cnt_enable_s = (adc_cnt_p < adc_cnt_value) ? 1'b1 : 1'b0;
  assign adc_cnt_value    = (single_lane) ? 'h9 : 'h4;
  assign cnv_in_io        = (self_sync) ? 1'b0 : cnv_in_io_s;
  assign serdes_reset_s   = serdes_reset[5];
  assign single_lane      = num_lanes[0];
  assign delay_locked     = &delay_locked_s;
  assign sync_status      = sync_status_int;
  assign adc_data         = {{12{adc_data_d[19]}},adc_data_d};
  assign adc_valid        = adc_valid_p;
  assign filter_data_aqc  = filter_data_ready_n & filter_enable;
  assign pattern_value    = 'hac5d6;
  assign shift_cnt_value  = 'd39;

  my_ila i_ila (
    .clk(adc_clk),
    .probe0(cnv_in_io),
    .probe1(rx_data_b_p),
    .probe2(rx_data_b_n),
    .probe3(rx_data_a_p),
    .probe4(rx_data_a_n),
    .probe5(adc_data),
    .probe6(adc_valid),
    .probe7(adc_cnt_value),
    .probe8(adc_cnt_enable_s),
    .probe9(adc_cnt_p),
    .probe10(cnv_in_io_d),
    .probe11(adc_valid_p),
    .probe12(adc_data_p),
    .probe13(filter_data_ready_n),
    .probe14(sync_status),
    .probe15(filter_enable),
    .probe16(bitslip_enable),
    .probe17(self_sync),
    .probe18(filter_data_aqc));

  IBUFDS i_cnv_in_ibuf(
  .I(cnv_in_p),
  .IB(cnv_in_n),
  .O(cnv_in_io_s));

  IBUFDS i_dclk_bufds (
    .O(dclk_s),
    .I(dclk_in_p),
    .IB(dclk_in_n));

  BUFH BUFH_inst (
     .O(adc_clk),
     .I(dclk_s));

  // Min 2 div_clk cycles once div_clk is running after deassertion of sync
  // To make sure that the clocks are present and stable

  always @(posedge adc_clk or negedge sync_n) begin
    if(~sync_n) begin
      serdes_reset <= 6'b000110;
    end else begin
      serdes_reset <= {serdes_reset[4:0],1'b0};
    end
  end
  
  ad_data_in # (
    .SINGLE_ENDED(0),
    .IDDR_CLK_EDGE("OPPOSITE_EDGE"),
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .DDR_SDR_N(1),
    .IODELAY_CTRL(IODELAY_CTRL),
    .IODELAY_GROUP(IO_DELAY_GROUP),
    .REFCLK_FREQUENCY(DELAY_REFCLK_FREQUENCY)
  ) da_iddr (
    .rx_clk(adc_clk),
    .rx_data_in_p(data_a_in_p),
    .rx_data_in_n(data_a_in_n),
    .rx_data_p(rx_data_a_p),
    .rx_data_n(rx_data_a_n),
    .up_clk(up_clk),
    .up_dld(up_adc_dld[0]),
    .up_dwdata(up_adc_dwdata[4:0]),
    .up_drdata(up_adc_drdata[4:0]),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_locked(delay_locked_s[1]));

    ad_data_in # (
      .SINGLE_ENDED(0),
      .IDDR_CLK_EDGE("OPPOSITE_EDGE"),
      .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
      .DDR_SDR_N(1),
      .IODELAY_CTRL(IODELAY_CTRL),
      .IODELAY_GROUP(IO_DELAY_GROUP),
      .REFCLK_FREQUENCY(DELAY_REFCLK_FREQUENCY)
    ) db_iddr (
      .rx_clk(adc_clk),
      .rx_data_in_p(data_b_in_p),
      .rx_data_in_n(data_b_in_n),
      .rx_data_p(rx_data_b_p),
      .rx_data_n(rx_data_b_n),
      .up_clk(up_clk),
      .up_dld(up_adc_dld[1]),
      .up_dwdata(up_adc_dwdata[9:5]),
      .up_drdata(up_adc_drdata[9:5]),
      .delay_clk(delay_clk),
      .delay_rst(delay_rst),
      .delay_locked(delay_locked_s[0]));

  // The shift_cnt_en signal will keep the data bits counter untill the pattern is captured in adc_data_p

  always @(posedge adc_clk) begin
    slip_d  <= bitslip_enable & self_sync;
    slip_dd <= slip_d;
    if(serdes_reset_s || adc_data_p == pattern_value || shift_cnt == shift_cnt_value)
      shift_cnt_en <= 1'b0;
    else if(slip_d & ~slip_dd)
      shift_cnt_en <= 1'b1;
  end
  
  // Additional counter that makes sure that the sinchronization process works only for 39 clock periods

  always @(posedge adc_clk) begin
    if(shift_cnt_en) begin
      if( serdes_reset_s) begin
        shift_cnt       <= 6'b0;
        sync_status_int <= 1'b0;
      end else if( adc_data_p != pattern_value) begin
        shift_cnt <= shift_cnt + 1;
      end
      if(adc_data_p == pattern_value) begin
        sync_status_int <= 1'b1;
      end
    end
  end

  // The counter resets based on the mode used: CNV is present or the design uses the self synchronization process
  // The adc_cnt_value is either 4 or 9 based on the number of lanes used

  always @(posedge adc_clk) begin
  
    cnv_in_io_d        <= {cnv_in_io_d[3:0], cnv_in_io};
    adc_cnt_enable_s_d <= adc_cnt_enable_s;

    if ( (~cnv_in_io_d[4] & cnv_in_io_d[3]) || serdes_reset_s || shift_cnt_en || (~adc_cnt_enable_s && ~filter_enable) || filter_data_aqc ) begin
      adc_cnt_p <= 'h000;
    end else if (adc_cnt_enable_s == 1'b1) begin
      adc_cnt_p <= adc_cnt_p + 1'b1;
    end

    if (adc_cnt_p == adc_cnt_value && adc_cnt_enable_s_d == 1'b1) begin
      adc_valid_p <= 1'b1;
    end else begin
      adc_valid_p <= 1'b0;
    end
  end

  //the single lane signal runs on the up clock and it's used on the adc_clk

  always @(posedge adc_clk) begin
    single_lane_d  <= single_lane;
    single_lane_dd <= single_lane_d;
  end

  // the captured bits are shifted in the adc_data_p register

  always @(posedge adc_clk) begin
    adc_data_d     <= adc_data_p;
    if(single_lane_dd) begin
        adc_data_p <= {adc_data_p[17:0], rx_data_a_p, rx_data_a_n};
    end else begin
        adc_data_p <= {adc_data_p[15:0], rx_data_a_p, rx_data_b_p, rx_data_a_n, rx_data_b_n};
    end
  end

endmodule
