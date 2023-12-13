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

module axi_logic_analyzer (

  // interface

  input                 clk,
  output                clk_out,

  input       [15:0]    data_i,
  output reg  [15:0]    data_o,
  output      [15:0]    data_t,
  input       [ 1:0]    trigger_i,

  output                adc_valid,
  output reg  [15:0]    adc_data,

  input       [15:0]    dac_data,
  input                 dac_valid,
  output reg            dac_read,

  input       [ 2:0]    external_rate,
  input                 external_valid,
  input                 external_decimation_en,
  input                 trigger_in,
  output                trigger_out,
  output                trigger_out_adc,
  output      [31:0]    fifo_depth,

  // axi interface

  input                 s_axi_aclk,
  input                 s_axi_aresetn,
  input                 s_axi_awvalid,
  input       [ 6:0]    s_axi_awaddr,
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
  input       [ 6:0]    s_axi_araddr,
  input       [ 2:0]    s_axi_arprot,
  output                s_axi_arready,
  output                s_axi_rvalid,
  output      [31:0]    s_axi_rdata,
  output      [ 1:0]    s_axi_rresp,
  input                 s_axi_rready
);

  // internal registers

  reg     [15:0]    data_r = 'd0;
  reg     [ 1:0]    trigger_m1 = 'd0;
  reg     [31:0]    downsampler_counter_la = 'd0;
  reg     [31:0]    upsampler_counter_pg = 'd0;

  reg               sample_valid_la = 'd0;

  reg     [15:0]    io_selection; // 1 - input, 0 - output

  reg     [31:0]    delay_counter = 'd0;
  reg               triggered = 'd0;

  reg               up_triggered;
  reg               up_triggered_d1;
  reg               up_triggered_d2;

  reg               up_triggered_set;
  reg               up_triggered_reset;
  reg               up_triggered_reset_d1;
  reg               up_triggered_reset_d2;

  reg               streaming_on;

  reg    [ 1:0]     trigger_i_m1 = 2'd0;
  reg    [ 1:0]     trigger_i_m2 = 2'd0;
  reg    [ 1:0]     trigger_i_m3 = 2'd0;
  reg               trigger_adc_m1 = 1'd0;
  reg               trigger_adc_m2 = 1'd0;
  reg               trigger_la_m2 = 1'd0;
  reg               pg_trigered = 1'd0;

  reg    [ 1:0]     any_edge_trigger = 1'd0;
  reg    [ 1:0]     rise_edge_trigger = 1'd0;
  reg    [ 1:0]     fall_edge_trigger = 1'd0;
  reg    [ 1:0]     high_level_trigger = 1'd0;
  reg    [ 1:0]     low_level_trigger = 1'd0;

  reg    [31:0]     trigger_holdoff_counter = 32'd0;
  reg    [ 3:0]     adc_data_delay = 4'd0;

  reg    [16:0]     data_fixed_delay [0:15];
  reg    [15:0]     data_dynamic_delay [0:15];

  // internal signals

  wire              up_clk;
  wire              up_rstn;
  wire    [ 4:0]    up_waddr;
  wire    [31:0]    up_wdata;
  wire              up_wack;
  wire              up_wreq;
  wire              up_rack;
  wire    [31:0]    up_rdata;
  wire              up_rreq;
  wire    [ 4:0]    up_raddr;

  wire              reset;

  wire    [31:0]    divider_counter_la;
  wire    [31:0]    divider_counter_pg;

  wire    [17:0]    edge_detect_enable;
  wire    [17:0]    rise_edge_enable;
  wire    [17:0]    fall_edge_enable;
  wire    [17:0]    low_level_enable;
  wire    [17:0]    high_level_enable;
  wire    [ 6:0]    trigger_logic; // 0-OR,1-AND
  wire              clock_select;
  wire    [15:0]    overwrite_enable;
  wire    [15:0]    overwrite_data;

  wire    [15:0]    io_selection_s; // 1 - input, 0 - output
  wire    [15:0]    od_pp_n; // 0 - push/pull, 1 - open drain

  wire              trigger_out_s;
  wire    [31:0]    trigger_delay;
  wire              trigger_out_delayed;

  wire    [19:0]    pg_trigger_config;

  wire    [ 1:0]    pg_en_trigger_pins;
  wire              pg_en_trigger_adc;
  wire              pg_en_trigger_la;

  wire    [ 1:0]    pg_low_level;
  wire    [ 1:0]    pg_high_level;
  wire    [ 1:0]    pg_any_edge;
  wire    [ 1:0]    pg_rise_edge;
  wire    [ 1:0]    pg_fall_edge;

  wire    [31:0]    trigger_holdoff;
  wire              trigger_out_holdoff;

  wire              streaming;

  wire    [ 3:0]    in_data_delay;
  wire    [ 3:0]    up_data_delay;
  wire              master_delay_ctrl;
  wire    [ 9:0]    data_delay_control;
  wire    [15:0]    adc_data_mn;

  genvar i;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  assign trigger_out = trigger_delay == 32'h0 ? trigger_out_holdoff | streaming_on : trigger_out_delayed | streaming_on;

  assign trigger_out_delayed = delay_counter == 32'h0 ? 1 : 0;

  always @(posedge clk_out) begin
    if (trigger_delay == 0) begin
      if (streaming == 1'b1 && sample_valid_la == 1'b1 && trigger_out_holdoff == 1'b1) begin
        streaming_on <= 1'b1;
      end else if (streaming == 1'b0) begin
        streaming_on <= 1'b0;
      end
    end else begin
      if (streaming == 1'b1 && sample_valid_la == 1'b1 && trigger_out_delayed == 1'b1) begin
        streaming_on <= 1'b1;
      end else if (streaming == 1'b0) begin
        streaming_on <= 1'b0;
      end
    end
  end

  always @(posedge clk_out) begin
    if (sample_valid_la == 1'b1 && trigger_out_holdoff == 1'b1) begin
      up_triggered_set <= 1'b1;
    end else if (up_triggered_reset == 1'b1) begin
      up_triggered_set <= 1'b0;
    end
    up_triggered_reset_d1 <= up_triggered;
    up_triggered_reset_d2 <= up_triggered_reset_d1;
    up_triggered_reset    <= up_triggered_reset_d2;
  end

  always @(posedge up_clk) begin
    up_triggered_d1 <= up_triggered_set;
    up_triggered_d2 <= up_triggered_d1;
    up_triggered    <= up_triggered_d2;
  end

  generate
  for (i = 0 ; i < 16; i = i + 1) begin
    assign data_t[i] = od_pp_n[i] ? io_selection[i] | data_o[i] : io_selection[i];
    always @(posedge clk_out) begin
      data_o[i] <= overwrite_enable[i] ? overwrite_data[i] : data_r[i];
    end
    always @(posedge clk_out) begin
      if(dac_valid == 1'b1) begin
        data_r[i] <= dac_data[i];
      end
      if (io_selection_s[i] == 1'b1) begin
        io_selection[i] <= 1'b1;
      end else begin
        if(dac_valid == 1'b1 || overwrite_enable[i] == 1'b1) begin
          io_selection[i] <= 1'b0;
        end
      end
    end
  end
  endgenerate

  BUFGMUX_CTRL BUFGMUX_CTRL_inst (
    .O (clk_out),
    .I0 (clk),
    .I1 (data_i[0]),
    .S (clock_select));

  // - synchronization
  // - compensate for m2k adc path delay

  // 17 clock cycles delay
  generate
  for (i = 0 ; i < 16; i = i + 1) begin
    always @(posedge clk_out) begin
      if (reset == 1'b1) begin
        data_fixed_delay[i] <= 'd0;
      end else begin
        data_fixed_delay[i] <= {data_fixed_delay[i][15:0], data_i[i]};
      end
    end
  end

  // dynamic sample delay (1 to 16)
  for (i = 0 ; i < 16; i = i + 1) begin
    always @(posedge clk_out) begin
      if (sample_valid_la == 1'b1) begin
        data_dynamic_delay[i] <= {data_dynamic_delay[i][14:0], data_fixed_delay[i][16]};
      end
    end
    assign adc_data_mn[i] = data_dynamic_delay[i][in_data_delay[3:0]];
  end
  endgenerate

  // adc path 'rate delay' given by axi_adc_decimate
  always @(posedge clk_out) begin
    case (external_rate)
      3'd0:    adc_data_delay <= 4'd1; // 100MSPS
      3'd1:    adc_data_delay <= 4'd3; // 10MSPS
      default: adc_data_delay <= 4'd1; // <= 1MSPS
    endcase
  end

  assign up_data_delay = data_delay_control[3:0];
  assign rate_gen_select = data_delay_control[8];

  // select if the delay taps number is chosen by the user or automatically
  assign master_delay_ctrl = data_delay_control[9];
  assign in_data_delay = master_delay_ctrl ? up_data_delay :
                         external_decimation_en ? 4'd0 : adc_data_delay;

  always @(posedge clk_out) begin
    if (sample_valid_la == 1'b1) begin
      adc_data <= adc_data_mn;
    end
  end

  assign adc_valid = sample_valid_la;

  always @(posedge clk_out) begin
    trigger_m1 <= trigger_i;
  end

  // downsampler logic analyzer

  always @(posedge clk_out) begin
    if (reset == 1'b1) begin
      sample_valid_la <= 1'b0;
      downsampler_counter_la <= 32'h0;
    end else begin
      if (rate_gen_select) begin
        downsampler_counter_la <= 32'h0;
        sample_valid_la <= external_valid;
      end else if (downsampler_counter_la < divider_counter_la ) begin
        downsampler_counter_la <= downsampler_counter_la + 1;
        sample_valid_la <= 1'b0;
      end else begin
        downsampler_counter_la <= 32'h0;
        sample_valid_la <= 1'b1;
      end
    end
  end

  // pattern generator instrument triggering

  assign pg_any_edge   = pg_trigger_config[1:0];
  assign pg_rise_edge  = pg_trigger_config[3:2];
  assign pg_fall_edge  = pg_trigger_config[5:4];
  assign pg_low_level  = pg_trigger_config[7:6];
  assign pg_high_level = pg_trigger_config[9:8];

  assign pg_en_trigger_pins = pg_trigger_config[17:16];
  assign pg_en_trigger_adc  = pg_trigger_config[18];
  assign pg_en_trigger_la   = pg_trigger_config[19];

  assign trigger_active = |pg_trigger_config[19:16];
  assign trigger = (ext_trigger & pg_en_trigger_pins) |
                   (trigger_adc_m2 & pg_en_trigger_adc) |
                   (trigger_out_s & pg_en_trigger_la);

  assign ext_trigger = |(any_edge_trigger |
                        rise_edge_trigger |
                        fall_edge_trigger |
                        high_level_trigger |
                        low_level_trigger);

  // sync
  always @(posedge clk) begin
    trigger_i_m1 <= trigger_i;
    trigger_i_m2 <= trigger_i_m1;
    trigger_i_m3 <= trigger_i_m2;

    trigger_adc_m1 <= trigger_in;
    trigger_adc_m2 <= trigger_adc_m1;
  end

  always @(posedge clk) begin
    any_edge_trigger <= (trigger_i_m3 ^ trigger_i_m2) & pg_any_edge;
    rise_edge_trigger <= (~trigger_i_m3 & trigger_i_m2) & pg_rise_edge;
    fall_edge_trigger <= (trigger_i_m3 & ~trigger_i_m2) & pg_fall_edge;
    high_level_trigger <= trigger_i_m3 & pg_high_level;
    low_level_trigger <= ~trigger_i_m3 & pg_low_level;
  end

  // upsampler pattern generator

  always @(posedge clk_out) begin
    if (reset == 1'b1) begin
      upsampler_counter_pg <= 32'h0;
      dac_read <= 1'b0;
    end else begin
      dac_read <= 1'b0;
      pg_trigered <= trigger_active ? (trigger | pg_trigered) : 1'b0;
      if (trigger_active & !pg_trigered) begin
        upsampler_counter_pg <= 32'h0;
        dac_read <= 1'b0;
      end else if (upsampler_counter_pg < divider_counter_pg) begin
        upsampler_counter_pg <= upsampler_counter_pg + 1;
      end else begin
        upsampler_counter_pg <= 32'h0;
        dac_read <= 1'b1;
      end
    end
  end

  always @(posedge clk_out) begin
    if(trigger_delay == 32'h0) begin
      delay_counter <= 32'h0;
    end else begin
      if (adc_valid == 1'b1) begin
        triggered <= trigger_out_holdoff | triggered;
        if (delay_counter == 32'h0) begin
          delay_counter <= trigger_delay;
          triggered <= 1'b0;
        end else begin
          if(triggered == 1'b1 || trigger_out_holdoff == 1'b1) begin
            delay_counter <= delay_counter - 1;
          end
        end
      end
    end
  end

  // hold off trigger
  assign trigger_out_holdoff = (trigger_holdoff_counter != 0) ? 0 : trigger_out_s;
  assign holdoff_cnt_en = |trigger_holdoff;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      trigger_holdoff_counter <= 0;
    end else begin
      if (trigger_holdoff_counter != 0) begin
        trigger_holdoff_counter <= trigger_holdoff_counter - 1'b1;
      end else if (trigger_out_holdoff == 1'b1) begin
        trigger_holdoff_counter <= trigger_holdoff;
      end else begin
        trigger_holdoff_counter <= trigger_holdoff_counter;
      end
    end
  end

  axi_logic_analyzer_trigger i_trigger (
    .clk (clk_out),
    .reset (reset),

    .data (adc_data_mn),
    .data_valid(sample_valid_la),
    .trigger_i (trigger_m1),
    .trigger_in (trigger_in),

    .edge_detect_enable (edge_detect_enable),
    .rise_edge_enable (rise_edge_enable),
    .fall_edge_enable (fall_edge_enable),
    .low_level_enable (low_level_enable),
    .high_level_enable (high_level_enable),
    .trigger_logic (trigger_logic),
    .trigger_out_adc (trigger_out_adc),
    .trigger_out (trigger_out_s));

  axi_logic_analyzer_reg i_registers (
    .clk (clk_out),
    .reset (reset),

    .divider_counter_la (divider_counter_la),
    .divider_counter_pg (divider_counter_pg),
    .io_selection (io_selection_s),

    .edge_detect_enable (edge_detect_enable),
    .rise_edge_enable (rise_edge_enable),
    .fall_edge_enable (fall_edge_enable),
    .low_level_enable (low_level_enable),
    .high_level_enable (high_level_enable),
    .fifo_depth (fifo_depth),
    .trigger_delay (trigger_delay),
    .trigger_holdoff (trigger_holdoff),
    .trigger_logic (trigger_logic),
    .clock_select (clock_select),
    .overwrite_enable (overwrite_enable),
    .overwrite_data (overwrite_data),
    .input_data (adc_data_mn),
    .od_pp_n (od_pp_n),
    .triggered (up_triggered),
    .pg_trigger_config (pg_trigger_config),
    .streaming(streaming),
    .data_delay_control (data_delay_control),

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

  up_axi #(
    .AXI_ADDRESS_WIDTH(7)
  ) i_up_axi (
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
