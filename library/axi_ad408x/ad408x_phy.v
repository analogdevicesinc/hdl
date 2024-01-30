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
  parameter NUM_LANES = 2,  // Max number of lanes is 2
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

  // control interface

   input                              sync_n,

    // Assumption:
    //  control bits are static after sync_n de-assertion

  input        [4:0]                num_lanes,

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

   output        [31:0]             adc_data,
   output                           adc_valid,

  // Debug interface

  output                            clk_in_s,
  input                             bitslip_enable,
  output                            sync_status
);

  localparam SEVEN_SERIES    = 1;
  localparam ULTRASCALE      = 2;
  localparam ULTRASCALE_PLUS = 3;

   wire              adc_clk_in_fast;
   wire              cnv_in_io;
   wire              rx_data_b_p;
   wire              rx_data_b_n;
   wire              rx_data_a_p;
   wire              rx_data_a_n;
   wire    [ 8:0]    adc_cnt_value;
   wire              adc_cnt_enable_s;
   wire    [ 1:0]    delay_locked_s;
   wire              single_lane;

   reg     [ 8:0]    adc_cnt_p          =   'b0;
   reg     [ 4:0]    cnv_in_io_d        =   'b0;
   reg               adc_valid_p        =   'd0;
   reg     [19:0]    adc_data_p         = 19'b0;
   reg               adc_cnt_enable_s_d =   'b0;

  assign delay_locked = &delay_locked_s;
  assign single_lane = num_lanes[0];

  my_ila i_ila (
    .clk(adc_clk_in_fast),
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
    .probe12(adc_data_p));


  wire dclk_s;

  IBUFDS i_cnv_in_ibuf(
  .I(cnv_in_p),
  .IB(cnv_in_n),
  .O(cnv_in_io));

  IBUFDS i_dclk_bufds (
    .O(dclk_s),
    .I(dclk_in_p),
    .IB(dclk_in_n));

   // It is added to constraint the tool to keep the logic in the same region
   // as the input pins, otherwise the tool will automatically add a bufg and
   // meeting the timing margins is harder.

  BUFH BUFH_inst (
     .O(adc_clk_in_fast),
     .I(dclk_s));
  

  ad_data_in # (
    .SINGLE_ENDED(0),
    .IDDR_CLK_EDGE("OPPOSITE_EDGE"),
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .DDR_SDR_N(1),
    .IODELAY_CTRL(IODELAY_CTRL),
    .IODELAY_GROUP(IO_DELAY_GROUP),
    .REFCLK_FREQUENCY(DELAY_REFCLK_FREQUENCY)
  ) da_iddr (
    .rx_clk(adc_clk_in_fast),
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
      .rx_clk(adc_clk_in_fast),
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

  assign adc_cnt_value    = (single_lane) ? 'h9 : 'h4;
  assign adc_cnt_enable_s = (adc_cnt_p < adc_cnt_value) ? 1'b1 : 1'b0;


  always @(posedge adc_clk_in_fast) begin
  
    cnv_in_io_d <= {cnv_in_io_d[3:0],cnv_in_io};
    adc_cnt_enable_s_d <= adc_cnt_enable_s;

    if (~cnv_in_io_d[4] & cnv_in_io_d[3] ) begin
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

  always @(posedge adc_clk_in_fast) begin
    if(single_lane) begin 
      if (adc_cnt_p == 'h000) begin
        adc_data_p <= {18'd0, rx_data_a_p, rx_data_a_n};
      end else begin
        adc_data_p <= {adc_data_p[17:0], rx_data_a_p, rx_data_a_n};
      end
    end else begin
      if (adc_cnt_p == 'h000) begin
        adc_data_p <= {16'd0, rx_data_a_p, rx_data_b_p, rx_data_a_n, rx_data_b_n};
      end else begin
        adc_data_p <= {adc_data_p[15:0], rx_data_a_p, rx_data_b_p, rx_data_a_n, rx_data_b_n};
      end
    end
  end


  // reg [19:0] adc_data_d;
  // reg [19:0] adc_data_dd;
// 
  // reg        adc_valid_d;
  // reg        adc_valid_dd;
// 
  // always @(posedge adc_clk_in_fast) begin
  //  
    // adc_data_d <= adc_data_p;
    // adc_valid_d <= adc_valid_p;
    // 
    // adc_data_dd  <= adc_data_d;
    // adc_valid_dd <= adc_valid_d;
  // end

   // Sign extend to 32 bits

  assign adc_data  = {{12{adc_data_p[19]}},adc_data_p};
  assign adc_valid = adc_valid_p;

  assign adc_clk     = adc_clk_in_fast;

  
endmodule
