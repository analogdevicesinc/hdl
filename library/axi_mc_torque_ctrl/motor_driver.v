// -----------------------------------------------------------------------------
//
// Copyright 2011(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//  - Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//  - Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in
//    the documentation and/or other materials provided with the
//    distribution.
//  - Neither the name of Analog Devices, Inc. nor the names of its
//    contributors may be used to endorse or promote products derived
//    from this software without specific prior written permission.
//  - The use of this software may or may not infringe the patent rights
//    of one or more patent holders.  This license does not release you
//    from the requirement that you obtain separate licenses from these
//    patent holders to use this software.
//  - Use of the software either in source or binary form, must be run
//    on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED
// WARRANTIES, INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY
// AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// INTELLECTUAL PROPERTY RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// -----------------------------------------------------------------------------
// FILE NAME :  motor_driver.v
// MODULE NAME :motor_driver
// AUTHOR : acozma
// AUTHOR'S EMAIL : andrei.cozma@analog.com
// -----------------------------------------------------------------------------
// SVN REVISION: $WCREV$
// -----------------------------------------------------------------------------
// KEYWORDS :
// -----------------------------------------------------------------------------
// PURPOSE : Module for driving a BLDC motor
// -----------------------------------------------------------------------------
// REUSE ISSUES
// Reset Strategy      : Active low reset signal
// Clock Domains       :
// Critical Timing     : N/A
// Test Features       : N/A
// Asynchronous I/F    : N/A
// Instantiations      : N/A
// Synthesizable (y/n) : Y
// Target Device       :
// Other               :
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

//------------------------------------------------------------------------------
//----------- Module Declaration -----------------------------------------------
//------------------------------------------------------------------------------
module motor_driver
//----------- Paramters Declarations -------------------------------------------
#(
    parameter PWM_BITS = 11
)
//----------- Ports Declarations -----------------------------------------------
(
    input       clk_i,
    input       pwm_clk_i,
    input       rst_n_i,
    input       run_i,
    input       star_delta_i,           // 0 star configuration, 1 delta configuration
    input [2:0] position_i,
    input [PWM_BITS-1:0] pwm_duty_i,
    output      AH_o,
    output      BH_o,
    output      CH_o,
    output      AL_o,
    output      BL_o,
    output      CL_o
);

//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------
reg [ 7:0]  motor_state;
reg [ 7:0]  motor_next_state;
reg [31:0]  align_counter;
reg         pwm_s;
reg [PWM_BITS-1:0] pwm_cnt;
reg [32:0]  stall_counter;

//------------------------------------------------------------------------------
//----------- Wires Declarations -----------------------------------------------
//------------------------------------------------------------------------------
wire                align_complete;
wire [PWM_BITS-1:0] pwm_duty_s;

//------------------------------------------------------------------------------
//----------- Local Parameters -------------------------------------------------
//------------------------------------------------------------------------------
parameter OFF    = 8'b00000001;
parameter ALIGN  = 8'b00000010;
parameter PHASE1 = 8'b00000100;
parameter PHASE2 = 8'b00001000;
parameter PHASE3 = 8'b00010000;
parameter PHASE4 = 8'b00100000;
parameter PHASE5 = 8'b01000000;
parameter PHASE6 = 8'b10000000;
parameter [PWM_BITS-1:0] ALIGN_PWM_DUTY = 2**(PWM_BITS-1) + 2**(PWM_BITS-4);
parameter [31:0] ALIGN_TIME = 32'h01000000;

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------
assign align_complete = align_counter < ALIGN_TIME ? 0 : 1;
assign pwm_duty_s  = motor_state == OFF ? 0 :
                     motor_state == ALIGN ? ALIGN_PWM_DUTY : pwm_duty_i;

//Motor Phases Control
// assign AH_o = star_delta_i ? ( (motor_state == ALIGN  || motor_state == PHASE1 || motor_state == PHASE2 || motor_state == PHASE3) ? pwm_s : ~pwm_s ) :
                              // ( (motor_state == ALIGN || motor_state == PHASE1 || motor_state == PHASE6) ? ~pwm_s  : (motor_state == PHASE3 || motor_state == PHASE4) ? pwm_s : 0) ;
// assign AL_o = star_delta_i ? ( (motor_state == ALIGN  || motor_state == PHASE1 || motor_state == PHASE2 || motor_state == PHASE3) ? ~pwm_s : pwm_s ) :
                              // ( (motor_state == ALIGN || motor_state == PHASE1 || motor_state == PHASE6) ? pwm_s  : (motor_state == PHASE3 || motor_state == PHASE4) ? ~pwm_s : 0) ;

// assign BH_o = star_delta_i ? ( (motor_state == PHASE3 || motor_state == PHASE4 || motor_state == PHASE5 ) ? pwm_s :  ~pwm_s ) :
                              // ( (motor_state == PHASE2 || motor_state == PHASE3) ? ~pwm_s : (motor_state == PHASE5 || motor_state == PHASE6) ? pwm_s : 0 );
// assign BL_o = star_delta_i ? ( (motor_state == PHASE3 || motor_state == PHASE4 || motor_state == PHASE5 ) ? ~pwm_s :  pwm_s ) :
                              // ( (motor_state == PHASE2 || motor_state == PHASE3) ? pwm_s : (motor_state == PHASE5 || motor_state == PHASE6) ? ~pwm_s : 0 );

// assign CH_o = star_delta_i ? ( (motor_state == ALIGN  || motor_state == PHASE1 || motor_state == PHASE5 || motor_state == PHASE6) ? pwm_s : ~pwm_s ) :
                              // ( (motor_state == PHASE4 || motor_state == PHASE5) ? ~pwm_s : (motor_state == ALIGN  || motor_state == PHASE1 || motor_state == PHASE2) ? pwm_s : 0 );
// assign CL_o = star_delta_i ? ( (motor_state == ALIGN  || motor_state == PHASE1 || motor_state == PHASE5 || motor_state == PHASE6) ? ~pwm_s : pwm_s ) :
                              // ( (motor_state == PHASE4 || motor_state == PHASE5) ? pwm_s : (motor_state == ALIGN  || motor_state == PHASE1 || motor_state == PHASE2) ? ~pwm_s : 0 );

assign AH_o =  ( (motor_state == PHASE3 || motor_state == PHASE4 || motor_state == PHASE5 ) ? ~pwm_s :  1 );
assign AL_o =  ( (motor_state == PHASE3 || motor_state == PHASE4 || motor_state == PHASE5 ) ? pwm_s :  ~pwm_s );

assign BH_o =  ( (motor_state == ALIGN  || motor_state == PHASE1 || motor_state == PHASE5 || motor_state == PHASE6) ? ~pwm_s : 1 );
assign BL_o =  ( (motor_state == ALIGN  || motor_state == PHASE1 || motor_state == PHASE5 || motor_state == PHASE6) ? pwm_s : ~pwm_s );

assign CH_o =  ( (motor_state == ALIGN  || motor_state == PHASE1 || motor_state == PHASE2 || motor_state == PHASE3) ? ~pwm_s : 1 );
assign CL_o =  ( (motor_state == ALIGN  || motor_state == PHASE1 || motor_state == PHASE2 || motor_state == PHASE3) ? pwm_s : ~pwm_s );


//Control the current motor state
always @(posedge clk_i)
begin
    if(rst_n_i == 1'b0)
    begin
        motor_state <= OFF;
        align_counter <= 0;
    end
    else
    begin
        motor_state <= (run_i == 1'b1 ? motor_next_state : OFF);
        align_counter <= motor_state == ALIGN ? align_counter + 1 : 0;
    end
end

//Determine the next motor state
always @(motor_state, position_i, align_complete,run_i, stall_counter)
begin
    motor_next_state <= motor_state;
    case(motor_state)
        OFF:
        begin
            if(run_i == 1'b1)
            begin
                motor_next_state <= ALIGN;
            end
        end
        ALIGN:
        begin
            if(align_complete == 1'b1)
            begin
                motor_next_state <= PHASE2;
            end

        end
        PHASE1:
        begin
            if(position_i == 3'b010  || stall_counter == 0 )
            begin
                motor_next_state <= PHASE2;
            end
        end
        PHASE2:
        begin
            if(position_i == 3'b110 || stall_counter == 0)
            begin
                motor_next_state <= PHASE3;
            end
        end
        PHASE3:
        begin
            if(position_i == 3'b100 || stall_counter == 0 )
            begin
                motor_next_state <= PHASE4;
            end
        end
        PHASE4:
        begin
            if(position_i == 3'b101 || stall_counter == 0 )
            begin
                motor_next_state <= PHASE5;
            end
        end
        PHASE5:
        begin
            if(position_i == 3'b001 || stall_counter == 0 )
            begin
                motor_next_state <= PHASE6;
            end
        end
        PHASE6:
        begin
            if(position_i == 3'b011 || stall_counter == 0 )
            begin
                motor_next_state <= PHASE1;
            end
        end
        default:
        begin
            motor_next_state <= OFF;
        end
    endcase
end

always @(posedge clk_i)
begin
    if (rst_n_i == 1'b0)
    begin
        stall_counter <= 32'd5000000;
    end
    else
    begin
        if (motor_next_state == motor_state && motor_state != OFF && motor_state != ALIGN)
        begin
            if(stall_counter > 0)
            begin
                stall_counter <= stall_counter - 1;
            end
        end
        else
        begin
                stall_counter <= 32'd5000000;
        end
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

