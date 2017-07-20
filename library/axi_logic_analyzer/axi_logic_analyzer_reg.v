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
  output      [31:0]  trigger_delay,
  output              trigger_logic,
  output              clock_select,
  output      [15:0]  overwrite_enable,
  output      [15:0]  overwrite_data,
  input       [15:0]  input_data,
  output      [15:0]  od_pp_n,

 // bus interface

  input               up_rstn,
  input               up_clk,
  input               up_wreq,
  input       [13:0]  up_waddr,
  input       [31:0]  up_wdata,
  output reg          up_wack,
  input               up_rreq,
  input       [13:0]  up_raddr,
  output reg  [31:0]  up_rdata,
  output reg          up_rack);

  // internal signals

  wire            up_wreq_s;
  wire            up_rreq_s;

  // internal registers

  reg     [31:0]  up_version = 32'h00010000;
  reg     [31:0]  up_scratch = 0;
  reg     [31:0]  up_divider_counter_la = 0;
  reg     [31:0]  up_divider_counter_pg = 0;
  reg     [15:0]  up_io_selection = 16'h0;

  reg     [17:0]  up_edge_detect_enable = 0;
  reg     [17:0]  up_rise_edge_enable = 0;
  reg     [17:0]  up_fall_edge_enable = 0;
  reg     [17:0]  up_low_level_enable = 0;
  reg     [17:0]  up_high_level_enable = 0;
  reg     [31:0]  up_trigger_delay = 0;
  reg             up_trigger_logic = 0;
  reg             up_clock_select = 0;
  reg     [15:0]  up_overwrite_enable = 0;
  reg     [15:0]  up_overwrite_data = 0;
  reg     [15:0]  up_od_pp_n = 0;

  wire    [15:0]  up_input_data;

  assign up_wreq_s = ((up_waddr[13:5] == 6'h00)) ? up_wreq : 1'b0;
  assign up_rreq_s = ((up_raddr[13:5] == 6'h00)) ? up_rreq : 1'b0;

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
      up_trigger_delay <= 'd0;
      up_trigger_logic <= 'd0;
      up_clock_select <= 'd0;
      up_overwrite_enable <= 'd0;
      up_overwrite_data <= 'd0;
      up_io_selection <= 16'h0;
      up_od_pp_n <= 16'h0;
    end else begin
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h1)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h2)) begin
        up_divider_counter_la <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h3)) begin
        up_divider_counter_pg <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h4)) begin
        up_io_selection <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h5)) begin
        up_edge_detect_enable <= up_wdata[17:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h6)) begin
        up_rise_edge_enable <= up_wdata[17:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h7)) begin
        up_fall_edge_enable <= up_wdata[17:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h8)) begin
        up_low_level_enable <= up_wdata[17:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h9)) begin
        up_high_level_enable <= up_wdata[17:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'ha)) begin
        up_trigger_delay <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'hb)) begin
        up_trigger_logic <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'hc)) begin
        up_clock_select <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'hd)) begin
        up_overwrite_enable <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'he)) begin
        up_overwrite_data <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[4:0] == 5'h10)) begin
        up_od_pp_n <= up_wdata[15:0];
      end
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
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
          5'ha: up_rdata <= up_trigger_delay;
          5'hb: up_rdata <= {31'h0,up_trigger_logic};
          5'hc: up_rdata <= {31'h0,up_clock_select};
          5'hd: up_rdata <= {16'h0,up_overwrite_enable};
          5'he: up_rdata <= {16'h0,up_overwrite_data};
          5'hf: up_rdata <= {16'h0,up_input_data};
          5'h10: up_rdata <= {16'h0,up_od_pp_n};
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  ad_rst i_core_rst_reg (.preset(!up_rstn), .clk(clk), .rst(reset));

   up_xfer_cntrl #(.DATA_WIDTH(252)) i_xfer_cntrl (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({ up_od_pp_n,               // 16
                      up_overwrite_data,        // 16
                      up_overwrite_enable,      // 16
                      up_clock_select,          // 1
                      up_trigger_logic,         // 1
                      up_trigger_delay,         // 32
                      up_high_level_enable,     // 18
                      up_low_level_enable,      // 18
                      up_fall_edge_enable,      // 18
                      up_rise_edge_enable,      // 18
                      up_edge_detect_enable,    // 18
                      up_io_selection,          // 16
                      up_divider_counter_pg,    // 32
                      up_divider_counter_la}),  // 32

    .up_xfer_done (),
    .d_rst (1'b0),
    .d_clk (clk),
    .d_data_cntrl ({  od_pp_n,                // 16
                      overwrite_data,         // 16
                      overwrite_enable,       // 16
                      clock_select,           // 1
                      trigger_logic,          // 1
                      trigger_delay,          // 32
                      high_level_enable,      // 18
                      low_level_enable,       // 18
                      fall_edge_enable,       // 18
                      rise_edge_enable,       // 18
                      edge_detect_enable,     // 18
                      io_selection,           // 16
                      divider_counter_pg,     // 32
                      divider_counter_la}));  // 32

 up_xfer_status #(.DATA_WIDTH(16)) i_xfer_status (

  // up interface

  .up_rstn(up_rstn),
  .up_clk(up_clk),
  .up_data_status(up_input_data),

  // device interface

  .d_rst(1'd0),
  .d_clk(clk),
  .d_data_status(input_data));

endmodule

// ***************************************************************************
// ***************************************************************************

