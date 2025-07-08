// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

module axi_fsrc_tx_regmap #(
  parameter ID = 0,
  parameter [31:0] CORE_VERSION = 0,
  parameter [31:0] CORE_MAGIC = 0,
  parameter ACCUM_WIDTH = 64,
  parameter NUM_SAMPLES = 16
) (
  input         clk,
  input         reset,
  output        enable,
  output        ext_trig_en,
  output        start,
  output        stop,
  output        change_rate,
  output        accum_set,
  output reg [15:0] conv_mask,
  output [ACCUM_WIDTH-1:0] accum_add_val,
  output reg [NUM_SAMPLES-1:0][ACCUM_WIDTH-1:0] accum_set_val,

  // debug interface
  input [31:0]   debug_flags,

  // axi interface
  input                   up_rstn,
  input                   up_clk,
  input                   up_wreq,
  input       [13:0]      up_waddr,
  input       [31:0]      up_wdata,
  output reg              up_wack,
  input                   up_rreq,
  input       [13:0]      up_raddr,
  output reg  [31:0]      up_rdata,
  output reg              up_rack
);

  wire stop_s;
  wire start_s;
  wire change_rate_s;
  wire accum_set_s;
  wire [31:0] debug_flags_s;
  wire [ACCUM_WIDTH-1:0] accum_set_val_s;

  reg stop_reg;
  reg start_reg;
  reg change_rate_reg;
  reg accum_set_reg;

  // internal registers
  reg [31:0] scratch_reg;
  reg [31:0] enable_reg;
  reg [31:0] ctrl_transmit_reg;
  reg [31:0] accum_add_val_0_reg;
  reg [31:0] accum_add_val_1_reg;
  reg  [3:0] accum_set_val_addr_reg;
  reg        accum_set_val_apply_reg;
  reg [31:0] accum_set_val_0_reg;
  reg [31:0] accum_set_val_1_reg;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      scratch_reg <= 'd0;
      enable_reg <= 'd0;
      ctrl_transmit_reg <= 'd0;
      conv_mask <= 'd0;
      accum_add_val_0_reg <= 'd0;
      accum_add_val_1_reg <= 'd0;
      accum_set_val_addr_reg <= 'd0;
      accum_set_val_apply_reg <= 1'b0;
      accum_set_val_0_reg <= 'd0;
      accum_set_val_1_reg <= 'd0;
    end else begin
      up_wack <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr == 14'h2)) begin
        scratch_reg <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h4)) begin
        enable_reg <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h5)) begin
        ctrl_transmit_reg <= up_wdata;
      end else begin
        ctrl_transmit_reg <= 'd0;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h6)) begin
       conv_mask <= up_wdata[15:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h7)) begin
        accum_add_val_0_reg <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h8)) begin
        accum_add_val_1_reg <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h9)) begin
        accum_set_val_addr_reg <= up_wdata[3:0];
        accum_set_val_apply_reg <= 1'b1;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'ha)) begin
        accum_set_val_0_reg <= up_wdata;
        accum_set_val_apply_reg <= 1'b0;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'hb)) begin
        accum_set_val_1_reg <= up_wdata;
        accum_set_val_apply_reg <= 1'b0;
      end
    end
  end

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq;
      if (up_rreq == 1'b1) begin
        case (up_raddr)
          14'h0:   up_rdata <= CORE_VERSION;
          14'h1:   up_rdata <= ID;
          14'h2:   up_rdata <= scratch_reg;
          14'h3:   up_rdata <= CORE_MAGIC;
          14'h4:   up_rdata <= enable_reg;
          14'h5:   up_rdata <= ctrl_transmit_reg;
          14'h6:   up_rdata <= conv_mask;
          14'h7:   up_rdata <= accum_add_val_0_reg;
          14'h8:   up_rdata <= accum_add_val_1_reg;
          14'h9:   up_rdata <= {28'b0, accum_set_val_addr_reg};
          14'ha:   up_rdata <= accum_set_val_0_reg;
          14'hb:   up_rdata <= accum_set_val_1_reg;
          14'hc:   up_rdata <= ACCUM_WIDTH;
          14'hd:   up_rdata <= debug_flags_s;
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  sync_bits #(
    .NUM_OF_BITS (32),
    .ASYNC_CLK (1)
  ) debug_flags_sync (
    .in_bits(debug_flags),
    .out_resetn (~reset),
    .out_clk(up_clk),
    .out_bits(debug_flags_s));

  genvar j;
  for (j=0; j < NUM_SAMPLES; j=j+1) begin : set_val_gen
    always @(posedge clk) begin
      // Write value first then address to apply
      if (j == accum_set_val_addr_reg && accum_set_val_apply_reg) begin
        accum_set_val[j] <= accum_set_val_s;
      end
    end
  end

  always @(posedge clk) begin
    change_rate_reg <= change_rate_s;
    accum_set_reg <= accum_set_s;
    start_reg <= start_s;
    stop_reg <= stop_s;
  end

  assign enable        = enable_reg[0];
  assign ext_trig_en   = enable_reg[1];
  assign start_s       = ctrl_transmit_reg[0];
  assign stop_s        = ctrl_transmit_reg[1];
  assign accum_set_s   = ctrl_transmit_reg[2];
  assign change_rate_s = ctrl_transmit_reg[3];
  assign accum_add_val = {accum_add_val_1_reg, accum_add_val_0_reg};
  assign accum_set_val_s = {accum_set_val_1_reg, accum_set_val_0_reg};

  assign change_rate = change_rate_s && ~change_rate_reg; // should go to apollo?
  assign accum_set = accum_set_s && ~accum_set_reg;
  assign start = start_s && ~start_reg;
  assign stop = stop_s && ~stop_reg;

endmodule