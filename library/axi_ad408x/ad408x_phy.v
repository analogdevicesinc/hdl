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
  input                             filter_rdy_n,

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

  localparam  SEVEN_SERIES     = 1;
  localparam  ULTRASCALE       = 2;
  localparam  ULTRASCALE_PLUS  = 3;

  localparam  [ 2:0]  IDLE         = 3'h0,
                      COUNT        = 3'h1,
                      FILTER_COUNT = 3'h2,
                      SYNC         = 3'h3;

  wire   [ 1:0]  delay_locked_s;
  wire   [19:0]  pattern_value;

  wire           rx_data_b_p;
  wire           rx_data_b_n;
  wire           rx_data_a_p;
  wire           rx_data_a_n;

  wire           single_lane;
  wire           cnv_in_io_s;
  wire           cnv_in_io;
  wire           adc_clk_phy;
  wire           adc_clk_data; 
  wire           dclk_s;

  //wire   [19:0]  adc_data_d  ;
  wire   [19:0]  adc_data_dd ;


  reg            sync_status_int     = 'b0;
  reg    [19:0]  adc_data_p          = 'b0;
  reg    [19:0]  adc_data_p_d        = 'b0;
  reg    [19:0]  adc_data_d          = 'b0;
  // reg    [19:0]  adc_data_dd         = 'b0;
  reg    [19:0]  adc_data_ddd        = 'd0;
  reg    [19:0]  adc_data_dddd       = 'd0;
  reg    [ 3:0]  adc_cnt_p           = 'b0;
  reg            adc_valid_p         = 'd0;
  reg     [1:0]  slip_d              = 'b0;
  reg            cycle_done          = 'b0;
  reg    [ 2:0]  transfer_state      = 'b0;
  reg    [ 2:0]  transfer_state_next = 'b0;


  assign single_lane   = num_lanes[0];
  assign delay_locked  = &delay_locked_s;
  assign sync_status   = sync_status_int;
  assign adc_data      = {{12{adc_data_dd[19]}},adc_data_dd};
  assign adc_valid     = adc_valid_d;      
  assign pattern_value = 'hd6ac5;
  assign adc_clk       = adc_clk_data;


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

  reg adc_valid_p_d = 'b0;
  wire adc_valid_d;
  sync_event # (
    .NUM_OF_EVENTS(1),
    .ASYNC_CLK(1)
  ) valid_cdc_sync (
    .in_clk(adc_clk_phy),
    .in_event(adc_valid_p_d),
    .out_clk(adc_clk_data),
    .out_event(adc_valid_d));

  sync_data #(
    .NUM_OF_BITS (20),
    .ASYNC_CLK (1)
  ) adc_data_sync (
    .in_clk (adc_clk_phy),
    .in_data (adc_data_d),
    .out_clk (adc_clk_data),
    .out_data (adc_data_dd));




// compensate the delay added by the sync_event 

  always @(posedge adc_clk_phy) begin
    adc_data_p_d  <= adc_data_p;
    adc_valid_p_d <= adc_valid_p;
    if(adc_valid_p == 1'b1) begin 
      adc_data_d <= adc_data_p_d;
    end else begin 
      adc_data_d <= adc_data_d;
    end
  end
 
wire      rise_cnv;
wire      rise_slip;
wire      slip;
reg [1:0] cnv_in_io_d = 'b0;
reg       filter_rdy_n_d = 'b0;

assign cnv_in_io           =  cnv_in_io_s    & ~self_sync;
assign slip                =  bitslip_enable &  self_sync;
assign filter_rdy_n_s      =  filter_rdy_n   & filter_enable;
assign fall_filter_ready   =  filter_rdy_n_d & ~filter_rdy_n_s;
assign rise_cnv            = ~cnv_in_io_d[1] & cnv_in_io_d[0];
assign rise_slip           = ~slip_d[1]      & slip_d[0];


always @(posedge adc_clk_phy) begin
  slip_d         <= {slip_d[0],slip};
  cnv_in_io_d    <= {cnv_in_io_d[0],cnv_in_io};
  filter_rdy_n_d <= filter_rdy_n_s;
end


always @(posedge adc_clk_phy) begin
  if (adc_rst == 1'b1) begin
    transfer_state <= IDLE;
  end else begin
    transfer_state <= transfer_state_next;
  end
end 

// FSM next state logic

  always @(*) begin
    case (transfer_state)
      IDLE : begin
        cycle_done = 0;
        sync_status_int     = 0;
        transfer_state_next = (fall_filter_ready) ? FILTER_COUNT :((filter_enable) ? IDLE : COUNT);
      end
      COUNT : begin
        transfer_state_next = (rise_slip) ? SYNC :((cycle_done)  ? ((filter_enable)  ? FILTER_COUNT : COUNT ) : COUNT );
        cycle_done          = (single_lane) ? (adc_cnt_p == 4'h9) : (adc_cnt_p == 4'h4);
      end
      FILTER_COUNT : begin
        transfer_state_next = (cycle_done)  ? IDLE : FILTER_COUNT;
        cycle_done          = (single_lane) ? (adc_cnt_p == 4'h9) : (adc_cnt_p == 4'h4);
      end
      SYNC: begin
        transfer_state_next = (cycle_done) ? ((fall_filter_ready) ? FILTER_COUNT : COUNT ) : SYNC;
        cycle_done          = (adc_data_p_d == pattern_value);
        sync_status_int     = (cycle_done) ? 1'b1 : sync_status_int;
      end
      default : begin
        cycle_done = 0;
        transfer_state_next = IDLE;
      end
    endcase
  end


  always @(posedge adc_clk_phy) begin
    if (transfer_state == IDLE || transfer_state == SYNC || adc_rst == 1'b1 ) begin
      adc_cnt_p <= 0;
    end else if (transfer_state == COUNT || transfer_state == FILTER_COUNT ) begin
      if (cycle_done) begin
        adc_cnt_p   <= 0;
        adc_valid_p <= 1'b1;
      end else  begin
        adc_cnt_p   <= adc_cnt_p + 1;
        adc_valid_p <= 1'b0;
      end
    end
  end

  always @(posedge adc_clk_phy) begin
    if(single_lane) begin
        adc_data_p <= {adc_data_p[17:0], rx_data_a_p, rx_data_a_n};
    end else begin
        adc_data_p <= {adc_data_p[15:0], rx_data_a_p, rx_data_b_p, rx_data_a_n, rx_data_b_n};
    end
  end

  ad_data_in # (
    .SINGLE_ENDED(0),
    .IDDR_CLK_EDGE("SAME_EDGE_PIPELINED"),
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
      .IDDR_CLK_EDGE("SAME_EDGE_PIPELINED"),
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
endmodule
