// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//    
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module up_xfer_status (

  // up interface

  up_rstn,
  up_clk,
  up_data_status,

  // device interface

  d_rst,
  d_clk,
  d_data_status);

  // parameters

  parameter     DATA_WIDTH = 8;
  localparam    DW = DATA_WIDTH - 1;

  // up interface

  input           up_rstn;
  input           up_clk;
  output  [DW:0]  up_data_status;

  // device interface

  input           d_rst;
  input           d_clk;
  input   [DW:0]  d_data_status;

  // internal registers

  reg             d_xfer_state_m1 = 'd0;
  reg             d_xfer_state_m2 = 'd0;
  reg             d_xfer_state = 'd0;
  reg     [ 5:0]  d_xfer_count = 'd0;
  reg             d_xfer_toggle = 'd0;
  reg     [DW:0]  d_xfer_data = 'd0;
  reg     [DW:0]  d_acc_data = 'd0;
  reg             up_xfer_toggle_m1 = 'd0;
  reg             up_xfer_toggle_m2 = 'd0;
  reg             up_xfer_toggle_m3 = 'd0;
  reg             up_xfer_toggle = 'd0;
  reg     [DW:0]  up_data_status = 'd0;

  // internal signals

  wire            d_xfer_enable_s;
  wire            up_xfer_toggle_s;

  // device status transfer

  assign d_xfer_enable_s = d_xfer_state ^ d_xfer_toggle;

  always @(posedge d_clk) begin
    if (d_rst == 1'b1) begin
      d_xfer_state_m1 <= 'd0;
      d_xfer_state_m2 <= 'd0;
      d_xfer_state <= 'd0;
      d_xfer_count <= 'd0;
      d_xfer_toggle <= 'd0;
      d_xfer_data <= 'd0;
      d_acc_data <= 'd0;
    end else begin
      d_xfer_state_m1 <= up_xfer_toggle;
      d_xfer_state_m2 <= d_xfer_state_m1;
      d_xfer_state <= d_xfer_state_m2;
      d_xfer_count <= d_xfer_count + 1'd1;
      if ((d_xfer_count == 6'd1) && (d_xfer_enable_s == 1'b0)) begin
        d_xfer_toggle <= ~d_xfer_toggle;
        d_xfer_data <= d_acc_data;
      end
      if ((d_xfer_count == 6'd1) && (d_xfer_enable_s == 1'b0)) begin
        d_acc_data <= d_data_status;
      end else begin
        d_acc_data <= d_acc_data | d_data_status;
      end
    end
  end

  assign up_xfer_toggle_s = up_xfer_toggle_m3 ^ up_xfer_toggle_m2;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_xfer_toggle_m1 <= 'd0;
      up_xfer_toggle_m2 <= 'd0;
      up_xfer_toggle_m3 <= 'd0;
      up_xfer_toggle <= 'd0;
      up_data_status <= 'd0;
    end else begin
      up_xfer_toggle_m1 <= d_xfer_toggle;
      up_xfer_toggle_m2 <= up_xfer_toggle_m1;
      up_xfer_toggle_m3 <= up_xfer_toggle_m2;
      up_xfer_toggle <= up_xfer_toggle_m3;
      if (up_xfer_toggle_s == 1'b1) begin
        up_data_status <= d_xfer_data;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
