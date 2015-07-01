//-----------------------------------------------------------------
// System Generator version 2013.4 Verilog source file.
//
// Copyright(C) 2013 by Xilinx, Inc.  All rights reserved.  This
// text/file contains proprietary, confidential information of Xilinx,
// Inc., is distributed under license from Xilinx, Inc., and may be used,
// copied and/or disclosed only pursuant to the terms of a valid license
// agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
// this text/file solely for design, simulation, implementation and
// creation of design files limited to Xilinx devices or technologies.
// Use with non-Xilinx devices or technologies is expressly prohibited
// and immediately terminates your license unless covered by a separate
// agreement.
//
// Xilinx is providing this design, code, or information "as is" solely
// for use in developing programs and solutions for Xilinx devices.  By
// providing this design, code, or information as one possible
// implementation of this feature, application or standard, Xilinx is
// making no representation that this implementation is free from any
// claims of infringement.  You are responsible for obtaining any rights
// you may require for your implementation.  Xilinx expressly disclaims
// any warranty whatsoever with respect to the adequacy of the
// implementation, including but not limited to warranties of
// merchantability or fitness for a particular purpose.
//
// Xilinx products are not intended for use in life support appliances,
// devices, or systems.  Use in such applications is expressly prohibited.
//
// Any modifications that are made to the source code are done at the user's
// sole risk and will be unsupported.
//
// This copyright and support notice must be retained as part of this
// text at all times.  (c) Copyright 1995-2013 Xilinx, Inc.  All rights
// reserved.
//-----------------------------------------------------------------

`include "conv_pkg.v"


module xlconvert_ip_pid_controller (din, clk, ce, clr, en, dout);

//Parameter Definitions
   parameter din_width= 16;
   parameter din_bin_pt= 4;
   parameter din_arith= `xlUnsigned;
   parameter dout_width= 8;
   parameter dout_bin_pt= 2;
   parameter dout_arith= `xlUnsigned;
   parameter en_width = 1;
   parameter en_bin_pt = 0;
   parameter en_arith = `xlUnsigned;
   parameter bool_conversion = 0;
   parameter latency = 0;
   parameter quantization= `xlTruncate;
   parameter overflow= `xlWrap;

//Port Declartions
   input [din_width-1:0] din;
   input clk, ce, clr;
   input [en_width-1:0] en;
   output [dout_width-1:0] dout;

//Wire Declartions
   wire [dout_width-1:0]   result;
   wire internal_ce;
   assign internal_ce = ce & en[0];

generate
 if (bool_conversion == 1)
    begin:bool_converion_generate
       assign result = din;
    end
 else
    begin:std_conversion
       convert_type #(din_width,
                      din_bin_pt,
                      din_arith,
		              dout_width,
                      dout_bin_pt,
                      dout_arith,
                      quantization,
                      overflow)
        conv_udp (.inp(din), .res(result));
    end
endgenerate

generate
if (latency > 0)
     begin:latency_test
	synth_reg # (dout_width, latency)
	  reg1 (
	       .i(result),
	       .ce(internal_ce),
	       .clr(clr),
	       .clk(clk),
	       .o(dout));
     end
else
     begin:latency0
	assign dout = result;
     end
endgenerate

endmodule

module sysgen_mcode_block_698c2b186c (
  input [(32 - 1):0] x,
  output [(32 - 1):0] z,
  input clk,
  input ce,
  input clr);
  wire signed [(32 - 1):0] x_1_22;
  localparam [(11 - 1):0] const_value = 11'b10010000000;
  localparam [(11 - 1):0] const_value_x_000000 = 11'b11111111111;
  localparam [(11 - 1):0] const_value_x_000001 = 11'b10010000000;
  localparam signed [(32 - 1):0] const_value_x_000002 = 32'sb00000100100000000000000000000000;
  wire rel_3_6;
  localparam [(11 - 1):0] const_value_x_000003 = 11'b11111111111;
  localparam signed [(32 - 1):0] const_value_x_000004 = 32'sb00000111111111110000000000000000;
  wire rel_5_10;
  reg signed [(32 - 1):0] z_join_3_3;
  localparam signed [(32 - 1):0] const_value_x_000005 = 32'sb00000100100000000000000000000000;
  localparam signed [(32 - 1):0] const_value_x_000006 = 32'sb00000111111111110000000000000000;
  assign x_1_22 = x;
  assign rel_3_6 = x_1_22 < const_value_x_000002;
  assign rel_5_10 = x_1_22 > const_value_x_000004;
  always @(rel_3_6 or rel_5_10 or x_1_22)
    begin:proc_if_3_3
      if (rel_3_6)
        begin
          z_join_3_3 = const_value_x_000005;
        end
      else if (rel_5_10)
        begin
          z_join_3_3 = const_value_x_000006;
        end
      else 
        begin
          z_join_3_3 = x_1_22;
        end
    end
  assign z = z_join_3_3;
endmodule
module sysgen_constant_383443dd88 (
  output [(8 - 1):0] op,
  input clk,
  input ce,
  input clr);
  assign op = 8'b00000000;
endmodule
module xldelay_ip_pid_controller #(parameter width = -1, latency = -1, reg_retiming = 0, reset = 0)
  (input [width-1:0] d,
   input ce, clk, en, rst,
   output [width-1:0] q);

generate
  if ((latency == 0) || ((reg_retiming == 0) && (reset == 0)))
  begin:srl_delay
    synth_reg # (width, latency)
      reg1 (
        .i(d),
        .ce(ce & en),
        .clr(1'b0),
        .clk(clk),
        .o(q));
  end

  if ((latency>=1) && ((reg_retiming) || (reset)))
  begin:reg_delay
    synth_reg_reg # (width, latency)
      reg2 (
        .i(d),
        .ce(ce & en),
        .clr(rst),
        .clk(clk),
        .o(q));
  end
endgenerate
endmodule
module sysgen_inverter_91fd45ca5a (
  input [(1 - 1):0] ip,
  output [(1 - 1):0] op,
  input clk,
  input ce,
  input clr);
  wire ip_1_26;
  reg op_mem_22_20[0:(1 - 1)];
  initial
    begin
      op_mem_22_20[0] = 1'b0;
    end
  wire op_mem_22_20_front_din;
  wire op_mem_22_20_back;
  wire op_mem_22_20_push_front_pop_back_en;
  localparam [(1 - 1):0] const_value = 1'b1;
  wire internal_ip_12_1_bitnot;
  assign ip_1_26 = ip;
  assign op_mem_22_20_back = op_mem_22_20[0];
  always @(posedge clk)
    begin:proc_op_mem_22_20
      integer i;
      if (((ce == 1'b1) && (op_mem_22_20_push_front_pop_back_en == 1'b1)))
        begin
          op_mem_22_20[0] <= op_mem_22_20_front_din;
        end
    end
  assign internal_ip_12_1_bitnot = ~ip_1_26;
  assign op_mem_22_20_front_din = internal_ip_12_1_bitnot;
  assign op_mem_22_20_push_front_pop_back_en = 1'b1;
  assign op = op_mem_22_20_back;
endmodule
module sysgen_logical_098c9fa070 (
  input [(1 - 1):0] d0,
  input [(1 - 1):0] d1,
  output [(1 - 1):0] y,
  input clk,
  input ce,
  input clr);
  wire d0_1_24;
  wire d1_1_27;
  wire fully_2_1_bit;
  assign d0_1_24 = d0;
  assign d1_1_27 = d1;
  assign fully_2_1_bit = d0_1_24 & d1_1_27;
  assign y = fully_2_1_bit;
endmodule
module xlregister_ip_pid_controller (d, rst, en, ce, clk, q);
   parameter d_width = 5;
   parameter init_value = 'b0;

   input [d_width-1:0] d;
   input rst, en, ce, clk;
   output [d_width-1:0] q;

   wire internal_clr, internal_ce;

   assign internal_clr = rst & ce;
   assign internal_ce  = ce & en;

   synth_reg_w_init #(.width(d_width),
                      .init_index(2),
                      .init_value(init_value),
                      .latency(1))
   synth_reg_inst(.i(d),
                  .ce(internal_ce),
                  .clr(internal_clr),
                  .clk(clk),
                  .o(q));
endmodule

module sysgen_relational_0c5dbda85b (
  input [(8 - 1):0] a,
  input [(8 - 1):0] b,
  output [(1 - 1):0] op,
  input clk,
  input ce,
  input clr);
  wire [(8 - 1):0] a_1_31;
  wire [(8 - 1):0] b_1_34;
  localparam [(1 - 1):0] const_value = 1'b1;
  wire result_12_3_rel;
  assign a_1_31 = a;
  assign b_1_34 = b;
  assign result_12_3_rel = a_1_31 == b_1_34;
  assign op = result_12_3_rel;
endmodule
module sysgen_constant_61a644b4c8 (
  output [(32 - 1):0] op,
  input clk,
  input ce,
  input clr);
  assign op = 32'b01011111010111100001000000000000;
endmodule
module sysgen_accum_ac23432ab2 (
  input [(32 - 1):0] b,
  input [(1 - 1):0] rst,
  input [(1 - 1):0] en,
  output [(32 - 1):0] q,
  input clk,
  input ce,
  input clr);
  wire signed [(32 - 1):0] b_17_24;
  wire rst_17_27;
  wire en_17_32;
  reg signed [(32 - 1):0] accum_reg_41_23 = 32'b00000000000000000000000000000000;
  wire accum_reg_41_23_rst;
  wire accum_reg_41_23_en;
  localparam [(1 - 1):0] const_value = 1'b0;
  localparam [(1 - 1):0] const_value_x_000000 = 1'b1;
  localparam [(1 - 1):0] const_value_x_000001 = 1'b0;
  localparam [(1 - 1):0] const_value_x_000002 = 1'b1;
  reg signed [(33 - 1):0] accum_reg_join_47_1;
  reg accum_reg_join_47_1_en;
  reg accum_reg_join_47_1_rst;
  assign b_17_24 = b;
  assign rst_17_27 = rst;
  assign en_17_32 = en;
  always @(posedge clk)
    begin:proc_accum_reg_41_23
      if (((ce == 1'b1) && (accum_reg_41_23_rst == 1'b1)))
        begin
          accum_reg_41_23 <= 32'b00000000000000000000000000000000;
        end
      else if (((ce == 1'b1) && (accum_reg_41_23_en == 1'b1)))
        begin
          accum_reg_41_23 <= accum_reg_41_23 + b_17_24;
        end
    end
  always @(accum_reg_41_23 or b_17_24 or en_17_32 or rst_17_27)
    begin:proc_if_47_1
      if (rst_17_27)
        begin
          accum_reg_join_47_1_rst = 1'b1;
        end
      else if (en_17_32)
        begin
          accum_reg_join_47_1_rst = 1'b0;
        end
      else 
        begin
          accum_reg_join_47_1_rst = 1'b0;
        end
      if (en_17_32)
        begin
          accum_reg_join_47_1_en = 1'b1;
        end
      else 
        begin
          accum_reg_join_47_1_en = 1'b0;
        end
    end
  assign accum_reg_41_23_rst = accum_reg_join_47_1_rst;
  assign accum_reg_41_23_en = accum_reg_join_47_1_en;
  assign q = accum_reg_41_23;
endmodule
module sysgen_constant_b4741603e8 (
  output [(32 - 1):0] op,
  input clk,
  input ce,
  input clr);
  assign op = 32'b00000111111111110000000000000000;
endmodule
module sysgen_constant_a7c2a996dd (
  output [(32 - 1):0] op,
  input clk,
  input ce,
  input clr);
  assign op = 32'b00000000000000000000000000000000;
endmodule
module sysgen_constant_bd840882a6 (
  output [(32 - 1):0] op,
  input clk,
  input ce,
  input clr);
  assign op = 32'b00000100100000000000000000000000;
endmodule
module sysgen_logical_0c47d61908 (
  input [(1 - 1):0] d0,
  input [(1 - 1):0] d1,
  output [(1 - 1):0] y,
  input clk,
  input ce,
  input clr);
  wire d0_1_24;
  wire d1_1_27;
  wire bit_2_27;
  wire fully_2_1_bitnot;
  assign d0_1_24 = d0;
  assign d1_1_27 = d1;
  assign bit_2_27 = d0_1_24 & d1_1_27;
  assign fully_2_1_bitnot = ~bit_2_27;
  assign y = fully_2_1_bitnot;
endmodule
module sysgen_logical_7913ccf482 (
  input [(1 - 1):0] d0,
  input [(1 - 1):0] d1,
  input [(1 - 1):0] d2,
  output [(1 - 1):0] y,
  input clk,
  input ce,
  input clr);
  wire d0_1_24;
  wire d1_1_27;
  wire d2_1_30;
  wire fully_2_1_bit;
  assign d0_1_24 = d0;
  assign d1_1_27 = d1;
  assign d2_1_30 = d2;
  assign fully_2_1_bit = d0_1_24 & d1_1_27 & d2_1_30;
  assign y = fully_2_1_bit;
endmodule
module sysgen_relational_56046aa836 (
  input [(32 - 1):0] a,
  input [(32 - 1):0] b,
  output [(1 - 1):0] op,
  input clk,
  input ce,
  input clr);
  wire signed [(32 - 1):0] a_1_31;
  wire signed [(32 - 1):0] b_1_34;
  localparam [(1 - 1):0] const_value = 1'b1;
  wire result_18_3_rel;
  assign a_1_31 = a;
  assign b_1_34 = b;
  assign result_18_3_rel = a_1_31 > b_1_34;
  assign op = result_18_3_rel;
endmodule
module sysgen_relational_860373682b (
  input [(32 - 1):0] a,
  input [(32 - 1):0] b,
  output [(1 - 1):0] op,
  input clk,
  input ce,
  input clr);
  wire signed [(32 - 1):0] a_1_31;
  wire signed [(32 - 1):0] b_1_34;
  localparam [(1 - 1):0] const_value = 1'b1;
  wire result_16_3_rel;
  assign a_1_31 = a;
  assign b_1_34 = b;
  assign result_16_3_rel = a_1_31 < b_1_34;
  assign op = result_16_3_rel;
endmodule
module xladdsub_ip_pid_controller (a, b, c_in, ce, clr, clk, rst, en, c_out, s);
 
 parameter core_name0= "";
 parameter a_width= 16;
 parameter signed a_bin_pt= 4;
 parameter a_arith= `xlUnsigned;
 parameter c_in_width= 16;
 parameter c_in_bin_pt= 4;
 parameter c_in_arith= `xlUnsigned;
 parameter c_out_width= 16;
 parameter c_out_bin_pt= 4;
 parameter c_out_arith= `xlUnsigned;
 parameter b_width= 8;
 parameter signed b_bin_pt= 2;
 parameter b_arith= `xlUnsigned;
 parameter s_width= 17;
 parameter s_bin_pt= 4;
 parameter s_arith= `xlUnsigned;
 parameter rst_width= 1;
 parameter rst_bin_pt= 0;
 parameter rst_arith= `xlUnsigned;
 parameter en_width= 1;
 parameter en_bin_pt= 0;
 parameter en_arith= `xlUnsigned;
 parameter full_s_width= 17;
 parameter full_s_arith= `xlUnsigned;
 parameter mode= `xlAddMode;
 parameter extra_registers= 0;
 parameter latency= 0;
 parameter quantization= `xlTruncate;
 parameter overflow= `xlWrap;
 parameter c_a_width= 16;
 parameter c_b_width= 8;
 parameter c_a_type= 1;
 parameter c_b_type= 1;
 parameter c_has_sclr= 0;
 parameter c_has_ce= 0;
 parameter c_latency= 0;
 parameter c_output_width= 17;
 parameter c_enable_rlocs= 1;
 parameter c_has_c_in= 0;
 parameter c_has_c_out= 0;
 
 input [a_width-1:0] a;
 input [b_width-1:0] b;
 input c_in, ce, clr, clk, rst, en;
 output c_out;
 output [s_width-1:0] s;
 
 parameter full_a_width = full_s_width;
 parameter full_b_width = full_s_width;
 parameter full_s_bin_pt = (a_bin_pt > b_bin_pt) ? a_bin_pt : b_bin_pt;
 
 wire [full_a_width-1:0] full_a;
 wire [full_b_width-1:0] full_b;
 wire [full_s_width-1:0] full_s;
 wire [full_s_width-1:0] core_s;
 wire [s_width-1:0] conv_s;
 wire  temp_cout;
 wire  real_a,real_b,real_s;
 wire  internal_clr;
 wire  internal_ce;
 wire  extra_reg_ce;
 wire  override;
 wire  logic1;
 wire  temp_cin;
 
 assign internal_clr = (clr | rst) & ce;
 assign internal_ce = ce & en;
 assign logic1 = 1'b1;
 assign temp_cin = (c_has_c_in) ? c_in : 1'b0;
 
 align_input # (a_width, b_bin_pt - a_bin_pt, a_arith, full_a_width)
 align_inp_a(.inp(a),.res(full_a));
 align_input # (b_width, a_bin_pt - b_bin_pt, b_arith, full_b_width)
 align_inp_b(.inp(b),.res(full_b));
 convert_type # (full_s_width, full_s_bin_pt, full_s_arith, s_width,
                 s_bin_pt, s_arith, quantization, overflow)
 conv_typ_s(.inp(core_s),.res(conv_s));
 
 generate


if (core_name0 == "ip_pid_controller_c_addsub_v12_0_0") 
     begin:comp0
ip_pid_controller_c_addsub_v12_0_0 core_instance0 ( 
         .A(full_a),
         .S(core_s),
         .B(full_b) 
       ); 
     end 

if (core_name0 == "ip_pid_controller_c_addsub_v12_0_1") 
     begin:comp1
ip_pid_controller_c_addsub_v12_0_1 core_instance1 ( 
         .A(full_a),
         .S(core_s),
         .B(full_b) 
       ); 
     end 

endgenerate 
 
 
 generate
   if (extra_registers > 0)
   begin:latency_test
     
     if (c_latency > 1)
     begin:override_test
       synth_reg # (1, c_latency)
         override_pipe (
           .i(logic1),
           .ce(internal_ce),
           .clr(internal_clr),
           .clk(clk),
           .o(override));
       assign extra_reg_ce = ce & en & override;
     end // override_test
 
     if ((c_latency == 0) || (c_latency == 1))
     begin:no_override
       assign extra_reg_ce = ce & en;
     end // no_override
 
     synth_reg # (s_width, extra_registers)
       extra_reg (
         .i(conv_s),
         .ce(extra_reg_ce),
         .clr(internal_clr),
         .clk(clk),
         .o(s));
 
     if (c_has_c_out == 1)
     begin:cout_test
       synth_reg # (1, extra_registers)
         c_out_extra_reg (
           .i(temp_cout),
           .ce(extra_reg_ce),
           .clr(internal_clr),
           .clk(clk),
           .o(c_out));
     end // cout_test
     
   end // latency_test
 endgenerate
 
 generate
   if ((latency == 0) || (extra_registers == 0))
   begin:latency_s
     assign s = conv_s;
   end // latency_s
 endgenerate
 
 generate
   if (((latency == 0) || (extra_registers == 0)) &&
       (c_has_c_out == 1))
   begin:latency0
     assign c_out = temp_cout;
   end // latency0
 endgenerate
 
 generate
   if (c_has_c_out == 0)
   begin:tie_dangling_cout
     assign c_out = 0;
   end // tie_dangling_cout
 endgenerate
 
 endmodule

module xlcounter_limit_ip_pid_controller (ce, clr, clk, op, up, en, rst);
 
 parameter core_name0= "";
 parameter op_width= 5;
 parameter op_arith= `xlSigned;
 parameter cnt_63_48 = 0;
 parameter cnt_47_32 = 0;
 parameter cnt_31_16 = 0;
 parameter cnt_15_0  = 0;
 parameter count_limited= 0;
 
    input  ce, clr, clk;
    input rst, en;  
    input up;
    output [op_width-1:0] op;
 
 parameter [63:0] cnt_to = { cnt_63_48[15:0], cnt_47_32[15:0], cnt_31_16[15:0], cnt_15_0[15:0]};
 parameter [(8*op_width)-1:0] oneStr = { op_width{"1"}}; 
    
 reg op_thresh0;
 wire core_sinit, core_ce;
 wire rst_overrides_en;
 wire [op_width-1:0] op_net;
 
    assign op = op_net;
    assign core_ce = ce & en;
    assign rst_overrides_en = rst | en;
    
 generate
 
    if (count_limited == 1)
      begin :limit
 	always @(op_net)
 	  begin:eq_cnt_to
 	     op_thresh0 = (op_net == cnt_to[op_width-1:0])? 1'b1 : 1'b0;
 	  end
         assign core_sinit = (op_thresh0 | clr | rst) & ce & rst_overrides_en;
      end
    if (count_limited == 0)
      begin :no_limit
 	assign core_sinit = (clr | rst) & ce & rst_overrides_en;
      end



if (core_name0 == "ip_pid_controller_c_counter_binary_v12_0_0") 
     begin:comp0
ip_pid_controller_c_counter_binary_v12_0_0 core_instance0 ( 
        .CLK(clk),
        .CE(core_ce),
        .SINIT(core_sinit),
        .Q(op_net) 
       ); 
     end 

endgenerate
 
 endmodule

module  xldivider_generator_c21cb25008addda87fe275acdfb605e1 (a,a_tvalid,b,b_tvalid,ce,clk,op);

input[31:0] a;
input a_tvalid;
input[31:0] b;
input b_tvalid;
input ce;
input clk;
output[37:0] op;
wire[39:0] m_axis_dout_tdata_net;
wire[37:0] m_axis_dout_tdata_shift_in_net;
wire[37:0] m_axis_dout_tdata_shift_out_net;
wire result_tvalid;
wire[31:0] s_axis_dividend_tdata_net;
wire[31:0] s_axis_divisor_tdata_net;
  assign m_axis_dout_tdata_shift_in_net = m_axis_dout_tdata_net[37 : 0];
  assign op = m_axis_dout_tdata_shift_out_net;
  assign s_axis_dividend_tdata_net[31 : 0] = a;
  assign s_axis_divisor_tdata_net[31 : 0] = b;
  shift_op # ( .inp_width(38), .result_width(38), .shift_value(6), .shift_dir(0))
shift_op_m_axis_dout_tdata_shift_in_net(.inp(m_axis_dout_tdata_shift_in_net), .res(m_axis_dout_tdata_shift_out_net));

  ip_pid_controller_div_gen_v5_1_0 ip_pid_controller_div_gen_v5_1_0_instance(
      .aclk(clk),
      .m_axis_dout_tdata(m_axis_dout_tdata_net),
      .m_axis_dout_tvalid(result_tvalid),
      .s_axis_dividend_tdata(s_axis_dividend_tdata_net),
      .s_axis_dividend_tvalid(a_tvalid),
      .s_axis_divisor_tdata(s_axis_divisor_tdata_net),
      .s_axis_divisor_tvalid(b_tvalid)
    );

 endmodule



module xlmult_ip_pid_controller (a, b, ce, clr, clk, core_ce, core_clr,core_clk, rst, en,p);
     parameter core_name0 = "";
     parameter a_width = 4;
     parameter a_bin_pt = 2;
     parameter a_arith = `xlSigned;
     parameter b_width = 4;
     parameter b_bin_pt = 1;
     parameter b_arith = `xlSigned;
     parameter p_width = 8;
     parameter p_bin_pt = 2;
     parameter p_arith = `xlSigned;
     parameter rst_width = 1;
     parameter rst_bin_pt = 0;
     parameter rst_arith = `xlUnsigned;
     parameter en_width = 1;
     parameter en_bin_pt = 0;
     parameter en_arith = `xlUnsigned;
     parameter quantization = `xlTruncate;
     parameter overflow = `xlWrap;
     parameter extra_registers = 0;
     parameter c_a_width = 7;
     parameter c_b_width = 7;
     parameter c_type = 0;
     parameter c_a_type = 0;
     parameter c_b_type = 0;
     parameter c_baat = 4;
     parameter oversample = 1;
     parameter multsign = `xlSigned;
     parameter c_output_width = 16;
     input [a_width - 1 : 0] a;
     input [b_width - 1 : 0] b;
     input ce, clr, clk;
     input core_ce, core_clr, core_clk;
     input en, rst;
     output [p_width - 1 : 0] p;
     wire [c_a_width - 1 : 0]    tmp_a, conv_a;
     wire [c_b_width - 1 : 0]    tmp_b, conv_b;
    wire [c_output_width - 1 : 0] tmp_p;
    wire [p_width - 1 : 0] conv_p;
    wire internal_ce, internal_clr, internal_core_ce;
    wire rfd, rdy, nd;
    
 
    assign internal_ce = ce & en;
    assign internal_core_ce = core_ce & en;
    assign internal_clr = (clr | rst) & en;
    assign nd = ce & en;
 
    zero_ext # (a_width, c_a_width) zero_ext_a (.inp(a), .res(tmp_a));
    zero_ext # (b_width, c_b_width) zero_ext_b (.inp(b), .res(tmp_b));
 
    //Output Process
    convert_type # (c_output_width, a_bin_pt+b_bin_pt, multsign,
 		   p_width, p_bin_pt, p_arith, quantization, overflow)
      conv_udp (.inp(tmp_p), .res(conv_p));
    
 generate
 


if (core_name0 == "ip_pid_controller_mult_gen_v12_0_0") 
     begin:comp0
ip_pid_controller_mult_gen_v12_0_0 core_instance0 ( 
        .A(tmp_a),
        .B(tmp_b),
        .CLK(clk),
        .CE(internal_ce),
        .SCLR(internal_clr),
        .P(tmp_p) 
       ); 
     end 

if (extra_registers > 0)
 begin:latency_gt_0
 synth_reg # (p_width, extra_registers) 
 reg1 (
 .i(conv_p), 
 .ce(internal_ce),
 .clr(internal_clr),
 .clk(clk),
 .o(p));
 end
 
 if (extra_registers == 0)
 begin:latency_eq_0
 assign p = conv_p;
 end
 endgenerate
 
 endmodule

