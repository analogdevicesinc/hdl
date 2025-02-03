// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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
// Redistribution and use of source or resulting binaries, with or without modification
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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_hmcad15xx_if #(
  parameter          DRP_WIDTH = 5,
  parameter          NUM_LANES = 9,  // Data lanes + frame lane
  parameter          FPGA_TECHNOLOGY = 0,
  parameter          IODELAY_CTRL = 1,
  parameter          IO_DELAY_GROUP = "adc_if_delay_group"
) (

  // device-interface

  input                  clk_in_p,
  input                  clk_in_n,
  input                  fclk_p,
  input                  fclk_n,
  input   [ 7:0]         data_in_p,
  input   [ 7:0]         data_in_n,

  input                  adc_rst,

  // data path interface

  output                 adc_clk,
  output                 adc_valid,
  output reg  [7:0]      adc_data_0,
  output reg  [7:0]      adc_data_1,
  output reg  [7:0]      adc_data_2,
  output reg  [7:0]      adc_data_3,

  // delay control signals
  input                                     up_clk,
  input       [NUM_LANES-1:0]               up_dld,
  input       [DRP_WIDTH*NUM_LANES-1:0]     up_dwdata,
  output      [DRP_WIDTH*NUM_LANES-1:0]     up_drdata,
  input                                     delay_clk,
  input                                     delay_rst,
  output                                    delay_locked

);


wire clk_in_s;
wire adc_clk_in_fast;
wire delay_locked_2;

IBUFGDS i_clk_in_ibuf(
  .I (clk_in_p),
  .IB(clk_in_n),
  .O(clk_in_s));

BUFIO i_clk_buf(
  .I(clk_in_s),
  .O(adc_clk_in_fast));

 BUFR #(
   .BUFR_DIVIDE("4")
 ) i_div_clk_buf (
   .CLR(1'b0),
   .CE(1'b1),
   .I(clk_in_s),
   .O(adc_clk_div));


  assign adc_clk = adc_clk_div;

wire [7:0] data_s0;
wire [7:0] data_s1;
wire [7:0] data_s2;
wire [7:0] data_s3;
wire [7:0] data_s4;
wire [7:0] data_s5;
wire [7:0] data_s6;
wire [7:0] data_s7;


  // Min 2 div_clk cycles once div_clk is running after deassertion of sync
  // Control externally the reset of serdes for precise timing

reg  [5:0]  serdes_reset = 6'b000110;
reg  [1:0]  serdes_valid = 2'b00;

wire serdes_reset_s;


always @(posedge adc_clk_div or posedge adc_rst) begin
  if(adc_rst) begin
    serdes_reset <= 6'b000110;
  end else begin
    serdes_reset <= {serdes_reset[4:0],1'b0};
  end
end
assign serdes_reset_s = serdes_reset[5];

always @(posedge adc_clk_div) begin
  if(serdes_reset_s) begin
    serdes_valid <= 2'b00;
  end else begin
    serdes_valid <= {serdes_valid[0],1'b1};
  end
end

ad_serdes_in # (
  .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
  .IODELAY_GROUP(IO_DELAY_GROUP),
  .IODELAY_CTRL(IODELAY_CTRL),
  .DATA_WIDTH(NUM_LANES),
  .DRP_WIDTH(DRP_WIDTH),
  .EXT_SERDES_RESET(1),
  .SERDES_FACTOR(8),
  .DDR_OR_SDR_N(1),
  .CMOS_LVDS_N(0)
) ad_serdes_data_inst (
  .rst(serdes_reset_s),
  .ext_serdes_rst(serdes_reset_s),
  .clk(adc_clk_in_fast),
  .div_clk(adc_clk_div),
  .data_s0(data_s0),
  .data_s1(data_s1),
  .data_s2(data_s2),
  .data_s3(data_s3),
  .data_s4(data_s4),
  .data_s5(data_s5),
  .data_s6(data_s6),
  .data_s7(data_s7),
  .data_in_p(data_in_p),
  .data_in_n(data_in_n),
  .up_clk(up_clk),
  .up_dld(up_dld[7:0]),
  .up_dwdata(up_dwdata[39:0]),
  .up_drdata(up_drdata[39:0]),
  .delay_clk(delay_clk),
  .delay_rst(delay_rst),
  .delay_locked(delay_locked)
);

wire [7:0] frame_data;

ad_serdes_in # (
  .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
  .IODELAY_GROUP(IO_DELAY_GROUP),
  .IODELAY_CTRL(0),
  .DATA_WIDTH(1),
  .DRP_WIDTH(DRP_WIDTH),
  .EXT_SERDES_RESET(1),
  .SERDES_FACTOR(8),
  .DDR_OR_SDR_N(1),
  .CMOS_LVDS_N(0)
) ad_serdes_frame_inst (
  .rst(serdes_reset_s),
  .ext_serdes_rst(serdes_reset_s),
  .clk(adc_clk_in_fast),
  .div_clk(adc_clk_div),
  .data_s0(frame_data[0]),
  .data_s1(frame_data[1]),
  .data_s2(frame_data[2]),
  .data_s3(frame_data[3]),
  .data_s4(frame_data[4]),
  .data_s5(frame_data[5]),
  .data_s6(frame_data[6]),
  .data_s7(frame_data[7]),
  .data_in_p(fclk_p),
  .data_in_n(fclk_n),
  .up_clk(up_clk),
  .up_dld(up_dld[8]),
  .up_dwdata(up_dwdata[44:40]),
  .up_drdata(up_drdata[44:40]),
  .delay_clk(delay_clk),
  .delay_rst(delay_rst),
  .delay_locked(delay_locked_2)
);


  wire [7:0] serdes_data_7;
  wire [7:0] serdes_data_6;
  wire [7:0] serdes_data_5;
  wire [7:0] serdes_data_4;
  wire [7:0] serdes_data_3;
  wire [7:0] serdes_data_2;
  wire [7:0] serdes_data_1;
  wire [7:0] serdes_data_0;

  assign {serdes_data_7[0],serdes_data_6[0],serdes_data_5[0],serdes_data_4[0],
          serdes_data_3[0],serdes_data_2[0],serdes_data_1[0],serdes_data_0[0]} = data_s0;  //latest bit received
  assign {serdes_data_7[1],serdes_data_6[1],serdes_data_5[1],serdes_data_4[1],
          serdes_data_3[1],serdes_data_2[1],serdes_data_1[1],serdes_data_0[1]} = data_s1;  //
  assign {serdes_data_7[2],serdes_data_6[2],serdes_data_5[2],serdes_data_4[2],
          serdes_data_3[2],serdes_data_2[2],serdes_data_1[2],serdes_data_0[2]} = data_s2;  //
  assign {serdes_data_7[3],serdes_data_6[3],serdes_data_5[3],serdes_data_4[3],
          serdes_data_3[3],serdes_data_2[3],serdes_data_1[3],serdes_data_0[3]} = data_s3;  //
  assign {serdes_data_7[4],serdes_data_6[4],serdes_data_5[4],serdes_data_4[4],
          serdes_data_3[4],serdes_data_2[4],serdes_data_1[4],serdes_data_0[4]} = data_s4;  //
  assign {serdes_data_7[5],serdes_data_6[5],serdes_data_5[5],serdes_data_4[5],
          serdes_data_3[5],serdes_data_2[5],serdes_data_1[5],serdes_data_0[5]} = data_s5;  //
  assign {serdes_data_7[6],serdes_data_6[6],serdes_data_5[6],serdes_data_4[6],
          serdes_data_3[6],serdes_data_2[6],serdes_data_1[6],serdes_data_0[6]} = data_s6;  //
  assign {serdes_data_7[7],serdes_data_6[7],serdes_data_5[7],serdes_data_4[7],
          serdes_data_3[7],serdes_data_2[7],serdes_data_1[7],serdes_data_0[7]} = data_s7;  // oldest bit received

wire [15:0] data_out;
wire        data_en;

  sample_assembly  sample_assembly_inst (
    .clk(adc_clk_div),
    .frame(frame_data),
    .data_in(serdes_data_7),
    .resolution(2'b00),
    .data_en(data_en),
    .data_out(data_out)
  );




  always @(posedge adc_clk_div) begin
    adc_data_0 <= {serdes_data_7};
    adc_data_1 <= {serdes_data_6};
    adc_data_2 <= {serdes_data_5};
    adc_data_3 <= {serdes_data_4};
  end

endmodule
