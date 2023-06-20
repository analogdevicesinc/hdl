// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
// This is the LVDS/DDR interface

`timescale 1ns/100ps

module axi_pwm_custom_if #(

  // the width and period are defined in number of clock cycles
  parameter   PULSE_PERIOD = 4096
) ( 

  // physical interface
    
input            pwm_clk,
input            rstn,
input    [11:0]  data_channel_0,
input    [11:0]  data_channel_1,
input    [11:0]  data_channel_2,
input    [11:0]  data_channel_3,
output           pwm_led_0,
output           pwm_led_1,
output           pwm_led_2,
output           pwm_led_3
);

// internal registers

reg     [11:0]  pulse_period_cnt = 12'h0;
reg             phase_align_armed = 1'b1;
reg     [11:0]  pulse_period_d = PULSE_PERIOD;
reg     [11:0]  data_channel_0_d = 12'b0;
reg     [11:0]  data_channel_1_d = 12'b0;
reg     [11:0]  data_channel_2_d = 12'b0;
reg     [11:0]  data_channel_3_d = 12'b0;  
reg             pwm_led_0_s = 1'b0;
reg             pwm_led_1_s = 1'b0;
reg             pwm_led_2_s = 1'b0;
reg             pwm_led_3_s = 1'b0;

// internal wires

wire           end_of_period;  
assign pwm_led_0 = pwm_led_0_s; 
assign pwm_led_1 = pwm_led_1_s;
assign pwm_led_2 = pwm_led_2_s;
assign pwm_led_3 = pwm_led_3_s;
 

// Counter

always @(posedge pwm_clk) begin
  if (rstn == 1'b0 || end_of_period == 1'b1) begin
    pulse_period_cnt <= 12'd1;
  end else begin
    pulse_period_cnt <= pulse_period_cnt + 1'b1;
    
  end
end

assign end_of_period = (pulse_period_cnt == pulse_period_d) ? 1'b1 : 1'b0;

// PWM Generator

always @(posedge pwm_clk) begin
  
  if (data_channel_0 > pulse_period_cnt)
    pwm_led_0_s <= 1'b1;
  else  
    pwm_led_0_s <= 1'b0;  
  if (data_channel_1 > pulse_period_cnt)
    pwm_led_1_s <= 1'b1;
  else  
    pwm_led_1_s <= 1'b0;
  if (data_channel_2 > pulse_period_cnt)
    pwm_led_2_s <= 1'b1;
  else  
    pwm_led_2_s <= 1'b0;
  if (data_channel_3 > pulse_period_cnt)
    pwm_led_3_s <= 1'b1;
  else  
    pwm_led_3_s <= 1'b0;        

end  

always @(posedge pwm_clk) begin


  if (end_of_period) begin
    data_channel_0_d <= data_channel_0;
    data_channel_1_d <= data_channel_1;
    data_channel_2_d <= data_channel_2;
    data_channel_3_d <= data_channel_3;
  end else begin
    data_channel_0_d <= data_channel_0_d;
    data_channel_1_d <= data_channel_1_d;
    data_channel_2_d <= data_channel_2_d;
    data_channel_3_d <= data_channel_3_d;
  end 


end
endmodule