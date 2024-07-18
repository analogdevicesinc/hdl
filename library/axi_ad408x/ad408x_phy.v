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
                      PRE_SYNC     = 3'h3,
                      SYNC         = 3'h4,
                      POST_SYNC    = 3'h5;

  wire           slip;

  wire           dclk_s;

  wire           rise_cnv;
  wire           rise_slip;
  wire           cnv_in_io;
  wire   [19:0]  adc_data_s;
  wire           adc_valid_s;
  wire           single_lane;

  wire           cnv_in_io_s;
  wire           rx_data_b_p;
  wire           rx_data_b_n;
  wire           rx_data_a_p;
  wire           rx_data_a_n;

  wire           adc_clk_phy;
  wire           adc_clk_data;

  wire   [19:0]  pattern_value;
  wire   [ 3:0]  adc_cnt_value;
  wire   [19:0]  adc_data_p_d;
  wire   [ 1:0]  delay_locked_s;
  wire           filter_rdy_n_s;
  wire   [ 4:0]  shift_cnt_value;
  wire           adc_cnt_enable_s;
  wire           fall_filter_ready;
  wire           fall_filter_ready_s;

  reg    [ 1:0]  slip_d              = 'b0;
  reg    [ 3:0]  adc_cnt_p           = 'b0;
  reg    [19:0]  adc_data_d [0:2]         ;
  reg            cycle_done          = 'b0;
  reg    [19:0]  adc_data_p          = 'b0;
  reg    [ 4:0]  shift_cnt           = 'd0;
  reg            adc_valid_d         = 'b0;
  reg    [ 1:0]  cnv_in_io_d         = 'b0;
  reg            filter_cycle        = 'b1;
  reg    [ 2:0]  transfer_state      = 'b0;
  reg            filter_rdy_n_d      = 'b0;
  reg            sync_status_int     = 'b0;
  reg            sync_status_int_d   = 'b0;
  reg    [19:0]  adc_data_shifted    = 'b0;
  reg    [ 2:0]  transfer_state_next = 'b0;
  reg    [ 1:0]  fall_filter_ready_d = 'b0;

  assign adc_cnt_value       = 'h4;
  assign shift_cnt_value     = 'd19;
  assign pattern_value       = 'hac5d6;
  assign single_lane         =  num_lanes[0];
  assign adc_clk             =  adc_clk_data;
  assign delay_locked        = &delay_locked_s;
  assign sync_status         =  sync_status_int_d;
  assign fall_filter_ready   =  fall_filter_ready_d[1];
  assign rise_slip           = ~slip_d[1]      & slip_d[0];
  assign cnv_in_io           =  cnv_in_io_s    & ~self_sync;
  assign slip                =  bitslip_enable &  self_sync;
  assign filter_rdy_n_s      = ~filter_rdy_n   & filter_enable;
  assign rise_cnv            = ~cnv_in_io_d[1] & cnv_in_io_d[0];
  assign fall_filter_ready_s = ~filter_rdy_n_d & filter_rdy_n_s;
  assign adc_cnt_enable_s    = (adc_cnt_p < adc_cnt_value) ? 1'b1 : 1'b0;
  assign adc_data            = {{12{adc_data_shifted[19]}},adc_data_shifted};
  assign adc_valid           =  cycle_done & (transfer_state == COUNT || transfer_state == FILTER_COUNT);


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

  BUFR #(
    .BUFR_DIVIDE("2")
  ) i_div_clk_buf (
    .CLR (1'b0),
    .CE (1'b1),
    .I (adc_clk_phy),
    .O (adc_clk_data));

  always @(posedge adc_clk_data) begin
    if(transfer_state == PRE_SYNC || adc_rst) begin
      sync_status_int_d <= 1'b0;
    end else if (transfer_state == POST_SYNC) begin
      sync_status_int_d <= 1'b1;
    end
  end

  always @(posedge adc_clk_data) begin
    adc_data_shifted <= {adc_data_d[2],adc_data_d[1]} >> shift_cnt;
  end

  always @(posedge adc_clk_data) begin
    if(transfer_state == SYNC) begin
      if(shift_cnt > shift_cnt_value || adc_rst) begin
        shift_cnt <= 0;
      end else if((adc_data_shifted != pattern_value) && cycle_done) begin
        shift_cnt <= shift_cnt + 1;
      end
    end
  end

  always @(posedge adc_clk_data) begin
    fall_filter_ready_d <= {fall_filter_ready_d[0],fall_filter_ready_s};
    filter_rdy_n_d   <= filter_rdy_n_s;
    slip_d           <= {slip_d[0],slip};
    cnv_in_io_d      <= {cnv_in_io_d[0],cnv_in_io};
  end

  always @(posedge adc_clk_data) begin
    if (adc_rst == 1'b1) begin
      transfer_state <= IDLE;
    end else begin
      transfer_state <= transfer_state_next;
    end
  end

// FSM next state logic

  always @(*) begin
    case (transfer_state)
      IDLE : begin : idle_state
        transfer_state_next = (rise_slip) ? PRE_SYNC :((filter_rdy_n_s & filter_cycle)
                                          ? FILTER_COUNT :((!filter_enable && (rise_cnv || self_sync ))
                                          ? COUNT : IDLE ));
        filter_cycle        = (fall_filter_ready)  ? 1'b1 : filter_cycle;
        cycle_done = 0;
      end
      COUNT : begin : count_state
        transfer_state_next = (rise_slip)   ? PRE_SYNC :((cycle_done)  ? ((filter_rdy_n_s & filter_cycle)
                                            ? FILTER_COUNT : COUNT ) : COUNT );
        filter_cycle        = (fall_filter_ready)  ? 1'b1 : filter_cycle;
        cycle_done          = (adc_cnt_p == 4'h4);
      end
      FILTER_COUNT : begin : filter_count_state
        transfer_state_next = (rise_slip)   ? PRE_SYNC :((cycle_done)  ? IDLE : FILTER_COUNT);
        cycle_done          = (adc_cnt_p == 4'h4);
        filter_cycle        = (cycle_done)  ? 1'b0 : filter_cycle;
      end
      PRE_SYNC: begin : pre_sync_state
        cycle_done          =  (adc_cnt_p == 4'h4);
        transfer_state_next = SYNC;
      end
      SYNC: begin : sync_state
        transfer_state_next = sync_status_int ? POST_SYNC : SYNC;
        cycle_done          = (adc_cnt_p == 4'h4);
        sync_status_int     = (adc_data_shifted == pattern_value);
      end
      POST_SYNC: begin : post_sync_state
        cycle_done          = (adc_cnt_p == 4'h4);
        transfer_state_next = (filter_rdy_n_s & filter_cycle) ? FILTER_COUNT :
                                             ((filter_enable) ? IDLE : COUNT);
      end
      default : begin : default_state
        transfer_state_next = IDLE;
        cycle_done = 0;
      end
    endcase
  end

  always @(posedge adc_clk_data) begin
    if (adc_rst || cycle_done || (sync_status_int && transfer_state == SYNC) || transfer_state == IDLE) begin
      adc_cnt_p   <= 4'b0;
    end else if (adc_cnt_enable_s) begin
        adc_cnt_p   <= adc_cnt_p + 4'b1;
    end
  end

  always @(posedge adc_clk_data) begin
    adc_data_d[0] <= adc_data_p_d;
    adc_data_d[1] <= adc_data_d[0];
    adc_data_d[2] <= adc_data_d[1];
  end

  // util_axis_fifo # (
    // .DATA_WIDTH(20),
    // .ADDRESS_WIDTH(4)
  // ) util_axis_fifo_inst (
    // .m_axis_aclk(adc_clk_data),
    // .m_axis_aresetn(~adc_rst),
    // .m_axis_ready(1'b1),
    // .m_axis_valid(),
    // .m_axis_data(adc_data_p_d),
    // .m_axis_tkeep(),
    // .m_axis_tlast(),
    // .m_axis_level(),
    // .m_axis_empty(),
    // .m_axis_almost_empty(),

    // .s_axis_aclk(adc_clk_phy),
    // .s_axis_aresetn(~adc_rst),
    // .s_axis_ready(),
    // .s_axis_valid(1'b1),
    // .s_axis_data(adc_data_p),
    // .s_axis_tkeep(),
    // .s_axis_tlast(),
    // .s_axis_room(),
    // .s_axis_full(),
    // .s_axis_almost_full());

  xpm_cdc_gray #(
    .DEST_SYNC_FF(10), // DECIMAL; range: 2-10
    .INIT_SYNC_FF(0),  // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
    .REG_OUTPUT(1),    // DECIMAL		0: Disable registered output 1: Enable registered output
    .WIDTH(20)         // 	Width of binary input bus that will be synchronized to destination clock domain.
  ) data_sync (
    .dest_clk(adc_clk_data),
    .dest_out_bin(adc_data_p_d),
    .src_clk(adc_clk_phy),
    .src_in_bin(adc_data_p));



  always @(posedge adc_clk_phy) begin
    adc_data_p <= {adc_data_p[17:0], rx_data_a_p, rx_data_a_n};
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

endmodule
