// ***************************************************************************
// ***************************************************************************
// Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
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

// Generic parallel PN generator

module ad_pngen #(

  // PN7 x^7 + x^6 + 1
  parameter POL_MASK = 32'b0000_0000_0000_0000_0000_0000_1100_0000,
  parameter POL_W = 7,

  // Number of output bits at every clock cycle
  parameter DW = 16
) (
  input           clk,
  input           reset,
  input           clk_en,

  // Output stream
  output [DW-1:0] pn_data_out,  // MSB has the oldest value,
                                // LSB has the latest value

  // Input stream to synchronize to (Optional)
  input           pn_init,
  input  [DW-1:0] pn_data_in

);

  /* We need at least enough bits to store the PN state */
  localparam PN_W = DW > POL_W ? DW : POL_W;

  reg [PN_W-1:0] pn_state = {PN_W{1'b1}};

  wire [DW-1:0] pn;
  wire [DW+POL_W-1:0] pn_full_state;
  wire [PN_W-1:0] pn_reset;
  wire [PN_W-1:0] pn_state_;
  wire [PN_W-1:0] pn_init_data;


  // pn init data selection
  generate if (PN_W > DW) begin
    reg [PN_W-DW-1:0] pn_data_in_d = 'd0;
    always @(posedge clk) begin
      pn_data_in_d <= {pn_data_in_d, pn_data_in};
    end
    assign pn_init_data = {pn_data_in_d, pn_data_in};
  end else begin
    assign pn_init_data = pn_data_in;
  end
  endgenerate


  // PRBS logic
  assign pn_state_ = pn_init ? pn_init_data : pn_state;
  generate
    genvar i;
    for (i = 0; i < DW; i = i + 1) begin: pn_loop
      assign pn[i] = ^(pn_full_state[i +: POL_W+1] & POL_MASK);
    end
  endgenerate
  assign pn_full_state = {pn_state_[POL_W-1 : 0],pn};

  // Reset value logic
  assign pn_reset[PN_W-1 -: POL_W] = {POL_W{1'b1}};
  generate
    genvar j;
    for (j = 0; j < PN_W-POL_W; j = j + 1) begin: pn_reset_loop
      assign pn_reset[j] = ^(pn_reset[j +: POL_W+1] & POL_MASK);
    end
  endgenerate

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      pn_state <= pn_reset;
    end else if (clk_en) begin
      pn_state <= pn_full_state[PN_W-1 : 0];
    end
  end

  assign pn_data_out = pn_state[PN_W-1 -: DW];

endmodule

