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
  parameter          IO_DELAY_GROUP = "adc_if_delay_group",
  parameter          REFCLK_FREQUENCY = 200,
  parameter          POLARITY_MASK = 8'h00
) (

  // device-interface

  input                  clk_in_p,
  input                  clk_in_n,
  input                  fclk_p,
  input                  fclk_n,
  input   [ 7:0]         data_in_p,
  input   [ 7:0]         data_in_n,

  input                  adc_rst,

  input   [ 1:0]         resolution,
  input   [ 2:0]         mode,

  // data path interface

  output                 adc_clk,
  output                 adc_valid,
  output    [127:0]      adc_data,

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
wire adc_clk_div;

IBUFDS i_clk_in_ibuf(
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

wire [8:0] data_s0;
wire [8:0] data_s1;
wire [8:0] data_s2;
wire [8:0] data_s3;
wire [8:0] data_s4;
wire [8:0] data_s5;
wire [8:0] data_s6;
wire [8:0] data_s7;


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
  .IODELAY_CTRL(0),
  .IODELAY_ENABLE(0),
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
  .data_in_p({fclk_p, data_in_p}),
  .data_in_n({fclk_n, data_in_n}),
  .up_clk(up_clk),
  .up_dld(up_dld),
  .up_dwdata(up_dwdata),
  .up_drdata(up_drdata),
  .delay_clk(delay_clk),
  .delay_rst(delay_rst),
  .delay_locked(delay_locked)
);




  wire [7:0] frame_data;
  wire [7:0] serdes_data [0:7];

  assign {frame_data[7],serdes_data[7][7],serdes_data[6][7],serdes_data[5][7],serdes_data[4][7],serdes_data[3][7],serdes_data[2][7],serdes_data[1][7],serdes_data[0][7]} = data_s0;  //latest bit received
  assign {frame_data[6],serdes_data[7][6],serdes_data[6][6],serdes_data[5][6],serdes_data[4][6],serdes_data[3][6],serdes_data[2][6],serdes_data[1][6],serdes_data[0][6]} = data_s1;  //
  assign {frame_data[5],serdes_data[7][5],serdes_data[6][5],serdes_data[5][5],serdes_data[4][5],serdes_data[3][5],serdes_data[2][5],serdes_data[1][5],serdes_data[0][5]} = data_s2;  //
  assign {frame_data[4],serdes_data[7][4],serdes_data[6][4],serdes_data[5][4],serdes_data[4][4],serdes_data[3][4],serdes_data[2][4],serdes_data[1][4],serdes_data[0][4]} = data_s3;  //
  assign {frame_data[3],serdes_data[7][3],serdes_data[6][3],serdes_data[5][3],serdes_data[4][3],serdes_data[3][3],serdes_data[2][3],serdes_data[1][3],serdes_data[0][3]} = data_s4;  //
  assign {frame_data[2],serdes_data[7][2],serdes_data[6][2],serdes_data[5][2],serdes_data[4][2],serdes_data[3][2],serdes_data[2][2],serdes_data[1][2],serdes_data[0][2]} = data_s5;  //
  assign {frame_data[1],serdes_data[7][1],serdes_data[6][1],serdes_data[5][1],serdes_data[4][1],serdes_data[3][1],serdes_data[2][1],serdes_data[1][1],serdes_data[0][1]} = data_s6;  //
  assign {frame_data[0],serdes_data[7][0],serdes_data[6][0],serdes_data[5][0],serdes_data[4][0],serdes_data[3][0],serdes_data[2][0],serdes_data[1][0],serdes_data[0][0]} = data_s7;  // oldest bit received

wire [15:0] data_out [0:7];
wire [ 7:0] data_en;

  generate
    genvar i;
      for (i = 0; i < NUM_LANES-1; i=i+1) begin: sample_assembly_lanes
        sample_assembly  sample_assembly_inst (
          .clk(adc_clk_div),
          .frame(frame_data),
          .data_in(serdes_data[i] ^ POLARITY_MASK),
          .resolution(resolution),
          .data_en(data_en[i]),
          .data_out(data_out[i])
        );
      end
  endgenerate

 //==========================================================================
 // Arrange samples in capture format
 //==========================================================================

always @(posedge adc_clk_div) begin
if((resolution == 2'b00) && (mode == 3'b100)) begin  //  8-bit quad channel
     wr_data_int <= {data_out[6][ 7:0], data_out[4][ 7:0], data_out[2][ 7:0], data_out[0][ 7:0],data_out[7][ 7:0], data_out[5][ 7:0], data_out[3][ 7:0], data_out[1][ 7:0],
                     data_out[6][15:8], data_out[4][15:8], data_out[2][15:8], data_out[0][15:8],data_out[7][15:8], data_out[5][15:8], data_out[3][15:8], data_out[1][15:8]};
  end else if((resolution == 2'b00) && (mode == 3'b010)) begin  //  8-bit dual channel
     wr_data_int <= {data_out[7][ 7:0], data_out[3][ 7:0], data_out[6][ 7:0], data_out[2][ 7:0], data_out[5][ 7:0], data_out[1][ 7:0], data_out[4][ 7:0], data_out[0][ 7:0],
                     data_out[7][15:8], data_out[3][15:8], data_out[6][15:8], data_out[2][15:8], data_out[5][15:8], data_out[1][15:8], data_out[4][15:8], data_out[0][15:8]};
  end else if((resolution == 2'b00) && (mode == 3'b001)) begin  //  8-bit single channel
     wr_data_int <= {data_out[7][ 7:0], data_out[6][ 7:0], data_out[5][ 7:0], data_out[4][ 7:0],
                     data_out[3][ 7:0], data_out[2][ 7:0], data_out[1][ 7:0], data_out[0][ 7:0],
                     data_out[7][15:8], data_out[6][15:8], data_out[5][15:8], data_out[4][15:8],
                     data_out[3][15:8], data_out[2][15:8], data_out[1][15:8], data_out[0][15:8]};
  end
end

reg               wr_en8_reg;
reg               wr_en14_reg;
reg  [127:0]      wr_data14_reg;
reg               wr_en_reg;
reg  [127:0]      wr_data_int;
reg  [127:0]      wr_data_reg;

 always @(posedge adc_clk_div) begin
    if(adc_rst) begin
       wr_en8_reg    <= 1'b0;
       wr_en14_reg   <= 1'b0;
       wr_data14_reg <= 128'b0;
    end else if(data_en[0]) begin
       wr_en8_reg    <= ~wr_en8_reg;
       wr_en14_reg   <= ~wr_en14_reg;
       wr_data14_reg <= {wr_data14_reg[63:0], wr_data_int[127:64]};
    end
 end

 always @(posedge adc_clk_div) begin
    wr_en_reg   <= data_en[0];
    wr_data_reg <= wr_data_int;
 end

 assign wr_clk      = adc_clk_div;
 assign adc_valid   = (resolution == 2'b00) ? wr_en8_reg  : (resolution != 2'b11) ? wr_en_reg : (wr_en14_reg && data_en[0]);
 assign adc_data    = (resolution != 2'b11) ? wr_data_reg :  wr_data14_reg;

endmodule
