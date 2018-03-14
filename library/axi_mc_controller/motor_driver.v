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
`timescale 1ns / 1ps

//------------------------------------------------------------------------------
//----------- Module Declaration -----------------------------------------------
//------------------------------------------------------------------------------

module motor_driver

//----------- Parameters Declarations -------------------------------------------
#(
    parameter   PWM_BITS = 11,
    localparam  PWMBW    = PWM_BITS - 1
)
//----------- Ports Declarations -----------------------------------------------
(
    input           clk_i,
    input           pwm_clk_i,
    input           rst_n_i,
    input           run_i,
    input           star_delta_i,   // 1 STAR, 0 DELTA
    input           dir_i,          // 1 CW, 0 CCW
    input [2:0]     position_i,
    input [PWMBW:0] pwm_duty_i,
    output          AH_o,
    output          BH_o,
    output          CH_o,
    output          AL_o,
    output          BL_o,
    output          CL_o
);

//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------

reg           pwm_s;
reg [ 3:0]    motor_state;
reg [15:0]    align_counter;
reg [ 2:0]    position_s;
reg [PWMBW:0] pwm_cnt;


//------------------------------------------------------------------------------
//----------- Wires Declarations -----------------------------------------------
//------------------------------------------------------------------------------

wire            align_complete;
wire [PWMBW:0]  pwm_duty_s;
wire [1:0]      commutation_table[0:2];

wire pwm_al_s;
wire pwm_ah_s;
wire pwm_bl_s;
wire pwm_bh_s;
wire pwm_cl_s;
wire pwm_ch_s;
wire pwmd_al_s;
wire pwmd_ah_s;
wire pwmd_bl_s;
wire pwmd_bh_s;
wire pwmd_cl_s;
wire pwmd_ch_s;

//------------------------------------------------------------------------------
//----------- Local Parameters -------------------------------------------------
//------------------------------------------------------------------------------

localparam OFF    = 3'b001;
localparam ALIGN  = 3'b010;
localparam RUN    = 3'b100;
localparam DT     = 20;

localparam [PWMBW:0] ALIGN_PWM_DUTY = 2**(PWMBW) + 2**(PWMBW-3);
localparam [15:0] ALIGN_TIME = 16'h8000;


localparam [1:0] COMMUTATION_TABLE_DELTA_CW_0[0:5]  = { 2'd1,-2'd1, 2'd1,-2'd1, 2'd1,-2'd1};
localparam [1:0] COMMUTATION_TABLE_DELTA_CW_1[0:5]  = {-2'd1, 2'd1, 2'd1,-2'd1,-2'd1, 2'd1};
localparam [1:0] COMMUTATION_TABLE_DELTA_CW_2[0:5]  = {-2'd1,-2'd1,-2'd1, 2'd1, 2'd1, 2'd1};
localparam [1:0] COMMUTATION_TABLE_DELTA_CCW_0[0:5] = {-2'd1, 2'd1,-2'd1, 2'd1,-2'd1, 2'd1};
localparam [1:0] COMMUTATION_TABLE_DELTA_CCW_1[0:5] = { 2'd1,-2'd1,-2'd1, 2'd1, 2'd1,-2'd1};
localparam [1:0] COMMUTATION_TABLE_DELTA_CCW_2[0:5] = { 2'd1, 2'd1, 2'd1,-2'd1,-2'd1,-2'd1};

localparam [1:0] COMMUTATION_TABLE_STAR_CW_0[0:5]   = { 2'd1,-2'd1, 2'd0, 2'd0, 2'd1,-2'd1};
localparam [1:0] COMMUTATION_TABLE_STAR_CW_1[0:5]   = { 2'd0, 2'd1, 2'd1,-2'd1,-2'd1, 2'd0};
localparam [1:0] COMMUTATION_TABLE_STAR_CW_2[0:5]   = {-2'd1, 2'd0,-2'd1, 2'd1, 2'd0, 2'd1};
localparam [1:0] COMMUTATION_TABLE_STAR_CCW_0[0:5]  = {-2'd1, 2'd1, 2'd0, 2'd0, -2'd1, 2'd1};
localparam [1:0] COMMUTATION_TABLE_STAR_CCW_1[0:5]  = { 2'd0,-2'd1,-2'd1, 2'd1,  2'd1, 2'd0};
localparam [1:0] COMMUTATION_TABLE_STAR_CCW_2[0:5]  = { 2'd1, 2'd0, 2'd1,-2'd1,  2'd0,-2'd1};

delay #(
    .DELAY(DT))
  delay_ah_i (
    .clk_i   (clk_i),
    .rst_n_i (pwm_ah_s),
    .sig_i   (pwm_ah_s),
  .sig_o   (pwmd_ah_s));
delay #(
    .DELAY(DT))
  delay_al_i (
    .clk_i   (clk_i),
    .rst_n_i (pwm_al_s),
    .sig_i   (pwm_al_s),
  .sig_o   (pwmd_al_s));

delay #(
    .DELAY(DT))
  delay_bh_i (
    .clk_i   (clk_i),
    .rst_n_i (pwm_bh_s),
    .sig_i   (pwm_bh_s),
  .sig_o   (pwmd_bh_s));
delay #(
    .DELAY(DT))
  delay_bl_i (
    .clk_i   (clk_i),
    .rst_n_i (pwm_bl_s),
    .sig_i   (pwm_bl_s),
  .sig_o   (pwmd_bl_s));

delay #(
    .DELAY(DT))
  delay_ch_i (
    .clk_i   (clk_i),
    .rst_n_i (pwm_ch_s),
    .sig_i   (pwm_ch_s),
  .sig_o   (pwmd_ch_s));
delay #(
    .DELAY(DT))
  delay_cl_i (
    .clk_i   (clk_i),
    .rst_n_i (pwm_cl_s),
    .sig_i   (pwm_cl_s),
  .sig_o   (pwmd_cl_s));

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------

assign align_complete   = align_counter < ALIGN_TIME ? 0 : 1;
assign pwm_duty_s       = motor_state == OFF ? 0 :
                          motor_state == ALIGN ? ALIGN_PWM_DUTY : pwm_duty_i;

assign commutation_table[0] = star_delta_i ?
                              dir_i ? COMMUTATION_TABLE_STAR_CW_0[position_s]  : COMMUTATION_TABLE_STAR_CCW_0[position_s] :
                              dir_i ? COMMUTATION_TABLE_DELTA_CW_0[position_s] : COMMUTATION_TABLE_DELTA_CCW_0[position_s];
assign commutation_table[1] = star_delta_i ?
                              dir_i ? COMMUTATION_TABLE_STAR_CW_1[position_s]  : COMMUTATION_TABLE_STAR_CCW_1[position_s] :
                              dir_i ? COMMUTATION_TABLE_DELTA_CW_1[position_s] : COMMUTATION_TABLE_DELTA_CCW_1[position_s];
assign commutation_table[2] = star_delta_i ?
                              dir_i ? COMMUTATION_TABLE_STAR_CW_2[position_s]  : COMMUTATION_TABLE_STAR_CCW_2[position_s] :
                              dir_i ? COMMUTATION_TABLE_DELTA_CW_2[position_s] : COMMUTATION_TABLE_DELTA_CCW_2[position_s];

//Motor Phases Control

assign pwm_ah_s = commutation_table[0] == 2'd1 ? ~pwm_s : commutation_table[0] == -2'd1 ?  pwm_s : 0;
assign pwm_al_s = commutation_table[0] == 2'd1 ?  pwm_s : commutation_table[0] == -2'd1 ? ~pwm_s : 0;

assign pwm_bh_s = commutation_table[1] == 2'd1 ? ~pwm_s : commutation_table[1] == -2'd1 ?  pwm_s : 0;
assign pwm_bl_s = commutation_table[1] == 2'd1 ?  pwm_s : commutation_table[1] == -2'd1 ? ~pwm_s : 0;

assign pwm_ch_s = commutation_table[2] == 2'd1 ? ~pwm_s : commutation_table[2] == -2'd1 ?  pwm_s : 0;
assign pwm_cl_s = commutation_table[2] == 2'd1 ?  pwm_s : commutation_table[2] == -2'd1 ? ~pwm_s : 0;

assign AL_o = pwmd_ah_s? 0 : pwmd_al_s;
assign AH_o = pwmd_ah_s;

assign BL_o = pwmd_bh_s ? 0 : pwmd_bl_s;
assign BH_o = pwmd_bh_s;

assign CL_o = pwmd_ch_s ? 0 : pwmd_cl_s;
assign CH_o = pwmd_ch_s;

//Control the current motor state
always @(posedge clk_i)
begin
    if(rst_n_i == 1'b0)
    begin
        motor_state     <= OFF;
        align_counter   <= 0;
    end
    else
    begin
        case(motor_state)
            OFF:
            begin
                position_s  <= 0;
                motor_state <= (run_i == 1'b1 ? ALIGN : OFF);
            end
            ALIGN:
            begin
                position_s      <= 0;
                if(align_complete == 1'b1)
                begin
                    motor_state <= (run_i == 1'b1 ? RUN : OFF);
                end
                else
                begin
                    motor_state <= (run_i == 1'b1 ? ALIGN : OFF);
                end
            end
            RUN:
            begin
                position_s  <= position_i - 1;
                motor_state <= (run_i == 1'b1 ? RUN : OFF);
            end
            default:
            begin
                motor_state <= OFF;
            end
        endcase
        align_counter <= motor_state == ALIGN ? align_counter + 1 : 0;
    end
end

//Generate the PWM signal

always @(posedge pwm_clk_i)
begin
    if((rst_n_i == 1'b0))
    begin
        pwm_cnt <= 0;
    end
    else
    begin
        pwm_cnt <= pwm_cnt < (2**PWM_BITS - 1) ? pwm_cnt + 1 : 0;
    end
    pwm_s <= pwm_cnt < pwm_duty_s ? 1 : 0;
end

endmodule
