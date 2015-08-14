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

`ifndef xlConvPkgIncluded
`include "conv_pkg.v"
`endif


// Generated from Simulink block "ip_pid_controller/Edge Detection"
module edge_detection_69f9d322be (
  clk_1,
  ce_1,
  in1,
  out1
);

  input clk_1;
  input ce_1;
  input in1;
  output out1;

  wire clk_1_net;
  wire ce_1_net;
  wire [7:0] constant_op_net;
  wire [7:0] counter_op_net;
  wire delay_q_net;
  wire inverter_op_net;
  wire logical_y_net;
  wire register_q_net;
  wire register1_q_net;
  wire relational_op_net;
  wire new_motor_speed_net;
  wire logical1_y_net;

  assign clk_1_net = clk_1;
  assign ce_1_net = ce_1;
  assign new_motor_speed_net = in1;
  assign out1 = logical1_y_net;

  sysgen_constant_383443dd88  constant_x0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .op(constant_op_net)
  );

  xlcounter_limit_ip_pid_controller #(
    .cnt_15_0(99),
    .cnt_31_16(0),
    .cnt_47_32(0),
    .cnt_63_48(0),
    .core_name0("ip_pid_controller_c_counter_binary_v12_0_0"),
    .count_limited(1),
    .op_arith(`xlUnsigned),
    .op_width(8))
  counter (
    .ce(ce_1_net),
    .clk(clk_1_net),
    .rst(1'b0),
    .clr(1'b0),
    .en(delay_q_net),
    .op(counter_op_net)
  );

  xldelay_ip_pid_controller #(
    .latency(25),
    .reg_retiming(0),
    .reset(0),
    .width(1))
  delay (
    .ce(ce_1_net),
    .clk(clk_1_net),
    .en(1'b1),
    .rst(1'b1),
    .d(logical_y_net),
    .q(delay_q_net)
  );

  sysgen_inverter_91fd45ca5a  inverter (
    .ce(ce_1_net),
    .clk(clk_1_net),
    .clr(1'b0),
    .ip(register1_q_net),
    .op(inverter_op_net)
  );

  sysgen_logical_098c9fa070  logical (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d0(register_q_net),
    .d1(inverter_op_net),
    .y(logical_y_net)
  );

  sysgen_logical_098c9fa070  logical1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d0(delay_q_net),
    .d1(relational_op_net),
    .y(logical1_y_net)
  );

  xlregister_ip_pid_controller #(
    .d_width(1),
    .init_value(1'b0))
  register_x0 (
    .ce(ce_1_net),
    .clk(clk_1_net),
    .en(1'b1),
    .rst(1'b0),
    .d(new_motor_speed_net),
    .q(register_q_net)
  );

  xlregister_ip_pid_controller #(
    .d_width(1),
    .init_value(1'b0))
  register1 (
    .ce(ce_1_net),
    .clk(clk_1_net),
    .en(1'b1),
    .rst(1'b0),
    .d(new_motor_speed_net),
    .q(register1_q_net)
  );

  sysgen_relational_0c5dbda85b  relational (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .a(constant_op_net),
    .b(counter_op_net),
    .op(relational_op_net)
  );
endmodule


// Generated from Simulink block "ip_pid_controller/PID Controller/Accumulator"
module accumulator_0c8f1c90b9 (
  clk_1,
  ce_1,
  rst,
  en,
  err,
  pwm
);

  input clk_1;
  input ce_1;
  input rst;
  input en;
  input [31:0] err;
  output [31:0] pwm;

  wire clk_1_net;
  wire ce_1_net;
  wire [31:0] constant4_op_net;
  wire [31:0] constant5_op_net;
  wire [31:0] constant6_op_net;
  wire [31:0] constant7_op_net;
  wire logical_y_net_x0;
  wire logical1_y_net_x0;
  wire logical2_y_net;
  wire relational_op_net_x0;
  wire relational1_op_net;
  wire relational2_op_net;
  wire relational3_op_net;
  wire rst_net;
  wire logical1_y_net;
  wire [31:0] mult_p_net;
  wire [31:0] accumulator_q_net;

  assign clk_1_net = clk_1;
  assign ce_1_net = ce_1;
  assign rst_net = rst;
  assign logical1_y_net = en;
  assign mult_p_net = err;
  assign pwm = accumulator_q_net;

  sysgen_accum_ac23432ab2  accumulator (
    .ce(ce_1_net),
    .clk(clk_1_net),
    .clr(1'b0),
    .b(mult_p_net),
    .rst(rst_net),
    .en(logical2_y_net),
    .q(accumulator_q_net)
  );

  sysgen_constant_b4741603e8  constant4 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .op(constant4_op_net)
  );

  sysgen_constant_a7c2a996dd  constant5 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .op(constant5_op_net)
  );

  sysgen_constant_bd840882a6  constant6 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .op(constant6_op_net)
  );

  sysgen_constant_a7c2a996dd  constant7 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .op(constant7_op_net)
  );

  sysgen_logical_0c47d61908  logical (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d0(relational_op_net_x0),
    .d1(relational1_op_net),
    .y(logical_y_net_x0)
  );

  sysgen_logical_0c47d61908  logical1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d0(relational2_op_net),
    .d1(relational3_op_net),
    .y(logical1_y_net_x0)
  );

  sysgen_logical_7913ccf482  logical2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d0(logical1_y_net),
    .d1(logical1_y_net_x0),
    .d2(logical_y_net_x0),
    .y(logical2_y_net)
  );

  sysgen_relational_56046aa836  relational (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .a(accumulator_q_net),
    .b(constant4_op_net),
    .op(relational_op_net_x0)
  );

  sysgen_relational_56046aa836  relational1 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .a(mult_p_net),
    .b(constant5_op_net),
    .op(relational1_op_net)
  );

  sysgen_relational_860373682b  relational2 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .a(accumulator_q_net),
    .b(constant6_op_net),
    .op(relational2_op_net)
  );

  sysgen_relational_860373682b  relational3 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .a(mult_p_net),
    .b(constant7_op_net),
    .op(relational3_op_net)
  );
endmodule


// Generated from Simulink block "ip_pid_controller/PID Controller"
module pid_controller_dfc330003e (
  clk_1,
  ce_1,
  en_acc,
  rst_acc,
  kd,
  ki,
  kp,
  err,
  pwm
);

  input clk_1;
  input ce_1;
  input en_acc;
  input rst_acc;
  input [31:0] kd;
  input [31:0] ki;
  input [31:0] kp;
  input [31:0] err;
  output [31:0] pwm;

  wire clk_1_net;
  wire ce_1_net;
  wire [31:0] addsub1_s_net;
  wire [31:0] addsub2_s_net;
  wire [31:0] delay_q_net_x0;
  wire [31:0] delay1_q_net;
  wire [31:0] mult_p_net;
  wire [31:0] mult1_p_net;
  wire [31:0] mult2_p_net;
  wire logical1_y_net;
  wire rst_net;
  wire [31:0] kd_net;
  wire [31:0] ki_net;
  wire [31:0] kp_net;
  wire [31:0] addsub_s_net;
  wire [31:0] addsub3_s_net;
  wire [31:0] accumulator_q_net;

  assign clk_1_net = clk_1;
  assign ce_1_net = ce_1;
  assign logical1_y_net = en_acc;
  assign rst_net = rst_acc;
  assign kd_net = kd;
  assign ki_net = ki;
  assign kp_net = kp;
  assign addsub_s_net = err;
  assign pwm = addsub3_s_net;

  xladdsub_ip_pid_controller #(
    .a_arith(`xlSigned),
    .a_bin_pt(16),
    .a_width(32),
    .b_arith(`xlSigned),
    .b_bin_pt(16),
    .b_width(32),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(33),
    .core_name0("ip_pid_controller_c_addsub_v12_0_0"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(33),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(16),
    .s_width(32))
  addsub1 (
    .ce(ce_1_net),
    .clk(clk_1_net),
    .clr(1'b0),
    .en(1'b1),
    .a(addsub_s_net),
    .b(delay1_q_net),
    .s(addsub1_s_net)
  );

  xladdsub_ip_pid_controller #(
    .a_arith(`xlSigned),
    .a_bin_pt(16),
    .a_width(32),
    .b_arith(`xlSigned),
    .b_bin_pt(16),
    .b_width(32),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(33),
    .core_name0("ip_pid_controller_c_addsub_v12_0_1"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(33),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(16),
    .s_width(32))
  addsub2 (
    .ce(ce_1_net),
    .clk(clk_1_net),
    .clr(1'b0),
    .en(1'b1),
    .a(mult1_p_net),
    .b(mult2_p_net),
    .s(addsub2_s_net)
  );

  xladdsub_ip_pid_controller #(
    .a_arith(`xlSigned),
    .a_bin_pt(16),
    .a_width(32),
    .b_arith(`xlSigned),
    .b_bin_pt(16),
    .b_width(32),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(33),
    .core_name0("ip_pid_controller_c_addsub_v12_0_1"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(33),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(16),
    .s_width(32))
  addsub3 (
    .ce(ce_1_net),
    .clk(clk_1_net),
    .clr(1'b0),
    .en(1'b1),
    .a(accumulator_q_net),
    .b(addsub2_s_net),
    .s(addsub3_s_net)
  );

  xldelay_ip_pid_controller #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(32))
  delay (
    .ce(ce_1_net),
    .clk(clk_1_net),
    .rst(1'b1),
    .d(addsub_s_net),
    .en(logical1_y_net),
    .q(delay_q_net_x0)
  );

  xldelay_ip_pid_controller #(
    .latency(1),
    .reg_retiming(0),
    .reset(0),
    .width(32))
  delay1 (
    .ce(ce_1_net),
    .clk(clk_1_net),
    .rst(1'b1),
    .d(delay_q_net_x0),
    .en(logical1_y_net),
    .q(delay1_q_net)
  );

  xlmult_ip_pid_controller #(
    .a_arith(`xlSigned),
    .a_bin_pt(16),
    .a_width(32),
    .b_arith(`xlSigned),
    .b_bin_pt(16),
    .b_width(32),
    .c_a_type(0),
    .c_a_width(32),
    .c_b_type(0),
    .c_b_width(32),
    .c_baat(32),
    .c_output_width(64),
    .c_type(0),
    .core_name0("ip_pid_controller_mult_gen_v12_0_0"),
    .extra_registers(1),
    .multsign(2),
    .overflow(2),
    .p_arith(`xlSigned),
    .p_bin_pt(16),
    .p_width(32),
    .quantization(1))
  mult (
    .core_ce(ce_1_net),
    .core_clk(clk_1_net),
    .ce(ce_1_net),
    .clk(clk_1_net),
    .clr(1'b0),
    .core_clr(1'b1),
    .en(1'b1),
    .rst(1'b0),
    .a(addsub_s_net),
    .b(ki_net),
    .p(mult_p_net)
  );

  xlmult_ip_pid_controller #(
    .a_arith(`xlSigned),
    .a_bin_pt(16),
    .a_width(32),
    .b_arith(`xlSigned),
    .b_bin_pt(16),
    .b_width(32),
    .c_a_type(0),
    .c_a_width(32),
    .c_b_type(0),
    .c_b_width(32),
    .c_baat(32),
    .c_output_width(64),
    .c_type(0),
    .core_name0("ip_pid_controller_mult_gen_v12_0_0"),
    .extra_registers(1),
    .multsign(2),
    .overflow(2),
    .p_arith(`xlSigned),
    .p_bin_pt(16),
    .p_width(32),
    .quantization(1))
  mult1 (
    .core_ce(ce_1_net),
    .core_clk(clk_1_net),
    .ce(ce_1_net),
    .clk(clk_1_net),
    .clr(1'b0),
    .core_clr(1'b1),
    .en(1'b1),
    .rst(1'b0),
    .a(addsub_s_net),
    .b(kp_net),
    .p(mult1_p_net)
  );

  xlmult_ip_pid_controller #(
    .a_arith(`xlSigned),
    .a_bin_pt(16),
    .a_width(32),
    .b_arith(`xlSigned),
    .b_bin_pt(16),
    .b_width(32),
    .c_a_type(0),
    .c_a_width(32),
    .c_b_type(0),
    .c_b_width(32),
    .c_baat(32),
    .c_output_width(64),
    .c_type(0),
    .core_name0("ip_pid_controller_mult_gen_v12_0_0"),
    .extra_registers(1),
    .multsign(2),
    .overflow(2),
    .p_arith(`xlSigned),
    .p_bin_pt(16),
    .p_width(32),
    .quantization(1))
  mult2 (
    .core_ce(ce_1_net),
    .core_clk(clk_1_net),
    .ce(ce_1_net),
    .clk(clk_1_net),
    .clr(1'b0),
    .core_clr(1'b1),
    .en(1'b1),
    .rst(1'b0),
    .a(addsub1_s_net),
    .b(kd_net),
    .p(mult2_p_net)
  );

  accumulator_0c8f1c90b9 accumulator (
    .clk_1(clk_1_net),
    .ce_1(ce_1_net),
    .rst(rst_net),
    .en(logical1_y_net),
    .err(mult_p_net),
    .pwm(accumulator_q_net)
  );
endmodule


// Generated from Simulink block "ip_pid_controller/Speed Computation"
module speed_computation_8d613ce520 (
  clk_1,
  ce_1,
  speed_cnt,
  speed_rpm
);

  input clk_1;
  input ce_1;
  input [31:0] speed_cnt;
  output [31:0] speed_rpm;

  wire clk_1_net;
  wire ce_1_net;
  wire [31:0] constant_op_net_x0;
  wire [37:0] divide_op_net;
  wire [31:0] motor_speed_net;
  wire [31:0] convert_dout_net_x0;

  assign clk_1_net = clk_1;
  assign ce_1_net = ce_1;
  assign motor_speed_net = speed_cnt;
  assign speed_rpm = convert_dout_net_x0;

  sysgen_constant_61a644b4c8  constant_x0 (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .op(constant_op_net_x0)
  );

  xlconvert_ip_pid_controller #(
    .bool_conversion(0),
    .din_arith(2),
    .din_bin_pt(6),
    .din_width(38),
    .dout_arith(2),
    .dout_bin_pt(16),
    .dout_width(32),
    .latency(1),
    .overflow(`xlSaturate),
    .quantization(`xlTruncate))
  convert (
    .ce(ce_1_net),
    .clk(clk_1_net),
    .clr(1'b0),
    .en(1'b1),
    .din(divide_op_net),
    .dout(convert_dout_net_x0)
  );

  xldivider_generator_c21cb25008addda87fe275acdfb605e1  divide (
    .ce(ce_1_net),
    .clk(clk_1_net),
    .a_tvalid(1'b1),
    .b_tvalid(1'b1),
    .a(constant_op_net_x0),
    .b(motor_speed_net),
    .op(divide_op_net)
  );
endmodule


// Generated from Simulink block "ip_pid_controller/ip_pid_controller_struct"
module ip_pid_controller_struct (
  clk_1,
  ce_1,
  rst,
  ref_speed,
  new_motor_speed,
  motor_speed,
  kp,
  ki,
  kd,
  err,
  pwm,
  speed
);

  input clk_1;
  input ce_1;
  input rst;
  input [31:0] ref_speed;
  input new_motor_speed;
  input [31:0] motor_speed;
  input [31:0] kp;
  input [31:0] ki;
  input [31:0] kd;
  output [31:0] err;
  output [31:0] pwm;
  output [31:0] speed;

  wire clk_1_net;
  wire ce_1_net;
  wire [31:0] addsub_s_net;
  wire [31:0] convert_dout_net;
  wire [31:0] convert1_dout_net;
  wire [31:0] convert2_dout_net;
  wire [31:0] mcode_z_net;
  wire rst_net;
  wire [31:0] ref_speed_net;
  wire new_motor_speed_net;
  wire [31:0] motor_speed_net;
  wire [31:0] kp_net;
  wire [31:0] ki_net;
  wire [31:0] kd_net;
  wire [31:0] err_net;
  wire [31:0] pwm_net;
  wire [31:0] speed_net;
  wire logical1_y_net;
  wire [31:0] addsub3_s_net;
  wire [31:0] convert_dout_net_x0;

  assign clk_1_net = clk_1;
  assign ce_1_net = ce_1;
  assign rst_net = rst;
  assign ref_speed_net = ref_speed;
  assign new_motor_speed_net = new_motor_speed;
  assign motor_speed_net = motor_speed;
  assign kp_net = kp;
  assign ki_net = ki;
  assign kd_net = kd;
  assign err = err_net;
  assign pwm = pwm_net;
  assign speed = speed_net;
  assign err_net = convert_dout_net;
  assign pwm_net = convert1_dout_net;
  assign speed_net = convert_dout_net_x0;

  xladdsub_ip_pid_controller #(
    .a_arith(`xlSigned),
    .a_bin_pt(16),
    .a_width(32),
    .b_arith(`xlSigned),
    .b_bin_pt(16),
    .b_width(32),
    .c_has_c_out(0),
    .c_latency(0),
    .c_output_width(33),
    .core_name0("ip_pid_controller_c_addsub_v12_0_0"),
    .extra_registers(0),
    .full_s_arith(2),
    .full_s_width(33),
    .latency(0),
    .overflow(1),
    .quantization(1),
    .s_arith(`xlSigned),
    .s_bin_pt(16),
    .s_width(32))
  addsub (
    .ce(ce_1_net),
    .clk(clk_1_net),
    .clr(1'b0),
    .en(1'b1),
    .a(convert2_dout_net),
    .b(convert_dout_net_x0),
    .s(addsub_s_net)
  );

  xlconvert_ip_pid_controller #(
    .bool_conversion(0),
    .din_arith(2),
    .din_bin_pt(16),
    .din_width(32),
    .dout_arith(2),
    .dout_bin_pt(0),
    .dout_width(32),
    .latency(0),
    .overflow(`xlWrap),
    .quantization(`xlTruncate))
  convert (
    .ce(ce_1_net),
    .clk(clk_1_net),
    .clr(1'b0),
    .en(1'b1),
    .din(addsub_s_net),
    .dout(convert_dout_net)
  );

  xlconvert_ip_pid_controller #(
    .bool_conversion(0),
    .din_arith(2),
    .din_bin_pt(16),
    .din_width(32),
    .dout_arith(2),
    .dout_bin_pt(0),
    .dout_width(32),
    .latency(0),
    .overflow(`xlWrap),
    .quantization(`xlTruncate))
  convert1 (
    .ce(ce_1_net),
    .clk(clk_1_net),
    .clr(1'b0),
    .en(1'b1),
    .din(mcode_z_net),
    .dout(convert1_dout_net)
  );

  xlconvert_ip_pid_controller #(
    .bool_conversion(0),
    .din_arith(2),
    .din_bin_pt(0),
    .din_width(32),
    .dout_arith(2),
    .dout_bin_pt(16),
    .dout_width(32),
    .latency(0),
    .overflow(`xlWrap),
    .quantization(`xlTruncate))
  convert2 (
    .ce(ce_1_net),
    .clk(clk_1_net),
    .clr(1'b0),
    .en(1'b1),
    .din(ref_speed_net),
    .dout(convert2_dout_net)
  );

  sysgen_mcode_block_698c2b186c  mcode (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .x(addsub3_s_net),
    .z(mcode_z_net)
  );

  edge_detection_69f9d322be edge_detection (
    .clk_1(clk_1_net),
    .ce_1(ce_1_net),
    .in1(new_motor_speed_net),
    .out1(logical1_y_net)
  );

  pid_controller_dfc330003e pid_controller (
    .clk_1(clk_1_net),
    .ce_1(ce_1_net),
    .en_acc(logical1_y_net),
    .rst_acc(rst_net),
    .kd(kd_net),
    .ki(ki_net),
    .kp(kp_net),
    .err(addsub_s_net),
    .pwm(addsub3_s_net)
  );

  speed_computation_8d613ce520 speed_computation (
    .clk_1(clk_1_net),
    .ce_1(ce_1_net),
    .speed_cnt(motor_speed_net),
    .speed_rpm(convert_dout_net_x0)
  );
endmodule


// Generated from Simulink block "ip_pid_controller/default_clock_driver_ip_pid_controller"
module default_clock_driver_ip_pid_controller (
  sysclk,
  sysce,
  sysce_clr,
  clk_1,
  ce_1
);

  input sysclk;
  input sysce;
  input sysce_clr;
  output ce_1;
  output clk_1;

  wire xlclockdriver_1_clk;
  wire xlclockdriver_1_ce;

  assign clk_1 = xlclockdriver_1_clk;
  assign ce_1 = xlclockdriver_1_ce;

  xlclockdriver #(
    .log_2_period(1),
    .period(1),
    .use_bufg(0))
  xlclockdriver_1 (
    .sysce(sysce),
    .sysclk(sysclk),
    .sysclr(sysce_clr),
    .ce(xlclockdriver_1_ce),
    .clk(xlclockdriver_1_clk)
  );
endmodule


// Generated from Simulink block "ip_pid_controller"

(* core_generation_info = "ip_pid_controller,sysgen_core_2013_4,{compilation=IP Catalog,block_icon_display=Default,family=zynq,part=xc7z020,speed=-1,package=clg484,synthesis_tool=Vivado,synthesis_language=verilog,hdl_library=work,proj_type=Vivado,synth_file=Vivado Synthesis Defaults,impl_file=Vivado Implementation Defaults,clock_loc=,clock_wrapper=Clock Enables,directory=./netlist,testbench=0,create_interface_document=0,ce_clr=0,base_system_period_hardware=10,dcm_input_clock_period=10,base_system_period_simulink=1,sim_time=1e+06,sim_status=0,}" *)
module ip_pid_controller (
  clk,
  rst,
  ref_speed,
  new_motor_speed,
  motor_speed,
  kp,
  ki,
  kd,
  err,
  pwm,
  speed
);

  input clk;
  input rst;
  input [31:0] ref_speed;
  input new_motor_speed;
  input [31:0] motor_speed;
  input [31:0] kp;
  input [31:0] ki;
  input [31:0] kd;
  output [31:0] err;
  output [31:0] pwm;
  output [31:0] speed;

  wire clk_1_net;
  wire ce_1_net;
  wire clk_net;
  wire rst_net;
  wire [31:0] ref_speed_net;
  wire new_motor_speed_net;
  wire [31:0] motor_speed_net;
  wire [31:0] kp_net;
  wire [31:0] ki_net;
  wire [31:0] kd_net;
  wire [31:0] err_net;
  wire [31:0] pwm_net;
  wire [31:0] speed_net;

  assign clk_net = clk;
  assign rst_net = rst;
  assign ref_speed_net = ref_speed;
  assign new_motor_speed_net = new_motor_speed;
  assign motor_speed_net = motor_speed;
  assign kp_net = kp;
  assign ki_net = ki;
  assign kd_net = kd;
  assign err = err_net;
  assign pwm = pwm_net;
  assign speed = speed_net;

  ip_pid_controller_struct ip_pid_controller_struct (
    .clk_1(clk_1_net),
    .ce_1(ce_1_net),
    .rst(rst_net),
    .ref_speed(ref_speed_net),
    .new_motor_speed(new_motor_speed_net),
    .motor_speed(motor_speed_net),
    .kp(kp_net),
    .ki(ki_net),
    .kd(kd_net),
    .err(err_net),
    .pwm(pwm_net),
    .speed(speed_net)
  );

  default_clock_driver_ip_pid_controller default_clock_driver_ip_pid_controller (
    .sysclk(clk_net),
    .sysce(1'b1),
    .sysce_clr(1'b0),
    .clk_1(clk_1_net),
    .ce_1(ce_1_net)
  );
endmodule
