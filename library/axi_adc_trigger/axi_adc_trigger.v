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

module axi_adc_trigger(

  input                 clk,

  input       [ 1:0]    trigger_i,
  output      [ 1:0]    trigger_o,
  output      [ 1:0]    trigger_t,

  input       [15:0]    data_a,
  input       [15:0]    data_b,
  input                 data_valid_a,
  input                 data_valid_b,

  output      [15:0]    data_a_trig,
  output      [15:0]    data_b_trig,
  output                data_valid_a_trig,
  output                data_valid_b_trig,

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
  input                 s_axi_rready);

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

  wire    [ 1:0]    io_selection;

  wire    [ 1:0]    low_level;
  wire    [ 1:0]    high_level;
  wire    [ 1:0]    any_edge;
  wire    [ 1:0]    rise_edge;
  wire    [ 1:0]    fall_edge;

  wire    [15:0]    limit_a;
  wire    [ 1:0]    function_a;
  wire    [31:0]    hysteresis_a;
  wire    [ 3:0]    trigger_l_mix_a;

  wire    [15:0]    limit_b;
  wire    [ 1:0]    function_b;
  wire    [31:0]    hysteresis_b;
  wire    [ 3:0]    trigger_l_mix_b;

  wire    [ 2:0]    trigger_out_mix;
  wire    [31:0]    trigger_delay;

  wire    [15:0]    data_a_cmp;
  wire    [15:0]    data_b_cmp;
  wire    [15:0]    limit_a_cmp;
  wire    [15:0]    limit_b_cmp;

  wire              trigger_a_fall_edge;
  wire              trigger_a_rise_edge;
  wire              trigger_b_fall_edge;
  wire              trigger_b_rise_edge;
  wire              trigger_a_any_edge;
  wire              trigger_b_any_edge;
  wire              trigger_out_a;
  wire              trigger_out_b;
  wire              trigger_out_delayed;
  wire              streaming;

  reg               trigger_a_d1; // synchronization flip flop
  reg               trigger_a_d2; // synchronization flip flop
  reg               trigger_a_d3;
  reg               trigger_b_d1; // synchronization flip flop
  reg               trigger_b_d2; // synchronization flip flop
  reg               trigger_b_d3;
  reg               passthrough_high_a; // trigger when rising through the limit
  reg               passthrough_low_a;  // trigger when fallingh thorugh the limit
  reg               low_a; // signal was under the limit, so if it goes through, assert rising
  reg               high_a; // signal was over the limit, so if it passes through, assert falling
  reg               comp_high_a;  // signal is over the limit
  reg               comp_low_a;   // signal is under the limit
  reg               passthrough_high_b; // trigger when rising through the limit
  reg               passthrough_low_b;  // trigger when fallingh thorugh the limit
  reg               low_b;   // signal was under the limit, so if it goes through, assert rising
  reg               high_b;   // signal was over the limit, so if it passes through, assert falling
  reg               comp_high_b;  // signal is over the limit
  reg               comp_low_b;   // signal is under the limit

  reg               trigger_pin_a;
  reg               trigger_pin_b;

  reg               trigger_adc_a;
  reg               trigger_adc_b;

  reg               trigger_a;
  reg               trigger_b;

  reg               trigger_out_mixed;
  reg               up_triggered;
  reg               up_triggered_d1;
  reg               up_triggered_d2;

  reg               up_triggered_set;
  reg               up_triggered_reset;
  reg               up_triggered_reset_d1;
  reg               up_triggered_reset_d2;

  reg     [14:0]    data_a_r;
  reg     [14:0]    data_b_r;
  reg               data_valid_a_r;
  reg               data_valid_b_r;

  reg     [31:0]    trigger_delay_counter;
  reg               triggered;

  reg               streaming_on;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  assign trigger_t = io_selection;

  assign trigger_a_fall_edge = (trigger_a_d2 == 1'b0 && trigger_a_d3 == 1'b1) ? 1'b1: 1'b0;
  assign trigger_a_rise_edge = (trigger_a_d2 == 1'b1 && trigger_a_d3 == 1'b0) ? 1'b1: 1'b0;
  assign trigger_a_any_edge = trigger_a_rise_edge | trigger_a_fall_edge;
  assign trigger_b_fall_edge = (trigger_b_d2 == 1'b0 && trigger_b_d3 == 1'b1) ? 1'b1: 1'b0;
  assign trigger_b_rise_edge = (trigger_b_d2 == 1'b1 && trigger_b_d3 == 1'b0) ? 1'b1: 1'b0;
  assign trigger_b_any_edge = trigger_b_rise_edge | trigger_b_fall_edge;

  assign data_a_cmp   = {!data_a[15],data_a[14:0]};
  assign data_b_cmp   = {!data_b[15],data_b[14:0]};
  assign limit_a_cmp  = {!limit_a[15],limit_a[14:0]};
  assign limit_b_cmp  = {!limit_b[15],limit_b[14:0]};

  assign data_a_trig = trigger_delay == 32'h0 ? {trigger_out_mixed | streaming_on, data_a_r} : {trigger_out_delayed |streaming_on, data_a_r};
  assign data_b_trig = trigger_delay == 32'h0 ? {trigger_out_mixed | streaming_on, data_b_r} : {trigger_out_delayed |streaming_on, data_b_r};
  assign data_valid_a_trig = data_valid_a_r;
  assign data_valid_b_trig = data_valid_b_r;

  assign trigger_out_delayed = (trigger_delay_counter == 32'h0) ? 1 : 0;

  always @(posedge clk) begin
    if (trigger_delay == 0) begin
      trigger_delay_counter <= 32'h0;
    end else begin
      if (data_valid_a_r == 1'b1) begin
        triggered <= trigger_out_mixed | triggered;
        if (trigger_delay_counter == 0) begin
          trigger_delay_counter <= trigger_delay;
          triggered <= 1'b0;
        end else begin
          if(triggered == 1'b1 || trigger_out_mixed == 1'b1) begin
            trigger_delay_counter <= trigger_delay_counter - 1;
          end
        end
      end
    end
  end

  always @(posedge clk) begin
    if (trigger_delay == 0) begin
      if (streaming == 1'b1 && data_valid_a_r == 1'b1 && trigger_out_mixed == 1'b1) begin
        streaming_on <= 1'b1;
      end else if (streaming == 1'b0) begin
        streaming_on <= 1'b0;
      end
    end else begin
      if (streaming == 1'b1 && data_valid_a_r == 1'b1 && trigger_out_delayed == 1'b1) begin
        streaming_on <= 1'b1;
      end else if (streaming == 1'b0) begin
        streaming_on <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    if (data_valid_a_r == 1'b1 && trigger_out_mixed == 1'b1) begin
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

  always @(posedge clk) begin
    data_a_r <= data_a[14:0];
    data_valid_a_r <= data_valid_a;
    data_b_r <= data_b[14:0];
    data_valid_b_r <= data_valid_b;
  end

  always @(*) begin
    case(trigger_l_mix_a)
      4'h0: trigger_a = 1'b1;
      4'h1: trigger_a = trigger_pin_a;
      4'h2: trigger_a = trigger_adc_a;
      4'h4: trigger_a = trigger_pin_a | trigger_adc_a ;
      4'h5: trigger_a = trigger_pin_a & trigger_adc_a ;
      4'h6: trigger_a = trigger_pin_a ^ trigger_adc_a ;
      4'h7: trigger_a = !(trigger_pin_a | trigger_adc_a) ;
      4'h8: trigger_a = !(trigger_pin_a & trigger_adc_a) ;
      4'h9: trigger_a = !(trigger_pin_a ^ trigger_adc_a) ;
      default: trigger_a = 1'b1;
    endcase
  end

  always @(*) begin
    case(trigger_l_mix_b)
      4'h0: trigger_b = 1'b1;
      4'h1: trigger_b = trigger_pin_b;
      4'h2: trigger_b = trigger_adc_b;
      4'h4: trigger_b = trigger_pin_b | trigger_adc_b ;
      4'h5: trigger_b = trigger_pin_b & trigger_adc_b ;
      4'h6: trigger_b = trigger_pin_b ^ trigger_adc_b ;
      4'h7: trigger_b = !(trigger_pin_b | trigger_adc_b) ;
      4'h8: trigger_b = !(trigger_pin_b & trigger_adc_b) ;
      4'h9: trigger_b = !(trigger_pin_b ^ trigger_adc_b) ;
      default: trigger_b = 1'b1;
    endcase
  end

  always @(*) begin
    case(function_a)
      2'h0: trigger_adc_a = comp_low_a;
      2'h1: trigger_adc_a = comp_high_a;
      2'h2: trigger_adc_a = passthrough_high_a;
      2'h3: trigger_adc_a = passthrough_low_a;
      default: trigger_adc_a = comp_low_a;
    endcase
  end

  always @(*) begin
    case(function_b)
      2'h0: trigger_adc_b = comp_low_b;
      2'h1: trigger_adc_b = comp_high_b;
      2'h2: trigger_adc_b = passthrough_high_b;
      2'h3: trigger_adc_b = passthrough_low_b;
      default: trigger_adc_b = comp_low_b;
    endcase
  end

  always @(posedge clk) begin
    trigger_a_d1 <= trigger_i[0];
    trigger_a_d2 <= trigger_a_d1;
    trigger_a_d3 <= trigger_a_d2;
    trigger_b_d1 <= trigger_i[1];
    trigger_b_d2 <= trigger_b_d1;
    trigger_b_d3 <= trigger_b_d2;
  end

  always @(*) begin
    trigger_pin_a = ((!trigger_a_d3 & low_level[0]) |
      (trigger_a_d3 & high_level[0]) |
      (trigger_a_fall_edge & fall_edge[0]) |
      (trigger_a_rise_edge & rise_edge[0]) |
      (trigger_a_any_edge & any_edge[0]));
  end

  always @(*) begin
    trigger_pin_b = ((!trigger_b_d3 & low_level[1]) |
      (trigger_b_d3 & high_level[1]) |
      (trigger_b_fall_edge & fall_edge[1]) |
      (trigger_b_rise_edge & rise_edge[1]) |
      (trigger_b_any_edge & any_edge[1]));
  end

   always @(*) begin
    case(trigger_out_mix)
      3'h0: trigger_out_mixed = trigger_a;
      3'h1: trigger_out_mixed = trigger_b;
      3'h2: trigger_out_mixed = trigger_a | trigger_b;
      3'h3: trigger_out_mixed = trigger_a & trigger_b;
      3'h4: trigger_out_mixed = trigger_a ^ trigger_b;
      default: trigger_out_mixed = trigger_a;
    endcase
  end

  always @(posedge clk) begin
    if (data_valid_a == 1'b1) begin
      if (data_a_cmp > limit_a_cmp) begin
        comp_high_a <= 1'b1;
        passthrough_high_a <= low_a;
      end else begin
        comp_high_a <= 1'b0;
        passthrough_high_a <= 1'b0;
      end
      if (data_a_cmp < limit_a_cmp) begin
        comp_low_a <= 1'b1;
        passthrough_low_a <= high_a;
      end else begin
        comp_low_a <= 1'b0;
        passthrough_low_a <= 1'b0;
      end
      if (passthrough_high_a == 1'b1) begin
        low_a <= 1'b0;
      end else if (data_a_cmp < limit_a_cmp - hysteresis_a) begin
        low_a <= 1'b1;
      end
      if (passthrough_low_a == 1'b1) begin
        high_a <= 1'b0;
      end else if (data_a_cmp > limit_a_cmp + hysteresis_a) begin
        high_a <= 1'b1;
      end
    end
  end

  always @(posedge clk) begin
    if (data_valid_b == 1'b1) begin
      if (data_b_cmp > limit_b_cmp) begin
        comp_high_b <= 1'b1;
        passthrough_high_b <= low_b;
      end else begin
        comp_high_b <= 1'b0;
        passthrough_high_b <= 1'b0;
      end
      if (data_b_cmp < limit_b_cmp) begin
        comp_low_b <= 1'b1;
        passthrough_low_b <= high_b;
      end else begin
        comp_low_b <= 1'b0;
        passthrough_low_b <= 1'b0;
      end
      if (trigger_b == 1'b1) begin
        low_b <= 1'b0;
        high_b <= 1'b0;
      end else if (data_b_cmp < limit_b_cmp - hysteresis_b) begin
        low_b <= 1'b1;
      end else if (data_b_cmp > limit_b_cmp + hysteresis_b) begin
        high_b <= 1'b1;
      end
    end
  end

  axi_adc_trigger_reg adc_trigger_registers (

  .clk(clk),

  .io_selection(io_selection),
  .trigger_o(trigger_o),
  .triggered(up_triggered),

  .low_level(low_level),
  .high_level(high_level),
  .any_edge(any_edge),
  .rise_edge(rise_edge),
  .fall_edge(fall_edge),

  .limit_a(limit_a),
  .function_a(function_a),
  .hysteresis_a(hysteresis_a),
  .trigger_l_mix_a(trigger_l_mix_a),

  .limit_b(limit_b),
  .function_b(function_b),
  .hysteresis_b(hysteresis_b),
  .trigger_l_mix_b(trigger_l_mix_b),

  .trigger_out_mix(trigger_out_mix),
  .trigger_delay(trigger_delay),
  .fifo_depth(fifo_depth),

  .streaming(streaming),

  // bus interface

  .up_rstn(up_rstn),
  .up_clk(up_clk),
  .up_wreq(up_wreq),
  .up_waddr(up_waddr),
  .up_wdata(up_wdata),
  .up_wack(up_wack),
  .up_rreq(up_rreq),
  .up_raddr(up_raddr),
  .up_rdata(up_rdata),
  .up_rack(up_rack));

 up_axi #(
    .AXI_ADDRESS_WIDTH(7),
    .ADDRESS_WIDTH(5)
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

// ***************************************************************************
// ***************************************************************************
