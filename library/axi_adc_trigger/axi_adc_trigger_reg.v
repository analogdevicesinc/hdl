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

`timescale 1ns/100ps

module axi_adc_trigger_reg (

  input               clk,

  output reg  [ 1:0]  io_selection,
  output reg  [ 1:0]  trigger_o,
  input               triggered,

  output      [ 1:0]  low_level,
  output      [ 1:0]  high_level,
  output      [ 1:0]  any_edge,
  output      [ 1:0]  rise_edge,
  output      [ 1:0]  fall_edge,

  output      [15:0]  limit_a,
  output      [ 1:0]  function_a,
  output      [31:0]  hysteresis_a,
  output      [ 3:0]  trigger_l_mix_a,

  output      [15:0]  limit_b,
  output      [ 1:0]  function_b,
  output      [31:0]  hysteresis_b,
  output      [ 3:0]  trigger_l_mix_b,

  output      [ 2:0]  trigger_out_mix,
  output      [31:0]  fifo_depth,
  output      [31:0]  trigger_delay,
  output              streaming,

 // bus interface

  input               up_rstn,
  input               up_clk,
  input               up_wreq,
  input       [ 4:0]  up_waddr,
  input       [31:0]  up_wdata,
  output reg          up_wack,
  input               up_rreq,
  input       [ 4:0]  up_raddr,
  output reg  [31:0]  up_rdata,
  output reg          up_rack);

  // internal signals

  wire    [ 9:0]  config_trigger;

  // internal registers

  reg     [31:0]  up_version = 32'h00010000;
  reg     [31:0]  up_scratch = 32'h0;
  reg     [ 9:0]  up_config_trigger = 10'h0;
  reg     [15:0]  up_limit_a = 16'h0;
  reg     [ 1:0]  up_function_a = 2'h0;
  reg     [31:0]  up_hysteresis_a = 32'h0;
  reg     [ 3:0]  up_trigger_l_mix_a = 32'h0;
  reg     [15:0]  up_limit_b = 16'h0;
  reg     [ 1:0]  up_function_b = 2'h0;
  reg     [31:0]  up_hysteresis_b = 32'h0;
  reg     [ 3:0]  up_trigger_l_mix_b = 32'h0;
  reg     [ 2:0]  up_trigger_out_mix = 32'h0;
  reg     [31:0]  up_fifo_depth = 32'h0;
  reg     [31:0]  up_trigger_delay = 32'h0;
  reg             up_triggered = 1'h0;
  reg             up_streaming = 1'h0;

  assign low_level  = config_trigger[1:0];
  assign high_level = config_trigger[3:2];
  assign any_edge   = config_trigger[5:4];
  assign rise_edge  = config_trigger[7:6];
  assign fall_edge  = config_trigger[9:8];

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_scratch <= 'd0;
      io_selection <= 'd3;
      trigger_o <= 'd0;
      up_config_trigger <= 'd0;
      up_limit_a <= 'd0;
      up_function_a <= 'd0;
      up_hysteresis_a <= 'd0;
      up_limit_b <= 'd0;
      up_function_b <= 'd0;
      up_hysteresis_b <= 'd0;
      up_fifo_depth <= 'd0;
      up_trigger_delay <= 'd0;
      up_trigger_l_mix_a <= 'd0;
      up_trigger_l_mix_b <= 'd0;
      up_trigger_out_mix <= 'd0;
      up_triggered <= 1'd0;
      up_streaming <= 1'd0;
    end else begin
      up_wack <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h1)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h2)) begin
        trigger_o <= up_wdata[1:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h3)) begin
        io_selection <= up_wdata[1:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h4)) begin
        up_config_trigger <= up_wdata[9:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h5)) begin
        up_limit_a <= up_wdata[15:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h6)) begin
        up_function_a <= up_wdata[1:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h7)) begin
        up_hysteresis_a <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h8)) begin
        up_trigger_l_mix_a <= up_wdata[3:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h9)) begin
        up_limit_b <= up_wdata[15:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'ha)) begin
        up_function_b <= up_wdata[1:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'hb)) begin
        up_hysteresis_b <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'hc)) begin
        up_trigger_l_mix_b <= up_wdata[3:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'hd)) begin
        up_trigger_out_mix <= up_wdata[2:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'he)) begin
        up_fifo_depth <= up_wdata;
      end
      if (triggered == 1'b1) begin
        up_triggered <= 1'b1;
      end else if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'hf)) begin
        up_triggered <= up_triggered & ~up_wdata[0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h10)) begin
        up_trigger_delay <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h11)) begin
        up_streaming <= up_wdata[0];
      end
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq;
      if (up_rreq == 1'b1) begin
        case (up_raddr[4:0])
          5'h0: up_rdata <= up_version;
          5'h1: up_rdata <= up_scratch;
          5'h2: up_rdata <= {30'h0,trigger_o};
          5'h3: up_rdata <= {30'h0,io_selection};
          5'h4: up_rdata <= {22'h0,up_config_trigger};
          5'h5: up_rdata <= {16'h0,up_limit_a};
          5'h6: up_rdata <= {30'h0,up_function_a};
          5'h7: up_rdata <= up_hysteresis_a;
          5'h8: up_rdata <= {28'h0,up_trigger_l_mix_a};
          5'h9: up_rdata <= {16'h0,up_limit_b};
          5'ha: up_rdata <= {30'h0,up_function_b};
          5'hb: up_rdata <= up_hysteresis_b;
          5'hc: up_rdata <= {28'h0,up_trigger_l_mix_b};
          5'hd: up_rdata <= {29'h0,up_trigger_out_mix};
          5'he: up_rdata <= up_fifo_depth;
          5'hf: up_rdata <= {31'h0,up_triggered};
          5'h10: up_rdata <= up_trigger_delay;
          5'h11: up_rdata <= {31'h0,up_streaming};
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

   up_xfer_cntrl #(.DATA_WIDTH(186)) i_xfer_cntrl (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({ up_streaming,         // 1
                      up_config_trigger,    // 10
                      up_limit_a,           // 16
                      up_function_a,        // 2
                      up_hysteresis_a,      // 32
                      up_trigger_l_mix_a,   // 4
                      up_limit_b,           // 16
                      up_function_b,        // 2
                      up_hysteresis_b,      // 32
                      up_trigger_l_mix_b,   // 4
                      up_trigger_out_mix,   // 3
                      up_fifo_depth,        // 32
                      up_trigger_delay}),   // 32

    .up_xfer_done (),
    .d_rst (1'b0),
    .d_clk (clk),
    .d_data_cntrl ({  streaming,          // 1
                      config_trigger,     // 10
                      limit_a,            // 16
                      function_a,         // 2
                      hysteresis_a,       // 32
                      trigger_l_mix_a,    // 4
                      limit_b,            // 16
                      function_b,         // 2
                      hysteresis_b,       // 32
                      trigger_l_mix_b,    // 4
                      trigger_out_mix,    // 3
                      fifo_depth,         // 32
                      trigger_delay}));   // 32

endmodule

// ***************************************************************************
// ***************************************************************************

