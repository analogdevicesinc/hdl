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
  wire    [31:0]    delay_trigger;

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

  reg     [15:0]    data_a_r;
  reg     [15:0]    data_b_r;
  reg               data_valid_a_r;
  reg               data_valid_b_r;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  assign trigger_offset = delay_trigger;

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

  assign data_a_trig = {trigger_out_mixed, data_a_r[14:0]};
  assign data_b_trig = {trigger_out_mixed, data_b_r[14:0]};;
  assign data_valid_a_trig = data_valid_a_r;
  assign data_valid_b_trig = data_valid_b_r;

  always @(posedge clk) begin
    data_a_r <= data_a;
    data_valid_a_r <= data_valid_a;
    data_b_r <= data_b;
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
  .delay_trigger(delay_trigger),

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
