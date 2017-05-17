// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// Each core or library found in this collection may have its own licensing terms. 
// The user should keep this in in mind while exploring these cores. 
//
// Redistribution and use in source and binary forms,
// with or without modification of this file, are permitted under the terms of either
//  (at the option of the user):
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory, or at:
// https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
//
// OR
//
//   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
// https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module util_var_fifo #(

  // parameters

  parameter DATA_WIDTH = 32,
  parameter ADDRESS_WIDTH =  13) (

  input                       clk,
  input                       rst,

  input   [31:0]              depth,

  input   [DATA_WIDTH -1:0]   data_in,
  input                       data_in_valid,

  output  [DATA_WIDTH-1:0]    data_out,
  output                      data_out_valid,

  output                      wea_w,
  output                      en_w,
  output  [ADDRESS_WIDTH-1:0] addr_w,
  output  [DATA_WIDTH-1:0]    din_w,
  output                      en_r,
  output  [ADDRESS_WIDTH-1:0] addr_r,
  input   [DATA_WIDTH-1:0]    dout_r);

  localparam      MAX_DEPTH = (2 ** ADDRESS_WIDTH) - 1;


  // internal registers

  reg [ADDRESS_WIDTH-1:0]    addra = 'd0;
  reg [ADDRESS_WIDTH-1:0]    addrb = 'd0;

  reg [31:0]            depth_d1 = 'd0;
  reg [DATA_WIDTH-1:0]  data_in_d1 = 'd0;
  reg [DATA_WIDTH-1:0]  data_in_d2 = 'd0;
  reg                   data_active = 'd0;
  reg                   fifo_active = 'd0;

  // internal signals

  wire                    reset;
  wire  [DATA_WIDTH-1:0]  data_out_s;
  wire                    data_out_valid_s;

  assign reset = ((rst == 1'b1) || (depth != depth_d1)) ? 1 : 0;

  assign data_out = fifo_active ? data_out_s : data_in_d2;
  assign data_out_valid_s = data_active & data_in_valid;
  assign data_out_valid = fifo_active ? data_out_valid_s : data_in_valid;

  assign wea_w = data_in_valid & fifo_active;
  assign en_w = fifo_active;
  assign addr_w = addra;
  assign din_w = data_in;
  assign en_r = fifo_active;
  assign addr_r = addrb;
  assign data_out_s = dout_r;

  always @(posedge clk) begin
    depth_d1 <= depth;
    if (depth == 32'h0) begin
      fifo_active <= 0;
    end else begin
      fifo_active <= 1;
    end
    if (data_in_valid == 1'b1 && fifo_active == 1'b0) begin
      data_in_d1 <= data_in;
      data_in_d2 <= data_in_d1;
    end
  end

  always @(posedge clk) begin
    if(reset == 1'b1 || fifo_active == 1'b0) begin
      addra <= 0;
      addrb <= 0;
      data_active <= 1'b0;
    end else begin
      if (data_in_valid == 1'b1) begin
        addra <= addra + 1;
        if (data_active == 1'b1) begin
          addrb <= addrb + 1;
        end
      end
      if (addra >= depth || addra > MAX_DEPTH - 2) begin
        data_active <= 1'b1;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
