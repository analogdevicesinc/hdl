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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad3552r_if #(

  parameter   ID = 0
) (

  input                   clk_in,  // 120MHz
  input                   reset_in,
  input       [31:0]      dac_data,
  input                   dac_data_valid,
  input       [7:0]       input_data_select,

  input       [ 7:0]      address,
  input                   sdr_ddr_n,
  input                   write_start,
  input                   write_stop,

  // DAC control signals
  output                  dac_data_ready,
  output                  sclk,
  output                  csn,
  output                  sdio_0,
  output                  sdio_1,
  output                  sdio_2,
  output                  sdio_3
);

  
  wire         start_transfer;

  wire [47:0]  transfer_data_0;
  wire [47:0]  transfer_data_1;
  wire [47:0]  transfer_data_2;
  wire [47:0]  transfer_data_3;

  wire [47:0]  sdr_transfer_data_0;
  wire [47:0]  sdr_transfer_data_1;
  wire [47:0]  sdr_transfer_data_2;
  wire [47:0]  sdr_transfer_data_3;

  wire [7:0]   ddr_transfer_data_0;
  wire [7:0]   ddr_transfer_data_1;
  wire [7:0]   ddr_transfer_data_2;
  wire [7:0]   ddr_transfer_data_3;
  wire [3:0]   clk_cnt_value;
  wire         sclk_int;
  wire [15:0]  data_in;
  wire         cnt_enable_s;
  wire         end_transfer;
  wire         valid_in_int;
  wire         sdio_0_int;
  wire         sdio_1_int;
  wire         sdio_2_int;
  wire         sdio_3_int;
  wire         dac_data_valid_int;
  wire [ 5:0]  cnt_value;

  reg          csn_int='d1;
  reg          write_start_d = 'd0;
  reg          write_start_dd = 'd0;
  reg          write_stop_d  = 'd0;
  reg          write_stop_dd = 'd0;
  reg  [ 5:0]  cnt_p = 'd0;
  reg          address_sent = 1'b0;
  reg          end_transfer_good =1'b0;
  reg          channel_sel = 1'b0;
  reg   [31:0] dac_data_int= 32'b0;
  reg   [31:0] new_dac_data = 32'b0;
  reg          dac_data_ready_int = 'b1;
  reg   [3:0]  count = 4'b0;
  reg          clk_div = 'b0;

  assign sclk   = sclk_int;
  assign csn    = csn_int;
  assign sdio_0 = sdio_0_int;
  assign sdio_1 = sdio_1_int;
  assign sdio_2 = sdio_2_int;
  assign sdio_3 = sdio_3_int;

  assign cnt_value      = ( sdr_ddr_n == 1'b1) ? ((input_data_select == 8'h33) ? ((address_sent == 1'b1) ? 'he :'h1e) : ((address_sent == 1'b1) ? 'h1f :'h2e)) :
                                                 ((address_sent == 1'b1) ? 'h3:'h7) ;
  assign cnt_enable_s   = (cnt_p < cnt_value) ? 1'b1 : 1'b0;
  assign start_transfer = write_start_d & ~write_start_dd;
  assign end_transfer   = write_stop_d & ~write_stop_dd;
  assign valid_in_int   = (cnt_p == cnt_value) ? 1'b1 : 1'b0 ;
  assign data_in        = (channel_sel == 1'b0 ) ? new_dac_data[15:0] : new_dac_data[31:16];

  assign dac_data_ready = dac_data_ready_int;

  always @(negedge clk_in) begin
    if(reset_in == 1'b1) begin 
      write_start_d  <= 'd0;
      write_start_dd <= 'd0;
      write_stop_d   <= 'd0;
      write_stop_dd  <= 'd0;
    end else begin 
      write_start_d  <= write_start;
      write_start_dd <= write_start_d;
      write_stop_d   <= write_stop;
      write_stop_dd  <= write_stop_d;
    end
  end

  always @(posedge clk_in) begin
    if(reset_in == 1'b1) begin 
      csn_int  <= 'd1;
    end else if (start_transfer == 1'b1 || (end_transfer_good == 1'b1 && valid_in_int == 1'b1) ) begin
    csn_int <= ~csn_int;
   end else begin
    csn_int <= csn_int;
   end
  end

  // counter for 1 command

  always @(negedge clk_in) begin
    if ( start_transfer || valid_in_int == 1'b1 || cnt_enable_s == 1'b0 || reset_in == 1'b1 ) begin
      cnt_p <= 'h0;
    end else if (cnt_enable_s == 1'b1 && csn_int == 1'b0) begin
      cnt_p <= cnt_p + 1'b1;
    end

    if (cnt_p == cnt_value) begin
     address_sent <= 1'b1;
    end

    if (end_transfer == 1'b1) begin
      end_transfer_good <= 1'b1;
    end

    if (csn_int == 1'b1 || reset_in == 1'b1 ) begin
     end_transfer_good <= 1'b0;
     address_sent <= 1'b0;
    end
    if(csn_int == 1'b1 || reset_in == 1'b1) begin
      channel_sel <= 1'b0;
    end else if( valid_in_int == 1'b1) begin
      channel_sel <= ~channel_sel;
    end 


    if(reset_in == 1'b1) begin 
      new_dac_data <= 'd0;
    end else if( valid_in_int == 1'b1 || address_sent ==1'b0 ) begin
      new_dac_data <= dac_data_int;
    end else begin
      new_dac_data <= new_dac_data;
    end
  end

  assign sdr_transfer_data_0 = (address_sent == 1'b0) ? {{8{data_in[0]}},{8{data_in[4]}},{8{data_in[8]}},{8{data_in[12]}},{8{address[0]}},{8{address[4]}}}:
                                                        {16'b0,{8{data_in[0]}},{8{data_in[4]}},{8{data_in[8]}},{8{data_in[12]}}};

  assign sdr_transfer_data_1 = (address_sent == 1'b0) ? {{8{data_in[1]}},{8{data_in[5]}},{8{data_in[9]}},{8{data_in[13]}},{8{address[1]}},{8{address[5]}}}:
                                                        {16'b0,{8{data_in[1]}},{8{data_in[5]}},{8{data_in[9]}},{8{data_in[13]}}};

  assign sdr_transfer_data_2 = (address_sent == 1'b0) ? {{8{data_in[2]}},{8{data_in[6]}},{8{data_in[10]}},{8{data_in[14]}},{8{address[2]}},{8{address[6]}}}:
                                                        {16'b0,{8{data_in[2]}},{8{data_in[6]}},{8{data_in[10]}},{8{data_in[14]}}};

  assign sdr_transfer_data_3 = (address_sent == 1'b0) ? {{8{data_in[3]}},{8{data_in[7]}},{8{data_in[11]}},{8{data_in[15]}},{8{address[3]}},{8{address[7]}}}:
                                                        {16'b0,{8{data_in[3]}},{8{data_in[7]}},{8{data_in[11]}},{8{data_in[15]}}};

  assign ddr_transfer_data_0 = (address_sent == 1'b0) ? {data_in[0],data_in[4],data_in[8],data_in[12],{2{address[0]}},{2{address[4]}}}:
                                                        {4'b0,data_in[0],data_in[4],data_in[8],data_in[12]};

  assign ddr_transfer_data_1 = (address_sent == 1'b0) ? {data_in[1],data_in[5],data_in[9],data_in[13],{2{address[1]}},{2{address[5]}}}:
                                                        {4'b0,data_in[1],data_in[5],data_in[9],data_in[13]};

  assign ddr_transfer_data_2 = (address_sent == 1'b0) ? {data_in[2],data_in[6],data_in[10],data_in[14],{2{address[2]}},{2{address[6]}}}:
                                                        {4'b0,data_in[2],data_in[6],data_in[10],data_in[14]};

  assign ddr_transfer_data_3 = (address_sent == 1'b0) ? {data_in[3],data_in[7],data_in[11],data_in[15],{2{address[3]}},{2{address[7]}}}:
                                                        {4'b0,data_in[3],data_in[7],data_in[11],data_in[15]};

  assign transfer_data_0 = (sdr_ddr_n == 1'b1) ?  sdr_transfer_data_0 : {40'b0,ddr_transfer_data_0};
  assign transfer_data_1 = (sdr_ddr_n == 1'b1) ?  sdr_transfer_data_1 : {40'b0,ddr_transfer_data_1};
  assign transfer_data_2 = (sdr_ddr_n == 1'b1) ?  sdr_transfer_data_2 : {40'b0,ddr_transfer_data_2};
  assign transfer_data_3 = (sdr_ddr_n == 1'b1) ?  sdr_transfer_data_3 : {40'b0,ddr_transfer_data_3};

  assign sdio_0_int =(csn_int == 1'b0) ?  transfer_data_0[cnt_p] : 1'b0;
  assign sdio_1_int =(csn_int == 1'b0) ?  transfer_data_1[cnt_p] : 1'b0;
  assign sdio_2_int =(csn_int == 1'b0) ?  transfer_data_2[cnt_p] : 1'b0;
  assign sdio_3_int =(csn_int == 1'b0) ?  transfer_data_3[cnt_p] : 1'b0;

  assign dac_data_valid_int = (dac_data_valid == 1'b1 && (input_data_select == 8'h33 || input_data_select == 8'h88 || input_data_select == 8'hbb)) ||
                              (dac_data_valid == 1'b1 &&  input_data_select == 8'h22 &&  dac_data_ready_int == 1'b1) ? 1'b1 : 1'b0;

  always @(negedge clk_in) begin
    if(reset_in == 1'b1) begin 
      dac_data_int <= 'd0;
    end else if( dac_data_valid_int == 1'b1) begin
      dac_data_int <= dac_data;
    end else begin
      dac_data_int <= dac_data_int;
    end
  end

  assign clk_cnt_value = (sdr_ddr_n == 1'b1) ? 4'h3 : 4'h0;
  assign sclk_int   = (csn_int == 1'b0) ? clk_div : 1'b0;

  always @ (posedge clk_in) begin
    if (csn_int == 1'b1 || count == clk_cnt_value || reset_in == 1'b1 ) begin
      count <= 4'b0;
      clk_div <= 1'b0;
    end else if (count < clk_cnt_value) begin
      count <= count + 1'b1;
    end
    if (count == clk_cnt_value) begin
      clk_div <= ~clk_div;
    end
  end

reg [2:0] cnt_valid = 'b0;

always @ (posedge clk_in) begin
  
  if(valid_in_int == 1'b1) begin
    cnt_valid <= cnt_valid+1;
  end else if (cnt_valid == 2'd2 || reset_in == 1'b1) begin 
    cnt_valid <= 3'b0;
    dac_data_ready_int <= 1'b1;
  end else begin
    dac_data_ready_int <= 1'b0;
  end
end
endmodule
