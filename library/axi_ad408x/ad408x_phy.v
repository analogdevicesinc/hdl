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

  (* MARK_DEBUG = "TRUE" *) input                              sync_n,

  // Assumption:
  //  control bits are static after sync_n de-assertion

  (* MARK_DEBUG = "TRUE" *) input        [4:0]                num_lanes,
  (* MARK_DEBUG = "TRUE" *) input                             self_sync,
  (* MARK_DEBUG = "TRUE" *) input                             bitslip_enable,
  (* MARK_DEBUG = "TRUE" *) input                             filter_enable,
  (* MARK_DEBUG = "TRUE" *) input                             filter_data_ready_n,

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

  (* MARK_DEBUG = "TRUE" *) output        [31:0]             adc_data,
  (* MARK_DEBUG = "TRUE" *) output                           adc_valid,

  // Synchronization signals used when CNV signal is not present 

  output                            sync_status
);

  localparam  SEVEN_SERIES     = 1;
  localparam  ULTRASCALE       = 2;
  localparam  ULTRASCALE_PLUS  = 3;

  (* MARK_DEBUG = "TRUE" *) wire           adc_cnt_enable_s;
  (* MARK_DEBUG = "TRUE" *) wire   [ 4:0]  shift_cnt_value;
  (* MARK_DEBUG = "TRUE" *) wire   [ 1:0]  delay_locked_s;
  (* MARK_DEBUG = "TRUE" *) wire   [19:0]  pattern_value;
  (* MARK_DEBUG = "TRUE" *) wire   [ 3:0]  adc_cnt_value;
  (* MARK_DEBUG = "TRUE" *) wire           rx_data_b_p;
  (* MARK_DEBUG = "TRUE" *) wire           rx_data_b_n;
  (* MARK_DEBUG = "TRUE" *) wire           rx_data_a_p;
  (* MARK_DEBUG = "TRUE" *) wire           rx_data_a_n;
  (* MARK_DEBUG = "TRUE" *) wire           single_lane;
  (* MARK_DEBUG = "TRUE" *) wire           cnv_in_io_s;
  (* MARK_DEBUG = "TRUE" *) wire           cnv_in_io;
  wire           adc_clk_phy;
  (* MARK_DEBUG = "TRUE" *) wire           adc_clk_data; 
  wire           dclk_s;
  (* MARK_DEBUG = "TRUE" *) wire           filter_data_aqc;
  (* MARK_DEBUG = "TRUE" *) wire           sync_n_adc;

  (* MARK_DEBUG = "TRUE" *) reg            filter_data_ready_n_d = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg            adc_cnt_enable_s_d    = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg            sync_status_int       = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg    [19:0]  adc_data_p            = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg    [19:0]  adc_data_d            = 'd0;
  (* MARK_DEBUG = "TRUE" *) reg    [19:0]  adc_data_dd           = 'd0;
  (* MARK_DEBUG = "TRUE" *) reg    [19:0]  adc_data_ddd          = 'd0;
  (* MARK_DEBUG = "TRUE" *) reg    [ 3:0]  adc_cnt_p             = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg    [ 4:0]  shift_cnt             = 'd0;
  (* MARK_DEBUG = "TRUE" *) reg    [ 4:0]  cnv_in_io_d           = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg            single_lane_dd        = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg            single_lane_d         = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg            adc_valid_p           = 'd0;
  (* MARK_DEBUG = "TRUE" *) reg            shift_cnt_en          = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg            slip_d                = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg            slip_dd               = 'b0;

  assign adc_cnt_enable_s = (adc_cnt_p < adc_cnt_value) ? 1'b1 : 1'b0;
  assign adc_cnt_value    = (single_lane) ? 'h9 : 'h4;
  assign cnv_in_io        = (self_sync) ? 1'b0 : cnv_in_io_s;
  assign single_lane      = num_lanes[0];
  assign delay_locked     = &delay_locked_s;
  assign sync_status      = sync_status_int;
  assign adc_data         = {{12{adc_data_ddd[19]}},adc_data_ddd};
  assign pattern_value    = 'hac5d6;
  assign shift_cnt_value  = 'd19;
  assign adc_clk          = adc_clk_data;

  IBUFDS i_cnv_in_ibuf(
    .I(cnv_in_p),
    .IB(cnv_in_n),
    .O(cnv_in_io_s));

  IBUFDS i_dclk_bufds (
    .O(dclk_s),
    .I(dclk_in_p),
    .IB(dclk_in_n));

  BUFH BUFH_inst (
     .O(adc_clk_phy),
     .I(dclk_s));

  generate
    if (FPGA_TECHNOLOGY == SEVEN_SERIES) begin
      BUFR #(
        .BUFR_DIVIDE("2")
      ) i_div_clk_buf (
        .CLR (~sync_n_adc),
        .CE (1'b1),
        .I (adc_clk_phy),
        .O (adc_clk_data));
  
    end else begin
      BUFGCE_DIV #(
         .BUFGCE_DIVIDE (2),
         .IS_CE_INVERTED (1'b0),
         .IS_CLR_INVERTED (1'b0),
         .IS_I_INVERTED (1'b0)
      ) i_div_clk_buf (
         .O (adc_clk_data),
         .CE (1'b1),
         .CLR (~sync_n_adc),
         .I (adc_clk_phy));
    end
  endgenerate

  sync_event # (
    .NUM_OF_EVENTS(1),
    .ASYNC_CLK(1)
  ) valid_cdc_sync (
    .in_clk(adc_clk_phy),
    .in_event(adc_valid_p),
    .out_clk(adc_clk_data),
    .out_event(adc_valid));

// compensate the delay added by the sync_event 

  always @(posedge adc_clk_phy) begin
    if(adc_valid_p == 1'b1) begin 
      adc_data_d <= adc_data_p;
    end else begin 
      adc_data_d <= adc_data_d;
    end
    adc_data_dd  <= adc_data_d;
    adc_data_ddd <= adc_data_dd;
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
    .rx_clk(~adc_clk_phy),
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
      .rx_clk(~adc_clk_phy),
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

  always @(posedge adc_clk_phy) begin
    slip_d  <= bitslip_enable & self_sync;
    slip_dd <= slip_d;
    if(adc_rst || adc_data_p == pattern_value || ((shift_cnt == shift_cnt_value) && ~filter_enable))
      shift_cnt_en <= 1'b0;
    else if(slip_d & ~slip_dd)
      shift_cnt_en <= 1'b1;
  end
  
  // Additional counter that makes sure that the sinchronization doesn't take longer than 19 clock periods

  reg shift_cnt_en_d = 1'b0;

  always @(posedge adc_clk_phy) begin
    shift_cnt_en_d <= shift_cnt_en;
    if(shift_cnt_en) begin
      if( adc_rst || (~shift_cnt_en_d && shift_cnt_en )) begin
        shift_cnt       <= 6'b0;
        sync_status_int <= 1'b0;
      end else begin
        shift_cnt <= shift_cnt + 1;
      end

      if(adc_data_p == pattern_value) begin
        sync_status_int <= 1'b1;
      end
    end
  end

  // The counter resets based on the mode used: CNV is present or the design uses the self synchronization process
  // The adc_cnt_value is either 4 or 9 based on the number of lanes used

  wire rise_cnv_d;
  assign rise_cnv_d = ~cnv_in_io_d[0] & cnv_in_io;

  always @(posedge adc_clk_phy) begin
  
    cnv_in_io_d        <= {cnv_in_io_d[3:0], cnv_in_io};
    adc_cnt_enable_s_d <= adc_cnt_enable_s;

    if ( ( rise_cnv_d && ~filter_enable) || adc_rst || shift_cnt_en || (~adc_cnt_enable_s && ~filter_enable) || filter_data_ready_n_d ) begin
      adc_cnt_p <= 9'h0;
    end else if (adc_cnt_enable_s == 1'b1) begin
      adc_cnt_p <= adc_cnt_p + 1'b1;
    end

    if (adc_cnt_p == adc_cnt_value && adc_cnt_enable_s_d == 1'b1) begin
      adc_valid_p <= 1'b1;
    end else begin
      adc_valid_p <= 1'b0;
    end
  end

  //the single lane signal runs on the up clock and it's used on the adc_clk_phy



  always @(posedge adc_clk_phy) begin
    single_lane_d  <= single_lane;
    single_lane_dd <= single_lane_d;
    filter_data_ready_n_d   <= filter_data_ready_n && filter_enable;
  end

  // the captured bits are shifted in the adc_data_p register


  always @(posedge adc_clk_phy) begin
    rx_a_pos <= {rx_a_pos,rx_data_a_p};
    rx_b_pos <= {rx_b_pos,rx_data_b_p};
  end
  
  always @(negedge adc_clk_phy) begin
    rx_a_neg <= {rx_a_neg,rx_data_a_n};
    rx_b_neg <= {rx_b_neg,rx_data_b_n};
  end

endmodule
