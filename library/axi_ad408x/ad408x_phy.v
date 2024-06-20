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

   (* MARK_DEBUG = "TRUE" *) input        [4:0]                num_lanes,
   (* MARK_DEBUG = "TRUE" *) input                             self_sync,
   (* MARK_DEBUG = "TRUE" *) input                             bitslip_enable,
   (* MARK_DEBUG = "TRUE" *) input                             filter_enable,
   (* MARK_DEBUG = "TRUE" *) input                             filter_rdy_n,

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

  (* MARK_DEBUG = "TRUE" *) output                            sync_status
);

  localparam  SEVEN_SERIES     = 1;
  localparam  ULTRASCALE       = 2;
  localparam  ULTRASCALE_PLUS  = 3;

  localparam  [ 2:0]  IDLE         = 3'h0,
                      COUNT        = 3'h1,
                      FILTER_COUNT = 3'h2,
                      SYNC         = 3'h3;

  (* MARK_DEBUG = "TRUE" *) wire           slip;
                            wire           dclk_s;
  (* MARK_DEBUG = "TRUE" *) wire           rise_cnv;
  (* MARK_DEBUG = "TRUE" *) wire           rise_slip;
  (* MARK_DEBUG = "TRUE" *) wire           cnv_in_io;
  (* MARK_DEBUG = "TRUE" *) wire           adc_valid_s;
  (* MARK_DEBUG = "TRUE" *) wire           single_lane;
  (* MARK_DEBUG = "TRUE" *) wire           cnv_in_io_s;
  (* MARK_DEBUG = "TRUE" *) wire           rx_data_b_p;
  (* MARK_DEBUG = "TRUE" *) wire           rx_data_b_n;
  (* MARK_DEBUG = "TRUE" *) wire           rx_data_a_p;
  (* MARK_DEBUG = "TRUE" *) wire           rx_data_a_n;
                            wire           adc_clk_phy;
                            wire           adc_clk_data;
                            wire   [19:0]  adc_data_p_d;
                            wire   [19:0]  pattern_value;
                            wire   [ 1:0]  delay_locked_s;
  (* MARK_DEBUG = "TRUE" *) wire           filter_rdy_n_s;
  (* MARK_DEBUG = "TRUE" *) wire           fall_filter_ready;





  (* MARK_DEBUG = "TRUE" *) reg     [1:0]  slip_d              = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg    [ 3:0]  adc_cnt_p           = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg            cycle_done          = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg    [19:0]  adc_data_p          = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg    [ 1:0]  adc_valid_d         = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg    [ 1:0]  cnv_in_io_d         = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg            filter_cycle        = 'b1;
  (* MARK_DEBUG = "TRUE" *) reg    [ 2:0]  transfer_state      = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg            filter_rdy_n_d      = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg            sync_status_int     = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg            sync_status_int_d   = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg    [ 2:0]  transfer_state_next = 'b0;
  (* MARK_DEBUG = "TRUE" *) reg    [19:0]  adc_data_p_dd[0:1];

  assign pattern_value     = 'hac5d6;
  assign single_lane       = num_lanes[0];
  assign adc_clk           = adc_clk_data;
  assign adc_valid         = adc_valid_d[1];
  assign delay_locked      = &delay_locked_s;
  assign sync_status       = sync_status_int_d;
  assign rise_slip         = ~slip_d[1]      & slip_d[0];
  assign cnv_in_io         =  cnv_in_io_s    & ~self_sync;
  assign slip              =  bitslip_enable &  self_sync;
  assign filter_rdy_n_s    = ~filter_rdy_n   & filter_enable;
  assign rise_cnv          = ~cnv_in_io_d[1] & cnv_in_io_d[0];
  assign fall_filter_ready =  filter_rdy_n_d & ~filter_rdy_n_s;
  assign adc_data          = {{12{adc_data_p_dd[1][19]}},adc_data_p_dd[1]};
  assign adc_valid_s       =  cycle_done & (transfer_state == COUNT || transfer_state == FILTER_COUNT);

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

    adc_data_p_dd[0] <= adc_data_p_d;
    adc_data_p_dd[1] <= adc_data_p_dd[0];
    filter_rdy_n_d   <= filter_rdy_n_s;
    slip_d           <= {slip_d[0],slip};
    cnv_in_io_d      <= {cnv_in_io_d[0],cnv_in_io};
    adc_valid_d      <= {adc_valid_d[0],adc_valid_s};
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
      IDLE : begin
        transfer_state_next = (rise_slip) ? SYNC :((filter_rdy_n_s & filter_cycle)
                                          ? FILTER_COUNT :((!filter_enable && (rise_cnv || self_sync ))
                                          ? COUNT : IDLE ));
        filter_cycle        = (fall_filter_ready)  ? 1'b1 : filter_cycle;
        cycle_done = 0;
      end
      COUNT : begin
        transfer_state_next = (rise_slip)   ? SYNC :((cycle_done)  ? ((filter_rdy_n_s & filter_cycle)
                                            ? FILTER_COUNT : COUNT ) : COUNT );
        filter_cycle        = (fall_filter_ready)  ? 1'b1 : filter_cycle;
        cycle_done          = (single_lane) ? (adc_cnt_p == 4'h4) : (adc_cnt_p == 4'h2);
      end
      FILTER_COUNT : begin
        transfer_state_next = (rise_slip)   ? SYNC :((cycle_done)  ? IDLE : FILTER_COUNT);
        cycle_done          = (single_lane) ? (adc_cnt_p == 4'h4) : (adc_cnt_p == 4'h2);
        filter_cycle        = (cycle_done)  ? 1'b0 : filter_cycle;
      end
      SYNC: begin
        transfer_state_next = (cycle_done)  ? ((filter_rdy_n_s & filter_cycle)
                                            ? FILTER_COUNT :(filter_enable)
                                            ? IDLE : COUNT ) : SYNC;
        cycle_done          = (adc_data_p_d == pattern_value);
        sync_status_int     = cycle_done;
      end
      default : begin
        transfer_state_next = IDLE;
        cycle_done = 0;
      end
    endcase
  end

  always @(posedge adc_clk_data) begin
    if( sync_status_int ) begin
      sync_status_int_d <= 1'b1;
    end else if (transfer_state == IDLE && !filter_enable ) begin
      sync_status_int_d <= 1'b0;
    end
  end

  always @(posedge adc_clk_data) begin

    if (transfer_state == SYNC || adc_rst || adc_cnt_p >= 4'h4) begin
      adc_cnt_p   <= 4'b0;
    end else if (transfer_state == COUNT || transfer_state == FILTER_COUNT || transfer_state == IDLE ) begin
      if (cycle_done) begin
        adc_cnt_p   <= 4'b0;
      end else  begin
        adc_cnt_p   <= adc_cnt_p + 4'b1;
      end
    end
  end

// CDC between the 400MHz phy clock and 200MHz data clock

  util_axis_fifo # (
    .DATA_WIDTH(20),
    .ADDRESS_WIDTH(4),
    .ASYNC_CLK(1)
  ) util_axis_fifo_inst (
    .m_axis_aclk(adc_clk_data),
    .m_axis_aresetn(~adc_rst),
    .m_axis_ready(1'b1),
    .m_axis_valid(),
    .m_axis_data(adc_data_p_d),
    .m_axis_tkeep(),
    .m_axis_tlast(),
    .m_axis_level(),
    .m_axis_empty(),
    .m_axis_almost_empty(),

    .s_axis_aclk(adc_clk_phy),
    .s_axis_aresetn(~adc_rst),
    .s_axis_ready(),
    .s_axis_valid(1'b1),
    .s_axis_data(adc_data_p),
    .s_axis_tkeep(),
    .s_axis_tlast(),
    .s_axis_room(),
    .s_axis_full(),
    .s_axis_almost_full());

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
