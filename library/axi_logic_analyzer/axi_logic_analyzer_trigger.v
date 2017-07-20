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

`timescale 1ns/100ps

module axi_logic_analyzer_trigger (

  input                 clk,
  input                 reset,

  input       [15:0]    data,
  input       [ 1:0]    trigger,

  input       [17:0]    edge_detect_enable,
  input       [17:0]    rise_edge_enable,
  input       [17:0]    fall_edge_enable,
  input       [17:0]    low_level_enable,
  input       [17:0]    high_level_enable,

  input                 trigger_logic,

  output                trigger_out);

  reg     [ 17:0]   data_m1 = 'd0;
  reg     [ 17:0]   low_level = 'd0;
  reg     [ 17:0]   high_level = 'd0;
  reg     [ 17:0]   edge_detect = 'd0;
  reg     [ 17:0]   rise_edge = 'd0;
  reg     [ 17:0]   fall_edge = 'd0;
  reg     [ 31:0]   delay_count = 'd0;

  reg              trigger_active;

  assign trigger_out = trigger_active;

  // trigger logic:
  // 0 OR
  // 1 AND

  always @(*) begin
    case (trigger_logic)
      0: trigger_active = | ((edge_detect & edge_detect_enable) |
                          (rise_edge & rise_edge_enable) |
                          (fall_edge & fall_edge_enable) |
                          (low_level & low_level_enable) |
                          (high_level & high_level_enable));
      1: trigger_active = | (((edge_detect & edge_detect_enable) | !(|edge_detect_enable)) &
                          ((rise_edge & rise_edge_enable) | !(|rise_edge_enable)) &
                          ((fall_edge & fall_edge_enable) | !(|fall_edge_enable)) &
                          ((low_level & low_level_enable) | !(|low_level_enable)) &
                          ((high_level & high_level_enable) | !(|high_level_enable)));
      default: trigger_active = 1'b1;
    endcase
  end

  // internal signals

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      data_m1 <= 'd0;
      edge_detect <= 'd0;
      rise_edge <= 'd0;
      fall_edge <= 'd0;
      low_level <= 'd0;
      high_level <= 'd0;
    end else begin
      data_m1 <= {trigger, data} ;
      edge_detect <= data_m1 ^ {trigger, data};
      rise_edge <= (data_m1 ^ {trigger, data} ) & {trigger, data};
      fall_edge <= (data_m1 ^ {trigger, data}) & ~{trigger, data};
      low_level <= ~{trigger, data};
      high_level <= {trigger, data};
    end
  end


endmodule

// ***************************************************************************
// ***************************************************************************
