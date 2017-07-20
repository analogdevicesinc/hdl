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

module axi_logic_analyzer (

  input                 clk,
  output                clk_out,

  input       [15:0]    data_i,
  output reg  [15:0]    data_o,
  output      [15:0]    data_t,
  input       [ 1:0]    trigger_i,

  output reg            adc_valid,
  output reg  [15:0]    adc_data,

  input       [15:0]    dac_data,
  input                 dac_valid,
  output reg            dac_read,

  output                trigger_out,
  output      [31:0]    trigger_offset,

  // axi interface

  input                 s_axi_aclk,
  input                 s_axi_aresetn,
  input                 s_axi_awvalid,
  input       [31:0]    s_axi_awaddr,
  input       [ 2:0]    s_axi_awprot,
  output                s_axi_awready,
  input                 s_axi_wvalid,
  input       [31:0]    s_axi_wdata,
  input       [ 3:0]    s_axi_wstrb,
  output                s_axi_wready,
  output                s_axi_bvalid,
  output      [ 1:0]    s_axi_bresp,
  input                 s_axi_bready,
  input                 s_axi_arvalid,
  input       [31:0]    s_axi_araddr,
  input       [ 2:0]    s_axi_arprot,
  output                s_axi_arready,
  output                s_axi_rvalid,
  output      [31:0]    s_axi_rdata,
  output      [ 1:0]    s_axi_rresp,
  input                 s_axi_rready);

  // internal registers

  reg     [15:0]    data_m1 = 'd0;
  reg     [15:0]    data_r = 'd0;
  reg     [ 1:0]    trigger_m1 = 'd0;
  reg     [ 1:0]    trigger_m2 = 'd0;
  reg     [31:0]    downsampler_counter_la = 'd0;
  reg     [31:0]    upsampler_counter_pg = 'd0;

  reg               sample_valid_la = 'd0;
  reg               adc_valid_d1 = 'd0;
  reg               adc_valid_d2 = 'd0;

  // internal signals

  wire              up_clk;
  wire              up_rstn;
  wire    [13:0]    up_waddr;
  wire    [31:0]    up_wdata;
  wire              up_wack;
  wire              up_wreq;
  wire              up_rack;
  wire    [31:0]    up_rdata;
  wire              up_rreq;
  wire    [13:0]    up_raddr;

  wire    [31:0]    divider_counter_la;
  wire    [31:0]    divider_counter_pg;

  wire    [17:0]    edge_detect_enable;
  wire    [17:0]    rise_edge_enable;
  wire    [17:0]    fall_edge_enable;
  wire    [17:0]    low_level_enable;
  wire    [17:0]    high_level_enable;
  wire    [31:0]    trigger_delay;
  wire              trigger_logic; // 0-OR,1-AND,2-XOR,3-NOR,4-NAND,5-NXOR
  wire              clock_select;
  wire    [15:0]    overwrite_enable;
  wire    [15:0]    overwrite_data;

  wire    [15:0]    io_selection;
  wire    [15:0]    od_pp_n; // 0 - push/pull, 1 - open drain

  genvar i;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  assign trigger_offset = trigger_delay;

  generate
  for (i = 0 ; i < 16; i = i + 1) begin
    assign data_t[i] = od_pp_n[i] ? io_selection[i] & !data_o[i] : io_selection[i];
    always @(posedge clk) begin
      data_o[i] <= overwrite_enable[i] ? overwrite_data[i] : data_r[i];
    end
  end
  endgenerate

  BUFGMUX BUFGMUX_inst (
    .O (clk_out),
    .I0 (data_i[0]),
    .I1 (trigger_i[0]),
    .S (clock_select));

  // synchronization

  always @(posedge clk) begin
    data_m1 <= data_i;
    trigger_m1 <= trigger_i;
    trigger_m2 <= trigger_m1;
  end

  // transfer data at clock frequency
  // if capture is enabled

  always @(posedge clk) begin
  adc_valid_d1 <= adc_valid_d2;
  adc_valid <= adc_valid_d1;
    if (sample_valid_la == 1'b1) begin
      adc_data  <= data_m1;
      adc_valid_d2 <= 1'b1;
    end else begin
      adc_valid_d2 <= 1'b0;
    end
  end

  // downsampler logic analyzer

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      sample_valid_la <= 1'b0;
      downsampler_counter_la <= 32'h0;
    end else begin
      if (downsampler_counter_la < divider_counter_la ) begin
        downsampler_counter_la <= downsampler_counter_la + 1;
        sample_valid_la <= 1'b0;
      end else begin
        downsampler_counter_la <= 32'h0;
        sample_valid_la <= 1'b1;
      end
    end
  end

  // upsampler pattern generator

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      upsampler_counter_pg <= 32'h0;
      dac_read <= 1'b0;
    end else begin
      dac_read <= 1'b0;
        if (upsampler_counter_pg < divider_counter_pg) begin
          upsampler_counter_pg <= upsampler_counter_pg + 1;
        end else begin
          upsampler_counter_pg <= 32'h0;
          dac_read <= 1'b1;
        end
    end
  end

  always @(posedge clk) begin
    if (dac_valid == 1'b1) begin
      data_r <= dac_data;
    end
  end

  axi_logic_analyzer_trigger i_trigger (
    .clk (clk),
    .reset (reset),

    .data (adc_data),
    .trigger (trigger_m2),

    .edge_detect_enable (edge_detect_enable),
    .rise_edge_enable (rise_edge_enable),
    .fall_edge_enable (fall_edge_enable),
    .low_level_enable (low_level_enable),
    .high_level_enable (high_level_enable),
    .trigger_logic (trigger_logic),
    .trigger_out (trigger_out));

   axi_logic_analyzer_reg i_registers (

    .clk (clk),
    .reset (reset),

    .divider_counter_la (divider_counter_la),
    .divider_counter_pg (divider_counter_pg),
    .io_selection (io_selection),

    .edge_detect_enable (edge_detect_enable),
    .rise_edge_enable (rise_edge_enable),
    .fall_edge_enable (fall_edge_enable),
    .low_level_enable (low_level_enable),
    .high_level_enable (high_level_enable),
    .trigger_delay (trigger_delay),
    .trigger_logic (trigger_logic),
    .clock_select (clock_select),
    .overwrite_enable (overwrite_enable),
    .overwrite_data (overwrite_data),
    .input_data (adc_data),
    .od_pp_n (od_pp_n),

    // bus interface

    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

  // axi interface

  up_axi i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule

// ***************************************************************************
// ***************************************************************************
