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
// Input must be RGB or CrYCb in that order, output is CrY/CbY

`timescale 1ns/100ps

module yuv422torgb_upscale (

  // 422 inputs

  input               clk,
  input               s422_sync,
  input       [15:0]  s422_data,

  // 444 outputs

  output              s444_sync,
  output      [23:0]  s444_data
);
  // internal regs

assign s444_data = {u_out_value,y_out_value,v_out_value};
assign s444_sync = (first_cycle == 1'b0) ? 1'b0 : s422_sync_2d;
  reg    [31:0]  u_v_value;
  reg    [31:0]  y_value;
  
  reg    [ 7:0]  u_out_value;
  reg    [ 7:0]  v_out_value;
  reg    [ 7:0]  y_out_value;


  // Input format is
  // [15:8] Cb/Cr
  // [ 7:0] Y
  //
  // Output format is
  // [23:15] Cr
  // [16: 8] Y
  // [ 7: 0] Cb

 
  always @(posedge clk) begin
    if(s422_sync == 1'b1) begin
      u_v_value <= {u_v_value,s422_data[15:8]};
      y_value   <= {y_value  ,s422_data[ 7:0]};
    end
  end

  reg [1:0] counter = 'd0;
  reg       first_cycle = 'b0;
  wire count_enable;
  assign count_enable = (counter == 2'd3) ? 1'b0 : 1'b1;
 
  always @(posedge clk) begin
    if(s422_sync == 1'b1 && count_enable == 1'b1) begin
      counter <= counter + 2'd1;
    end
    if(s422_sync == 1'b1 && count_enable == 1'b0) begin
      counter <= 2'b0;
    end
    if(s422_sync == 1'b1 && count_enable == 1'b0 && first_cycle == 1'b0) begin
      first_cycle <= 1'b1;
    end
  end
  reg s422_sync_d;
  reg s422_sync_2d; 

  always @(posedge clk) begin
    s422_sync_d <= s422_sync;
    s422_sync_2d <= s422_sync_d;
    if(s422_sync_d == 1'b1 && first_cycle == 1'b1) begin
      case(counter)
      2'd0 :  
      begin
        v_out_value <= u_v_value[31:24];	
        u_out_value <= u_v_value[23:16];
        y_out_value <= y_value[31:24];	
      end
      2'd1 :  
      begin
        v_out_value <= v_out_value;	
        u_out_value <= u_out_value;	
        y_out_value <= y_value[31:24];	
      end
      2'd2 :  
      begin
        v_out_value <= u_v_value[31:24];	
        u_out_value <= u_v_value[23:16];
        y_out_value <= y_value[31:24];	
      end
      2'd3 :  
      begin
        v_out_value <= v_out_value;	
        u_out_value <= u_out_value;	
        y_out_value <= y_value[31:24];	
      end
      default  :
      begin
        u_out_value <= 8'b0;	
        v_out_value <= 8'b0;	
        y_out_value <= 8'b0;	
      end 
    endcase
    end

  end





endmodule
