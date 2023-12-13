// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

module axi_logic_analyzer_reg (

  input               clk,
  output              reset,

  output      [31:0]  divider_counter_la,
  output      [31:0]  divider_counter_pg,
  output      [15:0]  io_selection,

  output      [17:0]  edge_detect_enable,
  output      [17:0]  rise_edge_enable,
  output      [17:0]  fall_edge_enable,
  output      [17:0]  low_level_enable,
  output      [17:0]  high_level_enable,
  output      [31:0]  fifo_depth,
  output      [31:0]  trigger_delay,
  output      [ 6:0]  trigger_logic,
  output              clock_select,
  output      [15:0]  overwrite_enable,
  output      [15:0]  overwrite_data,
  input       [15:0]  input_data,
  output      [15:0]  od_pp_n,

  output      [31:0]  trigger_holdoff,
  output      [19:0]  pg_trigger_config,

  input               triggered,
  output              streaming,
  output      [ 9:0]  data_delay_control,

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
  output reg          up_rack
);

  // internal registers

  reg     [31:0]  up_version = 32'h00020100;
  reg     [31:0]  up_scratch = 0;
  reg     [31:0]  up_divider_counter_la = 0;
  reg     [31:0]  up_divider_counter_pg = 0;
  reg     [15:0]  up_io_selection = 16'h0;

  reg     [17:0]  up_edge_detect_enable = 0;
  reg     [17:0]  up_rise_edge_enable = 0;
  reg     [17:0]  up_fall_edge_enable = 0;
  reg     [17:0]  up_low_level_enable = 0;
  reg     [17:0]  up_high_level_enable = 0;
  reg     [31:0]  up_fifo_depth = 0;
  reg     [31:0]  up_trigger_delay = 0;
  reg     [ 6:0]  up_trigger_logic = 0;
  reg             up_clock_select = 0;
  reg     [15:0]  up_overwrite_enable = 0;
  reg     [15:0]  up_overwrite_data = 0;
  reg     [15:0]  up_od_pp_n = 0;
  reg     [31:0]  up_trigger_holdoff = 32'h0;
  reg     [19:0]  up_pg_trigger_config = 20'h0;
  reg             up_triggered = 0;
  reg             up_streaming = 0;
  reg     [ 9:0]  up_data_delay_control = 10'd0;

  wire    [15:0]  up_input_data;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_scratch <= 'd0;
      up_divider_counter_la <= 'd0;
      up_divider_counter_pg <= 'd0;
      up_edge_detect_enable <= 'd0;
      up_rise_edge_enable <= 'd0;
      up_fall_edge_enable <= 'd0;
      up_low_level_enable <= 'd0;
      up_high_level_enable <= 'd0;
      up_fifo_depth <= 'd0;
      up_trigger_delay <= 'd0;
      up_trigger_logic <= 'd0;
      up_clock_select <= 'd0;
      up_overwrite_enable <= 'd0;
      up_overwrite_data <= 'd0;
      up_io_selection <= 16'h0;
      up_od_pp_n <= 16'h0;
      up_triggered <= 1'd0;
      up_streaming <= 1'd0;
      up_trigger_holdoff <= 32'h0;
      up_pg_trigger_config <= 20'd0;
      up_data_delay_control <= 10'h0;
    end else begin
      up_wack <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h1)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h2)) begin
        up_divider_counter_la <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h3)) begin
        up_divider_counter_pg <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h4)) begin
        up_io_selection <= up_wdata[15:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h5)) begin
        up_edge_detect_enable <= up_wdata[17:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h6)) begin
        up_rise_edge_enable <= up_wdata[17:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h7)) begin
        up_fall_edge_enable <= up_wdata[17:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h8)) begin
        up_low_level_enable <= up_wdata[17:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h9)) begin
        up_high_level_enable <= up_wdata[17:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'ha)) begin
        up_fifo_depth <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'hb)) begin
        up_trigger_logic <= up_wdata[6:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'hc)) begin
        up_clock_select <= up_wdata[0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'hd)) begin
        up_overwrite_enable <= up_wdata[15:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'he)) begin
        up_overwrite_data <= up_wdata[15:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h10)) begin
        up_od_pp_n <= up_wdata[15:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h11)) begin
        up_trigger_delay <= up_wdata;
      end
      if (triggered == 1'b1) begin
        up_triggered <= 1'b1;
      end else if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h12)) begin
        up_triggered <= up_triggered & ~up_wdata[0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h13)) begin
        up_streaming <= up_wdata[0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h14)) begin
        up_trigger_holdoff <= up_wdata[31:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h15)) begin
        up_pg_trigger_config <= up_wdata[19:0];
      end
      if ((up_wreq == 1'b1) && (up_waddr[4:0] == 5'h16)) begin
        up_data_delay_control <= up_wdata[9:0];
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
          5'h2: up_rdata <= up_divider_counter_la;
          5'h3: up_rdata <= up_divider_counter_pg;
          5'h4: up_rdata <= {16'h0,up_io_selection};
          5'h5: up_rdata <= {14'h0,up_edge_detect_enable};
          5'h6: up_rdata <= {14'h0,up_rise_edge_enable};
          5'h7: up_rdata <= {14'h0,up_fall_edge_enable};
          5'h8: up_rdata <= {14'h0,up_low_level_enable};
          5'h9: up_rdata <= {14'h0,up_high_level_enable};
          5'ha: up_rdata <= up_fifo_depth;
          5'hb: up_rdata <= {25'h0,up_trigger_logic};
          5'hc: up_rdata <= {31'h0,up_clock_select};
          5'hd: up_rdata <= {16'h0,up_overwrite_enable};
          5'he: up_rdata <= {16'h0,up_overwrite_data};
          5'hf: up_rdata <= {16'h0,up_input_data};
          5'h10: up_rdata <= {16'h0,up_od_pp_n};
          5'h11: up_rdata <= up_trigger_delay;
          5'h12: up_rdata <= {31'h0,up_triggered};
          5'h13: up_rdata <= {31'h0,up_streaming};
          5'h14: up_rdata <= up_trigger_holdoff;
          5'h15: up_rdata <= {12'h0,up_pg_trigger_config};
          5'h16: up_rdata <= {22'h0,up_data_delay_control};
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  ad_rst i_core_rst_reg (
    .rst_async(~up_rstn),
    .clk(clk),
    .rstn(),
    .rst(reset));

  up_xfer_cntrl #(
    .DATA_WIDTH(353)
  ) i_xfer_cntrl (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({ up_streaming,             // 1
                      up_od_pp_n,               // 16
                      up_overwrite_data,        // 16
                      up_overwrite_enable,      // 16
                      up_clock_select,          // 1
                      up_trigger_logic,         // 7
                      up_fifo_depth,            // 32
                      up_trigger_delay,         // 32
                      up_trigger_holdoff,       // 32
                      up_high_level_enable,     // 18
                      up_low_level_enable,      // 18
                      up_fall_edge_enable,      // 18
                      up_rise_edge_enable,      // 18
                      up_edge_detect_enable,    // 18
                      up_io_selection,          // 16
                      up_pg_trigger_config,     // 20
                      up_divider_counter_pg,    // 32
                      up_divider_counter_la,    // 32
                      up_data_delay_control}),  // 10

    .up_xfer_done (),
    .d_rst (1'b0),
    .d_clk (clk),
    .d_data_cntrl ({  streaming,              // 1
                      od_pp_n,                // 16
                      overwrite_data,         // 16
                      overwrite_enable,       // 16
                      clock_select,           // 1
                      trigger_logic,          // 7
                      fifo_depth,             // 32
                      trigger_delay,          // 32
                      trigger_holdoff,        // 32
                      high_level_enable,      // 18
                      low_level_enable,       // 18
                      fall_edge_enable,       // 18
                      rise_edge_enable,       // 18
                      edge_detect_enable,     // 18
                      io_selection,           // 16
                      pg_trigger_config,      // 20
                      divider_counter_pg,     // 32
                      divider_counter_la,     // 32
                      data_delay_control}));  // 10

  up_xfer_status #(
    .DATA_WIDTH(16)
  ) i_xfer_status (
    // up interface

    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_data_status(up_input_data),

    // device interface

    .d_rst(1'd0),
    .d_clk(clk),
    .d_data_status(input_data));

endmodule
