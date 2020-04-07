// ***************************************************************************
// ***************************************************************************
// Copyright 2020 (c) Analog Devices, Inc. All rights reserved.
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
// This is the LVDS/DDR interface, note that overrange is independent of data path,
// software will not be able to relate overrange to a specific sample!

`timescale 1ns/100ps

module axi_ltc2387_if #(

  parameter   FPGA_TECHNOLOGY = 0,
  parameter   IO_DELAY_GROUP = "adc_if_delay_group",
  parameter   DELAY_REFCLK_FREQUENCY = 200,
  parameter   TWOLANES = 0,       // 0 for Single Lane, 1 for Two Lanes
  parameter   RESOLUTION = 16,    // 16 or 18 bits
  parameter   TCLKDCO = 2.3) (

  // adc interface
  
  input                   dco_p,
  input                   dco_n,
  input                   adc_da_in_p,
  input                   adc_da_in_n,
  input                   adc_db_in_p,
  input                   adc_db_in_n,
  output                  cnv_p,
  output                  cnv_n,
  
  // interface outputs

  output                  adc_clk,
  output  reg [31:0]      adc_data,
  output  reg             adc_status,

  // delay control signals

  input                   up_clk,
  input       [ 8:0]      up_dld,
  input       [44:0]      up_dwdata,
  output      [44:0]      up_drdata,
  input                   delay_clk,
  input                   delay_rst,
  output                  delay_locked);
  
  // local wires and registers
  
  reg                     clk_p = 1'b0;
  reg                     cnv = 1'b0;
  reg                     dco = 1'b0;
  reg                     last_dco;
  reg         [3:0]       num_dco = (RESOLUTION == 18)?(TWOLANES == 0)?'h9:'h5:(TWOLANES == 0)?'h8:'h4; 
  reg                     dco_en;
  reg         [4:0]       adc_clk_cnt = 5'd0;
  reg                     two_lanes = TWOLANES;
  reg                     sync_pulse;
  reg  [RESOLUTION-1:0]   dac_data_s = 'b0;
  reg  [RESOLUTION-1:0]   adc_s_data = 'b0;   
  reg  [RESOLUTION-1:0]   data_r ='b0; 
  reg  [RESOLUTION+1:0]   adc_data_d ='b0;
 
  // internal registers

  reg         [8:0]       adc_data_p = 'd0;
  reg         [8:0]       adc_data_n = 'd0;

  // internal signals

  wire        [8:0]       adc_data_p_s;
  wire        [8:0]       adc_data_n_s;
  wire        [1:0]       rx_data_a_s;                                                      
  wire        [1:0]       rx_data_b_s;

  always @ (posedge adc_clk)    begin

    
  end

  always @(posedge adc_clk) begin                                                   
    if (adc_clk_cnt < RESOLUTION-1 )                                                    
      begin                                                                        
        adc_clk_cnt <= adc_clk_cnt + 1;     
        cnv <= 1'b0;                                             
      end else begin                                                                   
        adc_clk_cnt <= 4'd0 ;      
        cnv <= 1'b1;                                             
      end                                                                          
  end 

  always @(posedge adc_clk) begin 
    if (adc_clk_cnt < num_dco) begin
      dco_en <= 1'b1;
    end else begin
      dco_en <= 1'b0;                                                    
    end                          
  end  
 
  always @(posedge adc_clk) begin
    if (adc_clk_cnt == num_dco + 1) begin
      last_dco <= 1'b1;
    end else begin
      last_dco <= 1'b0;
    end
  end

  always @(posedge adc_clk or negedge adc_clk) begin     
    if (dco_en == 1) begin
      clk_p = ~clk_p;  
      #TCLKDCO dco = clk_p;                          
    end else begin
      clk_p = 1'b0;
      #TCLKDCO dco = clk_p;  
    end
  end

  always @(posedge adc_clk) begin
    if (last_dco == 1) begin
      adc_data_d <= 18'b0;
      adc_s_data <= 18'b0;
      data_r <= 18'b0;
    end
  end

 // always @(posedge cnv) begin                                                 
 //   dac_s_data <= input_signal;  
 // end

  always @(posedge dco) begin   
    if (two_lanes == 0) begin                                               
      dac_s_data <= dac_s_data << 2;  
    end else begin                                                          
      dac_s_data <= dac_s_data << 4;                                        
    end                             
  end

  assign  rx_data_a_s[1] = two_lanes ? dac_s_data[RESOLUTION-1] : dac_s_data[RESOLUTION-1];
  assign  rx_data_b_s[1] = two_lanes ? dac_s_data[RESOLUTION-2] : 1'b0;
  assign  rx_data_a_s[0] = two_lanes ? dac_s_data[RESOLUTION-3] : dac_s_data[RESOLUTION-2];
  assign  rx_data_b_s[0] = two_lanes ? dac_s_data[RESOLUTION-4] : 1'b0;

  always @(posedge dco) begin
    if (two_lanes == 0) begin
      adc_data_d <= (adc_data_d << 2) | {{(RESOLUTION-2){1'b0}}, rx_data_a_s[1], rx_data_a_s[0]};
    end else begin
      adc_data_d <= (adc_data_d << 4) | {{(RESOLUTION-4){1'b0}}, rx_data_a_s[1], rx_data_b_s[1], rx_data_a_s[0], rx_data_b_s[0]};
    end
  end

  always @(posedge last_dco) begin
    if (two_lanes == 0) begin
      adc_data <= adc_data_d[RESOLUTION-1:0];
    end else begin
      if (RESOLUTION == 16) begin
        adc_data = adc_data_d[RESOLUTION-1:0];
      end else begin
        adc_data = adc_data_d[RESOLUTION+1:2];
      end
    end
  end

  // data interface

  generate
  ad_data_in #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .IODELAY_CTRL (0),
    .IODELAY_GROUP (IO_DELAY_GROUP),
    .REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY))
  i_adc_data_a (
    .rx_clk (adc_clk),
    .rx_data_in_p (adc_da_in_p),
    .rx_data_in_n (adc_da_in_n),
    .rx_data_p (adc_data_p_s),
    .rx_data_n (adc_data_n_s),
    .up_clk (up_clk),
    .up_dld (up_dld),
    .up_dwdata (up_dwdata),
    .up_drdata (up_drdata),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked ());
   endgenerate

  generate
  ad_data_in #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .IODELAY_CTRL (0),
    .IODELAY_GROUP (IO_DELAY_GROUP),
    .REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY))
  i_adc_data_b (
    .rx_clk (adc_clk),
    .rx_data_in_p (adc_db_in_p),
    .rx_data_in_n (adc_db_in_n),
    .rx_data_p (adc_data_p_s),
    .rx_data_n (adc_data_n_s),
    .up_clk (up_clk),
    .up_dld (up_dld),
    .up_dwdata (up_dwdata),
    .up_drdata (up_drdata),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked ());
   endgenerate


  // clock

  ad_data_clk
  i_adc_clk (
    .rst (1'b0),
    .locked (),
    .clk_in_p (adc_clk_in_p),
    .clk_in_n (adc_clk_in_n),
    .clk (adc_clk));

endmodule

// ***************************************************************************
// ***************************************************************************
